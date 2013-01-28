
obj/user/testfdsharing:     file format elf32-i386

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
  80002c:	e8 13 03 00 00       	call   800344 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
char buf[512], buf2[512];

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003d:	6a 00                	push   $0x0
  80003f:	68 ec 2b 80 00       	push   $0x802bec
  800044:	e8 c7 1a 00 00       	call   801b10 <open>
  800049:	89 c3                	mov    %eax,%ebx
  80004b:	83 c4 10             	add    $0x10,%esp
  80004e:	85 c0                	test   %eax,%eax
  800050:	79 12                	jns    800064 <umain+0x30>
		panic("open motd: %e", fd);
  800052:	50                   	push   %eax
  800053:	68 80 2b 80 00       	push   $0x802b80
  800058:	6a 0c                	push   $0xc
  80005a:	68 8e 2b 80 00       	push   $0x802b8e
  80005f:	e8 3c 03 00 00       	call   8003a0 <_panic>
	seek(fd, 0);
  800064:	83 ec 08             	sub    $0x8,%esp
  800067:	6a 00                	push   $0x0
  800069:	50                   	push   %eax
  80006a:	e8 68 19 00 00       	call   8019d7 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	68 00 02 00 00       	push   $0x200
  800077:	68 80 72 80 00       	push   $0x807280
  80007c:	53                   	push   %ebx
  80007d:	e8 83 18 00 00       	call   801905 <readn>
  800082:	89 c6                	mov    %eax,%esi
  800084:	83 c4 10             	add    $0x10,%esp
  800087:	85 c0                	test   %eax,%eax
  800089:	7f 12                	jg     80009d <umain+0x69>
		panic("readn: %e", n);
  80008b:	50                   	push   %eax
  80008c:	68 a3 2b 80 00       	push   $0x802ba3
  800091:	6a 0f                	push   $0xf
  800093:	68 8e 2b 80 00       	push   $0x802b8e
  800098:	e8 03 03 00 00       	call   8003a0 <_panic>

	if ((r = fork()) < 0)
  80009d:	e8 34 13 00 00       	call   8013d6 <fork>
  8000a2:	89 c7                	mov    %eax,%edi
  8000a4:	85 c0                	test   %eax,%eax
  8000a6:	79 12                	jns    8000ba <umain+0x86>
		panic("fork: %e", r);
  8000a8:	50                   	push   %eax
  8000a9:	68 ad 2b 80 00       	push   $0x802bad
  8000ae:	6a 12                	push   $0x12
  8000b0:	68 8e 2b 80 00       	push   $0x802b8e
  8000b5:	e8 e6 02 00 00       	call   8003a0 <_panic>
	if (r == 0) {
  8000ba:	85 c0                	test   %eax,%eax
  8000bc:	0f 85 9d 00 00 00    	jne    80015f <umain+0x12b>
		seek(fd, 0);
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	6a 00                	push   $0x0
  8000c7:	53                   	push   %ebx
  8000c8:	e8 0a 19 00 00       	call   8019d7 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000cd:	c7 04 24 60 2c 80 00 	movl   $0x802c60,(%esp)
  8000d4:	e8 b7 03 00 00       	call   800490 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000d9:	83 c4 0c             	add    $0xc,%esp
  8000dc:	68 00 02 00 00       	push   $0x200
  8000e1:	68 80 70 80 00       	push   $0x807080
  8000e6:	53                   	push   %ebx
  8000e7:	e8 19 18 00 00       	call   801905 <readn>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	39 f0                	cmp    %esi,%eax
  8000f1:	74 16                	je     800109 <umain+0xd5>
			panic("read in parent got %d, read in child got %d", n, n2);
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	50                   	push   %eax
  8000f7:	56                   	push   %esi
  8000f8:	68 a4 2c 80 00       	push   $0x802ca4
  8000fd:	6a 17                	push   $0x17
  8000ff:	68 8e 2b 80 00       	push   $0x802b8e
  800104:	e8 97 02 00 00       	call   8003a0 <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	56                   	push   %esi
  80010d:	68 80 70 80 00       	push   $0x807080
  800112:	68 80 72 80 00       	push   $0x807280
  800117:	e8 72 0b 00 00       	call   800c8e <memcmp>
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	85 c0                	test   %eax,%eax
  800121:	74 14                	je     800137 <umain+0x103>
			panic("read in parent got different bytes from read in child");
  800123:	83 ec 04             	sub    $0x4,%esp
  800126:	68 d0 2c 80 00       	push   $0x802cd0
  80012b:	6a 19                	push   $0x19
  80012d:	68 8e 2b 80 00       	push   $0x802b8e
  800132:	e8 69 02 00 00       	call   8003a0 <_panic>
		cprintf("read in child succeeded\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 b6 2b 80 00       	push   $0x802bb6
  80013f:	e8 4c 03 00 00       	call   800490 <cprintf>
		seek(fd, 0);
  800144:	83 c4 08             	add    $0x8,%esp
  800147:	6a 00                	push   $0x0
  800149:	53                   	push   %ebx
  80014a:	e8 88 18 00 00       	call   8019d7 <seek>
		close(fd);
  80014f:	89 1c 24             	mov    %ebx,(%esp)
  800152:	e8 ab 15 00 00       	call   801702 <close>
		exit();
  800157:	e8 2c 02 00 00       	call   800388 <exit>
  80015c:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	57                   	push   %edi
  800163:	e8 ac 23 00 00       	call   802514 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800168:	83 c4 0c             	add    $0xc,%esp
  80016b:	68 00 02 00 00       	push   $0x200
  800170:	68 80 70 80 00       	push   $0x807080
  800175:	53                   	push   %ebx
  800176:	e8 8a 17 00 00       	call   801905 <readn>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	39 f0                	cmp    %esi,%eax
  800180:	74 16                	je     800198 <umain+0x164>
		panic("read in parent got %d, then got %d", n, n2);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	56                   	push   %esi
  800187:	68 08 2d 80 00       	push   $0x802d08
  80018c:	6a 21                	push   $0x21
  80018e:	68 8e 2b 80 00       	push   $0x802b8e
  800193:	e8 08 02 00 00       	call   8003a0 <_panic>
	cprintf("read in parent succeeded\n");		
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	68 cf 2b 80 00       	push   $0x802bcf
  8001a0:	e8 eb 02 00 00       	call   800490 <cprintf>
	close(fd);
  8001a5:	89 1c 24             	mov    %ebx,(%esp)
  8001a8:	e8 55 15 00 00       	call   801702 <close>

	if ((fd = open("newmotd", O_RDWR)) < 0)
  8001ad:	83 c4 08             	add    $0x8,%esp
  8001b0:	6a 02                	push   $0x2
  8001b2:	68 e9 2b 80 00       	push   $0x802be9
  8001b7:	e8 54 19 00 00       	call   801b10 <open>
  8001bc:	89 c3                	mov    %eax,%ebx
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	85 c0                	test   %eax,%eax
  8001c3:	79 12                	jns    8001d7 <umain+0x1a3>
		panic("open newmotd: %e", fd);
  8001c5:	50                   	push   %eax
  8001c6:	68 f1 2b 80 00       	push   $0x802bf1
  8001cb:	6a 26                	push   $0x26
  8001cd:	68 8e 2b 80 00       	push   $0x802b8e
  8001d2:	e8 c9 01 00 00       	call   8003a0 <_panic>
	seek(fd, 0);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	6a 00                	push   $0x0
  8001dc:	50                   	push   %eax
  8001dd:	e8 f5 17 00 00       	call   8019d7 <seek>
	if ((n = write(fd, "hello", 5)) != 5)
  8001e2:	83 c4 0c             	add    $0xc,%esp
  8001e5:	6a 05                	push   $0x5
  8001e7:	68 02 2c 80 00       	push   $0x802c02
  8001ec:	53                   	push   %ebx
  8001ed:	e8 5a 17 00 00       	call   80194c <write>
  8001f2:	83 c4 10             	add    $0x10,%esp
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	74 12                	je     80020c <umain+0x1d8>
		panic("write: %e", n);
  8001fa:	50                   	push   %eax
  8001fb:	68 08 2c 80 00       	push   $0x802c08
  800200:	6a 29                	push   $0x29
  800202:	68 8e 2b 80 00       	push   $0x802b8e
  800207:	e8 94 01 00 00       	call   8003a0 <_panic>

	if ((r = fork()) < 0)
  80020c:	e8 c5 11 00 00       	call   8013d6 <fork>
  800211:	89 c7                	mov    %eax,%edi
  800213:	85 c0                	test   %eax,%eax
  800215:	79 12                	jns    800229 <umain+0x1f5>
		panic("fork: %e", r);
  800217:	50                   	push   %eax
  800218:	68 ad 2b 80 00       	push   $0x802bad
  80021d:	6a 2c                	push   $0x2c
  80021f:	68 8e 2b 80 00       	push   $0x802b8e
  800224:	e8 77 01 00 00       	call   8003a0 <_panic>
	if (r == 0) {
  800229:	85 c0                	test   %eax,%eax
  80022b:	75 5e                	jne    80028b <umain+0x257>
		seek(fd, 0);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	6a 00                	push   $0x0
  800232:	53                   	push   %ebx
  800233:	e8 9f 17 00 00       	call   8019d7 <seek>
		cprintf("going to write in child\n");
  800238:	c7 04 24 12 2c 80 00 	movl   $0x802c12,(%esp)
  80023f:	e8 4c 02 00 00       	call   800490 <cprintf>
		if ((n = write(fd, "world", 5)) != 5)
  800244:	83 c4 0c             	add    $0xc,%esp
  800247:	6a 05                	push   $0x5
  800249:	68 2b 2c 80 00       	push   $0x802c2b
  80024e:	53                   	push   %ebx
  80024f:	e8 f8 16 00 00       	call   80194c <write>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	83 f8 05             	cmp    $0x5,%eax
  80025a:	74 12                	je     80026e <umain+0x23a>
			panic("write in child: %e", n);
  80025c:	50                   	push   %eax
  80025d:	68 31 2c 80 00       	push   $0x802c31
  800262:	6a 31                	push   $0x31
  800264:	68 8e 2b 80 00       	push   $0x802b8e
  800269:	e8 32 01 00 00       	call   8003a0 <_panic>
		cprintf("write in child finished\n");
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	68 44 2c 80 00       	push   $0x802c44
  800276:	e8 15 02 00 00       	call   800490 <cprintf>
		close(fd);
  80027b:	89 1c 24             	mov    %ebx,(%esp)
  80027e:	e8 7f 14 00 00       	call   801702 <close>
		exit();
  800283:	e8 00 01 00 00       	call   800388 <exit>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	57                   	push   %edi
  80028f:	e8 80 22 00 00       	call   802514 <wait>
	seek(fd, 0);
  800294:	83 c4 08             	add    $0x8,%esp
  800297:	6a 00                	push   $0x0
  800299:	53                   	push   %ebx
  80029a:	e8 38 17 00 00       	call   8019d7 <seek>
	if ((n = readn(fd, buf, 5)) != 5)
  80029f:	83 c4 0c             	add    $0xc,%esp
  8002a2:	6a 05                	push   $0x5
  8002a4:	68 80 72 80 00       	push   $0x807280
  8002a9:	53                   	push   %ebx
  8002aa:	e8 56 16 00 00       	call   801905 <readn>
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	83 f8 05             	cmp    $0x5,%eax
  8002b5:	74 12                	je     8002c9 <umain+0x295>
		panic("readn: %e", n);
  8002b7:	50                   	push   %eax
  8002b8:	68 a3 2b 80 00       	push   $0x802ba3
  8002bd:	6a 39                	push   $0x39
  8002bf:	68 8e 2b 80 00       	push   $0x802b8e
  8002c4:	e8 d7 00 00 00       	call   8003a0 <_panic>
	buf[5] = 0;
  8002c9:	c6 05 85 72 80 00 00 	movb   $0x0,0x807285
	if (strcmp(buf, "hello") == 0)
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	68 02 2c 80 00       	push   $0x802c02
  8002d8:	68 80 72 80 00       	push   $0x807280
  8002dd:	e8 33 08 00 00       	call   800b15 <strcmp>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	75 12                	jne    8002fb <umain+0x2c7>
		cprintf("write to file data page failed; got old data\n");
  8002e9:	83 ec 0c             	sub    $0xc,%esp
  8002ec:	68 2c 2d 80 00       	push   $0x802d2c
  8002f1:	e8 9a 01 00 00       	call   800490 <cprintf>
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	eb 40                	jmp    80033b <umain+0x307>
	else if (strcmp(buf, "world") == 0)
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	68 2b 2c 80 00       	push   $0x802c2b
  800303:	68 80 72 80 00       	push   $0x807280
  800308:	e8 08 08 00 00       	call   800b15 <strcmp>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	85 c0                	test   %eax,%eax
  800312:	75 12                	jne    800326 <umain+0x2f2>
		cprintf("write to file data page succeeded\n");
  800314:	83 ec 0c             	sub    $0xc,%esp
  800317:	68 5c 2d 80 00       	push   $0x802d5c
  80031c:	e8 6f 01 00 00       	call   800490 <cprintf>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	eb 15                	jmp    80033b <umain+0x307>
	else
		cprintf("write to file data page failed; got %s\n", buf);
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	68 80 72 80 00       	push   $0x807280
  80032e:	68 80 2d 80 00       	push   $0x802d80
  800333:	e8 58 01 00 00       	call   800490 <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  80033b:	cc                   	int3   

	breakpoint();
}
  80033c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80033f:	5b                   	pop    %ebx
  800340:	5e                   	pop    %esi
  800341:	5f                   	pop    %edi
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	56                   	push   %esi
  800348:	53                   	push   %ebx
  800349:	8b 75 08             	mov    0x8(%ebp),%esi
  80034c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  80034f:	e8 d4 0a 00 00       	call   800e28 <sys_getenvid>
  800354:	25 ff 03 00 00       	and    $0x3ff,%eax
  800359:	c1 e0 07             	shl    $0x7,%eax
  80035c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800361:	a3 80 74 80 00       	mov    %eax,0x807480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800366:	85 f6                	test   %esi,%esi
  800368:	7e 07                	jle    800371 <libmain+0x2d>
		binaryname = argv[0];
  80036a:	8b 03                	mov    (%ebx),%eax
  80036c:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	53                   	push   %ebx
  800375:	56                   	push   %esi
  800376:	e8 b9 fc ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80037b:	e8 08 00 00 00       	call   800388 <exit>
}
  800380:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	c9                   	leave  
  800386:	c3                   	ret    
	...

00800388 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80038e:	e8 9d 13 00 00       	call   801730 <close_all>
	sys_env_destroy(0);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	6a 00                	push   $0x0
  800398:	e8 4a 0a 00 00       	call   800de7 <sys_env_destroy>
}
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    
	...

008003a0 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	53                   	push   %ebx
  8003a4:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8003aa:	83 3d 84 74 80 00 00 	cmpl   $0x0,0x807484
  8003b1:	74 16                	je     8003c9 <_panic+0x29>
		cprintf("%s: ", argv0);
  8003b3:	83 ec 08             	sub    $0x8,%esp
  8003b6:	ff 35 84 74 80 00    	pushl  0x807484
  8003bc:	68 bf 2d 80 00       	push   $0x802dbf
  8003c1:	e8 ca 00 00 00       	call   800490 <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c9:	ff 75 0c             	pushl  0xc(%ebp)
  8003cc:	ff 75 08             	pushl  0x8(%ebp)
  8003cf:	ff 35 00 70 80 00    	pushl  0x807000
  8003d5:	68 c4 2d 80 00       	push   $0x802dc4
  8003da:	e8 b1 00 00 00       	call   800490 <cprintf>
	vcprintf(fmt, ap);
  8003df:	83 c4 08             	add    $0x8,%esp
  8003e2:	53                   	push   %ebx
  8003e3:	ff 75 10             	pushl  0x10(%ebp)
  8003e6:	e8 54 00 00 00       	call   80043f <vcprintf>
	cprintf("\n");
  8003eb:	c7 04 24 cd 2b 80 00 	movl   $0x802bcd,(%esp)
  8003f2:	e8 99 00 00 00       	call   800490 <cprintf>

	// Cause a breakpoint exception
	while (1)
  8003f7:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8003fa:	cc                   	int3   
  8003fb:	eb fd                	jmp    8003fa <_panic+0x5a>
  8003fd:	00 00                	add    %al,(%eax)
	...

00800400 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	53                   	push   %ebx
  800404:	83 ec 04             	sub    $0x4,%esp
  800407:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80040a:	8b 03                	mov    (%ebx),%eax
  80040c:	8b 55 08             	mov    0x8(%ebp),%edx
  80040f:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  800413:	40                   	inc    %eax
  800414:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800416:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041b:	75 1a                	jne    800437 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	68 ff 00 00 00       	push   $0xff
  800425:	8d 43 08             	lea    0x8(%ebx),%eax
  800428:	50                   	push   %eax
  800429:	e8 76 09 00 00       	call   800da4 <sys_cputs>
		b->idx = 0;
  80042e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800434:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800437:	ff 43 04             	incl   0x4(%ebx)
}
  80043a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80043d:	c9                   	leave  
  80043e:	c3                   	ret    

