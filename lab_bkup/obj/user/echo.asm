
obj/user/echo:     file format elf32-i386

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
  80002c:	e8 a7 00 00 00       	call   8000d8 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 0c             	sub    $0xc,%esp
  80003d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800040:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80004a:	83 ff 01             	cmp    $0x1,%edi
  80004d:	7e 22                	jle    800071 <umain+0x3d>
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	68 60 24 80 00       	push   $0x802460
  800057:	ff 76 04             	pushl  0x4(%esi)
  80005a:	e8 92 02 00 00       	call   8002f1 <strcmp>
  80005f:	83 c4 10             	add    $0x10,%esp
  800062:	85 c0                	test   %eax,%eax
  800064:	75 0b                	jne    800071 <umain+0x3d>
		nflag = 1;
  800066:	c7 45 f0 01 00 00 00 	movl   $0x1,0xfffffff0(%ebp)
		argc--;
  80006d:	4f                   	dec    %edi
		argv++;
  80006e:	83 c6 04             	add    $0x4,%esi
	}
	for (i = 1; i < argc; i++) {
  800071:	bb 01 00 00 00       	mov    $0x1,%ebx
  800076:	39 fb                	cmp    %edi,%ebx
  800078:	7d 3a                	jge    8000b4 <umain+0x80>
		if (i > 1)
  80007a:	83 fb 01             	cmp    $0x1,%ebx
  80007d:	7e 14                	jle    800093 <umain+0x5f>
			write(1, " ", 1);
  80007f:	83 ec 04             	sub    $0x4,%esp
  800082:	6a 01                	push   $0x1
  800084:	68 a5 26 80 00       	push   $0x8026a5
  800089:	6a 01                	push   $0x1
  80008b:	e8 f8 0c 00 00       	call   800d88 <write>
  800090:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800099:	e8 96 01 00 00       	call   800234 <strlen>
  80009e:	83 c4 0c             	add    $0xc,%esp
  8000a1:	50                   	push   %eax
  8000a2:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a5:	6a 01                	push   $0x1
  8000a7:	e8 dc 0c 00 00       	call   800d88 <write>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	43                   	inc    %ebx
  8000b0:	39 fb                	cmp    %edi,%ebx
  8000b2:	7c c6                	jl     80007a <umain+0x46>
	}
	if (!nflag)
  8000b4:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8000b8:	75 14                	jne    8000ce <umain+0x9a>
		write(1, "\n", 1);
  8000ba:	83 ec 04             	sub    $0x4,%esp
  8000bd:	6a 01                	push   $0x1
  8000bf:	68 71 26 80 00       	push   $0x802671
  8000c4:	6a 01                	push   $0x1
  8000c6:	e8 bd 0c 00 00       	call   800d88 <write>
  8000cb:	83 c4 10             	add    $0x10,%esp
}
  8000ce:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5f                   	pop    %edi
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
	...

008000d8 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8000e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8000e3:	e8 1c 05 00 00       	call   800604 <sys_getenvid>
  8000e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ed:	c1 e0 07             	shl    $0x7,%eax
  8000f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f5:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fa:	85 f6                	test   %esi,%esi
  8000fc:	7e 07                	jle    800105 <libmain+0x2d>
		binaryname = argv[0];
  8000fe:	8b 03                	mov    (%ebx),%eax
  800100:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800105:	83 ec 08             	sub    $0x8,%esp
  800108:	53                   	push   %ebx
  800109:	56                   	push   %esi
  80010a:	e8 25 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80010f:	e8 08 00 00 00       	call   80011c <exit>
}
  800114:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800117:	5b                   	pop    %ebx
  800118:	5e                   	pop    %esi
  800119:	c9                   	leave  
  80011a:	c3                   	ret    
	...

0080011c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800122:	e8 45 0a 00 00       	call   800b6c <close_all>
	sys_env_destroy(0);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	6a 00                	push   $0x0
  80012c:	e8 92 04 00 00       	call   8005c3 <sys_env_destroy>
}
  800131:	c9                   	leave  
  800132:	c3                   	ret    
	...

00800134 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	56                   	push   %esi
  800140:	e8 ef 00 00 00       	call   800234 <strlen>
  char letter;
  int hexnum = 0;
  800145:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80014a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	89 c2                	mov    %eax,%edx
  800154:	4a                   	dec    %edx
  800155:	0f 88 d0 00 00 00    	js     80022b <strtoint+0xf7>
    letter = string[cidx];
  80015b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80015e:	85 d2                	test   %edx,%edx
  800160:	75 12                	jne    800174 <strtoint+0x40>
      if (letter != '0') {
  800162:	3c 30                	cmp    $0x30,%al
  800164:	0f 84 ba 00 00 00    	je     800224 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80016a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80016f:	e9 b9 00 00 00       	jmp    80022d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800174:	83 fa 01             	cmp    $0x1,%edx
  800177:	75 12                	jne    80018b <strtoint+0x57>
      if (letter != 'x') {
  800179:	3c 78                	cmp    $0x78,%al
  80017b:	0f 84 a3 00 00 00    	je     800224 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800186:	e9 a2 00 00 00       	jmp    80022d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80018b:	0f be c0             	movsbl %al,%eax
  80018e:	83 e8 30             	sub    $0x30,%eax
  800191:	83 f8 36             	cmp    $0x36,%eax
  800194:	0f 87 80 00 00 00    	ja     80021a <strtoint+0xe6>
  80019a:	ff 24 85 7c 24 80 00 	jmp    *0x80247c(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8001a1:	01 cb                	add    %ecx,%ebx
          break;
  8001a3:	eb 7c                	jmp    800221 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8001a5:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8001a8:	eb 77                	jmp    800221 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8001aa:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8001ad:	01 c3                	add    %eax,%ebx
          break;
  8001af:	eb 70                	jmp    800221 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8001b1:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8001b4:	eb 6b                	jmp    800221 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8001b6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8001b9:	01 c3                	add    %eax,%ebx
          break;
  8001bb:	eb 64                	jmp    800221 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8001bd:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8001c0:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8001c3:	eb 5c                	jmp    800221 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8001c5:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8001cc:	29 c8                	sub    %ecx,%eax
  8001ce:	01 c3                	add    %eax,%ebx
          break;
  8001d0:	eb 4f                	jmp    800221 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8001d2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8001d5:	eb 4a                	jmp    800221 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8001d7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8001da:	01 c3                	add    %eax,%ebx
          break;
  8001dc:	eb 43                	jmp    800221 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8001de:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8001e1:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8001e4:	eb 3b                	jmp    800221 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8001e6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8001e9:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8001ec:	01 c3                	add    %eax,%ebx
          break;
  8001ee:	eb 31                	jmp    800221 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8001f0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8001f3:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8001f6:	eb 29                	jmp    800221 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8001f8:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8001fb:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  8001fe:	01 c3                	add    %eax,%ebx
          break;
  800200:	eb 1f                	jmp    800221 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800202:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800209:	29 c8                	sub    %ecx,%eax
  80020b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80020e:	eb 11                	jmp    800221 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800210:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800213:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800216:	01 c3                	add    %eax,%ebx
          break;
  800218:	eb 07                	jmp    800221 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80021a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80021f:	eb 0c                	jmp    80022d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800221:	c1 e1 04             	shl    $0x4,%ecx
  800224:	4a                   	dec    %edx
  800225:	0f 89 30 ff ff ff    	jns    80015b <strtoint+0x27>
    }
  }

  return hexnum;
  80022b:	89 d8                	mov    %ebx,%eax
}
  80022d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800230:	5b                   	pop    %ebx
  800231:	5e                   	pop    %esi
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <strlen>:





int
strlen(const char *s)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80023a:	b8 00 00 00 00       	mov    $0x0,%eax
  80023f:	80 3a 00             	cmpb   $0x0,(%edx)
  800242:	74 07                	je     80024b <strlen+0x17>
		n++;
  800244:	40                   	inc    %eax
  800245:	42                   	inc    %edx
  800246:	80 3a 00             	cmpb   $0x0,(%edx)
  800249:	75 f9                	jne    800244 <strlen+0x10>
	return n;
}
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800253:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	85 d2                	test   %edx,%edx
  80025d:	74 0f                	je     80026e <strnlen+0x21>
  80025f:	80 39 00             	cmpb   $0x0,(%ecx)
  800262:	74 0a                	je     80026e <strnlen+0x21>
		n++;
  800264:	40                   	inc    %eax
  800265:	41                   	inc    %ecx
  800266:	4a                   	dec    %edx
  800267:	74 05                	je     80026e <strnlen+0x21>
  800269:	80 39 00             	cmpb   $0x0,(%ecx)
  80026c:	75 f6                	jne    800264 <strnlen+0x17>
	return n;
}
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	53                   	push   %ebx
  800274:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800277:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80027a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  80027c:	8a 02                	mov    (%edx),%al
  80027e:	42                   	inc    %edx
  80027f:	88 01                	mov    %al,(%ecx)
  800281:	41                   	inc    %ecx
  800282:	84 c0                	test   %al,%al
  800284:	75 f6                	jne    80027c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800286:	89 d8                	mov    %ebx,%eax
  800288:	5b                   	pop    %ebx
  800289:	c9                   	leave  
  80028a:	c3                   	ret    

0080028b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	57                   	push   %edi
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
  800291:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800294:	8b 55 0c             	mov    0xc(%ebp),%edx
  800297:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  80029a:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  80029c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a1:	39 f3                	cmp    %esi,%ebx
  8002a3:	73 10                	jae    8002b5 <strncpy+0x2a>
		*dst++ = *src;
  8002a5:	8a 02                	mov    (%edx),%al
  8002a7:	88 01                	mov    %al,(%ecx)
  8002a9:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8002aa:	80 3a 01             	cmpb   $0x1,(%edx)
  8002ad:	83 da ff             	sbb    $0xffffffff,%edx
  8002b0:	43                   	inc    %ebx
  8002b1:	39 f3                	cmp    %esi,%ebx
  8002b3:	72 f0                	jb     8002a5 <strncpy+0x1a>
	}
	return ret;
}
  8002b5:	89 f8                	mov    %edi,%eax
  8002b7:	5b                   	pop    %ebx
  8002b8:	5e                   	pop    %esi
  8002b9:	5f                   	pop    %edi
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c7:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  8002ca:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8002cc:	85 d2                	test   %edx,%edx
  8002ce:	74 19                	je     8002e9 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8002d0:	4a                   	dec    %edx
  8002d1:	74 13                	je     8002e6 <strlcpy+0x2a>
  8002d3:	80 39 00             	cmpb   $0x0,(%ecx)
  8002d6:	74 0e                	je     8002e6 <strlcpy+0x2a>
  8002d8:	8a 01                	mov    (%ecx),%al
  8002da:	41                   	inc    %ecx
  8002db:	88 03                	mov    %al,(%ebx)
  8002dd:	43                   	inc    %ebx
  8002de:	4a                   	dec    %edx
  8002df:	74 05                	je     8002e6 <strlcpy+0x2a>
  8002e1:	80 39 00             	cmpb   $0x0,(%ecx)
  8002e4:	75 f2                	jne    8002d8 <strlcpy+0x1c>
		*dst = '\0';
  8002e6:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8002e9:	89 d8                	mov    %ebx,%eax
  8002eb:	29 f0                	sub    %esi,%eax
}
  8002ed:	5b                   	pop    %ebx
  8002ee:	5e                   	pop    %esi
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  8002fa:	80 3a 00             	cmpb   $0x0,(%edx)
  8002fd:	74 13                	je     800312 <strcmp+0x21>
  8002ff:	8a 02                	mov    (%edx),%al
  800301:	3a 01                	cmp    (%ecx),%al
  800303:	75 0d                	jne    800312 <strcmp+0x21>
  800305:	42                   	inc    %edx
  800306:	41                   	inc    %ecx
  800307:	80 3a 00             	cmpb   $0x0,(%edx)
  80030a:	74 06                	je     800312 <strcmp+0x21>
  80030c:	8a 02                	mov    (%edx),%al
  80030e:	3a 01                	cmp    (%ecx),%al
  800310:	74 f3                	je     800305 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800312:	0f b6 02             	movzbl (%edx),%eax
  800315:	0f b6 11             	movzbl (%ecx),%edx
  800318:	29 d0                	sub    %edx,%eax
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	53                   	push   %ebx
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800326:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800329:	85 c9                	test   %ecx,%ecx
  80032b:	74 1f                	je     80034c <strncmp+0x30>
  80032d:	80 3a 00             	cmpb   $0x0,(%edx)
  800330:	74 16                	je     800348 <strncmp+0x2c>
  800332:	8a 02                	mov    (%edx),%al
  800334:	3a 03                	cmp    (%ebx),%al
  800336:	75 10                	jne    800348 <strncmp+0x2c>
  800338:	42                   	inc    %edx
  800339:	43                   	inc    %ebx
  80033a:	49                   	dec    %ecx
  80033b:	74 0f                	je     80034c <strncmp+0x30>
  80033d:	80 3a 00             	cmpb   $0x0,(%edx)
  800340:	74 06                	je     800348 <strncmp+0x2c>
  800342:	8a 02                	mov    (%edx),%al
  800344:	3a 03                	cmp    (%ebx),%al
  800346:	74 f0                	je     800338 <strncmp+0x1c>
	if (n == 0)
  800348:	85 c9                	test   %ecx,%ecx
  80034a:	75 07                	jne    800353 <strncmp+0x37>
		return 0;
  80034c:	b8 00 00 00 00       	mov    $0x0,%eax
  800351:	eb 0a                	jmp    80035d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800353:	0f b6 12             	movzbl (%edx),%edx
  800356:	0f b6 03             	movzbl (%ebx),%eax
  800359:	29 c2                	sub    %eax,%edx
  80035b:	89 d0                	mov    %edx,%eax
}
  80035d:	5b                   	pop    %ebx
  80035e:	c9                   	leave  
  80035f:	c3                   	ret    

00800360 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	8b 45 08             	mov    0x8(%ebp),%eax
  800366:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800369:	80 38 00             	cmpb   $0x0,(%eax)
  80036c:	74 0a                	je     800378 <strchr+0x18>
		if (*s == c)
  80036e:	38 10                	cmp    %dl,(%eax)
  800370:	74 0b                	je     80037d <strchr+0x1d>
  800372:	40                   	inc    %eax
  800373:	80 38 00             	cmpb   $0x0,(%eax)
  800376:	75 f6                	jne    80036e <strchr+0xe>
			return (char *) s;
	return 0;
  800378:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	8b 45 08             	mov    0x8(%ebp),%eax
  800385:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800388:	80 38 00             	cmpb   $0x0,(%eax)
  80038b:	74 0a                	je     800397 <strfind+0x18>
		if (*s == c)
  80038d:	38 10                	cmp    %dl,(%eax)
  80038f:	74 06                	je     800397 <strfind+0x18>
  800391:	40                   	inc    %eax
  800392:	80 38 00             	cmpb   $0x0,(%eax)
  800395:	75 f6                	jne    80038d <strfind+0xe>
			break;
	return (char *) s;
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	57                   	push   %edi
  80039d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8003a3:	89 f8                	mov    %edi,%eax
  8003a5:	85 c9                	test   %ecx,%ecx
  8003a7:	74 40                	je     8003e9 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  8003a9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8003af:	75 30                	jne    8003e1 <memset+0x48>
  8003b1:	f6 c1 03             	test   $0x3,%cl
  8003b4:	75 2b                	jne    8003e1 <memset+0x48>
		c &= 0xFF;
  8003b6:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	c1 e0 18             	shl    $0x18,%eax
  8003c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c6:	c1 e2 10             	shl    $0x10,%edx
  8003c9:	09 d0                	or     %edx,%eax
  8003cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ce:	c1 e2 08             	shl    $0x8,%edx
  8003d1:	09 d0                	or     %edx,%eax
  8003d3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  8003d6:	c1 e9 02             	shr    $0x2,%ecx
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	fc                   	cld    
  8003dd:	f3 ab                	repz stos %eax,%es:(%edi)
  8003df:	eb 06                	jmp    8003e7 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8003e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e4:	fc                   	cld    
  8003e5:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8003e7:	89 f8                	mov    %edi,%eax
}
  8003e9:	5f                   	pop    %edi
  8003ea:	c9                   	leave  
  8003eb:	c3                   	ret    

