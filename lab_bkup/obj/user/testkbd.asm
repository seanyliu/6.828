
obj/user/testkbd:     file format elf32-i386

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
  80002c:	e8 37 02 00 00       	call   800268 <libmain>
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
  800037:	83 ec 14             	sub    $0x14,%esp
	int r;

	close(0);
  80003a:	6a 00                	push   $0x0
  80003c:	e8 1d 13 00 00       	call   80135e <close>
	if ((r = opencons()) < 0)
  800041:	e8 08 01 00 00       	call   80014e <opencons>
  800046:	83 c4 10             	add    $0x10,%esp
  800049:	85 c0                	test   %eax,%eax
  80004b:	79 12                	jns    80005f <umain+0x2b>
		panic("opencons: %e", r);
  80004d:	50                   	push   %eax
  80004e:	68 60 26 80 00       	push   $0x802660
  800053:	6a 0b                	push   $0xb
  800055:	68 6d 26 80 00       	push   $0x80266d
  80005a:	e8 65 02 00 00       	call   8002c4 <_panic>
	if (r != 0)
  80005f:	85 c0                	test   %eax,%eax
  800061:	74 12                	je     800075 <umain+0x41>
		panic("first opencons used fd %d", r);
  800063:	50                   	push   %eax
  800064:	68 7c 26 80 00       	push   $0x80267c
  800069:	6a 0d                	push   $0xd
  80006b:	68 6d 26 80 00       	push   $0x80266d
  800070:	e8 4f 02 00 00       	call   8002c4 <_panic>
	if ((r = dup(0, 1)) < 0)
  800075:	83 ec 08             	sub    $0x8,%esp
  800078:	6a 01                	push   $0x1
  80007a:	6a 00                	push   $0x0
  80007c:	e8 2e 13 00 00       	call   8013af <dup>
  800081:	83 c4 10             	add    $0x10,%esp
  800084:	85 c0                	test   %eax,%eax
  800086:	79 12                	jns    80009a <umain+0x66>
		panic("dup: %e", r);
  800088:	50                   	push   %eax
  800089:	68 96 26 80 00       	push   $0x802696
  80008e:	6a 0f                	push   $0xf
  800090:	68 6d 26 80 00       	push   $0x80266d
  800095:	e8 2a 02 00 00       	call   8002c4 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	68 9e 26 80 00       	push   $0x80269e
  8000a2:	e8 d5 07 00 00       	call   80087c <readline>
		if (buf != NULL)
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	74 15                	je     8000c3 <umain+0x8f>
			fprintf(1, "%s\n", buf);
  8000ae:	83 ec 04             	sub    $0x4,%esp
  8000b1:	50                   	push   %eax
  8000b2:	68 ac 26 80 00       	push   $0x8026ac
  8000b7:	6a 01                	push   $0x1
  8000b9:	e8 b3 1c 00 00       	call   801d71 <fprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	eb d7                	jmp    80009a <umain+0x66>
		else
			fprintf(1, "(end of file received)\n");
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	68 b0 26 80 00       	push   $0x8026b0
  8000cb:	6a 01                	push   $0x1
  8000cd:	e8 9f 1c 00 00       	call   801d71 <fprintf>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	eb c3                	jmp    80009a <umain+0x66>
	...

008000d8 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  8000de:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e1:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8000e4:	6a 01                	push   $0x1
  8000e6:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8000e9:	50                   	push   %eax
  8000ea:	e8 b1 0c 00 00       	call   800da0 <sys_cputs>
}
  8000ef:	c9                   	leave  
  8000f0:	c3                   	ret    

008000f1 <getchar>:

int
getchar(void)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8000f7:	6a 01                	push   $0x1
  8000f9:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8000fc:	50                   	push   %eax
  8000fd:	6a 00                	push   $0x0
  8000ff:	e8 cd 13 00 00       	call   8014d1 <read>
	if (r < 0)
  800104:	83 c4 10             	add    $0x10,%esp
		return r;
  800107:	89 c2                	mov    %eax,%edx
  800109:	85 c0                	test   %eax,%eax
  80010b:	78 0d                	js     80011a <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  80010d:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  800112:	85 c0                	test   %eax,%eax
  800114:	7e 04                	jle    80011a <getchar+0x29>
	return c;
  800116:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  80011a:	89 d0                	mov    %edx,%eax
  80011c:	c9                   	leave  
  80011d:	c3                   	ret    

0080011e <iscons>:


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
  80011e:	55                   	push   %ebp
  80011f:	89 e5                	mov    %esp,%ebp
  800121:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800124:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800127:	50                   	push   %eax
  800128:	ff 75 08             	pushl  0x8(%ebp)
  80012b:	e8 0e 11 00 00       	call   80123e <fd_lookup>
  800130:	83 c4 10             	add    $0x10,%esp
		return r;
  800133:	89 c2                	mov    %eax,%edx
  800135:	85 c0                	test   %eax,%eax
  800137:	78 11                	js     80014a <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  800139:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80013c:	8b 00                	mov    (%eax),%eax
  80013e:	3b 05 00 60 80 00    	cmp    0x806000,%eax
  800144:	0f 94 c0             	sete   %al
  800147:	0f b6 d0             	movzbl %al,%edx
}
  80014a:	89 d0                	mov    %edx,%eax
  80014c:	c9                   	leave  
  80014d:	c3                   	ret    

0080014e <opencons>:

int
opencons(void)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800154:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800157:	50                   	push   %eax
  800158:	e8 87 10 00 00       	call   8011e4 <fd_alloc>
  80015d:	83 c4 10             	add    $0x10,%esp
		return r;
  800160:	89 c2                	mov    %eax,%edx
  800162:	85 c0                	test   %eax,%eax
  800164:	78 3c                	js     8001a2 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800166:	83 ec 04             	sub    $0x4,%esp
  800169:	68 07 04 00 00       	push   $0x407
  80016e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  800171:	6a 00                	push   $0x0
  800173:	e8 ea 0c 00 00       	call   800e62 <sys_page_alloc>
  800178:	83 c4 10             	add    $0x10,%esp
		return r;
  80017b:	89 c2                	mov    %eax,%edx
  80017d:	85 c0                	test   %eax,%eax
  80017f:	78 21                	js     8001a2 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  800181:	a1 00 60 80 00       	mov    0x806000,%eax
  800186:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  800189:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80018b:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80018e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80019b:	e8 34 10 00 00       	call   8011d4 <fd2num>
  8001a0:	89 c2                	mov    %eax,%edx
}
  8001a2:	89 d0                	mov    %edx,%eax
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  8001ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001b5:	74 2a                	je     8001e1 <cons_read+0x3b>
  8001b7:	eb 05                	jmp    8001be <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001b9:	e8 85 0c 00 00       	call   800e43 <sys_yield>
  8001be:	e8 01 0c 00 00       	call   800dc4 <sys_cgetc>
  8001c3:	89 c2                	mov    %eax,%edx
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 f0                	je     8001b9 <cons_read+0x13>
	if (c < 0)
  8001c9:	85 d2                	test   %edx,%edx
  8001cb:	78 14                	js     8001e1 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d2:	83 fa 04             	cmp    $0x4,%edx
  8001d5:	74 0a                	je     8001e1 <cons_read+0x3b>
	*(char*)vbuf = c;
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	88 10                	mov    %dl,(%eax)
	return 1;
  8001dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  8001ef:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8001f2:	be 00 00 00 00       	mov    $0x0,%esi
  8001f7:	39 fe                	cmp    %edi,%esi
  8001f9:	73 3d                	jae    800238 <cons_write+0x55>
		m = n - tot;
  8001fb:	89 fb                	mov    %edi,%ebx
  8001fd:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8001ff:	83 fb 7f             	cmp    $0x7f,%ebx
  800202:	76 05                	jbe    800209 <cons_write+0x26>
			m = sizeof(buf) - 1;
  800204:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	53                   	push   %ebx
  80020d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800210:	01 f0                	add    %esi,%eax
  800212:	50                   	push   %eax
  800213:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  800219:	50                   	push   %eax
  80021a:	e8 ed 09 00 00       	call   800c0c <memmove>
		sys_cputs(buf, m);
  80021f:	83 c4 08             	add    $0x8,%esp
  800222:	53                   	push   %ebx
  800223:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  800229:	50                   	push   %eax
  80022a:	e8 71 0b 00 00       	call   800da0 <sys_cputs>
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	01 de                	add    %ebx,%esi
  800234:	39 fe                	cmp    %edi,%esi
  800236:	72 c3                	jb     8001fb <cons_write+0x18>
	}
	return tot;
}
  800238:	89 f0                	mov    %esi,%eax
  80023a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <cons_close>:

int
cons_close(struct Fd *fd)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800245:	b8 00 00 00 00       	mov    $0x0,%eax
  80024a:	c9                   	leave  
  80024b:	c3                   	ret    

0080024c <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800252:	68 cd 26 80 00       	push   $0x8026cd
  800257:	ff 75 0c             	pushl  0xc(%ebp)
  80025a:	e8 31 08 00 00       	call   800a90 <strcpy>
	return 0;
}
  80025f:	b8 00 00 00 00       	mov    $0x0,%eax
  800264:	c9                   	leave  
  800265:	c3                   	ret    
	...

00800268 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	8b 75 08             	mov    0x8(%ebp),%esi
  800270:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  800273:	e8 ac 0b 00 00       	call   800e24 <sys_getenvid>
  800278:	25 ff 03 00 00       	and    $0x3ff,%eax
  80027d:	c1 e0 07             	shl    $0x7,%eax
  800280:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800285:	a3 80 64 80 00       	mov    %eax,0x806480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80028a:	85 f6                	test   %esi,%esi
  80028c:	7e 07                	jle    800295 <libmain+0x2d>
		binaryname = argv[0];
  80028e:	8b 03                	mov    (%ebx),%eax
  800290:	a3 20 60 80 00       	mov    %eax,0x806020

	// call user main routine
	umain(argc, argv);
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	53                   	push   %ebx
  800299:	56                   	push   %esi
  80029a:	e8 95 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80029f:	e8 08 00 00 00       	call   8002ac <exit>
}
  8002a4:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8002a7:	5b                   	pop    %ebx
  8002a8:	5e                   	pop    %esi
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    
	...

008002ac <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002b2:	e8 d5 10 00 00       	call   80138c <close_all>
	sys_env_destroy(0);
  8002b7:	83 ec 0c             	sub    $0xc,%esp
  8002ba:	6a 00                	push   $0x0
  8002bc:	e8 22 0b 00 00       	call   800de3 <sys_env_destroy>
}
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    
	...

008002c4 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	53                   	push   %ebx
  8002c8:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8002cb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8002ce:	83 3d 84 64 80 00 00 	cmpl   $0x0,0x806484
  8002d5:	74 16                	je     8002ed <_panic+0x29>
		cprintf("%s: ", argv0);
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	ff 35 84 64 80 00    	pushl  0x806484
  8002e0:	68 eb 26 80 00       	push   $0x8026eb
  8002e5:	e8 ca 00 00 00       	call   8003b4 <cprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ed:	ff 75 0c             	pushl  0xc(%ebp)
  8002f0:	ff 75 08             	pushl  0x8(%ebp)
  8002f3:	ff 35 20 60 80 00    	pushl  0x806020
  8002f9:	68 f0 26 80 00       	push   $0x8026f0
  8002fe:	e8 b1 00 00 00       	call   8003b4 <cprintf>
	vcprintf(fmt, ap);
  800303:	83 c4 08             	add    $0x8,%esp
  800306:	53                   	push   %ebx
  800307:	ff 75 10             	pushl  0x10(%ebp)
  80030a:	e8 54 00 00 00       	call   800363 <vcprintf>
	cprintf("\n");
  80030f:	c7 04 24 c6 26 80 00 	movl   $0x8026c6,(%esp)
  800316:	e8 99 00 00 00       	call   8003b4 <cprintf>

	// Cause a breakpoint exception
	while (1)
  80031b:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  80031e:	cc                   	int3   
  80031f:	eb fd                	jmp    80031e <_panic+0x5a>
  800321:	00 00                	add    %al,(%eax)
	...

00800324 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	53                   	push   %ebx
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80032e:	8b 03                	mov    (%ebx),%eax
  800330:	8b 55 08             	mov    0x8(%ebp),%edx
  800333:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  800337:	40                   	inc    %eax
  800338:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80033a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80033f:	75 1a                	jne    80035b <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	68 ff 00 00 00       	push   $0xff
  800349:	8d 43 08             	lea    0x8(%ebx),%eax
  80034c:	50                   	push   %eax
  80034d:	e8 4e 0a 00 00       	call   800da0 <sys_cputs>
		b->idx = 0;
  800352:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800358:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80035b:	ff 43 04             	incl   0x4(%ebx)
}
  80035e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800361:	c9                   	leave  
  800362:	c3                   	ret    

00800363 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80036c:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  800373:	00 00 00 
	b.cnt = 0;
  800376:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  80037d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800380:	ff 75 0c             	pushl  0xc(%ebp)
  800383:	ff 75 08             	pushl  0x8(%ebp)
  800386:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  80038c:	50                   	push   %eax
  80038d:	68 24 03 80 00       	push   $0x800324
  800392:	e8 4f 01 00 00       	call   8004e6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800397:	83 c4 08             	add    $0x8,%esp
  80039a:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8003a0:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	e8 f4 09 00 00       	call   800da0 <sys_cputs>

	return b.cnt;
  8003ac:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    

008003b4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ba:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003bd:	50                   	push   %eax
  8003be:	ff 75 08             	pushl  0x8(%ebp)
  8003c1:	e8 9d ff ff ff       	call   800363 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	57                   	push   %edi
  8003cc:	56                   	push   %esi
  8003cd:	53                   	push   %ebx
  8003ce:	83 ec 0c             	sub    $0xc,%esp
  8003d1:	8b 75 10             	mov    0x10(%ebp),%esi
  8003d4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003d7:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003da:	8b 45 18             	mov    0x18(%ebp),%eax
  8003dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e2:	39 fa                	cmp    %edi,%edx
  8003e4:	77 39                	ja     80041f <printnum+0x57>
  8003e6:	72 04                	jb     8003ec <printnum+0x24>
  8003e8:	39 f0                	cmp    %esi,%eax
  8003ea:	77 33                	ja     80041f <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ec:	83 ec 04             	sub    $0x4,%esp
  8003ef:	ff 75 20             	pushl  0x20(%ebp)
  8003f2:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8003f5:	50                   	push   %eax
  8003f6:	ff 75 18             	pushl  0x18(%ebp)
  8003f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800401:	52                   	push   %edx
  800402:	50                   	push   %eax
  800403:	57                   	push   %edi
  800404:	56                   	push   %esi
  800405:	e8 86 1f 00 00       	call   802390 <__udivdi3>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	52                   	push   %edx
  80040e:	50                   	push   %eax
  80040f:	ff 75 0c             	pushl  0xc(%ebp)
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 ae ff ff ff       	call   8003c8 <printnum>
  80041a:	83 c4 20             	add    $0x20,%esp
  80041d:	eb 19                	jmp    800438 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80041f:	4b                   	dec    %ebx
  800420:	85 db                	test   %ebx,%ebx
  800422:	7e 14                	jle    800438 <printnum+0x70>
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 20             	pushl  0x20(%ebp)
  80042d:	ff 55 08             	call   *0x8(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	4b                   	dec    %ebx
  800434:	85 db                	test   %ebx,%ebx
  800436:	7f ec                	jg     800424 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	8b 45 18             	mov    0x18(%ebp),%eax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	52                   	push   %edx
  80044a:	50                   	push   %eax
  80044b:	57                   	push   %edi
  80044c:	56                   	push   %esi
  80044d:	e8 4a 20 00 00       	call   80249c <__umoddi3>
  800452:	83 c4 14             	add    $0x14,%esp
  800455:	0f be 80 06 28 80 00 	movsbl 0x802806(%eax),%eax
  80045c:	50                   	push   %eax
  80045d:	ff 55 08             	call   *0x8(%ebp)
}
  800460:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800463:	5b                   	pop    %ebx
  800464:	5e                   	pop    %esi
  800465:	5f                   	pop    %edi
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80046e:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800471:	83 f8 01             	cmp    $0x1,%eax
  800474:	7e 0f                	jle    800485 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800476:	8b 01                	mov    (%ecx),%eax
  800478:	83 c0 08             	add    $0x8,%eax
  80047b:	89 01                	mov    %eax,(%ecx)
  80047d:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800480:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800483:	eb 24                	jmp    8004a9 <getuint+0x41>
	else if (lflag)
  800485:	85 c0                	test   %eax,%eax
  800487:	74 11                	je     80049a <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800489:	8b 01                	mov    (%ecx),%eax
  80048b:	83 c0 04             	add    $0x4,%eax
  80048e:	89 01                	mov    %eax,(%ecx)
  800490:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800493:	ba 00 00 00 00       	mov    $0x0,%edx
  800498:	eb 0f                	jmp    8004a9 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  80049a:	8b 01                	mov    (%ecx),%eax
  80049c:	83 c0 04             	add    $0x4,%eax
  80049f:	89 01                	mov    %eax,(%ecx)
  8004a1:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8004a4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004a9:	c9                   	leave  
  8004aa:	c3                   	ret    