0080043f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800448:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80044f:	00 00 00 
	b.cnt = 0;
  800452:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800459:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80045c:	ff 75 0c             	pushl  0xc(%ebp)
  80045f:	ff 75 08             	pushl  0x8(%ebp)
  800462:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800468:	50                   	push   %eax
  800469:	68 00 04 80 00       	push   $0x800400
  80046e:	e8 4f 01 00 00       	call   8005c2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800473:	83 c4 08             	add    $0x8,%esp
  800476:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  80047c:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  800482:	50                   	push   %eax
  800483:	e8 1c 09 00 00       	call   800da4 <sys_cputs>

	return b.cnt;
  800488:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800496:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800499:	50                   	push   %eax
  80049a:	ff 75 08             	pushl  0x8(%ebp)
  80049d:	e8 9d ff ff ff       	call   80043f <vcprintf>
	va_end(ap);

	return cnt;
}
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	57                   	push   %edi
  8004a8:	56                   	push   %esi
  8004a9:	53                   	push   %ebx
  8004aa:	83 ec 0c             	sub    $0xc,%esp
  8004ad:	8b 75 10             	mov    0x10(%ebp),%esi
  8004b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8004b3:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004be:	39 fa                	cmp    %edi,%edx
  8004c0:	77 39                	ja     8004fb <printnum+0x57>
  8004c2:	72 04                	jb     8004c8 <printnum+0x24>
  8004c4:	39 f0                	cmp    %esi,%eax
  8004c6:	77 33                	ja     8004fb <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 20             	pushl  0x20(%ebp)
  8004ce:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8004d1:	50                   	push   %eax
  8004d2:	ff 75 18             	pushl  0x18(%ebp)
  8004d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dd:	52                   	push   %edx
  8004de:	50                   	push   %eax
  8004df:	57                   	push   %edi
  8004e0:	56                   	push   %esi
  8004e1:	e8 d6 23 00 00       	call   8028bc <__udivdi3>
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	52                   	push   %edx
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	ff 75 08             	pushl  0x8(%ebp)
  8004f1:	e8 ae ff ff ff       	call   8004a4 <printnum>
  8004f6:	83 c4 20             	add    $0x20,%esp
  8004f9:	eb 19                	jmp    800514 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004fb:	4b                   	dec    %ebx
  8004fc:	85 db                	test   %ebx,%ebx
  8004fe:	7e 14                	jle    800514 <printnum+0x70>
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 20             	pushl  0x20(%ebp)
  800509:	ff 55 08             	call   *0x8(%ebp)
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	4b                   	dec    %ebx
  800510:	85 db                	test   %ebx,%ebx
  800512:	7f ec                	jg     800500 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	ff 75 0c             	pushl  0xc(%ebp)
  80051a:	8b 45 18             	mov    0x18(%ebp),%eax
  80051d:	ba 00 00 00 00       	mov    $0x0,%edx
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	52                   	push   %edx
  800526:	50                   	push   %eax
  800527:	57                   	push   %edi
  800528:	56                   	push   %esi
  800529:	e8 9a 24 00 00       	call   8029c8 <__umoddi3>
  80052e:	83 c4 14             	add    $0x14,%esp
  800531:	0f be 80 da 2e 80 00 	movsbl 0x802eda(%eax),%eax
  800538:	50                   	push   %eax
  800539:	ff 55 08             	call   *0x8(%ebp)
}
  80053c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80053f:	5b                   	pop    %ebx
  800540:	5e                   	pop    %esi
  800541:	5f                   	pop    %edi
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80054a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80054d:	83 f8 01             	cmp    $0x1,%eax
  800550:	7e 0f                	jle    800561 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800552:	8b 01                	mov    (%ecx),%eax
  800554:	83 c0 08             	add    $0x8,%eax
  800557:	89 01                	mov    %eax,(%ecx)
  800559:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80055c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80055f:	eb 24                	jmp    800585 <getuint+0x41>
	else if (lflag)
  800561:	85 c0                	test   %eax,%eax
  800563:	74 11                	je     800576 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800565:	8b 01                	mov    (%ecx),%eax
  800567:	83 c0 04             	add    $0x4,%eax
  80056a:	89 01                	mov    %eax,(%ecx)
  80056c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80056f:	ba 00 00 00 00       	mov    $0x0,%edx
  800574:	eb 0f                	jmp    800585 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800576:	8b 01                	mov    (%ecx),%eax
  800578:	83 c0 04             	add    $0x4,%eax
  80057b:	89 01                	mov    %eax,(%ecx)
  80057d:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800580:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	8b 55 08             	mov    0x8(%ebp),%edx
  80058d:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800590:	83 f8 01             	cmp    $0x1,%eax
  800593:	7e 0f                	jle    8005a4 <getint+0x1d>
		return va_arg(*ap, long long);
  800595:	8b 02                	mov    (%edx),%eax
  800597:	83 c0 08             	add    $0x8,%eax
  80059a:	89 02                	mov    %eax,(%edx)
  80059c:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80059f:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8005a2:	eb 1c                	jmp    8005c0 <getint+0x39>
	else if (lflag)
  8005a4:	85 c0                	test   %eax,%eax
  8005a6:	74 0d                	je     8005b5 <getint+0x2e>
		return va_arg(*ap, long);
  8005a8:	8b 02                	mov    (%edx),%eax
  8005aa:	83 c0 04             	add    $0x4,%eax
  8005ad:	89 02                	mov    %eax,(%edx)
  8005af:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8005b2:	99                   	cltd   
  8005b3:	eb 0b                	jmp    8005c0 <getint+0x39>
	else
		return va_arg(*ap, int);
  8005b5:	8b 02                	mov    (%edx),%eax
  8005b7:	83 c0 04             	add    $0x4,%eax
  8005ba:	89 02                	mov    %eax,(%edx)
  8005bc:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8005bf:	99                   	cltd   
}
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	57                   	push   %edi
  8005c6:	56                   	push   %esi
  8005c7:	53                   	push   %ebx
  8005c8:	83 ec 1c             	sub    $0x1c,%esp
  8005cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8005ce:	0f b6 13             	movzbl (%ebx),%edx
  8005d1:	43                   	inc    %ebx
  8005d2:	83 fa 25             	cmp    $0x25,%edx
  8005d5:	74 1e                	je     8005f5 <vprintfmt+0x33>
  8005d7:	85 d2                	test   %edx,%edx
  8005d9:	0f 84 d7 02 00 00    	je     8008b6 <vprintfmt+0x2f4>
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	ff 55 08             	call   *0x8(%ebp)
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	0f b6 13             	movzbl (%ebx),%edx
  8005ef:	43                   	inc    %ebx
  8005f0:	83 fa 25             	cmp    $0x25,%edx
  8005f3:	75 e2                	jne    8005d7 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8005f5:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8005f9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800600:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800605:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  80060a:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800611:	0f b6 13             	movzbl (%ebx),%edx
  800614:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800617:	43                   	inc    %ebx
  800618:	83 f8 55             	cmp    $0x55,%eax
  80061b:	0f 87 70 02 00 00    	ja     800891 <vprintfmt+0x2cf>
  800621:	ff 24 85 5c 2f 80 00 	jmp    *0x802f5c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800628:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  80062c:	eb e3                	jmp    800611 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80062e:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  800632:	eb dd                	jmp    800611 <vprintfmt+0x4f>

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
  800634:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800639:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  80063c:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800640:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800643:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800646:	83 f8 09             	cmp    $0x9,%eax
  800649:	77 27                	ja     800672 <vprintfmt+0xb0>
  80064b:	43                   	inc    %ebx
  80064c:	eb eb                	jmp    800639 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80064e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800658:	eb 18                	jmp    800672 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80065a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80065e:	79 b1                	jns    800611 <vprintfmt+0x4f>
				width = 0;
  800660:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800667:	eb a8                	jmp    800611 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800669:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800670:	eb 9f                	jmp    800611 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  800672:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800676:	79 99                	jns    800611 <vprintfmt+0x4f>
				width = precision, precision = -1;
  800678:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80067b:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  800680:	eb 8f                	jmp    800611 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800682:	41                   	inc    %ecx
			goto reswitch;
  800683:	eb 8c                	jmp    800611 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 0c             	pushl  0xc(%ebp)
  80068b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800695:	ff 55 08             	call   *0x8(%ebp)
			break;
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	e9 2e ff ff ff       	jmp    8005ce <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006a0:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8006aa:	85 c0                	test   %eax,%eax
  8006ac:	79 02                	jns    8006b0 <vprintfmt+0xee>
				err = -err;
  8006ae:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006b0:	83 f8 0e             	cmp    $0xe,%eax
  8006b3:	7f 0b                	jg     8006c0 <vprintfmt+0xfe>
  8006b5:	8b 3c 85 20 2f 80 00 	mov    0x802f20(,%eax,4),%edi
  8006bc:	85 ff                	test   %edi,%edi
  8006be:	75 19                	jne    8006d9 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8006c0:	50                   	push   %eax
  8006c1:	68 eb 2e 80 00       	push   $0x802eeb
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	ff 75 08             	pushl  0x8(%ebp)
  8006cc:	e8 ed 01 00 00       	call   8008be <printfmt>
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	e9 f5 fe ff ff       	jmp    8005ce <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8006d9:	57                   	push   %edi
  8006da:	68 61 33 80 00       	push   $0x803361
  8006df:	ff 75 0c             	pushl  0xc(%ebp)
  8006e2:	ff 75 08             	pushl  0x8(%ebp)
  8006e5:	e8 d4 01 00 00       	call   8008be <printfmt>
  8006ea:	83 c4 10             	add    $0x10,%esp
			break;
  8006ed:	e9 dc fe ff ff       	jmp    8005ce <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006f2:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8006fc:	85 ff                	test   %edi,%edi
  8006fe:	75 05                	jne    800705 <vprintfmt+0x143>
				p = "(null)";
  800700:	bf f4 2e 80 00       	mov    $0x802ef4,%edi
			if (width > 0 && padc != '-')
  800705:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800709:	7e 3b                	jle    800746 <vprintfmt+0x184>
  80070b:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80070f:	74 35                	je     800746 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	56                   	push   %esi
  800715:	57                   	push   %edi
  800716:	e8 56 03 00 00       	call   800a71 <strnlen>
  80071b:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800725:	7e 1f                	jle    800746 <vprintfmt+0x184>
  800727:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800737:	ff 55 08             	call   *0x8(%ebp)
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800740:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800744:	7f e8                	jg     80072e <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800746:	0f be 17             	movsbl (%edi),%edx
  800749:	47                   	inc    %edi
  80074a:	85 d2                	test   %edx,%edx
  80074c:	74 44                	je     800792 <vprintfmt+0x1d0>
  80074e:	85 f6                	test   %esi,%esi
  800750:	78 03                	js     800755 <vprintfmt+0x193>
  800752:	4e                   	dec    %esi
  800753:	78 3d                	js     800792 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800755:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800759:	74 18                	je     800773 <vprintfmt+0x1b1>
  80075b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80075e:	83 f8 5e             	cmp    $0x5e,%eax
  800761:	76 10                	jbe    800773 <vprintfmt+0x1b1>
					putch('?', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	6a 3f                	push   $0x3f
  80076b:	ff 55 08             	call   *0x8(%ebp)
  80076e:	83 c4 10             	add    $0x10,%esp
  800771:	eb 0d                	jmp    800780 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	52                   	push   %edx
  80077a:	ff 55 08             	call   *0x8(%ebp)
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800783:	0f be 17             	movsbl (%edi),%edx
  800786:	47                   	inc    %edi
  800787:	85 d2                	test   %edx,%edx
  800789:	74 07                	je     800792 <vprintfmt+0x1d0>
  80078b:	85 f6                	test   %esi,%esi
  80078d:	78 c6                	js     800755 <vprintfmt+0x193>
  80078f:	4e                   	dec    %esi
  800790:	79 c3                	jns    800755 <vprintfmt+0x193>
			for (; width > 0; width--)
  800792:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800796:	0f 8e 32 fe ff ff    	jle    8005ce <vprintfmt+0xc>
				putch(' ', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 20                	push   $0x20
  8007a4:	ff 55 08             	call   *0x8(%ebp)
  8007a7:	83 c4 10             	add    $0x10,%esp
  8007aa:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8007ad:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8007b1:	7f e9                	jg     80079c <vprintfmt+0x1da>
			break;
  8007b3:	e9 16 fe ff ff       	jmp    8005ce <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007b8:	51                   	push   %ecx
  8007b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	e8 c5 fd ff ff       	call   800587 <getint>
  8007c2:	89 c6                	mov    %eax,%esi
  8007c4:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8007c6:	83 c4 08             	add    $0x8,%esp
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 15                	jns    8007e2 <vprintfmt+0x220>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007d8:	f7 de                	neg    %esi
  8007da:	83 d7 00             	adc    $0x0,%edi
  8007dd:	f7 df                	neg    %edi
  8007df:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8007e2:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8007e7:	eb 75                	jmp    80085e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e9:	51                   	push   %ecx
  8007ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ed:	50                   	push   %eax
  8007ee:	e8 51 fd ff ff       	call   800544 <getuint>
  8007f3:	89 c6                	mov    %eax,%esi
  8007f5:	89 d7                	mov    %edx,%edi
			base = 10;
  8007f7:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8007fc:	83 c4 08             	add    $0x8,%esp
  8007ff:	eb 5d                	jmp    80085e <vprintfmt+0x29c>

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
  800801:	51                   	push   %ecx
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 39 fd ff ff       	call   800544 <getuint>
  80080b:	89 c6                	mov    %eax,%esi
  80080d:	89 d7                	mov    %edx,%edi
			base = 8;
  80080f:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800814:	83 c4 08             	add    $0x8,%esp
  800817:	eb 45                	jmp    80085e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	6a 30                	push   $0x30
  800821:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800824:	83 c4 08             	add    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	6a 78                	push   $0x78
  80082c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80082f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800839:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80083e:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	eb 16                	jmp    80085e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800848:	51                   	push   %ecx
  800849:	8d 45 14             	lea    0x14(%ebp),%eax
  80084c:	50                   	push   %eax
  80084d:	e8 f2 fc ff ff       	call   800544 <getuint>
  800852:	89 c6                	mov    %eax,%esi
  800854:	89 d7                	mov    %edx,%edi
			base = 16;
  800856:	ba 10 00 00 00       	mov    $0x10,%edx
  80085b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800869:	52                   	push   %edx
  80086a:	57                   	push   %edi
  80086b:	56                   	push   %esi
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	ff 75 08             	pushl  0x8(%ebp)
  800872:	e8 2d fc ff ff       	call   8004a4 <printnum>
			break;
  800877:	83 c4 20             	add    $0x20,%esp
  80087a:	e9 4f fd ff ff       	jmp    8005ce <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	ff 75 0c             	pushl  0xc(%ebp)
  800885:	52                   	push   %edx
  800886:	ff 55 08             	call   *0x8(%ebp)
			break;
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	e9 3d fd ff ff       	jmp    8005ce <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	6a 25                	push   $0x25
  800899:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089c:	4b                   	dec    %ebx
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8008a4:	0f 84 24 fd ff ff    	je     8005ce <vprintfmt+0xc>
  8008aa:	4b                   	dec    %ebx
  8008ab:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8008af:	75 f9                	jne    8008aa <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8008b1:	e9 18 fd ff ff       	jmp    8005ce <vprintfmt+0xc>
		}
	}
}
  8008b6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5f                   	pop    %edi
  8008bc:	c9                   	leave  
  8008bd:	c3                   	ret    

008008be <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 10             	pushl  0x10(%ebp)
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 ec fc ff ff       	call   8005c2 <vprintfmt>
	va_end(ap);
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8008de:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  8008e1:	8b 0a                	mov    (%edx),%ecx
  8008e3:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8008e6:	73 07                	jae    8008ef <sprintputch+0x17>
		*b->buf++ = ch;
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	88 01                	mov    %al,(%ecx)
  8008ed:	ff 02                	incl   (%edx)
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    

008008f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
  8008f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8008fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fd:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800900:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800904:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800907:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80090e:	85 d2                	test   %edx,%edx
  800910:	74 04                	je     800916 <vsnprintf+0x25>
  800912:	85 c9                	test   %ecx,%ecx
  800914:	7f 07                	jg     80091d <vsnprintf+0x2c>
		return -E_INVAL;
  800916:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80091b:	eb 1d                	jmp    80093a <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80091d:	ff 75 14             	pushl  0x14(%ebp)
  800920:	ff 75 10             	pushl  0x10(%ebp)
  800923:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800926:	50                   	push   %eax
  800927:	68 d8 08 80 00       	push   $0x8008d8
  80092c:	e8 91 fc ff ff       	call   8005c2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800931:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800934:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800937:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800942:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800945:	50                   	push   %eax
  800946:	ff 75 10             	pushl  0x10(%ebp)
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	ff 75 08             	pushl  0x8(%ebp)
  80094f:	e8 9d ff ff ff       	call   8008f1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    
	...

00800958 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	56                   	push   %esi
  80095c:	53                   	push   %ebx
  80095d:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800960:	83 ec 0c             	sub    $0xc,%esp
  800963:	56                   	push   %esi
  800964:	e8 ef 00 00 00       	call   800a58 <strlen>
  char letter;
  int hexnum = 0;
  800969:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80096e:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	89 c2                	mov    %eax,%edx
  800978:	4a                   	dec    %edx
  800979:	0f 88 d0 00 00 00    	js     800a4f <strtoint+0xf7>
    letter = string[cidx];
  80097f:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  800982:	85 d2                	test   %edx,%edx
  800984:	75 12                	jne    800998 <strtoint+0x40>
      if (letter != '0') {
  800986:	3c 30                	cmp    $0x30,%al
  800988:	0f 84 ba 00 00 00    	je     800a48 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80098e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800993:	e9 b9 00 00 00       	jmp    800a51 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800998:	83 fa 01             	cmp    $0x1,%edx
  80099b:	75 12                	jne    8009af <strtoint+0x57>
      if (letter != 'x') {
  80099d:	3c 78                	cmp    $0x78,%al
  80099f:	0f 84 a3 00 00 00    	je     800a48 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8009a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8009aa:	e9 a2 00 00 00       	jmp    800a51 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8009af:	0f be c0             	movsbl %al,%eax
  8009b2:	83 e8 30             	sub    $0x30,%eax
  8009b5:	83 f8 36             	cmp    $0x36,%eax
  8009b8:	0f 87 80 00 00 00    	ja     800a3e <strtoint+0xe6>
  8009be:	ff 24 85 b4 30 80 00 	jmp    *0x8030b4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8009c5:	01 cb                	add    %ecx,%ebx
          break;
  8009c7:	eb 7c                	jmp    800a45 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8009c9:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8009cc:	eb 77                	jmp    800a45 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8009ce:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009d1:	01 c3                	add    %eax,%ebx
          break;
  8009d3:	eb 70                	jmp    800a45 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8009d5:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8009d8:	eb 6b                	jmp    800a45 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8009da:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8009dd:	01 c3                	add    %eax,%ebx
          break;
  8009df:	eb 64                	jmp    800a45 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8009e1:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009e4:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8009e7:	eb 5c                	jmp    800a45 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8009e9:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8009f0:	29 c8                	sub    %ecx,%eax
  8009f2:	01 c3                	add    %eax,%ebx
          break;
  8009f4:	eb 4f                	jmp    800a45 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8009f6:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8009f9:	eb 4a                	jmp    800a45 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8009fb:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8009fe:	01 c3                	add    %eax,%ebx
          break;
  800a00:	eb 43                	jmp    800a45 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  800a02:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800a05:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a08:	eb 3b                	jmp    800a45 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800a0a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800a0d:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800a10:	01 c3                	add    %eax,%ebx
          break;
  800a12:	eb 31                	jmp    800a45 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800a14:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a17:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800a1a:	eb 29                	jmp    800a45 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800a1c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a1f:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800a22:	01 c3                	add    %eax,%ebx
          break;
  800a24:	eb 1f                	jmp    800a45 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800a26:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800a2d:	29 c8                	sub    %ecx,%eax
  800a2f:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a32:	eb 11                	jmp    800a45 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800a34:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a37:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a3a:	01 c3                	add    %eax,%ebx
          break;
  800a3c:	eb 07                	jmp    800a45 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  800a3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800a43:	eb 0c                	jmp    800a51 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800a45:	c1 e1 04             	shl    $0x4,%ecx
  800a48:	4a                   	dec    %edx
  800a49:	0f 89 30 ff ff ff    	jns    80097f <strtoint+0x27>
    }
  }

  return hexnum;
  800a4f:	89 d8                	mov    %ebx,%eax
}
  800a51:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800a54:	5b                   	pop    %ebx
  800a55:	5e                   	pop    %esi
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <strlen>:





int
strlen(const char *s)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a63:	80 3a 00             	cmpb   $0x0,(%edx)
  800a66:	74 07                	je     800a6f <strlen+0x17>
		n++;
  800a68:	40                   	inc    %eax
  800a69:	42                   	inc    %edx
  800a6a:	80 3a 00             	cmpb   $0x0,(%edx)
  800a6d:	75 f9                	jne    800a68 <strlen+0x10>
	return n;
}
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

00800a71 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a77:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7f:	85 d2                	test   %edx,%edx
  800a81:	74 0f                	je     800a92 <strnlen+0x21>
  800a83:	80 39 00             	cmpb   $0x0,(%ecx)
  800a86:	74 0a                	je     800a92 <strnlen+0x21>
		n++;
  800a88:	40                   	inc    %eax
  800a89:	41                   	inc    %ecx
  800a8a:	4a                   	dec    %edx
  800a8b:	74 05                	je     800a92 <strnlen+0x21>
  800a8d:	80 39 00             	cmpb   $0x0,(%ecx)
  800a90:	75 f6                	jne    800a88 <strnlen+0x17>
	return n;
}
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    

00800a94 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	53                   	push   %ebx
  800a98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800a9e:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800aa0:	8a 02                	mov    (%edx),%al
  800aa2:	42                   	inc    %edx
  800aa3:	88 01                	mov    %al,(%ecx)
  800aa5:	41                   	inc    %ecx
  800aa6:	84 c0                	test   %al,%al
  800aa8:	75 f6                	jne    800aa0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	5b                   	pop    %ebx
  800aad:	c9                   	leave  
  800aae:	c3                   	ret    