008003ec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	57                   	push   %edi
  8003f0:	56                   	push   %esi
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8003f7:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8003fa:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8003fc:	39 c6                	cmp    %eax,%esi
  8003fe:	73 33                	jae    800433 <memmove+0x47>
  800400:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800403:	39 c2                	cmp    %eax,%edx
  800405:	76 2c                	jbe    800433 <memmove+0x47>
		s += n;
  800407:	89 d6                	mov    %edx,%esi
		d += n;
  800409:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80040c:	f6 c2 03             	test   $0x3,%dl
  80040f:	75 1b                	jne    80042c <memmove+0x40>
  800411:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800417:	75 13                	jne    80042c <memmove+0x40>
  800419:	f6 c1 03             	test   $0x3,%cl
  80041c:	75 0e                	jne    80042c <memmove+0x40>
			asm volatile("std; rep movsl\n"
  80041e:	83 ef 04             	sub    $0x4,%edi
  800421:	83 ee 04             	sub    $0x4,%esi
  800424:	c1 e9 02             	shr    $0x2,%ecx
  800427:	fd                   	std    
  800428:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80042a:	eb 27                	jmp    800453 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80042c:	4f                   	dec    %edi
  80042d:	4e                   	dec    %esi
  80042e:	fd                   	std    
  80042f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800431:	eb 20                	jmp    800453 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800433:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800439:	75 15                	jne    800450 <memmove+0x64>
  80043b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800441:	75 0d                	jne    800450 <memmove+0x64>
  800443:	f6 c1 03             	test   $0x3,%cl
  800446:	75 08                	jne    800450 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800448:	c1 e9 02             	shr    $0x2,%ecx
  80044b:	fc                   	cld    
  80044c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80044e:	eb 03                	jmp    800453 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800450:	fc                   	cld    
  800451:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800453:	5e                   	pop    %esi
  800454:	5f                   	pop    %edi
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <memcpy>:

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
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80045a:	ff 75 10             	pushl  0x10(%ebp)
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	ff 75 08             	pushl  0x8(%ebp)
  800463:	e8 84 ff ff ff       	call   8003ec <memmove>
}
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  80046e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800471:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800474:	8b 55 10             	mov    0x10(%ebp),%edx
  800477:	4a                   	dec    %edx
  800478:	83 fa ff             	cmp    $0xffffffff,%edx
  80047b:	74 1a                	je     800497 <memcmp+0x2d>
  80047d:	8a 01                	mov    (%ecx),%al
  80047f:	3a 03                	cmp    (%ebx),%al
  800481:	74 0c                	je     80048f <memcmp+0x25>
  800483:	0f b6 d0             	movzbl %al,%edx
  800486:	0f b6 03             	movzbl (%ebx),%eax
  800489:	29 c2                	sub    %eax,%edx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	eb 0d                	jmp    80049c <memcmp+0x32>
  80048f:	41                   	inc    %ecx
  800490:	43                   	inc    %ebx
  800491:	4a                   	dec    %edx
  800492:	83 fa ff             	cmp    $0xffffffff,%edx
  800495:	75 e6                	jne    80047d <memcmp+0x13>
	}

	return 0;
  800497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80049c:	5b                   	pop    %ebx
  80049d:	c9                   	leave  
  80049e:	c3                   	ret    

0080049f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8004a8:	89 c2                	mov    %eax,%edx
  8004aa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8004ad:	39 d0                	cmp    %edx,%eax
  8004af:	73 09                	jae    8004ba <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8004b1:	38 08                	cmp    %cl,(%eax)
  8004b3:	74 05                	je     8004ba <memfind+0x1b>
  8004b5:	40                   	inc    %eax
  8004b6:	39 d0                	cmp    %edx,%eax
  8004b8:	72 f7                	jb     8004b1 <memfind+0x12>
			break;
	return (void *) s;
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	57                   	push   %edi
  8004c0:	56                   	push   %esi
  8004c1:	53                   	push   %ebx
  8004c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  8004cb:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  8004d0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  8004d5:	80 3a 20             	cmpb   $0x20,(%edx)
  8004d8:	74 05                	je     8004df <strtol+0x23>
  8004da:	80 3a 09             	cmpb   $0x9,(%edx)
  8004dd:	75 0b                	jne    8004ea <strtol+0x2e>
  8004df:	42                   	inc    %edx
  8004e0:	80 3a 20             	cmpb   $0x20,(%edx)
  8004e3:	74 fa                	je     8004df <strtol+0x23>
  8004e5:	80 3a 09             	cmpb   $0x9,(%edx)
  8004e8:	74 f5                	je     8004df <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  8004ea:	80 3a 2b             	cmpb   $0x2b,(%edx)
  8004ed:	75 03                	jne    8004f2 <strtol+0x36>
		s++;
  8004ef:	42                   	inc    %edx
  8004f0:	eb 0b                	jmp    8004fd <strtol+0x41>
	else if (*s == '-')
  8004f2:	80 3a 2d             	cmpb   $0x2d,(%edx)
  8004f5:	75 06                	jne    8004fd <strtol+0x41>
		s++, neg = 1;
  8004f7:	42                   	inc    %edx
  8004f8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	74 05                	je     800506 <strtol+0x4a>
  800501:	83 f9 10             	cmp    $0x10,%ecx
  800504:	75 15                	jne    80051b <strtol+0x5f>
  800506:	80 3a 30             	cmpb   $0x30,(%edx)
  800509:	75 10                	jne    80051b <strtol+0x5f>
  80050b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80050f:	75 0a                	jne    80051b <strtol+0x5f>
		s += 2, base = 16;
  800511:	83 c2 02             	add    $0x2,%edx
  800514:	b9 10 00 00 00       	mov    $0x10,%ecx
  800519:	eb 14                	jmp    80052f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  80051b:	85 c9                	test   %ecx,%ecx
  80051d:	75 10                	jne    80052f <strtol+0x73>
  80051f:	80 3a 30             	cmpb   $0x30,(%edx)
  800522:	75 05                	jne    800529 <strtol+0x6d>
		s++, base = 8;
  800524:	42                   	inc    %edx
  800525:	b1 08                	mov    $0x8,%cl
  800527:	eb 06                	jmp    80052f <strtol+0x73>
	else if (base == 0)
  800529:	85 c9                	test   %ecx,%ecx
  80052b:	75 02                	jne    80052f <strtol+0x73>
		base = 10;
  80052d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80052f:	8a 02                	mov    (%edx),%al
  800531:	83 e8 30             	sub    $0x30,%eax
  800534:	3c 09                	cmp    $0x9,%al
  800536:	77 08                	ja     800540 <strtol+0x84>
			dig = *s - '0';
  800538:	0f be 02             	movsbl (%edx),%eax
  80053b:	83 e8 30             	sub    $0x30,%eax
  80053e:	eb 20                	jmp    800560 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800540:	8a 02                	mov    (%edx),%al
  800542:	83 e8 61             	sub    $0x61,%eax
  800545:	3c 19                	cmp    $0x19,%al
  800547:	77 08                	ja     800551 <strtol+0x95>
			dig = *s - 'a' + 10;
  800549:	0f be 02             	movsbl (%edx),%eax
  80054c:	83 e8 57             	sub    $0x57,%eax
  80054f:	eb 0f                	jmp    800560 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800551:	8a 02                	mov    (%edx),%al
  800553:	83 e8 41             	sub    $0x41,%eax
  800556:	3c 19                	cmp    $0x19,%al
  800558:	77 12                	ja     80056c <strtol+0xb0>
			dig = *s - 'A' + 10;
  80055a:	0f be 02             	movsbl (%edx),%eax
  80055d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800560:	39 c8                	cmp    %ecx,%eax
  800562:	7d 08                	jge    80056c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800564:	42                   	inc    %edx
  800565:	0f af d9             	imul   %ecx,%ebx
  800568:	01 c3                	add    %eax,%ebx
  80056a:	eb c3                	jmp    80052f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  80056c:	85 f6                	test   %esi,%esi
  80056e:	74 02                	je     800572 <strtol+0xb6>
		*endptr = (char *) s;
  800570:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800572:	89 d8                	mov    %ebx,%eax
  800574:	85 ff                	test   %edi,%edi
  800576:	74 02                	je     80057a <strtol+0xbe>
  800578:	f7 d8                	neg    %eax
}
  80057a:	5b                   	pop    %ebx
  80057b:	5e                   	pop    %esi
  80057c:	5f                   	pop    %edi
  80057d:	c9                   	leave  
  80057e:	c3                   	ret    
	...

00800580 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	8b 55 08             	mov    0x8(%ebp),%edx
  80058c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80058f:	bf 00 00 00 00       	mov    $0x0,%edi
  800594:	89 f8                	mov    %edi,%eax
  800596:	89 fb                	mov    %edi,%ebx
  800598:	89 fe                	mov    %edi,%esi
  80059a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80059c:	83 c4 04             	add    $0x4,%esp
  80059f:	5b                   	pop    %ebx
  8005a0:	5e                   	pop    %esi
  8005a1:	5f                   	pop    %edi
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	57                   	push   %edi
  8005a8:	56                   	push   %esi
  8005a9:	53                   	push   %ebx
  8005aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8005af:	bf 00 00 00 00       	mov    $0x0,%edi
  8005b4:	89 fa                	mov    %edi,%edx
  8005b6:	89 f9                	mov    %edi,%ecx
  8005b8:	89 fb                	mov    %edi,%ebx
  8005ba:	89 fe                	mov    %edi,%esi
  8005bc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8005be:	5b                   	pop    %ebx
  8005bf:	5e                   	pop    %esi
  8005c0:	5f                   	pop    %edi
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	57                   	push   %edi
  8005c7:	56                   	push   %esi
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 0c             	sub    $0xc,%esp
  8005cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8005cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8005d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8005d9:	89 f9                	mov    %edi,%ecx
  8005db:	89 fb                	mov    %edi,%ebx
  8005dd:	89 fe                	mov    %edi,%esi
  8005df:	cd 30                	int    $0x30
  8005e1:	85 c0                	test   %eax,%eax
  8005e3:	7e 17                	jle    8005fc <sys_env_destroy+0x39>
  8005e5:	83 ec 0c             	sub    $0xc,%esp
  8005e8:	50                   	push   %eax
  8005e9:	6a 03                	push   $0x3
  8005eb:	68 58 25 80 00       	push   $0x802558
  8005f0:	6a 23                	push   $0x23
  8005f2:	68 75 25 80 00       	push   $0x802575
  8005f7:	e8 e4 14 00 00       	call   801ae0 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8005fc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8005ff:	5b                   	pop    %ebx
  800600:	5e                   	pop    %esi
  800601:	5f                   	pop    %edi
  800602:	c9                   	leave  
  800603:	c3                   	ret    

00800604 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	57                   	push   %edi
  800608:	56                   	push   %esi
  800609:	53                   	push   %ebx
  80060a:	b8 02 00 00 00       	mov    $0x2,%eax
  80060f:	bf 00 00 00 00       	mov    $0x0,%edi
  800614:	89 fa                	mov    %edi,%edx
  800616:	89 f9                	mov    %edi,%ecx
  800618:	89 fb                	mov    %edi,%ebx
  80061a:	89 fe                	mov    %edi,%esi
  80061c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80061e:	5b                   	pop    %ebx
  80061f:	5e                   	pop    %esi
  800620:	5f                   	pop    %edi
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <sys_yield>:

void
sys_yield(void)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	57                   	push   %edi
  800627:	56                   	push   %esi
  800628:	53                   	push   %ebx
  800629:	b8 0b 00 00 00       	mov    $0xb,%eax
  80062e:	bf 00 00 00 00       	mov    $0x0,%edi
  800633:	89 fa                	mov    %edi,%edx
  800635:	89 f9                	mov    %edi,%ecx
  800637:	89 fb                	mov    %edi,%ebx
  800639:	89 fe                	mov    %edi,%esi
  80063b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80063d:	5b                   	pop    %ebx
  80063e:	5e                   	pop    %esi
  80063f:	5f                   	pop    %edi
  800640:	c9                   	leave  
  800641:	c3                   	ret    

00800642 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	57                   	push   %edi
  800646:	56                   	push   %esi
  800647:	53                   	push   %ebx
  800648:	83 ec 0c             	sub    $0xc,%esp
  80064b:	8b 55 08             	mov    0x8(%ebp),%edx
  80064e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800651:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800654:	b8 04 00 00 00       	mov    $0x4,%eax
  800659:	bf 00 00 00 00       	mov    $0x0,%edi
  80065e:	89 fe                	mov    %edi,%esi
  800660:	cd 30                	int    $0x30
  800662:	85 c0                	test   %eax,%eax
  800664:	7e 17                	jle    80067d <sys_page_alloc+0x3b>
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	50                   	push   %eax
  80066a:	6a 04                	push   $0x4
  80066c:	68 58 25 80 00       	push   $0x802558
  800671:	6a 23                	push   $0x23
  800673:	68 75 25 80 00       	push   $0x802575
  800678:	e8 63 14 00 00       	call   801ae0 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80067d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800680:	5b                   	pop    %ebx
  800681:	5e                   	pop    %esi
  800682:	5f                   	pop    %edi
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	57                   	push   %edi
  800689:	56                   	push   %esi
  80068a:	53                   	push   %ebx
  80068b:	83 ec 0c             	sub    $0xc,%esp
  80068e:	8b 55 08             	mov    0x8(%ebp),%edx
  800691:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800694:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800697:	8b 7d 14             	mov    0x14(%ebp),%edi
  80069a:	8b 75 18             	mov    0x18(%ebp),%esi
  80069d:	b8 05 00 00 00       	mov    $0x5,%eax
  8006a2:	cd 30                	int    $0x30
  8006a4:	85 c0                	test   %eax,%eax
  8006a6:	7e 17                	jle    8006bf <sys_page_map+0x3a>
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	50                   	push   %eax
  8006ac:	6a 05                	push   $0x5
  8006ae:	68 58 25 80 00       	push   $0x802558
  8006b3:	6a 23                	push   $0x23
  8006b5:	68 75 25 80 00       	push   $0x802575
  8006ba:	e8 21 14 00 00       	call   801ae0 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8006bf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006c2:	5b                   	pop    %ebx
  8006c3:	5e                   	pop    %esi
  8006c4:	5f                   	pop    %edi
  8006c5:	c9                   	leave  
  8006c6:	c3                   	ret    

008006c7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8006c7:	55                   	push   %ebp
  8006c8:	89 e5                	mov    %esp,%ebp
  8006ca:	57                   	push   %edi
  8006cb:	56                   	push   %esi
  8006cc:	53                   	push   %ebx
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8006d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8006db:	bf 00 00 00 00       	mov    $0x0,%edi
  8006e0:	89 fb                	mov    %edi,%ebx
  8006e2:	89 fe                	mov    %edi,%esi
  8006e4:	cd 30                	int    $0x30
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	7e 17                	jle    800701 <sys_page_unmap+0x3a>
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	50                   	push   %eax
  8006ee:	6a 06                	push   $0x6
  8006f0:	68 58 25 80 00       	push   $0x802558
  8006f5:	6a 23                	push   $0x23
  8006f7:	68 75 25 80 00       	push   $0x802575
  8006fc:	e8 df 13 00 00       	call   801ae0 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800701:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800704:	5b                   	pop    %ebx
  800705:	5e                   	pop    %esi
  800706:	5f                   	pop    %edi
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	57                   	push   %edi
  80070d:	56                   	push   %esi
  80070e:	53                   	push   %ebx
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	8b 55 08             	mov    0x8(%ebp),%edx
  800715:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800718:	b8 08 00 00 00       	mov    $0x8,%eax
  80071d:	bf 00 00 00 00       	mov    $0x0,%edi
  800722:	89 fb                	mov    %edi,%ebx
  800724:	89 fe                	mov    %edi,%esi
  800726:	cd 30                	int    $0x30
  800728:	85 c0                	test   %eax,%eax
  80072a:	7e 17                	jle    800743 <sys_env_set_status+0x3a>
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	50                   	push   %eax
  800730:	6a 08                	push   $0x8
  800732:	68 58 25 80 00       	push   $0x802558
  800737:	6a 23                	push   $0x23
  800739:	68 75 25 80 00       	push   $0x802575
  80073e:	e8 9d 13 00 00       	call   801ae0 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800743:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800746:	5b                   	pop    %ebx
  800747:	5e                   	pop    %esi
  800748:	5f                   	pop    %edi
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	57                   	push   %edi
  80074f:	56                   	push   %esi
  800750:	53                   	push   %ebx
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	8b 55 08             	mov    0x8(%ebp),%edx
  800757:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80075a:	b8 09 00 00 00       	mov    $0x9,%eax
  80075f:	bf 00 00 00 00       	mov    $0x0,%edi
  800764:	89 fb                	mov    %edi,%ebx
  800766:	89 fe                	mov    %edi,%esi
  800768:	cd 30                	int    $0x30
  80076a:	85 c0                	test   %eax,%eax
  80076c:	7e 17                	jle    800785 <sys_env_set_trapframe+0x3a>
  80076e:	83 ec 0c             	sub    $0xc,%esp
  800771:	50                   	push   %eax
  800772:	6a 09                	push   $0x9
  800774:	68 58 25 80 00       	push   $0x802558
  800779:	6a 23                	push   $0x23
  80077b:	68 75 25 80 00       	push   $0x802575
  800780:	e8 5b 13 00 00       	call   801ae0 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800785:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	57                   	push   %edi
  800791:	56                   	push   %esi
  800792:	53                   	push   %ebx
  800793:	83 ec 0c             	sub    $0xc,%esp
  800796:	8b 55 08             	mov    0x8(%ebp),%edx
  800799:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80079c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8007a6:	89 fb                	mov    %edi,%ebx
  8007a8:	89 fe                	mov    %edi,%esi
  8007aa:	cd 30                	int    $0x30
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	7e 17                	jle    8007c7 <sys_env_set_pgfault_upcall+0x3a>
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	50                   	push   %eax
  8007b4:	6a 0a                	push   $0xa
  8007b6:	68 58 25 80 00       	push   $0x802558
  8007bb:	6a 23                	push   $0x23
  8007bd:	68 75 25 80 00       	push   $0x802575
  8007c2:	e8 19 13 00 00       	call   801ae0 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8007c7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8007ca:	5b                   	pop    %ebx
  8007cb:	5e                   	pop    %esi
  8007cc:	5f                   	pop    %edi
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	57                   	push   %edi
  8007d3:	56                   	push   %esi
  8007d4:	53                   	push   %ebx
  8007d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8007e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8007e6:	be 00 00 00 00       	mov    $0x0,%esi
  8007eb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8007ed:	5b                   	pop    %ebx
  8007ee:	5e                   	pop    %esi
  8007ef:	5f                   	pop    %edi
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    

