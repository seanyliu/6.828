
obj/user/init:     file format elf32-i386

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
  80002c:	e8 4b 03 00 00       	call   80037c <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <sum>:
char bss[6000];

int
sum(const char *s, int n)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	8b 75 08             	mov    0x8(%ebp),%esi
  80003c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003f:	b9 00 00 00 00       	mov    $0x0,%ecx
	for (i = 0; i < n; i++)
  800044:	ba 00 00 00 00       	mov    $0x0,%edx
  800049:	39 d9                	cmp    %ebx,%ecx
  80004b:	7d 0e                	jge    80005b <sum+0x27>
		tot ^= i * s[i];
  80004d:	0f be 04 16          	movsbl (%esi,%edx,1),%eax
  800051:	0f af c2             	imul   %edx,%eax
  800054:	31 c1                	xor    %eax,%ecx
  800056:	42                   	inc    %edx
  800057:	39 da                	cmp    %ebx,%edx
  800059:	7c f2                	jl     80004d <sum+0x19>
	return tot;
}
  80005b:	89 c8                	mov    %ecx,%eax
  80005d:	5b                   	pop    %ebx
  80005e:	5e                   	pop    %esi
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:
		
void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	57                   	push   %edi
  800065:	56                   	push   %esi
  800066:	53                   	push   %ebx
  800067:	83 ec 18             	sub    $0x18,%esp
  80006a:	8b 75 08             	mov    0x8(%ebp),%esi
  80006d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;

	cprintf("init: running\n");
  800070:	68 80 2b 80 00       	push   $0x802b80
  800075:	e8 4e 04 00 00       	call   8004c8 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 70 80 00       	push   $0x807000
  800084:	e8 ab ff ff ff       	call   800034 <sum>
  800089:	83 c4 18             	add    $0x18,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	74 18                	je     8000ab <umain+0x4a>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 9e 98 0f 00       	push   $0xf989e
  80009b:	50                   	push   %eax
  80009c:	68 48 2c 80 00       	push   $0x802c48
  8000a1:	e8 22 04 00 00       	call   8004c8 <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	eb 10                	jmp    8000bb <umain+0x5a>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 8f 2b 80 00       	push   $0x802b8f
  8000b3:	e8 10 04 00 00       	call   8004c8 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	if ((x = sum(bss, sizeof bss)) != 0)
  8000bb:	68 70 17 00 00       	push   $0x1770
  8000c0:	68 00 88 80 00       	push   $0x808800
  8000c5:	e8 6a ff ff ff       	call   800034 <sum>
  8000ca:	83 c4 08             	add    $0x8,%esp
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	74 13                	je     8000e4 <umain+0x83>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	50                   	push   %eax
  8000d5:	68 84 2c 80 00       	push   $0x802c84
  8000da:	e8 e9 03 00 00       	call   8004c8 <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	eb 10                	jmp    8000f4 <umain+0x93>
	else
		cprintf("init: bss seems okay\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 a6 2b 80 00       	push   $0x802ba6
  8000ec:	e8 d7 03 00 00       	call   8004c8 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp

	cprintf("init: args:");
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 bc 2b 80 00       	push   $0x802bbc
  8000fc:	e8 c7 03 00 00       	call   8004c8 <cprintf>
	for (i = 0; i < argc; i++)
  800101:	bb 00 00 00 00       	mov    $0x0,%ebx
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	39 f3                	cmp    %esi,%ebx
  80010b:	7d 18                	jge    800125 <umain+0xc4>
		cprintf(" '%s'", argv[i]);
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800113:	68 c8 2b 80 00       	push   $0x802bc8
  800118:	e8 ab 03 00 00       	call   8004c8 <cprintf>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	43                   	inc    %ebx
  800121:	39 f3                	cmp    %esi,%ebx
  800123:	7c e8                	jl     80010d <umain+0xac>
	cprintf("\n");
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	68 98 32 80 00       	push   $0x803298
  80012d:	e8 96 03 00 00       	call   8004c8 <cprintf>

	cprintf("init: running sh\n");
  800132:	c7 04 24 ce 2b 80 00 	movl   $0x802bce,(%esp)
  800139:	e8 8a 03 00 00       	call   8004c8 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80013e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800145:	e8 50 12 00 00       	call   80139a <close>
	if ((r = opencons()) < 0)
  80014a:	e8 13 01 00 00       	call   800262 <opencons>
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	85 c0                	test   %eax,%eax
  800154:	79 12                	jns    800168 <umain+0x107>
		panic("opencons: %e", r);
  800156:	50                   	push   %eax
  800157:	68 e0 2b 80 00       	push   $0x802be0
  80015c:	6a 32                	push   $0x32
  80015e:	68 ed 2b 80 00       	push   $0x802bed
  800163:	e8 70 02 00 00       	call   8003d8 <_panic>
	if (r != 0)
  800168:	85 c0                	test   %eax,%eax
  80016a:	74 12                	je     80017e <umain+0x11d>
		panic("first opencons used fd %d", r);
  80016c:	50                   	push   %eax
  80016d:	68 f9 2b 80 00       	push   $0x802bf9
  800172:	6a 34                	push   $0x34
  800174:	68 ed 2b 80 00       	push   $0x802bed
  800179:	e8 5a 02 00 00       	call   8003d8 <_panic>
	if ((r = dup(0, 1)) < 0)
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	6a 01                	push   $0x1
  800183:	6a 00                	push   $0x0
  800185:	e8 61 12 00 00       	call   8013eb <dup>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	79 12                	jns    8001a3 <umain+0x142>
		panic("dup: %e", r);
  800191:	50                   	push   %eax
  800192:	68 13 2c 80 00       	push   $0x802c13
  800197:	6a 36                	push   $0x36
  800199:	68 ed 2b 80 00       	push   $0x802bed
  80019e:	e8 35 02 00 00       	call   8003d8 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	68 1b 2c 80 00       	push   $0x802c1b
  8001ab:	e8 18 03 00 00       	call   8004c8 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001b0:	83 c4 0c             	add    $0xc,%esp
  8001b3:	6a 00                	push   $0x0
  8001b5:	68 2f 2c 80 00       	push   $0x802c2f
  8001ba:	68 2e 2c 80 00       	push   $0x802c2e
  8001bf:	e8 8c 1e 00 00       	call   802050 <spawnl>
		if (r < 0) {
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	79 13                	jns    8001de <umain+0x17d>
			cprintf("init: spawn sh: %e\n", r);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	50                   	push   %eax
  8001cf:	68 32 2c 80 00       	push   $0x802c32
  8001d4:	e8 ef 02 00 00       	call   8004c8 <cprintf>
			continue;
  8001d9:	83 c4 10             	add    $0x10,%esp
  8001dc:	eb c5                	jmp    8001a3 <umain+0x142>
		}
		wait(r);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 6d 25 00 00       	call   802754 <wait>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb b7                	jmp    8001a3 <umain+0x142>

008001ec <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  8001f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f5:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001f8:	6a 01                	push   $0x1
  8001fa:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8001fd:	50                   	push   %eax
  8001fe:	e8 d9 0b 00 00       	call   800ddc <sys_cputs>
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <getchar>:

int
getchar(void)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80020b:	6a 01                	push   $0x1
  80020d:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  800210:	50                   	push   %eax
  800211:	6a 00                	push   $0x0
  800213:	e8 f5 12 00 00       	call   80150d <read>
	if (r < 0)
  800218:	83 c4 10             	add    $0x10,%esp
		return r;
  80021b:	89 c2                	mov    %eax,%edx
  80021d:	85 c0                	test   %eax,%eax
  80021f:	78 0d                	js     80022e <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  800221:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  800226:	85 c0                	test   %eax,%eax
  800228:	7e 04                	jle    80022e <getchar+0x29>
	return c;
  80022a:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  80022e:	89 d0                	mov    %edx,%eax
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <iscons>:


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
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800238:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80023b:	50                   	push   %eax
  80023c:	ff 75 08             	pushl  0x8(%ebp)
  80023f:	e8 36 10 00 00       	call   80127a <fd_lookup>
  800244:	83 c4 10             	add    $0x10,%esp
		return r;
  800247:	89 c2                	mov    %eax,%edx
  800249:	85 c0                	test   %eax,%eax
  80024b:	78 11                	js     80025e <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  80024d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  800250:	8b 00                	mov    (%eax),%eax
  800252:	3b 05 80 87 80 00    	cmp    0x808780,%eax
  800258:	0f 94 c0             	sete   %al
  80025b:	0f b6 d0             	movzbl %al,%edx
}
  80025e:	89 d0                	mov    %edx,%eax
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <opencons>:

int
opencons(void)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800268:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80026b:	50                   	push   %eax
  80026c:	e8 af 0f 00 00       	call   801220 <fd_alloc>
  800271:	83 c4 10             	add    $0x10,%esp
		return r;
  800274:	89 c2                	mov    %eax,%edx
  800276:	85 c0                	test   %eax,%eax
  800278:	78 3c                	js     8002b6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80027a:	83 ec 04             	sub    $0x4,%esp
  80027d:	68 07 04 00 00       	push   $0x407
  800282:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  800285:	6a 00                	push   $0x0
  800287:	e8 12 0c 00 00       	call   800e9e <sys_page_alloc>
  80028c:	83 c4 10             	add    $0x10,%esp
		return r;
  80028f:	89 c2                	mov    %eax,%edx
  800291:	85 c0                	test   %eax,%eax
  800293:	78 21                	js     8002b6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  800295:	a1 80 87 80 00       	mov    0x808780,%eax
  80029a:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  80029d:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80029f:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8002a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8002af:	e8 5c 0f 00 00       	call   801210 <fd2num>
  8002b4:	89 c2                	mov    %eax,%edx
}
  8002b6:	89 d0                	mov    %edx,%eax
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  8002c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002c9:	74 2a                	je     8002f5 <cons_read+0x3b>
  8002cb:	eb 05                	jmp    8002d2 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002cd:	e8 ad 0b 00 00       	call   800e7f <sys_yield>
  8002d2:	e8 29 0b 00 00       	call   800e00 <sys_cgetc>
  8002d7:	89 c2                	mov    %eax,%edx
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	74 f0                	je     8002cd <cons_read+0x13>
	if (c < 0)
  8002dd:	85 d2                	test   %edx,%edx
  8002df:	78 14                	js     8002f5 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	83 fa 04             	cmp    $0x4,%edx
  8002e9:	74 0a                	je     8002f5 <cons_read+0x3b>
	*(char*)vbuf = c;
  8002eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ee:	88 10                	mov    %dl,(%eax)
	return 1;
  8002f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  800303:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800306:	be 00 00 00 00       	mov    $0x0,%esi
  80030b:	39 fe                	cmp    %edi,%esi
  80030d:	73 3d                	jae    80034c <cons_write+0x55>
		m = n - tot;
  80030f:	89 fb                	mov    %edi,%ebx
  800311:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800313:	83 fb 7f             	cmp    $0x7f,%ebx
  800316:	76 05                	jbe    80031d <cons_write+0x26>
			m = sizeof(buf) - 1;
  800318:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80031d:	83 ec 04             	sub    $0x4,%esp
  800320:	53                   	push   %ebx
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	01 f0                	add    %esi,%eax
  800326:	50                   	push   %eax
  800327:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  80032d:	50                   	push   %eax
  80032e:	e8 15 09 00 00       	call   800c48 <memmove>
		sys_cputs(buf, m);
  800333:	83 c4 08             	add    $0x8,%esp
  800336:	53                   	push   %ebx
  800337:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  80033d:	50                   	push   %eax
  80033e:	e8 99 0a 00 00       	call   800ddc <sys_cputs>
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	01 de                	add    %ebx,%esi
  800348:	39 fe                	cmp    %edi,%esi
  80034a:	72 c3                	jb     80030f <cons_write+0x18>
	}
	return tot;
}
  80034c:	89 f0                	mov    %esi,%eax
  80034e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <cons_close>:

int
cons_close(struct Fd *fd)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800359:	b8 00 00 00 00       	mov    $0x0,%eax
  80035e:	c9                   	leave  
  80035f:	c3                   	ret    

00800360 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800366:	68 b8 2c 80 00       	push   $0x802cb8
  80036b:	ff 75 0c             	pushl  0xc(%ebp)
  80036e:	e8 59 07 00 00       	call   800acc <strcpy>
	return 0;
}
  800373:	b8 00 00 00 00       	mov    $0x0,%eax
  800378:	c9                   	leave  
  800379:	c3                   	ret    
	...

0080037c <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	8b 75 08             	mov    0x8(%ebp),%esi
  800384:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  800387:	e8 d4 0a 00 00       	call   800e60 <sys_getenvid>
  80038c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800391:	c1 e0 07             	shl    $0x7,%eax
  800394:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800399:	a3 70 9f 80 00       	mov    %eax,0x809f70

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80039e:	85 f6                	test   %esi,%esi
  8003a0:	7e 07                	jle    8003a9 <libmain+0x2d>
		binaryname = argv[0];
  8003a2:	8b 03                	mov    (%ebx),%eax
  8003a4:	a3 a0 87 80 00       	mov    %eax,0x8087a0

	// call user main routine
	umain(argc, argv);
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	53                   	push   %ebx
  8003ad:	56                   	push   %esi
  8003ae:	e8 ae fc ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8003b3:	e8 08 00 00 00       	call   8003c0 <exit>
}
  8003b8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8003bb:	5b                   	pop    %ebx
  8003bc:	5e                   	pop    %esi
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    
	...

008003c0 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8003c6:	e8 fd 0f 00 00       	call   8013c8 <close_all>
	sys_env_destroy(0);
  8003cb:	83 ec 0c             	sub    $0xc,%esp
  8003ce:	6a 00                	push   $0x0
  8003d0:	e8 4a 0a 00 00       	call   800e1f <sys_env_destroy>
}
  8003d5:	c9                   	leave  
  8003d6:	c3                   	ret    
	...

008003d8 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8003df:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8003e2:	83 3d 74 9f 80 00 00 	cmpl   $0x0,0x809f74
  8003e9:	74 16                	je     800401 <_panic+0x29>
		cprintf("%s: ", argv0);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	ff 35 74 9f 80 00    	pushl  0x809f74
  8003f4:	68 d6 2c 80 00       	push   $0x802cd6
  8003f9:	e8 ca 00 00 00       	call   8004c8 <cprintf>
  8003fe:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800401:	ff 75 0c             	pushl  0xc(%ebp)
  800404:	ff 75 08             	pushl  0x8(%ebp)
  800407:	ff 35 a0 87 80 00    	pushl  0x8087a0
  80040d:	68 db 2c 80 00       	push   $0x802cdb
  800412:	e8 b1 00 00 00       	call   8004c8 <cprintf>
	vcprintf(fmt, ap);
  800417:	83 c4 08             	add    $0x8,%esp
  80041a:	53                   	push   %ebx
  80041b:	ff 75 10             	pushl  0x10(%ebp)
  80041e:	e8 54 00 00 00       	call   800477 <vcprintf>
	cprintf("\n");
  800423:	c7 04 24 98 32 80 00 	movl   $0x803298,(%esp)
  80042a:	e8 99 00 00 00       	call   8004c8 <cprintf>

	// Cause a breakpoint exception
	while (1)
  80042f:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  800432:	cc                   	int3   
  800433:	eb fd                	jmp    800432 <_panic+0x5a>
  800435:	00 00                	add    %al,(%eax)
	...

00800438 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	53                   	push   %ebx
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800442:	8b 03                	mov    (%ebx),%eax
  800444:	8b 55 08             	mov    0x8(%ebp),%edx
  800447:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80044b:	40                   	inc    %eax
  80044c:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80044e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800453:	75 1a                	jne    80046f <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	68 ff 00 00 00       	push   $0xff
  80045d:	8d 43 08             	lea    0x8(%ebx),%eax
  800460:	50                   	push   %eax
  800461:	e8 76 09 00 00       	call   800ddc <sys_cputs>
		b->idx = 0;
  800466:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80046c:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80046f:	ff 43 04             	incl   0x4(%ebx)
}
  800472:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800475:	c9                   	leave  
  800476:	c3                   	ret    

00800477 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800480:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  800487:	00 00 00 
	b.cnt = 0;
  80048a:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800491:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800494:	ff 75 0c             	pushl  0xc(%ebp)
  800497:	ff 75 08             	pushl  0x8(%ebp)
  80049a:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  8004a0:	50                   	push   %eax
  8004a1:	68 38 04 80 00       	push   $0x800438
  8004a6:	e8 4f 01 00 00       	call   8005fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ab:	83 c4 08             	add    $0x8,%esp
  8004ae:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8004b4:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8004ba:	50                   	push   %eax
  8004bb:	e8 1c 09 00 00       	call   800ddc <sys_cputs>

	return b.cnt;
  8004c0:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004ce:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d1:	50                   	push   %eax
  8004d2:	ff 75 08             	pushl  0x8(%ebp)
  8004d5:	e8 9d ff ff ff       	call   800477 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	57                   	push   %edi
  8004e0:	56                   	push   %esi
  8004e1:	53                   	push   %ebx
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	8b 75 10             	mov    0x10(%ebp),%esi
  8004e8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8004eb:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f6:	39 fa                	cmp    %edi,%edx
  8004f8:	77 39                	ja     800533 <printnum+0x57>
  8004fa:	72 04                	jb     800500 <printnum+0x24>
  8004fc:	39 f0                	cmp    %esi,%eax
  8004fe:	77 33                	ja     800533 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	ff 75 20             	pushl  0x20(%ebp)
  800506:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800509:	50                   	push   %eax
  80050a:	ff 75 18             	pushl  0x18(%ebp)
  80050d:	8b 45 18             	mov    0x18(%ebp),%eax
  800510:	ba 00 00 00 00       	mov    $0x0,%edx
  800515:	52                   	push   %edx
  800516:	50                   	push   %eax
  800517:	57                   	push   %edi
  800518:	56                   	push   %esi
  800519:	e8 9a 23 00 00       	call   8028b8 <__udivdi3>
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	52                   	push   %edx
  800522:	50                   	push   %eax
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	e8 ae ff ff ff       	call   8004dc <printnum>
  80052e:	83 c4 20             	add    $0x20,%esp
  800531:	eb 19                	jmp    80054c <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800533:	4b                   	dec    %ebx
  800534:	85 db                	test   %ebx,%ebx
  800536:	7e 14                	jle    80054c <printnum+0x70>
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	ff 75 0c             	pushl  0xc(%ebp)
  80053e:	ff 75 20             	pushl  0x20(%ebp)
  800541:	ff 55 08             	call   *0x8(%ebp)
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	4b                   	dec    %ebx
  800548:	85 db                	test   %ebx,%ebx
  80054a:	7f ec                	jg     800538 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	8b 45 18             	mov    0x18(%ebp),%eax
  800555:	ba 00 00 00 00       	mov    $0x0,%edx
  80055a:	83 ec 04             	sub    $0x4,%esp
  80055d:	52                   	push   %edx
  80055e:	50                   	push   %eax
  80055f:	57                   	push   %edi
  800560:	56                   	push   %esi
  800561:	e8 5e 24 00 00       	call   8029c4 <__umoddi3>
  800566:	83 c4 14             	add    $0x14,%esp
  800569:	0f be 80 f1 2d 80 00 	movsbl 0x802df1(%eax),%eax
  800570:	50                   	push   %eax
  800571:	ff 55 08             	call   *0x8(%ebp)
}
  800574:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800577:	5b                   	pop    %ebx
  800578:	5e                   	pop    %esi
  800579:	5f                   	pop    %edi
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800582:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800585:	83 f8 01             	cmp    $0x1,%eax
  800588:	7e 0f                	jle    800599 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  80058a:	8b 01                	mov    (%ecx),%eax
  80058c:	83 c0 08             	add    $0x8,%eax
  80058f:	89 01                	mov    %eax,(%ecx)
  800591:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800594:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800597:	eb 24                	jmp    8005bd <getuint+0x41>
	else if (lflag)
  800599:	85 c0                	test   %eax,%eax
  80059b:	74 11                	je     8005ae <getuint+0x32>
		return va_arg(*ap, unsigned long);
  80059d:	8b 01                	mov    (%ecx),%eax
  80059f:	83 c0 04             	add    $0x4,%eax
  8005a2:	89 01                	mov    %eax,(%ecx)
  8005a4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8005a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ac:	eb 0f                	jmp    8005bd <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8005ae:	8b 01                	mov    (%ecx),%eax
  8005b0:	83 c0 04             	add    $0x4,%eax
  8005b3:	89 01                	mov    %eax,(%ecx)
  8005b5:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

