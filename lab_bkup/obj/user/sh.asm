
obj/user/sh:     file format elf32-i386

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
  80002c:	e8 e7 09 00 00       	call   800a18 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <runcmd>:
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	81 ec 64 04 00 00    	sub    $0x464,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800040:	bf 00 00 00 00       	mov    $0x0,%edi
	gettoken(s, 0);
  800045:	6a 00                	push   $0x0
  800047:	ff 75 08             	pushl  0x8(%ebp)
  80004a:	e8 7c 05 00 00       	call   8005cb <gettoken>
  80004f:	83 c4 10             	add    $0x10,%esp
	
again:
	argc = 0;
  800052:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800057:	83 ec 08             	sub    $0x8,%esp
  80005a:	8d 85 a4 fb ff ff    	lea    0xfffffba4(%ebp),%eax
  800060:	50                   	push   %eax
  800061:	6a 00                	push   $0x0
  800063:	e8 63 05 00 00       	call   8005cb <gettoken>
  800068:	83 c4 10             	add    $0x10,%esp
  80006b:	83 f8 77             	cmp    $0x77,%eax
  80006e:	74 38                	je     8000a8 <runcmd+0x74>
  800070:	83 f8 77             	cmp    $0x77,%eax
  800073:	7f 25                	jg     80009a <runcmd+0x66>
  800075:	83 f8 3c             	cmp    $0x3c,%eax
  800078:	74 55                	je     8000cf <runcmd+0x9b>
  80007a:	83 f8 3c             	cmp    $0x3c,%eax
  80007d:	7f 0d                	jg     80008c <runcmd+0x58>
  80007f:	85 c0                	test   %eax,%eax
  800081:	0f 84 63 02 00 00    	je     8002ea <runcmd+0x2b6>
  800087:	e9 4c 02 00 00       	jmp    8002d8 <runcmd+0x2a4>
  80008c:	83 f8 3e             	cmp    $0x3e,%eax
  80008f:	0f 84 c0 00 00 00    	je     800155 <runcmd+0x121>
  800095:	e9 3e 02 00 00       	jmp    8002d8 <runcmd+0x2a4>
  80009a:	83 f8 7c             	cmp    $0x7c,%eax
  80009d:	0f 84 43 01 00 00    	je     8001e6 <runcmd+0x1b2>
  8000a3:	e9 30 02 00 00       	jmp    8002d8 <runcmd+0x2a4>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000a8:	83 fe 10             	cmp    $0x10,%esi
  8000ab:	75 15                	jne    8000c2 <runcmd+0x8e>
				cprintf("too many arguments\n");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 60 38 80 00       	push   $0x803860
  8000b5:	e8 aa 0a 00 00       	call   800b64 <cprintf>
				exit();
  8000ba:	e8 9d 09 00 00       	call   800a5c <exit>
  8000bf:	83 c4 10             	add    $0x10,%esp
			}
			argv[argc++] = t;
  8000c2:	8b 85 a4 fb ff ff    	mov    0xfffffba4(%ebp),%eax
  8000c8:	89 44 b5 a8          	mov    %eax,0xffffffa8(%ebp,%esi,4)
  8000cc:	46                   	inc    %esi
			break;
  8000cd:	eb 88                	jmp    800057 <runcmd+0x23>
			
		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	8d 85 a4 fb ff ff    	lea    0xfffffba4(%ebp),%eax
  8000d8:	50                   	push   %eax
  8000d9:	6a 00                	push   $0x0
  8000db:	e8 eb 04 00 00       	call   8005cb <gettoken>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	83 f8 77             	cmp    $0x77,%eax
  8000e6:	74 15                	je     8000fd <runcmd+0xc9>
				cprintf("syntax error: < not followed by word\n");
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 f8 39 80 00       	push   $0x8039f8
  8000f0:	e8 6f 0a 00 00       	call   800b64 <cprintf>
				exit();
  8000f5:	e8 62 09 00 00       	call   800a5c <exit>
  8000fa:	83 c4 10             	add    $0x10,%esp
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	6a 00                	push   $0x0
  800102:	ff b5 a4 fb ff ff    	pushl  0xfffffba4(%ebp)
  800108:	e8 af 21 00 00       	call   8022bc <open>
  80010d:	89 c3                	mov    %eax,%ebx
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	85 c0                	test   %eax,%eax
  800114:	79 1c                	jns    800132 <runcmd+0xfe>
				cprintf("open %s for read: %e", t, fd);
  800116:	83 ec 04             	sub    $0x4,%esp
  800119:	50                   	push   %eax
  80011a:	ff b5 a4 fb ff ff    	pushl  0xfffffba4(%ebp)
  800120:	68 74 38 80 00       	push   $0x803874
  800125:	e8 3a 0a 00 00       	call   800b64 <cprintf>
				exit();
  80012a:	e8 2d 09 00 00       	call   800a5c <exit>
  80012f:	83 c4 10             	add    $0x10,%esp
			}
			if (fd != 0) {
  800132:	85 db                	test   %ebx,%ebx
  800134:	0f 84 1d ff ff ff    	je     800057 <runcmd+0x23>
				dup(fd, 0);
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	6a 00                	push   $0x0
  80013f:	53                   	push   %ebx
  800140:	e8 ba 1d 00 00       	call   801eff <dup>
				close(fd);
  800145:	89 1c 24             	mov    %ebx,(%esp)
  800148:	e8 61 1d 00 00       	call   801eae <close>
  80014d:	83 c4 10             	add    $0x10,%esp
			}
			break;
  800150:	e9 02 ff ff ff       	jmp    800057 <runcmd+0x23>
			
		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800155:	83 ec 08             	sub    $0x8,%esp
  800158:	8d 85 a4 fb ff ff    	lea    0xfffffba4(%ebp),%eax
  80015e:	50                   	push   %eax
  80015f:	6a 00                	push   $0x0
  800161:	e8 65 04 00 00       	call   8005cb <gettoken>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	83 f8 77             	cmp    $0x77,%eax
  80016c:	74 15                	je     800183 <runcmd+0x14f>
				cprintf("syntax error: > not followed by word\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 20 3a 80 00       	push   $0x803a20
  800176:	e8 e9 09 00 00       	call   800b64 <cprintf>
				exit();
  80017b:	e8 dc 08 00 00       	call   800a5c <exit>
  800180:	83 c4 10             	add    $0x10,%esp
			}
			if ((fd = open(t, O_WRONLY)) < 0) {
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	6a 01                	push   $0x1
  800188:	ff b5 a4 fb ff ff    	pushl  0xfffffba4(%ebp)
  80018e:	e8 29 21 00 00       	call   8022bc <open>
  800193:	89 c3                	mov    %eax,%ebx
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	85 c0                	test   %eax,%eax
  80019a:	79 1c                	jns    8001b8 <runcmd+0x184>
				cprintf("open %s for write: %e", t, fd);
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	50                   	push   %eax
  8001a0:	ff b5 a4 fb ff ff    	pushl  0xfffffba4(%ebp)
  8001a6:	68 89 38 80 00       	push   $0x803889
  8001ab:	e8 b4 09 00 00       	call   800b64 <cprintf>
				exit();
  8001b0:	e8 a7 08 00 00       	call   800a5c <exit>
  8001b5:	83 c4 10             	add    $0x10,%esp
			}
			if (fd != 1) {
  8001b8:	83 fb 01             	cmp    $0x1,%ebx
  8001bb:	74 16                	je     8001d3 <runcmd+0x19f>
				dup(fd, 1);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	6a 01                	push   $0x1
  8001c2:	53                   	push   %ebx
  8001c3:	e8 37 1d 00 00       	call   801eff <dup>
				close(fd);
  8001c8:	89 1c 24             	mov    %ebx,(%esp)
  8001cb:	e8 de 1c 00 00       	call   801eae <close>
  8001d0:	83 c4 10             	add    $0x10,%esp
			}
			ftruncate(fd, 0);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	6a 00                	push   $0x0
  8001d8:	53                   	push   %ebx
  8001d9:	e8 d2 1f 00 00       	call   8021b0 <ftruncate>
			break;
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	e9 71 fe ff ff       	jmp    800057 <runcmd+0x23>
			
		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8001e6:	83 ec 0c             	sub    $0xc,%esp
  8001e9:	8d 85 98 fb ff ff    	lea    0xfffffb98(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 1b 2e 00 00       	call   803010 <pipe>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	85 c0                	test   %eax,%eax
  8001fa:	79 16                	jns    800212 <runcmd+0x1de>
				cprintf("pipe: %e", r);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	50                   	push   %eax
  800200:	68 9f 38 80 00       	push   $0x80389f
  800205:	e8 5a 09 00 00       	call   800b64 <cprintf>
				exit();
  80020a:	e8 4d 08 00 00       	call   800a5c <exit>
  80020f:	83 c4 10             	add    $0x10,%esp
			}
			if (debug)
  800212:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800219:	74 1c                	je     800237 <runcmd+0x203>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80021b:	83 ec 04             	sub    $0x4,%esp
  80021e:	ff b5 9c fb ff ff    	pushl  0xfffffb9c(%ebp)
  800224:	ff b5 98 fb ff ff    	pushl  0xfffffb98(%ebp)
  80022a:	68 a8 38 80 00       	push   $0x8038a8
  80022f:	e8 30 09 00 00       	call   800b64 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
			if ((r = fork()) < 0) {
  800237:	e8 46 19 00 00       	call   801b82 <fork>
  80023c:	89 c3                	mov    %eax,%ebx
  80023e:	85 c0                	test   %eax,%eax
  800240:	79 16                	jns    800258 <runcmd+0x224>
				cprintf("fork: %e", r);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	50                   	push   %eax
  800246:	68 b5 38 80 00       	push   $0x8038b5
  80024b:	e8 14 09 00 00       	call   800b64 <cprintf>
				exit();
  800250:	e8 07 08 00 00       	call   800a5c <exit>
  800255:	83 c4 10             	add    $0x10,%esp
			}
			if (r == 0) {
  800258:	85 db                	test   %ebx,%ebx
  80025a:	75 40                	jne    80029c <runcmd+0x268>
				if (p[0] != 0) {
  80025c:	83 bd 98 fb ff ff 00 	cmpl   $0x0,0xfffffb98(%ebp)
  800263:	74 21                	je     800286 <runcmd+0x252>
					dup(p[0], 0);
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	6a 00                	push   $0x0
  80026a:	ff b5 98 fb ff ff    	pushl  0xfffffb98(%ebp)
  800270:	e8 8a 1c 00 00       	call   801eff <dup>
					close(p[0]);
  800275:	83 c4 04             	add    $0x4,%esp
  800278:	ff b5 98 fb ff ff    	pushl  0xfffffb98(%ebp)
  80027e:	e8 2b 1c 00 00       	call   801eae <close>
  800283:	83 c4 10             	add    $0x10,%esp
				}
				close(p[1]);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff b5 9c fb ff ff    	pushl  0xfffffb9c(%ebp)
  80028f:	e8 1a 1c 00 00       	call   801eae <close>
				goto again;
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	e9 b6 fd ff ff       	jmp    800052 <runcmd+0x1e>
			} else {
				pipe_child = r;
  80029c:	89 df                	mov    %ebx,%edi
				if (p[1] != 1) {
  80029e:	8d 9d 98 fb ff ff    	lea    0xfffffb98(%ebp),%ebx
  8002a4:	83 7b 04 01          	cmpl   $0x1,0x4(%ebx)
  8002a8:	74 1b                	je     8002c5 <runcmd+0x291>
					dup(p[1], 1);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	6a 01                	push   $0x1
  8002af:	ff 73 04             	pushl  0x4(%ebx)
  8002b2:	e8 48 1c 00 00       	call   801eff <dup>
					close(p[1]);
  8002b7:	83 c4 04             	add    $0x4,%esp
  8002ba:	ff 73 04             	pushl  0x4(%ebx)
  8002bd:	e8 ec 1b 00 00       	call   801eae <close>
  8002c2:	83 c4 10             	add    $0x10,%esp
				}
				close(p[0]);
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	ff b5 98 fb ff ff    	pushl  0xfffffb98(%ebp)
  8002ce:	e8 db 1b 00 00       	call   801eae <close>
				goto runit;
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	eb 12                	jmp    8002ea <runcmd+0x2b6>
			}
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
			
		default:
			panic("bad return %d from gettoken", c);
  8002d8:	50                   	push   %eax
  8002d9:	68 be 38 80 00       	push   $0x8038be
  8002de:	6a 6f                	push   $0x6f
  8002e0:	68 da 38 80 00       	push   $0x8038da
  8002e5:	e8 8a 07 00 00       	call   800a74 <_panic>
			break;
			
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8002ea:	85 f6                	test   %esi,%esi
  8002ec:	75 22                	jne    800310 <runcmd+0x2dc>
		if (debug)
  8002ee:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8002f5:	0f 84 81 01 00 00    	je     80047c <runcmd+0x448>
			cprintf("EMPTY COMMAND\n");
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	68 e4 38 80 00       	push   $0x8038e4
  800303:	e8 5c 08 00 00       	call   800b64 <cprintf>
  800308:	83 c4 10             	add    $0x10,%esp
		return;
  80030b:	e9 6c 01 00 00       	jmp    80047c <runcmd+0x448>
	}

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800310:	8b 45 a8             	mov    0xffffffa8(%ebp),%eax
  800313:	80 38 2f             	cmpb   $0x2f,(%eax)
  800316:	74 23                	je     80033b <runcmd+0x307>
		argv0buf[0] = '/';
  800318:	c6 85 a8 fb ff ff 2f 	movb   $0x2f,0xfffffba8(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80031f:	83 ec 08             	sub    $0x8,%esp
  800322:	50                   	push   %eax
  800323:	8d 9d a8 fb ff ff    	lea    0xfffffba8(%ebp),%ebx
  800329:	8d 85 a9 fb ff ff    	lea    0xfffffba9(%ebp),%eax
  80032f:	50                   	push   %eax
  800330:	e8 0b 0f 00 00       	call   801240 <strcpy>
		argv[0] = argv0buf;
  800335:	89 5d a8             	mov    %ebx,0xffffffa8(%ebp)
  800338:	83 c4 10             	add    $0x10,%esp
	}
	argv[argc] = 0;
  80033b:	c7 44 b5 a8 00 00 00 	movl   $0x0,0xffffffa8(%ebp,%esi,4)
  800342:	00 
	
	// Print the command.
	if (debug) {
  800343:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80034a:	74 50                	je     80039c <runcmd+0x368>
		cprintf("[%08x] SPAWN:", env->env_id);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800354:	8b 40 4c             	mov    0x4c(%eax),%eax
  800357:	50                   	push   %eax
  800358:	68 f3 38 80 00       	push   $0x8038f3
  80035d:	e8 02 08 00 00       	call   800b64 <cprintf>
		for (i = 0; argv[i]; i++)
  800362:	bb 00 00 00 00       	mov    $0x0,%ebx
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	83 7d a8 00          	cmpl   $0x0,0xffffffa8(%ebp)
  80036e:	74 1c                	je     80038c <runcmd+0x358>
			cprintf(" %s", argv[i]);
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 74 9d a8          	pushl  0xffffffa8(%ebp,%ebx,4)
  800377:	68 c0 39 80 00       	push   $0x8039c0
  80037c:	e8 e3 07 00 00       	call   800b64 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	43                   	inc    %ebx
  800385:	83 7c 9d a8 00       	cmpl   $0x0,0xffffffa8(%ebp,%ebx,4)
  80038a:	75 e4                	jne    800370 <runcmd+0x33c>
		cprintf("\n");
  80038c:	83 ec 0c             	sub    $0xc,%esp
  80038f:	68 77 39 80 00       	push   $0x803977
  800394:	e8 cb 07 00 00       	call   800b64 <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	8d 45 a8             	lea    0xffffffa8(%ebp),%eax
  8003a2:	50                   	push   %eax
  8003a3:	ff 75 a8             	pushl  0xffffffa8(%ebp)
  8003a6:	e8 bd 26 00 00       	call   802a68 <spawn>
  8003ab:	89 c3                	mov    %eax,%ebx
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	79 14                	jns    8003c8 <runcmd+0x394>
		cprintf("spawn %s: %e\n", argv[0], r);
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	50                   	push   %eax
  8003b8:	ff 75 a8             	pushl  0xffffffa8(%ebp)
  8003bb:	68 01 39 80 00       	push   $0x803901
  8003c0:	e8 9f 07 00 00       	call   800b64 <cprintf>
  8003c5:	83 c4 10             	add    $0x10,%esp

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8003c8:	e8 0f 1b 00 00       	call   801edc <close_all>
	if (r >= 0) {
  8003cd:	85 db                	test   %ebx,%ebx
  8003cf:	78 51                	js     800422 <runcmd+0x3ee>
		if (debug)
  8003d1:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8003d8:	74 1a                	je     8003f4 <runcmd+0x3c0>
			cprintf("[%08x] WAIT %s %08x\n", env->env_id, argv[0], r);
  8003da:	53                   	push   %ebx
  8003db:	ff 75 a8             	pushl  0xffffffa8(%ebp)
  8003de:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8003e3:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003e6:	50                   	push   %eax
  8003e7:	68 0f 39 80 00       	push   $0x80390f
  8003ec:	e8 73 07 00 00       	call   800b64 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		wait(r);
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	53                   	push   %ebx
  8003f8:	e8 87 2f 00 00       	call   803384 <wait>
		if (debug)
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800407:	74 19                	je     800422 <runcmd+0x3ee>
			cprintf("[%08x] wait finished\n", env->env_id);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800411:	8b 40 4c             	mov    0x4c(%eax),%eax
  800414:	50                   	push   %eax
  800415:	68 24 39 80 00       	push   $0x803924
  80041a:	e8 45 07 00 00       	call   800b64 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800422:	85 ff                	test   %edi,%edi
  800424:	74 51                	je     800477 <runcmd+0x443>
		if (debug)
  800426:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80042d:	74 1a                	je     800449 <runcmd+0x415>
			cprintf("[%08x] WAIT pipe_child %08x\n", env->env_id, pipe_child);
  80042f:	83 ec 04             	sub    $0x4,%esp
  800432:	57                   	push   %edi
  800433:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800438:	8b 40 4c             	mov    0x4c(%eax),%eax
  80043b:	50                   	push   %eax
  80043c:	68 3a 39 80 00       	push   $0x80393a
  800441:	e8 1e 07 00 00       	call   800b64 <cprintf>
  800446:	83 c4 10             	add    $0x10,%esp
		wait(pipe_child);
  800449:	83 ec 0c             	sub    $0xc,%esp
  80044c:	57                   	push   %edi
  80044d:	e8 32 2f 00 00       	call   803384 <wait>
		if (debug)
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80045c:	74 19                	je     800477 <runcmd+0x443>
			cprintf("[%08x] wait finished\n", env->env_id);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800466:	8b 40 4c             	mov    0x4c(%eax),%eax
  800469:	50                   	push   %eax
  80046a:	68 24 39 80 00       	push   $0x803924
  80046f:	e8 f0 06 00 00       	call   800b64 <cprintf>
  800474:	83 c4 10             	add    $0x10,%esp
	}

	// Done!
	exit();
  800477:	e8 e0 05 00 00       	call   800a5c <exit>
}
  80047c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80047f:	5b                   	pop    %ebx
  800480:	5e                   	pop    %esi
  800481:	5f                   	pop    %edi
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <_gettoken>:


// Get the next token from string s.
// Set *p1 to the beginning of the token and *p2 just past the token.
// Returns
//	0 for end-of-string;
//	< for <;
//	> for >;
//	| for |;
//	w for a word.
//
// Eventually (once we parse the space where the \0 will go),
// words get nul-terminated.
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	57                   	push   %edi
  800488:	56                   	push   %esi
  800489:	53                   	push   %ebx
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800490:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800493:	85 db                	test   %ebx,%ebx
  800495:	75 23                	jne    8004ba <_gettoken+0x36>
		if (debug > 1)
  800497:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  80049e:	7e 10                	jle    8004b0 <_gettoken+0x2c>
			cprintf("GETTOKEN NULL\n");
  8004a0:	83 ec 0c             	sub    $0xc,%esp
  8004a3:	68 57 39 80 00       	push   $0x803957
  8004a8:	e8 b7 06 00 00       	call   800b64 <cprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
		return 0;
  8004b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b5:	e9 09 01 00 00       	jmp    8005c3 <_gettoken+0x13f>
	}

	if (debug > 1)
  8004ba:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  8004c1:	7e 11                	jle    8004d4 <_gettoken+0x50>
		cprintf("GETTOKEN: %s\n", s);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	53                   	push   %ebx
  8004c7:	68 66 39 80 00       	push   $0x803966
  8004cc:	e8 93 06 00 00       	call   800b64 <cprintf>
  8004d1:	83 c4 10             	add    $0x10,%esp

	*p1 = 0;
  8004d4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  8004da:	8b 45 10             	mov    0x10(%ebp),%eax
  8004dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  8004e3:	eb 04                	jmp    8004e9 <_gettoken+0x65>
		*s++ = 0;
  8004e5:	c6 03 00             	movb   $0x0,(%ebx)
  8004e8:	43                   	inc    %ebx
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	0f be 03             	movsbl (%ebx),%eax
  8004ef:	50                   	push   %eax
  8004f0:	68 74 39 80 00       	push   $0x803974
  8004f5:	e8 36 0e 00 00       	call   801330 <strchr>
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	85 c0                	test   %eax,%eax
  8004ff:	75 e4                	jne    8004e5 <_gettoken+0x61>
	if (*s == 0) {
  800501:	80 3b 00             	cmpb   $0x0,(%ebx)
  800504:	75 23                	jne    800529 <_gettoken+0xa5>
		if (debug > 1)
  800506:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  80050d:	7e 10                	jle    80051f <_gettoken+0x9b>
			cprintf("EOL\n");
  80050f:	83 ec 0c             	sub    $0xc,%esp
  800512:	68 79 39 80 00       	push   $0x803979
  800517:	e8 48 06 00 00       	call   800b64 <cprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80051f:	b8 00 00 00 00       	mov    $0x0,%eax
  800524:	e9 9a 00 00 00       	jmp    8005c3 <_gettoken+0x13f>
	}
	if (strchr(SYMBOLS, *s)) {
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	0f be 03             	movsbl (%ebx),%eax
  80052f:	50                   	push   %eax
  800530:	68 8a 39 80 00       	push   $0x80398a
  800535:	e8 f6 0d 00 00       	call   801330 <strchr>
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	85 c0                	test   %eax,%eax
  80053f:	74 2c                	je     80056d <_gettoken+0xe9>
		t = *s;
  800541:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  800544:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800546:	c6 03 00             	movb   $0x0,(%ebx)
  800549:	43                   	inc    %ebx
		*p2 = s;
  80054a:	8b 55 10             	mov    0x10(%ebp),%edx
  80054d:	89 1a                	mov    %ebx,(%edx)
		if (debug > 1)
  80054f:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  800556:	7e 11                	jle    800569 <_gettoken+0xe5>
			cprintf("TOK %c\n", t);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	56                   	push   %esi
  80055c:	68 7e 39 80 00       	push   $0x80397e
  800561:	e8 fe 05 00 00       	call   800b64 <cprintf>
  800566:	83 c4 10             	add    $0x10,%esp
		return t;
  800569:	89 f0                	mov    %esi,%eax
  80056b:	eb 56                	jmp    8005c3 <_gettoken+0x13f>
	}
	*p1 = s;
  80056d:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80056f:	eb 01                	jmp    800572 <_gettoken+0xee>
		s++;
  800571:	43                   	inc    %ebx
  800572:	80 3b 00             	cmpb   $0x0,(%ebx)
  800575:	74 18                	je     80058f <_gettoken+0x10b>
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	0f be 03             	movsbl (%ebx),%eax
  80057d:	50                   	push   %eax
  80057e:	68 86 39 80 00       	push   $0x803986
  800583:	e8 a8 0d 00 00       	call   801330 <strchr>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	85 c0                	test   %eax,%eax
  80058d:	74 e2                	je     800571 <_gettoken+0xed>
	*p2 = s;
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 18                	mov    %ebx,(%eax)
	if (debug > 1) {
  800594:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  80059b:	7e 21                	jle    8005be <_gettoken+0x13a>
		t = **p2;
  80059d:	0f be 33             	movsbl (%ebx),%esi
		**p2 = 0;
  8005a0:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	ff 37                	pushl  (%edi)
  8005a8:	68 92 39 80 00       	push   $0x803992
  8005ad:	e8 b2 05 00 00       	call   800b64 <cprintf>
		**p2 = t;
  8005b2:	8b 55 10             	mov    0x10(%ebp),%edx
  8005b5:	8b 02                	mov    (%edx),%eax
  8005b7:	89 f2                	mov    %esi,%edx
  8005b9:	88 10                	mov    %dl,(%eax)
  8005bb:	83 c4 10             	add    $0x10,%esp
	}
	return 'w';
  8005be:	b8 77 00 00 00       	mov    $0x77,%eax
}
  8005c3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8005c6:	5b                   	pop    %ebx
  8005c7:	5e                   	pop    %esi
  8005c8:	5f                   	pop    %edi
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <gettoken>:

int
gettoken(char *s, char **p1)
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8005d4:	85 c0                	test   %eax,%eax
  8005d6:	74 1f                	je     8005f7 <gettoken+0x2c>
		nc = _gettoken(s, &np1, &np2);
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	68 90 80 80 00       	push   $0x808090
  8005e0:	68 8c 80 80 00       	push   $0x80808c
  8005e5:	50                   	push   %eax
  8005e6:	e8 99 fe ff ff       	call   800484 <_gettoken>
  8005eb:	a3 88 80 80 00       	mov    %eax,0x808088
		return 0;
  8005f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f5:	eb 37                	jmp    80062e <gettoken+0x63>
	}
	c = nc;
  8005f7:	a1 88 80 80 00       	mov    0x808088,%eax
  8005fc:	a3 84 80 80 00       	mov    %eax,0x808084
	*p1 = np1;
  800601:	8b 15 8c 80 80 00    	mov    0x80808c,%edx
  800607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060a:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	68 90 80 80 00       	push   $0x808090
  800614:	68 8c 80 80 00       	push   $0x80808c
  800619:	ff 35 90 80 80 00    	pushl  0x808090
  80061f:	e8 60 fe ff ff       	call   800484 <_gettoken>
  800624:	a3 88 80 80 00       	mov    %eax,0x808088
	return c;
  800629:	a1 84 80 80 00       	mov    0x808084,%eax
}
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

00800630 <usage>:


void
usage(void)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800636:	68 48 3a 80 00       	push   $0x803a48
  80063b:	e8 24 05 00 00       	call   800b64 <cprintf>
	exit();
  800640:	e8 17 04 00 00       	call   800a5c <exit>
}
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <umain>:

void
umain(int argc, char **argv)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
  80064a:	57                   	push   %edi
  80064b:	56                   	push   %esi
  80064c:	53                   	push   %ebx
  80064d:	83 ec 0c             	sub    $0xc,%esp
  800650:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;

	interactive = '?';
  800653:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
  800658:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
	ARGBEGIN{
  80065f:	85 f6                	test   %esi,%esi
  800661:	75 03                	jne    800666 <umain+0x1f>
  800663:	8d 75 08             	lea    0x8(%ebp),%esi
  800666:	83 3d a4 84 80 00 00 	cmpl   $0x0,0x8084a4
  80066d:	75 07                	jne    800676 <umain+0x2f>
  80066f:	8b 06                	mov    (%esi),%eax
  800671:	a3 a4 84 80 00       	mov    %eax,0x8084a4
  800676:	83 c6 04             	add    $0x4,%esi
  800679:	ff 4d 08             	decl   0x8(%ebp)
  80067c:	83 3e 00             	cmpl   $0x0,(%esi)
  80067f:	0f 84 8e 00 00 00    	je     800713 <umain+0xcc>
  800685:	8b 06                	mov    (%esi),%eax
  800687:	80 38 2d             	cmpb   $0x2d,(%eax)
  80068a:	0f 85 83 00 00 00    	jne    800713 <umain+0xcc>
  800690:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800694:	74 7d                	je     800713 <umain+0xcc>
  800696:	8b 06                	mov    (%esi),%eax
  800698:	8d 58 01             	lea    0x1(%eax),%ebx
  80069b:	80 78 01 2d          	cmpb   $0x2d,0x1(%eax)
  80069f:	75 0a                	jne    8006ab <umain+0x64>
  8006a1:	80 7b 01 00          	cmpb   $0x0,0x1(%ebx)
  8006a5:	0f 84 b0 00 00 00    	je     80075b <umain+0x114>
	case 'd':
		debug++;
		break;
	case 'i':
		interactive = 1;
		break;
	case 'x':
		echocmds = 1;
		break;
	default:
		usage();
  8006ab:	80 3b 00             	cmpb   $0x0,(%ebx)
  8006ae:	74 4b                	je     8006fb <umain+0xb4>
  8006b0:	8a 03                	mov    (%ebx),%al
  8006b2:	43                   	inc    %ebx
  8006b3:	84 c0                	test   %al,%al
  8006b5:	74 44                	je     8006fb <umain+0xb4>
  8006b7:	0f be c0             	movsbl %al,%eax
  8006ba:	83 f8 69             	cmp    $0x69,%eax
  8006bd:	74 1b                	je     8006da <umain+0x93>
  8006bf:	83 f8 69             	cmp    $0x69,%eax
  8006c2:	7f 07                	jg     8006cb <umain+0x84>
  8006c4:	83 f8 64             	cmp    $0x64,%eax
  8006c7:	74 09                	je     8006d2 <umain+0x8b>
  8006c9:	eb 1f                	jmp    8006ea <umain+0xa3>
  8006cb:	83 f8 78             	cmp    $0x78,%eax
  8006ce:	74 11                	je     8006e1 <umain+0x9a>
  8006d0:	eb 18                	jmp    8006ea <umain+0xa3>
  8006d2:	ff 05 80 80 80 00    	incl   0x808080
  8006d8:	eb 15                	jmp    8006ef <umain+0xa8>
  8006da:	bf 01 00 00 00       	mov    $0x1,%edi
  8006df:	eb 0e                	jmp    8006ef <umain+0xa8>
  8006e1:	c7 45 f0 01 00 00 00 	movl   $0x1,0xfffffff0(%ebp)
  8006e8:	eb 05                	jmp    8006ef <umain+0xa8>
  8006ea:	e8 41 ff ff ff       	call   800630 <usage>
  8006ef:	80 3b 00             	cmpb   $0x0,(%ebx)
  8006f2:	74 07                	je     8006fb <umain+0xb4>
  8006f4:	8a 03                	mov    (%ebx),%al
  8006f6:	43                   	inc    %ebx
  8006f7:	84 c0                	test   %al,%al
  8006f9:	75 bc                	jne    8006b7 <umain+0x70>
  8006fb:	ff 4d 08             	decl   0x8(%ebp)
  8006fe:	83 c6 04             	add    $0x4,%esi
  800701:	83 3e 00             	cmpl   $0x0,(%esi)
  800704:	74 0d                	je     800713 <umain+0xcc>
  800706:	8b 06                	mov    (%esi),%eax
  800708:	80 38 2d             	cmpb   $0x2d,(%eax)
  80070b:	75 06                	jne    800713 <umain+0xcc>
  80070d:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800711:	75 83                	jne    800696 <umain+0x4f>
	}ARGEND

	if (argc > 1)
  800713:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800717:	7e 05                	jle    80071e <umain+0xd7>
		usage();
  800719:	e8 12 ff ff ff       	call   800630 <usage>
	if (argc == 1) {
  80071e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800722:	75 5c                	jne    800780 <umain+0x139>
		close(0);
  800724:	83 ec 0c             	sub    $0xc,%esp
  800727:	6a 00                	push   $0x0
  800729:	e8 80 17 00 00       	call   801eae <close>
		if ((r = open(argv[0], O_RDONLY)) < 0)
  80072e:	83 c4 08             	add    $0x8,%esp
  800731:	6a 00                	push   $0x0
  800733:	ff 36                	pushl  (%esi)
  800735:	e8 82 1b 00 00       	call   8022bc <open>
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	85 c0                	test   %eax,%eax
  80073f:	79 22                	jns    800763 <umain+0x11c>
			panic("open %s: %e", argv[0], r);
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	50                   	push   %eax
  800745:	ff 36                	pushl  (%esi)
  800747:	68 9c 39 80 00       	push   $0x80399c
  80074c:	68 1c 01 00 00       	push   $0x11c
  800751:	68 da 38 80 00       	push   $0x8038da
  800756:	e8 19 03 00 00       	call   800a74 <_panic>
  80075b:	ff 4d 08             	decl   0x8(%ebp)
  80075e:	83 c6 04             	add    $0x4,%esi
  800761:	eb b0                	jmp    800713 <umain+0xcc>
		assert(r == 0);
  800763:	85 c0                	test   %eax,%eax
  800765:	74 19                	je     800780 <umain+0x139>
  800767:	68 a8 39 80 00       	push   $0x8039a8
  80076c:	68 af 39 80 00       	push   $0x8039af
  800771:	68 1d 01 00 00       	push   $0x11d
  800776:	68 da 38 80 00       	push   $0x8038da
  80077b:	e8 f4 02 00 00       	call   800a74 <_panic>
	}
	if (interactive == '?')
  800780:	83 ff 3f             	cmp    $0x3f,%edi
  800783:	75 0f                	jne    800794 <umain+0x14d>
		interactive = iscons(0);
  800785:	83 ec 0c             	sub    $0xc,%esp
  800788:	6a 00                	push   $0x0
  80078a:	e8 3f 01 00 00       	call   8008ce <iscons>
  80078f:	89 c7                	mov    %eax,%edi
  800791:	83 c4 10             	add    $0x10,%esp
	
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800794:	83 ec 0c             	sub    $0xc,%esp
  800797:	b8 c4 39 80 00       	mov    $0x8039c4,%eax
  80079c:	85 ff                	test   %edi,%edi
  80079e:	75 05                	jne    8007a5 <umain+0x15e>
  8007a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a5:	50                   	push   %eax
  8007a6:	e8 81 08 00 00       	call   80102c <readline>
  8007ab:	89 c6                	mov    %eax,%esi
		if (buf == NULL) {
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	75 1e                	jne    8007d2 <umain+0x18b>
			if (debug)
  8007b4:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8007bb:	74 10                	je     8007cd <umain+0x186>
				cprintf("EXITING\n");
  8007bd:	83 ec 0c             	sub    $0xc,%esp
  8007c0:	68 c7 39 80 00       	push   $0x8039c7
  8007c5:	e8 9a 03 00 00       	call   800b64 <cprintf>
  8007ca:	83 c4 10             	add    $0x10,%esp
			exit();	// end of file
  8007cd:	e8 8a 02 00 00       	call   800a5c <exit>
		}
		if (debug)
  8007d2:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8007d9:	74 11                	je     8007ec <umain+0x1a5>
			cprintf("LINE: %s\n", buf);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	56                   	push   %esi
  8007df:	68 d0 39 80 00       	push   $0x8039d0
  8007e4:	e8 7b 03 00 00       	call   800b64 <cprintf>
  8007e9:	83 c4 10             	add    $0x10,%esp
		if (buf[0] == '#')
  8007ec:	80 3e 23             	cmpb   $0x23,(%esi)
  8007ef:	74 a3                	je     800794 <umain+0x14d>
			continue;
		if (echocmds)
  8007f1:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8007f5:	74 13                	je     80080a <umain+0x1c3>
			fprintf(1, "# %s\n", buf);
  8007f7:	83 ec 04             	sub    $0x4,%esp
  8007fa:	56                   	push   %esi
  8007fb:	68 da 39 80 00       	push   $0x8039da
  800800:	6a 01                	push   $0x1
  800802:	e8 ba 20 00 00       	call   8028c1 <fprintf>
  800807:	83 c4 10             	add    $0x10,%esp
		if (debug)
  80080a:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800811:	74 10                	je     800823 <umain+0x1dc>
			cprintf("BEFORE FORK\n");
  800813:	83 ec 0c             	sub    $0xc,%esp
  800816:	68 e0 39 80 00       	push   $0x8039e0
  80081b:	e8 44 03 00 00       	call   800b64 <cprintf>
  800820:	83 c4 10             	add    $0x10,%esp
		if ((r = fork()) < 0)
  800823:	e8 5a 13 00 00       	call   801b82 <fork>
  800828:	89 c3                	mov    %eax,%ebx
  80082a:	85 c0                	test   %eax,%eax
  80082c:	79 15                	jns    800843 <umain+0x1fc>
			panic("fork: %e", r);
  80082e:	50                   	push   %eax
  80082f:	68 b5 38 80 00       	push   $0x8038b5
  800834:	68 34 01 00 00       	push   $0x134
  800839:	68 da 38 80 00       	push   $0x8038da
  80083e:	e8 31 02 00 00       	call   800a74 <_panic>
		if (debug)
  800843:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80084a:	74 11                	je     80085d <umain+0x216>
			cprintf("FORK: %d\n", r);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	50                   	push   %eax
  800850:	68 ed 39 80 00       	push   $0x8039ed
  800855:	e8 0a 03 00 00       	call   800b64 <cprintf>
  80085a:	83 c4 10             	add    $0x10,%esp
		if (r == 0) {
  80085d:	85 db                	test   %ebx,%ebx
  80085f:	75 16                	jne    800877 <umain+0x230>
			runcmd(buf);
  800861:	83 ec 0c             	sub    $0xc,%esp
  800864:	56                   	push   %esi
  800865:	e8 ca f7 ff ff       	call   800034 <runcmd>
			exit();
  80086a:	e8 ed 01 00 00       	call   800a5c <exit>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	e9 1d ff ff ff       	jmp    800794 <umain+0x14d>
		} else
			wait(r);
  800877:	83 ec 0c             	sub    $0xc,%esp
  80087a:	53                   	push   %ebx
  80087b:	e8 04 2b 00 00       	call   803384 <wait>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	e9 0c ff ff ff       	jmp    800794 <umain+0x14d>

00800888 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800894:	6a 01                	push   $0x1
  800896:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  800899:	50                   	push   %eax
  80089a:	e8 b1 0c 00 00       	call   801550 <sys_cputs>
}
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    

008008a1 <getchar>:

int
getchar(void)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8008a7:	6a 01                	push   $0x1
  8008a9:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	6a 00                	push   $0x0
  8008af:	e8 6d 17 00 00       	call   802021 <read>
	if (r < 0)
  8008b4:	83 c4 10             	add    $0x10,%esp
		return r;
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	78 0d                	js     8008ca <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8008bd:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8008c2:	85 c0                	test   %eax,%eax
  8008c4:	7e 04                	jle    8008ca <getchar+0x29>
	return c;
  8008c6:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  8008ca:	89 d0                	mov    %edx,%eax
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <iscons>:


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
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008d4:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8008d7:	50                   	push   %eax
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 ae 14 00 00       	call   801d8e <fd_lookup>
  8008e0:	83 c4 10             	add    $0x10,%esp
		return r;
  8008e3:	89 c2                	mov    %eax,%edx
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	78 11                	js     8008fa <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8008e9:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	3b 05 00 80 80 00    	cmp    0x808000,%eax
  8008f4:	0f 94 c0             	sete   %al
  8008f7:	0f b6 d0             	movzbl %al,%edx
}
  8008fa:	89 d0                	mov    %edx,%eax
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <opencons>:

int
opencons(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800904:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800907:	50                   	push   %eax
  800908:	e8 27 14 00 00       	call   801d34 <fd_alloc>
  80090d:	83 c4 10             	add    $0x10,%esp
		return r;
  800910:	89 c2                	mov    %eax,%edx
  800912:	85 c0                	test   %eax,%eax
  800914:	78 3c                	js     800952 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800916:	83 ec 04             	sub    $0x4,%esp
  800919:	68 07 04 00 00       	push   $0x407
  80091e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  800921:	6a 00                	push   $0x0
  800923:	e8 ea 0c 00 00       	call   801612 <sys_page_alloc>
  800928:	83 c4 10             	add    $0x10,%esp
		return r;
  80092b:	89 c2                	mov    %eax,%edx
  80092d:	85 c0                	test   %eax,%eax
  80092f:	78 21                	js     800952 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  800931:	a1 00 80 80 00       	mov    0x808000,%eax
  800936:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  800939:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80093b:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80093e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800945:	83 ec 0c             	sub    $0xc,%esp
  800948:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80094b:	e8 d4 13 00 00       	call   801d24 <fd2num>
  800950:	89 c2                	mov    %eax,%edx
}
  800952:	89 d0                	mov    %edx,%eax
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  80095c:	b8 00 00 00 00       	mov    $0x0,%eax
  800961:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800965:	74 2a                	je     800991 <cons_read+0x3b>
  800967:	eb 05                	jmp    80096e <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800969:	e8 85 0c 00 00       	call   8015f3 <sys_yield>
  80096e:	e8 01 0c 00 00       	call   801574 <sys_cgetc>
  800973:	89 c2                	mov    %eax,%edx
  800975:	85 c0                	test   %eax,%eax
  800977:	74 f0                	je     800969 <cons_read+0x13>
	if (c < 0)
  800979:	85 d2                	test   %edx,%edx
  80097b:	78 14                	js     800991 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80097d:	b8 00 00 00 00       	mov    $0x0,%eax
  800982:	83 fa 04             	cmp    $0x4,%edx
  800985:	74 0a                	je     800991 <cons_read+0x3b>
	*(char*)vbuf = c;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	88 10                	mov    %dl,(%eax)
	return 1;
  80098c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	57                   	push   %edi
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80099f:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8009a2:	be 00 00 00 00       	mov    $0x0,%esi
  8009a7:	39 fe                	cmp    %edi,%esi
  8009a9:	73 3d                	jae    8009e8 <cons_write+0x55>
		m = n - tot;
  8009ab:	89 fb                	mov    %edi,%ebx
  8009ad:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8009af:	83 fb 7f             	cmp    $0x7f,%ebx
  8009b2:	76 05                	jbe    8009b9 <cons_write+0x26>
			m = sizeof(buf) - 1;
  8009b4:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8009b9:	83 ec 04             	sub    $0x4,%esp
  8009bc:	53                   	push   %ebx
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c0:	01 f0                	add    %esi,%eax
  8009c2:	50                   	push   %eax
  8009c3:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8009c9:	50                   	push   %eax
  8009ca:	e8 ed 09 00 00       	call   8013bc <memmove>
		sys_cputs(buf, m);
  8009cf:	83 c4 08             	add    $0x8,%esp
  8009d2:	53                   	push   %ebx
  8009d3:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8009d9:	50                   	push   %eax
  8009da:	e8 71 0b 00 00       	call   801550 <sys_cputs>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	01 de                	add    %ebx,%esi
  8009e4:	39 fe                	cmp    %edi,%esi
  8009e6:	72 c3                	jb     8009ab <cons_write+0x18>
	}
	return tot;
}
  8009e8:	89 f0                	mov    %esi,%eax
  8009ea:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8009ed:	5b                   	pop    %ebx
  8009ee:	5e                   	pop    %esi
  8009ef:	5f                   	pop    %edi
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <cons_close>:

int
cons_close(struct Fd *fd)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8009f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800a02:	68 6e 3a 80 00       	push   $0x803a6e
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	e8 31 08 00 00       	call   801240 <strcpy>
	return 0;
}
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    
	...

00800a18 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  800a23:	e8 ac 0b 00 00       	call   8015d4 <sys_getenvid>
  800a28:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a2d:	c1 e0 07             	shl    $0x7,%eax
  800a30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a35:	a3 a0 84 80 00       	mov    %eax,0x8084a0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a3a:	85 f6                	test   %esi,%esi
  800a3c:	7e 07                	jle    800a45 <libmain+0x2d>
		binaryname = argv[0];
  800a3e:	8b 03                	mov    (%ebx),%eax
  800a40:	a3 20 80 80 00       	mov    %eax,0x808020

	// call user main routine
	umain(argc, argv);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	53                   	push   %ebx
  800a49:	56                   	push   %esi
  800a4a:	e8 f8 fb ff ff       	call   800647 <umain>

	// exit gracefully
	exit();
  800a4f:	e8 08 00 00 00       	call   800a5c <exit>
}
  800a54:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800a57:	5b                   	pop    %ebx
  800a58:	5e                   	pop    %esi
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    
	...

00800a5c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a62:	e8 75 14 00 00       	call   801edc <close_all>
	sys_env_destroy(0);
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	6a 00                	push   $0x0
  800a6c:	e8 22 0b 00 00       	call   801593 <sys_env_destroy>
}
  800a71:	c9                   	leave  
  800a72:	c3                   	ret    
	...

00800a74 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	53                   	push   %ebx
  800a78:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  800a7b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  800a7e:	83 3d a4 84 80 00 00 	cmpl   $0x0,0x8084a4
  800a85:	74 16                	je     800a9d <_panic+0x29>
		cprintf("%s: ", argv0);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 35 a4 84 80 00    	pushl  0x8084a4
  800a90:	68 8c 3a 80 00       	push   $0x803a8c
  800a95:	e8 ca 00 00 00       	call   800b64 <cprintf>
  800a9a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	ff 75 08             	pushl  0x8(%ebp)
  800aa3:	ff 35 20 80 80 00    	pushl  0x808020
  800aa9:	68 91 3a 80 00       	push   $0x803a91
  800aae:	e8 b1 00 00 00       	call   800b64 <cprintf>
	vcprintf(fmt, ap);
  800ab3:	83 c4 08             	add    $0x8,%esp
  800ab6:	53                   	push   %ebx
  800ab7:	ff 75 10             	pushl  0x10(%ebp)
  800aba:	e8 54 00 00 00       	call   800b13 <vcprintf>
	cprintf("\n");
  800abf:	c7 04 24 77 39 80 00 	movl   $0x803977,(%esp)
  800ac6:	e8 99 00 00 00       	call   800b64 <cprintf>

	// Cause a breakpoint exception
	while (1)
  800acb:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  800ace:	cc                   	int3   
  800acf:	eb fd                	jmp    800ace <_panic+0x5a>
  800ad1:	00 00                	add    %al,(%eax)
	...

00800ad4 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	53                   	push   %ebx
  800ad8:	83 ec 04             	sub    $0x4,%esp
  800adb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ade:	8b 03                	mov    (%ebx),%eax
  800ae0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae3:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  800ae7:	40                   	inc    %eax
  800ae8:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800aea:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aef:	75 1a                	jne    800b0b <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	68 ff 00 00 00       	push   $0xff
  800af9:	8d 43 08             	lea    0x8(%ebx),%eax
  800afc:	50                   	push   %eax
  800afd:	e8 4e 0a 00 00       	call   801550 <sys_cputs>
		b->idx = 0;
  800b02:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b08:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800b0b:	ff 43 04             	incl   0x4(%ebx)
}
  800b0e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b1c:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  800b23:	00 00 00 
	b.cnt = 0;
  800b26:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800b2d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	ff 75 08             	pushl  0x8(%ebp)
  800b36:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800b3c:	50                   	push   %eax
  800b3d:	68 d4 0a 80 00       	push   $0x800ad4
  800b42:	e8 4f 01 00 00       	call   800c96 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b47:	83 c4 08             	add    $0x8,%esp
  800b4a:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800b50:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  800b56:	50                   	push   %eax
  800b57:	e8 f4 09 00 00       	call   801550 <sys_cputs>

	return b.cnt;
  800b5c:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b6a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 9d ff ff ff       	call   800b13 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	57                   	push   %edi
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	8b 75 10             	mov    0x10(%ebp),%esi
  800b84:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b87:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b8a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b92:	39 fa                	cmp    %edi,%edx
  800b94:	77 39                	ja     800bcf <printnum+0x57>
  800b96:	72 04                	jb     800b9c <printnum+0x24>
  800b98:	39 f0                	cmp    %esi,%eax
  800b9a:	77 33                	ja     800bcf <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b9c:	83 ec 04             	sub    $0x4,%esp
  800b9f:	ff 75 20             	pushl  0x20(%ebp)
  800ba2:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800ba5:	50                   	push   %eax
  800ba6:	ff 75 18             	pushl  0x18(%ebp)
  800ba9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	52                   	push   %edx
  800bb2:	50                   	push   %eax
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	e8 e2 29 00 00       	call   80359c <__udivdi3>
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	52                   	push   %edx
  800bbe:	50                   	push   %eax
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	ff 75 08             	pushl  0x8(%ebp)
  800bc5:	e8 ae ff ff ff       	call   800b78 <printnum>
  800bca:	83 c4 20             	add    $0x20,%esp
  800bcd:	eb 19                	jmp    800be8 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bcf:	4b                   	dec    %ebx
  800bd0:	85 db                	test   %ebx,%ebx
  800bd2:	7e 14                	jle    800be8 <printnum+0x70>
  800bd4:	83 ec 08             	sub    $0x8,%esp
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 20             	pushl  0x20(%ebp)
  800bdd:	ff 55 08             	call   *0x8(%ebp)
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	4b                   	dec    %ebx
  800be4:	85 db                	test   %ebx,%ebx
  800be6:	7f ec                	jg     800bd4 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	8b 45 18             	mov    0x18(%ebp),%eax
  800bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	52                   	push   %edx
  800bfa:	50                   	push   %eax
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	e8 a6 2a 00 00       	call   8036a8 <__umoddi3>
  800c02:	83 c4 14             	add    $0x14,%esp
  800c05:	0f be 80 a7 3b 80 00 	movsbl 0x803ba7(%eax),%eax
  800c0c:	50                   	push   %eax
  800c0d:	ff 55 08             	call   *0x8(%ebp)
}
  800c10:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5f                   	pop    %edi
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	7e 0f                	jle    800c35 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800c26:	8b 01                	mov    (%ecx),%eax
  800c28:	83 c0 08             	add    $0x8,%eax
  800c2b:	89 01                	mov    %eax,(%ecx)
  800c2d:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800c30:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800c33:	eb 24                	jmp    800c59 <getuint+0x41>
	else if (lflag)
  800c35:	85 c0                	test   %eax,%eax
  800c37:	74 11                	je     800c4a <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800c39:	8b 01                	mov    (%ecx),%eax
  800c3b:	83 c0 04             	add    $0x4,%eax
  800c3e:	89 01                	mov    %eax,(%ecx)
  800c40:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
  800c48:	eb 0f                	jmp    800c59 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800c4a:	8b 01                	mov    (%ecx),%eax
  800c4c:	83 c0 04             	add    $0x4,%eax
  800c4f:	89 01                	mov    %eax,(%ecx)
  800c51:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800c64:	83 f8 01             	cmp    $0x1,%eax
  800c67:	7e 0f                	jle    800c78 <getint+0x1d>
		return va_arg(*ap, long long);
  800c69:	8b 02                	mov    (%edx),%eax
  800c6b:	83 c0 08             	add    $0x8,%eax
  800c6e:	89 02                	mov    %eax,(%edx)
  800c70:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800c73:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800c76:	eb 1c                	jmp    800c94 <getint+0x39>
	else if (lflag)
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	74 0d                	je     800c89 <getint+0x2e>
		return va_arg(*ap, long);
  800c7c:	8b 02                	mov    (%edx),%eax
  800c7e:	83 c0 04             	add    $0x4,%eax
  800c81:	89 02                	mov    %eax,(%edx)
  800c83:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800c86:	99                   	cltd   
  800c87:	eb 0b                	jmp    800c94 <getint+0x39>
	else
		return va_arg(*ap, int);
  800c89:	8b 02                	mov    (%edx),%eax
  800c8b:	83 c0 04             	add    $0x4,%eax
  800c8e:	89 02                	mov    %eax,(%edx)
  800c90:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800c93:	99                   	cltd   
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
  800c9c:	83 ec 1c             	sub    $0x1c,%esp
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  800ca2:	0f b6 13             	movzbl (%ebx),%edx
  800ca5:	43                   	inc    %ebx
  800ca6:	83 fa 25             	cmp    $0x25,%edx
  800ca9:	74 1e                	je     800cc9 <vprintfmt+0x33>
  800cab:	85 d2                	test   %edx,%edx
  800cad:	0f 84 d7 02 00 00    	je     800f8a <vprintfmt+0x2f4>
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	52                   	push   %edx
  800cba:	ff 55 08             	call   *0x8(%ebp)
  800cbd:	83 c4 10             	add    $0x10,%esp
  800cc0:	0f b6 13             	movzbl (%ebx),%edx
  800cc3:	43                   	inc    %ebx
  800cc4:	83 fa 25             	cmp    $0x25,%edx
  800cc7:	75 e2                	jne    800cab <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  800cc9:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800ccd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800cd4:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800cd9:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800cde:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ce5:	0f b6 13             	movzbl (%ebx),%edx
  800ce8:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800ceb:	43                   	inc    %ebx
  800cec:	83 f8 55             	cmp    $0x55,%eax
  800cef:	0f 87 70 02 00 00    	ja     800f65 <vprintfmt+0x2cf>
  800cf5:	ff 24 85 3c 3c 80 00 	jmp    *0x803c3c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800cfc:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800d00:	eb e3                	jmp    800ce5 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d02:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  800d06:	eb dd                	jmp    800ce5 <vprintfmt+0x4f>

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
  800d08:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800d0d:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800d10:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800d14:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800d17:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800d1a:	83 f8 09             	cmp    $0x9,%eax
  800d1d:	77 27                	ja     800d46 <vprintfmt+0xb0>
  800d1f:	43                   	inc    %ebx
  800d20:	eb eb                	jmp    800d0d <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d22:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800d26:	8b 45 14             	mov    0x14(%ebp),%eax
  800d29:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800d2c:	eb 18                	jmp    800d46 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800d2e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800d32:	79 b1                	jns    800ce5 <vprintfmt+0x4f>
				width = 0;
  800d34:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800d3b:	eb a8                	jmp    800ce5 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800d3d:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800d44:	eb 9f                	jmp    800ce5 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  800d46:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800d4a:	79 99                	jns    800ce5 <vprintfmt+0x4f>
				width = precision, precision = -1;
  800d4c:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800d4f:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  800d54:	eb 8f                	jmp    800ce5 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d56:	41                   	inc    %ecx
			goto reswitch;
  800d57:	eb 8c                	jmp    800ce5 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d59:	83 ec 08             	sub    $0x8,%esp
  800d5c:	ff 75 0c             	pushl  0xc(%ebp)
  800d5f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800d63:	8b 45 14             	mov    0x14(%ebp),%eax
  800d66:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800d69:	ff 55 08             	call   *0x8(%ebp)
			break;
  800d6c:	83 c4 10             	add    $0x10,%esp
  800d6f:	e9 2e ff ff ff       	jmp    800ca2 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d74:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800d78:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7b:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	79 02                	jns    800d84 <vprintfmt+0xee>
				err = -err;
  800d82:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d84:	83 f8 0e             	cmp    $0xe,%eax
  800d87:	7f 0b                	jg     800d94 <vprintfmt+0xfe>
  800d89:	8b 3c 85 00 3c 80 00 	mov    0x803c00(,%eax,4),%edi
  800d90:	85 ff                	test   %edi,%edi
  800d92:	75 19                	jne    800dad <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  800d94:	50                   	push   %eax
  800d95:	68 b8 3b 80 00       	push   $0x803bb8
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 ed 01 00 00       	call   800f92 <printfmt>
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	e9 f5 fe ff ff       	jmp    800ca2 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800dad:	57                   	push   %edi
  800dae:	68 c1 39 80 00       	push   $0x8039c1
  800db3:	ff 75 0c             	pushl  0xc(%ebp)
  800db6:	ff 75 08             	pushl  0x8(%ebp)
  800db9:	e8 d4 01 00 00       	call   800f92 <printfmt>
  800dbe:	83 c4 10             	add    $0x10,%esp
			break;
  800dc1:	e9 dc fe ff ff       	jmp    800ca2 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dc6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800dca:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcd:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800dd0:	85 ff                	test   %edi,%edi
  800dd2:	75 05                	jne    800dd9 <vprintfmt+0x143>
				p = "(null)";
  800dd4:	bf c1 3b 80 00       	mov    $0x803bc1,%edi
			if (width > 0 && padc != '-')
  800dd9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800ddd:	7e 3b                	jle    800e1a <vprintfmt+0x184>
  800ddf:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  800de3:	74 35                	je     800e1a <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	56                   	push   %esi
  800de9:	57                   	push   %edi
  800dea:	e8 2e 04 00 00       	call   80121d <strnlen>
  800def:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  800df2:	83 c4 10             	add    $0x10,%esp
  800df5:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800df9:	7e 1f                	jle    800e1a <vprintfmt+0x184>
  800dfb:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800dff:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 0c             	pushl  0xc(%ebp)
  800e08:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800e0b:	ff 55 08             	call   *0x8(%ebp)
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800e14:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800e18:	7f e8                	jg     800e02 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e1a:	0f be 17             	movsbl (%edi),%edx
  800e1d:	47                   	inc    %edi
  800e1e:	85 d2                	test   %edx,%edx
  800e20:	74 44                	je     800e66 <vprintfmt+0x1d0>
  800e22:	85 f6                	test   %esi,%esi
  800e24:	78 03                	js     800e29 <vprintfmt+0x193>
  800e26:	4e                   	dec    %esi
  800e27:	78 3d                	js     800e66 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800e29:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800e2d:	74 18                	je     800e47 <vprintfmt+0x1b1>
  800e2f:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  800e32:	83 f8 5e             	cmp    $0x5e,%eax
  800e35:	76 10                	jbe    800e47 <vprintfmt+0x1b1>
					putch('?', putdat);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 0c             	pushl  0xc(%ebp)
  800e3d:	6a 3f                	push   $0x3f
  800e3f:	ff 55 08             	call   *0x8(%ebp)
  800e42:	83 c4 10             	add    $0x10,%esp
  800e45:	eb 0d                	jmp    800e54 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	ff 75 0c             	pushl  0xc(%ebp)
  800e4d:	52                   	push   %edx
  800e4e:	ff 55 08             	call   *0x8(%ebp)
  800e51:	83 c4 10             	add    $0x10,%esp
  800e54:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800e57:	0f be 17             	movsbl (%edi),%edx
  800e5a:	47                   	inc    %edi
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	74 07                	je     800e66 <vprintfmt+0x1d0>
  800e5f:	85 f6                	test   %esi,%esi
  800e61:	78 c6                	js     800e29 <vprintfmt+0x193>
  800e63:	4e                   	dec    %esi
  800e64:	79 c3                	jns    800e29 <vprintfmt+0x193>
			for (; width > 0; width--)
  800e66:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800e6a:	0f 8e 32 fe ff ff    	jle    800ca2 <vprintfmt+0xc>
				putch(' ', putdat);
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	ff 75 0c             	pushl  0xc(%ebp)
  800e76:	6a 20                	push   $0x20
  800e78:	ff 55 08             	call   *0x8(%ebp)
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800e81:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800e85:	7f e9                	jg     800e70 <vprintfmt+0x1da>
			break;
  800e87:	e9 16 fe ff ff       	jmp    800ca2 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e8c:	51                   	push   %ecx
  800e8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e90:	50                   	push   %eax
  800e91:	e8 c5 fd ff ff       	call   800c5b <getint>
  800e96:	89 c6                	mov    %eax,%esi
  800e98:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  800e9a:	83 c4 08             	add    $0x8,%esp
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 15                	jns    800eb6 <vprintfmt+0x220>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800eac:	f7 de                	neg    %esi
  800eae:	83 d7 00             	adc    $0x0,%edi
  800eb1:	f7 df                	neg    %edi
  800eb3:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800eb6:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800ebb:	eb 75                	jmp    800f32 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ebd:	51                   	push   %ecx
  800ebe:	8d 45 14             	lea    0x14(%ebp),%eax
  800ec1:	50                   	push   %eax
  800ec2:	e8 51 fd ff ff       	call   800c18 <getuint>
  800ec7:	89 c6                	mov    %eax,%esi
  800ec9:	89 d7                	mov    %edx,%edi
			base = 10;
  800ecb:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800ed0:	83 c4 08             	add    $0x8,%esp
  800ed3:	eb 5d                	jmp    800f32 <vprintfmt+0x29c>

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
  800ed5:	51                   	push   %ecx
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 39 fd ff ff       	call   800c18 <getuint>
  800edf:	89 c6                	mov    %eax,%esi
  800ee1:	89 d7                	mov    %edx,%edi
			base = 8;
  800ee3:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800ee8:	83 c4 08             	add    $0x8,%esp
  800eeb:	eb 45                	jmp    800f32 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 0c             	pushl  0xc(%ebp)
  800ef3:	6a 30                	push   $0x30
  800ef5:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800ef8:	83 c4 08             	add    $0x8,%esp
  800efb:	ff 75 0c             	pushl  0xc(%ebp)
  800efe:	6a 78                	push   $0x78
  800f00:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800f03:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800f0d:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800f12:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  800f17:	83 c4 10             	add    $0x10,%esp
  800f1a:	eb 16                	jmp    800f32 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f1c:	51                   	push   %ecx
  800f1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800f20:	50                   	push   %eax
  800f21:	e8 f2 fc ff ff       	call   800c18 <getuint>
  800f26:	89 c6                	mov    %eax,%esi
  800f28:	89 d7                	mov    %edx,%edi
			base = 16;
  800f2a:	ba 10 00 00 00       	mov    $0x10,%edx
  800f2f:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f32:	83 ec 04             	sub    $0x4,%esp
  800f35:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800f39:	50                   	push   %eax
  800f3a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800f3d:	52                   	push   %edx
  800f3e:	57                   	push   %edi
  800f3f:	56                   	push   %esi
  800f40:	ff 75 0c             	pushl  0xc(%ebp)
  800f43:	ff 75 08             	pushl  0x8(%ebp)
  800f46:	e8 2d fc ff ff       	call   800b78 <printnum>
			break;
  800f4b:	83 c4 20             	add    $0x20,%esp
  800f4e:	e9 4f fd ff ff       	jmp    800ca2 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	52                   	push   %edx
  800f5a:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	e9 3d fd ff ff       	jmp    800ca2 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	6a 25                	push   $0x25
  800f6d:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f70:	4b                   	dec    %ebx
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800f78:	0f 84 24 fd ff ff    	je     800ca2 <vprintfmt+0xc>
  800f7e:	4b                   	dec    %ebx
  800f7f:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800f83:	75 f9                	jne    800f7e <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  800f85:	e9 18 fd ff ff       	jmp    800ca2 <vprintfmt+0xc>
		}
	}
}
  800f8a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800f98:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800f9b:	50                   	push   %eax
  800f9c:	ff 75 10             	pushl  0x10(%ebp)
  800f9f:	ff 75 0c             	pushl  0xc(%ebp)
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 ec fc ff ff       	call   800c96 <vprintfmt>
	va_end(ap);
}
  800faa:	c9                   	leave  
  800fab:	c3                   	ret    