008004ab <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8004b4:	83 f8 01             	cmp    $0x1,%eax
  8004b7:	7e 0f                	jle    8004c8 <getint+0x1d>
		return va_arg(*ap, long long);
  8004b9:	8b 02                	mov    (%edx),%eax
  8004bb:	83 c0 08             	add    $0x8,%eax
  8004be:	89 02                	mov    %eax,(%edx)
  8004c0:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8004c3:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8004c6:	eb 1c                	jmp    8004e4 <getint+0x39>
	else if (lflag)
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	74 0d                	je     8004d9 <getint+0x2e>
		return va_arg(*ap, long);
  8004cc:	8b 02                	mov    (%edx),%eax
  8004ce:	83 c0 04             	add    $0x4,%eax
  8004d1:	89 02                	mov    %eax,(%edx)
  8004d3:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8004d6:	99                   	cltd   
  8004d7:	eb 0b                	jmp    8004e4 <getint+0x39>
	else
		return va_arg(*ap, int);
  8004d9:	8b 02                	mov    (%edx),%eax
  8004db:	83 c0 04             	add    $0x4,%eax
  8004de:	89 02                	mov    %eax,(%edx)
  8004e0:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8004e3:	99                   	cltd   
}
  8004e4:	c9                   	leave  
  8004e5:	c3                   	ret    

008004e6 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	57                   	push   %edi
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
  8004ec:	83 ec 1c             	sub    $0x1c,%esp
  8004ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8004f2:	0f b6 13             	movzbl (%ebx),%edx
  8004f5:	43                   	inc    %ebx
  8004f6:	83 fa 25             	cmp    $0x25,%edx
  8004f9:	74 1e                	je     800519 <vprintfmt+0x33>
  8004fb:	85 d2                	test   %edx,%edx
  8004fd:	0f 84 d7 02 00 00    	je     8007da <vprintfmt+0x2f4>
  800503:	83 ec 08             	sub    $0x8,%esp
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	52                   	push   %edx
  80050a:	ff 55 08             	call   *0x8(%ebp)
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	0f b6 13             	movzbl (%ebx),%edx
  800513:	43                   	inc    %ebx
  800514:	83 fa 25             	cmp    $0x25,%edx
  800517:	75 e2                	jne    8004fb <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  800519:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  80051d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800524:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800529:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  80052e:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800535:	0f b6 13             	movzbl (%ebx),%edx
  800538:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  80053b:	43                   	inc    %ebx
  80053c:	83 f8 55             	cmp    $0x55,%eax
  80053f:	0f 87 70 02 00 00    	ja     8007b5 <vprintfmt+0x2cf>
  800545:	ff 24 85 9c 28 80 00 	jmp    *0x80289c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  80054c:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800550:	eb e3                	jmp    800535 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800552:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  800556:	eb dd                	jmp    800535 <vprintfmt+0x4f>

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
  800558:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  80055d:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800560:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800564:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800567:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  80056a:	83 f8 09             	cmp    $0x9,%eax
  80056d:	77 27                	ja     800596 <vprintfmt+0xb0>
  80056f:	43                   	inc    %ebx
  800570:	eb eb                	jmp    80055d <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800572:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  80057c:	eb 18                	jmp    800596 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80057e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800582:	79 b1                	jns    800535 <vprintfmt+0x4f>
				width = 0;
  800584:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  80058b:	eb a8                	jmp    800535 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  80058d:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800594:	eb 9f                	jmp    800535 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  800596:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80059a:	79 99                	jns    800535 <vprintfmt+0x4f>
				width = precision, precision = -1;
  80059c:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80059f:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8005a4:	eb 8f                	jmp    800535 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a6:	41                   	inc    %ecx
			goto reswitch;
  8005a7:	eb 8c                	jmp    800535 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 0c             	pushl  0xc(%ebp)
  8005af:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8005b9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	e9 2e ff ff ff       	jmp    8004f2 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c4:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	79 02                	jns    8005d4 <vprintfmt+0xee>
				err = -err;
  8005d2:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005d4:	83 f8 0e             	cmp    $0xe,%eax
  8005d7:	7f 0b                	jg     8005e4 <vprintfmt+0xfe>
  8005d9:	8b 3c 85 60 28 80 00 	mov    0x802860(,%eax,4),%edi
  8005e0:	85 ff                	test   %edi,%edi
  8005e2:	75 19                	jne    8005fd <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8005e4:	50                   	push   %eax
  8005e5:	68 17 28 80 00       	push   $0x802817
  8005ea:	ff 75 0c             	pushl  0xc(%ebp)
  8005ed:	ff 75 08             	pushl  0x8(%ebp)
  8005f0:	e8 ed 01 00 00       	call   8007e2 <printfmt>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	e9 f5 fe ff ff       	jmp    8004f2 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8005fd:	57                   	push   %edi
  8005fe:	68 b1 2b 80 00       	push   $0x802bb1
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	e8 d4 01 00 00       	call   8007e2 <printfmt>
  80060e:	83 c4 10             	add    $0x10,%esp
			break;
  800611:	e9 dc fe ff ff       	jmp    8004f2 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800616:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800620:	85 ff                	test   %edi,%edi
  800622:	75 05                	jne    800629 <vprintfmt+0x143>
				p = "(null)";
  800624:	bf 20 28 80 00       	mov    $0x802820,%edi
			if (width > 0 && padc != '-')
  800629:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80062d:	7e 3b                	jle    80066a <vprintfmt+0x184>
  80062f:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  800633:	74 35                	je     80066a <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	56                   	push   %esi
  800639:	57                   	push   %edi
  80063a:	e8 2e 04 00 00       	call   800a6d <strnlen>
  80063f:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800649:	7e 1f                	jle    80066a <vprintfmt+0x184>
  80064b:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80064f:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  80065b:	ff 55 08             	call   *0x8(%ebp)
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800664:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800668:	7f e8                	jg     800652 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066a:	0f be 17             	movsbl (%edi),%edx
  80066d:	47                   	inc    %edi
  80066e:	85 d2                	test   %edx,%edx
  800670:	74 44                	je     8006b6 <vprintfmt+0x1d0>
  800672:	85 f6                	test   %esi,%esi
  800674:	78 03                	js     800679 <vprintfmt+0x193>
  800676:	4e                   	dec    %esi
  800677:	78 3d                	js     8006b6 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800679:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  80067d:	74 18                	je     800697 <vprintfmt+0x1b1>
  80067f:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  800682:	83 f8 5e             	cmp    $0x5e,%eax
  800685:	76 10                	jbe    800697 <vprintfmt+0x1b1>
					putch('?', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	ff 75 0c             	pushl  0xc(%ebp)
  80068d:	6a 3f                	push   $0x3f
  80068f:	ff 55 08             	call   *0x8(%ebp)
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	eb 0d                	jmp    8006a4 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	52                   	push   %edx
  80069e:	ff 55 08             	call   *0x8(%ebp)
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8006a7:	0f be 17             	movsbl (%edi),%edx
  8006aa:	47                   	inc    %edi
  8006ab:	85 d2                	test   %edx,%edx
  8006ad:	74 07                	je     8006b6 <vprintfmt+0x1d0>
  8006af:	85 f6                	test   %esi,%esi
  8006b1:	78 c6                	js     800679 <vprintfmt+0x193>
  8006b3:	4e                   	dec    %esi
  8006b4:	79 c3                	jns    800679 <vprintfmt+0x193>
			for (; width > 0; width--)
  8006b6:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8006ba:	0f 8e 32 fe ff ff    	jle    8004f2 <vprintfmt+0xc>
				putch(' ', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	ff 75 0c             	pushl  0xc(%ebp)
  8006c6:	6a 20                	push   $0x20
  8006c8:	ff 55 08             	call   *0x8(%ebp)
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8006d1:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8006d5:	7f e9                	jg     8006c0 <vprintfmt+0x1da>
			break;
  8006d7:	e9 16 fe ff ff       	jmp    8004f2 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006dc:	51                   	push   %ecx
  8006dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	e8 c5 fd ff ff       	call   8004ab <getint>
  8006e6:	89 c6                	mov    %eax,%esi
  8006e8:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8006ea:	83 c4 08             	add    $0x8,%esp
  8006ed:	85 d2                	test   %edx,%edx
  8006ef:	79 15                	jns    800706 <vprintfmt+0x220>
				putch('-', putdat);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	6a 2d                	push   $0x2d
  8006f9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006fc:	f7 de                	neg    %esi
  8006fe:	83 d7 00             	adc    $0x0,%edi
  800701:	f7 df                	neg    %edi
  800703:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800706:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80070b:	eb 75                	jmp    800782 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80070d:	51                   	push   %ecx
  80070e:	8d 45 14             	lea    0x14(%ebp),%eax
  800711:	50                   	push   %eax
  800712:	e8 51 fd ff ff       	call   800468 <getuint>
  800717:	89 c6                	mov    %eax,%esi
  800719:	89 d7                	mov    %edx,%edi
			base = 10;
  80071b:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800720:	83 c4 08             	add    $0x8,%esp
  800723:	eb 5d                	jmp    800782 <vprintfmt+0x29c>

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
  800725:	51                   	push   %ecx
  800726:	8d 45 14             	lea    0x14(%ebp),%eax
  800729:	50                   	push   %eax
  80072a:	e8 39 fd ff ff       	call   800468 <getuint>
  80072f:	89 c6                	mov    %eax,%esi
  800731:	89 d7                	mov    %edx,%edi
			base = 8;
  800733:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800738:	83 c4 08             	add    $0x8,%esp
  80073b:	eb 45                	jmp    800782 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	6a 30                	push   $0x30
  800745:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800748:	83 c4 08             	add    $0x8,%esp
  80074b:	ff 75 0c             	pushl  0xc(%ebp)
  80074e:	6a 78                	push   $0x78
  800750:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800753:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  80075d:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800762:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	eb 16                	jmp    800782 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80076c:	51                   	push   %ecx
  80076d:	8d 45 14             	lea    0x14(%ebp),%eax
  800770:	50                   	push   %eax
  800771:	e8 f2 fc ff ff       	call   800468 <getuint>
  800776:	89 c6                	mov    %eax,%esi
  800778:	89 d7                	mov    %edx,%edi
			base = 16;
  80077a:	ba 10 00 00 00       	mov    $0x10,%edx
  80077f:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  800782:	83 ec 04             	sub    $0x4,%esp
  800785:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800789:	50                   	push   %eax
  80078a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80078d:	52                   	push   %edx
  80078e:	57                   	push   %edi
  80078f:	56                   	push   %esi
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	ff 75 08             	pushl  0x8(%ebp)
  800796:	e8 2d fc ff ff       	call   8003c8 <printnum>
			break;
  80079b:	83 c4 20             	add    $0x20,%esp
  80079e:	e9 4f fd ff ff       	jmp    8004f2 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	52                   	push   %edx
  8007aa:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	e9 3d fd ff ff       	jmp    8004f2 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	6a 25                	push   $0x25
  8007bd:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c0:	4b                   	dec    %ebx
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8007c8:	0f 84 24 fd ff ff    	je     8004f2 <vprintfmt+0xc>
  8007ce:	4b                   	dec    %ebx
  8007cf:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8007d3:	75 f9                	jne    8007ce <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8007d5:	e9 18 fd ff ff       	jmp    8004f2 <vprintfmt+0xc>
		}
	}
}
  8007da:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8007dd:	5b                   	pop    %ebx
  8007de:	5e                   	pop    %esi
  8007df:	5f                   	pop    %edi
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    

008007e2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8007e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007eb:	50                   	push   %eax
  8007ec:	ff 75 10             	pushl  0x10(%ebp)
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	e8 ec fc ff ff       	call   8004e6 <vprintfmt>
	va_end(ap);
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  800802:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800805:	8b 0a                	mov    (%edx),%ecx
  800807:	3b 4a 04             	cmp    0x4(%edx),%ecx
  80080a:	73 07                	jae    800813 <sprintputch+0x17>
		*b->buf++ = ch;
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	88 01                	mov    %al,(%ecx)
  800811:	ff 02                	incl   (%edx)
}
  800813:	c9                   	leave  
  800814:	c3                   	ret    

00800815 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 18             	sub    $0x18,%esp
  80081b:	8b 55 08             	mov    0x8(%ebp),%edx
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800821:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800824:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800828:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80082b:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  800832:	85 d2                	test   %edx,%edx
  800834:	74 04                	je     80083a <vsnprintf+0x25>
  800836:	85 c9                	test   %ecx,%ecx
  800838:	7f 07                	jg     800841 <vsnprintf+0x2c>
		return -E_INVAL;
  80083a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083f:	eb 1d                	jmp    80085e <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800841:	ff 75 14             	pushl  0x14(%ebp)
  800844:	ff 75 10             	pushl  0x10(%ebp)
  800847:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  80084a:	50                   	push   %eax
  80084b:	68 fc 07 80 00       	push   $0x8007fc
  800850:	e8 91 fc ff ff       	call   8004e6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800855:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800858:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80085e:	c9                   	leave  
  80085f:	c3                   	ret    

00800860 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800866:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800869:	50                   	push   %eax
  80086a:	ff 75 10             	pushl  0x10(%ebp)
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 9d ff ff ff       	call   800815 <vsnprintf>
	va_end(ap);

	return rc;
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    
	...

0080087c <readline>:
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	57                   	push   %edi
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
  800882:	83 ec 0c             	sub    $0xc,%esp
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800888:	85 c0                	test   %eax,%eax
  80088a:	74 13                	je     80089f <readline+0x23>
		fprintf(1, "%s", prompt);
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	50                   	push   %eax
  800890:	68 b1 2b 80 00       	push   $0x802bb1
  800895:	6a 01                	push   $0x1
  800897:	e8 d5 14 00 00       	call   801d71 <fprintf>
  80089c:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
  80089f:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
  8008a4:	83 ec 0c             	sub    $0xc,%esp
  8008a7:	6a 00                	push   $0x0
  8008a9:	e8 70 f8 ff ff       	call   80011e <iscons>
  8008ae:	89 c7                	mov    %eax,%edi
	while (1) {
  8008b0:	83 c4 10             	add    $0x10,%esp
		c = getchar();
  8008b3:	e8 39 f8 ff ff       	call   8000f1 <getchar>
  8008b8:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8008ba:	85 c0                	test   %eax,%eax
  8008bc:	79 1d                	jns    8008db <readline+0x5f>
			if (c != -E_EOF)
  8008be:	83 f8 f8             	cmp    $0xfffffff8,%eax
  8008c1:	74 11                	je     8008d4 <readline+0x58>
				cprintf("read error: %e\n", c);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	50                   	push   %eax
  8008c7:	68 f4 29 80 00       	push   $0x8029f4
  8008cc:	e8 e3 fa ff ff       	call   8003b4 <cprintf>
  8008d1:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8008d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d9:	eb 6f                	jmp    80094a <readline+0xce>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8008db:	83 f8 08             	cmp    $0x8,%eax
  8008de:	74 05                	je     8008e5 <readline+0x69>
  8008e0:	83 f8 7f             	cmp    $0x7f,%eax
  8008e3:	75 18                	jne    8008fd <readline+0x81>
  8008e5:	85 f6                	test   %esi,%esi
  8008e7:	7e 14                	jle    8008fd <readline+0x81>
			if (echoing)
  8008e9:	85 ff                	test   %edi,%edi
  8008eb:	74 0d                	je     8008fa <readline+0x7e>
				cputchar('\b');
  8008ed:	83 ec 0c             	sub    $0xc,%esp
  8008f0:	6a 08                	push   $0x8
  8008f2:	e8 e1 f7 ff ff       	call   8000d8 <cputchar>
  8008f7:	83 c4 10             	add    $0x10,%esp
			i--;
  8008fa:	4e                   	dec    %esi
  8008fb:	eb b6                	jmp    8008b3 <readline+0x37>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8008fd:	83 fb 1f             	cmp    $0x1f,%ebx
  800900:	7e 21                	jle    800923 <readline+0xa7>
  800902:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800908:	7f 19                	jg     800923 <readline+0xa7>
			if (echoing)
  80090a:	85 ff                	test   %edi,%edi
  80090c:	74 0c                	je     80091a <readline+0x9e>
				cputchar(c);
  80090e:	83 ec 0c             	sub    $0xc,%esp
  800911:	53                   	push   %ebx
  800912:	e8 c1 f7 ff ff       	call   8000d8 <cputchar>
  800917:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80091a:	88 9e 80 60 80 00    	mov    %bl,0x806080(%esi)
  800920:	46                   	inc    %esi
  800921:	eb 90                	jmp    8008b3 <readline+0x37>
		} else if (c == '\n' || c == '\r') {
  800923:	83 fb 0a             	cmp    $0xa,%ebx
  800926:	74 05                	je     80092d <readline+0xb1>
  800928:	83 fb 0d             	cmp    $0xd,%ebx
  80092b:	75 86                	jne    8008b3 <readline+0x37>
			if (echoing)
  80092d:	85 ff                	test   %edi,%edi
  80092f:	74 0d                	je     80093e <readline+0xc2>
				cputchar('\n');
  800931:	83 ec 0c             	sub    $0xc,%esp
  800934:	6a 0a                	push   $0xa
  800936:	e8 9d f7 ff ff       	call   8000d8 <cputchar>
  80093b:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80093e:	c6 86 80 60 80 00 00 	movb   $0x0,0x806080(%esi)
			return buf;
  800945:	b8 80 60 80 00       	mov    $0x806080,%eax
		}
	}
}
  80094a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5f                   	pop    %edi
  800950:	c9                   	leave  
  800951:	c3                   	ret    
	...