008005bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8005c8:	83 f8 01             	cmp    $0x1,%eax
  8005cb:	7e 0f                	jle    8005dc <getint+0x1d>
		return va_arg(*ap, long long);
  8005cd:	8b 02                	mov    (%edx),%eax
  8005cf:	83 c0 08             	add    $0x8,%eax
  8005d2:	89 02                	mov    %eax,(%edx)
  8005d4:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8005d7:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8005da:	eb 1c                	jmp    8005f8 <getint+0x39>
	else if (lflag)
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	74 0d                	je     8005ed <getint+0x2e>
		return va_arg(*ap, long);
  8005e0:	8b 02                	mov    (%edx),%eax
  8005e2:	83 c0 04             	add    $0x4,%eax
  8005e5:	89 02                	mov    %eax,(%edx)
  8005e7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8005ea:	99                   	cltd   
  8005eb:	eb 0b                	jmp    8005f8 <getint+0x39>
	else
		return va_arg(*ap, int);
  8005ed:	8b 02                	mov    (%edx),%eax
  8005ef:	83 c0 04             	add    $0x4,%eax
  8005f2:	89 02                	mov    %eax,(%edx)
  8005f4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8005f7:	99                   	cltd   
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	57                   	push   %edi
  8005fe:	56                   	push   %esi
  8005ff:	53                   	push   %ebx
  800600:	83 ec 1c             	sub    $0x1c,%esp
  800603:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  800606:	0f b6 13             	movzbl (%ebx),%edx
  800609:	43                   	inc    %ebx
  80060a:	83 fa 25             	cmp    $0x25,%edx
  80060d:	74 1e                	je     80062d <vprintfmt+0x33>
  80060f:	85 d2                	test   %edx,%edx
  800611:	0f 84 d7 02 00 00    	je     8008ee <vprintfmt+0x2f4>
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	52                   	push   %edx
  80061e:	ff 55 08             	call   *0x8(%ebp)
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	0f b6 13             	movzbl (%ebx),%edx
  800627:	43                   	inc    %ebx
  800628:	83 fa 25             	cmp    $0x25,%edx
  80062b:	75 e2                	jne    80060f <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  80062d:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800631:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800638:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  80063d:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800642:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800649:	0f b6 13             	movzbl (%ebx),%edx
  80064c:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  80064f:	43                   	inc    %ebx
  800650:	83 f8 55             	cmp    $0x55,%eax
  800653:	0f 87 70 02 00 00    	ja     8008c9 <vprintfmt+0x2cf>
  800659:	ff 24 85 7c 2e 80 00 	jmp    *0x802e7c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800660:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800664:	eb e3                	jmp    800649 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800666:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  80066a:	eb dd                	jmp    800649 <vprintfmt+0x4f>

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
  80066c:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800671:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800674:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800678:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80067b:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  80067e:	83 f8 09             	cmp    $0x9,%eax
  800681:	77 27                	ja     8006aa <vprintfmt+0xb0>
  800683:	43                   	inc    %ebx
  800684:	eb eb                	jmp    800671 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800686:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800690:	eb 18                	jmp    8006aa <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800692:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800696:	79 b1                	jns    800649 <vprintfmt+0x4f>
				width = 0;
  800698:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  80069f:	eb a8                	jmp    800649 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  8006a1:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8006a8:	eb 9f                	jmp    800649 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8006aa:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8006ae:	79 99                	jns    800649 <vprintfmt+0x4f>
				width = precision, precision = -1;
  8006b0:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8006b3:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8006b8:	eb 8f                	jmp    800649 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ba:	41                   	inc    %ecx
			goto reswitch;
  8006bb:	eb 8c                	jmp    800649 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	e9 2e ff ff ff       	jmp    800606 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d8:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	79 02                	jns    8006e8 <vprintfmt+0xee>
				err = -err;
  8006e6:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006e8:	83 f8 0e             	cmp    $0xe,%eax
  8006eb:	7f 0b                	jg     8006f8 <vprintfmt+0xfe>
  8006ed:	8b 3c 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edi
  8006f4:	85 ff                	test   %edi,%edi
  8006f6:	75 19                	jne    800711 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8006f8:	50                   	push   %eax
  8006f9:	68 02 2e 80 00       	push   $0x802e02
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	ff 75 08             	pushl  0x8(%ebp)
  800704:	e8 ed 01 00 00       	call   8008f6 <printfmt>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	e9 f5 fe ff ff       	jmp    800606 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800711:	57                   	push   %edi
  800712:	68 81 31 80 00       	push   $0x803181
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	ff 75 08             	pushl  0x8(%ebp)
  80071d:	e8 d4 01 00 00       	call   8008f6 <printfmt>
  800722:	83 c4 10             	add    $0x10,%esp
			break;
  800725:	e9 dc fe ff ff       	jmp    800606 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80072a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800734:	85 ff                	test   %edi,%edi
  800736:	75 05                	jne    80073d <vprintfmt+0x143>
				p = "(null)";
  800738:	bf 0b 2e 80 00       	mov    $0x802e0b,%edi
			if (width > 0 && padc != '-')
  80073d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800741:	7e 3b                	jle    80077e <vprintfmt+0x184>
  800743:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  800747:	74 35                	je     80077e <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	56                   	push   %esi
  80074d:	57                   	push   %edi
  80074e:	e8 56 03 00 00       	call   800aa9 <strnlen>
  800753:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80075d:	7e 1f                	jle    80077e <vprintfmt+0x184>
  80075f:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800763:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  80076f:	ff 55 08             	call   *0x8(%ebp)
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800778:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80077c:	7f e8                	jg     800766 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80077e:	0f be 17             	movsbl (%edi),%edx
  800781:	47                   	inc    %edi
  800782:	85 d2                	test   %edx,%edx
  800784:	74 44                	je     8007ca <vprintfmt+0x1d0>
  800786:	85 f6                	test   %esi,%esi
  800788:	78 03                	js     80078d <vprintfmt+0x193>
  80078a:	4e                   	dec    %esi
  80078b:	78 3d                	js     8007ca <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  80078d:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800791:	74 18                	je     8007ab <vprintfmt+0x1b1>
  800793:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  800796:	83 f8 5e             	cmp    $0x5e,%eax
  800799:	76 10                	jbe    8007ab <vprintfmt+0x1b1>
					putch('?', putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	6a 3f                	push   $0x3f
  8007a3:	ff 55 08             	call   *0x8(%ebp)
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	eb 0d                	jmp    8007b8 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	52                   	push   %edx
  8007b2:	ff 55 08             	call   *0x8(%ebp)
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8007bb:	0f be 17             	movsbl (%edi),%edx
  8007be:	47                   	inc    %edi
  8007bf:	85 d2                	test   %edx,%edx
  8007c1:	74 07                	je     8007ca <vprintfmt+0x1d0>
  8007c3:	85 f6                	test   %esi,%esi
  8007c5:	78 c6                	js     80078d <vprintfmt+0x193>
  8007c7:	4e                   	dec    %esi
  8007c8:	79 c3                	jns    80078d <vprintfmt+0x193>
			for (; width > 0; width--)
  8007ca:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8007ce:	0f 8e 32 fe ff ff    	jle    800606 <vprintfmt+0xc>
				putch(' ', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	6a 20                	push   $0x20
  8007dc:	ff 55 08             	call   *0x8(%ebp)
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8007e5:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8007e9:	7f e9                	jg     8007d4 <vprintfmt+0x1da>
			break;
  8007eb:	e9 16 fe ff ff       	jmp    800606 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007f0:	51                   	push   %ecx
  8007f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	e8 c5 fd ff ff       	call   8005bf <getint>
  8007fa:	89 c6                	mov    %eax,%esi
  8007fc:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8007fe:	83 c4 08             	add    $0x8,%esp
  800801:	85 d2                	test   %edx,%edx
  800803:	79 15                	jns    80081a <vprintfmt+0x220>
				putch('-', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	6a 2d                	push   $0x2d
  80080d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800810:	f7 de                	neg    %esi
  800812:	83 d7 00             	adc    $0x0,%edi
  800815:	f7 df                	neg    %edi
  800817:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80081a:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80081f:	eb 75                	jmp    800896 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800821:	51                   	push   %ecx
  800822:	8d 45 14             	lea    0x14(%ebp),%eax
  800825:	50                   	push   %eax
  800826:	e8 51 fd ff ff       	call   80057c <getuint>
  80082b:	89 c6                	mov    %eax,%esi
  80082d:	89 d7                	mov    %edx,%edi
			base = 10;
  80082f:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800834:	83 c4 08             	add    $0x8,%esp
  800837:	eb 5d                	jmp    800896 <vprintfmt+0x29c>

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
  800839:	51                   	push   %ecx
  80083a:	8d 45 14             	lea    0x14(%ebp),%eax
  80083d:	50                   	push   %eax
  80083e:	e8 39 fd ff ff       	call   80057c <getuint>
  800843:	89 c6                	mov    %eax,%esi
  800845:	89 d7                	mov    %edx,%edi
			base = 8;
  800847:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  80084c:	83 c4 08             	add    $0x8,%esp
  80084f:	eb 45                	jmp    800896 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	6a 30                	push   $0x30
  800859:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80085c:	83 c4 08             	add    $0x8,%esp
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	6a 78                	push   $0x78
  800864:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800867:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800871:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800876:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	eb 16                	jmp    800896 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800880:	51                   	push   %ecx
  800881:	8d 45 14             	lea    0x14(%ebp),%eax
  800884:	50                   	push   %eax
  800885:	e8 f2 fc ff ff       	call   80057c <getuint>
  80088a:	89 c6                	mov    %eax,%esi
  80088c:	89 d7                	mov    %edx,%edi
			base = 16;
  80088e:	ba 10 00 00 00       	mov    $0x10,%edx
  800893:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  800896:	83 ec 04             	sub    $0x4,%esp
  800899:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80089d:	50                   	push   %eax
  80089e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8008a1:	52                   	push   %edx
  8008a2:	57                   	push   %edi
  8008a3:	56                   	push   %esi
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 2d fc ff ff       	call   8004dc <printnum>
			break;
  8008af:	83 c4 20             	add    $0x20,%esp
  8008b2:	e9 4f fd ff ff       	jmp    800606 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	52                   	push   %edx
  8008be:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	e9 3d fd ff ff       	jmp    800606 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	6a 25                	push   $0x25
  8008d1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d4:	4b                   	dec    %ebx
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8008dc:	0f 84 24 fd ff ff    	je     800606 <vprintfmt+0xc>
  8008e2:	4b                   	dec    %ebx
  8008e3:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8008e7:	75 f9                	jne    8008e2 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8008e9:	e9 18 fd ff ff       	jmp    800606 <vprintfmt+0xc>
		}
	}
}
  8008ee:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8008f1:	5b                   	pop    %ebx
  8008f2:	5e                   	pop    %esi
  8008f3:	5f                   	pop    %edi
  8008f4:	c9                   	leave  
  8008f5:	c3                   	ret    

008008f6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8008fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008ff:	50                   	push   %eax
  800900:	ff 75 10             	pushl  0x10(%ebp)
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 ec fc ff ff       	call   8005fa <vprintfmt>
	va_end(ap);
}
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  800916:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800919:	8b 0a                	mov    (%edx),%ecx
  80091b:	3b 4a 04             	cmp    0x4(%edx),%ecx
  80091e:	73 07                	jae    800927 <sprintputch+0x17>
		*b->buf++ = ch;
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	88 01                	mov    %al,(%ecx)
  800925:	ff 02                	incl   (%edx)
}
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	83 ec 18             	sub    $0x18,%esp
  80092f:	8b 55 08             	mov    0x8(%ebp),%edx
  800932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800935:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800938:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  80093c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  800946:	85 d2                	test   %edx,%edx
  800948:	74 04                	je     80094e <vsnprintf+0x25>
  80094a:	85 c9                	test   %ecx,%ecx
  80094c:	7f 07                	jg     800955 <vsnprintf+0x2c>
		return -E_INVAL;
  80094e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800953:	eb 1d                	jmp    800972 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800955:	ff 75 14             	pushl  0x14(%ebp)
  800958:	ff 75 10             	pushl  0x10(%ebp)
  80095b:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	68 10 09 80 00       	push   $0x800910
  800964:	e8 91 fc ff ff       	call   8005fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800969:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  80096c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80096f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  800972:	c9                   	leave  
  800973:	c3                   	ret    

00800974 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80097d:	50                   	push   %eax
  80097e:	ff 75 10             	pushl  0x10(%ebp)
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	ff 75 08             	pushl  0x8(%ebp)
  800987:	e8 9d ff ff ff       	call   800929 <vsnprintf>
	va_end(ap);

	return rc;
}
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    
	...

00800990 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800998:	83 ec 0c             	sub    $0xc,%esp
  80099b:	56                   	push   %esi
  80099c:	e8 ef 00 00 00       	call   800a90 <strlen>
  char letter;
  int hexnum = 0;
  8009a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  8009a6:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	4a                   	dec    %edx
  8009b1:	0f 88 d0 00 00 00    	js     800a87 <strtoint+0xf7>
    letter = string[cidx];
  8009b7:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8009ba:	85 d2                	test   %edx,%edx
  8009bc:	75 12                	jne    8009d0 <strtoint+0x40>
      if (letter != '0') {
  8009be:	3c 30                	cmp    $0x30,%al
  8009c0:	0f 84 ba 00 00 00    	je     800a80 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8009c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8009cb:	e9 b9 00 00 00       	jmp    800a89 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  8009d0:	83 fa 01             	cmp    $0x1,%edx
  8009d3:	75 12                	jne    8009e7 <strtoint+0x57>
      if (letter != 'x') {
  8009d5:	3c 78                	cmp    $0x78,%al
  8009d7:	0f 84 a3 00 00 00    	je     800a80 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8009dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8009e2:	e9 a2 00 00 00       	jmp    800a89 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8009e7:	0f be c0             	movsbl %al,%eax
  8009ea:	83 e8 30             	sub    $0x30,%eax
  8009ed:	83 f8 36             	cmp    $0x36,%eax
  8009f0:	0f 87 80 00 00 00    	ja     800a76 <strtoint+0xe6>
  8009f6:	ff 24 85 d4 2f 80 00 	jmp    *0x802fd4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8009fd:	01 cb                	add    %ecx,%ebx
          break;
  8009ff:	eb 7c                	jmp    800a7d <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800a01:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800a04:	eb 77                	jmp    800a7d <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  800a06:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a09:	01 c3                	add    %eax,%ebx
          break;
  800a0b:	eb 70                	jmp    800a7d <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800a0d:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800a10:	eb 6b                	jmp    800a7d <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800a12:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800a15:	01 c3                	add    %eax,%ebx
          break;
  800a17:	eb 64                	jmp    800a7d <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800a19:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a1c:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a1f:	eb 5c                	jmp    800a7d <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800a21:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800a28:	29 c8                	sub    %ecx,%eax
  800a2a:	01 c3                	add    %eax,%ebx
          break;
  800a2c:	eb 4f                	jmp    800a7d <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  800a2e:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800a31:	eb 4a                	jmp    800a7d <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  800a33:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  800a36:	01 c3                	add    %eax,%ebx
          break;
  800a38:	eb 43                	jmp    800a7d <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  800a3a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800a3d:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a40:	eb 3b                	jmp    800a7d <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800a42:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800a45:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800a48:	01 c3                	add    %eax,%ebx
          break;
  800a4a:	eb 31                	jmp    800a7d <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800a4c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a4f:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800a52:	eb 29                	jmp    800a7d <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800a54:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a57:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800a5a:	01 c3                	add    %eax,%ebx
          break;
  800a5c:	eb 1f                	jmp    800a7d <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800a5e:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800a65:	29 c8                	sub    %ecx,%eax
  800a67:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a6a:	eb 11                	jmp    800a7d <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800a6c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a6f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a72:	01 c3                	add    %eax,%ebx
          break;
  800a74:	eb 07                	jmp    800a7d <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  800a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800a7b:	eb 0c                	jmp    800a89 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800a7d:	c1 e1 04             	shl    $0x4,%ecx
  800a80:	4a                   	dec    %edx
  800a81:	0f 89 30 ff ff ff    	jns    8009b7 <strtoint+0x27>
    }
  }

  return hexnum;
  800a87:	89 d8                	mov    %ebx,%eax
}
  800a89:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800a8c:	5b                   	pop    %ebx
  800a8d:	5e                   	pop    %esi
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <strlen>:





int
strlen(const char *s)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a9e:	74 07                	je     800aa7 <strlen+0x17>
		n++;
  800aa0:	40                   	inc    %eax
  800aa1:	42                   	inc    %edx
  800aa2:	80 3a 00             	cmpb   $0x0,(%edx)
  800aa5:	75 f9                	jne    800aa0 <strlen+0x10>
	return n;
}
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab7:	85 d2                	test   %edx,%edx
  800ab9:	74 0f                	je     800aca <strnlen+0x21>
  800abb:	80 39 00             	cmpb   $0x0,(%ecx)
  800abe:	74 0a                	je     800aca <strnlen+0x21>
		n++;
  800ac0:	40                   	inc    %eax
  800ac1:	41                   	inc    %ecx
  800ac2:	4a                   	dec    %edx
  800ac3:	74 05                	je     800aca <strnlen+0x21>
  800ac5:	80 39 00             	cmpb   $0x0,(%ecx)
  800ac8:	75 f6                	jne    800ac0 <strnlen+0x17>
	return n;
}
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    

