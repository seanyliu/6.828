
obj/user/ls:     file format elf32-i386

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
  80002c:	e8 f3 02 00 00       	call   800324 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <ls>:
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  800041:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  800047:	50                   	push   %eax
  800048:	53                   	push   %ebx
  800049:	e8 c8 16 00 00       	call   801716 <stat>
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	85 c0                	test   %eax,%eax
  800053:	79 16                	jns    80006b <ls+0x37>
		panic("stat %s: %e", path, r);
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	50                   	push   %eax
  800059:	53                   	push   %ebx
  80005a:	68 c0 27 80 00       	push   $0x8027c0
  80005f:	6a 0f                	push   $0xf
  800061:	68 cc 27 80 00       	push   $0x8027cc
  800066:	e8 15 03 00 00       	call   800380 <_panic>
	if (st.st_isdir && !flag['d'])
  80006b:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  80006f:	74 1a                	je     80008b <ls+0x57>
  800071:	83 3d 10 62 80 00 00 	cmpl   $0x0,0x806210
  800078:	75 11                	jne    80008b <ls+0x57>
		lsdir(path, prefix);
  80007a:	83 ec 08             	sub    $0x8,%esp
  80007d:	ff 75 0c             	pushl  0xc(%ebp)
  800080:	53                   	push   %ebx
  800081:	e8 1b 00 00 00       	call   8000a1 <lsdir>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	eb 11                	jmp    80009c <ls+0x68>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  80008b:	53                   	push   %ebx
  80008c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80008f:	ff 75 ec             	pushl  0xffffffec(%ebp)
  800092:	6a 00                	push   $0x0
  800094:	e8 c4 00 00 00       	call   80015d <ls1>
  800099:	83 c4 10             	add    $0x10,%esp
}
  80009c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80009f:	c9                   	leave  
  8000a0:	c3                   	ret    

008000a1 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	57                   	push   %edi
  8000a5:	56                   	push   %esi
  8000a6:	53                   	push   %ebx
  8000a7:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  8000b0:	6a 00                	push   $0x0
  8000b2:	ff 75 08             	pushl  0x8(%ebp)
  8000b5:	e8 96 16 00 00       	call   801750 <open>
  8000ba:	89 c3                	mov    %eax,%ebx
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d b5 e8 fe ff ff    	lea    0xfffffee8(%ebp),%esi
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	79 3f                	jns    800108 <lsdir+0x67>
		panic("open %s: %e", path, fd);
  8000c9:	83 ec 0c             	sub    $0xc,%esp
  8000cc:	50                   	push   %eax
  8000cd:	ff 75 08             	pushl  0x8(%ebp)
  8000d0:	68 d6 27 80 00       	push   $0x8027d6
  8000d5:	6a 1d                	push   $0x1d
  8000d7:	68 cc 27 80 00       	push   $0x8027cc
  8000dc:	e8 9f 02 00 00       	call   800380 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  8000e1:	80 bd e8 fe ff ff 00 	cmpb   $0x0,0xfffffee8(%ebp)
  8000e8:	74 1e                	je     800108 <lsdir+0x67>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8000ea:	56                   	push   %esi
  8000eb:	ff b5 68 ff ff ff    	pushl  0xffffff68(%ebp)
  8000f1:	83 bd 6c ff ff ff 01 	cmpl   $0x1,0xffffff6c(%ebp)
  8000f8:	0f 94 c0             	sete   %al
  8000fb:	0f b6 c0             	movzbl %al,%eax
  8000fe:	50                   	push   %eax
  8000ff:	57                   	push   %edi
  800100:	e8 58 00 00 00       	call   80015d <ls1>
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	68 00 01 00 00       	push   $0x100
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
  800112:	e8 2e 14 00 00       	call   801545 <readn>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80011f:	74 c0                	je     8000e1 <lsdir+0x40>
	if (n > 0)
  800121:	85 c0                	test   %eax,%eax
  800123:	7e 14                	jle    800139 <lsdir+0x98>
		panic("short read in directory %s", path);
  800125:	ff 75 08             	pushl  0x8(%ebp)
  800128:	68 e2 27 80 00       	push   $0x8027e2
  80012d:	6a 22                	push   $0x22
  80012f:	68 cc 27 80 00       	push   $0x8027cc
  800134:	e8 47 02 00 00       	call   800380 <_panic>
	if (n < 0)
  800139:	85 c0                	test   %eax,%eax
  80013b:	79 18                	jns    800155 <lsdir+0xb4>
		panic("error reading directory %s: %e", path, n);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	50                   	push   %eax
  800141:	ff 75 08             	pushl  0x8(%ebp)
  800144:	68 2c 28 80 00       	push   $0x80282c
  800149:	6a 24                	push   $0x24
  80014b:	68 cc 27 80 00       	push   $0x8027cc
  800150:	e8 2b 02 00 00       	call   800380 <_panic>
}
  800155:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800158:	5b                   	pop    %ebx
  800159:	5e                   	pop    %esi
  80015a:	5f                   	pop    %edi
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    

0080015d <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800165:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *sep;

	if(flag['l'])
  800168:	83 3d 30 62 80 00 00 	cmpl   $0x0,0x806230
  80016f:	74 1e                	je     80018f <ls1+0x32>
		fprintf(1, "%11d %c ", size, isdir ? 'd' : '-');
  800171:	83 fe 01             	cmp    $0x1,%esi
  800174:	19 c0                	sbb    %eax,%eax
  800176:	83 e0 c9             	and    $0xffffffc9,%eax
  800179:	83 c0 64             	add    $0x64,%eax
  80017c:	50                   	push   %eax
  80017d:	ff 75 10             	pushl  0x10(%ebp)
  800180:	68 fd 27 80 00       	push   $0x8027fd
  800185:	6a 01                	push   $0x1
  800187:	e8 c9 1b 00 00       	call   801d55 <fprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  80018f:	85 db                	test   %ebx,%ebx
  800191:	74 33                	je     8001c6 <ls1+0x69>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800193:	80 3b 00             	cmpb   $0x0,(%ebx)
  800196:	74 18                	je     8001b0 <ls1+0x53>
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	53                   	push   %ebx
  80019c:	e8 97 08 00 00       	call   800a38 <strlen>
  8001a1:	83 c4 10             	add    $0x10,%esp
			sep = "/";
  8001a4:	ba 06 28 80 00       	mov    $0x802806,%edx
  8001a9:	80 7c 18 ff 2f       	cmpb   $0x2f,0xffffffff(%eax,%ebx,1)
  8001ae:	75 05                	jne    8001b5 <ls1+0x58>
		else
			sep = "";
  8001b0:	ba 28 28 80 00       	mov    $0x802828,%edx
		fprintf(1, "%s%s", prefix, sep);
  8001b5:	52                   	push   %edx
  8001b6:	53                   	push   %ebx
  8001b7:	68 08 28 80 00       	push   $0x802808
  8001bc:	6a 01                	push   $0x1
  8001be:	e8 92 1b 00 00       	call   801d55 <fprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	}
	fprintf(1, "%s", name);
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	ff 75 14             	pushl  0x14(%ebp)
  8001cc:	68 01 2d 80 00       	push   $0x802d01
  8001d1:	6a 01                	push   $0x1
  8001d3:	e8 7d 1b 00 00       	call   801d55 <fprintf>
	if(flag['F'] && isdir)
  8001d8:	83 c4 10             	add    $0x10,%esp
  8001db:	83 3d 98 61 80 00 00 	cmpl   $0x0,0x806198
  8001e2:	74 16                	je     8001fa <ls1+0x9d>
  8001e4:	85 f6                	test   %esi,%esi
  8001e6:	74 12                	je     8001fa <ls1+0x9d>
		fprintf(1, "/");
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	68 06 28 80 00       	push   $0x802806
  8001f0:	6a 01                	push   $0x1
  8001f2:	e8 5e 1b 00 00       	call   801d55 <fprintf>
  8001f7:	83 c4 10             	add    $0x10,%esp
	fprintf(1, "\n");
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	68 27 28 80 00       	push   $0x802827
  800202:	6a 01                	push   $0x1
  800204:	e8 4c 1b 00 00       	call   801d55 <fprintf>
}
  800209:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <usage>:

void
usage(void)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 10             	sub    $0x10,%esp
	fprintf(1, "usage: ls [-dFl] [file...]\n");
  800216:	68 0d 28 80 00       	push   $0x80280d
  80021b:	6a 01                	push   $0x1
  80021d:	e8 33 1b 00 00       	call   801d55 <fprintf>
	exit();
  800222:	e8 41 01 00 00       	call   800368 <exit>
}
  800227:	c9                   	leave  
  800228:	c3                   	ret    

00800229 <umain>:

void
umain(int argc, char **argv)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	57                   	push   %edi
  80022d:	56                   	push   %esi
  80022e:	53                   	push   %ebx
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i;

	ARGBEGIN{
  800235:	85 ff                	test   %edi,%edi
  800237:	75 03                	jne    80023c <umain+0x13>
  800239:	8d 7d 08             	lea    0x8(%ebp),%edi
  80023c:	83 3d 84 64 80 00 00 	cmpl   $0x0,0x806484
  800243:	75 07                	jne    80024c <umain+0x23>
  800245:	8b 07                	mov    (%edi),%eax
  800247:	a3 84 64 80 00       	mov    %eax,0x806484
  80024c:	83 c7 04             	add    $0x4,%edi
  80024f:	ff 4d 08             	decl   0x8(%ebp)
  800252:	83 3f 00             	cmpl   $0x0,(%edi)
  800255:	74 7e                	je     8002d5 <umain+0xac>
  800257:	8b 07                	mov    (%edi),%eax
  800259:	80 38 2d             	cmpb   $0x2d,(%eax)
  80025c:	75 77                	jne    8002d5 <umain+0xac>
  80025e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800262:	74 71                	je     8002d5 <umain+0xac>
  800264:	8b 07                	mov    (%edi),%eax
  800266:	8d 58 01             	lea    0x1(%eax),%ebx
  800269:	80 78 01 2d          	cmpb   $0x2d,0x1(%eax)
  80026d:	75 06                	jne    800275 <umain+0x4c>
  80026f:	80 7b 01 00          	cmpb   $0x0,0x1(%ebx)
  800273:	74 7d                	je     8002f2 <umain+0xc9>
	default:
		usage();
	case 'd':
	case 'F':
	case 'l':
		flag[(uint8_t)ARGC()]++;
		break;
  800275:	80 3b 00             	cmpb   $0x0,(%ebx)
  800278:	74 43                	je     8002bd <umain+0x94>
  80027a:	8a 03                	mov    (%ebx),%al
  80027c:	43                   	inc    %ebx
  80027d:	89 c6                	mov    %eax,%esi
  80027f:	84 c0                	test   %al,%al
  800281:	74 3a                	je     8002bd <umain+0x94>
  800283:	89 f2                	mov    %esi,%edx
  800285:	0f be c2             	movsbl %dl,%eax
  800288:	83 f8 64             	cmp    $0x64,%eax
  80028b:	74 16                	je     8002a3 <umain+0x7a>
  80028d:	83 f8 64             	cmp    $0x64,%eax
  800290:	7f 07                	jg     800299 <umain+0x70>
  800292:	83 f8 46             	cmp    $0x46,%eax
  800295:	74 0c                	je     8002a3 <umain+0x7a>
  800297:	eb 05                	jmp    80029e <umain+0x75>
  800299:	83 f8 6c             	cmp    $0x6c,%eax
  80029c:	74 05                	je     8002a3 <umain+0x7a>
  80029e:	e8 6d ff ff ff       	call   800210 <usage>
  8002a3:	89 f2                	mov    %esi,%edx
  8002a5:	0f b6 c2             	movzbl %dl,%eax
  8002a8:	ff 04 85 80 60 80 00 	incl   0x806080(,%eax,4)
  8002af:	80 3b 00             	cmpb   $0x0,(%ebx)
  8002b2:	74 09                	je     8002bd <umain+0x94>
  8002b4:	8a 03                	mov    (%ebx),%al
  8002b6:	43                   	inc    %ebx
  8002b7:	89 c6                	mov    %eax,%esi
  8002b9:	84 c0                	test   %al,%al
  8002bb:	75 c6                	jne    800283 <umain+0x5a>
  8002bd:	ff 4d 08             	decl   0x8(%ebp)
  8002c0:	83 c7 04             	add    $0x4,%edi
  8002c3:	83 3f 00             	cmpl   $0x0,(%edi)
  8002c6:	74 0d                	je     8002d5 <umain+0xac>
  8002c8:	8b 07                	mov    (%edi),%eax
  8002ca:	80 38 2d             	cmpb   $0x2d,(%eax)
  8002cd:	75 06                	jne    8002d5 <umain+0xac>
  8002cf:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8002d3:	75 8f                	jne    800264 <umain+0x3b>
	}ARGEND

	if (argc == 0)
  8002d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002d9:	75 1f                	jne    8002fa <umain+0xd1>
		ls("/", "");
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	68 28 28 80 00       	push   $0x802828
  8002e3:	68 06 28 80 00       	push   $0x802806
  8002e8:	e8 47 fd ff ff       	call   800034 <ls>
  8002ed:	83 c4 10             	add    $0x10,%esp
  8002f0:	eb 29                	jmp    80031b <umain+0xf2>
  8002f2:	ff 4d 08             	decl   0x8(%ebp)
  8002f5:	83 c7 04             	add    $0x4,%edi
  8002f8:	eb db                	jmp    8002d5 <umain+0xac>
	else {
		for (i=0; i<argc; i++)
  8002fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ff:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800302:	7d 17                	jge    80031b <umain+0xf2>
			ls(argv[i], argv[i]);
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80030a:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80030d:	e8 22 fd ff ff       	call   800034 <ls>
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	43                   	inc    %ebx
  800316:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800319:	7c e9                	jl     800304 <umain+0xdb>
	}
}
  80031b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80031e:	5b                   	pop    %ebx
  80031f:	5e                   	pop    %esi
  800320:	5f                   	pop    %edi
  800321:	c9                   	leave  
  800322:	c3                   	ret    
	...

00800324 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
  800329:	8b 75 08             	mov    0x8(%ebp),%esi
  80032c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  80032f:	e8 d4 0a 00 00       	call   800e08 <sys_getenvid>
  800334:	25 ff 03 00 00       	and    $0x3ff,%eax
  800339:	c1 e0 07             	shl    $0x7,%eax
  80033c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800341:	a3 80 64 80 00       	mov    %eax,0x806480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800346:	85 f6                	test   %esi,%esi
  800348:	7e 07                	jle    800351 <libmain+0x2d>
		binaryname = argv[0];
  80034a:	8b 03                	mov    (%ebx),%eax
  80034c:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	53                   	push   %ebx
  800355:	56                   	push   %esi
  800356:	e8 ce fe ff ff       	call   800229 <umain>

	// exit gracefully
	exit();
  80035b:	e8 08 00 00 00       	call   800368 <exit>
}
  800360:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800363:	5b                   	pop    %ebx
  800364:	5e                   	pop    %esi
  800365:	c9                   	leave  
  800366:	c3                   	ret    
	...

00800368 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80036e:	e8 fd 0f 00 00       	call   801370 <close_all>
	sys_env_destroy(0);
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	6a 00                	push   $0x0
  800378:	e8 4a 0a 00 00       	call   800dc7 <sys_env_destroy>
}
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    
	...

00800380 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	53                   	push   %ebx
  800384:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  800387:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  80038a:	83 3d 84 64 80 00 00 	cmpl   $0x0,0x806484
  800391:	74 16                	je     8003a9 <_panic+0x29>
		cprintf("%s: ", argv0);
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	ff 35 84 64 80 00    	pushl  0x806484
  80039c:	68 62 28 80 00       	push   $0x802862
  8003a1:	e8 ca 00 00 00       	call   800470 <cprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003a9:	ff 75 0c             	pushl  0xc(%ebp)
  8003ac:	ff 75 08             	pushl  0x8(%ebp)
  8003af:	ff 35 00 60 80 00    	pushl  0x806000
  8003b5:	68 67 28 80 00       	push   $0x802867
  8003ba:	e8 b1 00 00 00       	call   800470 <cprintf>
	vcprintf(fmt, ap);
  8003bf:	83 c4 08             	add    $0x8,%esp
  8003c2:	53                   	push   %ebx
  8003c3:	ff 75 10             	pushl  0x10(%ebp)
  8003c6:	e8 54 00 00 00       	call   80041f <vcprintf>
	cprintf("\n");
  8003cb:	c7 04 24 27 28 80 00 	movl   $0x802827,(%esp)
  8003d2:	e8 99 00 00 00       	call   800470 <cprintf>

	// Cause a breakpoint exception
	while (1)
  8003d7:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8003da:	cc                   	int3   
  8003db:	eb fd                	jmp    8003da <_panic+0x5a>
  8003dd:	00 00                	add    %al,(%eax)
	...

008003e0 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	53                   	push   %ebx
  8003e4:	83 ec 04             	sub    $0x4,%esp
  8003e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ea:	8b 03                	mov    (%ebx),%eax
  8003ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ef:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  8003f3:	40                   	inc    %eax
  8003f4:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8003f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003fb:	75 1a                	jne    800417 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	68 ff 00 00 00       	push   $0xff
  800405:	8d 43 08             	lea    0x8(%ebx),%eax
  800408:	50                   	push   %eax
  800409:	e8 76 09 00 00       	call   800d84 <sys_cputs>
		b->idx = 0;
  80040e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800414:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800417:	ff 43 04             	incl   0x4(%ebx)
}
  80041a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80041d:	c9                   	leave  
  80041e:	c3                   	ret    

