
obj/user/prfork:     file format elf32-i386

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
  80002c:	e8 c3 01 00 00       	call   8001f4 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
envid_t prfork(void);

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
	envid_t who;
	int i;

	// fork a child process
	who = prfork();
  800039:	e8 e4 00 00 00       	call   800122 <prfork>
  80003e:	89 c6                	mov    %eax,%esi

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800040:	bb 00 00 00 00       	mov    $0x0,%ebx
  800045:	eb 26                	jmp    80006d <umain+0x39>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800047:	83 ec 04             	sub    $0x4,%esp
  80004a:	b8 80 25 80 00       	mov    $0x802580,%eax
  80004f:	85 f6                	test   %esi,%esi
  800051:	75 05                	jne    800058 <umain+0x24>
  800053:	b8 87 25 80 00       	mov    $0x802587,%eax
  800058:	50                   	push   %eax
  800059:	53                   	push   %ebx
  80005a:	68 8d 25 80 00       	push   $0x80258d
  80005f:	e8 dc 02 00 00       	call   800340 <cprintf>
		sys_yield();
  800064:	e8 8e 0c 00 00       	call   800cf7 <sys_yield>
  800069:	83 c4 10             	add    $0x10,%esp
  80006c:	43                   	inc    %ebx
  80006d:	85 f6                	test   %esi,%esi
  80006f:	74 07                	je     800078 <umain+0x44>
  800071:	83 fb 09             	cmp    $0x9,%ebx
  800074:	7e d1                	jle    800047 <umain+0x13>
  800076:	eb 05                	jmp    80007d <umain+0x49>
  800078:	83 fb 13             	cmp    $0x13,%ebx
  80007b:	7e ca                	jle    800047 <umain+0x13>
	}
}
  80007d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	c9                   	leave  
  800083:	c3                   	ret    

00800084 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	56                   	push   %esi
  800088:	53                   	push   %ebx
  800089:	8b 75 08             	mov    0x8(%ebp),%esi
  80008c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80008f:	83 ec 04             	sub    $0x4,%esp
  800092:	6a 07                	push   $0x7
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 7b 0c 00 00       	call   800d16 <sys_page_alloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	79 12                	jns    8000b4 <duppage+0x30>
		panic("sys_page_alloc: %e", r);
  8000a2:	50                   	push   %eax
  8000a3:	68 9f 25 80 00       	push   $0x80259f
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 b2 25 80 00       	push   $0x8025b2
  8000af:	e8 9c 01 00 00       	call   800250 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 07                	push   $0x7
  8000b9:	68 00 00 40 00       	push   $0x400000
  8000be:	6a 00                	push   $0x0
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 92 0c 00 00       	call   800d59 <sys_page_map>
  8000c7:	83 c4 20             	add    $0x20,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	79 12                	jns    8000e0 <duppage+0x5c>
		panic("sys_page_map: %e", r);
  8000ce:	50                   	push   %eax
  8000cf:	68 c0 25 80 00       	push   $0x8025c0
  8000d4:	6a 22                	push   $0x22
  8000d6:	68 b2 25 80 00       	push   $0x8025b2
  8000db:	e8 70 01 00 00       	call   800250 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	68 00 10 00 00       	push   $0x1000
  8000e8:	53                   	push   %ebx
  8000e9:	68 00 00 40 00       	push   $0x400000
  8000ee:	e8 cd 09 00 00       	call   800ac0 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	68 00 00 40 00       	push   $0x400000
  8000fb:	6a 00                	push   $0x0
  8000fd:	e8 99 0c 00 00       	call   800d9b <sys_page_unmap>
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	85 c0                	test   %eax,%eax
  800107:	79 12                	jns    80011b <duppage+0x97>
		panic("sys_page_unmap: %e", r);
  800109:	50                   	push   %eax
  80010a:	68 d1 25 80 00       	push   $0x8025d1
  80010f:	6a 25                	push   $0x25
  800111:	68 b2 25 80 00       	push   $0x8025b2
  800116:	e8 35 01 00 00       	call   800250 <_panic>
}
  80011b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	c9                   	leave  
  800121:	c3                   	ret    

00800122 <prfork>:

envid_t
prfork(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	53                   	push   %ebx
  800126:	83 ec 04             	sub    $0x4,%esp
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  800129:	ba 07 00 00 00       	mov    $0x7,%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	cd 30                	int    $0x30
  800132:	89 c3                	mov    %eax,%ebx
	envid_t envid;
	uint8_t *addr;
	int r;
	extern unsigned char end[];

	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  800134:	85 c0                	test   %eax,%eax
  800136:	79 12                	jns    80014a <prfork+0x28>
		panic("sys_exofork: %e", envid);
  800138:	50                   	push   %eax
  800139:	68 e4 25 80 00       	push   $0x8025e4
  80013e:	6a 37                	push   $0x37
  800140:	68 b2 25 80 00       	push   $0x8025b2
  800145:	e8 06 01 00 00       	call   800250 <_panic>
	if (envid == 0) {
  80014a:	85 c0                	test   %eax,%eax
  80014c:	75 1e                	jne    80016c <prfork+0x4a>
		// We're the child.
		// The copied value of the global variable 'env'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
                //sys_env_set_priority(sys_getenvid(), ENV_PR_LOWEST);
		env = &envs[ENVX(sys_getenvid())];
  80014e:	e8 85 0b 00 00       	call   800cd8 <sys_getenvid>
  800153:	25 ff 03 00 00       	and    $0x3ff,%eax
  800158:	c1 e0 07             	shl    $0x7,%eax
  80015b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800160:	a3 80 60 80 00       	mov    %eax,0x806080
		return 0;
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	eb 7f                	jmp    8001eb <prfork+0xc9>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
        //sys_env_set_priority(sys_getenvid(), ENV_PR_LOWEST);
        sys_env_set_priority(sys_getenvid(), ENV_PR_HIGHEST);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	6a 02                	push   $0x2
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	e8 5f 0b 00 00       	call   800cd8 <sys_getenvid>
  800179:	89 04 24             	mov    %eax,(%esp)
  80017c:	e8 ab 0e 00 00       	call   80102c <sys_env_set_priority>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800181:	c7 45 f8 00 00 80 00 	movl   $0x800000,0xfffffff8(%ebp)
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	81 7d f8 88 60 80 00 	cmpl   $0x806088,0xfffffff8(%ebp)
  800192:	73 1f                	jae    8001b3 <prfork+0x91>
		duppage(envid, addr);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80019a:	53                   	push   %ebx
  80019b:	e8 e4 fe ff ff       	call   800084 <duppage>
  8001a0:	83 c4 10             	add    $0x10,%esp
  8001a3:	81 45 f8 00 10 00 00 	addl   $0x1000,0xfffffff8(%ebp)
  8001aa:	81 7d f8 88 60 80 00 	cmpl   $0x806088,0xfffffff8(%ebp)
  8001b1:	72 e1                	jb     800194 <prfork+0x72>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8001b3:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8001b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	50                   	push   %eax
  8001bf:	53                   	push   %ebx
  8001c0:	e8 bf fe ff ff       	call   800084 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001c5:	83 c4 08             	add    $0x8,%esp
  8001c8:	6a 01                	push   $0x1
  8001ca:	53                   	push   %ebx
  8001cb:	e8 0d 0c 00 00       	call   800ddd <sys_env_set_status>
  8001d0:	83 c4 10             	add    $0x10,%esp
		panic("sys_env_set_status: %e", r);

	return envid;
  8001d3:	89 da                	mov    %ebx,%edx
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	79 12                	jns    8001eb <prfork+0xc9>
  8001d9:	50                   	push   %eax
  8001da:	68 f4 25 80 00       	push   $0x8025f4
  8001df:	6a 4f                	push   $0x4f
  8001e1:	68 b2 25 80 00       	push   $0x8025b2
  8001e6:	e8 65 00 00 00       	call   800250 <_panic>
}
  8001eb:	89 d0                	mov    %edx,%eax
  8001ed:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    
	...

008001f4 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	56                   	push   %esi
  8001f8:	53                   	push   %ebx
  8001f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8001fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8001ff:	e8 d4 0a 00 00       	call   800cd8 <sys_getenvid>
  800204:	25 ff 03 00 00       	and    $0x3ff,%eax
  800209:	c1 e0 07             	shl    $0x7,%eax
  80020c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800211:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800216:	85 f6                	test   %esi,%esi
  800218:	7e 07                	jle    800221 <libmain+0x2d>
		binaryname = argv[0];
  80021a:	8b 03                	mov    (%ebx),%eax
  80021c:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	53                   	push   %ebx
  800225:	56                   	push   %esi
  800226:	e8 09 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80022b:	e8 08 00 00 00       	call   800238 <exit>
}
  800230:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800233:	5b                   	pop    %ebx
  800234:	5e                   	pop    %esi
  800235:	c9                   	leave  
  800236:	c3                   	ret    
	...

00800238 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80023e:	e8 fd 0f 00 00       	call   801240 <close_all>
	sys_env_destroy(0);
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	6a 00                	push   $0x0
  800248:	e8 4a 0a 00 00       	call   800c97 <sys_env_destroy>
}
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    
	...

00800250 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	53                   	push   %ebx
  800254:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  800257:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  80025a:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  800261:	74 16                	je     800279 <_panic+0x29>
		cprintf("%s: ", argv0);
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	ff 35 84 60 80 00    	pushl  0x806084
  80026c:	68 22 26 80 00       	push   $0x802622
  800271:	e8 ca 00 00 00       	call   800340 <cprintf>
  800276:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	ff 35 00 60 80 00    	pushl  0x806000
  800285:	68 27 26 80 00       	push   $0x802627
  80028a:	e8 b1 00 00 00       	call   800340 <cprintf>
	vcprintf(fmt, ap);
  80028f:	83 c4 08             	add    $0x8,%esp
  800292:	53                   	push   %ebx
  800293:	ff 75 10             	pushl  0x10(%ebp)
  800296:	e8 54 00 00 00       	call   8002ef <vcprintf>
	cprintf("\n");
  80029b:	c7 04 24 9d 25 80 00 	movl   $0x80259d,(%esp)
  8002a2:	e8 99 00 00 00       	call   800340 <cprintf>

	// Cause a breakpoint exception
	while (1)
  8002a7:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8002aa:	cc                   	int3   
  8002ab:	eb fd                	jmp    8002aa <_panic+0x5a>
  8002ad:	00 00                	add    %al,(%eax)
	...

008002b0 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ba:	8b 03                	mov    (%ebx),%eax
  8002bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bf:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  8002c3:	40                   	inc    %eax
  8002c4:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002cb:	75 1a                	jne    8002e7 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	68 ff 00 00 00       	push   $0xff
  8002d5:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d8:	50                   	push   %eax
  8002d9:	e8 76 09 00 00       	call   800c54 <sys_cputs>
		b->idx = 0;
  8002de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e4:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8002e7:	ff 43 04             	incl   0x4(%ebx)
}
  8002ea:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f8:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  8002ff:	00 00 00 
	b.cnt = 0;
  800302:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800309:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030c:	ff 75 0c             	pushl  0xc(%ebp)
  80030f:	ff 75 08             	pushl  0x8(%ebp)
  800312:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800318:	50                   	push   %eax
  800319:	68 b0 02 80 00       	push   $0x8002b0
  80031e:	e8 4f 01 00 00       	call   800472 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800323:	83 c4 08             	add    $0x8,%esp
  800326:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  80032c:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  800332:	50                   	push   %eax
  800333:	e8 1c 09 00 00       	call   800c54 <sys_cputs>

	return b.cnt;
  800338:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80033e:	c9                   	leave  
  80033f:	c3                   	ret    

00800340 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800346:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800349:	50                   	push   %eax
  80034a:	ff 75 08             	pushl  0x8(%ebp)
  80034d:	e8 9d ff ff ff       	call   8002ef <vcprintf>
	va_end(ap);

	return cnt;
}
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	8b 75 10             	mov    0x10(%ebp),%esi
  800360:	8b 7d 14             	mov    0x14(%ebp),%edi
  800363:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800366:	8b 45 18             	mov    0x18(%ebp),%eax
  800369:	ba 00 00 00 00       	mov    $0x0,%edx
  80036e:	39 fa                	cmp    %edi,%edx
  800370:	77 39                	ja     8003ab <printnum+0x57>
  800372:	72 04                	jb     800378 <printnum+0x24>
  800374:	39 f0                	cmp    %esi,%eax
  800376:	77 33                	ja     8003ab <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	ff 75 20             	pushl  0x20(%ebp)
  80037e:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800381:	50                   	push   %eax
  800382:	ff 75 18             	pushl  0x18(%ebp)
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	ba 00 00 00 00       	mov    $0x0,%edx
  80038d:	52                   	push   %edx
  80038e:	50                   	push   %eax
  80038f:	57                   	push   %edi
  800390:	56                   	push   %esi
  800391:	e8 22 1f 00 00       	call   8022b8 <__udivdi3>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	52                   	push   %edx
  80039a:	50                   	push   %eax
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 ae ff ff ff       	call   800354 <printnum>
  8003a6:	83 c4 20             	add    $0x20,%esp
  8003a9:	eb 19                	jmp    8003c4 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ab:	4b                   	dec    %ebx
  8003ac:	85 db                	test   %ebx,%ebx
  8003ae:	7e 14                	jle    8003c4 <printnum+0x70>
  8003b0:	83 ec 08             	sub    $0x8,%esp
  8003b3:	ff 75 0c             	pushl  0xc(%ebp)
  8003b6:	ff 75 20             	pushl  0x20(%ebp)
  8003b9:	ff 55 08             	call   *0x8(%ebp)
  8003bc:	83 c4 10             	add    $0x10,%esp
  8003bf:	4b                   	dec    %ebx
  8003c0:	85 db                	test   %ebx,%ebx
  8003c2:	7f ec                	jg     8003b0 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8003cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d2:	83 ec 04             	sub    $0x4,%esp
  8003d5:	52                   	push   %edx
  8003d6:	50                   	push   %eax
  8003d7:	57                   	push   %edi
  8003d8:	56                   	push   %esi
  8003d9:	e8 e6 1f 00 00       	call   8023c4 <__umoddi3>
  8003de:	83 c4 14             	add    $0x14,%esp
  8003e1:	0f be 80 3d 27 80 00 	movsbl 0x80273d(%eax),%eax
  8003e8:	50                   	push   %eax
  8003e9:	ff 55 08             	call   *0x8(%ebp)
}
  8003ec:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8003ef:	5b                   	pop    %ebx
  8003f0:	5e                   	pop    %esi
  8003f1:	5f                   	pop    %edi
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8003fd:	83 f8 01             	cmp    $0x1,%eax
  800400:	7e 0f                	jle    800411 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800402:	8b 01                	mov    (%ecx),%eax
  800404:	83 c0 08             	add    $0x8,%eax
  800407:	89 01                	mov    %eax,(%ecx)
  800409:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80040c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80040f:	eb 24                	jmp    800435 <getuint+0x41>
	else if (lflag)
  800411:	85 c0                	test   %eax,%eax
  800413:	74 11                	je     800426 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800415:	8b 01                	mov    (%ecx),%eax
  800417:	83 c0 04             	add    $0x4,%eax
  80041a:	89 01                	mov    %eax,(%ecx)
  80041c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80041f:	ba 00 00 00 00       	mov    $0x0,%edx
  800424:	eb 0f                	jmp    800435 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800426:	8b 01                	mov    (%ecx),%eax
  800428:	83 c0 04             	add    $0x4,%eax
  80042b:	89 01                	mov    %eax,(%ecx)
  80042d:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800430:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800435:	c9                   	leave  
  800436:	c3                   	ret    

00800437 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800437:	55                   	push   %ebp
  800438:	89 e5                	mov    %esp,%ebp
  80043a:	8b 55 08             	mov    0x8(%ebp),%edx
  80043d:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800440:	83 f8 01             	cmp    $0x1,%eax
  800443:	7e 0f                	jle    800454 <getint+0x1d>
		return va_arg(*ap, long long);
  800445:	8b 02                	mov    (%edx),%eax
  800447:	83 c0 08             	add    $0x8,%eax
  80044a:	89 02                	mov    %eax,(%edx)
  80044c:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80044f:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800452:	eb 1c                	jmp    800470 <getint+0x39>
	else if (lflag)
  800454:	85 c0                	test   %eax,%eax
  800456:	74 0d                	je     800465 <getint+0x2e>
		return va_arg(*ap, long);
  800458:	8b 02                	mov    (%edx),%eax
  80045a:	83 c0 04             	add    $0x4,%eax
  80045d:	89 02                	mov    %eax,(%edx)
  80045f:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800462:	99                   	cltd   
  800463:	eb 0b                	jmp    800470 <getint+0x39>
	else
		return va_arg(*ap, int);
  800465:	8b 02                	mov    (%edx),%eax
  800467:	83 c0 04             	add    $0x4,%eax
  80046a:	89 02                	mov    %eax,(%edx)
  80046c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80046f:	99                   	cltd   
}
  800470:	c9                   	leave  
  800471:	c3                   	ret    