008007f2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	57                   	push   %edi
  8007f6:	56                   	push   %esi
  8007f7:	53                   	push   %ebx
  8007f8:	83 ec 0c             	sub    $0xc,%esp
  8007fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8007fe:	b8 0d 00 00 00       	mov    $0xd,%eax
  800803:	bf 00 00 00 00       	mov    $0x0,%edi
  800808:	89 f9                	mov    %edi,%ecx
  80080a:	89 fb                	mov    %edi,%ebx
  80080c:	89 fe                	mov    %edi,%esi
  80080e:	cd 30                	int    $0x30
  800810:	85 c0                	test   %eax,%eax
  800812:	7e 17                	jle    80082b <sys_ipc_recv+0x39>
  800814:	83 ec 0c             	sub    $0xc,%esp
  800817:	50                   	push   %eax
  800818:	6a 0d                	push   $0xd
  80081a:	68 58 25 80 00       	push   $0x802558
  80081f:	6a 23                	push   $0x23
  800821:	68 75 25 80 00       	push   $0x802575
  800826:	e8 b5 12 00 00       	call   801ae0 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80082b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80082e:	5b                   	pop    %ebx
  80082f:	5e                   	pop    %esi
  800830:	5f                   	pop    %edi
  800831:	c9                   	leave  
  800832:	c3                   	ret    

00800833 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	57                   	push   %edi
  800837:	56                   	push   %esi
  800838:	53                   	push   %ebx
  800839:	83 ec 0c             	sub    $0xc,%esp
  80083c:	8b 55 08             	mov    0x8(%ebp),%edx
  80083f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800842:	b8 10 00 00 00       	mov    $0x10,%eax
  800847:	bf 00 00 00 00       	mov    $0x0,%edi
  80084c:	89 fb                	mov    %edi,%ebx
  80084e:	89 fe                	mov    %edi,%esi
  800850:	cd 30                	int    $0x30
  800852:	85 c0                	test   %eax,%eax
  800854:	7e 17                	jle    80086d <sys_transmit_packet+0x3a>
  800856:	83 ec 0c             	sub    $0xc,%esp
  800859:	50                   	push   %eax
  80085a:	6a 10                	push   $0x10
  80085c:	68 58 25 80 00       	push   $0x802558
  800861:	6a 23                	push   $0x23
  800863:	68 75 25 80 00       	push   $0x802575
  800868:	e8 73 12 00 00       	call   801ae0 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  80086d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800870:	5b                   	pop    %ebx
  800871:	5e                   	pop    %esi
  800872:	5f                   	pop    %edi
  800873:	c9                   	leave  
  800874:	c3                   	ret    

00800875 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	57                   	push   %edi
  800879:	56                   	push   %esi
  80087a:	53                   	push   %ebx
  80087b:	83 ec 0c             	sub    $0xc,%esp
  80087e:	8b 55 08             	mov    0x8(%ebp),%edx
  800881:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800884:	b8 11 00 00 00       	mov    $0x11,%eax
  800889:	bf 00 00 00 00       	mov    $0x0,%edi
  80088e:	89 fb                	mov    %edi,%ebx
  800890:	89 fe                	mov    %edi,%esi
  800892:	cd 30                	int    $0x30
  800894:	85 c0                	test   %eax,%eax
  800896:	7e 17                	jle    8008af <sys_receive_packet+0x3a>
  800898:	83 ec 0c             	sub    $0xc,%esp
  80089b:	50                   	push   %eax
  80089c:	6a 11                	push   $0x11
  80089e:	68 58 25 80 00       	push   $0x802558
  8008a3:	6a 23                	push   $0x23
  8008a5:	68 75 25 80 00       	push   $0x802575
  8008aa:	e8 31 12 00 00       	call   801ae0 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  8008af:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8008b2:	5b                   	pop    %ebx
  8008b3:	5e                   	pop    %esi
  8008b4:	5f                   	pop    %edi
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    

008008b7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	57                   	push   %edi
  8008bb:	56                   	push   %esi
  8008bc:	53                   	push   %ebx
  8008bd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8008c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8008c7:	89 fa                	mov    %edi,%edx
  8008c9:	89 f9                	mov    %edi,%ecx
  8008cb:	89 fb                	mov    %edi,%ebx
  8008cd:	89 fe                	mov    %edi,%esi
  8008cf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5f                   	pop    %edi
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    

008008d6 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	57                   	push   %edi
  8008da:	56                   	push   %esi
  8008db:	53                   	push   %ebx
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8008e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ec:	89 f9                	mov    %edi,%ecx
  8008ee:	89 fb                	mov    %edi,%ebx
  8008f0:	89 fe                	mov    %edi,%esi
  8008f2:	cd 30                	int    $0x30
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	7e 17                	jle    80090f <sys_map_receive_buffers+0x39>
  8008f8:	83 ec 0c             	sub    $0xc,%esp
  8008fb:	50                   	push   %eax
  8008fc:	6a 0e                	push   $0xe
  8008fe:	68 58 25 80 00       	push   $0x802558
  800903:	6a 23                	push   $0x23
  800905:	68 75 25 80 00       	push   $0x802575
  80090a:	e8 d1 11 00 00       	call   801ae0 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  80090f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5f                   	pop    %edi
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	57                   	push   %edi
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	83 ec 0c             	sub    $0xc,%esp
  800920:	8b 55 08             	mov    0x8(%ebp),%edx
  800923:	b8 12 00 00 00       	mov    $0x12,%eax
  800928:	bf 00 00 00 00       	mov    $0x0,%edi
  80092d:	89 f9                	mov    %edi,%ecx
  80092f:	89 fb                	mov    %edi,%ebx
  800931:	89 fe                	mov    %edi,%esi
  800933:	cd 30                	int    $0x30
  800935:	85 c0                	test   %eax,%eax
  800937:	7e 17                	jle    800950 <sys_receive_packet_zerocopy+0x39>
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	50                   	push   %eax
  80093d:	6a 12                	push   $0x12
  80093f:	68 58 25 80 00       	push   $0x802558
  800944:	6a 23                	push   $0x23
  800946:	68 75 25 80 00       	push   $0x802575
  80094b:	e8 90 11 00 00       	call   801ae0 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800950:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800953:	5b                   	pop    %ebx
  800954:	5e                   	pop    %esi
  800955:	5f                   	pop    %edi
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	57                   	push   %edi
  80095c:	56                   	push   %esi
  80095d:	53                   	push   %ebx
  80095e:	83 ec 0c             	sub    $0xc,%esp
  800961:	8b 55 08             	mov    0x8(%ebp),%edx
  800964:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800967:	b8 13 00 00 00       	mov    $0x13,%eax
  80096c:	bf 00 00 00 00       	mov    $0x0,%edi
  800971:	89 fb                	mov    %edi,%ebx
  800973:	89 fe                	mov    %edi,%esi
  800975:	cd 30                	int    $0x30
  800977:	85 c0                	test   %eax,%eax
  800979:	7e 17                	jle    800992 <sys_env_set_priority+0x3a>
  80097b:	83 ec 0c             	sub    $0xc,%esp
  80097e:	50                   	push   %eax
  80097f:	6a 13                	push   $0x13
  800981:	68 58 25 80 00       	push   $0x802558
  800986:	6a 23                	push   $0x23
  800988:	68 75 25 80 00       	push   $0x802575
  80098d:	e8 4e 11 00 00       	call   801ae0 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800992:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5f                   	pop    %edi
  800998:	c9                   	leave  
  800999:	c3                   	ret    
	...

0080099c <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8009a2:	ff 75 08             	pushl  0x8(%ebp)
  8009a5:	e8 0a 00 00 00       	call   8009b4 <fd2num>
  8009aa:	c1 e0 16             	shl    $0x16,%eax
  8009ad:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    

008009b4 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	05 00 00 40 30       	add    $0x30400000,%eax
  8009bf:	c1 e8 0c             	shr    $0xc,%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <fd_alloc>:

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
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	53                   	push   %ebx
  8009ca:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8009cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d2:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  8009d7:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  8009dc:	89 c8                	mov    %ecx,%eax
  8009de:	c1 e0 0c             	shl    $0xc,%eax
  8009e1:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8009e7:	89 d0                	mov    %edx,%eax
  8009e9:	c1 e8 16             	shr    $0x16,%eax
  8009ec:	8b 04 86             	mov    (%esi,%eax,4),%eax
  8009ef:	a8 01                	test   $0x1,%al
  8009f1:	74 0c                	je     8009ff <fd_alloc+0x3b>
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	c1 e8 0c             	shr    $0xc,%eax
  8009f8:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  8009fb:	a8 01                	test   $0x1,%al
  8009fd:	75 09                	jne    800a08 <fd_alloc+0x44>
			*fd_store = fd;
  8009ff:	89 17                	mov    %edx,(%edi)
			return 0;
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
  800a06:	eb 11                	jmp    800a19 <fd_alloc+0x55>
  800a08:	41                   	inc    %ecx
  800a09:	83 f9 1f             	cmp    $0x1f,%ecx
  800a0c:	7e ce                	jle    8009dc <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  800a0e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  800a14:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800a19:	5b                   	pop    %ebx
  800a1a:	5e                   	pop    %esi
  800a1b:	5f                   	pop    %edi
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    

00800a1e <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  800a24:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800a29:	83 f8 1f             	cmp    $0x1f,%eax
  800a2c:	77 3a                	ja     800a68 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  800a2e:	c1 e0 0c             	shl    $0xc,%eax
  800a31:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	c1 e8 16             	shr    $0x16,%eax
  800a3c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800a43:	a8 01                	test   $0x1,%al
  800a45:	74 10                	je     800a57 <fd_lookup+0x39>
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	c1 e8 0c             	shr    $0xc,%eax
  800a4c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800a53:	a8 01                	test   $0x1,%al
  800a55:	75 07                	jne    800a5e <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  800a57:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800a5c:	eb 0a                	jmp    800a68 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	89 10                	mov    %edx,(%eax)
	return 0;
  800a63:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a68:	89 d0                	mov    %edx,%eax
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <fd_close>:

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
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	56                   	push   %esi
  800a70:	53                   	push   %ebx
  800a71:	83 ec 10             	sub    $0x10,%esp
  800a74:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800a77:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800a7a:	50                   	push   %eax
  800a7b:	56                   	push   %esi
  800a7c:	e8 33 ff ff ff       	call   8009b4 <fd2num>
  800a81:	89 04 24             	mov    %eax,(%esp)
  800a84:	e8 95 ff ff ff       	call   800a1e <fd_lookup>
  800a89:	89 c3                	mov    %eax,%ebx
  800a8b:	83 c4 08             	add    $0x8,%esp
  800a8e:	85 c0                	test   %eax,%eax
  800a90:	78 05                	js     800a97 <fd_close+0x2b>
  800a92:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  800a95:	74 0f                	je     800aa6 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800a97:	89 d8                	mov    %ebx,%eax
  800a99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9d:	75 3a                	jne    800ad9 <fd_close+0x6d>
  800a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa4:	eb 33                	jmp    800ad9 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	ff 36                	pushl  (%esi)
  800aaf:	e8 2c 00 00 00       	call   800ae0 <dev_lookup>
  800ab4:	89 c3                	mov    %eax,%ebx
  800ab6:	83 c4 10             	add    $0x10,%esp
  800ab9:	85 c0                	test   %eax,%eax
  800abb:	78 0f                	js     800acc <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  800abd:	83 ec 0c             	sub    $0xc,%esp
  800ac0:	56                   	push   %esi
  800ac1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  800ac4:	ff 50 10             	call   *0x10(%eax)
  800ac7:	89 c3                	mov    %eax,%ebx
  800ac9:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	56                   	push   %esi
  800ad0:	6a 00                	push   $0x0
  800ad2:	e8 f0 fb ff ff       	call   8006c7 <sys_page_unmap>
	return r;
  800ad7:	89 d8                	mov    %ebx,%eax
}
  800ad9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800adc:	5b                   	pop    %ebx
  800add:	5e                   	pop    %esi
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <dev_lookup>:


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
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	56                   	push   %esi
  800ae4:	53                   	push   %ebx
  800ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ae8:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  800af7:	74 1c                	je     800b15 <dev_lookup+0x35>
  800af9:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  800afe:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  800b01:	39 18                	cmp    %ebx,(%eax)
  800b03:	75 09                	jne    800b0e <dev_lookup+0x2e>
			*dev = devtab[i];
  800b05:	89 06                	mov    %eax,(%esi)
			return 0;
  800b07:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0c:	eb 29                	jmp    800b37 <dev_lookup+0x57>
  800b0e:	42                   	inc    %edx
  800b0f:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  800b13:	75 e9                	jne    800afe <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	53                   	push   %ebx
  800b19:	a1 80 60 80 00       	mov    0x806080,%eax
  800b1e:	8b 40 4c             	mov    0x4c(%eax),%eax
  800b21:	50                   	push   %eax
  800b22:	68 84 25 80 00       	push   $0x802584
  800b27:	e8 a4 10 00 00       	call   801bd0 <cprintf>
	*dev = 0;
  800b2c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  800b32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800b37:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <close>:

int
close(int fdnum)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800b44:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800b47:	50                   	push   %eax
  800b48:	ff 75 08             	pushl  0x8(%ebp)
  800b4b:	e8 ce fe ff ff       	call   800a1e <fd_lookup>
  800b50:	83 c4 08             	add    $0x8,%esp
		return r;
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	85 c0                	test   %eax,%eax
  800b57:	78 0f                	js     800b68 <close+0x2a>
	else
		return fd_close(fd, 1);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	6a 01                	push   $0x1
  800b5e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  800b61:	e8 06 ff ff ff       	call   800a6c <fd_close>
  800b66:	89 c2                	mov    %eax,%edx
}
  800b68:	89 d0                	mov    %edx,%eax
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <close_all>:

void
close_all(void)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	53                   	push   %ebx
  800b70:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800b73:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800b78:	83 ec 0c             	sub    $0xc,%esp
  800b7b:	53                   	push   %ebx
  800b7c:	e8 bd ff ff ff       	call   800b3e <close>
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	43                   	inc    %ebx
  800b85:	83 fb 1f             	cmp    $0x1f,%ebx
  800b88:	7e ee                	jle    800b78 <close_all+0xc>
}
  800b8a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800b98:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800b9b:	50                   	push   %eax
  800b9c:	ff 75 08             	pushl  0x8(%ebp)
  800b9f:	e8 7a fe ff ff       	call   800a1e <fd_lookup>
  800ba4:	89 c6                	mov    %eax,%esi
  800ba6:	83 c4 08             	add    $0x8,%esp
  800ba9:	85 f6                	test   %esi,%esi
  800bab:	0f 88 f8 00 00 00    	js     800ca9 <dup+0x11a>
		return r;
	close(newfdnum);
  800bb1:	83 ec 0c             	sub    $0xc,%esp
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	e8 82 ff ff ff       	call   800b3e <close>

	newfd = INDEX2FD(newfdnum);
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	c1 e0 0c             	shl    $0xc,%eax
  800bc2:	2d 00 00 40 30       	sub    $0x30400000,%eax
  800bc7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  800bca:	83 c4 04             	add    $0x4,%esp
  800bcd:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800bd0:	e8 c7 fd ff ff       	call   80099c <fd2data>
  800bd5:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800bd7:	83 c4 04             	add    $0x4,%esp
  800bda:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800bdd:	e8 ba fd ff ff       	call   80099c <fd2data>
  800be2:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  800be5:	89 f8                	mov    %edi,%eax
  800be7:	c1 e8 16             	shr    $0x16,%eax
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800bf4:	85 c0                	test   %eax,%eax
  800bf6:	74 48                	je     800c40 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  800bf8:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  800bfd:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  800c00:	89 d0                	mov    %edx,%eax
  800c02:	c1 e8 0c             	shr    $0xc,%eax
  800c05:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  800c0c:	a8 01                	test   $0x1,%al
  800c0e:	74 22                	je     800c32 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	25 07 0e 00 00       	and    $0xe07,%eax
  800c18:	50                   	push   %eax
  800c19:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  800c1c:	01 d8                	add    %ebx,%eax
  800c1e:	50                   	push   %eax
  800c1f:	6a 00                	push   $0x0
  800c21:	52                   	push   %edx
  800c22:	6a 00                	push   $0x0
  800c24:	e8 5c fa ff ff       	call   800685 <sys_page_map>
  800c29:	89 c6                	mov    %eax,%esi
  800c2b:	83 c4 20             	add    $0x20,%esp
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	78 3f                	js     800c71 <dup+0xe2>
  800c32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800c38:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  800c3e:	7e bd                	jle    800bfd <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800c40:	83 ec 0c             	sub    $0xc,%esp
  800c43:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  800c46:	89 d0                	mov    %edx,%eax
  800c48:	c1 e8 0c             	shr    $0xc,%eax
  800c4b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800c52:	25 07 0e 00 00       	and    $0xe07,%eax
  800c57:	50                   	push   %eax
  800c58:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800c5b:	6a 00                	push   $0x0
  800c5d:	52                   	push   %edx
  800c5e:	6a 00                	push   $0x0
  800c60:	e8 20 fa ff ff       	call   800685 <sys_page_map>
  800c65:	89 c6                	mov    %eax,%esi
  800c67:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	85 f6                	test   %esi,%esi
  800c6f:	79 38                	jns    800ca9 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800c77:	6a 00                	push   $0x0
  800c79:	e8 49 fa ff ff       	call   8006c7 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  800c7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c83:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  800c8c:	01 d8                	add    %ebx,%eax
  800c8e:	50                   	push   %eax
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 31 fa ff ff       	call   8006c7 <sys_page_unmap>
  800c96:	83 c4 10             	add    $0x10,%esp
  800c99:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800c9f:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  800ca5:	7e df                	jle    800c86 <dup+0xf7>
	return r;
  800ca7:	89 f0                	mov    %esi,%eax
}
  800ca9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 14             	sub    $0x14,%esp
  800cb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cbb:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800cbe:	50                   	push   %eax
  800cbf:	53                   	push   %ebx
  800cc0:	e8 59 fd ff ff       	call   800a1e <fd_lookup>
  800cc5:	89 c2                	mov    %eax,%edx
  800cc7:	83 c4 08             	add    $0x8,%esp
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	78 1a                	js     800ce8 <read+0x37>
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800cd4:	50                   	push   %eax
  800cd5:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800cd8:	ff 30                	pushl  (%eax)
  800cda:	e8 01 fe ff ff       	call   800ae0 <dev_lookup>
  800cdf:	89 c2                	mov    %eax,%edx
  800ce1:	83 c4 10             	add    $0x10,%esp
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	79 04                	jns    800cec <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  800ce8:	89 d0                	mov    %edx,%eax
  800cea:	eb 50                	jmp    800d3c <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800cec:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800cef:	8b 40 08             	mov    0x8(%eax),%eax
  800cf2:	83 e0 03             	and    $0x3,%eax
  800cf5:	83 f8 01             	cmp    $0x1,%eax
  800cf8:	75 1e                	jne    800d18 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800cfa:	83 ec 04             	sub    $0x4,%esp
  800cfd:	53                   	push   %ebx
  800cfe:	a1 80 60 80 00       	mov    0x806080,%eax
  800d03:	8b 40 4c             	mov    0x4c(%eax),%eax
  800d06:	50                   	push   %eax
  800d07:	68 c5 25 80 00       	push   $0x8025c5
  800d0c:	e8 bf 0e 00 00       	call   801bd0 <cprintf>
		return -E_INVAL;
  800d11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d16:	eb 24                	jmp    800d3c <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  800d18:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800d1b:	ff 70 04             	pushl  0x4(%eax)
  800d1e:	ff 75 10             	pushl  0x10(%ebp)
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	50                   	push   %eax
  800d25:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800d28:	ff 50 08             	call   *0x8(%eax)
  800d2b:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  800d2d:	83 c4 10             	add    $0x10,%esp
  800d30:	85 c0                	test   %eax,%eax
  800d32:	78 06                	js     800d3a <read+0x89>
		fd->fd_offset += r;
  800d34:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800d37:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  800d3a:	89 d0                	mov    %edx,%eax
}
  800d3c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
  800d47:	83 ec 0c             	sub    $0xc,%esp
  800d4a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d4d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d55:	39 f3                	cmp    %esi,%ebx
  800d57:	73 25                	jae    800d7e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800d59:	83 ec 04             	sub    $0x4,%esp
  800d5c:	89 f0                	mov    %esi,%eax
  800d5e:	29 d8                	sub    %ebx,%eax
  800d60:	50                   	push   %eax
  800d61:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  800d64:	50                   	push   %eax
  800d65:	ff 75 08             	pushl  0x8(%ebp)
  800d68:	e8 44 ff ff ff       	call   800cb1 <read>
		if (m < 0)
  800d6d:	83 c4 10             	add    $0x10,%esp
  800d70:	85 c0                	test   %eax,%eax
  800d72:	78 0c                	js     800d80 <readn+0x3f>
			return m;
		if (m == 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	74 06                	je     800d7e <readn+0x3d>
  800d78:	01 c3                	add    %eax,%ebx
  800d7a:	39 f3                	cmp    %esi,%ebx
  800d7c:	72 db                	jb     800d59 <readn+0x18>
			break;
	}
	return tot;
  800d7e:	89 d8                	mov    %ebx,%eax
}
  800d80:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 14             	sub    $0x14,%esp
  800d8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d92:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800d95:	50                   	push   %eax
  800d96:	53                   	push   %ebx
  800d97:	e8 82 fc ff ff       	call   800a1e <fd_lookup>
  800d9c:	89 c2                	mov    %eax,%edx
  800d9e:	83 c4 08             	add    $0x8,%esp
  800da1:	85 c0                	test   %eax,%eax
  800da3:	78 1a                	js     800dbf <write+0x37>
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800dab:	50                   	push   %eax
  800dac:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800daf:	ff 30                	pushl  (%eax)
  800db1:	e8 2a fd ff ff       	call   800ae0 <dev_lookup>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	83 c4 10             	add    $0x10,%esp
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	79 04                	jns    800dc3 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  800dbf:	89 d0                	mov    %edx,%eax
  800dc1:	eb 4b                	jmp    800e0e <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dc3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800dc6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800dca:	75 1e                	jne    800dea <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	53                   	push   %ebx
  800dd0:	a1 80 60 80 00       	mov    0x806080,%eax
  800dd5:	8b 40 4c             	mov    0x4c(%eax),%eax
  800dd8:	50                   	push   %eax
  800dd9:	68 e1 25 80 00       	push   $0x8025e1
  800dde:	e8 ed 0d 00 00       	call   801bd0 <cprintf>
		return -E_INVAL;
  800de3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800de8:	eb 24                	jmp    800e0e <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  800dea:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800ded:	ff 70 04             	pushl  0x4(%eax)
  800df0:	ff 75 10             	pushl  0x10(%ebp)
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	50                   	push   %eax
  800df7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800dfa:	ff 50 0c             	call   *0xc(%eax)
  800dfd:	89 c2                	mov    %eax,%edx
	if (r > 0)
  800dff:	83 c4 10             	add    $0x10,%esp
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7e 06                	jle    800e0c <write+0x84>
		fd->fd_offset += r;
  800e06:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800e09:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  800e0c:	89 d0                	mov    %edx,%eax
}
  800e0e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <seek>:

int
seek(int fdnum, off_t offset)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e19:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800e1c:	50                   	push   %eax
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 f9 fb ff ff       	call   800a1e <fd_lookup>
  800e25:	83 c4 08             	add    $0x8,%esp
		return r;
  800e28:	89 c2                	mov    %eax,%edx
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	78 0e                	js     800e3c <seek+0x29>
	fd->fd_offset = offset;
  800e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e31:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  800e34:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800e37:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e3c:	89 d0                	mov    %edx,%eax
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	53                   	push   %ebx
  800e44:	83 ec 14             	sub    $0x14,%esp
  800e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e4a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800e4d:	50                   	push   %eax
  800e4e:	53                   	push   %ebx
  800e4f:	e8 ca fb ff ff       	call   800a1e <fd_lookup>
  800e54:	83 c4 08             	add    $0x8,%esp
  800e57:	85 c0                	test   %eax,%eax
  800e59:	78 4e                	js     800ea9 <ftruncate+0x69>
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800e61:	50                   	push   %eax
  800e62:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800e65:	ff 30                	pushl  (%eax)
  800e67:	e8 74 fc ff ff       	call   800ae0 <dev_lookup>
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	78 36                	js     800ea9 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e73:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800e76:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800e7a:	75 1e                	jne    800e9a <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e7c:	83 ec 04             	sub    $0x4,%esp
  800e7f:	53                   	push   %ebx
  800e80:	a1 80 60 80 00       	mov    0x806080,%eax
  800e85:	8b 40 4c             	mov    0x4c(%eax),%eax
  800e88:	50                   	push   %eax
  800e89:	68 a4 25 80 00       	push   $0x8025a4
  800e8e:	e8 3d 0d 00 00       	call   801bd0 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  800e93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e98:	eb 0f                	jmp    800ea9 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ea0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800ea3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800ea6:	ff 50 1c             	call   *0x1c(%eax)
}
  800ea9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 14             	sub    $0x14,%esp
  800eb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800eb8:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800ebb:	50                   	push   %eax
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 5a fb ff ff       	call   800a1e <fd_lookup>
  800ec4:	83 c4 08             	add    $0x8,%esp
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	78 42                	js     800f0d <fstat+0x5f>
  800ecb:	83 ec 08             	sub    $0x8,%esp
  800ece:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800ed1:	50                   	push   %eax
  800ed2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800ed5:	ff 30                	pushl  (%eax)
  800ed7:	e8 04 fc ff ff       	call   800ae0 <dev_lookup>
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	78 2a                	js     800f0d <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  800ee3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800ee6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800eed:	00 00 00 
	stat->st_isdir = 0;
  800ef0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ef7:	00 00 00 
	stat->st_dev = dev;
  800efa:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800efd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800f03:	83 ec 08             	sub    $0x8,%esp
  800f06:	53                   	push   %ebx
  800f07:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800f0a:	ff 50 14             	call   *0x14(%eax)
}
  800f0d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	56                   	push   %esi
  800f16:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f17:	83 ec 08             	sub    $0x8,%esp
  800f1a:	6a 00                	push   $0x0
  800f1c:	ff 75 08             	pushl  0x8(%ebp)
  800f1f:	e8 28 00 00 00       	call   800f4c <open>
  800f24:	89 c6                	mov    %eax,%esi
  800f26:	83 c4 10             	add    $0x10,%esp
  800f29:	85 f6                	test   %esi,%esi
  800f2b:	78 18                	js     800f45 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  800f2d:	83 ec 08             	sub    $0x8,%esp
  800f30:	ff 75 0c             	pushl  0xc(%ebp)
  800f33:	56                   	push   %esi
  800f34:	e8 75 ff ff ff       	call   800eae <fstat>
  800f39:	89 c3                	mov    %eax,%ebx
	close(fd);
  800f3b:	89 34 24             	mov    %esi,(%esp)
  800f3e:	e8 fb fb ff ff       	call   800b3e <close>
	return r;
  800f43:	89 d8                	mov    %ebx,%eax
}
  800f45:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 10             	sub    $0x10,%esp
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
  800f53:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800f56:	50                   	push   %eax
  800f57:	e8 68 fa ff ff       	call   8009c4 <fd_alloc>
  800f5c:	89 c3                	mov    %eax,%ebx
  800f5e:	83 c4 10             	add    $0x10,%esp
  800f61:	85 db                	test   %ebx,%ebx
  800f63:	78 36                	js     800f9b <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  800f65:	83 ec 04             	sub    $0x4,%esp
  800f68:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 1b 05 00 00       	call   801491 <fsipc_open>
  800f76:	89 c3                	mov    %eax,%ebx
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	79 11                	jns    800f90 <open+0x44>
          fd_close(fd_store, 0);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	6a 00                	push   $0x0
  800f84:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800f87:	e8 e0 fa ff ff       	call   800a6c <fd_close>
          return r;
  800f8c:	89 d8                	mov    %ebx,%eax
  800f8e:	eb 0b                	jmp    800f9b <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800f96:	e8 19 fa ff ff       	call   8009b4 <fd2num>
}
  800f9b:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 04             	sub    $0x4,%esp
  800fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  800faa:	6a 01                	push   $0x1
  800fac:	6a 00                	push   $0x0
  800fae:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  800fb4:	53                   	push   %ebx
  800fb5:	e8 e7 03 00 00       	call   8013a1 <funmap>
  800fba:	83 c4 10             	add    $0x10,%esp
          return r;
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	78 19                	js     800fdc <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	ff 73 0c             	pushl  0xc(%ebx)
  800fc9:	e8 68 05 00 00       	call   801536 <fsipc_close>
  800fce:	83 c4 10             	add    $0x10,%esp
          return r;
  800fd1:	89 c2                	mov    %eax,%edx
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	78 05                	js     800fdc <file_close+0x3c>
        }
        return 0;
  800fd7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800fdc:	89 d0                	mov    %edx,%eax
  800fde:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800fe1:	c9                   	leave  
  800fe2:	c3                   	ret    