00800acc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	53                   	push   %ebx
  800ad0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800ad6:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800ad8:	8a 02                	mov    (%edx),%al
  800ada:	42                   	inc    %edx
  800adb:	88 01                	mov    %al,(%ecx)
  800add:	41                   	inc    %ecx
  800ade:	84 c0                	test   %al,%al
  800ae0:	75 f6                	jne    800ad8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ae2:	89 d8                	mov    %ebx,%eax
  800ae4:	5b                   	pop    %ebx
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
  800aed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af3:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  800af6:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800af8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800afd:	39 f3                	cmp    %esi,%ebx
  800aff:	73 10                	jae    800b11 <strncpy+0x2a>
		*dst++ = *src;
  800b01:	8a 02                	mov    (%edx),%al
  800b03:	88 01                	mov    %al,(%ecx)
  800b05:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b06:	80 3a 01             	cmpb   $0x1,(%edx)
  800b09:	83 da ff             	sbb    $0xffffffff,%edx
  800b0c:	43                   	inc    %ebx
  800b0d:	39 f3                	cmp    %esi,%ebx
  800b0f:	72 f0                	jb     800b01 <strncpy+0x1a>
	}
	return ret;
}
  800b11:	89 f8                	mov    %edi,%eax
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
  800b1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b23:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  800b26:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800b28:	85 d2                	test   %edx,%edx
  800b2a:	74 19                	je     800b45 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b2c:	4a                   	dec    %edx
  800b2d:	74 13                	je     800b42 <strlcpy+0x2a>
  800b2f:	80 39 00             	cmpb   $0x0,(%ecx)
  800b32:	74 0e                	je     800b42 <strlcpy+0x2a>
  800b34:	8a 01                	mov    (%ecx),%al
  800b36:	41                   	inc    %ecx
  800b37:	88 03                	mov    %al,(%ebx)
  800b39:	43                   	inc    %ebx
  800b3a:	4a                   	dec    %edx
  800b3b:	74 05                	je     800b42 <strlcpy+0x2a>
  800b3d:	80 39 00             	cmpb   $0x0,(%ecx)
  800b40:	75 f2                	jne    800b34 <strlcpy+0x1c>
		*dst = '\0';
  800b42:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800b45:	89 d8                	mov    %ebx,%eax
  800b47:	29 f0                	sub    %esi,%eax
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	8b 55 08             	mov    0x8(%ebp),%edx
  800b53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800b56:	80 3a 00             	cmpb   $0x0,(%edx)
  800b59:	74 13                	je     800b6e <strcmp+0x21>
  800b5b:	8a 02                	mov    (%edx),%al
  800b5d:	3a 01                	cmp    (%ecx),%al
  800b5f:	75 0d                	jne    800b6e <strcmp+0x21>
  800b61:	42                   	inc    %edx
  800b62:	41                   	inc    %ecx
  800b63:	80 3a 00             	cmpb   $0x0,(%edx)
  800b66:	74 06                	je     800b6e <strcmp+0x21>
  800b68:	8a 02                	mov    (%edx),%al
  800b6a:	3a 01                	cmp    (%ecx),%al
  800b6c:	74 f3                	je     800b61 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6e:	0f b6 02             	movzbl (%edx),%eax
  800b71:	0f b6 11             	movzbl (%ecx),%edx
  800b74:	29 d0                	sub    %edx,%eax
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	53                   	push   %ebx
  800b7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b82:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800b85:	85 c9                	test   %ecx,%ecx
  800b87:	74 1f                	je     800ba8 <strncmp+0x30>
  800b89:	80 3a 00             	cmpb   $0x0,(%edx)
  800b8c:	74 16                	je     800ba4 <strncmp+0x2c>
  800b8e:	8a 02                	mov    (%edx),%al
  800b90:	3a 03                	cmp    (%ebx),%al
  800b92:	75 10                	jne    800ba4 <strncmp+0x2c>
  800b94:	42                   	inc    %edx
  800b95:	43                   	inc    %ebx
  800b96:	49                   	dec    %ecx
  800b97:	74 0f                	je     800ba8 <strncmp+0x30>
  800b99:	80 3a 00             	cmpb   $0x0,(%edx)
  800b9c:	74 06                	je     800ba4 <strncmp+0x2c>
  800b9e:	8a 02                	mov    (%edx),%al
  800ba0:	3a 03                	cmp    (%ebx),%al
  800ba2:	74 f0                	je     800b94 <strncmp+0x1c>
	if (n == 0)
  800ba4:	85 c9                	test   %ecx,%ecx
  800ba6:	75 07                	jne    800baf <strncmp+0x37>
		return 0;
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	eb 0a                	jmp    800bb9 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800baf:	0f b6 12             	movzbl (%edx),%edx
  800bb2:	0f b6 03             	movzbl (%ebx),%eax
  800bb5:	29 c2                	sub    %eax,%edx
  800bb7:	89 d0                	mov    %edx,%eax
}
  800bb9:	5b                   	pop    %ebx
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800bc5:	80 38 00             	cmpb   $0x0,(%eax)
  800bc8:	74 0a                	je     800bd4 <strchr+0x18>
		if (*s == c)
  800bca:	38 10                	cmp    %dl,(%eax)
  800bcc:	74 0b                	je     800bd9 <strchr+0x1d>
  800bce:	40                   	inc    %eax
  800bcf:	80 38 00             	cmpb   $0x0,(%eax)
  800bd2:	75 f6                	jne    800bca <strchr+0xe>
			return (char *) s;
	return 0;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800be4:	80 38 00             	cmpb   $0x0,(%eax)
  800be7:	74 0a                	je     800bf3 <strfind+0x18>
		if (*s == c)
  800be9:	38 10                	cmp    %dl,(%eax)
  800beb:	74 06                	je     800bf3 <strfind+0x18>
  800bed:	40                   	inc    %eax
  800bee:	80 38 00             	cmpb   $0x0,(%eax)
  800bf1:	75 f6                	jne    800be9 <strfind+0xe>
			break;
	return (char *) s;
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bfc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800bff:	89 f8                	mov    %edi,%eax
  800c01:	85 c9                	test   %ecx,%ecx
  800c03:	74 40                	je     800c45 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800c05:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c0b:	75 30                	jne    800c3d <memset+0x48>
  800c0d:	f6 c1 03             	test   $0x3,%cl
  800c10:	75 2b                	jne    800c3d <memset+0x48>
		c &= 0xFF;
  800c12:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	c1 e0 18             	shl    $0x18,%eax
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	c1 e2 10             	shl    $0x10,%edx
  800c25:	09 d0                	or     %edx,%eax
  800c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2a:	c1 e2 08             	shl    $0x8,%edx
  800c2d:	09 d0                	or     %edx,%eax
  800c2f:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800c32:	c1 e9 02             	shr    $0x2,%ecx
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	fc                   	cld    
  800c39:	f3 ab                	repz stos %eax,%es:(%edi)
  800c3b:	eb 06                	jmp    800c43 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	fc                   	cld    
  800c41:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800c43:	89 f8                	mov    %edi,%eax
}
  800c45:	5f                   	pop    %edi
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800c53:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c56:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c58:	39 c6                	cmp    %eax,%esi
  800c5a:	73 33                	jae    800c8f <memmove+0x47>
  800c5c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c5f:	39 c2                	cmp    %eax,%edx
  800c61:	76 2c                	jbe    800c8f <memmove+0x47>
		s += n;
  800c63:	89 d6                	mov    %edx,%esi
		d += n;
  800c65:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c68:	f6 c2 03             	test   $0x3,%dl
  800c6b:	75 1b                	jne    800c88 <memmove+0x40>
  800c6d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c73:	75 13                	jne    800c88 <memmove+0x40>
  800c75:	f6 c1 03             	test   $0x3,%cl
  800c78:	75 0e                	jne    800c88 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800c7a:	83 ef 04             	sub    $0x4,%edi
  800c7d:	83 ee 04             	sub    $0x4,%esi
  800c80:	c1 e9 02             	shr    $0x2,%ecx
  800c83:	fd                   	std    
  800c84:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800c86:	eb 27                	jmp    800caf <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c88:	4f                   	dec    %edi
  800c89:	4e                   	dec    %esi
  800c8a:	fd                   	std    
  800c8b:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800c8d:	eb 20                	jmp    800caf <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c95:	75 15                	jne    800cac <memmove+0x64>
  800c97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c9d:	75 0d                	jne    800cac <memmove+0x64>
  800c9f:	f6 c1 03             	test   $0x3,%cl
  800ca2:	75 08                	jne    800cac <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800ca4:	c1 e9 02             	shr    $0x2,%ecx
  800ca7:	fc                   	cld    
  800ca8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800caa:	eb 03                	jmp    800caf <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cac:	fc                   	cld    
  800cad:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <memcpy>:

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
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800cb6:	ff 75 10             	pushl  0x10(%ebp)
  800cb9:	ff 75 0c             	pushl  0xc(%ebp)
  800cbc:	ff 75 08             	pushl  0x8(%ebp)
  800cbf:	e8 84 ff ff ff       	call   800c48 <memmove>
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800cca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800ccd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cd0:	8b 55 10             	mov    0x10(%ebp),%edx
  800cd3:	4a                   	dec    %edx
  800cd4:	83 fa ff             	cmp    $0xffffffff,%edx
  800cd7:	74 1a                	je     800cf3 <memcmp+0x2d>
  800cd9:	8a 01                	mov    (%ecx),%al
  800cdb:	3a 03                	cmp    (%ebx),%al
  800cdd:	74 0c                	je     800ceb <memcmp+0x25>
  800cdf:	0f b6 d0             	movzbl %al,%edx
  800ce2:	0f b6 03             	movzbl (%ebx),%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
  800ce9:	eb 0d                	jmp    800cf8 <memcmp+0x32>
  800ceb:	41                   	inc    %ecx
  800cec:	43                   	inc    %ebx
  800ced:	4a                   	dec    %edx
  800cee:	83 fa ff             	cmp    $0xffffffff,%edx
  800cf1:	75 e6                	jne    800cd9 <memcmp+0x13>
	}

	return 0;
  800cf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf8:	5b                   	pop    %ebx
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d04:	89 c2                	mov    %eax,%edx
  800d06:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d09:	39 d0                	cmp    %edx,%eax
  800d0b:	73 09                	jae    800d16 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d0d:	38 08                	cmp    %cl,(%eax)
  800d0f:	74 05                	je     800d16 <memfind+0x1b>
  800d11:	40                   	inc    %eax
  800d12:	39 d0                	cmp    %edx,%eax
  800d14:	72 f7                	jb     800d0d <memfind+0x12>
			break;
	return (void *) s;
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d24:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800d27:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800d2c:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800d31:	80 3a 20             	cmpb   $0x20,(%edx)
  800d34:	74 05                	je     800d3b <strtol+0x23>
  800d36:	80 3a 09             	cmpb   $0x9,(%edx)
  800d39:	75 0b                	jne    800d46 <strtol+0x2e>
  800d3b:	42                   	inc    %edx
  800d3c:	80 3a 20             	cmpb   $0x20,(%edx)
  800d3f:	74 fa                	je     800d3b <strtol+0x23>
  800d41:	80 3a 09             	cmpb   $0x9,(%edx)
  800d44:	74 f5                	je     800d3b <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800d46:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800d49:	75 03                	jne    800d4e <strtol+0x36>
		s++;
  800d4b:	42                   	inc    %edx
  800d4c:	eb 0b                	jmp    800d59 <strtol+0x41>
	else if (*s == '-')
  800d4e:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800d51:	75 06                	jne    800d59 <strtol+0x41>
		s++, neg = 1;
  800d53:	42                   	inc    %edx
  800d54:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d59:	85 c9                	test   %ecx,%ecx
  800d5b:	74 05                	je     800d62 <strtol+0x4a>
  800d5d:	83 f9 10             	cmp    $0x10,%ecx
  800d60:	75 15                	jne    800d77 <strtol+0x5f>
  800d62:	80 3a 30             	cmpb   $0x30,(%edx)
  800d65:	75 10                	jne    800d77 <strtol+0x5f>
  800d67:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d6b:	75 0a                	jne    800d77 <strtol+0x5f>
		s += 2, base = 16;
  800d6d:	83 c2 02             	add    $0x2,%edx
  800d70:	b9 10 00 00 00       	mov    $0x10,%ecx
  800d75:	eb 14                	jmp    800d8b <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800d77:	85 c9                	test   %ecx,%ecx
  800d79:	75 10                	jne    800d8b <strtol+0x73>
  800d7b:	80 3a 30             	cmpb   $0x30,(%edx)
  800d7e:	75 05                	jne    800d85 <strtol+0x6d>
		s++, base = 8;
  800d80:	42                   	inc    %edx
  800d81:	b1 08                	mov    $0x8,%cl
  800d83:	eb 06                	jmp    800d8b <strtol+0x73>
	else if (base == 0)
  800d85:	85 c9                	test   %ecx,%ecx
  800d87:	75 02                	jne    800d8b <strtol+0x73>
		base = 10;
  800d89:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d8b:	8a 02                	mov    (%edx),%al
  800d8d:	83 e8 30             	sub    $0x30,%eax
  800d90:	3c 09                	cmp    $0x9,%al
  800d92:	77 08                	ja     800d9c <strtol+0x84>
			dig = *s - '0';
  800d94:	0f be 02             	movsbl (%edx),%eax
  800d97:	83 e8 30             	sub    $0x30,%eax
  800d9a:	eb 20                	jmp    800dbc <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800d9c:	8a 02                	mov    (%edx),%al
  800d9e:	83 e8 61             	sub    $0x61,%eax
  800da1:	3c 19                	cmp    $0x19,%al
  800da3:	77 08                	ja     800dad <strtol+0x95>
			dig = *s - 'a' + 10;
  800da5:	0f be 02             	movsbl (%edx),%eax
  800da8:	83 e8 57             	sub    $0x57,%eax
  800dab:	eb 0f                	jmp    800dbc <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800dad:	8a 02                	mov    (%edx),%al
  800daf:	83 e8 41             	sub    $0x41,%eax
  800db2:	3c 19                	cmp    $0x19,%al
  800db4:	77 12                	ja     800dc8 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800db6:	0f be 02             	movsbl (%edx),%eax
  800db9:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800dbc:	39 c8                	cmp    %ecx,%eax
  800dbe:	7d 08                	jge    800dc8 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800dc0:	42                   	inc    %edx
  800dc1:	0f af d9             	imul   %ecx,%ebx
  800dc4:	01 c3                	add    %eax,%ebx
  800dc6:	eb c3                	jmp    800d8b <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc8:	85 f6                	test   %esi,%esi
  800dca:	74 02                	je     800dce <strtol+0xb6>
		*endptr = (char *) s;
  800dcc:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dce:	89 d8                	mov    %ebx,%eax
  800dd0:	85 ff                	test   %edi,%edi
  800dd2:	74 02                	je     800dd6 <strtol+0xbe>
  800dd4:	f7 d8                	neg    %eax
}
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	c9                   	leave  
  800dda:	c3                   	ret    
	...

00800ddc <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 04             	sub    $0x4,%esp
  800de5:	8b 55 08             	mov    0x8(%ebp),%edx
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	bf 00 00 00 00       	mov    $0x0,%edi
  800df0:	89 f8                	mov    %edi,%eax
  800df2:	89 fb                	mov    %edi,%ebx
  800df4:	89 fe                	mov    %edi,%esi
  800df6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df8:	83 c4 04             	add    $0x4,%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800e10:	89 fa                	mov    %edi,%edx
  800e12:	89 f9                	mov    %edi,%ecx
  800e14:	89 fb                	mov    %edi,%ebx
  800e16:	89 fe                	mov    %edi,%esi
  800e18:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	bf 00 00 00 00       	mov    $0x0,%edi
  800e35:	89 f9                	mov    %edi,%ecx
  800e37:	89 fb                	mov    %edi,%ebx
  800e39:	89 fe                	mov    %edi,%esi
  800e3b:	cd 30                	int    $0x30
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7e 17                	jle    800e58 <sys_env_destroy+0x39>
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	50                   	push   %eax
  800e45:	6a 03                	push   $0x3
  800e47:	68 b0 30 80 00       	push   $0x8030b0
  800e4c:	6a 23                	push   $0x23
  800e4e:	68 cd 30 80 00       	push   $0x8030cd
  800e53:	e8 80 f5 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e58:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	b8 02 00 00 00       	mov    $0x2,%eax
  800e6b:	bf 00 00 00 00       	mov    $0x0,%edi
  800e70:	89 fa                	mov    %edi,%edx
  800e72:	89 f9                	mov    %edi,%ecx
  800e74:	89 fb                	mov    %edi,%ebx
  800e76:	89 fe                	mov    %edi,%esi
  800e78:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <sys_yield>:

void
sys_yield(void)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e8f:	89 fa                	mov    %edi,%edx
  800e91:	89 f9                	mov    %edi,%ecx
  800e93:	89 fb                	mov    %edi,%ebx
  800e95:	89 fe                	mov    %edi,%esi
  800e97:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb0:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb5:	bf 00 00 00 00       	mov    $0x0,%edi
  800eba:	89 fe                	mov    %edi,%esi
  800ebc:	cd 30                	int    $0x30
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7e 17                	jle    800ed9 <sys_page_alloc+0x3b>
  800ec2:	83 ec 0c             	sub    $0xc,%esp
  800ec5:	50                   	push   %eax
  800ec6:	6a 04                	push   $0x4
  800ec8:	68 b0 30 80 00       	push   $0x8030b0
  800ecd:	6a 23                	push   $0x23
  800ecf:	68 cd 30 80 00       	push   $0x8030cd
  800ed4:	e8 ff f4 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ed9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800edc:	5b                   	pop    %ebx
  800edd:	5e                   	pop    %esi
  800ede:	5f                   	pop    %edi
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    

00800ee1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef6:	8b 75 18             	mov    0x18(%ebp),%esi
  800ef9:	b8 05 00 00 00       	mov    $0x5,%eax
  800efe:	cd 30                	int    $0x30
  800f00:	85 c0                	test   %eax,%eax
  800f02:	7e 17                	jle    800f1b <sys_page_map+0x3a>
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	50                   	push   %eax
  800f08:	6a 05                	push   $0x5
  800f0a:	68 b0 30 80 00       	push   $0x8030b0
  800f0f:	6a 23                	push   $0x23
  800f11:	68 cd 30 80 00       	push   $0x8030cd
  800f16:	e8 bd f4 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f1b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 0c             	sub    $0xc,%esp
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	b8 06 00 00 00       	mov    $0x6,%eax
  800f37:	bf 00 00 00 00       	mov    $0x0,%edi
  800f3c:	89 fb                	mov    %edi,%ebx
  800f3e:	89 fe                	mov    %edi,%esi
  800f40:	cd 30                	int    $0x30
  800f42:	85 c0                	test   %eax,%eax
  800f44:	7e 17                	jle    800f5d <sys_page_unmap+0x3a>
  800f46:	83 ec 0c             	sub    $0xc,%esp
  800f49:	50                   	push   %eax
  800f4a:	6a 06                	push   $0x6
  800f4c:	68 b0 30 80 00       	push   $0x8030b0
  800f51:	6a 23                	push   $0x23
  800f53:	68 cd 30 80 00       	push   $0x8030cd
  800f58:	e8 7b f4 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f5d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f74:	b8 08 00 00 00       	mov    $0x8,%eax
  800f79:	bf 00 00 00 00       	mov    $0x0,%edi
  800f7e:	89 fb                	mov    %edi,%ebx
  800f80:	89 fe                	mov    %edi,%esi
  800f82:	cd 30                	int    $0x30
  800f84:	85 c0                	test   %eax,%eax
  800f86:	7e 17                	jle    800f9f <sys_env_set_status+0x3a>
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	6a 08                	push   $0x8
  800f8e:	68 b0 30 80 00       	push   $0x8030b0
  800f93:	6a 23                	push   $0x23
  800f95:	68 cd 30 80 00       	push   $0x8030cd
  800f9a:	e8 39 f4 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f9f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5f                   	pop    %edi
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	57                   	push   %edi
  800fab:	56                   	push   %esi
  800fac:	53                   	push   %ebx
  800fad:	83 ec 0c             	sub    $0xc,%esp
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 09 00 00 00       	mov    $0x9,%eax
  800fbb:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc0:	89 fb                	mov    %edi,%ebx
  800fc2:	89 fe                	mov    %edi,%esi
  800fc4:	cd 30                	int    $0x30
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	7e 17                	jle    800fe1 <sys_env_set_trapframe+0x3a>
  800fca:	83 ec 0c             	sub    $0xc,%esp
  800fcd:	50                   	push   %eax
  800fce:	6a 09                	push   $0x9
  800fd0:	68 b0 30 80 00       	push   $0x8030b0
  800fd5:	6a 23                	push   $0x23
  800fd7:	68 cd 30 80 00       	push   $0x8030cd
  800fdc:	e8 f7 f3 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fe1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffd:	bf 00 00 00 00       	mov    $0x0,%edi
  801002:	89 fb                	mov    %edi,%ebx
  801004:	89 fe                	mov    %edi,%esi
  801006:	cd 30                	int    $0x30
  801008:	85 c0                	test   %eax,%eax
  80100a:	7e 17                	jle    801023 <sys_env_set_pgfault_upcall+0x3a>
  80100c:	83 ec 0c             	sub    $0xc,%esp
  80100f:	50                   	push   %eax
  801010:	6a 0a                	push   $0xa
  801012:	68 b0 30 80 00       	push   $0x8030b0
  801017:	6a 23                	push   $0x23
  801019:	68 cd 30 80 00       	push   $0x8030cd
  80101e:	e8 b5 f3 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801023:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801037:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80103d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801042:	be 00 00 00 00       	mov    $0x0,%esi
  801047:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	c9                   	leave  
  80104d:	c3                   	ret    

