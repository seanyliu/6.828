
obj/user/testpipe:     file format elf32-i386

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
  80002c:	e8 8b 02 00 00       	call   8002bc <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	char buf[100];
	int i, pid, p[2];

	argv0 = "pipereadeof";
  80003f:	c7 05 84 70 80 00 44 	movl   $0x802b44,0x807084
  800046:	2b 80 00 

	if ((i = pipe(p)) < 0)
  800049:	8d 45 80             	lea    0xffffff80(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	e8 c6 20 00 00       	call   802118 <pipe>
  800052:	89 c3                	mov    %eax,%ebx
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	79 12                	jns    80006d <umain+0x39>
		panic("pipe: %e", i);
  80005b:	50                   	push   %eax
  80005c:	68 50 2b 80 00       	push   $0x802b50
  800061:	6a 0e                	push   $0xe
  800063:	68 59 2b 80 00       	push   $0x802b59
  800068:	e8 ab 02 00 00       	call   800318 <_panic>

	if ((pid = fork()) < 0)
  80006d:	e8 dc 12 00 00       	call   80134e <fork>
  800072:	89 c6                	mov    %eax,%esi
  800074:	85 c0                	test   %eax,%eax
  800076:	79 12                	jns    80008a <umain+0x56>
		panic("fork: %e", i);
  800078:	53                   	push   %ebx
  800079:	68 69 2b 80 00       	push   $0x802b69
  80007e:	6a 11                	push   $0x11
  800080:	68 59 2b 80 00       	push   $0x802b59
  800085:	e8 8e 02 00 00       	call   800318 <_panic>

	if (pid == 0) {
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 85 bb 00 00 00    	jne    80014d <umain+0x119>
		cprintf("[%08x] pipereadeof close %d\n", env->env_id, p[1]);
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	8d 5d 80             	lea    0xffffff80(%ebp),%ebx
  800098:	ff 73 04             	pushl  0x4(%ebx)
  80009b:	a1 80 70 80 00       	mov    0x807080,%eax
  8000a0:	8b 40 4c             	mov    0x4c(%eax),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 72 2b 80 00       	push   $0x802b72
  8000a9:	e8 5a 03 00 00       	call   800408 <cprintf>
		close(p[1]);
  8000ae:	83 c4 04             	add    $0x4,%esp
  8000b1:	ff 73 04             	pushl  0x4(%ebx)
  8000b4:	e8 c1 15 00 00       	call   80167a <close>
		cprintf("[%08x] pipereadeof readn %d\n", env->env_id, p[0]);
  8000b9:	83 c4 0c             	add    $0xc,%esp
  8000bc:	ff 75 80             	pushl  0xffffff80(%ebp)
  8000bf:	a1 80 70 80 00       	mov    0x807080,%eax
  8000c4:	8b 40 4c             	mov    0x4c(%eax),%eax
  8000c7:	50                   	push   %eax
  8000c8:	68 8f 2b 80 00       	push   $0x802b8f
  8000cd:	e8 36 03 00 00       	call   800408 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000d2:	83 c4 0c             	add    $0xc,%esp
  8000d5:	6a 63                	push   $0x63
  8000d7:	8d 45 88             	lea    0xffffff88(%ebp),%eax
  8000da:	50                   	push   %eax
  8000db:	ff 75 80             	pushl  0xffffff80(%ebp)
  8000de:	e8 9a 17 00 00       	call   80187d <readn>
  8000e3:	89 c3                	mov    %eax,%ebx
		if (i < 0)
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	79 12                	jns    8000fe <umain+0xca>
			panic("read: %e", i);
  8000ec:	50                   	push   %eax
  8000ed:	68 ac 2b 80 00       	push   $0x802bac
  8000f2:	6a 19                	push   $0x19
  8000f4:	68 59 2b 80 00       	push   $0x802b59
  8000f9:	e8 1a 02 00 00       	call   800318 <_panic>
		buf[i] = 0;
  8000fe:	c6 44 05 88 00       	movb   $0x0,0xffffff88(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	ff 35 00 70 80 00    	pushl  0x807000
  80010c:	8d 45 88             	lea    0xffffff88(%ebp),%eax
  80010f:	50                   	push   %eax
  800110:	e8 78 09 00 00       	call   800a8d <strcmp>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	85 c0                	test   %eax,%eax
  80011a:	75 12                	jne    80012e <umain+0xfa>
			cprintf("\npipe read closed properly\n");
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	68 b5 2b 80 00       	push   $0x802bb5
  800124:	e8 df 02 00 00       	call   800408 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	eb 15                	jmp    800143 <umain+0x10f>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	8d 45 88             	lea    0xffffff88(%ebp),%eax
  800134:	50                   	push   %eax
  800135:	53                   	push   %ebx
  800136:	68 d1 2b 80 00       	push   $0x802bd1
  80013b:	e8 c8 02 00 00       	call   800408 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
		exit();
  800143:	e8 b8 01 00 00       	call   800300 <exit>
  800148:	e9 97 00 00 00       	jmp    8001e4 <umain+0x1b0>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", env->env_id, p[0]);
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	ff 75 80             	pushl  0xffffff80(%ebp)
  800153:	a1 80 70 80 00       	mov    0x807080,%eax
  800158:	8b 40 4c             	mov    0x4c(%eax),%eax
  80015b:	50                   	push   %eax
  80015c:	68 72 2b 80 00       	push   $0x802b72
  800161:	e8 a2 02 00 00       	call   800408 <cprintf>
		close(p[0]);
  800166:	83 c4 04             	add    $0x4,%esp
  800169:	ff 75 80             	pushl  0xffffff80(%ebp)
  80016c:	e8 09 15 00 00       	call   80167a <close>
		cprintf("[%08x] pipereadeof write %d\n", env->env_id, p[1]);
  800171:	83 c4 0c             	add    $0xc,%esp
  800174:	8d 5d 80             	lea    0xffffff80(%ebp),%ebx
  800177:	ff 73 04             	pushl  0x4(%ebx)
  80017a:	a1 80 70 80 00       	mov    0x807080,%eax
  80017f:	8b 40 4c             	mov    0x4c(%eax),%eax
  800182:	50                   	push   %eax
  800183:	68 e4 2b 80 00       	push   $0x802be4
  800188:	e8 7b 02 00 00       	call   800408 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  80018d:	83 c4 04             	add    $0x4,%esp
  800190:	ff 35 00 70 80 00    	pushl  0x807000
  800196:	e8 35 08 00 00       	call   8009d0 <strlen>
  80019b:	83 c4 0c             	add    $0xc,%esp
  80019e:	50                   	push   %eax
  80019f:	ff 35 00 70 80 00    	pushl  0x807000
  8001a5:	ff 73 04             	pushl  0x4(%ebx)
  8001a8:	e8 17 17 00 00       	call   8018c4 <write>
  8001ad:	89 c3                	mov    %eax,%ebx
  8001af:	83 c4 04             	add    $0x4,%esp
  8001b2:	ff 35 00 70 80 00    	pushl  0x807000
  8001b8:	e8 13 08 00 00       	call   8009d0 <strlen>
  8001bd:	83 c4 10             	add    $0x10,%esp
  8001c0:	39 c3                	cmp    %eax,%ebx
  8001c2:	74 12                	je     8001d6 <umain+0x1a2>
			panic("write: %e", i);
  8001c4:	53                   	push   %ebx
  8001c5:	68 01 2c 80 00       	push   $0x802c01
  8001ca:	6a 25                	push   $0x25
  8001cc:	68 59 2b 80 00       	push   $0x802b59
  8001d1:	e8 42 01 00 00       	call   800318 <_panic>
		close(p[1]);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 84             	pushl  0xffffff84(%ebp)
  8001dc:	e8 99 14 00 00       	call   80167a <close>
  8001e1:	83 c4 10             	add    $0x10,%esp
	}
	wait(pid);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	56                   	push   %esi
  8001e8:	e8 9f 22 00 00       	call   80248c <wait>

	argv0 = "pipewriteeof";
  8001ed:	c7 05 84 70 80 00 0b 	movl   $0x802c0b,0x807084
  8001f4:	2c 80 00 
	if ((i = pipe(p)) < 0)
  8001f7:	8d 45 80             	lea    0xffffff80(%ebp),%eax
  8001fa:	89 04 24             	mov    %eax,(%esp)
  8001fd:	e8 16 1f 00 00       	call   802118 <pipe>
  800202:	89 c3                	mov    %eax,%ebx
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	85 c0                	test   %eax,%eax
  800209:	79 12                	jns    80021d <umain+0x1e9>
		panic("pipe: %e", i);
  80020b:	50                   	push   %eax
  80020c:	68 50 2b 80 00       	push   $0x802b50
  800211:	6a 2c                	push   $0x2c
  800213:	68 59 2b 80 00       	push   $0x802b59
  800218:	e8 fb 00 00 00       	call   800318 <_panic>

	if ((pid = fork()) < 0)
  80021d:	e8 2c 11 00 00       	call   80134e <fork>
  800222:	89 c6                	mov    %eax,%esi
  800224:	85 c0                	test   %eax,%eax
  800226:	79 12                	jns    80023a <umain+0x206>
		panic("fork: %e", i);
  800228:	53                   	push   %ebx
  800229:	68 69 2b 80 00       	push   $0x802b69
  80022e:	6a 2f                	push   $0x2f
  800230:	68 59 2b 80 00       	push   $0x802b59
  800235:	e8 de 00 00 00       	call   800318 <_panic>

	if (pid == 0) {
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 4d                	jne    80028b <umain+0x257>
		close(p[0]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 80             	pushl  0xffffff80(%ebp)
  800244:	e8 31 14 00 00       	call   80167a <close>
		while (1) {
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	8d 5d 80             	lea    0xffffff80(%ebp),%ebx
			cprintf(".");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 18 2c 80 00       	push   $0x802c18
  800257:	e8 ac 01 00 00       	call   800408 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80025c:	83 c4 0c             	add    $0xc,%esp
  80025f:	6a 01                	push   $0x1
  800261:	68 1a 2c 80 00       	push   $0x802c1a
  800266:	ff 73 04             	pushl  0x4(%ebx)
  800269:	e8 56 16 00 00       	call   8018c4 <write>
  80026e:	83 c4 10             	add    $0x10,%esp
  800271:	83 f8 01             	cmp    $0x1,%eax
  800274:	74 d9                	je     80024f <umain+0x21b>
				break;
		}
		cprintf("\npipe write closed properly\n");
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 1c 2c 80 00       	push   $0x802c1c
  80027e:	e8 85 01 00 00       	call   800408 <cprintf>
		exit();
  800283:	e8 78 00 00 00       	call   800300 <exit>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	close(p[0]);
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	ff 75 80             	pushl  0xffffff80(%ebp)
  800291:	e8 e4 13 00 00       	call   80167a <close>
	close(p[1]);
  800296:	83 c4 04             	add    $0x4,%esp
  800299:	ff 75 84             	pushl  0xffffff84(%ebp)
  80029c:	e8 d9 13 00 00       	call   80167a <close>
	wait(pid);
  8002a1:	89 34 24             	mov    %esi,(%esp)
  8002a4:	e8 e3 21 00 00       	call   80248c <wait>

	cprintf("pipe tests passed\n");
  8002a9:	c7 04 24 39 2c 80 00 	movl   $0x802c39,(%esp)
  8002b0:	e8 53 01 00 00       	call   800408 <cprintf>
}
  8002b5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8002b8:	5b                   	pop    %ebx
  8002b9:	5e                   	pop    %esi
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8002c7:	e8 d4 0a 00 00       	call   800da0 <sys_getenvid>
  8002cc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d1:	c1 e0 07             	shl    $0x7,%eax
  8002d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002d9:	a3 80 70 80 00       	mov    %eax,0x807080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002de:	85 f6                	test   %esi,%esi
  8002e0:	7e 07                	jle    8002e9 <libmain+0x2d>
		binaryname = argv[0];
  8002e2:	8b 03                	mov    (%ebx),%eax
  8002e4:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	umain(argc, argv);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	53                   	push   %ebx
  8002ed:	56                   	push   %esi
  8002ee:	e8 41 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8002f3:	e8 08 00 00 00       	call   800300 <exit>
}
  8002f8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8002fb:	5b                   	pop    %ebx
  8002fc:	5e                   	pop    %esi
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    
	...

00800300 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800306:	e8 9d 13 00 00       	call   8016a8 <close_all>
	sys_env_destroy(0);
  80030b:	83 ec 0c             	sub    $0xc,%esp
  80030e:	6a 00                	push   $0x0
  800310:	e8 4a 0a 00 00       	call   800d5f <sys_env_destroy>
}
  800315:	c9                   	leave  
  800316:	c3                   	ret    
	...

00800318 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	53                   	push   %ebx
  80031c:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  80031f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  800322:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  800329:	74 16                	je     800341 <_panic+0x29>
		cprintf("%s: ", argv0);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	ff 35 84 70 80 00    	pushl  0x807084
  800334:	68 63 2c 80 00       	push   $0x802c63
  800339:	e8 ca 00 00 00       	call   800408 <cprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	ff 35 04 70 80 00    	pushl  0x807004
  80034d:	68 68 2c 80 00       	push   $0x802c68
  800352:	e8 b1 00 00 00       	call   800408 <cprintf>
	vcprintf(fmt, ap);
  800357:	83 c4 08             	add    $0x8,%esp
  80035a:	53                   	push   %ebx
  80035b:	ff 75 10             	pushl  0x10(%ebp)
  80035e:	e8 54 00 00 00       	call   8003b7 <vcprintf>
	cprintf("\n");
  800363:	c7 04 24 8d 2b 80 00 	movl   $0x802b8d,(%esp)
  80036a:	e8 99 00 00 00       	call   800408 <cprintf>

	// Cause a breakpoint exception
	while (1)
  80036f:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  800372:	cc                   	int3   
  800373:	eb fd                	jmp    800372 <_panic+0x5a>
  800375:	00 00                	add    %al,(%eax)
	...

00800378 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	53                   	push   %ebx
  80037c:	83 ec 04             	sub    $0x4,%esp
  80037f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800382:	8b 03                	mov    (%ebx),%eax
  800384:	8b 55 08             	mov    0x8(%ebp),%edx
  800387:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80038b:	40                   	inc    %eax
  80038c:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80038e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800393:	75 1a                	jne    8003af <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	68 ff 00 00 00       	push   $0xff
  80039d:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a0:	50                   	push   %eax
  8003a1:	e8 76 09 00 00       	call   800d1c <sys_cputs>
		b->idx = 0;
  8003a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ac:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8003af:	ff 43 04             	incl   0x4(%ebx)
}
  8003b2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c0:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  8003c7:	00 00 00 
	b.cnt = 0;
  8003ca:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  8003d1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d4:	ff 75 0c             	pushl  0xc(%ebp)
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  8003e0:	50                   	push   %eax
  8003e1:	68 78 03 80 00       	push   $0x800378
  8003e6:	e8 4f 01 00 00       	call   80053a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003eb:	83 c4 08             	add    $0x8,%esp
  8003ee:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8003f4:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	e8 1c 09 00 00       	call   800d1c <sys_cputs>

	return b.cnt;
  800400:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80040e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 9d ff ff ff       	call   8003b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	57                   	push   %edi
  800420:	56                   	push   %esi
  800421:	53                   	push   %ebx
  800422:	83 ec 0c             	sub    $0xc,%esp
  800425:	8b 75 10             	mov    0x10(%ebp),%esi
  800428:	8b 7d 14             	mov    0x14(%ebp),%edi
  80042b:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80042e:	8b 45 18             	mov    0x18(%ebp),%eax
  800431:	ba 00 00 00 00       	mov    $0x0,%edx
  800436:	39 fa                	cmp    %edi,%edx
  800438:	77 39                	ja     800473 <printnum+0x57>
  80043a:	72 04                	jb     800440 <printnum+0x24>
  80043c:	39 f0                	cmp    %esi,%eax
  80043e:	77 33                	ja     800473 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800449:	50                   	push   %eax
  80044a:	ff 75 18             	pushl  0x18(%ebp)
  80044d:	8b 45 18             	mov    0x18(%ebp),%eax
  800450:	ba 00 00 00 00       	mov    $0x0,%edx
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	57                   	push   %edi
  800458:	56                   	push   %esi
  800459:	e8 d6 23 00 00       	call   802834 <__udivdi3>
  80045e:	83 c4 10             	add    $0x10,%esp
  800461:	52                   	push   %edx
  800462:	50                   	push   %eax
  800463:	ff 75 0c             	pushl  0xc(%ebp)
  800466:	ff 75 08             	pushl  0x8(%ebp)
  800469:	e8 ae ff ff ff       	call   80041c <printnum>
  80046e:	83 c4 20             	add    $0x20,%esp
  800471:	eb 19                	jmp    80048c <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800473:	4b                   	dec    %ebx
  800474:	85 db                	test   %ebx,%ebx
  800476:	7e 14                	jle    80048c <printnum+0x70>
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	ff 75 0c             	pushl  0xc(%ebp)
  80047e:	ff 75 20             	pushl  0x20(%ebp)
  800481:	ff 55 08             	call   *0x8(%ebp)
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	4b                   	dec    %ebx
  800488:	85 db                	test   %ebx,%ebx
  80048a:	7f ec                	jg     800478 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 0c             	pushl  0xc(%ebp)
  800492:	8b 45 18             	mov    0x18(%ebp),%eax
  800495:	ba 00 00 00 00       	mov    $0x0,%edx
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	52                   	push   %edx
  80049e:	50                   	push   %eax
  80049f:	57                   	push   %edi
  8004a0:	56                   	push   %esi
  8004a1:	e8 9a 24 00 00       	call   802940 <__umoddi3>
  8004a6:	83 c4 14             	add    $0x14,%esp
  8004a9:	0f be 80 7e 2d 80 00 	movsbl 0x802d7e(%eax),%eax
  8004b0:	50                   	push   %eax
  8004b1:	ff 55 08             	call   *0x8(%ebp)
}
  8004b4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8004b7:	5b                   	pop    %ebx
  8004b8:	5e                   	pop    %esi
  8004b9:	5f                   	pop    %edi
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8004c5:	83 f8 01             	cmp    $0x1,%eax
  8004c8:	7e 0f                	jle    8004d9 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  8004ca:	8b 01                	mov    (%ecx),%eax
  8004cc:	83 c0 08             	add    $0x8,%eax
  8004cf:	89 01                	mov    %eax,(%ecx)
  8004d1:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8004d4:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8004d7:	eb 24                	jmp    8004fd <getuint+0x41>
	else if (lflag)
  8004d9:	85 c0                	test   %eax,%eax
  8004db:	74 11                	je     8004ee <getuint+0x32>
		return va_arg(*ap, unsigned long);
  8004dd:	8b 01                	mov    (%ecx),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 01                	mov    %eax,(%ecx)
  8004e4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8004e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ec:	eb 0f                	jmp    8004fd <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8004ee:	8b 01                	mov    (%ecx),%eax
  8004f0:	83 c0 04             	add    $0x4,%eax
  8004f3:	89 01                	mov    %eax,(%ecx)
  8004f5:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8004f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	8b 55 08             	mov    0x8(%ebp),%edx
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800508:	83 f8 01             	cmp    $0x1,%eax
  80050b:	7e 0f                	jle    80051c <getint+0x1d>
		return va_arg(*ap, long long);
  80050d:	8b 02                	mov    (%edx),%eax
  80050f:	83 c0 08             	add    $0x8,%eax
  800512:	89 02                	mov    %eax,(%edx)
  800514:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800517:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80051a:	eb 1c                	jmp    800538 <getint+0x39>
	else if (lflag)
  80051c:	85 c0                	test   %eax,%eax
  80051e:	74 0d                	je     80052d <getint+0x2e>
		return va_arg(*ap, long);
  800520:	8b 02                	mov    (%edx),%eax
  800522:	83 c0 04             	add    $0x4,%eax
  800525:	89 02                	mov    %eax,(%edx)
  800527:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80052a:	99                   	cltd   
  80052b:	eb 0b                	jmp    800538 <getint+0x39>
	else
		return va_arg(*ap, int);
  80052d:	8b 02                	mov    (%edx),%eax
  80052f:	83 c0 04             	add    $0x4,%eax
  800532:	89 02                	mov    %eax,(%edx)
  800534:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800537:	99                   	cltd   
}
  800538:	c9                   	leave  
  800539:	c3                   	ret    