00800954 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	56                   	push   %esi
  800960:	e8 ef 00 00 00       	call   800a54 <strlen>
  char letter;
  int hexnum = 0;
  800965:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80096a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	89 c2                	mov    %eax,%edx
  800974:	4a                   	dec    %edx
  800975:	0f 88 d0 00 00 00    	js     800a4b <strtoint+0xf7>
    letter = string[cidx];
  80097b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80097e:	85 d2                	test   %edx,%edx
  800980:	75 12                	jne    800994 <strtoint+0x40>
      if (letter != '0') {
  800982:	3c 30                	cmp    $0x30,%al
  800984:	0f 84 ba 00 00 00    	je     800a44 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80098a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80098f:	e9 b9 00 00 00       	jmp    800a4d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800994:	83 fa 01             	cmp    $0x1,%edx
  800997:	75 12                	jne    8009ab <strtoint+0x57>
      if (letter != 'x') {
  800999:	3c 78                	cmp    $0x78,%al
  80099b:	0f 84 a3 00 00 00    	je     800a44 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8009a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8009a6:	e9 a2 00 00 00       	jmp    800a4d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8009ab:	0f be c0             	movsbl %al,%eax
  8009ae:	83 e8 30             	sub    $0x30,%eax
  8009b1:	83 f8 36             	cmp    $0x36,%eax
  8009b4:	0f 87 80 00 00 00    	ja     800a3a <strtoint+0xe6>
  8009ba:	ff 24 85 04 2a 80 00 	jmp    *0x802a04(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8009c1:	01 cb                	add    %ecx,%ebx
          break;
  8009c3:	eb 7c                	jmp    800a41 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8009c5:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8009c8:	eb 77                	jmp    800a41 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8009ca:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009cd:	01 c3                	add    %eax,%ebx
          break;
  8009cf:	eb 70                	jmp    800a41 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8009d1:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8009d4:	eb 6b                	jmp    800a41 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8009d6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8009d9:	01 c3                	add    %eax,%ebx
          break;
  8009db:	eb 64                	jmp    800a41 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8009dd:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009e0:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8009e3:	eb 5c                	jmp    800a41 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8009e5:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8009ec:	29 c8                	sub    %ecx,%eax
  8009ee:	01 c3                	add    %eax,%ebx
          break;
  8009f0:	eb 4f                	jmp    800a41 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8009f2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8009f5:	eb 4a                	jmp    800a41 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8009f7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8009fa:	01 c3                	add    %eax,%ebx
          break;
  8009fc:	eb 43                	jmp    800a41 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8009fe:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800a01:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a04:	eb 3b                	jmp    800a41 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800a06:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800a09:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800a0c:	01 c3                	add    %eax,%ebx
          break;
  800a0e:	eb 31                	jmp    800a41 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800a10:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a13:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800a16:	eb 29                	jmp    800a41 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800a18:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a1b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800a1e:	01 c3                	add    %eax,%ebx
          break;
  800a20:	eb 1f                	jmp    800a41 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800a22:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800a29:	29 c8                	sub    %ecx,%eax
  800a2b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a2e:	eb 11                	jmp    800a41 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800a30:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a33:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a36:	01 c3                	add    %eax,%ebx
          break;
  800a38:	eb 07                	jmp    800a41 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  800a3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800a3f:	eb 0c                	jmp    800a4d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800a41:	c1 e1 04             	shl    $0x4,%ecx
  800a44:	4a                   	dec    %edx
  800a45:	0f 89 30 ff ff ff    	jns    80097b <strtoint+0x27>
    }
  }

  return hexnum;
  800a4b:	89 d8                	mov    %ebx,%eax
}
  800a4d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	c9                   	leave  
  800a53:	c3                   	ret    

00800a54 <strlen>:





int
strlen(const char *s)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5f:	80 3a 00             	cmpb   $0x0,(%edx)
  800a62:	74 07                	je     800a6b <strlen+0x17>
		n++;
  800a64:	40                   	inc    %eax
  800a65:	42                   	inc    %edx
  800a66:	80 3a 00             	cmpb   $0x0,(%edx)
  800a69:	75 f9                	jne    800a64 <strlen+0x10>
	return n;
}
  800a6b:	c9                   	leave  
  800a6c:	c3                   	ret    

00800a6d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	85 d2                	test   %edx,%edx
  800a7d:	74 0f                	je     800a8e <strnlen+0x21>
  800a7f:	80 39 00             	cmpb   $0x0,(%ecx)
  800a82:	74 0a                	je     800a8e <strnlen+0x21>
		n++;
  800a84:	40                   	inc    %eax
  800a85:	41                   	inc    %ecx
  800a86:	4a                   	dec    %edx
  800a87:	74 05                	je     800a8e <strnlen+0x21>
  800a89:	80 39 00             	cmpb   $0x0,(%ecx)
  800a8c:	75 f6                	jne    800a84 <strnlen+0x17>
	return n;
}
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	53                   	push   %ebx
  800a94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800a9a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800a9c:	8a 02                	mov    (%edx),%al
  800a9e:	42                   	inc    %edx
  800a9f:	88 01                	mov    %al,(%ecx)
  800aa1:	41                   	inc    %ecx
  800aa2:	84 c0                	test   %al,%al
  800aa4:	75 f6                	jne    800a9c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800aa6:	89 d8                	mov    %ebx,%eax
  800aa8:	5b                   	pop    %ebx
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	57                   	push   %edi
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab7:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  800aba:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800abc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac1:	39 f3                	cmp    %esi,%ebx
  800ac3:	73 10                	jae    800ad5 <strncpy+0x2a>
		*dst++ = *src;
  800ac5:	8a 02                	mov    (%edx),%al
  800ac7:	88 01                	mov    %al,(%ecx)
  800ac9:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aca:	80 3a 01             	cmpb   $0x1,(%edx)
  800acd:	83 da ff             	sbb    $0xffffffff,%edx
  800ad0:	43                   	inc    %ebx
  800ad1:	39 f3                	cmp    %esi,%ebx
  800ad3:	72 f0                	jb     800ac5 <strncpy+0x1a>
	}
	return ret;
}
  800ad5:	89 f8                	mov    %edi,%eax
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	56                   	push   %esi
  800ae0:	53                   	push   %ebx
  800ae1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ae4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae7:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  800aea:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800aec:	85 d2                	test   %edx,%edx
  800aee:	74 19                	je     800b09 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800af0:	4a                   	dec    %edx
  800af1:	74 13                	je     800b06 <strlcpy+0x2a>
  800af3:	80 39 00             	cmpb   $0x0,(%ecx)
  800af6:	74 0e                	je     800b06 <strlcpy+0x2a>
  800af8:	8a 01                	mov    (%ecx),%al
  800afa:	41                   	inc    %ecx
  800afb:	88 03                	mov    %al,(%ebx)
  800afd:	43                   	inc    %ebx
  800afe:	4a                   	dec    %edx
  800aff:	74 05                	je     800b06 <strlcpy+0x2a>
  800b01:	80 39 00             	cmpb   $0x0,(%ecx)
  800b04:	75 f2                	jne    800af8 <strlcpy+0x1c>
		*dst = '\0';
  800b06:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800b09:	89 d8                	mov    %ebx,%eax
  800b0b:	29 f0                	sub    %esi,%eax
}
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	8b 55 08             	mov    0x8(%ebp),%edx
  800b17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800b1a:	80 3a 00             	cmpb   $0x0,(%edx)
  800b1d:	74 13                	je     800b32 <strcmp+0x21>
  800b1f:	8a 02                	mov    (%edx),%al
  800b21:	3a 01                	cmp    (%ecx),%al
  800b23:	75 0d                	jne    800b32 <strcmp+0x21>
  800b25:	42                   	inc    %edx
  800b26:	41                   	inc    %ecx
  800b27:	80 3a 00             	cmpb   $0x0,(%edx)
  800b2a:	74 06                	je     800b32 <strcmp+0x21>
  800b2c:	8a 02                	mov    (%edx),%al
  800b2e:	3a 01                	cmp    (%ecx),%al
  800b30:	74 f3                	je     800b25 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b32:	0f b6 02             	movzbl (%edx),%eax
  800b35:	0f b6 11             	movzbl (%ecx),%edx
  800b38:	29 d0                	sub    %edx,%eax
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	53                   	push   %ebx
  800b40:	8b 55 08             	mov    0x8(%ebp),%edx
  800b43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800b49:	85 c9                	test   %ecx,%ecx
  800b4b:	74 1f                	je     800b6c <strncmp+0x30>
  800b4d:	80 3a 00             	cmpb   $0x0,(%edx)
  800b50:	74 16                	je     800b68 <strncmp+0x2c>
  800b52:	8a 02                	mov    (%edx),%al
  800b54:	3a 03                	cmp    (%ebx),%al
  800b56:	75 10                	jne    800b68 <strncmp+0x2c>
  800b58:	42                   	inc    %edx
  800b59:	43                   	inc    %ebx
  800b5a:	49                   	dec    %ecx
  800b5b:	74 0f                	je     800b6c <strncmp+0x30>
  800b5d:	80 3a 00             	cmpb   $0x0,(%edx)
  800b60:	74 06                	je     800b68 <strncmp+0x2c>
  800b62:	8a 02                	mov    (%edx),%al
  800b64:	3a 03                	cmp    (%ebx),%al
  800b66:	74 f0                	je     800b58 <strncmp+0x1c>
	if (n == 0)
  800b68:	85 c9                	test   %ecx,%ecx
  800b6a:	75 07                	jne    800b73 <strncmp+0x37>
		return 0;
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b71:	eb 0a                	jmp    800b7d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b73:	0f b6 12             	movzbl (%edx),%edx
  800b76:	0f b6 03             	movzbl (%ebx),%eax
  800b79:	29 c2                	sub    %eax,%edx
  800b7b:	89 d0                	mov    %edx,%eax
}
  800b7d:	5b                   	pop    %ebx
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800b89:	80 38 00             	cmpb   $0x0,(%eax)
  800b8c:	74 0a                	je     800b98 <strchr+0x18>
		if (*s == c)
  800b8e:	38 10                	cmp    %dl,(%eax)
  800b90:	74 0b                	je     800b9d <strchr+0x1d>
  800b92:	40                   	inc    %eax
  800b93:	80 38 00             	cmpb   $0x0,(%eax)
  800b96:	75 f6                	jne    800b8e <strchr+0xe>
			return (char *) s;
	return 0;
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800ba8:	80 38 00             	cmpb   $0x0,(%eax)
  800bab:	74 0a                	je     800bb7 <strfind+0x18>
		if (*s == c)
  800bad:	38 10                	cmp    %dl,(%eax)
  800baf:	74 06                	je     800bb7 <strfind+0x18>
  800bb1:	40                   	inc    %eax
  800bb2:	80 38 00             	cmpb   $0x0,(%eax)
  800bb5:	75 f6                	jne    800bad <strfind+0xe>
			break;
	return (char *) s;
}
  800bb7:	c9                   	leave  
  800bb8:	c3                   	ret    

00800bb9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800bc3:	89 f8                	mov    %edi,%eax
  800bc5:	85 c9                	test   %ecx,%ecx
  800bc7:	74 40                	je     800c09 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800bc9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bcf:	75 30                	jne    800c01 <memset+0x48>
  800bd1:	f6 c1 03             	test   $0x3,%cl
  800bd4:	75 2b                	jne    800c01 <memset+0x48>
		c &= 0xFF;
  800bd6:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	c1 e0 18             	shl    $0x18,%eax
  800be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be6:	c1 e2 10             	shl    $0x10,%edx
  800be9:	09 d0                	or     %edx,%eax
  800beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bee:	c1 e2 08             	shl    $0x8,%edx
  800bf1:	09 d0                	or     %edx,%eax
  800bf3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800bf6:	c1 e9 02             	shr    $0x2,%ecx
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	fc                   	cld    
  800bfd:	f3 ab                	repz stos %eax,%es:(%edi)
  800bff:	eb 06                	jmp    800c07 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	fc                   	cld    
  800c05:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800c07:	89 f8                	mov    %edi,%eax
}
  800c09:	5f                   	pop    %edi
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800c17:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c1a:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c1c:	39 c6                	cmp    %eax,%esi
  800c1e:	73 33                	jae    800c53 <memmove+0x47>
  800c20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c23:	39 c2                	cmp    %eax,%edx
  800c25:	76 2c                	jbe    800c53 <memmove+0x47>
		s += n;
  800c27:	89 d6                	mov    %edx,%esi
		d += n;
  800c29:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2c:	f6 c2 03             	test   $0x3,%dl
  800c2f:	75 1b                	jne    800c4c <memmove+0x40>
  800c31:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c37:	75 13                	jne    800c4c <memmove+0x40>
  800c39:	f6 c1 03             	test   $0x3,%cl
  800c3c:	75 0e                	jne    800c4c <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800c3e:	83 ef 04             	sub    $0x4,%edi
  800c41:	83 ee 04             	sub    $0x4,%esi
  800c44:	c1 e9 02             	shr    $0x2,%ecx
  800c47:	fd                   	std    
  800c48:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800c4a:	eb 27                	jmp    800c73 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c4c:	4f                   	dec    %edi
  800c4d:	4e                   	dec    %esi
  800c4e:	fd                   	std    
  800c4f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800c51:	eb 20                	jmp    800c73 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c53:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c59:	75 15                	jne    800c70 <memmove+0x64>
  800c5b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c61:	75 0d                	jne    800c70 <memmove+0x64>
  800c63:	f6 c1 03             	test   $0x3,%cl
  800c66:	75 08                	jne    800c70 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800c68:	c1 e9 02             	shr    $0x2,%ecx
  800c6b:	fc                   	cld    
  800c6c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800c6e:	eb 03                	jmp    800c73 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c70:	fc                   	cld    
  800c71:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <memcpy>:

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
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c7a:	ff 75 10             	pushl  0x10(%ebp)
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	ff 75 08             	pushl  0x8(%ebp)
  800c83:	e8 84 ff ff ff       	call   800c0c <memmove>
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800c91:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c94:	8b 55 10             	mov    0x10(%ebp),%edx
  800c97:	4a                   	dec    %edx
  800c98:	83 fa ff             	cmp    $0xffffffff,%edx
  800c9b:	74 1a                	je     800cb7 <memcmp+0x2d>
  800c9d:	8a 01                	mov    (%ecx),%al
  800c9f:	3a 03                	cmp    (%ebx),%al
  800ca1:	74 0c                	je     800caf <memcmp+0x25>
  800ca3:	0f b6 d0             	movzbl %al,%edx
  800ca6:	0f b6 03             	movzbl (%ebx),%eax
  800ca9:	29 c2                	sub    %eax,%edx
  800cab:	89 d0                	mov    %edx,%eax
  800cad:	eb 0d                	jmp    800cbc <memcmp+0x32>
  800caf:	41                   	inc    %ecx
  800cb0:	43                   	inc    %ebx
  800cb1:	4a                   	dec    %edx
  800cb2:	83 fa ff             	cmp    $0xffffffff,%edx
  800cb5:	75 e6                	jne    800c9d <memcmp+0x13>
	}

	return 0;
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	c9                   	leave  
  800cbe:	c3                   	ret    