00800472 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	57                   	push   %edi
  800476:	56                   	push   %esi
  800477:	53                   	push   %ebx
  800478:	83 ec 1c             	sub    $0x1c,%esp
  80047b:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  80047e:	0f b6 13             	movzbl (%ebx),%edx
  800481:	43                   	inc    %ebx
  800482:	83 fa 25             	cmp    $0x25,%edx
  800485:	74 1e                	je     8004a5 <vprintfmt+0x33>
  800487:	85 d2                	test   %edx,%edx
  800489:	0f 84 d7 02 00 00    	je     800766 <vprintfmt+0x2f4>
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	ff 75 0c             	pushl  0xc(%ebp)
  800495:	52                   	push   %edx
  800496:	ff 55 08             	call   *0x8(%ebp)
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	0f b6 13             	movzbl (%ebx),%edx
  80049f:	43                   	inc    %ebx
  8004a0:	83 fa 25             	cmp    $0x25,%edx
  8004a3:	75 e2                	jne    800487 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8004a5:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8004a9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8004b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  8004b5:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  8004ba:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c1:	0f b6 13             	movzbl (%ebx),%edx
  8004c4:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  8004c7:	43                   	inc    %ebx
  8004c8:	83 f8 55             	cmp    $0x55,%eax
  8004cb:	0f 87 70 02 00 00    	ja     800741 <vprintfmt+0x2cf>
  8004d1:	ff 24 85 bc 27 80 00 	jmp    *0x8027bc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d8:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  8004dc:	eb e3                	jmp    8004c1 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004de:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  8004e2:	eb dd                	jmp    8004c1 <vprintfmt+0x4f>

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
  8004e4:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8004e9:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8004ec:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8004f0:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8004f3:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8004f6:	83 f8 09             	cmp    $0x9,%eax
  8004f9:	77 27                	ja     800522 <vprintfmt+0xb0>
  8004fb:	43                   	inc    %ebx
  8004fc:	eb eb                	jmp    8004e9 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004fe:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800508:	eb 18                	jmp    800522 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80050a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80050e:	79 b1                	jns    8004c1 <vprintfmt+0x4f>
				width = 0;
  800510:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800517:	eb a8                	jmp    8004c1 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800519:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800520:	eb 9f                	jmp    8004c1 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  800522:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800526:	79 99                	jns    8004c1 <vprintfmt+0x4f>
				width = precision, precision = -1;
  800528:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80052b:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  800530:	eb 8f                	jmp    8004c1 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800532:	41                   	inc    %ecx
			goto reswitch;
  800533:	eb 8c                	jmp    8004c1 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	ff 75 0c             	pushl  0xc(%ebp)
  80053b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800545:	ff 55 08             	call   *0x8(%ebp)
			break;
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	e9 2e ff ff ff       	jmp    80047e <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800550:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  80055a:	85 c0                	test   %eax,%eax
  80055c:	79 02                	jns    800560 <vprintfmt+0xee>
				err = -err;
  80055e:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800560:	83 f8 0e             	cmp    $0xe,%eax
  800563:	7f 0b                	jg     800570 <vprintfmt+0xfe>
  800565:	8b 3c 85 80 27 80 00 	mov    0x802780(,%eax,4),%edi
  80056c:	85 ff                	test   %edi,%edi
  80056e:	75 19                	jne    800589 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  800570:	50                   	push   %eax
  800571:	68 4e 27 80 00       	push   $0x80274e
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	ff 75 08             	pushl  0x8(%ebp)
  80057c:	e8 ed 01 00 00       	call   80076e <printfmt>
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	e9 f5 fe ff ff       	jmp    80047e <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800589:	57                   	push   %edi
  80058a:	68 c1 2a 80 00       	push   $0x802ac1
  80058f:	ff 75 0c             	pushl  0xc(%ebp)
  800592:	ff 75 08             	pushl  0x8(%ebp)
  800595:	e8 d4 01 00 00       	call   80076e <printfmt>
  80059a:	83 c4 10             	add    $0x10,%esp
			break;
  80059d:	e9 dc fe ff ff       	jmp    80047e <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a2:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8005ac:	85 ff                	test   %edi,%edi
  8005ae:	75 05                	jne    8005b5 <vprintfmt+0x143>
				p = "(null)";
  8005b0:	bf 57 27 80 00       	mov    $0x802757,%edi
			if (width > 0 && padc != '-')
  8005b5:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005b9:	7e 3b                	jle    8005f6 <vprintfmt+0x184>
  8005bb:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  8005bf:	74 35                	je     8005f6 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	56                   	push   %esi
  8005c5:	57                   	push   %edi
  8005c6:	e8 56 03 00 00       	call   800921 <strnlen>
  8005cb:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005d5:	7e 1f                	jle    8005f6 <vprintfmt+0x184>
  8005d7:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8005db:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 0c             	pushl  0xc(%ebp)
  8005e4:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8005e7:	ff 55 08             	call   *0x8(%ebp)
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005f0:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005f4:	7f e8                	jg     8005de <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f6:	0f be 17             	movsbl (%edi),%edx
  8005f9:	47                   	inc    %edi
  8005fa:	85 d2                	test   %edx,%edx
  8005fc:	74 44                	je     800642 <vprintfmt+0x1d0>
  8005fe:	85 f6                	test   %esi,%esi
  800600:	78 03                	js     800605 <vprintfmt+0x193>
  800602:	4e                   	dec    %esi
  800603:	78 3d                	js     800642 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800605:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800609:	74 18                	je     800623 <vprintfmt+0x1b1>
  80060b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80060e:	83 f8 5e             	cmp    $0x5e,%eax
  800611:	76 10                	jbe    800623 <vprintfmt+0x1b1>
					putch('?', putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	ff 75 0c             	pushl  0xc(%ebp)
  800619:	6a 3f                	push   $0x3f
  80061b:	ff 55 08             	call   *0x8(%ebp)
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	eb 0d                	jmp    800630 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	ff 75 0c             	pushl  0xc(%ebp)
  800629:	52                   	push   %edx
  80062a:	ff 55 08             	call   *0x8(%ebp)
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800633:	0f be 17             	movsbl (%edi),%edx
  800636:	47                   	inc    %edi
  800637:	85 d2                	test   %edx,%edx
  800639:	74 07                	je     800642 <vprintfmt+0x1d0>
  80063b:	85 f6                	test   %esi,%esi
  80063d:	78 c6                	js     800605 <vprintfmt+0x193>
  80063f:	4e                   	dec    %esi
  800640:	79 c3                	jns    800605 <vprintfmt+0x193>
			for (; width > 0; width--)
  800642:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800646:	0f 8e 32 fe ff ff    	jle    80047e <vprintfmt+0xc>
				putch(' ', putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	ff 75 0c             	pushl  0xc(%ebp)
  800652:	6a 20                	push   $0x20
  800654:	ff 55 08             	call   *0x8(%ebp)
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80065d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800661:	7f e9                	jg     80064c <vprintfmt+0x1da>
			break;
  800663:	e9 16 fe ff ff       	jmp    80047e <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800668:	51                   	push   %ecx
  800669:	8d 45 14             	lea    0x14(%ebp),%eax
  80066c:	50                   	push   %eax
  80066d:	e8 c5 fd ff ff       	call   800437 <getint>
  800672:	89 c6                	mov    %eax,%esi
  800674:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  800676:	83 c4 08             	add    $0x8,%esp
  800679:	85 d2                	test   %edx,%edx
  80067b:	79 15                	jns    800692 <vprintfmt+0x220>
				putch('-', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	6a 2d                	push   $0x2d
  800685:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800688:	f7 de                	neg    %esi
  80068a:	83 d7 00             	adc    $0x0,%edi
  80068d:	f7 df                	neg    %edi
  80068f:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800692:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800697:	eb 75                	jmp    80070e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800699:	51                   	push   %ecx
  80069a:	8d 45 14             	lea    0x14(%ebp),%eax
  80069d:	50                   	push   %eax
  80069e:	e8 51 fd ff ff       	call   8003f4 <getuint>
  8006a3:	89 c6                	mov    %eax,%esi
  8006a5:	89 d7                	mov    %edx,%edi
			base = 10;
  8006a7:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8006ac:	83 c4 08             	add    $0x8,%esp
  8006af:	eb 5d                	jmp    80070e <vprintfmt+0x29c>

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
  8006b1:	51                   	push   %ecx
  8006b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b5:	50                   	push   %eax
  8006b6:	e8 39 fd ff ff       	call   8003f4 <getuint>
  8006bb:	89 c6                	mov    %eax,%esi
  8006bd:	89 d7                	mov    %edx,%edi
			base = 8;
  8006bf:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  8006c4:	83 c4 08             	add    $0x8,%esp
  8006c7:	eb 45                	jmp    80070e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	6a 30                	push   $0x30
  8006d1:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006d4:	83 c4 08             	add    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	6a 78                	push   $0x78
  8006dc:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8006df:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  8006e9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ee:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	eb 16                	jmp    80070e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f8:	51                   	push   %ecx
  8006f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fc:	50                   	push   %eax
  8006fd:	e8 f2 fc ff ff       	call   8003f4 <getuint>
  800702:	89 c6                	mov    %eax,%esi
  800704:	89 d7                	mov    %edx,%edi
			base = 16;
  800706:	ba 10 00 00 00       	mov    $0x10,%edx
  80070b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80070e:	83 ec 04             	sub    $0x4,%esp
  800711:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800715:	50                   	push   %eax
  800716:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800719:	52                   	push   %edx
  80071a:	57                   	push   %edi
  80071b:	56                   	push   %esi
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	ff 75 08             	pushl  0x8(%ebp)
  800722:	e8 2d fc ff ff       	call   800354 <printnum>
			break;
  800727:	83 c4 20             	add    $0x20,%esp
  80072a:	e9 4f fd ff ff       	jmp    80047e <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	52                   	push   %edx
  800736:	ff 55 08             	call   *0x8(%ebp)
			break;
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	e9 3d fd ff ff       	jmp    80047e <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	6a 25                	push   $0x25
  800749:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80074c:	4b                   	dec    %ebx
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800754:	0f 84 24 fd ff ff    	je     80047e <vprintfmt+0xc>
  80075a:	4b                   	dec    %ebx
  80075b:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80075f:	75 f9                	jne    80075a <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  800761:	e9 18 fd ff ff       	jmp    80047e <vprintfmt+0xc>
		}
	}
}
  800766:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800769:	5b                   	pop    %ebx
  80076a:	5e                   	pop    %esi
  80076b:	5f                   	pop    %edi
  80076c:	c9                   	leave  
  80076d:	c3                   	ret    

0080076e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800774:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800777:	50                   	push   %eax
  800778:	ff 75 10             	pushl  0x10(%ebp)
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	ff 75 08             	pushl  0x8(%ebp)
  800781:	e8 ec fc ff ff       	call   800472 <vprintfmt>
	va_end(ap);
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80078e:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800791:	8b 0a                	mov    (%edx),%ecx
  800793:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800796:	73 07                	jae    80079f <sprintputch+0x17>
		*b->buf++ = ch;
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	88 01                	mov    %al,(%ecx)
  80079d:	ff 02                	incl   (%edx)
}
  80079f:	c9                   	leave  
  8007a0:	c3                   	ret    

008007a1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 18             	sub    $0x18,%esp
  8007a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8007aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ad:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8007b0:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  8007b4:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8007b7:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  8007be:	85 d2                	test   %edx,%edx
  8007c0:	74 04                	je     8007c6 <vsnprintf+0x25>
  8007c2:	85 c9                	test   %ecx,%ecx
  8007c4:	7f 07                	jg     8007cd <vsnprintf+0x2c>
		return -E_INVAL;
  8007c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007cb:	eb 1d                	jmp    8007ea <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	ff 75 14             	pushl  0x14(%ebp)
  8007d0:	ff 75 10             	pushl  0x10(%ebp)
  8007d3:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  8007d6:	50                   	push   %eax
  8007d7:	68 88 07 80 00       	push   $0x800788
  8007dc:	e8 91 fc ff ff       	call   800472 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e1:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  8007e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e7:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  8007ea:	c9                   	leave  
  8007eb:	c3                   	ret    

008007ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f5:	50                   	push   %eax
  8007f6:	ff 75 10             	pushl  0x10(%ebp)
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	ff 75 08             	pushl  0x8(%ebp)
  8007ff:	e8 9d ff ff ff       	call   8007a1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800804:	c9                   	leave  
  800805:	c3                   	ret    
	...

00800808 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	56                   	push   %esi
  80080c:	53                   	push   %ebx
  80080d:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800810:	83 ec 0c             	sub    $0xc,%esp
  800813:	56                   	push   %esi
  800814:	e8 ef 00 00 00       	call   800908 <strlen>
  char letter;
  int hexnum = 0;
  800819:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80081e:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	89 c2                	mov    %eax,%edx
  800828:	4a                   	dec    %edx
  800829:	0f 88 d0 00 00 00    	js     8008ff <strtoint+0xf7>
    letter = string[cidx];
  80082f:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  800832:	85 d2                	test   %edx,%edx
  800834:	75 12                	jne    800848 <strtoint+0x40>
      if (letter != '0') {
  800836:	3c 30                	cmp    $0x30,%al
  800838:	0f 84 ba 00 00 00    	je     8008f8 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80083e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800843:	e9 b9 00 00 00       	jmp    800901 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800848:	83 fa 01             	cmp    $0x1,%edx
  80084b:	75 12                	jne    80085f <strtoint+0x57>
      if (letter != 'x') {
  80084d:	3c 78                	cmp    $0x78,%al
  80084f:	0f 84 a3 00 00 00    	je     8008f8 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80085a:	e9 a2 00 00 00       	jmp    800901 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80085f:	0f be c0             	movsbl %al,%eax
  800862:	83 e8 30             	sub    $0x30,%eax
  800865:	83 f8 36             	cmp    $0x36,%eax
  800868:	0f 87 80 00 00 00    	ja     8008ee <strtoint+0xe6>
  80086e:	ff 24 85 14 29 80 00 	jmp    *0x802914(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  800875:	01 cb                	add    %ecx,%ebx
          break;
  800877:	eb 7c                	jmp    8008f5 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800879:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  80087c:	eb 77                	jmp    8008f5 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  80087e:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800881:	01 c3                	add    %eax,%ebx
          break;
  800883:	eb 70                	jmp    8008f5 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800885:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800888:	eb 6b                	jmp    8008f5 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  80088a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  80088d:	01 c3                	add    %eax,%ebx
          break;
  80088f:	eb 64                	jmp    8008f5 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800891:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800894:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800897:	eb 5c                	jmp    8008f5 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800899:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8008a0:	29 c8                	sub    %ecx,%eax
  8008a2:	01 c3                	add    %eax,%ebx
          break;
  8008a4:	eb 4f                	jmp    8008f5 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8008a6:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8008a9:	eb 4a                	jmp    8008f5 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8008ab:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8008ae:	01 c3                	add    %eax,%ebx
          break;
  8008b0:	eb 43                	jmp    8008f5 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8008b2:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8008b5:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8008b8:	eb 3b                	jmp    8008f5 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8008ba:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8008bd:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8008c0:	01 c3                	add    %eax,%ebx
          break;
  8008c2:	eb 31                	jmp    8008f5 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8008c4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008c7:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8008ca:	eb 29                	jmp    8008f5 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8008cc:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008cf:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  8008d2:	01 c3                	add    %eax,%ebx
          break;
  8008d4:	eb 1f                	jmp    8008f5 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  8008d6:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8008dd:	29 c8                	sub    %ecx,%eax
  8008df:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8008e2:	eb 11                	jmp    8008f5 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8008e4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008e7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008ea:	01 c3                	add    %eax,%ebx
          break;
  8008ec:	eb 07                	jmp    8008f5 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8008ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8008f3:	eb 0c                	jmp    800901 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  8008f5:	c1 e1 04             	shl    $0x4,%ecx
  8008f8:	4a                   	dec    %edx
  8008f9:	0f 89 30 ff ff ff    	jns    80082f <strtoint+0x27>
    }
  }

  return hexnum;
  8008ff:	89 d8                	mov    %ebx,%eax
}
  800901:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <strlen>:





int
strlen(const char *s)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
  800913:	80 3a 00             	cmpb   $0x0,(%edx)
  800916:	74 07                	je     80091f <strlen+0x17>
		n++;
  800918:	40                   	inc    %eax
  800919:	42                   	inc    %edx
  80091a:	80 3a 00             	cmpb   $0x0,(%edx)
  80091d:	75 f9                	jne    800918 <strlen+0x10>
	return n;
}
  80091f:	c9                   	leave  
  800920:	c3                   	ret    

00800921 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092a:	b8 00 00 00 00       	mov    $0x0,%eax
  80092f:	85 d2                	test   %edx,%edx
  800931:	74 0f                	je     800942 <strnlen+0x21>
  800933:	80 39 00             	cmpb   $0x0,(%ecx)
  800936:	74 0a                	je     800942 <strnlen+0x21>
		n++;
  800938:	40                   	inc    %eax
  800939:	41                   	inc    %ecx
  80093a:	4a                   	dec    %edx
  80093b:	74 05                	je     800942 <strnlen+0x21>
  80093d:	80 39 00             	cmpb   $0x0,(%ecx)
  800940:	75 f6                	jne    800938 <strnlen+0x17>
	return n;
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	53                   	push   %ebx
  800948:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80094e:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800950:	8a 02                	mov    (%edx),%al
  800952:	42                   	inc    %edx
  800953:	88 01                	mov    %al,(%ecx)
  800955:	41                   	inc    %ecx
  800956:	84 c0                	test   %al,%al
  800958:	75 f6                	jne    800950 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80095a:	89 d8                	mov    %ebx,%eax
  80095c:	5b                   	pop    %ebx
  80095d:	c9                   	leave  
  80095e:	c3                   	ret    

0080095f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	57                   	push   %edi
  800963:	56                   	push   %esi
  800964:	53                   	push   %ebx
  800965:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096b:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  80096e:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800970:	bb 00 00 00 00       	mov    $0x0,%ebx
  800975:	39 f3                	cmp    %esi,%ebx
  800977:	73 10                	jae    800989 <strncpy+0x2a>
		*dst++ = *src;
  800979:	8a 02                	mov    (%edx),%al
  80097b:	88 01                	mov    %al,(%ecx)
  80097d:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80097e:	80 3a 01             	cmpb   $0x1,(%edx)
  800981:	83 da ff             	sbb    $0xffffffff,%edx
  800984:	43                   	inc    %ebx
  800985:	39 f3                	cmp    %esi,%ebx
  800987:	72 f0                	jb     800979 <strncpy+0x1a>
	}
	return ret;
}
  800989:	89 f8                	mov    %edi,%eax
  80098b:	5b                   	pop    %ebx
  80098c:	5e                   	pop    %esi
  80098d:	5f                   	pop    %edi
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800998:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099b:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80099e:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8009a0:	85 d2                	test   %edx,%edx
  8009a2:	74 19                	je     8009bd <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009a4:	4a                   	dec    %edx
  8009a5:	74 13                	je     8009ba <strlcpy+0x2a>
  8009a7:	80 39 00             	cmpb   $0x0,(%ecx)
  8009aa:	74 0e                	je     8009ba <strlcpy+0x2a>
  8009ac:	8a 01                	mov    (%ecx),%al
  8009ae:	41                   	inc    %ecx
  8009af:	88 03                	mov    %al,(%ebx)
  8009b1:	43                   	inc    %ebx
  8009b2:	4a                   	dec    %edx
  8009b3:	74 05                	je     8009ba <strlcpy+0x2a>
  8009b5:	80 39 00             	cmpb   $0x0,(%ecx)
  8009b8:	75 f2                	jne    8009ac <strlcpy+0x1c>
		*dst = '\0';
  8009ba:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8009bd:	89 d8                	mov    %ebx,%eax
  8009bf:	29 f0                	sub    %esi,%eax
}
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	c9                   	leave  
  8009c4:	c3                   	ret    

008009c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  8009ce:	80 3a 00             	cmpb   $0x0,(%edx)
  8009d1:	74 13                	je     8009e6 <strcmp+0x21>
  8009d3:	8a 02                	mov    (%edx),%al
  8009d5:	3a 01                	cmp    (%ecx),%al
  8009d7:	75 0d                	jne    8009e6 <strcmp+0x21>
  8009d9:	42                   	inc    %edx
  8009da:	41                   	inc    %ecx
  8009db:	80 3a 00             	cmpb   $0x0,(%edx)
  8009de:	74 06                	je     8009e6 <strcmp+0x21>
  8009e0:	8a 02                	mov    (%edx),%al
  8009e2:	3a 01                	cmp    (%ecx),%al
  8009e4:	74 f3                	je     8009d9 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e6:	0f b6 02             	movzbl (%edx),%eax
  8009e9:	0f b6 11             	movzbl (%ecx),%edx
  8009ec:	29 d0                	sub    %edx,%eax
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	53                   	push   %ebx
  8009f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  8009fd:	85 c9                	test   %ecx,%ecx
  8009ff:	74 1f                	je     800a20 <strncmp+0x30>
  800a01:	80 3a 00             	cmpb   $0x0,(%edx)
  800a04:	74 16                	je     800a1c <strncmp+0x2c>
  800a06:	8a 02                	mov    (%edx),%al
  800a08:	3a 03                	cmp    (%ebx),%al
  800a0a:	75 10                	jne    800a1c <strncmp+0x2c>
  800a0c:	42                   	inc    %edx
  800a0d:	43                   	inc    %ebx
  800a0e:	49                   	dec    %ecx
  800a0f:	74 0f                	je     800a20 <strncmp+0x30>
  800a11:	80 3a 00             	cmpb   $0x0,(%edx)
  800a14:	74 06                	je     800a1c <strncmp+0x2c>
  800a16:	8a 02                	mov    (%edx),%al
  800a18:	3a 03                	cmp    (%ebx),%al
  800a1a:	74 f0                	je     800a0c <strncmp+0x1c>
	if (n == 0)
  800a1c:	85 c9                	test   %ecx,%ecx
  800a1e:	75 07                	jne    800a27 <strncmp+0x37>
		return 0;
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	eb 0a                	jmp    800a31 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a27:	0f b6 12             	movzbl (%edx),%edx
  800a2a:	0f b6 03             	movzbl (%ebx),%eax
  800a2d:	29 c2                	sub    %eax,%edx
  800a2f:	89 d0                	mov    %edx,%eax
}
  800a31:	5b                   	pop    %ebx
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800a3d:	80 38 00             	cmpb   $0x0,(%eax)
  800a40:	74 0a                	je     800a4c <strchr+0x18>
		if (*s == c)
  800a42:	38 10                	cmp    %dl,(%eax)
  800a44:	74 0b                	je     800a51 <strchr+0x1d>
  800a46:	40                   	inc    %eax
  800a47:	80 38 00             	cmpb   $0x0,(%eax)
  800a4a:	75 f6                	jne    800a42 <strchr+0xe>
			return (char *) s;
	return 0;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800a5c:	80 38 00             	cmpb   $0x0,(%eax)
  800a5f:	74 0a                	je     800a6b <strfind+0x18>
		if (*s == c)
  800a61:	38 10                	cmp    %dl,(%eax)
  800a63:	74 06                	je     800a6b <strfind+0x18>
  800a65:	40                   	inc    %eax
  800a66:	80 38 00             	cmpb   $0x0,(%eax)
  800a69:	75 f6                	jne    800a61 <strfind+0xe>
			break;
	return (char *) s;
}
  800a6b:	c9                   	leave  
  800a6c:	c3                   	ret    

00800a6d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	57                   	push   %edi
  800a71:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800a77:	89 f8                	mov    %edi,%eax
  800a79:	85 c9                	test   %ecx,%ecx
  800a7b:	74 40                	je     800abd <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a83:	75 30                	jne    800ab5 <memset+0x48>
  800a85:	f6 c1 03             	test   $0x3,%cl
  800a88:	75 2b                	jne    800ab5 <memset+0x48>
		c &= 0xFF;
  800a8a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	c1 e0 18             	shl    $0x18,%eax
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	c1 e2 10             	shl    $0x10,%edx
  800a9d:	09 d0                	or     %edx,%eax
  800a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa2:	c1 e2 08             	shl    $0x8,%edx
  800aa5:	09 d0                	or     %edx,%eax
  800aa7:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800aaa:	c1 e9 02             	shr    $0x2,%ecx
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	fc                   	cld    
  800ab1:	f3 ab                	repz stos %eax,%es:(%edi)
  800ab3:	eb 06                	jmp    800abb <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	fc                   	cld    
  800ab9:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800abb:	89 f8                	mov    %edi,%eax
}
  800abd:	5f                   	pop    %edi
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800acb:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800ace:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800ad0:	39 c6                	cmp    %eax,%esi
  800ad2:	73 33                	jae    800b07 <memmove+0x47>
  800ad4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad7:	39 c2                	cmp    %eax,%edx
  800ad9:	76 2c                	jbe    800b07 <memmove+0x47>
		s += n;
  800adb:	89 d6                	mov    %edx,%esi
		d += n;
  800add:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	f6 c2 03             	test   $0x3,%dl
  800ae3:	75 1b                	jne    800b00 <memmove+0x40>
  800ae5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aeb:	75 13                	jne    800b00 <memmove+0x40>
  800aed:	f6 c1 03             	test   $0x3,%cl
  800af0:	75 0e                	jne    800b00 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800af2:	83 ef 04             	sub    $0x4,%edi
  800af5:	83 ee 04             	sub    $0x4,%esi
  800af8:	c1 e9 02             	shr    $0x2,%ecx
  800afb:	fd                   	std    
  800afc:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800afe:	eb 27                	jmp    800b27 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b00:	4f                   	dec    %edi
  800b01:	4e                   	dec    %esi
  800b02:	fd                   	std    
  800b03:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800b05:	eb 20                	jmp    800b27 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b07:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0d:	75 15                	jne    800b24 <memmove+0x64>
  800b0f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b15:	75 0d                	jne    800b24 <memmove+0x64>
  800b17:	f6 c1 03             	test   $0x3,%cl
  800b1a:	75 08                	jne    800b24 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800b1c:	c1 e9 02             	shr    $0x2,%ecx
  800b1f:	fc                   	cld    
  800b20:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800b22:	eb 03                	jmp    800b27 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b24:	fc                   	cld    
  800b25:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b27:	5e                   	pop    %esi
  800b28:	5f                   	pop    %edi
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <memcpy>:

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
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b2e:	ff 75 10             	pushl  0x10(%ebp)
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	ff 75 08             	pushl  0x8(%ebp)
  800b37:	e8 84 ff ff ff       	call   800ac0 <memmove>
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800b42:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800b45:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b48:	8b 55 10             	mov    0x10(%ebp),%edx
  800b4b:	4a                   	dec    %edx
  800b4c:	83 fa ff             	cmp    $0xffffffff,%edx
  800b4f:	74 1a                	je     800b6b <memcmp+0x2d>
  800b51:	8a 01                	mov    (%ecx),%al
  800b53:	3a 03                	cmp    (%ebx),%al
  800b55:	74 0c                	je     800b63 <memcmp+0x25>
  800b57:	0f b6 d0             	movzbl %al,%edx
  800b5a:	0f b6 03             	movzbl (%ebx),%eax
  800b5d:	29 c2                	sub    %eax,%edx
  800b5f:	89 d0                	mov    %edx,%eax
  800b61:	eb 0d                	jmp    800b70 <memcmp+0x32>
  800b63:	41                   	inc    %ecx
  800b64:	43                   	inc    %ebx
  800b65:	4a                   	dec    %edx
  800b66:	83 fa ff             	cmp    $0xffffffff,%edx
  800b69:	75 e6                	jne    800b51 <memcmp+0x13>
	}

	return 0;
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b70:	5b                   	pop    %ebx
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7c:	89 c2                	mov    %eax,%edx
  800b7e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b81:	39 d0                	cmp    %edx,%eax
  800b83:	73 09                	jae    800b8e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b85:	38 08                	cmp    %cl,(%eax)
  800b87:	74 05                	je     800b8e <memfind+0x1b>
  800b89:	40                   	inc    %eax
  800b8a:	39 d0                	cmp    %edx,%eax
  800b8c:	72 f7                	jb     800b85 <memfind+0x12>
			break;
	return (void *) s;
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 55 08             	mov    0x8(%ebp),%edx
  800b99:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800b9f:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800ba4:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800ba9:	80 3a 20             	cmpb   $0x20,(%edx)
  800bac:	74 05                	je     800bb3 <strtol+0x23>
  800bae:	80 3a 09             	cmpb   $0x9,(%edx)
  800bb1:	75 0b                	jne    800bbe <strtol+0x2e>
  800bb3:	42                   	inc    %edx
  800bb4:	80 3a 20             	cmpb   $0x20,(%edx)
  800bb7:	74 fa                	je     800bb3 <strtol+0x23>
  800bb9:	80 3a 09             	cmpb   $0x9,(%edx)
  800bbc:	74 f5                	je     800bb3 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800bbe:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800bc1:	75 03                	jne    800bc6 <strtol+0x36>
		s++;
  800bc3:	42                   	inc    %edx
  800bc4:	eb 0b                	jmp    800bd1 <strtol+0x41>
	else if (*s == '-')
  800bc6:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800bc9:	75 06                	jne    800bd1 <strtol+0x41>
		s++, neg = 1;
  800bcb:	42                   	inc    %edx
  800bcc:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd1:	85 c9                	test   %ecx,%ecx
  800bd3:	74 05                	je     800bda <strtol+0x4a>
  800bd5:	83 f9 10             	cmp    $0x10,%ecx
  800bd8:	75 15                	jne    800bef <strtol+0x5f>
  800bda:	80 3a 30             	cmpb   $0x30,(%edx)
  800bdd:	75 10                	jne    800bef <strtol+0x5f>
  800bdf:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800be3:	75 0a                	jne    800bef <strtol+0x5f>
		s += 2, base = 16;
  800be5:	83 c2 02             	add    $0x2,%edx
  800be8:	b9 10 00 00 00       	mov    $0x10,%ecx
  800bed:	eb 14                	jmp    800c03 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800bef:	85 c9                	test   %ecx,%ecx
  800bf1:	75 10                	jne    800c03 <strtol+0x73>
  800bf3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bf6:	75 05                	jne    800bfd <strtol+0x6d>
		s++, base = 8;
  800bf8:	42                   	inc    %edx
  800bf9:	b1 08                	mov    $0x8,%cl
  800bfb:	eb 06                	jmp    800c03 <strtol+0x73>
	else if (base == 0)
  800bfd:	85 c9                	test   %ecx,%ecx
  800bff:	75 02                	jne    800c03 <strtol+0x73>
		base = 10;
  800c01:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c03:	8a 02                	mov    (%edx),%al
  800c05:	83 e8 30             	sub    $0x30,%eax
  800c08:	3c 09                	cmp    $0x9,%al
  800c0a:	77 08                	ja     800c14 <strtol+0x84>
			dig = *s - '0';
  800c0c:	0f be 02             	movsbl (%edx),%eax
  800c0f:	83 e8 30             	sub    $0x30,%eax
  800c12:	eb 20                	jmp    800c34 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800c14:	8a 02                	mov    (%edx),%al
  800c16:	83 e8 61             	sub    $0x61,%eax
  800c19:	3c 19                	cmp    $0x19,%al
  800c1b:	77 08                	ja     800c25 <strtol+0x95>
			dig = *s - 'a' + 10;
  800c1d:	0f be 02             	movsbl (%edx),%eax
  800c20:	83 e8 57             	sub    $0x57,%eax
  800c23:	eb 0f                	jmp    800c34 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800c25:	8a 02                	mov    (%edx),%al
  800c27:	83 e8 41             	sub    $0x41,%eax
  800c2a:	3c 19                	cmp    $0x19,%al
  800c2c:	77 12                	ja     800c40 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800c2e:	0f be 02             	movsbl (%edx),%eax
  800c31:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800c34:	39 c8                	cmp    %ecx,%eax
  800c36:	7d 08                	jge    800c40 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800c38:	42                   	inc    %edx
  800c39:	0f af d9             	imul   %ecx,%ebx
  800c3c:	01 c3                	add    %eax,%ebx
  800c3e:	eb c3                	jmp    800c03 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c40:	85 f6                	test   %esi,%esi
  800c42:	74 02                	je     800c46 <strtol+0xb6>
		*endptr = (char *) s;
  800c44:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c46:	89 d8                	mov    %ebx,%eax
  800c48:	85 ff                	test   %edi,%edi
  800c4a:	74 02                	je     800c4e <strtol+0xbe>
  800c4c:	f7 d8                	neg    %eax
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    
	...