0080053a <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	57                   	push   %edi
  80053e:	56                   	push   %esi
  80053f:	53                   	push   %ebx
  800540:	83 ec 1c             	sub    $0x1c,%esp
  800543:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  800546:	0f b6 13             	movzbl (%ebx),%edx
  800549:	43                   	inc    %ebx
  80054a:	83 fa 25             	cmp    $0x25,%edx
  80054d:	74 1e                	je     80056d <vprintfmt+0x33>
  80054f:	85 d2                	test   %edx,%edx
  800551:	0f 84 d7 02 00 00    	je     80082e <vprintfmt+0x2f4>
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	ff 75 0c             	pushl  0xc(%ebp)
  80055d:	52                   	push   %edx
  80055e:	ff 55 08             	call   *0x8(%ebp)
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	0f b6 13             	movzbl (%ebx),%edx
  800567:	43                   	inc    %ebx
  800568:	83 fa 25             	cmp    $0x25,%edx
  80056b:	75 e2                	jne    80054f <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  80056d:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800571:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800578:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  80057d:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800582:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800589:	0f b6 13             	movzbl (%ebx),%edx
  80058c:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  80058f:	43                   	inc    %ebx
  800590:	83 f8 55             	cmp    $0x55,%eax
  800593:	0f 87 70 02 00 00    	ja     800809 <vprintfmt+0x2cf>
  800599:	ff 24 85 fc 2d 80 00 	jmp    *0x802dfc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a0:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  8005a4:	eb e3                	jmp    800589 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a6:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  8005aa:	eb dd                	jmp    800589 <vprintfmt+0x4f>

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
  8005ac:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8005b1:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8005b4:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8005b8:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8005bb:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8005be:	83 f8 09             	cmp    $0x9,%eax
  8005c1:	77 27                	ja     8005ea <vprintfmt+0xb0>
  8005c3:	43                   	inc    %ebx
  8005c4:	eb eb                	jmp    8005b1 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005c6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  8005d0:	eb 18                	jmp    8005ea <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  8005d2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005d6:	79 b1                	jns    800589 <vprintfmt+0x4f>
				width = 0;
  8005d8:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  8005df:	eb a8                	jmp    800589 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  8005e1:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8005e8:	eb 9f                	jmp    800589 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8005ea:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005ee:	79 99                	jns    800589 <vprintfmt+0x4f>
				width = precision, precision = -1;
  8005f0:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8005f3:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8005f8:	eb 8f                	jmp    800589 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005fa:	41                   	inc    %ecx
			goto reswitch;
  8005fb:	eb 8c                	jmp    800589 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	ff 70 fc             	pushl  0xfffffffc(%eax)
  80060d:	ff 55 08             	call   *0x8(%ebp)
			break;
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	e9 2e ff ff ff       	jmp    800546 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800618:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  800622:	85 c0                	test   %eax,%eax
  800624:	79 02                	jns    800628 <vprintfmt+0xee>
				err = -err;
  800626:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800628:	83 f8 0e             	cmp    $0xe,%eax
  80062b:	7f 0b                	jg     800638 <vprintfmt+0xfe>
  80062d:	8b 3c 85 c0 2d 80 00 	mov    0x802dc0(,%eax,4),%edi
  800634:	85 ff                	test   %edi,%edi
  800636:	75 19                	jne    800651 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  800638:	50                   	push   %eax
  800639:	68 8f 2d 80 00       	push   $0x802d8f
  80063e:	ff 75 0c             	pushl  0xc(%ebp)
  800641:	ff 75 08             	pushl  0x8(%ebp)
  800644:	e8 ed 01 00 00       	call   800836 <printfmt>
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	e9 f5 fe ff ff       	jmp    800546 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800651:	57                   	push   %edi
  800652:	68 01 32 80 00       	push   $0x803201
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	e8 d4 01 00 00       	call   800836 <printfmt>
  800662:	83 c4 10             	add    $0x10,%esp
			break;
  800665:	e9 dc fe ff ff       	jmp    800546 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80066a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800674:	85 ff                	test   %edi,%edi
  800676:	75 05                	jne    80067d <vprintfmt+0x143>
				p = "(null)";
  800678:	bf 98 2d 80 00       	mov    $0x802d98,%edi
			if (width > 0 && padc != '-')
  80067d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800681:	7e 3b                	jle    8006be <vprintfmt+0x184>
  800683:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  800687:	74 35                	je     8006be <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	56                   	push   %esi
  80068d:	57                   	push   %edi
  80068e:	e8 56 03 00 00       	call   8009e9 <strnlen>
  800693:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  800696:	83 c4 10             	add    $0x10,%esp
  800699:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80069d:	7e 1f                	jle    8006be <vprintfmt+0x184>
  80069f:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8006a3:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ac:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8006af:	ff 55 08             	call   *0x8(%ebp)
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8006b8:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8006bc:	7f e8                	jg     8006a6 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006be:	0f be 17             	movsbl (%edi),%edx
  8006c1:	47                   	inc    %edi
  8006c2:	85 d2                	test   %edx,%edx
  8006c4:	74 44                	je     80070a <vprintfmt+0x1d0>
  8006c6:	85 f6                	test   %esi,%esi
  8006c8:	78 03                	js     8006cd <vprintfmt+0x193>
  8006ca:	4e                   	dec    %esi
  8006cb:	78 3d                	js     80070a <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  8006cd:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  8006d1:	74 18                	je     8006eb <vprintfmt+0x1b1>
  8006d3:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  8006d6:	83 f8 5e             	cmp    $0x5e,%eax
  8006d9:	76 10                	jbe    8006eb <vprintfmt+0x1b1>
					putch('?', putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	6a 3f                	push   $0x3f
  8006e3:	ff 55 08             	call   *0x8(%ebp)
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	eb 0d                	jmp    8006f8 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	ff 75 0c             	pushl  0xc(%ebp)
  8006f1:	52                   	push   %edx
  8006f2:	ff 55 08             	call   *0x8(%ebp)
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8006fb:	0f be 17             	movsbl (%edi),%edx
  8006fe:	47                   	inc    %edi
  8006ff:	85 d2                	test   %edx,%edx
  800701:	74 07                	je     80070a <vprintfmt+0x1d0>
  800703:	85 f6                	test   %esi,%esi
  800705:	78 c6                	js     8006cd <vprintfmt+0x193>
  800707:	4e                   	dec    %esi
  800708:	79 c3                	jns    8006cd <vprintfmt+0x193>
			for (; width > 0; width--)
  80070a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80070e:	0f 8e 32 fe ff ff    	jle    800546 <vprintfmt+0xc>
				putch(' ', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	6a 20                	push   $0x20
  80071c:	ff 55 08             	call   *0x8(%ebp)
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800725:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800729:	7f e9                	jg     800714 <vprintfmt+0x1da>
			break;
  80072b:	e9 16 fe ff ff       	jmp    800546 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800730:	51                   	push   %ecx
  800731:	8d 45 14             	lea    0x14(%ebp),%eax
  800734:	50                   	push   %eax
  800735:	e8 c5 fd ff ff       	call   8004ff <getint>
  80073a:	89 c6                	mov    %eax,%esi
  80073c:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  80073e:	83 c4 08             	add    $0x8,%esp
  800741:	85 d2                	test   %edx,%edx
  800743:	79 15                	jns    80075a <vprintfmt+0x220>
				putch('-', putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	6a 2d                	push   $0x2d
  80074d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800750:	f7 de                	neg    %esi
  800752:	83 d7 00             	adc    $0x0,%edi
  800755:	f7 df                	neg    %edi
  800757:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80075a:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80075f:	eb 75                	jmp    8007d6 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800761:	51                   	push   %ecx
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
  800765:	50                   	push   %eax
  800766:	e8 51 fd ff ff       	call   8004bc <getuint>
  80076b:	89 c6                	mov    %eax,%esi
  80076d:	89 d7                	mov    %edx,%edi
			base = 10;
  80076f:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800774:	83 c4 08             	add    $0x8,%esp
  800777:	eb 5d                	jmp    8007d6 <vprintfmt+0x29c>

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
  800779:	51                   	push   %ecx
  80077a:	8d 45 14             	lea    0x14(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	e8 39 fd ff ff       	call   8004bc <getuint>
  800783:	89 c6                	mov    %eax,%esi
  800785:	89 d7                	mov    %edx,%edi
			base = 8;
  800787:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  80078c:	83 c4 08             	add    $0x8,%esp
  80078f:	eb 45                	jmp    8007d6 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	6a 30                	push   $0x30
  800799:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80079c:	83 c4 08             	add    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 78                	push   $0x78
  8007a4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8007a7:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  8007b1:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007b6:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	eb 16                	jmp    8007d6 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007c0:	51                   	push   %ecx
  8007c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c4:	50                   	push   %eax
  8007c5:	e8 f2 fc ff ff       	call   8004bc <getuint>
  8007ca:	89 c6                	mov    %eax,%esi
  8007cc:	89 d7                	mov    %edx,%edi
			base = 16;
  8007ce:	ba 10 00 00 00       	mov    $0x10,%edx
  8007d3:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007d6:	83 ec 04             	sub    $0x4,%esp
  8007d9:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8007dd:	50                   	push   %eax
  8007de:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8007e1:	52                   	push   %edx
  8007e2:	57                   	push   %edi
  8007e3:	56                   	push   %esi
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	ff 75 08             	pushl  0x8(%ebp)
  8007ea:	e8 2d fc ff ff       	call   80041c <printnum>
			break;
  8007ef:	83 c4 20             	add    $0x20,%esp
  8007f2:	e9 4f fd ff ff       	jmp    800546 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	52                   	push   %edx
  8007fe:	ff 55 08             	call   *0x8(%ebp)
			break;
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	e9 3d fd ff ff       	jmp    800546 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	6a 25                	push   $0x25
  800811:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800814:	4b                   	dec    %ebx
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80081c:	0f 84 24 fd ff ff    	je     800546 <vprintfmt+0xc>
  800822:	4b                   	dec    %ebx
  800823:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800827:	75 f9                	jne    800822 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  800829:	e9 18 fd ff ff       	jmp    800546 <vprintfmt+0xc>
		}
	}
}
  80082e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800831:	5b                   	pop    %ebx
  800832:	5e                   	pop    %esi
  800833:	5f                   	pop    %edi
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80083c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80083f:	50                   	push   %eax
  800840:	ff 75 10             	pushl  0x10(%ebp)
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	ff 75 08             	pushl  0x8(%ebp)
  800849:	e8 ec fc ff ff       	call   80053a <vprintfmt>
	va_end(ap);
}
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  800856:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800859:	8b 0a                	mov    (%edx),%ecx
  80085b:	3b 4a 04             	cmp    0x4(%edx),%ecx
  80085e:	73 07                	jae    800867 <sprintputch+0x17>
		*b->buf++ = ch;
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	88 01                	mov    %al,(%ecx)
  800865:	ff 02                	incl   (%edx)
}
  800867:	c9                   	leave  
  800868:	c3                   	ret    

00800869 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	83 ec 18             	sub    $0x18,%esp
  80086f:	8b 55 08             	mov    0x8(%ebp),%edx
  800872:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800875:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800878:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  80087c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80087f:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  800886:	85 d2                	test   %edx,%edx
  800888:	74 04                	je     80088e <vsnprintf+0x25>
  80088a:	85 c9                	test   %ecx,%ecx
  80088c:	7f 07                	jg     800895 <vsnprintf+0x2c>
		return -E_INVAL;
  80088e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800893:	eb 1d                	jmp    8008b2 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800895:	ff 75 14             	pushl  0x14(%ebp)
  800898:	ff 75 10             	pushl  0x10(%ebp)
  80089b:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  80089e:	50                   	push   %eax
  80089f:	68 50 08 80 00       	push   $0x800850
  8008a4:	e8 91 fc ff ff       	call   80053a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a9:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  8008ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008af:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    

008008b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ba:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008bd:	50                   	push   %eax
  8008be:	ff 75 10             	pushl  0x10(%ebp)
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	ff 75 08             	pushl  0x8(%ebp)
  8008c7:	e8 9d ff ff ff       	call   800869 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    
	...

008008d0 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	56                   	push   %esi
  8008d4:	53                   	push   %ebx
  8008d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  8008d8:	83 ec 0c             	sub    $0xc,%esp
  8008db:	56                   	push   %esi
  8008dc:	e8 ef 00 00 00       	call   8009d0 <strlen>
  char letter;
  int hexnum = 0;
  8008e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  8008e6:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 c2                	mov    %eax,%edx
  8008f0:	4a                   	dec    %edx
  8008f1:	0f 88 d0 00 00 00    	js     8009c7 <strtoint+0xf7>
    letter = string[cidx];
  8008f7:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8008fa:	85 d2                	test   %edx,%edx
  8008fc:	75 12                	jne    800910 <strtoint+0x40>
      if (letter != '0') {
  8008fe:	3c 30                	cmp    $0x30,%al
  800900:	0f 84 ba 00 00 00    	je     8009c0 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800906:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80090b:	e9 b9 00 00 00       	jmp    8009c9 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800910:	83 fa 01             	cmp    $0x1,%edx
  800913:	75 12                	jne    800927 <strtoint+0x57>
      if (letter != 'x') {
  800915:	3c 78                	cmp    $0x78,%al
  800917:	0f 84 a3 00 00 00    	je     8009c0 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80091d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800922:	e9 a2 00 00 00       	jmp    8009c9 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  800927:	0f be c0             	movsbl %al,%eax
  80092a:	83 e8 30             	sub    $0x30,%eax
  80092d:	83 f8 36             	cmp    $0x36,%eax
  800930:	0f 87 80 00 00 00    	ja     8009b6 <strtoint+0xe6>
  800936:	ff 24 85 54 2f 80 00 	jmp    *0x802f54(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  80093d:	01 cb                	add    %ecx,%ebx
          break;
  80093f:	eb 7c                	jmp    8009bd <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800941:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800944:	eb 77                	jmp    8009bd <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  800946:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800949:	01 c3                	add    %eax,%ebx
          break;
  80094b:	eb 70                	jmp    8009bd <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  80094d:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800950:	eb 6b                	jmp    8009bd <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800952:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800955:	01 c3                	add    %eax,%ebx
          break;
  800957:	eb 64                	jmp    8009bd <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800959:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80095c:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80095f:	eb 5c                	jmp    8009bd <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800961:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800968:	29 c8                	sub    %ecx,%eax
  80096a:	01 c3                	add    %eax,%ebx
          break;
  80096c:	eb 4f                	jmp    8009bd <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  80096e:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800971:	eb 4a                	jmp    8009bd <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  800973:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  800976:	01 c3                	add    %eax,%ebx
          break;
  800978:	eb 43                	jmp    8009bd <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  80097a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  80097d:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800980:	eb 3b                	jmp    8009bd <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800982:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800985:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800988:	01 c3                	add    %eax,%ebx
          break;
  80098a:	eb 31                	jmp    8009bd <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  80098c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80098f:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800992:	eb 29                	jmp    8009bd <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800994:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800997:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80099a:	01 c3                	add    %eax,%ebx
          break;
  80099c:	eb 1f                	jmp    8009bd <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  80099e:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8009a5:	29 c8                	sub    %ecx,%eax
  8009a7:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8009aa:	eb 11                	jmp    8009bd <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8009ac:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009af:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8009b2:	01 c3                	add    %eax,%ebx
          break;
  8009b4:	eb 07                	jmp    8009bd <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8009b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8009bb:	eb 0c                	jmp    8009c9 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  8009bd:	c1 e1 04             	shl    $0x4,%ecx
  8009c0:	4a                   	dec    %edx
  8009c1:	0f 89 30 ff ff ff    	jns    8008f7 <strtoint+0x27>
    }
  }

  return hexnum;
  8009c7:	89 d8                	mov    %ebx,%eax
}
  8009c9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8009cc:	5b                   	pop    %ebx
  8009cd:	5e                   	pop    %esi
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <strlen>:





int
strlen(const char *s)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009db:	80 3a 00             	cmpb   $0x0,(%edx)
  8009de:	74 07                	je     8009e7 <strlen+0x17>
		n++;
  8009e0:	40                   	inc    %eax
  8009e1:	42                   	inc    %edx
  8009e2:	80 3a 00             	cmpb   $0x0,(%edx)
  8009e5:	75 f9                	jne    8009e0 <strlen+0x10>
	return n;
}
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f7:	85 d2                	test   %edx,%edx
  8009f9:	74 0f                	je     800a0a <strnlen+0x21>
  8009fb:	80 39 00             	cmpb   $0x0,(%ecx)
  8009fe:	74 0a                	je     800a0a <strnlen+0x21>
		n++;
  800a00:	40                   	inc    %eax
  800a01:	41                   	inc    %ecx
  800a02:	4a                   	dec    %edx
  800a03:	74 05                	je     800a0a <strnlen+0x21>
  800a05:	80 39 00             	cmpb   $0x0,(%ecx)
  800a08:	75 f6                	jne    800a00 <strnlen+0x17>
	return n;
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	53                   	push   %ebx
  800a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a13:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800a16:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800a18:	8a 02                	mov    (%edx),%al
  800a1a:	42                   	inc    %edx
  800a1b:	88 01                	mov    %al,(%ecx)
  800a1d:	41                   	inc    %ecx
  800a1e:	84 c0                	test   %al,%al
  800a20:	75 f6                	jne    800a18 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a22:	89 d8                	mov    %ebx,%eax
  800a24:	5b                   	pop    %ebx
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a33:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  800a36:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800a38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a3d:	39 f3                	cmp    %esi,%ebx
  800a3f:	73 10                	jae    800a51 <strncpy+0x2a>
		*dst++ = *src;
  800a41:	8a 02                	mov    (%edx),%al
  800a43:	88 01                	mov    %al,(%ecx)
  800a45:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a46:	80 3a 01             	cmpb   $0x1,(%edx)
  800a49:	83 da ff             	sbb    $0xffffffff,%edx
  800a4c:	43                   	inc    %ebx
  800a4d:	39 f3                	cmp    %esi,%ebx
  800a4f:	72 f0                	jb     800a41 <strncpy+0x1a>
	}
	return ret;
}
  800a51:	89 f8                	mov    %edi,%eax
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5f                   	pop    %edi
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	56                   	push   %esi
  800a5c:	53                   	push   %ebx
  800a5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a63:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  800a66:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800a68:	85 d2                	test   %edx,%edx
  800a6a:	74 19                	je     800a85 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a6c:	4a                   	dec    %edx
  800a6d:	74 13                	je     800a82 <strlcpy+0x2a>
  800a6f:	80 39 00             	cmpb   $0x0,(%ecx)
  800a72:	74 0e                	je     800a82 <strlcpy+0x2a>
  800a74:	8a 01                	mov    (%ecx),%al
  800a76:	41                   	inc    %ecx
  800a77:	88 03                	mov    %al,(%ebx)
  800a79:	43                   	inc    %ebx
  800a7a:	4a                   	dec    %edx
  800a7b:	74 05                	je     800a82 <strlcpy+0x2a>
  800a7d:	80 39 00             	cmpb   $0x0,(%ecx)
  800a80:	75 f2                	jne    800a74 <strlcpy+0x1c>
		*dst = '\0';
  800a82:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800a85:	89 d8                	mov    %ebx,%eax
  800a87:	29 f0                	sub    %esi,%eax
}
  800a89:	5b                   	pop    %ebx
  800a8a:	5e                   	pop    %esi
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800a96:	80 3a 00             	cmpb   $0x0,(%edx)
  800a99:	74 13                	je     800aae <strcmp+0x21>
  800a9b:	8a 02                	mov    (%edx),%al
  800a9d:	3a 01                	cmp    (%ecx),%al
  800a9f:	75 0d                	jne    800aae <strcmp+0x21>
  800aa1:	42                   	inc    %edx
  800aa2:	41                   	inc    %ecx
  800aa3:	80 3a 00             	cmpb   $0x0,(%edx)
  800aa6:	74 06                	je     800aae <strcmp+0x21>
  800aa8:	8a 02                	mov    (%edx),%al
  800aaa:	3a 01                	cmp    (%ecx),%al
  800aac:	74 f3                	je     800aa1 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aae:	0f b6 02             	movzbl (%edx),%eax
  800ab1:	0f b6 11             	movzbl (%ecx),%edx
  800ab4:	29 d0                	sub    %edx,%eax
}
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	53                   	push   %ebx
  800abc:	8b 55 08             	mov    0x8(%ebp),%edx
  800abf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800ac5:	85 c9                	test   %ecx,%ecx
  800ac7:	74 1f                	je     800ae8 <strncmp+0x30>
  800ac9:	80 3a 00             	cmpb   $0x0,(%edx)
  800acc:	74 16                	je     800ae4 <strncmp+0x2c>
  800ace:	8a 02                	mov    (%edx),%al
  800ad0:	3a 03                	cmp    (%ebx),%al
  800ad2:	75 10                	jne    800ae4 <strncmp+0x2c>
  800ad4:	42                   	inc    %edx
  800ad5:	43                   	inc    %ebx
  800ad6:	49                   	dec    %ecx
  800ad7:	74 0f                	je     800ae8 <strncmp+0x30>
  800ad9:	80 3a 00             	cmpb   $0x0,(%edx)
  800adc:	74 06                	je     800ae4 <strncmp+0x2c>
  800ade:	8a 02                	mov    (%edx),%al
  800ae0:	3a 03                	cmp    (%ebx),%al
  800ae2:	74 f0                	je     800ad4 <strncmp+0x1c>
	if (n == 0)
  800ae4:	85 c9                	test   %ecx,%ecx
  800ae6:	75 07                	jne    800aef <strncmp+0x37>
		return 0;
  800ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  800aed:	eb 0a                	jmp    800af9 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aef:	0f b6 12             	movzbl (%edx),%edx
  800af2:	0f b6 03             	movzbl (%ebx),%eax
  800af5:	29 c2                	sub    %eax,%edx
  800af7:	89 d0                	mov    %edx,%eax
}
  800af9:	5b                   	pop    %ebx
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800b05:	80 38 00             	cmpb   $0x0,(%eax)
  800b08:	74 0a                	je     800b14 <strchr+0x18>
		if (*s == c)
  800b0a:	38 10                	cmp    %dl,(%eax)
  800b0c:	74 0b                	je     800b19 <strchr+0x1d>
  800b0e:	40                   	inc    %eax
  800b0f:	80 38 00             	cmpb   $0x0,(%eax)
  800b12:	75 f6                	jne    800b0a <strchr+0xe>
			return (char *) s;
	return 0;
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800b24:	80 38 00             	cmpb   $0x0,(%eax)
  800b27:	74 0a                	je     800b33 <strfind+0x18>
		if (*s == c)
  800b29:	38 10                	cmp    %dl,(%eax)
  800b2b:	74 06                	je     800b33 <strfind+0x18>
  800b2d:	40                   	inc    %eax
  800b2e:	80 38 00             	cmpb   $0x0,(%eax)
  800b31:	75 f6                	jne    800b29 <strfind+0xe>
			break;
	return (char *) s;
}
  800b33:	c9                   	leave  
  800b34:	c3                   	ret    

00800b35 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	57                   	push   %edi
  800b39:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800b3f:	89 f8                	mov    %edi,%eax
  800b41:	85 c9                	test   %ecx,%ecx
  800b43:	74 40                	je     800b85 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800b45:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b4b:	75 30                	jne    800b7d <memset+0x48>
  800b4d:	f6 c1 03             	test   $0x3,%cl
  800b50:	75 2b                	jne    800b7d <memset+0x48>
		c &= 0xFF;
  800b52:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	c1 e0 18             	shl    $0x18,%eax
  800b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b62:	c1 e2 10             	shl    $0x10,%edx
  800b65:	09 d0                	or     %edx,%eax
  800b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6a:	c1 e2 08             	shl    $0x8,%edx
  800b6d:	09 d0                	or     %edx,%eax
  800b6f:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800b72:	c1 e9 02             	shr    $0x2,%ecx
  800b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b78:	fc                   	cld    
  800b79:	f3 ab                	repz stos %eax,%es:(%edi)
  800b7b:	eb 06                	jmp    800b83 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	fc                   	cld    
  800b81:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800b83:	89 f8                	mov    %edi,%eax
}
  800b85:	5f                   	pop    %edi
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b93:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b96:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b98:	39 c6                	cmp    %eax,%esi
  800b9a:	73 33                	jae    800bcf <memmove+0x47>
  800b9c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b9f:	39 c2                	cmp    %eax,%edx
  800ba1:	76 2c                	jbe    800bcf <memmove+0x47>
		s += n;
  800ba3:	89 d6                	mov    %edx,%esi
		d += n;
  800ba5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba8:	f6 c2 03             	test   $0x3,%dl
  800bab:	75 1b                	jne    800bc8 <memmove+0x40>
  800bad:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bb3:	75 13                	jne    800bc8 <memmove+0x40>
  800bb5:	f6 c1 03             	test   $0x3,%cl
  800bb8:	75 0e                	jne    800bc8 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800bba:	83 ef 04             	sub    $0x4,%edi
  800bbd:	83 ee 04             	sub    $0x4,%esi
  800bc0:	c1 e9 02             	shr    $0x2,%ecx
  800bc3:	fd                   	std    
  800bc4:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800bc6:	eb 27                	jmp    800bef <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bc8:	4f                   	dec    %edi
  800bc9:	4e                   	dec    %esi
  800bca:	fd                   	std    
  800bcb:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800bcd:	eb 20                	jmp    800bef <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bcf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bd5:	75 15                	jne    800bec <memmove+0x64>
  800bd7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bdd:	75 0d                	jne    800bec <memmove+0x64>
  800bdf:	f6 c1 03             	test   $0x3,%cl
  800be2:	75 08                	jne    800bec <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800be4:	c1 e9 02             	shr    $0x2,%ecx
  800be7:	fc                   	cld    
  800be8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800bea:	eb 03                	jmp    800bef <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bec:	fc                   	cld    
  800bed:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <memcpy>:

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
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800bf6:	ff 75 10             	pushl  0x10(%ebp)
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	ff 75 08             	pushl  0x8(%ebp)
  800bff:	e8 84 ff ff ff       	call   800b88 <memmove>
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800c0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800c0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c10:	8b 55 10             	mov    0x10(%ebp),%edx
  800c13:	4a                   	dec    %edx
  800c14:	83 fa ff             	cmp    $0xffffffff,%edx
  800c17:	74 1a                	je     800c33 <memcmp+0x2d>
  800c19:	8a 01                	mov    (%ecx),%al
  800c1b:	3a 03                	cmp    (%ebx),%al
  800c1d:	74 0c                	je     800c2b <memcmp+0x25>
  800c1f:	0f b6 d0             	movzbl %al,%edx
  800c22:	0f b6 03             	movzbl (%ebx),%eax
  800c25:	29 c2                	sub    %eax,%edx
  800c27:	89 d0                	mov    %edx,%eax
  800c29:	eb 0d                	jmp    800c38 <memcmp+0x32>
  800c2b:	41                   	inc    %ecx
  800c2c:	43                   	inc    %ebx
  800c2d:	4a                   	dec    %edx
  800c2e:	83 fa ff             	cmp    $0xffffffff,%edx
  800c31:	75 e6                	jne    800c19 <memcmp+0x13>
	}

	return 0;
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c44:	89 c2                	mov    %eax,%edx
  800c46:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c49:	39 d0                	cmp    %edx,%eax
  800c4b:	73 09                	jae    800c56 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c4d:	38 08                	cmp    %cl,(%eax)
  800c4f:	74 05                	je     800c56 <memfind+0x1b>
  800c51:	40                   	inc    %eax
  800c52:	39 d0                	cmp    %edx,%eax
  800c54:	72 f7                	jb     800c4d <memfind+0x12>
			break;
	return (void *) s;
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c64:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800c67:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800c6c:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800c71:	80 3a 20             	cmpb   $0x20,(%edx)
  800c74:	74 05                	je     800c7b <strtol+0x23>
  800c76:	80 3a 09             	cmpb   $0x9,(%edx)
  800c79:	75 0b                	jne    800c86 <strtol+0x2e>
  800c7b:	42                   	inc    %edx
  800c7c:	80 3a 20             	cmpb   $0x20,(%edx)
  800c7f:	74 fa                	je     800c7b <strtol+0x23>
  800c81:	80 3a 09             	cmpb   $0x9,(%edx)
  800c84:	74 f5                	je     800c7b <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800c86:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800c89:	75 03                	jne    800c8e <strtol+0x36>
		s++;
  800c8b:	42                   	inc    %edx
  800c8c:	eb 0b                	jmp    800c99 <strtol+0x41>
	else if (*s == '-')
  800c8e:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800c91:	75 06                	jne    800c99 <strtol+0x41>
		s++, neg = 1;
  800c93:	42                   	inc    %edx
  800c94:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c99:	85 c9                	test   %ecx,%ecx
  800c9b:	74 05                	je     800ca2 <strtol+0x4a>
  800c9d:	83 f9 10             	cmp    $0x10,%ecx
  800ca0:	75 15                	jne    800cb7 <strtol+0x5f>
  800ca2:	80 3a 30             	cmpb   $0x30,(%edx)
  800ca5:	75 10                	jne    800cb7 <strtol+0x5f>
  800ca7:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cab:	75 0a                	jne    800cb7 <strtol+0x5f>
		s += 2, base = 16;
  800cad:	83 c2 02             	add    $0x2,%edx
  800cb0:	b9 10 00 00 00       	mov    $0x10,%ecx
  800cb5:	eb 14                	jmp    800ccb <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800cb7:	85 c9                	test   %ecx,%ecx
  800cb9:	75 10                	jne    800ccb <strtol+0x73>
  800cbb:	80 3a 30             	cmpb   $0x30,(%edx)
  800cbe:	75 05                	jne    800cc5 <strtol+0x6d>
		s++, base = 8;
  800cc0:	42                   	inc    %edx
  800cc1:	b1 08                	mov    $0x8,%cl
  800cc3:	eb 06                	jmp    800ccb <strtol+0x73>
	else if (base == 0)
  800cc5:	85 c9                	test   %ecx,%ecx
  800cc7:	75 02                	jne    800ccb <strtol+0x73>
		base = 10;
  800cc9:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ccb:	8a 02                	mov    (%edx),%al
  800ccd:	83 e8 30             	sub    $0x30,%eax
  800cd0:	3c 09                	cmp    $0x9,%al
  800cd2:	77 08                	ja     800cdc <strtol+0x84>
			dig = *s - '0';
  800cd4:	0f be 02             	movsbl (%edx),%eax
  800cd7:	83 e8 30             	sub    $0x30,%eax
  800cda:	eb 20                	jmp    800cfc <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800cdc:	8a 02                	mov    (%edx),%al
  800cde:	83 e8 61             	sub    $0x61,%eax
  800ce1:	3c 19                	cmp    $0x19,%al
  800ce3:	77 08                	ja     800ced <strtol+0x95>
			dig = *s - 'a' + 10;
  800ce5:	0f be 02             	movsbl (%edx),%eax
  800ce8:	83 e8 57             	sub    $0x57,%eax
  800ceb:	eb 0f                	jmp    800cfc <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800ced:	8a 02                	mov    (%edx),%al
  800cef:	83 e8 41             	sub    $0x41,%eax
  800cf2:	3c 19                	cmp    $0x19,%al
  800cf4:	77 12                	ja     800d08 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800cf6:	0f be 02             	movsbl (%edx),%eax
  800cf9:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800cfc:	39 c8                	cmp    %ecx,%eax
  800cfe:	7d 08                	jge    800d08 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800d00:	42                   	inc    %edx
  800d01:	0f af d9             	imul   %ecx,%ebx
  800d04:	01 c3                	add    %eax,%ebx
  800d06:	eb c3                	jmp    800ccb <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d08:	85 f6                	test   %esi,%esi
  800d0a:	74 02                	je     800d0e <strtol+0xb6>
		*endptr = (char *) s;
  800d0c:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d0e:	89 d8                	mov    %ebx,%eax
  800d10:	85 ff                	test   %edi,%edi
  800d12:	74 02                	je     800d16 <strtol+0xbe>
  800d14:	f7 d8                	neg    %eax
}
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    
	...

00800d1c <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
  800d22:	83 ec 04             	sub    $0x4,%esp
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d30:	89 f8                	mov    %edi,%eax
  800d32:	89 fb                	mov    %edi,%ebx
  800d34:	89 fe                	mov    %edi,%esi
  800d36:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d38:	83 c4 04             	add    $0x4,%esp
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5f                   	pop    %edi
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	b8 01 00 00 00       	mov    $0x1,%eax
  800d4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d50:	89 fa                	mov    %edi,%edx
  800d52:	89 f9                	mov    %edi,%ecx
  800d54:	89 fb                	mov    %edi,%ebx
  800d56:	89 fe                	mov    %edi,%esi
  800d58:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	83 ec 0c             	sub    $0xc,%esp
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800d70:	bf 00 00 00 00       	mov    $0x0,%edi
  800d75:	89 f9                	mov    %edi,%ecx
  800d77:	89 fb                	mov    %edi,%ebx
  800d79:	89 fe                	mov    %edi,%esi
  800d7b:	cd 30                	int    $0x30
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	7e 17                	jle    800d98 <sys_env_destroy+0x39>
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 03                	push   $0x3
  800d87:	68 30 30 80 00       	push   $0x803030
  800d8c:	6a 23                	push   $0x23
  800d8e:	68 4d 30 80 00       	push   $0x80304d
  800d93:	e8 80 f5 ff ff       	call   800318 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dab:	bf 00 00 00 00       	mov    $0x0,%edi
  800db0:	89 fa                	mov    %edi,%edx
  800db2:	89 f9                	mov    %edi,%ecx
  800db4:	89 fb                	mov    %edi,%ebx
  800db6:	89 fe                	mov    %edi,%esi
  800db8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <sys_yield>:

void
sys_yield(void)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dca:	bf 00 00 00 00       	mov    $0x0,%edi
  800dcf:	89 fa                	mov    %edi,%edx
  800dd1:	89 f9                	mov    %edi,%ecx
  800dd3:	89 fb                	mov    %edi,%ebx
  800dd5:	89 fe                	mov    %edi,%esi
  800dd7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	57                   	push   %edi
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ded:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df0:	b8 04 00 00 00       	mov    $0x4,%eax
  800df5:	bf 00 00 00 00       	mov    $0x0,%edi
  800dfa:	89 fe                	mov    %edi,%esi
  800dfc:	cd 30                	int    $0x30
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	7e 17                	jle    800e19 <sys_page_alloc+0x3b>
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 04                	push   $0x4
  800e08:	68 30 30 80 00       	push   $0x803030
  800e0d:	6a 23                	push   $0x23
  800e0f:	68 4d 30 80 00       	push   $0x80304d
  800e14:	e8 ff f4 ff ff       	call   800318 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e19:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e36:	8b 75 18             	mov    0x18(%ebp),%esi
  800e39:	b8 05 00 00 00       	mov    $0x5,%eax
  800e3e:	cd 30                	int    $0x30
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7e 17                	jle    800e5b <sys_page_map+0x3a>
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 05                	push   $0x5
  800e4a:	68 30 30 80 00       	push   $0x803030
  800e4f:	6a 23                	push   $0x23
  800e51:	68 4d 30 80 00       	push   $0x80304d
  800e56:	e8 bd f4 ff ff       	call   800318 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e5b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	c9                   	leave  
  800e62:	c3                   	ret    