00800cbf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cc8:	89 c2                	mov    %eax,%edx
  800cca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ccd:	39 d0                	cmp    %edx,%eax
  800ccf:	73 09                	jae    800cda <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cd1:	38 08                	cmp    %cl,(%eax)
  800cd3:	74 05                	je     800cda <memfind+0x1b>
  800cd5:	40                   	inc    %eax
  800cd6:	39 d0                	cmp    %edx,%eax
  800cd8:	72 f7                	jb     800cd1 <memfind+0x12>
			break;
	return (void *) s;
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800ceb:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800cf0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800cf5:	80 3a 20             	cmpb   $0x20,(%edx)
  800cf8:	74 05                	je     800cff <strtol+0x23>
  800cfa:	80 3a 09             	cmpb   $0x9,(%edx)
  800cfd:	75 0b                	jne    800d0a <strtol+0x2e>
  800cff:	42                   	inc    %edx
  800d00:	80 3a 20             	cmpb   $0x20,(%edx)
  800d03:	74 fa                	je     800cff <strtol+0x23>
  800d05:	80 3a 09             	cmpb   $0x9,(%edx)
  800d08:	74 f5                	je     800cff <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800d0a:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800d0d:	75 03                	jne    800d12 <strtol+0x36>
		s++;
  800d0f:	42                   	inc    %edx
  800d10:	eb 0b                	jmp    800d1d <strtol+0x41>
	else if (*s == '-')
  800d12:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800d15:	75 06                	jne    800d1d <strtol+0x41>
		s++, neg = 1;
  800d17:	42                   	inc    %edx
  800d18:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1d:	85 c9                	test   %ecx,%ecx
  800d1f:	74 05                	je     800d26 <strtol+0x4a>
  800d21:	83 f9 10             	cmp    $0x10,%ecx
  800d24:	75 15                	jne    800d3b <strtol+0x5f>
  800d26:	80 3a 30             	cmpb   $0x30,(%edx)
  800d29:	75 10                	jne    800d3b <strtol+0x5f>
  800d2b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d2f:	75 0a                	jne    800d3b <strtol+0x5f>
		s += 2, base = 16;
  800d31:	83 c2 02             	add    $0x2,%edx
  800d34:	b9 10 00 00 00       	mov    $0x10,%ecx
  800d39:	eb 14                	jmp    800d4f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800d3b:	85 c9                	test   %ecx,%ecx
  800d3d:	75 10                	jne    800d4f <strtol+0x73>
  800d3f:	80 3a 30             	cmpb   $0x30,(%edx)
  800d42:	75 05                	jne    800d49 <strtol+0x6d>
		s++, base = 8;
  800d44:	42                   	inc    %edx
  800d45:	b1 08                	mov    $0x8,%cl
  800d47:	eb 06                	jmp    800d4f <strtol+0x73>
	else if (base == 0)
  800d49:	85 c9                	test   %ecx,%ecx
  800d4b:	75 02                	jne    800d4f <strtol+0x73>
		base = 10;
  800d4d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d4f:	8a 02                	mov    (%edx),%al
  800d51:	83 e8 30             	sub    $0x30,%eax
  800d54:	3c 09                	cmp    $0x9,%al
  800d56:	77 08                	ja     800d60 <strtol+0x84>
			dig = *s - '0';
  800d58:	0f be 02             	movsbl (%edx),%eax
  800d5b:	83 e8 30             	sub    $0x30,%eax
  800d5e:	eb 20                	jmp    800d80 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800d60:	8a 02                	mov    (%edx),%al
  800d62:	83 e8 61             	sub    $0x61,%eax
  800d65:	3c 19                	cmp    $0x19,%al
  800d67:	77 08                	ja     800d71 <strtol+0x95>
			dig = *s - 'a' + 10;
  800d69:	0f be 02             	movsbl (%edx),%eax
  800d6c:	83 e8 57             	sub    $0x57,%eax
  800d6f:	eb 0f                	jmp    800d80 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800d71:	8a 02                	mov    (%edx),%al
  800d73:	83 e8 41             	sub    $0x41,%eax
  800d76:	3c 19                	cmp    $0x19,%al
  800d78:	77 12                	ja     800d8c <strtol+0xb0>
			dig = *s - 'A' + 10;
  800d7a:	0f be 02             	movsbl (%edx),%eax
  800d7d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800d80:	39 c8                	cmp    %ecx,%eax
  800d82:	7d 08                	jge    800d8c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800d84:	42                   	inc    %edx
  800d85:	0f af d9             	imul   %ecx,%ebx
  800d88:	01 c3                	add    %eax,%ebx
  800d8a:	eb c3                	jmp    800d4f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d8c:	85 f6                	test   %esi,%esi
  800d8e:	74 02                	je     800d92 <strtol+0xb6>
		*endptr = (char *) s;
  800d90:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d92:	89 d8                	mov    %ebx,%eax
  800d94:	85 ff                	test   %edi,%edi
  800d96:	74 02                	je     800d9a <strtol+0xbe>
  800d98:	f7 d8                	neg    %eax
}
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    
	...

00800da0 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 04             	sub    $0x4,%esp
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daf:	bf 00 00 00 00       	mov    $0x0,%edi
  800db4:	89 f8                	mov    %edi,%eax
  800db6:	89 fb                	mov    %edi,%ebx
  800db8:	89 fe                	mov    %edi,%esi
  800dba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dbc:	83 c4 04             	add    $0x4,%esp
  800dbf:	5b                   	pop    %ebx
  800dc0:	5e                   	pop    %esi
  800dc1:	5f                   	pop    %edi
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	b8 01 00 00 00       	mov    $0x1,%eax
  800dcf:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd4:	89 fa                	mov    %edi,%edx
  800dd6:	89 f9                	mov    %edi,%ecx
  800dd8:	89 fb                	mov    %edi,%ebx
  800dda:	89 fe                	mov    %edi,%esi
  800ddc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	b8 03 00 00 00       	mov    $0x3,%eax
  800df4:	bf 00 00 00 00       	mov    $0x0,%edi
  800df9:	89 f9                	mov    %edi,%ecx
  800dfb:	89 fb                	mov    %edi,%ebx
  800dfd:	89 fe                	mov    %edi,%esi
  800dff:	cd 30                	int    $0x30
  800e01:	85 c0                	test   %eax,%eax
  800e03:	7e 17                	jle    800e1c <sys_env_destroy+0x39>
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	50                   	push   %eax
  800e09:	6a 03                	push   $0x3
  800e0b:	68 e0 2a 80 00       	push   $0x802ae0
  800e10:	6a 23                	push   $0x23
  800e12:	68 fd 2a 80 00       	push   $0x802afd
  800e17:	e8 a8 f4 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e1c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
  800e2a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e34:	89 fa                	mov    %edi,%edx
  800e36:	89 f9                	mov    %edi,%ecx
  800e38:	89 fb                	mov    %edi,%ebx
  800e3a:	89 fe                	mov    %edi,%esi
  800e3c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e3e:	5b                   	pop    %ebx
  800e3f:	5e                   	pop    %esi
  800e40:	5f                   	pop    %edi
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <sys_yield>:

void
sys_yield(void)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800e53:	89 fa                	mov    %edi,%edx
  800e55:	89 f9                	mov    %edi,%ecx
  800e57:	89 fb                	mov    %edi,%ebx
  800e59:	89 fe                	mov    %edi,%esi
  800e5b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	53                   	push   %ebx
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e74:	b8 04 00 00 00       	mov    $0x4,%eax
  800e79:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7e:	89 fe                	mov    %edi,%esi
  800e80:	cd 30                	int    $0x30
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7e 17                	jle    800e9d <sys_page_alloc+0x3b>
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 04                	push   $0x4
  800e8c:	68 e0 2a 80 00       	push   $0x802ae0
  800e91:	6a 23                	push   $0x23
  800e93:	68 fd 2a 80 00       	push   $0x802afd
  800e98:	e8 27 f4 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e9d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eba:	8b 75 18             	mov    0x18(%ebp),%esi
  800ebd:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec2:	cd 30                	int    $0x30
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7e 17                	jle    800edf <sys_page_map+0x3a>
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 05                	push   $0x5
  800ece:	68 e0 2a 80 00       	push   $0x802ae0
  800ed3:	6a 23                	push   $0x23
  800ed5:	68 fd 2a 80 00       	push   $0x802afd
  800eda:	e8 e5 f3 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800edf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	83 ec 0c             	sub    $0xc,%esp
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	b8 06 00 00 00       	mov    $0x6,%eax
  800efb:	bf 00 00 00 00       	mov    $0x0,%edi
  800f00:	89 fb                	mov    %edi,%ebx
  800f02:	89 fe                	mov    %edi,%esi
  800f04:	cd 30                	int    $0x30
  800f06:	85 c0                	test   %eax,%eax
  800f08:	7e 17                	jle    800f21 <sys_page_unmap+0x3a>
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	6a 06                	push   $0x6
  800f10:	68 e0 2a 80 00       	push   $0x802ae0
  800f15:	6a 23                	push   $0x23
  800f17:	68 fd 2a 80 00       	push   $0x802afd
  800f1c:	e8 a3 f3 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f21:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 08 00 00 00       	mov    $0x8,%eax
  800f3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800f42:	89 fb                	mov    %edi,%ebx
  800f44:	89 fe                	mov    %edi,%esi
  800f46:	cd 30                	int    $0x30
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	7e 17                	jle    800f63 <sys_env_set_status+0x3a>
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	50                   	push   %eax
  800f50:	6a 08                	push   $0x8
  800f52:	68 e0 2a 80 00       	push   $0x802ae0
  800f57:	6a 23                	push   $0x23
  800f59:	68 fd 2a 80 00       	push   $0x802afd
  800f5e:	e8 61 f3 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f63:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800f7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800f84:	89 fb                	mov    %edi,%ebx
  800f86:	89 fe                	mov    %edi,%esi
  800f88:	cd 30                	int    $0x30
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	7e 17                	jle    800fa5 <sys_env_set_trapframe+0x3a>
  800f8e:	83 ec 0c             	sub    $0xc,%esp
  800f91:	50                   	push   %eax
  800f92:	6a 09                	push   $0x9
  800f94:	68 e0 2a 80 00       	push   $0x802ae0
  800f99:	6a 23                	push   $0x23
  800f9b:	68 fd 2a 80 00       	push   $0x802afd
  800fa0:	e8 1f f3 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fa5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc1:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc6:	89 fb                	mov    %edi,%ebx
  800fc8:	89 fe                	mov    %edi,%esi
  800fca:	cd 30                	int    $0x30
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	7e 17                	jle    800fe7 <sys_env_set_pgfault_upcall+0x3a>
  800fd0:	83 ec 0c             	sub    $0xc,%esp
  800fd3:	50                   	push   %eax
  800fd4:	6a 0a                	push   $0xa
  800fd6:	68 e0 2a 80 00       	push   $0x802ae0
  800fdb:	6a 23                	push   $0x23
  800fdd:	68 fd 2a 80 00       	push   $0x802afd
  800fe2:	e8 dd f2 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fe7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fea:	5b                   	pop    %ebx
  800feb:	5e                   	pop    %esi
  800fec:	5f                   	pop    %edi
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	57                   	push   %edi
  800ff3:	56                   	push   %esi
  800ff4:	53                   	push   %ebx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ffe:	8b 7d 14             	mov    0x14(%ebp),%edi
  801001:	b8 0c 00 00 00       	mov    $0xc,%eax
  801006:	be 00 00 00 00       	mov    $0x0,%esi
  80100b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80100d:	5b                   	pop    %ebx
  80100e:	5e                   	pop    %esi
  80100f:	5f                   	pop    %edi
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	57                   	push   %edi
  801016:	56                   	push   %esi
  801017:	53                   	push   %ebx
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
  80101e:	b8 0d 00 00 00       	mov    $0xd,%eax
  801023:	bf 00 00 00 00       	mov    $0x0,%edi
  801028:	89 f9                	mov    %edi,%ecx
  80102a:	89 fb                	mov    %edi,%ebx
  80102c:	89 fe                	mov    %edi,%esi
  80102e:	cd 30                	int    $0x30
  801030:	85 c0                	test   %eax,%eax
  801032:	7e 17                	jle    80104b <sys_ipc_recv+0x39>
  801034:	83 ec 0c             	sub    $0xc,%esp
  801037:	50                   	push   %eax
  801038:	6a 0d                	push   $0xd
  80103a:	68 e0 2a 80 00       	push   $0x802ae0
  80103f:	6a 23                	push   $0x23
  801041:	68 fd 2a 80 00       	push   $0x802afd
  801046:	e8 79 f2 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80104b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
  801059:	83 ec 0c             	sub    $0xc,%esp
  80105c:	8b 55 08             	mov    0x8(%ebp),%edx
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801062:	b8 10 00 00 00       	mov    $0x10,%eax
  801067:	bf 00 00 00 00       	mov    $0x0,%edi
  80106c:	89 fb                	mov    %edi,%ebx
  80106e:	89 fe                	mov    %edi,%esi
  801070:	cd 30                	int    $0x30
  801072:	85 c0                	test   %eax,%eax
  801074:	7e 17                	jle    80108d <sys_transmit_packet+0x3a>
  801076:	83 ec 0c             	sub    $0xc,%esp
  801079:	50                   	push   %eax
  80107a:	6a 10                	push   $0x10
  80107c:	68 e0 2a 80 00       	push   $0x802ae0
  801081:	6a 23                	push   $0x23
  801083:	68 fd 2a 80 00       	push   $0x802afd
  801088:	e8 37 f2 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  80108d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	57                   	push   %edi
  801099:	56                   	push   %esi
  80109a:	53                   	push   %ebx
  80109b:	83 ec 0c             	sub    $0xc,%esp
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a4:	b8 11 00 00 00       	mov    $0x11,%eax
  8010a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ae:	89 fb                	mov    %edi,%ebx
  8010b0:	89 fe                	mov    %edi,%esi
  8010b2:	cd 30                	int    $0x30
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	7e 17                	jle    8010cf <sys_receive_packet+0x3a>
  8010b8:	83 ec 0c             	sub    $0xc,%esp
  8010bb:	50                   	push   %eax
  8010bc:	6a 11                	push   $0x11
  8010be:	68 e0 2a 80 00       	push   $0x802ae0
  8010c3:	6a 23                	push   $0x23
  8010c5:	68 fd 2a 80 00       	push   $0x802afd
  8010ca:	e8 f5 f1 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  8010cf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	57                   	push   %edi
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
  8010dd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8010e7:	89 fa                	mov    %edi,%edx
  8010e9:	89 f9                	mov    %edi,%ecx
  8010eb:	89 fb                	mov    %edi,%ebx
  8010ed:	89 fe                	mov    %edi,%esi
  8010ef:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010f1:	5b                   	pop    %ebx
  8010f2:	5e                   	pop    %esi
  8010f3:	5f                   	pop    %edi
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801102:	b8 0e 00 00 00       	mov    $0xe,%eax
  801107:	bf 00 00 00 00       	mov    $0x0,%edi
  80110c:	89 f9                	mov    %edi,%ecx
  80110e:	89 fb                	mov    %edi,%ebx
  801110:	89 fe                	mov    %edi,%esi
  801112:	cd 30                	int    $0x30
  801114:	85 c0                	test   %eax,%eax
  801116:	7e 17                	jle    80112f <sys_map_receive_buffers+0x39>
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	50                   	push   %eax
  80111c:	6a 0e                	push   $0xe
  80111e:	68 e0 2a 80 00       	push   $0x802ae0
  801123:	6a 23                	push   $0x23
  801125:	68 fd 2a 80 00       	push   $0x802afd
  80112a:	e8 95 f1 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  80112f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	8b 55 08             	mov    0x8(%ebp),%edx
  801143:	b8 12 00 00 00       	mov    $0x12,%eax
  801148:	bf 00 00 00 00       	mov    $0x0,%edi
  80114d:	89 f9                	mov    %edi,%ecx
  80114f:	89 fb                	mov    %edi,%ebx
  801151:	89 fe                	mov    %edi,%esi
  801153:	cd 30                	int    $0x30
  801155:	85 c0                	test   %eax,%eax
  801157:	7e 17                	jle    801170 <sys_receive_packet_zerocopy+0x39>
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	50                   	push   %eax
  80115d:	6a 12                	push   $0x12
  80115f:	68 e0 2a 80 00       	push   $0x802ae0
  801164:	6a 23                	push   $0x23
  801166:	68 fd 2a 80 00       	push   $0x802afd
  80116b:	e8 54 f1 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  801170:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801173:	5b                   	pop    %ebx
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	57                   	push   %edi
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
  80117e:	83 ec 0c             	sub    $0xc,%esp
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
  801184:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801187:	b8 13 00 00 00       	mov    $0x13,%eax
  80118c:	bf 00 00 00 00       	mov    $0x0,%edi
  801191:	89 fb                	mov    %edi,%ebx
  801193:	89 fe                	mov    %edi,%esi
  801195:	cd 30                	int    $0x30
  801197:	85 c0                	test   %eax,%eax
  801199:	7e 17                	jle    8011b2 <sys_env_set_priority+0x3a>
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	50                   	push   %eax
  80119f:	6a 13                	push   $0x13
  8011a1:	68 e0 2a 80 00       	push   $0x802ae0
  8011a6:	6a 23                	push   $0x23
  8011a8:	68 fd 2a 80 00       	push   $0x802afd
  8011ad:	e8 12 f1 ff ff       	call   8002c4 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8011b2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8011b5:	5b                   	pop    %ebx
  8011b6:	5e                   	pop    %esi
  8011b7:	5f                   	pop    %edi
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    
	...