00800aaf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abb:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  800abe:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800ac0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac5:	39 f3                	cmp    %esi,%ebx
  800ac7:	73 10                	jae    800ad9 <strncpy+0x2a>
		*dst++ = *src;
  800ac9:	8a 02                	mov    (%edx),%al
  800acb:	88 01                	mov    %al,(%ecx)
  800acd:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ace:	80 3a 01             	cmpb   $0x1,(%edx)
  800ad1:	83 da ff             	sbb    $0xffffffff,%edx
  800ad4:	43                   	inc    %ebx
  800ad5:	39 f3                	cmp    %esi,%ebx
  800ad7:	72 f0                	jb     800ac9 <strncpy+0x1a>
	}
	return ret;
}
  800ad9:	89 f8                	mov    %edi,%eax
  800adb:	5b                   	pop    %ebx
  800adc:	5e                   	pop    %esi
  800add:	5f                   	pop    %edi
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	56                   	push   %esi
  800ae4:	53                   	push   %ebx
  800ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ae8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aeb:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  800aee:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800af0:	85 d2                	test   %edx,%edx
  800af2:	74 19                	je     800b0d <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800af4:	4a                   	dec    %edx
  800af5:	74 13                	je     800b0a <strlcpy+0x2a>
  800af7:	80 39 00             	cmpb   $0x0,(%ecx)
  800afa:	74 0e                	je     800b0a <strlcpy+0x2a>
  800afc:	8a 01                	mov    (%ecx),%al
  800afe:	41                   	inc    %ecx
  800aff:	88 03                	mov    %al,(%ebx)
  800b01:	43                   	inc    %ebx
  800b02:	4a                   	dec    %edx
  800b03:	74 05                	je     800b0a <strlcpy+0x2a>
  800b05:	80 39 00             	cmpb   $0x0,(%ecx)
  800b08:	75 f2                	jne    800afc <strlcpy+0x1c>
		*dst = '\0';
  800b0a:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800b0d:	89 d8                	mov    %ebx,%eax
  800b0f:	29 f0                	sub    %esi,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800b1e:	80 3a 00             	cmpb   $0x0,(%edx)
  800b21:	74 13                	je     800b36 <strcmp+0x21>
  800b23:	8a 02                	mov    (%edx),%al
  800b25:	3a 01                	cmp    (%ecx),%al
  800b27:	75 0d                	jne    800b36 <strcmp+0x21>
  800b29:	42                   	inc    %edx
  800b2a:	41                   	inc    %ecx
  800b2b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b2e:	74 06                	je     800b36 <strcmp+0x21>
  800b30:	8a 02                	mov    (%edx),%al
  800b32:	3a 01                	cmp    (%ecx),%al
  800b34:	74 f3                	je     800b29 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b36:	0f b6 02             	movzbl (%edx),%eax
  800b39:	0f b6 11             	movzbl (%ecx),%edx
  800b3c:	29 d0                	sub    %edx,%eax
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	53                   	push   %ebx
  800b44:	8b 55 08             	mov    0x8(%ebp),%edx
  800b47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800b4d:	85 c9                	test   %ecx,%ecx
  800b4f:	74 1f                	je     800b70 <strncmp+0x30>
  800b51:	80 3a 00             	cmpb   $0x0,(%edx)
  800b54:	74 16                	je     800b6c <strncmp+0x2c>
  800b56:	8a 02                	mov    (%edx),%al
  800b58:	3a 03                	cmp    (%ebx),%al
  800b5a:	75 10                	jne    800b6c <strncmp+0x2c>
  800b5c:	42                   	inc    %edx
  800b5d:	43                   	inc    %ebx
  800b5e:	49                   	dec    %ecx
  800b5f:	74 0f                	je     800b70 <strncmp+0x30>
  800b61:	80 3a 00             	cmpb   $0x0,(%edx)
  800b64:	74 06                	je     800b6c <strncmp+0x2c>
  800b66:	8a 02                	mov    (%edx),%al
  800b68:	3a 03                	cmp    (%ebx),%al
  800b6a:	74 f0                	je     800b5c <strncmp+0x1c>
	if (n == 0)
  800b6c:	85 c9                	test   %ecx,%ecx
  800b6e:	75 07                	jne    800b77 <strncmp+0x37>
		return 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
  800b75:	eb 0a                	jmp    800b81 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b77:	0f b6 12             	movzbl (%edx),%edx
  800b7a:	0f b6 03             	movzbl (%ebx),%eax
  800b7d:	29 c2                	sub    %eax,%edx
  800b7f:	89 d0                	mov    %edx,%eax
}
  800b81:	5b                   	pop    %ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800b8d:	80 38 00             	cmpb   $0x0,(%eax)
  800b90:	74 0a                	je     800b9c <strchr+0x18>
		if (*s == c)
  800b92:	38 10                	cmp    %dl,(%eax)
  800b94:	74 0b                	je     800ba1 <strchr+0x1d>
  800b96:	40                   	inc    %eax
  800b97:	80 38 00             	cmpb   $0x0,(%eax)
  800b9a:	75 f6                	jne    800b92 <strchr+0xe>
			return (char *) s;
	return 0;
  800b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800bac:	80 38 00             	cmpb   $0x0,(%eax)
  800baf:	74 0a                	je     800bbb <strfind+0x18>
		if (*s == c)
  800bb1:	38 10                	cmp    %dl,(%eax)
  800bb3:	74 06                	je     800bbb <strfind+0x18>
  800bb5:	40                   	inc    %eax
  800bb6:	80 38 00             	cmpb   $0x0,(%eax)
  800bb9:	75 f6                	jne    800bb1 <strfind+0xe>
			break;
	return (char *) s;
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	57                   	push   %edi
  800bc1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800bc7:	89 f8                	mov    %edi,%eax
  800bc9:	85 c9                	test   %ecx,%ecx
  800bcb:	74 40                	je     800c0d <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800bcd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bd3:	75 30                	jne    800c05 <memset+0x48>
  800bd5:	f6 c1 03             	test   $0x3,%cl
  800bd8:	75 2b                	jne    800c05 <memset+0x48>
		c &= 0xFF;
  800bda:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	c1 e0 18             	shl    $0x18,%eax
  800be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bea:	c1 e2 10             	shl    $0x10,%edx
  800bed:	09 d0                	or     %edx,%eax
  800bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf2:	c1 e2 08             	shl    $0x8,%edx
  800bf5:	09 d0                	or     %edx,%eax
  800bf7:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800bfa:	c1 e9 02             	shr    $0x2,%ecx
  800bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c00:	fc                   	cld    
  800c01:	f3 ab                	repz stos %eax,%es:(%edi)
  800c03:	eb 06                	jmp    800c0b <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	fc                   	cld    
  800c09:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800c0b:	89 f8                	mov    %edi,%eax
}
  800c0d:	5f                   	pop    %edi
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800c1b:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c1e:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c20:	39 c6                	cmp    %eax,%esi
  800c22:	73 33                	jae    800c57 <memmove+0x47>
  800c24:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c27:	39 c2                	cmp    %eax,%edx
  800c29:	76 2c                	jbe    800c57 <memmove+0x47>
		s += n;
  800c2b:	89 d6                	mov    %edx,%esi
		d += n;
  800c2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c30:	f6 c2 03             	test   $0x3,%dl
  800c33:	75 1b                	jne    800c50 <memmove+0x40>
  800c35:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c3b:	75 13                	jne    800c50 <memmove+0x40>
  800c3d:	f6 c1 03             	test   $0x3,%cl
  800c40:	75 0e                	jne    800c50 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800c42:	83 ef 04             	sub    $0x4,%edi
  800c45:	83 ee 04             	sub    $0x4,%esi
  800c48:	c1 e9 02             	shr    $0x2,%ecx
  800c4b:	fd                   	std    
  800c4c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800c4e:	eb 27                	jmp    800c77 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c50:	4f                   	dec    %edi
  800c51:	4e                   	dec    %esi
  800c52:	fd                   	std    
  800c53:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800c55:	eb 20                	jmp    800c77 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c57:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5d:	75 15                	jne    800c74 <memmove+0x64>
  800c5f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c65:	75 0d                	jne    800c74 <memmove+0x64>
  800c67:	f6 c1 03             	test   $0x3,%cl
  800c6a:	75 08                	jne    800c74 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800c6c:	c1 e9 02             	shr    $0x2,%ecx
  800c6f:	fc                   	cld    
  800c70:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800c72:	eb 03                	jmp    800c77 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c74:	fc                   	cld    
  800c75:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <memcpy>:

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
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c7e:	ff 75 10             	pushl  0x10(%ebp)
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	ff 75 08             	pushl  0x8(%ebp)
  800c87:	e8 84 ff ff ff       	call   800c10 <memmove>
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800c92:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800c95:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c98:	8b 55 10             	mov    0x10(%ebp),%edx
  800c9b:	4a                   	dec    %edx
  800c9c:	83 fa ff             	cmp    $0xffffffff,%edx
  800c9f:	74 1a                	je     800cbb <memcmp+0x2d>
  800ca1:	8a 01                	mov    (%ecx),%al
  800ca3:	3a 03                	cmp    (%ebx),%al
  800ca5:	74 0c                	je     800cb3 <memcmp+0x25>
  800ca7:	0f b6 d0             	movzbl %al,%edx
  800caa:	0f b6 03             	movzbl (%ebx),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
  800cb1:	eb 0d                	jmp    800cc0 <memcmp+0x32>
  800cb3:	41                   	inc    %ecx
  800cb4:	43                   	inc    %ebx
  800cb5:	4a                   	dec    %edx
  800cb6:	83 fa ff             	cmp    $0xffffffff,%edx
  800cb9:	75 e6                	jne    800ca1 <memcmp+0x13>
	}

	return 0;
  800cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc0:	5b                   	pop    %ebx
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cd1:	39 d0                	cmp    %edx,%eax
  800cd3:	73 09                	jae    800cde <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cd5:	38 08                	cmp    %cl,(%eax)
  800cd7:	74 05                	je     800cde <memfind+0x1b>
  800cd9:	40                   	inc    %eax
  800cda:	39 d0                	cmp    %edx,%eax
  800cdc:	72 f7                	jb     800cd5 <memfind+0x12>
			break;
	return (void *) s;
}
  800cde:	c9                   	leave  
  800cdf:	c3                   	ret    

00800ce0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800cef:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800cf4:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800cf9:	80 3a 20             	cmpb   $0x20,(%edx)
  800cfc:	74 05                	je     800d03 <strtol+0x23>
  800cfe:	80 3a 09             	cmpb   $0x9,(%edx)
  800d01:	75 0b                	jne    800d0e <strtol+0x2e>
  800d03:	42                   	inc    %edx
  800d04:	80 3a 20             	cmpb   $0x20,(%edx)
  800d07:	74 fa                	je     800d03 <strtol+0x23>
  800d09:	80 3a 09             	cmpb   $0x9,(%edx)
  800d0c:	74 f5                	je     800d03 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800d0e:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800d11:	75 03                	jne    800d16 <strtol+0x36>
		s++;
  800d13:	42                   	inc    %edx
  800d14:	eb 0b                	jmp    800d21 <strtol+0x41>
	else if (*s == '-')
  800d16:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800d19:	75 06                	jne    800d21 <strtol+0x41>
		s++, neg = 1;
  800d1b:	42                   	inc    %edx
  800d1c:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d21:	85 c9                	test   %ecx,%ecx
  800d23:	74 05                	je     800d2a <strtol+0x4a>
  800d25:	83 f9 10             	cmp    $0x10,%ecx
  800d28:	75 15                	jne    800d3f <strtol+0x5f>
  800d2a:	80 3a 30             	cmpb   $0x30,(%edx)
  800d2d:	75 10                	jne    800d3f <strtol+0x5f>
  800d2f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d33:	75 0a                	jne    800d3f <strtol+0x5f>
		s += 2, base = 16;
  800d35:	83 c2 02             	add    $0x2,%edx
  800d38:	b9 10 00 00 00       	mov    $0x10,%ecx
  800d3d:	eb 14                	jmp    800d53 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800d3f:	85 c9                	test   %ecx,%ecx
  800d41:	75 10                	jne    800d53 <strtol+0x73>
  800d43:	80 3a 30             	cmpb   $0x30,(%edx)
  800d46:	75 05                	jne    800d4d <strtol+0x6d>
		s++, base = 8;
  800d48:	42                   	inc    %edx
  800d49:	b1 08                	mov    $0x8,%cl
  800d4b:	eb 06                	jmp    800d53 <strtol+0x73>
	else if (base == 0)
  800d4d:	85 c9                	test   %ecx,%ecx
  800d4f:	75 02                	jne    800d53 <strtol+0x73>
		base = 10;
  800d51:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d53:	8a 02                	mov    (%edx),%al
  800d55:	83 e8 30             	sub    $0x30,%eax
  800d58:	3c 09                	cmp    $0x9,%al
  800d5a:	77 08                	ja     800d64 <strtol+0x84>
			dig = *s - '0';
  800d5c:	0f be 02             	movsbl (%edx),%eax
  800d5f:	83 e8 30             	sub    $0x30,%eax
  800d62:	eb 20                	jmp    800d84 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800d64:	8a 02                	mov    (%edx),%al
  800d66:	83 e8 61             	sub    $0x61,%eax
  800d69:	3c 19                	cmp    $0x19,%al
  800d6b:	77 08                	ja     800d75 <strtol+0x95>
			dig = *s - 'a' + 10;
  800d6d:	0f be 02             	movsbl (%edx),%eax
  800d70:	83 e8 57             	sub    $0x57,%eax
  800d73:	eb 0f                	jmp    800d84 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800d75:	8a 02                	mov    (%edx),%al
  800d77:	83 e8 41             	sub    $0x41,%eax
  800d7a:	3c 19                	cmp    $0x19,%al
  800d7c:	77 12                	ja     800d90 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800d7e:	0f be 02             	movsbl (%edx),%eax
  800d81:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800d84:	39 c8                	cmp    %ecx,%eax
  800d86:	7d 08                	jge    800d90 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800d88:	42                   	inc    %edx
  800d89:	0f af d9             	imul   %ecx,%ebx
  800d8c:	01 c3                	add    %eax,%ebx
  800d8e:	eb c3                	jmp    800d53 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d90:	85 f6                	test   %esi,%esi
  800d92:	74 02                	je     800d96 <strtol+0xb6>
		*endptr = (char *) s;
  800d94:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d96:	89 d8                	mov    %ebx,%eax
  800d98:	85 ff                	test   %edi,%edi
  800d9a:	74 02                	je     800d9e <strtol+0xbe>
  800d9c:	f7 d8                	neg    %eax
}
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    
	...

00800da4 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
  800daa:	83 ec 04             	sub    $0x4,%esp
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	bf 00 00 00 00       	mov    $0x0,%edi
  800db8:	89 f8                	mov    %edi,%eax
  800dba:	89 fb                	mov    %edi,%ebx
  800dbc:	89 fe                	mov    %edi,%esi
  800dbe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dc0:	83 c4 04             	add    $0x4,%esp
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd3:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd8:	89 fa                	mov    %edi,%edx
  800dda:	89 f9                	mov    %edi,%ecx
  800ddc:	89 fb                	mov    %edi,%ebx
  800dde:	89 fe                	mov    %edi,%esi
  800de0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	b8 03 00 00 00       	mov    $0x3,%eax
  800df8:	bf 00 00 00 00       	mov    $0x0,%edi
  800dfd:	89 f9                	mov    %edi,%ecx
  800dff:	89 fb                	mov    %edi,%ebx
  800e01:	89 fe                	mov    %edi,%esi
  800e03:	cd 30                	int    $0x30
  800e05:	85 c0                	test   %eax,%eax
  800e07:	7e 17                	jle    800e20 <sys_env_destroy+0x39>
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	50                   	push   %eax
  800e0d:	6a 03                	push   $0x3
  800e0f:	68 90 31 80 00       	push   $0x803190
  800e14:	6a 23                	push   $0x23
  800e16:	68 ad 31 80 00       	push   $0x8031ad
  800e1b:	e8 80 f5 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e20:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e33:	bf 00 00 00 00       	mov    $0x0,%edi
  800e38:	89 fa                	mov    %edi,%edx
  800e3a:	89 f9                	mov    %edi,%ecx
  800e3c:	89 fb                	mov    %edi,%ebx
  800e3e:	89 fe                	mov    %edi,%esi
  800e40:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	c9                   	leave  
  800e46:	c3                   	ret    

00800e47 <sys_yield>:

void
sys_yield(void)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e52:	bf 00 00 00 00       	mov    $0x0,%edi
  800e57:	89 fa                	mov    %edi,%edx
  800e59:	89 f9                	mov    %edi,%ecx
  800e5b:	89 fb                	mov    %edi,%ebx
  800e5d:	89 fe                	mov    %edi,%esi
  800e5f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	57                   	push   %edi
  800e6a:	56                   	push   %esi
  800e6b:	53                   	push   %ebx
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e78:	b8 04 00 00 00       	mov    $0x4,%eax
  800e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e82:	89 fe                	mov    %edi,%esi
  800e84:	cd 30                	int    $0x30
  800e86:	85 c0                	test   %eax,%eax
  800e88:	7e 17                	jle    800ea1 <sys_page_alloc+0x3b>
  800e8a:	83 ec 0c             	sub    $0xc,%esp
  800e8d:	50                   	push   %eax
  800e8e:	6a 04                	push   $0x4
  800e90:	68 90 31 80 00       	push   $0x803190
  800e95:	6a 23                	push   $0x23
  800e97:	68 ad 31 80 00       	push   $0x8031ad
  800e9c:	e8 ff f4 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    

00800ea9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 0c             	sub    $0xc,%esp
  800eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebe:	8b 75 18             	mov    0x18(%ebp),%esi
  800ec1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec6:	cd 30                	int    $0x30
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7e 17                	jle    800ee3 <sys_page_map+0x3a>
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	50                   	push   %eax
  800ed0:	6a 05                	push   $0x5
  800ed2:	68 90 31 80 00       	push   $0x803190
  800ed7:	6a 23                	push   $0x23
  800ed9:	68 ad 31 80 00       	push   $0x8031ad
  800ede:	e8 bd f4 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    