00800fac <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  800fb2:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800fb5:	8b 0a                	mov    (%edx),%ecx
  800fb7:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800fba:	73 07                	jae    800fc3 <sprintputch+0x17>
		*b->buf++ = ch;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	88 01                	mov    %al,(%ecx)
  800fc1:	ff 02                	incl   (%edx)
}
  800fc3:	c9                   	leave  
  800fc4:	c3                   	ret    

00800fc5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 18             	sub    $0x18,%esp
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd1:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800fd4:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800fd8:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800fdb:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  800fe2:	85 d2                	test   %edx,%edx
  800fe4:	74 04                	je     800fea <vsnprintf+0x25>
  800fe6:	85 c9                	test   %ecx,%ecx
  800fe8:	7f 07                	jg     800ff1 <vsnprintf+0x2c>
		return -E_INVAL;
  800fea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fef:	eb 1d                	jmp    80100e <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ff1:	ff 75 14             	pushl  0x14(%ebp)
  800ff4:	ff 75 10             	pushl  0x10(%ebp)
  800ff7:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800ffa:	50                   	push   %eax
  800ffb:	68 ac 0f 80 00       	push   $0x800fac
  801000:	e8 91 fc ff ff       	call   800c96 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801005:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  801008:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80100b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801016:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801019:	50                   	push   %eax
  80101a:	ff 75 10             	pushl  0x10(%ebp)
  80101d:	ff 75 0c             	pushl  0xc(%ebp)
  801020:	ff 75 08             	pushl  0x8(%ebp)
  801023:	e8 9d ff ff ff       	call   800fc5 <vsnprintf>
	va_end(ap);

	return rc;
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    
	...

0080102c <readline>:
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801038:	85 c0                	test   %eax,%eax
  80103a:	74 13                	je     80104f <readline+0x23>
		fprintf(1, "%s", prompt);
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	50                   	push   %eax
  801040:	68 c1 39 80 00       	push   $0x8039c1
  801045:	6a 01                	push   $0x1
  801047:	e8 75 18 00 00       	call   8028c1 <fprintf>
  80104c:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
  80104f:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	6a 00                	push   $0x0
  801059:	e8 70 f8 ff ff       	call   8008ce <iscons>
  80105e:	89 c7                	mov    %eax,%edi
	while (1) {
  801060:	83 c4 10             	add    $0x10,%esp
		c = getchar();
  801063:	e8 39 f8 ff ff       	call   8008a1 <getchar>
  801068:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  80106a:	85 c0                	test   %eax,%eax
  80106c:	79 1d                	jns    80108b <readline+0x5f>
			if (c != -E_EOF)
  80106e:	83 f8 f8             	cmp    $0xfffffff8,%eax
  801071:	74 11                	je     801084 <readline+0x58>
				cprintf("read error: %e\n", c);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	50                   	push   %eax
  801077:	68 94 3d 80 00       	push   $0x803d94
  80107c:	e8 e3 fa ff ff       	call   800b64 <cprintf>
  801081:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
  801089:	eb 6f                	jmp    8010fa <readline+0xce>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80108b:	83 f8 08             	cmp    $0x8,%eax
  80108e:	74 05                	je     801095 <readline+0x69>
  801090:	83 f8 7f             	cmp    $0x7f,%eax
  801093:	75 18                	jne    8010ad <readline+0x81>
  801095:	85 f6                	test   %esi,%esi
  801097:	7e 14                	jle    8010ad <readline+0x81>
			if (echoing)
  801099:	85 ff                	test   %edi,%edi
  80109b:	74 0d                	je     8010aa <readline+0x7e>
				cputchar('\b');
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	6a 08                	push   $0x8
  8010a2:	e8 e1 f7 ff ff       	call   800888 <cputchar>
  8010a7:	83 c4 10             	add    $0x10,%esp
			i--;
  8010aa:	4e                   	dec    %esi
  8010ab:	eb b6                	jmp    801063 <readline+0x37>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010ad:	83 fb 1f             	cmp    $0x1f,%ebx
  8010b0:	7e 21                	jle    8010d3 <readline+0xa7>
  8010b2:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8010b8:	7f 19                	jg     8010d3 <readline+0xa7>
			if (echoing)
  8010ba:	85 ff                	test   %edi,%edi
  8010bc:	74 0c                	je     8010ca <readline+0x9e>
				cputchar(c);
  8010be:	83 ec 0c             	sub    $0xc,%esp
  8010c1:	53                   	push   %ebx
  8010c2:	e8 c1 f7 ff ff       	call   800888 <cputchar>
  8010c7:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010ca:	88 9e a0 80 80 00    	mov    %bl,0x8080a0(%esi)
  8010d0:	46                   	inc    %esi
  8010d1:	eb 90                	jmp    801063 <readline+0x37>
		} else if (c == '\n' || c == '\r') {
  8010d3:	83 fb 0a             	cmp    $0xa,%ebx
  8010d6:	74 05                	je     8010dd <readline+0xb1>
  8010d8:	83 fb 0d             	cmp    $0xd,%ebx
  8010db:	75 86                	jne    801063 <readline+0x37>
			if (echoing)
  8010dd:	85 ff                	test   %edi,%edi
  8010df:	74 0d                	je     8010ee <readline+0xc2>
				cputchar('\n');
  8010e1:	83 ec 0c             	sub    $0xc,%esp
  8010e4:	6a 0a                	push   $0xa
  8010e6:	e8 9d f7 ff ff       	call   800888 <cputchar>
  8010eb:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8010ee:	c6 86 a0 80 80 00 00 	movb   $0x0,0x8080a0(%esi)
			return buf;
  8010f5:	b8 a0 80 80 00       	mov    $0x8080a0,%eax
		}
	}
}
  8010fa:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5f                   	pop    %edi
  801100:	c9                   	leave  
  801101:	c3                   	ret    
	...

00801104 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	56                   	push   %esi
  801108:	53                   	push   %ebx
  801109:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	56                   	push   %esi
  801110:	e8 ef 00 00 00       	call   801204 <strlen>
  char letter;
  int hexnum = 0;
  801115:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80111a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80111f:	83 c4 10             	add    $0x10,%esp
  801122:	89 c2                	mov    %eax,%edx
  801124:	4a                   	dec    %edx
  801125:	0f 88 d0 00 00 00    	js     8011fb <strtoint+0xf7>
    letter = string[cidx];
  80112b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80112e:	85 d2                	test   %edx,%edx
  801130:	75 12                	jne    801144 <strtoint+0x40>
      if (letter != '0') {
  801132:	3c 30                	cmp    $0x30,%al
  801134:	0f 84 ba 00 00 00    	je     8011f4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80113a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80113f:	e9 b9 00 00 00       	jmp    8011fd <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  801144:	83 fa 01             	cmp    $0x1,%edx
  801147:	75 12                	jne    80115b <strtoint+0x57>
      if (letter != 'x') {
  801149:	3c 78                	cmp    $0x78,%al
  80114b:	0f 84 a3 00 00 00    	je     8011f4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  801151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801156:	e9 a2 00 00 00       	jmp    8011fd <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80115b:	0f be c0             	movsbl %al,%eax
  80115e:	83 e8 30             	sub    $0x30,%eax
  801161:	83 f8 36             	cmp    $0x36,%eax
  801164:	0f 87 80 00 00 00    	ja     8011ea <strtoint+0xe6>
  80116a:	ff 24 85 a4 3d 80 00 	jmp    *0x803da4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  801171:	01 cb                	add    %ecx,%ebx
          break;
  801173:	eb 7c                	jmp    8011f1 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  801175:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  801178:	eb 77                	jmp    8011f1 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  80117a:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80117d:	01 c3                	add    %eax,%ebx
          break;
  80117f:	eb 70                	jmp    8011f1 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  801181:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  801184:	eb 6b                	jmp    8011f1 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  801186:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  801189:	01 c3                	add    %eax,%ebx
          break;
  80118b:	eb 64                	jmp    8011f1 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  80118d:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  801190:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  801193:	eb 5c                	jmp    8011f1 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  801195:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80119c:	29 c8                	sub    %ecx,%eax
  80119e:	01 c3                	add    %eax,%ebx
          break;
  8011a0:	eb 4f                	jmp    8011f1 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8011a2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8011a5:	eb 4a                	jmp    8011f1 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8011a7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8011aa:	01 c3                	add    %eax,%ebx
          break;
  8011ac:	eb 43                	jmp    8011f1 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8011ae:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8011b1:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8011b4:	eb 3b                	jmp    8011f1 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8011b6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8011b9:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8011bc:	01 c3                	add    %eax,%ebx
          break;
  8011be:	eb 31                	jmp    8011f1 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8011c0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8011c3:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8011c6:	eb 29                	jmp    8011f1 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8011c8:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8011cb:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  8011ce:	01 c3                	add    %eax,%ebx
          break;
  8011d0:	eb 1f                	jmp    8011f1 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  8011d2:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8011d9:	29 c8                	sub    %ecx,%eax
  8011db:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8011de:	eb 11                	jmp    8011f1 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8011e0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8011e3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8011e6:	01 c3                	add    %eax,%ebx
          break;
  8011e8:	eb 07                	jmp    8011f1 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8011ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011ef:	eb 0c                	jmp    8011fd <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  8011f1:	c1 e1 04             	shl    $0x4,%ecx
  8011f4:	4a                   	dec    %edx
  8011f5:	0f 89 30 ff ff ff    	jns    80112b <strtoint+0x27>
    }
  }

  return hexnum;
  8011fb:	89 d8                	mov    %ebx,%eax
}
  8011fd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801200:	5b                   	pop    %ebx
  801201:	5e                   	pop    %esi
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <strlen>:





int
strlen(const char *s)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
  80120f:	80 3a 00             	cmpb   $0x0,(%edx)
  801212:	74 07                	je     80121b <strlen+0x17>
		n++;
  801214:	40                   	inc    %eax
  801215:	42                   	inc    %edx
  801216:	80 3a 00             	cmpb   $0x0,(%edx)
  801219:	75 f9                	jne    801214 <strlen+0x10>
	return n;
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801223:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	85 d2                	test   %edx,%edx
  80122d:	74 0f                	je     80123e <strnlen+0x21>
  80122f:	80 39 00             	cmpb   $0x0,(%ecx)
  801232:	74 0a                	je     80123e <strnlen+0x21>
		n++;
  801234:	40                   	inc    %eax
  801235:	41                   	inc    %ecx
  801236:	4a                   	dec    %edx
  801237:	74 05                	je     80123e <strnlen+0x21>
  801239:	80 39 00             	cmpb   $0x0,(%ecx)
  80123c:	75 f6                	jne    801234 <strnlen+0x17>
	return n;
}
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	53                   	push   %ebx
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80124a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  80124c:	8a 02                	mov    (%edx),%al
  80124e:	42                   	inc    %edx
  80124f:	88 01                	mov    %al,(%ecx)
  801251:	41                   	inc    %ecx
  801252:	84 c0                	test   %al,%al
  801254:	75 f6                	jne    80124c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801256:	89 d8                	mov    %ebx,%eax
  801258:	5b                   	pop    %ebx
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801264:	8b 55 0c             	mov    0xc(%ebp),%edx
  801267:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  80126a:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  80126c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801271:	39 f3                	cmp    %esi,%ebx
  801273:	73 10                	jae    801285 <strncpy+0x2a>
		*dst++ = *src;
  801275:	8a 02                	mov    (%edx),%al
  801277:	88 01                	mov    %al,(%ecx)
  801279:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80127a:	80 3a 01             	cmpb   $0x1,(%edx)
  80127d:	83 da ff             	sbb    $0xffffffff,%edx
  801280:	43                   	inc    %ebx
  801281:	39 f3                	cmp    %esi,%ebx
  801283:	72 f0                	jb     801275 <strncpy+0x1a>
	}
	return ret;
}
  801285:	89 f8                	mov    %edi,%eax
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5f                   	pop    %edi
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801294:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801297:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80129a:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  80129c:	85 d2                	test   %edx,%edx
  80129e:	74 19                	je     8012b9 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8012a0:	4a                   	dec    %edx
  8012a1:	74 13                	je     8012b6 <strlcpy+0x2a>
  8012a3:	80 39 00             	cmpb   $0x0,(%ecx)
  8012a6:	74 0e                	je     8012b6 <strlcpy+0x2a>
  8012a8:	8a 01                	mov    (%ecx),%al
  8012aa:	41                   	inc    %ecx
  8012ab:	88 03                	mov    %al,(%ebx)
  8012ad:	43                   	inc    %ebx
  8012ae:	4a                   	dec    %edx
  8012af:	74 05                	je     8012b6 <strlcpy+0x2a>
  8012b1:	80 39 00             	cmpb   $0x0,(%ecx)
  8012b4:	75 f2                	jne    8012a8 <strlcpy+0x1c>
		*dst = '\0';
  8012b6:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8012b9:	89 d8                	mov    %ebx,%eax
  8012bb:	29 f0                	sub    %esi,%eax
}
  8012bd:	5b                   	pop    %ebx
  8012be:	5e                   	pop    %esi
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  8012ca:	80 3a 00             	cmpb   $0x0,(%edx)
  8012cd:	74 13                	je     8012e2 <strcmp+0x21>
  8012cf:	8a 02                	mov    (%edx),%al
  8012d1:	3a 01                	cmp    (%ecx),%al
  8012d3:	75 0d                	jne    8012e2 <strcmp+0x21>
  8012d5:	42                   	inc    %edx
  8012d6:	41                   	inc    %ecx
  8012d7:	80 3a 00             	cmpb   $0x0,(%edx)
  8012da:	74 06                	je     8012e2 <strcmp+0x21>
  8012dc:	8a 02                	mov    (%edx),%al
  8012de:	3a 01                	cmp    (%ecx),%al
  8012e0:	74 f3                	je     8012d5 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e2:	0f b6 02             	movzbl (%edx),%eax
  8012e5:	0f b6 11             	movzbl (%ecx),%edx
  8012e8:	29 d0                	sub    %edx,%eax
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	53                   	push   %ebx
  8012f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  8012f9:	85 c9                	test   %ecx,%ecx
  8012fb:	74 1f                	je     80131c <strncmp+0x30>
  8012fd:	80 3a 00             	cmpb   $0x0,(%edx)
  801300:	74 16                	je     801318 <strncmp+0x2c>
  801302:	8a 02                	mov    (%edx),%al
  801304:	3a 03                	cmp    (%ebx),%al
  801306:	75 10                	jne    801318 <strncmp+0x2c>
  801308:	42                   	inc    %edx
  801309:	43                   	inc    %ebx
  80130a:	49                   	dec    %ecx
  80130b:	74 0f                	je     80131c <strncmp+0x30>
  80130d:	80 3a 00             	cmpb   $0x0,(%edx)
  801310:	74 06                	je     801318 <strncmp+0x2c>
  801312:	8a 02                	mov    (%edx),%al
  801314:	3a 03                	cmp    (%ebx),%al
  801316:	74 f0                	je     801308 <strncmp+0x1c>
	if (n == 0)
  801318:	85 c9                	test   %ecx,%ecx
  80131a:	75 07                	jne    801323 <strncmp+0x37>
		return 0;
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
  801321:	eb 0a                	jmp    80132d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801323:	0f b6 12             	movzbl (%edx),%edx
  801326:	0f b6 03             	movzbl (%ebx),%eax
  801329:	29 c2                	sub    %eax,%edx
  80132b:	89 d0                	mov    %edx,%eax
}
  80132d:	5b                   	pop    %ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  801339:	80 38 00             	cmpb   $0x0,(%eax)
  80133c:	74 0a                	je     801348 <strchr+0x18>
		if (*s == c)
  80133e:	38 10                	cmp    %dl,(%eax)
  801340:	74 0b                	je     80134d <strchr+0x1d>
  801342:	40                   	inc    %eax
  801343:	80 38 00             	cmpb   $0x0,(%eax)
  801346:	75 f6                	jne    80133e <strchr+0xe>
			return (char *) s;
	return 0;
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  801358:	80 38 00             	cmpb   $0x0,(%eax)
  80135b:	74 0a                	je     801367 <strfind+0x18>
		if (*s == c)
  80135d:	38 10                	cmp    %dl,(%eax)
  80135f:	74 06                	je     801367 <strfind+0x18>
  801361:	40                   	inc    %eax
  801362:	80 38 00             	cmpb   $0x0,(%eax)
  801365:	75 f6                	jne    80135d <strfind+0xe>
			break;
	return (char *) s;
}
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	57                   	push   %edi
  80136d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801370:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  801373:	89 f8                	mov    %edi,%eax
  801375:	85 c9                	test   %ecx,%ecx
  801377:	74 40                	je     8013b9 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  801379:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80137f:	75 30                	jne    8013b1 <memset+0x48>
  801381:	f6 c1 03             	test   $0x3,%cl
  801384:	75 2b                	jne    8013b1 <memset+0x48>
		c &= 0xFF;
  801386:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	c1 e0 18             	shl    $0x18,%eax
  801393:	8b 55 0c             	mov    0xc(%ebp),%edx
  801396:	c1 e2 10             	shl    $0x10,%edx
  801399:	09 d0                	or     %edx,%eax
  80139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139e:	c1 e2 08             	shl    $0x8,%edx
  8013a1:	09 d0                	or     %edx,%eax
  8013a3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  8013a6:	c1 e9 02             	shr    $0x2,%ecx
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	fc                   	cld    
  8013ad:	f3 ab                	repz stos %eax,%es:(%edi)
  8013af:	eb 06                	jmp    8013b7 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	fc                   	cld    
  8013b5:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8013b7:	89 f8                	mov    %edi,%eax
}
  8013b9:	5f                   	pop    %edi
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	57                   	push   %edi
  8013c0:	56                   	push   %esi
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8013c7:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8013ca:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8013cc:	39 c6                	cmp    %eax,%esi
  8013ce:	73 33                	jae    801403 <memmove+0x47>
  8013d0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8013d3:	39 c2                	cmp    %eax,%edx
  8013d5:	76 2c                	jbe    801403 <memmove+0x47>
		s += n;
  8013d7:	89 d6                	mov    %edx,%esi
		d += n;
  8013d9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013dc:	f6 c2 03             	test   $0x3,%dl
  8013df:	75 1b                	jne    8013fc <memmove+0x40>
  8013e1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013e7:	75 13                	jne    8013fc <memmove+0x40>
  8013e9:	f6 c1 03             	test   $0x3,%cl
  8013ec:	75 0e                	jne    8013fc <memmove+0x40>
			asm volatile("std; rep movsl\n"
  8013ee:	83 ef 04             	sub    $0x4,%edi
  8013f1:	83 ee 04             	sub    $0x4,%esi
  8013f4:	c1 e9 02             	shr    $0x2,%ecx
  8013f7:	fd                   	std    
  8013f8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  8013fa:	eb 27                	jmp    801423 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013fc:	4f                   	dec    %edi
  8013fd:	4e                   	dec    %esi
  8013fe:	fd                   	std    
  8013ff:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  801401:	eb 20                	jmp    801423 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801403:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801409:	75 15                	jne    801420 <memmove+0x64>
  80140b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801411:	75 0d                	jne    801420 <memmove+0x64>
  801413:	f6 c1 03             	test   $0x3,%cl
  801416:	75 08                	jne    801420 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  801418:	c1 e9 02             	shr    $0x2,%ecx
  80141b:	fc                   	cld    
  80141c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80141e:	eb 03                	jmp    801423 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801420:	fc                   	cld    
  801421:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <memcpy>:

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
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80142a:	ff 75 10             	pushl  0x10(%ebp)
  80142d:	ff 75 0c             	pushl  0xc(%ebp)
  801430:	ff 75 08             	pushl  0x8(%ebp)
  801433:	e8 84 ff ff ff       	call   8013bc <memmove>
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  80143e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801444:	8b 55 10             	mov    0x10(%ebp),%edx
  801447:	4a                   	dec    %edx
  801448:	83 fa ff             	cmp    $0xffffffff,%edx
  80144b:	74 1a                	je     801467 <memcmp+0x2d>
  80144d:	8a 01                	mov    (%ecx),%al
  80144f:	3a 03                	cmp    (%ebx),%al
  801451:	74 0c                	je     80145f <memcmp+0x25>
  801453:	0f b6 d0             	movzbl %al,%edx
  801456:	0f b6 03             	movzbl (%ebx),%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
  80145d:	eb 0d                	jmp    80146c <memcmp+0x32>
  80145f:	41                   	inc    %ecx
  801460:	43                   	inc    %ebx
  801461:	4a                   	dec    %edx
  801462:	83 fa ff             	cmp    $0xffffffff,%edx
  801465:	75 e6                	jne    80144d <memcmp+0x13>
	}

	return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146c:	5b                   	pop    %ebx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801478:	89 c2                	mov    %eax,%edx
  80147a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80147d:	39 d0                	cmp    %edx,%eax
  80147f:	73 09                	jae    80148a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801481:	38 08                	cmp    %cl,(%eax)
  801483:	74 05                	je     80148a <memfind+0x1b>
  801485:	40                   	inc    %eax
  801486:	39 d0                	cmp    %edx,%eax
  801488:	72 f7                	jb     801481 <memfind+0x12>
			break;
	return (void *) s;
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	8b 55 08             	mov    0x8(%ebp),%edx
  801495:	8b 75 0c             	mov    0xc(%ebp),%esi
  801498:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  80149b:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  8014a0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  8014a5:	80 3a 20             	cmpb   $0x20,(%edx)
  8014a8:	74 05                	je     8014af <strtol+0x23>
  8014aa:	80 3a 09             	cmpb   $0x9,(%edx)
  8014ad:	75 0b                	jne    8014ba <strtol+0x2e>
  8014af:	42                   	inc    %edx
  8014b0:	80 3a 20             	cmpb   $0x20,(%edx)
  8014b3:	74 fa                	je     8014af <strtol+0x23>
  8014b5:	80 3a 09             	cmpb   $0x9,(%edx)
  8014b8:	74 f5                	je     8014af <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  8014ba:	80 3a 2b             	cmpb   $0x2b,(%edx)
  8014bd:	75 03                	jne    8014c2 <strtol+0x36>
		s++;
  8014bf:	42                   	inc    %edx
  8014c0:	eb 0b                	jmp    8014cd <strtol+0x41>
	else if (*s == '-')
  8014c2:	80 3a 2d             	cmpb   $0x2d,(%edx)
  8014c5:	75 06                	jne    8014cd <strtol+0x41>
		s++, neg = 1;
  8014c7:	42                   	inc    %edx
  8014c8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014cd:	85 c9                	test   %ecx,%ecx
  8014cf:	74 05                	je     8014d6 <strtol+0x4a>
  8014d1:	83 f9 10             	cmp    $0x10,%ecx
  8014d4:	75 15                	jne    8014eb <strtol+0x5f>
  8014d6:	80 3a 30             	cmpb   $0x30,(%edx)
  8014d9:	75 10                	jne    8014eb <strtol+0x5f>
  8014db:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8014df:	75 0a                	jne    8014eb <strtol+0x5f>
		s += 2, base = 16;
  8014e1:	83 c2 02             	add    $0x2,%edx
  8014e4:	b9 10 00 00 00       	mov    $0x10,%ecx
  8014e9:	eb 14                	jmp    8014ff <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  8014eb:	85 c9                	test   %ecx,%ecx
  8014ed:	75 10                	jne    8014ff <strtol+0x73>
  8014ef:	80 3a 30             	cmpb   $0x30,(%edx)
  8014f2:	75 05                	jne    8014f9 <strtol+0x6d>
		s++, base = 8;
  8014f4:	42                   	inc    %edx
  8014f5:	b1 08                	mov    $0x8,%cl
  8014f7:	eb 06                	jmp    8014ff <strtol+0x73>
	else if (base == 0)
  8014f9:	85 c9                	test   %ecx,%ecx
  8014fb:	75 02                	jne    8014ff <strtol+0x73>
		base = 10;
  8014fd:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014ff:	8a 02                	mov    (%edx),%al
  801501:	83 e8 30             	sub    $0x30,%eax
  801504:	3c 09                	cmp    $0x9,%al
  801506:	77 08                	ja     801510 <strtol+0x84>
			dig = *s - '0';
  801508:	0f be 02             	movsbl (%edx),%eax
  80150b:	83 e8 30             	sub    $0x30,%eax
  80150e:	eb 20                	jmp    801530 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  801510:	8a 02                	mov    (%edx),%al
  801512:	83 e8 61             	sub    $0x61,%eax
  801515:	3c 19                	cmp    $0x19,%al
  801517:	77 08                	ja     801521 <strtol+0x95>
			dig = *s - 'a' + 10;
  801519:	0f be 02             	movsbl (%edx),%eax
  80151c:	83 e8 57             	sub    $0x57,%eax
  80151f:	eb 0f                	jmp    801530 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  801521:	8a 02                	mov    (%edx),%al
  801523:	83 e8 41             	sub    $0x41,%eax
  801526:	3c 19                	cmp    $0x19,%al
  801528:	77 12                	ja     80153c <strtol+0xb0>
			dig = *s - 'A' + 10;
  80152a:	0f be 02             	movsbl (%edx),%eax
  80152d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  801530:	39 c8                	cmp    %ecx,%eax
  801532:	7d 08                	jge    80153c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  801534:	42                   	inc    %edx
  801535:	0f af d9             	imul   %ecx,%ebx
  801538:	01 c3                	add    %eax,%ebx
  80153a:	eb c3                	jmp    8014ff <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  80153c:	85 f6                	test   %esi,%esi
  80153e:	74 02                	je     801542 <strtol+0xb6>
		*endptr = (char *) s;
  801540:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801542:	89 d8                	mov    %ebx,%eax
  801544:	85 ff                	test   %edi,%edi
  801546:	74 02                	je     80154a <strtol+0xbe>
  801548:	f7 d8                	neg    %eax
}
  80154a:	5b                   	pop    %ebx
  80154b:	5e                   	pop    %esi
  80154c:	5f                   	pop    %edi
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    
	...