008011bc <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8011c2:	ff 75 08             	pushl  0x8(%ebp)
  8011c5:	e8 0a 00 00 00       	call   8011d4 <fd2num>
  8011ca:	c1 e0 16             	shl    $0x16,%eax
  8011cd:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	05 00 00 40 30       	add    $0x30400000,%eax
  8011df:	c1 e8 0c             	shr    $0xc,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <fd_alloc>:

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
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	57                   	push   %edi
  8011e8:	56                   	push   %esi
  8011e9:	53                   	push   %ebx
  8011ea:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f2:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  8011f7:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  8011fc:	89 c8                	mov    %ecx,%eax
  8011fe:	c1 e0 0c             	shl    $0xc,%eax
  801201:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801207:	89 d0                	mov    %edx,%eax
  801209:	c1 e8 16             	shr    $0x16,%eax
  80120c:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80120f:	a8 01                	test   $0x1,%al
  801211:	74 0c                	je     80121f <fd_alloc+0x3b>
  801213:	89 d0                	mov    %edx,%eax
  801215:	c1 e8 0c             	shr    $0xc,%eax
  801218:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  80121b:	a8 01                	test   $0x1,%al
  80121d:	75 09                	jne    801228 <fd_alloc+0x44>
			*fd_store = fd;
  80121f:	89 17                	mov    %edx,(%edi)
			return 0;
  801221:	b8 00 00 00 00       	mov    $0x0,%eax
  801226:	eb 11                	jmp    801239 <fd_alloc+0x55>
  801228:	41                   	inc    %ecx
  801229:	83 f9 1f             	cmp    $0x1f,%ecx
  80122c:	7e ce                	jle    8011fc <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80122e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801234:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5f                   	pop    %edi
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801244:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801249:	83 f8 1f             	cmp    $0x1f,%eax
  80124c:	77 3a                	ja     801288 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80124e:	c1 e0 0c             	shl    $0xc,%eax
  801251:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801257:	89 d0                	mov    %edx,%eax
  801259:	c1 e8 16             	shr    $0x16,%eax
  80125c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801263:	a8 01                	test   $0x1,%al
  801265:	74 10                	je     801277 <fd_lookup+0x39>
  801267:	89 d0                	mov    %edx,%eax
  801269:	c1 e8 0c             	shr    $0xc,%eax
  80126c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801273:	a8 01                	test   $0x1,%al
  801275:	75 07                	jne    80127e <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801277:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80127c:	eb 0a                	jmp    801288 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801281:	89 10                	mov    %edx,(%eax)
	return 0;
  801283:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801288:	89 d0                	mov    %edx,%eax
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <fd_close>:

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
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	83 ec 10             	sub    $0x10,%esp
  801294:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801297:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80129a:	50                   	push   %eax
  80129b:	56                   	push   %esi
  80129c:	e8 33 ff ff ff       	call   8011d4 <fd2num>
  8012a1:	89 04 24             	mov    %eax,(%esp)
  8012a4:	e8 95 ff ff ff       	call   80123e <fd_lookup>
  8012a9:	89 c3                	mov    %eax,%ebx
  8012ab:	83 c4 08             	add    $0x8,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 05                	js     8012b7 <fd_close+0x2b>
  8012b2:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8012b5:	74 0f                	je     8012c6 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8012b7:	89 d8                	mov    %ebx,%eax
  8012b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012bd:	75 3a                	jne    8012f9 <fd_close+0x6d>
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c4:	eb 33                	jmp    8012f9 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8012c6:	83 ec 08             	sub    $0x8,%esp
  8012c9:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	ff 36                	pushl  (%esi)
  8012cf:	e8 2c 00 00 00       	call   801300 <dev_lookup>
  8012d4:	89 c3                	mov    %eax,%ebx
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 0f                	js     8012ec <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	56                   	push   %esi
  8012e1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8012e4:	ff 50 10             	call   *0x10(%eax)
  8012e7:	89 c3                	mov    %eax,%ebx
  8012e9:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	56                   	push   %esi
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 f0 fb ff ff       	call   800ee7 <sys_page_unmap>
	return r;
  8012f7:	89 d8                	mov    %ebx,%eax
}
  8012f9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8012fc:	5b                   	pop    %ebx
  8012fd:	5e                   	pop    %esi
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <dev_lookup>:


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
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	56                   	push   %esi
  801304:	53                   	push   %ebx
  801305:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801308:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  80130b:	ba 00 00 00 00       	mov    $0x0,%edx
  801310:	83 3d 24 60 80 00 00 	cmpl   $0x0,0x806024
  801317:	74 1c                	je     801335 <dev_lookup+0x35>
  801319:	b9 24 60 80 00       	mov    $0x806024,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80131e:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801321:	39 18                	cmp    %ebx,(%eax)
  801323:	75 09                	jne    80132e <dev_lookup+0x2e>
			*dev = devtab[i];
  801325:	89 06                	mov    %eax,(%esi)
			return 0;
  801327:	b8 00 00 00 00       	mov    $0x0,%eax
  80132c:	eb 29                	jmp    801357 <dev_lookup+0x57>
  80132e:	42                   	inc    %edx
  80132f:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801333:	75 e9                	jne    80131e <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801335:	83 ec 04             	sub    $0x4,%esp
  801338:	53                   	push   %ebx
  801339:	a1 80 64 80 00       	mov    0x806480,%eax
  80133e:	8b 40 4c             	mov    0x4c(%eax),%eax
  801341:	50                   	push   %eax
  801342:	68 0c 2b 80 00       	push   $0x802b0c
  801347:	e8 68 f0 ff ff       	call   8003b4 <cprintf>
	*dev = 0;
  80134c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801352:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801357:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80135a:	5b                   	pop    %ebx
  80135b:	5e                   	pop    %esi
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <close>:

int
close(int fdnum)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801364:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801367:	50                   	push   %eax
  801368:	ff 75 08             	pushl  0x8(%ebp)
  80136b:	e8 ce fe ff ff       	call   80123e <fd_lookup>
  801370:	83 c4 08             	add    $0x8,%esp
		return r;
  801373:	89 c2                	mov    %eax,%edx
  801375:	85 c0                	test   %eax,%eax
  801377:	78 0f                	js     801388 <close+0x2a>
	else
		return fd_close(fd, 1);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	6a 01                	push   $0x1
  80137e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801381:	e8 06 ff ff ff       	call   80128c <fd_close>
  801386:	89 c2                	mov    %eax,%edx
}
  801388:	89 d0                	mov    %edx,%eax
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <close_all>:

void
close_all(void)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	53                   	push   %ebx
  801390:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801393:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801398:	83 ec 0c             	sub    $0xc,%esp
  80139b:	53                   	push   %ebx
  80139c:	e8 bd ff ff ff       	call   80135e <close>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	43                   	inc    %ebx
  8013a5:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a8:	7e ee                	jle    801398 <close_all+0xc>
}
  8013aa:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	57                   	push   %edi
  8013b3:	56                   	push   %esi
  8013b4:	53                   	push   %ebx
  8013b5:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013b8:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8013bb:	50                   	push   %eax
  8013bc:	ff 75 08             	pushl  0x8(%ebp)
  8013bf:	e8 7a fe ff ff       	call   80123e <fd_lookup>
  8013c4:	89 c6                	mov    %eax,%esi
  8013c6:	83 c4 08             	add    $0x8,%esp
  8013c9:	85 f6                	test   %esi,%esi
  8013cb:	0f 88 f8 00 00 00    	js     8014c9 <dup+0x11a>
		return r;
	close(newfdnum);
  8013d1:	83 ec 0c             	sub    $0xc,%esp
  8013d4:	ff 75 0c             	pushl  0xc(%ebp)
  8013d7:	e8 82 ff ff ff       	call   80135e <close>

	newfd = INDEX2FD(newfdnum);
  8013dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013df:	c1 e0 0c             	shl    $0xc,%eax
  8013e2:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8013e7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8013ea:	83 c4 04             	add    $0x4,%esp
  8013ed:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8013f0:	e8 c7 fd ff ff       	call   8011bc <fd2data>
  8013f5:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8013f7:	83 c4 04             	add    $0x4,%esp
  8013fa:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8013fd:	e8 ba fd ff ff       	call   8011bc <fd2data>
  801402:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801405:	89 f8                	mov    %edi,%eax
  801407:	c1 e8 16             	shr    $0x16,%eax
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801414:	85 c0                	test   %eax,%eax
  801416:	74 48                	je     801460 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801418:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  80141d:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801420:	89 d0                	mov    %edx,%eax
  801422:	c1 e8 0c             	shr    $0xc,%eax
  801425:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  80142c:	a8 01                	test   $0x1,%al
  80142e:	74 22                	je     801452 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	25 07 0e 00 00       	and    $0xe07,%eax
  801438:	50                   	push   %eax
  801439:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80143c:	01 d8                	add    %ebx,%eax
  80143e:	50                   	push   %eax
  80143f:	6a 00                	push   $0x0
  801441:	52                   	push   %edx
  801442:	6a 00                	push   $0x0
  801444:	e8 5c fa ff ff       	call   800ea5 <sys_page_map>
  801449:	89 c6                	mov    %eax,%esi
  80144b:	83 c4 20             	add    $0x20,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 3f                	js     801491 <dup+0xe2>
  801452:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801458:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80145e:	7e bd                	jle    80141d <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801460:	83 ec 0c             	sub    $0xc,%esp
  801463:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801466:	89 d0                	mov    %edx,%eax
  801468:	c1 e8 0c             	shr    $0xc,%eax
  80146b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801472:	25 07 0e 00 00       	and    $0xe07,%eax
  801477:	50                   	push   %eax
  801478:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80147b:	6a 00                	push   $0x0
  80147d:	52                   	push   %edx
  80147e:	6a 00                	push   $0x0
  801480:	e8 20 fa ff ff       	call   800ea5 <sys_page_map>
  801485:	89 c6                	mov    %eax,%esi
  801487:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	85 f6                	test   %esi,%esi
  80148f:	79 38                	jns    8014c9 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801497:	6a 00                	push   $0x0
  801499:	e8 49 fa ff ff       	call   800ee7 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80149e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a3:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8014a6:	83 ec 08             	sub    $0x8,%esp
  8014a9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8014ac:	01 d8                	add    %ebx,%eax
  8014ae:	50                   	push   %eax
  8014af:	6a 00                	push   $0x0
  8014b1:	e8 31 fa ff ff       	call   800ee7 <sys_page_unmap>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014bf:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8014c5:	7e df                	jle    8014a6 <dup+0xf7>
	return r;
  8014c7:	89 f0                	mov    %esi,%eax
}
  8014c9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8014cc:	5b                   	pop    %ebx
  8014cd:	5e                   	pop    %esi
  8014ce:	5f                   	pop    %edi
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 14             	sub    $0x14,%esp
  8014d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014db:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	53                   	push   %ebx
  8014e0:	e8 59 fd ff ff       	call   80123e <fd_lookup>
  8014e5:	89 c2                	mov    %eax,%edx
  8014e7:	83 c4 08             	add    $0x8,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 1a                	js     801508 <read+0x37>
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014f8:	ff 30                	pushl  (%eax)
  8014fa:	e8 01 fe ff ff       	call   801300 <dev_lookup>
  8014ff:	89 c2                	mov    %eax,%edx
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	79 04                	jns    80150c <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801508:	89 d0                	mov    %edx,%eax
  80150a:	eb 50                	jmp    80155c <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80150c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80150f:	8b 40 08             	mov    0x8(%eax),%eax
  801512:	83 e0 03             	and    $0x3,%eax
  801515:	83 f8 01             	cmp    $0x1,%eax
  801518:	75 1e                	jne    801538 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	53                   	push   %ebx
  80151e:	a1 80 64 80 00       	mov    0x806480,%eax
  801523:	8b 40 4c             	mov    0x4c(%eax),%eax
  801526:	50                   	push   %eax
  801527:	68 4d 2b 80 00       	push   $0x802b4d
  80152c:	e8 83 ee ff ff       	call   8003b4 <cprintf>
		return -E_INVAL;
  801531:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801536:	eb 24                	jmp    80155c <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801538:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80153b:	ff 70 04             	pushl  0x4(%eax)
  80153e:	ff 75 10             	pushl  0x10(%ebp)
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	50                   	push   %eax
  801545:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801548:	ff 50 08             	call   *0x8(%eax)
  80154b:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	78 06                	js     80155a <read+0x89>
		fd->fd_offset += r;
  801554:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801557:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80155a:	89 d0                	mov    %edx,%eax
}
  80155c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	57                   	push   %edi
  801565:	56                   	push   %esi
  801566:	53                   	push   %ebx
  801567:	83 ec 0c             	sub    $0xc,%esp
  80156a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80156d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801570:	bb 00 00 00 00       	mov    $0x0,%ebx
  801575:	39 f3                	cmp    %esi,%ebx
  801577:	73 25                	jae    80159e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	89 f0                	mov    %esi,%eax
  80157e:	29 d8                	sub    %ebx,%eax
  801580:	50                   	push   %eax
  801581:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801584:	50                   	push   %eax
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	e8 44 ff ff ff       	call   8014d1 <read>
		if (m < 0)
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 0c                	js     8015a0 <readn+0x3f>
			return m;
		if (m == 0)
  801594:	85 c0                	test   %eax,%eax
  801596:	74 06                	je     80159e <readn+0x3d>
  801598:	01 c3                	add    %eax,%ebx
  80159a:	39 f3                	cmp    %esi,%ebx
  80159c:	72 db                	jb     801579 <readn+0x18>
			break;
	}
	return tot;
  80159e:	89 d8                	mov    %ebx,%eax
}
  8015a0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5f                   	pop    %edi
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	53                   	push   %ebx
  8015ac:	83 ec 14             	sub    $0x14,%esp
  8015af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b2:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8015b5:	50                   	push   %eax
  8015b6:	53                   	push   %ebx
  8015b7:	e8 82 fc ff ff       	call   80123e <fd_lookup>
  8015bc:	89 c2                	mov    %eax,%edx
  8015be:	83 c4 08             	add    $0x8,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 1a                	js     8015df <write+0x37>
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8015cb:	50                   	push   %eax
  8015cc:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015cf:	ff 30                	pushl  (%eax)
  8015d1:	e8 2a fd ff ff       	call   801300 <dev_lookup>
  8015d6:	89 c2                	mov    %eax,%edx
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	79 04                	jns    8015e3 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8015df:	89 d0                	mov    %edx,%eax
  8015e1:	eb 4b                	jmp    80162e <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ea:	75 1e                	jne    80160a <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	53                   	push   %ebx
  8015f0:	a1 80 64 80 00       	mov    0x806480,%eax
  8015f5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015f8:	50                   	push   %eax
  8015f9:	68 69 2b 80 00       	push   $0x802b69
  8015fe:	e8 b1 ed ff ff       	call   8003b4 <cprintf>
		return -E_INVAL;
  801603:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801608:	eb 24                	jmp    80162e <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  80160a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80160d:	ff 70 04             	pushl  0x4(%eax)
  801610:	ff 75 10             	pushl  0x10(%ebp)
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	50                   	push   %eax
  801617:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80161a:	ff 50 0c             	call   *0xc(%eax)
  80161d:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	85 c0                	test   %eax,%eax
  801624:	7e 06                	jle    80162c <write+0x84>
		fd->fd_offset += r;
  801626:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801629:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80162c:	89 d0                	mov    %edx,%eax
}
  80162e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <seek>:

int
seek(int fdnum, off_t offset)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801639:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80163c:	50                   	push   %eax
  80163d:	ff 75 08             	pushl  0x8(%ebp)
  801640:	e8 f9 fb ff ff       	call   80123e <fd_lookup>
  801645:	83 c4 08             	add    $0x8,%esp
		return r;
  801648:	89 c2                	mov    %eax,%edx
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 0e                	js     80165c <seek+0x29>
	fd->fd_offset = offset;
  80164e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801651:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801654:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801657:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80165c:	89 d0                	mov    %edx,%eax
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	53                   	push   %ebx
  801664:	83 ec 14             	sub    $0x14,%esp
  801667:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80166d:	50                   	push   %eax
  80166e:	53                   	push   %ebx
  80166f:	e8 ca fb ff ff       	call   80123e <fd_lookup>
  801674:	83 c4 08             	add    $0x8,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 4e                	js     8016c9 <ftruncate+0x69>
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801681:	50                   	push   %eax
  801682:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801685:	ff 30                	pushl  (%eax)
  801687:	e8 74 fc ff ff       	call   801300 <dev_lookup>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 36                	js     8016c9 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801693:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801696:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80169a:	75 1e                	jne    8016ba <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	53                   	push   %ebx
  8016a0:	a1 80 64 80 00       	mov    0x806480,%eax
  8016a5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016a8:	50                   	push   %eax
  8016a9:	68 2c 2b 80 00       	push   $0x802b2c
  8016ae:	e8 01 ed ff ff       	call   8003b4 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8016b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b8:	eb 0f                	jmp    8016c9 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	ff 75 0c             	pushl  0xc(%ebp)
  8016c0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8016c3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8016c6:	ff 50 1c             	call   *0x1c(%eax)
}
  8016c9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 14             	sub    $0x14,%esp
  8016d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d8:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8016db:	50                   	push   %eax
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	e8 5a fb ff ff       	call   80123e <fd_lookup>
  8016e4:	83 c4 08             	add    $0x8,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 42                	js     80172d <fstat+0x5f>
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016f1:	50                   	push   %eax
  8016f2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016f5:	ff 30                	pushl  (%eax)
  8016f7:	e8 04 fc ff ff       	call   801300 <dev_lookup>
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 2a                	js     80172d <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801703:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801706:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80170d:	00 00 00 
	stat->st_isdir = 0;
  801710:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801717:	00 00 00 
	stat->st_dev = dev;
  80171a:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80171d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	53                   	push   %ebx
  801727:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80172a:	ff 50 14             	call   *0x14(%eax)
}
  80172d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	56                   	push   %esi
  801736:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	6a 00                	push   $0x0
  80173c:	ff 75 08             	pushl  0x8(%ebp)
  80173f:	e8 28 00 00 00       	call   80176c <open>
  801744:	89 c6                	mov    %eax,%esi
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	85 f6                	test   %esi,%esi
  80174b:	78 18                	js     801765 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	56                   	push   %esi
  801754:	e8 75 ff ff ff       	call   8016ce <fstat>
  801759:	89 c3                	mov    %eax,%ebx
	close(fd);
  80175b:	89 34 24             	mov    %esi,(%esp)
  80175e:	e8 fb fb ff ff       	call   80135e <close>
	return r;
  801763:	89 d8                	mov    %ebx,%eax
}
  801765:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	53                   	push   %ebx
  801770:	83 ec 10             	sub    $0x10,%esp
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
  801773:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801776:	50                   	push   %eax
  801777:	e8 68 fa ff ff       	call   8011e4 <fd_alloc>
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	85 db                	test   %ebx,%ebx
  801783:	78 36                	js     8017bb <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80178b:	ff 75 0c             	pushl  0xc(%ebp)
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	e8 37 06 00 00       	call   801dcd <fsipc_open>
  801796:	89 c3                	mov    %eax,%ebx
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	79 11                	jns    8017b0 <open+0x44>
          fd_close(fd_store, 0);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	6a 00                	push   $0x0
  8017a4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8017a7:	e8 e0 fa ff ff       	call   80128c <fd_close>
          return r;
  8017ac:	89 d8                	mov    %ebx,%eax
  8017ae:	eb 0b                	jmp    8017bb <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  8017b0:	83 ec 0c             	sub    $0xc,%esp
  8017b3:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8017b6:	e8 19 fa ff ff       	call   8011d4 <fd2num>
}
  8017bb:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8017ca:	6a 01                	push   $0x1
  8017cc:	6a 00                	push   $0x0
  8017ce:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8017d4:	53                   	push   %ebx
  8017d5:	e8 e7 03 00 00       	call   801bc1 <funmap>
  8017da:	83 c4 10             	add    $0x10,%esp
          return r;
  8017dd:	89 c2                	mov    %eax,%edx
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 19                	js     8017fc <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8017e3:	83 ec 0c             	sub    $0xc,%esp
  8017e6:	ff 73 0c             	pushl  0xc(%ebx)
  8017e9:	e8 84 06 00 00       	call   801e72 <fsipc_close>
  8017ee:	83 c4 10             	add    $0x10,%esp
          return r;
  8017f1:	89 c2                	mov    %eax,%edx
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 05                	js     8017fc <file_close+0x3c>
        }
        return 0;
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017fc:	89 d0                	mov    %edx,%eax
  8017fe:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	57                   	push   %edi
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	83 ec 0c             	sub    $0xc,%esp
  80180c:	8b 75 10             	mov    0x10(%ebp),%esi
  80180f:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  80181b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801820:	39 d7                	cmp    %edx,%edi
  801822:	0f 87 95 00 00 00    	ja     8018bd <file_read+0xba>
	if (offset + n > size)
  801828:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80182b:	39 d0                	cmp    %edx,%eax
  80182d:	76 04                	jbe    801833 <file_read+0x30>
		n = size - offset;
  80182f:	89 d6                	mov    %edx,%esi
  801831:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801833:	83 ec 0c             	sub    $0xc,%esp
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	e8 7e f9 ff ff       	call   8011bc <fd2data>
  80183e:	89 c3                	mov    %eax,%ebx
  801840:	01 fb                	add    %edi,%ebx
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	eb 41                	jmp    801888 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801847:	89 d8                	mov    %ebx,%eax
  801849:	c1 e8 16             	shr    $0x16,%eax
  80184c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801853:	a8 01                	test   $0x1,%al
  801855:	74 10                	je     801867 <file_read+0x64>
  801857:	89 d8                	mov    %ebx,%eax
  801859:	c1 e8 0c             	shr    $0xc,%eax
  80185c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801863:	a8 01                	test   $0x1,%al
  801865:	75 1b                	jne    801882 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80186d:	50                   	push   %eax
  80186e:	57                   	push   %edi
  80186f:	ff 75 08             	pushl  0x8(%ebp)
  801872:	e8 d4 02 00 00       	call   801b4b <fmap>
  801877:	83 c4 10             	add    $0x10,%esp
              return r;
  80187a:	89 c1                	mov    %eax,%ecx
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 3d                	js     8018bd <file_read+0xba>
  801880:	eb 1c                	jmp    80189e <file_read+0x9b>
  801882:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801888:	83 ec 0c             	sub    $0xc,%esp
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 29 f9 ff ff       	call   8011bc <fd2data>
  801893:	01 f8                	add    %edi,%eax
  801895:	01 f0                	add    %esi,%eax
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	39 d8                	cmp    %ebx,%eax
  80189c:	77 a9                	ja     801847 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	56                   	push   %esi
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	e8 0f f9 ff ff       	call   8011bc <fd2data>
  8018ad:	83 c4 08             	add    $0x8,%esp
  8018b0:	01 f8                	add    %edi,%eax
  8018b2:	50                   	push   %eax
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	e8 51 f3 ff ff       	call   800c0c <memmove>
	return n;
  8018bb:	89 f1                	mov    %esi,%ecx
}
  8018bd:	89 c8                	mov    %ecx,%eax
  8018bf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	5f                   	pop    %edi
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	56                   	push   %esi
  8018cb:	53                   	push   %ebx
  8018cc:	83 ec 18             	sub    $0x18,%esp
  8018cf:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018d5:	50                   	push   %eax
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	e8 60 f9 ff ff       	call   80123e <fd_lookup>
  8018de:	83 c4 10             	add    $0x10,%esp
		return r;
  8018e1:	89 c2                	mov    %eax,%edx
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	0f 88 9f 00 00 00    	js     80198a <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8018eb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8018ee:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8018f0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8018f5:	3b 05 40 60 80 00    	cmp    0x806040,%eax
  8018fb:	0f 85 89 00 00 00    	jne    80198a <read_map+0xc3>
	va = fd2data(fd) + offset;
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801907:	e8 b0 f8 ff ff       	call   8011bc <fd2data>
  80190c:	89 c3                	mov    %eax,%ebx
  80190e:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801910:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801913:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801918:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  80191e:	7f 6a                	jg     80198a <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801920:	89 d8                	mov    %ebx,%eax
  801922:	c1 e8 16             	shr    $0x16,%eax
  801925:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80192c:	a8 01                	test   $0x1,%al
  80192e:	74 10                	je     801940 <read_map+0x79>
  801930:	89 d8                	mov    %ebx,%eax
  801932:	c1 e8 0c             	shr    $0xc,%eax
  801935:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80193c:	a8 01                	test   $0x1,%al
  80193e:	75 19                	jne    801959 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801940:	83 ec 04             	sub    $0x4,%esp
  801943:	8d 46 01             	lea    0x1(%esi),%eax
  801946:	50                   	push   %eax
  801947:	56                   	push   %esi
  801948:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80194b:	e8 fb 01 00 00       	call   801b4b <fmap>
  801950:	83 c4 10             	add    $0x10,%esp
            return r;
  801953:	89 c2                	mov    %eax,%edx
  801955:	85 c0                	test   %eax,%eax
  801957:	78 31                	js     80198a <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801959:	89 d8                	mov    %ebx,%eax
  80195b:	c1 e8 16             	shr    $0x16,%eax
  80195e:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801965:	a8 01                	test   $0x1,%al
  801967:	74 10                	je     801979 <read_map+0xb2>
  801969:	89 d8                	mov    %ebx,%eax
  80196b:	c1 e8 0c             	shr    $0xc,%eax
  80196e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801975:	a8 01                	test   $0x1,%al
  801977:	75 07                	jne    801980 <read_map+0xb9>
		return -E_NO_DISK;
  801979:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80197e:	eb 0a                	jmp    80198a <read_map+0xc3>

	*blk = (void*) va;
  801980:	8b 45 10             	mov    0x10(%ebp),%eax
  801983:	89 18                	mov    %ebx,(%eax)
	return 0;
  801985:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80198a:	89 d0                	mov    %edx,%eax
  80198c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	57                   	push   %edi
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
  801999:	83 ec 0c             	sub    $0xc,%esp
  80199c:	8b 75 08             	mov    0x8(%ebp),%esi
  80199f:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  8019a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a5:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  8019a8:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  8019ad:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8019b3:	0f 87 bd 00 00 00    	ja     801a76 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8019b9:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8019bf:	73 17                	jae    8019d8 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8019c1:	83 ec 08             	sub    $0x8,%esp
  8019c4:	52                   	push   %edx
  8019c5:	56                   	push   %esi
  8019c6:	e8 fb 00 00 00       	call   801ac6 <file_trunc>
  8019cb:	83 c4 10             	add    $0x10,%esp
			return r;
  8019ce:	89 c1                	mov    %eax,%ecx
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	0f 88 9e 00 00 00    	js     801a76 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	56                   	push   %esi
  8019dc:	e8 db f7 ff ff       	call   8011bc <fd2data>
  8019e1:	89 c3                	mov    %eax,%ebx
  8019e3:	01 fb                	add    %edi,%ebx
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	eb 42                	jmp    801a2c <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8019ea:	89 d8                	mov    %ebx,%eax
  8019ec:	c1 e8 16             	shr    $0x16,%eax
  8019ef:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8019f6:	a8 01                	test   $0x1,%al
  8019f8:	74 10                	je     801a0a <file_write+0x77>
  8019fa:	89 d8                	mov    %ebx,%eax
  8019fc:	c1 e8 0c             	shr    $0xc,%eax
  8019ff:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a06:	a8 01                	test   $0x1,%al
  801a08:	75 1c                	jne    801a26 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	8b 55 10             	mov    0x10(%ebp),%edx
  801a10:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801a13:	50                   	push   %eax
  801a14:	57                   	push   %edi
  801a15:	56                   	push   %esi
  801a16:	e8 30 01 00 00       	call   801b4b <fmap>
  801a1b:	83 c4 10             	add    $0x10,%esp
              return r;
  801a1e:	89 c1                	mov    %eax,%ecx
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 52                	js     801a76 <file_write+0xe3>
  801a24:	eb 1b                	jmp    801a41 <file_write+0xae>
  801a26:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	56                   	push   %esi
  801a30:	e8 87 f7 ff ff       	call   8011bc <fd2data>
  801a35:	01 f8                	add    %edi,%eax
  801a37:	03 45 10             	add    0x10(%ebp),%eax
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	39 d8                	cmp    %ebx,%eax
  801a3f:	77 a9                	ja     8019ea <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801a41:	83 ec 0c             	sub    $0xc,%esp
  801a44:	68 86 2b 80 00       	push   $0x802b86
  801a49:	e8 66 e9 ff ff       	call   8003b4 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801a4e:	83 c4 0c             	add    $0xc,%esp
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	56                   	push   %esi
  801a58:	e8 5f f7 ff ff       	call   8011bc <fd2data>
  801a5d:	01 f8                	add    %edi,%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 a5 f1 ff ff       	call   800c0c <memmove>
        cprintf("write done\n");
  801a67:	c7 04 24 93 2b 80 00 	movl   $0x802b93,(%esp)
  801a6e:	e8 41 e9 ff ff       	call   8003b4 <cprintf>
	return n;
  801a73:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801a76:	89 c8                	mov    %ecx,%eax
  801a78:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	56                   	push   %esi
  801a84:	53                   	push   %ebx
  801a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a88:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	8d 43 10             	lea    0x10(%ebx),%eax
  801a91:	50                   	push   %eax
  801a92:	56                   	push   %esi
  801a93:	e8 f8 ef ff ff       	call   800a90 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801a98:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801a9e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801aae:	0f 94 c0             	sete   %al
  801ab1:	0f b6 c0             	movzbl %al,%eax
  801ab4:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801aba:	b8 00 00 00 00       	mov    $0x0,%eax
  801abf:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ac2:	5b                   	pop    %ebx
  801ac3:	5e                   	pop    %esi
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	57                   	push   %edi
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	8b 75 08             	mov    0x8(%ebp),%esi
  801ad2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801ad5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801ada:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801ae0:	7f 5f                	jg     801b41 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801ae2:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	53                   	push   %ebx
  801aec:	ff 76 0c             	pushl  0xc(%esi)
  801aef:	e8 56 03 00 00       	call   801e4a <fsipc_set_size>
  801af4:	83 c4 10             	add    $0x10,%esp
		return r;
  801af7:	89 c2                	mov    %eax,%edx
  801af9:	85 c0                	test   %eax,%eax
  801afb:	78 44                	js     801b41 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801afd:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801b03:	74 19                	je     801b1e <file_trunc+0x58>
  801b05:	68 c0 2b 80 00       	push   $0x802bc0
  801b0a:	68 9f 2b 80 00       	push   $0x802b9f
  801b0f:	68 dc 00 00 00       	push   $0xdc
  801b14:	68 b4 2b 80 00       	push   $0x802bb4
  801b19:	e8 a6 e7 ff ff       	call   8002c4 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801b1e:	83 ec 04             	sub    $0x4,%esp
  801b21:	53                   	push   %ebx
  801b22:	57                   	push   %edi
  801b23:	56                   	push   %esi
  801b24:	e8 22 00 00 00       	call   801b4b <fmap>
  801b29:	83 c4 10             	add    $0x10,%esp
		return r;
  801b2c:	89 c2                	mov    %eax,%edx
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	78 0f                	js     801b41 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	53                   	push   %ebx
  801b35:	57                   	push   %edi
  801b36:	56                   	push   %esi
  801b37:	e8 85 00 00 00       	call   801bc1 <funmap>

	return 0;
  801b3c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5f                   	pop    %edi
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <fmap>:

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
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	57                   	push   %edi
  801b4f:	56                   	push   %esi
  801b50:	53                   	push   %ebx
  801b51:	83 ec 0c             	sub    $0xc,%esp
  801b54:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b57:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801b5a:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801b5d:	7d 55                	jge    801bb4 <fmap+0x69>
          fma = fd2data(fd);
  801b5f:	83 ec 0c             	sub    $0xc,%esp
  801b62:	57                   	push   %edi
  801b63:	e8 54 f6 ff ff       	call   8011bc <fd2data>
  801b68:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b71:	05 ff 0f 00 00       	add    $0xfff,%eax
  801b76:	89 c3                	mov    %eax,%ebx
  801b78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801b7e:	39 f3                	cmp    %esi,%ebx
  801b80:	7d 32                	jge    801bb4 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801b88:	01 d8                	add    %ebx,%eax
  801b8a:	50                   	push   %eax
  801b8b:	53                   	push   %ebx
  801b8c:	ff 77 0c             	pushl  0xc(%edi)
  801b8f:	e8 8b 02 00 00       	call   801e1f <fsipc_map>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	79 0f                	jns    801baa <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	53                   	push   %ebx
  801ba1:	57                   	push   %edi
  801ba2:	e8 1a 00 00 00       	call   801bc1 <funmap>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bb0:	39 f3                	cmp    %esi,%ebx
  801bb2:	7c ce                	jl     801b82 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5f                   	pop    %edi
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <funmap>:

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
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	57                   	push   %edi
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 0c             	sub    $0xc,%esp
  801bca:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801bd0:	39 f3                	cmp    %esi,%ebx
  801bd2:	0f 8d 80 00 00 00    	jge    801c58 <funmap+0x97>
          fma = fd2data(fd);
  801bd8:	83 ec 0c             	sub    $0xc,%esp
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	e8 d9 f5 ff ff       	call   8011bc <fd2data>
  801be3:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801bee:	89 c3                	mov    %eax,%ebx
  801bf0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801bf6:	39 f3                	cmp    %esi,%ebx
  801bf8:	7d 5e                	jge    801c58 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801bfa:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801bfd:	89 c2                	mov    %eax,%edx
  801bff:	c1 ea 0c             	shr    $0xc,%edx
  801c02:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801c09:	a8 01                	test   $0x1,%al
  801c0b:	74 41                	je     801c4e <funmap+0x8d>
              if (dirty) {
  801c0d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801c11:	74 21                	je     801c34 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801c13:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801c1a:	a8 40                	test   $0x40,%al
  801c1c:	74 16                	je     801c34 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801c1e:	83 ec 08             	sub    $0x8,%esp
  801c21:	53                   	push   %ebx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	ff 70 0c             	pushl  0xc(%eax)
  801c28:	e8 65 02 00 00       	call   801e92 <fsipc_dirty>
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	85 c0                	test   %eax,%eax
  801c32:	78 29                	js     801c5d <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801c3a:	50                   	push   %eax
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	e8 e1 f1 ff ff       	call   800e24 <sys_getenvid>
  801c43:	89 04 24             	mov    %eax,(%esp)
  801c46:	e8 9c f2 ff ff       	call   800ee7 <sys_page_unmap>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c54:	39 f3                	cmp    %esi,%ebx
  801c56:	7c a2                	jl     801bfa <funmap+0x39>
            }
          }
        }

        return 0;
  801c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c60:	5b                   	pop    %ebx
  801c61:	5e                   	pop    %esi
  801c62:	5f                   	pop    %edi
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <remove>:

// Delete a file
int
remove(const char *path)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801c6b:	ff 75 08             	pushl  0x8(%ebp)
  801c6e:	e8 47 02 00 00       	call   801eba <fsipc_remove>
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801c7b:	e8 80 02 00 00       	call   801f00 <fsipc_sync>
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    
	...