0080104e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	8b 55 08             	mov    0x8(%ebp),%edx
  80105a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105f:	bf 00 00 00 00       	mov    $0x0,%edi
  801064:	89 f9                	mov    %edi,%ecx
  801066:	89 fb                	mov    %edi,%ebx
  801068:	89 fe                	mov    %edi,%esi
  80106a:	cd 30                	int    $0x30
  80106c:	85 c0                	test   %eax,%eax
  80106e:	7e 17                	jle    801087 <sys_ipc_recv+0x39>
  801070:	83 ec 0c             	sub    $0xc,%esp
  801073:	50                   	push   %eax
  801074:	6a 0d                	push   $0xd
  801076:	68 b0 30 80 00       	push   $0x8030b0
  80107b:	6a 23                	push   $0x23
  80107d:	68 cd 30 80 00       	push   $0x8030cd
  801082:	e8 51 f3 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801087:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80108a:	5b                   	pop    %ebx
  80108b:	5e                   	pop    %esi
  80108c:	5f                   	pop    %edi
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	57                   	push   %edi
  801093:	56                   	push   %esi
  801094:	53                   	push   %ebx
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	8b 55 08             	mov    0x8(%ebp),%edx
  80109b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109e:	b8 10 00 00 00       	mov    $0x10,%eax
  8010a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8010a8:	89 fb                	mov    %edi,%ebx
  8010aa:	89 fe                	mov    %edi,%esi
  8010ac:	cd 30                	int    $0x30
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	7e 17                	jle    8010c9 <sys_transmit_packet+0x3a>
  8010b2:	83 ec 0c             	sub    $0xc,%esp
  8010b5:	50                   	push   %eax
  8010b6:	6a 10                	push   $0x10
  8010b8:	68 b0 30 80 00       	push   $0x8030b0
  8010bd:	6a 23                	push   $0x23
  8010bf:	68 cd 30 80 00       	push   $0x8030cd
  8010c4:	e8 0f f3 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  8010c9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	57                   	push   %edi
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e0:	b8 11 00 00 00       	mov    $0x11,%eax
  8010e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ea:	89 fb                	mov    %edi,%ebx
  8010ec:	89 fe                	mov    %edi,%esi
  8010ee:	cd 30                	int    $0x30
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	7e 17                	jle    80110b <sys_receive_packet+0x3a>
  8010f4:	83 ec 0c             	sub    $0xc,%esp
  8010f7:	50                   	push   %eax
  8010f8:	6a 11                	push   $0x11
  8010fa:	68 b0 30 80 00       	push   $0x8030b0
  8010ff:	6a 23                	push   $0x23
  801101:	68 cd 30 80 00       	push   $0x8030cd
  801106:	e8 cd f2 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  80110b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80110e:	5b                   	pop    %ebx
  80110f:	5e                   	pop    %esi
  801110:	5f                   	pop    %edi
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	57                   	push   %edi
  801117:	56                   	push   %esi
  801118:	53                   	push   %ebx
  801119:	b8 0f 00 00 00       	mov    $0xf,%eax
  80111e:	bf 00 00 00 00       	mov    $0x0,%edi
  801123:	89 fa                	mov    %edi,%edx
  801125:	89 f9                	mov    %edi,%ecx
  801127:	89 fb                	mov    %edi,%ebx
  801129:	89 fe                	mov    %edi,%esi
  80112b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801143:	bf 00 00 00 00       	mov    $0x0,%edi
  801148:	89 f9                	mov    %edi,%ecx
  80114a:	89 fb                	mov    %edi,%ebx
  80114c:	89 fe                	mov    %edi,%esi
  80114e:	cd 30                	int    $0x30
  801150:	85 c0                	test   %eax,%eax
  801152:	7e 17                	jle    80116b <sys_map_receive_buffers+0x39>
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	50                   	push   %eax
  801158:	6a 0e                	push   $0xe
  80115a:	68 b0 30 80 00       	push   $0x8030b0
  80115f:	6a 23                	push   $0x23
  801161:	68 cd 30 80 00       	push   $0x8030cd
  801166:	e8 6d f2 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  80116b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80116e:	5b                   	pop    %ebx
  80116f:	5e                   	pop    %esi
  801170:	5f                   	pop    %edi
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	b8 12 00 00 00       	mov    $0x12,%eax
  801184:	bf 00 00 00 00       	mov    $0x0,%edi
  801189:	89 f9                	mov    %edi,%ecx
  80118b:	89 fb                	mov    %edi,%ebx
  80118d:	89 fe                	mov    %edi,%esi
  80118f:	cd 30                	int    $0x30
  801191:	85 c0                	test   %eax,%eax
  801193:	7e 17                	jle    8011ac <sys_receive_packet_zerocopy+0x39>
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	50                   	push   %eax
  801199:	6a 12                	push   $0x12
  80119b:	68 b0 30 80 00       	push   $0x8030b0
  8011a0:	6a 23                	push   $0x23
  8011a2:	68 cd 30 80 00       	push   $0x8030cd
  8011a7:	e8 2c f2 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  8011ac:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8011af:	5b                   	pop    %ebx
  8011b0:	5e                   	pop    %esi
  8011b1:	5f                   	pop    %edi
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	57                   	push   %edi
  8011b8:	56                   	push   %esi
  8011b9:	53                   	push   %ebx
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c3:	b8 13 00 00 00       	mov    $0x13,%eax
  8011c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8011cd:	89 fb                	mov    %edi,%ebx
  8011cf:	89 fe                	mov    %edi,%esi
  8011d1:	cd 30                	int    $0x30
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	7e 17                	jle    8011ee <sys_env_set_priority+0x3a>
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	50                   	push   %eax
  8011db:	6a 13                	push   $0x13
  8011dd:	68 b0 30 80 00       	push   $0x8030b0
  8011e2:	6a 23                	push   $0x23
  8011e4:	68 cd 30 80 00       	push   $0x8030cd
  8011e9:	e8 ea f1 ff ff       	call   8003d8 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8011ee:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8011f1:	5b                   	pop    %ebx
  8011f2:	5e                   	pop    %esi
  8011f3:	5f                   	pop    %edi
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    
	...

008011f8 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8011fe:	ff 75 08             	pushl  0x8(%ebp)
  801201:	e8 0a 00 00 00       	call   801210 <fd2num>
  801206:	c1 e0 16             	shl    $0x16,%eax
  801209:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	05 00 00 40 30       	add    $0x30400000,%eax
  80121b:	c1 e8 0c             	shr    $0xc,%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <fd_alloc>:

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
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801229:	b9 00 00 00 00       	mov    $0x0,%ecx
  80122e:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801233:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 e0 0c             	shl    $0xc,%eax
  80123d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e8 16             	shr    $0x16,%eax
  801248:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80124b:	a8 01                	test   $0x1,%al
  80124d:	74 0c                	je     80125b <fd_alloc+0x3b>
  80124f:	89 d0                	mov    %edx,%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
  801254:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801257:	a8 01                	test   $0x1,%al
  801259:	75 09                	jne    801264 <fd_alloc+0x44>
			*fd_store = fd;
  80125b:	89 17                	mov    %edx,(%edi)
			return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
  801262:	eb 11                	jmp    801275 <fd_alloc+0x55>
  801264:	41                   	inc    %ecx
  801265:	83 f9 1f             	cmp    $0x1f,%ecx
  801268:	7e ce                	jle    801238 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80126a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801270:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5f                   	pop    %edi
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801280:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801285:	83 f8 1f             	cmp    $0x1f,%eax
  801288:	77 3a                	ja     8012c4 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80128a:	c1 e0 0c             	shl    $0xc,%eax
  80128d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801293:	89 d0                	mov    %edx,%eax
  801295:	c1 e8 16             	shr    $0x16,%eax
  801298:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80129f:	a8 01                	test   $0x1,%al
  8012a1:	74 10                	je     8012b3 <fd_lookup+0x39>
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	c1 e8 0c             	shr    $0xc,%eax
  8012a8:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8012af:	a8 01                	test   $0x1,%al
  8012b1:	75 07                	jne    8012ba <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8012b3:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8012b8:	eb 0a                	jmp    8012c4 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	89 10                	mov    %edx,(%eax)
	return 0;
  8012bf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012c4:	89 d0                	mov    %edx,%eax
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <fd_close>:

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
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	56                   	push   %esi
  8012cc:	53                   	push   %ebx
  8012cd:	83 ec 10             	sub    $0x10,%esp
  8012d0:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d3:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8012d6:	50                   	push   %eax
  8012d7:	56                   	push   %esi
  8012d8:	e8 33 ff ff ff       	call   801210 <fd2num>
  8012dd:	89 04 24             	mov    %eax,(%esp)
  8012e0:	e8 95 ff ff ff       	call   80127a <fd_lookup>
  8012e5:	89 c3                	mov    %eax,%ebx
  8012e7:	83 c4 08             	add    $0x8,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	78 05                	js     8012f3 <fd_close+0x2b>
  8012ee:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8012f1:	74 0f                	je     801302 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8012f3:	89 d8                	mov    %ebx,%eax
  8012f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f9:	75 3a                	jne    801335 <fd_close+0x6d>
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801300:	eb 33                	jmp    801335 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801308:	50                   	push   %eax
  801309:	ff 36                	pushl  (%esi)
  80130b:	e8 2c 00 00 00       	call   80133c <dev_lookup>
  801310:	89 c3                	mov    %eax,%ebx
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	78 0f                	js     801328 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	56                   	push   %esi
  80131d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801320:	ff 50 10             	call   *0x10(%eax)
  801323:	89 c3                	mov    %eax,%ebx
  801325:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	56                   	push   %esi
  80132c:	6a 00                	push   $0x0
  80132e:	e8 f0 fb ff ff       	call   800f23 <sys_page_unmap>
	return r;
  801333:	89 d8                	mov    %ebx,%eax
}
  801335:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <dev_lookup>:


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
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	56                   	push   %esi
  801340:	53                   	push   %ebx
  801341:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801344:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  801347:	ba 00 00 00 00       	mov    $0x0,%edx
  80134c:	83 3d a4 87 80 00 00 	cmpl   $0x0,0x8087a4
  801353:	74 1c                	je     801371 <dev_lookup+0x35>
  801355:	b9 a4 87 80 00       	mov    $0x8087a4,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80135a:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  80135d:	39 18                	cmp    %ebx,(%eax)
  80135f:	75 09                	jne    80136a <dev_lookup+0x2e>
			*dev = devtab[i];
  801361:	89 06                	mov    %eax,(%esi)
			return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	eb 29                	jmp    801393 <dev_lookup+0x57>
  80136a:	42                   	inc    %edx
  80136b:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80136f:	75 e9                	jne    80135a <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801371:	83 ec 04             	sub    $0x4,%esp
  801374:	53                   	push   %ebx
  801375:	a1 70 9f 80 00       	mov    0x809f70,%eax
  80137a:	8b 40 4c             	mov    0x4c(%eax),%eax
  80137d:	50                   	push   %eax
  80137e:	68 dc 30 80 00       	push   $0x8030dc
  801383:	e8 40 f1 ff ff       	call   8004c8 <cprintf>
	*dev = 0;
  801388:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801393:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <close>:

int
close(int fdnum)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a0:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8013a3:	50                   	push   %eax
  8013a4:	ff 75 08             	pushl  0x8(%ebp)
  8013a7:	e8 ce fe ff ff       	call   80127a <fd_lookup>
  8013ac:	83 c4 08             	add    $0x8,%esp
		return r;
  8013af:	89 c2                	mov    %eax,%edx
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 0f                	js     8013c4 <close+0x2a>
	else
		return fd_close(fd, 1);
  8013b5:	83 ec 08             	sub    $0x8,%esp
  8013b8:	6a 01                	push   $0x1
  8013ba:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8013bd:	e8 06 ff ff ff       	call   8012c8 <fd_close>
  8013c2:	89 c2                	mov    %eax,%edx
}
  8013c4:	89 d0                	mov    %edx,%eax
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <close_all>:

void
close_all(void)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	53                   	push   %ebx
  8013cc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013d4:	83 ec 0c             	sub    $0xc,%esp
  8013d7:	53                   	push   %ebx
  8013d8:	e8 bd ff ff ff       	call   80139a <close>
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	43                   	inc    %ebx
  8013e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013e4:	7e ee                	jle    8013d4 <close_all+0xc>
}
  8013e6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	57                   	push   %edi
  8013ef:	56                   	push   %esi
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013f4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	e8 7a fe ff ff       	call   80127a <fd_lookup>
  801400:	89 c6                	mov    %eax,%esi
  801402:	83 c4 08             	add    $0x8,%esp
  801405:	85 f6                	test   %esi,%esi
  801407:	0f 88 f8 00 00 00    	js     801505 <dup+0x11a>
		return r;
	close(newfdnum);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	ff 75 0c             	pushl  0xc(%ebp)
  801413:	e8 82 ff ff ff       	call   80139a <close>

	newfd = INDEX2FD(newfdnum);
  801418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141b:	c1 e0 0c             	shl    $0xc,%eax
  80141e:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801423:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  801426:	83 c4 04             	add    $0x4,%esp
  801429:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80142c:	e8 c7 fd ff ff       	call   8011f8 <fd2data>
  801431:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801433:	83 c4 04             	add    $0x4,%esp
  801436:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801439:	e8 ba fd ff ff       	call   8011f8 <fd2data>
  80143e:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801441:	89 f8                	mov    %edi,%eax
  801443:	c1 e8 16             	shr    $0x16,%eax
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801450:	85 c0                	test   %eax,%eax
  801452:	74 48                	je     80149c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801454:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801459:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  80145c:	89 d0                	mov    %edx,%eax
  80145e:	c1 e8 0c             	shr    $0xc,%eax
  801461:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801468:	a8 01                	test   $0x1,%al
  80146a:	74 22                	je     80148e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	25 07 0e 00 00       	and    $0xe07,%eax
  801474:	50                   	push   %eax
  801475:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801478:	01 d8                	add    %ebx,%eax
  80147a:	50                   	push   %eax
  80147b:	6a 00                	push   $0x0
  80147d:	52                   	push   %edx
  80147e:	6a 00                	push   $0x0
  801480:	e8 5c fa ff ff       	call   800ee1 <sys_page_map>
  801485:	89 c6                	mov    %eax,%esi
  801487:	83 c4 20             	add    $0x20,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 3f                	js     8014cd <dup+0xe2>
  80148e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801494:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80149a:	7e bd                	jle    801459 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8014a2:	89 d0                	mov    %edx,%eax
  8014a4:	c1 e8 0c             	shr    $0xc,%eax
  8014a7:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8014ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8014b3:	50                   	push   %eax
  8014b4:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8014b7:	6a 00                	push   $0x0
  8014b9:	52                   	push   %edx
  8014ba:	6a 00                	push   $0x0
  8014bc:	e8 20 fa ff ff       	call   800ee1 <sys_page_map>
  8014c1:	89 c6                	mov    %eax,%esi
  8014c3:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8014c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c9:	85 f6                	test   %esi,%esi
  8014cb:	79 38                	jns    801505 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  8014cd:	83 ec 08             	sub    $0x8,%esp
  8014d0:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8014d3:	6a 00                	push   $0x0
  8014d5:	e8 49 fa ff ff       	call   800f23 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8014da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014df:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8014e8:	01 d8                	add    %ebx,%eax
  8014ea:	50                   	push   %eax
  8014eb:	6a 00                	push   $0x0
  8014ed:	e8 31 fa ff ff       	call   800f23 <sys_page_unmap>
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014fb:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801501:	7e df                	jle    8014e2 <dup+0xf7>
	return r;
  801503:	89 f0                	mov    %esi,%eax
}
  801505:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801508:	5b                   	pop    %ebx
  801509:	5e                   	pop    %esi
  80150a:	5f                   	pop    %edi
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	53                   	push   %ebx
  801511:	83 ec 14             	sub    $0x14,%esp
  801514:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801517:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80151a:	50                   	push   %eax
  80151b:	53                   	push   %ebx
  80151c:	e8 59 fd ff ff       	call   80127a <fd_lookup>
  801521:	89 c2                	mov    %eax,%edx
  801523:	83 c4 08             	add    $0x8,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 1a                	js     801544 <read+0x37>
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801534:	ff 30                	pushl  (%eax)
  801536:	e8 01 fe ff ff       	call   80133c <dev_lookup>
  80153b:	89 c2                	mov    %eax,%edx
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	79 04                	jns    801548 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801544:	89 d0                	mov    %edx,%eax
  801546:	eb 50                	jmp    801598 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801548:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80154b:	8b 40 08             	mov    0x8(%eax),%eax
  80154e:	83 e0 03             	and    $0x3,%eax
  801551:	83 f8 01             	cmp    $0x1,%eax
  801554:	75 1e                	jne    801574 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801556:	83 ec 04             	sub    $0x4,%esp
  801559:	53                   	push   %ebx
  80155a:	a1 70 9f 80 00       	mov    0x809f70,%eax
  80155f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801562:	50                   	push   %eax
  801563:	68 1d 31 80 00       	push   $0x80311d
  801568:	e8 5b ef ff ff       	call   8004c8 <cprintf>
		return -E_INVAL;
  80156d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801572:	eb 24                	jmp    801598 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801574:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801577:	ff 70 04             	pushl  0x4(%eax)
  80157a:	ff 75 10             	pushl  0x10(%ebp)
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	50                   	push   %eax
  801581:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801584:	ff 50 08             	call   *0x8(%eax)
  801587:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 06                	js     801596 <read+0x89>
		fd->fd_offset += r;
  801590:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801593:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801596:	89 d0                	mov    %edx,%eax
}
  801598:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	57                   	push   %edi
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 0c             	sub    $0xc,%esp
  8015a6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8015a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b1:	39 f3                	cmp    %esi,%ebx
  8015b3:	73 25                	jae    8015da <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	89 f0                	mov    %esi,%eax
  8015ba:	29 d8                	sub    %ebx,%eax
  8015bc:	50                   	push   %eax
  8015bd:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8015c0:	50                   	push   %eax
  8015c1:	ff 75 08             	pushl  0x8(%ebp)
  8015c4:	e8 44 ff ff ff       	call   80150d <read>
		if (m < 0)
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 0c                	js     8015dc <readn+0x3f>
			return m;
		if (m == 0)
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	74 06                	je     8015da <readn+0x3d>
  8015d4:	01 c3                	add    %eax,%ebx
  8015d6:	39 f3                	cmp    %esi,%ebx
  8015d8:	72 db                	jb     8015b5 <readn+0x18>
			break;
	}
	return tot;
  8015da:	89 d8                	mov    %ebx,%eax
}
  8015dc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8015df:	5b                   	pop    %ebx
  8015e0:	5e                   	pop    %esi
  8015e1:	5f                   	pop    %edi
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	53                   	push   %ebx
  8015e8:	83 ec 14             	sub    $0x14,%esp
  8015eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ee:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8015f1:	50                   	push   %eax
  8015f2:	53                   	push   %ebx
  8015f3:	e8 82 fc ff ff       	call   80127a <fd_lookup>
  8015f8:	89 c2                	mov    %eax,%edx
  8015fa:	83 c4 08             	add    $0x8,%esp
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	78 1a                	js     80161b <write+0x37>
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801607:	50                   	push   %eax
  801608:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80160b:	ff 30                	pushl  (%eax)
  80160d:	e8 2a fd ff ff       	call   80133c <dev_lookup>
  801612:	89 c2                	mov    %eax,%edx
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	85 c0                	test   %eax,%eax
  801619:	79 04                	jns    80161f <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  80161b:	89 d0                	mov    %edx,%eax
  80161d:	eb 4b                	jmp    80166a <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80161f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801622:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801626:	75 1e                	jne    801646 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	53                   	push   %ebx
  80162c:	a1 70 9f 80 00       	mov    0x809f70,%eax
  801631:	8b 40 4c             	mov    0x4c(%eax),%eax
  801634:	50                   	push   %eax
  801635:	68 39 31 80 00       	push   $0x803139
  80163a:	e8 89 ee ff ff       	call   8004c8 <cprintf>
		return -E_INVAL;
  80163f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801644:	eb 24                	jmp    80166a <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801646:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801649:	ff 70 04             	pushl  0x4(%eax)
  80164c:	ff 75 10             	pushl  0x10(%ebp)
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	50                   	push   %eax
  801653:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801656:	ff 50 0c             	call   *0xc(%eax)
  801659:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	85 c0                	test   %eax,%eax
  801660:	7e 06                	jle    801668 <write+0x84>
		fd->fd_offset += r;
  801662:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801665:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801668:	89 d0                	mov    %edx,%eax
}
  80166a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <seek>:

int
seek(int fdnum, off_t offset)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801675:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	e8 f9 fb ff ff       	call   80127a <fd_lookup>
  801681:	83 c4 08             	add    $0x8,%esp
		return r;
  801684:	89 c2                	mov    %eax,%edx
  801686:	85 c0                	test   %eax,%eax
  801688:	78 0e                	js     801698 <seek+0x29>
	fd->fd_offset = offset;
  80168a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801690:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801693:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801698:	89 d0                	mov    %edx,%eax
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	53                   	push   %ebx
  8016a0:	83 ec 14             	sub    $0x14,%esp
  8016a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a6:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8016a9:	50                   	push   %eax
  8016aa:	53                   	push   %ebx
  8016ab:	e8 ca fb ff ff       	call   80127a <fd_lookup>
  8016b0:	83 c4 08             	add    $0x8,%esp
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	78 4e                	js     801705 <ftruncate+0x69>
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016bd:	50                   	push   %eax
  8016be:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016c1:	ff 30                	pushl  (%eax)
  8016c3:	e8 74 fc ff ff       	call   80133c <dev_lookup>
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 36                	js     801705 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016cf:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016d2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016d6:	75 1e                	jne    8016f6 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	53                   	push   %ebx
  8016dc:	a1 70 9f 80 00       	mov    0x809f70,%eax
  8016e1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 fc 30 80 00       	push   $0x8030fc
  8016ea:	e8 d9 ed ff ff       	call   8004c8 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8016ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f4:	eb 0f                	jmp    801705 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8016ff:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801702:	ff 50 1c             	call   *0x1c(%eax)
}
  801705:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	53                   	push   %ebx
  80170e:	83 ec 14             	sub    $0x14,%esp
  801711:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801714:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801717:	50                   	push   %eax
  801718:	ff 75 08             	pushl  0x8(%ebp)
  80171b:	e8 5a fb ff ff       	call   80127a <fd_lookup>
  801720:	83 c4 08             	add    $0x8,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	78 42                	js     801769 <fstat+0x5f>
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80172d:	50                   	push   %eax
  80172e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801731:	ff 30                	pushl  (%eax)
  801733:	e8 04 fc ff ff       	call   80133c <dev_lookup>
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 2a                	js     801769 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  80173f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801742:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801749:	00 00 00 
	stat->st_isdir = 0;
  80174c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801753:	00 00 00 
	stat->st_dev = dev;
  801756:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801759:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80175f:	83 ec 08             	sub    $0x8,%esp
  801762:	53                   	push   %ebx
  801763:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801766:	ff 50 14             	call   *0x14(%eax)
}
  801769:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801773:	83 ec 08             	sub    $0x8,%esp
  801776:	6a 00                	push   $0x0
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	e8 28 00 00 00       	call   8017a8 <open>
  801780:	89 c6                	mov    %eax,%esi
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 f6                	test   %esi,%esi
  801787:	78 18                	js     8017a1 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	56                   	push   %esi
  801790:	e8 75 ff ff ff       	call   80170a <fstat>
  801795:	89 c3                	mov    %eax,%ebx
	close(fd);
  801797:	89 34 24             	mov    %esi,(%esp)
  80179a:	e8 fb fb ff ff       	call   80139a <close>
	return r;
  80179f:	89 d8                	mov    %ebx,%eax
}
  8017a1:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5e                   	pop    %esi
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	53                   	push   %ebx
  8017ac:	83 ec 10             	sub    $0x10,%esp
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
  8017af:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8017b2:	50                   	push   %eax
  8017b3:	e8 68 fa ff ff       	call   801220 <fd_alloc>
  8017b8:	89 c3                	mov    %eax,%ebx
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	85 db                	test   %ebx,%ebx
  8017bf:	78 36                	js     8017f7 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	e8 1b 05 00 00       	call   801ced <fsipc_open>
  8017d2:	89 c3                	mov    %eax,%ebx
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	79 11                	jns    8017ec <open+0x44>
          fd_close(fd_store, 0);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	6a 00                	push   $0x0
  8017e0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8017e3:	e8 e0 fa ff ff       	call   8012c8 <fd_close>
          return r;
  8017e8:	89 d8                	mov    %ebx,%eax
  8017ea:	eb 0b                	jmp    8017f7 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  8017ec:	83 ec 0c             	sub    $0xc,%esp
  8017ef:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8017f2:	e8 19 fa ff ff       	call   801210 <fd2num>
}
  8017f7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	53                   	push   %ebx
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801806:	6a 01                	push   $0x1
  801808:	6a 00                	push   $0x0
  80180a:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801810:	53                   	push   %ebx
  801811:	e8 e7 03 00 00       	call   801bfd <funmap>
  801816:	83 c4 10             	add    $0x10,%esp
          return r;
  801819:	89 c2                	mov    %eax,%edx
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 19                	js     801838 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	ff 73 0c             	pushl  0xc(%ebx)
  801825:	e8 68 05 00 00       	call   801d92 <fsipc_close>
  80182a:	83 c4 10             	add    $0x10,%esp
          return r;
  80182d:	89 c2                	mov    %eax,%edx
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 05                	js     801838 <file_close+0x3c>
        }
        return 0;
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801838:	89 d0                	mov    %edx,%eax
  80183a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	57                   	push   %edi
  801843:	56                   	push   %esi
  801844:	53                   	push   %ebx
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	8b 75 10             	mov    0x10(%ebp),%esi
  80184b:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801857:	b9 00 00 00 00       	mov    $0x0,%ecx
  80185c:	39 d7                	cmp    %edx,%edi
  80185e:	0f 87 95 00 00 00    	ja     8018f9 <file_read+0xba>
	if (offset + n > size)
  801864:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801867:	39 d0                	cmp    %edx,%eax
  801869:	76 04                	jbe    80186f <file_read+0x30>
		n = size - offset;
  80186b:	89 d6                	mov    %edx,%esi
  80186d:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	e8 7e f9 ff ff       	call   8011f8 <fd2data>
  80187a:	89 c3                	mov    %eax,%ebx
  80187c:	01 fb                	add    %edi,%ebx
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	eb 41                	jmp    8018c4 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801883:	89 d8                	mov    %ebx,%eax
  801885:	c1 e8 16             	shr    $0x16,%eax
  801888:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80188f:	a8 01                	test   $0x1,%al
  801891:	74 10                	je     8018a3 <file_read+0x64>
  801893:	89 d8                	mov    %ebx,%eax
  801895:	c1 e8 0c             	shr    $0xc,%eax
  801898:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80189f:	a8 01                	test   $0x1,%al
  8018a1:	75 1b                	jne    8018be <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8018a3:	83 ec 04             	sub    $0x4,%esp
  8018a6:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8018a9:	50                   	push   %eax
  8018aa:	57                   	push   %edi
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	e8 d4 02 00 00       	call   801b87 <fmap>
  8018b3:	83 c4 10             	add    $0x10,%esp
              return r;
  8018b6:	89 c1                	mov    %eax,%ecx
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 3d                	js     8018f9 <file_read+0xba>
  8018bc:	eb 1c                	jmp    8018da <file_read+0x9b>
  8018be:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018c4:	83 ec 0c             	sub    $0xc,%esp
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	e8 29 f9 ff ff       	call   8011f8 <fd2data>
  8018cf:	01 f8                	add    %edi,%eax
  8018d1:	01 f0                	add    %esi,%eax
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	39 d8                	cmp    %ebx,%eax
  8018d8:	77 a9                	ja     801883 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	56                   	push   %esi
  8018de:	83 ec 04             	sub    $0x4,%esp
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	e8 0f f9 ff ff       	call   8011f8 <fd2data>
  8018e9:	83 c4 08             	add    $0x8,%esp
  8018ec:	01 f8                	add    %edi,%eax
  8018ee:	50                   	push   %eax
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	e8 51 f3 ff ff       	call   800c48 <memmove>
	return n;
  8018f7:	89 f1                	mov    %esi,%ecx
}
  8018f9:	89 c8                	mov    %ecx,%eax
  8018fb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5f                   	pop    %edi
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
  801908:	83 ec 18             	sub    $0x18,%esp
  80190b:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80190e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801911:	50                   	push   %eax
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	e8 60 f9 ff ff       	call   80127a <fd_lookup>
  80191a:	83 c4 10             	add    $0x10,%esp
		return r;
  80191d:	89 c2                	mov    %eax,%edx
  80191f:	85 c0                	test   %eax,%eax
  801921:	0f 88 9f 00 00 00    	js     8019c6 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801927:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80192a:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  80192c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801931:	3b 05 c0 87 80 00    	cmp    0x8087c0,%eax
  801937:	0f 85 89 00 00 00    	jne    8019c6 <read_map+0xc3>
	va = fd2data(fd) + offset;
  80193d:	83 ec 0c             	sub    $0xc,%esp
  801940:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801943:	e8 b0 f8 ff ff       	call   8011f8 <fd2data>
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  80194c:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  80194f:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801954:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  80195a:	7f 6a                	jg     8019c6 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  80195c:	89 d8                	mov    %ebx,%eax
  80195e:	c1 e8 16             	shr    $0x16,%eax
  801961:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801968:	a8 01                	test   $0x1,%al
  80196a:	74 10                	je     80197c <read_map+0x79>
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	c1 e8 0c             	shr    $0xc,%eax
  801971:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801978:	a8 01                	test   $0x1,%al
  80197a:	75 19                	jne    801995 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	8d 46 01             	lea    0x1(%esi),%eax
  801982:	50                   	push   %eax
  801983:	56                   	push   %esi
  801984:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801987:	e8 fb 01 00 00       	call   801b87 <fmap>
  80198c:	83 c4 10             	add    $0x10,%esp
            return r;
  80198f:	89 c2                	mov    %eax,%edx
  801991:	85 c0                	test   %eax,%eax
  801993:	78 31                	js     8019c6 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801995:	89 d8                	mov    %ebx,%eax
  801997:	c1 e8 16             	shr    $0x16,%eax
  80199a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8019a1:	a8 01                	test   $0x1,%al
  8019a3:	74 10                	je     8019b5 <read_map+0xb2>
  8019a5:	89 d8                	mov    %ebx,%eax
  8019a7:	c1 e8 0c             	shr    $0xc,%eax
  8019aa:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8019b1:	a8 01                	test   $0x1,%al
  8019b3:	75 07                	jne    8019bc <read_map+0xb9>
		return -E_NO_DISK;
  8019b5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8019ba:	eb 0a                	jmp    8019c6 <read_map+0xc3>

	*blk = (void*) va;
  8019bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bf:	89 18                	mov    %ebx,(%eax)
	return 0;
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019c6:	89 d0                	mov    %edx,%eax
  8019c8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	57                   	push   %edi
  8019d3:	56                   	push   %esi
  8019d4:	53                   	push   %ebx
  8019d5:	83 ec 0c             	sub    $0xc,%esp
  8019d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8019db:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  8019de:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e1:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  8019e4:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  8019e9:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8019ef:	0f 87 bd 00 00 00    	ja     801ab2 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8019f5:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8019fb:	73 17                	jae    801a14 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8019fd:	83 ec 08             	sub    $0x8,%esp
  801a00:	52                   	push   %edx
  801a01:	56                   	push   %esi
  801a02:	e8 fb 00 00 00       	call   801b02 <file_trunc>
  801a07:	83 c4 10             	add    $0x10,%esp
			return r;
  801a0a:	89 c1                	mov    %eax,%ecx
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	0f 88 9e 00 00 00    	js     801ab2 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801a14:	83 ec 0c             	sub    $0xc,%esp
  801a17:	56                   	push   %esi
  801a18:	e8 db f7 ff ff       	call   8011f8 <fd2data>
  801a1d:	89 c3                	mov    %eax,%ebx
  801a1f:	01 fb                	add    %edi,%ebx
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	eb 42                	jmp    801a68 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801a26:	89 d8                	mov    %ebx,%eax
  801a28:	c1 e8 16             	shr    $0x16,%eax
  801a2b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801a32:	a8 01                	test   $0x1,%al
  801a34:	74 10                	je     801a46 <file_write+0x77>
  801a36:	89 d8                	mov    %ebx,%eax
  801a38:	c1 e8 0c             	shr    $0xc,%eax
  801a3b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a42:	a8 01                	test   $0x1,%al
  801a44:	75 1c                	jne    801a62 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	8b 55 10             	mov    0x10(%ebp),%edx
  801a4c:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801a4f:	50                   	push   %eax
  801a50:	57                   	push   %edi
  801a51:	56                   	push   %esi
  801a52:	e8 30 01 00 00       	call   801b87 <fmap>
  801a57:	83 c4 10             	add    $0x10,%esp
              return r;
  801a5a:	89 c1                	mov    %eax,%ecx
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 52                	js     801ab2 <file_write+0xe3>
  801a60:	eb 1b                	jmp    801a7d <file_write+0xae>
  801a62:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a68:	83 ec 0c             	sub    $0xc,%esp
  801a6b:	56                   	push   %esi
  801a6c:	e8 87 f7 ff ff       	call   8011f8 <fd2data>
  801a71:	01 f8                	add    %edi,%eax
  801a73:	03 45 10             	add    0x10(%ebp),%eax
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	39 d8                	cmp    %ebx,%eax
  801a7b:	77 a9                	ja     801a26 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801a7d:	83 ec 0c             	sub    $0xc,%esp
  801a80:	68 56 31 80 00       	push   $0x803156
  801a85:	e8 3e ea ff ff       	call   8004c8 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801a8a:	83 c4 0c             	add    $0xc,%esp
  801a8d:	ff 75 10             	pushl  0x10(%ebp)
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	56                   	push   %esi
  801a94:	e8 5f f7 ff ff       	call   8011f8 <fd2data>
  801a99:	01 f8                	add    %edi,%eax
  801a9b:	89 04 24             	mov    %eax,(%esp)
  801a9e:	e8 a5 f1 ff ff       	call   800c48 <memmove>
        cprintf("write done\n");
  801aa3:	c7 04 24 63 31 80 00 	movl   $0x803163,(%esp)
  801aaa:	e8 19 ea ff ff       	call   8004c8 <cprintf>
	return n;
  801aaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801ab2:	89 c8                	mov    %ecx,%eax
  801ab4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	56                   	push   %esi
  801ac0:	53                   	push   %ebx
  801ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ac4:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	8d 43 10             	lea    0x10(%ebx),%eax
  801acd:	50                   	push   %eax
  801ace:	56                   	push   %esi
  801acf:	e8 f8 ef ff ff       	call   800acc <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801ad4:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801ada:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801aea:	0f 94 c0             	sete   %al
  801aed:	0f b6 c0             	movzbl %al,%eax
  801af0:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801af6:	b8 00 00 00 00       	mov    $0x0,%eax
  801afb:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	57                   	push   %edi
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 0c             	sub    $0xc,%esp
  801b0b:	8b 75 08             	mov    0x8(%ebp),%esi
  801b0e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801b11:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801b16:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801b1c:	7f 5f                	jg     801b7d <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801b1e:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801b24:	83 ec 08             	sub    $0x8,%esp
  801b27:	53                   	push   %ebx
  801b28:	ff 76 0c             	pushl  0xc(%esi)
  801b2b:	e8 3a 02 00 00       	call   801d6a <fsipc_set_size>
  801b30:	83 c4 10             	add    $0x10,%esp
		return r;
  801b33:	89 c2                	mov    %eax,%edx
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 44                	js     801b7d <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801b39:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801b3f:	74 19                	je     801b5a <file_trunc+0x58>
  801b41:	68 90 31 80 00       	push   $0x803190
  801b46:	68 6f 31 80 00       	push   $0x80316f
  801b4b:	68 dc 00 00 00       	push   $0xdc
  801b50:	68 84 31 80 00       	push   $0x803184
  801b55:	e8 7e e8 ff ff       	call   8003d8 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	53                   	push   %ebx
  801b5e:	57                   	push   %edi
  801b5f:	56                   	push   %esi
  801b60:	e8 22 00 00 00       	call   801b87 <fmap>
  801b65:	83 c4 10             	add    $0x10,%esp
		return r;
  801b68:	89 c2                	mov    %eax,%edx
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 0f                	js     801b7d <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	53                   	push   %ebx
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	e8 85 00 00 00       	call   801bfd <funmap>

	return 0;
  801b78:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b7d:	89 d0                	mov    %edx,%eax
  801b7f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5f                   	pop    %edi
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <fmap>:

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
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	57                   	push   %edi
  801b8b:	56                   	push   %esi
  801b8c:	53                   	push   %ebx
  801b8d:	83 ec 0c             	sub    $0xc,%esp
  801b90:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b93:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801b96:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801b99:	7d 55                	jge    801bf0 <fmap+0x69>
          fma = fd2data(fd);
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	57                   	push   %edi
  801b9f:	e8 54 f6 ff ff       	call   8011f8 <fd2data>
  801ba4:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bad:	05 ff 0f 00 00       	add    $0xfff,%eax
  801bb2:	89 c3                	mov    %eax,%ebx
  801bb4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801bba:	39 f3                	cmp    %esi,%ebx
  801bbc:	7d 32                	jge    801bf0 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801bc4:	01 d8                	add    %ebx,%eax
  801bc6:	50                   	push   %eax
  801bc7:	53                   	push   %ebx
  801bc8:	ff 77 0c             	pushl  0xc(%edi)
  801bcb:	e8 6f 01 00 00       	call   801d3f <fsipc_map>
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	79 0f                	jns    801be6 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	ff 75 0c             	pushl  0xc(%ebp)
  801bdc:	53                   	push   %ebx
  801bdd:	57                   	push   %edi
  801bde:	e8 1a 00 00 00       	call   801bfd <funmap>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bec:	39 f3                	cmp    %esi,%ebx
  801bee:	7c ce                	jl     801bbe <fmap+0x37>
            }
          }
        }

        return 0;
}
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5f                   	pop    %edi
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <funmap>:

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
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	57                   	push   %edi
  801c01:	56                   	push   %esi
  801c02:	53                   	push   %ebx
  801c03:	83 ec 0c             	sub    $0xc,%esp
  801c06:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801c0c:	39 f3                	cmp    %esi,%ebx
  801c0e:	0f 8d 80 00 00 00    	jge    801c94 <funmap+0x97>
          fma = fd2data(fd);
  801c14:	83 ec 0c             	sub    $0xc,%esp
  801c17:	ff 75 08             	pushl  0x8(%ebp)
  801c1a:	e8 d9 f5 ff ff       	call   8011f8 <fd2data>
  801c1f:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801c2a:	89 c3                	mov    %eax,%ebx
  801c2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801c32:	39 f3                	cmp    %esi,%ebx
  801c34:	7d 5e                	jge    801c94 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801c36:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801c39:	89 c2                	mov    %eax,%edx
  801c3b:	c1 ea 0c             	shr    $0xc,%edx
  801c3e:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801c45:	a8 01                	test   $0x1,%al
  801c47:	74 41                	je     801c8a <funmap+0x8d>
              if (dirty) {
  801c49:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801c4d:	74 21                	je     801c70 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801c4f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801c56:	a8 40                	test   $0x40,%al
  801c58:	74 16                	je     801c70 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801c5a:	83 ec 08             	sub    $0x8,%esp
  801c5d:	53                   	push   %ebx
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	ff 70 0c             	pushl  0xc(%eax)
  801c64:	e8 49 01 00 00       	call   801db2 <fsipc_dirty>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 29                	js     801c99 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801c70:	83 ec 08             	sub    $0x8,%esp
  801c73:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801c76:	50                   	push   %eax
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	e8 e1 f1 ff ff       	call   800e60 <sys_getenvid>
  801c7f:	89 04 24             	mov    %eax,(%esp)
  801c82:	e8 9c f2 ff ff       	call   800f23 <sys_page_unmap>
  801c87:	83 c4 10             	add    $0x10,%esp
  801c8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c90:	39 f3                	cmp    %esi,%ebx
  801c92:	7c a2                	jl     801c36 <funmap+0x39>
            }
          }
        }

        return 0;
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c99:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <remove>:

// Delete a file
int
remove(const char *path)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	e8 2b 01 00 00       	call   801dda <fsipc_remove>
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801cb7:	e8 64 01 00 00       	call   801e20 <fsipc_sync>
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    
	...

00801cc0 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801cc6:	6a 07                	push   $0x7
  801cc8:	ff 75 0c             	pushl  0xc(%ebp)
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801cd3:	50                   	push   %eax
  801cd4:	e8 3e 0b 00 00       	call   802817 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801cd9:	83 c4 0c             	add    $0xc,%esp
  801cdc:	ff 75 14             	pushl  0x14(%ebp)
  801cdf:	ff 75 10             	pushl  0x10(%ebp)
  801ce2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801ce5:	50                   	push   %eax
  801ce6:	e8 c9 0a 00 00       	call   8027b4 <ipc_recv>
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	56                   	push   %esi
  801cf1:	53                   	push   %ebx
  801cf2:	83 ec 1c             	sub    $0x1c,%esp
  801cf5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801cf8:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801cfd:	56                   	push   %esi
  801cfe:	e8 8d ed ff ff       	call   800a90 <strlen>
  801d03:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801d06:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801d0b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d10:	7f 24                	jg     801d36 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801d12:	83 ec 08             	sub    $0x8,%esp
  801d15:	56                   	push   %esi
  801d16:	53                   	push   %ebx
  801d17:	e8 b0 ed ff ff       	call   800acc <strcpy>
	req->req_omode = omode;
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801d25:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801d28:	50                   	push   %eax
  801d29:	ff 75 10             	pushl  0x10(%ebp)
  801d2c:	53                   	push   %ebx
  801d2d:	6a 01                	push   $0x1
  801d2f:	e8 8c ff ff ff       	call   801cc0 <fsipc>
  801d34:	89 c2                	mov    %eax,%edx
}
  801d36:	89 d0                	mov    %edx,%eax
  801d38:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d50:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801d55:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801d58:	50                   	push   %eax
  801d59:	ff 75 10             	pushl  0x10(%ebp)
  801d5c:	68 00 40 80 00       	push   $0x804000
  801d61:	6a 02                	push   $0x2
  801d63:	e8 58 ff ff ff       	call   801cc0 <fsipc>

	//return -E_UNSPECIFIED;
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	68 00 40 80 00       	push   $0x804000
  801d89:	6a 03                	push   $0x3
  801d8b:	e8 30 ff ff ff       	call   801cc0 <fsipc>
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	68 00 40 80 00       	push   $0x804000
  801da9:	6a 04                	push   $0x4
  801dab:	e8 10 ff ff ff       	call   801cc0 <fsipc>
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc3:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	68 00 40 80 00       	push   $0x804000
  801dd1:	6a 05                	push   $0x5
  801dd3:	e8 e8 fe ff ff       	call   801cc0 <fsipc>
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	56                   	push   %esi
  801dde:	53                   	push   %ebx
  801ddf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801de2:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	53                   	push   %ebx
  801deb:	e8 a0 ec ff ff       	call   800a90 <strlen>
  801df0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801df3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801df8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dfd:	7f 18                	jg     801e17 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	53                   	push   %ebx
  801e03:	56                   	push   %esi
  801e04:	e8 c3 ec ff ff       	call   800acc <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	56                   	push   %esi
  801e0e:	6a 06                	push   $0x6
  801e10:	e8 ab fe ff ff       	call   801cc0 <fsipc>
  801e15:	89 c2                	mov    %eax,%edx
}
  801e17:	89 d0                	mov    %edx,%eax
  801e19:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	68 00 40 80 00       	push   $0x804000
  801e2f:	6a 07                	push   $0x7
  801e31:	e8 8a fe ff ff       	call   801cc0 <fsipc>
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <spawn>:
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	57                   	push   %edi
  801e3c:	56                   	push   %esi
  801e3d:	53                   	push   %ebx
  801e3e:	81 ec 74 02 00 00    	sub    $0x274,%esp
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
  801e44:	6a 00                	push   $0x0
  801e46:	ff 75 08             	pushl  0x8(%ebp)
  801e49:	e8 5a f9 ff ff       	call   8017a8 <open>
  801e4e:	89 c3                	mov    %eax,%ebx
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	85 db                	test   %ebx,%ebx
  801e55:	0f 88 ed 01 00 00    	js     802048 <spawn+0x210>
		return r;
	fd = r;
  801e5b:	89 9d 90 fd ff ff    	mov    %ebx,0xfffffd90(%ebp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 00 02 00 00       	push   $0x200
  801e69:	8d 85 e8 fd ff ff    	lea    0xfffffde8(%ebp),%eax
  801e6f:	50                   	push   %eax
  801e70:	53                   	push   %ebx
  801e71:	e8 97 f6 ff ff       	call   80150d <read>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e7e:	75 0c                	jne    801e8c <spawn+0x54>
  801e80:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,0xfffffde8(%ebp)
  801e87:	45 4c 46 
  801e8a:	74 30                	je     801ebc <spawn+0x84>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  801e95:	e8 00 f5 ff ff       	call   80139a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e9a:	83 c4 0c             	add    $0xc,%esp
  801e9d:	68 7f 45 4c 46       	push   $0x464c457f
  801ea2:	ff b5 e8 fd ff ff    	pushl  0xfffffde8(%ebp)
  801ea8:	68 b3 31 80 00       	push   $0x8031b3
  801ead:	e8 16 e6 ff ff       	call   8004c8 <cprintf>
		return -E_NOT_EXEC;
  801eb2:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801eb7:	e9 8c 01 00 00       	jmp    802048 <spawn+0x210>
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ebc:	ba 07 00 00 00       	mov    $0x7,%edx
  801ec1:	89 d0                	mov    %edx,%eax
  801ec3:	cd 30                	int    $0x30
  801ec5:	89 c3                	mov    %eax,%ebx
  801ec7:	85 db                	test   %ebx,%ebx
  801ec9:	0f 88 79 01 00 00    	js     802048 <spawn+0x210>
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
	child = r;
  801ecf:	89 9d 94 fd ff ff    	mov    %ebx,0xfffffd94(%ebp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801ed5:	89 d8                	mov    %ebx,%eax
  801ed7:	25 ff 03 00 00       	and    $0x3ff,%eax
  801edc:	c1 e0 07             	shl    $0x7,%eax
  801edf:	8d 95 98 fd ff ff    	lea    0xfffffd98(%ebp),%edx
  801ee5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801eea:	83 ec 04             	sub    $0x4,%esp
  801eed:	6a 44                	push   $0x44
  801eef:	50                   	push   %eax
  801ef0:	52                   	push   %edx
  801ef1:	e8 bd ed ff ff       	call   800cb3 <memcpy>
	child_tf.tf_eip = elf->e_entry;
  801ef6:	8b 85 00 fe ff ff    	mov    0xfffffe00(%ebp),%eax
  801efc:	89 85 c8 fd ff ff    	mov    %eax,0xfffffdc8(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  801f02:	83 c4 0c             	add    $0xc,%esp
  801f05:	8d 85 d4 fd ff ff    	lea    0xfffffdd4(%ebp),%eax
  801f0b:	50                   	push   %eax
  801f0c:	ff 75 0c             	pushl  0xc(%ebp)
  801f0f:	53                   	push   %ebx
  801f10:	e8 4f 01 00 00       	call   802064 <init_stack>
  801f15:	89 c3                	mov    %eax,%ebx
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	85 db                	test   %ebx,%ebx
  801f1c:	0f 88 26 01 00 00    	js     802048 <spawn+0x210>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801f22:	8b 85 04 fe ff ff    	mov    0xfffffe04(%ebp),%eax
  801f28:	8d b4 05 e8 fd ff ff 	lea    0xfffffde8(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f34:	66 83 bd 14 fe ff ff 	cmpw   $0x0,0xfffffe14(%ebp)
  801f3b:	00 
  801f3c:	74 4f                	je     801f8d <spawn+0x155>
		if (ph->p_type != ELF_PROG_LOAD)
  801f3e:	83 3e 01             	cmpl   $0x1,(%esi)
  801f41:	75 3b                	jne    801f7e <spawn+0x146>
			continue;
		perm = PTE_P | PTE_U;
  801f43:	b8 05 00 00 00       	mov    $0x5,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f48:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  801f4c:	74 02                	je     801f50 <spawn+0x118>
			perm |= PTE_W;
  801f4e:	b0 07                	mov    $0x7,%al
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	50                   	push   %eax
  801f54:	ff 76 04             	pushl  0x4(%esi)
  801f57:	ff 76 10             	pushl  0x10(%esi)
  801f5a:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  801f60:	ff 76 14             	pushl  0x14(%esi)
  801f63:	ff 76 08             	pushl  0x8(%esi)
  801f66:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801f6c:	e8 5f 02 00 00       	call   8021d0 <map_segment>
  801f71:	89 c3                	mov    %eax,%ebx
  801f73:	83 c4 20             	add    $0x20,%esp
  801f76:	85 c0                	test   %eax,%eax
  801f78:	0f 88 ac 00 00 00    	js     80202a <spawn+0x1f2>
  801f7e:	47                   	inc    %edi
  801f7f:	83 c6 20             	add    $0x20,%esi
  801f82:	0f b7 85 14 fe ff ff 	movzwl 0xfffffe14(%ebp),%eax
  801f89:	39 f8                	cmp    %edi,%eax
  801f8b:	7f b1                	jg     801f3e <spawn+0x106>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  801f96:	e8 ff f3 ff ff       	call   80139a <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  801f9b:	83 c4 04             	add    $0x4,%esp
  801f9e:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801fa4:	e8 9f 03 00 00       	call   802348 <copy_shared_pages>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	79 15                	jns    801fc5 <spawn+0x18d>
		panic("copy_shared_pages: %e", r);
  801fb0:	50                   	push   %eax
  801fb1:	68 cd 31 80 00       	push   $0x8031cd
  801fb6:	68 82 00 00 00       	push   $0x82
  801fbb:	68 e3 31 80 00       	push   $0x8031e3
  801fc0:	e8 13 e4 ff ff       	call   8003d8 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801fc5:	83 ec 08             	sub    $0x8,%esp
  801fc8:	8d 85 98 fd ff ff    	lea    0xfffffd98(%ebp),%eax
  801fce:	50                   	push   %eax
  801fcf:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801fd5:	e8 cd ef ff ff       	call   800fa7 <sys_env_set_trapframe>
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	79 15                	jns    801ff6 <spawn+0x1be>
		panic("sys_env_set_trapframe: %e", r);
  801fe1:	50                   	push   %eax
  801fe2:	68 ef 31 80 00       	push   $0x8031ef
  801fe7:	68 85 00 00 00       	push   $0x85
  801fec:	68 e3 31 80 00       	push   $0x8031e3
  801ff1:	e8 e2 e3 ff ff       	call   8003d8 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801ff6:	83 ec 08             	sub    $0x8,%esp
  801ff9:	6a 01                	push   $0x1
  801ffb:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802001:	e8 5f ef ff ff       	call   800f65 <sys_env_set_status>
  802006:	89 c3                	mov    %eax,%ebx
  802008:	83 c4 10             	add    $0x10,%esp
		panic("sys_env_set_status: %e", r);

	return child;
  80200b:	8b 85 94 fd ff ff    	mov    0xfffffd94(%ebp),%eax
  802011:	85 db                	test   %ebx,%ebx
  802013:	79 33                	jns    802048 <spawn+0x210>
  802015:	53                   	push   %ebx
  802016:	68 09 32 80 00       	push   $0x803209
  80201b:	68 88 00 00 00       	push   $0x88
  802020:	68 e3 31 80 00       	push   $0x8031e3
  802025:	e8 ae e3 ff ff       	call   8003d8 <_panic>

error:
	sys_env_destroy(child);
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802033:	e8 e7 ed ff ff       	call   800e1f <sys_env_destroy>
	close(fd);
  802038:	83 c4 04             	add    $0x4,%esp
  80203b:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802041:	e8 54 f3 ff ff       	call   80139a <close>
	return r;
  802046:	89 d8                	mov    %ebx,%eax
}
  802048:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 10             	sub    $0x10,%esp
	return spawn(prog, &arg0);
  802056:	8d 45 0c             	lea    0xc(%ebp),%eax
  802059:	50                   	push   %eax
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	e8 d6 fd ff ff       	call   801e38 <spawn>
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <init_stack>:


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
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	57                   	push   %edi
  802068:	56                   	push   %esi
  802069:	53                   	push   %ebx
  80206a:	83 ec 0c             	sub    $0xc,%esp
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80206d:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  802072:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
  802079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207c:	83 38 00             	cmpl   $0x0,(%eax)
  80207f:	74 27                	je     8020a8 <init_stack+0x44>
		string_size += strlen(argv[argc]) + 1;
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	ff 34 90             	pushl  (%eax,%edx,4)
  80208d:	e8 fe e9 ff ff       	call   800a90 <strlen>
  802092:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	ff 45 f0             	incl   0xfffffff0(%ebp)
  80209c:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80209f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a2:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  8020a6:	75 d9                	jne    802081 <init_stack+0x1d>

	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8020a8:	b8 00 10 40 00       	mov    $0x401000,%eax
  8020ad:	89 c7                	mov    %eax,%edi
  8020af:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8020b1:	89 fa                	mov    %edi,%edx
  8020b3:	83 e2 fc             	and    $0xfffffffc,%edx
  8020b6:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8020b9:	c1 e0 02             	shl    $0x2,%eax
  8020bc:	89 d6                	mov    %edx,%esi
  8020be:	29 c6                	sub    %eax,%esi
  8020c0:	83 ee 04             	sub    $0x4,%esi
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8020c3:	8d 46 f8             	lea    0xfffffff8(%esi),%eax
		return -E_NO_MEM;
  8020c6:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
  8020cb:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8020d0:	0f 86 f0 00 00 00    	jbe    8021c6 <init_stack+0x162>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	6a 07                	push   $0x7
  8020db:	68 00 00 40 00       	push   $0x400000
  8020e0:	6a 00                	push   $0x0
  8020e2:	e8 b7 ed ff ff       	call   800e9e <sys_page_alloc>
  8020e7:	83 c4 10             	add    $0x10,%esp
		return r;
  8020ea:	89 c2                	mov    %eax,%edx
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	0f 88 d2 00 00 00    	js     8021c6 <init_stack+0x162>


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
  8020f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020f9:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  8020fc:	7d 33                	jge    802131 <init_stack+0xcd>
		argv_store[i] = UTEMP2USTACK(string_store);
  8020fe:	8d 87 00 d0 7f ee    	lea    0xee7fd000(%edi),%eax
  802104:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
		strcpy(string_store, argv[i]);
  802107:	83 ec 08             	sub    $0x8,%esp
  80210a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210d:	ff 34 9a             	pushl  (%edx,%ebx,4)
  802110:	57                   	push   %edi
  802111:	e8 b6 e9 ff ff       	call   800acc <strcpy>
		string_store += strlen(argv[i]) + 1;
  802116:	83 c4 04             	add    $0x4,%esp
  802119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211c:	ff 34 98             	pushl  (%eax,%ebx,4)
  80211f:	e8 6c e9 ff ff       	call   800a90 <strlen>
  802124:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
  802128:	83 c4 10             	add    $0x10,%esp
  80212b:	43                   	inc    %ebx
  80212c:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  80212f:	7c cd                	jl     8020fe <init_stack+0x9a>
	}
	argv_store[argc] = 0;
  802131:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802134:	c7 04 96 00 00 00 00 	movl   $0x0,(%esi,%edx,4)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80213b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802141:	74 19                	je     80215c <init_stack+0xf8>
  802143:	68 5c 32 80 00       	push   $0x80325c
  802148:	68 6f 31 80 00       	push   $0x80316f
  80214d:	68 d9 00 00 00       	push   $0xd9
  802152:	68 e3 31 80 00       	push   $0x8031e3
  802157:	e8 7c e2 ff ff       	call   8003d8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80215c:	8d 86 00 d0 7f ee    	lea    0xee7fd000(%esi),%eax
  802162:	89 46 fc             	mov    %eax,0xfffffffc(%esi)
	argv_store[-2] = argc;
  802165:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802168:	89 46 f8             	mov    %eax,0xfffffff8(%esi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80216b:	8d 96 f8 cf 7f ee    	lea    0xee7fcff8(%esi),%edx
  802171:	8b 45 10             	mov    0x10(%ebp),%eax
  802174:	89 10                	mov    %edx,(%eax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802176:	83 ec 0c             	sub    $0xc,%esp
  802179:	6a 07                	push   $0x7
  80217b:	68 00 d0 bf ee       	push   $0xeebfd000
  802180:	ff 75 08             	pushl  0x8(%ebp)
  802183:	68 00 00 40 00       	push   $0x400000
  802188:	6a 00                	push   $0x0
  80218a:	e8 52 ed ff ff       	call   800ee1 <sys_page_map>
  80218f:	89 c3                	mov    %eax,%ebx
  802191:	83 c4 20             	add    $0x20,%esp
  802194:	85 c0                	test   %eax,%eax
  802196:	78 1d                	js     8021b5 <init_stack+0x151>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802198:	83 ec 08             	sub    $0x8,%esp
  80219b:	68 00 00 40 00       	push   $0x400000
  8021a0:	6a 00                	push   $0x0
  8021a2:	e8 7c ed ff ff       	call   800f23 <sys_page_unmap>
  8021a7:	89 c3                	mov    %eax,%ebx
  8021a9:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  8021ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	79 11                	jns    8021c6 <init_stack+0x162>

error:
	sys_page_unmap(0, UTEMP);
  8021b5:	83 ec 08             	sub    $0x8,%esp
  8021b8:	68 00 00 40 00       	push   $0x400000
  8021bd:	6a 00                	push   $0x0
  8021bf:	e8 5f ed ff ff       	call   800f23 <sys_page_unmap>
	return r;
  8021c4:	89 da                	mov    %ebx,%edx
}
  8021c6:	89 d0                	mov    %edx,%eax
  8021c8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5e                   	pop    %esi
  8021cd:	5f                   	pop    %edi
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz, 
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	57                   	push   %edi
  8021d4:	56                   	push   %esi
  8021d5:	53                   	push   %ebx
  8021d6:	83 ec 0c             	sub    $0xc,%esp
  8021d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021dc:	8b 7d 18             	mov    0x18(%ebp),%edi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8021df:	89 f3                	mov    %esi,%ebx
  8021e1:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  8021e7:	74 0a                	je     8021f3 <map_segment+0x23>
		va -= i;
  8021e9:	29 de                	sub    %ebx,%esi
		memsz += i;
  8021eb:	01 5d 10             	add    %ebx,0x10(%ebp)
		filesz += i;
  8021ee:	01 df                	add    %ebx,%edi
		fileoffset -= i;
  8021f0:	29 5d 1c             	sub    %ebx,0x1c(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8021f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021f8:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021fb:	0f 83 3a 01 00 00    	jae    80233b <map_segment+0x16b>
		if (i >= filesz) {
  802201:	39 fb                	cmp    %edi,%ebx
  802203:	72 22                	jb     802227 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802205:	83 ec 04             	sub    $0x4,%esp
  802208:	ff 75 20             	pushl  0x20(%ebp)
  80220b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80220e:	50                   	push   %eax
  80220f:	ff 75 08             	pushl  0x8(%ebp)
  802212:	e8 87 ec ff ff       	call   800e9e <sys_page_alloc>
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	85 c0                	test   %eax,%eax
  80221c:	0f 89 0a 01 00 00    	jns    80232c <map_segment+0x15c>
				return r;
  802222:	e9 19 01 00 00       	jmp    802340 <map_segment+0x170>
		} else {
			// from file
			if (perm & PTE_W) {
  802227:	f6 45 20 02          	testb  $0x2,0x20(%ebp)
  80222b:	0f 84 ac 00 00 00    	je     8022dd <map_segment+0x10d>
				// must make a copy so it can be writable
				if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	6a 07                	push   $0x7
  802236:	68 00 00 40 00       	push   $0x400000
  80223b:	6a 00                	push   $0x0
  80223d:	e8 5c ec ff ff       	call   800e9e <sys_page_alloc>
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	85 c0                	test   %eax,%eax
  802247:	0f 88 f3 00 00 00    	js     802340 <map_segment+0x170>
					return r;
				if ((r = seek(fd, fileoffset + i)) < 0)
  80224d:	83 ec 08             	sub    $0x8,%esp
  802250:	8b 45 1c             	mov    0x1c(%ebp),%eax
  802253:	01 d8                	add    %ebx,%eax
  802255:	50                   	push   %eax
  802256:	ff 75 14             	pushl  0x14(%ebp)
  802259:	e8 11 f4 ff ff       	call   80166f <seek>
  80225e:	83 c4 10             	add    $0x10,%esp
  802261:	85 c0                	test   %eax,%eax
  802263:	0f 88 d7 00 00 00    	js     802340 <map_segment+0x170>
					return r;
				if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802269:	89 fa                	mov    %edi,%edx
  80226b:	29 da                	sub    %ebx,%edx
  80226d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802272:	39 d0                	cmp    %edx,%eax
  802274:	76 02                	jbe    802278 <map_segment+0xa8>
  802276:	89 d0                	mov    %edx,%eax
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	50                   	push   %eax
  80227c:	68 00 00 40 00       	push   $0x400000
  802281:	ff 75 14             	pushl  0x14(%ebp)
  802284:	e8 84 f2 ff ff       	call   80150d <read>
  802289:	83 c4 10             	add    $0x10,%esp
  80228c:	85 c0                	test   %eax,%eax
  80228e:	0f 88 ac 00 00 00    	js     802340 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802294:	83 ec 0c             	sub    $0xc,%esp
  802297:	ff 75 20             	pushl  0x20(%ebp)
  80229a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80229d:	50                   	push   %eax
  80229e:	ff 75 08             	pushl  0x8(%ebp)
  8022a1:	68 00 00 40 00       	push   $0x400000
  8022a6:	6a 00                	push   $0x0
  8022a8:	e8 34 ec ff ff       	call   800ee1 <sys_page_map>
  8022ad:	83 c4 20             	add    $0x20,%esp
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	79 15                	jns    8022c9 <map_segment+0xf9>
					panic("spawn: sys_page_map data: %e", r);
  8022b4:	50                   	push   %eax
  8022b5:	68 20 32 80 00       	push   $0x803220
  8022ba:	68 0e 01 00 00       	push   $0x10e
  8022bf:	68 e3 31 80 00       	push   $0x8031e3
  8022c4:	e8 0f e1 ff ff       	call   8003d8 <_panic>
				sys_page_unmap(0, UTEMP);
  8022c9:	83 ec 08             	sub    $0x8,%esp
  8022cc:	68 00 00 40 00       	push   $0x400000
  8022d1:	6a 00                	push   $0x0
  8022d3:	e8 4b ec ff ff       	call   800f23 <sys_page_unmap>
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	eb 4f                	jmp    80232c <map_segment+0x15c>
			} else {
				// can map buffer cache read only
				if ((r = read_map(fd, fileoffset + i, &blk)) < 0)
  8022dd:	83 ec 04             	sub    $0x4,%esp
  8022e0:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8022e3:	50                   	push   %eax
  8022e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8022e7:	01 d8                	add    %ebx,%eax
  8022e9:	50                   	push   %eax
  8022ea:	ff 75 14             	pushl  0x14(%ebp)
  8022ed:	e8 11 f6 ff ff       	call   801903 <read_map>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	78 47                	js     802340 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, blk, child, (void*) (va + i), perm)) < 0)
  8022f9:	83 ec 0c             	sub    $0xc,%esp
  8022fc:	ff 75 20             	pushl  0x20(%ebp)
  8022ff:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  802302:	50                   	push   %eax
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802309:	6a 00                	push   $0x0
  80230b:	e8 d1 eb ff ff       	call   800ee1 <sys_page_map>
  802310:	83 c4 20             	add    $0x20,%esp
  802313:	85 c0                	test   %eax,%eax
  802315:	79 15                	jns    80232c <map_segment+0x15c>
					panic("spawn: sys_page_map text: %e", r);
  802317:	50                   	push   %eax
  802318:	68 3d 32 80 00       	push   $0x80323d
  80231d:	68 15 01 00 00       	push   $0x115
  802322:	68 e3 31 80 00       	push   $0x8031e3
  802327:	e8 ac e0 ff ff       	call   8003d8 <_panic>
  80232c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802332:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802335:	0f 82 c6 fe ff ff    	jb     802201 <map_segment+0x31>
			}
		}
	}
	return 0;
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802340:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802343:	5b                   	pop    %ebx
  802344:	5e                   	pop    %esi
  802345:	5f                   	pop    %edi
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child) {
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	57                   	push   %edi
  80234c:	56                   	push   %esi
  80234d:	53                   	push   %ebx
  80234e:	83 ec 0c             	sub    $0xc,%esp
  // LAB 7: Your code here.

  int i,j, r;
  void* va;

  for (i=0; i < VPD(UTOP); i++) {
  802351:	be 00 00 00 00       	mov    $0x0,%esi
    if (vpd[i] & PTE_P) {
  802356:	8b 04 b5 00 d0 7b ef 	mov    0xef7bd000(,%esi,4),%eax
  80235d:	a8 01                	test   $0x1,%al
  80235f:	74 68                	je     8023c9 <copy_shared_pages+0x81>
      for (j=0; j<NPTENTRIES && i*NPDENTRIES+j < (UXSTACKTOP-PGSIZE)/PGSIZE; j++) { // make sure not to remap exception stack this way
  802361:	bb 00 00 00 00       	mov    $0x0,%ebx
  802366:	89 f0                	mov    %esi,%eax
  802368:	c1 e0 0a             	shl    $0xa,%eax
  80236b:	89 c2                	mov    %eax,%edx
  80236d:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  802372:	77 55                	ja     8023c9 <copy_shared_pages+0x81>
  802374:	89 c7                	mov    %eax,%edi
        if ((vpt[i*NPDENTRIES+j] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  802376:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  802379:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  802380:	25 01 04 00 00       	and    $0x401,%eax
  802385:	3d 01 04 00 00       	cmp    $0x401,%eax
  80238a:	75 28                	jne    8023b4 <copy_shared_pages+0x6c>
          va = (void *)((i*NPDENTRIES+j) << PGSHIFT);
  80238c:	89 ca                	mov    %ecx,%edx
  80238e:	c1 e2 0c             	shl    $0xc,%edx
          if ((r = sys_page_map(0, va, child, va, vpt[i*NPDENTRIES+j] & PTE_USER)) < 0) {
  802391:	83 ec 0c             	sub    $0xc,%esp
  802394:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  80239b:	25 07 0e 00 00       	and    $0xe07,%eax
  8023a0:	50                   	push   %eax
  8023a1:	52                   	push   %edx
  8023a2:	ff 75 08             	pushl  0x8(%ebp)
  8023a5:	52                   	push   %edx
  8023a6:	6a 00                	push   $0x0
  8023a8:	e8 34 eb ff ff       	call   800ee1 <sys_page_map>
  8023ad:	83 c4 20             	add    $0x20,%esp
  8023b0:	85 c0                	test   %eax,%eax
  8023b2:	78 23                	js     8023d7 <copy_shared_pages+0x8f>
  8023b4:	43                   	inc    %ebx
  8023b5:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  8023bb:	7f 0c                	jg     8023c9 <copy_shared_pages+0x81>
  8023bd:	89 fa                	mov    %edi,%edx
  8023bf:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8023c2:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8023c7:	76 ad                	jbe    802376 <copy_shared_pages+0x2e>
  8023c9:	46                   	inc    %esi
  8023ca:	81 fe ba 03 00 00    	cmp    $0x3ba,%esi
  8023d0:	76 84                	jbe    802356 <copy_shared_pages+0xe>
            return r;
          }
        }
      }
    }
  }

  return 0;
  8023d2:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8023d7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8023da:	5b                   	pop    %ebx
  8023db:	5e                   	pop    %esi
  8023dc:	5f                   	pop    %edi
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    
	...

008023e0 <pipe>:
};

int
pipe(int pfd[2])
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	57                   	push   %edi
  8023e4:	56                   	push   %esi
  8023e5:	53                   	push   %ebx
  8023e6:	83 ec 18             	sub    $0x18,%esp
  8023e9:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023ec:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8023ef:	50                   	push   %eax
  8023f0:	e8 2b ee ff ff       	call   801220 <fd_alloc>
  8023f5:	89 c3                	mov    %eax,%ebx
  8023f7:	83 c4 10             	add    $0x10,%esp
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	0f 88 25 01 00 00    	js     802527 <pipe+0x147>
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 07 04 00 00       	push   $0x407
  80240a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80240d:	6a 00                	push   $0x0
  80240f:	e8 8a ea ff ff       	call   800e9e <sys_page_alloc>
  802414:	89 c3                	mov    %eax,%ebx
  802416:	83 c4 10             	add    $0x10,%esp
  802419:	85 c0                	test   %eax,%eax
  80241b:	0f 88 06 01 00 00    	js     802527 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  802427:	50                   	push   %eax
  802428:	e8 f3 ed ff ff       	call   801220 <fd_alloc>
  80242d:	89 c3                	mov    %eax,%ebx
  80242f:	83 c4 10             	add    $0x10,%esp
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 88 dd 00 00 00    	js     802517 <pipe+0x137>
  80243a:	83 ec 04             	sub    $0x4,%esp
  80243d:	68 07 04 00 00       	push   $0x407
  802442:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802445:	6a 00                	push   $0x0
  802447:	e8 52 ea ff ff       	call   800e9e <sys_page_alloc>
  80244c:	89 c3                	mov    %eax,%ebx
  80244e:	83 c4 10             	add    $0x10,%esp
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 88 be 00 00 00    	js     802517 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802459:	83 ec 0c             	sub    $0xc,%esp
  80245c:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80245f:	e8 94 ed ff ff       	call   8011f8 <fd2data>
  802464:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802466:	83 c4 0c             	add    $0xc,%esp
  802469:	68 07 04 00 00       	push   $0x407
  80246e:	50                   	push   %eax
  80246f:	6a 00                	push   $0x0
  802471:	e8 28 ea ff ff       	call   800e9e <sys_page_alloc>
  802476:	89 c3                	mov    %eax,%ebx
  802478:	83 c4 10             	add    $0x10,%esp
  80247b:	85 c0                	test   %eax,%eax
  80247d:	0f 88 84 00 00 00    	js     802507 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802483:	83 ec 0c             	sub    $0xc,%esp
  802486:	68 07 04 00 00       	push   $0x407
  80248b:	83 ec 0c             	sub    $0xc,%esp
  80248e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802491:	e8 62 ed ff ff       	call   8011f8 <fd2data>
  802496:	83 c4 10             	add    $0x10,%esp
  802499:	50                   	push   %eax
  80249a:	6a 00                	push   $0x0
  80249c:	56                   	push   %esi
  80249d:	6a 00                	push   $0x0
  80249f:	e8 3d ea ff ff       	call   800ee1 <sys_page_map>
  8024a4:	89 c3                	mov    %eax,%ebx
  8024a6:	83 c4 20             	add    $0x20,%esp
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	78 4c                	js     8024f9 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024ad:	8b 15 e0 87 80 00    	mov    0x8087e0,%edx
  8024b3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8024b6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024b8:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8024bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024c2:	8b 15 e0 87 80 00    	mov    0x8087e0,%edx
  8024c8:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8024cb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024cd:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8024d0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8024dd:	e8 2e ed ff ff       	call   801210 <fd2num>
  8024e2:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8024e4:	83 c4 04             	add    $0x4,%esp
  8024e7:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8024ea:	e8 21 ed ff ff       	call   801210 <fd2num>
  8024ef:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f7:	eb 30                	jmp    802529 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  8024f9:	83 ec 08             	sub    $0x8,%esp
  8024fc:	56                   	push   %esi
  8024fd:	6a 00                	push   $0x0
  8024ff:	e8 1f ea ff ff       	call   800f23 <sys_page_unmap>
  802504:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  802507:	83 ec 08             	sub    $0x8,%esp
  80250a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80250d:	6a 00                	push   $0x0
  80250f:	e8 0f ea ff ff       	call   800f23 <sys_page_unmap>
  802514:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802517:	83 ec 08             	sub    $0x8,%esp
  80251a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80251d:	6a 00                	push   $0x0
  80251f:	e8 ff e9 ff ff       	call   800f23 <sys_page_unmap>
  802524:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  802527:	89 d8                	mov    %ebx,%eax
}
  802529:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5f                   	pop    %edi
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	57                   	push   %edi
  802535:	56                   	push   %esi
  802536:	53                   	push   %ebx
  802537:	83 ec 0c             	sub    $0xc,%esp
  80253a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  80253d:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802542:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802545:	83 ec 0c             	sub    $0xc,%esp
  802548:	ff 75 08             	pushl  0x8(%ebp)
  80254b:	e8 20 03 00 00       	call   802870 <pageref>
  802550:	89 c3                	mov    %eax,%ebx
  802552:	89 3c 24             	mov    %edi,(%esp)
  802555:	e8 16 03 00 00       	call   802870 <pageref>
  80255a:	83 c4 10             	add    $0x10,%esp
  80255d:	39 c3                	cmp    %eax,%ebx
  80255f:	0f 94 c0             	sete   %al
  802562:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802565:	8b 0d 70 9f 80 00    	mov    0x809f70,%ecx
  80256b:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80256e:	39 c6                	cmp    %eax,%esi
  802570:	74 1b                	je     80258d <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  802572:	83 fa 01             	cmp    $0x1,%edx
  802575:	75 c6                	jne    80253d <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802577:	6a 01                	push   $0x1
  802579:	8b 41 58             	mov    0x58(%ecx),%eax
  80257c:	50                   	push   %eax
  80257d:	56                   	push   %esi
  80257e:	68 87 32 80 00       	push   $0x803287
  802583:	e8 40 df ff ff       	call   8004c8 <cprintf>
  802588:	83 c4 10             	add    $0x10,%esp
  80258b:	eb b0                	jmp    80253d <_pipeisclosed+0xc>
	}
}
  80258d:	89 d0                	mov    %edx,%eax
  80258f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802592:	5b                   	pop    %ebx
  802593:	5e                   	pop    %esi
  802594:	5f                   	pop    %edi
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80259d:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8025a0:	50                   	push   %eax
  8025a1:	ff 75 08             	pushl  0x8(%ebp)
  8025a4:	e8 d1 ec ff ff       	call   80127a <fd_lookup>
  8025a9:	83 c4 10             	add    $0x10,%esp
		return r;
  8025ac:	89 c2                	mov    %eax,%edx
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	78 19                	js     8025cb <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8025b8:	e8 3b ec ff ff       	call   8011f8 <fd2data>
	return _pipeisclosed(fd, p);
  8025bd:	83 c4 08             	add    $0x8,%esp
  8025c0:	50                   	push   %eax
  8025c1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8025c4:	e8 68 ff ff ff       	call   802531 <_pipeisclosed>
  8025c9:	89 c2                	mov    %eax,%edx
}
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	57                   	push   %edi
  8025d3:	56                   	push   %esi
  8025d4:	53                   	push   %ebx
  8025d5:	83 ec 18             	sub    $0x18,%esp
  8025d8:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  8025db:	57                   	push   %edi
  8025dc:	e8 17 ec ff ff       	call   8011f8 <fd2data>
  8025e1:	89 c3                	mov    %eax,%ebx
	if (debug)
  8025e3:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8025e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e9:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8025ec:	be 00 00 00 00       	mov    $0x0,%esi
  8025f1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025f4:	73 55                	jae    80264b <piperead+0x7c>
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
  8025f6:	8b 03                	mov    (%ebx),%eax
  8025f8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025fb:	75 2c                	jne    802629 <piperead+0x5a>
  8025fd:	85 f6                	test   %esi,%esi
  8025ff:	74 04                	je     802605 <piperead+0x36>
  802601:	89 f0                	mov    %esi,%eax
  802603:	eb 48                	jmp    80264d <piperead+0x7e>
  802605:	83 ec 08             	sub    $0x8,%esp
  802608:	53                   	push   %ebx
  802609:	57                   	push   %edi
  80260a:	e8 22 ff ff ff       	call   802531 <_pipeisclosed>
  80260f:	83 c4 10             	add    $0x10,%esp
  802612:	85 c0                	test   %eax,%eax
  802614:	74 07                	je     80261d <piperead+0x4e>
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
  80261b:	eb 30                	jmp    80264d <piperead+0x7e>
  80261d:	e8 5d e8 ff ff       	call   800e7f <sys_yield>
  802622:	8b 03                	mov    (%ebx),%eax
  802624:	3b 43 04             	cmp    0x4(%ebx),%eax
  802627:	74 d4                	je     8025fd <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802629:	8b 13                	mov    (%ebx),%edx
  80262b:	89 d0                	mov    %edx,%eax
  80262d:	85 d2                	test   %edx,%edx
  80262f:	79 03                	jns    802634 <piperead+0x65>
  802631:	8d 42 1f             	lea    0x1f(%edx),%eax
  802634:	83 e0 e0             	and    $0xffffffe0,%eax
  802637:	29 c2                	sub    %eax,%edx
  802639:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  80263d:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802640:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802643:	ff 03                	incl   (%ebx)
  802645:	46                   	inc    %esi
  802646:	3b 75 10             	cmp    0x10(%ebp),%esi
  802649:	72 ab                	jb     8025f6 <piperead+0x27>
	}
	return i;
  80264b:	89 f0                	mov    %esi,%eax
}
  80264d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5f                   	pop    %edi
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	57                   	push   %edi
  802659:	56                   	push   %esi
  80265a:	53                   	push   %ebx
  80265b:	83 ec 18             	sub    $0x18,%esp
  80265e:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  802661:	57                   	push   %edi
  802662:	e8 91 eb ff ff       	call   8011f8 <fd2data>
  802667:	89 c3                	mov    %eax,%ebx
	if (debug)
  802669:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80266c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802672:	be 00 00 00 00       	mov    $0x0,%esi
  802677:	3b 75 10             	cmp    0x10(%ebp),%esi
  80267a:	73 55                	jae    8026d1 <pipewrite+0x7c>
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
  80267c:	8b 03                	mov    (%ebx),%eax
  80267e:	83 c0 20             	add    $0x20,%eax
  802681:	39 43 04             	cmp    %eax,0x4(%ebx)
  802684:	72 27                	jb     8026ad <pipewrite+0x58>
  802686:	83 ec 08             	sub    $0x8,%esp
  802689:	53                   	push   %ebx
  80268a:	57                   	push   %edi
  80268b:	e8 a1 fe ff ff       	call   802531 <_pipeisclosed>
  802690:	83 c4 10             	add    $0x10,%esp
  802693:	85 c0                	test   %eax,%eax
  802695:	74 07                	je     80269e <pipewrite+0x49>
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	eb 35                	jmp    8026d3 <pipewrite+0x7e>
  80269e:	e8 dc e7 ff ff       	call   800e7f <sys_yield>
  8026a3:	8b 03                	mov    (%ebx),%eax
  8026a5:	83 c0 20             	add    $0x20,%eax
  8026a8:	39 43 04             	cmp    %eax,0x4(%ebx)
  8026ab:	73 d9                	jae    802686 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026ad:	8b 53 04             	mov    0x4(%ebx),%edx
  8026b0:	89 d0                	mov    %edx,%eax
  8026b2:	85 d2                	test   %edx,%edx
  8026b4:	79 03                	jns    8026b9 <pipewrite+0x64>
  8026b6:	8d 42 1f             	lea    0x1f(%edx),%eax
  8026b9:	83 e0 e0             	and    $0xffffffe0,%eax
  8026bc:	29 c2                	sub    %eax,%edx
  8026be:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8026c1:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8026c4:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026c8:	ff 43 04             	incl   0x4(%ebx)
  8026cb:	46                   	inc    %esi
  8026cc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026cf:	72 ab                	jb     80267c <pipewrite+0x27>
	}
	
	return i;
  8026d1:	89 f0                	mov    %esi,%eax
}
  8026d3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8026d6:	5b                   	pop    %ebx
  8026d7:	5e                   	pop    %esi
  8026d8:	5f                   	pop    %edi
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	56                   	push   %esi
  8026df:	53                   	push   %ebx
  8026e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	ff 75 08             	pushl  0x8(%ebp)
  8026e9:	e8 0a eb ff ff       	call   8011f8 <fd2data>
  8026ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8026f0:	83 c4 08             	add    $0x8,%esp
  8026f3:	68 9a 32 80 00       	push   $0x80329a
  8026f8:	53                   	push   %ebx
  8026f9:	e8 ce e3 ff ff       	call   800acc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8026fe:	8b 46 04             	mov    0x4(%esi),%eax
  802701:	2b 06                	sub    (%esi),%eax
  802703:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802709:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802710:	00 00 00 
	stat->st_dev = &devpipe;
  802713:	c7 83 88 00 00 00 e0 	movl   $0x8087e0,0x88(%ebx)
  80271a:	87 80 00 
	return 0;
}
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
  802722:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802725:	5b                   	pop    %ebx
  802726:	5e                   	pop    %esi
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	53                   	push   %ebx
  80272d:	83 ec 0c             	sub    $0xc,%esp
  802730:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802733:	53                   	push   %ebx
  802734:	6a 00                	push   $0x0
  802736:	e8 e8 e7 ff ff       	call   800f23 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80273b:	89 1c 24             	mov    %ebx,(%esp)
  80273e:	e8 b5 ea ff ff       	call   8011f8 <fd2data>
  802743:	83 c4 08             	add    $0x8,%esp
  802746:	50                   	push   %eax
  802747:	6a 00                	push   $0x0
  802749:	e8 d5 e7 ff ff       	call   800f23 <sys_page_unmap>
}
  80274e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802751:	c9                   	leave  
  802752:	c3                   	ret    
	...