00801550 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	57                   	push   %edi
  801554:	56                   	push   %esi
  801555:	53                   	push   %ebx
  801556:	83 ec 04             	sub    $0x4,%esp
  801559:	8b 55 08             	mov    0x8(%ebp),%edx
  80155c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80155f:	bf 00 00 00 00       	mov    $0x0,%edi
  801564:	89 f8                	mov    %edi,%eax
  801566:	89 fb                	mov    %edi,%ebx
  801568:	89 fe                	mov    %edi,%esi
  80156a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80156c:	83 c4 04             	add    $0x4,%esp
  80156f:	5b                   	pop    %ebx
  801570:	5e                   	pop    %esi
  801571:	5f                   	pop    %edi
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_cgetc>:

int
sys_cgetc(void)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	57                   	push   %edi
  801578:	56                   	push   %esi
  801579:	53                   	push   %ebx
  80157a:	b8 01 00 00 00       	mov    $0x1,%eax
  80157f:	bf 00 00 00 00       	mov    $0x0,%edi
  801584:	89 fa                	mov    %edi,%edx
  801586:	89 f9                	mov    %edi,%ecx
  801588:	89 fb                	mov    %edi,%ebx
  80158a:	89 fe                	mov    %edi,%esi
  80158c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5f                   	pop    %edi
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	57                   	push   %edi
  801597:	56                   	push   %esi
  801598:	53                   	push   %ebx
  801599:	83 ec 0c             	sub    $0xc,%esp
  80159c:	8b 55 08             	mov    0x8(%ebp),%edx
  80159f:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8015a9:	89 f9                	mov    %edi,%ecx
  8015ab:	89 fb                	mov    %edi,%ebx
  8015ad:	89 fe                	mov    %edi,%esi
  8015af:	cd 30                	int    $0x30
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	7e 17                	jle    8015cc <sys_env_destroy+0x39>
  8015b5:	83 ec 0c             	sub    $0xc,%esp
  8015b8:	50                   	push   %eax
  8015b9:	6a 03                	push   $0x3
  8015bb:	68 80 3e 80 00       	push   $0x803e80
  8015c0:	6a 23                	push   $0x23
  8015c2:	68 9d 3e 80 00       	push   $0x803e9d
  8015c7:	e8 a8 f4 ff ff       	call   800a74 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8015cc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5f                   	pop    %edi
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	57                   	push   %edi
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
  8015da:	b8 02 00 00 00       	mov    $0x2,%eax
  8015df:	bf 00 00 00 00       	mov    $0x0,%edi
  8015e4:	89 fa                	mov    %edi,%edx
  8015e6:	89 f9                	mov    %edi,%ecx
  8015e8:	89 fb                	mov    %edi,%ebx
  8015ea:	89 fe                	mov    %edi,%esi
  8015ec:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8015ee:	5b                   	pop    %ebx
  8015ef:	5e                   	pop    %esi
  8015f0:	5f                   	pop    %edi
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_yield>:

void
sys_yield(void)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	57                   	push   %edi
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8015fe:	bf 00 00 00 00       	mov    $0x0,%edi
  801603:	89 fa                	mov    %edi,%edx
  801605:	89 f9                	mov    %edi,%ecx
  801607:	89 fb                	mov    %edi,%ebx
  801609:	89 fe                	mov    %edi,%esi
  80160b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80160d:	5b                   	pop    %ebx
  80160e:	5e                   	pop    %esi
  80160f:	5f                   	pop    %edi
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	57                   	push   %edi
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	83 ec 0c             	sub    $0xc,%esp
  80161b:	8b 55 08             	mov    0x8(%ebp),%edx
  80161e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801621:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801624:	b8 04 00 00 00       	mov    $0x4,%eax
  801629:	bf 00 00 00 00       	mov    $0x0,%edi
  80162e:	89 fe                	mov    %edi,%esi
  801630:	cd 30                	int    $0x30
  801632:	85 c0                	test   %eax,%eax
  801634:	7e 17                	jle    80164d <sys_page_alloc+0x3b>
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	50                   	push   %eax
  80163a:	6a 04                	push   $0x4
  80163c:	68 80 3e 80 00       	push   $0x803e80
  801641:	6a 23                	push   $0x23
  801643:	68 9d 3e 80 00       	push   $0x803e9d
  801648:	e8 27 f4 ff ff       	call   800a74 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80164d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801650:	5b                   	pop    %ebx
  801651:	5e                   	pop    %esi
  801652:	5f                   	pop    %edi
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	57                   	push   %edi
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	8b 55 08             	mov    0x8(%ebp),%edx
  801661:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801664:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801667:	8b 7d 14             	mov    0x14(%ebp),%edi
  80166a:	8b 75 18             	mov    0x18(%ebp),%esi
  80166d:	b8 05 00 00 00       	mov    $0x5,%eax
  801672:	cd 30                	int    $0x30
  801674:	85 c0                	test   %eax,%eax
  801676:	7e 17                	jle    80168f <sys_page_map+0x3a>
  801678:	83 ec 0c             	sub    $0xc,%esp
  80167b:	50                   	push   %eax
  80167c:	6a 05                	push   $0x5
  80167e:	68 80 3e 80 00       	push   $0x803e80
  801683:	6a 23                	push   $0x23
  801685:	68 9d 3e 80 00       	push   $0x803e9d
  80168a:	e8 e5 f3 ff ff       	call   800a74 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80168f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801692:	5b                   	pop    %ebx
  801693:	5e                   	pop    %esi
  801694:	5f                   	pop    %edi
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	57                   	push   %edi
  80169b:	56                   	push   %esi
  80169c:	53                   	push   %ebx
  80169d:	83 ec 0c             	sub    $0xc,%esp
  8016a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a6:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b0:	89 fb                	mov    %edi,%ebx
  8016b2:	89 fe                	mov    %edi,%esi
  8016b4:	cd 30                	int    $0x30
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	7e 17                	jle    8016d1 <sys_page_unmap+0x3a>
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	50                   	push   %eax
  8016be:	6a 06                	push   $0x6
  8016c0:	68 80 3e 80 00       	push   $0x803e80
  8016c5:	6a 23                	push   $0x23
  8016c7:	68 9d 3e 80 00       	push   $0x803e9d
  8016cc:	e8 a3 f3 ff ff       	call   800a74 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016d1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016d4:	5b                   	pop    %ebx
  8016d5:	5e                   	pop    %esi
  8016d6:	5f                   	pop    %edi
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	57                   	push   %edi
  8016dd:	56                   	push   %esi
  8016de:	53                   	push   %ebx
  8016df:	83 ec 0c             	sub    $0xc,%esp
  8016e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8016ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f2:	89 fb                	mov    %edi,%ebx
  8016f4:	89 fe                	mov    %edi,%esi
  8016f6:	cd 30                	int    $0x30
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	7e 17                	jle    801713 <sys_env_set_status+0x3a>
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	50                   	push   %eax
  801700:	6a 08                	push   $0x8
  801702:	68 80 3e 80 00       	push   $0x803e80
  801707:	6a 23                	push   $0x23
  801709:	68 9d 3e 80 00       	push   $0x803e9d
  80170e:	e8 61 f3 ff ff       	call   800a74 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801713:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801716:	5b                   	pop    %ebx
  801717:	5e                   	pop    %esi
  801718:	5f                   	pop    %edi
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	57                   	push   %edi
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	8b 55 08             	mov    0x8(%ebp),%edx
  801727:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172a:	b8 09 00 00 00       	mov    $0x9,%eax
  80172f:	bf 00 00 00 00       	mov    $0x0,%edi
  801734:	89 fb                	mov    %edi,%ebx
  801736:	89 fe                	mov    %edi,%esi
  801738:	cd 30                	int    $0x30
  80173a:	85 c0                	test   %eax,%eax
  80173c:	7e 17                	jle    801755 <sys_env_set_trapframe+0x3a>
  80173e:	83 ec 0c             	sub    $0xc,%esp
  801741:	50                   	push   %eax
  801742:	6a 09                	push   $0x9
  801744:	68 80 3e 80 00       	push   $0x803e80
  801749:	6a 23                	push   $0x23
  80174b:	68 9d 3e 80 00       	push   $0x803e9d
  801750:	e8 1f f3 ff ff       	call   800a74 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801755:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801758:	5b                   	pop    %ebx
  801759:	5e                   	pop    %esi
  80175a:	5f                   	pop    %edi
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	57                   	push   %edi
  801761:	56                   	push   %esi
  801762:	53                   	push   %ebx
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	8b 55 08             	mov    0x8(%ebp),%edx
  801769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80176c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801771:	bf 00 00 00 00       	mov    $0x0,%edi
  801776:	89 fb                	mov    %edi,%ebx
  801778:	89 fe                	mov    %edi,%esi
  80177a:	cd 30                	int    $0x30
  80177c:	85 c0                	test   %eax,%eax
  80177e:	7e 17                	jle    801797 <sys_env_set_pgfault_upcall+0x3a>
  801780:	83 ec 0c             	sub    $0xc,%esp
  801783:	50                   	push   %eax
  801784:	6a 0a                	push   $0xa
  801786:	68 80 3e 80 00       	push   $0x803e80
  80178b:	6a 23                	push   $0x23
  80178d:	68 9d 3e 80 00       	push   $0x803e9d
  801792:	e8 dd f2 ff ff       	call   800a74 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801797:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5f                   	pop    %edi
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	57                   	push   %edi
  8017a3:	56                   	push   %esi
  8017a4:	53                   	push   %ebx
  8017a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017ae:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8017b6:	be 00 00 00 00       	mov    $0x0,%esi
  8017bb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8017bd:	5b                   	pop    %ebx
  8017be:	5e                   	pop    %esi
  8017bf:	5f                   	pop    %edi
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	57                   	push   %edi
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ce:	b8 0d 00 00 00       	mov    $0xd,%eax
  8017d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d8:	89 f9                	mov    %edi,%ecx
  8017da:	89 fb                	mov    %edi,%ebx
  8017dc:	89 fe                	mov    %edi,%esi
  8017de:	cd 30                	int    $0x30
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	7e 17                	jle    8017fb <sys_ipc_recv+0x39>
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	50                   	push   %eax
  8017e8:	6a 0d                	push   $0xd
  8017ea:	68 80 3e 80 00       	push   $0x803e80
  8017ef:	6a 23                	push   $0x23
  8017f1:	68 9d 3e 80 00       	push   $0x803e9d
  8017f6:	e8 79 f2 ff ff       	call   800a74 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8017fb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8017fe:	5b                   	pop    %ebx
  8017ff:	5e                   	pop    %esi
  801800:	5f                   	pop    %edi
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	57                   	push   %edi
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	83 ec 0c             	sub    $0xc,%esp
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801812:	b8 10 00 00 00       	mov    $0x10,%eax
  801817:	bf 00 00 00 00       	mov    $0x0,%edi
  80181c:	89 fb                	mov    %edi,%ebx
  80181e:	89 fe                	mov    %edi,%esi
  801820:	cd 30                	int    $0x30
  801822:	85 c0                	test   %eax,%eax
  801824:	7e 17                	jle    80183d <sys_transmit_packet+0x3a>
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	50                   	push   %eax
  80182a:	6a 10                	push   $0x10
  80182c:	68 80 3e 80 00       	push   $0x803e80
  801831:	6a 23                	push   $0x23
  801833:	68 9d 3e 80 00       	push   $0x803e9d
  801838:	e8 37 f2 ff ff       	call   800a74 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  80183d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5f                   	pop    %edi
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	57                   	push   %edi
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	83 ec 0c             	sub    $0xc,%esp
  80184e:	8b 55 08             	mov    0x8(%ebp),%edx
  801851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801854:	b8 11 00 00 00       	mov    $0x11,%eax
  801859:	bf 00 00 00 00       	mov    $0x0,%edi
  80185e:	89 fb                	mov    %edi,%ebx
  801860:	89 fe                	mov    %edi,%esi
  801862:	cd 30                	int    $0x30
  801864:	85 c0                	test   %eax,%eax
  801866:	7e 17                	jle    80187f <sys_receive_packet+0x3a>
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	50                   	push   %eax
  80186c:	6a 11                	push   $0x11
  80186e:	68 80 3e 80 00       	push   $0x803e80
  801873:	6a 23                	push   $0x23
  801875:	68 9d 3e 80 00       	push   $0x803e9d
  80187a:	e8 f5 f1 ff ff       	call   800a74 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  80187f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801882:	5b                   	pop    %ebx
  801883:	5e                   	pop    %esi
  801884:	5f                   	pop    %edi
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	57                   	push   %edi
  80188b:	56                   	push   %esi
  80188c:	53                   	push   %ebx
  80188d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801892:	bf 00 00 00 00       	mov    $0x0,%edi
  801897:	89 fa                	mov    %edi,%edx
  801899:	89 f9                	mov    %edi,%ecx
  80189b:	89 fb                	mov    %edi,%ebx
  80189d:	89 fe                	mov    %edi,%esi
  80189f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8018a1:	5b                   	pop    %ebx
  8018a2:	5e                   	pop    %esi
  8018a3:	5f                   	pop    %edi
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	57                   	push   %edi
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	83 ec 0c             	sub    $0xc,%esp
  8018af:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8018b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8018bc:	89 f9                	mov    %edi,%ecx
  8018be:	89 fb                	mov    %edi,%ebx
  8018c0:	89 fe                	mov    %edi,%esi
  8018c2:	cd 30                	int    $0x30
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	7e 17                	jle    8018df <sys_map_receive_buffers+0x39>
  8018c8:	83 ec 0c             	sub    $0xc,%esp
  8018cb:	50                   	push   %eax
  8018cc:	6a 0e                	push   $0xe
  8018ce:	68 80 3e 80 00       	push   $0x803e80
  8018d3:	6a 23                	push   $0x23
  8018d5:	68 9d 3e 80 00       	push   $0x803e9d
  8018da:	e8 95 f1 ff ff       	call   800a74 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  8018df:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5f                   	pop    %edi
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	57                   	push   %edi
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
  8018ed:	83 ec 0c             	sub    $0xc,%esp
  8018f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f3:	b8 12 00 00 00       	mov    $0x12,%eax
  8018f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8018fd:	89 f9                	mov    %edi,%ecx
  8018ff:	89 fb                	mov    %edi,%ebx
  801901:	89 fe                	mov    %edi,%esi
  801903:	cd 30                	int    $0x30
  801905:	85 c0                	test   %eax,%eax
  801907:	7e 17                	jle    801920 <sys_receive_packet_zerocopy+0x39>
  801909:	83 ec 0c             	sub    $0xc,%esp
  80190c:	50                   	push   %eax
  80190d:	6a 12                	push   $0x12
  80190f:	68 80 3e 80 00       	push   $0x803e80
  801914:	6a 23                	push   $0x23
  801916:	68 9d 3e 80 00       	push   $0x803e9d
  80191b:	e8 54 f1 ff ff       	call   800a74 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  801920:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5f                   	pop    %edi
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	57                   	push   %edi
  80192c:	56                   	push   %esi
  80192d:	53                   	push   %ebx
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	8b 55 08             	mov    0x8(%ebp),%edx
  801934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801937:	b8 13 00 00 00       	mov    $0x13,%eax
  80193c:	bf 00 00 00 00       	mov    $0x0,%edi
  801941:	89 fb                	mov    %edi,%ebx
  801943:	89 fe                	mov    %edi,%esi
  801945:	cd 30                	int    $0x30
  801947:	85 c0                	test   %eax,%eax
  801949:	7e 17                	jle    801962 <sys_env_set_priority+0x3a>
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	50                   	push   %eax
  80194f:	6a 13                	push   $0x13
  801951:	68 80 3e 80 00       	push   $0x803e80
  801956:	6a 23                	push   $0x23
  801958:	68 9d 3e 80 00       	push   $0x803e9d
  80195d:	e8 12 f1 ff ff       	call   800a74 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  801962:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801965:	5b                   	pop    %ebx
  801966:	5e                   	pop    %esi
  801967:	5f                   	pop    %edi
  801968:	c9                   	leave  
  801969:	c3                   	ret    
	...

0080196c <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	53                   	push   %ebx
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801976:	8b 18                	mov    (%eax),%ebx
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
  801978:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80197c:	74 11                	je     80198f <pgfault+0x23>
  80197e:	89 d8                	mov    %ebx,%eax
  801980:	c1 e8 0c             	shr    $0xc,%eax
  801983:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80198a:	f6 c4 08             	test   $0x8,%ah
  80198d:	75 14                	jne    8019a3 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	68 ac 3e 80 00       	push   $0x803eac
  801997:	6a 1e                	push   $0x1e
  801999:	68 00 3f 80 00       	push   $0x803f00
  80199e:	e8 d1 f0 ff ff       	call   800a74 <_panic>
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
  8019a3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	6a 07                	push   $0x7
  8019ae:	68 00 f0 7f 00       	push   $0x7ff000
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	e8 19 fc ff ff       	call   8015d4 <sys_getenvid>
  8019bb:	89 04 24             	mov    %eax,(%esp)
  8019be:	e8 4f fc ff ff       	call   801612 <sys_page_alloc>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	79 12                	jns    8019dc <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  8019ca:	50                   	push   %eax
  8019cb:	68 0b 3f 80 00       	push   $0x803f0b
  8019d0:	6a 2d                	push   $0x2d
  8019d2:	68 00 3f 80 00       	push   $0x803f00
  8019d7:	e8 98 f0 ff ff       	call   800a74 <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  8019dc:	83 ec 04             	sub    $0x4,%esp
  8019df:	68 00 10 00 00       	push   $0x1000
  8019e4:	53                   	push   %ebx
  8019e5:	68 00 f0 7f 00       	push   $0x7ff000
  8019ea:	e8 cd f9 ff ff       	call   8013bc <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  8019ef:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8019f6:	53                   	push   %ebx
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	e8 d5 fb ff ff       	call   8015d4 <sys_getenvid>
  8019ff:	83 c4 0c             	add    $0xc,%esp
  801a02:	50                   	push   %eax
  801a03:	68 00 f0 7f 00       	push   $0x7ff000
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	e8 c4 fb ff ff       	call   8015d4 <sys_getenvid>
  801a10:	89 04 24             	mov    %eax,(%esp)
  801a13:	e8 3d fc ff ff       	call   801655 <sys_page_map>
  801a18:	83 c4 20             	add    $0x20,%esp
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	79 12                	jns    801a31 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  801a1f:	50                   	push   %eax
  801a20:	68 26 3f 80 00       	push   $0x803f26
  801a25:	6a 33                	push   $0x33
  801a27:	68 00 3f 80 00       	push   $0x803f00
  801a2c:	e8 43 f0 ff ff       	call   800a74 <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  801a31:	83 ec 08             	sub    $0x8,%esp
  801a34:	68 00 f0 7f 00       	push   $0x7ff000
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	e8 93 fb ff ff       	call   8015d4 <sys_getenvid>
  801a41:	89 04 24             	mov    %eax,(%esp)
  801a44:	e8 4e fc ff ff       	call   801697 <sys_page_unmap>
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	79 12                	jns    801a62 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  801a50:	50                   	push   %eax
  801a51:	68 3f 3f 80 00       	push   $0x803f3f
  801a56:	6a 36                	push   $0x36
  801a58:	68 00 3f 80 00       	push   $0x803f00
  801a5d:	e8 12 f0 ff ff       	call   800a74 <_panic>
        }

	//panic("pgfault not implemented");
}
  801a62:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <duppage>:

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
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	53                   	push   %ebx
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  801a74:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  801a79:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801a7c:	f6 c4 04             	test   $0x4,%ah
  801a7f:	74 36                	je     801ab7 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  801a81:	83 ec 0c             	sub    $0xc,%esp
  801a84:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801a87:	25 07 0e 00 00       	and    $0xe07,%eax
  801a8c:	50                   	push   %eax
  801a8d:	89 d8                	mov    %ebx,%eax
  801a8f:	c1 e0 0c             	shl    $0xc,%eax
  801a92:	50                   	push   %eax
  801a93:	51                   	push   %ecx
  801a94:	50                   	push   %eax
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	e8 37 fb ff ff       	call   8015d4 <sys_getenvid>
  801a9d:	89 04 24             	mov    %eax,(%esp)
  801aa0:	e8 b0 fb ff ff       	call   801655 <sys_page_map>
  801aa5:	83 c4 20             	add    $0x20,%esp
            return r;
  801aa8:	89 c2                	mov    %eax,%edx
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	0f 88 c9 00 00 00    	js     801b7b <duppage+0x114>
  801ab2:	e9 bf 00 00 00       	jmp    801b76 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  801ab7:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  801abe:	a9 02 08 00 00       	test   $0x802,%eax
  801ac3:	74 7b                	je     801b40 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	68 05 08 00 00       	push   $0x805
  801acd:	89 d8                	mov    %ebx,%eax
  801acf:	c1 e0 0c             	shl    $0xc,%eax
  801ad2:	50                   	push   %eax
  801ad3:	51                   	push   %ecx
  801ad4:	50                   	push   %eax
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	e8 f7 fa ff ff       	call   8015d4 <sys_getenvid>
  801add:	89 04 24             	mov    %eax,(%esp)
  801ae0:	e8 70 fb ff ff       	call   801655 <sys_page_map>
  801ae5:	83 c4 20             	add    $0x20,%esp
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	79 12                	jns    801afe <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  801aec:	50                   	push   %eax
  801aed:	68 5a 3f 80 00       	push   $0x803f5a
  801af2:	6a 56                	push   $0x56
  801af4:	68 00 3f 80 00       	push   $0x803f00
  801af9:	e8 76 ef ff ff       	call   800a74 <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801afe:	83 ec 0c             	sub    $0xc,%esp
  801b01:	68 05 08 00 00       	push   $0x805
  801b06:	c1 e3 0c             	shl    $0xc,%ebx
  801b09:	53                   	push   %ebx
  801b0a:	83 ec 0c             	sub    $0xc,%esp
  801b0d:	e8 c2 fa ff ff       	call   8015d4 <sys_getenvid>
  801b12:	83 c4 0c             	add    $0xc,%esp
  801b15:	50                   	push   %eax
  801b16:	53                   	push   %ebx
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	e8 b5 fa ff ff       	call   8015d4 <sys_getenvid>
  801b1f:	89 04 24             	mov    %eax,(%esp)
  801b22:	e8 2e fb ff ff       	call   801655 <sys_page_map>
  801b27:	83 c4 20             	add    $0x20,%esp
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	79 48                	jns    801b76 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801b2e:	50                   	push   %eax
  801b2f:	68 5a 3f 80 00       	push   $0x803f5a
  801b34:	6a 5b                	push   $0x5b
  801b36:	68 00 3f 80 00       	push   $0x803f00
  801b3b:	e8 34 ef ff ff       	call   800a74 <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  801b40:	83 ec 0c             	sub    $0xc,%esp
  801b43:	6a 05                	push   $0x5
  801b45:	89 d8                	mov    %ebx,%eax
  801b47:	c1 e0 0c             	shl    $0xc,%eax
  801b4a:	50                   	push   %eax
  801b4b:	51                   	push   %ecx
  801b4c:	50                   	push   %eax
  801b4d:	83 ec 04             	sub    $0x4,%esp
  801b50:	e8 7f fa ff ff       	call   8015d4 <sys_getenvid>
  801b55:	89 04 24             	mov    %eax,(%esp)
  801b58:	e8 f8 fa ff ff       	call   801655 <sys_page_map>
  801b5d:	83 c4 20             	add    $0x20,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	79 12                	jns    801b76 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801b64:	50                   	push   %eax
  801b65:	68 5a 3f 80 00       	push   $0x803f5a
  801b6a:	6a 5f                	push   $0x5f
  801b6c:	68 00 3f 80 00       	push   $0x803f00
  801b71:	e8 fe ee ff ff       	call   800a74 <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  801b76:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b7b:	89 d0                	mov    %edx,%eax
  801b7d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <fork>:

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
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	57                   	push   %edi
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  801b8b:	68 6c 19 80 00       	push   $0x80196c
  801b90:	e8 4f 18 00 00       	call   8033e4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801b95:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  801b98:	ba 07 00 00 00       	mov    $0x7,%edx
  801b9d:	89 d0                	mov    %edx,%eax
  801b9f:	cd 30                	int    $0x30
  801ba1:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	79 15                	jns    801bbd <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  801ba8:	50                   	push   %eax
  801ba9:	68 e0 3e 80 00       	push   $0x803ee0
  801bae:	68 85 00 00 00       	push   $0x85
  801bb3:	68 00 3f 80 00       	push   $0x803f00
  801bb8:	e8 b7 ee ff ff       	call   800a74 <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  801bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801bc6:	75 21                	jne    801be9 <fork+0x67>
  801bc8:	e8 07 fa ff ff       	call   8015d4 <sys_getenvid>
  801bcd:	25 ff 03 00 00       	and    $0x3ff,%eax
  801bd2:	c1 e0 07             	shl    $0x7,%eax
  801bd5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bda:	a3 a0 84 80 00       	mov    %eax,0x8084a0
  801bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801be4:	e9 fd 00 00 00       	jmp    801ce6 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  801be9:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  801bf0:	a8 01                	test   $0x1,%al
  801bf2:	74 5f                	je     801c53 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  801bf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bf9:	89 f8                	mov    %edi,%eax
  801bfb:	c1 e0 0a             	shl    $0xa,%eax
  801bfe:	89 c2                	mov    %eax,%edx
  801c00:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801c05:	77 4c                	ja     801c53 <fork+0xd1>
  801c07:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  801c09:	01 da                	add    %ebx,%edx
  801c0b:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801c12:	a8 01                	test   $0x1,%al
  801c14:	74 28                	je     801c3e <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  801c16:	83 ec 08             	sub    $0x8,%esp
  801c19:	52                   	push   %edx
  801c1a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801c1d:	e8 45 fe ff ff       	call   801a67 <duppage>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	85 c0                	test   %eax,%eax
  801c27:	79 15                	jns    801c3e <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  801c29:	50                   	push   %eax
  801c2a:	68 73 3f 80 00       	push   $0x803f73
  801c2f:	68 95 00 00 00       	push   $0x95
  801c34:	68 00 3f 80 00       	push   $0x803f00
  801c39:	e8 36 ee ff ff       	call   800a74 <_panic>
  801c3e:	43                   	inc    %ebx
  801c3f:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801c45:	7f 0c                	jg     801c53 <fork+0xd1>
  801c47:	89 f2                	mov    %esi,%edx
  801c49:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801c4c:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801c51:	76 b6                	jbe    801c09 <fork+0x87>
  801c53:	47                   	inc    %edi
  801c54:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  801c5a:	76 8d                	jbe    801be9 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	6a 07                	push   $0x7
  801c61:	68 00 f0 bf ee       	push   $0xeebff000
  801c66:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801c69:	e8 a4 f9 ff ff       	call   801612 <sys_page_alloc>
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	79 15                	jns    801c8a <fork+0x108>
          panic("fork: %d", r);
  801c75:	50                   	push   %eax
  801c76:	68 8c 3f 80 00       	push   $0x803f8c
  801c7b:	68 9d 00 00 00       	push   $0x9d
  801c80:	68 00 3f 80 00       	push   $0x803f00
  801c85:	e8 ea ed ff ff       	call   800a74 <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  801c92:	8b 40 64             	mov    0x64(%eax),%eax
  801c95:	50                   	push   %eax
  801c96:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801c99:	e8 bf fa ff ff       	call   80175d <sys_env_set_pgfault_upcall>
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	79 15                	jns    801cba <fork+0x138>
          panic("fork: %d", r);
  801ca5:	50                   	push   %eax
  801ca6:	68 8c 3f 80 00       	push   $0x803f8c
  801cab:	68 a2 00 00 00       	push   $0xa2
  801cb0:	68 00 3f 80 00       	push   $0x803f00
  801cb5:	e8 ba ed ff ff       	call   800a74 <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	6a 01                	push   $0x1
  801cbf:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801cc2:	e8 12 fa ff ff       	call   8016d9 <sys_env_set_status>
  801cc7:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  801cca:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	79 15                	jns    801ce6 <fork+0x164>
  801cd1:	50                   	push   %eax
  801cd2:	68 8c 3f 80 00       	push   $0x803f8c
  801cd7:	68 a7 00 00 00       	push   $0xa7
  801cdc:	68 00 3f 80 00       	push   $0x803f00
  801ce1:	e8 8e ed ff ff       	call   800a74 <_panic>
 
	//panic("fork not implemented");
}
  801ce6:	89 d0                	mov    %edx,%eax
  801ce8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sfork>:



// Challenge!
int
sfork(void)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801cf6:	68 95 3f 80 00       	push   $0x803f95
  801cfb:	68 b5 00 00 00       	push   $0xb5
  801d00:	68 00 3f 80 00       	push   $0x803f00
  801d05:	e8 6a ed ff ff       	call   800a74 <_panic>
	...

00801d0c <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 0a 00 00 00       	call   801d24 <fd2num>
  801d1a:	c1 e0 16             	shl    $0x16,%eax
  801d1d:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	05 00 00 40 30       	add    $0x30400000,%eax
  801d2f:	c1 e8 0c             	shr    $0xc,%eax
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <fd_alloc>:

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
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	57                   	push   %edi
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d42:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801d47:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  801d4c:	89 c8                	mov    %ecx,%eax
  801d4e:	c1 e0 0c             	shl    $0xc,%eax
  801d51:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801d57:	89 d0                	mov    %edx,%eax
  801d59:	c1 e8 16             	shr    $0x16,%eax
  801d5c:	8b 04 86             	mov    (%esi,%eax,4),%eax
  801d5f:	a8 01                	test   $0x1,%al
  801d61:	74 0c                	je     801d6f <fd_alloc+0x3b>
  801d63:	89 d0                	mov    %edx,%eax
  801d65:	c1 e8 0c             	shr    $0xc,%eax
  801d68:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801d6b:	a8 01                	test   $0x1,%al
  801d6d:	75 09                	jne    801d78 <fd_alloc+0x44>
			*fd_store = fd;
  801d6f:	89 17                	mov    %edx,(%edi)
			return 0;
  801d71:	b8 00 00 00 00       	mov    $0x0,%eax
  801d76:	eb 11                	jmp    801d89 <fd_alloc+0x55>
  801d78:	41                   	inc    %ecx
  801d79:	83 f9 1f             	cmp    $0x1f,%ecx
  801d7c:	7e ce                	jle    801d4c <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  801d7e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801d84:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5f                   	pop    %edi
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801d94:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801d99:	83 f8 1f             	cmp    $0x1f,%eax
  801d9c:	77 3a                	ja     801dd8 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  801d9e:	c1 e0 0c             	shl    $0xc,%eax
  801da1:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801da7:	89 d0                	mov    %edx,%eax
  801da9:	c1 e8 16             	shr    $0x16,%eax
  801dac:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801db3:	a8 01                	test   $0x1,%al
  801db5:	74 10                	je     801dc7 <fd_lookup+0x39>
  801db7:	89 d0                	mov    %edx,%eax
  801db9:	c1 e8 0c             	shr    $0xc,%eax
  801dbc:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801dc3:	a8 01                	test   $0x1,%al
  801dc5:	75 07                	jne    801dce <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801dc7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801dcc:	eb 0a                	jmp    801dd8 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  801dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd1:	89 10                	mov    %edx,(%eax)
	return 0;
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801dd8:	89 d0                	mov    %edx,%eax
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <fd_close>:

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
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	56                   	push   %esi
  801de0:	53                   	push   %ebx
  801de1:	83 ec 10             	sub    $0x10,%esp
  801de4:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801de7:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801dea:	50                   	push   %eax
  801deb:	56                   	push   %esi
  801dec:	e8 33 ff ff ff       	call   801d24 <fd2num>
  801df1:	89 04 24             	mov    %eax,(%esp)
  801df4:	e8 95 ff ff ff       	call   801d8e <fd_lookup>
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	83 c4 08             	add    $0x8,%esp
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	78 05                	js     801e07 <fd_close+0x2b>
  801e02:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801e05:	74 0f                	je     801e16 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801e07:	89 d8                	mov    %ebx,%eax
  801e09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e0d:	75 3a                	jne    801e49 <fd_close+0x6d>
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e14:	eb 33                	jmp    801e49 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801e16:	83 ec 08             	sub    $0x8,%esp
  801e19:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801e1c:	50                   	push   %eax
  801e1d:	ff 36                	pushl  (%esi)
  801e1f:	e8 2c 00 00 00       	call   801e50 <dev_lookup>
  801e24:	89 c3                	mov    %eax,%ebx
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 0f                	js     801e3c <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	56                   	push   %esi
  801e31:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801e34:	ff 50 10             	call   *0x10(%eax)
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e3c:	83 ec 08             	sub    $0x8,%esp
  801e3f:	56                   	push   %esi
  801e40:	6a 00                	push   $0x0
  801e42:	e8 50 f8 ff ff       	call   801697 <sys_page_unmap>
	return r;
  801e47:	89 d8                	mov    %ebx,%eax
}
  801e49:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5e                   	pop    %esi
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <dev_lookup>:


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
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	56                   	push   %esi
  801e54:	53                   	push   %ebx
  801e55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e58:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  801e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e60:	83 3d 24 80 80 00 00 	cmpl   $0x0,0x808024
  801e67:	74 1c                	je     801e85 <dev_lookup+0x35>
  801e69:	b9 24 80 80 00       	mov    $0x808024,%ecx
		if (devtab[i]->dev_id == dev_id) {
  801e6e:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801e71:	39 18                	cmp    %ebx,(%eax)
  801e73:	75 09                	jne    801e7e <dev_lookup+0x2e>
			*dev = devtab[i];
  801e75:	89 06                	mov    %eax,(%esi)
			return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	eb 29                	jmp    801ea7 <dev_lookup+0x57>
  801e7e:	42                   	inc    %edx
  801e7f:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801e83:	75 e9                	jne    801e6e <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	53                   	push   %ebx
  801e89:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  801e8e:	8b 40 4c             	mov    0x4c(%eax),%eax
  801e91:	50                   	push   %eax
  801e92:	68 ac 3f 80 00       	push   $0x803fac
  801e97:	e8 c8 ec ff ff       	call   800b64 <cprintf>
	*dev = 0;
  801e9c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801ea2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ea7:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801eaa:	5b                   	pop    %ebx
  801eab:	5e                   	pop    %esi
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <close>:

int
close(int fdnum)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb4:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801eb7:	50                   	push   %eax
  801eb8:	ff 75 08             	pushl  0x8(%ebp)
  801ebb:	e8 ce fe ff ff       	call   801d8e <fd_lookup>
  801ec0:	83 c4 08             	add    $0x8,%esp
		return r;
  801ec3:	89 c2                	mov    %eax,%edx
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	78 0f                	js     801ed8 <close+0x2a>
	else
		return fd_close(fd, 1);
  801ec9:	83 ec 08             	sub    $0x8,%esp
  801ecc:	6a 01                	push   $0x1
  801ece:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801ed1:	e8 06 ff ff ff       	call   801ddc <fd_close>
  801ed6:	89 c2                	mov    %eax,%edx
}
  801ed8:	89 d0                	mov    %edx,%eax
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <close_all>:

void
close_all(void)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	53                   	push   %ebx
  801eec:	e8 bd ff ff ff       	call   801eae <close>
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	43                   	inc    %ebx
  801ef5:	83 fb 1f             	cmp    $0x1f,%ebx
  801ef8:	7e ee                	jle    801ee8 <close_all+0xc>
}
  801efa:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	57                   	push   %edi
  801f03:	56                   	push   %esi
  801f04:	53                   	push   %ebx
  801f05:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f08:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801f0b:	50                   	push   %eax
  801f0c:	ff 75 08             	pushl  0x8(%ebp)
  801f0f:	e8 7a fe ff ff       	call   801d8e <fd_lookup>
  801f14:	89 c6                	mov    %eax,%esi
  801f16:	83 c4 08             	add    $0x8,%esp
  801f19:	85 f6                	test   %esi,%esi
  801f1b:	0f 88 f8 00 00 00    	js     802019 <dup+0x11a>
		return r;
	close(newfdnum);
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	e8 82 ff ff ff       	call   801eae <close>

	newfd = INDEX2FD(newfdnum);
  801f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2f:	c1 e0 0c             	shl    $0xc,%eax
  801f32:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801f37:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  801f3a:	83 c4 04             	add    $0x4,%esp
  801f3d:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801f40:	e8 c7 fd ff ff       	call   801d0c <fd2data>
  801f45:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801f47:	83 c4 04             	add    $0x4,%esp
  801f4a:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801f4d:	e8 ba fd ff ff       	call   801d0c <fd2data>
  801f52:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801f55:	89 f8                	mov    %edi,%eax
  801f57:	c1 e8 16             	shr    $0x16,%eax
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801f64:	85 c0                	test   %eax,%eax
  801f66:	74 48                	je     801fb0 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801f68:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801f6d:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801f70:	89 d0                	mov    %edx,%eax
  801f72:	c1 e8 0c             	shr    $0xc,%eax
  801f75:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801f7c:	a8 01                	test   $0x1,%al
  801f7e:	74 22                	je     801fa2 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	25 07 0e 00 00       	and    $0xe07,%eax
  801f88:	50                   	push   %eax
  801f89:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801f8c:	01 d8                	add    %ebx,%eax
  801f8e:	50                   	push   %eax
  801f8f:	6a 00                	push   $0x0
  801f91:	52                   	push   %edx
  801f92:	6a 00                	push   $0x0
  801f94:	e8 bc f6 ff ff       	call   801655 <sys_page_map>
  801f99:	89 c6                	mov    %eax,%esi
  801f9b:	83 c4 20             	add    $0x20,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 3f                	js     801fe1 <dup+0xe2>
  801fa2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801fa8:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801fae:	7e bd                	jle    801f6d <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801fb6:	89 d0                	mov    %edx,%eax
  801fb8:	c1 e8 0c             	shr    $0xc,%eax
  801fbb:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801fc2:	25 07 0e 00 00       	and    $0xe07,%eax
  801fc7:	50                   	push   %eax
  801fc8:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801fcb:	6a 00                	push   $0x0
  801fcd:	52                   	push   %edx
  801fce:	6a 00                	push   $0x0
  801fd0:	e8 80 f6 ff ff       	call   801655 <sys_page_map>
  801fd5:	89 c6                	mov    %eax,%esi
  801fd7:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdd:	85 f6                	test   %esi,%esi
  801fdf:	79 38                	jns    802019 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801fe1:	83 ec 08             	sub    $0x8,%esp
  801fe4:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801fe7:	6a 00                	push   $0x0
  801fe9:	e8 a9 f6 ff ff       	call   801697 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801fee:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ff3:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  801ff6:	83 ec 08             	sub    $0x8,%esp
  801ff9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801ffc:	01 d8                	add    %ebx,%eax
  801ffe:	50                   	push   %eax
  801fff:	6a 00                	push   $0x0
  802001:	e8 91 f6 ff ff       	call   801697 <sys_page_unmap>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80200f:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  802015:	7e df                	jle    801ff6 <dup+0xf7>
	return r;
  802017:	89 f0                	mov    %esi,%eax
}
  802019:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80201c:	5b                   	pop    %ebx
  80201d:	5e                   	pop    %esi
  80201e:	5f                   	pop    %edi
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	53                   	push   %ebx
  802025:	83 ec 14             	sub    $0x14,%esp
  802028:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80202b:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80202e:	50                   	push   %eax
  80202f:	53                   	push   %ebx
  802030:	e8 59 fd ff ff       	call   801d8e <fd_lookup>
  802035:	89 c2                	mov    %eax,%edx
  802037:	83 c4 08             	add    $0x8,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 1a                	js     802058 <read+0x37>
  80203e:	83 ec 08             	sub    $0x8,%esp
  802041:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802044:	50                   	push   %eax
  802045:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802048:	ff 30                	pushl  (%eax)
  80204a:	e8 01 fe ff ff       	call   801e50 <dev_lookup>
  80204f:	89 c2                	mov    %eax,%edx
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	85 c0                	test   %eax,%eax
  802056:	79 04                	jns    80205c <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  802058:	89 d0                	mov    %edx,%eax
  80205a:	eb 50                	jmp    8020ac <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80205c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80205f:	8b 40 08             	mov    0x8(%eax),%eax
  802062:	83 e0 03             	and    $0x3,%eax
  802065:	83 f8 01             	cmp    $0x1,%eax
  802068:	75 1e                	jne    802088 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	53                   	push   %ebx
  80206e:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  802073:	8b 40 4c             	mov    0x4c(%eax),%eax
  802076:	50                   	push   %eax
  802077:	68 ed 3f 80 00       	push   $0x803fed
  80207c:	e8 e3 ea ff ff       	call   800b64 <cprintf>
		return -E_INVAL;
  802081:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802086:	eb 24                	jmp    8020ac <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  802088:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80208b:	ff 70 04             	pushl  0x4(%eax)
  80208e:	ff 75 10             	pushl  0x10(%ebp)
  802091:	ff 75 0c             	pushl  0xc(%ebp)
  802094:	50                   	push   %eax
  802095:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  802098:	ff 50 08             	call   *0x8(%eax)
  80209b:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  80209d:	83 c4 10             	add    $0x10,%esp
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	78 06                	js     8020aa <read+0x89>
		fd->fd_offset += r;
  8020a4:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8020a7:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8020aa:	89 d0                	mov    %edx,%eax
}
  8020ac:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	57                   	push   %edi
  8020b5:	56                   	push   %esi
  8020b6:	53                   	push   %ebx
  8020b7:	83 ec 0c             	sub    $0xc,%esp
  8020ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8020bd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020c5:	39 f3                	cmp    %esi,%ebx
  8020c7:	73 25                	jae    8020ee <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	89 f0                	mov    %esi,%eax
  8020ce:	29 d8                	sub    %ebx,%eax
  8020d0:	50                   	push   %eax
  8020d1:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8020d4:	50                   	push   %eax
  8020d5:	ff 75 08             	pushl  0x8(%ebp)
  8020d8:	e8 44 ff ff ff       	call   802021 <read>
		if (m < 0)
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	78 0c                	js     8020f0 <readn+0x3f>
			return m;
		if (m == 0)
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	74 06                	je     8020ee <readn+0x3d>
  8020e8:	01 c3                	add    %eax,%ebx
  8020ea:	39 f3                	cmp    %esi,%ebx
  8020ec:	72 db                	jb     8020c9 <readn+0x18>
			break;
	}
	return tot;
  8020ee:	89 d8                	mov    %ebx,%eax
}
  8020f0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5f                   	pop    %edi
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 14             	sub    $0x14,%esp
  8020ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802102:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	53                   	push   %ebx
  802107:	e8 82 fc ff ff       	call   801d8e <fd_lookup>
  80210c:	89 c2                	mov    %eax,%edx
  80210e:	83 c4 08             	add    $0x8,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	78 1a                	js     80212f <write+0x37>
  802115:	83 ec 08             	sub    $0x8,%esp
  802118:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80211b:	50                   	push   %eax
  80211c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80211f:	ff 30                	pushl  (%eax)
  802121:	e8 2a fd ff ff       	call   801e50 <dev_lookup>
  802126:	89 c2                	mov    %eax,%edx
  802128:	83 c4 10             	add    $0x10,%esp
  80212b:	85 c0                	test   %eax,%eax
  80212d:	79 04                	jns    802133 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  80212f:	89 d0                	mov    %edx,%eax
  802131:	eb 4b                	jmp    80217e <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802133:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802136:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80213a:	75 1e                	jne    80215a <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	53                   	push   %ebx
  802140:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  802145:	8b 40 4c             	mov    0x4c(%eax),%eax
  802148:	50                   	push   %eax
  802149:	68 09 40 80 00       	push   $0x804009
  80214e:	e8 11 ea ff ff       	call   800b64 <cprintf>
		return -E_INVAL;
  802153:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802158:	eb 24                	jmp    80217e <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  80215a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80215d:	ff 70 04             	pushl  0x4(%eax)
  802160:	ff 75 10             	pushl  0x10(%ebp)
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	50                   	push   %eax
  802167:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80216a:	ff 50 0c             	call   *0xc(%eax)
  80216d:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80216f:	83 c4 10             	add    $0x10,%esp
  802172:	85 c0                	test   %eax,%eax
  802174:	7e 06                	jle    80217c <write+0x84>
		fd->fd_offset += r;
  802176:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802179:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80217c:	89 d0                	mov    %edx,%eax
}
  80217e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <seek>:

int
seek(int fdnum, off_t offset)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802189:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80218c:	50                   	push   %eax
  80218d:	ff 75 08             	pushl  0x8(%ebp)
  802190:	e8 f9 fb ff ff       	call   801d8e <fd_lookup>
  802195:	83 c4 08             	add    $0x8,%esp
		return r;
  802198:	89 c2                	mov    %eax,%edx
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 0e                	js     8021ac <seek+0x29>
	fd->fd_offset = offset;
  80219e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8021a4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8021a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8021ac:	89 d0                	mov    %edx,%eax
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 14             	sub    $0x14,%esp
  8021b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ba:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8021bd:	50                   	push   %eax
  8021be:	53                   	push   %ebx
  8021bf:	e8 ca fb ff ff       	call   801d8e <fd_lookup>
  8021c4:	83 c4 08             	add    $0x8,%esp
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	78 4e                	js     802219 <ftruncate+0x69>
  8021cb:	83 ec 08             	sub    $0x8,%esp
  8021ce:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8021d1:	50                   	push   %eax
  8021d2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8021d5:	ff 30                	pushl  (%eax)
  8021d7:	e8 74 fc ff ff       	call   801e50 <dev_lookup>
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 36                	js     802219 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021e3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8021e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021ea:	75 1e                	jne    80220a <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	53                   	push   %ebx
  8021f0:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8021f5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8021f8:	50                   	push   %eax
  8021f9:	68 cc 3f 80 00       	push   $0x803fcc
  8021fe:	e8 61 e9 ff ff       	call   800b64 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  802203:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802208:	eb 0f                	jmp    802219 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  80220a:	83 ec 08             	sub    $0x8,%esp
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  802213:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  802216:	ff 50 1c             	call   *0x1c(%eax)
}
  802219:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	53                   	push   %ebx
  802222:	83 ec 14             	sub    $0x14,%esp
  802225:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802228:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80222b:	50                   	push   %eax
  80222c:	ff 75 08             	pushl  0x8(%ebp)
  80222f:	e8 5a fb ff ff       	call   801d8e <fd_lookup>
  802234:	83 c4 08             	add    $0x8,%esp
  802237:	85 c0                	test   %eax,%eax
  802239:	78 42                	js     80227d <fstat+0x5f>
  80223b:	83 ec 08             	sub    $0x8,%esp
  80223e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802241:	50                   	push   %eax
  802242:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802245:	ff 30                	pushl  (%eax)
  802247:	e8 04 fc ff ff       	call   801e50 <dev_lookup>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 2a                	js     80227d <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  802253:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802256:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80225d:	00 00 00 
	stat->st_isdir = 0;
  802260:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802267:	00 00 00 
	stat->st_dev = dev;
  80226a:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80226d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802273:	83 ec 08             	sub    $0x8,%esp
  802276:	53                   	push   %ebx
  802277:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80227a:	ff 50 14             	call   *0x14(%eax)
}
  80227d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	56                   	push   %esi
  802286:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802287:	83 ec 08             	sub    $0x8,%esp
  80228a:	6a 00                	push   $0x0
  80228c:	ff 75 08             	pushl  0x8(%ebp)
  80228f:	e8 28 00 00 00       	call   8022bc <open>
  802294:	89 c6                	mov    %eax,%esi
  802296:	83 c4 10             	add    $0x10,%esp
  802299:	85 f6                	test   %esi,%esi
  80229b:	78 18                	js     8022b5 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  80229d:	83 ec 08             	sub    $0x8,%esp
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	56                   	push   %esi
  8022a4:	e8 75 ff ff ff       	call   80221e <fstat>
  8022a9:	89 c3                	mov    %eax,%ebx
	close(fd);
  8022ab:	89 34 24             	mov    %esi,(%esp)
  8022ae:	e8 fb fb ff ff       	call   801eae <close>
	return r;
  8022b3:	89 d8                	mov    %ebx,%eax
}
  8022b5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8022b8:	5b                   	pop    %ebx
  8022b9:	5e                   	pop    %esi
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	53                   	push   %ebx
  8022c0:	83 ec 10             	sub    $0x10,%esp
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
  8022c3:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8022c6:	50                   	push   %eax
  8022c7:	e8 68 fa ff ff       	call   801d34 <fd_alloc>
  8022cc:	89 c3                	mov    %eax,%ebx
  8022ce:	83 c4 10             	add    $0x10,%esp
  8022d1:	85 db                	test   %ebx,%ebx
  8022d3:	78 36                	js     80230b <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8022db:	ff 75 0c             	pushl  0xc(%ebp)
  8022de:	ff 75 08             	pushl  0x8(%ebp)
  8022e1:	e8 37 06 00 00       	call   80291d <fsipc_open>
  8022e6:	89 c3                	mov    %eax,%ebx
  8022e8:	83 c4 10             	add    $0x10,%esp
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	79 11                	jns    802300 <open+0x44>
          fd_close(fd_store, 0);
  8022ef:	83 ec 08             	sub    $0x8,%esp
  8022f2:	6a 00                	push   $0x0
  8022f4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8022f7:	e8 e0 fa ff ff       	call   801ddc <fd_close>
          return r;
  8022fc:	89 d8                	mov    %ebx,%eax
  8022fe:	eb 0b                	jmp    80230b <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  802306:	e8 19 fa ff ff       	call   801d24 <fd2num>
}
  80230b:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	53                   	push   %ebx
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  80231a:	6a 01                	push   $0x1
  80231c:	6a 00                	push   $0x0
  80231e:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  802324:	53                   	push   %ebx
  802325:	e8 e7 03 00 00       	call   802711 <funmap>
  80232a:	83 c4 10             	add    $0x10,%esp
          return r;
  80232d:	89 c2                	mov    %eax,%edx
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 19                	js     80234c <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	ff 73 0c             	pushl  0xc(%ebx)
  802339:	e8 84 06 00 00       	call   8029c2 <fsipc_close>
  80233e:	83 c4 10             	add    $0x10,%esp
          return r;
  802341:	89 c2                	mov    %eax,%edx
  802343:	85 c0                	test   %eax,%eax
  802345:	78 05                	js     80234c <file_close+0x3c>
        }
        return 0;
  802347:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80234c:	89 d0                	mov    %edx,%eax
  80234e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	57                   	push   %edi
  802357:	56                   	push   %esi
  802358:	53                   	push   %ebx
  802359:	83 ec 0c             	sub    $0xc,%esp
  80235c:	8b 75 10             	mov    0x10(%ebp),%esi
  80235f:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  80236b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802370:	39 d7                	cmp    %edx,%edi
  802372:	0f 87 95 00 00 00    	ja     80240d <file_read+0xba>
	if (offset + n > size)
  802378:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80237b:	39 d0                	cmp    %edx,%eax
  80237d:	76 04                	jbe    802383 <file_read+0x30>
		n = size - offset;
  80237f:	89 d6                	mov    %edx,%esi
  802381:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  802383:	83 ec 0c             	sub    $0xc,%esp
  802386:	ff 75 08             	pushl  0x8(%ebp)
  802389:	e8 7e f9 ff ff       	call   801d0c <fd2data>
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	01 fb                	add    %edi,%ebx
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	eb 41                	jmp    8023d8 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  802397:	89 d8                	mov    %ebx,%eax
  802399:	c1 e8 16             	shr    $0x16,%eax
  80239c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8023a3:	a8 01                	test   $0x1,%al
  8023a5:	74 10                	je     8023b7 <file_read+0x64>
  8023a7:	89 d8                	mov    %ebx,%eax
  8023a9:	c1 e8 0c             	shr    $0xc,%eax
  8023ac:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8023b3:	a8 01                	test   $0x1,%al
  8023b5:	75 1b                	jne    8023d2 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8023b7:	83 ec 04             	sub    $0x4,%esp
  8023ba:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8023bd:	50                   	push   %eax
  8023be:	57                   	push   %edi
  8023bf:	ff 75 08             	pushl  0x8(%ebp)
  8023c2:	e8 d4 02 00 00       	call   80269b <fmap>
  8023c7:	83 c4 10             	add    $0x10,%esp
              return r;
  8023ca:	89 c1                	mov    %eax,%ecx
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	78 3d                	js     80240d <file_read+0xba>
  8023d0:	eb 1c                	jmp    8023ee <file_read+0x9b>
  8023d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	ff 75 08             	pushl  0x8(%ebp)
  8023de:	e8 29 f9 ff ff       	call   801d0c <fd2data>
  8023e3:	01 f8                	add    %edi,%eax
  8023e5:	01 f0                	add    %esi,%eax
  8023e7:	83 c4 10             	add    $0x10,%esp
  8023ea:	39 d8                	cmp    %ebx,%eax
  8023ec:	77 a9                	ja     802397 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  8023ee:	83 ec 04             	sub    $0x4,%esp
  8023f1:	56                   	push   %esi
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	ff 75 08             	pushl  0x8(%ebp)
  8023f8:	e8 0f f9 ff ff       	call   801d0c <fd2data>
  8023fd:	83 c4 08             	add    $0x8,%esp
  802400:	01 f8                	add    %edi,%eax
  802402:	50                   	push   %eax
  802403:	ff 75 0c             	pushl  0xc(%ebp)
  802406:	e8 b1 ef ff ff       	call   8013bc <memmove>
	return n;
  80240b:	89 f1                	mov    %esi,%ecx
}
  80240d:	89 c8                	mov    %ecx,%eax
  80240f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802412:	5b                   	pop    %ebx
  802413:	5e                   	pop    %esi
  802414:	5f                   	pop    %edi
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	56                   	push   %esi
  80241b:	53                   	push   %ebx
  80241c:	83 ec 18             	sub    $0x18,%esp
  80241f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802422:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802425:	50                   	push   %eax
  802426:	ff 75 08             	pushl  0x8(%ebp)
  802429:	e8 60 f9 ff ff       	call   801d8e <fd_lookup>
  80242e:	83 c4 10             	add    $0x10,%esp
		return r;
  802431:	89 c2                	mov    %eax,%edx
  802433:	85 c0                	test   %eax,%eax
  802435:	0f 88 9f 00 00 00    	js     8024da <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  80243b:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  802440:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802445:	3b 05 40 80 80 00    	cmp    0x808040,%eax
  80244b:	0f 85 89 00 00 00    	jne    8024da <read_map+0xc3>
	va = fd2data(fd) + offset;
  802451:	83 ec 0c             	sub    $0xc,%esp
  802454:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  802457:	e8 b0 f8 ff ff       	call   801d0c <fd2data>
  80245c:	89 c3                	mov    %eax,%ebx
  80245e:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  802460:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  802463:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  802468:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  80246e:	7f 6a                	jg     8024da <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  802470:	89 d8                	mov    %ebx,%eax
  802472:	c1 e8 16             	shr    $0x16,%eax
  802475:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80247c:	a8 01                	test   $0x1,%al
  80247e:	74 10                	je     802490 <read_map+0x79>
  802480:	89 d8                	mov    %ebx,%eax
  802482:	c1 e8 0c             	shr    $0xc,%eax
  802485:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80248c:	a8 01                	test   $0x1,%al
  80248e:	75 19                	jne    8024a9 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	8d 46 01             	lea    0x1(%esi),%eax
  802496:	50                   	push   %eax
  802497:	56                   	push   %esi
  802498:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80249b:	e8 fb 01 00 00       	call   80269b <fmap>
  8024a0:	83 c4 10             	add    $0x10,%esp
            return r;
  8024a3:	89 c2                	mov    %eax,%edx
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	78 31                	js     8024da <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	c1 e8 16             	shr    $0x16,%eax
  8024ae:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8024b5:	a8 01                	test   $0x1,%al
  8024b7:	74 10                	je     8024c9 <read_map+0xb2>
  8024b9:	89 d8                	mov    %ebx,%eax
  8024bb:	c1 e8 0c             	shr    $0xc,%eax
  8024be:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8024c5:	a8 01                	test   $0x1,%al
  8024c7:	75 07                	jne    8024d0 <read_map+0xb9>
		return -E_NO_DISK;
  8024c9:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8024ce:	eb 0a                	jmp    8024da <read_map+0xc3>

	*blk = (void*) va;
  8024d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d3:	89 18                	mov    %ebx,(%eax)
	return 0;
  8024d5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8024da:	89 d0                	mov    %edx,%eax
  8024dc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	57                   	push   %edi
  8024e7:	56                   	push   %esi
  8024e8:	53                   	push   %ebx
  8024e9:	83 ec 0c             	sub    $0xc,%esp
  8024ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8024ef:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  8024f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f5:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  8024f8:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  8024fd:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  802503:	0f 87 bd 00 00 00    	ja     8025c6 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  802509:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  80250f:	73 17                	jae    802528 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  802511:	83 ec 08             	sub    $0x8,%esp
  802514:	52                   	push   %edx
  802515:	56                   	push   %esi
  802516:	e8 fb 00 00 00       	call   802616 <file_trunc>
  80251b:	83 c4 10             	add    $0x10,%esp
			return r;
  80251e:	89 c1                	mov    %eax,%ecx
  802520:	85 c0                	test   %eax,%eax
  802522:	0f 88 9e 00 00 00    	js     8025c6 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  802528:	83 ec 0c             	sub    $0xc,%esp
  80252b:	56                   	push   %esi
  80252c:	e8 db f7 ff ff       	call   801d0c <fd2data>
  802531:	89 c3                	mov    %eax,%ebx
  802533:	01 fb                	add    %edi,%ebx
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	eb 42                	jmp    80257c <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  80253a:	89 d8                	mov    %ebx,%eax
  80253c:	c1 e8 16             	shr    $0x16,%eax
  80253f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  802546:	a8 01                	test   $0x1,%al
  802548:	74 10                	je     80255a <file_write+0x77>
  80254a:	89 d8                	mov    %ebx,%eax
  80254c:	c1 e8 0c             	shr    $0xc,%eax
  80254f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  802556:	a8 01                	test   $0x1,%al
  802558:	75 1c                	jne    802576 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  80255a:	83 ec 04             	sub    $0x4,%esp
  80255d:	8b 55 10             	mov    0x10(%ebp),%edx
  802560:	8d 04 17             	lea    (%edi,%edx,1),%eax
  802563:	50                   	push   %eax
  802564:	57                   	push   %edi
  802565:	56                   	push   %esi
  802566:	e8 30 01 00 00       	call   80269b <fmap>
  80256b:	83 c4 10             	add    $0x10,%esp
              return r;
  80256e:	89 c1                	mov    %eax,%ecx
  802570:	85 c0                	test   %eax,%eax
  802572:	78 52                	js     8025c6 <file_write+0xe3>
  802574:	eb 1b                	jmp    802591 <file_write+0xae>
  802576:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80257c:	83 ec 0c             	sub    $0xc,%esp
  80257f:	56                   	push   %esi
  802580:	e8 87 f7 ff ff       	call   801d0c <fd2data>
  802585:	01 f8                	add    %edi,%eax
  802587:	03 45 10             	add    0x10(%ebp),%eax
  80258a:	83 c4 10             	add    $0x10,%esp
  80258d:	39 d8                	cmp    %ebx,%eax
  80258f:	77 a9                	ja     80253a <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  802591:	83 ec 0c             	sub    $0xc,%esp
  802594:	68 26 40 80 00       	push   $0x804026
  802599:	e8 c6 e5 ff ff       	call   800b64 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  80259e:	83 c4 0c             	add    $0xc,%esp
  8025a1:	ff 75 10             	pushl  0x10(%ebp)
  8025a4:	ff 75 0c             	pushl  0xc(%ebp)
  8025a7:	56                   	push   %esi
  8025a8:	e8 5f f7 ff ff       	call   801d0c <fd2data>
  8025ad:	01 f8                	add    %edi,%eax
  8025af:	89 04 24             	mov    %eax,(%esp)
  8025b2:	e8 05 ee ff ff       	call   8013bc <memmove>
        cprintf("write done\n");
  8025b7:	c7 04 24 33 40 80 00 	movl   $0x804033,(%esp)
  8025be:	e8 a1 e5 ff ff       	call   800b64 <cprintf>
	return n;
  8025c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  8025c6:	89 c8                	mov    %ecx,%eax
  8025c8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8025cb:	5b                   	pop    %ebx
  8025cc:	5e                   	pop    %esi
  8025cd:	5f                   	pop    %edi
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	56                   	push   %esi
  8025d4:	53                   	push   %ebx
  8025d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8025d8:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  8025db:	83 ec 08             	sub    $0x8,%esp
  8025de:	8d 43 10             	lea    0x10(%ebx),%eax
  8025e1:	50                   	push   %eax
  8025e2:	56                   	push   %esi
  8025e3:	e8 58 ec ff ff       	call   801240 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  8025e8:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  8025ee:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  8025f4:	83 c4 10             	add    $0x10,%esp
  8025f7:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  8025fe:	0f 94 c0             	sete   %al
  802601:	0f b6 c0             	movzbl %al,%eax
  802604:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
  80260f:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802612:	5b                   	pop    %ebx
  802613:	5e                   	pop    %esi
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	57                   	push   %edi
  80261a:	56                   	push   %esi
  80261b:	53                   	push   %ebx
  80261c:	83 ec 0c             	sub    $0xc,%esp
  80261f:	8b 75 08             	mov    0x8(%ebp),%esi
  802622:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  802625:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80262a:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  802630:	7f 5f                	jg     802691 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  802632:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  802638:	83 ec 08             	sub    $0x8,%esp
  80263b:	53                   	push   %ebx
  80263c:	ff 76 0c             	pushl  0xc(%esi)
  80263f:	e8 56 03 00 00       	call   80299a <fsipc_set_size>
  802644:	83 c4 10             	add    $0x10,%esp
		return r;
  802647:	89 c2                	mov    %eax,%edx
  802649:	85 c0                	test   %eax,%eax
  80264b:	78 44                	js     802691 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  80264d:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  802653:	74 19                	je     80266e <file_trunc+0x58>
  802655:	68 4c 40 80 00       	push   $0x80404c
  80265a:	68 af 39 80 00       	push   $0x8039af
  80265f:	68 dc 00 00 00       	push   $0xdc
  802664:	68 3f 40 80 00       	push   $0x80403f
  802669:	e8 06 e4 ff ff       	call   800a74 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80266e:	83 ec 04             	sub    $0x4,%esp
  802671:	53                   	push   %ebx
  802672:	57                   	push   %edi
  802673:	56                   	push   %esi
  802674:	e8 22 00 00 00       	call   80269b <fmap>
  802679:	83 c4 10             	add    $0x10,%esp
		return r;
  80267c:	89 c2                	mov    %eax,%edx
  80267e:	85 c0                	test   %eax,%eax
  802680:	78 0f                	js     802691 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  802682:	6a 00                	push   $0x0
  802684:	53                   	push   %ebx
  802685:	57                   	push   %edi
  802686:	56                   	push   %esi
  802687:	e8 85 00 00 00       	call   802711 <funmap>

	return 0;
  80268c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  802691:	89 d0                	mov    %edx,%eax
  802693:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802696:	5b                   	pop    %ebx
  802697:	5e                   	pop    %esi
  802698:	5f                   	pop    %edi
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <fmap>:

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
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	57                   	push   %edi
  80269f:	56                   	push   %esi
  8026a0:	53                   	push   %ebx
  8026a1:	83 ec 0c             	sub    $0xc,%esp
  8026a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026a7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  8026aa:	39 75 0c             	cmp    %esi,0xc(%ebp)
  8026ad:	7d 55                	jge    802704 <fmap+0x69>
          fma = fd2data(fd);
  8026af:	83 ec 0c             	sub    $0xc,%esp
  8026b2:	57                   	push   %edi
  8026b3:	e8 54 f6 ff ff       	call   801d0c <fd2data>
  8026b8:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  8026bb:	83 c4 10             	add    $0x10,%esp
  8026be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8026c6:	89 c3                	mov    %eax,%ebx
  8026c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8026ce:	39 f3                	cmp    %esi,%ebx
  8026d0:	7d 32                	jge    802704 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8026d8:	01 d8                	add    %ebx,%eax
  8026da:	50                   	push   %eax
  8026db:	53                   	push   %ebx
  8026dc:	ff 77 0c             	pushl  0xc(%edi)
  8026df:	e8 8b 02 00 00       	call   80296f <fsipc_map>
  8026e4:	83 c4 10             	add    $0x10,%esp
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	79 0f                	jns    8026fa <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	ff 75 0c             	pushl  0xc(%ebp)
  8026f0:	53                   	push   %ebx
  8026f1:	57                   	push   %edi
  8026f2:	e8 1a 00 00 00       	call   802711 <funmap>
  8026f7:	83 c4 10             	add    $0x10,%esp
  8026fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802700:	39 f3                	cmp    %esi,%ebx
  802702:	7c ce                	jl     8026d2 <fmap+0x37>
            }
          }
        }

        return 0;
}
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
  802709:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80270c:	5b                   	pop    %ebx
  80270d:	5e                   	pop    %esi
  80270e:	5f                   	pop    %edi
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <funmap>:

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
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
  802714:	57                   	push   %edi
  802715:	56                   	push   %esi
  802716:	53                   	push   %ebx
  802717:	83 ec 0c             	sub    $0xc,%esp
  80271a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80271d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  802720:	39 f3                	cmp    %esi,%ebx
  802722:	0f 8d 80 00 00 00    	jge    8027a8 <funmap+0x97>
          fma = fd2data(fd);
  802728:	83 ec 0c             	sub    $0xc,%esp
  80272b:	ff 75 08             	pushl  0x8(%ebp)
  80272e:	e8 d9 f5 ff ff       	call   801d0c <fd2data>
  802733:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  80273e:	89 c3                	mov    %eax,%ebx
  802740:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  802746:	39 f3                	cmp    %esi,%ebx
  802748:	7d 5e                	jge    8027a8 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  80274a:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80274d:	89 c2                	mov    %eax,%edx
  80274f:	c1 ea 0c             	shr    $0xc,%edx
  802752:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  802759:	a8 01                	test   $0x1,%al
  80275b:	74 41                	je     80279e <funmap+0x8d>
              if (dirty) {
  80275d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  802761:	74 21                	je     802784 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  802763:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  80276a:	a8 40                	test   $0x40,%al
  80276c:	74 16                	je     802784 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  80276e:	83 ec 08             	sub    $0x8,%esp
  802771:	53                   	push   %ebx
  802772:	8b 45 08             	mov    0x8(%ebp),%eax
  802775:	ff 70 0c             	pushl  0xc(%eax)
  802778:	e8 65 02 00 00       	call   8029e2 <fsipc_dirty>
  80277d:	83 c4 10             	add    $0x10,%esp
  802780:	85 c0                	test   %eax,%eax
  802782:	78 29                	js     8027ad <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  802784:	83 ec 08             	sub    $0x8,%esp
  802787:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80278a:	50                   	push   %eax
  80278b:	83 ec 04             	sub    $0x4,%esp
  80278e:	e8 41 ee ff ff       	call   8015d4 <sys_getenvid>
  802793:	89 04 24             	mov    %eax,(%esp)
  802796:	e8 fc ee ff ff       	call   801697 <sys_page_unmap>
  80279b:	83 c4 10             	add    $0x10,%esp
  80279e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8027a4:	39 f3                	cmp    %esi,%ebx
  8027a6:	7c a2                	jl     80274a <funmap+0x39>
            }
          }
        }

        return 0;
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ad:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8027b0:	5b                   	pop    %ebx
  8027b1:	5e                   	pop    %esi
  8027b2:	5f                   	pop    %edi
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <remove>:

// Delete a file
int
remove(const char *path)
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  8027bb:	ff 75 08             	pushl  0x8(%ebp)
  8027be:	e8 47 02 00 00       	call   802a0a <fsipc_remove>
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  8027cb:	e8 80 02 00 00       	call   802a50 <fsipc_sync>
}
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    
	...

008027d4 <writebuf>:


static void
writebuf(struct printbuf *b)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	53                   	push   %ebx
  8027d8:	83 ec 04             	sub    $0x4,%esp
  8027db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (b->error > 0) {
  8027de:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
  8027e2:	7e 2c                	jle    802810 <writebuf+0x3c>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8027e4:	83 ec 04             	sub    $0x4,%esp
  8027e7:	ff 73 04             	pushl  0x4(%ebx)
  8027ea:	8d 43 10             	lea    0x10(%ebx),%eax
  8027ed:	50                   	push   %eax
  8027ee:	ff 33                	pushl  (%ebx)
  8027f0:	e8 03 f9 ff ff       	call   8020f8 <write>
		if (result > 0)
  8027f5:	83 c4 10             	add    $0x10,%esp
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	7e 03                	jle    8027ff <writebuf+0x2b>
			b->result += result;
  8027fc:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8027ff:	39 43 04             	cmp    %eax,0x4(%ebx)
  802802:	74 0c                	je     802810 <writebuf+0x3c>
			b->error = (result < 0 ? result : 0);
  802804:	85 c0                	test   %eax,%eax
  802806:	7e 05                	jle    80280d <writebuf+0x39>
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
  80280d:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802810:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <putch>:

static void
putch(int ch, void *thunk)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	53                   	push   %ebx
  802819:	83 ec 04             	sub    $0x4,%esp
  80281c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80281f:	8b 43 04             	mov    0x4(%ebx),%eax
  802822:	8b 55 08             	mov    0x8(%ebp),%edx
  802825:	88 54 18 10          	mov    %dl,0x10(%eax,%ebx,1)
  802829:	40                   	inc    %eax
  80282a:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  80282d:	3d 00 01 00 00       	cmp    $0x100,%eax
  802832:	75 13                	jne    802847 <putch+0x32>
		writebuf(b);
  802834:	83 ec 0c             	sub    $0xc,%esp
  802837:	53                   	push   %ebx
  802838:	e8 97 ff ff ff       	call   8027d4 <writebuf>
		b->idx = 0;
  80283d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  802844:	83 c4 10             	add    $0x10,%esp
	}
}
  802847:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	53                   	push   %ebx
  802850:	81 ec 14 01 00 00    	sub    $0x114,%esp
	struct printbuf b;

	b.fd = fd;
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	89 85 e8 fe ff ff    	mov    %eax,0xfffffee8(%ebp)
	b.idx = 0;
  80285f:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  802866:	00 00 00 
	b.result = 0;
  802869:	c7 85 f0 fe ff ff 00 	movl   $0x0,0xfffffef0(%ebp)
  802870:	00 00 00 
	b.error = 1;
  802873:	c7 85 f4 fe ff ff 01 	movl   $0x1,0xfffffef4(%ebp)
  80287a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80287d:	ff 75 10             	pushl  0x10(%ebp)
  802880:	ff 75 0c             	pushl  0xc(%ebp)
  802883:	8d 9d e8 fe ff ff    	lea    0xfffffee8(%ebp),%ebx
  802889:	53                   	push   %ebx
  80288a:	68 15 28 80 00       	push   $0x802815
  80288f:	e8 02 e4 ff ff       	call   800c96 <vprintfmt>
	if (b.idx > 0)
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	83 bd ec fe ff ff 00 	cmpl   $0x0,0xfffffeec(%ebp)
  80289e:	7e 0c                	jle    8028ac <vfprintf+0x60>
		writebuf(&b);
  8028a0:	83 ec 0c             	sub    $0xc,%esp
  8028a3:	53                   	push   %ebx
  8028a4:	e8 2b ff ff ff       	call   8027d4 <writebuf>
  8028a9:	83 c4 10             	add    $0x10,%esp

	return (b.result ? b.result : b.error);
  8028ac:	8b 85 f0 fe ff ff    	mov    0xfffffef0(%ebp),%eax
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	75 06                	jne    8028bc <vfprintf+0x70>
  8028b6:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
}
  8028bc:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8028bf:	c9                   	leave  
  8028c0:	c3                   	ret    

008028c1 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
  8028c4:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8028c7:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8028ca:	50                   	push   %eax
  8028cb:	ff 75 0c             	pushl  0xc(%ebp)
  8028ce:	ff 75 08             	pushl  0x8(%ebp)
  8028d1:	e8 76 ff ff ff       	call   80284c <vfprintf>
	va_end(ap);

	return cnt;
}
  8028d6:	c9                   	leave  
  8028d7:	c3                   	ret    

008028d8 <printf>:

int
printf(const char *fmt, ...)
{
  8028d8:	55                   	push   %ebp
  8028d9:	89 e5                	mov    %esp,%ebp
  8028db:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8028de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8028e1:	50                   	push   %eax
  8028e2:	ff 75 08             	pushl  0x8(%ebp)
  8028e5:	6a 01                	push   $0x1
  8028e7:	e8 60 ff ff ff       	call   80284c <vfprintf>
	va_end(ap);

	return cnt;
}
  8028ec:	c9                   	leave  
  8028ed:	c3                   	ret    
	...

008028f0 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
  8028f3:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  8028f6:	6a 07                	push   $0x7
  8028f8:	ff 75 0c             	pushl  0xc(%ebp)
  8028fb:	ff 75 08             	pushl  0x8(%ebp)
  8028fe:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  802903:	50                   	push   %eax
  802904:	e8 f2 0b 00 00       	call   8034fb <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802909:	83 c4 0c             	add    $0xc,%esp
  80290c:	ff 75 14             	pushl  0x14(%ebp)
  80290f:	ff 75 10             	pushl  0x10(%ebp)
  802912:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802915:	50                   	push   %eax
  802916:	e8 7d 0b 00 00       	call   803498 <ipc_recv>
}
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
  802920:	56                   	push   %esi
  802921:	53                   	push   %ebx
  802922:	83 ec 1c             	sub    $0x1c,%esp
  802925:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  802928:	bb 00 50 80 00       	mov    $0x805000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  80292d:	56                   	push   %esi
  80292e:	e8 d1 e8 ff ff       	call   801204 <strlen>
  802933:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  802936:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80293b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802940:	7f 24                	jg     802966 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  802942:	83 ec 08             	sub    $0x8,%esp
  802945:	56                   	push   %esi
  802946:	53                   	push   %ebx
  802947:	e8 f4 e8 ff ff       	call   801240 <strcpy>
	req->req_omode = omode;
  80294c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294f:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  802955:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802958:	50                   	push   %eax
  802959:	ff 75 10             	pushl  0x10(%ebp)
  80295c:	53                   	push   %ebx
  80295d:	6a 01                	push   $0x1
  80295f:	e8 8c ff ff ff       	call   8028f0 <fsipc>
  802964:	89 c2                	mov    %eax,%edx
}
  802966:	89 d0                	mov    %edx,%eax
  802968:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80296b:	5b                   	pop    %ebx
  80296c:	5e                   	pop    %esi
  80296d:	c9                   	leave  
  80296e:	c3                   	ret    

0080296f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	a3 00 50 80 00       	mov    %eax,0x805000
        req->req_offset = offset;
  80297d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802980:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  802985:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802988:	50                   	push   %eax
  802989:	ff 75 10             	pushl  0x10(%ebp)
  80298c:	68 00 50 80 00       	push   $0x805000
  802991:	6a 02                	push   $0x2
  802993:	e8 58 ff ff ff       	call   8028f0 <fsipc>

	//return -E_UNSPECIFIED;
}
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	a3 00 50 80 00       	mov    %eax,0x805000
	req->req_size = size;
  8029a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ab:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 00                	push   $0x0
  8029b4:	68 00 50 80 00       	push   $0x805000
  8029b9:	6a 03                	push   $0x3
  8029bb:	e8 30 ff ff ff       	call   8028f0 <fsipc>
}
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
  8029c5:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	68 00 50 80 00       	push   $0x805000
  8029d9:	6a 04                	push   $0x4
  8029db:	e8 10 ff ff ff       	call   8028f0 <fsipc>
}
  8029e0:	c9                   	leave  
  8029e1:	c3                   	ret    

008029e2 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
  8029e5:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	a3 00 50 80 00       	mov    %eax,0x805000
        req->req_offset = offset;
  8029f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	68 00 50 80 00       	push   $0x805000
  802a01:	6a 05                	push   $0x5
  802a03:	e8 e8 fe ff ff       	call   8028f0 <fsipc>
}
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    

00802a0a <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
  802a0d:	56                   	push   %esi
  802a0e:	53                   	push   %ebx
  802a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802a12:	be 00 50 80 00       	mov    $0x805000,%esi
	if (strlen(path) >= MAXPATHLEN)
  802a17:	83 ec 0c             	sub    $0xc,%esp
  802a1a:	53                   	push   %ebx
  802a1b:	e8 e4 e7 ff ff       	call   801204 <strlen>
  802a20:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  802a23:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802a28:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a2d:	7f 18                	jg     802a47 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  802a2f:	83 ec 08             	sub    $0x8,%esp
  802a32:	53                   	push   %ebx
  802a33:	56                   	push   %esi
  802a34:	e8 07 e8 ff ff       	call   801240 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 00                	push   $0x0
  802a3d:	56                   	push   %esi
  802a3e:	6a 06                	push   $0x6
  802a40:	e8 ab fe ff ff       	call   8028f0 <fsipc>
  802a45:	89 c2                	mov    %eax,%edx
}
  802a47:	89 d0                	mov    %edx,%eax
  802a49:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802a4c:	5b                   	pop    %ebx
  802a4d:	5e                   	pop    %esi
  802a4e:	c9                   	leave  
  802a4f:	c3                   	ret    

00802a50 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	68 00 50 80 00       	push   $0x805000
  802a5f:	6a 07                	push   $0x7
  802a61:	e8 8a fe ff ff       	call   8028f0 <fsipc>
}
  802a66:	c9                   	leave  
  802a67:	c3                   	ret    