00800c54 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c63:	bf 00 00 00 00       	mov    $0x0,%edi
  800c68:	89 f8                	mov    %edi,%eax
  800c6a:	89 fb                	mov    %edi,%ebx
  800c6c:	89 fe                	mov    %edi,%esi
  800c6e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c70:	83 c4 04             	add    $0x4,%esp
  800c73:	5b                   	pop    %ebx
  800c74:	5e                   	pop    %esi
  800c75:	5f                   	pop    %edi
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
  800c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c83:	bf 00 00 00 00       	mov    $0x0,%edi
  800c88:	89 fa                	mov    %edi,%edx
  800c8a:	89 f9                	mov    %edi,%ecx
  800c8c:	89 fb                	mov    %edi,%ebx
  800c8e:	89 fe                	mov    %edi,%esi
  800c90:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca8:	bf 00 00 00 00       	mov    $0x0,%edi
  800cad:	89 f9                	mov    %edi,%ecx
  800caf:	89 fb                	mov    %edi,%ebx
  800cb1:	89 fe                	mov    %edi,%esi
  800cb3:	cd 30                	int    $0x30
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	7e 17                	jle    800cd0 <sys_env_destroy+0x39>
  800cb9:	83 ec 0c             	sub    $0xc,%esp
  800cbc:	50                   	push   %eax
  800cbd:	6a 03                	push   $0x3
  800cbf:	68 f0 29 80 00       	push   $0x8029f0
  800cc4:	6a 23                	push   $0x23
  800cc6:	68 0d 2a 80 00       	push   $0x802a0d
  800ccb:	e8 80 f5 ff ff       	call   800250 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce8:	89 fa                	mov    %edi,%edx
  800cea:	89 f9                	mov    %edi,%ecx
  800cec:	89 fb                	mov    %edi,%ebx
  800cee:	89 fe                	mov    %edi,%esi
  800cf0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <sys_yield>:

void
sys_yield(void)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d02:	bf 00 00 00 00       	mov    $0x0,%edi
  800d07:	89 fa                	mov    %edi,%edx
  800d09:	89 f9                	mov    %edi,%ecx
  800d0b:	89 fb                	mov    %edi,%ebx
  800d0d:	89 fe                	mov    %edi,%esi
  800d0f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d28:	b8 04 00 00 00       	mov    $0x4,%eax
  800d2d:	bf 00 00 00 00       	mov    $0x0,%edi
  800d32:	89 fe                	mov    %edi,%esi
  800d34:	cd 30                	int    $0x30
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7e 17                	jle    800d51 <sys_page_alloc+0x3b>
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 04                	push   $0x4
  800d40:	68 f0 29 80 00       	push   $0x8029f0
  800d45:	6a 23                	push   $0x23
  800d47:	68 0d 2a 80 00       	push   $0x802a0d
  800d4c:	e8 ff f4 ff ff       	call   800250 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d51:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d71:	b8 05 00 00 00       	mov    $0x5,%eax
  800d76:	cd 30                	int    $0x30
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7e 17                	jle    800d93 <sys_page_map+0x3a>
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 05                	push   $0x5
  800d82:	68 f0 29 80 00       	push   $0x8029f0
  800d87:	6a 23                	push   $0x23
  800d89:	68 0d 2a 80 00       	push   $0x802a0d
  800d8e:	e8 bd f4 ff ff       	call   800250 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d93:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
  800da1:	83 ec 0c             	sub    $0xc,%esp
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	b8 06 00 00 00       	mov    $0x6,%eax
  800daf:	bf 00 00 00 00       	mov    $0x0,%edi
  800db4:	89 fb                	mov    %edi,%ebx
  800db6:	89 fe                	mov    %edi,%esi
  800db8:	cd 30                	int    $0x30
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	7e 17                	jle    800dd5 <sys_page_unmap+0x3a>
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 06                	push   $0x6
  800dc4:	68 f0 29 80 00       	push   $0x8029f0
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 0d 2a 80 00       	push   $0x802a0d
  800dd0:	e8 7b f4 ff ff       	call   800250 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	83 ec 0c             	sub    $0xc,%esp
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	b8 08 00 00 00       	mov    $0x8,%eax
  800df1:	bf 00 00 00 00       	mov    $0x0,%edi
  800df6:	89 fb                	mov    %edi,%ebx
  800df8:	89 fe                	mov    %edi,%esi
  800dfa:	cd 30                	int    $0x30
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7e 17                	jle    800e17 <sys_env_set_status+0x3a>
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	50                   	push   %eax
  800e04:	6a 08                	push   $0x8
  800e06:	68 f0 29 80 00       	push   $0x8029f0
  800e0b:	6a 23                	push   $0x23
  800e0d:	68 0d 2a 80 00       	push   $0x802a0d
  800e12:	e8 39 f4 ff ff       	call   800250 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e17:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e33:	bf 00 00 00 00       	mov    $0x0,%edi
  800e38:	89 fb                	mov    %edi,%ebx
  800e3a:	89 fe                	mov    %edi,%esi
  800e3c:	cd 30                	int    $0x30
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7e 17                	jle    800e59 <sys_env_set_trapframe+0x3a>
  800e42:	83 ec 0c             	sub    $0xc,%esp
  800e45:	50                   	push   %eax
  800e46:	6a 09                	push   $0x9
  800e48:	68 f0 29 80 00       	push   $0x8029f0
  800e4d:	6a 23                	push   $0x23
  800e4f:	68 0d 2a 80 00       	push   $0x802a0d
  800e54:	e8 f7 f3 ff ff       	call   800250 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e75:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7a:	89 fb                	mov    %edi,%ebx
  800e7c:	89 fe                	mov    %edi,%esi
  800e7e:	cd 30                	int    $0x30
  800e80:	85 c0                	test   %eax,%eax
  800e82:	7e 17                	jle    800e9b <sys_env_set_pgfault_upcall+0x3a>
  800e84:	83 ec 0c             	sub    $0xc,%esp
  800e87:	50                   	push   %eax
  800e88:	6a 0a                	push   $0xa
  800e8a:	68 f0 29 80 00       	push   $0x8029f0
  800e8f:	6a 23                	push   $0x23
  800e91:	68 0d 2a 80 00       	push   $0x802a0d
  800e96:	e8 b5 f3 ff ff       	call   800250 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eba:	be 00 00 00 00       	mov    $0x0,%esi
  800ebf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec1:	5b                   	pop    %ebx
  800ec2:	5e                   	pop    %esi
  800ec3:	5f                   	pop    %edi
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	57                   	push   %edi
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed7:	bf 00 00 00 00       	mov    $0x0,%edi
  800edc:	89 f9                	mov    %edi,%ecx
  800ede:	89 fb                	mov    %edi,%ebx
  800ee0:	89 fe                	mov    %edi,%esi
  800ee2:	cd 30                	int    $0x30
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	7e 17                	jle    800eff <sys_ipc_recv+0x39>
  800ee8:	83 ec 0c             	sub    $0xc,%esp
  800eeb:	50                   	push   %eax
  800eec:	6a 0d                	push   $0xd
  800eee:	68 f0 29 80 00       	push   $0x8029f0
  800ef3:	6a 23                	push   $0x23
  800ef5:	68 0d 2a 80 00       	push   $0x802a0d
  800efa:	e8 51 f3 ff ff       	call   800250 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eff:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	b8 10 00 00 00       	mov    $0x10,%eax
  800f1b:	bf 00 00 00 00       	mov    $0x0,%edi
  800f20:	89 fb                	mov    %edi,%ebx
  800f22:	89 fe                	mov    %edi,%esi
  800f24:	cd 30                	int    $0x30
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7e 17                	jle    800f41 <sys_transmit_packet+0x3a>
  800f2a:	83 ec 0c             	sub    $0xc,%esp
  800f2d:	50                   	push   %eax
  800f2e:	6a 10                	push   $0x10
  800f30:	68 f0 29 80 00       	push   $0x8029f0
  800f35:	6a 23                	push   $0x23
  800f37:	68 0d 2a 80 00       	push   $0x802a0d
  800f3c:	e8 0f f3 ff ff       	call   800250 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800f41:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	c9                   	leave  
  800f48:	c3                   	ret    

00800f49 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	b8 11 00 00 00       	mov    $0x11,%eax
  800f5d:	bf 00 00 00 00       	mov    $0x0,%edi
  800f62:	89 fb                	mov    %edi,%ebx
  800f64:	89 fe                	mov    %edi,%esi
  800f66:	cd 30                	int    $0x30
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	7e 17                	jle    800f83 <sys_receive_packet+0x3a>
  800f6c:	83 ec 0c             	sub    $0xc,%esp
  800f6f:	50                   	push   %eax
  800f70:	6a 11                	push   $0x11
  800f72:	68 f0 29 80 00       	push   $0x8029f0
  800f77:	6a 23                	push   $0x23
  800f79:	68 0d 2a 80 00       	push   $0x802a0d
  800f7e:	e8 cd f2 ff ff       	call   800250 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800f83:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
  800f91:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f96:	bf 00 00 00 00       	mov    $0x0,%edi
  800f9b:	89 fa                	mov    %edi,%edx
  800f9d:	89 f9                	mov    %edi,%ecx
  800f9f:	89 fb                	mov    %edi,%ebx
  800fa1:	89 fe                	mov    %edi,%esi
  800fa3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	57                   	push   %edi
  800fae:	56                   	push   %esi
  800faf:	53                   	push   %ebx
  800fb0:	83 ec 0c             	sub    $0xc,%esp
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fbb:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc0:	89 f9                	mov    %edi,%ecx
  800fc2:	89 fb                	mov    %edi,%ebx
  800fc4:	89 fe                	mov    %edi,%esi
  800fc6:	cd 30                	int    $0x30
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	7e 17                	jle    800fe3 <sys_map_receive_buffers+0x39>
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	50                   	push   %eax
  800fd0:	6a 0e                	push   $0xe
  800fd2:	68 f0 29 80 00       	push   $0x8029f0
  800fd7:	6a 23                	push   $0x23
  800fd9:	68 0d 2a 80 00       	push   $0x802a0d
  800fde:	e8 6d f2 ff ff       	call   800250 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800fe3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 0c             	sub    $0xc,%esp
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	b8 12 00 00 00       	mov    $0x12,%eax
  800ffc:	bf 00 00 00 00       	mov    $0x0,%edi
  801001:	89 f9                	mov    %edi,%ecx
  801003:	89 fb                	mov    %edi,%ebx
  801005:	89 fe                	mov    %edi,%esi
  801007:	cd 30                	int    $0x30
  801009:	85 c0                	test   %eax,%eax
  80100b:	7e 17                	jle    801024 <sys_receive_packet_zerocopy+0x39>
  80100d:	83 ec 0c             	sub    $0xc,%esp
  801010:	50                   	push   %eax
  801011:	6a 12                	push   $0x12
  801013:	68 f0 29 80 00       	push   $0x8029f0
  801018:	6a 23                	push   $0x23
  80101a:	68 0d 2a 80 00       	push   $0x802a0d
  80101f:	e8 2c f2 ff ff       	call   800250 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  801024:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	b8 13 00 00 00       	mov    $0x13,%eax
  801040:	bf 00 00 00 00       	mov    $0x0,%edi
  801045:	89 fb                	mov    %edi,%ebx
  801047:	89 fe                	mov    %edi,%esi
  801049:	cd 30                	int    $0x30
  80104b:	85 c0                	test   %eax,%eax
  80104d:	7e 17                	jle    801066 <sys_env_set_priority+0x3a>
  80104f:	83 ec 0c             	sub    $0xc,%esp
  801052:	50                   	push   %eax
  801053:	6a 13                	push   $0x13
  801055:	68 f0 29 80 00       	push   $0x8029f0
  80105a:	6a 23                	push   $0x23
  80105c:	68 0d 2a 80 00       	push   $0x802a0d
  801061:	e8 ea f1 ff ff       	call   800250 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  801066:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    
	...

00801070 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801076:	ff 75 08             	pushl  0x8(%ebp)
  801079:	e8 0a 00 00 00       	call   801088 <fd2num>
  80107e:	c1 e0 16             	shl    $0x16,%eax
  801081:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	05 00 00 40 30       	add    $0x30400000,%eax
  801093:	c1 e8 0c             	shr    $0xc,%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <fd_alloc>:

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
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	57                   	push   %edi
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
  80109e:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a6:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  8010ab:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 e0 0c             	shl    $0xc,%eax
  8010b5:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8010bb:	89 d0                	mov    %edx,%eax
  8010bd:	c1 e8 16             	shr    $0x16,%eax
  8010c0:	8b 04 86             	mov    (%esi,%eax,4),%eax
  8010c3:	a8 01                	test   $0x1,%al
  8010c5:	74 0c                	je     8010d3 <fd_alloc+0x3b>
  8010c7:	89 d0                	mov    %edx,%eax
  8010c9:	c1 e8 0c             	shr    $0xc,%eax
  8010cc:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  8010cf:	a8 01                	test   $0x1,%al
  8010d1:	75 09                	jne    8010dc <fd_alloc+0x44>
			*fd_store = fd;
  8010d3:	89 17                	mov    %edx,(%edi)
			return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010da:	eb 11                	jmp    8010ed <fd_alloc+0x55>
  8010dc:	41                   	inc    %ecx
  8010dd:	83 f9 1f             	cmp    $0x1f,%ecx
  8010e0:	7e ce                	jle    8010b0 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  8010e2:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8010e8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010ed:	5b                   	pop    %ebx
  8010ee:	5e                   	pop    %esi
  8010ef:	5f                   	pop    %edi
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8010f8:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010fd:	83 f8 1f             	cmp    $0x1f,%eax
  801100:	77 3a                	ja     80113c <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  801102:	c1 e0 0c             	shl    $0xc,%eax
  801105:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  80110b:	89 d0                	mov    %edx,%eax
  80110d:	c1 e8 16             	shr    $0x16,%eax
  801110:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 10                	je     80112b <fd_lookup+0x39>
  80111b:	89 d0                	mov    %edx,%eax
  80111d:	c1 e8 0c             	shr    $0xc,%eax
  801120:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801127:	a8 01                	test   $0x1,%al
  801129:	75 07                	jne    801132 <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80112b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801130:	eb 0a                	jmp    80113c <fd_lookup+0x4a>
	}
	*fd_store = fd;
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	89 10                	mov    %edx,(%eax)
	return 0;
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80113c:	89 d0                	mov    %edx,%eax
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <fd_close>:

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
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	56                   	push   %esi
  801144:	53                   	push   %ebx
  801145:	83 ec 10             	sub    $0x10,%esp
  801148:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80114b:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80114e:	50                   	push   %eax
  80114f:	56                   	push   %esi
  801150:	e8 33 ff ff ff       	call   801088 <fd2num>
  801155:	89 04 24             	mov    %eax,(%esp)
  801158:	e8 95 ff ff ff       	call   8010f2 <fd_lookup>
  80115d:	89 c3                	mov    %eax,%ebx
  80115f:	83 c4 08             	add    $0x8,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	78 05                	js     80116b <fd_close+0x2b>
  801166:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801169:	74 0f                	je     80117a <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80116b:	89 d8                	mov    %ebx,%eax
  80116d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801171:	75 3a                	jne    8011ad <fd_close+0x6d>
  801173:	b8 00 00 00 00       	mov    $0x0,%eax
  801178:	eb 33                	jmp    8011ad <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  80117a:	83 ec 08             	sub    $0x8,%esp
  80117d:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801180:	50                   	push   %eax
  801181:	ff 36                	pushl  (%esi)
  801183:	e8 2c 00 00 00       	call   8011b4 <dev_lookup>
  801188:	89 c3                	mov    %eax,%ebx
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	85 c0                	test   %eax,%eax
  80118f:	78 0f                	js     8011a0 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	56                   	push   %esi
  801195:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801198:	ff 50 10             	call   *0x10(%eax)
  80119b:	89 c3                	mov    %eax,%ebx
  80119d:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	56                   	push   %esi
  8011a4:	6a 00                	push   $0x0
  8011a6:	e8 f0 fb ff ff       	call   800d9b <sys_page_unmap>
	return r;
  8011ab:	89 d8                	mov    %ebx,%eax
}
  8011ad:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <dev_lookup>:


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
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	56                   	push   %esi
  8011b8:	53                   	push   %ebx
  8011b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8011bc:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  8011bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c4:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8011cb:	74 1c                	je     8011e9 <dev_lookup+0x35>
  8011cd:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  8011d2:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  8011d5:	39 18                	cmp    %ebx,(%eax)
  8011d7:	75 09                	jne    8011e2 <dev_lookup+0x2e>
			*dev = devtab[i];
  8011d9:	89 06                	mov    %eax,(%esi)
			return 0;
  8011db:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e0:	eb 29                	jmp    80120b <dev_lookup+0x57>
  8011e2:	42                   	inc    %edx
  8011e3:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  8011e7:	75 e9                	jne    8011d2 <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	53                   	push   %ebx
  8011ed:	a1 80 60 80 00       	mov    0x806080,%eax
  8011f2:	8b 40 4c             	mov    0x4c(%eax),%eax
  8011f5:	50                   	push   %eax
  8011f6:	68 1c 2a 80 00       	push   $0x802a1c
  8011fb:	e8 40 f1 ff ff       	call   800340 <cprintf>
	*dev = 0;
  801200:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801206:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80120b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <close>:

int
close(int fdnum)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801218:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80121b:	50                   	push   %eax
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	e8 ce fe ff ff       	call   8010f2 <fd_lookup>
  801224:	83 c4 08             	add    $0x8,%esp
		return r;
  801227:	89 c2                	mov    %eax,%edx
  801229:	85 c0                	test   %eax,%eax
  80122b:	78 0f                	js     80123c <close+0x2a>
	else
		return fd_close(fd, 1);
  80122d:	83 ec 08             	sub    $0x8,%esp
  801230:	6a 01                	push   $0x1
  801232:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801235:	e8 06 ff ff ff       	call   801140 <fd_close>
  80123a:	89 c2                	mov    %eax,%edx
}
  80123c:	89 d0                	mov    %edx,%eax
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <close_all>:

void
close_all(void)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	53                   	push   %ebx
  801244:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801247:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	53                   	push   %ebx
  801250:	e8 bd ff ff ff       	call   801212 <close>
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	43                   	inc    %ebx
  801259:	83 fb 1f             	cmp    $0x1f,%ebx
  80125c:	7e ee                	jle    80124c <close_all+0xc>
}
  80125e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801261:	c9                   	leave  
  801262:	c3                   	ret    

00801263 <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	57                   	push   %edi
  801267:	56                   	push   %esi
  801268:	53                   	push   %ebx
  801269:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80126c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80126f:	50                   	push   %eax
  801270:	ff 75 08             	pushl  0x8(%ebp)
  801273:	e8 7a fe ff ff       	call   8010f2 <fd_lookup>
  801278:	89 c6                	mov    %eax,%esi
  80127a:	83 c4 08             	add    $0x8,%esp
  80127d:	85 f6                	test   %esi,%esi
  80127f:	0f 88 f8 00 00 00    	js     80137d <dup+0x11a>
		return r;
	close(newfdnum);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	e8 82 ff ff ff       	call   801212 <close>

	newfd = INDEX2FD(newfdnum);
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	c1 e0 0c             	shl    $0xc,%eax
  801296:	2d 00 00 40 30       	sub    $0x30400000,%eax
  80129b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  80129e:	83 c4 04             	add    $0x4,%esp
  8012a1:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8012a4:	e8 c7 fd ff ff       	call   801070 <fd2data>
  8012a9:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8012ab:	83 c4 04             	add    $0x4,%esp
  8012ae:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8012b1:	e8 ba fd ff ff       	call   801070 <fd2data>
  8012b6:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8012b9:	89 f8                	mov    %edi,%eax
  8012bb:	c1 e8 16             	shr    $0x16,%eax
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 48                	je     801314 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8012cc:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  8012d1:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  8012d4:	89 d0                	mov    %edx,%eax
  8012d6:	c1 e8 0c             	shr    $0xc,%eax
  8012d9:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  8012e0:	a8 01                	test   $0x1,%al
  8012e2:	74 22                	je     801306 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8012e4:	83 ec 0c             	sub    $0xc,%esp
  8012e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ec:	50                   	push   %eax
  8012ed:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8012f0:	01 d8                	add    %ebx,%eax
  8012f2:	50                   	push   %eax
  8012f3:	6a 00                	push   $0x0
  8012f5:	52                   	push   %edx
  8012f6:	6a 00                	push   $0x0
  8012f8:	e8 5c fa ff ff       	call   800d59 <sys_page_map>
  8012fd:	89 c6                	mov    %eax,%esi
  8012ff:	83 c4 20             	add    $0x20,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	78 3f                	js     801345 <dup+0xe2>
  801306:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80130c:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801312:	7e bd                	jle    8012d1 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801314:	83 ec 0c             	sub    $0xc,%esp
  801317:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80131a:	89 d0                	mov    %edx,%eax
  80131c:	c1 e8 0c             	shr    $0xc,%eax
  80131f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801326:	25 07 0e 00 00       	and    $0xe07,%eax
  80132b:	50                   	push   %eax
  80132c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80132f:	6a 00                	push   $0x0
  801331:	52                   	push   %edx
  801332:	6a 00                	push   $0x0
  801334:	e8 20 fa ff ff       	call   800d59 <sys_page_map>
  801339:	89 c6                	mov    %eax,%esi
  80133b:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	85 f6                	test   %esi,%esi
  801343:	79 38                	jns    80137d <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80134b:	6a 00                	push   $0x0
  80134d:	e8 49 fa ff ff       	call   800d9b <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801352:	bb 00 00 00 00       	mov    $0x0,%ebx
  801357:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801360:	01 d8                	add    %ebx,%eax
  801362:	50                   	push   %eax
  801363:	6a 00                	push   $0x0
  801365:	e8 31 fa ff ff       	call   800d9b <sys_page_unmap>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801373:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801379:	7e df                	jle    80135a <dup+0xf7>
	return r;
  80137b:	89 f0                	mov    %esi,%eax
}
  80137d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801380:	5b                   	pop    %ebx
  801381:	5e                   	pop    %esi
  801382:	5f                   	pop    %edi
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	53                   	push   %ebx
  801389:	83 ec 14             	sub    $0x14,%esp
  80138c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801392:	50                   	push   %eax
  801393:	53                   	push   %ebx
  801394:	e8 59 fd ff ff       	call   8010f2 <fd_lookup>
  801399:	89 c2                	mov    %eax,%edx
  80139b:	83 c4 08             	add    $0x8,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 1a                	js     8013bc <read+0x37>
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8013a8:	50                   	push   %eax
  8013a9:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013ac:	ff 30                	pushl  (%eax)
  8013ae:	e8 01 fe ff ff       	call   8011b4 <dev_lookup>
  8013b3:	89 c2                	mov    %eax,%edx
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	79 04                	jns    8013c0 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8013bc:	89 d0                	mov    %edx,%eax
  8013be:	eb 50                	jmp    801410 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c0:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013c3:	8b 40 08             	mov    0x8(%eax),%eax
  8013c6:	83 e0 03             	and    $0x3,%eax
  8013c9:	83 f8 01             	cmp    $0x1,%eax
  8013cc:	75 1e                	jne    8013ec <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8013ce:	83 ec 04             	sub    $0x4,%esp
  8013d1:	53                   	push   %ebx
  8013d2:	a1 80 60 80 00       	mov    0x806080,%eax
  8013d7:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013da:	50                   	push   %eax
  8013db:	68 5d 2a 80 00       	push   $0x802a5d
  8013e0:	e8 5b ef ff ff       	call   800340 <cprintf>
		return -E_INVAL;
  8013e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ea:	eb 24                	jmp    801410 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8013ec:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013ef:	ff 70 04             	pushl  0x4(%eax)
  8013f2:	ff 75 10             	pushl  0x10(%ebp)
  8013f5:	ff 75 0c             	pushl  0xc(%ebp)
  8013f8:	50                   	push   %eax
  8013f9:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8013fc:	ff 50 08             	call   *0x8(%eax)
  8013ff:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	78 06                	js     80140e <read+0x89>
		fd->fd_offset += r;
  801408:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80140b:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80140e:	89 d0                	mov    %edx,%eax
}
  801410:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	57                   	push   %edi
  801419:	56                   	push   %esi
  80141a:	53                   	push   %ebx
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801421:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801424:	bb 00 00 00 00       	mov    $0x0,%ebx
  801429:	39 f3                	cmp    %esi,%ebx
  80142b:	73 25                	jae    801452 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	89 f0                	mov    %esi,%eax
  801432:	29 d8                	sub    %ebx,%eax
  801434:	50                   	push   %eax
  801435:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801438:	50                   	push   %eax
  801439:	ff 75 08             	pushl  0x8(%ebp)
  80143c:	e8 44 ff ff ff       	call   801385 <read>
		if (m < 0)
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 0c                	js     801454 <readn+0x3f>
			return m;
		if (m == 0)
  801448:	85 c0                	test   %eax,%eax
  80144a:	74 06                	je     801452 <readn+0x3d>
  80144c:	01 c3                	add    %eax,%ebx
  80144e:	39 f3                	cmp    %esi,%ebx
  801450:	72 db                	jb     80142d <readn+0x18>
			break;
	}
	return tot;
  801452:	89 d8                	mov    %ebx,%eax
}
  801454:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801457:	5b                   	pop    %ebx
  801458:	5e                   	pop    %esi
  801459:	5f                   	pop    %edi
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	53                   	push   %ebx
  801460:	83 ec 14             	sub    $0x14,%esp
  801463:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801466:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	53                   	push   %ebx
  80146b:	e8 82 fc ff ff       	call   8010f2 <fd_lookup>
  801470:	89 c2                	mov    %eax,%edx
  801472:	83 c4 08             	add    $0x8,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	78 1a                	js     801493 <write+0x37>
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80147f:	50                   	push   %eax
  801480:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801483:	ff 30                	pushl  (%eax)
  801485:	e8 2a fd ff ff       	call   8011b4 <dev_lookup>
  80148a:	89 c2                	mov    %eax,%edx
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	79 04                	jns    801497 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801493:	89 d0                	mov    %edx,%eax
  801495:	eb 4b                	jmp    8014e2 <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801497:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80149a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149e:	75 1e                	jne    8014be <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	53                   	push   %ebx
  8014a4:	a1 80 60 80 00       	mov    0x806080,%eax
  8014a9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014ac:	50                   	push   %eax
  8014ad:	68 79 2a 80 00       	push   $0x802a79
  8014b2:	e8 89 ee ff ff       	call   800340 <cprintf>
		return -E_INVAL;
  8014b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bc:	eb 24                	jmp    8014e2 <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8014be:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014c1:	ff 70 04             	pushl  0x4(%eax)
  8014c4:	ff 75 10             	pushl  0x10(%ebp)
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	50                   	push   %eax
  8014cb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8014ce:	ff 50 0c             	call   *0xc(%eax)
  8014d1:	89 c2                	mov    %eax,%edx
	if (r > 0)
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	7e 06                	jle    8014e0 <write+0x84>
		fd->fd_offset += r;
  8014da:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014dd:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8014e0:	89 d0                	mov    %edx,%eax
}
  8014e2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ed:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8014f0:	50                   	push   %eax
  8014f1:	ff 75 08             	pushl  0x8(%ebp)
  8014f4:	e8 f9 fb ff ff       	call   8010f2 <fd_lookup>
  8014f9:	83 c4 08             	add    $0x8,%esp
		return r;
  8014fc:	89 c2                	mov    %eax,%edx
  8014fe:	85 c0                	test   %eax,%eax
  801500:	78 0e                	js     801510 <seek+0x29>
	fd->fd_offset = offset;
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801508:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80150b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801510:	89 d0                	mov    %edx,%eax
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	53                   	push   %ebx
  801518:	83 ec 14             	sub    $0x14,%esp
  80151b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801521:	50                   	push   %eax
  801522:	53                   	push   %ebx
  801523:	e8 ca fb ff ff       	call   8010f2 <fd_lookup>
  801528:	83 c4 08             	add    $0x8,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 4e                	js     80157d <ftruncate+0x69>
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801539:	ff 30                	pushl  (%eax)
  80153b:	e8 74 fc ff ff       	call   8011b4 <dev_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 36                	js     80157d <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801547:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80154a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80154e:	75 1e                	jne    80156e <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	53                   	push   %ebx
  801554:	a1 80 60 80 00       	mov    0x806080,%eax
  801559:	8b 40 4c             	mov    0x4c(%eax),%eax
  80155c:	50                   	push   %eax
  80155d:	68 3c 2a 80 00       	push   $0x802a3c
  801562:	e8 d9 ed ff ff       	call   800340 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801567:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156c:	eb 0f                	jmp    80157d <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801577:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80157a:	ff 50 1c             	call   *0x1c(%eax)
}
  80157d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	53                   	push   %ebx
  801586:	83 ec 14             	sub    $0x14,%esp
  801589:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158c:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80158f:	50                   	push   %eax
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 5a fb ff ff       	call   8010f2 <fd_lookup>
  801598:	83 c4 08             	add    $0x8,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 42                	js     8015e1 <fstat+0x5f>
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015a9:	ff 30                	pushl  (%eax)
  8015ab:	e8 04 fc ff ff       	call   8011b4 <dev_lookup>
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 2a                	js     8015e1 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  8015b7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ba:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c1:	00 00 00 
	stat->st_isdir = 0;
  8015c4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cb:	00 00 00 
	stat->st_dev = dev;
  8015ce:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8015d1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d7:	83 ec 08             	sub    $0x8,%esp
  8015da:	53                   	push   %ebx
  8015db:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015de:	ff 50 14             	call   *0x14(%eax)
}
  8015e1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	56                   	push   %esi
  8015ea:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	6a 00                	push   $0x0
  8015f0:	ff 75 08             	pushl  0x8(%ebp)
  8015f3:	e8 28 00 00 00       	call   801620 <open>
  8015f8:	89 c6                	mov    %eax,%esi
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	85 f6                	test   %esi,%esi
  8015ff:	78 18                	js     801619 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	56                   	push   %esi
  801608:	e8 75 ff ff ff       	call   801582 <fstat>
  80160d:	89 c3                	mov    %eax,%ebx
	close(fd);
  80160f:	89 34 24             	mov    %esi,(%esp)
  801612:	e8 fb fb ff ff       	call   801212 <close>
	return r;
  801617:	89 d8                	mov    %ebx,%eax
}
  801619:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	53                   	push   %ebx
  801624:	83 ec 10             	sub    $0x10,%esp
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
  801627:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80162a:	50                   	push   %eax
  80162b:	e8 68 fa ff ff       	call   801098 <fd_alloc>
  801630:	89 c3                	mov    %eax,%ebx
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 db                	test   %ebx,%ebx
  801637:	78 36                	js     80166f <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	e8 1b 05 00 00       	call   801b65 <fsipc_open>
  80164a:	89 c3                	mov    %eax,%ebx
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	79 11                	jns    801664 <open+0x44>
          fd_close(fd_store, 0);
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	6a 00                	push   $0x0
  801658:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80165b:	e8 e0 fa ff ff       	call   801140 <fd_close>
          return r;
  801660:	89 d8                	mov    %ebx,%eax
  801662:	eb 0b                	jmp    80166f <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801664:	83 ec 0c             	sub    $0xc,%esp
  801667:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80166a:	e8 19 fa ff ff       	call   801088 <fd2num>
}
  80166f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	53                   	push   %ebx
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  80167e:	6a 01                	push   $0x1
  801680:	6a 00                	push   $0x0
  801682:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801688:	53                   	push   %ebx
  801689:	e8 e7 03 00 00       	call   801a75 <funmap>
  80168e:	83 c4 10             	add    $0x10,%esp
          return r;
  801691:	89 c2                	mov    %eax,%edx
  801693:	85 c0                	test   %eax,%eax
  801695:	78 19                	js     8016b0 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	ff 73 0c             	pushl  0xc(%ebx)
  80169d:	e8 68 05 00 00       	call   801c0a <fsipc_close>
  8016a2:	83 c4 10             	add    $0x10,%esp
          return r;
  8016a5:	89 c2                	mov    %eax,%edx
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	78 05                	js     8016b0 <file_close+0x3c>
        }
        return 0;
  8016ab:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016b0:	89 d0                	mov    %edx,%eax
  8016b2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	57                   	push   %edi
  8016bb:	56                   	push   %esi
  8016bc:	53                   	push   %ebx
  8016bd:	83 ec 0c             	sub    $0xc,%esp
  8016c0:	8b 75 10             	mov    0x10(%ebp),%esi
  8016c3:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  8016cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d4:	39 d7                	cmp    %edx,%edi
  8016d6:	0f 87 95 00 00 00    	ja     801771 <file_read+0xba>
	if (offset + n > size)
  8016dc:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8016df:	39 d0                	cmp    %edx,%eax
  8016e1:	76 04                	jbe    8016e7 <file_read+0x30>
		n = size - offset;
  8016e3:	89 d6                	mov    %edx,%esi
  8016e5:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	e8 7e f9 ff ff       	call   801070 <fd2data>
  8016f2:	89 c3                	mov    %eax,%ebx
  8016f4:	01 fb                	add    %edi,%ebx
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	eb 41                	jmp    80173c <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8016fb:	89 d8                	mov    %ebx,%eax
  8016fd:	c1 e8 16             	shr    $0x16,%eax
  801700:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801707:	a8 01                	test   $0x1,%al
  801709:	74 10                	je     80171b <file_read+0x64>
  80170b:	89 d8                	mov    %ebx,%eax
  80170d:	c1 e8 0c             	shr    $0xc,%eax
  801710:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801717:	a8 01                	test   $0x1,%al
  801719:	75 1b                	jne    801736 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801721:	50                   	push   %eax
  801722:	57                   	push   %edi
  801723:	ff 75 08             	pushl  0x8(%ebp)
  801726:	e8 d4 02 00 00       	call   8019ff <fmap>
  80172b:	83 c4 10             	add    $0x10,%esp
              return r;
  80172e:	89 c1                	mov    %eax,%ecx
  801730:	85 c0                	test   %eax,%eax
  801732:	78 3d                	js     801771 <file_read+0xba>
  801734:	eb 1c                	jmp    801752 <file_read+0x9b>
  801736:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80173c:	83 ec 0c             	sub    $0xc,%esp
  80173f:	ff 75 08             	pushl  0x8(%ebp)
  801742:	e8 29 f9 ff ff       	call   801070 <fd2data>
  801747:	01 f8                	add    %edi,%eax
  801749:	01 f0                	add    %esi,%eax
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	39 d8                	cmp    %ebx,%eax
  801750:	77 a9                	ja     8016fb <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	56                   	push   %esi
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	ff 75 08             	pushl  0x8(%ebp)
  80175c:	e8 0f f9 ff ff       	call   801070 <fd2data>
  801761:	83 c4 08             	add    $0x8,%esp
  801764:	01 f8                	add    %edi,%eax
  801766:	50                   	push   %eax
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	e8 51 f3 ff ff       	call   800ac0 <memmove>
	return n;
  80176f:	89 f1                	mov    %esi,%ecx
}
  801771:	89 c8                	mov    %ecx,%eax
  801773:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801776:	5b                   	pop    %ebx
  801777:	5e                   	pop    %esi
  801778:	5f                   	pop    %edi
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 18             	sub    $0x18,%esp
  801783:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801786:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801789:	50                   	push   %eax
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	e8 60 f9 ff ff       	call   8010f2 <fd_lookup>
  801792:	83 c4 10             	add    $0x10,%esp
		return r;
  801795:	89 c2                	mov    %eax,%edx
  801797:	85 c0                	test   %eax,%eax
  801799:	0f 88 9f 00 00 00    	js     80183e <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  80179f:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8017a2:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8017a4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8017a9:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  8017af:	0f 85 89 00 00 00    	jne    80183e <read_map+0xc3>
	va = fd2data(fd) + offset;
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8017bb:	e8 b0 f8 ff ff       	call   801070 <fd2data>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8017c4:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8017c7:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8017cc:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  8017d2:	7f 6a                	jg     80183e <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  8017d4:	89 d8                	mov    %ebx,%eax
  8017d6:	c1 e8 16             	shr    $0x16,%eax
  8017d9:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8017e0:	a8 01                	test   $0x1,%al
  8017e2:	74 10                	je     8017f4 <read_map+0x79>
  8017e4:	89 d8                	mov    %ebx,%eax
  8017e6:	c1 e8 0c             	shr    $0xc,%eax
  8017e9:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8017f0:	a8 01                	test   $0x1,%al
  8017f2:	75 19                	jne    80180d <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	8d 46 01             	lea    0x1(%esi),%eax
  8017fa:	50                   	push   %eax
  8017fb:	56                   	push   %esi
  8017fc:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8017ff:	e8 fb 01 00 00       	call   8019ff <fmap>
  801804:	83 c4 10             	add    $0x10,%esp
            return r;
  801807:	89 c2                	mov    %eax,%edx
  801809:	85 c0                	test   %eax,%eax
  80180b:	78 31                	js     80183e <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  80180d:	89 d8                	mov    %ebx,%eax
  80180f:	c1 e8 16             	shr    $0x16,%eax
  801812:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801819:	a8 01                	test   $0x1,%al
  80181b:	74 10                	je     80182d <read_map+0xb2>
  80181d:	89 d8                	mov    %ebx,%eax
  80181f:	c1 e8 0c             	shr    $0xc,%eax
  801822:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801829:	a8 01                	test   $0x1,%al
  80182b:	75 07                	jne    801834 <read_map+0xb9>
		return -E_NO_DISK;
  80182d:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801832:	eb 0a                	jmp    80183e <read_map+0xc3>

	*blk = (void*) va;
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	89 18                	mov    %ebx,(%eax)
	return 0;
  801839:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80183e:	89 d0                	mov    %edx,%eax
  801840:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	57                   	push   %edi
  80184b:	56                   	push   %esi
  80184c:	53                   	push   %ebx
  80184d:	83 ec 0c             	sub    $0xc,%esp
  801850:	8b 75 08             	mov    0x8(%ebp),%esi
  801853:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801856:	8b 45 10             	mov    0x10(%ebp),%eax
  801859:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  80185c:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801861:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801867:	0f 87 bd 00 00 00    	ja     80192a <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  80186d:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801873:	73 17                	jae    80188c <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801875:	83 ec 08             	sub    $0x8,%esp
  801878:	52                   	push   %edx
  801879:	56                   	push   %esi
  80187a:	e8 fb 00 00 00       	call   80197a <file_trunc>
  80187f:	83 c4 10             	add    $0x10,%esp
			return r;
  801882:	89 c1                	mov    %eax,%ecx
  801884:	85 c0                	test   %eax,%eax
  801886:	0f 88 9e 00 00 00    	js     80192a <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  80188c:	83 ec 0c             	sub    $0xc,%esp
  80188f:	56                   	push   %esi
  801890:	e8 db f7 ff ff       	call   801070 <fd2data>
  801895:	89 c3                	mov    %eax,%ebx
  801897:	01 fb                	add    %edi,%ebx
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	eb 42                	jmp    8018e0 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  80189e:	89 d8                	mov    %ebx,%eax
  8018a0:	c1 e8 16             	shr    $0x16,%eax
  8018a3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8018aa:	a8 01                	test   $0x1,%al
  8018ac:	74 10                	je     8018be <file_write+0x77>
  8018ae:	89 d8                	mov    %ebx,%eax
  8018b0:	c1 e8 0c             	shr    $0xc,%eax
  8018b3:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8018ba:	a8 01                	test   $0x1,%al
  8018bc:	75 1c                	jne    8018da <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 55 10             	mov    0x10(%ebp),%edx
  8018c4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  8018c7:	50                   	push   %eax
  8018c8:	57                   	push   %edi
  8018c9:	56                   	push   %esi
  8018ca:	e8 30 01 00 00       	call   8019ff <fmap>
  8018cf:	83 c4 10             	add    $0x10,%esp
              return r;
  8018d2:	89 c1                	mov    %eax,%ecx
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 52                	js     80192a <file_write+0xe3>
  8018d8:	eb 1b                	jmp    8018f5 <file_write+0xae>
  8018da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	56                   	push   %esi
  8018e4:	e8 87 f7 ff ff       	call   801070 <fd2data>
  8018e9:	01 f8                	add    %edi,%eax
  8018eb:	03 45 10             	add    0x10(%ebp),%eax
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	39 d8                	cmp    %ebx,%eax
  8018f3:	77 a9                	ja     80189e <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  8018f5:	83 ec 0c             	sub    $0xc,%esp
  8018f8:	68 96 2a 80 00       	push   $0x802a96
  8018fd:	e8 3e ea ff ff       	call   800340 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801902:	83 c4 0c             	add    $0xc,%esp
  801905:	ff 75 10             	pushl  0x10(%ebp)
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	56                   	push   %esi
  80190c:	e8 5f f7 ff ff       	call   801070 <fd2data>
  801911:	01 f8                	add    %edi,%eax
  801913:	89 04 24             	mov    %eax,(%esp)
  801916:	e8 a5 f1 ff ff       	call   800ac0 <memmove>
        cprintf("write done\n");
  80191b:	c7 04 24 a3 2a 80 00 	movl   $0x802aa3,(%esp)
  801922:	e8 19 ea ff ff       	call   800340 <cprintf>
	return n;
  801927:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  80192a:	89 c8                	mov    %ecx,%eax
  80192c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5f                   	pop    %edi
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80193c:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	8d 43 10             	lea    0x10(%ebx),%eax
  801945:	50                   	push   %eax
  801946:	56                   	push   %esi
  801947:	e8 f8 ef ff ff       	call   800944 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  80194c:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801952:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801962:	0f 94 c0             	sete   %al
  801965:	0f b6 c0             	movzbl %al,%eax
  801968:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
  801973:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801976:	5b                   	pop    %ebx
  801977:	5e                   	pop    %esi
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	57                   	push   %edi
  80197e:	56                   	push   %esi
  80197f:	53                   	push   %ebx
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	8b 75 08             	mov    0x8(%ebp),%esi
  801986:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801989:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80198e:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801994:	7f 5f                	jg     8019f5 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801996:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	53                   	push   %ebx
  8019a0:	ff 76 0c             	pushl  0xc(%esi)
  8019a3:	e8 3a 02 00 00       	call   801be2 <fsipc_set_size>
  8019a8:	83 c4 10             	add    $0x10,%esp
		return r;
  8019ab:	89 c2                	mov    %eax,%edx
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	78 44                	js     8019f5 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  8019b1:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  8019b7:	74 19                	je     8019d2 <file_trunc+0x58>
  8019b9:	68 d0 2a 80 00       	push   $0x802ad0
  8019be:	68 af 2a 80 00       	push   $0x802aaf
  8019c3:	68 dc 00 00 00       	push   $0xdc
  8019c8:	68 c4 2a 80 00       	push   $0x802ac4
  8019cd:	e8 7e e8 ff ff       	call   800250 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	53                   	push   %ebx
  8019d6:	57                   	push   %edi
  8019d7:	56                   	push   %esi
  8019d8:	e8 22 00 00 00       	call   8019ff <fmap>
  8019dd:	83 c4 10             	add    $0x10,%esp
		return r;
  8019e0:	89 c2                	mov    %eax,%edx
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	78 0f                	js     8019f5 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	53                   	push   %ebx
  8019e9:	57                   	push   %edi
  8019ea:	56                   	push   %esi
  8019eb:	e8 85 00 00 00       	call   801a75 <funmap>

	return 0;
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019f5:	89 d0                	mov    %edx,%eax
  8019f7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5f                   	pop    %edi
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <fmap>:

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
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	57                   	push   %edi
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 0c             	sub    $0xc,%esp
  801a08:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a0b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801a0e:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801a11:	7d 55                	jge    801a68 <fmap+0x69>
          fma = fd2data(fd);
  801a13:	83 ec 0c             	sub    $0xc,%esp
  801a16:	57                   	push   %edi
  801a17:	e8 54 f6 ff ff       	call   801070 <fd2data>
  801a1c:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  801a2a:	89 c3                	mov    %eax,%ebx
  801a2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801a32:	39 f3                	cmp    %esi,%ebx
  801a34:	7d 32                	jge    801a68 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801a3c:	01 d8                	add    %ebx,%eax
  801a3e:	50                   	push   %eax
  801a3f:	53                   	push   %ebx
  801a40:	ff 77 0c             	pushl  0xc(%edi)
  801a43:	e8 6f 01 00 00       	call   801bb7 <fsipc_map>
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	79 0f                	jns    801a5e <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	53                   	push   %ebx
  801a55:	57                   	push   %edi
  801a56:	e8 1a 00 00 00       	call   801a75 <funmap>
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a64:	39 f3                	cmp    %esi,%ebx
  801a66:	7c ce                	jl     801a36 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801a68:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5f                   	pop    %edi
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <funmap>:

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
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	57                   	push   %edi
  801a79:	56                   	push   %esi
  801a7a:	53                   	push   %ebx
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801a84:	39 f3                	cmp    %esi,%ebx
  801a86:	0f 8d 80 00 00 00    	jge    801b0c <funmap+0x97>
          fma = fd2data(fd);
  801a8c:	83 ec 0c             	sub    $0xc,%esp
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	e8 d9 f5 ff ff       	call   801070 <fd2data>
  801a97:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801aa2:	89 c3                	mov    %eax,%ebx
  801aa4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801aaa:	39 f3                	cmp    %esi,%ebx
  801aac:	7d 5e                	jge    801b0c <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801aae:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801ab1:	89 c2                	mov    %eax,%edx
  801ab3:	c1 ea 0c             	shr    $0xc,%edx
  801ab6:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801abd:	a8 01                	test   $0x1,%al
  801abf:	74 41                	je     801b02 <funmap+0x8d>
              if (dirty) {
  801ac1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801ac5:	74 21                	je     801ae8 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801ac7:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801ace:	a8 40                	test   $0x40,%al
  801ad0:	74 16                	je     801ae8 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	53                   	push   %ebx
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	ff 70 0c             	pushl  0xc(%eax)
  801adc:	e8 49 01 00 00       	call   801c2a <fsipc_dirty>
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	78 29                	js     801b11 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801aee:	50                   	push   %eax
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	e8 e1 f1 ff ff       	call   800cd8 <sys_getenvid>
  801af7:	89 04 24             	mov    %eax,(%esp)
  801afa:	e8 9c f2 ff ff       	call   800d9b <sys_page_unmap>
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b08:	39 f3                	cmp    %esi,%ebx
  801b0a:	7c a2                	jl     801aae <funmap+0x39>
            }
          }
        }

        return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b11:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801b14:	5b                   	pop    %ebx
  801b15:	5e                   	pop    %esi
  801b16:	5f                   	pop    %edi
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <remove>:

// Delete a file
int
remove(const char *path)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	e8 2b 01 00 00       	call   801c52 <fsipc_remove>
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801b2f:	e8 64 01 00 00       	call   801c98 <fsipc_sync>
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    
	...

00801b38 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801b3e:	6a 07                	push   $0x7
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801b4b:	50                   	push   %eax
  801b4c:	e8 c6 06 00 00       	call   802217 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801b51:	83 c4 0c             	add    $0xc,%esp
  801b54:	ff 75 14             	pushl  0x14(%ebp)
  801b57:	ff 75 10             	pushl  0x10(%ebp)
  801b5a:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	e8 51 06 00 00       	call   8021b4 <ipc_recv>
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	56                   	push   %esi
  801b69:	53                   	push   %ebx
  801b6a:	83 ec 1c             	sub    $0x1c,%esp
  801b6d:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801b70:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801b75:	56                   	push   %esi
  801b76:	e8 8d ed ff ff       	call   800908 <strlen>
  801b7b:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801b7e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b83:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b88:	7f 24                	jg     801bae <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	56                   	push   %esi
  801b8e:	53                   	push   %ebx
  801b8f:	e8 b0 ed ff ff       	call   800944 <strcpy>
	req->req_omode = omode;
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801b9d:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801ba0:	50                   	push   %eax
  801ba1:	ff 75 10             	pushl  0x10(%ebp)
  801ba4:	53                   	push   %ebx
  801ba5:	6a 01                	push   $0x1
  801ba7:	e8 8c ff ff ff       	call   801b38 <fsipc>
  801bac:	89 c2                	mov    %eax,%edx
}
  801bae:	89 d0                	mov    %edx,%eax
  801bb0:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc8:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801bcd:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801bd0:	50                   	push   %eax
  801bd1:	ff 75 10             	pushl  0x10(%ebp)
  801bd4:	68 00 30 80 00       	push   $0x803000
  801bd9:	6a 02                	push   $0x2
  801bdb:	e8 58 ff ff ff       	call   801b38 <fsipc>

	//return -E_UNSPECIFIED;
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	68 00 30 80 00       	push   $0x803000
  801c01:	6a 03                	push   $0x3
  801c03:	e8 30 ff ff ff       	call   801b38 <fsipc>
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	68 00 30 80 00       	push   $0x803000
  801c21:	6a 04                	push   $0x4
  801c23:	e8 10 ff ff ff       	call   801b38 <fsipc>
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3b:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	68 00 30 80 00       	push   $0x803000
  801c49:	6a 05                	push   $0x5
  801c4b:	e8 e8 fe ff ff       	call   801b38 <fsipc>
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	56                   	push   %esi
  801c56:	53                   	push   %ebx
  801c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801c5a:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801c5f:	83 ec 0c             	sub    $0xc,%esp
  801c62:	53                   	push   %ebx
  801c63:	e8 a0 ec ff ff       	call   800908 <strlen>
  801c68:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801c6b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801c70:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c75:	7f 18                	jg     801c8f <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801c77:	83 ec 08             	sub    $0x8,%esp
  801c7a:	53                   	push   %ebx
  801c7b:	56                   	push   %esi
  801c7c:	e8 c3 ec ff ff       	call   800944 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	56                   	push   %esi
  801c86:	6a 06                	push   $0x6
  801c88:	e8 ab fe ff ff       	call   801b38 <fsipc>
  801c8d:	89 c2                	mov    %eax,%edx
}
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	68 00 30 80 00       	push   $0x803000
  801ca7:	6a 07                	push   $0x7
  801ca9:	e8 8a fe ff ff       	call   801b38 <fsipc>
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <pipe>:
};