00800fe3 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	57                   	push   %edi
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 0c             	sub    $0xc,%esp
  800fec:	8b 75 10             	mov    0x10(%ebp),%esi
  800fef:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  800ffb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801000:	39 d7                	cmp    %edx,%edi
  801002:	0f 87 95 00 00 00    	ja     80109d <file_read+0xba>
	if (offset + n > size)
  801008:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80100b:	39 d0                	cmp    %edx,%eax
  80100d:	76 04                	jbe    801013 <file_read+0x30>
		n = size - offset;
  80100f:	89 d6                	mov    %edx,%esi
  801011:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801013:	83 ec 0c             	sub    $0xc,%esp
  801016:	ff 75 08             	pushl  0x8(%ebp)
  801019:	e8 7e f9 ff ff       	call   80099c <fd2data>
  80101e:	89 c3                	mov    %eax,%ebx
  801020:	01 fb                	add    %edi,%ebx
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	eb 41                	jmp    801068 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801027:	89 d8                	mov    %ebx,%eax
  801029:	c1 e8 16             	shr    $0x16,%eax
  80102c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801033:	a8 01                	test   $0x1,%al
  801035:	74 10                	je     801047 <file_read+0x64>
  801037:	89 d8                	mov    %ebx,%eax
  801039:	c1 e8 0c             	shr    $0xc,%eax
  80103c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801043:	a8 01                	test   $0x1,%al
  801045:	75 1b                	jne    801062 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801047:	83 ec 04             	sub    $0x4,%esp
  80104a:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80104d:	50                   	push   %eax
  80104e:	57                   	push   %edi
  80104f:	ff 75 08             	pushl  0x8(%ebp)
  801052:	e8 d4 02 00 00       	call   80132b <fmap>
  801057:	83 c4 10             	add    $0x10,%esp
              return r;
  80105a:	89 c1                	mov    %eax,%ecx
  80105c:	85 c0                	test   %eax,%eax
  80105e:	78 3d                	js     80109d <file_read+0xba>
  801060:	eb 1c                	jmp    80107e <file_read+0x9b>
  801062:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801068:	83 ec 0c             	sub    $0xc,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	e8 29 f9 ff ff       	call   80099c <fd2data>
  801073:	01 f8                	add    %edi,%eax
  801075:	01 f0                	add    %esi,%eax
  801077:	83 c4 10             	add    $0x10,%esp
  80107a:	39 d8                	cmp    %ebx,%eax
  80107c:	77 a9                	ja     801027 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80107e:	83 ec 04             	sub    $0x4,%esp
  801081:	56                   	push   %esi
  801082:	83 ec 04             	sub    $0x4,%esp
  801085:	ff 75 08             	pushl  0x8(%ebp)
  801088:	e8 0f f9 ff ff       	call   80099c <fd2data>
  80108d:	83 c4 08             	add    $0x8,%esp
  801090:	01 f8                	add    %edi,%eax
  801092:	50                   	push   %eax
  801093:	ff 75 0c             	pushl  0xc(%ebp)
  801096:	e8 51 f3 ff ff       	call   8003ec <memmove>
	return n;
  80109b:	89 f1                	mov    %esi,%ecx
}
  80109d:	89 c8                	mov    %ecx,%eax
  80109f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010a2:	5b                   	pop    %ebx
  8010a3:	5e                   	pop    %esi
  8010a4:	5f                   	pop    %edi
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 18             	sub    $0x18,%esp
  8010af:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010b2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8010b5:	50                   	push   %eax
  8010b6:	ff 75 08             	pushl  0x8(%ebp)
  8010b9:	e8 60 f9 ff ff       	call   800a1e <fd_lookup>
  8010be:	83 c4 10             	add    $0x10,%esp
		return r;
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	0f 88 9f 00 00 00    	js     80116a <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8010cb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8010ce:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8010d0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010d5:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  8010db:	0f 85 89 00 00 00    	jne    80116a <read_map+0xc3>
	va = fd2data(fd) + offset;
  8010e1:	83 ec 0c             	sub    $0xc,%esp
  8010e4:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8010e7:	e8 b0 f8 ff ff       	call   80099c <fd2data>
  8010ec:	89 c3                	mov    %eax,%ebx
  8010ee:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8010f0:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8010f3:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8010f8:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  8010fe:	7f 6a                	jg     80116a <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801100:	89 d8                	mov    %ebx,%eax
  801102:	c1 e8 16             	shr    $0x16,%eax
  801105:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80110c:	a8 01                	test   $0x1,%al
  80110e:	74 10                	je     801120 <read_map+0x79>
  801110:	89 d8                	mov    %ebx,%eax
  801112:	c1 e8 0c             	shr    $0xc,%eax
  801115:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80111c:	a8 01                	test   $0x1,%al
  80111e:	75 19                	jne    801139 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801120:	83 ec 04             	sub    $0x4,%esp
  801123:	8d 46 01             	lea    0x1(%esi),%eax
  801126:	50                   	push   %eax
  801127:	56                   	push   %esi
  801128:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80112b:	e8 fb 01 00 00       	call   80132b <fmap>
  801130:	83 c4 10             	add    $0x10,%esp
            return r;
  801133:	89 c2                	mov    %eax,%edx
  801135:	85 c0                	test   %eax,%eax
  801137:	78 31                	js     80116a <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801139:	89 d8                	mov    %ebx,%eax
  80113b:	c1 e8 16             	shr    $0x16,%eax
  80113e:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801145:	a8 01                	test   $0x1,%al
  801147:	74 10                	je     801159 <read_map+0xb2>
  801149:	89 d8                	mov    %ebx,%eax
  80114b:	c1 e8 0c             	shr    $0xc,%eax
  80114e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801155:	a8 01                	test   $0x1,%al
  801157:	75 07                	jne    801160 <read_map+0xb9>
		return -E_NO_DISK;
  801159:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80115e:	eb 0a                	jmp    80116a <read_map+0xc3>

	*blk = (void*) va;
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	89 18                	mov    %ebx,(%eax)
	return 0;
  801165:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80116a:	89 d0                	mov    %edx,%eax
  80116c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80116f:	5b                   	pop    %ebx
  801170:	5e                   	pop    %esi
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	8b 75 08             	mov    0x8(%ebp),%esi
  80117f:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801188:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  80118d:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801193:	0f 87 bd 00 00 00    	ja     801256 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801199:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  80119f:	73 17                	jae    8011b8 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	52                   	push   %edx
  8011a5:	56                   	push   %esi
  8011a6:	e8 fb 00 00 00       	call   8012a6 <file_trunc>
  8011ab:	83 c4 10             	add    $0x10,%esp
			return r;
  8011ae:	89 c1                	mov    %eax,%ecx
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	0f 88 9e 00 00 00    	js     801256 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	56                   	push   %esi
  8011bc:	e8 db f7 ff ff       	call   80099c <fd2data>
  8011c1:	89 c3                	mov    %eax,%ebx
  8011c3:	01 fb                	add    %edi,%ebx
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	eb 42                	jmp    80120c <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8011ca:	89 d8                	mov    %ebx,%eax
  8011cc:	c1 e8 16             	shr    $0x16,%eax
  8011cf:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8011d6:	a8 01                	test   $0x1,%al
  8011d8:	74 10                	je     8011ea <file_write+0x77>
  8011da:	89 d8                	mov    %ebx,%eax
  8011dc:	c1 e8 0c             	shr    $0xc,%eax
  8011df:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8011e6:	a8 01                	test   $0x1,%al
  8011e8:	75 1c                	jne    801206 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8011f0:	8d 04 17             	lea    (%edi,%edx,1),%eax
  8011f3:	50                   	push   %eax
  8011f4:	57                   	push   %edi
  8011f5:	56                   	push   %esi
  8011f6:	e8 30 01 00 00       	call   80132b <fmap>
  8011fb:	83 c4 10             	add    $0x10,%esp
              return r;
  8011fe:	89 c1                	mov    %eax,%ecx
  801200:	85 c0                	test   %eax,%eax
  801202:	78 52                	js     801256 <file_write+0xe3>
  801204:	eb 1b                	jmp    801221 <file_write+0xae>
  801206:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	56                   	push   %esi
  801210:	e8 87 f7 ff ff       	call   80099c <fd2data>
  801215:	01 f8                	add    %edi,%eax
  801217:	03 45 10             	add    0x10(%ebp),%eax
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	39 d8                	cmp    %ebx,%eax
  80121f:	77 a9                	ja     8011ca <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801221:	83 ec 0c             	sub    $0xc,%esp
  801224:	68 fe 25 80 00       	push   $0x8025fe
  801229:	e8 a2 09 00 00       	call   801bd0 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  80122e:	83 c4 0c             	add    $0xc,%esp
  801231:	ff 75 10             	pushl  0x10(%ebp)
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	56                   	push   %esi
  801238:	e8 5f f7 ff ff       	call   80099c <fd2data>
  80123d:	01 f8                	add    %edi,%eax
  80123f:	89 04 24             	mov    %eax,(%esp)
  801242:	e8 a5 f1 ff ff       	call   8003ec <memmove>
        cprintf("write done\n");
  801247:	c7 04 24 0b 26 80 00 	movl   $0x80260b,(%esp)
  80124e:	e8 7d 09 00 00       	call   801bd0 <cprintf>
	return n;
  801253:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801256:	89 c8                	mov    %ecx,%eax
  801258:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
  801265:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801268:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	8d 43 10             	lea    0x10(%ebx),%eax
  801271:	50                   	push   %eax
  801272:	56                   	push   %esi
  801273:	e8 f8 ef ff ff       	call   800270 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801278:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  80127e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  80128e:	0f 94 c0             	sete   %al
  801291:	0f b6 c0             	movzbl %al,%eax
  801294:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  80129a:	b8 00 00 00 00       	mov    $0x0,%eax
  80129f:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8012a2:	5b                   	pop    %ebx
  8012a3:	5e                   	pop    %esi
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	57                   	push   %edi
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  8012b5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8012ba:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8012c0:	7f 5f                	jg     801321 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  8012c2:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8012c8:	83 ec 08             	sub    $0x8,%esp
  8012cb:	53                   	push   %ebx
  8012cc:	ff 76 0c             	pushl  0xc(%esi)
  8012cf:	e8 3a 02 00 00       	call   80150e <fsipc_set_size>
  8012d4:	83 c4 10             	add    $0x10,%esp
		return r;
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 44                	js     801321 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  8012dd:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  8012e3:	74 19                	je     8012fe <file_trunc+0x58>
  8012e5:	68 38 26 80 00       	push   $0x802638
  8012ea:	68 17 26 80 00       	push   $0x802617
  8012ef:	68 dc 00 00 00       	push   $0xdc
  8012f4:	68 2c 26 80 00       	push   $0x80262c
  8012f9:	e8 e2 07 00 00       	call   801ae0 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	53                   	push   %ebx
  801302:	57                   	push   %edi
  801303:	56                   	push   %esi
  801304:	e8 22 00 00 00       	call   80132b <fmap>
  801309:	83 c4 10             	add    $0x10,%esp
		return r;
  80130c:	89 c2                	mov    %eax,%edx
  80130e:	85 c0                	test   %eax,%eax
  801310:	78 0f                	js     801321 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801312:	6a 00                	push   $0x0
  801314:	53                   	push   %ebx
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	e8 85 00 00 00       	call   8013a1 <funmap>

	return 0;
  80131c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801321:	89 d0                	mov    %edx,%eax
  801323:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801326:	5b                   	pop    %ebx
  801327:	5e                   	pop    %esi
  801328:	5f                   	pop    %edi
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <fmap>:

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
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	57                   	push   %edi
  80132f:	56                   	push   %esi
  801330:	53                   	push   %ebx
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	8b 7d 08             	mov    0x8(%ebp),%edi
  801337:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  80133a:	39 75 0c             	cmp    %esi,0xc(%ebp)
  80133d:	7d 55                	jge    801394 <fmap+0x69>
          fma = fd2data(fd);
  80133f:	83 ec 0c             	sub    $0xc,%esp
  801342:	57                   	push   %edi
  801343:	e8 54 f6 ff ff       	call   80099c <fd2data>
  801348:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	05 ff 0f 00 00       	add    $0xfff,%eax
  801356:	89 c3                	mov    %eax,%ebx
  801358:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80135e:	39 f3                	cmp    %esi,%ebx
  801360:	7d 32                	jge    801394 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801368:	01 d8                	add    %ebx,%eax
  80136a:	50                   	push   %eax
  80136b:	53                   	push   %ebx
  80136c:	ff 77 0c             	pushl  0xc(%edi)
  80136f:	e8 6f 01 00 00       	call   8014e3 <fsipc_map>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	79 0f                	jns    80138a <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  80137b:	6a 00                	push   $0x0
  80137d:	ff 75 0c             	pushl  0xc(%ebp)
  801380:	53                   	push   %ebx
  801381:	57                   	push   %edi
  801382:	e8 1a 00 00 00       	call   8013a1 <funmap>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801390:	39 f3                	cmp    %esi,%ebx
  801392:	7c ce                	jl     801362 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
  801399:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80139c:	5b                   	pop    %ebx
  80139d:	5e                   	pop    %esi
  80139e:	5f                   	pop    %edi
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <funmap>:

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
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	57                   	push   %edi
  8013a5:	56                   	push   %esi
  8013a6:	53                   	push   %ebx
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  8013b0:	39 f3                	cmp    %esi,%ebx
  8013b2:	0f 8d 80 00 00 00    	jge    801438 <funmap+0x97>
          fma = fd2data(fd);
  8013b8:	83 ec 0c             	sub    $0xc,%esp
  8013bb:	ff 75 08             	pushl  0x8(%ebp)
  8013be:	e8 d9 f5 ff ff       	call   80099c <fd2data>
  8013c3:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8013ce:	89 c3                	mov    %eax,%ebx
  8013d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8013d6:	39 f3                	cmp    %esi,%ebx
  8013d8:	7d 5e                	jge    801438 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  8013da:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8013dd:	89 c2                	mov    %eax,%edx
  8013df:	c1 ea 0c             	shr    $0xc,%edx
  8013e2:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8013e9:	a8 01                	test   $0x1,%al
  8013eb:	74 41                	je     80142e <funmap+0x8d>
              if (dirty) {
  8013ed:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8013f1:	74 21                	je     801414 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  8013f3:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8013fa:	a8 40                	test   $0x40,%al
  8013fc:	74 16                	je     801414 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  8013fe:	83 ec 08             	sub    $0x8,%esp
  801401:	53                   	push   %ebx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	ff 70 0c             	pushl  0xc(%eax)
  801408:	e8 49 01 00 00       	call   801556 <fsipc_dirty>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	78 29                	js     80143d <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80141a:	50                   	push   %eax
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	e8 e1 f1 ff ff       	call   800604 <sys_getenvid>
  801423:	89 04 24             	mov    %eax,(%esp)
  801426:	e8 9c f2 ff ff       	call   8006c7 <sys_page_unmap>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801434:	39 f3                	cmp    %esi,%ebx
  801436:	7c a2                	jl     8013da <funmap+0x39>
            }
          }
        }

        return 0;
  801438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801440:	5b                   	pop    %ebx
  801441:	5e                   	pop    %esi
  801442:	5f                   	pop    %edi
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <remove>:

// Delete a file
int
remove(const char *path)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  80144b:	ff 75 08             	pushl  0x8(%ebp)
  80144e:	e8 2b 01 00 00       	call   80157e <fsipc_remove>
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  80145b:	e8 64 01 00 00       	call   8015c4 <fsipc_sync>
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    
	...

00801464 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80146a:	6a 07                	push   $0x7
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801477:	50                   	push   %eax
  801478:	e8 7e 0c 00 00       	call   8020fb <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  80147d:	83 c4 0c             	add    $0xc,%esp
  801480:	ff 75 14             	pushl  0x14(%ebp)
  801483:	ff 75 10             	pushl  0x10(%ebp)
  801486:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801489:	50                   	push   %eax
  80148a:	e8 09 0c 00 00       	call   802098 <ipc_recv>
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	56                   	push   %esi
  801495:	53                   	push   %ebx
  801496:	83 ec 1c             	sub    $0x1c,%esp
  801499:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  80149c:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  8014a1:	56                   	push   %esi
  8014a2:	e8 8d ed ff ff       	call   800234 <strlen>
  8014a7:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8014aa:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8014af:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014b4:	7f 24                	jg     8014da <fsipc_open+0x49>
	strcpy(req->req_path, path);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
  8014bb:	e8 b0 ed ff ff       	call   800270 <strcpy>
	req->req_omode = omode;
  8014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c3:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8014c9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	ff 75 10             	pushl  0x10(%ebp)
  8014d0:	53                   	push   %ebx
  8014d1:	6a 01                	push   $0x1
  8014d3:	e8 8c ff ff ff       	call   801464 <fsipc>
  8014d8:	89 c2                	mov    %eax,%edx
}
  8014da:	89 d0                	mov    %edx,%eax
  8014dc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  8014f9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 10             	pushl  0x10(%ebp)
  801500:	68 00 30 80 00       	push   $0x803000
  801505:	6a 02                	push   $0x2
  801507:	e8 58 ff ff ff       	call   801464 <fsipc>

	//return -E_UNSPECIFIED;
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	68 00 30 80 00       	push   $0x803000
  80152d:	6a 03                	push   $0x3
  80152f:	e8 30 ff ff ff       	call   801464 <fsipc>
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	68 00 30 80 00       	push   $0x803000
  80154d:	6a 04                	push   $0x4
  80154f:	e8 10 ff ff ff       	call   801464 <fsipc>
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801564:	8b 45 0c             	mov    0xc(%ebp),%eax
  801567:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	68 00 30 80 00       	push   $0x803000
  801575:	6a 05                	push   $0x5
  801577:	e8 e8 fe ff ff       	call   801464 <fsipc>
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	56                   	push   %esi
  801582:	53                   	push   %ebx
  801583:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801586:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  80158b:	83 ec 0c             	sub    $0xc,%esp
  80158e:	53                   	push   %ebx
  80158f:	e8 a0 ec ff ff       	call   800234 <strlen>
  801594:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801597:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80159c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015a1:	7f 18                	jg     8015bb <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	53                   	push   %ebx
  8015a7:	56                   	push   %esi
  8015a8:	e8 c3 ec ff ff       	call   800270 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	56                   	push   %esi
  8015b2:	6a 06                	push   $0x6
  8015b4:	e8 ab fe ff ff       	call   801464 <fsipc>
  8015b9:	89 c2                	mov    %eax,%edx
}
  8015bb:	89 d0                	mov    %edx,%eax
  8015bd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8015c0:	5b                   	pop    %ebx
  8015c1:	5e                   	pop    %esi
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	68 00 30 80 00       	push   $0x803000
  8015d3:	6a 07                	push   $0x7
  8015d5:	e8 8a fe ff ff       	call   801464 <fsipc>
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <pipe>:
};