00802a68 <spawn>:
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
  802a6b:	57                   	push   %edi
  802a6c:	56                   	push   %esi
  802a6d:	53                   	push   %ebx
  802a6e:	81 ec 74 02 00 00    	sub    $0x274,%esp
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
  802a74:	6a 00                	push   $0x0
  802a76:	ff 75 08             	pushl  0x8(%ebp)
  802a79:	e8 3e f8 ff ff       	call   8022bc <open>
  802a7e:	89 c3                	mov    %eax,%ebx
  802a80:	83 c4 10             	add    $0x10,%esp
  802a83:	85 db                	test   %ebx,%ebx
  802a85:	0f 88 ed 01 00 00    	js     802c78 <spawn+0x210>
		return r;
	fd = r;
  802a8b:	89 9d 90 fd ff ff    	mov    %ebx,0xfffffd90(%ebp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	68 00 02 00 00       	push   $0x200
  802a99:	8d 85 e8 fd ff ff    	lea    0xfffffde8(%ebp),%eax
  802a9f:	50                   	push   %eax
  802aa0:	53                   	push   %ebx
  802aa1:	e8 7b f5 ff ff       	call   802021 <read>
  802aa6:	83 c4 10             	add    $0x10,%esp
  802aa9:	3d 00 02 00 00       	cmp    $0x200,%eax
  802aae:	75 0c                	jne    802abc <spawn+0x54>
  802ab0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,0xfffffde8(%ebp)
  802ab7:	45 4c 46 
  802aba:	74 30                	je     802aec <spawn+0x84>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802ac5:	e8 e4 f3 ff ff       	call   801eae <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802aca:	83 c4 0c             	add    $0xc,%esp
  802acd:	68 7f 45 4c 46       	push   $0x464c457f
  802ad2:	ff b5 e8 fd ff ff    	pushl  0xfffffde8(%ebp)
  802ad8:	68 6f 40 80 00       	push   $0x80406f
  802add:	e8 82 e0 ff ff       	call   800b64 <cprintf>
		return -E_NOT_EXEC;
  802ae2:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802ae7:	e9 8c 01 00 00       	jmp    802c78 <spawn+0x210>
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802aec:	ba 07 00 00 00       	mov    $0x7,%edx
  802af1:	89 d0                	mov    %edx,%eax
  802af3:	cd 30                	int    $0x30
  802af5:	89 c3                	mov    %eax,%ebx
  802af7:	85 db                	test   %ebx,%ebx
  802af9:	0f 88 79 01 00 00    	js     802c78 <spawn+0x210>
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
	child = r;
  802aff:	89 9d 94 fd ff ff    	mov    %ebx,0xfffffd94(%ebp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b05:	89 d8                	mov    %ebx,%eax
  802b07:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b0c:	c1 e0 07             	shl    $0x7,%eax
  802b0f:	8d 95 98 fd ff ff    	lea    0xfffffd98(%ebp),%edx
  802b15:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	6a 44                	push   $0x44
  802b1f:	50                   	push   %eax
  802b20:	52                   	push   %edx
  802b21:	e8 01 e9 ff ff       	call   801427 <memcpy>
	child_tf.tf_eip = elf->e_entry;
  802b26:	8b 85 00 fe ff ff    	mov    0xfffffe00(%ebp),%eax
  802b2c:	89 85 c8 fd ff ff    	mov    %eax,0xfffffdc8(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  802b32:	83 c4 0c             	add    $0xc,%esp
  802b35:	8d 85 d4 fd ff ff    	lea    0xfffffdd4(%ebp),%eax
  802b3b:	50                   	push   %eax
  802b3c:	ff 75 0c             	pushl  0xc(%ebp)
  802b3f:	53                   	push   %ebx
  802b40:	e8 4f 01 00 00       	call   802c94 <init_stack>
  802b45:	89 c3                	mov    %eax,%ebx
  802b47:	83 c4 10             	add    $0x10,%esp
  802b4a:	85 db                	test   %ebx,%ebx
  802b4c:	0f 88 26 01 00 00    	js     802c78 <spawn+0x210>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802b52:	8b 85 04 fe ff ff    	mov    0xfffffe04(%ebp),%eax
  802b58:	8d b4 05 e8 fd ff ff 	lea    0xfffffde8(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b5f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b64:	66 83 bd 14 fe ff ff 	cmpw   $0x0,0xfffffe14(%ebp)
  802b6b:	00 
  802b6c:	74 4f                	je     802bbd <spawn+0x155>
		if (ph->p_type != ELF_PROG_LOAD)
  802b6e:	83 3e 01             	cmpl   $0x1,(%esi)
  802b71:	75 3b                	jne    802bae <spawn+0x146>
			continue;
		perm = PTE_P | PTE_U;
  802b73:	b8 05 00 00 00       	mov    $0x5,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802b78:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  802b7c:	74 02                	je     802b80 <spawn+0x118>
			perm |= PTE_W;
  802b7e:	b0 07                	mov    $0x7,%al
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	50                   	push   %eax
  802b84:	ff 76 04             	pushl  0x4(%esi)
  802b87:	ff 76 10             	pushl  0x10(%esi)
  802b8a:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802b90:	ff 76 14             	pushl  0x14(%esi)
  802b93:	ff 76 08             	pushl  0x8(%esi)
  802b96:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802b9c:	e8 5f 02 00 00       	call   802e00 <map_segment>
  802ba1:	89 c3                	mov    %eax,%ebx
  802ba3:	83 c4 20             	add    $0x20,%esp
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	0f 88 ac 00 00 00    	js     802c5a <spawn+0x1f2>
  802bae:	47                   	inc    %edi
  802baf:	83 c6 20             	add    $0x20,%esi
  802bb2:	0f b7 85 14 fe ff ff 	movzwl 0xfffffe14(%ebp),%eax
  802bb9:	39 f8                	cmp    %edi,%eax
  802bbb:	7f b1                	jg     802b6e <spawn+0x106>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802bbd:	83 ec 0c             	sub    $0xc,%esp
  802bc0:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802bc6:	e8 e3 f2 ff ff       	call   801eae <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802bcb:	83 c4 04             	add    $0x4,%esp
  802bce:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802bd4:	e8 9f 03 00 00       	call   802f78 <copy_shared_pages>
  802bd9:	83 c4 10             	add    $0x10,%esp
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	79 15                	jns    802bf5 <spawn+0x18d>
		panic("copy_shared_pages: %e", r);
  802be0:	50                   	push   %eax
  802be1:	68 89 40 80 00       	push   $0x804089
  802be6:	68 82 00 00 00       	push   $0x82
  802beb:	68 9f 40 80 00       	push   $0x80409f
  802bf0:	e8 7f de ff ff       	call   800a74 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802bf5:	83 ec 08             	sub    $0x8,%esp
  802bf8:	8d 85 98 fd ff ff    	lea    0xfffffd98(%ebp),%eax
  802bfe:	50                   	push   %eax
  802bff:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802c05:	e8 11 eb ff ff       	call   80171b <sys_env_set_trapframe>
  802c0a:	83 c4 10             	add    $0x10,%esp
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	79 15                	jns    802c26 <spawn+0x1be>
		panic("sys_env_set_trapframe: %e", r);
  802c11:	50                   	push   %eax
  802c12:	68 ab 40 80 00       	push   $0x8040ab
  802c17:	68 85 00 00 00       	push   $0x85
  802c1c:	68 9f 40 80 00       	push   $0x80409f
  802c21:	e8 4e de ff ff       	call   800a74 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802c26:	83 ec 08             	sub    $0x8,%esp
  802c29:	6a 01                	push   $0x1
  802c2b:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802c31:	e8 a3 ea ff ff       	call   8016d9 <sys_env_set_status>
  802c36:	89 c3                	mov    %eax,%ebx
  802c38:	83 c4 10             	add    $0x10,%esp
		panic("sys_env_set_status: %e", r);

	return child;
  802c3b:	8b 85 94 fd ff ff    	mov    0xfffffd94(%ebp),%eax
  802c41:	85 db                	test   %ebx,%ebx
  802c43:	79 33                	jns    802c78 <spawn+0x210>
  802c45:	53                   	push   %ebx
  802c46:	68 c5 40 80 00       	push   $0x8040c5
  802c4b:	68 88 00 00 00       	push   $0x88
  802c50:	68 9f 40 80 00       	push   $0x80409f
  802c55:	e8 1a de ff ff       	call   800a74 <_panic>

error:
	sys_env_destroy(child);
  802c5a:	83 ec 0c             	sub    $0xc,%esp
  802c5d:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802c63:	e8 2b e9 ff ff       	call   801593 <sys_env_destroy>
	close(fd);
  802c68:	83 c4 04             	add    $0x4,%esp
  802c6b:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802c71:	e8 38 f2 ff ff       	call   801eae <close>
	return r;
  802c76:	89 d8                	mov    %ebx,%eax
}
  802c78:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802c7b:	5b                   	pop    %ebx
  802c7c:	5e                   	pop    %esi
  802c7d:	5f                   	pop    %edi
  802c7e:	c9                   	leave  
  802c7f:	c3                   	ret    

00802c80 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
  802c83:	83 ec 10             	sub    $0x10,%esp
	return spawn(prog, &arg0);
  802c86:	8d 45 0c             	lea    0xc(%ebp),%eax
  802c89:	50                   	push   %eax
  802c8a:	ff 75 08             	pushl  0x8(%ebp)
  802c8d:	e8 d6 fd ff ff       	call   802a68 <spawn>
}
  802c92:	c9                   	leave  
  802c93:	c3                   	ret    

00802c94 <init_stack>:


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
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	57                   	push   %edi
  802c98:	56                   	push   %esi
  802c99:	53                   	push   %ebx
  802c9a:	83 ec 0c             	sub    $0xc,%esp
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802c9d:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  802ca2:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
  802ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cac:	83 38 00             	cmpl   $0x0,(%eax)
  802caf:	74 27                	je     802cd8 <init_stack+0x44>
		string_size += strlen(argv[argc]) + 1;
  802cb1:	83 ec 0c             	sub    $0xc,%esp
  802cb4:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cba:	ff 34 90             	pushl  (%eax,%edx,4)
  802cbd:	e8 42 e5 ff ff       	call   801204 <strlen>
  802cc2:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
  802cc6:	83 c4 10             	add    $0x10,%esp
  802cc9:	ff 45 f0             	incl   0xfffffff0(%ebp)
  802ccc:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd2:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  802cd6:	75 d9                	jne    802cb1 <init_stack+0x1d>

	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802cd8:	b8 00 10 40 00       	mov    $0x401000,%eax
  802cdd:	89 c7                	mov    %eax,%edi
  802cdf:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802ce1:	89 fa                	mov    %edi,%edx
  802ce3:	83 e2 fc             	and    $0xfffffffc,%edx
  802ce6:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802ce9:	c1 e0 02             	shl    $0x2,%eax
  802cec:	89 d6                	mov    %edx,%esi
  802cee:	29 c6                	sub    %eax,%esi
  802cf0:	83 ee 04             	sub    $0x4,%esi
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802cf3:	8d 46 f8             	lea    0xfffffff8(%esi),%eax
		return -E_NO_MEM;
  802cf6:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
  802cfb:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802d00:	0f 86 f0 00 00 00    	jbe    802df6 <init_stack+0x162>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	6a 07                	push   $0x7
  802d0b:	68 00 00 40 00       	push   $0x400000
  802d10:	6a 00                	push   $0x0
  802d12:	e8 fb e8 ff ff       	call   801612 <sys_page_alloc>
  802d17:	83 c4 10             	add    $0x10,%esp
		return r;
  802d1a:	89 c2                	mov    %eax,%edx
  802d1c:	85 c0                	test   %eax,%eax
  802d1e:	0f 88 d2 00 00 00    	js     802df6 <init_stack+0x162>


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
  802d24:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d29:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  802d2c:	7d 33                	jge    802d61 <init_stack+0xcd>
		argv_store[i] = UTEMP2USTACK(string_store);
  802d2e:	8d 87 00 d0 7f ee    	lea    0xee7fd000(%edi),%eax
  802d34:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
		strcpy(string_store, argv[i]);
  802d37:	83 ec 08             	sub    $0x8,%esp
  802d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3d:	ff 34 9a             	pushl  (%edx,%ebx,4)
  802d40:	57                   	push   %edi
  802d41:	e8 fa e4 ff ff       	call   801240 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802d46:	83 c4 04             	add    $0x4,%esp
  802d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4c:	ff 34 98             	pushl  (%eax,%ebx,4)
  802d4f:	e8 b0 e4 ff ff       	call   801204 <strlen>
  802d54:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
  802d58:	83 c4 10             	add    $0x10,%esp
  802d5b:	43                   	inc    %ebx
  802d5c:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  802d5f:	7c cd                	jl     802d2e <init_stack+0x9a>
	}
	argv_store[argc] = 0;
  802d61:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802d64:	c7 04 96 00 00 00 00 	movl   $0x0,(%esi,%edx,4)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802d6b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802d71:	74 19                	je     802d8c <init_stack+0xf8>
  802d73:	68 18 41 80 00       	push   $0x804118
  802d78:	68 af 39 80 00       	push   $0x8039af
  802d7d:	68 d9 00 00 00       	push   $0xd9
  802d82:	68 9f 40 80 00       	push   $0x80409f
  802d87:	e8 e8 dc ff ff       	call   800a74 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802d8c:	8d 86 00 d0 7f ee    	lea    0xee7fd000(%esi),%eax
  802d92:	89 46 fc             	mov    %eax,0xfffffffc(%esi)
	argv_store[-2] = argc;
  802d95:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802d98:	89 46 f8             	mov    %eax,0xfffffff8(%esi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802d9b:	8d 96 f8 cf 7f ee    	lea    0xee7fcff8(%esi),%edx
  802da1:	8b 45 10             	mov    0x10(%ebp),%eax
  802da4:	89 10                	mov    %edx,(%eax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802da6:	83 ec 0c             	sub    $0xc,%esp
  802da9:	6a 07                	push   $0x7
  802dab:	68 00 d0 bf ee       	push   $0xeebfd000
  802db0:	ff 75 08             	pushl  0x8(%ebp)
  802db3:	68 00 00 40 00       	push   $0x400000
  802db8:	6a 00                	push   $0x0
  802dba:	e8 96 e8 ff ff       	call   801655 <sys_page_map>
  802dbf:	89 c3                	mov    %eax,%ebx
  802dc1:	83 c4 20             	add    $0x20,%esp
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	78 1d                	js     802de5 <init_stack+0x151>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802dc8:	83 ec 08             	sub    $0x8,%esp
  802dcb:	68 00 00 40 00       	push   $0x400000
  802dd0:	6a 00                	push   $0x0
  802dd2:	e8 c0 e8 ff ff       	call   801697 <sys_page_unmap>
  802dd7:	89 c3                	mov    %eax,%ebx
  802dd9:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  802ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  802de1:	85 c0                	test   %eax,%eax
  802de3:	79 11                	jns    802df6 <init_stack+0x162>

error:
	sys_page_unmap(0, UTEMP);
  802de5:	83 ec 08             	sub    $0x8,%esp
  802de8:	68 00 00 40 00       	push   $0x400000
  802ded:	6a 00                	push   $0x0
  802def:	e8 a3 e8 ff ff       	call   801697 <sys_page_unmap>
	return r;
  802df4:	89 da                	mov    %ebx,%edx
}
  802df6:	89 d0                	mov    %edx,%eax
  802df8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802dfb:	5b                   	pop    %ebx
  802dfc:	5e                   	pop    %esi
  802dfd:	5f                   	pop    %edi
  802dfe:	c9                   	leave  
  802dff:	c3                   	ret    

00802e00 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz, 
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
  802e03:	57                   	push   %edi
  802e04:	56                   	push   %esi
  802e05:	53                   	push   %ebx
  802e06:	83 ec 0c             	sub    $0xc,%esp
  802e09:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e0c:	8b 7d 18             	mov    0x18(%ebp),%edi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802e0f:	89 f3                	mov    %esi,%ebx
  802e11:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  802e17:	74 0a                	je     802e23 <map_segment+0x23>
		va -= i;
  802e19:	29 de                	sub    %ebx,%esi
		memsz += i;
  802e1b:	01 5d 10             	add    %ebx,0x10(%ebp)
		filesz += i;
  802e1e:	01 df                	add    %ebx,%edi
		fileoffset -= i;
  802e20:	29 5d 1c             	sub    %ebx,0x1c(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802e23:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e28:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802e2b:	0f 83 3a 01 00 00    	jae    802f6b <map_segment+0x16b>
		if (i >= filesz) {
  802e31:	39 fb                	cmp    %edi,%ebx
  802e33:	72 22                	jb     802e57 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802e35:	83 ec 04             	sub    $0x4,%esp
  802e38:	ff 75 20             	pushl  0x20(%ebp)
  802e3b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  802e3e:	50                   	push   %eax
  802e3f:	ff 75 08             	pushl  0x8(%ebp)
  802e42:	e8 cb e7 ff ff       	call   801612 <sys_page_alloc>
  802e47:	83 c4 10             	add    $0x10,%esp
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	0f 89 0a 01 00 00    	jns    802f5c <map_segment+0x15c>
				return r;
  802e52:	e9 19 01 00 00       	jmp    802f70 <map_segment+0x170>
		} else {
			// from file
			if (perm & PTE_W) {
  802e57:	f6 45 20 02          	testb  $0x2,0x20(%ebp)
  802e5b:	0f 84 ac 00 00 00    	je     802f0d <map_segment+0x10d>
				// must make a copy so it can be writable
				if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	6a 07                	push   $0x7
  802e66:	68 00 00 40 00       	push   $0x400000
  802e6b:	6a 00                	push   $0x0
  802e6d:	e8 a0 e7 ff ff       	call   801612 <sys_page_alloc>
  802e72:	83 c4 10             	add    $0x10,%esp
  802e75:	85 c0                	test   %eax,%eax
  802e77:	0f 88 f3 00 00 00    	js     802f70 <map_segment+0x170>
					return r;
				if ((r = seek(fd, fileoffset + i)) < 0)
  802e7d:	83 ec 08             	sub    $0x8,%esp
  802e80:	8b 45 1c             	mov    0x1c(%ebp),%eax
  802e83:	01 d8                	add    %ebx,%eax
  802e85:	50                   	push   %eax
  802e86:	ff 75 14             	pushl  0x14(%ebp)
  802e89:	e8 f5 f2 ff ff       	call   802183 <seek>
  802e8e:	83 c4 10             	add    $0x10,%esp
  802e91:	85 c0                	test   %eax,%eax
  802e93:	0f 88 d7 00 00 00    	js     802f70 <map_segment+0x170>
					return r;
				if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802e99:	89 fa                	mov    %edi,%edx
  802e9b:	29 da                	sub    %ebx,%edx
  802e9d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ea2:	39 d0                	cmp    %edx,%eax
  802ea4:	76 02                	jbe    802ea8 <map_segment+0xa8>
  802ea6:	89 d0                	mov    %edx,%eax
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	50                   	push   %eax
  802eac:	68 00 00 40 00       	push   $0x400000
  802eb1:	ff 75 14             	pushl  0x14(%ebp)
  802eb4:	e8 68 f1 ff ff       	call   802021 <read>
  802eb9:	83 c4 10             	add    $0x10,%esp
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	0f 88 ac 00 00 00    	js     802f70 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802ec4:	83 ec 0c             	sub    $0xc,%esp
  802ec7:	ff 75 20             	pushl  0x20(%ebp)
  802eca:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  802ecd:	50                   	push   %eax
  802ece:	ff 75 08             	pushl  0x8(%ebp)
  802ed1:	68 00 00 40 00       	push   $0x400000
  802ed6:	6a 00                	push   $0x0
  802ed8:	e8 78 e7 ff ff       	call   801655 <sys_page_map>
  802edd:	83 c4 20             	add    $0x20,%esp
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	79 15                	jns    802ef9 <map_segment+0xf9>
					panic("spawn: sys_page_map data: %e", r);
  802ee4:	50                   	push   %eax
  802ee5:	68 dc 40 80 00       	push   $0x8040dc
  802eea:	68 0e 01 00 00       	push   $0x10e
  802eef:	68 9f 40 80 00       	push   $0x80409f
  802ef4:	e8 7b db ff ff       	call   800a74 <_panic>
				sys_page_unmap(0, UTEMP);
  802ef9:	83 ec 08             	sub    $0x8,%esp
  802efc:	68 00 00 40 00       	push   $0x400000
  802f01:	6a 00                	push   $0x0
  802f03:	e8 8f e7 ff ff       	call   801697 <sys_page_unmap>
  802f08:	83 c4 10             	add    $0x10,%esp
  802f0b:	eb 4f                	jmp    802f5c <map_segment+0x15c>
			} else {
				// can map buffer cache read only
				if ((r = read_map(fd, fileoffset + i, &blk)) < 0)
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  802f13:	50                   	push   %eax
  802f14:	8b 45 1c             	mov    0x1c(%ebp),%eax
  802f17:	01 d8                	add    %ebx,%eax
  802f19:	50                   	push   %eax
  802f1a:	ff 75 14             	pushl  0x14(%ebp)
  802f1d:	e8 f5 f4 ff ff       	call   802417 <read_map>
  802f22:	83 c4 10             	add    $0x10,%esp
  802f25:	85 c0                	test   %eax,%eax
  802f27:	78 47                	js     802f70 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, blk, child, (void*) (va + i), perm)) < 0)
  802f29:	83 ec 0c             	sub    $0xc,%esp
  802f2c:	ff 75 20             	pushl  0x20(%ebp)
  802f2f:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  802f32:	50                   	push   %eax
  802f33:	ff 75 08             	pushl  0x8(%ebp)
  802f36:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802f39:	6a 00                	push   $0x0
  802f3b:	e8 15 e7 ff ff       	call   801655 <sys_page_map>
  802f40:	83 c4 20             	add    $0x20,%esp
  802f43:	85 c0                	test   %eax,%eax
  802f45:	79 15                	jns    802f5c <map_segment+0x15c>
					panic("spawn: sys_page_map text: %e", r);
  802f47:	50                   	push   %eax
  802f48:	68 f9 40 80 00       	push   $0x8040f9
  802f4d:	68 15 01 00 00       	push   $0x115
  802f52:	68 9f 40 80 00       	push   $0x80409f
  802f57:	e8 18 db ff ff       	call   800a74 <_panic>
  802f5c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802f62:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802f65:	0f 82 c6 fe ff ff    	jb     802e31 <map_segment+0x31>
			}
		}
	}
	return 0;
  802f6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f70:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802f73:	5b                   	pop    %ebx
  802f74:	5e                   	pop    %esi
  802f75:	5f                   	pop    %edi
  802f76:	c9                   	leave  
  802f77:	c3                   	ret    

00802f78 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child) {
  802f78:	55                   	push   %ebp
  802f79:	89 e5                	mov    %esp,%ebp
  802f7b:	57                   	push   %edi
  802f7c:	56                   	push   %esi
  802f7d:	53                   	push   %ebx
  802f7e:	83 ec 0c             	sub    $0xc,%esp
  // LAB 7: Your code here.

  int i,j, r;
  void* va;

  for (i=0; i < VPD(UTOP); i++) {
  802f81:	be 00 00 00 00       	mov    $0x0,%esi
    if (vpd[i] & PTE_P) {
  802f86:	8b 04 b5 00 d0 7b ef 	mov    0xef7bd000(,%esi,4),%eax
  802f8d:	a8 01                	test   $0x1,%al
  802f8f:	74 68                	je     802ff9 <copy_shared_pages+0x81>
      for (j=0; j<NPTENTRIES && i*NPDENTRIES+j < (UXSTACKTOP-PGSIZE)/PGSIZE; j++) { // make sure not to remap exception stack this way
  802f91:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f96:	89 f0                	mov    %esi,%eax
  802f98:	c1 e0 0a             	shl    $0xa,%eax
  802f9b:	89 c2                	mov    %eax,%edx
  802f9d:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  802fa2:	77 55                	ja     802ff9 <copy_shared_pages+0x81>
  802fa4:	89 c7                	mov    %eax,%edi
        if ((vpt[i*NPDENTRIES+j] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  802fa6:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  802fa9:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  802fb0:	25 01 04 00 00       	and    $0x401,%eax
  802fb5:	3d 01 04 00 00       	cmp    $0x401,%eax
  802fba:	75 28                	jne    802fe4 <copy_shared_pages+0x6c>
          va = (void *)((i*NPDENTRIES+j) << PGSHIFT);
  802fbc:	89 ca                	mov    %ecx,%edx
  802fbe:	c1 e2 0c             	shl    $0xc,%edx
          if ((r = sys_page_map(0, va, child, va, vpt[i*NPDENTRIES+j] & PTE_USER)) < 0) {
  802fc1:	83 ec 0c             	sub    $0xc,%esp
  802fc4:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  802fcb:	25 07 0e 00 00       	and    $0xe07,%eax
  802fd0:	50                   	push   %eax
  802fd1:	52                   	push   %edx
  802fd2:	ff 75 08             	pushl  0x8(%ebp)
  802fd5:	52                   	push   %edx
  802fd6:	6a 00                	push   $0x0
  802fd8:	e8 78 e6 ff ff       	call   801655 <sys_page_map>
  802fdd:	83 c4 20             	add    $0x20,%esp
  802fe0:	85 c0                	test   %eax,%eax
  802fe2:	78 23                	js     803007 <copy_shared_pages+0x8f>
  802fe4:	43                   	inc    %ebx
  802fe5:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  802feb:	7f 0c                	jg     802ff9 <copy_shared_pages+0x81>
  802fed:	89 fa                	mov    %edi,%edx
  802fef:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  802ff2:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  802ff7:	76 ad                	jbe    802fa6 <copy_shared_pages+0x2e>
  802ff9:	46                   	inc    %esi
  802ffa:	81 fe ba 03 00 00    	cmp    $0x3ba,%esi
  803000:	76 84                	jbe    802f86 <copy_shared_pages+0xe>
            return r;
          }
        }
      }
    }
  }

  return 0;
  803002:	b8 00 00 00 00       	mov    $0x0,%eax

}
  803007:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80300a:	5b                   	pop    %ebx
  80300b:	5e                   	pop    %esi
  80300c:	5f                   	pop    %edi
  80300d:	c9                   	leave  
  80300e:	c3                   	ret    
	...

00803010 <pipe>:
};

int
pipe(int pfd[2])
{
  803010:	55                   	push   %ebp
  803011:	89 e5                	mov    %esp,%ebp
  803013:	57                   	push   %edi
  803014:	56                   	push   %esi
  803015:	53                   	push   %ebx
  803016:	83 ec 18             	sub    $0x18,%esp
  803019:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80301c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80301f:	50                   	push   %eax
  803020:	e8 0f ed ff ff       	call   801d34 <fd_alloc>
  803025:	89 c3                	mov    %eax,%ebx
  803027:	83 c4 10             	add    $0x10,%esp
  80302a:	85 c0                	test   %eax,%eax
  80302c:	0f 88 25 01 00 00    	js     803157 <pipe+0x147>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 07 04 00 00       	push   $0x407
  80303a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80303d:	6a 00                	push   $0x0
  80303f:	e8 ce e5 ff ff       	call   801612 <sys_page_alloc>
  803044:	89 c3                	mov    %eax,%ebx
  803046:	83 c4 10             	add    $0x10,%esp
  803049:	85 c0                	test   %eax,%eax
  80304b:	0f 88 06 01 00 00    	js     803157 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803051:	83 ec 0c             	sub    $0xc,%esp
  803054:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  803057:	50                   	push   %eax
  803058:	e8 d7 ec ff ff       	call   801d34 <fd_alloc>
  80305d:	89 c3                	mov    %eax,%ebx
  80305f:	83 c4 10             	add    $0x10,%esp
  803062:	85 c0                	test   %eax,%eax
  803064:	0f 88 dd 00 00 00    	js     803147 <pipe+0x137>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 07 04 00 00       	push   $0x407
  803072:	ff 75 ec             	pushl  0xffffffec(%ebp)
  803075:	6a 00                	push   $0x0
  803077:	e8 96 e5 ff ff       	call   801612 <sys_page_alloc>
  80307c:	89 c3                	mov    %eax,%ebx
  80307e:	83 c4 10             	add    $0x10,%esp
  803081:	85 c0                	test   %eax,%eax
  803083:	0f 88 be 00 00 00    	js     803147 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803089:	83 ec 0c             	sub    $0xc,%esp
  80308c:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80308f:	e8 78 ec ff ff       	call   801d0c <fd2data>
  803094:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803096:	83 c4 0c             	add    $0xc,%esp
  803099:	68 07 04 00 00       	push   $0x407
  80309e:	50                   	push   %eax
  80309f:	6a 00                	push   $0x0
  8030a1:	e8 6c e5 ff ff       	call   801612 <sys_page_alloc>
  8030a6:	89 c3                	mov    %eax,%ebx
  8030a8:	83 c4 10             	add    $0x10,%esp
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	0f 88 84 00 00 00    	js     803137 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030b3:	83 ec 0c             	sub    $0xc,%esp
  8030b6:	68 07 04 00 00       	push   $0x407
  8030bb:	83 ec 0c             	sub    $0xc,%esp
  8030be:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8030c1:	e8 46 ec ff ff       	call   801d0c <fd2data>
  8030c6:	83 c4 10             	add    $0x10,%esp
  8030c9:	50                   	push   %eax
  8030ca:	6a 00                	push   $0x0
  8030cc:	56                   	push   %esi
  8030cd:	6a 00                	push   $0x0
  8030cf:	e8 81 e5 ff ff       	call   801655 <sys_page_map>
  8030d4:	89 c3                	mov    %eax,%ebx
  8030d6:	83 c4 20             	add    $0x20,%esp
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	78 4c                	js     803129 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8030dd:	8b 15 60 80 80 00    	mov    0x808060,%edx
  8030e3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8030e6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8030e8:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8030eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8030f2:	8b 15 60 80 80 00    	mov    0x808060,%edx
  8030f8:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8030fb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8030fd:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  803100:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  803107:	83 ec 0c             	sub    $0xc,%esp
  80310a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80310d:	e8 12 ec ff ff       	call   801d24 <fd2num>
  803112:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  803114:	83 c4 04             	add    $0x4,%esp
  803117:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80311a:	e8 05 ec ff ff       	call   801d24 <fd2num>
  80311f:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803122:	b8 00 00 00 00       	mov    $0x0,%eax
  803127:	eb 30                	jmp    803159 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  803129:	83 ec 08             	sub    $0x8,%esp
  80312c:	56                   	push   %esi
  80312d:	6a 00                	push   $0x0
  80312f:	e8 63 e5 ff ff       	call   801697 <sys_page_unmap>
  803134:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  803137:	83 ec 08             	sub    $0x8,%esp
  80313a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80313d:	6a 00                	push   $0x0
  80313f:	e8 53 e5 ff ff       	call   801697 <sys_page_unmap>
  803144:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  803147:	83 ec 08             	sub    $0x8,%esp
  80314a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80314d:	6a 00                	push   $0x0
  80314f:	e8 43 e5 ff ff       	call   801697 <sys_page_unmap>
  803154:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  803157:	89 d8                	mov    %ebx,%eax
}
  803159:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80315c:	5b                   	pop    %ebx
  80315d:	5e                   	pop    %esi
  80315e:	5f                   	pop    %edi
  80315f:	c9                   	leave  
  803160:	c3                   	ret    

00803161 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
  803164:	57                   	push   %edi
  803165:	56                   	push   %esi
  803166:	53                   	push   %ebx
  803167:	83 ec 0c             	sub    $0xc,%esp
  80316a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  80316d:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  803172:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  803175:	83 ec 0c             	sub    $0xc,%esp
  803178:	ff 75 08             	pushl  0x8(%ebp)
  80317b:	e8 d4 03 00 00       	call   803554 <pageref>
  803180:	89 c3                	mov    %eax,%ebx
  803182:	89 3c 24             	mov    %edi,(%esp)
  803185:	e8 ca 03 00 00       	call   803554 <pageref>
  80318a:	83 c4 10             	add    $0x10,%esp
  80318d:	39 c3                	cmp    %eax,%ebx
  80318f:	0f 94 c0             	sete   %al
  803192:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  803195:	8b 0d a0 84 80 00    	mov    0x8084a0,%ecx
  80319b:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80319e:	39 c6                	cmp    %eax,%esi
  8031a0:	74 1b                	je     8031bd <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  8031a2:	83 fa 01             	cmp    $0x1,%edx
  8031a5:	75 c6                	jne    80316d <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8031a7:	6a 01                	push   $0x1
  8031a9:	8b 41 58             	mov    0x58(%ecx),%eax
  8031ac:	50                   	push   %eax
  8031ad:	56                   	push   %esi
  8031ae:	68 43 41 80 00       	push   $0x804143
  8031b3:	e8 ac d9 ff ff       	call   800b64 <cprintf>
  8031b8:	83 c4 10             	add    $0x10,%esp
  8031bb:	eb b0                	jmp    80316d <_pipeisclosed+0xc>
	}
}
  8031bd:	89 d0                	mov    %edx,%eax
  8031bf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8031c2:	5b                   	pop    %ebx
  8031c3:	5e                   	pop    %esi
  8031c4:	5f                   	pop    %edi
  8031c5:	c9                   	leave  
  8031c6:	c3                   	ret    