00801c84 <writebuf>:


static void
writebuf(struct printbuf *b)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	53                   	push   %ebx
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (b->error > 0) {
  801c8e:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
  801c92:	7e 2c                	jle    801cc0 <writebuf+0x3c>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c94:	83 ec 04             	sub    $0x4,%esp
  801c97:	ff 73 04             	pushl  0x4(%ebx)
  801c9a:	8d 43 10             	lea    0x10(%ebx),%eax
  801c9d:	50                   	push   %eax
  801c9e:	ff 33                	pushl  (%ebx)
  801ca0:	e8 03 f9 ff ff       	call   8015a8 <write>
		if (result > 0)
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	7e 03                	jle    801caf <writebuf+0x2b>
			b->result += result;
  801cac:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801caf:	39 43 04             	cmp    %eax,0x4(%ebx)
  801cb2:	74 0c                	je     801cc0 <writebuf+0x3c>
			b->error = (result < 0 ? result : 0);
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	7e 05                	jle    801cbd <writebuf+0x39>
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbd:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801cc0:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <putch>:

static void
putch(int ch, void *thunk)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	53                   	push   %ebx
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801ccf:	8b 43 04             	mov    0x4(%ebx),%eax
  801cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd5:	88 54 18 10          	mov    %dl,0x10(%eax,%ebx,1)
  801cd9:	40                   	inc    %eax
  801cda:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801cdd:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ce2:	75 13                	jne    801cf7 <putch+0x32>
		writebuf(b);
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	53                   	push   %ebx
  801ce8:	e8 97 ff ff ff       	call   801c84 <writebuf>
		b->idx = 0;
  801ced:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  801cf4:	83 c4 10             	add    $0x10,%esp
	}
}
  801cf7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	53                   	push   %ebx
  801d00:	81 ec 14 01 00 00    	sub    $0x114,%esp
	struct printbuf b;

	b.fd = fd;
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	89 85 e8 fe ff ff    	mov    %eax,0xfffffee8(%ebp)
	b.idx = 0;
  801d0f:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  801d16:	00 00 00 
	b.result = 0;
  801d19:	c7 85 f0 fe ff ff 00 	movl   $0x0,0xfffffef0(%ebp)
  801d20:	00 00 00 
	b.error = 1;
  801d23:	c7 85 f4 fe ff ff 01 	movl   $0x1,0xfffffef4(%ebp)
  801d2a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d2d:	ff 75 10             	pushl  0x10(%ebp)
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	8d 9d e8 fe ff ff    	lea    0xfffffee8(%ebp),%ebx
  801d39:	53                   	push   %ebx
  801d3a:	68 c5 1c 80 00       	push   $0x801cc5
  801d3f:	e8 a2 e7 ff ff       	call   8004e6 <vprintfmt>
	if (b.idx > 0)
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	83 bd ec fe ff ff 00 	cmpl   $0x0,0xfffffeec(%ebp)
  801d4e:	7e 0c                	jle    801d5c <vfprintf+0x60>
		writebuf(&b);
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	53                   	push   %ebx
  801d54:	e8 2b ff ff ff       	call   801c84 <writebuf>
  801d59:	83 c4 10             	add    $0x10,%esp

	return (b.result ? b.result : b.error);
  801d5c:	8b 85 f0 fe ff ff    	mov    0xfffffef0(%ebp),%eax
  801d62:	85 c0                	test   %eax,%eax
  801d64:	75 06                	jne    801d6c <vfprintf+0x70>
  801d66:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
}
  801d6c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d77:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d7a:	50                   	push   %eax
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	e8 76 ff ff ff       	call   801cfc <vfprintf>
	va_end(ap);

	return cnt;
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <printf>:

int
printf(const char *fmt, ...)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d8e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d91:	50                   	push   %eax
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	6a 01                	push   $0x1
  801d97:	e8 60 ff ff ff       	call   801cfc <vfprintf>
	va_end(ap);

	return cnt;
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    
	...

00801da0 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801da6:	6a 07                	push   $0x7
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801db3:	50                   	push   %eax
  801db4:	e8 36 05 00 00       	call   8022ef <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801db9:	83 c4 0c             	add    $0xc,%esp
  801dbc:	ff 75 14             	pushl  0x14(%ebp)
  801dbf:	ff 75 10             	pushl  0x10(%ebp)
  801dc2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801dc5:	50                   	push   %eax
  801dc6:	e8 c1 04 00 00       	call   80228c <ipc_recv>
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	56                   	push   %esi
  801dd1:	53                   	push   %ebx
  801dd2:	83 ec 1c             	sub    $0x1c,%esp
  801dd5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801dd8:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801ddd:	56                   	push   %esi
  801dde:	e8 71 ec ff ff       	call   800a54 <strlen>
  801de3:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801de6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801deb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801df0:	7f 24                	jg     801e16 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801df2:	83 ec 08             	sub    $0x8,%esp
  801df5:	56                   	push   %esi
  801df6:	53                   	push   %ebx
  801df7:	e8 94 ec ff ff       	call   800a90 <strcpy>
	req->req_omode = omode;
  801dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dff:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801e05:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801e08:	50                   	push   %eax
  801e09:	ff 75 10             	pushl  0x10(%ebp)
  801e0c:	53                   	push   %ebx
  801e0d:	6a 01                	push   $0x1
  801e0f:	e8 8c ff ff ff       	call   801da0 <fsipc>
  801e14:	89 c2                	mov    %eax,%edx
}
  801e16:	89 d0                	mov    %edx,%eax
  801e18:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5e                   	pop    %esi
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e30:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801e35:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e38:	50                   	push   %eax
  801e39:	ff 75 10             	pushl  0x10(%ebp)
  801e3c:	68 00 30 80 00       	push   $0x803000
  801e41:	6a 02                	push   $0x2
  801e43:	e8 58 ff ff ff       	call   801da0 <fsipc>

	//return -E_UNSPECIFIED;
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5b:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	68 00 30 80 00       	push   $0x803000
  801e69:	6a 03                	push   $0x3
  801e6b:	e8 30 ff ff ff       	call   801da0 <fsipc>
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	68 00 30 80 00       	push   $0x803000
  801e89:	6a 04                	push   $0x4
  801e8b:	e8 10 ff ff ff       	call   801da0 <fsipc>
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea3:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	68 00 30 80 00       	push   $0x803000
  801eb1:	6a 05                	push   $0x5
  801eb3:	e8 e8 fe ff ff       	call   801da0 <fsipc>
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	56                   	push   %esi
  801ebe:	53                   	push   %ebx
  801ebf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801ec2:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801ec7:	83 ec 0c             	sub    $0xc,%esp
  801eca:	53                   	push   %ebx
  801ecb:	e8 84 eb ff ff       	call   800a54 <strlen>
  801ed0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801ed3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801ed8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801edd:	7f 18                	jg     801ef7 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801edf:	83 ec 08             	sub    $0x8,%esp
  801ee2:	53                   	push   %ebx
  801ee3:	56                   	push   %esi
  801ee4:	e8 a7 eb ff ff       	call   800a90 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	56                   	push   %esi
  801eee:	6a 06                	push   $0x6
  801ef0:	e8 ab fe ff ff       	call   801da0 <fsipc>
  801ef5:	89 c2                	mov    %eax,%edx
}
  801ef7:	89 d0                	mov    %edx,%eax
  801ef9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	68 00 30 80 00       	push   $0x803000
  801f0f:	6a 07                	push   $0x7
  801f11:	e8 8a fe ff ff       	call   801da0 <fsipc>
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <pipe>:
};

int
pipe(int pfd[2])
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	57                   	push   %edi
  801f1c:	56                   	push   %esi
  801f1d:	53                   	push   %ebx
  801f1e:	83 ec 18             	sub    $0x18,%esp
  801f21:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f24:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801f27:	50                   	push   %eax
  801f28:	e8 b7 f2 ff ff       	call   8011e4 <fd_alloc>
  801f2d:	89 c3                	mov    %eax,%ebx
  801f2f:	83 c4 10             	add    $0x10,%esp
  801f32:	85 c0                	test   %eax,%eax
  801f34:	0f 88 25 01 00 00    	js     80205f <pipe+0x147>
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	68 07 04 00 00       	push   $0x407
  801f42:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801f45:	6a 00                	push   $0x0
  801f47:	e8 16 ef ff ff       	call   800e62 <sys_page_alloc>
  801f4c:	89 c3                	mov    %eax,%ebx
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	85 c0                	test   %eax,%eax
  801f53:	0f 88 06 01 00 00    	js     80205f <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801f5f:	50                   	push   %eax
  801f60:	e8 7f f2 ff ff       	call   8011e4 <fd_alloc>
  801f65:	89 c3                	mov    %eax,%ebx
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	0f 88 dd 00 00 00    	js     80204f <pipe+0x137>
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	68 07 04 00 00       	push   $0x407
  801f7a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801f7d:	6a 00                	push   $0x0
  801f7f:	e8 de ee ff ff       	call   800e62 <sys_page_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	0f 88 be 00 00 00    	js     80204f <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801f97:	e8 20 f2 ff ff       	call   8011bc <fd2data>
  801f9c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9e:	83 c4 0c             	add    $0xc,%esp
  801fa1:	68 07 04 00 00       	push   $0x407
  801fa6:	50                   	push   %eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	e8 b4 ee ff ff       	call   800e62 <sys_page_alloc>
  801fae:	89 c3                	mov    %eax,%ebx
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	0f 88 84 00 00 00    	js     80203f <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	68 07 04 00 00       	push   $0x407
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801fc9:	e8 ee f1 ff ff       	call   8011bc <fd2data>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	50                   	push   %eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	56                   	push   %esi
  801fd5:	6a 00                	push   $0x0
  801fd7:	e8 c9 ee ff ff       	call   800ea5 <sys_page_map>
  801fdc:	89 c3                	mov    %eax,%ebx
  801fde:	83 c4 20             	add    $0x20,%esp
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 4c                	js     802031 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fe5:	8b 15 60 60 80 00    	mov    0x806060,%edx
  801feb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801fee:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ff0:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801ff3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ffa:	8b 15 60 60 80 00    	mov    0x806060,%edx
  802000:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802003:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802005:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802008:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802015:	e8 ba f1 ff ff       	call   8011d4 <fd2num>
  80201a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80201c:	83 c4 04             	add    $0x4,%esp
  80201f:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802022:	e8 ad f1 ff ff       	call   8011d4 <fd2num>
  802027:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80202a:	b8 00 00 00 00       	mov    $0x0,%eax
  80202f:	eb 30                	jmp    802061 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802031:	83 ec 08             	sub    $0x8,%esp
  802034:	56                   	push   %esi
  802035:	6a 00                	push   $0x0
  802037:	e8 ab ee ff ff       	call   800ee7 <sys_page_unmap>
  80203c:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80203f:	83 ec 08             	sub    $0x8,%esp
  802042:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802045:	6a 00                	push   $0x0
  802047:	e8 9b ee ff ff       	call   800ee7 <sys_page_unmap>
  80204c:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80204f:	83 ec 08             	sub    $0x8,%esp
  802052:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802055:	6a 00                	push   $0x0
  802057:	e8 8b ee ff ff       	call   800ee7 <sys_page_unmap>
  80205c:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  80205f:	89 d8                	mov    %ebx,%eax
}
  802061:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5f                   	pop    %edi
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	57                   	push   %edi
  80206d:	56                   	push   %esi
  80206e:	53                   	push   %ebx
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802075:	a1 80 64 80 00       	mov    0x806480,%eax
  80207a:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	ff 75 08             	pushl  0x8(%ebp)
  802083:	e8 c0 02 00 00       	call   802348 <pageref>
  802088:	89 c3                	mov    %eax,%ebx
  80208a:	89 3c 24             	mov    %edi,(%esp)
  80208d:	e8 b6 02 00 00       	call   802348 <pageref>
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	39 c3                	cmp    %eax,%ebx
  802097:	0f 94 c0             	sete   %al
  80209a:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  80209d:	8b 0d 80 64 80 00    	mov    0x806480,%ecx
  8020a3:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  8020a6:	39 c6                	cmp    %eax,%esi
  8020a8:	74 1b                	je     8020c5 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  8020aa:	83 fa 01             	cmp    $0x1,%edx
  8020ad:	75 c6                	jne    802075 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8020af:	6a 01                	push   $0x1
  8020b1:	8b 41 58             	mov    0x58(%ecx),%eax
  8020b4:	50                   	push   %eax
  8020b5:	56                   	push   %esi
  8020b6:	68 e8 2b 80 00       	push   $0x802be8
  8020bb:	e8 f4 e2 ff ff       	call   8003b4 <cprintf>
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	eb b0                	jmp    802075 <_pipeisclosed+0xc>
	}
}
  8020c5:	89 d0                	mov    %edx,%eax
  8020c7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020ca:	5b                   	pop    %ebx
  8020cb:	5e                   	pop    %esi
  8020cc:	5f                   	pop    %edi
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d5:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8020d8:	50                   	push   %eax
  8020d9:	ff 75 08             	pushl  0x8(%ebp)
  8020dc:	e8 5d f1 ff ff       	call   80123e <fd_lookup>
  8020e1:	83 c4 10             	add    $0x10,%esp
		return r;
  8020e4:	89 c2                	mov    %eax,%edx
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 19                	js     802103 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8020ea:	83 ec 0c             	sub    $0xc,%esp
  8020ed:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020f0:	e8 c7 f0 ff ff       	call   8011bc <fd2data>
	return _pipeisclosed(fd, p);
  8020f5:	83 c4 08             	add    $0x8,%esp
  8020f8:	50                   	push   %eax
  8020f9:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020fc:	e8 68 ff ff ff       	call   802069 <_pipeisclosed>
  802101:	89 c2                	mov    %eax,%edx
}
  802103:	89 d0                	mov    %edx,%eax
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	57                   	push   %edi
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	83 ec 18             	sub    $0x18,%esp
  802110:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802113:	57                   	push   %edi
  802114:	e8 a3 f0 ff ff       	call   8011bc <fd2data>
  802119:	89 c3                	mov    %eax,%ebx
	if (debug)
  80211b:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80211e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802121:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802124:	be 00 00 00 00       	mov    $0x0,%esi
  802129:	3b 75 10             	cmp    0x10(%ebp),%esi
  80212c:	73 55                	jae    802183 <piperead+0x7c>
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
  80212e:	8b 03                	mov    (%ebx),%eax
  802130:	3b 43 04             	cmp    0x4(%ebx),%eax
  802133:	75 2c                	jne    802161 <piperead+0x5a>
  802135:	85 f6                	test   %esi,%esi
  802137:	74 04                	je     80213d <piperead+0x36>
  802139:	89 f0                	mov    %esi,%eax
  80213b:	eb 48                	jmp    802185 <piperead+0x7e>
  80213d:	83 ec 08             	sub    $0x8,%esp
  802140:	53                   	push   %ebx
  802141:	57                   	push   %edi
  802142:	e8 22 ff ff ff       	call   802069 <_pipeisclosed>
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	85 c0                	test   %eax,%eax
  80214c:	74 07                	je     802155 <piperead+0x4e>
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	eb 30                	jmp    802185 <piperead+0x7e>
  802155:	e8 e9 ec ff ff       	call   800e43 <sys_yield>
  80215a:	8b 03                	mov    (%ebx),%eax
  80215c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80215f:	74 d4                	je     802135 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802161:	8b 13                	mov    (%ebx),%edx
  802163:	89 d0                	mov    %edx,%eax
  802165:	85 d2                	test   %edx,%edx
  802167:	79 03                	jns    80216c <piperead+0x65>
  802169:	8d 42 1f             	lea    0x1f(%edx),%eax
  80216c:	83 e0 e0             	and    $0xffffffe0,%eax
  80216f:	29 c2                	sub    %eax,%edx
  802171:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  802175:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802178:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80217b:	ff 03                	incl   (%ebx)
  80217d:	46                   	inc    %esi
  80217e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802181:	72 ab                	jb     80212e <piperead+0x27>
	}
	return i;
  802183:	89 f0                	mov    %esi,%eax
}
  802185:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802188:	5b                   	pop    %ebx
  802189:	5e                   	pop    %esi
  80218a:	5f                   	pop    %edi
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	57                   	push   %edi
  802191:	56                   	push   %esi
  802192:	53                   	push   %ebx
  802193:	83 ec 18             	sub    $0x18,%esp
  802196:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  802199:	57                   	push   %edi
  80219a:	e8 1d f0 ff ff       	call   8011bc <fd2data>
  80219f:	89 c3                	mov    %eax,%ebx
	if (debug)
  8021a1:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8021a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a7:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8021aa:	be 00 00 00 00       	mov    $0x0,%esi
  8021af:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021b2:	73 55                	jae    802209 <pipewrite+0x7c>
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
  8021b4:	8b 03                	mov    (%ebx),%eax
  8021b6:	83 c0 20             	add    $0x20,%eax
  8021b9:	39 43 04             	cmp    %eax,0x4(%ebx)
  8021bc:	72 27                	jb     8021e5 <pipewrite+0x58>
  8021be:	83 ec 08             	sub    $0x8,%esp
  8021c1:	53                   	push   %ebx
  8021c2:	57                   	push   %edi
  8021c3:	e8 a1 fe ff ff       	call   802069 <_pipeisclosed>
  8021c8:	83 c4 10             	add    $0x10,%esp
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	74 07                	je     8021d6 <pipewrite+0x49>
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	eb 35                	jmp    80220b <pipewrite+0x7e>
  8021d6:	e8 68 ec ff ff       	call   800e43 <sys_yield>
  8021db:	8b 03                	mov    (%ebx),%eax
  8021dd:	83 c0 20             	add    $0x20,%eax
  8021e0:	39 43 04             	cmp    %eax,0x4(%ebx)
  8021e3:	73 d9                	jae    8021be <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021e5:	8b 53 04             	mov    0x4(%ebx),%edx
  8021e8:	89 d0                	mov    %edx,%eax
  8021ea:	85 d2                	test   %edx,%edx
  8021ec:	79 03                	jns    8021f1 <pipewrite+0x64>
  8021ee:	8d 42 1f             	lea    0x1f(%edx),%eax
  8021f1:	83 e0 e0             	and    $0xffffffe0,%eax
  8021f4:	29 c2                	sub    %eax,%edx
  8021f6:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8021f9:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8021fc:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802200:	ff 43 04             	incl   0x4(%ebx)
  802203:	46                   	inc    %esi
  802204:	3b 75 10             	cmp    0x10(%ebp),%esi
  802207:	72 ab                	jb     8021b4 <pipewrite+0x27>
	}
	
	return i;
  802209:	89 f0                	mov    %esi,%eax
}
  80220b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80220e:	5b                   	pop    %ebx
  80220f:	5e                   	pop    %esi
  802210:	5f                   	pop    %edi
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80221b:	83 ec 0c             	sub    $0xc,%esp
  80221e:	ff 75 08             	pushl  0x8(%ebp)
  802221:	e8 96 ef ff ff       	call   8011bc <fd2data>
  802226:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802228:	83 c4 08             	add    $0x8,%esp
  80222b:	68 fb 2b 80 00       	push   $0x802bfb
  802230:	53                   	push   %ebx
  802231:	e8 5a e8 ff ff       	call   800a90 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802236:	8b 46 04             	mov    0x4(%esi),%eax
  802239:	2b 06                	sub    (%esi),%eax
  80223b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802241:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802248:	00 00 00 
	stat->st_dev = &devpipe;
  80224b:	c7 83 88 00 00 00 60 	movl   $0x806060,0x88(%ebx)
  802252:	60 80 00 
	return 0;
}
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
  80225a:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	53                   	push   %ebx
  802265:	83 ec 0c             	sub    $0xc,%esp
  802268:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80226b:	53                   	push   %ebx
  80226c:	6a 00                	push   $0x0
  80226e:	e8 74 ec ff ff       	call   800ee7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802273:	89 1c 24             	mov    %ebx,(%esp)
  802276:	e8 41 ef ff ff       	call   8011bc <fd2data>
  80227b:	83 c4 08             	add    $0x8,%esp
  80227e:	50                   	push   %eax
  80227f:	6a 00                	push   $0x0
  802281:	e8 61 ec ff ff       	call   800ee7 <sys_page_unmap>
}
  802286:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802289:	c9                   	leave  
  80228a:	c3                   	ret    
	...