int
pipe(int pfd[2])
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	57                   	push   %edi
  8015e0:	56                   	push   %esi
  8015e1:	53                   	push   %ebx
  8015e2:	83 ec 18             	sub    $0x18,%esp
  8015e5:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015e8:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8015eb:	50                   	push   %eax
  8015ec:	e8 d3 f3 ff ff       	call   8009c4 <fd_alloc>
  8015f1:	89 c3                	mov    %eax,%ebx
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	0f 88 25 01 00 00    	js     801723 <pipe+0x147>
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 07 04 00 00       	push   $0x407
  801606:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801609:	6a 00                	push   $0x0
  80160b:	e8 32 f0 ff ff       	call   800642 <sys_page_alloc>
  801610:	89 c3                	mov    %eax,%ebx
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	85 c0                	test   %eax,%eax
  801617:	0f 88 06 01 00 00    	js     801723 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80161d:	83 ec 0c             	sub    $0xc,%esp
  801620:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	e8 9b f3 ff ff       	call   8009c4 <fd_alloc>
  801629:	89 c3                	mov    %eax,%ebx
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	85 c0                	test   %eax,%eax
  801630:	0f 88 dd 00 00 00    	js     801713 <pipe+0x137>
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 07 04 00 00       	push   $0x407
  80163e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801641:	6a 00                	push   $0x0
  801643:	e8 fa ef ff ff       	call   800642 <sys_page_alloc>
  801648:	89 c3                	mov    %eax,%ebx
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	85 c0                	test   %eax,%eax
  80164f:	0f 88 be 00 00 00    	js     801713 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801655:	83 ec 0c             	sub    $0xc,%esp
  801658:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80165b:	e8 3c f3 ff ff       	call   80099c <fd2data>
  801660:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801662:	83 c4 0c             	add    $0xc,%esp
  801665:	68 07 04 00 00       	push   $0x407
  80166a:	50                   	push   %eax
  80166b:	6a 00                	push   $0x0
  80166d:	e8 d0 ef ff ff       	call   800642 <sys_page_alloc>
  801672:	89 c3                	mov    %eax,%ebx
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	0f 88 84 00 00 00    	js     801703 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 07 04 00 00       	push   $0x407
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80168d:	e8 0a f3 ff ff       	call   80099c <fd2data>
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	50                   	push   %eax
  801696:	6a 00                	push   $0x0
  801698:	56                   	push   %esi
  801699:	6a 00                	push   $0x0
  80169b:	e8 e5 ef ff ff       	call   800685 <sys_page_map>
  8016a0:	89 c3                	mov    %eax,%ebx
  8016a2:	83 c4 20             	add    $0x20,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 4c                	js     8016f5 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016a9:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8016af:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8016b2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8016b4:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8016b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8016be:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8016c4:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8016c7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8016c9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8016cc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8016d3:	83 ec 0c             	sub    $0xc,%esp
  8016d6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8016d9:	e8 d6 f2 ff ff       	call   8009b4 <fd2num>
  8016de:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8016e0:	83 c4 04             	add    $0x4,%esp
  8016e3:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8016e6:	e8 c9 f2 ff ff       	call   8009b4 <fd2num>
  8016eb:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	eb 30                	jmp    801725 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	56                   	push   %esi
  8016f9:	6a 00                	push   $0x0
  8016fb:	e8 c7 ef ff ff       	call   8006c7 <sys_page_unmap>
  801700:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801703:	83 ec 08             	sub    $0x8,%esp
  801706:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801709:	6a 00                	push   $0x0
  80170b:	e8 b7 ef ff ff       	call   8006c7 <sys_page_unmap>
  801710:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801713:	83 ec 08             	sub    $0x8,%esp
  801716:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801719:	6a 00                	push   $0x0
  80171b:	e8 a7 ef ff ff       	call   8006c7 <sys_page_unmap>
  801720:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  801723:	89 d8                	mov    %ebx,%eax
}
  801725:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801728:	5b                   	pop    %ebx
  801729:	5e                   	pop    %esi
  80172a:	5f                   	pop    %edi
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	57                   	push   %edi
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801739:	a1 80 60 80 00       	mov    0x806080,%eax
  80173e:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801741:	83 ec 0c             	sub    $0xc,%esp
  801744:	ff 75 08             	pushl  0x8(%ebp)
  801747:	e8 08 0a 00 00       	call   802154 <pageref>
  80174c:	89 c3                	mov    %eax,%ebx
  80174e:	89 3c 24             	mov    %edi,(%esp)
  801751:	e8 fe 09 00 00       	call   802154 <pageref>
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	39 c3                	cmp    %eax,%ebx
  80175b:	0f 94 c0             	sete   %al
  80175e:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801761:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  801767:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80176a:	39 c6                	cmp    %eax,%esi
  80176c:	74 1b                	je     801789 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80176e:	83 fa 01             	cmp    $0x1,%edx
  801771:	75 c6                	jne    801739 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801773:	6a 01                	push   $0x1
  801775:	8b 41 58             	mov    0x58(%ecx),%eax
  801778:	50                   	push   %eax
  801779:	56                   	push   %esi
  80177a:	68 60 26 80 00       	push   $0x802660
  80177f:	e8 4c 04 00 00       	call   801bd0 <cprintf>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	eb b0                	jmp    801739 <_pipeisclosed+0xc>
	}
}
  801789:	89 d0                	mov    %edx,%eax
  80178b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80178e:	5b                   	pop    %ebx
  80178f:	5e                   	pop    %esi
  801790:	5f                   	pop    %edi
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801799:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80179c:	50                   	push   %eax
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	e8 79 f2 ff ff       	call   800a1e <fd_lookup>
  8017a5:	83 c4 10             	add    $0x10,%esp
		return r;
  8017a8:	89 c2                	mov    %eax,%edx
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 19                	js     8017c7 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8017b4:	e8 e3 f1 ff ff       	call   80099c <fd2data>
	return _pipeisclosed(fd, p);
  8017b9:	83 c4 08             	add    $0x8,%esp
  8017bc:	50                   	push   %eax
  8017bd:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8017c0:	e8 68 ff ff ff       	call   80172d <_pipeisclosed>
  8017c5:	89 c2                	mov    %eax,%edx
}
  8017c7:	89 d0                	mov    %edx,%eax
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	57                   	push   %edi
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 18             	sub    $0x18,%esp
  8017d4:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  8017d7:	57                   	push   %edi
  8017d8:	e8 bf f1 ff ff       	call   80099c <fd2data>
  8017dd:	89 c3                	mov    %eax,%ebx
	if (debug)
  8017df:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8017e8:	be 00 00 00 00       	mov    $0x0,%esi
  8017ed:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017f0:	73 55                	jae    801847 <piperead+0x7c>
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
  8017f2:	8b 03                	mov    (%ebx),%eax
  8017f4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017f7:	75 2c                	jne    801825 <piperead+0x5a>
  8017f9:	85 f6                	test   %esi,%esi
  8017fb:	74 04                	je     801801 <piperead+0x36>
  8017fd:	89 f0                	mov    %esi,%eax
  8017ff:	eb 48                	jmp    801849 <piperead+0x7e>
  801801:	83 ec 08             	sub    $0x8,%esp
  801804:	53                   	push   %ebx
  801805:	57                   	push   %edi
  801806:	e8 22 ff ff ff       	call   80172d <_pipeisclosed>
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	74 07                	je     801819 <piperead+0x4e>
  801812:	b8 00 00 00 00       	mov    $0x0,%eax
  801817:	eb 30                	jmp    801849 <piperead+0x7e>
  801819:	e8 05 ee ff ff       	call   800623 <sys_yield>
  80181e:	8b 03                	mov    (%ebx),%eax
  801820:	3b 43 04             	cmp    0x4(%ebx),%eax
  801823:	74 d4                	je     8017f9 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801825:	8b 13                	mov    (%ebx),%edx
  801827:	89 d0                	mov    %edx,%eax
  801829:	85 d2                	test   %edx,%edx
  80182b:	79 03                	jns    801830 <piperead+0x65>
  80182d:	8d 42 1f             	lea    0x1f(%edx),%eax
  801830:	83 e0 e0             	and    $0xffffffe0,%eax
  801833:	29 c2                	sub    %eax,%edx
  801835:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801839:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80183c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80183f:	ff 03                	incl   (%ebx)
  801841:	46                   	inc    %esi
  801842:	3b 75 10             	cmp    0x10(%ebp),%esi
  801845:	72 ab                	jb     8017f2 <piperead+0x27>
	}
	return i;
  801847:	89 f0                	mov    %esi,%eax
}
  801849:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80184c:	5b                   	pop    %ebx
  80184d:	5e                   	pop    %esi
  80184e:	5f                   	pop    %edi
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	57                   	push   %edi
  801855:	56                   	push   %esi
  801856:	53                   	push   %ebx
  801857:	83 ec 18             	sub    $0x18,%esp
  80185a:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  80185d:	57                   	push   %edi
  80185e:	e8 39 f1 ff ff       	call   80099c <fd2data>
  801863:	89 c3                	mov    %eax,%ebx
	if (debug)
  801865:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80186e:	be 00 00 00 00       	mov    $0x0,%esi
  801873:	3b 75 10             	cmp    0x10(%ebp),%esi
  801876:	73 55                	jae    8018cd <pipewrite+0x7c>
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
  801878:	8b 03                	mov    (%ebx),%eax
  80187a:	83 c0 20             	add    $0x20,%eax
  80187d:	39 43 04             	cmp    %eax,0x4(%ebx)
  801880:	72 27                	jb     8018a9 <pipewrite+0x58>
  801882:	83 ec 08             	sub    $0x8,%esp
  801885:	53                   	push   %ebx
  801886:	57                   	push   %edi
  801887:	e8 a1 fe ff ff       	call   80172d <_pipeisclosed>
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	85 c0                	test   %eax,%eax
  801891:	74 07                	je     80189a <pipewrite+0x49>
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
  801898:	eb 35                	jmp    8018cf <pipewrite+0x7e>
  80189a:	e8 84 ed ff ff       	call   800623 <sys_yield>
  80189f:	8b 03                	mov    (%ebx),%eax
  8018a1:	83 c0 20             	add    $0x20,%eax
  8018a4:	39 43 04             	cmp    %eax,0x4(%ebx)
  8018a7:	73 d9                	jae    801882 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018a9:	8b 53 04             	mov    0x4(%ebx),%edx
  8018ac:	89 d0                	mov    %edx,%eax
  8018ae:	85 d2                	test   %edx,%edx
  8018b0:	79 03                	jns    8018b5 <pipewrite+0x64>
  8018b2:	8d 42 1f             	lea    0x1f(%edx),%eax
  8018b5:	83 e0 e0             	and    $0xffffffe0,%eax
  8018b8:	29 c2                	sub    %eax,%edx
  8018ba:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8018bd:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8018c0:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018c4:	ff 43 04             	incl   0x4(%ebx)
  8018c7:	46                   	inc    %esi
  8018c8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018cb:	72 ab                	jb     801878 <pipewrite+0x27>
	}
	
	return i;
  8018cd:	89 f0                	mov    %esi,%eax
}
  8018cf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5e                   	pop    %esi
  8018d4:	5f                   	pop    %edi
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
  8018dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	e8 b2 f0 ff ff       	call   80099c <fd2data>
  8018ea:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018ec:	83 c4 08             	add    $0x8,%esp
  8018ef:	68 73 26 80 00       	push   $0x802673
  8018f4:	53                   	push   %ebx
  8018f5:	e8 76 e9 ff ff       	call   800270 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018fa:	8b 46 04             	mov    0x4(%esi),%eax
  8018fd:	2b 06                	sub    (%esi),%eax
  8018ff:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801905:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80190c:	00 00 00 
	stat->st_dev = &devpipe;
  80190f:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  801916:	60 80 00 
	return 0;
}
  801919:	b8 00 00 00 00       	mov    $0x0,%eax
  80191e:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	53                   	push   %ebx
  801929:	83 ec 0c             	sub    $0xc,%esp
  80192c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80192f:	53                   	push   %ebx
  801930:	6a 00                	push   $0x0
  801932:	e8 90 ed ff ff       	call   8006c7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801937:	89 1c 24             	mov    %ebx,(%esp)
  80193a:	e8 5d f0 ff ff       	call   80099c <fd2data>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	50                   	push   %eax
  801943:	6a 00                	push   $0x0
  801945:	e8 7d ed ff ff       	call   8006c7 <sys_page_unmap>
}
  80194a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    
	...

00801950 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80195c:	6a 01                	push   $0x1
  80195e:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801961:	50                   	push   %eax
  801962:	e8 19 ec ff ff       	call   800580 <sys_cputs>
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <getchar>:

int
getchar(void)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80196f:	6a 01                	push   $0x1
  801971:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801974:	50                   	push   %eax
  801975:	6a 00                	push   $0x0
  801977:	e8 35 f3 ff ff       	call   800cb1 <read>
	if (r < 0)
  80197c:	83 c4 10             	add    $0x10,%esp
		return r;
  80197f:	89 c2                	mov    %eax,%edx
  801981:	85 c0                	test   %eax,%eax
  801983:	78 0d                	js     801992 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  801985:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  80198a:	85 c0                	test   %eax,%eax
  80198c:	7e 04                	jle    801992 <getchar+0x29>
	return c;
  80198e:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  801992:	89 d0                	mov    %edx,%eax
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <iscons>:


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
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80199c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80199f:	50                   	push   %eax
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	e8 76 f0 ff ff       	call   800a1e <fd_lookup>
  8019a8:	83 c4 10             	add    $0x10,%esp
		return r;
  8019ab:	89 c2                	mov    %eax,%edx
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	78 11                	js     8019c2 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8019b1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8019b4:	8b 00                	mov    (%eax),%eax
  8019b6:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  8019bc:	0f 94 c0             	sete   %al
  8019bf:	0f b6 d0             	movzbl %al,%edx
}
  8019c2:	89 d0                	mov    %edx,%eax
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <opencons>:

int
opencons(void)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8019cc:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	e8 ef ef ff ff       	call   8009c4 <fd_alloc>
  8019d5:	83 c4 10             	add    $0x10,%esp
		return r;
  8019d8:	89 c2                	mov    %eax,%edx
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 3c                	js     801a1a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	68 07 04 00 00       	push   $0x407
  8019e6:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8019e9:	6a 00                	push   $0x0
  8019eb:	e8 52 ec ff ff       	call   800642 <sys_page_alloc>
  8019f0:	83 c4 10             	add    $0x10,%esp
		return r;
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 21                	js     801a1a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8019f9:	a1 60 60 80 00       	mov    0x806060,%eax
  8019fe:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  801a01:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  801a03:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801a06:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801a13:	e8 9c ef ff ff       	call   8009b4 <fd2num>
  801a18:	89 c2                	mov    %eax,%edx
}
  801a1a:	89 d0                	mov    %edx,%eax
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
  801a29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a2d:	74 2a                	je     801a59 <cons_read+0x3b>
  801a2f:	eb 05                	jmp    801a36 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801a31:	e8 ed eb ff ff       	call   800623 <sys_yield>
  801a36:	e8 69 eb ff ff       	call   8005a4 <sys_cgetc>
  801a3b:	89 c2                	mov    %eax,%edx
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 f0                	je     801a31 <cons_read+0x13>
	if (c < 0)
  801a41:	85 d2                	test   %edx,%edx
  801a43:	78 14                	js     801a59 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4a:	83 fa 04             	cmp    $0x4,%edx
  801a4d:	74 0a                	je     801a59 <cons_read+0x3b>
	*(char*)vbuf = c;
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	88 10                	mov    %dl,(%eax)
	return 1;
  801a54:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	57                   	push   %edi
  801a5f:	56                   	push   %esi
  801a60:	53                   	push   %ebx
  801a61:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  801a67:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a6a:	be 00 00 00 00       	mov    $0x0,%esi
  801a6f:	39 fe                	cmp    %edi,%esi
  801a71:	73 3d                	jae    801ab0 <cons_write+0x55>
		m = n - tot;
  801a73:	89 fb                	mov    %edi,%ebx
  801a75:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801a77:	83 fb 7f             	cmp    $0x7f,%ebx
  801a7a:	76 05                	jbe    801a81 <cons_write+0x26>
			m = sizeof(buf) - 1;
  801a7c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	53                   	push   %ebx
  801a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a88:	01 f0                	add    %esi,%eax
  801a8a:	50                   	push   %eax
  801a8b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  801a91:	50                   	push   %eax
  801a92:	e8 55 e9 ff ff       	call   8003ec <memmove>
		sys_cputs(buf, m);
  801a97:	83 c4 08             	add    $0x8,%esp
  801a9a:	53                   	push   %ebx
  801a9b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  801aa1:	50                   	push   %eax
  801aa2:	e8 d9 ea ff ff       	call   800580 <sys_cputs>
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	01 de                	add    %ebx,%esi
  801aac:	39 fe                	cmp    %edi,%esi
  801aae:	72 c3                	jb     801a73 <cons_write+0x18>
	}
	return tot;
}
  801ab0:	89 f0                	mov    %esi,%eax
  801ab2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ab5:	5b                   	pop    %ebx
  801ab6:	5e                   	pop    %esi
  801ab7:	5f                   	pop    %edi
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <cons_close>:

int
cons_close(struct Fd *fd)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801abd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801aca:	68 7f 26 80 00       	push   $0x80267f
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	e8 99 e7 ff ff       	call   800270 <strcpy>
	return 0;
}
  801ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  801adc:	c9                   	leave  
  801add:	c3                   	ret    
	...

00801ae0 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  801ae7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  801aea:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  801af1:	74 16                	je     801b09 <_panic+0x29>
		cprintf("%s: ", argv0);
  801af3:	83 ec 08             	sub    $0x8,%esp
  801af6:	ff 35 84 60 80 00    	pushl  0x806084
  801afc:	68 86 26 80 00       	push   $0x802686
  801b01:	e8 ca 00 00 00       	call   801bd0 <cprintf>
  801b06:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	ff 35 00 60 80 00    	pushl  0x806000
  801b15:	68 8b 26 80 00       	push   $0x80268b
  801b1a:	e8 b1 00 00 00       	call   801bd0 <cprintf>
	vcprintf(fmt, ap);
  801b1f:	83 c4 08             	add    $0x8,%esp
  801b22:	53                   	push   %ebx
  801b23:	ff 75 10             	pushl  0x10(%ebp)
  801b26:	e8 54 00 00 00       	call   801b7f <vcprintf>
	cprintf("\n");
  801b2b:	c7 04 24 71 26 80 00 	movl   $0x802671,(%esp)
  801b32:	e8 99 00 00 00       	call   801bd0 <cprintf>

	// Cause a breakpoint exception
	while (1)
  801b37:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  801b3a:	cc                   	int3   
  801b3b:	eb fd                	jmp    801b3a <_panic+0x5a>
  801b3d:	00 00                	add    %al,(%eax)
	...