0080041f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800428:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80042f:	00 00 00 
	b.cnt = 0;
  800432:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800439:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80043c:	ff 75 0c             	pushl  0xc(%ebp)
  80043f:	ff 75 08             	pushl  0x8(%ebp)
  800442:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800448:	50                   	push   %eax
  800449:	68 e0 03 80 00       	push   $0x8003e0
  80044e:	e8 4f 01 00 00       	call   8005a2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800453:	83 c4 08             	add    $0x8,%esp
  800456:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  80045c:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  800462:	50                   	push   %eax
  800463:	e8 1c 09 00 00       	call   800d84 <sys_cputs>

	return b.cnt;
  800468:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800476:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800479:	50                   	push   %eax
  80047a:	ff 75 08             	pushl  0x8(%ebp)
  80047d:	e8 9d ff ff ff       	call   80041f <vcprintf>
	va_end(ap);

	return cnt;
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	57                   	push   %edi
  800488:	56                   	push   %esi
  800489:	53                   	push   %ebx
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	8b 75 10             	mov    0x10(%ebp),%esi
  800490:	8b 7d 14             	mov    0x14(%ebp),%edi
  800493:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800496:	8b 45 18             	mov    0x18(%ebp),%eax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	39 fa                	cmp    %edi,%edx
  8004a0:	77 39                	ja     8004db <printnum+0x57>
  8004a2:	72 04                	jb     8004a8 <printnum+0x24>
  8004a4:	39 f0                	cmp    %esi,%eax
  8004a6:	77 33                	ja     8004db <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	ff 75 20             	pushl  0x20(%ebp)
  8004ae:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8004b1:	50                   	push   %eax
  8004b2:	ff 75 18             	pushl  0x18(%ebp)
  8004b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bd:	52                   	push   %edx
  8004be:	50                   	push   %eax
  8004bf:	57                   	push   %edi
  8004c0:	56                   	push   %esi
  8004c1:	e8 3e 20 00 00       	call   802504 <__udivdi3>
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	52                   	push   %edx
  8004ca:	50                   	push   %eax
  8004cb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ce:	ff 75 08             	pushl  0x8(%ebp)
  8004d1:	e8 ae ff ff ff       	call   800484 <printnum>
  8004d6:	83 c4 20             	add    $0x20,%esp
  8004d9:	eb 19                	jmp    8004f4 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004db:	4b                   	dec    %ebx
  8004dc:	85 db                	test   %ebx,%ebx
  8004de:	7e 14                	jle    8004f4 <printnum+0x70>
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 20             	pushl  0x20(%ebp)
  8004e9:	ff 55 08             	call   *0x8(%ebp)
  8004ec:	83 c4 10             	add    $0x10,%esp
  8004ef:	4b                   	dec    %ebx
  8004f0:	85 db                	test   %ebx,%ebx
  8004f2:	7f ec                	jg     8004e0 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	ff 75 0c             	pushl  0xc(%ebp)
  8004fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800502:	83 ec 04             	sub    $0x4,%esp
  800505:	52                   	push   %edx
  800506:	50                   	push   %eax
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	e8 02 21 00 00       	call   802610 <__umoddi3>
  80050e:	83 c4 14             	add    $0x14,%esp
  800511:	0f be 80 7d 29 80 00 	movsbl 0x80297d(%eax),%eax
  800518:	50                   	push   %eax
  800519:	ff 55 08             	call   *0x8(%ebp)
}
  80051c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80051f:	5b                   	pop    %ebx
  800520:	5e                   	pop    %esi
  800521:	5f                   	pop    %edi
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80052d:	83 f8 01             	cmp    $0x1,%eax
  800530:	7e 0f                	jle    800541 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800532:	8b 01                	mov    (%ecx),%eax
  800534:	83 c0 08             	add    $0x8,%eax
  800537:	89 01                	mov    %eax,(%ecx)
  800539:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80053c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80053f:	eb 24                	jmp    800565 <getuint+0x41>
	else if (lflag)
  800541:	85 c0                	test   %eax,%eax
  800543:	74 11                	je     800556 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800545:	8b 01                	mov    (%ecx),%eax
  800547:	83 c0 04             	add    $0x4,%eax
  80054a:	89 01                	mov    %eax,(%ecx)
  80054c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80054f:	ba 00 00 00 00       	mov    $0x0,%edx
  800554:	eb 0f                	jmp    800565 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800556:	8b 01                	mov    (%ecx),%eax
  800558:	83 c0 04             	add    $0x4,%eax
  80055b:	89 01                	mov    %eax,(%ecx)
  80055d:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800560:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	8b 55 08             	mov    0x8(%ebp),%edx
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800570:	83 f8 01             	cmp    $0x1,%eax
  800573:	7e 0f                	jle    800584 <getint+0x1d>
		return va_arg(*ap, long long);
  800575:	8b 02                	mov    (%edx),%eax
  800577:	83 c0 08             	add    $0x8,%eax
  80057a:	89 02                	mov    %eax,(%edx)
  80057c:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80057f:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800582:	eb 1c                	jmp    8005a0 <getint+0x39>
	else if (lflag)
  800584:	85 c0                	test   %eax,%eax
  800586:	74 0d                	je     800595 <getint+0x2e>
		return va_arg(*ap, long);
  800588:	8b 02                	mov    (%edx),%eax
  80058a:	83 c0 04             	add    $0x4,%eax
  80058d:	89 02                	mov    %eax,(%edx)
  80058f:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800592:	99                   	cltd   
  800593:	eb 0b                	jmp    8005a0 <getint+0x39>
	else
		return va_arg(*ap, int);
  800595:	8b 02                	mov    (%edx),%eax
  800597:	83 c0 04             	add    $0x4,%eax
  80059a:	89 02                	mov    %eax,(%edx)
  80059c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80059f:	99                   	cltd   
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	57                   	push   %edi
  8005a6:	56                   	push   %esi
  8005a7:	53                   	push   %ebx
  8005a8:	83 ec 1c             	sub    $0x1c,%esp
  8005ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8005ae:	0f b6 13             	movzbl (%ebx),%edx
  8005b1:	43                   	inc    %ebx
  8005b2:	83 fa 25             	cmp    $0x25,%edx
  8005b5:	74 1e                	je     8005d5 <vprintfmt+0x33>
  8005b7:	85 d2                	test   %edx,%edx
  8005b9:	0f 84 d7 02 00 00    	je     800896 <vprintfmt+0x2f4>
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	ff 75 0c             	pushl  0xc(%ebp)
  8005c5:	52                   	push   %edx
  8005c6:	ff 55 08             	call   *0x8(%ebp)
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	0f b6 13             	movzbl (%ebx),%edx
  8005cf:	43                   	inc    %ebx
  8005d0:	83 fa 25             	cmp    $0x25,%edx
  8005d3:	75 e2                	jne    8005b7 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8005d5:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8005d9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8005e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  8005e5:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  8005ea:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f1:	0f b6 13             	movzbl (%ebx),%edx
  8005f4:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  8005f7:	43                   	inc    %ebx
  8005f8:	83 f8 55             	cmp    $0x55,%eax
  8005fb:	0f 87 70 02 00 00    	ja     800871 <vprintfmt+0x2cf>
  800601:	ff 24 85 fc 29 80 00 	jmp    *0x8029fc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800608:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  80060c:	eb e3                	jmp    8005f1 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80060e:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  800612:	eb dd                	jmp    8005f1 <vprintfmt+0x4f>

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
  800614:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800619:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  80061c:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800620:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800623:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800626:	83 f8 09             	cmp    $0x9,%eax
  800629:	77 27                	ja     800652 <vprintfmt+0xb0>
  80062b:	43                   	inc    %ebx
  80062c:	eb eb                	jmp    800619 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80062e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800638:	eb 18                	jmp    800652 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80063a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80063e:	79 b1                	jns    8005f1 <vprintfmt+0x4f>
				width = 0;
  800640:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800647:	eb a8                	jmp    8005f1 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800649:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800650:	eb 9f                	jmp    8005f1 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  800652:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800656:	79 99                	jns    8005f1 <vprintfmt+0x4f>
				width = precision, precision = -1;
  800658:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80065b:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  800660:	eb 8f                	jmp    8005f1 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800662:	41                   	inc    %ecx
			goto reswitch;
  800663:	eb 8c                	jmp    8005f1 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800675:	ff 55 08             	call   *0x8(%ebp)
			break;
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	e9 2e ff ff ff       	jmp    8005ae <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800680:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  80068a:	85 c0                	test   %eax,%eax
  80068c:	79 02                	jns    800690 <vprintfmt+0xee>
				err = -err;
  80068e:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800690:	83 f8 0e             	cmp    $0xe,%eax
  800693:	7f 0b                	jg     8006a0 <vprintfmt+0xfe>
  800695:	8b 3c 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edi
  80069c:	85 ff                	test   %edi,%edi
  80069e:	75 19                	jne    8006b9 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8006a0:	50                   	push   %eax
  8006a1:	68 8e 29 80 00       	push   $0x80298e
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	ff 75 08             	pushl  0x8(%ebp)
  8006ac:	e8 ed 01 00 00       	call   80089e <printfmt>
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	e9 f5 fe ff ff       	jmp    8005ae <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8006b9:	57                   	push   %edi
  8006ba:	68 01 2d 80 00       	push   $0x802d01
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	ff 75 08             	pushl  0x8(%ebp)
  8006c5:	e8 d4 01 00 00       	call   80089e <printfmt>
  8006ca:	83 c4 10             	add    $0x10,%esp
			break;
  8006cd:	e9 dc fe ff ff       	jmp    8005ae <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006d2:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8006dc:	85 ff                	test   %edi,%edi
  8006de:	75 05                	jne    8006e5 <vprintfmt+0x143>
				p = "(null)";
  8006e0:	bf 97 29 80 00       	mov    $0x802997,%edi
			if (width > 0 && padc != '-')
  8006e5:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8006e9:	7e 3b                	jle    800726 <vprintfmt+0x184>
  8006eb:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  8006ef:	74 35                	je     800726 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	56                   	push   %esi
  8006f5:	57                   	push   %edi
  8006f6:	e8 56 03 00 00       	call   800a51 <strnlen>
  8006fb:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800705:	7e 1f                	jle    800726 <vprintfmt+0x184>
  800707:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80070b:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800717:	ff 55 08             	call   *0x8(%ebp)
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800720:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800724:	7f e8                	jg     80070e <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800726:	0f be 17             	movsbl (%edi),%edx
  800729:	47                   	inc    %edi
  80072a:	85 d2                	test   %edx,%edx
  80072c:	74 44                	je     800772 <vprintfmt+0x1d0>
  80072e:	85 f6                	test   %esi,%esi
  800730:	78 03                	js     800735 <vprintfmt+0x193>
  800732:	4e                   	dec    %esi
  800733:	78 3d                	js     800772 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800735:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800739:	74 18                	je     800753 <vprintfmt+0x1b1>
  80073b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80073e:	83 f8 5e             	cmp    $0x5e,%eax
  800741:	76 10                	jbe    800753 <vprintfmt+0x1b1>
					putch('?', putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	6a 3f                	push   $0x3f
  80074b:	ff 55 08             	call   *0x8(%ebp)
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	eb 0d                	jmp    800760 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	52                   	push   %edx
  80075a:	ff 55 08             	call   *0x8(%ebp)
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800763:	0f be 17             	movsbl (%edi),%edx
  800766:	47                   	inc    %edi
  800767:	85 d2                	test   %edx,%edx
  800769:	74 07                	je     800772 <vprintfmt+0x1d0>
  80076b:	85 f6                	test   %esi,%esi
  80076d:	78 c6                	js     800735 <vprintfmt+0x193>
  80076f:	4e                   	dec    %esi
  800770:	79 c3                	jns    800735 <vprintfmt+0x193>
			for (; width > 0; width--)
  800772:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800776:	0f 8e 32 fe ff ff    	jle    8005ae <vprintfmt+0xc>
				putch(' ', putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	ff 75 0c             	pushl  0xc(%ebp)
  800782:	6a 20                	push   $0x20
  800784:	ff 55 08             	call   *0x8(%ebp)
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80078d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800791:	7f e9                	jg     80077c <vprintfmt+0x1da>
			break;
  800793:	e9 16 fe ff ff       	jmp    8005ae <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800798:	51                   	push   %ecx
  800799:	8d 45 14             	lea    0x14(%ebp),%eax
  80079c:	50                   	push   %eax
  80079d:	e8 c5 fd ff ff       	call   800567 <getint>
  8007a2:	89 c6                	mov    %eax,%esi
  8007a4:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8007a6:	83 c4 08             	add    $0x8,%esp
  8007a9:	85 d2                	test   %edx,%edx
  8007ab:	79 15                	jns    8007c2 <vprintfmt+0x220>
				putch('-', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	6a 2d                	push   $0x2d
  8007b5:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007b8:	f7 de                	neg    %esi
  8007ba:	83 d7 00             	adc    $0x0,%edi
  8007bd:	f7 df                	neg    %edi
  8007bf:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8007c2:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8007c7:	eb 75                	jmp    80083e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	51                   	push   %ecx
  8007ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8007cd:	50                   	push   %eax
  8007ce:	e8 51 fd ff ff       	call   800524 <getuint>
  8007d3:	89 c6                	mov    %eax,%esi
  8007d5:	89 d7                	mov    %edx,%edi
			base = 10;
  8007d7:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8007dc:	83 c4 08             	add    $0x8,%esp
  8007df:	eb 5d                	jmp    80083e <vprintfmt+0x29c>

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
  8007e1:	51                   	push   %ecx
  8007e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e5:	50                   	push   %eax
  8007e6:	e8 39 fd ff ff       	call   800524 <getuint>
  8007eb:	89 c6                	mov    %eax,%esi
  8007ed:	89 d7                	mov    %edx,%edi
			base = 8;
  8007ef:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  8007f4:	83 c4 08             	add    $0x8,%esp
  8007f7:	eb 45                	jmp    80083e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	6a 30                	push   $0x30
  800801:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800804:	83 c4 08             	add    $0x8,%esp
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	6a 78                	push   $0x78
  80080c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80080f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800819:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80081e:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	eb 16                	jmp    80083e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800828:	51                   	push   %ecx
  800829:	8d 45 14             	lea    0x14(%ebp),%eax
  80082c:	50                   	push   %eax
  80082d:	e8 f2 fc ff ff       	call   800524 <getuint>
  800832:	89 c6                	mov    %eax,%esi
  800834:	89 d7                	mov    %edx,%edi
			base = 16;
  800836:	ba 10 00 00 00       	mov    $0x10,%edx
  80083b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80083e:	83 ec 04             	sub    $0x4,%esp
  800841:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800845:	50                   	push   %eax
  800846:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800849:	52                   	push   %edx
  80084a:	57                   	push   %edi
  80084b:	56                   	push   %esi
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	ff 75 08             	pushl  0x8(%ebp)
  800852:	e8 2d fc ff ff       	call   800484 <printnum>
			break;
  800857:	83 c4 20             	add    $0x20,%esp
  80085a:	e9 4f fd ff ff       	jmp    8005ae <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	52                   	push   %edx
  800866:	ff 55 08             	call   *0x8(%ebp)
			break;
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	e9 3d fd ff ff       	jmp    8005ae <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	6a 25                	push   $0x25
  800879:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087c:	4b                   	dec    %ebx
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800884:	0f 84 24 fd ff ff    	je     8005ae <vprintfmt+0xc>
  80088a:	4b                   	dec    %ebx
  80088b:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80088f:	75 f9                	jne    80088a <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  800891:	e9 18 fd ff ff       	jmp    8005ae <vprintfmt+0xc>
		}
	}
}
  800896:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800899:	5b                   	pop    %ebx
  80089a:	5e                   	pop    %esi
  80089b:	5f                   	pop    %edi
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8008a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008a7:	50                   	push   %eax
  8008a8:	ff 75 10             	pushl  0x10(%ebp)
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 ec fc ff ff       	call   8005a2 <vprintfmt>
	va_end(ap);
}
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8008be:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  8008c1:	8b 0a                	mov    (%edx),%ecx
  8008c3:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8008c6:	73 07                	jae    8008cf <sprintputch+0x17>
		*b->buf++ = ch;
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	88 01                	mov    %al,(%ecx)
  8008cd:	ff 02                	incl   (%edx)
}
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	83 ec 18             	sub    $0x18,%esp
  8008d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8008da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008dd:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8008e0:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  8008e4:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8008e7:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  8008ee:	85 d2                	test   %edx,%edx
  8008f0:	74 04                	je     8008f6 <vsnprintf+0x25>
  8008f2:	85 c9                	test   %ecx,%ecx
  8008f4:	7f 07                	jg     8008fd <vsnprintf+0x2c>
		return -E_INVAL;
  8008f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fb:	eb 1d                	jmp    80091a <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008fd:	ff 75 14             	pushl  0x14(%ebp)
  800900:	ff 75 10             	pushl  0x10(%ebp)
  800903:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800906:	50                   	push   %eax
  800907:	68 b8 08 80 00       	push   $0x8008b8
  80090c:	e8 91 fc ff ff       	call   8005a2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800911:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800914:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800917:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800922:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800925:	50                   	push   %eax
  800926:	ff 75 10             	pushl  0x10(%ebp)
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	ff 75 08             	pushl  0x8(%ebp)
  80092f:	e8 9d ff ff ff       	call   8008d1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800934:	c9                   	leave  
  800935:	c3                   	ret    
	...