int
pipe(int pfd[2])
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	57                   	push   %edi
  801cb4:	56                   	push   %esi
  801cb5:	53                   	push   %ebx
  801cb6:	83 ec 18             	sub    $0x18,%esp
  801cb9:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801cbc:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801cbf:	50                   	push   %eax
  801cc0:	e8 d3 f3 ff ff       	call   801098 <fd_alloc>
  801cc5:	89 c3                	mov    %eax,%ebx
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	0f 88 25 01 00 00    	js     801df7 <pipe+0x147>
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	68 07 04 00 00       	push   $0x407
  801cda:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801cdd:	6a 00                	push   $0x0
  801cdf:	e8 32 f0 ff ff       	call   800d16 <sys_page_alloc>
  801ce4:	89 c3                	mov    %eax,%ebx
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	0f 88 06 01 00 00    	js     801df7 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801cf7:	50                   	push   %eax
  801cf8:	e8 9b f3 ff ff       	call   801098 <fd_alloc>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	85 c0                	test   %eax,%eax
  801d04:	0f 88 dd 00 00 00    	js     801de7 <pipe+0x137>
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	68 07 04 00 00       	push   $0x407
  801d12:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801d15:	6a 00                	push   $0x0
  801d17:	e8 fa ef ff ff       	call   800d16 <sys_page_alloc>
  801d1c:	89 c3                	mov    %eax,%ebx
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	85 c0                	test   %eax,%eax
  801d23:	0f 88 be 00 00 00    	js     801de7 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d29:	83 ec 0c             	sub    $0xc,%esp
  801d2c:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801d2f:	e8 3c f3 ff ff       	call   801070 <fd2data>
  801d34:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d36:	83 c4 0c             	add    $0xc,%esp
  801d39:	68 07 04 00 00       	push   $0x407
  801d3e:	50                   	push   %eax
  801d3f:	6a 00                	push   $0x0
  801d41:	e8 d0 ef ff ff       	call   800d16 <sys_page_alloc>
  801d46:	89 c3                	mov    %eax,%ebx
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	0f 88 84 00 00 00    	js     801dd7 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	68 07 04 00 00       	push   $0x407
  801d5b:	83 ec 0c             	sub    $0xc,%esp
  801d5e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801d61:	e8 0a f3 ff ff       	call   801070 <fd2data>
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	50                   	push   %eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	56                   	push   %esi
  801d6d:	6a 00                	push   $0x0
  801d6f:	e8 e5 ef ff ff       	call   800d59 <sys_page_map>
  801d74:	89 c3                	mov    %eax,%ebx
  801d76:	83 c4 20             	add    $0x20,%esp
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	78 4c                	js     801dc9 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d7d:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801d83:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801d86:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d88:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801d8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d92:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801d98:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801d9b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d9d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801da0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801dad:	e8 d6 f2 ff ff       	call   801088 <fd2num>
  801db2:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801db4:	83 c4 04             	add    $0x4,%esp
  801db7:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801dba:	e8 c9 f2 ff ff       	call   801088 <fd2num>
  801dbf:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 30                	jmp    801df9 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	56                   	push   %esi
  801dcd:	6a 00                	push   $0x0
  801dcf:	e8 c7 ef ff ff       	call   800d9b <sys_page_unmap>
  801dd4:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801ddd:	6a 00                	push   $0x0
  801ddf:	e8 b7 ef ff ff       	call   800d9b <sys_page_unmap>
  801de4:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801de7:	83 ec 08             	sub    $0x8,%esp
  801dea:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801ded:	6a 00                	push   $0x0
  801def:	e8 a7 ef ff ff       	call   800d9b <sys_page_unmap>
  801df4:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  801df7:	89 d8                	mov    %ebx,%eax
}
  801df9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801dfc:	5b                   	pop    %ebx
  801dfd:	5e                   	pop    %esi
  801dfe:	5f                   	pop    %edi
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	57                   	push   %edi
  801e05:	56                   	push   %esi
  801e06:	53                   	push   %ebx
  801e07:	83 ec 0c             	sub    $0xc,%esp
  801e0a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801e0d:	a1 80 60 80 00       	mov    0x806080,%eax
  801e12:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	e8 50 04 00 00       	call   802270 <pageref>
  801e20:	89 c3                	mov    %eax,%ebx
  801e22:	89 3c 24             	mov    %edi,(%esp)
  801e25:	e8 46 04 00 00       	call   802270 <pageref>
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	39 c3                	cmp    %eax,%ebx
  801e2f:	0f 94 c0             	sete   %al
  801e32:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801e35:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  801e3b:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  801e3e:	39 c6                	cmp    %eax,%esi
  801e40:	74 1b                	je     801e5d <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  801e42:	83 fa 01             	cmp    $0x1,%edx
  801e45:	75 c6                	jne    801e0d <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801e47:	6a 01                	push   $0x1
  801e49:	8b 41 58             	mov    0x58(%ecx),%eax
  801e4c:	50                   	push   %eax
  801e4d:	56                   	push   %esi
  801e4e:	68 f8 2a 80 00       	push   $0x802af8
  801e53:	e8 e8 e4 ff ff       	call   800340 <cprintf>
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	eb b0                	jmp    801e0d <_pipeisclosed+0xc>
	}
}
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e62:	5b                   	pop    %ebx
  801e63:	5e                   	pop    %esi
  801e64:	5f                   	pop    %edi
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e6d:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e70:	50                   	push   %eax
  801e71:	ff 75 08             	pushl  0x8(%ebp)
  801e74:	e8 79 f2 ff ff       	call   8010f2 <fd_lookup>
  801e79:	83 c4 10             	add    $0x10,%esp
		return r;
  801e7c:	89 c2                	mov    %eax,%edx
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 19                	js     801e9b <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801e88:	e8 e3 f1 ff ff       	call   801070 <fd2data>
	return _pipeisclosed(fd, p);
  801e8d:	83 c4 08             	add    $0x8,%esp
  801e90:	50                   	push   %eax
  801e91:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801e94:	e8 68 ff ff ff       	call   801e01 <_pipeisclosed>
  801e99:	89 c2                	mov    %eax,%edx
}
  801e9b:	89 d0                	mov    %edx,%eax
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	57                   	push   %edi
  801ea3:	56                   	push   %esi
  801ea4:	53                   	push   %ebx
  801ea5:	83 ec 18             	sub    $0x18,%esp
  801ea8:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  801eab:	57                   	push   %edi
  801eac:	e8 bf f1 ff ff       	call   801070 <fd2data>
  801eb1:	89 c3                	mov    %eax,%ebx
	if (debug)
  801eb3:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb9:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801ebc:	be 00 00 00 00       	mov    $0x0,%esi
  801ec1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ec4:	73 55                	jae    801f1b <piperead+0x7c>
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
  801ec6:	8b 03                	mov    (%ebx),%eax
  801ec8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ecb:	75 2c                	jne    801ef9 <piperead+0x5a>
  801ecd:	85 f6                	test   %esi,%esi
  801ecf:	74 04                	je     801ed5 <piperead+0x36>
  801ed1:	89 f0                	mov    %esi,%eax
  801ed3:	eb 48                	jmp    801f1d <piperead+0x7e>
  801ed5:	83 ec 08             	sub    $0x8,%esp
  801ed8:	53                   	push   %ebx
  801ed9:	57                   	push   %edi
  801eda:	e8 22 ff ff ff       	call   801e01 <_pipeisclosed>
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	74 07                	je     801eed <piperead+0x4e>
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eeb:	eb 30                	jmp    801f1d <piperead+0x7e>
  801eed:	e8 05 ee ff ff       	call   800cf7 <sys_yield>
  801ef2:	8b 03                	mov    (%ebx),%eax
  801ef4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ef7:	74 d4                	je     801ecd <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ef9:	8b 13                	mov    (%ebx),%edx
  801efb:	89 d0                	mov    %edx,%eax
  801efd:	85 d2                	test   %edx,%edx
  801eff:	79 03                	jns    801f04 <piperead+0x65>
  801f01:	8d 42 1f             	lea    0x1f(%edx),%eax
  801f04:	83 e0 e0             	and    $0xffffffe0,%eax
  801f07:	29 c2                	sub    %eax,%edx
  801f09:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801f0d:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801f10:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f13:	ff 03                	incl   (%ebx)
  801f15:	46                   	inc    %esi
  801f16:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f19:	72 ab                	jb     801ec6 <piperead+0x27>
	}
	return i;
  801f1b:	89 f0                	mov    %esi,%eax
}
  801f1d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5f                   	pop    %edi
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	57                   	push   %edi
  801f29:	56                   	push   %esi
  801f2a:	53                   	push   %ebx
  801f2b:	83 ec 18             	sub    $0x18,%esp
  801f2e:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  801f31:	57                   	push   %edi
  801f32:	e8 39 f1 ff ff       	call   801070 <fd2data>
  801f37:	89 c3                	mov    %eax,%ebx
	if (debug)
  801f39:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801f42:	be 00 00 00 00       	mov    $0x0,%esi
  801f47:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f4a:	73 55                	jae    801fa1 <pipewrite+0x7c>
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
  801f4c:	8b 03                	mov    (%ebx),%eax
  801f4e:	83 c0 20             	add    $0x20,%eax
  801f51:	39 43 04             	cmp    %eax,0x4(%ebx)
  801f54:	72 27                	jb     801f7d <pipewrite+0x58>
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	53                   	push   %ebx
  801f5a:	57                   	push   %edi
  801f5b:	e8 a1 fe ff ff       	call   801e01 <_pipeisclosed>
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	85 c0                	test   %eax,%eax
  801f65:	74 07                	je     801f6e <pipewrite+0x49>
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	eb 35                	jmp    801fa3 <pipewrite+0x7e>
  801f6e:	e8 84 ed ff ff       	call   800cf7 <sys_yield>
  801f73:	8b 03                	mov    (%ebx),%eax
  801f75:	83 c0 20             	add    $0x20,%eax
  801f78:	39 43 04             	cmp    %eax,0x4(%ebx)
  801f7b:	73 d9                	jae    801f56 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f7d:	8b 53 04             	mov    0x4(%ebx),%edx
  801f80:	89 d0                	mov    %edx,%eax
  801f82:	85 d2                	test   %edx,%edx
  801f84:	79 03                	jns    801f89 <pipewrite+0x64>
  801f86:	8d 42 1f             	lea    0x1f(%edx),%eax
  801f89:	83 e0 e0             	and    $0xffffffe0,%eax
  801f8c:	29 c2                	sub    %eax,%edx
  801f8e:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  801f91:	8a 04 31             	mov    (%ecx,%esi,1),%al
  801f94:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f98:	ff 43 04             	incl   0x4(%ebx)
  801f9b:	46                   	inc    %esi
  801f9c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f9f:	72 ab                	jb     801f4c <pipewrite+0x27>
	}
	
	return i;
  801fa1:	89 f0                	mov    %esi,%eax
}
  801fa3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801fa6:	5b                   	pop    %ebx
  801fa7:	5e                   	pop    %esi
  801fa8:	5f                   	pop    %edi
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	56                   	push   %esi
  801faf:	53                   	push   %ebx
  801fb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	ff 75 08             	pushl  0x8(%ebp)
  801fb9:	e8 b2 f0 ff ff       	call   801070 <fd2data>
  801fbe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fc0:	83 c4 08             	add    $0x8,%esp
  801fc3:	68 0b 2b 80 00       	push   $0x802b0b
  801fc8:	53                   	push   %ebx
  801fc9:	e8 76 e9 ff ff       	call   800944 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801fce:	8b 46 04             	mov    0x4(%esi),%eax
  801fd1:	2b 06                	sub    (%esi),%eax
  801fd3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fd9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fe0:	00 00 00 
	stat->st_dev = &devpipe;
  801fe3:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  801fea:	60 80 00 
	return 0;
}
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ff5:	5b                   	pop    %ebx
  801ff6:	5e                   	pop    %esi
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	53                   	push   %ebx
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802003:	53                   	push   %ebx
  802004:	6a 00                	push   $0x0
  802006:	e8 90 ed ff ff       	call   800d9b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80200b:	89 1c 24             	mov    %ebx,(%esp)
  80200e:	e8 5d f0 ff ff       	call   801070 <fd2data>
  802013:	83 c4 08             	add    $0x8,%esp
  802016:	50                   	push   %eax
  802017:	6a 00                	push   $0x0
  802019:	e8 7d ed ff ff       	call   800d9b <sys_page_unmap>
}
  80201e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802021:	c9                   	leave  
  802022:	c3                   	ret    
	...

00802024 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802030:	6a 01                	push   $0x1
  802032:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802035:	50                   	push   %eax
  802036:	e8 19 ec ff ff       	call   800c54 <sys_cputs>
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <getchar>:

int
getchar(void)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802043:	6a 01                	push   $0x1
  802045:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802048:	50                   	push   %eax
  802049:	6a 00                	push   $0x0
  80204b:	e8 35 f3 ff ff       	call   801385 <read>
	if (r < 0)
  802050:	83 c4 10             	add    $0x10,%esp
		return r;
  802053:	89 c2                	mov    %eax,%edx
  802055:	85 c0                	test   %eax,%eax
  802057:	78 0d                	js     802066 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  802059:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  80205e:	85 c0                	test   %eax,%eax
  802060:	7e 04                	jle    802066 <getchar+0x29>
	return c;
  802062:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  802066:	89 d0                	mov    %edx,%eax
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <iscons>:


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
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802070:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802073:	50                   	push   %eax
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	e8 76 f0 ff ff       	call   8010f2 <fd_lookup>
  80207c:	83 c4 10             	add    $0x10,%esp
		return r;
  80207f:	89 c2                	mov    %eax,%edx
  802081:	85 c0                	test   %eax,%eax
  802083:	78 11                	js     802096 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  802085:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802088:	8b 00                	mov    (%eax),%eax
  80208a:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  802090:	0f 94 c0             	sete   %al
  802093:	0f b6 d0             	movzbl %al,%edx
}
  802096:	89 d0                	mov    %edx,%eax
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <opencons>:

int
opencons(void)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8020a0:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8020a3:	50                   	push   %eax
  8020a4:	e8 ef ef ff ff       	call   801098 <fd_alloc>
  8020a9:	83 c4 10             	add    $0x10,%esp
		return r;
  8020ac:	89 c2                	mov    %eax,%edx
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 3c                	js     8020ee <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	68 07 04 00 00       	push   $0x407
  8020ba:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020bd:	6a 00                	push   $0x0
  8020bf:	e8 52 ec ff ff       	call   800d16 <sys_page_alloc>
  8020c4:	83 c4 10             	add    $0x10,%esp
		return r;
  8020c7:	89 c2                	mov    %eax,%edx
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	78 21                	js     8020ee <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8020cd:	a1 60 60 80 00       	mov    0x806060,%eax
  8020d2:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  8020d5:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  8020d7:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8020da:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020e7:	e8 9c ef ff ff       	call   801088 <fd2num>
  8020ec:	89 c2                	mov    %eax,%edx
}
  8020ee:	89 d0                	mov    %edx,%eax
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802101:	74 2a                	je     80212d <cons_read+0x3b>
  802103:	eb 05                	jmp    80210a <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802105:	e8 ed eb ff ff       	call   800cf7 <sys_yield>
  80210a:	e8 69 eb ff ff       	call   800c78 <sys_cgetc>
  80210f:	89 c2                	mov    %eax,%edx
  802111:	85 c0                	test   %eax,%eax
  802113:	74 f0                	je     802105 <cons_read+0x13>
	if (c < 0)
  802115:	85 d2                	test   %edx,%edx
  802117:	78 14                	js     80212d <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	83 fa 04             	cmp    $0x4,%edx
  802121:	74 0a                	je     80212d <cons_read+0x3b>
	*(char*)vbuf = c;
  802123:	8b 45 0c             	mov    0xc(%ebp),%eax
  802126:	88 10                	mov    %dl,(%eax)
	return 1;
  802128:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	57                   	push   %edi
  802133:	56                   	push   %esi
  802134:	53                   	push   %ebx
  802135:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80213b:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80213e:	be 00 00 00 00       	mov    $0x0,%esi
  802143:	39 fe                	cmp    %edi,%esi
  802145:	73 3d                	jae    802184 <cons_write+0x55>
		m = n - tot;
  802147:	89 fb                	mov    %edi,%ebx
  802149:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80214b:	83 fb 7f             	cmp    $0x7f,%ebx
  80214e:	76 05                	jbe    802155 <cons_write+0x26>
			m = sizeof(buf) - 1;
  802150:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	53                   	push   %ebx
  802159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215c:	01 f0                	add    %esi,%eax
  80215e:	50                   	push   %eax
  80215f:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802165:	50                   	push   %eax
  802166:	e8 55 e9 ff ff       	call   800ac0 <memmove>
		sys_cputs(buf, m);
  80216b:	83 c4 08             	add    $0x8,%esp
  80216e:	53                   	push   %ebx
  80216f:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802175:	50                   	push   %eax
  802176:	e8 d9 ea ff ff       	call   800c54 <sys_cputs>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	01 de                	add    %ebx,%esi
  802180:	39 fe                	cmp    %edi,%esi
  802182:	72 c3                	jb     802147 <cons_write+0x18>
	}
	return tot;
}
  802184:	89 f0                	mov    %esi,%eax
  802186:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802189:	5b                   	pop    %ebx
  80218a:	5e                   	pop    %esi
  80218b:	5f                   	pop    %edi
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <cons_close>:

int
cons_close(struct Fd *fd)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80219e:	68 17 2b 80 00       	push   $0x802b17
  8021a3:	ff 75 0c             	pushl  0xc(%ebp)
  8021a6:	e8 99 e7 ff ff       	call   800944 <strcpy>
	return 0;
}
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    
	...

008021b4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8021bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bf:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	75 12                	jne    8021d8 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	68 00 00 c0 ee       	push   $0xeec00000
  8021ce:	e8 f3 ec ff ff       	call   800ec6 <sys_ipc_recv>
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	eb 0c                	jmp    8021e4 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8021d8:	83 ec 0c             	sub    $0xc,%esp
  8021db:	50                   	push   %eax
  8021dc:	e8 e5 ec ff ff       	call   800ec6 <sys_ipc_recv>
  8021e1:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8021e4:	89 c2                	mov    %eax,%edx
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 24                	js     80220e <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8021ea:	85 db                	test   %ebx,%ebx
  8021ec:	74 0a                	je     8021f8 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8021ee:	a1 80 60 80 00       	mov    0x806080,%eax
  8021f3:	8b 40 74             	mov    0x74(%eax),%eax
  8021f6:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8021f8:	85 f6                	test   %esi,%esi
  8021fa:	74 0a                	je     802206 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8021fc:	a1 80 60 80 00       	mov    0x806080,%eax
  802201:	8b 40 78             	mov    0x78(%eax),%eax
  802204:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802206:	a1 80 60 80 00       	mov    0x806080,%eax
  80220b:	8b 50 70             	mov    0x70(%eax),%edx

}
  80220e:	89 d0                	mov    %edx,%eax
  802210:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <ipc_send>:

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
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	57                   	push   %edi
  80221b:	56                   	push   %esi
  80221c:	53                   	push   %ebx
  80221d:	83 ec 0c             	sub    $0xc,%esp
  802220:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802223:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802226:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802229:	85 db                	test   %ebx,%ebx
  80222b:	75 0a                	jne    802237 <ipc_send+0x20>
    pg = (void *) UTOP;
  80222d:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802232:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
  802239:	57                   	push   %edi
  80223a:	ff 75 08             	pushl  0x8(%ebp)
  80223d:	e8 61 ec ff ff       	call   800ea3 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802248:	75 07                	jne    802251 <ipc_send+0x3a>
      sys_yield();
  80224a:	e8 a8 ea ff ff       	call   800cf7 <sys_yield>
  80224f:	eb e6                	jmp    802237 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802251:	85 c0                	test   %eax,%eax
  802253:	79 12                	jns    802267 <ipc_send+0x50>
  802255:	50                   	push   %eax
  802256:	68 1e 2b 80 00       	push   $0x802b1e
  80225b:	6a 49                	push   $0x49
  80225d:	68 3b 2b 80 00       	push   $0x802b3b
  802262:	e8 e9 df ff ff       	call   800250 <_panic>
    else break;
  }
}
  802267:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80226a:	5b                   	pop    %ebx
  80226b:	5e                   	pop    %esi
  80226c:	5f                   	pop    %edi
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    
	...

00802270 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802276:	89 c8                	mov    %ecx,%eax
  802278:	c1 e8 16             	shr    $0x16,%eax
  80227b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802282:	ba 00 00 00 00       	mov    $0x0,%edx
  802287:	a8 01                	test   $0x1,%al
  802289:	74 28                	je     8022b3 <pageref+0x43>
	pte = vpt[VPN(v)];
  80228b:	89 c8                	mov    %ecx,%eax
  80228d:	c1 e8 0c             	shr    $0xc,%eax
  802290:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  802297:	ba 00 00 00 00       	mov    $0x0,%edx
  80229c:	a8 01                	test   $0x1,%al
  80229e:	74 13                	je     8022b3 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8022a0:	c1 e8 0c             	shr    $0xc,%eax
  8022a3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8022a6:	c1 e0 02             	shl    $0x2,%eax
  8022a9:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8022b0:	0f b7 d0             	movzwl %ax,%edx
}
  8022b3:	89 d0                	mov    %edx,%eax
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    
	...

008022b8 <__udivdi3>:
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	57                   	push   %edi
  8022bc:	56                   	push   %esi
  8022bd:	83 ec 14             	sub    $0x14,%esp
  8022c0:	8b 55 14             	mov    0x14(%ebp),%edx
  8022c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8022c6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cc:	85 d2                	test   %edx,%edx
  8022ce:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8022d1:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8022d4:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8022d7:	89 fe                	mov    %edi,%esi
  8022d9:	75 11                	jne    8022ec <__udivdi3+0x34>
  8022db:	39 f8                	cmp    %edi,%eax
  8022dd:	76 4d                	jbe    80232c <__udivdi3+0x74>
  8022df:	89 fa                	mov    %edi,%edx
  8022e1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8022e4:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8022e7:	89 c7                	mov    %eax,%edi
  8022e9:	eb 09                	jmp    8022f4 <__udivdi3+0x3c>
  8022eb:	90                   	nop    
  8022ec:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  8022ef:	76 17                	jbe    802308 <__udivdi3+0x50>
  8022f1:	31 ff                	xor    %edi,%edi
  8022f3:	90                   	nop    
  8022f4:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  8022fb:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8022fe:	83 c4 14             	add    $0x14,%esp
  802301:	5e                   	pop    %esi
  802302:	89 f8                	mov    %edi,%eax
  802304:	5f                   	pop    %edi
  802305:	c9                   	leave  
  802306:	c3                   	ret    
  802307:	90                   	nop    
  802308:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  80230c:	89 c7                	mov    %eax,%edi
  80230e:	83 f7 1f             	xor    $0x1f,%edi
  802311:	75 4d                	jne    802360 <__udivdi3+0xa8>
  802313:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802316:	77 0a                	ja     802322 <__udivdi3+0x6a>
  802318:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80231b:	31 ff                	xor    %edi,%edi
  80231d:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802320:	72 d2                	jb     8022f4 <__udivdi3+0x3c>
  802322:	bf 01 00 00 00       	mov    $0x1,%edi
  802327:	eb cb                	jmp    8022f4 <__udivdi3+0x3c>
  802329:	8d 76 00             	lea    0x0(%esi),%esi
  80232c:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80232f:	85 c0                	test   %eax,%eax
  802331:	75 0e                	jne    802341 <__udivdi3+0x89>
  802333:	b8 01 00 00 00       	mov    $0x1,%eax
  802338:	31 c9                	xor    %ecx,%ecx
  80233a:	31 d2                	xor    %edx,%edx
  80233c:	f7 f1                	div    %ecx
  80233e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802341:	89 f0                	mov    %esi,%eax
  802343:	31 d2                	xor    %edx,%edx
  802345:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802348:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80234b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80234e:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802351:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802354:	83 c4 14             	add    $0x14,%esp
  802357:	89 c7                	mov    %eax,%edi
  802359:	5e                   	pop    %esi
  80235a:	89 f8                	mov    %edi,%eax
  80235c:	5f                   	pop    %edi
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    
  80235f:	90                   	nop    
  802360:	b8 20 00 00 00       	mov    $0x20,%eax
  802365:	29 f8                	sub    %edi,%eax
  802367:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80236a:	89 f9                	mov    %edi,%ecx
  80236c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80236f:	d3 e2                	shl    %cl,%edx
  802371:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802374:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802377:	d3 e8                	shr    %cl,%eax
  802379:	09 c2                	or     %eax,%edx
  80237b:	89 f9                	mov    %edi,%ecx
  80237d:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802380:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802383:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802386:	89 f2                	mov    %esi,%edx
  802388:	d3 ea                	shr    %cl,%edx
  80238a:	89 f9                	mov    %edi,%ecx
  80238c:	d3 e6                	shl    %cl,%esi
  80238e:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802391:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802394:	d3 e8                	shr    %cl,%eax
  802396:	09 c6                	or     %eax,%esi
  802398:	89 f9                	mov    %edi,%ecx
  80239a:	89 f0                	mov    %esi,%eax
  80239c:	f7 75 f4             	divl   0xfffffff4(%ebp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8023a6:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8023a9:	f7 e7                	mul    %edi
  8023ab:	39 f2                	cmp    %esi,%edx
  8023ad:	77 0f                	ja     8023be <__udivdi3+0x106>
  8023af:	0f 85 3f ff ff ff    	jne    8022f4 <__udivdi3+0x3c>
  8023b5:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  8023b8:	0f 86 36 ff ff ff    	jbe    8022f4 <__udivdi3+0x3c>
  8023be:	4f                   	dec    %edi
  8023bf:	e9 30 ff ff ff       	jmp    8022f4 <__udivdi3+0x3c>

008023c4 <__umoddi3>:
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	57                   	push   %edi
  8023c8:	56                   	push   %esi
  8023c9:	83 ec 30             	sub    $0x30,%esp
  8023cc:	8b 55 14             	mov    0x14(%ebp),%edx
  8023cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d2:	89 d7                	mov    %edx,%edi
  8023d4:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8023d7:	89 c6                	mov    %eax,%esi
  8023d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	85 ff                	test   %edi,%edi
  8023e1:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  8023e8:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8023ef:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  8023f2:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8023f5:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8023f8:	75 3e                	jne    802438 <__umoddi3+0x74>
  8023fa:	39 d6                	cmp    %edx,%esi
  8023fc:	0f 86 a2 00 00 00    	jbe    8024a4 <__umoddi3+0xe0>
  802402:	f7 f6                	div    %esi
  802404:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802407:	85 c9                	test   %ecx,%ecx
  802409:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  80240c:	74 1b                	je     802429 <__umoddi3+0x65>
  80240e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802411:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802414:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80241b:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80241e:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802421:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802424:	89 10                	mov    %edx,(%eax)
  802426:	89 48 04             	mov    %ecx,0x4(%eax)
  802429:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80242c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80242f:	83 c4 30             	add    $0x30,%esp
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	c9                   	leave  
  802435:	c3                   	ret    
  802436:	89 f6                	mov    %esi,%esi
  802438:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80243b:	76 1f                	jbe    80245c <__umoddi3+0x98>
  80243d:	8b 55 08             	mov    0x8(%ebp),%edx
  802440:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802443:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802446:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802449:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80244c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80244f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802452:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802455:	83 c4 30             	add    $0x30,%esp
  802458:	5e                   	pop    %esi
  802459:	5f                   	pop    %edi
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    
  80245c:	0f bd c7             	bsr    %edi,%eax
  80245f:	83 f0 1f             	xor    $0x1f,%eax
  802462:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802465:	75 61                	jne    8024c8 <__umoddi3+0x104>
  802467:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80246a:	77 05                	ja     802471 <__umoddi3+0xad>
  80246c:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  80246f:	72 10                	jb     802481 <__umoddi3+0xbd>
  802471:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802474:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802477:	29 f0                	sub    %esi,%eax
  802479:	19 fa                	sbb    %edi,%edx
  80247b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80247e:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802481:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802484:	85 d2                	test   %edx,%edx
  802486:	74 a1                	je     802429 <__umoddi3+0x65>
  802488:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80248b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80248e:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802491:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802494:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802497:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80249a:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80249d:	89 01                	mov    %eax,(%ecx)
  80249f:	89 51 04             	mov    %edx,0x4(%ecx)
  8024a2:	eb 85                	jmp    802429 <__umoddi3+0x65>
  8024a4:	85 f6                	test   %esi,%esi
  8024a6:	75 0b                	jne    8024b3 <__umoddi3+0xef>
  8024a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ad:	31 d2                	xor    %edx,%edx
  8024af:	f7 f6                	div    %esi
  8024b1:	89 c6                	mov    %eax,%esi
  8024b3:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8024b6:	89 fa                	mov    %edi,%edx
  8024b8:	f7 f6                	div    %esi
  8024ba:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8024bd:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8024c0:	f7 f6                	div    %esi
  8024c2:	e9 3d ff ff ff       	jmp    802404 <__umoddi3+0x40>
  8024c7:	90                   	nop    
  8024c8:	b8 20 00 00 00       	mov    $0x20,%eax
  8024cd:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  8024d0:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  8024d3:	89 fa                	mov    %edi,%edx
  8024d5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8024d8:	d3 e2                	shl    %cl,%edx
  8024da:	89 f0                	mov    %esi,%eax
  8024dc:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8024df:	d3 e8                	shr    %cl,%eax
  8024e1:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8024e4:	d3 e6                	shl    %cl,%esi
  8024e6:	89 d7                	mov    %edx,%edi
  8024e8:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8024eb:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8024ee:	09 c7                	or     %eax,%edi
  8024f0:	d3 ea                	shr    %cl,%edx
  8024f2:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8024f5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8024f8:	d3 e0                	shl    %cl,%eax
  8024fa:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8024fd:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802500:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802503:	d3 e8                	shr    %cl,%eax
  802505:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802508:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80250b:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80250e:	f7 f7                	div    %edi
  802510:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802513:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802516:	f7 e6                	mul    %esi
  802518:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  80251b:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  80251e:	77 0a                	ja     80252a <__umoddi3+0x166>
  802520:	75 12                	jne    802534 <__umoddi3+0x170>
  802522:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802525:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802528:	76 0a                	jbe    802534 <__umoddi3+0x170>
  80252a:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  80252d:	29 f1                	sub    %esi,%ecx
  80252f:	19 fa                	sbb    %edi,%edx
  802531:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802534:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	0f 84 ea fe ff ff    	je     802429 <__umoddi3+0x65>
  80253f:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802542:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802545:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802548:	19 d1                	sbb    %edx,%ecx
  80254a:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  80254d:	89 ca                	mov    %ecx,%edx
  80254f:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802552:	d3 e2                	shl    %cl,%edx
  802554:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802557:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80255a:	d3 e8                	shr    %cl,%eax
  80255c:	09 c2                	or     %eax,%edx
  80255e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802561:	d3 e8                	shr    %cl,%eax
  802563:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802566:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802569:	e9 ad fe ff ff       	jmp    80241b <__umoddi3+0x57>