00801b40 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	53                   	push   %ebx
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801b4a:	8b 03                	mov    (%ebx),%eax
  801b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b4f:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  801b53:	40                   	inc    %eax
  801b54:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801b56:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b5b:	75 1a                	jne    801b77 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  801b5d:	83 ec 08             	sub    $0x8,%esp
  801b60:	68 ff 00 00 00       	push   $0xff
  801b65:	8d 43 08             	lea    0x8(%ebx),%eax
  801b68:	50                   	push   %eax
  801b69:	e8 12 ea ff ff       	call   800580 <sys_cputs>
		b->idx = 0;
  801b6e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b74:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801b77:	ff 43 04             	incl   0x4(%ebx)
}
  801b7a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b88:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  801b8f:	00 00 00 
	b.cnt = 0;
  801b92:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  801b99:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  801ba8:	50                   	push   %eax
  801ba9:	68 40 1b 80 00       	push   $0x801b40
  801bae:	e8 4f 01 00 00       	call   801d02 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801bb3:	83 c4 08             	add    $0x8,%esp
  801bb6:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  801bbc:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  801bc2:	50                   	push   %eax
  801bc3:	e8 b8 e9 ff ff       	call   800580 <sys_cputs>

	return b.cnt;
  801bc8:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bd6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801bd9:	50                   	push   %eax
  801bda:	ff 75 08             	pushl  0x8(%ebp)
  801bdd:	e8 9d ff ff ff       	call   801b7f <vcprintf>
	va_end(ap);

	return cnt;
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	57                   	push   %edi
  801be8:	56                   	push   %esi
  801be9:	53                   	push   %ebx
  801bea:	83 ec 0c             	sub    $0xc,%esp
  801bed:	8b 75 10             	mov    0x10(%ebp),%esi
  801bf0:	8b 7d 14             	mov    0x14(%ebp),%edi
  801bf3:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801bf6:	8b 45 18             	mov    0x18(%ebp),%eax
  801bf9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfe:	39 fa                	cmp    %edi,%edx
  801c00:	77 39                	ja     801c3b <printnum+0x57>
  801c02:	72 04                	jb     801c08 <printnum+0x24>
  801c04:	39 f0                	cmp    %esi,%eax
  801c06:	77 33                	ja     801c3b <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	ff 75 20             	pushl  0x20(%ebp)
  801c0e:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  801c11:	50                   	push   %eax
  801c12:	ff 75 18             	pushl  0x18(%ebp)
  801c15:	8b 45 18             	mov    0x18(%ebp),%eax
  801c18:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	57                   	push   %edi
  801c20:	56                   	push   %esi
  801c21:	e8 76 05 00 00       	call   80219c <__udivdi3>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	52                   	push   %edx
  801c2a:	50                   	push   %eax
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	e8 ae ff ff ff       	call   801be4 <printnum>
  801c36:	83 c4 20             	add    $0x20,%esp
  801c39:	eb 19                	jmp    801c54 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c3b:	4b                   	dec    %ebx
  801c3c:	85 db                	test   %ebx,%ebx
  801c3e:	7e 14                	jle    801c54 <printnum+0x70>
  801c40:	83 ec 08             	sub    $0x8,%esp
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	ff 75 20             	pushl  0x20(%ebp)
  801c49:	ff 55 08             	call   *0x8(%ebp)
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	4b                   	dec    %ebx
  801c50:	85 db                	test   %ebx,%ebx
  801c52:	7f ec                	jg     801c40 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801c54:	83 ec 08             	sub    $0x8,%esp
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	8b 45 18             	mov    0x18(%ebp),%eax
  801c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	52                   	push   %edx
  801c66:	50                   	push   %eax
  801c67:	57                   	push   %edi
  801c68:	56                   	push   %esi
  801c69:	e8 3a 06 00 00       	call   8022a8 <__umoddi3>
  801c6e:	83 c4 14             	add    $0x14,%esp
  801c71:	0f be 80 a1 27 80 00 	movsbl 0x8027a1(%eax),%eax
  801c78:	50                   	push   %eax
  801c79:	ff 55 08             	call   *0x8(%ebp)
}
  801c7c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c7f:	5b                   	pop    %ebx
  801c80:	5e                   	pop    %esi
  801c81:	5f                   	pop    %edi
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  801c8d:	83 f8 01             	cmp    $0x1,%eax
  801c90:	7e 0f                	jle    801ca1 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  801c92:	8b 01                	mov    (%ecx),%eax
  801c94:	83 c0 08             	add    $0x8,%eax
  801c97:	89 01                	mov    %eax,(%ecx)
  801c99:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  801c9c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  801c9f:	eb 24                	jmp    801cc5 <getuint+0x41>
	else if (lflag)
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	74 11                	je     801cb6 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  801ca5:	8b 01                	mov    (%ecx),%eax
  801ca7:	83 c0 04             	add    $0x4,%eax
  801caa:	89 01                	mov    %eax,(%ecx)
  801cac:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801caf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb4:	eb 0f                	jmp    801cc5 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  801cb6:	8b 01                	mov    (%ecx),%eax
  801cb8:	83 c0 04             	add    $0x4,%eax
  801cbb:	89 01                	mov    %eax,(%ecx)
  801cbd:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801cc0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	8b 55 08             	mov    0x8(%ebp),%edx
  801ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  801cd0:	83 f8 01             	cmp    $0x1,%eax
  801cd3:	7e 0f                	jle    801ce4 <getint+0x1d>
		return va_arg(*ap, long long);
  801cd5:	8b 02                	mov    (%edx),%eax
  801cd7:	83 c0 08             	add    $0x8,%eax
  801cda:	89 02                	mov    %eax,(%edx)
  801cdc:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  801cdf:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  801ce2:	eb 1c                	jmp    801d00 <getint+0x39>
	else if (lflag)
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	74 0d                	je     801cf5 <getint+0x2e>
		return va_arg(*ap, long);
  801ce8:	8b 02                	mov    (%edx),%eax
  801cea:	83 c0 04             	add    $0x4,%eax
  801ced:	89 02                	mov    %eax,(%edx)
  801cef:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801cf2:	99                   	cltd   
  801cf3:	eb 0b                	jmp    801d00 <getint+0x39>
	else
		return va_arg(*ap, int);
  801cf5:	8b 02                	mov    (%edx),%eax
  801cf7:	83 c0 04             	add    $0x4,%eax
  801cfa:	89 02                	mov    %eax,(%edx)
  801cfc:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801cff:	99                   	cltd   
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	57                   	push   %edi
  801d06:	56                   	push   %esi
  801d07:	53                   	push   %ebx
  801d08:	83 ec 1c             	sub    $0x1c,%esp
  801d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  801d0e:	0f b6 13             	movzbl (%ebx),%edx
  801d11:	43                   	inc    %ebx
  801d12:	83 fa 25             	cmp    $0x25,%edx
  801d15:	74 1e                	je     801d35 <vprintfmt+0x33>
  801d17:	85 d2                	test   %edx,%edx
  801d19:	0f 84 d7 02 00 00    	je     801ff6 <vprintfmt+0x2f4>
  801d1f:	83 ec 08             	sub    $0x8,%esp
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	52                   	push   %edx
  801d26:	ff 55 08             	call   *0x8(%ebp)
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	0f b6 13             	movzbl (%ebx),%edx
  801d2f:	43                   	inc    %ebx
  801d30:	83 fa 25             	cmp    $0x25,%edx
  801d33:	75 e2                	jne    801d17 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  801d35:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  801d39:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  801d40:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  801d45:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  801d4a:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801d51:	0f b6 13             	movzbl (%ebx),%edx
  801d54:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  801d57:	43                   	inc    %ebx
  801d58:	83 f8 55             	cmp    $0x55,%eax
  801d5b:	0f 87 70 02 00 00    	ja     801fd1 <vprintfmt+0x2cf>
  801d61:	ff 24 85 3c 28 80 00 	jmp    *0x80283c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  801d68:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  801d6c:	eb e3                	jmp    801d51 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801d6e:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  801d72:	eb dd                	jmp    801d51 <vprintfmt+0x4f>

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
  801d74:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  801d79:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  801d7c:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  801d80:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  801d83:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  801d86:	83 f8 09             	cmp    $0x9,%eax
  801d89:	77 27                	ja     801db2 <vprintfmt+0xb0>
  801d8b:	43                   	inc    %ebx
  801d8c:	eb eb                	jmp    801d79 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d8e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801d92:	8b 45 14             	mov    0x14(%ebp),%eax
  801d95:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  801d98:	eb 18                	jmp    801db2 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  801d9a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801d9e:	79 b1                	jns    801d51 <vprintfmt+0x4f>
				width = 0;
  801da0:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  801da7:	eb a8                	jmp    801d51 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  801da9:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  801db0:	eb 9f                	jmp    801d51 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  801db2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801db6:	79 99                	jns    801d51 <vprintfmt+0x4f>
				width = precision, precision = -1;
  801db8:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  801dbb:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  801dc0:	eb 8f                	jmp    801d51 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801dc2:	41                   	inc    %ecx
			goto reswitch;
  801dc3:	eb 8c                	jmp    801d51 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801dc5:	83 ec 08             	sub    $0x8,%esp
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801dcf:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd2:	ff 70 fc             	pushl  0xfffffffc(%eax)
  801dd5:	ff 55 08             	call   *0x8(%ebp)
			break;
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	e9 2e ff ff ff       	jmp    801d0e <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801de0:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  801dea:	85 c0                	test   %eax,%eax
  801dec:	79 02                	jns    801df0 <vprintfmt+0xee>
				err = -err;
  801dee:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801df0:	83 f8 0e             	cmp    $0xe,%eax
  801df3:	7f 0b                	jg     801e00 <vprintfmt+0xfe>
  801df5:	8b 3c 85 00 28 80 00 	mov    0x802800(,%eax,4),%edi
  801dfc:	85 ff                	test   %edi,%edi
  801dfe:	75 19                	jne    801e19 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  801e00:	50                   	push   %eax
  801e01:	68 b2 27 80 00       	push   $0x8027b2
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	ff 75 08             	pushl  0x8(%ebp)
  801e0c:	e8 ed 01 00 00       	call   801ffe <printfmt>
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	e9 f5 fe ff ff       	jmp    801d0e <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  801e19:	57                   	push   %edi
  801e1a:	68 29 26 80 00       	push   $0x802629
  801e1f:	ff 75 0c             	pushl  0xc(%ebp)
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	e8 d4 01 00 00       	call   801ffe <printfmt>
  801e2a:	83 c4 10             	add    $0x10,%esp
			break;
  801e2d:	e9 dc fe ff ff       	jmp    801d0e <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801e32:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801e36:	8b 45 14             	mov    0x14(%ebp),%eax
  801e39:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  801e3c:	85 ff                	test   %edi,%edi
  801e3e:	75 05                	jne    801e45 <vprintfmt+0x143>
				p = "(null)";
  801e40:	bf bb 27 80 00       	mov    $0x8027bb,%edi
			if (width > 0 && padc != '-')
  801e45:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801e49:	7e 3b                	jle    801e86 <vprintfmt+0x184>
  801e4b:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  801e4f:	74 35                	je     801e86 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e51:	83 ec 08             	sub    $0x8,%esp
  801e54:	56                   	push   %esi
  801e55:	57                   	push   %edi
  801e56:	e8 f2 e3 ff ff       	call   80024d <strnlen>
  801e5b:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801e65:	7e 1f                	jle    801e86 <vprintfmt+0x184>
  801e67:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  801e6b:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  801e6e:	83 ec 08             	sub    $0x8,%esp
  801e71:	ff 75 0c             	pushl  0xc(%ebp)
  801e74:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  801e77:	ff 55 08             	call   *0x8(%ebp)
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	ff 4d f0             	decl   0xfffffff0(%ebp)
  801e80:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801e84:	7f e8                	jg     801e6e <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e86:	0f be 17             	movsbl (%edi),%edx
  801e89:	47                   	inc    %edi
  801e8a:	85 d2                	test   %edx,%edx
  801e8c:	74 44                	je     801ed2 <vprintfmt+0x1d0>
  801e8e:	85 f6                	test   %esi,%esi
  801e90:	78 03                	js     801e95 <vprintfmt+0x193>
  801e92:	4e                   	dec    %esi
  801e93:	78 3d                	js     801ed2 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  801e95:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  801e99:	74 18                	je     801eb3 <vprintfmt+0x1b1>
  801e9b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  801e9e:	83 f8 5e             	cmp    $0x5e,%eax
  801ea1:	76 10                	jbe    801eb3 <vprintfmt+0x1b1>
					putch('?', putdat);
  801ea3:	83 ec 08             	sub    $0x8,%esp
  801ea6:	ff 75 0c             	pushl  0xc(%ebp)
  801ea9:	6a 3f                	push   $0x3f
  801eab:	ff 55 08             	call   *0x8(%ebp)
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	eb 0d                	jmp    801ec0 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	52                   	push   %edx
  801eba:	ff 55 08             	call   *0x8(%ebp)
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	ff 4d f0             	decl   0xfffffff0(%ebp)
  801ec3:	0f be 17             	movsbl (%edi),%edx
  801ec6:	47                   	inc    %edi
  801ec7:	85 d2                	test   %edx,%edx
  801ec9:	74 07                	je     801ed2 <vprintfmt+0x1d0>
  801ecb:	85 f6                	test   %esi,%esi
  801ecd:	78 c6                	js     801e95 <vprintfmt+0x193>
  801ecf:	4e                   	dec    %esi
  801ed0:	79 c3                	jns    801e95 <vprintfmt+0x193>
			for (; width > 0; width--)
  801ed2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801ed6:	0f 8e 32 fe ff ff    	jle    801d0e <vprintfmt+0xc>
				putch(' ', putdat);
  801edc:	83 ec 08             	sub    $0x8,%esp
  801edf:	ff 75 0c             	pushl  0xc(%ebp)
  801ee2:	6a 20                	push   $0x20
  801ee4:	ff 55 08             	call   *0x8(%ebp)
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	ff 4d f0             	decl   0xfffffff0(%ebp)
  801eed:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801ef1:	7f e9                	jg     801edc <vprintfmt+0x1da>
			break;
  801ef3:	e9 16 fe ff ff       	jmp    801d0e <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ef8:	51                   	push   %ecx
  801ef9:	8d 45 14             	lea    0x14(%ebp),%eax
  801efc:	50                   	push   %eax
  801efd:	e8 c5 fd ff ff       	call   801cc7 <getint>
  801f02:	89 c6                	mov    %eax,%esi
  801f04:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  801f06:	83 c4 08             	add    $0x8,%esp
  801f09:	85 d2                	test   %edx,%edx
  801f0b:	79 15                	jns    801f22 <vprintfmt+0x220>
				putch('-', putdat);
  801f0d:	83 ec 08             	sub    $0x8,%esp
  801f10:	ff 75 0c             	pushl  0xc(%ebp)
  801f13:	6a 2d                	push   $0x2d
  801f15:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801f18:	f7 de                	neg    %esi
  801f1a:	83 d7 00             	adc    $0x0,%edi
  801f1d:	f7 df                	neg    %edi
  801f1f:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  801f22:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  801f27:	eb 75                	jmp    801f9e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801f29:	51                   	push   %ecx
  801f2a:	8d 45 14             	lea    0x14(%ebp),%eax
  801f2d:	50                   	push   %eax
  801f2e:	e8 51 fd ff ff       	call   801c84 <getuint>
  801f33:	89 c6                	mov    %eax,%esi
  801f35:	89 d7                	mov    %edx,%edi
			base = 10;
  801f37:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  801f3c:	83 c4 08             	add    $0x8,%esp
  801f3f:	eb 5d                	jmp    801f9e <vprintfmt+0x29c>

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
  801f41:	51                   	push   %ecx
  801f42:	8d 45 14             	lea    0x14(%ebp),%eax
  801f45:	50                   	push   %eax
  801f46:	e8 39 fd ff ff       	call   801c84 <getuint>
  801f4b:	89 c6                	mov    %eax,%esi
  801f4d:	89 d7                	mov    %edx,%edi
			base = 8;
  801f4f:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  801f54:	83 c4 08             	add    $0x8,%esp
  801f57:	eb 45                	jmp    801f9e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  801f59:	83 ec 08             	sub    $0x8,%esp
  801f5c:	ff 75 0c             	pushl  0xc(%ebp)
  801f5f:	6a 30                	push   $0x30
  801f61:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801f64:	83 c4 08             	add    $0x8,%esp
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	6a 78                	push   $0x78
  801f6c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  801f6f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801f73:	8b 45 14             	mov    0x14(%ebp),%eax
  801f76:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  801f79:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801f7e:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	eb 16                	jmp    801f9e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f88:	51                   	push   %ecx
  801f89:	8d 45 14             	lea    0x14(%ebp),%eax
  801f8c:	50                   	push   %eax
  801f8d:	e8 f2 fc ff ff       	call   801c84 <getuint>
  801f92:	89 c6                	mov    %eax,%esi
  801f94:	89 d7                	mov    %edx,%edi
			base = 16;
  801f96:	ba 10 00 00 00       	mov    $0x10,%edx
  801f9b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  801fa5:	50                   	push   %eax
  801fa6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801fa9:	52                   	push   %edx
  801faa:	57                   	push   %edi
  801fab:	56                   	push   %esi
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	e8 2d fc ff ff       	call   801be4 <printnum>
			break;
  801fb7:	83 c4 20             	add    $0x20,%esp
  801fba:	e9 4f fd ff ff       	jmp    801d0e <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	52                   	push   %edx
  801fc6:	ff 55 08             	call   *0x8(%ebp)
			break;
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	e9 3d fd ff ff       	jmp    801d0e <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801fd1:	83 ec 08             	sub    $0x8,%esp
  801fd4:	ff 75 0c             	pushl  0xc(%ebp)
  801fd7:	6a 25                	push   $0x25
  801fd9:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801fdc:	4b                   	dec    %ebx
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  801fe4:	0f 84 24 fd ff ff    	je     801d0e <vprintfmt+0xc>
  801fea:	4b                   	dec    %ebx
  801feb:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  801fef:	75 f9                	jne    801fea <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  801ff1:	e9 18 fd ff ff       	jmp    801d0e <vprintfmt+0xc>
		}
	}
}
  801ff6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5f                   	pop    %edi
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  802004:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  802007:	50                   	push   %eax
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	e8 ec fc ff ff       	call   801d02 <vprintfmt>
	va_end(ap);
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80201e:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  802021:	8b 0a                	mov    (%edx),%ecx
  802023:	3b 4a 04             	cmp    0x4(%edx),%ecx
  802026:	73 07                	jae    80202f <sprintputch+0x17>
		*b->buf++ = ch;
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	88 01                	mov    %al,(%ecx)
  80202d:	ff 02                	incl   (%edx)
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 18             	sub    $0x18,%esp
  802037:	8b 55 08             	mov    0x8(%ebp),%edx
  80203a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80203d:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  802040:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  802044:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802047:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80204e:	85 d2                	test   %edx,%edx
  802050:	74 04                	je     802056 <vsnprintf+0x25>
  802052:	85 c9                	test   %ecx,%ecx
  802054:	7f 07                	jg     80205d <vsnprintf+0x2c>
		return -E_INVAL;
  802056:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80205b:	eb 1d                	jmp    80207a <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80205d:	ff 75 14             	pushl  0x14(%ebp)
  802060:	ff 75 10             	pushl  0x10(%ebp)
  802063:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  802066:	50                   	push   %eax
  802067:	68 18 20 80 00       	push   $0x802018
  80206c:	e8 91 fc ff ff       	call   801d02 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802071:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  802074:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802077:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802082:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802085:	50                   	push   %eax
  802086:	ff 75 10             	pushl  0x10(%ebp)
  802089:	ff 75 0c             	pushl  0xc(%ebp)
  80208c:	ff 75 08             	pushl  0x8(%ebp)
  80208f:	e8 9d ff ff ff       	call   802031 <vsnprintf>
	va_end(ap);

	return rc;
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    
	...