00800938 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800940:	83 ec 0c             	sub    $0xc,%esp
  800943:	56                   	push   %esi
  800944:	e8 ef 00 00 00       	call   800a38 <strlen>
  char letter;
  int hexnum = 0;
  800949:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80094e:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	89 c2                	mov    %eax,%edx
  800958:	4a                   	dec    %edx
  800959:	0f 88 d0 00 00 00    	js     800a2f <strtoint+0xf7>
    letter = string[cidx];
  80095f:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  800962:	85 d2                	test   %edx,%edx
  800964:	75 12                	jne    800978 <strtoint+0x40>
      if (letter != '0') {
  800966:	3c 30                	cmp    $0x30,%al
  800968:	0f 84 ba 00 00 00    	je     800a28 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80096e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800973:	e9 b9 00 00 00       	jmp    800a31 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800978:	83 fa 01             	cmp    $0x1,%edx
  80097b:	75 12                	jne    80098f <strtoint+0x57>
      if (letter != 'x') {
  80097d:	3c 78                	cmp    $0x78,%al
  80097f:	0f 84 a3 00 00 00    	je     800a28 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80098a:	e9 a2 00 00 00       	jmp    800a31 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80098f:	0f be c0             	movsbl %al,%eax
  800992:	83 e8 30             	sub    $0x30,%eax
  800995:	83 f8 36             	cmp    $0x36,%eax
  800998:	0f 87 80 00 00 00    	ja     800a1e <strtoint+0xe6>
  80099e:	ff 24 85 54 2b 80 00 	jmp    *0x802b54(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8009a5:	01 cb                	add    %ecx,%ebx
          break;
  8009a7:	eb 7c                	jmp    800a25 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8009a9:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8009ac:	eb 77                	jmp    800a25 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8009ae:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009b1:	01 c3                	add    %eax,%ebx
          break;
  8009b3:	eb 70                	jmp    800a25 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8009b5:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8009b8:	eb 6b                	jmp    800a25 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8009ba:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8009bd:	01 c3                	add    %eax,%ebx
          break;
  8009bf:	eb 64                	jmp    800a25 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8009c1:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009c4:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8009c7:	eb 5c                	jmp    800a25 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8009c9:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8009d0:	29 c8                	sub    %ecx,%eax
  8009d2:	01 c3                	add    %eax,%ebx
          break;
  8009d4:	eb 4f                	jmp    800a25 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8009d6:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8009d9:	eb 4a                	jmp    800a25 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8009db:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8009de:	01 c3                	add    %eax,%ebx
          break;
  8009e0:	eb 43                	jmp    800a25 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8009e2:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8009e5:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8009e8:	eb 3b                	jmp    800a25 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8009ea:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8009ed:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8009f0:	01 c3                	add    %eax,%ebx
          break;
  8009f2:	eb 31                	jmp    800a25 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8009f4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009f7:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8009fa:	eb 29                	jmp    800a25 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8009fc:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8009ff:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800a02:	01 c3                	add    %eax,%ebx
          break;
  800a04:	eb 1f                	jmp    800a25 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800a06:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800a0d:	29 c8                	sub    %ecx,%eax
  800a0f:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800a12:	eb 11                	jmp    800a25 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800a14:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800a17:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a1a:	01 c3                	add    %eax,%ebx
          break;
  800a1c:	eb 07                	jmp    800a25 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  800a1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800a23:	eb 0c                	jmp    800a31 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800a25:	c1 e1 04             	shl    $0x4,%ecx
  800a28:	4a                   	dec    %edx
  800a29:	0f 89 30 ff ff ff    	jns    80095f <strtoint+0x27>
    }
  }

  return hexnum;
  800a2f:	89 d8                	mov    %ebx,%eax
}
  800a31:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800a34:	5b                   	pop    %ebx
  800a35:	5e                   	pop    %esi
  800a36:	c9                   	leave  
  800a37:	c3                   	ret    

00800a38 <strlen>:





int
strlen(const char *s)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a43:	80 3a 00             	cmpb   $0x0,(%edx)
  800a46:	74 07                	je     800a4f <strlen+0x17>
		n++;
  800a48:	40                   	inc    %eax
  800a49:	42                   	inc    %edx
  800a4a:	80 3a 00             	cmpb   $0x0,(%edx)
  800a4d:	75 f9                	jne    800a48 <strlen+0x10>
	return n;
}
  800a4f:	c9                   	leave  
  800a50:	c3                   	ret    

00800a51 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5f:	85 d2                	test   %edx,%edx
  800a61:	74 0f                	je     800a72 <strnlen+0x21>
  800a63:	80 39 00             	cmpb   $0x0,(%ecx)
  800a66:	74 0a                	je     800a72 <strnlen+0x21>
		n++;
  800a68:	40                   	inc    %eax
  800a69:	41                   	inc    %ecx
  800a6a:	4a                   	dec    %edx
  800a6b:	74 05                	je     800a72 <strnlen+0x21>
  800a6d:	80 39 00             	cmpb   $0x0,(%ecx)
  800a70:	75 f6                	jne    800a68 <strnlen+0x17>
	return n;
}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	53                   	push   %ebx
  800a78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800a7e:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800a80:	8a 02                	mov    (%edx),%al
  800a82:	42                   	inc    %edx
  800a83:	88 01                	mov    %al,(%ecx)
  800a85:	41                   	inc    %ecx
  800a86:	84 c0                	test   %al,%al
  800a88:	75 f6                	jne    800a80 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a8a:	89 d8                	mov    %ebx,%eax
  800a8c:	5b                   	pop    %ebx
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	57                   	push   %edi
  800a93:	56                   	push   %esi
  800a94:	53                   	push   %ebx
  800a95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  800a9e:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800aa0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa5:	39 f3                	cmp    %esi,%ebx
  800aa7:	73 10                	jae    800ab9 <strncpy+0x2a>
		*dst++ = *src;
  800aa9:	8a 02                	mov    (%edx),%al
  800aab:	88 01                	mov    %al,(%ecx)
  800aad:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aae:	80 3a 01             	cmpb   $0x1,(%edx)
  800ab1:	83 da ff             	sbb    $0xffffffff,%edx
  800ab4:	43                   	inc    %ebx
  800ab5:	39 f3                	cmp    %esi,%ebx
  800ab7:	72 f0                	jb     800aa9 <strncpy+0x1a>
	}
	return ret;
}
  800ab9:	89 f8                	mov    %edi,%eax
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5f                   	pop    %edi
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	56                   	push   %esi
  800ac4:	53                   	push   %ebx
  800ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ac8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800acb:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  800ace:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800ad0:	85 d2                	test   %edx,%edx
  800ad2:	74 19                	je     800aed <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad4:	4a                   	dec    %edx
  800ad5:	74 13                	je     800aea <strlcpy+0x2a>
  800ad7:	80 39 00             	cmpb   $0x0,(%ecx)
  800ada:	74 0e                	je     800aea <strlcpy+0x2a>
  800adc:	8a 01                	mov    (%ecx),%al
  800ade:	41                   	inc    %ecx
  800adf:	88 03                	mov    %al,(%ebx)
  800ae1:	43                   	inc    %ebx
  800ae2:	4a                   	dec    %edx
  800ae3:	74 05                	je     800aea <strlcpy+0x2a>
  800ae5:	80 39 00             	cmpb   $0x0,(%ecx)
  800ae8:	75 f2                	jne    800adc <strlcpy+0x1c>
		*dst = '\0';
  800aea:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800aed:	89 d8                	mov    %ebx,%eax
  800aef:	29 f0                	sub    %esi,%eax
}
  800af1:	5b                   	pop    %ebx
  800af2:	5e                   	pop    %esi
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	8b 55 08             	mov    0x8(%ebp),%edx
  800afb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800afe:	80 3a 00             	cmpb   $0x0,(%edx)
  800b01:	74 13                	je     800b16 <strcmp+0x21>
  800b03:	8a 02                	mov    (%edx),%al
  800b05:	3a 01                	cmp    (%ecx),%al
  800b07:	75 0d                	jne    800b16 <strcmp+0x21>
  800b09:	42                   	inc    %edx
  800b0a:	41                   	inc    %ecx
  800b0b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b0e:	74 06                	je     800b16 <strcmp+0x21>
  800b10:	8a 02                	mov    (%edx),%al
  800b12:	3a 01                	cmp    (%ecx),%al
  800b14:	74 f3                	je     800b09 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b16:	0f b6 02             	movzbl (%edx),%eax
  800b19:	0f b6 11             	movzbl (%ecx),%edx
  800b1c:	29 d0                	sub    %edx,%eax
}
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	53                   	push   %ebx
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800b2d:	85 c9                	test   %ecx,%ecx
  800b2f:	74 1f                	je     800b50 <strncmp+0x30>
  800b31:	80 3a 00             	cmpb   $0x0,(%edx)
  800b34:	74 16                	je     800b4c <strncmp+0x2c>
  800b36:	8a 02                	mov    (%edx),%al
  800b38:	3a 03                	cmp    (%ebx),%al
  800b3a:	75 10                	jne    800b4c <strncmp+0x2c>
  800b3c:	42                   	inc    %edx
  800b3d:	43                   	inc    %ebx
  800b3e:	49                   	dec    %ecx
  800b3f:	74 0f                	je     800b50 <strncmp+0x30>
  800b41:	80 3a 00             	cmpb   $0x0,(%edx)
  800b44:	74 06                	je     800b4c <strncmp+0x2c>
  800b46:	8a 02                	mov    (%edx),%al
  800b48:	3a 03                	cmp    (%ebx),%al
  800b4a:	74 f0                	je     800b3c <strncmp+0x1c>
	if (n == 0)
  800b4c:	85 c9                	test   %ecx,%ecx
  800b4e:	75 07                	jne    800b57 <strncmp+0x37>
		return 0;
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
  800b55:	eb 0a                	jmp    800b61 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b57:	0f b6 12             	movzbl (%edx),%edx
  800b5a:	0f b6 03             	movzbl (%ebx),%eax
  800b5d:	29 c2                	sub    %eax,%edx
  800b5f:	89 d0                	mov    %edx,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800b6d:	80 38 00             	cmpb   $0x0,(%eax)
  800b70:	74 0a                	je     800b7c <strchr+0x18>
		if (*s == c)
  800b72:	38 10                	cmp    %dl,(%eax)
  800b74:	74 0b                	je     800b81 <strchr+0x1d>
  800b76:	40                   	inc    %eax
  800b77:	80 38 00             	cmpb   $0x0,(%eax)
  800b7a:	75 f6                	jne    800b72 <strchr+0xe>
			return (char *) s;
	return 0;
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800b8c:	80 38 00             	cmpb   $0x0,(%eax)
  800b8f:	74 0a                	je     800b9b <strfind+0x18>
		if (*s == c)
  800b91:	38 10                	cmp    %dl,(%eax)
  800b93:	74 06                	je     800b9b <strfind+0x18>
  800b95:	40                   	inc    %eax
  800b96:	80 38 00             	cmpb   $0x0,(%eax)
  800b99:	75 f6                	jne    800b91 <strfind+0xe>
			break;
	return (char *) s;
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800ba7:	89 f8                	mov    %edi,%eax
  800ba9:	85 c9                	test   %ecx,%ecx
  800bab:	74 40                	je     800bed <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800bad:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bb3:	75 30                	jne    800be5 <memset+0x48>
  800bb5:	f6 c1 03             	test   $0x3,%cl
  800bb8:	75 2b                	jne    800be5 <memset+0x48>
		c &= 0xFF;
  800bba:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	c1 e0 18             	shl    $0x18,%eax
  800bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bca:	c1 e2 10             	shl    $0x10,%edx
  800bcd:	09 d0                	or     %edx,%eax
  800bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd2:	c1 e2 08             	shl    $0x8,%edx
  800bd5:	09 d0                	or     %edx,%eax
  800bd7:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800bda:	c1 e9 02             	shr    $0x2,%ecx
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	fc                   	cld    
  800be1:	f3 ab                	repz stos %eax,%es:(%edi)
  800be3:	eb 06                	jmp    800beb <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be8:	fc                   	cld    
  800be9:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800beb:	89 f8                	mov    %edi,%eax
}
  800bed:	5f                   	pop    %edi
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800bfb:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800bfe:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c00:	39 c6                	cmp    %eax,%esi
  800c02:	73 33                	jae    800c37 <memmove+0x47>
  800c04:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c07:	39 c2                	cmp    %eax,%edx
  800c09:	76 2c                	jbe    800c37 <memmove+0x47>
		s += n;
  800c0b:	89 d6                	mov    %edx,%esi
		d += n;
  800c0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c10:	f6 c2 03             	test   $0x3,%dl
  800c13:	75 1b                	jne    800c30 <memmove+0x40>
  800c15:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c1b:	75 13                	jne    800c30 <memmove+0x40>
  800c1d:	f6 c1 03             	test   $0x3,%cl
  800c20:	75 0e                	jne    800c30 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800c22:	83 ef 04             	sub    $0x4,%edi
  800c25:	83 ee 04             	sub    $0x4,%esi
  800c28:	c1 e9 02             	shr    $0x2,%ecx
  800c2b:	fd                   	std    
  800c2c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800c2e:	eb 27                	jmp    800c57 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c30:	4f                   	dec    %edi
  800c31:	4e                   	dec    %esi
  800c32:	fd                   	std    
  800c33:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800c35:	eb 20                	jmp    800c57 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c37:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c3d:	75 15                	jne    800c54 <memmove+0x64>
  800c3f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c45:	75 0d                	jne    800c54 <memmove+0x64>
  800c47:	f6 c1 03             	test   $0x3,%cl
  800c4a:	75 08                	jne    800c54 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800c4c:	c1 e9 02             	shr    $0x2,%ecx
  800c4f:	fc                   	cld    
  800c50:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800c52:	eb 03                	jmp    800c57 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c54:	fc                   	cld    
  800c55:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <memcpy>:

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
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c5e:	ff 75 10             	pushl  0x10(%ebp)
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 84 ff ff ff       	call   800bf0 <memmove>
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800c72:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800c75:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c78:	8b 55 10             	mov    0x10(%ebp),%edx
  800c7b:	4a                   	dec    %edx
  800c7c:	83 fa ff             	cmp    $0xffffffff,%edx
  800c7f:	74 1a                	je     800c9b <memcmp+0x2d>
  800c81:	8a 01                	mov    (%ecx),%al
  800c83:	3a 03                	cmp    (%ebx),%al
  800c85:	74 0c                	je     800c93 <memcmp+0x25>
  800c87:	0f b6 d0             	movzbl %al,%edx
  800c8a:	0f b6 03             	movzbl (%ebx),%eax
  800c8d:	29 c2                	sub    %eax,%edx
  800c8f:	89 d0                	mov    %edx,%eax
  800c91:	eb 0d                	jmp    800ca0 <memcmp+0x32>
  800c93:	41                   	inc    %ecx
  800c94:	43                   	inc    %ebx
  800c95:	4a                   	dec    %edx
  800c96:	83 fa ff             	cmp    $0xffffffff,%edx
  800c99:	75 e6                	jne    800c81 <memcmp+0x13>
	}

	return 0;
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cac:	89 c2                	mov    %eax,%edx
  800cae:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb1:	39 d0                	cmp    %edx,%eax
  800cb3:	73 09                	jae    800cbe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb5:	38 08                	cmp    %cl,(%eax)
  800cb7:	74 05                	je     800cbe <memfind+0x1b>
  800cb9:	40                   	inc    %eax
  800cba:	39 d0                	cmp    %edx,%eax
  800cbc:	72 f7                	jb     800cb5 <memfind+0x12>
			break;
	return (void *) s;
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ccc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800ccf:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800cd4:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800cd9:	80 3a 20             	cmpb   $0x20,(%edx)
  800cdc:	74 05                	je     800ce3 <strtol+0x23>
  800cde:	80 3a 09             	cmpb   $0x9,(%edx)
  800ce1:	75 0b                	jne    800cee <strtol+0x2e>
  800ce3:	42                   	inc    %edx
  800ce4:	80 3a 20             	cmpb   $0x20,(%edx)
  800ce7:	74 fa                	je     800ce3 <strtol+0x23>
  800ce9:	80 3a 09             	cmpb   $0x9,(%edx)
  800cec:	74 f5                	je     800ce3 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800cee:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800cf1:	75 03                	jne    800cf6 <strtol+0x36>
		s++;
  800cf3:	42                   	inc    %edx
  800cf4:	eb 0b                	jmp    800d01 <strtol+0x41>
	else if (*s == '-')
  800cf6:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800cf9:	75 06                	jne    800d01 <strtol+0x41>
		s++, neg = 1;
  800cfb:	42                   	inc    %edx
  800cfc:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d01:	85 c9                	test   %ecx,%ecx
  800d03:	74 05                	je     800d0a <strtol+0x4a>
  800d05:	83 f9 10             	cmp    $0x10,%ecx
  800d08:	75 15                	jne    800d1f <strtol+0x5f>
  800d0a:	80 3a 30             	cmpb   $0x30,(%edx)
  800d0d:	75 10                	jne    800d1f <strtol+0x5f>
  800d0f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d13:	75 0a                	jne    800d1f <strtol+0x5f>
		s += 2, base = 16;
  800d15:	83 c2 02             	add    $0x2,%edx
  800d18:	b9 10 00 00 00       	mov    $0x10,%ecx
  800d1d:	eb 14                	jmp    800d33 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800d1f:	85 c9                	test   %ecx,%ecx
  800d21:	75 10                	jne    800d33 <strtol+0x73>
  800d23:	80 3a 30             	cmpb   $0x30,(%edx)
  800d26:	75 05                	jne    800d2d <strtol+0x6d>
		s++, base = 8;
  800d28:	42                   	inc    %edx
  800d29:	b1 08                	mov    $0x8,%cl
  800d2b:	eb 06                	jmp    800d33 <strtol+0x73>
	else if (base == 0)
  800d2d:	85 c9                	test   %ecx,%ecx
  800d2f:	75 02                	jne    800d33 <strtol+0x73>
		base = 10;
  800d31:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d33:	8a 02                	mov    (%edx),%al
  800d35:	83 e8 30             	sub    $0x30,%eax
  800d38:	3c 09                	cmp    $0x9,%al
  800d3a:	77 08                	ja     800d44 <strtol+0x84>
			dig = *s - '0';
  800d3c:	0f be 02             	movsbl (%edx),%eax
  800d3f:	83 e8 30             	sub    $0x30,%eax
  800d42:	eb 20                	jmp    800d64 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800d44:	8a 02                	mov    (%edx),%al
  800d46:	83 e8 61             	sub    $0x61,%eax
  800d49:	3c 19                	cmp    $0x19,%al
  800d4b:	77 08                	ja     800d55 <strtol+0x95>
			dig = *s - 'a' + 10;
  800d4d:	0f be 02             	movsbl (%edx),%eax
  800d50:	83 e8 57             	sub    $0x57,%eax
  800d53:	eb 0f                	jmp    800d64 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800d55:	8a 02                	mov    (%edx),%al
  800d57:	83 e8 41             	sub    $0x41,%eax
  800d5a:	3c 19                	cmp    $0x19,%al
  800d5c:	77 12                	ja     800d70 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800d5e:	0f be 02             	movsbl (%edx),%eax
  800d61:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800d64:	39 c8                	cmp    %ecx,%eax
  800d66:	7d 08                	jge    800d70 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800d68:	42                   	inc    %edx
  800d69:	0f af d9             	imul   %ecx,%ebx
  800d6c:	01 c3                	add    %eax,%ebx
  800d6e:	eb c3                	jmp    800d33 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d70:	85 f6                	test   %esi,%esi
  800d72:	74 02                	je     800d76 <strtol+0xb6>
		*endptr = (char *) s;
  800d74:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d76:	89 d8                	mov    %ebx,%eax
  800d78:	85 ff                	test   %edi,%edi
  800d7a:	74 02                	je     800d7e <strtol+0xbe>
  800d7c:	f7 d8                	neg    %eax
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    
	...