00802754 <wait>:

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	56                   	push   %esi
  802758:	53                   	push   %ebx
  802759:	8b 75 08             	mov    0x8(%ebp),%esi
	volatile struct Env *e;

	assert(envid != 0);
  80275c:	85 f6                	test   %esi,%esi
  80275e:	75 16                	jne    802776 <wait+0x22>
  802760:	68 a1 32 80 00       	push   $0x8032a1
  802765:	68 6f 31 80 00       	push   $0x80316f
  80276a:	6a 09                	push   $0x9
  80276c:	68 ac 32 80 00       	push   $0x8032ac
  802771:	e8 62 dc ff ff       	call   8003d8 <_panic>
	e = &envs[ENVX(envid)];
  802776:	89 f3                	mov    %esi,%ebx
  802778:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80277e:	89 d8                	mov    %ebx,%eax
  802780:	c1 e0 07             	shl    $0x7,%eax
  802783:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
		sys_yield();
  802789:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80278c:	39 f0                	cmp    %esi,%eax
  80278e:	75 1a                	jne    8027aa <wait+0x56>
  802790:	8b 43 54             	mov    0x54(%ebx),%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	74 13                	je     8027aa <wait+0x56>
  802797:	e8 e3 e6 ff ff       	call   800e7f <sys_yield>
  80279c:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80279f:	39 f0                	cmp    %esi,%eax
  8027a1:	75 07                	jne    8027aa <wait+0x56>
  8027a3:	8b 43 54             	mov    0x54(%ebx),%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	75 ed                	jne    802797 <wait+0x43>
}
  8027aa:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8027ad:	5b                   	pop    %ebx
  8027ae:	5e                   	pop    %esi
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    
  8027b1:	00 00                	add    %al,(%eax)
	...