00802098 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	56                   	push   %esi
  80209c:	53                   	push   %ebx
  80209d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8020a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a3:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	75 12                	jne    8020bc <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	68 00 00 c0 ee       	push   $0xeec00000
  8020b2:	e8 3b e7 ff ff       	call   8007f2 <sys_ipc_recv>
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	eb 0c                	jmp    8020c8 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	50                   	push   %eax
  8020c0:	e8 2d e7 ff ff       	call   8007f2 <sys_ipc_recv>
  8020c5:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8020c8:	89 c2                	mov    %eax,%edx
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	78 24                	js     8020f2 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8020ce:	85 db                	test   %ebx,%ebx
  8020d0:	74 0a                	je     8020dc <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8020d2:	a1 80 60 80 00       	mov    0x806080,%eax
  8020d7:	8b 40 74             	mov    0x74(%eax),%eax
  8020da:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8020dc:	85 f6                	test   %esi,%esi
  8020de:	74 0a                	je     8020ea <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8020e0:	a1 80 60 80 00       	mov    0x806080,%eax
  8020e5:	8b 40 78             	mov    0x78(%eax),%eax
  8020e8:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  8020ea:	a1 80 60 80 00       	mov    0x806080,%eax
  8020ef:	8b 50 70             	mov    0x70(%eax),%edx

}
  8020f2:	89 d0                	mov    %edx,%eax
  8020f4:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <ipc_send>:

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
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	57                   	push   %edi
  8020ff:	56                   	push   %esi
  802100:	53                   	push   %ebx
  802101:	83 ec 0c             	sub    $0xc,%esp
  802104:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802107:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80210a:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  80210d:	85 db                	test   %ebx,%ebx
  80210f:	75 0a                	jne    80211b <ipc_send+0x20>
    pg = (void *) UTOP;
  802111:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802116:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80211b:	56                   	push   %esi
  80211c:	53                   	push   %ebx
  80211d:	57                   	push   %edi
  80211e:	ff 75 08             	pushl  0x8(%ebp)
  802121:	e8 a9 e6 ff ff       	call   8007cf <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80212c:	75 07                	jne    802135 <ipc_send+0x3a>
      sys_yield();
  80212e:	e8 f0 e4 ff ff       	call   800623 <sys_yield>
  802133:	eb e6                	jmp    80211b <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802135:	85 c0                	test   %eax,%eax
  802137:	79 12                	jns    80214b <ipc_send+0x50>
  802139:	50                   	push   %eax
  80213a:	68 94 29 80 00       	push   $0x802994
  80213f:	6a 49                	push   $0x49
  802141:	68 b1 29 80 00       	push   $0x8029b1
  802146:	e8 95 f9 ff ff       	call   801ae0 <_panic>
    else break;
  }
}
  80214b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80214e:	5b                   	pop    %ebx
  80214f:	5e                   	pop    %esi
  802150:	5f                   	pop    %edi
  802151:	c9                   	leave  
  802152:	c3                   	ret    
	...

00802154 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80215a:	89 c8                	mov    %ecx,%eax
  80215c:	c1 e8 16             	shr    $0x16,%eax
  80215f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802166:	ba 00 00 00 00       	mov    $0x0,%edx
  80216b:	a8 01                	test   $0x1,%al
  80216d:	74 28                	je     802197 <pageref+0x43>
	pte = vpt[VPN(v)];
  80216f:	89 c8                	mov    %ecx,%eax
  802171:	c1 e8 0c             	shr    $0xc,%eax
  802174:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80217b:	ba 00 00 00 00       	mov    $0x0,%edx
  802180:	a8 01                	test   $0x1,%al
  802182:	74 13                	je     802197 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802184:	c1 e8 0c             	shr    $0xc,%eax
  802187:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80218a:	c1 e0 02             	shl    $0x2,%eax
  80218d:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802194:	0f b7 d0             	movzwl %ax,%edx
}
  802197:	89 d0                	mov    %edx,%eax
  802199:	c9                   	leave  
  80219a:	c3                   	ret    
	...

0080219c <__udivdi3>:
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	57                   	push   %edi
  8021a0:	56                   	push   %esi
  8021a1:	83 ec 14             	sub    $0x14,%esp
  8021a4:	8b 55 14             	mov    0x14(%ebp),%edx
  8021a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8021aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8021ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b0:	85 d2                	test   %edx,%edx
  8021b2:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8021b5:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8021b8:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8021bb:	89 fe                	mov    %edi,%esi
  8021bd:	75 11                	jne    8021d0 <__udivdi3+0x34>
  8021bf:	39 f8                	cmp    %edi,%eax
  8021c1:	76 4d                	jbe    802210 <__udivdi3+0x74>
  8021c3:	89 fa                	mov    %edi,%edx
  8021c5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8021c8:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8021cb:	89 c7                	mov    %eax,%edi
  8021cd:	eb 09                	jmp    8021d8 <__udivdi3+0x3c>
  8021cf:	90                   	nop    
  8021d0:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  8021d3:	76 17                	jbe    8021ec <__udivdi3+0x50>
  8021d5:	31 ff                	xor    %edi,%edi
  8021d7:	90                   	nop    
  8021d8:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  8021df:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8021e2:	83 c4 14             	add    $0x14,%esp
  8021e5:	5e                   	pop    %esi
  8021e6:	89 f8                	mov    %edi,%eax
  8021e8:	5f                   	pop    %edi
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    
  8021eb:	90                   	nop    
  8021ec:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  8021f0:	89 c7                	mov    %eax,%edi
  8021f2:	83 f7 1f             	xor    $0x1f,%edi
  8021f5:	75 4d                	jne    802244 <__udivdi3+0xa8>
  8021f7:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8021fa:	77 0a                	ja     802206 <__udivdi3+0x6a>
  8021fc:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8021ff:	31 ff                	xor    %edi,%edi
  802201:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802204:	72 d2                	jb     8021d8 <__udivdi3+0x3c>
  802206:	bf 01 00 00 00       	mov    $0x1,%edi
  80220b:	eb cb                	jmp    8021d8 <__udivdi3+0x3c>
  80220d:	8d 76 00             	lea    0x0(%esi),%esi
  802210:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	75 0e                	jne    802225 <__udivdi3+0x89>
  802217:	b8 01 00 00 00       	mov    $0x1,%eax
  80221c:	31 c9                	xor    %ecx,%ecx
  80221e:	31 d2                	xor    %edx,%edx
  802220:	f7 f1                	div    %ecx
  802222:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802225:	89 f0                	mov    %esi,%eax
  802227:	31 d2                	xor    %edx,%edx
  802229:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80222c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80222f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802232:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802235:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802238:	83 c4 14             	add    $0x14,%esp
  80223b:	89 c7                	mov    %eax,%edi
  80223d:	5e                   	pop    %esi
  80223e:	89 f8                	mov    %edi,%eax
  802240:	5f                   	pop    %edi
  802241:	c9                   	leave  
  802242:	c3                   	ret    
  802243:	90                   	nop    
  802244:	b8 20 00 00 00       	mov    $0x20,%eax
  802249:	29 f8                	sub    %edi,%eax
  80224b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80224e:	89 f9                	mov    %edi,%ecx
  802250:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802253:	d3 e2                	shl    %cl,%edx
  802255:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802258:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80225b:	d3 e8                	shr    %cl,%eax
  80225d:	09 c2                	or     %eax,%edx
  80225f:	89 f9                	mov    %edi,%ecx
  802261:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802264:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802267:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80226a:	89 f2                	mov    %esi,%edx
  80226c:	d3 ea                	shr    %cl,%edx
  80226e:	89 f9                	mov    %edi,%ecx
  802270:	d3 e6                	shl    %cl,%esi
  802272:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802275:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802278:	d3 e8                	shr    %cl,%eax
  80227a:	09 c6                	or     %eax,%esi
  80227c:	89 f9                	mov    %edi,%ecx
  80227e:	89 f0                	mov    %esi,%eax
  802280:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802283:	89 d6                	mov    %edx,%esi
  802285:	89 c7                	mov    %eax,%edi
  802287:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  80228a:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80228d:	f7 e7                	mul    %edi
  80228f:	39 f2                	cmp    %esi,%edx
  802291:	77 0f                	ja     8022a2 <__udivdi3+0x106>
  802293:	0f 85 3f ff ff ff    	jne    8021d8 <__udivdi3+0x3c>
  802299:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  80229c:	0f 86 36 ff ff ff    	jbe    8021d8 <__udivdi3+0x3c>
  8022a2:	4f                   	dec    %edi
  8022a3:	e9 30 ff ff ff       	jmp    8021d8 <__udivdi3+0x3c>

008022a8 <__umoddi3>:
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	57                   	push   %edi
  8022ac:	56                   	push   %esi
  8022ad:	83 ec 30             	sub    $0x30,%esp
  8022b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8022b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b6:	89 d7                	mov    %edx,%edi
  8022b8:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8022bb:	89 c6                	mov    %eax,%esi
  8022bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	85 ff                	test   %edi,%edi
  8022c5:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  8022cc:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8022d3:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  8022d6:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8022d9:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8022dc:	75 3e                	jne    80231c <__umoddi3+0x74>
  8022de:	39 d6                	cmp    %edx,%esi
  8022e0:	0f 86 a2 00 00 00    	jbe    802388 <__umoddi3+0xe0>
  8022e6:	f7 f6                	div    %esi
  8022e8:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8022eb:	85 c9                	test   %ecx,%ecx
  8022ed:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  8022f0:	74 1b                	je     80230d <__umoddi3+0x65>
  8022f2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8022f5:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8022f8:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8022ff:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802302:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802305:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802308:	89 10                	mov    %edx,(%eax)
  80230a:	89 48 04             	mov    %ecx,0x4(%eax)
  80230d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802310:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802313:	83 c4 30             	add    $0x30,%esp
  802316:	5e                   	pop    %esi
  802317:	5f                   	pop    %edi
  802318:	c9                   	leave  
  802319:	c3                   	ret    
  80231a:	89 f6                	mov    %esi,%esi
  80231c:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80231f:	76 1f                	jbe    802340 <__umoddi3+0x98>
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
  802324:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802327:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80232a:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  80232d:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802330:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802333:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802336:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802339:	83 c4 30             	add    $0x30,%esp
  80233c:	5e                   	pop    %esi
  80233d:	5f                   	pop    %edi
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    
  802340:	0f bd c7             	bsr    %edi,%eax
  802343:	83 f0 1f             	xor    $0x1f,%eax
  802346:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802349:	75 61                	jne    8023ac <__umoddi3+0x104>
  80234b:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80234e:	77 05                	ja     802355 <__umoddi3+0xad>
  802350:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  802353:	72 10                	jb     802365 <__umoddi3+0xbd>
  802355:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802358:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80235b:	29 f0                	sub    %esi,%eax
  80235d:	19 fa                	sbb    %edi,%edx
  80235f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802362:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802365:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802368:	85 d2                	test   %edx,%edx
  80236a:	74 a1                	je     80230d <__umoddi3+0x65>
  80236c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80236f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802372:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802375:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802378:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80237b:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80237e:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802381:	89 01                	mov    %eax,(%ecx)
  802383:	89 51 04             	mov    %edx,0x4(%ecx)
  802386:	eb 85                	jmp    80230d <__umoddi3+0x65>
  802388:	85 f6                	test   %esi,%esi
  80238a:	75 0b                	jne    802397 <__umoddi3+0xef>
  80238c:	b8 01 00 00 00       	mov    $0x1,%eax
  802391:	31 d2                	xor    %edx,%edx
  802393:	f7 f6                	div    %esi
  802395:	89 c6                	mov    %eax,%esi
  802397:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80239a:	89 fa                	mov    %edi,%edx
  80239c:	f7 f6                	div    %esi
  80239e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8023a1:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8023a4:	f7 f6                	div    %esi
  8023a6:	e9 3d ff ff ff       	jmp    8022e8 <__umoddi3+0x40>
  8023ab:	90                   	nop    
  8023ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8023b1:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  8023b4:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  8023b7:	89 fa                	mov    %edi,%edx
  8023b9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8023bc:	d3 e2                	shl    %cl,%edx
  8023be:	89 f0                	mov    %esi,%eax
  8023c0:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8023c3:	d3 e8                	shr    %cl,%eax
  8023c5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8023c8:	d3 e6                	shl    %cl,%esi
  8023ca:	89 d7                	mov    %edx,%edi
  8023cc:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8023cf:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8023d2:	09 c7                	or     %eax,%edi
  8023d4:	d3 ea                	shr    %cl,%edx
  8023d6:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8023d9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8023dc:	d3 e0                	shl    %cl,%eax
  8023de:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8023e1:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8023e4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  8023ec:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8023ef:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8023f2:	f7 f7                	div    %edi
  8023f4:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8023f7:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  8023fa:	f7 e6                	mul    %esi
  8023fc:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  8023ff:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802402:	77 0a                	ja     80240e <__umoddi3+0x166>
  802404:	75 12                	jne    802418 <__umoddi3+0x170>
  802406:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802409:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  80240c:	76 0a                	jbe    802418 <__umoddi3+0x170>
  80240e:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802411:	29 f1                	sub    %esi,%ecx
  802413:	19 fa                	sbb    %edi,%edx
  802415:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802418:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80241b:	85 c0                	test   %eax,%eax
  80241d:	0f 84 ea fe ff ff    	je     80230d <__umoddi3+0x65>
  802423:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802426:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802429:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  80242c:	19 d1                	sbb    %edx,%ecx
  80242e:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802431:	89 ca                	mov    %ecx,%edx
  802433:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802436:	d3 e2                	shl    %cl,%edx
  802438:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80243b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80243e:	d3 e8                	shr    %cl,%eax
  802440:	09 c2                	or     %eax,%edx
  802442:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802445:	d3 e8                	shr    %cl,%eax
  802447:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80244a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80244d:	e9 ad fe ff ff       	jmp    8022ff <__umoddi3+0x57>