00800e63 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 06 00 00 00       	mov    $0x6,%eax
  800e77:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7c:	89 fb                	mov    %edi,%ebx
  800e7e:	89 fe                	mov    %edi,%esi
  800e80:	cd 30                	int    $0x30
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7e 17                	jle    800e9d <sys_page_unmap+0x3a>
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 06                	push   $0x6
  800e8c:	68 30 30 80 00       	push   $0x803030
  800e91:	6a 23                	push   $0x23
  800e93:	68 4d 30 80 00       	push   $0x80304d
  800e98:	e8 7b f4 ff ff       	call   800318 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e9d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ebe:	89 fb                	mov    %edi,%ebx
  800ec0:	89 fe                	mov    %edi,%esi
  800ec2:	cd 30                	int    $0x30
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7e 17                	jle    800edf <sys_env_set_status+0x3a>
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 08                	push   $0x8
  800ece:	68 30 30 80 00       	push   $0x803030
  800ed3:	6a 23                	push   $0x23
  800ed5:	68 4d 30 80 00       	push   $0x80304d
  800eda:	e8 39 f4 ff ff       	call   800318 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800edf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	83 ec 0c             	sub    $0xc,%esp
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	b8 09 00 00 00       	mov    $0x9,%eax
  800efb:	bf 00 00 00 00       	mov    $0x0,%edi
  800f00:	89 fb                	mov    %edi,%ebx
  800f02:	89 fe                	mov    %edi,%esi
  800f04:	cd 30                	int    $0x30
  800f06:	85 c0                	test   %eax,%eax
  800f08:	7e 17                	jle    800f21 <sys_env_set_trapframe+0x3a>
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	6a 09                	push   $0x9
  800f10:	68 30 30 80 00       	push   $0x803030
  800f15:	6a 23                	push   $0x23
  800f17:	68 4d 30 80 00       	push   $0x80304d
  800f1c:	e8 f7 f3 ff ff       	call   800318 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f21:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800f42:	89 fb                	mov    %edi,%ebx
  800f44:	89 fe                	mov    %edi,%esi
  800f46:	cd 30                	int    $0x30
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	7e 17                	jle    800f63 <sys_env_set_pgfault_upcall+0x3a>
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	50                   	push   %eax
  800f50:	6a 0a                	push   $0xa
  800f52:	68 30 30 80 00       	push   $0x803030
  800f57:	6a 23                	push   $0x23
  800f59:	68 4d 30 80 00       	push   $0x80304d
  800f5e:	e8 b5 f3 ff ff       	call   800318 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f63:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f82:	be 00 00 00 00       	mov    $0x0,%esi
  800f87:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f9f:	bf 00 00 00 00       	mov    $0x0,%edi
  800fa4:	89 f9                	mov    %edi,%ecx
  800fa6:	89 fb                	mov    %edi,%ebx
  800fa8:	89 fe                	mov    %edi,%esi
  800faa:	cd 30                	int    $0x30
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7e 17                	jle    800fc7 <sys_ipc_recv+0x39>
  800fb0:	83 ec 0c             	sub    $0xc,%esp
  800fb3:	50                   	push   %eax
  800fb4:	6a 0d                	push   $0xd
  800fb6:	68 30 30 80 00       	push   $0x803030
  800fbb:	6a 23                	push   $0x23
  800fbd:	68 4d 30 80 00       	push   $0x80304d
  800fc2:	e8 51 f3 ff ff       	call   800318 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    

00800fcf <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 0c             	sub    $0xc,%esp
  800fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	b8 10 00 00 00       	mov    $0x10,%eax
  800fe3:	bf 00 00 00 00       	mov    $0x0,%edi
  800fe8:	89 fb                	mov    %edi,%ebx
  800fea:	89 fe                	mov    %edi,%esi
  800fec:	cd 30                	int    $0x30
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	7e 17                	jle    801009 <sys_transmit_packet+0x3a>
  800ff2:	83 ec 0c             	sub    $0xc,%esp
  800ff5:	50                   	push   %eax
  800ff6:	6a 10                	push   $0x10
  800ff8:	68 30 30 80 00       	push   $0x803030
  800ffd:	6a 23                	push   $0x23
  800fff:	68 4d 30 80 00       	push   $0x80304d
  801004:	e8 0f f3 ff ff       	call   800318 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  801009:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801020:	b8 11 00 00 00       	mov    $0x11,%eax
  801025:	bf 00 00 00 00       	mov    $0x0,%edi
  80102a:	89 fb                	mov    %edi,%ebx
  80102c:	89 fe                	mov    %edi,%esi
  80102e:	cd 30                	int    $0x30
  801030:	85 c0                	test   %eax,%eax
  801032:	7e 17                	jle    80104b <sys_receive_packet+0x3a>
  801034:	83 ec 0c             	sub    $0xc,%esp
  801037:	50                   	push   %eax
  801038:	6a 11                	push   $0x11
  80103a:	68 30 30 80 00       	push   $0x803030
  80103f:	6a 23                	push   $0x23
  801041:	68 4d 30 80 00       	push   $0x80304d
  801046:	e8 cd f2 ff ff       	call   800318 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  80104b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
  801059:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105e:	bf 00 00 00 00       	mov    $0x0,%edi
  801063:	89 fa                	mov    %edi,%edx
  801065:	89 f9                	mov    %edi,%ecx
  801067:	89 fb                	mov    %edi,%ebx
  801069:	89 fe                	mov    %edi,%esi
  80106b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
  801078:	83 ec 0c             	sub    $0xc,%esp
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801083:	bf 00 00 00 00       	mov    $0x0,%edi
  801088:	89 f9                	mov    %edi,%ecx
  80108a:	89 fb                	mov    %edi,%ebx
  80108c:	89 fe                	mov    %edi,%esi
  80108e:	cd 30                	int    $0x30
  801090:	85 c0                	test   %eax,%eax
  801092:	7e 17                	jle    8010ab <sys_map_receive_buffers+0x39>
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	50                   	push   %eax
  801098:	6a 0e                	push   $0xe
  80109a:	68 30 30 80 00       	push   $0x803030
  80109f:	6a 23                	push   $0x23
  8010a1:	68 4d 30 80 00       	push   $0x80304d
  8010a6:	e8 6d f2 ff ff       	call   800318 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  8010ab:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bf:	b8 12 00 00 00       	mov    $0x12,%eax
  8010c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c9:	89 f9                	mov    %edi,%ecx
  8010cb:	89 fb                	mov    %edi,%ebx
  8010cd:	89 fe                	mov    %edi,%esi
  8010cf:	cd 30                	int    $0x30
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	7e 17                	jle    8010ec <sys_receive_packet_zerocopy+0x39>
  8010d5:	83 ec 0c             	sub    $0xc,%esp
  8010d8:	50                   	push   %eax
  8010d9:	6a 12                	push   $0x12
  8010db:	68 30 30 80 00       	push   $0x803030
  8010e0:	6a 23                	push   $0x23
  8010e2:	68 4d 30 80 00       	push   $0x80304d
  8010e7:	e8 2c f2 ff ff       	call   800318 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  8010ec:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5f                   	pop    %edi
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	57                   	push   %edi
  8010f8:	56                   	push   %esi
  8010f9:	53                   	push   %ebx
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801103:	b8 13 00 00 00       	mov    $0x13,%eax
  801108:	bf 00 00 00 00       	mov    $0x0,%edi
  80110d:	89 fb                	mov    %edi,%ebx
  80110f:	89 fe                	mov    %edi,%esi
  801111:	cd 30                	int    $0x30
  801113:	85 c0                	test   %eax,%eax
  801115:	7e 17                	jle    80112e <sys_env_set_priority+0x3a>
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	50                   	push   %eax
  80111b:	6a 13                	push   $0x13
  80111d:	68 30 30 80 00       	push   $0x803030
  801122:	6a 23                	push   $0x23
  801124:	68 4d 30 80 00       	push   $0x80304d
  801129:	e8 ea f1 ff ff       	call   800318 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80112e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	c9                   	leave  
  801135:	c3                   	ret    
	...

00801138 <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	53                   	push   %ebx
  80113c:	83 ec 04             	sub    $0x4,%esp
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801142:	8b 18                	mov    (%eax),%ebx
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
  801144:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801148:	74 11                	je     80115b <pgfault+0x23>
  80114a:	89 d8                	mov    %ebx,%eax
  80114c:	c1 e8 0c             	shr    $0xc,%eax
  80114f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801156:	f6 c4 08             	test   $0x8,%ah
  801159:	75 14                	jne    80116f <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  80115b:	83 ec 04             	sub    $0x4,%esp
  80115e:	68 5c 30 80 00       	push   $0x80305c
  801163:	6a 1e                	push   $0x1e
  801165:	68 b0 30 80 00       	push   $0x8030b0
  80116a:	e8 a9 f1 ff ff       	call   800318 <_panic>
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
  80116f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  801175:	83 ec 04             	sub    $0x4,%esp
  801178:	6a 07                	push   $0x7
  80117a:	68 00 f0 7f 00       	push   $0x7ff000
  80117f:	83 ec 04             	sub    $0x4,%esp
  801182:	e8 19 fc ff ff       	call   800da0 <sys_getenvid>
  801187:	89 04 24             	mov    %eax,(%esp)
  80118a:	e8 4f fc ff ff       	call   800dde <sys_page_alloc>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	79 12                	jns    8011a8 <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  801196:	50                   	push   %eax
  801197:	68 bb 30 80 00       	push   $0x8030bb
  80119c:	6a 2d                	push   $0x2d
  80119e:	68 b0 30 80 00       	push   $0x8030b0
  8011a3:	e8 70 f1 ff ff       	call   800318 <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  8011a8:	83 ec 04             	sub    $0x4,%esp
  8011ab:	68 00 10 00 00       	push   $0x1000
  8011b0:	53                   	push   %ebx
  8011b1:	68 00 f0 7f 00       	push   $0x7ff000
  8011b6:	e8 cd f9 ff ff       	call   800b88 <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  8011bb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011c2:	53                   	push   %ebx
  8011c3:	83 ec 0c             	sub    $0xc,%esp
  8011c6:	e8 d5 fb ff ff       	call   800da0 <sys_getenvid>
  8011cb:	83 c4 0c             	add    $0xc,%esp
  8011ce:	50                   	push   %eax
  8011cf:	68 00 f0 7f 00       	push   $0x7ff000
  8011d4:	83 ec 04             	sub    $0x4,%esp
  8011d7:	e8 c4 fb ff ff       	call   800da0 <sys_getenvid>
  8011dc:	89 04 24             	mov    %eax,(%esp)
  8011df:	e8 3d fc ff ff       	call   800e21 <sys_page_map>
  8011e4:	83 c4 20             	add    $0x20,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	79 12                	jns    8011fd <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  8011eb:	50                   	push   %eax
  8011ec:	68 d6 30 80 00       	push   $0x8030d6
  8011f1:	6a 33                	push   $0x33
  8011f3:	68 b0 30 80 00       	push   $0x8030b0
  8011f8:	e8 1b f1 ff ff       	call   800318 <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  8011fd:	83 ec 08             	sub    $0x8,%esp
  801200:	68 00 f0 7f 00       	push   $0x7ff000
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	e8 93 fb ff ff       	call   800da0 <sys_getenvid>
  80120d:	89 04 24             	mov    %eax,(%esp)
  801210:	e8 4e fc ff ff       	call   800e63 <sys_page_unmap>
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	85 c0                	test   %eax,%eax
  80121a:	79 12                	jns    80122e <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  80121c:	50                   	push   %eax
  80121d:	68 ef 30 80 00       	push   $0x8030ef
  801222:	6a 36                	push   $0x36
  801224:	68 b0 30 80 00       	push   $0x8030b0
  801229:	e8 ea f0 ff ff       	call   800318 <_panic>
        }

	//panic("pgfault not implemented");
}
  80122e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <duppage>:

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
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	53                   	push   %ebx
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  801240:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  801245:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801248:	f6 c4 04             	test   $0x4,%ah
  80124b:	74 36                	je     801283 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  80124d:	83 ec 0c             	sub    $0xc,%esp
  801250:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801253:	25 07 0e 00 00       	and    $0xe07,%eax
  801258:	50                   	push   %eax
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	c1 e0 0c             	shl    $0xc,%eax
  80125e:	50                   	push   %eax
  80125f:	51                   	push   %ecx
  801260:	50                   	push   %eax
  801261:	83 ec 04             	sub    $0x4,%esp
  801264:	e8 37 fb ff ff       	call   800da0 <sys_getenvid>
  801269:	89 04 24             	mov    %eax,(%esp)
  80126c:	e8 b0 fb ff ff       	call   800e21 <sys_page_map>
  801271:	83 c4 20             	add    $0x20,%esp
            return r;
  801274:	89 c2                	mov    %eax,%edx
  801276:	85 c0                	test   %eax,%eax
  801278:	0f 88 c9 00 00 00    	js     801347 <duppage+0x114>
  80127e:	e9 bf 00 00 00       	jmp    801342 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  801283:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  80128a:	a9 02 08 00 00       	test   $0x802,%eax
  80128f:	74 7b                	je     80130c <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801291:	83 ec 0c             	sub    $0xc,%esp
  801294:	68 05 08 00 00       	push   $0x805
  801299:	89 d8                	mov    %ebx,%eax
  80129b:	c1 e0 0c             	shl    $0xc,%eax
  80129e:	50                   	push   %eax
  80129f:	51                   	push   %ecx
  8012a0:	50                   	push   %eax
  8012a1:	83 ec 04             	sub    $0x4,%esp
  8012a4:	e8 f7 fa ff ff       	call   800da0 <sys_getenvid>
  8012a9:	89 04 24             	mov    %eax,(%esp)
  8012ac:	e8 70 fb ff ff       	call   800e21 <sys_page_map>
  8012b1:	83 c4 20             	add    $0x20,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	79 12                	jns    8012ca <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  8012b8:	50                   	push   %eax
  8012b9:	68 0a 31 80 00       	push   $0x80310a
  8012be:	6a 56                	push   $0x56
  8012c0:	68 b0 30 80 00       	push   $0x8030b0
  8012c5:	e8 4e f0 ff ff       	call   800318 <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	68 05 08 00 00       	push   $0x805
  8012d2:	c1 e3 0c             	shl    $0xc,%ebx
  8012d5:	53                   	push   %ebx
  8012d6:	83 ec 0c             	sub    $0xc,%esp
  8012d9:	e8 c2 fa ff ff       	call   800da0 <sys_getenvid>
  8012de:	83 c4 0c             	add    $0xc,%esp
  8012e1:	50                   	push   %eax
  8012e2:	53                   	push   %ebx
  8012e3:	83 ec 04             	sub    $0x4,%esp
  8012e6:	e8 b5 fa ff ff       	call   800da0 <sys_getenvid>
  8012eb:	89 04 24             	mov    %eax,(%esp)
  8012ee:	e8 2e fb ff ff       	call   800e21 <sys_page_map>
  8012f3:	83 c4 20             	add    $0x20,%esp
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	79 48                	jns    801342 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8012fa:	50                   	push   %eax
  8012fb:	68 0a 31 80 00       	push   $0x80310a
  801300:	6a 5b                	push   $0x5b
  801302:	68 b0 30 80 00       	push   $0x8030b0
  801307:	e8 0c f0 ff ff       	call   800318 <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	6a 05                	push   $0x5
  801311:	89 d8                	mov    %ebx,%eax
  801313:	c1 e0 0c             	shl    $0xc,%eax
  801316:	50                   	push   %eax
  801317:	51                   	push   %ecx
  801318:	50                   	push   %eax
  801319:	83 ec 04             	sub    $0x4,%esp
  80131c:	e8 7f fa ff ff       	call   800da0 <sys_getenvid>
  801321:	89 04 24             	mov    %eax,(%esp)
  801324:	e8 f8 fa ff ff       	call   800e21 <sys_page_map>
  801329:	83 c4 20             	add    $0x20,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	79 12                	jns    801342 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801330:	50                   	push   %eax
  801331:	68 0a 31 80 00       	push   $0x80310a
  801336:	6a 5f                	push   $0x5f
  801338:	68 b0 30 80 00       	push   $0x8030b0
  80133d:	e8 d6 ef ff ff       	call   800318 <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  801342:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801347:	89 d0                	mov    %edx,%eax
  801349:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <fork>:

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
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
  801354:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  801357:	68 38 11 80 00       	push   $0x801138
  80135c:	e8 1b 13 00 00       	call   80267c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801361:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  801364:	ba 07 00 00 00       	mov    $0x7,%edx
  801369:	89 d0                	mov    %edx,%eax
  80136b:	cd 30                	int    $0x30
  80136d:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  801370:	85 c0                	test   %eax,%eax
  801372:	79 15                	jns    801389 <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  801374:	50                   	push   %eax
  801375:	68 90 30 80 00       	push   $0x803090
  80137a:	68 85 00 00 00       	push   $0x85
  80137f:	68 b0 30 80 00       	push   $0x8030b0
  801384:	e8 8f ef ff ff       	call   800318 <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  801389:	bf 00 00 00 00       	mov    $0x0,%edi
  80138e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801392:	75 21                	jne    8013b5 <fork+0x67>
  801394:	e8 07 fa ff ff       	call   800da0 <sys_getenvid>
  801399:	25 ff 03 00 00       	and    $0x3ff,%eax
  80139e:	c1 e0 07             	shl    $0x7,%eax
  8013a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013a6:	a3 80 70 80 00       	mov    %eax,0x807080
  8013ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b0:	e9 fd 00 00 00       	jmp    8014b2 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  8013b5:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  8013bc:	a8 01                	test   $0x1,%al
  8013be:	74 5f                	je     80141f <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  8013c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c5:	89 f8                	mov    %edi,%eax
  8013c7:	c1 e0 0a             	shl    $0xa,%eax
  8013ca:	89 c2                	mov    %eax,%edx
  8013cc:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8013d1:	77 4c                	ja     80141f <fork+0xd1>
  8013d3:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  8013d5:	01 da                	add    %ebx,%edx
  8013d7:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8013de:	a8 01                	test   $0x1,%al
  8013e0:	74 28                	je     80140a <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	52                   	push   %edx
  8013e6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8013e9:	e8 45 fe ff ff       	call   801233 <duppage>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	79 15                	jns    80140a <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  8013f5:	50                   	push   %eax
  8013f6:	68 23 31 80 00       	push   $0x803123
  8013fb:	68 95 00 00 00       	push   $0x95
  801400:	68 b0 30 80 00       	push   $0x8030b0
  801405:	e8 0e ef ff ff       	call   800318 <_panic>
  80140a:	43                   	inc    %ebx
  80140b:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801411:	7f 0c                	jg     80141f <fork+0xd1>
  801413:	89 f2                	mov    %esi,%edx
  801415:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801418:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  80141d:	76 b6                	jbe    8013d5 <fork+0x87>
  80141f:	47                   	inc    %edi
  801420:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  801426:	76 8d                	jbe    8013b5 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	6a 07                	push   $0x7
  80142d:	68 00 f0 bf ee       	push   $0xeebff000
  801432:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801435:	e8 a4 f9 ff ff       	call   800dde <sys_page_alloc>
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	79 15                	jns    801456 <fork+0x108>
          panic("fork: %d", r);
  801441:	50                   	push   %eax
  801442:	68 3c 31 80 00       	push   $0x80313c
  801447:	68 9d 00 00 00       	push   $0x9d
  80144c:	68 b0 30 80 00       	push   $0x8030b0
  801451:	e8 c2 ee ff ff       	call   800318 <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	a1 80 70 80 00       	mov    0x807080,%eax
  80145e:	8b 40 64             	mov    0x64(%eax),%eax
  801461:	50                   	push   %eax
  801462:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801465:	e8 bf fa ff ff       	call   800f29 <sys_env_set_pgfault_upcall>
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	79 15                	jns    801486 <fork+0x138>
          panic("fork: %d", r);
  801471:	50                   	push   %eax
  801472:	68 3c 31 80 00       	push   $0x80313c
  801477:	68 a2 00 00 00       	push   $0xa2
  80147c:	68 b0 30 80 00       	push   $0x8030b0
  801481:	e8 92 ee ff ff       	call   800318 <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  801486:	83 ec 08             	sub    $0x8,%esp
  801489:	6a 01                	push   $0x1
  80148b:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80148e:	e8 12 fa ff ff       	call   800ea5 <sys_env_set_status>
  801493:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  801496:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801499:	85 c0                	test   %eax,%eax
  80149b:	79 15                	jns    8014b2 <fork+0x164>
  80149d:	50                   	push   %eax
  80149e:	68 3c 31 80 00       	push   $0x80313c
  8014a3:	68 a7 00 00 00       	push   $0xa7
  8014a8:	68 b0 30 80 00       	push   $0x8030b0
  8014ad:	e8 66 ee ff ff       	call   800318 <_panic>
 
	//panic("fork not implemented");
}
  8014b2:	89 d0                	mov    %edx,%eax
  8014b4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8014b7:	5b                   	pop    %ebx
  8014b8:	5e                   	pop    %esi
  8014b9:	5f                   	pop    %edi
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sfork>:



// Challenge!
int
sfork(void)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8014c2:	68 45 31 80 00       	push   $0x803145
  8014c7:	68 b5 00 00 00       	push   $0xb5
  8014cc:	68 b0 30 80 00       	push   $0x8030b0
  8014d1:	e8 42 ee ff ff       	call   800318 <_panic>
	...

008014d8 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8014de:	ff 75 08             	pushl  0x8(%ebp)
  8014e1:	e8 0a 00 00 00       	call   8014f0 <fd2num>
  8014e6:	c1 e0 16             	shl    $0x16,%eax
  8014e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	05 00 00 40 30       	add    $0x30400000,%eax
  8014fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <fd_alloc>:

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
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	57                   	push   %edi
  801504:	56                   	push   %esi
  801505:	53                   	push   %ebx
  801506:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801509:	b9 00 00 00 00       	mov    $0x0,%ecx
  80150e:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801513:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  801518:	89 c8                	mov    %ecx,%eax
  80151a:	c1 e0 0c             	shl    $0xc,%eax
  80151d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801523:	89 d0                	mov    %edx,%eax
  801525:	c1 e8 16             	shr    $0x16,%eax
  801528:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80152b:	a8 01                	test   $0x1,%al
  80152d:	74 0c                	je     80153b <fd_alloc+0x3b>
  80152f:	89 d0                	mov    %edx,%eax
  801531:	c1 e8 0c             	shr    $0xc,%eax
  801534:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801537:	a8 01                	test   $0x1,%al
  801539:	75 09                	jne    801544 <fd_alloc+0x44>
			*fd_store = fd;
  80153b:	89 17                	mov    %edx,(%edi)
			return 0;
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	eb 11                	jmp    801555 <fd_alloc+0x55>
  801544:	41                   	inc    %ecx
  801545:	83 f9 1f             	cmp    $0x1f,%ecx
  801548:	7e ce                	jle    801518 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80154a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801550:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801555:	5b                   	pop    %ebx
  801556:	5e                   	pop    %esi
  801557:	5f                   	pop    %edi
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801560:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801565:	83 f8 1f             	cmp    $0x1f,%eax
  801568:	77 3a                	ja     8015a4 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80156a:	c1 e0 0c             	shl    $0xc,%eax
  80156d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801573:	89 d0                	mov    %edx,%eax
  801575:	c1 e8 16             	shr    $0x16,%eax
  801578:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80157f:	a8 01                	test   $0x1,%al
  801581:	74 10                	je     801593 <fd_lookup+0x39>
  801583:	89 d0                	mov    %edx,%eax
  801585:	c1 e8 0c             	shr    $0xc,%eax
  801588:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80158f:	a8 01                	test   $0x1,%al
  801591:	75 07                	jne    80159a <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801593:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801598:	eb 0a                	jmp    8015a4 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	89 10                	mov    %edx,(%eax)
	return 0;
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015a4:	89 d0                	mov    %edx,%eax
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <fd_close>:

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
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	56                   	push   %esi
  8015ac:	53                   	push   %ebx
  8015ad:	83 ec 10             	sub    $0x10,%esp
  8015b0:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015b3:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	56                   	push   %esi
  8015b8:	e8 33 ff ff ff       	call   8014f0 <fd2num>
  8015bd:	89 04 24             	mov    %eax,(%esp)
  8015c0:	e8 95 ff ff ff       	call   80155a <fd_lookup>
  8015c5:	89 c3                	mov    %eax,%ebx
  8015c7:	83 c4 08             	add    $0x8,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 05                	js     8015d3 <fd_close+0x2b>
  8015ce:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8015d1:	74 0f                	je     8015e2 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8015d3:	89 d8                	mov    %ebx,%eax
  8015d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d9:	75 3a                	jne    801615 <fd_close+0x6d>
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e0:	eb 33                	jmp    801615 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	ff 36                	pushl  (%esi)
  8015eb:	e8 2c 00 00 00       	call   80161c <dev_lookup>
  8015f0:	89 c3                	mov    %eax,%ebx
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 0f                	js     801608 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	56                   	push   %esi
  8015fd:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801600:	ff 50 10             	call   *0x10(%eax)
  801603:	89 c3                	mov    %eax,%ebx
  801605:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	56                   	push   %esi
  80160c:	6a 00                	push   $0x0
  80160e:	e8 50 f8 ff ff       	call   800e63 <sys_page_unmap>
	return r;
  801613:	89 d8                	mov    %ebx,%eax
}
  801615:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <dev_lookup>:


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
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	56                   	push   %esi
  801620:	53                   	push   %ebx
  801621:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801624:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	83 3d 08 70 80 00 00 	cmpl   $0x0,0x807008
  801633:	74 1c                	je     801651 <dev_lookup+0x35>
  801635:	b9 08 70 80 00       	mov    $0x807008,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80163a:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  80163d:	39 18                	cmp    %ebx,(%eax)
  80163f:	75 09                	jne    80164a <dev_lookup+0x2e>
			*dev = devtab[i];
  801641:	89 06                	mov    %eax,(%esi)
			return 0;
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	eb 29                	jmp    801673 <dev_lookup+0x57>
  80164a:	42                   	inc    %edx
  80164b:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80164f:	75 e9                	jne    80163a <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	53                   	push   %ebx
  801655:	a1 80 70 80 00       	mov    0x807080,%eax
  80165a:	8b 40 4c             	mov    0x4c(%eax),%eax
  80165d:	50                   	push   %eax
  80165e:	68 5c 31 80 00       	push   $0x80315c
  801663:	e8 a0 ed ff ff       	call   800408 <cprintf>
	*dev = 0;
  801668:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80166e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801673:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <close>:

int
close(int fdnum)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801680:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801683:	50                   	push   %eax
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	e8 ce fe ff ff       	call   80155a <fd_lookup>
  80168c:	83 c4 08             	add    $0x8,%esp
		return r;
  80168f:	89 c2                	mov    %eax,%edx
  801691:	85 c0                	test   %eax,%eax
  801693:	78 0f                	js     8016a4 <close+0x2a>
	else
		return fd_close(fd, 1);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	6a 01                	push   $0x1
  80169a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80169d:	e8 06 ff ff ff       	call   8015a8 <fd_close>
  8016a2:	89 c2                	mov    %eax,%edx
}
  8016a4:	89 d0                	mov    %edx,%eax
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <close_all>:

void
close_all(void)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016af:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	53                   	push   %ebx
  8016b8:	e8 bd ff ff ff       	call   80167a <close>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	43                   	inc    %ebx
  8016c1:	83 fb 1f             	cmp    $0x1f,%ebx
  8016c4:	7e ee                	jle    8016b4 <close_all+0xc>
}
  8016c6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	57                   	push   %edi
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016d4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8016d7:	50                   	push   %eax
  8016d8:	ff 75 08             	pushl  0x8(%ebp)
  8016db:	e8 7a fe ff ff       	call   80155a <fd_lookup>
  8016e0:	89 c6                	mov    %eax,%esi
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 f6                	test   %esi,%esi
  8016e7:	0f 88 f8 00 00 00    	js     8017e5 <dup+0x11a>
		return r;
	close(newfdnum);
  8016ed:	83 ec 0c             	sub    $0xc,%esp
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	e8 82 ff ff ff       	call   80167a <close>

	newfd = INDEX2FD(newfdnum);
  8016f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fb:	c1 e0 0c             	shl    $0xc,%eax
  8016fe:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801703:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  801706:	83 c4 04             	add    $0x4,%esp
  801709:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80170c:	e8 c7 fd ff ff       	call   8014d8 <fd2data>
  801711:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801713:	83 c4 04             	add    $0x4,%esp
  801716:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801719:	e8 ba fd ff ff       	call   8014d8 <fd2data>
  80171e:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801721:	89 f8                	mov    %edi,%eax
  801723:	c1 e8 16             	shr    $0x16,%eax
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801730:	85 c0                	test   %eax,%eax
  801732:	74 48                	je     80177c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801734:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801739:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  80173c:	89 d0                	mov    %edx,%eax
  80173e:	c1 e8 0c             	shr    $0xc,%eax
  801741:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801748:	a8 01                	test   $0x1,%al
  80174a:	74 22                	je     80176e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	25 07 0e 00 00       	and    $0xe07,%eax
  801754:	50                   	push   %eax
  801755:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801758:	01 d8                	add    %ebx,%eax
  80175a:	50                   	push   %eax
  80175b:	6a 00                	push   $0x0
  80175d:	52                   	push   %edx
  80175e:	6a 00                	push   $0x0
  801760:	e8 bc f6 ff ff       	call   800e21 <sys_page_map>
  801765:	89 c6                	mov    %eax,%esi
  801767:	83 c4 20             	add    $0x20,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 3f                	js     8017ad <dup+0xe2>
  80176e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801774:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80177a:	7e bd                	jle    801739 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80177c:	83 ec 0c             	sub    $0xc,%esp
  80177f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801782:	89 d0                	mov    %edx,%eax
  801784:	c1 e8 0c             	shr    $0xc,%eax
  801787:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80178e:	25 07 0e 00 00       	and    $0xe07,%eax
  801793:	50                   	push   %eax
  801794:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801797:	6a 00                	push   $0x0
  801799:	52                   	push   %edx
  80179a:	6a 00                	push   $0x0
  80179c:	e8 80 f6 ff ff       	call   800e21 <sys_page_map>
  8017a1:	89 c6                	mov    %eax,%esi
  8017a3:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	85 f6                	test   %esi,%esi
  8017ab:	79 38                	jns    8017e5 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8017b3:	6a 00                	push   $0x0
  8017b5:	e8 a9 f6 ff ff       	call   800e63 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8017ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017bf:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8017c8:	01 d8                	add    %ebx,%eax
  8017ca:	50                   	push   %eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	e8 91 f6 ff ff       	call   800e63 <sys_page_unmap>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8017db:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8017e1:	7e df                	jle    8017c2 <dup+0xf7>
	return r;
  8017e3:	89 f0                	mov    %esi,%eax
}
  8017e5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5e                   	pop    %esi
  8017ea:	5f                   	pop    %edi
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	53                   	push   %ebx
  8017f1:	83 ec 14             	sub    $0x14,%esp
  8017f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f7:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8017fa:	50                   	push   %eax
  8017fb:	53                   	push   %ebx
  8017fc:	e8 59 fd ff ff       	call   80155a <fd_lookup>
  801801:	89 c2                	mov    %eax,%edx
  801803:	83 c4 08             	add    $0x8,%esp
  801806:	85 c0                	test   %eax,%eax
  801808:	78 1a                	js     801824 <read+0x37>
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801810:	50                   	push   %eax
  801811:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801814:	ff 30                	pushl  (%eax)
  801816:	e8 01 fe ff ff       	call   80161c <dev_lookup>
  80181b:	89 c2                	mov    %eax,%edx
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	85 c0                	test   %eax,%eax
  801822:	79 04                	jns    801828 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801824:	89 d0                	mov    %edx,%eax
  801826:	eb 50                	jmp    801878 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801828:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80182b:	8b 40 08             	mov    0x8(%eax),%eax
  80182e:	83 e0 03             	and    $0x3,%eax
  801831:	83 f8 01             	cmp    $0x1,%eax
  801834:	75 1e                	jne    801854 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	53                   	push   %ebx
  80183a:	a1 80 70 80 00       	mov    0x807080,%eax
  80183f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801842:	50                   	push   %eax
  801843:	68 9d 31 80 00       	push   $0x80319d
  801848:	e8 bb eb ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  80184d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801852:	eb 24                	jmp    801878 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801854:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801857:	ff 70 04             	pushl  0x4(%eax)
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801864:	ff 50 08             	call   *0x8(%eax)
  801867:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 06                	js     801876 <read+0x89>
		fd->fd_offset += r;
  801870:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801873:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801876:	89 d0                	mov    %edx,%eax
}
  801878:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	57                   	push   %edi
  801881:	56                   	push   %esi
  801882:	53                   	push   %ebx
  801883:	83 ec 0c             	sub    $0xc,%esp
  801886:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801889:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80188c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801891:	39 f3                	cmp    %esi,%ebx
  801893:	73 25                	jae    8018ba <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	89 f0                	mov    %esi,%eax
  80189a:	29 d8                	sub    %ebx,%eax
  80189c:	50                   	push   %eax
  80189d:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8018a0:	50                   	push   %eax
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	e8 44 ff ff ff       	call   8017ed <read>
		if (m < 0)
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 0c                	js     8018bc <readn+0x3f>
			return m;
		if (m == 0)
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	74 06                	je     8018ba <readn+0x3d>
  8018b4:	01 c3                	add    %eax,%ebx
  8018b6:	39 f3                	cmp    %esi,%ebx
  8018b8:	72 db                	jb     801895 <readn+0x18>
			break;
	}
	return tot;
  8018ba:	89 d8                	mov    %ebx,%eax
}
  8018bc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 14             	sub    $0x14,%esp
  8018cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ce:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	53                   	push   %ebx
  8018d3:	e8 82 fc ff ff       	call   80155a <fd_lookup>
  8018d8:	89 c2                	mov    %eax,%edx
  8018da:	83 c4 08             	add    $0x8,%esp
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 1a                	js     8018fb <write+0x37>
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018eb:	ff 30                	pushl  (%eax)
  8018ed:	e8 2a fd ff ff       	call   80161c <dev_lookup>
  8018f2:	89 c2                	mov    %eax,%edx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	79 04                	jns    8018ff <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8018fb:	89 d0                	mov    %edx,%eax
  8018fd:	eb 4b                	jmp    80194a <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ff:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801902:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801906:	75 1e                	jne    801926 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	53                   	push   %ebx
  80190c:	a1 80 70 80 00       	mov    0x807080,%eax
  801911:	8b 40 4c             	mov    0x4c(%eax),%eax
  801914:	50                   	push   %eax
  801915:	68 b9 31 80 00       	push   $0x8031b9
  80191a:	e8 e9 ea ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  80191f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801924:	eb 24                	jmp    80194a <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801926:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801929:	ff 70 04             	pushl  0x4(%eax)
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	50                   	push   %eax
  801933:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801936:	ff 50 0c             	call   *0xc(%eax)
  801939:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	7e 06                	jle    801948 <write+0x84>
		fd->fd_offset += r;
  801942:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801945:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801948:	89 d0                	mov    %edx,%eax
}
  80194a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <seek>:

int
seek(int fdnum, off_t offset)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801955:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801958:	50                   	push   %eax
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	e8 f9 fb ff ff       	call   80155a <fd_lookup>
  801961:	83 c4 08             	add    $0x8,%esp
		return r;
  801964:	89 c2                	mov    %eax,%edx
  801966:	85 c0                	test   %eax,%eax
  801968:	78 0e                	js     801978 <seek+0x29>
	fd->fd_offset = offset;
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801970:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801973:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801978:	89 d0                	mov    %edx,%eax
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	53                   	push   %ebx
  801980:	83 ec 14             	sub    $0x14,%esp
  801983:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801986:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801989:	50                   	push   %eax
  80198a:	53                   	push   %ebx
  80198b:	e8 ca fb ff ff       	call   80155a <fd_lookup>
  801990:	83 c4 08             	add    $0x8,%esp
  801993:	85 c0                	test   %eax,%eax
  801995:	78 4e                	js     8019e5 <ftruncate+0x69>
  801997:	83 ec 08             	sub    $0x8,%esp
  80199a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80199d:	50                   	push   %eax
  80199e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8019a1:	ff 30                	pushl  (%eax)
  8019a3:	e8 74 fc ff ff       	call   80161c <dev_lookup>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 36                	js     8019e5 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019af:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8019b2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019b6:	75 1e                	jne    8019d6 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	53                   	push   %ebx
  8019bc:	a1 80 70 80 00       	mov    0x807080,%eax
  8019c1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019c4:	50                   	push   %eax
  8019c5:	68 7c 31 80 00       	push   $0x80317c
  8019ca:	e8 39 ea ff ff       	call   800408 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8019cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d4:	eb 0f                	jmp    8019e5 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019df:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8019e2:	ff 50 1c             	call   *0x1c(%eax)
}
  8019e5:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 14             	sub    $0x14,%esp
  8019f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f4:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8019f7:	50                   	push   %eax
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	e8 5a fb ff ff       	call   80155a <fd_lookup>
  801a00:	83 c4 08             	add    $0x8,%esp
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 42                	js     801a49 <fstat+0x5f>
  801a07:	83 ec 08             	sub    $0x8,%esp
  801a0a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801a0d:	50                   	push   %eax
  801a0e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a11:	ff 30                	pushl  (%eax)
  801a13:	e8 04 fc ff ff       	call   80161c <dev_lookup>
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 2a                	js     801a49 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801a1f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a22:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a29:	00 00 00 
	stat->st_isdir = 0;
  801a2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a33:	00 00 00 
	stat->st_dev = dev;
  801a36:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801a39:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a3f:	83 ec 08             	sub    $0x8,%esp
  801a42:	53                   	push   %ebx
  801a43:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801a46:	ff 50 14             	call   *0x14(%eax)
}
  801a49:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	56                   	push   %esi
  801a52:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a53:	83 ec 08             	sub    $0x8,%esp
  801a56:	6a 00                	push   $0x0
  801a58:	ff 75 08             	pushl  0x8(%ebp)
  801a5b:	e8 28 00 00 00       	call   801a88 <open>
  801a60:	89 c6                	mov    %eax,%esi
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	85 f6                	test   %esi,%esi
  801a67:	78 18                	js     801a81 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801a69:	83 ec 08             	sub    $0x8,%esp
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	56                   	push   %esi
  801a70:	e8 75 ff ff ff       	call   8019ea <fstat>
  801a75:	89 c3                	mov    %eax,%ebx
	close(fd);
  801a77:	89 34 24             	mov    %esi,(%esp)
  801a7a:	e8 fb fb ff ff       	call   80167a <close>
	return r;
  801a7f:	89 d8                	mov    %ebx,%eax
}
  801a81:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 10             	sub    $0x10,%esp
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
  801a8f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801a92:	50                   	push   %eax
  801a93:	e8 68 fa ff ff       	call   801500 <fd_alloc>
  801a98:	89 c3                	mov    %eax,%ebx
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	85 db                	test   %ebx,%ebx
  801a9f:	78 36                	js     801ad7 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	e8 1b 05 00 00       	call   801fcd <fsipc_open>
  801ab2:	89 c3                	mov    %eax,%ebx
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	79 11                	jns    801acc <open+0x44>
          fd_close(fd_store, 0);
  801abb:	83 ec 08             	sub    $0x8,%esp
  801abe:	6a 00                	push   $0x0
  801ac0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801ac3:	e8 e0 fa ff ff       	call   8015a8 <fd_close>
          return r;
  801ac8:	89 d8                	mov    %ebx,%eax
  801aca:	eb 0b                	jmp    801ad7 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801ad2:	e8 19 fa ff ff       	call   8014f0 <fd2num>
}
  801ad7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801ae6:	6a 01                	push   $0x1
  801ae8:	6a 00                	push   $0x0
  801aea:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801af0:	53                   	push   %ebx
  801af1:	e8 e7 03 00 00       	call   801edd <funmap>
  801af6:	83 c4 10             	add    $0x10,%esp
          return r;
  801af9:	89 c2                	mov    %eax,%edx
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 19                	js     801b18 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801aff:	83 ec 0c             	sub    $0xc,%esp
  801b02:	ff 73 0c             	pushl  0xc(%ebx)
  801b05:	e8 68 05 00 00       	call   802072 <fsipc_close>
  801b0a:	83 c4 10             	add    $0x10,%esp
          return r;
  801b0d:	89 c2                	mov    %eax,%edx
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	78 05                	js     801b18 <file_close+0x3c>
        }
        return 0;
  801b13:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b18:	89 d0                	mov    %edx,%eax
  801b1a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	57                   	push   %edi
  801b23:	56                   	push   %esi
  801b24:	53                   	push   %ebx
  801b25:	83 ec 0c             	sub    $0xc,%esp
  801b28:	8b 75 10             	mov    0x10(%ebp),%esi
  801b2b:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801b37:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3c:	39 d7                	cmp    %edx,%edi
  801b3e:	0f 87 95 00 00 00    	ja     801bd9 <file_read+0xba>
	if (offset + n > size)
  801b44:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801b47:	39 d0                	cmp    %edx,%eax
  801b49:	76 04                	jbe    801b4f <file_read+0x30>
		n = size - offset;
  801b4b:	89 d6                	mov    %edx,%esi
  801b4d:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	e8 7e f9 ff ff       	call   8014d8 <fd2data>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	01 fb                	add    %edi,%ebx
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	eb 41                	jmp    801ba4 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801b63:	89 d8                	mov    %ebx,%eax
  801b65:	c1 e8 16             	shr    $0x16,%eax
  801b68:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b6f:	a8 01                	test   $0x1,%al
  801b71:	74 10                	je     801b83 <file_read+0x64>
  801b73:	89 d8                	mov    %ebx,%eax
  801b75:	c1 e8 0c             	shr    $0xc,%eax
  801b78:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b7f:	a8 01                	test   $0x1,%al
  801b81:	75 1b                	jne    801b9e <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801b89:	50                   	push   %eax
  801b8a:	57                   	push   %edi
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 d4 02 00 00       	call   801e67 <fmap>
  801b93:	83 c4 10             	add    $0x10,%esp
              return r;
  801b96:	89 c1                	mov    %eax,%ecx
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	78 3d                	js     801bd9 <file_read+0xba>
  801b9c:	eb 1c                	jmp    801bba <file_read+0x9b>
  801b9e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ba4:	83 ec 0c             	sub    $0xc,%esp
  801ba7:	ff 75 08             	pushl  0x8(%ebp)
  801baa:	e8 29 f9 ff ff       	call   8014d8 <fd2data>
  801baf:	01 f8                	add    %edi,%eax
  801bb1:	01 f0                	add    %esi,%eax
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	39 d8                	cmp    %ebx,%eax
  801bb8:	77 a9                	ja     801b63 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	56                   	push   %esi
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	ff 75 08             	pushl  0x8(%ebp)
  801bc4:	e8 0f f9 ff ff       	call   8014d8 <fd2data>
  801bc9:	83 c4 08             	add    $0x8,%esp
  801bcc:	01 f8                	add    %edi,%eax
  801bce:	50                   	push   %eax
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	e8 b1 ef ff ff       	call   800b88 <memmove>
	return n;
  801bd7:	89 f1                	mov    %esi,%ecx
}
  801bd9:	89 c8                	mov    %ecx,%eax
  801bdb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5f                   	pop    %edi
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 18             	sub    $0x18,%esp
  801beb:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bee:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801bf1:	50                   	push   %eax
  801bf2:	ff 75 08             	pushl  0x8(%ebp)
  801bf5:	e8 60 f9 ff ff       	call   80155a <fd_lookup>
  801bfa:	83 c4 10             	add    $0x10,%esp
		return r;
  801bfd:	89 c2                	mov    %eax,%edx
  801bff:	85 c0                	test   %eax,%eax
  801c01:	0f 88 9f 00 00 00    	js     801ca6 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801c07:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801c0a:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801c0c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801c11:	3b 05 20 70 80 00    	cmp    0x807020,%eax
  801c17:	0f 85 89 00 00 00    	jne    801ca6 <read_map+0xc3>
	va = fd2data(fd) + offset;
  801c1d:	83 ec 0c             	sub    $0xc,%esp
  801c20:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801c23:	e8 b0 f8 ff ff       	call   8014d8 <fd2data>
  801c28:	89 c3                	mov    %eax,%ebx
  801c2a:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801c2c:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801c2f:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801c34:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801c3a:	7f 6a                	jg     801ca6 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801c3c:	89 d8                	mov    %ebx,%eax
  801c3e:	c1 e8 16             	shr    $0x16,%eax
  801c41:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c48:	a8 01                	test   $0x1,%al
  801c4a:	74 10                	je     801c5c <read_map+0x79>
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	c1 e8 0c             	shr    $0xc,%eax
  801c51:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c58:	a8 01                	test   $0x1,%al
  801c5a:	75 19                	jne    801c75 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	8d 46 01             	lea    0x1(%esi),%eax
  801c62:	50                   	push   %eax
  801c63:	56                   	push   %esi
  801c64:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801c67:	e8 fb 01 00 00       	call   801e67 <fmap>
  801c6c:	83 c4 10             	add    $0x10,%esp
            return r;
  801c6f:	89 c2                	mov    %eax,%edx
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 31                	js     801ca6 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801c75:	89 d8                	mov    %ebx,%eax
  801c77:	c1 e8 16             	shr    $0x16,%eax
  801c7a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c81:	a8 01                	test   $0x1,%al
  801c83:	74 10                	je     801c95 <read_map+0xb2>
  801c85:	89 d8                	mov    %ebx,%eax
  801c87:	c1 e8 0c             	shr    $0xc,%eax
  801c8a:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c91:	a8 01                	test   $0x1,%al
  801c93:	75 07                	jne    801c9c <read_map+0xb9>
		return -E_NO_DISK;
  801c95:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801c9a:	eb 0a                	jmp    801ca6 <read_map+0xc3>

	*blk = (void*) va;
  801c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9f:	89 18                	mov    %ebx,(%eax)
	return 0;
  801ca1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	57                   	push   %edi
  801cb3:	56                   	push   %esi
  801cb4:	53                   	push   %ebx
  801cb5:	83 ec 0c             	sub    $0xc,%esp
  801cb8:	8b 75 08             	mov    0x8(%ebp),%esi
  801cbb:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc1:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801cc4:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801cc9:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801ccf:	0f 87 bd 00 00 00    	ja     801d92 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801cd5:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801cdb:	73 17                	jae    801cf4 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	52                   	push   %edx
  801ce1:	56                   	push   %esi
  801ce2:	e8 fb 00 00 00       	call   801de2 <file_trunc>
  801ce7:	83 c4 10             	add    $0x10,%esp
			return r;
  801cea:	89 c1                	mov    %eax,%ecx
  801cec:	85 c0                	test   %eax,%eax
  801cee:	0f 88 9e 00 00 00    	js     801d92 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801cf4:	83 ec 0c             	sub    $0xc,%esp
  801cf7:	56                   	push   %esi
  801cf8:	e8 db f7 ff ff       	call   8014d8 <fd2data>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	01 fb                	add    %edi,%ebx
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	eb 42                	jmp    801d48 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801d06:	89 d8                	mov    %ebx,%eax
  801d08:	c1 e8 16             	shr    $0x16,%eax
  801d0b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801d12:	a8 01                	test   $0x1,%al
  801d14:	74 10                	je     801d26 <file_write+0x77>
  801d16:	89 d8                	mov    %ebx,%eax
  801d18:	c1 e8 0c             	shr    $0xc,%eax
  801d1b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801d22:	a8 01                	test   $0x1,%al
  801d24:	75 1c                	jne    801d42 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	8b 55 10             	mov    0x10(%ebp),%edx
  801d2c:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801d2f:	50                   	push   %eax
  801d30:	57                   	push   %edi
  801d31:	56                   	push   %esi
  801d32:	e8 30 01 00 00       	call   801e67 <fmap>
  801d37:	83 c4 10             	add    $0x10,%esp
              return r;
  801d3a:	89 c1                	mov    %eax,%ecx
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	78 52                	js     801d92 <file_write+0xe3>
  801d40:	eb 1b                	jmp    801d5d <file_write+0xae>
  801d42:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	56                   	push   %esi
  801d4c:	e8 87 f7 ff ff       	call   8014d8 <fd2data>
  801d51:	01 f8                	add    %edi,%eax
  801d53:	03 45 10             	add    0x10(%ebp),%eax
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	39 d8                	cmp    %ebx,%eax
  801d5b:	77 a9                	ja     801d06 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	68 d6 31 80 00       	push   $0x8031d6
  801d65:	e8 9e e6 ff ff       	call   800408 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801d6a:	83 c4 0c             	add    $0xc,%esp
  801d6d:	ff 75 10             	pushl  0x10(%ebp)
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	56                   	push   %esi
  801d74:	e8 5f f7 ff ff       	call   8014d8 <fd2data>
  801d79:	01 f8                	add    %edi,%eax
  801d7b:	89 04 24             	mov    %eax,(%esp)
  801d7e:	e8 05 ee ff ff       	call   800b88 <memmove>
        cprintf("write done\n");
  801d83:	c7 04 24 e3 31 80 00 	movl   $0x8031e3,(%esp)
  801d8a:	e8 79 e6 ff ff       	call   800408 <cprintf>
	return n;
  801d8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801d92:	89 c8                	mov    %ecx,%eax
  801d94:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	56                   	push   %esi
  801da0:	53                   	push   %ebx
  801da1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801da4:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801da7:	83 ec 08             	sub    $0x8,%esp
  801daa:	8d 43 10             	lea    0x10(%ebx),%eax
  801dad:	50                   	push   %eax
  801dae:	56                   	push   %esi
  801daf:	e8 58 ec ff ff       	call   800a0c <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801db4:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801dba:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801dca:	0f 94 c0             	sete   %al
  801dcd:	0f b6 c0             	movzbl %al,%eax
  801dd0:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddb:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5e                   	pop    %esi
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	57                   	push   %edi
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	8b 75 08             	mov    0x8(%ebp),%esi
  801dee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801df1:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801df6:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801dfc:	7f 5f                	jg     801e5d <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801dfe:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801e04:	83 ec 08             	sub    $0x8,%esp
  801e07:	53                   	push   %ebx
  801e08:	ff 76 0c             	pushl  0xc(%esi)
  801e0b:	e8 3a 02 00 00       	call   80204a <fsipc_set_size>
  801e10:	83 c4 10             	add    $0x10,%esp
		return r;
  801e13:	89 c2                	mov    %eax,%edx
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 44                	js     801e5d <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801e19:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801e1f:	74 19                	je     801e3a <file_trunc+0x58>
  801e21:	68 10 32 80 00       	push   $0x803210
  801e26:	68 ef 31 80 00       	push   $0x8031ef
  801e2b:	68 dc 00 00 00       	push   $0xdc
  801e30:	68 04 32 80 00       	push   $0x803204
  801e35:	e8 de e4 ff ff       	call   800318 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	53                   	push   %ebx
  801e3e:	57                   	push   %edi
  801e3f:	56                   	push   %esi
  801e40:	e8 22 00 00 00       	call   801e67 <fmap>
  801e45:	83 c4 10             	add    $0x10,%esp
		return r;
  801e48:	89 c2                	mov    %eax,%edx
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	78 0f                	js     801e5d <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	53                   	push   %ebx
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	e8 85 00 00 00       	call   801edd <funmap>

	return 0;
  801e58:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e62:	5b                   	pop    %ebx
  801e63:	5e                   	pop    %esi
  801e64:	5f                   	pop    %edi
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <fmap>:

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
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	57                   	push   %edi
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 0c             	sub    $0xc,%esp
  801e70:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e73:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801e76:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801e79:	7d 55                	jge    801ed0 <fmap+0x69>
          fma = fd2data(fd);
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	57                   	push   %edi
  801e7f:	e8 54 f6 ff ff       	call   8014d8 <fd2data>
  801e84:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8d:	05 ff 0f 00 00       	add    $0xfff,%eax
  801e92:	89 c3                	mov    %eax,%ebx
  801e94:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801e9a:	39 f3                	cmp    %esi,%ebx
  801e9c:	7d 32                	jge    801ed0 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801e9e:	83 ec 04             	sub    $0x4,%esp
  801ea1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801ea4:	01 d8                	add    %ebx,%eax
  801ea6:	50                   	push   %eax
  801ea7:	53                   	push   %ebx
  801ea8:	ff 77 0c             	pushl  0xc(%edi)
  801eab:	e8 6f 01 00 00       	call   80201f <fsipc_map>
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	79 0f                	jns    801ec6 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	ff 75 0c             	pushl  0xc(%ebp)
  801ebc:	53                   	push   %ebx
  801ebd:	57                   	push   %edi
  801ebe:	e8 1a 00 00 00       	call   801edd <funmap>
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ecc:	39 f3                	cmp    %esi,%ebx
  801ece:	7c ce                	jl     801e9e <fmap+0x37>
            }
          }
        }

        return 0;
}
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ed8:	5b                   	pop    %ebx
  801ed9:	5e                   	pop    %esi
  801eda:	5f                   	pop    %edi
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <funmap>:

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
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	57                   	push   %edi
  801ee1:	56                   	push   %esi
  801ee2:	53                   	push   %ebx
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ee9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801eec:	39 f3                	cmp    %esi,%ebx
  801eee:	0f 8d 80 00 00 00    	jge    801f74 <funmap+0x97>
          fma = fd2data(fd);
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	ff 75 08             	pushl  0x8(%ebp)
  801efa:	e8 d9 f5 ff ff       	call   8014d8 <fd2data>
  801eff:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801f0a:	89 c3                	mov    %eax,%ebx
  801f0c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801f12:	39 f3                	cmp    %esi,%ebx
  801f14:	7d 5e                	jge    801f74 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801f16:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801f19:	89 c2                	mov    %eax,%edx
  801f1b:	c1 ea 0c             	shr    $0xc,%edx
  801f1e:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801f25:	a8 01                	test   $0x1,%al
  801f27:	74 41                	je     801f6a <funmap+0x8d>
              if (dirty) {
  801f29:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801f2d:	74 21                	je     801f50 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801f2f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801f36:	a8 40                	test   $0x40,%al
  801f38:	74 16                	je     801f50 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801f3a:	83 ec 08             	sub    $0x8,%esp
  801f3d:	53                   	push   %ebx
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	ff 70 0c             	pushl  0xc(%eax)
  801f44:	e8 49 01 00 00       	call   802092 <fsipc_dirty>
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	78 29                	js     801f79 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801f50:	83 ec 08             	sub    $0x8,%esp
  801f53:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801f56:	50                   	push   %eax
  801f57:	83 ec 04             	sub    $0x4,%esp
  801f5a:	e8 41 ee ff ff       	call   800da0 <sys_getenvid>
  801f5f:	89 04 24             	mov    %eax,(%esp)
  801f62:	e8 fc ee ff ff       	call   800e63 <sys_page_unmap>
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f70:	39 f3                	cmp    %esi,%ebx
  801f72:	7c a2                	jl     801f16 <funmap+0x39>
            }
          }
        }

        return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f79:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <remove>:

// Delete a file
int
remove(const char *path)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	e8 2b 01 00 00       	call   8020ba <fsipc_remove>
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801f97:	e8 64 01 00 00       	call   802100 <fsipc_sync>
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    
	...

00801fa0 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801fa6:	6a 07                	push   $0x7
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	ff 75 08             	pushl  0x8(%ebp)
  801fae:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801fb3:	50                   	push   %eax
  801fb4:	e8 da 07 00 00       	call   802793 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801fb9:	83 c4 0c             	add    $0xc,%esp
  801fbc:	ff 75 14             	pushl  0x14(%ebp)
  801fbf:	ff 75 10             	pushl  0x10(%ebp)
  801fc2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801fc5:	50                   	push   %eax
  801fc6:	e8 65 07 00 00       	call   802730 <ipc_recv>
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	56                   	push   %esi
  801fd1:	53                   	push   %ebx
  801fd2:	83 ec 1c             	sub    $0x1c,%esp
  801fd5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801fd8:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801fdd:	56                   	push   %esi
  801fde:	e8 ed e9 ff ff       	call   8009d0 <strlen>
  801fe3:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801fe6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801feb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ff0:	7f 24                	jg     802016 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801ff2:	83 ec 08             	sub    $0x8,%esp
  801ff5:	56                   	push   %esi
  801ff6:	53                   	push   %ebx
  801ff7:	e8 10 ea ff ff       	call   800a0c <strcpy>
	req->req_omode = omode;
  801ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fff:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  802005:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802008:	50                   	push   %eax
  802009:	ff 75 10             	pushl  0x10(%ebp)
  80200c:	53                   	push   %ebx
  80200d:	6a 01                	push   $0x1
  80200f:	e8 8c ff ff ff       	call   801fa0 <fsipc>
  802014:	89 c2                	mov    %eax,%edx
}
  802016:	89 d0                	mov    %edx,%eax
  802018:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80201b:	5b                   	pop    %ebx
  80201c:	5e                   	pop    %esi
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  80202d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802030:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  802035:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802038:	50                   	push   %eax
  802039:	ff 75 10             	pushl  0x10(%ebp)
  80203c:	68 00 40 80 00       	push   $0x804000
  802041:	6a 02                	push   $0x2
  802043:	e8 58 ff ff ff       	call   801fa0 <fsipc>

	//return -E_UNSPECIFIED;
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  802058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205b:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	68 00 40 80 00       	push   $0x804000
  802069:	6a 03                	push   $0x3
  80206b:	e8 30 ff ff ff       	call   801fa0 <fsipc>
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	68 00 40 80 00       	push   $0x804000
  802089:	6a 04                	push   $0x4
  80208b:	e8 10 ff ff ff       	call   801fa0 <fsipc>
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  8020a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a3:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	68 00 40 80 00       	push   $0x804000
  8020b1:	6a 05                	push   $0x5
  8020b3:	e8 e8 fe ff ff       	call   801fa0 <fsipc>
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	56                   	push   %esi
  8020be:	53                   	push   %ebx
  8020bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  8020c2:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	53                   	push   %ebx
  8020cb:	e8 00 e9 ff ff       	call   8009d0 <strlen>
  8020d0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8020d3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8020d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020dd:	7f 18                	jg     8020f7 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  8020df:	83 ec 08             	sub    $0x8,%esp
  8020e2:	53                   	push   %ebx
  8020e3:	56                   	push   %esi
  8020e4:	e8 23 e9 ff ff       	call   800a0c <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	56                   	push   %esi
  8020ee:	6a 06                	push   $0x6
  8020f0:	e8 ab fe ff ff       	call   801fa0 <fsipc>
  8020f5:	89 c2                	mov    %eax,%edx
}
  8020f7:	89 d0                	mov    %edx,%eax
  8020f9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8020fc:	5b                   	pop    %ebx
  8020fd:	5e                   	pop    %esi
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	68 00 40 80 00       	push   $0x804000
  80210f:	6a 07                	push   $0x7
  802111:	e8 8a fe ff ff       	call   801fa0 <fsipc>
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <pipe>:
};