008027b4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	56                   	push   %esi
  8027b8:	53                   	push   %ebx
  8027b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8027bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bf:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	75 12                	jne    8027d8 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8027c6:	83 ec 0c             	sub    $0xc,%esp
  8027c9:	68 00 00 c0 ee       	push   $0xeec00000
  8027ce:	e8 7b e8 ff ff       	call   80104e <sys_ipc_recv>
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	eb 0c                	jmp    8027e4 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8027d8:	83 ec 0c             	sub    $0xc,%esp
  8027db:	50                   	push   %eax
  8027dc:	e8 6d e8 ff ff       	call   80104e <sys_ipc_recv>
  8027e1:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8027e4:	89 c2                	mov    %eax,%edx
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	78 24                	js     80280e <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8027ea:	85 db                	test   %ebx,%ebx
  8027ec:	74 0a                	je     8027f8 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8027ee:	a1 70 9f 80 00       	mov    0x809f70,%eax
  8027f3:	8b 40 74             	mov    0x74(%eax),%eax
  8027f6:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8027f8:	85 f6                	test   %esi,%esi
  8027fa:	74 0a                	je     802806 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8027fc:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802801:	8b 40 78             	mov    0x78(%eax),%eax
  802804:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802806:	a1 70 9f 80 00       	mov    0x809f70,%eax
  80280b:	8b 50 70             	mov    0x70(%eax),%edx

}
  80280e:	89 d0                	mov    %edx,%eax
  802810:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802813:	5b                   	pop    %ebx
  802814:	5e                   	pop    %esi
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <ipc_send>:

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
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	57                   	push   %edi
  80281b:	56                   	push   %esi
  80281c:	53                   	push   %ebx
  80281d:	83 ec 0c             	sub    $0xc,%esp
  802820:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802823:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802826:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802829:	85 db                	test   %ebx,%ebx
  80282b:	75 0a                	jne    802837 <ipc_send+0x20>
    pg = (void *) UTOP;
  80282d:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802832:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802837:	56                   	push   %esi
  802838:	53                   	push   %ebx
  802839:	57                   	push   %edi
  80283a:	ff 75 08             	pushl  0x8(%ebp)
  80283d:	e8 e9 e7 ff ff       	call   80102b <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802842:	83 c4 10             	add    $0x10,%esp
  802845:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802848:	75 07                	jne    802851 <ipc_send+0x3a>
      sys_yield();
  80284a:	e8 30 e6 ff ff       	call   800e7f <sys_yield>
  80284f:	eb e6                	jmp    802837 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802851:	85 c0                	test   %eax,%eax
  802853:	79 12                	jns    802867 <ipc_send+0x50>
  802855:	50                   	push   %eax
  802856:	68 b7 32 80 00       	push   $0x8032b7
  80285b:	6a 49                	push   $0x49
  80285d:	68 d4 32 80 00       	push   $0x8032d4
  802862:	e8 71 db ff ff       	call   8003d8 <_panic>
    else break;
  }
}
  802867:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80286a:	5b                   	pop    %ebx
  80286b:	5e                   	pop    %esi
  80286c:	5f                   	pop    %edi
  80286d:	c9                   	leave  
  80286e:	c3                   	ret    
	...

00802870 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802876:	89 c8                	mov    %ecx,%eax
  802878:	c1 e8 16             	shr    $0x16,%eax
  80287b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802882:	ba 00 00 00 00       	mov    $0x0,%edx
  802887:	a8 01                	test   $0x1,%al
  802889:	74 28                	je     8028b3 <pageref+0x43>
	pte = vpt[VPN(v)];
  80288b:	89 c8                	mov    %ecx,%eax
  80288d:	c1 e8 0c             	shr    $0xc,%eax
  802890:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  802897:	ba 00 00 00 00       	mov    $0x0,%edx
  80289c:	a8 01                	test   $0x1,%al
  80289e:	74 13                	je     8028b3 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8028a0:	c1 e8 0c             	shr    $0xc,%eax
  8028a3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8028a6:	c1 e0 02             	shl    $0x2,%eax
  8028a9:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8028b0:	0f b7 d0             	movzwl %ax,%edx
}
  8028b3:	89 d0                	mov    %edx,%eax
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    
	...

008028b8 <__udivdi3>:
  8028b8:	55                   	push   %ebp
  8028b9:	89 e5                	mov    %esp,%ebp
  8028bb:	57                   	push   %edi
  8028bc:	56                   	push   %esi
  8028bd:	83 ec 14             	sub    $0x14,%esp
  8028c0:	8b 55 14             	mov    0x14(%ebp),%edx
  8028c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8028c6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8028cc:	85 d2                	test   %edx,%edx
  8028ce:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8028d1:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8028d4:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8028d7:	89 fe                	mov    %edi,%esi
  8028d9:	75 11                	jne    8028ec <__udivdi3+0x34>
  8028db:	39 f8                	cmp    %edi,%eax
  8028dd:	76 4d                	jbe    80292c <__udivdi3+0x74>
  8028df:	89 fa                	mov    %edi,%edx
  8028e1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8028e4:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8028e7:	89 c7                	mov    %eax,%edi
  8028e9:	eb 09                	jmp    8028f4 <__udivdi3+0x3c>
  8028eb:	90                   	nop    
  8028ec:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  8028ef:	76 17                	jbe    802908 <__udivdi3+0x50>
  8028f1:	31 ff                	xor    %edi,%edi
  8028f3:	90                   	nop    
  8028f4:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  8028fb:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8028fe:	83 c4 14             	add    $0x14,%esp
  802901:	5e                   	pop    %esi
  802902:	89 f8                	mov    %edi,%eax
  802904:	5f                   	pop    %edi
  802905:	c9                   	leave  
  802906:	c3                   	ret    
  802907:	90                   	nop    
  802908:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  80290c:	89 c7                	mov    %eax,%edi
  80290e:	83 f7 1f             	xor    $0x1f,%edi
  802911:	75 4d                	jne    802960 <__udivdi3+0xa8>
  802913:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802916:	77 0a                	ja     802922 <__udivdi3+0x6a>
  802918:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80291b:	31 ff                	xor    %edi,%edi
  80291d:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802920:	72 d2                	jb     8028f4 <__udivdi3+0x3c>
  802922:	bf 01 00 00 00       	mov    $0x1,%edi
  802927:	eb cb                	jmp    8028f4 <__udivdi3+0x3c>
  802929:	8d 76 00             	lea    0x0(%esi),%esi
  80292c:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	75 0e                	jne    802941 <__udivdi3+0x89>
  802933:	b8 01 00 00 00       	mov    $0x1,%eax
  802938:	31 c9                	xor    %ecx,%ecx
  80293a:	31 d2                	xor    %edx,%edx
  80293c:	f7 f1                	div    %ecx
  80293e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802941:	89 f0                	mov    %esi,%eax
  802943:	31 d2                	xor    %edx,%edx
  802945:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802948:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80294b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80294e:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802951:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802954:	83 c4 14             	add    $0x14,%esp
  802957:	89 c7                	mov    %eax,%edi
  802959:	5e                   	pop    %esi
  80295a:	89 f8                	mov    %edi,%eax
  80295c:	5f                   	pop    %edi
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    
  80295f:	90                   	nop    
  802960:	b8 20 00 00 00       	mov    $0x20,%eax
  802965:	29 f8                	sub    %edi,%eax
  802967:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80296a:	89 f9                	mov    %edi,%ecx
  80296c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80296f:	d3 e2                	shl    %cl,%edx
  802971:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802974:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802977:	d3 e8                	shr    %cl,%eax
  802979:	09 c2                	or     %eax,%edx
  80297b:	89 f9                	mov    %edi,%ecx
  80297d:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802980:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802983:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802986:	89 f2                	mov    %esi,%edx
  802988:	d3 ea                	shr    %cl,%edx
  80298a:	89 f9                	mov    %edi,%ecx
  80298c:	d3 e6                	shl    %cl,%esi
  80298e:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802991:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802994:	d3 e8                	shr    %cl,%eax
  802996:	09 c6                	or     %eax,%esi
  802998:	89 f9                	mov    %edi,%ecx
  80299a:	89 f0                	mov    %esi,%eax
  80299c:	f7 75 f4             	divl   0xfffffff4(%ebp)
  80299f:	89 d6                	mov    %edx,%esi
  8029a1:	89 c7                	mov    %eax,%edi
  8029a3:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8029a6:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8029a9:	f7 e7                	mul    %edi
  8029ab:	39 f2                	cmp    %esi,%edx
  8029ad:	77 0f                	ja     8029be <__udivdi3+0x106>
  8029af:	0f 85 3f ff ff ff    	jne    8028f4 <__udivdi3+0x3c>
  8029b5:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  8029b8:	0f 86 36 ff ff ff    	jbe    8028f4 <__udivdi3+0x3c>
  8029be:	4f                   	dec    %edi
  8029bf:	e9 30 ff ff ff       	jmp    8028f4 <__udivdi3+0x3c>

008029c4 <__umoddi3>:
  8029c4:	55                   	push   %ebp
  8029c5:	89 e5                	mov    %esp,%ebp
  8029c7:	57                   	push   %edi
  8029c8:	56                   	push   %esi
  8029c9:	83 ec 30             	sub    $0x30,%esp
  8029cc:	8b 55 14             	mov    0x14(%ebp),%edx
  8029cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d2:	89 d7                	mov    %edx,%edi
  8029d4:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8029d7:	89 c6                	mov    %eax,%esi
  8029d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	85 ff                	test   %edi,%edi
  8029e1:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  8029e8:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8029ef:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  8029f2:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8029f5:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8029f8:	75 3e                	jne    802a38 <__umoddi3+0x74>
  8029fa:	39 d6                	cmp    %edx,%esi
  8029fc:	0f 86 a2 00 00 00    	jbe    802aa4 <__umoddi3+0xe0>
  802a02:	f7 f6                	div    %esi
  802a04:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802a07:	85 c9                	test   %ecx,%ecx
  802a09:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802a0c:	74 1b                	je     802a29 <__umoddi3+0x65>
  802a0e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a11:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802a14:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802a1b:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802a1e:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802a21:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802a24:	89 10                	mov    %edx,(%eax)
  802a26:	89 48 04             	mov    %ecx,0x4(%eax)
  802a29:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802a2c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802a2f:	83 c4 30             	add    $0x30,%esp
  802a32:	5e                   	pop    %esi
  802a33:	5f                   	pop    %edi
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    
  802a36:	89 f6                	mov    %esi,%esi
  802a38:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802a3b:	76 1f                	jbe    802a5c <__umoddi3+0x98>
  802a3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a40:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802a43:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802a46:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802a49:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802a4c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802a4f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802a52:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802a55:	83 c4 30             	add    $0x30,%esp
  802a58:	5e                   	pop    %esi
  802a59:	5f                   	pop    %edi
  802a5a:	c9                   	leave  
  802a5b:	c3                   	ret    
  802a5c:	0f bd c7             	bsr    %edi,%eax
  802a5f:	83 f0 1f             	xor    $0x1f,%eax
  802a62:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802a65:	75 61                	jne    802ac8 <__umoddi3+0x104>
  802a67:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  802a6a:	77 05                	ja     802a71 <__umoddi3+0xad>
  802a6c:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  802a6f:	72 10                	jb     802a81 <__umoddi3+0xbd>
  802a71:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802a74:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a77:	29 f0                	sub    %esi,%eax
  802a79:	19 fa                	sbb    %edi,%edx
  802a7b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802a7e:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802a81:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802a84:	85 d2                	test   %edx,%edx
  802a86:	74 a1                	je     802a29 <__umoddi3+0x65>
  802a88:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a8b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802a8e:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802a91:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802a94:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802a97:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802a9a:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802a9d:	89 01                	mov    %eax,(%ecx)
  802a9f:	89 51 04             	mov    %edx,0x4(%ecx)
  802aa2:	eb 85                	jmp    802a29 <__umoddi3+0x65>
  802aa4:	85 f6                	test   %esi,%esi
  802aa6:	75 0b                	jne    802ab3 <__umoddi3+0xef>
  802aa8:	b8 01 00 00 00       	mov    $0x1,%eax
  802aad:	31 d2                	xor    %edx,%edx
  802aaf:	f7 f6                	div    %esi
  802ab1:	89 c6                	mov    %eax,%esi
  802ab3:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802ab6:	89 fa                	mov    %edi,%edx
  802ab8:	f7 f6                	div    %esi
  802aba:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802abd:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802ac0:	f7 f6                	div    %esi
  802ac2:	e9 3d ff ff ff       	jmp    802a04 <__umoddi3+0x40>
  802ac7:	90                   	nop    
  802ac8:	b8 20 00 00 00       	mov    $0x20,%eax
  802acd:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802ad0:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802ad3:	89 fa                	mov    %edi,%edx
  802ad5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802ad8:	d3 e2                	shl    %cl,%edx
  802ada:	89 f0                	mov    %esi,%eax
  802adc:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802adf:	d3 e8                	shr    %cl,%eax
  802ae1:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802ae4:	d3 e6                	shl    %cl,%esi
  802ae6:	89 d7                	mov    %edx,%edi
  802ae8:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802aeb:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802aee:	09 c7                	or     %eax,%edi
  802af0:	d3 ea                	shr    %cl,%edx
  802af2:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802af5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802af8:	d3 e0                	shl    %cl,%eax
  802afa:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802afd:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802b00:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802b03:	d3 e8                	shr    %cl,%eax
  802b05:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802b08:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802b0b:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802b0e:	f7 f7                	div    %edi
  802b10:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802b13:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802b16:	f7 e6                	mul    %esi
  802b18:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802b1b:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802b1e:	77 0a                	ja     802b2a <__umoddi3+0x166>
  802b20:	75 12                	jne    802b34 <__umoddi3+0x170>
  802b22:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802b25:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802b28:	76 0a                	jbe    802b34 <__umoddi3+0x170>
  802b2a:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802b2d:	29 f1                	sub    %esi,%ecx
  802b2f:	19 fa                	sbb    %edi,%edx
  802b31:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802b34:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	0f 84 ea fe ff ff    	je     802a29 <__umoddi3+0x65>
  802b3f:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802b42:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802b45:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802b48:	19 d1                	sbb    %edx,%ecx
  802b4a:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802b4d:	89 ca                	mov    %ecx,%edx
  802b4f:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802b52:	d3 e2                	shl    %cl,%edx
  802b54:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802b57:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802b5a:	d3 e8                	shr    %cl,%eax
  802b5c:	09 c2                	or     %eax,%edx
  802b5e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802b61:	d3 e8                	shr    %cl,%eax
  802b63:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802b66:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802b69:	e9 ad fe ff ff       	jmp    802a1b <__umoddi3+0x57>