008031c7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031c7:	55                   	push   %ebp
  8031c8:	89 e5                	mov    %esp,%ebp
  8031ca:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031cd:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8031d0:	50                   	push   %eax
  8031d1:	ff 75 08             	pushl  0x8(%ebp)
  8031d4:	e8 b5 eb ff ff       	call   801d8e <fd_lookup>
  8031d9:	83 c4 10             	add    $0x10,%esp
		return r;
  8031dc:	89 c2                	mov    %eax,%edx
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	78 19                	js     8031fb <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8031e2:	83 ec 0c             	sub    $0xc,%esp
  8031e5:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8031e8:	e8 1f eb ff ff       	call   801d0c <fd2data>
	return _pipeisclosed(fd, p);
  8031ed:	83 c4 08             	add    $0x8,%esp
  8031f0:	50                   	push   %eax
  8031f1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8031f4:	e8 68 ff ff ff       	call   803161 <_pipeisclosed>
  8031f9:	89 c2                	mov    %eax,%edx
}
  8031fb:	89 d0                	mov    %edx,%eax
  8031fd:	c9                   	leave  
  8031fe:	c3                   	ret    

008031ff <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8031ff:	55                   	push   %ebp
  803200:	89 e5                	mov    %esp,%ebp
  803202:	57                   	push   %edi
  803203:	56                   	push   %esi
  803204:	53                   	push   %ebx
  803205:	83 ec 18             	sub    $0x18,%esp
  803208:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  80320b:	57                   	push   %edi
  80320c:	e8 fb ea ff ff       	call   801d0c <fd2data>
  803211:	89 c3                	mov    %eax,%ebx
	if (debug)
  803213:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803216:	8b 45 0c             	mov    0xc(%ebp),%eax
  803219:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80321c:	be 00 00 00 00       	mov    $0x0,%esi
  803221:	3b 75 10             	cmp    0x10(%ebp),%esi
  803224:	73 55                	jae    80327b <piperead+0x7c>
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
  803226:	8b 03                	mov    (%ebx),%eax
  803228:	3b 43 04             	cmp    0x4(%ebx),%eax
  80322b:	75 2c                	jne    803259 <piperead+0x5a>
  80322d:	85 f6                	test   %esi,%esi
  80322f:	74 04                	je     803235 <piperead+0x36>
  803231:	89 f0                	mov    %esi,%eax
  803233:	eb 48                	jmp    80327d <piperead+0x7e>
  803235:	83 ec 08             	sub    $0x8,%esp
  803238:	53                   	push   %ebx
  803239:	57                   	push   %edi
  80323a:	e8 22 ff ff ff       	call   803161 <_pipeisclosed>
  80323f:	83 c4 10             	add    $0x10,%esp
  803242:	85 c0                	test   %eax,%eax
  803244:	74 07                	je     80324d <piperead+0x4e>
  803246:	b8 00 00 00 00       	mov    $0x0,%eax
  80324b:	eb 30                	jmp    80327d <piperead+0x7e>
  80324d:	e8 a1 e3 ff ff       	call   8015f3 <sys_yield>
  803252:	8b 03                	mov    (%ebx),%eax
  803254:	3b 43 04             	cmp    0x4(%ebx),%eax
  803257:	74 d4                	je     80322d <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803259:	8b 13                	mov    (%ebx),%edx
  80325b:	89 d0                	mov    %edx,%eax
  80325d:	85 d2                	test   %edx,%edx
  80325f:	79 03                	jns    803264 <piperead+0x65>
  803261:	8d 42 1f             	lea    0x1f(%edx),%eax
  803264:	83 e0 e0             	and    $0xffffffe0,%eax
  803267:	29 c2                	sub    %eax,%edx
  803269:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  80326d:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  803270:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803273:	ff 03                	incl   (%ebx)
  803275:	46                   	inc    %esi
  803276:	3b 75 10             	cmp    0x10(%ebp),%esi
  803279:	72 ab                	jb     803226 <piperead+0x27>
	}
	return i;
  80327b:	89 f0                	mov    %esi,%eax
}
  80327d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  803280:	5b                   	pop    %ebx
  803281:	5e                   	pop    %esi
  803282:	5f                   	pop    %edi
  803283:	c9                   	leave  
  803284:	c3                   	ret    

00803285 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
  803288:	57                   	push   %edi
  803289:	56                   	push   %esi
  80328a:	53                   	push   %ebx
  80328b:	83 ec 18             	sub    $0x18,%esp
  80328e:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  803291:	57                   	push   %edi
  803292:	e8 75 ea ff ff       	call   801d0c <fd2data>
  803297:	89 c3                	mov    %eax,%ebx
	if (debug)
  803299:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80329c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8032a2:	be 00 00 00 00       	mov    $0x0,%esi
  8032a7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8032aa:	73 55                	jae    803301 <pipewrite+0x7c>
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
  8032ac:	8b 03                	mov    (%ebx),%eax
  8032ae:	83 c0 20             	add    $0x20,%eax
  8032b1:	39 43 04             	cmp    %eax,0x4(%ebx)
  8032b4:	72 27                	jb     8032dd <pipewrite+0x58>
  8032b6:	83 ec 08             	sub    $0x8,%esp
  8032b9:	53                   	push   %ebx
  8032ba:	57                   	push   %edi
  8032bb:	e8 a1 fe ff ff       	call   803161 <_pipeisclosed>
  8032c0:	83 c4 10             	add    $0x10,%esp
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 07                	je     8032ce <pipewrite+0x49>
  8032c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cc:	eb 35                	jmp    803303 <pipewrite+0x7e>
  8032ce:	e8 20 e3 ff ff       	call   8015f3 <sys_yield>
  8032d3:	8b 03                	mov    (%ebx),%eax
  8032d5:	83 c0 20             	add    $0x20,%eax
  8032d8:	39 43 04             	cmp    %eax,0x4(%ebx)
  8032db:	73 d9                	jae    8032b6 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8032dd:	8b 53 04             	mov    0x4(%ebx),%edx
  8032e0:	89 d0                	mov    %edx,%eax
  8032e2:	85 d2                	test   %edx,%edx
  8032e4:	79 03                	jns    8032e9 <pipewrite+0x64>
  8032e6:	8d 42 1f             	lea    0x1f(%edx),%eax
  8032e9:	83 e0 e0             	and    $0xffffffe0,%eax
  8032ec:	29 c2                	sub    %eax,%edx
  8032ee:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8032f1:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8032f4:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8032f8:	ff 43 04             	incl   0x4(%ebx)
  8032fb:	46                   	inc    %esi
  8032fc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8032ff:	72 ab                	jb     8032ac <pipewrite+0x27>
	}
	
	return i;
  803301:	89 f0                	mov    %esi,%eax
}
  803303:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  803306:	5b                   	pop    %ebx
  803307:	5e                   	pop    %esi
  803308:	5f                   	pop    %edi
  803309:	c9                   	leave  
  80330a:	c3                   	ret    

0080330b <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  80330b:	55                   	push   %ebp
  80330c:	89 e5                	mov    %esp,%ebp
  80330e:	56                   	push   %esi
  80330f:	53                   	push   %ebx
  803310:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803313:	83 ec 0c             	sub    $0xc,%esp
  803316:	ff 75 08             	pushl  0x8(%ebp)
  803319:	e8 ee e9 ff ff       	call   801d0c <fd2data>
  80331e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803320:	83 c4 08             	add    $0x8,%esp
  803323:	68 56 41 80 00       	push   $0x804156
  803328:	53                   	push   %ebx
  803329:	e8 12 df ff ff       	call   801240 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80332e:	8b 46 04             	mov    0x4(%esi),%eax
  803331:	2b 06                	sub    (%esi),%eax
  803333:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803339:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803340:	00 00 00 
	stat->st_dev = &devpipe;
  803343:	c7 83 88 00 00 00 60 	movl   $0x808060,0x88(%ebx)
  80334a:	80 80 00 
	return 0;
}
  80334d:	b8 00 00 00 00       	mov    $0x0,%eax
  803352:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  803355:	5b                   	pop    %ebx
  803356:	5e                   	pop    %esi
  803357:	c9                   	leave  
  803358:	c3                   	ret    

00803359 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  803359:	55                   	push   %ebp
  80335a:	89 e5                	mov    %esp,%ebp
  80335c:	53                   	push   %ebx
  80335d:	83 ec 0c             	sub    $0xc,%esp
  803360:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803363:	53                   	push   %ebx
  803364:	6a 00                	push   $0x0
  803366:	e8 2c e3 ff ff       	call   801697 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80336b:	89 1c 24             	mov    %ebx,(%esp)
  80336e:	e8 99 e9 ff ff       	call   801d0c <fd2data>
  803373:	83 c4 08             	add    $0x8,%esp
  803376:	50                   	push   %eax
  803377:	6a 00                	push   $0x0
  803379:	e8 19 e3 ff ff       	call   801697 <sys_page_unmap>
}
  80337e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  803381:	c9                   	leave  
  803382:	c3                   	ret    
	...

00803384 <wait>:

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803384:	55                   	push   %ebp
  803385:	89 e5                	mov    %esp,%ebp
  803387:	56                   	push   %esi
  803388:	53                   	push   %ebx
  803389:	8b 75 08             	mov    0x8(%ebp),%esi
	volatile struct Env *e;

	assert(envid != 0);
  80338c:	85 f6                	test   %esi,%esi
  80338e:	75 16                	jne    8033a6 <wait+0x22>
  803390:	68 5d 41 80 00       	push   $0x80415d
  803395:	68 af 39 80 00       	push   $0x8039af
  80339a:	6a 09                	push   $0x9
  80339c:	68 68 41 80 00       	push   $0x804168
  8033a1:	e8 ce d6 ff ff       	call   800a74 <_panic>
	e = &envs[ENVX(envid)];
  8033a6:	89 f3                	mov    %esi,%ebx
  8033a8:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8033ae:	89 d8                	mov    %ebx,%eax
  8033b0:	c1 e0 07             	shl    $0x7,%eax
  8033b3:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
		sys_yield();
  8033b9:	8b 43 4c             	mov    0x4c(%ebx),%eax
  8033bc:	39 f0                	cmp    %esi,%eax
  8033be:	75 1a                	jne    8033da <wait+0x56>
  8033c0:	8b 43 54             	mov    0x54(%ebx),%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	74 13                	je     8033da <wait+0x56>
  8033c7:	e8 27 e2 ff ff       	call   8015f3 <sys_yield>
  8033cc:	8b 43 4c             	mov    0x4c(%ebx),%eax
  8033cf:	39 f0                	cmp    %esi,%eax
  8033d1:	75 07                	jne    8033da <wait+0x56>
  8033d3:	8b 43 54             	mov    0x54(%ebx),%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	75 ed                	jne    8033c7 <wait+0x43>
}
  8033da:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8033dd:	5b                   	pop    %ebx
  8033de:	5e                   	pop    %esi
  8033df:	c9                   	leave  
  8033e0:	c3                   	ret    
  8033e1:	00 00                	add    %al,(%eax)
	...

008033e4 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8033e4:	55                   	push   %ebp
  8033e5:	89 e5                	mov    %esp,%ebp
  8033e7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8033ea:	83 3d a8 84 80 00 00 	cmpl   $0x0,0x8084a8
  8033f1:	75 68                	jne    80345b <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  8033f3:	83 ec 04             	sub    $0x4,%esp
  8033f6:	6a 07                	push   $0x7
  8033f8:	68 00 f0 bf ee       	push   $0xeebff000
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	e8 cf e1 ff ff       	call   8015d4 <sys_getenvid>
  803405:	89 04 24             	mov    %eax,(%esp)
  803408:	e8 05 e2 ff ff       	call   801612 <sys_page_alloc>
  80340d:	83 c4 10             	add    $0x10,%esp
  803410:	85 c0                	test   %eax,%eax
  803412:	79 14                	jns    803428 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	68 74 41 80 00       	push   $0x804174
  80341c:	6a 21                	push   $0x21
  80341e:	68 d5 41 80 00       	push   $0x8041d5
  803423:	e8 4c d6 ff ff       	call   800a74 <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  803428:	83 ec 08             	sub    $0x8,%esp
  80342b:	68 68 34 80 00       	push   $0x803468
  803430:	83 ec 04             	sub    $0x4,%esp
  803433:	e8 9c e1 ff ff       	call   8015d4 <sys_getenvid>
  803438:	89 04 24             	mov    %eax,(%esp)
  80343b:	e8 1d e3 ff ff       	call   80175d <sys_env_set_pgfault_upcall>
  803440:	83 c4 10             	add    $0x10,%esp
  803443:	85 c0                	test   %eax,%eax
  803445:	79 14                	jns    80345b <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  803447:	83 ec 04             	sub    $0x4,%esp
  80344a:	68 a4 41 80 00       	push   $0x8041a4
  80344f:	6a 24                	push   $0x24
  803451:	68 d5 41 80 00       	push   $0x8041d5
  803456:	e8 19 d6 ff ff       	call   800a74 <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	a3 a8 84 80 00       	mov    %eax,0x8084a8
}
  803463:	c9                   	leave  
  803464:	c3                   	ret    
  803465:	00 00                	add    %al,(%eax)
	...

00803468 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803468:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803469:	a1 a8 84 80 00       	mov    0x8084a8,%eax
	call *%eax
  80346e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803470:	83 c4 04             	add    $0x4,%esp
	
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
  803473:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  803477:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  80347b:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  80347e:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  803481:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  803484:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  803488:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  80348b:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  80348f:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  803490:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  803493:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  803494:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  803495:	c3                   	ret    
	...

00803498 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
  80349b:	56                   	push   %esi
  80349c:	53                   	push   %ebx
  80349d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8034a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a3:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  8034a6:	85 c0                	test   %eax,%eax
  8034a8:	75 12                	jne    8034bc <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8034aa:	83 ec 0c             	sub    $0xc,%esp
  8034ad:	68 00 00 c0 ee       	push   $0xeec00000
  8034b2:	e8 0b e3 ff ff       	call   8017c2 <sys_ipc_recv>
  8034b7:	83 c4 10             	add    $0x10,%esp
  8034ba:	eb 0c                	jmp    8034c8 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8034bc:	83 ec 0c             	sub    $0xc,%esp
  8034bf:	50                   	push   %eax
  8034c0:	e8 fd e2 ff ff       	call   8017c2 <sys_ipc_recv>
  8034c5:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8034c8:	89 c2                	mov    %eax,%edx
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	78 24                	js     8034f2 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8034ce:	85 db                	test   %ebx,%ebx
  8034d0:	74 0a                	je     8034dc <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8034d2:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8034d7:	8b 40 74             	mov    0x74(%eax),%eax
  8034da:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8034dc:	85 f6                	test   %esi,%esi
  8034de:	74 0a                	je     8034ea <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8034e0:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8034e5:	8b 40 78             	mov    0x78(%eax),%eax
  8034e8:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  8034ea:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8034ef:	8b 50 70             	mov    0x70(%eax),%edx

}
  8034f2:	89 d0                	mov    %edx,%eax
  8034f4:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8034f7:	5b                   	pop    %ebx
  8034f8:	5e                   	pop    %esi
  8034f9:	c9                   	leave  
  8034fa:	c3                   	ret    

008034fb <ipc_send>:

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
  8034fb:	55                   	push   %ebp
  8034fc:	89 e5                	mov    %esp,%ebp
  8034fe:	57                   	push   %edi
  8034ff:	56                   	push   %esi
  803500:	53                   	push   %ebx
  803501:	83 ec 0c             	sub    $0xc,%esp
  803504:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803507:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80350a:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  80350d:	85 db                	test   %ebx,%ebx
  80350f:	75 0a                	jne    80351b <ipc_send+0x20>
    pg = (void *) UTOP;
  803511:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  803516:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80351b:	56                   	push   %esi
  80351c:	53                   	push   %ebx
  80351d:	57                   	push   %edi
  80351e:	ff 75 08             	pushl  0x8(%ebp)
  803521:	e8 79 e2 ff ff       	call   80179f <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  803526:	83 c4 10             	add    $0x10,%esp
  803529:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80352c:	75 07                	jne    803535 <ipc_send+0x3a>
      sys_yield();
  80352e:	e8 c0 e0 ff ff       	call   8015f3 <sys_yield>
  803533:	eb e6                	jmp    80351b <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  803535:	85 c0                	test   %eax,%eax
  803537:	79 12                	jns    80354b <ipc_send+0x50>
  803539:	50                   	push   %eax
  80353a:	68 e3 41 80 00       	push   $0x8041e3
  80353f:	6a 49                	push   $0x49
  803541:	68 00 42 80 00       	push   $0x804200
  803546:	e8 29 d5 ff ff       	call   800a74 <_panic>
    else break;
  }
}
  80354b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80354e:	5b                   	pop    %ebx
  80354f:	5e                   	pop    %esi
  803550:	5f                   	pop    %edi
  803551:	c9                   	leave  
  803552:	c3                   	ret    
	...

00803554 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803554:	55                   	push   %ebp
  803555:	89 e5                	mov    %esp,%ebp
  803557:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80355a:	89 c8                	mov    %ecx,%eax
  80355c:	c1 e8 16             	shr    $0x16,%eax
  80355f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  803566:	ba 00 00 00 00       	mov    $0x0,%edx
  80356b:	a8 01                	test   $0x1,%al
  80356d:	74 28                	je     803597 <pageref+0x43>
	pte = vpt[VPN(v)];
  80356f:	89 c8                	mov    %ecx,%eax
  803571:	c1 e8 0c             	shr    $0xc,%eax
  803574:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80357b:	ba 00 00 00 00       	mov    $0x0,%edx
  803580:	a8 01                	test   $0x1,%al
  803582:	74 13                	je     803597 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  803584:	c1 e8 0c             	shr    $0xc,%eax
  803587:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80358a:	c1 e0 02             	shl    $0x2,%eax
  80358d:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  803594:	0f b7 d0             	movzwl %ax,%edx
}
  803597:	89 d0                	mov    %edx,%eax
  803599:	c9                   	leave  
  80359a:	c3                   	ret    
	...

0080359c <__udivdi3>:
  80359c:	55                   	push   %ebp
  80359d:	89 e5                	mov    %esp,%ebp
  80359f:	57                   	push   %edi
  8035a0:	56                   	push   %esi
  8035a1:	83 ec 14             	sub    $0x14,%esp
  8035a4:	8b 55 14             	mov    0x14(%ebp),%edx
  8035a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8035aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8035ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8035b0:	85 d2                	test   %edx,%edx
  8035b2:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8035b5:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8035b8:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8035bb:	89 fe                	mov    %edi,%esi
  8035bd:	75 11                	jne    8035d0 <__udivdi3+0x34>
  8035bf:	39 f8                	cmp    %edi,%eax
  8035c1:	76 4d                	jbe    803610 <__udivdi3+0x74>
  8035c3:	89 fa                	mov    %edi,%edx
  8035c5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8035c8:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8035cb:	89 c7                	mov    %eax,%edi
  8035cd:	eb 09                	jmp    8035d8 <__udivdi3+0x3c>
  8035cf:	90                   	nop    
  8035d0:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  8035d3:	76 17                	jbe    8035ec <__udivdi3+0x50>
  8035d5:	31 ff                	xor    %edi,%edi
  8035d7:	90                   	nop    
  8035d8:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  8035df:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8035e2:	83 c4 14             	add    $0x14,%esp
  8035e5:	5e                   	pop    %esi
  8035e6:	89 f8                	mov    %edi,%eax
  8035e8:	5f                   	pop    %edi
  8035e9:	c9                   	leave  
  8035ea:	c3                   	ret    
  8035eb:	90                   	nop    
  8035ec:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  8035f0:	89 c7                	mov    %eax,%edi
  8035f2:	83 f7 1f             	xor    $0x1f,%edi
  8035f5:	75 4d                	jne    803644 <__udivdi3+0xa8>
  8035f7:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8035fa:	77 0a                	ja     803606 <__udivdi3+0x6a>
  8035fc:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8035ff:	31 ff                	xor    %edi,%edi
  803601:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  803604:	72 d2                	jb     8035d8 <__udivdi3+0x3c>
  803606:	bf 01 00 00 00       	mov    $0x1,%edi
  80360b:	eb cb                	jmp    8035d8 <__udivdi3+0x3c>
  80360d:	8d 76 00             	lea    0x0(%esi),%esi
  803610:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	75 0e                	jne    803625 <__udivdi3+0x89>
  803617:	b8 01 00 00 00       	mov    $0x1,%eax
  80361c:	31 c9                	xor    %ecx,%ecx
  80361e:	31 d2                	xor    %edx,%edx
  803620:	f7 f1                	div    %ecx
  803622:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  803625:	89 f0                	mov    %esi,%eax
  803627:	31 d2                	xor    %edx,%edx
  803629:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80362c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80362f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803632:	f7 75 e4             	divl   0xffffffe4(%ebp)
  803635:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  803638:	83 c4 14             	add    $0x14,%esp
  80363b:	89 c7                	mov    %eax,%edi
  80363d:	5e                   	pop    %esi
  80363e:	89 f8                	mov    %edi,%eax
  803640:	5f                   	pop    %edi
  803641:	c9                   	leave  
  803642:	c3                   	ret    
  803643:	90                   	nop    
  803644:	b8 20 00 00 00       	mov    $0x20,%eax
  803649:	29 f8                	sub    %edi,%eax
  80364b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80364e:	89 f9                	mov    %edi,%ecx
  803650:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  803653:	d3 e2                	shl    %cl,%edx
  803655:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  803658:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80365b:	d3 e8                	shr    %cl,%eax
  80365d:	09 c2                	or     %eax,%edx
  80365f:	89 f9                	mov    %edi,%ecx
  803661:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  803664:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  803667:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80366a:	89 f2                	mov    %esi,%edx
  80366c:	d3 ea                	shr    %cl,%edx
  80366e:	89 f9                	mov    %edi,%ecx
  803670:	d3 e6                	shl    %cl,%esi
  803672:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803675:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  803678:	d3 e8                	shr    %cl,%eax
  80367a:	09 c6                	or     %eax,%esi
  80367c:	89 f9                	mov    %edi,%ecx
  80367e:	89 f0                	mov    %esi,%eax
  803680:	f7 75 f4             	divl   0xfffffff4(%ebp)
  803683:	89 d6                	mov    %edx,%esi
  803685:	89 c7                	mov    %eax,%edi
  803687:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  80368a:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80368d:	f7 e7                	mul    %edi
  80368f:	39 f2                	cmp    %esi,%edx
  803691:	77 0f                	ja     8036a2 <__udivdi3+0x106>
  803693:	0f 85 3f ff ff ff    	jne    8035d8 <__udivdi3+0x3c>
  803699:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  80369c:	0f 86 36 ff ff ff    	jbe    8035d8 <__udivdi3+0x3c>
  8036a2:	4f                   	dec    %edi
  8036a3:	e9 30 ff ff ff       	jmp    8035d8 <__udivdi3+0x3c>

008036a8 <__umoddi3>:
  8036a8:	55                   	push   %ebp
  8036a9:	89 e5                	mov    %esp,%ebp
  8036ab:	57                   	push   %edi
  8036ac:	56                   	push   %esi
  8036ad:	83 ec 30             	sub    $0x30,%esp
  8036b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8036b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8036b6:	89 d7                	mov    %edx,%edi
  8036b8:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8036bb:	89 c6                	mov    %eax,%esi
  8036bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	85 ff                	test   %edi,%edi
  8036c5:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  8036cc:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8036d3:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  8036d6:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8036d9:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8036dc:	75 3e                	jne    80371c <__umoddi3+0x74>
  8036de:	39 d6                	cmp    %edx,%esi
  8036e0:	0f 86 a2 00 00 00    	jbe    803788 <__umoddi3+0xe0>
  8036e6:	f7 f6                	div    %esi
  8036e8:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8036eb:	85 c9                	test   %ecx,%ecx
  8036ed:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  8036f0:	74 1b                	je     80370d <__umoddi3+0x65>
  8036f2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8036f5:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8036f8:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8036ff:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  803702:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  803705:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  803708:	89 10                	mov    %edx,(%eax)
  80370a:	89 48 04             	mov    %ecx,0x4(%eax)
  80370d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803710:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  803713:	83 c4 30             	add    $0x30,%esp
  803716:	5e                   	pop    %esi
  803717:	5f                   	pop    %edi
  803718:	c9                   	leave  
  803719:	c3                   	ret    
  80371a:	89 f6                	mov    %esi,%esi
  80371c:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80371f:	76 1f                	jbe    803740 <__umoddi3+0x98>
  803721:	8b 55 08             	mov    0x8(%ebp),%edx
  803724:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  803727:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80372a:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  80372d:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  803730:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  803733:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  803736:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  803739:	83 c4 30             	add    $0x30,%esp
  80373c:	5e                   	pop    %esi
  80373d:	5f                   	pop    %edi
  80373e:	c9                   	leave  
  80373f:	c3                   	ret    
  803740:	0f bd c7             	bsr    %edi,%eax
  803743:	83 f0 1f             	xor    $0x1f,%eax
  803746:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  803749:	75 61                	jne    8037ac <__umoddi3+0x104>
  80374b:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80374e:	77 05                	ja     803755 <__umoddi3+0xad>
  803750:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  803753:	72 10                	jb     803765 <__umoddi3+0xbd>
  803755:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803758:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80375b:	29 f0                	sub    %esi,%eax
  80375d:	19 fa                	sbb    %edi,%edx
  80375f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  803762:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  803765:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  803768:	85 d2                	test   %edx,%edx
  80376a:	74 a1                	je     80370d <__umoddi3+0x65>
  80376c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80376f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803772:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  803775:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  803778:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80377b:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80377e:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  803781:	89 01                	mov    %eax,(%ecx)
  803783:	89 51 04             	mov    %edx,0x4(%ecx)
  803786:	eb 85                	jmp    80370d <__umoddi3+0x65>
  803788:	85 f6                	test   %esi,%esi
  80378a:	75 0b                	jne    803797 <__umoddi3+0xef>
  80378c:	b8 01 00 00 00       	mov    $0x1,%eax
  803791:	31 d2                	xor    %edx,%edx
  803793:	f7 f6                	div    %esi
  803795:	89 c6                	mov    %eax,%esi
  803797:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80379a:	89 fa                	mov    %edi,%edx
  80379c:	f7 f6                	div    %esi
  80379e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8037a1:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8037a4:	f7 f6                	div    %esi
  8037a6:	e9 3d ff ff ff       	jmp    8036e8 <__umoddi3+0x40>
  8037ab:	90                   	nop    
  8037ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8037b1:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  8037b4:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  8037b7:	89 fa                	mov    %edi,%edx
  8037b9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8037bc:	d3 e2                	shl    %cl,%edx
  8037be:	89 f0                	mov    %esi,%eax
  8037c0:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8037c3:	d3 e8                	shr    %cl,%eax
  8037c5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8037c8:	d3 e6                	shl    %cl,%esi
  8037ca:	89 d7                	mov    %edx,%edi
  8037cc:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8037cf:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8037d2:	09 c7                	or     %eax,%edi
  8037d4:	d3 ea                	shr    %cl,%edx
  8037d6:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8037d9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8037dc:	d3 e0                	shl    %cl,%eax
  8037de:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8037e1:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8037e4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8037e7:	d3 e8                	shr    %cl,%eax
  8037e9:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  8037ec:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8037ef:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8037f2:	f7 f7                	div    %edi
  8037f4:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8037f7:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  8037fa:	f7 e6                	mul    %esi
  8037fc:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  8037ff:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  803802:	77 0a                	ja     80380e <__umoddi3+0x166>
  803804:	75 12                	jne    803818 <__umoddi3+0x170>
  803806:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803809:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  80380c:	76 0a                	jbe    803818 <__umoddi3+0x170>
  80380e:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  803811:	29 f1                	sub    %esi,%ecx
  803813:	19 fa                	sbb    %edi,%edx
  803815:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  803818:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80381b:	85 c0                	test   %eax,%eax
  80381d:	0f 84 ea fe ff ff    	je     80370d <__umoddi3+0x65>
  803823:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  803826:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803829:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  80382c:	19 d1                	sbb    %edx,%ecx
  80382e:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  803831:	89 ca                	mov    %ecx,%edx
  803833:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  803836:	d3 e2                	shl    %cl,%edx
  803838:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80383b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80383e:	d3 e8                	shr    %cl,%eax
  803840:	09 c2                	or     %eax,%edx
  803842:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  803845:	d3 e8                	shr    %cl,%eax
  803847:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80384a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80384d:	e9 ad fe ff ff       	jmp    8036ff <__umoddi3+0x57>