int
pipe(int pfd[2])
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	57                   	push   %edi
  80211c:	56                   	push   %esi
  80211d:	53                   	push   %ebx
  80211e:	83 ec 18             	sub    $0x18,%esp
  802121:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802124:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  802127:	50                   	push   %eax
  802128:	e8 d3 f3 ff ff       	call   801500 <fd_alloc>
  80212d:	89 c3                	mov    %eax,%ebx
  80212f:	83 c4 10             	add    $0x10,%esp
  802132:	85 c0                	test   %eax,%eax
  802134:	0f 88 25 01 00 00    	js     80225f <pipe+0x147>
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 07 04 00 00       	push   $0x407
  802142:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802145:	6a 00                	push   $0x0
  802147:	e8 92 ec ff ff       	call   800dde <sys_page_alloc>
  80214c:	89 c3                	mov    %eax,%ebx
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	85 c0                	test   %eax,%eax
  802153:	0f 88 06 01 00 00    	js     80225f <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  80215f:	50                   	push   %eax
  802160:	e8 9b f3 ff ff       	call   801500 <fd_alloc>
  802165:	89 c3                	mov    %eax,%ebx
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	85 c0                	test   %eax,%eax
  80216c:	0f 88 dd 00 00 00    	js     80224f <pipe+0x137>
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 07 04 00 00       	push   $0x407
  80217a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80217d:	6a 00                	push   $0x0
  80217f:	e8 5a ec ff ff       	call   800dde <sys_page_alloc>
  802184:	89 c3                	mov    %eax,%ebx
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	85 c0                	test   %eax,%eax
  80218b:	0f 88 be 00 00 00    	js     80224f <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802197:	e8 3c f3 ff ff       	call   8014d8 <fd2data>
  80219c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219e:	83 c4 0c             	add    $0xc,%esp
  8021a1:	68 07 04 00 00       	push   $0x407
  8021a6:	50                   	push   %eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	e8 30 ec ff ff       	call   800dde <sys_page_alloc>
  8021ae:	89 c3                	mov    %eax,%ebx
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	0f 88 84 00 00 00    	js     80223f <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021bb:	83 ec 0c             	sub    $0xc,%esp
  8021be:	68 07 04 00 00       	push   $0x407
  8021c3:	83 ec 0c             	sub    $0xc,%esp
  8021c6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8021c9:	e8 0a f3 ff ff       	call   8014d8 <fd2data>
  8021ce:	83 c4 10             	add    $0x10,%esp
  8021d1:	50                   	push   %eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	56                   	push   %esi
  8021d5:	6a 00                	push   $0x0
  8021d7:	e8 45 ec ff ff       	call   800e21 <sys_page_map>
  8021dc:	89 c3                	mov    %eax,%ebx
  8021de:	83 c4 20             	add    $0x20,%esp
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	78 4c                	js     802231 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021e5:	8b 15 40 70 80 00    	mov    0x807040,%edx
  8021eb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8021ee:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021f0:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8021f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021fa:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802200:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802203:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802205:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802208:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80220f:	83 ec 0c             	sub    $0xc,%esp
  802212:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802215:	e8 d6 f2 ff ff       	call   8014f0 <fd2num>
  80221a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80221c:	83 c4 04             	add    $0x4,%esp
  80221f:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802222:	e8 c9 f2 ff ff       	call   8014f0 <fd2num>
  802227:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
  80222f:	eb 30                	jmp    802261 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802231:	83 ec 08             	sub    $0x8,%esp
  802234:	56                   	push   %esi
  802235:	6a 00                	push   $0x0
  802237:	e8 27 ec ff ff       	call   800e63 <sys_page_unmap>
  80223c:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80223f:	83 ec 08             	sub    $0x8,%esp
  802242:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802245:	6a 00                	push   $0x0
  802247:	e8 17 ec ff ff       	call   800e63 <sys_page_unmap>
  80224c:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80224f:	83 ec 08             	sub    $0x8,%esp
  802252:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802255:	6a 00                	push   $0x0
  802257:	e8 07 ec ff ff       	call   800e63 <sys_page_unmap>
  80225c:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  80225f:	89 d8                	mov    %ebx,%eax
}
  802261:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5f                   	pop    %edi
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	57                   	push   %edi
  80226d:	56                   	push   %esi
  80226e:	53                   	push   %ebx
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802275:	a1 80 70 80 00       	mov    0x807080,%eax
  80227a:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  80227d:	83 ec 0c             	sub    $0xc,%esp
  802280:	ff 75 08             	pushl  0x8(%ebp)
  802283:	e8 64 05 00 00       	call   8027ec <pageref>
  802288:	89 c3                	mov    %eax,%ebx
  80228a:	89 3c 24             	mov    %edi,(%esp)
  80228d:	e8 5a 05 00 00       	call   8027ec <pageref>
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	39 c3                	cmp    %eax,%ebx
  802297:	0f 94 c0             	sete   %al
  80229a:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  80229d:	8b 0d 80 70 80 00    	mov    0x807080,%ecx
  8022a3:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  8022a6:	39 c6                	cmp    %eax,%esi
  8022a8:	74 1b                	je     8022c5 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  8022aa:	83 fa 01             	cmp    $0x1,%edx
  8022ad:	75 c6                	jne    802275 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8022af:	6a 01                	push   $0x1
  8022b1:	8b 41 58             	mov    0x58(%ecx),%eax
  8022b4:	50                   	push   %eax
  8022b5:	56                   	push   %esi
  8022b6:	68 38 32 80 00       	push   $0x803238
  8022bb:	e8 48 e1 ff ff       	call   800408 <cprintf>
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	eb b0                	jmp    802275 <_pipeisclosed+0xc>
	}
}
  8022c5:	89 d0                	mov    %edx,%eax
  8022c7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8022ca:	5b                   	pop    %ebx
  8022cb:	5e                   	pop    %esi
  8022cc:	5f                   	pop    %edi
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022d5:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8022d8:	50                   	push   %eax
  8022d9:	ff 75 08             	pushl  0x8(%ebp)
  8022dc:	e8 79 f2 ff ff       	call   80155a <fd_lookup>
  8022e1:	83 c4 10             	add    $0x10,%esp
		return r;
  8022e4:	89 c2                	mov    %eax,%edx
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	78 19                	js     802303 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8022f0:	e8 e3 f1 ff ff       	call   8014d8 <fd2data>
	return _pipeisclosed(fd, p);
  8022f5:	83 c4 08             	add    $0x8,%esp
  8022f8:	50                   	push   %eax
  8022f9:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8022fc:	e8 68 ff ff ff       	call   802269 <_pipeisclosed>
  802301:	89 c2                	mov    %eax,%edx
}
  802303:	89 d0                	mov    %edx,%eax
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	57                   	push   %edi
  80230b:	56                   	push   %esi
  80230c:	53                   	push   %ebx
  80230d:	83 ec 18             	sub    $0x18,%esp
  802310:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802313:	57                   	push   %edi
  802314:	e8 bf f1 ff ff       	call   8014d8 <fd2data>
  802319:	89 c3                	mov    %eax,%ebx
	if (debug)
  80231b:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80231e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802321:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802324:	be 00 00 00 00       	mov    $0x0,%esi
  802329:	3b 75 10             	cmp    0x10(%ebp),%esi
  80232c:	73 55                	jae    802383 <piperead+0x7c>
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
  80232e:	8b 03                	mov    (%ebx),%eax
  802330:	3b 43 04             	cmp    0x4(%ebx),%eax
  802333:	75 2c                	jne    802361 <piperead+0x5a>
  802335:	85 f6                	test   %esi,%esi
  802337:	74 04                	je     80233d <piperead+0x36>
  802339:	89 f0                	mov    %esi,%eax
  80233b:	eb 48                	jmp    802385 <piperead+0x7e>
  80233d:	83 ec 08             	sub    $0x8,%esp
  802340:	53                   	push   %ebx
  802341:	57                   	push   %edi
  802342:	e8 22 ff ff ff       	call   802269 <_pipeisclosed>
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	85 c0                	test   %eax,%eax
  80234c:	74 07                	je     802355 <piperead+0x4e>
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
  802353:	eb 30                	jmp    802385 <piperead+0x7e>
  802355:	e8 65 ea ff ff       	call   800dbf <sys_yield>
  80235a:	8b 03                	mov    (%ebx),%eax
  80235c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80235f:	74 d4                	je     802335 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802361:	8b 13                	mov    (%ebx),%edx
  802363:	89 d0                	mov    %edx,%eax
  802365:	85 d2                	test   %edx,%edx
  802367:	79 03                	jns    80236c <piperead+0x65>
  802369:	8d 42 1f             	lea    0x1f(%edx),%eax
  80236c:	83 e0 e0             	and    $0xffffffe0,%eax
  80236f:	29 c2                	sub    %eax,%edx
  802371:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  802375:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802378:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80237b:	ff 03                	incl   (%ebx)
  80237d:	46                   	inc    %esi
  80237e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802381:	72 ab                	jb     80232e <piperead+0x27>
	}
	return i;
  802383:	89 f0                	mov    %esi,%eax
}
  802385:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802388:	5b                   	pop    %ebx
  802389:	5e                   	pop    %esi
  80238a:	5f                   	pop    %edi
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	57                   	push   %edi
  802391:	56                   	push   %esi
  802392:	53                   	push   %ebx
  802393:	83 ec 18             	sub    $0x18,%esp
  802396:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  802399:	57                   	push   %edi
  80239a:	e8 39 f1 ff ff       	call   8014d8 <fd2data>
  80239f:	89 c3                	mov    %eax,%ebx
	if (debug)
  8023a1:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8023a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a7:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8023aa:	be 00 00 00 00       	mov    $0x0,%esi
  8023af:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023b2:	73 55                	jae    802409 <pipewrite+0x7c>
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
  8023b4:	8b 03                	mov    (%ebx),%eax
  8023b6:	83 c0 20             	add    $0x20,%eax
  8023b9:	39 43 04             	cmp    %eax,0x4(%ebx)
  8023bc:	72 27                	jb     8023e5 <pipewrite+0x58>
  8023be:	83 ec 08             	sub    $0x8,%esp
  8023c1:	53                   	push   %ebx
  8023c2:	57                   	push   %edi
  8023c3:	e8 a1 fe ff ff       	call   802269 <_pipeisclosed>
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 07                	je     8023d6 <pipewrite+0x49>
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	eb 35                	jmp    80240b <pipewrite+0x7e>
  8023d6:	e8 e4 e9 ff ff       	call   800dbf <sys_yield>
  8023db:	8b 03                	mov    (%ebx),%eax
  8023dd:	83 c0 20             	add    $0x20,%eax
  8023e0:	39 43 04             	cmp    %eax,0x4(%ebx)
  8023e3:	73 d9                	jae    8023be <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023e5:	8b 53 04             	mov    0x4(%ebx),%edx
  8023e8:	89 d0                	mov    %edx,%eax
  8023ea:	85 d2                	test   %edx,%edx
  8023ec:	79 03                	jns    8023f1 <pipewrite+0x64>
  8023ee:	8d 42 1f             	lea    0x1f(%edx),%eax
  8023f1:	83 e0 e0             	and    $0xffffffe0,%eax
  8023f4:	29 c2                	sub    %eax,%edx
  8023f6:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8023f9:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8023fc:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802400:	ff 43 04             	incl   0x4(%ebx)
  802403:	46                   	inc    %esi
  802404:	3b 75 10             	cmp    0x10(%ebp),%esi
  802407:	72 ab                	jb     8023b4 <pipewrite+0x27>
	}
	
	return i;
  802409:	89 f0                	mov    %esi,%eax
}
  80240b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80240e:	5b                   	pop    %ebx
  80240f:	5e                   	pop    %esi
  802410:	5f                   	pop    %edi
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80241b:	83 ec 0c             	sub    $0xc,%esp
  80241e:	ff 75 08             	pushl  0x8(%ebp)
  802421:	e8 b2 f0 ff ff       	call   8014d8 <fd2data>
  802426:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802428:	83 c4 08             	add    $0x8,%esp
  80242b:	68 4b 32 80 00       	push   $0x80324b
  802430:	53                   	push   %ebx
  802431:	e8 d6 e5 ff ff       	call   800a0c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802436:	8b 46 04             	mov    0x4(%esi),%eax
  802439:	2b 06                	sub    (%esi),%eax
  80243b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802441:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802448:	00 00 00 
	stat->st_dev = &devpipe;
  80244b:	c7 83 88 00 00 00 40 	movl   $0x807040,0x88(%ebx)
  802452:	70 80 00 
	return 0;
}
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
  80245a:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	53                   	push   %ebx
  802465:	83 ec 0c             	sub    $0xc,%esp
  802468:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80246b:	53                   	push   %ebx
  80246c:	6a 00                	push   $0x0
  80246e:	e8 f0 e9 ff ff       	call   800e63 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802473:	89 1c 24             	mov    %ebx,(%esp)
  802476:	e8 5d f0 ff ff       	call   8014d8 <fd2data>
  80247b:	83 c4 08             	add    $0x8,%esp
  80247e:	50                   	push   %eax
  80247f:	6a 00                	push   $0x0
  802481:	e8 dd e9 ff ff       	call   800e63 <sys_page_unmap>
}
  802486:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802489:	c9                   	leave  
  80248a:	c3                   	ret    
	...

0080248c <wait>:

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	56                   	push   %esi
  802490:	53                   	push   %ebx
  802491:	8b 75 08             	mov    0x8(%ebp),%esi
	volatile struct Env *e;

	assert(envid != 0);
  802494:	85 f6                	test   %esi,%esi
  802496:	75 16                	jne    8024ae <wait+0x22>
  802498:	68 52 32 80 00       	push   $0x803252
  80249d:	68 ef 31 80 00       	push   $0x8031ef
  8024a2:	6a 09                	push   $0x9
  8024a4:	68 5d 32 80 00       	push   $0x80325d
  8024a9:	e8 6a de ff ff       	call   800318 <_panic>
	e = &envs[ENVX(envid)];
  8024ae:	89 f3                	mov    %esi,%ebx
  8024b0:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8024b6:	89 d8                	mov    %ebx,%eax
  8024b8:	c1 e0 07             	shl    $0x7,%eax
  8024bb:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
		sys_yield();
  8024c1:	8b 43 4c             	mov    0x4c(%ebx),%eax
  8024c4:	39 f0                	cmp    %esi,%eax
  8024c6:	75 1a                	jne    8024e2 <wait+0x56>
  8024c8:	8b 43 54             	mov    0x54(%ebx),%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	74 13                	je     8024e2 <wait+0x56>
  8024cf:	e8 eb e8 ff ff       	call   800dbf <sys_yield>
  8024d4:	8b 43 4c             	mov    0x4c(%ebx),%eax
  8024d7:	39 f0                	cmp    %esi,%eax
  8024d9:	75 07                	jne    8024e2 <wait+0x56>
  8024db:	8b 43 54             	mov    0x54(%ebx),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	75 ed                	jne    8024cf <wait+0x43>
}
  8024e2:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8024e5:	5b                   	pop    %ebx
  8024e6:	5e                   	pop    %esi
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    
  8024e9:	00 00                	add    %al,(%eax)
	...

008024ec <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024f8:	6a 01                	push   $0x1
  8024fa:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8024fd:	50                   	push   %eax
  8024fe:	e8 19 e8 ff ff       	call   800d1c <sys_cputs>
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <getchar>:

int
getchar(void)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80250b:	6a 01                	push   $0x1
  80250d:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802510:	50                   	push   %eax
  802511:	6a 00                	push   $0x0
  802513:	e8 d5 f2 ff ff       	call   8017ed <read>
	if (r < 0)
  802518:	83 c4 10             	add    $0x10,%esp
		return r;
  80251b:	89 c2                	mov    %eax,%edx
  80251d:	85 c0                	test   %eax,%eax
  80251f:	78 0d                	js     80252e <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  802521:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  802526:	85 c0                	test   %eax,%eax
  802528:	7e 04                	jle    80252e <getchar+0x29>
	return c;
  80252a:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  80252e:	89 d0                	mov    %edx,%eax
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <iscons>:


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
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802538:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80253b:	50                   	push   %eax
  80253c:	ff 75 08             	pushl  0x8(%ebp)
  80253f:	e8 16 f0 ff ff       	call   80155a <fd_lookup>
  802544:	83 c4 10             	add    $0x10,%esp
		return r;
  802547:	89 c2                	mov    %eax,%edx
  802549:	85 c0                	test   %eax,%eax
  80254b:	78 11                	js     80255e <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  80254d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  802558:	0f 94 c0             	sete   %al
  80255b:	0f b6 d0             	movzbl %al,%edx
}
  80255e:	89 d0                	mov    %edx,%eax
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <opencons>:

int
opencons(void)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802568:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80256b:	50                   	push   %eax
  80256c:	e8 8f ef ff ff       	call   801500 <fd_alloc>
  802571:	83 c4 10             	add    $0x10,%esp
		return r;
  802574:	89 c2                	mov    %eax,%edx
  802576:	85 c0                	test   %eax,%eax
  802578:	78 3c                	js     8025b6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	68 07 04 00 00       	push   $0x407
  802582:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802585:	6a 00                	push   $0x0
  802587:	e8 52 e8 ff ff       	call   800dde <sys_page_alloc>
  80258c:	83 c4 10             	add    $0x10,%esp
		return r;
  80258f:	89 c2                	mov    %eax,%edx
  802591:	85 c0                	test   %eax,%eax
  802593:	78 21                	js     8025b6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802595:	a1 60 70 80 00       	mov    0x807060,%eax
  80259a:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  80259d:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80259f:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8025a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025a9:	83 ec 0c             	sub    $0xc,%esp
  8025ac:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8025af:	e8 3c ef ff ff       	call   8014f0 <fd2num>
  8025b4:	89 c2                	mov    %eax,%edx
}
  8025b6:	89 d0                	mov    %edx,%eax
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025c9:	74 2a                	je     8025f5 <cons_read+0x3b>
  8025cb:	eb 05                	jmp    8025d2 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025cd:	e8 ed e7 ff ff       	call   800dbf <sys_yield>
  8025d2:	e8 69 e7 ff ff       	call   800d40 <sys_cgetc>
  8025d7:	89 c2                	mov    %eax,%edx
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 f0                	je     8025cd <cons_read+0x13>
	if (c < 0)
  8025dd:	85 d2                	test   %edx,%edx
  8025df:	78 14                	js     8025f5 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e6:	83 fa 04             	cmp    $0x4,%edx
  8025e9:	74 0a                	je     8025f5 <cons_read+0x3b>
	*(char*)vbuf = c;
  8025eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ee:	88 10                	mov    %dl,(%eax)
	return 1;
  8025f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	57                   	push   %edi
  8025fb:	56                   	push   %esi
  8025fc:	53                   	push   %ebx
  8025fd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802603:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802606:	be 00 00 00 00       	mov    $0x0,%esi
  80260b:	39 fe                	cmp    %edi,%esi
  80260d:	73 3d                	jae    80264c <cons_write+0x55>
		m = n - tot;
  80260f:	89 fb                	mov    %edi,%ebx
  802611:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802613:	83 fb 7f             	cmp    $0x7f,%ebx
  802616:	76 05                	jbe    80261d <cons_write+0x26>
			m = sizeof(buf) - 1;
  802618:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80261d:	83 ec 04             	sub    $0x4,%esp
  802620:	53                   	push   %ebx
  802621:	8b 45 0c             	mov    0xc(%ebp),%eax
  802624:	01 f0                	add    %esi,%eax
  802626:	50                   	push   %eax
  802627:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  80262d:	50                   	push   %eax
  80262e:	e8 55 e5 ff ff       	call   800b88 <memmove>
		sys_cputs(buf, m);
  802633:	83 c4 08             	add    $0x8,%esp
  802636:	53                   	push   %ebx
  802637:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  80263d:	50                   	push   %eax
  80263e:	e8 d9 e6 ff ff       	call   800d1c <sys_cputs>
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	01 de                	add    %ebx,%esi
  802648:	39 fe                	cmp    %edi,%esi
  80264a:	72 c3                	jb     80260f <cons_write+0x18>
	}
	return tot;
}
  80264c:	89 f0                	mov    %esi,%eax
  80264e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <cons_close>:

int
cons_close(struct Fd *fd)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802666:	68 6d 32 80 00       	push   $0x80326d
  80266b:	ff 75 0c             	pushl  0xc(%ebp)
  80266e:	e8 99 e3 ff ff       	call   800a0c <strcpy>
	return 0;
}
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
  802678:	c9                   	leave  
  802679:	c3                   	ret    
	...

0080267c <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802682:	83 3d 88 70 80 00 00 	cmpl   $0x0,0x807088
  802689:	75 68                	jne    8026f3 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  80268b:	83 ec 04             	sub    $0x4,%esp
  80268e:	6a 07                	push   $0x7
  802690:	68 00 f0 bf ee       	push   $0xeebff000
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	e8 03 e7 ff ff       	call   800da0 <sys_getenvid>
  80269d:	89 04 24             	mov    %eax,(%esp)
  8026a0:	e8 39 e7 ff ff       	call   800dde <sys_page_alloc>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	79 14                	jns    8026c0 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	68 74 32 80 00       	push   $0x803274
  8026b4:	6a 21                	push   $0x21
  8026b6:	68 d5 32 80 00       	push   $0x8032d5
  8026bb:	e8 58 dc ff ff       	call   800318 <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  8026c0:	83 ec 08             	sub    $0x8,%esp
  8026c3:	68 00 27 80 00       	push   $0x802700
  8026c8:	83 ec 04             	sub    $0x4,%esp
  8026cb:	e8 d0 e6 ff ff       	call   800da0 <sys_getenvid>
  8026d0:	89 04 24             	mov    %eax,(%esp)
  8026d3:	e8 51 e8 ff ff       	call   800f29 <sys_env_set_pgfault_upcall>
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	79 14                	jns    8026f3 <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	68 a4 32 80 00       	push   $0x8032a4
  8026e7:	6a 24                	push   $0x24
  8026e9:	68 d5 32 80 00       	push   $0x8032d5
  8026ee:	e8 25 dc ff ff       	call   800318 <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	a3 88 70 80 00       	mov    %eax,0x807088
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    
  8026fd:	00 00                	add    %al,(%eax)
	...

00802700 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802700:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802701:	a1 88 70 80 00       	mov    0x807088,%eax
	call *%eax
  802706:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802708:	83 c4 04             	add    $0x4,%esp
	
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
  80270b:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  80270f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  802713:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  802716:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  802719:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  80271c:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  802720:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  802723:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  802727:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  802728:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  80272b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  80272c:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  80272d:	c3                   	ret    
	...

00802730 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	56                   	push   %esi
  802734:	53                   	push   %ebx
  802735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273b:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80273e:	85 c0                	test   %eax,%eax
  802740:	75 12                	jne    802754 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  802742:	83 ec 0c             	sub    $0xc,%esp
  802745:	68 00 00 c0 ee       	push   $0xeec00000
  80274a:	e8 3f e8 ff ff       	call   800f8e <sys_ipc_recv>
  80274f:	83 c4 10             	add    $0x10,%esp
  802752:	eb 0c                	jmp    802760 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802754:	83 ec 0c             	sub    $0xc,%esp
  802757:	50                   	push   %eax
  802758:	e8 31 e8 ff ff       	call   800f8e <sys_ipc_recv>
  80275d:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802760:	89 c2                	mov    %eax,%edx
  802762:	85 c0                	test   %eax,%eax
  802764:	78 24                	js     80278a <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802766:	85 db                	test   %ebx,%ebx
  802768:	74 0a                	je     802774 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  80276a:	a1 80 70 80 00       	mov    0x807080,%eax
  80276f:	8b 40 74             	mov    0x74(%eax),%eax
  802772:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802774:	85 f6                	test   %esi,%esi
  802776:	74 0a                	je     802782 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802778:	a1 80 70 80 00       	mov    0x807080,%eax
  80277d:	8b 40 78             	mov    0x78(%eax),%eax
  802780:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802782:	a1 80 70 80 00       	mov    0x807080,%eax
  802787:	8b 50 70             	mov    0x70(%eax),%edx

}
  80278a:	89 d0                	mov    %edx,%eax
  80278c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80278f:	5b                   	pop    %ebx
  802790:	5e                   	pop    %esi
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <ipc_send>:

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
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
  802796:	57                   	push   %edi
  802797:	56                   	push   %esi
  802798:	53                   	push   %ebx
  802799:	83 ec 0c             	sub    $0xc,%esp
  80279c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80279f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027a2:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  8027a5:	85 db                	test   %ebx,%ebx
  8027a7:	75 0a                	jne    8027b3 <ipc_send+0x20>
    pg = (void *) UTOP;
  8027a9:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  8027ae:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	57                   	push   %edi
  8027b6:	ff 75 08             	pushl  0x8(%ebp)
  8027b9:	e8 ad e7 ff ff       	call   800f6b <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  8027be:	83 c4 10             	add    $0x10,%esp
  8027c1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027c4:	75 07                	jne    8027cd <ipc_send+0x3a>
      sys_yield();
  8027c6:	e8 f4 e5 ff ff       	call   800dbf <sys_yield>
  8027cb:	eb e6                	jmp    8027b3 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	79 12                	jns    8027e3 <ipc_send+0x50>
  8027d1:	50                   	push   %eax
  8027d2:	68 e3 32 80 00       	push   $0x8032e3
  8027d7:	6a 49                	push   $0x49
  8027d9:	68 00 33 80 00       	push   $0x803300
  8027de:	e8 35 db ff ff       	call   800318 <_panic>
    else break;
  }
}
  8027e3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8027e6:	5b                   	pop    %ebx
  8027e7:	5e                   	pop    %esi
  8027e8:	5f                   	pop    %edi
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    
	...

008027ec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027f2:	89 c8                	mov    %ecx,%eax
  8027f4:	c1 e8 16             	shr    $0x16,%eax
  8027f7:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8027fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802803:	a8 01                	test   $0x1,%al
  802805:	74 28                	je     80282f <pageref+0x43>
	pte = vpt[VPN(v)];
  802807:	89 c8                	mov    %ecx,%eax
  802809:	c1 e8 0c             	shr    $0xc,%eax
  80280c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  802813:	ba 00 00 00 00       	mov    $0x0,%edx
  802818:	a8 01                	test   $0x1,%al
  80281a:	74 13                	je     80282f <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  80281c:	c1 e8 0c             	shr    $0xc,%eax
  80281f:	8d 04 40             	lea    (%eax,%eax,2),%eax
  802822:	c1 e0 02             	shl    $0x2,%eax
  802825:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  80282c:	0f b7 d0             	movzwl %ax,%edx
}
  80282f:	89 d0                	mov    %edx,%eax
  802831:	c9                   	leave  
  802832:	c3                   	ret    
	...

00802834 <__udivdi3>:
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	57                   	push   %edi
  802838:	56                   	push   %esi
  802839:	83 ec 14             	sub    $0x14,%esp
  80283c:	8b 55 14             	mov    0x14(%ebp),%edx
  80283f:	8b 75 08             	mov    0x8(%ebp),%esi
  802842:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802845:	8b 45 10             	mov    0x10(%ebp),%eax
  802848:	85 d2                	test   %edx,%edx
  80284a:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80284d:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802850:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802853:	89 fe                	mov    %edi,%esi
  802855:	75 11                	jne    802868 <__udivdi3+0x34>
  802857:	39 f8                	cmp    %edi,%eax
  802859:	76 4d                	jbe    8028a8 <__udivdi3+0x74>
  80285b:	89 fa                	mov    %edi,%edx
  80285d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802860:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802863:	89 c7                	mov    %eax,%edi
  802865:	eb 09                	jmp    802870 <__udivdi3+0x3c>
  802867:	90                   	nop    
  802868:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80286b:	76 17                	jbe    802884 <__udivdi3+0x50>
  80286d:	31 ff                	xor    %edi,%edi
  80286f:	90                   	nop    
  802870:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802877:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80287a:	83 c4 14             	add    $0x14,%esp
  80287d:	5e                   	pop    %esi
  80287e:	89 f8                	mov    %edi,%eax
  802880:	5f                   	pop    %edi
  802881:	c9                   	leave  
  802882:	c3                   	ret    
  802883:	90                   	nop    
  802884:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802888:	89 c7                	mov    %eax,%edi
  80288a:	83 f7 1f             	xor    $0x1f,%edi
  80288d:	75 4d                	jne    8028dc <__udivdi3+0xa8>
  80288f:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802892:	77 0a                	ja     80289e <__udivdi3+0x6a>
  802894:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802897:	31 ff                	xor    %edi,%edi
  802899:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  80289c:	72 d2                	jb     802870 <__udivdi3+0x3c>
  80289e:	bf 01 00 00 00       	mov    $0x1,%edi
  8028a3:	eb cb                	jmp    802870 <__udivdi3+0x3c>
  8028a5:	8d 76 00             	lea    0x0(%esi),%esi
  8028a8:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	75 0e                	jne    8028bd <__udivdi3+0x89>
  8028af:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b4:	31 c9                	xor    %ecx,%ecx
  8028b6:	31 d2                	xor    %edx,%edx
  8028b8:	f7 f1                	div    %ecx
  8028ba:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8028bd:	89 f0                	mov    %esi,%eax
  8028bf:	31 d2                	xor    %edx,%edx
  8028c1:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8028c4:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8028c7:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8028ca:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8028cd:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8028d0:	83 c4 14             	add    $0x14,%esp
  8028d3:	89 c7                	mov    %eax,%edi
  8028d5:	5e                   	pop    %esi
  8028d6:	89 f8                	mov    %edi,%eax
  8028d8:	5f                   	pop    %edi
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    
  8028db:	90                   	nop    
  8028dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8028e1:	29 f8                	sub    %edi,%eax
  8028e3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8028e6:	89 f9                	mov    %edi,%ecx
  8028e8:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8028eb:	d3 e2                	shl    %cl,%edx
  8028ed:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8028f0:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8028f3:	d3 e8                	shr    %cl,%eax
  8028f5:	09 c2                	or     %eax,%edx
  8028f7:	89 f9                	mov    %edi,%ecx
  8028f9:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8028fc:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8028ff:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802902:	89 f2                	mov    %esi,%edx
  802904:	d3 ea                	shr    %cl,%edx
  802906:	89 f9                	mov    %edi,%ecx
  802908:	d3 e6                	shl    %cl,%esi
  80290a:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80290d:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802910:	d3 e8                	shr    %cl,%eax
  802912:	09 c6                	or     %eax,%esi
  802914:	89 f9                	mov    %edi,%ecx
  802916:	89 f0                	mov    %esi,%eax
  802918:	f7 75 f4             	divl   0xfffffff4(%ebp)
  80291b:	89 d6                	mov    %edx,%esi
  80291d:	89 c7                	mov    %eax,%edi
  80291f:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  802922:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802925:	f7 e7                	mul    %edi
  802927:	39 f2                	cmp    %esi,%edx
  802929:	77 0f                	ja     80293a <__udivdi3+0x106>
  80292b:	0f 85 3f ff ff ff    	jne    802870 <__udivdi3+0x3c>
  802931:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802934:	0f 86 36 ff ff ff    	jbe    802870 <__udivdi3+0x3c>
  80293a:	4f                   	dec    %edi
  80293b:	e9 30 ff ff ff       	jmp    802870 <__udivdi3+0x3c>

00802940 <__umoddi3>:
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	57                   	push   %edi
  802944:	56                   	push   %esi
  802945:	83 ec 30             	sub    $0x30,%esp
  802948:	8b 55 14             	mov    0x14(%ebp),%edx
  80294b:	8b 45 10             	mov    0x10(%ebp),%eax
  80294e:	89 d7                	mov    %edx,%edi
  802950:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802953:	89 c6                	mov    %eax,%esi
  802955:	8b 55 0c             	mov    0xc(%ebp),%edx
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	85 ff                	test   %edi,%edi
  80295d:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802964:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80296b:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  80296e:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802971:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802974:	75 3e                	jne    8029b4 <__umoddi3+0x74>
  802976:	39 d6                	cmp    %edx,%esi
  802978:	0f 86 a2 00 00 00    	jbe    802a20 <__umoddi3+0xe0>
  80297e:	f7 f6                	div    %esi
  802980:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802983:	85 c9                	test   %ecx,%ecx
  802985:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802988:	74 1b                	je     8029a5 <__umoddi3+0x65>
  80298a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80298d:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802990:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802997:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80299a:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  80299d:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  8029a0:	89 10                	mov    %edx,(%eax)
  8029a2:	89 48 04             	mov    %ecx,0x4(%eax)
  8029a5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8029a8:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8029ab:	83 c4 30             	add    $0x30,%esp
  8029ae:	5e                   	pop    %esi
  8029af:	5f                   	pop    %edi
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    
  8029b2:	89 f6                	mov    %esi,%esi
  8029b4:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  8029b7:	76 1f                	jbe    8029d8 <__umoddi3+0x98>
  8029b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bc:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8029bf:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8029c2:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  8029c5:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8029c8:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8029cb:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8029ce:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8029d1:	83 c4 30             	add    $0x30,%esp
  8029d4:	5e                   	pop    %esi
  8029d5:	5f                   	pop    %edi
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    
  8029d8:	0f bd c7             	bsr    %edi,%eax
  8029db:	83 f0 1f             	xor    $0x1f,%eax
  8029de:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8029e1:	75 61                	jne    802a44 <__umoddi3+0x104>
  8029e3:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8029e6:	77 05                	ja     8029ed <__umoddi3+0xad>
  8029e8:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8029eb:	72 10                	jb     8029fd <__umoddi3+0xbd>
  8029ed:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8029f0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8029f3:	29 f0                	sub    %esi,%eax
  8029f5:	19 fa                	sbb    %edi,%edx
  8029f7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8029fa:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8029fd:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802a00:	85 d2                	test   %edx,%edx
  802a02:	74 a1                	je     8029a5 <__umoddi3+0x65>
  802a04:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a07:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802a0a:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802a0d:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802a10:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802a13:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802a16:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802a19:	89 01                	mov    %eax,(%ecx)
  802a1b:	89 51 04             	mov    %edx,0x4(%ecx)
  802a1e:	eb 85                	jmp    8029a5 <__umoddi3+0x65>
  802a20:	85 f6                	test   %esi,%esi
  802a22:	75 0b                	jne    802a2f <__umoddi3+0xef>
  802a24:	b8 01 00 00 00       	mov    $0x1,%eax
  802a29:	31 d2                	xor    %edx,%edx
  802a2b:	f7 f6                	div    %esi
  802a2d:	89 c6                	mov    %eax,%esi
  802a2f:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802a32:	89 fa                	mov    %edi,%edx
  802a34:	f7 f6                	div    %esi
  802a36:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a39:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802a3c:	f7 f6                	div    %esi
  802a3e:	e9 3d ff ff ff       	jmp    802980 <__umoddi3+0x40>
  802a43:	90                   	nop    
  802a44:	b8 20 00 00 00       	mov    $0x20,%eax
  802a49:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802a4c:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802a4f:	89 fa                	mov    %edi,%edx
  802a51:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802a54:	d3 e2                	shl    %cl,%edx
  802a56:	89 f0                	mov    %esi,%eax
  802a58:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802a5b:	d3 e8                	shr    %cl,%eax
  802a5d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802a60:	d3 e6                	shl    %cl,%esi
  802a62:	89 d7                	mov    %edx,%edi
  802a64:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802a67:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802a6a:	09 c7                	or     %eax,%edi
  802a6c:	d3 ea                	shr    %cl,%edx
  802a6e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802a71:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802a74:	d3 e0                	shl    %cl,%eax
  802a76:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802a79:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802a7c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a7f:	d3 e8                	shr    %cl,%eax
  802a81:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802a84:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802a87:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802a8a:	f7 f7                	div    %edi
  802a8c:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802a8f:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802a92:	f7 e6                	mul    %esi
  802a94:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802a97:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802a9a:	77 0a                	ja     802aa6 <__umoddi3+0x166>
  802a9c:	75 12                	jne    802ab0 <__umoddi3+0x170>
  802a9e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802aa1:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802aa4:	76 0a                	jbe    802ab0 <__umoddi3+0x170>
  802aa6:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802aa9:	29 f1                	sub    %esi,%ecx
  802aab:	19 fa                	sbb    %edi,%edx
  802aad:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802ab0:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	0f 84 ea fe ff ff    	je     8029a5 <__umoddi3+0x65>
  802abb:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802abe:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802ac1:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802ac4:	19 d1                	sbb    %edx,%ecx
  802ac6:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802ac9:	89 ca                	mov    %ecx,%edx
  802acb:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802ace:	d3 e2                	shl    %cl,%edx
  802ad0:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802ad3:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802ad6:	d3 e8                	shr    %cl,%eax
  802ad8:	09 c2                	or     %eax,%edx
  802ada:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802add:	d3 e8                	shr    %cl,%eax
  802adf:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802ae2:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802ae5:	e9 ad fe ff ff       	jmp    802997 <__umoddi3+0x57>