00800eeb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efa:	b8 06 00 00 00       	mov    $0x6,%eax
  800eff:	bf 00 00 00 00       	mov    $0x0,%edi
  800f04:	89 fb                	mov    %edi,%ebx
  800f06:	89 fe                	mov    %edi,%esi
  800f08:	cd 30                	int    $0x30
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7e 17                	jle    800f25 <sys_page_unmap+0x3a>
  800f0e:	83 ec 0c             	sub    $0xc,%esp
  800f11:	50                   	push   %eax
  800f12:	6a 06                	push   $0x6
  800f14:	68 90 31 80 00       	push   $0x803190
  800f19:	6a 23                	push   $0x23
  800f1b:	68 ad 31 80 00       	push   $0x8031ad
  800f20:	e8 7b f4 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f41:	bf 00 00 00 00       	mov    $0x0,%edi
  800f46:	89 fb                	mov    %edi,%ebx
  800f48:	89 fe                	mov    %edi,%esi
  800f4a:	cd 30                	int    $0x30
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7e 17                	jle    800f67 <sys_env_set_status+0x3a>
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	50                   	push   %eax
  800f54:	6a 08                	push   $0x8
  800f56:	68 90 31 80 00       	push   $0x803190
  800f5b:	6a 23                	push   $0x23
  800f5d:	68 ad 31 80 00       	push   $0x8031ad
  800f62:	e8 39 f4 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f67:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 0c             	sub    $0xc,%esp
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f83:	bf 00 00 00 00       	mov    $0x0,%edi
  800f88:	89 fb                	mov    %edi,%ebx
  800f8a:	89 fe                	mov    %edi,%esi
  800f8c:	cd 30                	int    $0x30
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7e 17                	jle    800fa9 <sys_env_set_trapframe+0x3a>
  800f92:	83 ec 0c             	sub    $0xc,%esp
  800f95:	50                   	push   %eax
  800f96:	6a 09                	push   $0x9
  800f98:	68 90 31 80 00       	push   $0x803190
  800f9d:	6a 23                	push   $0x23
  800f9f:	68 ad 31 80 00       	push   $0x8031ad
  800fa4:	e8 f7 f3 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fa9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 0c             	sub    $0xc,%esp
  800fba:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc5:	bf 00 00 00 00       	mov    $0x0,%edi
  800fca:	89 fb                	mov    %edi,%ebx
  800fcc:	89 fe                	mov    %edi,%esi
  800fce:	cd 30                	int    $0x30
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	7e 17                	jle    800feb <sys_env_set_pgfault_upcall+0x3a>
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	50                   	push   %eax
  800fd8:	6a 0a                	push   $0xa
  800fda:	68 90 31 80 00       	push   $0x803190
  800fdf:	6a 23                	push   $0x23
  800fe1:	68 ad 31 80 00       	push   $0x8031ad
  800fe6:	e8 b5 f3 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800feb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5f                   	pop    %edi
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	57                   	push   %edi
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
  800ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801002:	8b 7d 14             	mov    0x14(%ebp),%edi
  801005:	b8 0c 00 00 00       	mov    $0xc,%eax
  80100a:	be 00 00 00 00       	mov    $0x0,%esi
  80100f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	b8 0d 00 00 00       	mov    $0xd,%eax
  801027:	bf 00 00 00 00       	mov    $0x0,%edi
  80102c:	89 f9                	mov    %edi,%ecx
  80102e:	89 fb                	mov    %edi,%ebx
  801030:	89 fe                	mov    %edi,%esi
  801032:	cd 30                	int    $0x30
  801034:	85 c0                	test   %eax,%eax
  801036:	7e 17                	jle    80104f <sys_ipc_recv+0x39>
  801038:	83 ec 0c             	sub    $0xc,%esp
  80103b:	50                   	push   %eax
  80103c:	6a 0d                	push   $0xd
  80103e:	68 90 31 80 00       	push   $0x803190
  801043:	6a 23                	push   $0x23
  801045:	68 ad 31 80 00       	push   $0x8031ad
  80104a:	e8 51 f3 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80104f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	83 ec 0c             	sub    $0xc,%esp
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	b8 10 00 00 00       	mov    $0x10,%eax
  80106b:	bf 00 00 00 00       	mov    $0x0,%edi
  801070:	89 fb                	mov    %edi,%ebx
  801072:	89 fe                	mov    %edi,%esi
  801074:	cd 30                	int    $0x30
  801076:	85 c0                	test   %eax,%eax
  801078:	7e 17                	jle    801091 <sys_transmit_packet+0x3a>
  80107a:	83 ec 0c             	sub    $0xc,%esp
  80107d:	50                   	push   %eax
  80107e:	6a 10                	push   $0x10
  801080:	68 90 31 80 00       	push   $0x803190
  801085:	6a 23                	push   $0x23
  801087:	68 ad 31 80 00       	push   $0x8031ad
  80108c:	e8 0f f3 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  801091:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801094:	5b                   	pop    %ebx
  801095:	5e                   	pop    %esi
  801096:	5f                   	pop    %edi
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
  80109f:	83 ec 0c             	sub    $0xc,%esp
  8010a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a8:	b8 11 00 00 00       	mov    $0x11,%eax
  8010ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8010b2:	89 fb                	mov    %edi,%ebx
  8010b4:	89 fe                	mov    %edi,%esi
  8010b6:	cd 30                	int    $0x30
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	7e 17                	jle    8010d3 <sys_receive_packet+0x3a>
  8010bc:	83 ec 0c             	sub    $0xc,%esp
  8010bf:	50                   	push   %eax
  8010c0:	6a 11                	push   $0x11
  8010c2:	68 90 31 80 00       	push   $0x803190
  8010c7:	6a 23                	push   $0x23
  8010c9:	68 ad 31 80 00       	push   $0x8031ad
  8010ce:	e8 cd f2 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  8010d3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010d6:	5b                   	pop    %ebx
  8010d7:	5e                   	pop    %esi
  8010d8:	5f                   	pop    %edi
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	57                   	push   %edi
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
  8010e1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8010eb:	89 fa                	mov    %edi,%edx
  8010ed:	89 f9                	mov    %edi,%ecx
  8010ef:	89 fb                	mov    %edi,%ebx
  8010f1:	89 fe                	mov    %edi,%esi
  8010f3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	57                   	push   %edi
  8010fe:	56                   	push   %esi
  8010ff:	53                   	push   %ebx
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	b8 0e 00 00 00       	mov    $0xe,%eax
  80110b:	bf 00 00 00 00       	mov    $0x0,%edi
  801110:	89 f9                	mov    %edi,%ecx
  801112:	89 fb                	mov    %edi,%ebx
  801114:	89 fe                	mov    %edi,%esi
  801116:	cd 30                	int    $0x30
  801118:	85 c0                	test   %eax,%eax
  80111a:	7e 17                	jle    801133 <sys_map_receive_buffers+0x39>
  80111c:	83 ec 0c             	sub    $0xc,%esp
  80111f:	50                   	push   %eax
  801120:	6a 0e                	push   $0xe
  801122:	68 90 31 80 00       	push   $0x803190
  801127:	6a 23                	push   $0x23
  801129:	68 ad 31 80 00       	push   $0x8031ad
  80112e:	e8 6d f2 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  801133:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801136:	5b                   	pop    %ebx
  801137:	5e                   	pop    %esi
  801138:	5f                   	pop    %edi
  801139:	c9                   	leave  
  80113a:	c3                   	ret    

0080113b <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	57                   	push   %edi
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	8b 55 08             	mov    0x8(%ebp),%edx
  801147:	b8 12 00 00 00       	mov    $0x12,%eax
  80114c:	bf 00 00 00 00       	mov    $0x0,%edi
  801151:	89 f9                	mov    %edi,%ecx
  801153:	89 fb                	mov    %edi,%ebx
  801155:	89 fe                	mov    %edi,%esi
  801157:	cd 30                	int    $0x30
  801159:	85 c0                	test   %eax,%eax
  80115b:	7e 17                	jle    801174 <sys_receive_packet_zerocopy+0x39>
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	50                   	push   %eax
  801161:	6a 12                	push   $0x12
  801163:	68 90 31 80 00       	push   $0x803190
  801168:	6a 23                	push   $0x23
  80116a:	68 ad 31 80 00       	push   $0x8031ad
  80116f:	e8 2c f2 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  801174:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    

0080117c <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	57                   	push   %edi
  801180:	56                   	push   %esi
  801181:	53                   	push   %ebx
  801182:	83 ec 0c             	sub    $0xc,%esp
  801185:	8b 55 08             	mov    0x8(%ebp),%edx
  801188:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118b:	b8 13 00 00 00       	mov    $0x13,%eax
  801190:	bf 00 00 00 00       	mov    $0x0,%edi
  801195:	89 fb                	mov    %edi,%ebx
  801197:	89 fe                	mov    %edi,%esi
  801199:	cd 30                	int    $0x30
  80119b:	85 c0                	test   %eax,%eax
  80119d:	7e 17                	jle    8011b6 <sys_env_set_priority+0x3a>
  80119f:	83 ec 0c             	sub    $0xc,%esp
  8011a2:	50                   	push   %eax
  8011a3:	6a 13                	push   $0x13
  8011a5:	68 90 31 80 00       	push   $0x803190
  8011aa:	6a 23                	push   $0x23
  8011ac:	68 ad 31 80 00       	push   $0x8031ad
  8011b1:	e8 ea f1 ff ff       	call   8003a0 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8011b6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8011b9:	5b                   	pop    %ebx
  8011ba:	5e                   	pop    %esi
  8011bb:	5f                   	pop    %edi
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    
	...

008011c0 <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8011ca:	8b 18                	mov    (%eax),%ebx
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
  8011cc:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8011d0:	74 11                	je     8011e3 <pgfault+0x23>
  8011d2:	89 d8                	mov    %ebx,%eax
  8011d4:	c1 e8 0c             	shr    $0xc,%eax
  8011d7:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8011de:	f6 c4 08             	test   $0x8,%ah
  8011e1:	75 14                	jne    8011f7 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	68 bc 31 80 00       	push   $0x8031bc
  8011eb:	6a 1e                	push   $0x1e
  8011ed:	68 10 32 80 00       	push   $0x803210
  8011f2:	e8 a9 f1 ff ff       	call   8003a0 <_panic>
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
  8011f7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	6a 07                	push   $0x7
  801202:	68 00 f0 7f 00       	push   $0x7ff000
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	e8 19 fc ff ff       	call   800e28 <sys_getenvid>
  80120f:	89 04 24             	mov    %eax,(%esp)
  801212:	e8 4f fc ff ff       	call   800e66 <sys_page_alloc>
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	85 c0                	test   %eax,%eax
  80121c:	79 12                	jns    801230 <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  80121e:	50                   	push   %eax
  80121f:	68 1b 32 80 00       	push   $0x80321b
  801224:	6a 2d                	push   $0x2d
  801226:	68 10 32 80 00       	push   $0x803210
  80122b:	e8 70 f1 ff ff       	call   8003a0 <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	68 00 10 00 00       	push   $0x1000
  801238:	53                   	push   %ebx
  801239:	68 00 f0 7f 00       	push   $0x7ff000
  80123e:	e8 cd f9 ff ff       	call   800c10 <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  801243:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80124a:	53                   	push   %ebx
  80124b:	83 ec 0c             	sub    $0xc,%esp
  80124e:	e8 d5 fb ff ff       	call   800e28 <sys_getenvid>
  801253:	83 c4 0c             	add    $0xc,%esp
  801256:	50                   	push   %eax
  801257:	68 00 f0 7f 00       	push   $0x7ff000
  80125c:	83 ec 04             	sub    $0x4,%esp
  80125f:	e8 c4 fb ff ff       	call   800e28 <sys_getenvid>
  801264:	89 04 24             	mov    %eax,(%esp)
  801267:	e8 3d fc ff ff       	call   800ea9 <sys_page_map>
  80126c:	83 c4 20             	add    $0x20,%esp
  80126f:	85 c0                	test   %eax,%eax
  801271:	79 12                	jns    801285 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  801273:	50                   	push   %eax
  801274:	68 36 32 80 00       	push   $0x803236
  801279:	6a 33                	push   $0x33
  80127b:	68 10 32 80 00       	push   $0x803210
  801280:	e8 1b f1 ff ff       	call   8003a0 <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	68 00 f0 7f 00       	push   $0x7ff000
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	e8 93 fb ff ff       	call   800e28 <sys_getenvid>
  801295:	89 04 24             	mov    %eax,(%esp)
  801298:	e8 4e fc ff ff       	call   800eeb <sys_page_unmap>
  80129d:	83 c4 10             	add    $0x10,%esp
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	79 12                	jns    8012b6 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  8012a4:	50                   	push   %eax
  8012a5:	68 4f 32 80 00       	push   $0x80324f
  8012aa:	6a 36                	push   $0x36
  8012ac:	68 10 32 80 00       	push   $0x803210
  8012b1:	e8 ea f0 ff ff       	call   8003a0 <_panic>
        }

	//panic("pgfault not implemented");
}
  8012b6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <duppage>:

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
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 04             	sub    $0x4,%esp
  8012c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  8012c8:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  8012cd:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  8012d0:	f6 c4 04             	test   $0x4,%ah
  8012d3:	74 36                	je     80130b <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  8012db:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e0:	50                   	push   %eax
  8012e1:	89 d8                	mov    %ebx,%eax
  8012e3:	c1 e0 0c             	shl    $0xc,%eax
  8012e6:	50                   	push   %eax
  8012e7:	51                   	push   %ecx
  8012e8:	50                   	push   %eax
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	e8 37 fb ff ff       	call   800e28 <sys_getenvid>
  8012f1:	89 04 24             	mov    %eax,(%esp)
  8012f4:	e8 b0 fb ff ff       	call   800ea9 <sys_page_map>
  8012f9:	83 c4 20             	add    $0x20,%esp
            return r;
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	85 c0                	test   %eax,%eax
  801300:	0f 88 c9 00 00 00    	js     8013cf <duppage+0x114>
  801306:	e9 bf 00 00 00       	jmp    8013ca <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  80130b:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  801312:	a9 02 08 00 00       	test   $0x802,%eax
  801317:	74 7b                	je     801394 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	68 05 08 00 00       	push   $0x805
  801321:	89 d8                	mov    %ebx,%eax
  801323:	c1 e0 0c             	shl    $0xc,%eax
  801326:	50                   	push   %eax
  801327:	51                   	push   %ecx
  801328:	50                   	push   %eax
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	e8 f7 fa ff ff       	call   800e28 <sys_getenvid>
  801331:	89 04 24             	mov    %eax,(%esp)
  801334:	e8 70 fb ff ff       	call   800ea9 <sys_page_map>
  801339:	83 c4 20             	add    $0x20,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	79 12                	jns    801352 <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  801340:	50                   	push   %eax
  801341:	68 6a 32 80 00       	push   $0x80326a
  801346:	6a 56                	push   $0x56
  801348:	68 10 32 80 00       	push   $0x803210
  80134d:	e8 4e f0 ff ff       	call   8003a0 <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	68 05 08 00 00       	push   $0x805
  80135a:	c1 e3 0c             	shl    $0xc,%ebx
  80135d:	53                   	push   %ebx
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	e8 c2 fa ff ff       	call   800e28 <sys_getenvid>
  801366:	83 c4 0c             	add    $0xc,%esp
  801369:	50                   	push   %eax
  80136a:	53                   	push   %ebx
  80136b:	83 ec 04             	sub    $0x4,%esp
  80136e:	e8 b5 fa ff ff       	call   800e28 <sys_getenvid>
  801373:	89 04 24             	mov    %eax,(%esp)
  801376:	e8 2e fb ff ff       	call   800ea9 <sys_page_map>
  80137b:	83 c4 20             	add    $0x20,%esp
  80137e:	85 c0                	test   %eax,%eax
  801380:	79 48                	jns    8013ca <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801382:	50                   	push   %eax
  801383:	68 6a 32 80 00       	push   $0x80326a
  801388:	6a 5b                	push   $0x5b
  80138a:	68 10 32 80 00       	push   $0x803210
  80138f:	e8 0c f0 ff ff       	call   8003a0 <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	6a 05                	push   $0x5
  801399:	89 d8                	mov    %ebx,%eax
  80139b:	c1 e0 0c             	shl    $0xc,%eax
  80139e:	50                   	push   %eax
  80139f:	51                   	push   %ecx
  8013a0:	50                   	push   %eax
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	e8 7f fa ff ff       	call   800e28 <sys_getenvid>
  8013a9:	89 04 24             	mov    %eax,(%esp)
  8013ac:	e8 f8 fa ff ff       	call   800ea9 <sys_page_map>
  8013b1:	83 c4 20             	add    $0x20,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	79 12                	jns    8013ca <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8013b8:	50                   	push   %eax
  8013b9:	68 6a 32 80 00       	push   $0x80326a
  8013be:	6a 5f                	push   $0x5f
  8013c0:	68 10 32 80 00       	push   $0x803210
  8013c5:	e8 d6 ef ff ff       	call   8003a0 <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  8013ca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013cf:	89 d0                	mov    %edx,%eax
  8013d1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <fork>:

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
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	57                   	push   %edi
  8013da:	56                   	push   %esi
  8013db:	53                   	push   %ebx
  8013dc:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  8013df:	68 c0 11 80 00       	push   $0x8011c0
  8013e4:	e8 1b 13 00 00       	call   802704 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  8013e9:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  8013ec:	ba 07 00 00 00       	mov    $0x7,%edx
  8013f1:	89 d0                	mov    %edx,%eax
  8013f3:	cd 30                	int    $0x30
  8013f5:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	79 15                	jns    801411 <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  8013fc:	50                   	push   %eax
  8013fd:	68 f0 31 80 00       	push   $0x8031f0
  801402:	68 85 00 00 00       	push   $0x85
  801407:	68 10 32 80 00       	push   $0x803210
  80140c:	e8 8f ef ff ff       	call   8003a0 <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  801411:	bf 00 00 00 00       	mov    $0x0,%edi
  801416:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80141a:	75 21                	jne    80143d <fork+0x67>
  80141c:	e8 07 fa ff ff       	call   800e28 <sys_getenvid>
  801421:	25 ff 03 00 00       	and    $0x3ff,%eax
  801426:	c1 e0 07             	shl    $0x7,%eax
  801429:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80142e:	a3 80 74 80 00       	mov    %eax,0x807480
  801433:	ba 00 00 00 00       	mov    $0x0,%edx
  801438:	e9 fd 00 00 00       	jmp    80153a <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  80143d:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  801444:	a8 01                	test   $0x1,%al
  801446:	74 5f                	je     8014a7 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  801448:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144d:	89 f8                	mov    %edi,%eax
  80144f:	c1 e0 0a             	shl    $0xa,%eax
  801452:	89 c2                	mov    %eax,%edx
  801454:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801459:	77 4c                	ja     8014a7 <fork+0xd1>
  80145b:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  80145d:	01 da                	add    %ebx,%edx
  80145f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801466:	a8 01                	test   $0x1,%al
  801468:	74 28                	je     801492 <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	52                   	push   %edx
  80146e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801471:	e8 45 fe ff ff       	call   8012bb <duppage>
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	79 15                	jns    801492 <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  80147d:	50                   	push   %eax
  80147e:	68 83 32 80 00       	push   $0x803283
  801483:	68 95 00 00 00       	push   $0x95
  801488:	68 10 32 80 00       	push   $0x803210
  80148d:	e8 0e ef ff ff       	call   8003a0 <_panic>
  801492:	43                   	inc    %ebx
  801493:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801499:	7f 0c                	jg     8014a7 <fork+0xd1>
  80149b:	89 f2                	mov    %esi,%edx
  80149d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8014a0:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8014a5:	76 b6                	jbe    80145d <fork+0x87>
  8014a7:	47                   	inc    %edi
  8014a8:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  8014ae:	76 8d                	jbe    80143d <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	6a 07                	push   $0x7
  8014b5:	68 00 f0 bf ee       	push   $0xeebff000
  8014ba:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8014bd:	e8 a4 f9 ff ff       	call   800e66 <sys_page_alloc>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	79 15                	jns    8014de <fork+0x108>
          panic("fork: %d", r);
  8014c9:	50                   	push   %eax
  8014ca:	68 9c 32 80 00       	push   $0x80329c
  8014cf:	68 9d 00 00 00       	push   $0x9d
  8014d4:	68 10 32 80 00       	push   $0x803210
  8014d9:	e8 c2 ee ff ff       	call   8003a0 <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	a1 80 74 80 00       	mov    0x807480,%eax
  8014e6:	8b 40 64             	mov    0x64(%eax),%eax
  8014e9:	50                   	push   %eax
  8014ea:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8014ed:	e8 bf fa ff ff       	call   800fb1 <sys_env_set_pgfault_upcall>
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	79 15                	jns    80150e <fork+0x138>
          panic("fork: %d", r);
  8014f9:	50                   	push   %eax
  8014fa:	68 9c 32 80 00       	push   $0x80329c
  8014ff:	68 a2 00 00 00       	push   $0xa2
  801504:	68 10 32 80 00       	push   $0x803210
  801509:	e8 92 ee ff ff       	call   8003a0 <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	6a 01                	push   $0x1
  801513:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801516:	e8 12 fa ff ff       	call   800f2d <sys_env_set_status>
  80151b:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  80151e:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801521:	85 c0                	test   %eax,%eax
  801523:	79 15                	jns    80153a <fork+0x164>
  801525:	50                   	push   %eax
  801526:	68 9c 32 80 00       	push   $0x80329c
  80152b:	68 a7 00 00 00       	push   $0xa7
  801530:	68 10 32 80 00       	push   $0x803210
  801535:	e8 66 ee ff ff       	call   8003a0 <_panic>
 
	//panic("fork not implemented");
}
  80153a:	89 d0                	mov    %edx,%eax
  80153c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80153f:	5b                   	pop    %ebx
  801540:	5e                   	pop    %esi
  801541:	5f                   	pop    %edi
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <sfork>:



// Challenge!
int
sfork(void)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80154a:	68 a5 32 80 00       	push   $0x8032a5
  80154f:	68 b5 00 00 00       	push   $0xb5
  801554:	68 10 32 80 00       	push   $0x803210
  801559:	e8 42 ee ff ff       	call   8003a0 <_panic>
	...

00801560 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	e8 0a 00 00 00       	call   801578 <fd2num>
  80156e:	c1 e0 16             	shl    $0x16,%eax
  801571:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	05 00 00 40 30       	add    $0x30400000,%eax
  801583:	c1 e8 0c             	shr    $0xc,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <fd_alloc>:

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
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	57                   	push   %edi
  80158c:	56                   	push   %esi
  80158d:	53                   	push   %ebx
  80158e:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801591:	b9 00 00 00 00       	mov    $0x0,%ecx
  801596:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  80159b:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  8015a0:	89 c8                	mov    %ecx,%eax
  8015a2:	c1 e0 0c             	shl    $0xc,%eax
  8015a5:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8015ab:	89 d0                	mov    %edx,%eax
  8015ad:	c1 e8 16             	shr    $0x16,%eax
  8015b0:	8b 04 86             	mov    (%esi,%eax,4),%eax
  8015b3:	a8 01                	test   $0x1,%al
  8015b5:	74 0c                	je     8015c3 <fd_alloc+0x3b>
  8015b7:	89 d0                	mov    %edx,%eax
  8015b9:	c1 e8 0c             	shr    $0xc,%eax
  8015bc:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  8015bf:	a8 01                	test   $0x1,%al
  8015c1:	75 09                	jne    8015cc <fd_alloc+0x44>
			*fd_store = fd;
  8015c3:	89 17                	mov    %edx,(%edi)
			return 0;
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	eb 11                	jmp    8015dd <fd_alloc+0x55>
  8015cc:	41                   	inc    %ecx
  8015cd:	83 f9 1f             	cmp    $0x1f,%ecx
  8015d0:	7e ce                	jle    8015a0 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  8015d2:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8015d8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8015e8:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8015ed:	83 f8 1f             	cmp    $0x1f,%eax
  8015f0:	77 3a                	ja     80162c <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  8015f2:	c1 e0 0c             	shl    $0xc,%eax
  8015f5:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8015fb:	89 d0                	mov    %edx,%eax
  8015fd:	c1 e8 16             	shr    $0x16,%eax
  801600:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801607:	a8 01                	test   $0x1,%al
  801609:	74 10                	je     80161b <fd_lookup+0x39>
  80160b:	89 d0                	mov    %edx,%eax
  80160d:	c1 e8 0c             	shr    $0xc,%eax
  801610:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801617:	a8 01                	test   $0x1,%al
  801619:	75 07                	jne    801622 <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80161b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801620:	eb 0a                	jmp    80162c <fd_lookup+0x4a>
	}
	*fd_store = fd;
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	89 10                	mov    %edx,(%eax)
	return 0;
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80162c:	89 d0                	mov    %edx,%eax
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <fd_close>:

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
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	56                   	push   %esi
  801634:	53                   	push   %ebx
  801635:	83 ec 10             	sub    $0x10,%esp
  801638:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80163b:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80163e:	50                   	push   %eax
  80163f:	56                   	push   %esi
  801640:	e8 33 ff ff ff       	call   801578 <fd2num>
  801645:	89 04 24             	mov    %eax,(%esp)
  801648:	e8 95 ff ff ff       	call   8015e2 <fd_lookup>
  80164d:	89 c3                	mov    %eax,%ebx
  80164f:	83 c4 08             	add    $0x8,%esp
  801652:	85 c0                	test   %eax,%eax
  801654:	78 05                	js     80165b <fd_close+0x2b>
  801656:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801659:	74 0f                	je     80166a <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80165b:	89 d8                	mov    %ebx,%eax
  80165d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801661:	75 3a                	jne    80169d <fd_close+0x6d>
  801663:	b8 00 00 00 00       	mov    $0x0,%eax
  801668:	eb 33                	jmp    80169d <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801670:	50                   	push   %eax
  801671:	ff 36                	pushl  (%esi)
  801673:	e8 2c 00 00 00       	call   8016a4 <dev_lookup>
  801678:	89 c3                	mov    %eax,%ebx
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 0f                	js     801690 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	56                   	push   %esi
  801685:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801688:	ff 50 10             	call   *0x10(%eax)
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	56                   	push   %esi
  801694:	6a 00                	push   $0x0
  801696:	e8 50 f8 ff ff       	call   800eeb <sys_page_unmap>
	return r;
  80169b:	89 d8                	mov    %ebx,%eax
}
  80169d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8016a0:	5b                   	pop    %ebx
  8016a1:	5e                   	pop    %esi
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <dev_lookup>:


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
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
  8016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8016ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  8016af:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b4:	83 3d 04 70 80 00 00 	cmpl   $0x0,0x807004
  8016bb:	74 1c                	je     8016d9 <dev_lookup+0x35>
  8016bd:	b9 04 70 80 00       	mov    $0x807004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  8016c2:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  8016c5:	39 18                	cmp    %ebx,(%eax)
  8016c7:	75 09                	jne    8016d2 <dev_lookup+0x2e>
			*dev = devtab[i];
  8016c9:	89 06                	mov    %eax,(%esi)
			return 0;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	eb 29                	jmp    8016fb <dev_lookup+0x57>
  8016d2:	42                   	inc    %edx
  8016d3:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  8016d7:	75 e9                	jne    8016c2 <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	53                   	push   %ebx
  8016dd:	a1 80 74 80 00       	mov    0x807480,%eax
  8016e2:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016e5:	50                   	push   %eax
  8016e6:	68 bc 32 80 00       	push   $0x8032bc
  8016eb:	e8 a0 ed ff ff       	call   800490 <cprintf>
	*dev = 0;
  8016f0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  8016f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016fb:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5e                   	pop    %esi
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <close>:

int
close(int fdnum)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801708:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80170b:	50                   	push   %eax
  80170c:	ff 75 08             	pushl  0x8(%ebp)
  80170f:	e8 ce fe ff ff       	call   8015e2 <fd_lookup>
  801714:	83 c4 08             	add    $0x8,%esp
		return r;
  801717:	89 c2                	mov    %eax,%edx
  801719:	85 c0                	test   %eax,%eax
  80171b:	78 0f                	js     80172c <close+0x2a>
	else
		return fd_close(fd, 1);
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	6a 01                	push   $0x1
  801722:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801725:	e8 06 ff ff ff       	call   801630 <fd_close>
  80172a:	89 c2                	mov    %eax,%edx
}
  80172c:	89 d0                	mov    %edx,%eax
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <close_all>:

void
close_all(void)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
  801734:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801737:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80173c:	83 ec 0c             	sub    $0xc,%esp
  80173f:	53                   	push   %ebx
  801740:	e8 bd ff ff ff       	call   801702 <close>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	43                   	inc    %ebx
  801749:	83 fb 1f             	cmp    $0x1f,%ebx
  80174c:	7e ee                	jle    80173c <close_all+0xc>
}
  80174e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	57                   	push   %edi
  801757:	56                   	push   %esi
  801758:	53                   	push   %ebx
  801759:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80175c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80175f:	50                   	push   %eax
  801760:	ff 75 08             	pushl  0x8(%ebp)
  801763:	e8 7a fe ff ff       	call   8015e2 <fd_lookup>
  801768:	89 c6                	mov    %eax,%esi
  80176a:	83 c4 08             	add    $0x8,%esp
  80176d:	85 f6                	test   %esi,%esi
  80176f:	0f 88 f8 00 00 00    	js     80186d <dup+0x11a>
		return r;
	close(newfdnum);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	e8 82 ff ff ff       	call   801702 <close>

	newfd = INDEX2FD(newfdnum);
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	c1 e0 0c             	shl    $0xc,%eax
  801786:	2d 00 00 40 30       	sub    $0x30400000,%eax
  80178b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  80178e:	83 c4 04             	add    $0x4,%esp
  801791:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801794:	e8 c7 fd ff ff       	call   801560 <fd2data>
  801799:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  80179b:	83 c4 04             	add    $0x4,%esp
  80179e:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8017a1:	e8 ba fd ff ff       	call   801560 <fd2data>
  8017a6:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8017a9:	89 f8                	mov    %edi,%eax
  8017ab:	c1 e8 16             	shr    $0x16,%eax
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	74 48                	je     801804 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8017bc:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  8017c1:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  8017c4:	89 d0                	mov    %edx,%eax
  8017c6:	c1 e8 0c             	shr    $0xc,%eax
  8017c9:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  8017d0:	a8 01                	test   $0x1,%al
  8017d2:	74 22                	je     8017f6 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8017d4:	83 ec 0c             	sub    $0xc,%esp
  8017d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017dc:	50                   	push   %eax
  8017dd:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8017e0:	01 d8                	add    %ebx,%eax
  8017e2:	50                   	push   %eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	6a 00                	push   $0x0
  8017e8:	e8 bc f6 ff ff       	call   800ea9 <sys_page_map>
  8017ed:	89 c6                	mov    %eax,%esi
  8017ef:	83 c4 20             	add    $0x20,%esp
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	78 3f                	js     801835 <dup+0xe2>
  8017f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8017fc:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801802:	7e bd                	jle    8017c1 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801804:	83 ec 0c             	sub    $0xc,%esp
  801807:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80180a:	89 d0                	mov    %edx,%eax
  80180c:	c1 e8 0c             	shr    $0xc,%eax
  80180f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801816:	25 07 0e 00 00       	and    $0xe07,%eax
  80181b:	50                   	push   %eax
  80181c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80181f:	6a 00                	push   $0x0
  801821:	52                   	push   %edx
  801822:	6a 00                	push   $0x0
  801824:	e8 80 f6 ff ff       	call   800ea9 <sys_page_map>
  801829:	89 c6                	mov    %eax,%esi
  80182b:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80182e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801831:	85 f6                	test   %esi,%esi
  801833:	79 38                	jns    80186d <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801835:	83 ec 08             	sub    $0x8,%esp
  801838:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80183b:	6a 00                	push   $0x0
  80183d:	e8 a9 f6 ff ff       	call   800eeb <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801842:	bb 00 00 00 00       	mov    $0x0,%ebx
  801847:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  80184a:	83 ec 08             	sub    $0x8,%esp
  80184d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801850:	01 d8                	add    %ebx,%eax
  801852:	50                   	push   %eax
  801853:	6a 00                	push   $0x0
  801855:	e8 91 f6 ff ff       	call   800eeb <sys_page_unmap>
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801863:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801869:	7e df                	jle    80184a <dup+0xf7>
	return r;
  80186b:	89 f0                	mov    %esi,%eax
}
  80186d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801870:	5b                   	pop    %ebx
  801871:	5e                   	pop    %esi
  801872:	5f                   	pop    %edi
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	53                   	push   %ebx
  801879:	83 ec 14             	sub    $0x14,%esp
  80187c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801882:	50                   	push   %eax
  801883:	53                   	push   %ebx
  801884:	e8 59 fd ff ff       	call   8015e2 <fd_lookup>
  801889:	89 c2                	mov    %eax,%edx
  80188b:	83 c4 08             	add    $0x8,%esp
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 1a                	js     8018ac <read+0x37>
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801898:	50                   	push   %eax
  801899:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80189c:	ff 30                	pushl  (%eax)
  80189e:	e8 01 fe ff ff       	call   8016a4 <dev_lookup>
  8018a3:	89 c2                	mov    %eax,%edx
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	79 04                	jns    8018b0 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8018ac:	89 d0                	mov    %edx,%eax
  8018ae:	eb 50                	jmp    801900 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018b0:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018b3:	8b 40 08             	mov    0x8(%eax),%eax
  8018b6:	83 e0 03             	and    $0x3,%eax
  8018b9:	83 f8 01             	cmp    $0x1,%eax
  8018bc:	75 1e                	jne    8018dc <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	53                   	push   %ebx
  8018c2:	a1 80 74 80 00       	mov    0x807480,%eax
  8018c7:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018ca:	50                   	push   %eax
  8018cb:	68 fd 32 80 00       	push   $0x8032fd
  8018d0:	e8 bb eb ff ff       	call   800490 <cprintf>
		return -E_INVAL;
  8018d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018da:	eb 24                	jmp    801900 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8018dc:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018df:	ff 70 04             	pushl  0x4(%eax)
  8018e2:	ff 75 10             	pushl  0x10(%ebp)
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	50                   	push   %eax
  8018e9:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8018ec:	ff 50 08             	call   *0x8(%eax)
  8018ef:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 06                	js     8018fe <read+0x89>
		fd->fd_offset += r;
  8018f8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018fb:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8018fe:	89 d0                	mov    %edx,%eax
}
  801900:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	57                   	push   %edi
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801911:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801914:	bb 00 00 00 00       	mov    $0x0,%ebx
  801919:	39 f3                	cmp    %esi,%ebx
  80191b:	73 25                	jae    801942 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	89 f0                	mov    %esi,%eax
  801922:	29 d8                	sub    %ebx,%eax
  801924:	50                   	push   %eax
  801925:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801928:	50                   	push   %eax
  801929:	ff 75 08             	pushl  0x8(%ebp)
  80192c:	e8 44 ff ff ff       	call   801875 <read>
		if (m < 0)
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	85 c0                	test   %eax,%eax
  801936:	78 0c                	js     801944 <readn+0x3f>
			return m;
		if (m == 0)
  801938:	85 c0                	test   %eax,%eax
  80193a:	74 06                	je     801942 <readn+0x3d>
  80193c:	01 c3                	add    %eax,%ebx
  80193e:	39 f3                	cmp    %esi,%ebx
  801940:	72 db                	jb     80191d <readn+0x18>
			break;
	}
	return tot;
  801942:	89 d8                	mov    %ebx,%eax
}
  801944:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801947:	5b                   	pop    %ebx
  801948:	5e                   	pop    %esi
  801949:	5f                   	pop    %edi
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	53                   	push   %ebx
  801950:	83 ec 14             	sub    $0x14,%esp
  801953:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801956:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801959:	50                   	push   %eax
  80195a:	53                   	push   %ebx
  80195b:	e8 82 fc ff ff       	call   8015e2 <fd_lookup>
  801960:	89 c2                	mov    %eax,%edx
  801962:	83 c4 08             	add    $0x8,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 1a                	js     801983 <write+0x37>
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80196f:	50                   	push   %eax
  801970:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801973:	ff 30                	pushl  (%eax)
  801975:	e8 2a fd ff ff       	call   8016a4 <dev_lookup>
  80197a:	89 c2                	mov    %eax,%edx
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	79 04                	jns    801987 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801983:	89 d0                	mov    %edx,%eax
  801985:	eb 4b                	jmp    8019d2 <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801987:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80198a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80198e:	75 1e                	jne    8019ae <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	53                   	push   %ebx
  801994:	a1 80 74 80 00       	mov    0x807480,%eax
  801999:	8b 40 4c             	mov    0x4c(%eax),%eax
  80199c:	50                   	push   %eax
  80199d:	68 19 33 80 00       	push   $0x803319
  8019a2:	e8 e9 ea ff ff       	call   800490 <cprintf>
		return -E_INVAL;
  8019a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ac:	eb 24                	jmp    8019d2 <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8019ae:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8019b1:	ff 70 04             	pushl  0x4(%eax)
  8019b4:	ff 75 10             	pushl  0x10(%ebp)
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	50                   	push   %eax
  8019bb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8019be:	ff 50 0c             	call   *0xc(%eax)
  8019c1:	89 c2                	mov    %eax,%edx
	if (r > 0)
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	7e 06                	jle    8019d0 <write+0x84>
		fd->fd_offset += r;
  8019ca:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8019cd:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8019d0:	89 d0                	mov    %edx,%eax
}
  8019d2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019dd:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8019e0:	50                   	push   %eax
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 f9 fb ff ff       	call   8015e2 <fd_lookup>
  8019e9:	83 c4 08             	add    $0x8,%esp
		return r;
  8019ec:	89 c2                	mov    %eax,%edx
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 0e                	js     801a00 <seek+0x29>
	fd->fd_offset = offset;
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8019f8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a00:	89 d0                	mov    %edx,%eax
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	53                   	push   %ebx
  801a08:	83 ec 14             	sub    $0x14,%esp
  801a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801a11:	50                   	push   %eax
  801a12:	53                   	push   %ebx
  801a13:	e8 ca fb ff ff       	call   8015e2 <fd_lookup>
  801a18:	83 c4 08             	add    $0x8,%esp
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 4e                	js     801a6d <ftruncate+0x69>
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801a25:	50                   	push   %eax
  801a26:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a29:	ff 30                	pushl  (%eax)
  801a2b:	e8 74 fc ff ff       	call   8016a4 <dev_lookup>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 36                	js     801a6d <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a37:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a3a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3e:	75 1e                	jne    801a5e <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	53                   	push   %ebx
  801a44:	a1 80 74 80 00       	mov    0x807480,%eax
  801a49:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a4c:	50                   	push   %eax
  801a4d:	68 dc 32 80 00       	push   $0x8032dc
  801a52:	e8 39 ea ff ff       	call   800490 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801a57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5c:	eb 0f                	jmp    801a6d <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	ff 75 0c             	pushl  0xc(%ebp)
  801a64:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801a67:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801a6a:	ff 50 1c             	call   *0x1c(%eax)
}
  801a6d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	53                   	push   %ebx
  801a76:	83 ec 14             	sub    $0x14,%esp
  801a79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a7c:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801a7f:	50                   	push   %eax
  801a80:	ff 75 08             	pushl  0x8(%ebp)
  801a83:	e8 5a fb ff ff       	call   8015e2 <fd_lookup>
  801a88:	83 c4 08             	add    $0x8,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 42                	js     801ad1 <fstat+0x5f>
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801a95:	50                   	push   %eax
  801a96:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a99:	ff 30                	pushl  (%eax)
  801a9b:	e8 04 fc ff ff       	call   8016a4 <dev_lookup>
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 2a                	js     801ad1 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801aa7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aaa:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ab1:	00 00 00 
	stat->st_isdir = 0;
  801ab4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801abb:	00 00 00 
	stat->st_dev = dev;
  801abe:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801ac1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	53                   	push   %ebx
  801acb:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801ace:	ff 50 14             	call   *0x14(%eax)
}
  801ad1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	6a 00                	push   $0x0
  801ae0:	ff 75 08             	pushl  0x8(%ebp)
  801ae3:	e8 28 00 00 00       	call   801b10 <open>
  801ae8:	89 c6                	mov    %eax,%esi
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 f6                	test   %esi,%esi
  801aef:	78 18                	js     801b09 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	56                   	push   %esi
  801af8:	e8 75 ff ff ff       	call   801a72 <fstat>
  801afd:	89 c3                	mov    %eax,%ebx
	close(fd);
  801aff:	89 34 24             	mov    %esi,(%esp)
  801b02:	e8 fb fb ff ff       	call   801702 <close>
	return r;
  801b07:	89 d8                	mov    %ebx,%eax
}
  801b09:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	53                   	push   %ebx
  801b14:	83 ec 10             	sub    $0x10,%esp
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
  801b17:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801b1a:	50                   	push   %eax
  801b1b:	e8 68 fa ff ff       	call   801588 <fd_alloc>
  801b20:	89 c3                	mov    %eax,%ebx
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	85 db                	test   %ebx,%ebx
  801b27:	78 36                	js     801b5f <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	e8 1b 05 00 00       	call   802055 <fsipc_open>
  801b3a:	89 c3                	mov    %eax,%ebx
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	79 11                	jns    801b54 <open+0x44>
          fd_close(fd_store, 0);
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	6a 00                	push   $0x0
  801b48:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801b4b:	e8 e0 fa ff ff       	call   801630 <fd_close>
          return r;
  801b50:	89 d8                	mov    %ebx,%eax
  801b52:	eb 0b                	jmp    801b5f <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801b5a:	e8 19 fa ff ff       	call   801578 <fd2num>
}
  801b5f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	53                   	push   %ebx
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801b6e:	6a 01                	push   $0x1
  801b70:	6a 00                	push   $0x0
  801b72:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801b78:	53                   	push   %ebx
  801b79:	e8 e7 03 00 00       	call   801f65 <funmap>
  801b7e:	83 c4 10             	add    $0x10,%esp
          return r;
  801b81:	89 c2                	mov    %eax,%edx
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 19                	js     801ba0 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801b87:	83 ec 0c             	sub    $0xc,%esp
  801b8a:	ff 73 0c             	pushl  0xc(%ebx)
  801b8d:	e8 68 05 00 00       	call   8020fa <fsipc_close>
  801b92:	83 c4 10             	add    $0x10,%esp
          return r;
  801b95:	89 c2                	mov    %eax,%edx
  801b97:	85 c0                	test   %eax,%eax
  801b99:	78 05                	js     801ba0 <file_close+0x3c>
        }
        return 0;
  801b9b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801ba0:	89 d0                	mov    %edx,%eax
  801ba2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	57                   	push   %edi
  801bab:	56                   	push   %esi
  801bac:	53                   	push   %ebx
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	8b 75 10             	mov    0x10(%ebp),%esi
  801bb3:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801bbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc4:	39 d7                	cmp    %edx,%edi
  801bc6:	0f 87 95 00 00 00    	ja     801c61 <file_read+0xba>
	if (offset + n > size)
  801bcc:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801bcf:	39 d0                	cmp    %edx,%eax
  801bd1:	76 04                	jbe    801bd7 <file_read+0x30>
		n = size - offset;
  801bd3:	89 d6                	mov    %edx,%esi
  801bd5:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801bd7:	83 ec 0c             	sub    $0xc,%esp
  801bda:	ff 75 08             	pushl  0x8(%ebp)
  801bdd:	e8 7e f9 ff ff       	call   801560 <fd2data>
  801be2:	89 c3                	mov    %eax,%ebx
  801be4:	01 fb                	add    %edi,%ebx
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	eb 41                	jmp    801c2c <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801beb:	89 d8                	mov    %ebx,%eax
  801bed:	c1 e8 16             	shr    $0x16,%eax
  801bf0:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801bf7:	a8 01                	test   $0x1,%al
  801bf9:	74 10                	je     801c0b <file_read+0x64>
  801bfb:	89 d8                	mov    %ebx,%eax
  801bfd:	c1 e8 0c             	shr    $0xc,%eax
  801c00:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c07:	a8 01                	test   $0x1,%al
  801c09:	75 1b                	jne    801c26 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801c11:	50                   	push   %eax
  801c12:	57                   	push   %edi
  801c13:	ff 75 08             	pushl  0x8(%ebp)
  801c16:	e8 d4 02 00 00       	call   801eef <fmap>
  801c1b:	83 c4 10             	add    $0x10,%esp
              return r;
  801c1e:	89 c1                	mov    %eax,%ecx
  801c20:	85 c0                	test   %eax,%eax
  801c22:	78 3d                	js     801c61 <file_read+0xba>
  801c24:	eb 1c                	jmp    801c42 <file_read+0x9b>
  801c26:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	e8 29 f9 ff ff       	call   801560 <fd2data>
  801c37:	01 f8                	add    %edi,%eax
  801c39:	01 f0                	add    %esi,%eax
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	39 d8                	cmp    %ebx,%eax
  801c40:	77 a9                	ja     801beb <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801c42:	83 ec 04             	sub    $0x4,%esp
  801c45:	56                   	push   %esi
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	ff 75 08             	pushl  0x8(%ebp)
  801c4c:	e8 0f f9 ff ff       	call   801560 <fd2data>
  801c51:	83 c4 08             	add    $0x8,%esp
  801c54:	01 f8                	add    %edi,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 b1 ef ff ff       	call   800c10 <memmove>
	return n;
  801c5f:	89 f1                	mov    %esi,%ecx
}
  801c61:	89 c8                	mov    %ecx,%eax
  801c63:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5e                   	pop    %esi
  801c68:	5f                   	pop    %edi
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	83 ec 18             	sub    $0x18,%esp
  801c73:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c76:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801c79:	50                   	push   %eax
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	e8 60 f9 ff ff       	call   8015e2 <fd_lookup>
  801c82:	83 c4 10             	add    $0x10,%esp
		return r;
  801c85:	89 c2                	mov    %eax,%edx
  801c87:	85 c0                	test   %eax,%eax
  801c89:	0f 88 9f 00 00 00    	js     801d2e <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801c8f:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801c92:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801c94:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801c99:	3b 05 20 70 80 00    	cmp    0x807020,%eax
  801c9f:	0f 85 89 00 00 00    	jne    801d2e <read_map+0xc3>
	va = fd2data(fd) + offset;
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801cab:	e8 b0 f8 ff ff       	call   801560 <fd2data>
  801cb0:	89 c3                	mov    %eax,%ebx
  801cb2:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801cb4:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801cb7:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801cbc:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801cc2:	7f 6a                	jg     801d2e <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	c1 e8 16             	shr    $0x16,%eax
  801cc9:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801cd0:	a8 01                	test   $0x1,%al
  801cd2:	74 10                	je     801ce4 <read_map+0x79>
  801cd4:	89 d8                	mov    %ebx,%eax
  801cd6:	c1 e8 0c             	shr    $0xc,%eax
  801cd9:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801ce0:	a8 01                	test   $0x1,%al
  801ce2:	75 19                	jne    801cfd <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	8d 46 01             	lea    0x1(%esi),%eax
  801cea:	50                   	push   %eax
  801ceb:	56                   	push   %esi
  801cec:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801cef:	e8 fb 01 00 00       	call   801eef <fmap>
  801cf4:	83 c4 10             	add    $0x10,%esp
            return r;
  801cf7:	89 c2                	mov    %eax,%edx
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	78 31                	js     801d2e <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801cfd:	89 d8                	mov    %ebx,%eax
  801cff:	c1 e8 16             	shr    $0x16,%eax
  801d02:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801d09:	a8 01                	test   $0x1,%al
  801d0b:	74 10                	je     801d1d <read_map+0xb2>
  801d0d:	89 d8                	mov    %ebx,%eax
  801d0f:	c1 e8 0c             	shr    $0xc,%eax
  801d12:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801d19:	a8 01                	test   $0x1,%al
  801d1b:	75 07                	jne    801d24 <read_map+0xb9>
		return -E_NO_DISK;
  801d1d:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801d22:	eb 0a                	jmp    801d2e <read_map+0xc3>

	*blk = (void*) va;
  801d24:	8b 45 10             	mov    0x10(%ebp),%eax
  801d27:	89 18                	mov    %ebx,(%eax)
	return 0;
  801d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d2e:	89 d0                	mov    %edx,%eax
  801d30:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	57                   	push   %edi
  801d3b:	56                   	push   %esi
  801d3c:	53                   	push   %ebx
  801d3d:	83 ec 0c             	sub    $0xc,%esp
  801d40:	8b 75 08             	mov    0x8(%ebp),%esi
  801d43:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801d46:	8b 45 10             	mov    0x10(%ebp),%eax
  801d49:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801d4c:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801d51:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801d57:	0f 87 bd 00 00 00    	ja     801e1a <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801d5d:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801d63:	73 17                	jae    801d7c <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	52                   	push   %edx
  801d69:	56                   	push   %esi
  801d6a:	e8 fb 00 00 00       	call   801e6a <file_trunc>
  801d6f:	83 c4 10             	add    $0x10,%esp
			return r;
  801d72:	89 c1                	mov    %eax,%ecx
  801d74:	85 c0                	test   %eax,%eax
  801d76:	0f 88 9e 00 00 00    	js     801e1a <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	56                   	push   %esi
  801d80:	e8 db f7 ff ff       	call   801560 <fd2data>
  801d85:	89 c3                	mov    %eax,%ebx
  801d87:	01 fb                	add    %edi,%ebx
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	eb 42                	jmp    801dd0 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801d8e:	89 d8                	mov    %ebx,%eax
  801d90:	c1 e8 16             	shr    $0x16,%eax
  801d93:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801d9a:	a8 01                	test   $0x1,%al
  801d9c:	74 10                	je     801dae <file_write+0x77>
  801d9e:	89 d8                	mov    %ebx,%eax
  801da0:	c1 e8 0c             	shr    $0xc,%eax
  801da3:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801daa:	a8 01                	test   $0x1,%al
  801dac:	75 1c                	jne    801dca <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	8b 55 10             	mov    0x10(%ebp),%edx
  801db4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801db7:	50                   	push   %eax
  801db8:	57                   	push   %edi
  801db9:	56                   	push   %esi
  801dba:	e8 30 01 00 00       	call   801eef <fmap>
  801dbf:	83 c4 10             	add    $0x10,%esp
              return r;
  801dc2:	89 c1                	mov    %eax,%ecx
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	78 52                	js     801e1a <file_write+0xe3>
  801dc8:	eb 1b                	jmp    801de5 <file_write+0xae>
  801dca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	56                   	push   %esi
  801dd4:	e8 87 f7 ff ff       	call   801560 <fd2data>
  801dd9:	01 f8                	add    %edi,%eax
  801ddb:	03 45 10             	add    0x10(%ebp),%eax
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	39 d8                	cmp    %ebx,%eax
  801de3:	77 a9                	ja     801d8e <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801de5:	83 ec 0c             	sub    $0xc,%esp
  801de8:	68 36 33 80 00       	push   $0x803336
  801ded:	e8 9e e6 ff ff       	call   800490 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801df2:	83 c4 0c             	add    $0xc,%esp
  801df5:	ff 75 10             	pushl  0x10(%ebp)
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	56                   	push   %esi
  801dfc:	e8 5f f7 ff ff       	call   801560 <fd2data>
  801e01:	01 f8                	add    %edi,%eax
  801e03:	89 04 24             	mov    %eax,(%esp)
  801e06:	e8 05 ee ff ff       	call   800c10 <memmove>
        cprintf("write done\n");
  801e0b:	c7 04 24 43 33 80 00 	movl   $0x803343,(%esp)
  801e12:	e8 79 e6 ff ff       	call   800490 <cprintf>
	return n;
  801e17:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801e1a:	89 c8                	mov    %ecx,%eax
  801e1c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e2c:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801e2f:	83 ec 08             	sub    $0x8,%esp
  801e32:	8d 43 10             	lea    0x10(%ebx),%eax
  801e35:	50                   	push   %eax
  801e36:	56                   	push   %esi
  801e37:	e8 58 ec ff ff       	call   800a94 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801e3c:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801e42:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801e52:	0f 94 c0             	sete   %al
  801e55:	0f b6 c0             	movzbl %al,%eax
  801e58:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801e66:	5b                   	pop    %ebx
  801e67:	5e                   	pop    %esi
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	8b 75 08             	mov    0x8(%ebp),%esi
  801e76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801e79:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801e7e:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801e84:	7f 5f                	jg     801ee5 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801e86:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801e8c:	83 ec 08             	sub    $0x8,%esp
  801e8f:	53                   	push   %ebx
  801e90:	ff 76 0c             	pushl  0xc(%esi)
  801e93:	e8 3a 02 00 00       	call   8020d2 <fsipc_set_size>
  801e98:	83 c4 10             	add    $0x10,%esp
		return r;
  801e9b:	89 c2                	mov    %eax,%edx
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	78 44                	js     801ee5 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801ea1:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801ea7:	74 19                	je     801ec2 <file_trunc+0x58>
  801ea9:	68 70 33 80 00       	push   $0x803370
  801eae:	68 4f 33 80 00       	push   $0x80334f
  801eb3:	68 dc 00 00 00       	push   $0xdc
  801eb8:	68 64 33 80 00       	push   $0x803364
  801ebd:	e8 de e4 ff ff       	call   8003a0 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801ec2:	83 ec 04             	sub    $0x4,%esp
  801ec5:	53                   	push   %ebx
  801ec6:	57                   	push   %edi
  801ec7:	56                   	push   %esi
  801ec8:	e8 22 00 00 00       	call   801eef <fmap>
  801ecd:	83 c4 10             	add    $0x10,%esp
		return r;
  801ed0:	89 c2                	mov    %eax,%edx
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 0f                	js     801ee5 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801ed6:	6a 00                	push   $0x0
  801ed8:	53                   	push   %ebx
  801ed9:	57                   	push   %edi
  801eda:	56                   	push   %esi
  801edb:	e8 85 00 00 00       	call   801f65 <funmap>

	return 0;
  801ee0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801ee5:	89 d0                	mov    %edx,%eax
  801ee7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801eea:	5b                   	pop    %ebx
  801eeb:	5e                   	pop    %esi
  801eec:	5f                   	pop    %edi
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <fmap>:

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
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	57                   	push   %edi
  801ef3:	56                   	push   %esi
  801ef4:	53                   	push   %ebx
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	8b 7d 08             	mov    0x8(%ebp),%edi
  801efb:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801efe:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801f01:	7d 55                	jge    801f58 <fmap+0x69>
          fma = fd2data(fd);
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	57                   	push   %edi
  801f07:	e8 54 f6 ff ff       	call   801560 <fd2data>
  801f0c:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f15:	05 ff 0f 00 00       	add    $0xfff,%eax
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801f22:	39 f3                	cmp    %esi,%ebx
  801f24:	7d 32                	jge    801f58 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801f2c:	01 d8                	add    %ebx,%eax
  801f2e:	50                   	push   %eax
  801f2f:	53                   	push   %ebx
  801f30:	ff 77 0c             	pushl  0xc(%edi)
  801f33:	e8 6f 01 00 00       	call   8020a7 <fsipc_map>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	79 0f                	jns    801f4e <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801f3f:	6a 00                	push   $0x0
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	53                   	push   %ebx
  801f45:	57                   	push   %edi
  801f46:	e8 1a 00 00 00       	call   801f65 <funmap>
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f54:	39 f3                	cmp    %esi,%ebx
  801f56:	7c ce                	jl     801f26 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f60:	5b                   	pop    %ebx
  801f61:	5e                   	pop    %esi
  801f62:	5f                   	pop    %edi
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <funmap>:

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
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	57                   	push   %edi
  801f69:	56                   	push   %esi
  801f6a:	53                   	push   %ebx
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801f74:	39 f3                	cmp    %esi,%ebx
  801f76:	0f 8d 80 00 00 00    	jge    801ffc <funmap+0x97>
          fma = fd2data(fd);
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	e8 d9 f5 ff ff       	call   801560 <fd2data>
  801f87:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801f92:	89 c3                	mov    %eax,%ebx
  801f94:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801f9a:	39 f3                	cmp    %esi,%ebx
  801f9c:	7d 5e                	jge    801ffc <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801f9e:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801fa1:	89 c2                	mov    %eax,%edx
  801fa3:	c1 ea 0c             	shr    $0xc,%edx
  801fa6:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801fad:	a8 01                	test   $0x1,%al
  801faf:	74 41                	je     801ff2 <funmap+0x8d>
              if (dirty) {
  801fb1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801fb5:	74 21                	je     801fd8 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801fb7:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801fbe:	a8 40                	test   $0x40,%al
  801fc0:	74 16                	je     801fd8 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	53                   	push   %ebx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	ff 70 0c             	pushl  0xc(%eax)
  801fcc:	e8 49 01 00 00       	call   80211a <fsipc_dirty>
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 29                	js     802001 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801fd8:	83 ec 08             	sub    $0x8,%esp
  801fdb:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801fde:	50                   	push   %eax
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	e8 41 ee ff ff       	call   800e28 <sys_getenvid>
  801fe7:	89 04 24             	mov    %eax,(%esp)
  801fea:	e8 fc ee ff ff       	call   800eeb <sys_page_unmap>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ff8:	39 f3                	cmp    %esi,%ebx
  801ffa:	7c a2                	jl     801f9e <funmap+0x39>
            }
          }
        }

        return 0;
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802001:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802004:	5b                   	pop    %ebx
  802005:	5e                   	pop    %esi
  802006:	5f                   	pop    %edi
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <remove>:

// Delete a file
int
remove(const char *path)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  80200f:	ff 75 08             	pushl  0x8(%ebp)
  802012:	e8 2b 01 00 00       	call   802142 <fsipc_remove>
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  80201f:	e8 64 01 00 00       	call   802188 <fsipc_sync>
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    
	...