0080228c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	56                   	push   %esi
  802290:	53                   	push   %ebx
  802291:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802294:	8b 45 0c             	mov    0xc(%ebp),%eax
  802297:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80229a:	85 c0                	test   %eax,%eax
  80229c:	75 12                	jne    8022b0 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80229e:	83 ec 0c             	sub    $0xc,%esp
  8022a1:	68 00 00 c0 ee       	push   $0xeec00000
  8022a6:	e8 67 ed ff ff       	call   801012 <sys_ipc_recv>
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	eb 0c                	jmp    8022bc <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	50                   	push   %eax
  8022b4:	e8 59 ed ff ff       	call   801012 <sys_ipc_recv>
  8022b9:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8022bc:	89 c2                	mov    %eax,%edx
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 24                	js     8022e6 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8022c2:	85 db                	test   %ebx,%ebx
  8022c4:	74 0a                	je     8022d0 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8022c6:	a1 80 64 80 00       	mov    0x806480,%eax
  8022cb:	8b 40 74             	mov    0x74(%eax),%eax
  8022ce:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8022d0:	85 f6                	test   %esi,%esi
  8022d2:	74 0a                	je     8022de <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8022d4:	a1 80 64 80 00       	mov    0x806480,%eax
  8022d9:	8b 40 78             	mov    0x78(%eax),%eax
  8022dc:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  8022de:	a1 80 64 80 00       	mov    0x806480,%eax
  8022e3:	8b 50 70             	mov    0x70(%eax),%edx

}
  8022e6:	89 d0                	mov    %edx,%eax
  8022e8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <ipc_send>:

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
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	57                   	push   %edi
  8022f3:	56                   	push   %esi
  8022f4:	53                   	push   %ebx
  8022f5:	83 ec 0c             	sub    $0xc,%esp
  8022f8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022fe:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802301:	85 db                	test   %ebx,%ebx
  802303:	75 0a                	jne    80230f <ipc_send+0x20>
    pg = (void *) UTOP;
  802305:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80230a:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80230f:	56                   	push   %esi
  802310:	53                   	push   %ebx
  802311:	57                   	push   %edi
  802312:	ff 75 08             	pushl  0x8(%ebp)
  802315:	e8 d5 ec ff ff       	call   800fef <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802320:	75 07                	jne    802329 <ipc_send+0x3a>
      sys_yield();
  802322:	e8 1c eb ff ff       	call   800e43 <sys_yield>
  802327:	eb e6                	jmp    80230f <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802329:	85 c0                	test   %eax,%eax
  80232b:	79 12                	jns    80233f <ipc_send+0x50>
  80232d:	50                   	push   %eax
  80232e:	68 02 2c 80 00       	push   $0x802c02
  802333:	6a 49                	push   $0x49
  802335:	68 1f 2c 80 00       	push   $0x802c1f
  80233a:	e8 85 df ff ff       	call   8002c4 <_panic>
    else break;
  }
}
  80233f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802342:	5b                   	pop    %ebx
  802343:	5e                   	pop    %esi
  802344:	5f                   	pop    %edi
  802345:	c9                   	leave  
  802346:	c3                   	ret    
	...

00802348 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80234e:	89 c8                	mov    %ecx,%eax
  802350:	c1 e8 16             	shr    $0x16,%eax
  802353:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  80235a:	ba 00 00 00 00       	mov    $0x0,%edx
  80235f:	a8 01                	test   $0x1,%al
  802361:	74 28                	je     80238b <pageref+0x43>
	pte = vpt[VPN(v)];
  802363:	89 c8                	mov    %ecx,%eax
  802365:	c1 e8 0c             	shr    $0xc,%eax
  802368:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80236f:	ba 00 00 00 00       	mov    $0x0,%edx
  802374:	a8 01                	test   $0x1,%al
  802376:	74 13                	je     80238b <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802378:	c1 e8 0c             	shr    $0xc,%eax
  80237b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80237e:	c1 e0 02             	shl    $0x2,%eax
  802381:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802388:	0f b7 d0             	movzwl %ax,%edx
}
  80238b:	89 d0                	mov    %edx,%eax
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    
	...

00802390 <__udivdi3>:
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	57                   	push   %edi
  802394:	56                   	push   %esi
  802395:	83 ec 14             	sub    $0x14,%esp
  802398:	8b 55 14             	mov    0x14(%ebp),%edx
  80239b:	8b 75 08             	mov    0x8(%ebp),%esi
  80239e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8023a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a4:	85 d2                	test   %edx,%edx
  8023a6:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8023a9:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8023ac:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8023af:	89 fe                	mov    %edi,%esi
  8023b1:	75 11                	jne    8023c4 <__udivdi3+0x34>
  8023b3:	39 f8                	cmp    %edi,%eax
  8023b5:	76 4d                	jbe    802404 <__udivdi3+0x74>
  8023b7:	89 fa                	mov    %edi,%edx
  8023b9:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8023bc:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	eb 09                	jmp    8023cc <__udivdi3+0x3c>
  8023c3:	90                   	nop    
  8023c4:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  8023c7:	76 17                	jbe    8023e0 <__udivdi3+0x50>
  8023c9:	31 ff                	xor    %edi,%edi
  8023cb:	90                   	nop    
  8023cc:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  8023d3:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8023d6:	83 c4 14             	add    $0x14,%esp
  8023d9:	5e                   	pop    %esi
  8023da:	89 f8                	mov    %edi,%eax
  8023dc:	5f                   	pop    %edi
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    
  8023df:	90                   	nop    
  8023e0:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  8023e4:	89 c7                	mov    %eax,%edi
  8023e6:	83 f7 1f             	xor    $0x1f,%edi
  8023e9:	75 4d                	jne    802438 <__udivdi3+0xa8>
  8023eb:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8023ee:	77 0a                	ja     8023fa <__udivdi3+0x6a>
  8023f0:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  8023f8:	72 d2                	jb     8023cc <__udivdi3+0x3c>
  8023fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8023ff:	eb cb                	jmp    8023cc <__udivdi3+0x3c>
  802401:	8d 76 00             	lea    0x0(%esi),%esi
  802404:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	75 0e                	jne    802419 <__udivdi3+0x89>
  80240b:	b8 01 00 00 00       	mov    $0x1,%eax
  802410:	31 c9                	xor    %ecx,%ecx
  802412:	31 d2                	xor    %edx,%edx
  802414:	f7 f1                	div    %ecx
  802416:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802419:	89 f0                	mov    %esi,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802420:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802423:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802426:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802429:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80242c:	83 c4 14             	add    $0x14,%esp
  80242f:	89 c7                	mov    %eax,%edi
  802431:	5e                   	pop    %esi
  802432:	89 f8                	mov    %edi,%eax
  802434:	5f                   	pop    %edi
  802435:	c9                   	leave  
  802436:	c3                   	ret    
  802437:	90                   	nop    
  802438:	b8 20 00 00 00       	mov    $0x20,%eax
  80243d:	29 f8                	sub    %edi,%eax
  80243f:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  802442:	89 f9                	mov    %edi,%ecx
  802444:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802447:	d3 e2                	shl    %cl,%edx
  802449:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80244c:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80244f:	d3 e8                	shr    %cl,%eax
  802451:	09 c2                	or     %eax,%edx
  802453:	89 f9                	mov    %edi,%ecx
  802455:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802458:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80245b:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80245e:	89 f2                	mov    %esi,%edx
  802460:	d3 ea                	shr    %cl,%edx
  802462:	89 f9                	mov    %edi,%ecx
  802464:	d3 e6                	shl    %cl,%esi
  802466:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802469:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80246c:	d3 e8                	shr    %cl,%eax
  80246e:	09 c6                	or     %eax,%esi
  802470:	89 f9                	mov    %edi,%ecx
  802472:	89 f0                	mov    %esi,%eax
  802474:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802477:	89 d6                	mov    %edx,%esi
  802479:	89 c7                	mov    %eax,%edi
  80247b:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  80247e:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802481:	f7 e7                	mul    %edi
  802483:	39 f2                	cmp    %esi,%edx
  802485:	77 0f                	ja     802496 <__udivdi3+0x106>
  802487:	0f 85 3f ff ff ff    	jne    8023cc <__udivdi3+0x3c>
  80248d:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802490:	0f 86 36 ff ff ff    	jbe    8023cc <__udivdi3+0x3c>
  802496:	4f                   	dec    %edi
  802497:	e9 30 ff ff ff       	jmp    8023cc <__udivdi3+0x3c>

0080249c <__umoddi3>:
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	57                   	push   %edi
  8024a0:	56                   	push   %esi
  8024a1:	83 ec 30             	sub    $0x30,%esp
  8024a4:	8b 55 14             	mov    0x14(%ebp),%edx
  8024a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024aa:	89 d7                	mov    %edx,%edi
  8024ac:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8024af:	89 c6                	mov    %eax,%esi
  8024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	85 ff                	test   %edi,%edi
  8024b9:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  8024c0:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8024c7:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  8024ca:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8024cd:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8024d0:	75 3e                	jne    802510 <__umoddi3+0x74>
  8024d2:	39 d6                	cmp    %edx,%esi
  8024d4:	0f 86 a2 00 00 00    	jbe    80257c <__umoddi3+0xe0>
  8024da:	f7 f6                	div    %esi
  8024dc:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8024df:	85 c9                	test   %ecx,%ecx
  8024e1:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  8024e4:	74 1b                	je     802501 <__umoddi3+0x65>
  8024e6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8024e9:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8024ec:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8024f3:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8024f6:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  8024f9:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  8024fc:	89 10                	mov    %edx,(%eax)
  8024fe:	89 48 04             	mov    %ecx,0x4(%eax)
  802501:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802504:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802507:	83 c4 30             	add    $0x30,%esp
  80250a:	5e                   	pop    %esi
  80250b:	5f                   	pop    %edi
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    
  80250e:	89 f6                	mov    %esi,%esi
  802510:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802513:	76 1f                	jbe    802534 <__umoddi3+0x98>
  802515:	8b 55 08             	mov    0x8(%ebp),%edx
  802518:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80251b:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80251e:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802521:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802524:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802527:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  80252a:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80252d:	83 c4 30             	add    $0x30,%esp
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	c9                   	leave  
  802533:	c3                   	ret    
  802534:	0f bd c7             	bsr    %edi,%eax
  802537:	83 f0 1f             	xor    $0x1f,%eax
  80253a:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  80253d:	75 61                	jne    8025a0 <__umoddi3+0x104>
  80253f:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  802542:	77 05                	ja     802549 <__umoddi3+0xad>
  802544:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  802547:	72 10                	jb     802559 <__umoddi3+0xbd>
  802549:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80254c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80254f:	29 f0                	sub    %esi,%eax
  802551:	19 fa                	sbb    %edi,%edx
  802553:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802556:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802559:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80255c:	85 d2                	test   %edx,%edx
  80255e:	74 a1                	je     802501 <__umoddi3+0x65>
  802560:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802563:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802566:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802569:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  80256c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80256f:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802572:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802575:	89 01                	mov    %eax,(%ecx)
  802577:	89 51 04             	mov    %edx,0x4(%ecx)
  80257a:	eb 85                	jmp    802501 <__umoddi3+0x65>
  80257c:	85 f6                	test   %esi,%esi
  80257e:	75 0b                	jne    80258b <__umoddi3+0xef>
  802580:	b8 01 00 00 00       	mov    $0x1,%eax
  802585:	31 d2                	xor    %edx,%edx
  802587:	f7 f6                	div    %esi
  802589:	89 c6                	mov    %eax,%esi
  80258b:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80258e:	89 fa                	mov    %edi,%edx
  802590:	f7 f6                	div    %esi
  802592:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802595:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802598:	f7 f6                	div    %esi
  80259a:	e9 3d ff ff ff       	jmp    8024dc <__umoddi3+0x40>
  80259f:	90                   	nop    
  8025a0:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a5:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  8025a8:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  8025ab:	89 fa                	mov    %edi,%edx
  8025ad:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8025b0:	d3 e2                	shl    %cl,%edx
  8025b2:	89 f0                	mov    %esi,%eax
  8025b4:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8025b7:	d3 e8                	shr    %cl,%eax
  8025b9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8025bc:	d3 e6                	shl    %cl,%esi
  8025be:	89 d7                	mov    %edx,%edi
  8025c0:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8025c3:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8025c6:	09 c7                	or     %eax,%edi
  8025c8:	d3 ea                	shr    %cl,%edx
  8025ca:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8025cd:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8025d0:	d3 e0                	shl    %cl,%eax
  8025d2:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8025d5:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8025d8:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8025db:	d3 e8                	shr    %cl,%eax
  8025dd:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  8025e0:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8025e3:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8025e6:	f7 f7                	div    %edi
  8025e8:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8025eb:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  8025ee:	f7 e6                	mul    %esi
  8025f0:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  8025f3:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  8025f6:	77 0a                	ja     802602 <__umoddi3+0x166>
  8025f8:	75 12                	jne    80260c <__umoddi3+0x170>
  8025fa:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8025fd:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802600:	76 0a                	jbe    80260c <__umoddi3+0x170>
  802602:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802605:	29 f1                	sub    %esi,%ecx
  802607:	19 fa                	sbb    %edi,%edx
  802609:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  80260c:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	0f 84 ea fe ff ff    	je     802501 <__umoddi3+0x65>
  802617:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80261a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80261d:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802620:	19 d1                	sbb    %edx,%ecx
  802622:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802625:	89 ca                	mov    %ecx,%edx
  802627:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80262a:	d3 e2                	shl    %cl,%edx
  80262c:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80262f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802632:	d3 e8                	shr    %cl,%eax
  802634:	09 c2                	or     %eax,%edx
  802636:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802639:	d3 e8                	shr    %cl,%eax
  80263b:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80263e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802641:	e9 ad fe ff ff       	jmp    8024f3 <__umoddi3+0x57>