00800d84 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
  800d8a:	83 ec 04             	sub    $0x4,%esp
  800d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	bf 00 00 00 00       	mov    $0x0,%edi
  800d98:	89 f8                	mov    %edi,%eax
  800d9a:	89 fb                	mov    %edi,%ebx
  800d9c:	89 fe                	mov    %edi,%esi
  800d9e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da0:	83 c4 04             	add    $0x4,%esp
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
  800dae:	b8 01 00 00 00       	mov    $0x1,%eax
  800db3:	bf 00 00 00 00       	mov    $0x0,%edi
  800db8:	89 fa                	mov    %edi,%edx
  800dba:	89 f9                	mov    %edi,%ecx
  800dbc:	89 fb                	mov    %edi,%ebx
  800dbe:	89 fe                	mov    %edi,%esi
  800dc0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	bf 00 00 00 00       	mov    $0x0,%edi
  800ddd:	89 f9                	mov    %edi,%ecx
  800ddf:	89 fb                	mov    %edi,%ebx
  800de1:	89 fe                	mov    %edi,%esi
  800de3:	cd 30                	int    $0x30
  800de5:	85 c0                	test   %eax,%eax
  800de7:	7e 17                	jle    800e00 <sys_env_destroy+0x39>
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	50                   	push   %eax
  800ded:	6a 03                	push   $0x3
  800def:	68 30 2c 80 00       	push   $0x802c30
  800df4:	6a 23                	push   $0x23
  800df6:	68 4d 2c 80 00       	push   $0x802c4d
  800dfb:	e8 80 f5 ff ff       	call   800380 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e00:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e03:	5b                   	pop    %ebx
  800e04:	5e                   	pop    %esi
  800e05:	5f                   	pop    %edi
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e13:	bf 00 00 00 00       	mov    $0x0,%edi
  800e18:	89 fa                	mov    %edi,%edx
  800e1a:	89 f9                	mov    %edi,%ecx
  800e1c:	89 fb                	mov    %edi,%ebx
  800e1e:	89 fe                	mov    %edi,%esi
  800e20:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <sys_yield>:

void
sys_yield(void)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e32:	bf 00 00 00 00       	mov    $0x0,%edi
  800e37:	89 fa                	mov    %edi,%edx
  800e39:	89 f9                	mov    %edi,%ecx
  800e3b:	89 fb                	mov    %edi,%ebx
  800e3d:	89 fe                	mov    %edi,%esi
  800e3f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e58:	b8 04 00 00 00       	mov    $0x4,%eax
  800e5d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e62:	89 fe                	mov    %edi,%esi
  800e64:	cd 30                	int    $0x30
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7e 17                	jle    800e81 <sys_page_alloc+0x3b>
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	50                   	push   %eax
  800e6e:	6a 04                	push   $0x4
  800e70:	68 30 2c 80 00       	push   $0x802c30
  800e75:	6a 23                	push   $0x23
  800e77:	68 4d 2c 80 00       	push   $0x802c4d
  800e7c:	e8 ff f4 ff ff       	call   800380 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e81:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9e:	8b 75 18             	mov    0x18(%ebp),%esi
  800ea1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea6:	cd 30                	int    $0x30
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	7e 17                	jle    800ec3 <sys_page_map+0x3a>
  800eac:	83 ec 0c             	sub    $0xc,%esp
  800eaf:	50                   	push   %eax
  800eb0:	6a 05                	push   $0x5
  800eb2:	68 30 2c 80 00       	push   $0x802c30
  800eb7:	6a 23                	push   $0x23
  800eb9:	68 4d 2c 80 00       	push   $0x802c4d
  800ebe:	e8 bd f4 ff ff       	call   800380 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ec3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	b8 06 00 00 00       	mov    $0x6,%eax
  800edf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee4:	89 fb                	mov    %edi,%ebx
  800ee6:	89 fe                	mov    %edi,%esi
  800ee8:	cd 30                	int    $0x30
  800eea:	85 c0                	test   %eax,%eax
  800eec:	7e 17                	jle    800f05 <sys_page_unmap+0x3a>
  800eee:	83 ec 0c             	sub    $0xc,%esp
  800ef1:	50                   	push   %eax
  800ef2:	6a 06                	push   $0x6
  800ef4:	68 30 2c 80 00       	push   $0x802c30
  800ef9:	6a 23                	push   $0x23
  800efb:	68 4d 2c 80 00       	push   $0x802c4d
  800f00:	e8 7b f4 ff ff       	call   800380 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f05:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f21:	bf 00 00 00 00       	mov    $0x0,%edi
  800f26:	89 fb                	mov    %edi,%ebx
  800f28:	89 fe                	mov    %edi,%esi
  800f2a:	cd 30                	int    $0x30
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7e 17                	jle    800f47 <sys_env_set_status+0x3a>
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	50                   	push   %eax
  800f34:	6a 08                	push   $0x8
  800f36:	68 30 2c 80 00       	push   $0x802c30
  800f3b:	6a 23                	push   $0x23
  800f3d:	68 4d 2c 80 00       	push   $0x802c4d
  800f42:	e8 39 f4 ff ff       	call   800380 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 0c             	sub    $0xc,%esp
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f63:	bf 00 00 00 00       	mov    $0x0,%edi
  800f68:	89 fb                	mov    %edi,%ebx
  800f6a:	89 fe                	mov    %edi,%esi
  800f6c:	cd 30                	int    $0x30
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	7e 17                	jle    800f89 <sys_env_set_trapframe+0x3a>
  800f72:	83 ec 0c             	sub    $0xc,%esp
  800f75:	50                   	push   %eax
  800f76:	6a 09                	push   $0x9
  800f78:	68 30 2c 80 00       	push   $0x802c30
  800f7d:	6a 23                	push   $0x23
  800f7f:	68 4d 2c 80 00       	push   $0x802c4d
  800f84:	e8 f7 f3 ff ff       	call   800380 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f89:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
  800f97:	83 ec 0c             	sub    $0xc,%esp
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa5:	bf 00 00 00 00       	mov    $0x0,%edi
  800faa:	89 fb                	mov    %edi,%ebx
  800fac:	89 fe                	mov    %edi,%esi
  800fae:	cd 30                	int    $0x30
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	7e 17                	jle    800fcb <sys_env_set_pgfault_upcall+0x3a>
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	50                   	push   %eax
  800fb8:	6a 0a                	push   $0xa
  800fba:	68 30 2c 80 00       	push   $0x802c30
  800fbf:	6a 23                	push   $0x23
  800fc1:	68 4d 2c 80 00       	push   $0x802c4d
  800fc6:	e8 b5 f3 ff ff       	call   800380 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fcb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	57                   	push   %edi
  800fd7:	56                   	push   %esi
  800fd8:	53                   	push   %ebx
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fea:	be 00 00 00 00       	mov    $0x0,%esi
  800fef:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	b8 0d 00 00 00       	mov    $0xd,%eax
  801007:	bf 00 00 00 00       	mov    $0x0,%edi
  80100c:	89 f9                	mov    %edi,%ecx
  80100e:	89 fb                	mov    %edi,%ebx
  801010:	89 fe                	mov    %edi,%esi
  801012:	cd 30                	int    $0x30
  801014:	85 c0                	test   %eax,%eax
  801016:	7e 17                	jle    80102f <sys_ipc_recv+0x39>
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	50                   	push   %eax
  80101c:	6a 0d                	push   $0xd
  80101e:	68 30 2c 80 00       	push   $0x802c30
  801023:	6a 23                	push   $0x23
  801025:	68 4d 2c 80 00       	push   $0x802c4d
  80102a:	e8 51 f3 ff ff       	call   800380 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80102f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801032:	5b                   	pop    %ebx
  801033:	5e                   	pop    %esi
  801034:	5f                   	pop    %edi
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	57                   	push   %edi
  80103b:	56                   	push   %esi
  80103c:	53                   	push   %ebx
  80103d:	83 ec 0c             	sub    $0xc,%esp
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	b8 10 00 00 00       	mov    $0x10,%eax
  80104b:	bf 00 00 00 00       	mov    $0x0,%edi
  801050:	89 fb                	mov    %edi,%ebx
  801052:	89 fe                	mov    %edi,%esi
  801054:	cd 30                	int    $0x30
  801056:	85 c0                	test   %eax,%eax
  801058:	7e 17                	jle    801071 <sys_transmit_packet+0x3a>
  80105a:	83 ec 0c             	sub    $0xc,%esp
  80105d:	50                   	push   %eax
  80105e:	6a 10                	push   $0x10
  801060:	68 30 2c 80 00       	push   $0x802c30
  801065:	6a 23                	push   $0x23
  801067:	68 4d 2c 80 00       	push   $0x802c4d
  80106c:	e8 0f f3 ff ff       	call   800380 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  801071:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	57                   	push   %edi
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
  80107f:	83 ec 0c             	sub    $0xc,%esp
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801088:	b8 11 00 00 00       	mov    $0x11,%eax
  80108d:	bf 00 00 00 00       	mov    $0x0,%edi
  801092:	89 fb                	mov    %edi,%ebx
  801094:	89 fe                	mov    %edi,%esi
  801096:	cd 30                	int    $0x30
  801098:	85 c0                	test   %eax,%eax
  80109a:	7e 17                	jle    8010b3 <sys_receive_packet+0x3a>
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	50                   	push   %eax
  8010a0:	6a 11                	push   $0x11
  8010a2:	68 30 2c 80 00       	push   $0x802c30
  8010a7:	6a 23                	push   $0x23
  8010a9:	68 4d 2c 80 00       	push   $0x802c4d
  8010ae:	e8 cd f2 ff ff       	call   800380 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  8010b3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010b6:	5b                   	pop    %ebx
  8010b7:	5e                   	pop    %esi
  8010b8:	5f                   	pop    %edi
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	57                   	push   %edi
  8010bf:	56                   	push   %esi
  8010c0:	53                   	push   %ebx
  8010c1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8010cb:	89 fa                	mov    %edi,%edx
  8010cd:	89 f9                	mov    %edi,%ecx
  8010cf:	89 fb                	mov    %edi,%ebx
  8010d1:	89 fe                	mov    %edi,%esi
  8010d3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010d5:	5b                   	pop    %ebx
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 0c             	sub    $0xc,%esp
  8010e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8010f0:	89 f9                	mov    %edi,%ecx
  8010f2:	89 fb                	mov    %edi,%ebx
  8010f4:	89 fe                	mov    %edi,%esi
  8010f6:	cd 30                	int    $0x30
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	7e 17                	jle    801113 <sys_map_receive_buffers+0x39>
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	50                   	push   %eax
  801100:	6a 0e                	push   $0xe
  801102:	68 30 2c 80 00       	push   $0x802c30
  801107:	6a 23                	push   $0x23
  801109:	68 4d 2c 80 00       	push   $0x802c4d
  80110e:	e8 6d f2 ff ff       	call   800380 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  801113:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801116:	5b                   	pop    %ebx
  801117:	5e                   	pop    %esi
  801118:	5f                   	pop    %edi
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	57                   	push   %edi
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
  801121:	83 ec 0c             	sub    $0xc,%esp
  801124:	8b 55 08             	mov    0x8(%ebp),%edx
  801127:	b8 12 00 00 00       	mov    $0x12,%eax
  80112c:	bf 00 00 00 00       	mov    $0x0,%edi
  801131:	89 f9                	mov    %edi,%ecx
  801133:	89 fb                	mov    %edi,%ebx
  801135:	89 fe                	mov    %edi,%esi
  801137:	cd 30                	int    $0x30
  801139:	85 c0                	test   %eax,%eax
  80113b:	7e 17                	jle    801154 <sys_receive_packet_zerocopy+0x39>
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	50                   	push   %eax
  801141:	6a 12                	push   $0x12
  801143:	68 30 2c 80 00       	push   $0x802c30
  801148:	6a 23                	push   $0x23
  80114a:	68 4d 2c 80 00       	push   $0x802c4d
  80114f:	e8 2c f2 ff ff       	call   800380 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  801154:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	53                   	push   %ebx
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	8b 55 08             	mov    0x8(%ebp),%edx
  801168:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116b:	b8 13 00 00 00       	mov    $0x13,%eax
  801170:	bf 00 00 00 00       	mov    $0x0,%edi
  801175:	89 fb                	mov    %edi,%ebx
  801177:	89 fe                	mov    %edi,%esi
  801179:	cd 30                	int    $0x30
  80117b:	85 c0                	test   %eax,%eax
  80117d:	7e 17                	jle    801196 <sys_env_set_priority+0x3a>
  80117f:	83 ec 0c             	sub    $0xc,%esp
  801182:	50                   	push   %eax
  801183:	6a 13                	push   $0x13
  801185:	68 30 2c 80 00       	push   $0x802c30
  80118a:	6a 23                	push   $0x23
  80118c:	68 4d 2c 80 00       	push   $0x802c4d
  801191:	e8 ea f1 ff ff       	call   800380 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  801196:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5f                   	pop    %edi
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    
	...

008011a0 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8011a6:	ff 75 08             	pushl  0x8(%ebp)
  8011a9:	e8 0a 00 00 00       	call   8011b8 <fd2num>
  8011ae:	c1 e0 16             	shl    $0x16,%eax
  8011b1:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	05 00 00 40 30       	add    $0x30400000,%eax
  8011c3:	c1 e8 0c             	shr    $0xc,%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <fd_alloc>:

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
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	57                   	push   %edi
  8011cc:	56                   	push   %esi
  8011cd:	53                   	push   %ebx
  8011ce:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011d6:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  8011db:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  8011e0:	89 c8                	mov    %ecx,%eax
  8011e2:	c1 e0 0c             	shl    $0xc,%eax
  8011e5:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8011eb:	89 d0                	mov    %edx,%eax
  8011ed:	c1 e8 16             	shr    $0x16,%eax
  8011f0:	8b 04 86             	mov    (%esi,%eax,4),%eax
  8011f3:	a8 01                	test   $0x1,%al
  8011f5:	74 0c                	je     801203 <fd_alloc+0x3b>
  8011f7:	89 d0                	mov    %edx,%eax
  8011f9:	c1 e8 0c             	shr    $0xc,%eax
  8011fc:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  8011ff:	a8 01                	test   $0x1,%al
  801201:	75 09                	jne    80120c <fd_alloc+0x44>
			*fd_store = fd;
  801203:	89 17                	mov    %edx,(%edi)
			return 0;
  801205:	b8 00 00 00 00       	mov    $0x0,%eax
  80120a:	eb 11                	jmp    80121d <fd_alloc+0x55>
  80120c:	41                   	inc    %ecx
  80120d:	83 f9 1f             	cmp    $0x1f,%ecx
  801210:	7e ce                	jle    8011e0 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  801212:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801218:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5f                   	pop    %edi
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801228:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80122d:	83 f8 1f             	cmp    $0x1f,%eax
  801230:	77 3a                	ja     80126c <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  801232:	c1 e0 0c             	shl    $0xc,%eax
  801235:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  80123b:	89 d0                	mov    %edx,%eax
  80123d:	c1 e8 16             	shr    $0x16,%eax
  801240:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801247:	a8 01                	test   $0x1,%al
  801249:	74 10                	je     80125b <fd_lookup+0x39>
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	c1 e8 0c             	shr    $0xc,%eax
  801250:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801257:	a8 01                	test   $0x1,%al
  801259:	75 07                	jne    801262 <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80125b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801260:	eb 0a                	jmp    80126c <fd_lookup+0x4a>
	}
	*fd_store = fd;
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	89 10                	mov    %edx,(%eax)
	return 0;
  801267:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80126c:	89 d0                	mov    %edx,%eax
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <fd_close>:

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
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	56                   	push   %esi
  801274:	53                   	push   %ebx
  801275:	83 ec 10             	sub    $0x10,%esp
  801278:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80127b:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80127e:	50                   	push   %eax
  80127f:	56                   	push   %esi
  801280:	e8 33 ff ff ff       	call   8011b8 <fd2num>
  801285:	89 04 24             	mov    %eax,(%esp)
  801288:	e8 95 ff ff ff       	call   801222 <fd_lookup>
  80128d:	89 c3                	mov    %eax,%ebx
  80128f:	83 c4 08             	add    $0x8,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 05                	js     80129b <fd_close+0x2b>
  801296:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801299:	74 0f                	je     8012aa <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80129b:	89 d8                	mov    %ebx,%eax
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	75 3a                	jne    8012dd <fd_close+0x6d>
  8012a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a8:	eb 33                	jmp    8012dd <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8012b0:	50                   	push   %eax
  8012b1:	ff 36                	pushl  (%esi)
  8012b3:	e8 2c 00 00 00       	call   8012e4 <dev_lookup>
  8012b8:	89 c3                	mov    %eax,%ebx
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 0f                	js     8012d0 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8012c1:	83 ec 0c             	sub    $0xc,%esp
  8012c4:	56                   	push   %esi
  8012c5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8012c8:	ff 50 10             	call   *0x10(%eax)
  8012cb:	89 c3                	mov    %eax,%ebx
  8012cd:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	56                   	push   %esi
  8012d4:	6a 00                	push   $0x0
  8012d6:	e8 f0 fb ff ff       	call   800ecb <sys_page_unmap>
	return r;
  8012db:	89 d8                	mov    %ebx,%eax
}
  8012dd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <dev_lookup>:


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
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  8012ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f4:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8012fb:	74 1c                	je     801319 <dev_lookup+0x35>
  8012fd:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  801302:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801305:	39 18                	cmp    %ebx,(%eax)
  801307:	75 09                	jne    801312 <dev_lookup+0x2e>
			*dev = devtab[i];
  801309:	89 06                	mov    %eax,(%esi)
			return 0;
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
  801310:	eb 29                	jmp    80133b <dev_lookup+0x57>
  801312:	42                   	inc    %edx
  801313:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801317:	75 e9                	jne    801302 <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801319:	83 ec 04             	sub    $0x4,%esp
  80131c:	53                   	push   %ebx
  80131d:	a1 80 64 80 00       	mov    0x806480,%eax
  801322:	8b 40 4c             	mov    0x4c(%eax),%eax
  801325:	50                   	push   %eax
  801326:	68 5c 2c 80 00       	push   $0x802c5c
  80132b:	e8 40 f1 ff ff       	call   800470 <cprintf>
	*dev = 0;
  801330:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801336:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80133b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <close>:

int
close(int fdnum)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801348:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80134b:	50                   	push   %eax
  80134c:	ff 75 08             	pushl  0x8(%ebp)
  80134f:	e8 ce fe ff ff       	call   801222 <fd_lookup>
  801354:	83 c4 08             	add    $0x8,%esp
		return r;
  801357:	89 c2                	mov    %eax,%edx
  801359:	85 c0                	test   %eax,%eax
  80135b:	78 0f                	js     80136c <close+0x2a>
	else
		return fd_close(fd, 1);
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	6a 01                	push   $0x1
  801362:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801365:	e8 06 ff ff ff       	call   801270 <fd_close>
  80136a:	89 c2                	mov    %eax,%edx
}
  80136c:	89 d0                	mov    %edx,%eax
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <close_all>:

void
close_all(void)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	53                   	push   %ebx
  801374:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801377:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80137c:	83 ec 0c             	sub    $0xc,%esp
  80137f:	53                   	push   %ebx
  801380:	e8 bd ff ff ff       	call   801342 <close>
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	43                   	inc    %ebx
  801389:	83 fb 1f             	cmp    $0x1f,%ebx
  80138c:	7e ee                	jle    80137c <close_all+0xc>
}
  80138e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	57                   	push   %edi
  801397:	56                   	push   %esi
  801398:	53                   	push   %ebx
  801399:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80139c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80139f:	50                   	push   %eax
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 7a fe ff ff       	call   801222 <fd_lookup>
  8013a8:	89 c6                	mov    %eax,%esi
  8013aa:	83 c4 08             	add    $0x8,%esp
  8013ad:	85 f6                	test   %esi,%esi
  8013af:	0f 88 f8 00 00 00    	js     8014ad <dup+0x11a>
		return r;
	close(newfdnum);
  8013b5:	83 ec 0c             	sub    $0xc,%esp
  8013b8:	ff 75 0c             	pushl  0xc(%ebp)
  8013bb:	e8 82 ff ff ff       	call   801342 <close>

	newfd = INDEX2FD(newfdnum);
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	c1 e0 0c             	shl    $0xc,%eax
  8013c6:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8013cb:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8013ce:	83 c4 04             	add    $0x4,%esp
  8013d1:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8013d4:	e8 c7 fd ff ff       	call   8011a0 <fd2data>
  8013d9:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8013db:	83 c4 04             	add    $0x4,%esp
  8013de:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8013e1:	e8 ba fd ff ff       	call   8011a0 <fd2data>
  8013e6:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8013e9:	89 f8                	mov    %edi,%eax
  8013eb:	c1 e8 16             	shr    $0x16,%eax
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	74 48                	je     801444 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8013fc:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801401:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801404:	89 d0                	mov    %edx,%eax
  801406:	c1 e8 0c             	shr    $0xc,%eax
  801409:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801410:	a8 01                	test   $0x1,%al
  801412:	74 22                	je     801436 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801414:	83 ec 0c             	sub    $0xc,%esp
  801417:	25 07 0e 00 00       	and    $0xe07,%eax
  80141c:	50                   	push   %eax
  80141d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801420:	01 d8                	add    %ebx,%eax
  801422:	50                   	push   %eax
  801423:	6a 00                	push   $0x0
  801425:	52                   	push   %edx
  801426:	6a 00                	push   $0x0
  801428:	e8 5c fa ff ff       	call   800e89 <sys_page_map>
  80142d:	89 c6                	mov    %eax,%esi
  80142f:	83 c4 20             	add    $0x20,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	78 3f                	js     801475 <dup+0xe2>
  801436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80143c:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801442:	7e bd                	jle    801401 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80144a:	89 d0                	mov    %edx,%eax
  80144c:	c1 e8 0c             	shr    $0xc,%eax
  80144f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801456:	25 07 0e 00 00       	and    $0xe07,%eax
  80145b:	50                   	push   %eax
  80145c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80145f:	6a 00                	push   $0x0
  801461:	52                   	push   %edx
  801462:	6a 00                	push   $0x0
  801464:	e8 20 fa ff ff       	call   800e89 <sys_page_map>
  801469:	89 c6                	mov    %eax,%esi
  80146b:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	85 f6                	test   %esi,%esi
  801473:	79 38                	jns    8014ad <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80147b:	6a 00                	push   $0x0
  80147d:	e8 49 fa ff ff       	call   800ecb <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801482:	bb 00 00 00 00       	mov    $0x0,%ebx
  801487:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801490:	01 d8                	add    %ebx,%eax
  801492:	50                   	push   %eax
  801493:	6a 00                	push   $0x0
  801495:	e8 31 fa ff ff       	call   800ecb <sys_page_unmap>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014a3:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8014a9:	7e df                	jle    80148a <dup+0xf7>
	return r;
  8014ab:	89 f0                	mov    %esi,%eax
}
  8014ad:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8014b0:	5b                   	pop    %ebx
  8014b1:	5e                   	pop    %esi
  8014b2:	5f                   	pop    %edi
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	53                   	push   %ebx
  8014b9:	83 ec 14             	sub    $0x14,%esp
  8014bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bf:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	53                   	push   %ebx
  8014c4:	e8 59 fd ff ff       	call   801222 <fd_lookup>
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	83 c4 08             	add    $0x8,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 1a                	js     8014ec <read+0x37>
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014d8:	50                   	push   %eax
  8014d9:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014dc:	ff 30                	pushl  (%eax)
  8014de:	e8 01 fe ff ff       	call   8012e4 <dev_lookup>
  8014e3:	89 c2                	mov    %eax,%edx
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	79 04                	jns    8014f0 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8014ec:	89 d0                	mov    %edx,%eax
  8014ee:	eb 50                	jmp    801540 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014f0:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014f3:	8b 40 08             	mov    0x8(%eax),%eax
  8014f6:	83 e0 03             	and    $0x3,%eax
  8014f9:	83 f8 01             	cmp    $0x1,%eax
  8014fc:	75 1e                	jne    80151c <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	53                   	push   %ebx
  801502:	a1 80 64 80 00       	mov    0x806480,%eax
  801507:	8b 40 4c             	mov    0x4c(%eax),%eax
  80150a:	50                   	push   %eax
  80150b:	68 9d 2c 80 00       	push   $0x802c9d
  801510:	e8 5b ef ff ff       	call   800470 <cprintf>
		return -E_INVAL;
  801515:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151a:	eb 24                	jmp    801540 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  80151c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80151f:	ff 70 04             	pushl  0x4(%eax)
  801522:	ff 75 10             	pushl  0x10(%ebp)
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	50                   	push   %eax
  801529:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80152c:	ff 50 08             	call   *0x8(%eax)
  80152f:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 06                	js     80153e <read+0x89>
		fd->fd_offset += r;
  801538:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80153b:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80153e:	89 d0                	mov    %edx,%eax
}
  801540:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	57                   	push   %edi
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801551:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801554:	bb 00 00 00 00       	mov    $0x0,%ebx
  801559:	39 f3                	cmp    %esi,%ebx
  80155b:	73 25                	jae    801582 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	89 f0                	mov    %esi,%eax
  801562:	29 d8                	sub    %ebx,%eax
  801564:	50                   	push   %eax
  801565:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801568:	50                   	push   %eax
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	e8 44 ff ff ff       	call   8014b5 <read>
		if (m < 0)
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	85 c0                	test   %eax,%eax
  801576:	78 0c                	js     801584 <readn+0x3f>
			return m;
		if (m == 0)
  801578:	85 c0                	test   %eax,%eax
  80157a:	74 06                	je     801582 <readn+0x3d>
  80157c:	01 c3                	add    %eax,%ebx
  80157e:	39 f3                	cmp    %esi,%ebx
  801580:	72 db                	jb     80155d <readn+0x18>
			break;
	}
	return tot;
  801582:	89 d8                	mov    %ebx,%eax
}
  801584:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801587:	5b                   	pop    %ebx
  801588:	5e                   	pop    %esi
  801589:	5f                   	pop    %edi
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	53                   	push   %ebx
  801590:	83 ec 14             	sub    $0x14,%esp
  801593:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801596:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	53                   	push   %ebx
  80159b:	e8 82 fc ff ff       	call   801222 <fd_lookup>
  8015a0:	89 c2                	mov    %eax,%edx
  8015a2:	83 c4 08             	add    $0x8,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 1a                	js     8015c3 <write+0x37>
  8015a9:	83 ec 08             	sub    $0x8,%esp
  8015ac:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015b3:	ff 30                	pushl  (%eax)
  8015b5:	e8 2a fd ff ff       	call   8012e4 <dev_lookup>
  8015ba:	89 c2                	mov    %eax,%edx
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	79 04                	jns    8015c7 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	eb 4b                	jmp    801612 <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c7:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ce:	75 1e                	jne    8015ee <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	53                   	push   %ebx
  8015d4:	a1 80 64 80 00       	mov    0x806480,%eax
  8015d9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015dc:	50                   	push   %eax
  8015dd:	68 b9 2c 80 00       	push   $0x802cb9
  8015e2:	e8 89 ee ff ff       	call   800470 <cprintf>
		return -E_INVAL;
  8015e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ec:	eb 24                	jmp    801612 <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8015ee:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015f1:	ff 70 04             	pushl  0x4(%eax)
  8015f4:	ff 75 10             	pushl  0x10(%ebp)
  8015f7:	ff 75 0c             	pushl  0xc(%ebp)
  8015fa:	50                   	push   %eax
  8015fb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8015fe:	ff 50 0c             	call   *0xc(%eax)
  801601:	89 c2                	mov    %eax,%edx
	if (r > 0)
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	7e 06                	jle    801610 <write+0x84>
		fd->fd_offset += r;
  80160a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80160d:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801610:	89 d0                	mov    %edx,%eax
}
  801612:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <seek>:

int
seek(int fdnum, off_t offset)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80161d:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801620:	50                   	push   %eax
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	e8 f9 fb ff ff       	call   801222 <fd_lookup>
  801629:	83 c4 08             	add    $0x8,%esp
		return r;
  80162c:	89 c2                	mov    %eax,%edx
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 0e                	js     801640 <seek+0x29>
	fd->fd_offset = offset;
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
  801635:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801638:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801640:	89 d0                	mov    %edx,%eax
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	53                   	push   %ebx
  801648:	83 ec 14             	sub    $0x14,%esp
  80164b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801651:	50                   	push   %eax
  801652:	53                   	push   %ebx
  801653:	e8 ca fb ff ff       	call   801222 <fd_lookup>
  801658:	83 c4 08             	add    $0x8,%esp
  80165b:	85 c0                	test   %eax,%eax
  80165d:	78 4e                	js     8016ad <ftruncate+0x69>
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801665:	50                   	push   %eax
  801666:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801669:	ff 30                	pushl  (%eax)
  80166b:	e8 74 fc ff ff       	call   8012e4 <dev_lookup>
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	85 c0                	test   %eax,%eax
  801675:	78 36                	js     8016ad <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801677:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80167a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80167e:	75 1e                	jne    80169e <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	53                   	push   %ebx
  801684:	a1 80 64 80 00       	mov    0x806480,%eax
  801689:	8b 40 4c             	mov    0x4c(%eax),%eax
  80168c:	50                   	push   %eax
  80168d:	68 7c 2c 80 00       	push   $0x802c7c
  801692:	e8 d9 ed ff ff       	call   800470 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801697:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169c:	eb 0f                	jmp    8016ad <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8016a7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8016aa:	ff 50 1c             	call   *0x1c(%eax)
}
  8016ad:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 14             	sub    $0x14,%esp
  8016b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bc:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	e8 5a fb ff ff       	call   801222 <fd_lookup>
  8016c8:	83 c4 08             	add    $0x8,%esp
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 42                	js     801711 <fstat+0x5f>
  8016cf:	83 ec 08             	sub    $0x8,%esp
  8016d2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016d9:	ff 30                	pushl  (%eax)
  8016db:	e8 04 fc ff ff       	call   8012e4 <dev_lookup>
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 2a                	js     801711 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  8016e7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ea:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f1:	00 00 00 
	stat->st_isdir = 0;
  8016f4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fb:	00 00 00 
	stat->st_dev = dev;
  8016fe:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801701:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	53                   	push   %ebx
  80170b:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80170e:	ff 50 14             	call   *0x14(%eax)
}
  801711:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	56                   	push   %esi
  80171a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	6a 00                	push   $0x0
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 28 00 00 00       	call   801750 <open>
  801728:	89 c6                	mov    %eax,%esi
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	85 f6                	test   %esi,%esi
  80172f:	78 18                	js     801749 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	ff 75 0c             	pushl  0xc(%ebp)
  801737:	56                   	push   %esi
  801738:	e8 75 ff ff ff       	call   8016b2 <fstat>
  80173d:	89 c3                	mov    %eax,%ebx
	close(fd);
  80173f:	89 34 24             	mov    %esi,(%esp)
  801742:	e8 fb fb ff ff       	call   801342 <close>
	return r;
  801747:	89 d8                	mov    %ebx,%eax
}
  801749:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	53                   	push   %ebx
  801754:	83 ec 10             	sub    $0x10,%esp
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
  801757:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80175a:	50                   	push   %eax
  80175b:	e8 68 fa ff ff       	call   8011c8 <fd_alloc>
  801760:	89 c3                	mov    %eax,%ebx
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	85 db                	test   %ebx,%ebx
  801767:	78 36                	js     80179f <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	e8 37 06 00 00       	call   801db1 <fsipc_open>
  80177a:	89 c3                	mov    %eax,%ebx
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	85 c0                	test   %eax,%eax
  801781:	79 11                	jns    801794 <open+0x44>
          fd_close(fd_store, 0);
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	6a 00                	push   $0x0
  801788:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80178b:	e8 e0 fa ff ff       	call   801270 <fd_close>
          return r;
  801790:	89 d8                	mov    %ebx,%eax
  801792:	eb 0b                	jmp    80179f <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80179a:	e8 19 fa ff ff       	call   8011b8 <fd2num>
}
  80179f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8017ae:	6a 01                	push   $0x1
  8017b0:	6a 00                	push   $0x0
  8017b2:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8017b8:	53                   	push   %ebx
  8017b9:	e8 e7 03 00 00       	call   801ba5 <funmap>
  8017be:	83 c4 10             	add    $0x10,%esp
          return r;
  8017c1:	89 c2                	mov    %eax,%edx
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 19                	js     8017e0 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8017c7:	83 ec 0c             	sub    $0xc,%esp
  8017ca:	ff 73 0c             	pushl  0xc(%ebx)
  8017cd:	e8 84 06 00 00       	call   801e56 <fsipc_close>
  8017d2:	83 c4 10             	add    $0x10,%esp
          return r;
  8017d5:	89 c2                	mov    %eax,%edx
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 05                	js     8017e0 <file_close+0x3c>
        }
        return 0;
  8017db:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017e0:	89 d0                	mov    %edx,%eax
  8017e2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	57                   	push   %edi
  8017eb:	56                   	push   %esi
  8017ec:	53                   	push   %ebx
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	8b 75 10             	mov    0x10(%ebp),%esi
  8017f3:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  8017ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801804:	39 d7                	cmp    %edx,%edi
  801806:	0f 87 95 00 00 00    	ja     8018a1 <file_read+0xba>
	if (offset + n > size)
  80180c:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80180f:	39 d0                	cmp    %edx,%eax
  801811:	76 04                	jbe    801817 <file_read+0x30>
		n = size - offset;
  801813:	89 d6                	mov    %edx,%esi
  801815:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801817:	83 ec 0c             	sub    $0xc,%esp
  80181a:	ff 75 08             	pushl  0x8(%ebp)
  80181d:	e8 7e f9 ff ff       	call   8011a0 <fd2data>
  801822:	89 c3                	mov    %eax,%ebx
  801824:	01 fb                	add    %edi,%ebx
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	eb 41                	jmp    80186c <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	c1 e8 16             	shr    $0x16,%eax
  801830:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801837:	a8 01                	test   $0x1,%al
  801839:	74 10                	je     80184b <file_read+0x64>
  80183b:	89 d8                	mov    %ebx,%eax
  80183d:	c1 e8 0c             	shr    $0xc,%eax
  801840:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801847:	a8 01                	test   $0x1,%al
  801849:	75 1b                	jne    801866 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801851:	50                   	push   %eax
  801852:	57                   	push   %edi
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	e8 d4 02 00 00       	call   801b2f <fmap>
  80185b:	83 c4 10             	add    $0x10,%esp
              return r;
  80185e:	89 c1                	mov    %eax,%ecx
  801860:	85 c0                	test   %eax,%eax
  801862:	78 3d                	js     8018a1 <file_read+0xba>
  801864:	eb 1c                	jmp    801882 <file_read+0x9b>
  801866:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80186c:	83 ec 0c             	sub    $0xc,%esp
  80186f:	ff 75 08             	pushl  0x8(%ebp)
  801872:	e8 29 f9 ff ff       	call   8011a0 <fd2data>
  801877:	01 f8                	add    %edi,%eax
  801879:	01 f0                	add    %esi,%eax
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	39 d8                	cmp    %ebx,%eax
  801880:	77 a9                	ja     80182b <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	56                   	push   %esi
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	ff 75 08             	pushl  0x8(%ebp)
  80188c:	e8 0f f9 ff ff       	call   8011a0 <fd2data>
  801891:	83 c4 08             	add    $0x8,%esp
  801894:	01 f8                	add    %edi,%eax
  801896:	50                   	push   %eax
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	e8 51 f3 ff ff       	call   800bf0 <memmove>
	return n;
  80189f:	89 f1                	mov    %esi,%ecx
}
  8018a1:	89 c8                	mov    %ecx,%eax
  8018a3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5f                   	pop    %edi
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 18             	sub    $0x18,%esp
  8018b3:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018b6:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018b9:	50                   	push   %eax
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 60 f9 ff ff       	call   801222 <fd_lookup>
  8018c2:	83 c4 10             	add    $0x10,%esp
		return r;
  8018c5:	89 c2                	mov    %eax,%edx
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	0f 88 9f 00 00 00    	js     80196e <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8018cf:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8018d2:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8018d4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8018d9:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  8018df:	0f 85 89 00 00 00    	jne    80196e <read_map+0xc3>
	va = fd2data(fd) + offset;
  8018e5:	83 ec 0c             	sub    $0xc,%esp
  8018e8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8018eb:	e8 b0 f8 ff ff       	call   8011a0 <fd2data>
  8018f0:	89 c3                	mov    %eax,%ebx
  8018f2:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8018f4:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8018f7:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8018fc:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801902:	7f 6a                	jg     80196e <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801904:	89 d8                	mov    %ebx,%eax
  801906:	c1 e8 16             	shr    $0x16,%eax
  801909:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801910:	a8 01                	test   $0x1,%al
  801912:	74 10                	je     801924 <read_map+0x79>
  801914:	89 d8                	mov    %ebx,%eax
  801916:	c1 e8 0c             	shr    $0xc,%eax
  801919:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801920:	a8 01                	test   $0x1,%al
  801922:	75 19                	jne    80193d <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	8d 46 01             	lea    0x1(%esi),%eax
  80192a:	50                   	push   %eax
  80192b:	56                   	push   %esi
  80192c:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80192f:	e8 fb 01 00 00       	call   801b2f <fmap>
  801934:	83 c4 10             	add    $0x10,%esp
            return r;
  801937:	89 c2                	mov    %eax,%edx
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 31                	js     80196e <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  80193d:	89 d8                	mov    %ebx,%eax
  80193f:	c1 e8 16             	shr    $0x16,%eax
  801942:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801949:	a8 01                	test   $0x1,%al
  80194b:	74 10                	je     80195d <read_map+0xb2>
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	c1 e8 0c             	shr    $0xc,%eax
  801952:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801959:	a8 01                	test   $0x1,%al
  80195b:	75 07                	jne    801964 <read_map+0xb9>
		return -E_NO_DISK;
  80195d:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801962:	eb 0a                	jmp    80196e <read_map+0xc3>

	*blk = (void*) va;
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	89 18                	mov    %ebx,(%eax)
	return 0;
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80196e:	89 d0                	mov    %edx,%eax
  801970:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801973:	5b                   	pop    %ebx
  801974:	5e                   	pop    %esi
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	57                   	push   %edi
  80197b:	56                   	push   %esi
  80197c:	53                   	push   %ebx
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	8b 75 08             	mov    0x8(%ebp),%esi
  801983:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  80198c:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801991:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801997:	0f 87 bd 00 00 00    	ja     801a5a <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  80199d:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8019a3:	73 17                	jae    8019bc <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	52                   	push   %edx
  8019a9:	56                   	push   %esi
  8019aa:	e8 fb 00 00 00       	call   801aaa <file_trunc>
  8019af:	83 c4 10             	add    $0x10,%esp
			return r;
  8019b2:	89 c1                	mov    %eax,%ecx
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	0f 88 9e 00 00 00    	js     801a5a <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	56                   	push   %esi
  8019c0:	e8 db f7 ff ff       	call   8011a0 <fd2data>
  8019c5:	89 c3                	mov    %eax,%ebx
  8019c7:	01 fb                	add    %edi,%ebx
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	eb 42                	jmp    801a10 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8019ce:	89 d8                	mov    %ebx,%eax
  8019d0:	c1 e8 16             	shr    $0x16,%eax
  8019d3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8019da:	a8 01                	test   $0x1,%al
  8019dc:	74 10                	je     8019ee <file_write+0x77>
  8019de:	89 d8                	mov    %ebx,%eax
  8019e0:	c1 e8 0c             	shr    $0xc,%eax
  8019e3:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8019ea:	a8 01                	test   $0x1,%al
  8019ec:	75 1c                	jne    801a0a <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	8b 55 10             	mov    0x10(%ebp),%edx
  8019f4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  8019f7:	50                   	push   %eax
  8019f8:	57                   	push   %edi
  8019f9:	56                   	push   %esi
  8019fa:	e8 30 01 00 00       	call   801b2f <fmap>
  8019ff:	83 c4 10             	add    $0x10,%esp
              return r;
  801a02:	89 c1                	mov    %eax,%ecx
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 52                	js     801a5a <file_write+0xe3>
  801a08:	eb 1b                	jmp    801a25 <file_write+0xae>
  801a0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a10:	83 ec 0c             	sub    $0xc,%esp
  801a13:	56                   	push   %esi
  801a14:	e8 87 f7 ff ff       	call   8011a0 <fd2data>
  801a19:	01 f8                	add    %edi,%eax
  801a1b:	03 45 10             	add    0x10(%ebp),%eax
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	39 d8                	cmp    %ebx,%eax
  801a23:	77 a9                	ja     8019ce <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	68 d6 2c 80 00       	push   $0x802cd6
  801a2d:	e8 3e ea ff ff       	call   800470 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801a32:	83 c4 0c             	add    $0xc,%esp
  801a35:	ff 75 10             	pushl  0x10(%ebp)
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	56                   	push   %esi
  801a3c:	e8 5f f7 ff ff       	call   8011a0 <fd2data>
  801a41:	01 f8                	add    %edi,%eax
  801a43:	89 04 24             	mov    %eax,(%esp)
  801a46:	e8 a5 f1 ff ff       	call   800bf0 <memmove>
        cprintf("write done\n");
  801a4b:	c7 04 24 e3 2c 80 00 	movl   $0x802ce3,(%esp)
  801a52:	e8 19 ea ff ff       	call   800470 <cprintf>
	return n;
  801a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801a5a:	89 c8                	mov    %ecx,%eax
  801a5c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5f                   	pop    %edi
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	56                   	push   %esi
  801a68:	53                   	push   %ebx
  801a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801a6f:	83 ec 08             	sub    $0x8,%esp
  801a72:	8d 43 10             	lea    0x10(%ebx),%eax
  801a75:	50                   	push   %eax
  801a76:	56                   	push   %esi
  801a77:	e8 f8 ef ff ff       	call   800a74 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801a7c:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801a82:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801a92:	0f 94 c0             	sete   %al
  801a95:	0f b6 c0             	movzbl %al,%eax
  801a98:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa3:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	57                   	push   %edi
  801aae:	56                   	push   %esi
  801aaf:	53                   	push   %ebx
  801ab0:	83 ec 0c             	sub    $0xc,%esp
  801ab3:	8b 75 08             	mov    0x8(%ebp),%esi
  801ab6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801ab9:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801abe:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801ac4:	7f 5f                	jg     801b25 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801ac6:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	53                   	push   %ebx
  801ad0:	ff 76 0c             	pushl  0xc(%esi)
  801ad3:	e8 56 03 00 00       	call   801e2e <fsipc_set_size>
  801ad8:	83 c4 10             	add    $0x10,%esp
		return r;
  801adb:	89 c2                	mov    %eax,%edx
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 44                	js     801b25 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801ae1:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801ae7:	74 19                	je     801b02 <file_trunc+0x58>
  801ae9:	68 10 2d 80 00       	push   $0x802d10
  801aee:	68 ef 2c 80 00       	push   $0x802cef
  801af3:	68 dc 00 00 00       	push   $0xdc
  801af8:	68 04 2d 80 00       	push   $0x802d04
  801afd:	e8 7e e8 ff ff       	call   800380 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	53                   	push   %ebx
  801b06:	57                   	push   %edi
  801b07:	56                   	push   %esi
  801b08:	e8 22 00 00 00       	call   801b2f <fmap>
  801b0d:	83 c4 10             	add    $0x10,%esp
		return r;
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 0f                	js     801b25 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	53                   	push   %ebx
  801b19:	57                   	push   %edi
  801b1a:	56                   	push   %esi
  801b1b:	e8 85 00 00 00       	call   801ba5 <funmap>

	return 0;
  801b20:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b25:	89 d0                	mov    %edx,%eax
  801b27:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801b2a:	5b                   	pop    %ebx
  801b2b:	5e                   	pop    %esi
  801b2c:	5f                   	pop    %edi
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <fmap>:

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
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	57                   	push   %edi
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	83 ec 0c             	sub    $0xc,%esp
  801b38:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b3b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801b3e:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801b41:	7d 55                	jge    801b98 <fmap+0x69>
          fma = fd2data(fd);
  801b43:	83 ec 0c             	sub    $0xc,%esp
  801b46:	57                   	push   %edi
  801b47:	e8 54 f6 ff ff       	call   8011a0 <fd2data>
  801b4c:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	05 ff 0f 00 00       	add    $0xfff,%eax
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801b62:	39 f3                	cmp    %esi,%ebx
  801b64:	7d 32                	jge    801b98 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801b6c:	01 d8                	add    %ebx,%eax
  801b6e:	50                   	push   %eax
  801b6f:	53                   	push   %ebx
  801b70:	ff 77 0c             	pushl  0xc(%edi)
  801b73:	e8 8b 02 00 00       	call   801e03 <fsipc_map>
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	79 0f                	jns    801b8e <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	53                   	push   %ebx
  801b85:	57                   	push   %edi
  801b86:	e8 1a 00 00 00       	call   801ba5 <funmap>
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b94:	39 f3                	cmp    %esi,%ebx
  801b96:	7c ce                	jl     801b66 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5f                   	pop    %edi
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <funmap>:

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
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	57                   	push   %edi
  801ba9:	56                   	push   %esi
  801baa:	53                   	push   %ebx
  801bab:	83 ec 0c             	sub    $0xc,%esp
  801bae:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801bb4:	39 f3                	cmp    %esi,%ebx
  801bb6:	0f 8d 80 00 00 00    	jge    801c3c <funmap+0x97>
          fma = fd2data(fd);
  801bbc:	83 ec 0c             	sub    $0xc,%esp
  801bbf:	ff 75 08             	pushl  0x8(%ebp)
  801bc2:	e8 d9 f5 ff ff       	call   8011a0 <fd2data>
  801bc7:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801bc9:	83 c4 10             	add    $0x10,%esp
  801bcc:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801bd2:	89 c3                	mov    %eax,%ebx
  801bd4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801bda:	39 f3                	cmp    %esi,%ebx
  801bdc:	7d 5e                	jge    801c3c <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801bde:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801be1:	89 c2                	mov    %eax,%edx
  801be3:	c1 ea 0c             	shr    $0xc,%edx
  801be6:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801bed:	a8 01                	test   $0x1,%al
  801bef:	74 41                	je     801c32 <funmap+0x8d>
              if (dirty) {
  801bf1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801bf5:	74 21                	je     801c18 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801bf7:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801bfe:	a8 40                	test   $0x40,%al
  801c00:	74 16                	je     801c18 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801c02:	83 ec 08             	sub    $0x8,%esp
  801c05:	53                   	push   %ebx
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	ff 70 0c             	pushl  0xc(%eax)
  801c0c:	e8 65 02 00 00       	call   801e76 <fsipc_dirty>
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	85 c0                	test   %eax,%eax
  801c16:	78 29                	js     801c41 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801c1e:	50                   	push   %eax
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	e8 e1 f1 ff ff       	call   800e08 <sys_getenvid>
  801c27:	89 04 24             	mov    %eax,(%esp)
  801c2a:	e8 9c f2 ff ff       	call   800ecb <sys_page_unmap>
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c38:	39 f3                	cmp    %esi,%ebx
  801c3a:	7c a2                	jl     801bde <funmap+0x39>
            }
          }
        }

        return 0;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c41:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <remove>:

// Delete a file
int
remove(const char *path)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	e8 47 02 00 00       	call   801e9e <fsipc_remove>
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801c5f:	e8 80 02 00 00       	call   801ee4 <fsipc_sync>
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    
	...

00801c68 <writebuf>:


static void
writebuf(struct printbuf *b)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	53                   	push   %ebx
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (b->error > 0) {
  801c72:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
  801c76:	7e 2c                	jle    801ca4 <writebuf+0x3c>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	ff 73 04             	pushl  0x4(%ebx)
  801c7e:	8d 43 10             	lea    0x10(%ebx),%eax
  801c81:	50                   	push   %eax
  801c82:	ff 33                	pushl  (%ebx)
  801c84:	e8 03 f9 ff ff       	call   80158c <write>
		if (result > 0)
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	7e 03                	jle    801c93 <writebuf+0x2b>
			b->result += result;
  801c90:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c93:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c96:	74 0c                	je     801ca4 <writebuf+0x3c>
			b->error = (result < 0 ? result : 0);
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	7e 05                	jle    801ca1 <writebuf+0x39>
  801c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca1:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ca4:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <putch>:

static void
putch(int ch, void *thunk)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	53                   	push   %ebx
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801cb3:	8b 43 04             	mov    0x4(%ebx),%eax
  801cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb9:	88 54 18 10          	mov    %dl,0x10(%eax,%ebx,1)
  801cbd:	40                   	inc    %eax
  801cbe:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801cc1:	3d 00 01 00 00       	cmp    $0x100,%eax
  801cc6:	75 13                	jne    801cdb <putch+0x32>
		writebuf(b);
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	53                   	push   %ebx
  801ccc:	e8 97 ff ff ff       	call   801c68 <writebuf>
		b->idx = 0;
  801cd1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  801cd8:	83 c4 10             	add    $0x10,%esp
	}
}
  801cdb:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	53                   	push   %ebx
  801ce4:	81 ec 14 01 00 00    	sub    $0x114,%esp
	struct printbuf b;

	b.fd = fd;
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	89 85 e8 fe ff ff    	mov    %eax,0xfffffee8(%ebp)
	b.idx = 0;
  801cf3:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  801cfa:	00 00 00 
	b.result = 0;
  801cfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,0xfffffef0(%ebp)
  801d04:	00 00 00 
	b.error = 1;
  801d07:	c7 85 f4 fe ff ff 01 	movl   $0x1,0xfffffef4(%ebp)
  801d0e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d11:	ff 75 10             	pushl  0x10(%ebp)
  801d14:	ff 75 0c             	pushl  0xc(%ebp)
  801d17:	8d 9d e8 fe ff ff    	lea    0xfffffee8(%ebp),%ebx
  801d1d:	53                   	push   %ebx
  801d1e:	68 a9 1c 80 00       	push   $0x801ca9
  801d23:	e8 7a e8 ff ff       	call   8005a2 <vprintfmt>
	if (b.idx > 0)
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	83 bd ec fe ff ff 00 	cmpl   $0x0,0xfffffeec(%ebp)
  801d32:	7e 0c                	jle    801d40 <vfprintf+0x60>
		writebuf(&b);
  801d34:	83 ec 0c             	sub    $0xc,%esp
  801d37:	53                   	push   %ebx
  801d38:	e8 2b ff ff ff       	call   801c68 <writebuf>
  801d3d:	83 c4 10             	add    $0x10,%esp

	return (b.result ? b.result : b.error);
  801d40:	8b 85 f0 fe ff ff    	mov    0xfffffef0(%ebp),%eax
  801d46:	85 c0                	test   %eax,%eax
  801d48:	75 06                	jne    801d50 <vfprintf+0x70>
  801d4a:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
}
  801d50:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d5b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d5e:	50                   	push   %eax
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	e8 76 ff ff ff       	call   801ce0 <vfprintf>
	va_end(ap);

	return cnt;
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <printf>:

int
printf(const char *fmt, ...)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d72:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d75:	50                   	push   %eax
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 01                	push   $0x1
  801d7b:	e8 60 ff ff ff       	call   801ce0 <vfprintf>
	va_end(ap);

	return cnt;
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    
	...

00801d84 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801d8a:	6a 07                	push   $0x7
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	ff 75 08             	pushl  0x8(%ebp)
  801d92:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801d97:	50                   	push   %eax
  801d98:	e8 c6 06 00 00       	call   802463 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801d9d:	83 c4 0c             	add    $0xc,%esp
  801da0:	ff 75 14             	pushl  0x14(%ebp)
  801da3:	ff 75 10             	pushl  0x10(%ebp)
  801da6:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801da9:	50                   	push   %eax
  801daa:	e8 51 06 00 00       	call   802400 <ipc_recv>
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	83 ec 1c             	sub    $0x1c,%esp
  801db9:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801dbc:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801dc1:	56                   	push   %esi
  801dc2:	e8 71 ec ff ff       	call   800a38 <strlen>
  801dc7:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801dca:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801dcf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dd4:	7f 24                	jg     801dfa <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	56                   	push   %esi
  801dda:	53                   	push   %ebx
  801ddb:	e8 94 ec ff ff       	call   800a74 <strcpy>
	req->req_omode = omode;
  801de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de3:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801de9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801dec:	50                   	push   %eax
  801ded:	ff 75 10             	pushl  0x10(%ebp)
  801df0:	53                   	push   %ebx
  801df1:	6a 01                	push   $0x1
  801df3:	e8 8c ff ff ff       	call   801d84 <fsipc>
  801df8:	89 c2                	mov    %eax,%edx
}
  801dfa:	89 d0                	mov    %edx,%eax
  801dfc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e14:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801e19:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e1c:	50                   	push   %eax
  801e1d:	ff 75 10             	pushl  0x10(%ebp)
  801e20:	68 00 30 80 00       	push   $0x803000
  801e25:	6a 02                	push   $0x2
  801e27:	e8 58 ff ff ff       	call   801d84 <fsipc>

	//return -E_UNSPECIFIED;
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3f:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	68 00 30 80 00       	push   $0x803000
  801e4d:	6a 03                	push   $0x3
  801e4f:	e8 30 ff ff ff       	call   801d84 <fsipc>
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	68 00 30 80 00       	push   $0x803000
  801e6d:	6a 04                	push   $0x4
  801e6f:	e8 10 ff ff ff       	call   801d84 <fsipc>
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	68 00 30 80 00       	push   $0x803000
  801e95:	6a 05                	push   $0x5
  801e97:	e8 e8 fe ff ff       	call   801d84 <fsipc>
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	56                   	push   %esi
  801ea2:	53                   	push   %ebx
  801ea3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801ea6:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	53                   	push   %ebx
  801eaf:	e8 84 eb ff ff       	call   800a38 <strlen>
  801eb4:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801eb7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801ebc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ec1:	7f 18                	jg     801edb <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801ec3:	83 ec 08             	sub    $0x8,%esp
  801ec6:	53                   	push   %ebx
  801ec7:	56                   	push   %esi
  801ec8:	e8 a7 eb ff ff       	call   800a74 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	56                   	push   %esi
  801ed2:	6a 06                	push   $0x6
  801ed4:	e8 ab fe ff ff       	call   801d84 <fsipc>
  801ed9:	89 c2                	mov    %eax,%edx
}
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	68 00 30 80 00       	push   $0x803000
  801ef3:	6a 07                	push   $0x7
  801ef5:	e8 8a fe ff ff       	call   801d84 <fsipc>
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <pipe>:
};

int
pipe(int pfd[2])
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	57                   	push   %edi
  801f00:	56                   	push   %esi
  801f01:	53                   	push   %ebx
  801f02:	83 ec 18             	sub    $0x18,%esp
  801f05:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f08:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801f0b:	50                   	push   %eax
  801f0c:	e8 b7 f2 ff ff       	call   8011c8 <fd_alloc>
  801f11:	89 c3                	mov    %eax,%ebx
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	85 c0                	test   %eax,%eax
  801f18:	0f 88 25 01 00 00    	js     802043 <pipe+0x147>
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 07 04 00 00       	push   $0x407
  801f26:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801f29:	6a 00                	push   $0x0
  801f2b:	e8 16 ef ff ff       	call   800e46 <sys_page_alloc>
  801f30:	89 c3                	mov    %eax,%ebx
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	85 c0                	test   %eax,%eax
  801f37:	0f 88 06 01 00 00    	js     802043 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801f43:	50                   	push   %eax
  801f44:	e8 7f f2 ff ff       	call   8011c8 <fd_alloc>
  801f49:	89 c3                	mov    %eax,%ebx
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	0f 88 dd 00 00 00    	js     802033 <pipe+0x137>
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	68 07 04 00 00       	push   $0x407
  801f5e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801f61:	6a 00                	push   $0x0
  801f63:	e8 de ee ff ff       	call   800e46 <sys_page_alloc>
  801f68:	89 c3                	mov    %eax,%ebx
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	0f 88 be 00 00 00    	js     802033 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801f7b:	e8 20 f2 ff ff       	call   8011a0 <fd2data>
  801f80:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f82:	83 c4 0c             	add    $0xc,%esp
  801f85:	68 07 04 00 00       	push   $0x407
  801f8a:	50                   	push   %eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	e8 b4 ee ff ff       	call   800e46 <sys_page_alloc>
  801f92:	89 c3                	mov    %eax,%ebx
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	85 c0                	test   %eax,%eax
  801f99:	0f 88 84 00 00 00    	js     802023 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	68 07 04 00 00       	push   $0x407
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801fad:	e8 ee f1 ff ff       	call   8011a0 <fd2data>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	50                   	push   %eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	56                   	push   %esi
  801fb9:	6a 00                	push   $0x0
  801fbb:	e8 c9 ee ff ff       	call   800e89 <sys_page_map>
  801fc0:	89 c3                	mov    %eax,%ebx
  801fc2:	83 c4 20             	add    $0x20,%esp
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 4c                	js     802015 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fc9:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801fcf:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801fd2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fd4:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801fd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fde:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801fe4:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801fe7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fe9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801fec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801ff9:	e8 ba f1 ff ff       	call   8011b8 <fd2num>
  801ffe:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802000:	83 c4 04             	add    $0x4,%esp
  802003:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802006:	e8 ad f1 ff ff       	call   8011b8 <fd2num>
  80200b:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
  802013:	eb 30                	jmp    802045 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802015:	83 ec 08             	sub    $0x8,%esp
  802018:	56                   	push   %esi
  802019:	6a 00                	push   $0x0
  80201b:	e8 ab ee ff ff       	call   800ecb <sys_page_unmap>
  802020:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  802023:	83 ec 08             	sub    $0x8,%esp
  802026:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802029:	6a 00                	push   $0x0
  80202b:	e8 9b ee ff ff       	call   800ecb <sys_page_unmap>
  802030:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802033:	83 ec 08             	sub    $0x8,%esp
  802036:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802039:	6a 00                	push   $0x0
  80203b:	e8 8b ee ff ff       	call   800ecb <sys_page_unmap>
  802040:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  802043:	89 d8                	mov    %ebx,%eax
}
  802045:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802048:	5b                   	pop    %ebx
  802049:	5e                   	pop    %esi
  80204a:	5f                   	pop    %edi
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	57                   	push   %edi
  802051:	56                   	push   %esi
  802052:	53                   	push   %ebx
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802059:	a1 80 64 80 00       	mov    0x806480,%eax
  80205e:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	e8 50 04 00 00       	call   8024bc <pageref>
  80206c:	89 c3                	mov    %eax,%ebx
  80206e:	89 3c 24             	mov    %edi,(%esp)
  802071:	e8 46 04 00 00       	call   8024bc <pageref>
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	39 c3                	cmp    %eax,%ebx
  80207b:	0f 94 c0             	sete   %al
  80207e:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802081:	8b 0d 80 64 80 00    	mov    0x806480,%ecx
  802087:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80208a:	39 c6                	cmp    %eax,%esi
  80208c:	74 1b                	je     8020a9 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80208e:	83 fa 01             	cmp    $0x1,%edx
  802091:	75 c6                	jne    802059 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802093:	6a 01                	push   $0x1
  802095:	8b 41 58             	mov    0x58(%ecx),%eax
  802098:	50                   	push   %eax
  802099:	56                   	push   %esi
  80209a:	68 38 2d 80 00       	push   $0x802d38
  80209f:	e8 cc e3 ff ff       	call   800470 <cprintf>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	eb b0                	jmp    802059 <_pipeisclosed+0xc>
	}
}
  8020a9:	89 d0                	mov    %edx,%eax
  8020ab:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020ae:	5b                   	pop    %ebx
  8020af:	5e                   	pop    %esi
  8020b0:	5f                   	pop    %edi
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8020bc:	50                   	push   %eax
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	e8 5d f1 ff ff       	call   801222 <fd_lookup>
  8020c5:	83 c4 10             	add    $0x10,%esp
		return r;
  8020c8:	89 c2                	mov    %eax,%edx
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	78 19                	js     8020e7 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8020ce:	83 ec 0c             	sub    $0xc,%esp
  8020d1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020d4:	e8 c7 f0 ff ff       	call   8011a0 <fd2data>
	return _pipeisclosed(fd, p);
  8020d9:	83 c4 08             	add    $0x8,%esp
  8020dc:	50                   	push   %eax
  8020dd:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020e0:	e8 68 ff ff ff       	call   80204d <_pipeisclosed>
  8020e5:	89 c2                	mov    %eax,%edx
}
  8020e7:	89 d0                	mov    %edx,%eax
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	57                   	push   %edi
  8020ef:	56                   	push   %esi
  8020f0:	53                   	push   %ebx
  8020f1:	83 ec 18             	sub    $0x18,%esp
  8020f4:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  8020f7:	57                   	push   %edi
  8020f8:	e8 a3 f0 ff ff       	call   8011a0 <fd2data>
  8020fd:	89 c3                	mov    %eax,%ebx
	if (debug)
  8020ff:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802102:	8b 45 0c             	mov    0xc(%ebp),%eax
  802105:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802108:	be 00 00 00 00       	mov    $0x0,%esi
  80210d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802110:	73 55                	jae    802167 <piperead+0x7c>
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
  802112:	8b 03                	mov    (%ebx),%eax
  802114:	3b 43 04             	cmp    0x4(%ebx),%eax
  802117:	75 2c                	jne    802145 <piperead+0x5a>
  802119:	85 f6                	test   %esi,%esi
  80211b:	74 04                	je     802121 <piperead+0x36>
  80211d:	89 f0                	mov    %esi,%eax
  80211f:	eb 48                	jmp    802169 <piperead+0x7e>
  802121:	83 ec 08             	sub    $0x8,%esp
  802124:	53                   	push   %ebx
  802125:	57                   	push   %edi
  802126:	e8 22 ff ff ff       	call   80204d <_pipeisclosed>
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	85 c0                	test   %eax,%eax
  802130:	74 07                	je     802139 <piperead+0x4e>
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	eb 30                	jmp    802169 <piperead+0x7e>
  802139:	e8 e9 ec ff ff       	call   800e27 <sys_yield>
  80213e:	8b 03                	mov    (%ebx),%eax
  802140:	3b 43 04             	cmp    0x4(%ebx),%eax
  802143:	74 d4                	je     802119 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802145:	8b 13                	mov    (%ebx),%edx
  802147:	89 d0                	mov    %edx,%eax
  802149:	85 d2                	test   %edx,%edx
  80214b:	79 03                	jns    802150 <piperead+0x65>
  80214d:	8d 42 1f             	lea    0x1f(%edx),%eax
  802150:	83 e0 e0             	and    $0xffffffe0,%eax
  802153:	29 c2                	sub    %eax,%edx
  802155:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  802159:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80215c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80215f:	ff 03                	incl   (%ebx)
  802161:	46                   	inc    %esi
  802162:	3b 75 10             	cmp    0x10(%ebp),%esi
  802165:	72 ab                	jb     802112 <piperead+0x27>
	}
	return i;
  802167:	89 f0                	mov    %esi,%eax
}
  802169:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80216c:	5b                   	pop    %ebx
  80216d:	5e                   	pop    %esi
  80216e:	5f                   	pop    %edi
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	57                   	push   %edi
  802175:	56                   	push   %esi
  802176:	53                   	push   %ebx
  802177:	83 ec 18             	sub    $0x18,%esp
  80217a:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  80217d:	57                   	push   %edi
  80217e:	e8 1d f0 ff ff       	call   8011a0 <fd2data>
  802183:	89 c3                	mov    %eax,%ebx
	if (debug)
  802185:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80218e:	be 00 00 00 00       	mov    $0x0,%esi
  802193:	3b 75 10             	cmp    0x10(%ebp),%esi
  802196:	73 55                	jae    8021ed <pipewrite+0x7c>
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
  802198:	8b 03                	mov    (%ebx),%eax
  80219a:	83 c0 20             	add    $0x20,%eax
  80219d:	39 43 04             	cmp    %eax,0x4(%ebx)
  8021a0:	72 27                	jb     8021c9 <pipewrite+0x58>
  8021a2:	83 ec 08             	sub    $0x8,%esp
  8021a5:	53                   	push   %ebx
  8021a6:	57                   	push   %edi
  8021a7:	e8 a1 fe ff ff       	call   80204d <_pipeisclosed>
  8021ac:	83 c4 10             	add    $0x10,%esp
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	74 07                	je     8021ba <pipewrite+0x49>
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	eb 35                	jmp    8021ef <pipewrite+0x7e>
  8021ba:	e8 68 ec ff ff       	call   800e27 <sys_yield>
  8021bf:	8b 03                	mov    (%ebx),%eax
  8021c1:	83 c0 20             	add    $0x20,%eax
  8021c4:	39 43 04             	cmp    %eax,0x4(%ebx)
  8021c7:	73 d9                	jae    8021a2 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021c9:	8b 53 04             	mov    0x4(%ebx),%edx
  8021cc:	89 d0                	mov    %edx,%eax
  8021ce:	85 d2                	test   %edx,%edx
  8021d0:	79 03                	jns    8021d5 <pipewrite+0x64>
  8021d2:	8d 42 1f             	lea    0x1f(%edx),%eax
  8021d5:	83 e0 e0             	and    $0xffffffe0,%eax
  8021d8:	29 c2                	sub    %eax,%edx
  8021da:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8021dd:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8021e0:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021e4:	ff 43 04             	incl   0x4(%ebx)
  8021e7:	46                   	inc    %esi
  8021e8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021eb:	72 ab                	jb     802198 <pipewrite+0x27>
	}
	
	return i;
  8021ed:	89 f0                	mov    %esi,%eax
}
  8021ef:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5f                   	pop    %edi
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	56                   	push   %esi
  8021fb:	53                   	push   %ebx
  8021fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	e8 96 ef ff ff       	call   8011a0 <fd2data>
  80220a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80220c:	83 c4 08             	add    $0x8,%esp
  80220f:	68 4b 2d 80 00       	push   $0x802d4b
  802214:	53                   	push   %ebx
  802215:	e8 5a e8 ff ff       	call   800a74 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80221a:	8b 46 04             	mov    0x4(%esi),%eax
  80221d:	2b 06                	sub    (%esi),%eax
  80221f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802225:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80222c:	00 00 00 
	stat->st_dev = &devpipe;
  80222f:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  802236:	60 80 00 
	return 0;
}
  802239:	b8 00 00 00 00       	mov    $0x0,%eax
  80223e:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	53                   	push   %ebx
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80224f:	53                   	push   %ebx
  802250:	6a 00                	push   $0x0
  802252:	e8 74 ec ff ff       	call   800ecb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802257:	89 1c 24             	mov    %ebx,(%esp)
  80225a:	e8 41 ef ff ff       	call   8011a0 <fd2data>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	50                   	push   %eax
  802263:	6a 00                	push   $0x0
  802265:	e8 61 ec ff ff       	call   800ecb <sys_page_unmap>
}
  80226a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    
	...

00802270 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80227c:	6a 01                	push   $0x1
  80227e:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802281:	50                   	push   %eax
  802282:	e8 fd ea ff ff       	call   800d84 <sys_cputs>
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <getchar>:

int
getchar(void)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80228f:	6a 01                	push   $0x1
  802291:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802294:	50                   	push   %eax
  802295:	6a 00                	push   $0x0
  802297:	e8 19 f2 ff ff       	call   8014b5 <read>
	if (r < 0)
  80229c:	83 c4 10             	add    $0x10,%esp
		return r;
  80229f:	89 c2                	mov    %eax,%edx
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	78 0d                	js     8022b2 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8022a5:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	7e 04                	jle    8022b2 <getchar+0x29>
	return c;
  8022ae:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  8022b2:	89 d0                	mov    %edx,%eax
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <iscons>:


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
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022bc:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8022bf:	50                   	push   %eax
  8022c0:	ff 75 08             	pushl  0x8(%ebp)
  8022c3:	e8 5a ef ff ff       	call   801222 <fd_lookup>
  8022c8:	83 c4 10             	add    $0x10,%esp
		return r;
  8022cb:	89 c2                	mov    %eax,%edx
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	78 11                	js     8022e2 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8022d1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8022d4:	8b 00                	mov    (%eax),%eax
  8022d6:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  8022dc:	0f 94 c0             	sete   %al
  8022df:	0f b6 d0             	movzbl %al,%edx
}
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <opencons>:

int
opencons(void)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022ec:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8022ef:	50                   	push   %eax
  8022f0:	e8 d3 ee ff ff       	call   8011c8 <fd_alloc>
  8022f5:	83 c4 10             	add    $0x10,%esp
		return r;
  8022f8:	89 c2                	mov    %eax,%edx
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	78 3c                	js     80233a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022fe:	83 ec 04             	sub    $0x4,%esp
  802301:	68 07 04 00 00       	push   $0x407
  802306:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802309:	6a 00                	push   $0x0
  80230b:	e8 36 eb ff ff       	call   800e46 <sys_page_alloc>
  802310:	83 c4 10             	add    $0x10,%esp
		return r;
  802313:	89 c2                	mov    %eax,%edx
  802315:	85 c0                	test   %eax,%eax
  802317:	78 21                	js     80233a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802319:	a1 60 60 80 00       	mov    0x806060,%eax
  80231e:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  802321:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  802323:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802326:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80232d:	83 ec 0c             	sub    $0xc,%esp
  802330:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802333:	e8 80 ee ff ff       	call   8011b8 <fd2num>
  802338:	89 c2                	mov    %eax,%edx
}
  80233a:	89 d0                	mov    %edx,%eax
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234d:	74 2a                	je     802379 <cons_read+0x3b>
  80234f:	eb 05                	jmp    802356 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802351:	e8 d1 ea ff ff       	call   800e27 <sys_yield>
  802356:	e8 4d ea ff ff       	call   800da8 <sys_cgetc>
  80235b:	89 c2                	mov    %eax,%edx
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 f0                	je     802351 <cons_read+0x13>
	if (c < 0)
  802361:	85 d2                	test   %edx,%edx
  802363:	78 14                	js     802379 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
  80236a:	83 fa 04             	cmp    $0x4,%edx
  80236d:	74 0a                	je     802379 <cons_read+0x3b>
	*(char*)vbuf = c;
  80236f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802372:	88 10                	mov    %dl,(%eax)
	return 1;
  802374:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	57                   	push   %edi
  80237f:	56                   	push   %esi
  802380:	53                   	push   %ebx
  802381:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802387:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80238a:	be 00 00 00 00       	mov    $0x0,%esi
  80238f:	39 fe                	cmp    %edi,%esi
  802391:	73 3d                	jae    8023d0 <cons_write+0x55>
		m = n - tot;
  802393:	89 fb                	mov    %edi,%ebx
  802395:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802397:	83 fb 7f             	cmp    $0x7f,%ebx
  80239a:	76 05                	jbe    8023a1 <cons_write+0x26>
			m = sizeof(buf) - 1;
  80239c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023a1:	83 ec 04             	sub    $0x4,%esp
  8023a4:	53                   	push   %ebx
  8023a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a8:	01 f0                	add    %esi,%eax
  8023aa:	50                   	push   %eax
  8023ab:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8023b1:	50                   	push   %eax
  8023b2:	e8 39 e8 ff ff       	call   800bf0 <memmove>
		sys_cputs(buf, m);
  8023b7:	83 c4 08             	add    $0x8,%esp
  8023ba:	53                   	push   %ebx
  8023bb:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8023c1:	50                   	push   %eax
  8023c2:	e8 bd e9 ff ff       	call   800d84 <sys_cputs>
  8023c7:	83 c4 10             	add    $0x10,%esp
  8023ca:	01 de                	add    %ebx,%esi
  8023cc:	39 fe                	cmp    %edi,%esi
  8023ce:	72 c3                	jb     802393 <cons_write+0x18>
	}
	return tot;
}
  8023d0:	89 f0                	mov    %esi,%eax
  8023d2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5f                   	pop    %edi
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <cons_close>:

int
cons_close(struct Fd *fd)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023ea:	68 57 2d 80 00       	push   $0x802d57
  8023ef:	ff 75 0c             	pushl  0xc(%ebp)
  8023f2:	e8 7d e6 ff ff       	call   800a74 <strcpy>
	return 0;
}
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    
	...

00802400 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	56                   	push   %esi
  802404:	53                   	push   %ebx
  802405:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240b:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80240e:	85 c0                	test   %eax,%eax
  802410:	75 12                	jne    802424 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	68 00 00 c0 ee       	push   $0xeec00000
  80241a:	e8 d7 eb ff ff       	call   800ff6 <sys_ipc_recv>
  80241f:	83 c4 10             	add    $0x10,%esp
  802422:	eb 0c                	jmp    802430 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802424:	83 ec 0c             	sub    $0xc,%esp
  802427:	50                   	push   %eax
  802428:	e8 c9 eb ff ff       	call   800ff6 <sys_ipc_recv>
  80242d:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802430:	89 c2                	mov    %eax,%edx
  802432:	85 c0                	test   %eax,%eax
  802434:	78 24                	js     80245a <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802436:	85 db                	test   %ebx,%ebx
  802438:	74 0a                	je     802444 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  80243a:	a1 80 64 80 00       	mov    0x806480,%eax
  80243f:	8b 40 74             	mov    0x74(%eax),%eax
  802442:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802444:	85 f6                	test   %esi,%esi
  802446:	74 0a                	je     802452 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802448:	a1 80 64 80 00       	mov    0x806480,%eax
  80244d:	8b 40 78             	mov    0x78(%eax),%eax
  802450:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802452:	a1 80 64 80 00       	mov    0x806480,%eax
  802457:	8b 50 70             	mov    0x70(%eax),%edx

}
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <ipc_send>:

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
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	57                   	push   %edi
  802467:	56                   	push   %esi
  802468:	53                   	push   %ebx
  802469:	83 ec 0c             	sub    $0xc,%esp
  80246c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80246f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802472:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802475:	85 db                	test   %ebx,%ebx
  802477:	75 0a                	jne    802483 <ipc_send+0x20>
    pg = (void *) UTOP;
  802479:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80247e:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802483:	56                   	push   %esi
  802484:	53                   	push   %ebx
  802485:	57                   	push   %edi
  802486:	ff 75 08             	pushl  0x8(%ebp)
  802489:	e8 45 eb ff ff       	call   800fd3 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802494:	75 07                	jne    80249d <ipc_send+0x3a>
      sys_yield();
  802496:	e8 8c e9 ff ff       	call   800e27 <sys_yield>
  80249b:	eb e6                	jmp    802483 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  80249d:	85 c0                	test   %eax,%eax
  80249f:	79 12                	jns    8024b3 <ipc_send+0x50>
  8024a1:	50                   	push   %eax
  8024a2:	68 5e 2d 80 00       	push   $0x802d5e
  8024a7:	6a 49                	push   $0x49
  8024a9:	68 7b 2d 80 00       	push   $0x802d7b
  8024ae:	e8 cd de ff ff       	call   800380 <_panic>
    else break;
  }
}
  8024b3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8024b6:	5b                   	pop    %ebx
  8024b7:	5e                   	pop    %esi
  8024b8:	5f                   	pop    %edi
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    
	...

008024bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8024c2:	89 c8                	mov    %ecx,%eax
  8024c4:	c1 e8 16             	shr    $0x16,%eax
  8024c7:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8024ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d3:	a8 01                	test   $0x1,%al
  8024d5:	74 28                	je     8024ff <pageref+0x43>
	pte = vpt[VPN(v)];
  8024d7:	89 c8                	mov    %ecx,%eax
  8024d9:	c1 e8 0c             	shr    $0xc,%eax
  8024dc:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8024e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e8:	a8 01                	test   $0x1,%al
  8024ea:	74 13                	je     8024ff <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8024ec:	c1 e8 0c             	shr    $0xc,%eax
  8024ef:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8024f2:	c1 e0 02             	shl    $0x2,%eax
  8024f5:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8024fc:	0f b7 d0             	movzwl %ax,%edx
}
  8024ff:	89 d0                	mov    %edx,%eax
  802501:	c9                   	leave  
  802502:	c3                   	ret    
	...

00802504 <__udivdi3>:
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	57                   	push   %edi
  802508:	56                   	push   %esi
  802509:	83 ec 14             	sub    $0x14,%esp
  80250c:	8b 55 14             	mov    0x14(%ebp),%edx
  80250f:	8b 75 08             	mov    0x8(%ebp),%esi
  802512:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802515:	8b 45 10             	mov    0x10(%ebp),%eax
  802518:	85 d2                	test   %edx,%edx
  80251a:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80251d:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802520:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802523:	89 fe                	mov    %edi,%esi
  802525:	75 11                	jne    802538 <__udivdi3+0x34>
  802527:	39 f8                	cmp    %edi,%eax
  802529:	76 4d                	jbe    802578 <__udivdi3+0x74>
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802530:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802533:	89 c7                	mov    %eax,%edi
  802535:	eb 09                	jmp    802540 <__udivdi3+0x3c>
  802537:	90                   	nop    
  802538:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80253b:	76 17                	jbe    802554 <__udivdi3+0x50>
  80253d:	31 ff                	xor    %edi,%edi
  80253f:	90                   	nop    
  802540:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802547:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80254a:	83 c4 14             	add    $0x14,%esp
  80254d:	5e                   	pop    %esi
  80254e:	89 f8                	mov    %edi,%eax
  802550:	5f                   	pop    %edi
  802551:	c9                   	leave  
  802552:	c3                   	ret    
  802553:	90                   	nop    
  802554:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802558:	89 c7                	mov    %eax,%edi
  80255a:	83 f7 1f             	xor    $0x1f,%edi
  80255d:	75 4d                	jne    8025ac <__udivdi3+0xa8>
  80255f:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802562:	77 0a                	ja     80256e <__udivdi3+0x6a>
  802564:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802567:	31 ff                	xor    %edi,%edi
  802569:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  80256c:	72 d2                	jb     802540 <__udivdi3+0x3c>
  80256e:	bf 01 00 00 00       	mov    $0x1,%edi
  802573:	eb cb                	jmp    802540 <__udivdi3+0x3c>
  802575:	8d 76 00             	lea    0x0(%esi),%esi
  802578:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	75 0e                	jne    80258d <__udivdi3+0x89>
  80257f:	b8 01 00 00 00       	mov    $0x1,%eax
  802584:	31 c9                	xor    %ecx,%ecx
  802586:	31 d2                	xor    %edx,%edx
  802588:	f7 f1                	div    %ecx
  80258a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80258d:	89 f0                	mov    %esi,%eax
  80258f:	31 d2                	xor    %edx,%edx
  802591:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802594:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802597:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80259a:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80259d:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8025a0:	83 c4 14             	add    $0x14,%esp
  8025a3:	89 c7                	mov    %eax,%edi
  8025a5:	5e                   	pop    %esi
  8025a6:	89 f8                	mov    %edi,%eax
  8025a8:	5f                   	pop    %edi
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    
  8025ab:	90                   	nop    
  8025ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b1:	29 f8                	sub    %edi,%eax
  8025b3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8025b6:	89 f9                	mov    %edi,%ecx
  8025b8:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8025bb:	d3 e2                	shl    %cl,%edx
  8025bd:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8025c0:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8025c3:	d3 e8                	shr    %cl,%eax
  8025c5:	09 c2                	or     %eax,%edx
  8025c7:	89 f9                	mov    %edi,%ecx
  8025c9:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8025cc:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8025cf:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8025d2:	89 f2                	mov    %esi,%edx
  8025d4:	d3 ea                	shr    %cl,%edx
  8025d6:	89 f9                	mov    %edi,%ecx
  8025d8:	d3 e6                	shl    %cl,%esi
  8025da:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8025dd:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8025e0:	d3 e8                	shr    %cl,%eax
  8025e2:	09 c6                	or     %eax,%esi
  8025e4:	89 f9                	mov    %edi,%ecx
  8025e6:	89 f0                	mov    %esi,%eax
  8025e8:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8025eb:	89 d6                	mov    %edx,%esi
  8025ed:	89 c7                	mov    %eax,%edi
  8025ef:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8025f2:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8025f5:	f7 e7                	mul    %edi
  8025f7:	39 f2                	cmp    %esi,%edx
  8025f9:	77 0f                	ja     80260a <__udivdi3+0x106>
  8025fb:	0f 85 3f ff ff ff    	jne    802540 <__udivdi3+0x3c>
  802601:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802604:	0f 86 36 ff ff ff    	jbe    802540 <__udivdi3+0x3c>
  80260a:	4f                   	dec    %edi
  80260b:	e9 30 ff ff ff       	jmp    802540 <__udivdi3+0x3c>

00802610 <__umoddi3>:
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	57                   	push   %edi
  802614:	56                   	push   %esi
  802615:	83 ec 30             	sub    $0x30,%esp
  802618:	8b 55 14             	mov    0x14(%ebp),%edx
  80261b:	8b 45 10             	mov    0x10(%ebp),%eax
  80261e:	89 d7                	mov    %edx,%edi
  802620:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802623:	89 c6                	mov    %eax,%esi
  802625:	8b 55 0c             	mov    0xc(%ebp),%edx
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	85 ff                	test   %edi,%edi
  80262d:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802634:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80263b:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  80263e:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802641:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802644:	75 3e                	jne    802684 <__umoddi3+0x74>
  802646:	39 d6                	cmp    %edx,%esi
  802648:	0f 86 a2 00 00 00    	jbe    8026f0 <__umoddi3+0xe0>
  80264e:	f7 f6                	div    %esi
  802650:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802653:	85 c9                	test   %ecx,%ecx
  802655:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802658:	74 1b                	je     802675 <__umoddi3+0x65>
  80265a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80265d:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802660:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802667:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80266a:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  80266d:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802670:	89 10                	mov    %edx,(%eax)
  802672:	89 48 04             	mov    %ecx,0x4(%eax)
  802675:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802678:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80267b:	83 c4 30             	add    $0x30,%esp
  80267e:	5e                   	pop    %esi
  80267f:	5f                   	pop    %edi
  802680:	c9                   	leave  
  802681:	c3                   	ret    
  802682:	89 f6                	mov    %esi,%esi
  802684:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802687:	76 1f                	jbe    8026a8 <__umoddi3+0x98>
  802689:	8b 55 08             	mov    0x8(%ebp),%edx
  80268c:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80268f:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802692:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802695:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802698:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80269b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  80269e:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8026a1:	83 c4 30             	add    $0x30,%esp
  8026a4:	5e                   	pop    %esi
  8026a5:	5f                   	pop    %edi
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    
  8026a8:	0f bd c7             	bsr    %edi,%eax
  8026ab:	83 f0 1f             	xor    $0x1f,%eax
  8026ae:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8026b1:	75 61                	jne    802714 <__umoddi3+0x104>
  8026b3:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8026b6:	77 05                	ja     8026bd <__umoddi3+0xad>
  8026b8:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8026bb:	72 10                	jb     8026cd <__umoddi3+0xbd>
  8026bd:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8026c0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8026c3:	29 f0                	sub    %esi,%eax
  8026c5:	19 fa                	sbb    %edi,%edx
  8026c7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8026ca:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8026cd:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8026d0:	85 d2                	test   %edx,%edx
  8026d2:	74 a1                	je     802675 <__umoddi3+0x65>
  8026d4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8026d7:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8026da:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8026dd:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8026e0:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8026e3:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8026e6:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8026e9:	89 01                	mov    %eax,(%ecx)
  8026eb:	89 51 04             	mov    %edx,0x4(%ecx)
  8026ee:	eb 85                	jmp    802675 <__umoddi3+0x65>
  8026f0:	85 f6                	test   %esi,%esi
  8026f2:	75 0b                	jne    8026ff <__umoddi3+0xef>
  8026f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f9:	31 d2                	xor    %edx,%edx
  8026fb:	f7 f6                	div    %esi
  8026fd:	89 c6                	mov    %eax,%esi
  8026ff:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802702:	89 fa                	mov    %edi,%edx
  802704:	f7 f6                	div    %esi
  802706:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802709:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80270c:	f7 f6                	div    %esi
  80270e:	e9 3d ff ff ff       	jmp    802650 <__umoddi3+0x40>
  802713:	90                   	nop    
  802714:	b8 20 00 00 00       	mov    $0x20,%eax
  802719:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  80271c:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  80271f:	89 fa                	mov    %edi,%edx
  802721:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802724:	d3 e2                	shl    %cl,%edx
  802726:	89 f0                	mov    %esi,%eax
  802728:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80272b:	d3 e8                	shr    %cl,%eax
  80272d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802730:	d3 e6                	shl    %cl,%esi
  802732:	89 d7                	mov    %edx,%edi
  802734:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802737:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80273a:	09 c7                	or     %eax,%edi
  80273c:	d3 ea                	shr    %cl,%edx
  80273e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802741:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802744:	d3 e0                	shl    %cl,%eax
  802746:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802749:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80274c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80274f:	d3 e8                	shr    %cl,%eax
  802751:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802754:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802757:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80275a:	f7 f7                	div    %edi
  80275c:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80275f:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802762:	f7 e6                	mul    %esi
  802764:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802767:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  80276a:	77 0a                	ja     802776 <__umoddi3+0x166>
  80276c:	75 12                	jne    802780 <__umoddi3+0x170>
  80276e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802771:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802774:	76 0a                	jbe    802780 <__umoddi3+0x170>
  802776:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802779:	29 f1                	sub    %esi,%ecx
  80277b:	19 fa                	sbb    %edi,%edx
  80277d:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802780:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	0f 84 ea fe ff ff    	je     802675 <__umoddi3+0x65>
  80278b:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80278e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802791:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802794:	19 d1                	sbb    %edx,%ecx
  802796:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802799:	89 ca                	mov    %ecx,%edx
  80279b:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80279e:	d3 e2                	shl    %cl,%edx
  8027a0:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8027a3:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8027a6:	d3 e8                	shr    %cl,%eax
  8027a8:	09 c2                	or     %eax,%edx
  8027aa:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8027ad:	d3 e8                	shr    %cl,%eax
  8027af:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8027b2:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8027b5:	e9 ad fe ff ff       	jmp    802667 <__umoddi3+0x57>