00802028 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80202e:	6a 07                	push   $0x7
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	ff 75 08             	pushl  0x8(%ebp)
  802036:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80203b:	50                   	push   %eax
  80203c:	e8 da 07 00 00       	call   80281b <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802041:	83 c4 0c             	add    $0xc,%esp
  802044:	ff 75 14             	pushl  0x14(%ebp)
  802047:	ff 75 10             	pushl  0x10(%ebp)
  80204a:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80204d:	50                   	push   %eax
  80204e:	e8 65 07 00 00       	call   8027b8 <ipc_recv>
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	56                   	push   %esi
  802059:	53                   	push   %ebx
  80205a:	83 ec 1c             	sub    $0x1c,%esp
  80205d:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  802060:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  802065:	56                   	push   %esi
  802066:	e8 ed e9 ff ff       	call   800a58 <strlen>
  80206b:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  80206e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802073:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802078:	7f 24                	jg     80209e <fsipc_open+0x49>
	strcpy(req->req_path, path);
  80207a:	83 ec 08             	sub    $0x8,%esp
  80207d:	56                   	push   %esi
  80207e:	53                   	push   %ebx
  80207f:	e8 10 ea ff ff       	call   800a94 <strcpy>
	req->req_omode = omode;
  802084:	8b 45 0c             	mov    0xc(%ebp),%eax
  802087:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  80208d:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802090:	50                   	push   %eax
  802091:	ff 75 10             	pushl  0x10(%ebp)
  802094:	53                   	push   %ebx
  802095:	6a 01                	push   $0x1
  802097:	e8 8c ff ff ff       	call   802028 <fsipc>
  80209c:	89 c2                	mov    %eax,%edx
}
  80209e:	89 d0                	mov    %edx,%eax
  8020a0:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8020a3:	5b                   	pop    %ebx
  8020a4:	5e                   	pop    %esi
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  8020bd:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8020c0:	50                   	push   %eax
  8020c1:	ff 75 10             	pushl  0x10(%ebp)
  8020c4:	68 00 40 80 00       	push   $0x804000
  8020c9:	6a 02                	push   $0x2
  8020cb:	e8 58 ff ff ff       	call   802028 <fsipc>

	//return -E_UNSPECIFIED;
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  8020e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e3:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	68 00 40 80 00       	push   $0x804000
  8020f1:	6a 03                	push   $0x3
  8020f3:	e8 30 ff ff ff       	call   802028 <fsipc>
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	68 00 40 80 00       	push   $0x804000
  802111:	6a 04                	push   $0x4
  802113:	e8 10 ff ff ff       	call   802028 <fsipc>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  802128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212b:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	68 00 40 80 00       	push   $0x804000
  802139:	6a 05                	push   $0x5
  80213b:	e8 e8 fe ff ff       	call   802028 <fsipc>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	56                   	push   %esi
  802146:	53                   	push   %ebx
  802147:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  80214a:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	53                   	push   %ebx
  802153:	e8 00 e9 ff ff       	call   800a58 <strlen>
  802158:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  80215b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802160:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802165:	7f 18                	jg     80217f <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  802167:	83 ec 08             	sub    $0x8,%esp
  80216a:	53                   	push   %ebx
  80216b:	56                   	push   %esi
  80216c:	e8 23 e9 ff ff       	call   800a94 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	56                   	push   %esi
  802176:	6a 06                	push   $0x6
  802178:	e8 ab fe ff ff       	call   802028 <fsipc>
  80217d:	89 c2                	mov    %eax,%edx
}
  80217f:	89 d0                	mov    %edx,%eax
  802181:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802184:	5b                   	pop    %ebx
  802185:	5e                   	pop    %esi
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	68 00 40 80 00       	push   $0x804000
  802197:	6a 07                	push   $0x7
  802199:	e8 8a fe ff ff       	call   802028 <fsipc>
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <pipe>:
};

int
pipe(int pfd[2])
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	57                   	push   %edi
  8021a4:	56                   	push   %esi
  8021a5:	53                   	push   %ebx
  8021a6:	83 ec 18             	sub    $0x18,%esp
  8021a9:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021ac:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8021af:	50                   	push   %eax
  8021b0:	e8 d3 f3 ff ff       	call   801588 <fd_alloc>
  8021b5:	89 c3                	mov    %eax,%ebx
  8021b7:	83 c4 10             	add    $0x10,%esp
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	0f 88 25 01 00 00    	js     8022e7 <pipe+0x147>
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	68 07 04 00 00       	push   $0x407
  8021ca:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8021cd:	6a 00                	push   $0x0
  8021cf:	e8 92 ec ff ff       	call   800e66 <sys_page_alloc>
  8021d4:	89 c3                	mov    %eax,%ebx
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	0f 88 06 01 00 00    	js     8022e7 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  8021e7:	50                   	push   %eax
  8021e8:	e8 9b f3 ff ff       	call   801588 <fd_alloc>
  8021ed:	89 c3                	mov    %eax,%ebx
  8021ef:	83 c4 10             	add    $0x10,%esp
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	0f 88 dd 00 00 00    	js     8022d7 <pipe+0x137>
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 07 04 00 00       	push   $0x407
  802202:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802205:	6a 00                	push   $0x0
  802207:	e8 5a ec ff ff       	call   800e66 <sys_page_alloc>
  80220c:	89 c3                	mov    %eax,%ebx
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	85 c0                	test   %eax,%eax
  802213:	0f 88 be 00 00 00    	js     8022d7 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80221f:	e8 3c f3 ff ff       	call   801560 <fd2data>
  802224:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802226:	83 c4 0c             	add    $0xc,%esp
  802229:	68 07 04 00 00       	push   $0x407
  80222e:	50                   	push   %eax
  80222f:	6a 00                	push   $0x0
  802231:	e8 30 ec ff ff       	call   800e66 <sys_page_alloc>
  802236:	89 c3                	mov    %eax,%ebx
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	85 c0                	test   %eax,%eax
  80223d:	0f 88 84 00 00 00    	js     8022c7 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802243:	83 ec 0c             	sub    $0xc,%esp
  802246:	68 07 04 00 00       	push   $0x407
  80224b:	83 ec 0c             	sub    $0xc,%esp
  80224e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802251:	e8 0a f3 ff ff       	call   801560 <fd2data>
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	50                   	push   %eax
  80225a:	6a 00                	push   $0x0
  80225c:	56                   	push   %esi
  80225d:	6a 00                	push   $0x0
  80225f:	e8 45 ec ff ff       	call   800ea9 <sys_page_map>
  802264:	89 c3                	mov    %eax,%ebx
  802266:	83 c4 20             	add    $0x20,%esp
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 4c                	js     8022b9 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80226d:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802273:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802276:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802278:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80227b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802282:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802288:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80228b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80228d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802290:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80229d:	e8 d6 f2 ff ff       	call   801578 <fd2num>
  8022a2:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8022a4:	83 c4 04             	add    $0x4,%esp
  8022a7:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8022aa:	e8 c9 f2 ff ff       	call   801578 <fd2num>
  8022af:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	eb 30                	jmp    8022e9 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  8022b9:	83 ec 08             	sub    $0x8,%esp
  8022bc:	56                   	push   %esi
  8022bd:	6a 00                	push   $0x0
  8022bf:	e8 27 ec ff ff       	call   800eeb <sys_page_unmap>
  8022c4:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8022c7:	83 ec 08             	sub    $0x8,%esp
  8022ca:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8022cd:	6a 00                	push   $0x0
  8022cf:	e8 17 ec ff ff       	call   800eeb <sys_page_unmap>
  8022d4:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8022d7:	83 ec 08             	sub    $0x8,%esp
  8022da:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8022dd:	6a 00                	push   $0x0
  8022df:	e8 07 ec ff ff       	call   800eeb <sys_page_unmap>
  8022e4:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  8022e7:	89 d8                	mov    %ebx,%eax
}
  8022e9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	57                   	push   %edi
  8022f5:	56                   	push   %esi
  8022f6:	53                   	push   %ebx
  8022f7:	83 ec 0c             	sub    $0xc,%esp
  8022fa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8022fd:	a1 80 74 80 00       	mov    0x807480,%eax
  802302:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802305:	83 ec 0c             	sub    $0xc,%esp
  802308:	ff 75 08             	pushl  0x8(%ebp)
  80230b:	e8 64 05 00 00       	call   802874 <pageref>
  802310:	89 c3                	mov    %eax,%ebx
  802312:	89 3c 24             	mov    %edi,(%esp)
  802315:	e8 5a 05 00 00       	call   802874 <pageref>
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	39 c3                	cmp    %eax,%ebx
  80231f:	0f 94 c0             	sete   %al
  802322:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802325:	8b 0d 80 74 80 00    	mov    0x807480,%ecx
  80232b:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80232e:	39 c6                	cmp    %eax,%esi
  802330:	74 1b                	je     80234d <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  802332:	83 fa 01             	cmp    $0x1,%edx
  802335:	75 c6                	jne    8022fd <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802337:	6a 01                	push   $0x1
  802339:	8b 41 58             	mov    0x58(%ecx),%eax
  80233c:	50                   	push   %eax
  80233d:	56                   	push   %esi
  80233e:	68 98 33 80 00       	push   $0x803398
  802343:	e8 48 e1 ff ff       	call   800490 <cprintf>
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	eb b0                	jmp    8022fd <_pipeisclosed+0xc>
	}
}
  80234d:	89 d0                	mov    %edx,%eax
  80234f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802352:	5b                   	pop    %ebx
  802353:	5e                   	pop    %esi
  802354:	5f                   	pop    %edi
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80235d:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802360:	50                   	push   %eax
  802361:	ff 75 08             	pushl  0x8(%ebp)
  802364:	e8 79 f2 ff ff       	call   8015e2 <fd_lookup>
  802369:	83 c4 10             	add    $0x10,%esp
		return r;
  80236c:	89 c2                	mov    %eax,%edx
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 19                	js     80238b <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  802372:	83 ec 0c             	sub    $0xc,%esp
  802375:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802378:	e8 e3 f1 ff ff       	call   801560 <fd2data>
	return _pipeisclosed(fd, p);
  80237d:	83 c4 08             	add    $0x8,%esp
  802380:	50                   	push   %eax
  802381:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802384:	e8 68 ff ff ff       	call   8022f1 <_pipeisclosed>
  802389:	89 c2                	mov    %eax,%edx
}
  80238b:	89 d0                	mov    %edx,%eax
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	57                   	push   %edi
  802393:	56                   	push   %esi
  802394:	53                   	push   %ebx
  802395:	83 ec 18             	sub    $0x18,%esp
  802398:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  80239b:	57                   	push   %edi
  80239c:	e8 bf f1 ff ff       	call   801560 <fd2data>
  8023a1:	89 c3                	mov    %eax,%ebx
	if (debug)
  8023a3:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8023a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a9:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8023ac:	be 00 00 00 00       	mov    $0x0,%esi
  8023b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023b4:	73 55                	jae    80240b <piperead+0x7c>
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
  8023b6:	8b 03                	mov    (%ebx),%eax
  8023b8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023bb:	75 2c                	jne    8023e9 <piperead+0x5a>
  8023bd:	85 f6                	test   %esi,%esi
  8023bf:	74 04                	je     8023c5 <piperead+0x36>
  8023c1:	89 f0                	mov    %esi,%eax
  8023c3:	eb 48                	jmp    80240d <piperead+0x7e>
  8023c5:	83 ec 08             	sub    $0x8,%esp
  8023c8:	53                   	push   %ebx
  8023c9:	57                   	push   %edi
  8023ca:	e8 22 ff ff ff       	call   8022f1 <_pipeisclosed>
  8023cf:	83 c4 10             	add    $0x10,%esp
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 07                	je     8023dd <piperead+0x4e>
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023db:	eb 30                	jmp    80240d <piperead+0x7e>
  8023dd:	e8 65 ea ff ff       	call   800e47 <sys_yield>
  8023e2:	8b 03                	mov    (%ebx),%eax
  8023e4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023e7:	74 d4                	je     8023bd <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023e9:	8b 13                	mov    (%ebx),%edx
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	85 d2                	test   %edx,%edx
  8023ef:	79 03                	jns    8023f4 <piperead+0x65>
  8023f1:	8d 42 1f             	lea    0x1f(%edx),%eax
  8023f4:	83 e0 e0             	and    $0xffffffe0,%eax
  8023f7:	29 c2                	sub    %eax,%edx
  8023f9:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  8023fd:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802400:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802403:	ff 03                	incl   (%ebx)
  802405:	46                   	inc    %esi
  802406:	3b 75 10             	cmp    0x10(%ebp),%esi
  802409:	72 ab                	jb     8023b6 <piperead+0x27>
	}
	return i;
  80240b:	89 f0                	mov    %esi,%eax
}
  80240d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802410:	5b                   	pop    %ebx
  802411:	5e                   	pop    %esi
  802412:	5f                   	pop    %edi
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	57                   	push   %edi
  802419:	56                   	push   %esi
  80241a:	53                   	push   %ebx
  80241b:	83 ec 18             	sub    $0x18,%esp
  80241e:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  802421:	57                   	push   %edi
  802422:	e8 39 f1 ff ff       	call   801560 <fd2data>
  802427:	89 c3                	mov    %eax,%ebx
	if (debug)
  802429:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802432:	be 00 00 00 00       	mov    $0x0,%esi
  802437:	3b 75 10             	cmp    0x10(%ebp),%esi
  80243a:	73 55                	jae    802491 <pipewrite+0x7c>
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
  80243c:	8b 03                	mov    (%ebx),%eax
  80243e:	83 c0 20             	add    $0x20,%eax
  802441:	39 43 04             	cmp    %eax,0x4(%ebx)
  802444:	72 27                	jb     80246d <pipewrite+0x58>
  802446:	83 ec 08             	sub    $0x8,%esp
  802449:	53                   	push   %ebx
  80244a:	57                   	push   %edi
  80244b:	e8 a1 fe ff ff       	call   8022f1 <_pipeisclosed>
  802450:	83 c4 10             	add    $0x10,%esp
  802453:	85 c0                	test   %eax,%eax
  802455:	74 07                	je     80245e <pipewrite+0x49>
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
  80245c:	eb 35                	jmp    802493 <pipewrite+0x7e>
  80245e:	e8 e4 e9 ff ff       	call   800e47 <sys_yield>
  802463:	8b 03                	mov    (%ebx),%eax
  802465:	83 c0 20             	add    $0x20,%eax
  802468:	39 43 04             	cmp    %eax,0x4(%ebx)
  80246b:	73 d9                	jae    802446 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80246d:	8b 53 04             	mov    0x4(%ebx),%edx
  802470:	89 d0                	mov    %edx,%eax
  802472:	85 d2                	test   %edx,%edx
  802474:	79 03                	jns    802479 <pipewrite+0x64>
  802476:	8d 42 1f             	lea    0x1f(%edx),%eax
  802479:	83 e0 e0             	and    $0xffffffe0,%eax
  80247c:	29 c2                	sub    %eax,%edx
  80247e:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  802481:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802484:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802488:	ff 43 04             	incl   0x4(%ebx)
  80248b:	46                   	inc    %esi
  80248c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80248f:	72 ab                	jb     80243c <pipewrite+0x27>
	}
	
	return i;
  802491:	89 f0                	mov    %esi,%eax
}
  802493:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802496:	5b                   	pop    %ebx
  802497:	5e                   	pop    %esi
  802498:	5f                   	pop    %edi
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	56                   	push   %esi
  80249f:	53                   	push   %ebx
  8024a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024a3:	83 ec 0c             	sub    $0xc,%esp
  8024a6:	ff 75 08             	pushl  0x8(%ebp)
  8024a9:	e8 b2 f0 ff ff       	call   801560 <fd2data>
  8024ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024b0:	83 c4 08             	add    $0x8,%esp
  8024b3:	68 ab 33 80 00       	push   $0x8033ab
  8024b8:	53                   	push   %ebx
  8024b9:	e8 d6 e5 ff ff       	call   800a94 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024be:	8b 46 04             	mov    0x4(%esi),%eax
  8024c1:	2b 06                	sub    (%esi),%eax
  8024c3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024c9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024d0:	00 00 00 
	stat->st_dev = &devpipe;
  8024d3:	c7 83 88 00 00 00 40 	movl   $0x807040,0x88(%ebx)
  8024da:	70 80 00 
	return 0;
}
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8024e5:	5b                   	pop    %ebx
  8024e6:	5e                   	pop    %esi
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	53                   	push   %ebx
  8024ed:	83 ec 0c             	sub    $0xc,%esp
  8024f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024f3:	53                   	push   %ebx
  8024f4:	6a 00                	push   $0x0
  8024f6:	e8 f0 e9 ff ff       	call   800eeb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024fb:	89 1c 24             	mov    %ebx,(%esp)
  8024fe:	e8 5d f0 ff ff       	call   801560 <fd2data>
  802503:	83 c4 08             	add    $0x8,%esp
  802506:	50                   	push   %eax
  802507:	6a 00                	push   $0x0
  802509:	e8 dd e9 ff ff       	call   800eeb <sys_page_unmap>
}
  80250e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802511:	c9                   	leave  
  802512:	c3                   	ret    
	...

00802514 <wait>:

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	56                   	push   %esi
  802518:	53                   	push   %ebx
  802519:	8b 75 08             	mov    0x8(%ebp),%esi
	volatile struct Env *e;

	assert(envid != 0);
  80251c:	85 f6                	test   %esi,%esi
  80251e:	75 16                	jne    802536 <wait+0x22>
  802520:	68 b2 33 80 00       	push   $0x8033b2
  802525:	68 4f 33 80 00       	push   $0x80334f
  80252a:	6a 09                	push   $0x9
  80252c:	68 bd 33 80 00       	push   $0x8033bd
  802531:	e8 6a de ff ff       	call   8003a0 <_panic>
	e = &envs[ENVX(envid)];
  802536:	89 f3                	mov    %esi,%ebx
  802538:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80253e:	89 d8                	mov    %ebx,%eax
  802540:	c1 e0 07             	shl    $0x7,%eax
  802543:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
		sys_yield();
  802549:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80254c:	39 f0                	cmp    %esi,%eax
  80254e:	75 1a                	jne    80256a <wait+0x56>
  802550:	8b 43 54             	mov    0x54(%ebx),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 13                	je     80256a <wait+0x56>
  802557:	e8 eb e8 ff ff       	call   800e47 <sys_yield>
  80255c:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80255f:	39 f0                	cmp    %esi,%eax
  802561:	75 07                	jne    80256a <wait+0x56>
  802563:	8b 43 54             	mov    0x54(%ebx),%eax
  802566:	85 c0                	test   %eax,%eax
  802568:	75 ed                	jne    802557 <wait+0x43>
}
  80256a:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5e                   	pop    %esi
  80256f:	c9                   	leave  
  802570:	c3                   	ret    
  802571:	00 00                	add    %al,(%eax)
	...

00802574 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802580:	6a 01                	push   $0x1
  802582:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802585:	50                   	push   %eax
  802586:	e8 19 e8 ff ff       	call   800da4 <sys_cputs>
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <getchar>:

int
getchar(void)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802593:	6a 01                	push   $0x1
  802595:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802598:	50                   	push   %eax
  802599:	6a 00                	push   $0x0
  80259b:	e8 d5 f2 ff ff       	call   801875 <read>
	if (r < 0)
  8025a0:	83 c4 10             	add    $0x10,%esp
		return r;
  8025a3:	89 c2                	mov    %eax,%edx
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	78 0d                	js     8025b6 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8025a9:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	7e 04                	jle    8025b6 <getchar+0x29>
	return c;
  8025b2:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  8025b6:	89 d0                	mov    %edx,%eax
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <iscons>:


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
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025c0:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8025c3:	50                   	push   %eax
  8025c4:	ff 75 08             	pushl  0x8(%ebp)
  8025c7:	e8 16 f0 ff ff       	call   8015e2 <fd_lookup>
  8025cc:	83 c4 10             	add    $0x10,%esp
		return r;
  8025cf:	89 c2                	mov    %eax,%edx
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	78 11                	js     8025e6 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8025d5:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  8025e0:	0f 94 c0             	sete   %al
  8025e3:	0f b6 d0             	movzbl %al,%edx
}
  8025e6:	89 d0                	mov    %edx,%eax
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <opencons>:

int
opencons(void)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025f0:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8025f3:	50                   	push   %eax
  8025f4:	e8 8f ef ff ff       	call   801588 <fd_alloc>
  8025f9:	83 c4 10             	add    $0x10,%esp
		return r;
  8025fc:	89 c2                	mov    %eax,%edx
  8025fe:	85 c0                	test   %eax,%eax
  802600:	78 3c                	js     80263e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	68 07 04 00 00       	push   $0x407
  80260a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80260d:	6a 00                	push   $0x0
  80260f:	e8 52 e8 ff ff       	call   800e66 <sys_page_alloc>
  802614:	83 c4 10             	add    $0x10,%esp
		return r;
  802617:	89 c2                	mov    %eax,%edx
  802619:	85 c0                	test   %eax,%eax
  80261b:	78 21                	js     80263e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80261d:	a1 60 70 80 00       	mov    0x807060,%eax
  802622:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  802625:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  802627:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80262a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802631:	83 ec 0c             	sub    $0xc,%esp
  802634:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802637:	e8 3c ef ff ff       	call   801578 <fd2num>
  80263c:	89 c2                	mov    %eax,%edx
}
  80263e:	89 d0                	mov    %edx,%eax
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802651:	74 2a                	je     80267d <cons_read+0x3b>
  802653:	eb 05                	jmp    80265a <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802655:	e8 ed e7 ff ff       	call   800e47 <sys_yield>
  80265a:	e8 69 e7 ff ff       	call   800dc8 <sys_cgetc>
  80265f:	89 c2                	mov    %eax,%edx
  802661:	85 c0                	test   %eax,%eax
  802663:	74 f0                	je     802655 <cons_read+0x13>
	if (c < 0)
  802665:	85 d2                	test   %edx,%edx
  802667:	78 14                	js     80267d <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	83 fa 04             	cmp    $0x4,%edx
  802671:	74 0a                	je     80267d <cons_read+0x3b>
	*(char*)vbuf = c;
  802673:	8b 45 0c             	mov    0xc(%ebp),%eax
  802676:	88 10                	mov    %dl,(%eax)
	return 1;
  802678:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80267d:	c9                   	leave  
  80267e:	c3                   	ret    

0080267f <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80267f:	55                   	push   %ebp
  802680:	89 e5                	mov    %esp,%ebp
  802682:	57                   	push   %edi
  802683:	56                   	push   %esi
  802684:	53                   	push   %ebx
  802685:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80268b:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80268e:	be 00 00 00 00       	mov    $0x0,%esi
  802693:	39 fe                	cmp    %edi,%esi
  802695:	73 3d                	jae    8026d4 <cons_write+0x55>
		m = n - tot;
  802697:	89 fb                	mov    %edi,%ebx
  802699:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80269b:	83 fb 7f             	cmp    $0x7f,%ebx
  80269e:	76 05                	jbe    8026a5 <cons_write+0x26>
			m = sizeof(buf) - 1;
  8026a0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	53                   	push   %ebx
  8026a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ac:	01 f0                	add    %esi,%eax
  8026ae:	50                   	push   %eax
  8026af:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8026b5:	50                   	push   %eax
  8026b6:	e8 55 e5 ff ff       	call   800c10 <memmove>
		sys_cputs(buf, m);
  8026bb:	83 c4 08             	add    $0x8,%esp
  8026be:	53                   	push   %ebx
  8026bf:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8026c5:	50                   	push   %eax
  8026c6:	e8 d9 e6 ff ff       	call   800da4 <sys_cputs>
  8026cb:	83 c4 10             	add    $0x10,%esp
  8026ce:	01 de                	add    %ebx,%esi
  8026d0:	39 fe                	cmp    %edi,%esi
  8026d2:	72 c3                	jb     802697 <cons_write+0x18>
	}
	return tot;
}
  8026d4:	89 f0                	mov    %esi,%eax
  8026d6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8026d9:	5b                   	pop    %ebx
  8026da:	5e                   	pop    %esi
  8026db:	5f                   	pop    %edi
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <cons_close>:

int
cons_close(struct Fd *fd)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026ee:	68 cd 33 80 00       	push   $0x8033cd
  8026f3:	ff 75 0c             	pushl  0xc(%ebp)
  8026f6:	e8 99 e3 ff ff       	call   800a94 <strcpy>
	return 0;
}
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	c9                   	leave  
  802701:	c3                   	ret    
	...

00802704 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
  802707:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80270a:	83 3d 88 74 80 00 00 	cmpl   $0x0,0x807488
  802711:	75 68                	jne    80277b <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	6a 07                	push   $0x7
  802718:	68 00 f0 bf ee       	push   $0xeebff000
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	e8 03 e7 ff ff       	call   800e28 <sys_getenvid>
  802725:	89 04 24             	mov    %eax,(%esp)
  802728:	e8 39 e7 ff ff       	call   800e66 <sys_page_alloc>
  80272d:	83 c4 10             	add    $0x10,%esp
  802730:	85 c0                	test   %eax,%eax
  802732:	79 14                	jns    802748 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  802734:	83 ec 04             	sub    $0x4,%esp
  802737:	68 d4 33 80 00       	push   $0x8033d4
  80273c:	6a 21                	push   $0x21
  80273e:	68 35 34 80 00       	push   $0x803435
  802743:	e8 58 dc ff ff       	call   8003a0 <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802748:	83 ec 08             	sub    $0x8,%esp
  80274b:	68 88 27 80 00       	push   $0x802788
  802750:	83 ec 04             	sub    $0x4,%esp
  802753:	e8 d0 e6 ff ff       	call   800e28 <sys_getenvid>
  802758:	89 04 24             	mov    %eax,(%esp)
  80275b:	e8 51 e8 ff ff       	call   800fb1 <sys_env_set_pgfault_upcall>
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	85 c0                	test   %eax,%eax
  802765:	79 14                	jns    80277b <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 04 34 80 00       	push   $0x803404
  80276f:	6a 24                	push   $0x24
  802771:	68 35 34 80 00       	push   $0x803435
  802776:	e8 25 dc ff ff       	call   8003a0 <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	a3 88 74 80 00       	mov    %eax,0x807488
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    
  802785:	00 00                	add    %al,(%eax)
	...

00802788 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802788:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802789:	a1 88 74 80 00       	mov    0x807488,%eax
	call *%eax
  80278e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802790:	83 c4 04             	add    $0x4,%esp
	
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
  802793:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  802797:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  80279b:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  80279e:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  8027a1:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  8027a4:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  8027a8:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  8027ab:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  8027af:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  8027b0:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  8027b3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  8027b4:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  8027b5:	c3                   	ret    
	...

008027b8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	56                   	push   %esi
  8027bc:	53                   	push   %ebx
  8027bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8027c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c3:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	75 12                	jne    8027dc <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	68 00 00 c0 ee       	push   $0xeec00000
  8027d2:	e8 3f e8 ff ff       	call   801016 <sys_ipc_recv>
  8027d7:	83 c4 10             	add    $0x10,%esp
  8027da:	eb 0c                	jmp    8027e8 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8027dc:	83 ec 0c             	sub    $0xc,%esp
  8027df:	50                   	push   %eax
  8027e0:	e8 31 e8 ff ff       	call   801016 <sys_ipc_recv>
  8027e5:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8027e8:	89 c2                	mov    %eax,%edx
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	78 24                	js     802812 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8027ee:	85 db                	test   %ebx,%ebx
  8027f0:	74 0a                	je     8027fc <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8027f2:	a1 80 74 80 00       	mov    0x807480,%eax
  8027f7:	8b 40 74             	mov    0x74(%eax),%eax
  8027fa:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8027fc:	85 f6                	test   %esi,%esi
  8027fe:	74 0a                	je     80280a <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802800:	a1 80 74 80 00       	mov    0x807480,%eax
  802805:	8b 40 78             	mov    0x78(%eax),%eax
  802808:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  80280a:	a1 80 74 80 00       	mov    0x807480,%eax
  80280f:	8b 50 70             	mov    0x70(%eax),%edx

}
  802812:	89 d0                	mov    %edx,%eax
  802814:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802817:	5b                   	pop    %ebx
  802818:	5e                   	pop    %esi
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <ipc_send>:

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
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	57                   	push   %edi
  80281f:	56                   	push   %esi
  802820:	53                   	push   %ebx
  802821:	83 ec 0c             	sub    $0xc,%esp
  802824:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802827:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80282a:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  80282d:	85 db                	test   %ebx,%ebx
  80282f:	75 0a                	jne    80283b <ipc_send+0x20>
    pg = (void *) UTOP;
  802831:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802836:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80283b:	56                   	push   %esi
  80283c:	53                   	push   %ebx
  80283d:	57                   	push   %edi
  80283e:	ff 75 08             	pushl  0x8(%ebp)
  802841:	e8 ad e7 ff ff       	call   800ff3 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802846:	83 c4 10             	add    $0x10,%esp
  802849:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80284c:	75 07                	jne    802855 <ipc_send+0x3a>
      sys_yield();
  80284e:	e8 f4 e5 ff ff       	call   800e47 <sys_yield>
  802853:	eb e6                	jmp    80283b <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802855:	85 c0                	test   %eax,%eax
  802857:	79 12                	jns    80286b <ipc_send+0x50>
  802859:	50                   	push   %eax
  80285a:	68 43 34 80 00       	push   $0x803443
  80285f:	6a 49                	push   $0x49
  802861:	68 60 34 80 00       	push   $0x803460
  802866:	e8 35 db ff ff       	call   8003a0 <_panic>
    else break;
  }
}
  80286b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80286e:	5b                   	pop    %ebx
  80286f:	5e                   	pop    %esi
  802870:	5f                   	pop    %edi
  802871:	c9                   	leave  
  802872:	c3                   	ret    
	...

00802874 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80287a:	89 c8                	mov    %ecx,%eax
  80287c:	c1 e8 16             	shr    $0x16,%eax
  80287f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802886:	ba 00 00 00 00       	mov    $0x0,%edx
  80288b:	a8 01                	test   $0x1,%al
  80288d:	74 28                	je     8028b7 <pageref+0x43>
	pte = vpt[VPN(v)];
  80288f:	89 c8                	mov    %ecx,%eax
  802891:	c1 e8 0c             	shr    $0xc,%eax
  802894:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80289b:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a0:	a8 01                	test   $0x1,%al
  8028a2:	74 13                	je     8028b7 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8028a4:	c1 e8 0c             	shr    $0xc,%eax
  8028a7:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8028aa:	c1 e0 02             	shl    $0x2,%eax
  8028ad:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8028b4:	0f b7 d0             	movzwl %ax,%edx
}
  8028b7:	89 d0                	mov    %edx,%eax
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    
	...

008028bc <__udivdi3>:
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	57                   	push   %edi
  8028c0:	56                   	push   %esi
  8028c1:	83 ec 14             	sub    $0x14,%esp
  8028c4:	8b 55 14             	mov    0x14(%ebp),%edx
  8028c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8028ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d0:	85 d2                	test   %edx,%edx
  8028d2:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8028d5:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8028d8:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8028db:	89 fe                	mov    %edi,%esi
  8028dd:	75 11                	jne    8028f0 <__udivdi3+0x34>
  8028df:	39 f8                	cmp    %edi,%eax
  8028e1:	76 4d                	jbe    802930 <__udivdi3+0x74>
  8028e3:	89 fa                	mov    %edi,%edx
  8028e5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8028e8:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8028eb:	89 c7                	mov    %eax,%edi
  8028ed:	eb 09                	jmp    8028f8 <__udivdi3+0x3c>
  8028ef:	90                   	nop    
  8028f0:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  8028f3:	76 17                	jbe    80290c <__udivdi3+0x50>
  8028f5:	31 ff                	xor    %edi,%edi
  8028f7:	90                   	nop    
  8028f8:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  8028ff:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802902:	83 c4 14             	add    $0x14,%esp
  802905:	5e                   	pop    %esi
  802906:	89 f8                	mov    %edi,%eax
  802908:	5f                   	pop    %edi
  802909:	c9                   	leave  
  80290a:	c3                   	ret    
  80290b:	90                   	nop    
  80290c:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802910:	89 c7                	mov    %eax,%edi
  802912:	83 f7 1f             	xor    $0x1f,%edi
  802915:	75 4d                	jne    802964 <__udivdi3+0xa8>
  802917:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  80291a:	77 0a                	ja     802926 <__udivdi3+0x6a>
  80291c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80291f:	31 ff                	xor    %edi,%edi
  802921:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802924:	72 d2                	jb     8028f8 <__udivdi3+0x3c>
  802926:	bf 01 00 00 00       	mov    $0x1,%edi
  80292b:	eb cb                	jmp    8028f8 <__udivdi3+0x3c>
  80292d:	8d 76 00             	lea    0x0(%esi),%esi
  802930:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	75 0e                	jne    802945 <__udivdi3+0x89>
  802937:	b8 01 00 00 00       	mov    $0x1,%eax
  80293c:	31 c9                	xor    %ecx,%ecx
  80293e:	31 d2                	xor    %edx,%edx
  802940:	f7 f1                	div    %ecx
  802942:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802945:	89 f0                	mov    %esi,%eax
  802947:	31 d2                	xor    %edx,%edx
  802949:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80294c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80294f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802952:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802955:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802958:	83 c4 14             	add    $0x14,%esp
  80295b:	89 c7                	mov    %eax,%edi
  80295d:	5e                   	pop    %esi
  80295e:	89 f8                	mov    %edi,%eax
  802960:	5f                   	pop    %edi
  802961:	c9                   	leave  
  802962:	c3                   	ret    
  802963:	90                   	nop    
  802964:	b8 20 00 00 00       	mov    $0x20,%eax
  802969:	29 f8                	sub    %edi,%eax
  80296b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80296e:	89 f9                	mov    %edi,%ecx
  802970:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802973:	d3 e2                	shl    %cl,%edx
  802975:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802978:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80297b:	d3 e8                	shr    %cl,%eax
  80297d:	09 c2                	or     %eax,%edx
  80297f:	89 f9                	mov    %edi,%ecx
  802981:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802984:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802987:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80298a:	89 f2                	mov    %esi,%edx
  80298c:	d3 ea                	shr    %cl,%edx
  80298e:	89 f9                	mov    %edi,%ecx
  802990:	d3 e6                	shl    %cl,%esi
  802992:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802995:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802998:	d3 e8                	shr    %cl,%eax
  80299a:	09 c6                	or     %eax,%esi
  80299c:	89 f9                	mov    %edi,%ecx
  80299e:	89 f0                	mov    %esi,%eax
  8029a0:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8029a3:	89 d6                	mov    %edx,%esi
  8029a5:	89 c7                	mov    %eax,%edi
  8029a7:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8029aa:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8029ad:	f7 e7                	mul    %edi
  8029af:	39 f2                	cmp    %esi,%edx
  8029b1:	77 0f                	ja     8029c2 <__udivdi3+0x106>
  8029b3:	0f 85 3f ff ff ff    	jne    8028f8 <__udivdi3+0x3c>
  8029b9:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  8029bc:	0f 86 36 ff ff ff    	jbe    8028f8 <__udivdi3+0x3c>
  8029c2:	4f                   	dec    %edi
  8029c3:	e9 30 ff ff ff       	jmp    8028f8 <__udivdi3+0x3c>

008029c8 <__umoddi3>:
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	57                   	push   %edi
  8029cc:	56                   	push   %esi
  8029cd:	83 ec 30             	sub    $0x30,%esp
  8029d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8029d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d6:	89 d7                	mov    %edx,%edi
  8029d8:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8029db:	89 c6                	mov    %eax,%esi
  8029dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	85 ff                	test   %edi,%edi
  8029e5:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  8029ec:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8029f3:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  8029f6:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8029f9:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8029fc:	75 3e                	jne    802a3c <__umoddi3+0x74>
  8029fe:	39 d6                	cmp    %edx,%esi
  802a00:	0f 86 a2 00 00 00    	jbe    802aa8 <__umoddi3+0xe0>
  802a06:	f7 f6                	div    %esi
  802a08:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802a0b:	85 c9                	test   %ecx,%ecx
  802a0d:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802a10:	74 1b                	je     802a2d <__umoddi3+0x65>
  802a12:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a15:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802a18:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802a1f:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802a22:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802a25:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802a28:	89 10                	mov    %edx,(%eax)
  802a2a:	89 48 04             	mov    %ecx,0x4(%eax)
  802a2d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802a30:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802a33:	83 c4 30             	add    $0x30,%esp
  802a36:	5e                   	pop    %esi
  802a37:	5f                   	pop    %edi
  802a38:	c9                   	leave  
  802a39:	c3                   	ret    
  802a3a:	89 f6                	mov    %esi,%esi
  802a3c:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802a3f:	76 1f                	jbe    802a60 <__umoddi3+0x98>
  802a41:	8b 55 08             	mov    0x8(%ebp),%edx
  802a44:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802a47:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802a4a:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802a4d:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802a50:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802a53:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802a56:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802a59:	83 c4 30             	add    $0x30,%esp
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	c9                   	leave  
  802a5f:	c3                   	ret    
  802a60:	0f bd c7             	bsr    %edi,%eax
  802a63:	83 f0 1f             	xor    $0x1f,%eax
  802a66:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802a69:	75 61                	jne    802acc <__umoddi3+0x104>
  802a6b:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  802a6e:	77 05                	ja     802a75 <__umoddi3+0xad>
  802a70:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  802a73:	72 10                	jb     802a85 <__umoddi3+0xbd>
  802a75:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802a78:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a7b:	29 f0                	sub    %esi,%eax
  802a7d:	19 fa                	sbb    %edi,%edx
  802a7f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802a82:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802a85:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802a88:	85 d2                	test   %edx,%edx
  802a8a:	74 a1                	je     802a2d <__umoddi3+0x65>
  802a8c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a8f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802a92:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802a95:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802a98:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802a9b:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802a9e:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802aa1:	89 01                	mov    %eax,(%ecx)
  802aa3:	89 51 04             	mov    %edx,0x4(%ecx)
  802aa6:	eb 85                	jmp    802a2d <__umoddi3+0x65>
  802aa8:	85 f6                	test   %esi,%esi
  802aaa:	75 0b                	jne    802ab7 <__umoddi3+0xef>
  802aac:	b8 01 00 00 00       	mov    $0x1,%eax
  802ab1:	31 d2                	xor    %edx,%edx
  802ab3:	f7 f6                	div    %esi
  802ab5:	89 c6                	mov    %eax,%esi
  802ab7:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802aba:	89 fa                	mov    %edi,%edx
  802abc:	f7 f6                	div    %esi
  802abe:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802ac1:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802ac4:	f7 f6                	div    %esi
  802ac6:	e9 3d ff ff ff       	jmp    802a08 <__umoddi3+0x40>
  802acb:	90                   	nop    
  802acc:	b8 20 00 00 00       	mov    $0x20,%eax
  802ad1:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802ad4:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802ad7:	89 fa                	mov    %edi,%edx
  802ad9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802adc:	d3 e2                	shl    %cl,%edx
  802ade:	89 f0                	mov    %esi,%eax
  802ae0:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802ae3:	d3 e8                	shr    %cl,%eax
  802ae5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802ae8:	d3 e6                	shl    %cl,%esi
  802aea:	89 d7                	mov    %edx,%edi
  802aec:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802aef:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802af2:	09 c7                	or     %eax,%edi
  802af4:	d3 ea                	shr    %cl,%edx
  802af6:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802af9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802afc:	d3 e0                	shl    %cl,%eax
  802afe:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802b01:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802b04:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802b07:	d3 e8                	shr    %cl,%eax
  802b09:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802b0c:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802b0f:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802b12:	f7 f7                	div    %edi
  802b14:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802b17:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802b1a:	f7 e6                	mul    %esi
  802b1c:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802b1f:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802b22:	77 0a                	ja     802b2e <__umoddi3+0x166>
  802b24:	75 12                	jne    802b38 <__umoddi3+0x170>
  802b26:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802b29:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802b2c:	76 0a                	jbe    802b38 <__umoddi3+0x170>
  802b2e:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802b31:	29 f1                	sub    %esi,%ecx
  802b33:	19 fa                	sbb    %edi,%edx
  802b35:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802b38:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	0f 84 ea fe ff ff    	je     802a2d <__umoddi3+0x65>
  802b43:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802b46:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802b49:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802b4c:	19 d1                	sbb    %edx,%ecx
  802b4e:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802b51:	89 ca                	mov    %ecx,%edx
  802b53:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802b56:	d3 e2                	shl    %cl,%edx
  802b58:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802b5b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802b5e:	d3 e8                	shr    %cl,%eax
  802b60:	09 c2                	or     %eax,%edx
  802b62:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802b65:	d3 e8                	shr    %cl,%eax
  802b67:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802b6a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802b6d:	e9 ad fe ff ff       	jmp    802a1f <__umoddi3+0x57>
