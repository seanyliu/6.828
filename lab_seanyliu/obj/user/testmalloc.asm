
obj/user/testmalloc:     file format elf32-i386

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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
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
  800037:	53                   	push   %ebx
  800038:	83 ec 04             	sub    $0x4,%esp
	char *buf;
	int n;
	void *v;

	while (1) {
		buf = readline("> ");
  80003b:	83 ec 0c             	sub    $0xc,%esp
  80003e:	68 00 29 80 00       	push   $0x802900
  800043:	e8 f8 00 00 00       	call   800140 <readline>
  800048:	89 c3                	mov    %eax,%ebx
		if (buf == 0)
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	75 05                	jne    800056 <umain+0x22>
			exit();
  800051:	e8 d2 00 00 00       	call   800128 <exit>
		if (memcmp(buf, "free ", 5) == 0) {
  800056:	83 ec 04             	sub    $0x4,%esp
  800059:	6a 05                	push   $0x5
  80005b:	68 03 29 80 00       	push   $0x802903
  800060:	53                   	push   %ebx
  800061:	e8 e8 04 00 00       	call   80054e <memcmp>
  800066:	83 c4 10             	add    $0x10,%esp
  800069:	85 c0                	test   %eax,%eax
  80006b:	75 1d                	jne    80008a <umain+0x56>
			v = (void*) strtol(buf + 5, 0, 0);
  80006d:	83 ec 04             	sub    $0x4,%esp
  800070:	6a 00                	push   $0x0
  800072:	6a 00                	push   $0x0
  800074:	8d 43 05             	lea    0x5(%ebx),%eax
  800077:	50                   	push   %eax
  800078:	e8 23 05 00 00       	call   8005a0 <strtol>
			free(v);
  80007d:	89 04 24             	mov    %eax,(%esp)
  800080:	e8 34 19 00 00       	call   8019b9 <free>
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	eb b1                	jmp    80003b <umain+0x7>
		} else if (memcmp(buf, "malloc ", 7) == 0) {
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 07                	push   $0x7
  80008f:	68 09 29 80 00       	push   $0x802909
  800094:	53                   	push   %ebx
  800095:	e8 b4 04 00 00       	call   80054e <memcmp>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	85 c0                	test   %eax,%eax
  80009f:	75 2e                	jne    8000cf <umain+0x9b>
			n = strtol(buf + 7, 0, 0);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	6a 00                	push   $0x0
  8000a8:	8d 43 07             	lea    0x7(%ebx),%eax
  8000ab:	50                   	push   %eax
  8000ac:	e8 ef 04 00 00       	call   8005a0 <strtol>
			v = malloc(n);
  8000b1:	89 04 24             	mov    %eax,(%esp)
  8000b4:	e8 7a 17 00 00       	call   801833 <malloc>
			printf("\t0x%x\n", (uintptr_t) v);
  8000b9:	83 c4 08             	add    $0x8,%esp
  8000bc:	50                   	push   %eax
  8000bd:	68 11 29 80 00       	push   $0x802911
  8000c2:	e8 85 15 00 00       	call   80164c <printf>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	e9 6c ff ff ff       	jmp    80003b <umain+0x7>
		} else
			printf("?unknown command\n");
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	68 18 29 80 00       	push   $0x802918
  8000d7:	e8 70 15 00 00       	call   80164c <printf>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	e9 57 ff ff ff       	jmp    80003b <umain+0x7>

008000e4 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8000ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 f4 05 00 00       	call   8006e8 <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	c1 e0 07             	shl    $0x7,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 a4 64 80 00       	mov    %eax,0x8064a4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 f6                	test   %esi,%esi
  800108:	7e 07                	jle    800111 <libmain+0x2d>
		binaryname = argv[0];
  80010a:	8b 03                	mov    (%ebx),%eax
  80010c:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	53                   	push   %ebx
  800115:	56                   	push   %esi
  800116:	e8 19 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80011b:	e8 08 00 00 00       	call   800128 <exit>
}
  800120:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800123:	5b                   	pop    %ebx
  800124:	5e                   	pop    %esi
  800125:	c9                   	leave  
  800126:	c3                   	ret    
	...

00800128 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012e:	e8 1d 0b 00 00       	call   800c50 <close_all>
	sys_env_destroy(0);
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	6a 00                	push   $0x0
  800138:	e8 6a 05 00 00       	call   8006a7 <sys_env_destroy>
}
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    
	...

00800140 <readline>:
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	57                   	push   %edi
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80014c:	85 c0                	test   %eax,%eax
  80014e:	74 13                	je     800163 <readline+0x23>
		fprintf(1, "%s", prompt);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	50                   	push   %eax
  800154:	68 01 2b 80 00       	push   $0x802b01
  800159:	6a 01                	push   $0x1
  80015b:	e8 d5 14 00 00       	call   801635 <fprintf>
  800160:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
  800163:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	e8 c4 1c 00 00       	call   801e36 <iscons>
  800172:	89 c7                	mov    %eax,%edi
	while (1) {
  800174:	83 c4 10             	add    $0x10,%esp
		c = getchar();
  800177:	e8 8d 1c 00 00       	call   801e09 <getchar>
  80017c:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  80017e:	85 c0                	test   %eax,%eax
  800180:	79 1d                	jns    80019f <readline+0x5f>
			if (c != -E_EOF)
  800182:	83 f8 f8             	cmp    $0xfffffff8,%eax
  800185:	74 11                	je     800198 <readline+0x58>
				cprintf("read error: %e\n", c);
  800187:	83 ec 08             	sub    $0x8,%esp
  80018a:	50                   	push   %eax
  80018b:	68 41 29 80 00       	push   $0x802941
  800190:	e8 db 1e 00 00       	call   802070 <cprintf>
  800195:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	eb 6f                	jmp    80020e <readline+0xce>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80019f:	83 f8 08             	cmp    $0x8,%eax
  8001a2:	74 05                	je     8001a9 <readline+0x69>
  8001a4:	83 f8 7f             	cmp    $0x7f,%eax
  8001a7:	75 18                	jne    8001c1 <readline+0x81>
  8001a9:	85 f6                	test   %esi,%esi
  8001ab:	7e 14                	jle    8001c1 <readline+0x81>
			if (echoing)
  8001ad:	85 ff                	test   %edi,%edi
  8001af:	74 0d                	je     8001be <readline+0x7e>
				cputchar('\b');
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	6a 08                	push   $0x8
  8001b6:	e8 35 1c 00 00       	call   801df0 <cputchar>
  8001bb:	83 c4 10             	add    $0x10,%esp
			i--;
  8001be:	4e                   	dec    %esi
  8001bf:	eb b6                	jmp    800177 <readline+0x37>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8001c1:	83 fb 1f             	cmp    $0x1f,%ebx
  8001c4:	7e 21                	jle    8001e7 <readline+0xa7>
  8001c6:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8001cc:	7f 19                	jg     8001e7 <readline+0xa7>
			if (echoing)
  8001ce:	85 ff                	test   %edi,%edi
  8001d0:	74 0c                	je     8001de <readline+0x9e>
				cputchar(c);
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	53                   	push   %ebx
  8001d6:	e8 15 1c 00 00       	call   801df0 <cputchar>
  8001db:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8001de:	88 9e a0 60 80 00    	mov    %bl,0x8060a0(%esi)
  8001e4:	46                   	inc    %esi
  8001e5:	eb 90                	jmp    800177 <readline+0x37>
		} else if (c == '\n' || c == '\r') {
  8001e7:	83 fb 0a             	cmp    $0xa,%ebx
  8001ea:	74 05                	je     8001f1 <readline+0xb1>
  8001ec:	83 fb 0d             	cmp    $0xd,%ebx
  8001ef:	75 86                	jne    800177 <readline+0x37>
			if (echoing)
  8001f1:	85 ff                	test   %edi,%edi
  8001f3:	74 0d                	je     800202 <readline+0xc2>
				cputchar('\n');
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	6a 0a                	push   $0xa
  8001fa:	e8 f1 1b 00 00       	call   801df0 <cputchar>
  8001ff:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800202:	c6 86 a0 60 80 00 00 	movb   $0x0,0x8060a0(%esi)
			return buf;
  800209:	b8 a0 60 80 00       	mov    $0x8060a0,%eax
		}
	}
}
  80020e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800211:	5b                   	pop    %ebx
  800212:	5e                   	pop    %esi
  800213:	5f                   	pop    %edi
  800214:	c9                   	leave  
  800215:	c3                   	ret    
	...

00800218 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	56                   	push   %esi
  800224:	e8 ef 00 00 00       	call   800318 <strlen>
  char letter;
  int hexnum = 0;
  800229:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80022e:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	89 c2                	mov    %eax,%edx
  800238:	4a                   	dec    %edx
  800239:	0f 88 d0 00 00 00    	js     80030f <strtoint+0xf7>
    letter = string[cidx];
  80023f:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  800242:	85 d2                	test   %edx,%edx
  800244:	75 12                	jne    800258 <strtoint+0x40>
      if (letter != '0') {
  800246:	3c 30                	cmp    $0x30,%al
  800248:	0f 84 ba 00 00 00    	je     800308 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80024e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800253:	e9 b9 00 00 00       	jmp    800311 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800258:	83 fa 01             	cmp    $0x1,%edx
  80025b:	75 12                	jne    80026f <strtoint+0x57>
      if (letter != 'x') {
  80025d:	3c 78                	cmp    $0x78,%al
  80025f:	0f 84 a3 00 00 00    	je     800308 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80026a:	e9 a2 00 00 00       	jmp    800311 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80026f:	0f be c0             	movsbl %al,%eax
  800272:	83 e8 30             	sub    $0x30,%eax
  800275:	83 f8 36             	cmp    $0x36,%eax
  800278:	0f 87 80 00 00 00    	ja     8002fe <strtoint+0xe6>
  80027e:	ff 24 85 54 29 80 00 	jmp    *0x802954(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  800285:	01 cb                	add    %ecx,%ebx
          break;
  800287:	eb 7c                	jmp    800305 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800289:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  80028c:	eb 77                	jmp    800305 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  80028e:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800291:	01 c3                	add    %eax,%ebx
          break;
  800293:	eb 70                	jmp    800305 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800295:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800298:	eb 6b                	jmp    800305 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  80029a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  80029d:	01 c3                	add    %eax,%ebx
          break;
  80029f:	eb 64                	jmp    800305 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8002a1:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8002a4:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8002a7:	eb 5c                	jmp    800305 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8002a9:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8002b0:	29 c8                	sub    %ecx,%eax
  8002b2:	01 c3                	add    %eax,%ebx
          break;
  8002b4:	eb 4f                	jmp    800305 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8002b6:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8002b9:	eb 4a                	jmp    800305 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8002bb:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8002be:	01 c3                	add    %eax,%ebx
          break;
  8002c0:	eb 43                	jmp    800305 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8002c2:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8002c5:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8002c8:	eb 3b                	jmp    800305 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8002ca:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8002cd:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8002d0:	01 c3                	add    %eax,%ebx
          break;
  8002d2:	eb 31                	jmp    800305 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8002d4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8002d7:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8002da:	eb 29                	jmp    800305 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8002dc:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8002df:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  8002e2:	01 c3                	add    %eax,%ebx
          break;
  8002e4:	eb 1f                	jmp    800305 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  8002e6:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8002ed:	29 c8                	sub    %ecx,%eax
  8002ef:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8002f2:	eb 11                	jmp    800305 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8002f4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8002f7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002fa:	01 c3                	add    %eax,%ebx
          break;
  8002fc:	eb 07                	jmp    800305 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8002fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800303:	eb 0c                	jmp    800311 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800305:	c1 e1 04             	shl    $0x4,%ecx
  800308:	4a                   	dec    %edx
  800309:	0f 89 30 ff ff ff    	jns    80023f <strtoint+0x27>
    }
  }

  return hexnum;
  80030f:	89 d8                	mov    %ebx,%eax
}
  800311:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <strlen>:





int
strlen(const char *s)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
  800323:	80 3a 00             	cmpb   $0x0,(%edx)
  800326:	74 07                	je     80032f <strlen+0x17>
		n++;
  800328:	40                   	inc    %eax
  800329:	42                   	inc    %edx
  80032a:	80 3a 00             	cmpb   $0x0,(%edx)
  80032d:	75 f9                	jne    800328 <strlen+0x10>
	return n;
}
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800337:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	85 d2                	test   %edx,%edx
  800341:	74 0f                	je     800352 <strnlen+0x21>
  800343:	80 39 00             	cmpb   $0x0,(%ecx)
  800346:	74 0a                	je     800352 <strnlen+0x21>
		n++;
  800348:	40                   	inc    %eax
  800349:	41                   	inc    %ecx
  80034a:	4a                   	dec    %edx
  80034b:	74 05                	je     800352 <strnlen+0x21>
  80034d:	80 39 00             	cmpb   $0x0,(%ecx)
  800350:	75 f6                	jne    800348 <strnlen+0x17>
	return n;
}
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	53                   	push   %ebx
  800358:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80035b:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80035e:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800360:	8a 02                	mov    (%edx),%al
  800362:	42                   	inc    %edx
  800363:	88 01                	mov    %al,(%ecx)
  800365:	41                   	inc    %ecx
  800366:	84 c0                	test   %al,%al
  800368:	75 f6                	jne    800360 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80036a:	89 d8                	mov    %ebx,%eax
  80036c:	5b                   	pop    %ebx
  80036d:	c9                   	leave  
  80036e:	c3                   	ret    

0080036f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	57                   	push   %edi
  800373:	56                   	push   %esi
  800374:	53                   	push   %ebx
  800375:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037b:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  80037e:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800380:	bb 00 00 00 00       	mov    $0x0,%ebx
  800385:	39 f3                	cmp    %esi,%ebx
  800387:	73 10                	jae    800399 <strncpy+0x2a>
		*dst++ = *src;
  800389:	8a 02                	mov    (%edx),%al
  80038b:	88 01                	mov    %al,(%ecx)
  80038d:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80038e:	80 3a 01             	cmpb   $0x1,(%edx)
  800391:	83 da ff             	sbb    $0xffffffff,%edx
  800394:	43                   	inc    %ebx
  800395:	39 f3                	cmp    %esi,%ebx
  800397:	72 f0                	jb     800389 <strncpy+0x1a>
	}
	return ret;
}
  800399:	89 f8                	mov    %edi,%eax
  80039b:	5b                   	pop    %ebx
  80039c:	5e                   	pop    %esi
  80039d:	5f                   	pop    %edi
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ab:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  8003ae:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8003b0:	85 d2                	test   %edx,%edx
  8003b2:	74 19                	je     8003cd <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8003b4:	4a                   	dec    %edx
  8003b5:	74 13                	je     8003ca <strlcpy+0x2a>
  8003b7:	80 39 00             	cmpb   $0x0,(%ecx)
  8003ba:	74 0e                	je     8003ca <strlcpy+0x2a>
  8003bc:	8a 01                	mov    (%ecx),%al
  8003be:	41                   	inc    %ecx
  8003bf:	88 03                	mov    %al,(%ebx)
  8003c1:	43                   	inc    %ebx
  8003c2:	4a                   	dec    %edx
  8003c3:	74 05                	je     8003ca <strlcpy+0x2a>
  8003c5:	80 39 00             	cmpb   $0x0,(%ecx)
  8003c8:	75 f2                	jne    8003bc <strlcpy+0x1c>
		*dst = '\0';
  8003ca:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8003cd:	89 d8                	mov    %ebx,%eax
  8003cf:	29 f0                	sub    %esi,%eax
}
  8003d1:	5b                   	pop    %ebx
  8003d2:	5e                   	pop    %esi
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8003db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  8003de:	80 3a 00             	cmpb   $0x0,(%edx)
  8003e1:	74 13                	je     8003f6 <strcmp+0x21>
  8003e3:	8a 02                	mov    (%edx),%al
  8003e5:	3a 01                	cmp    (%ecx),%al
  8003e7:	75 0d                	jne    8003f6 <strcmp+0x21>
  8003e9:	42                   	inc    %edx
  8003ea:	41                   	inc    %ecx
  8003eb:	80 3a 00             	cmpb   $0x0,(%edx)
  8003ee:	74 06                	je     8003f6 <strcmp+0x21>
  8003f0:	8a 02                	mov    (%edx),%al
  8003f2:	3a 01                	cmp    (%ecx),%al
  8003f4:	74 f3                	je     8003e9 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8003f6:	0f b6 02             	movzbl (%edx),%eax
  8003f9:	0f b6 11             	movzbl (%ecx),%edx
  8003fc:	29 d0                	sub    %edx,%eax
}
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	53                   	push   %ebx
  800404:	8b 55 08             	mov    0x8(%ebp),%edx
  800407:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80040a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  80040d:	85 c9                	test   %ecx,%ecx
  80040f:	74 1f                	je     800430 <strncmp+0x30>
  800411:	80 3a 00             	cmpb   $0x0,(%edx)
  800414:	74 16                	je     80042c <strncmp+0x2c>
  800416:	8a 02                	mov    (%edx),%al
  800418:	3a 03                	cmp    (%ebx),%al
  80041a:	75 10                	jne    80042c <strncmp+0x2c>
  80041c:	42                   	inc    %edx
  80041d:	43                   	inc    %ebx
  80041e:	49                   	dec    %ecx
  80041f:	74 0f                	je     800430 <strncmp+0x30>
  800421:	80 3a 00             	cmpb   $0x0,(%edx)
  800424:	74 06                	je     80042c <strncmp+0x2c>
  800426:	8a 02                	mov    (%edx),%al
  800428:	3a 03                	cmp    (%ebx),%al
  80042a:	74 f0                	je     80041c <strncmp+0x1c>
	if (n == 0)
  80042c:	85 c9                	test   %ecx,%ecx
  80042e:	75 07                	jne    800437 <strncmp+0x37>
		return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	eb 0a                	jmp    800441 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800437:	0f b6 12             	movzbl (%edx),%edx
  80043a:	0f b6 03             	movzbl (%ebx),%eax
  80043d:	29 c2                	sub    %eax,%edx
  80043f:	89 d0                	mov    %edx,%eax
}
  800441:	5b                   	pop    %ebx
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  80044d:	80 38 00             	cmpb   $0x0,(%eax)
  800450:	74 0a                	je     80045c <strchr+0x18>
		if (*s == c)
  800452:	38 10                	cmp    %dl,(%eax)
  800454:	74 0b                	je     800461 <strchr+0x1d>
  800456:	40                   	inc    %eax
  800457:	80 38 00             	cmpb   $0x0,(%eax)
  80045a:	75 f6                	jne    800452 <strchr+0xe>
			return (char *) s;
	return 0;
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  80046c:	80 38 00             	cmpb   $0x0,(%eax)
  80046f:	74 0a                	je     80047b <strfind+0x18>
		if (*s == c)
  800471:	38 10                	cmp    %dl,(%eax)
  800473:	74 06                	je     80047b <strfind+0x18>
  800475:	40                   	inc    %eax
  800476:	80 38 00             	cmpb   $0x0,(%eax)
  800479:	75 f6                	jne    800471 <strfind+0xe>
			break;
	return (char *) s;
}
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	57                   	push   %edi
  800481:	8b 7d 08             	mov    0x8(%ebp),%edi
  800484:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800487:	89 f8                	mov    %edi,%eax
  800489:	85 c9                	test   %ecx,%ecx
  80048b:	74 40                	je     8004cd <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  80048d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800493:	75 30                	jne    8004c5 <memset+0x48>
  800495:	f6 c1 03             	test   $0x3,%cl
  800498:	75 2b                	jne    8004c5 <memset+0x48>
		c &= 0xFF;
  80049a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8004a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a4:	c1 e0 18             	shl    $0x18,%eax
  8004a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004aa:	c1 e2 10             	shl    $0x10,%edx
  8004ad:	09 d0                	or     %edx,%eax
  8004af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b2:	c1 e2 08             	shl    $0x8,%edx
  8004b5:	09 d0                	or     %edx,%eax
  8004b7:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  8004ba:	c1 e9 02             	shr    $0x2,%ecx
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	fc                   	cld    
  8004c1:	f3 ab                	repz stos %eax,%es:(%edi)
  8004c3:	eb 06                	jmp    8004cb <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c8:	fc                   	cld    
  8004c9:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8004cb:	89 f8                	mov    %edi,%eax
}
  8004cd:	5f                   	pop    %edi
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	57                   	push   %edi
  8004d4:	56                   	push   %esi
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8004db:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8004de:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8004e0:	39 c6                	cmp    %eax,%esi
  8004e2:	73 33                	jae    800517 <memmove+0x47>
  8004e4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8004e7:	39 c2                	cmp    %eax,%edx
  8004e9:	76 2c                	jbe    800517 <memmove+0x47>
		s += n;
  8004eb:	89 d6                	mov    %edx,%esi
		d += n;
  8004ed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8004f0:	f6 c2 03             	test   $0x3,%dl
  8004f3:	75 1b                	jne    800510 <memmove+0x40>
  8004f5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8004fb:	75 13                	jne    800510 <memmove+0x40>
  8004fd:	f6 c1 03             	test   $0x3,%cl
  800500:	75 0e                	jne    800510 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800502:	83 ef 04             	sub    $0x4,%edi
  800505:	83 ee 04             	sub    $0x4,%esi
  800508:	c1 e9 02             	shr    $0x2,%ecx
  80050b:	fd                   	std    
  80050c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80050e:	eb 27                	jmp    800537 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800510:	4f                   	dec    %edi
  800511:	4e                   	dec    %esi
  800512:	fd                   	std    
  800513:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800515:	eb 20                	jmp    800537 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800517:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80051d:	75 15                	jne    800534 <memmove+0x64>
  80051f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800525:	75 0d                	jne    800534 <memmove+0x64>
  800527:	f6 c1 03             	test   $0x3,%cl
  80052a:	75 08                	jne    800534 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  80052c:	c1 e9 02             	shr    $0x2,%ecx
  80052f:	fc                   	cld    
  800530:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800532:	eb 03                	jmp    800537 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800534:	fc                   	cld    
  800535:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800537:	5e                   	pop    %esi
  800538:	5f                   	pop    %edi
  800539:	c9                   	leave  
  80053a:	c3                   	ret    

0080053b <memcpy>:

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
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80053e:	ff 75 10             	pushl  0x10(%ebp)
  800541:	ff 75 0c             	pushl  0xc(%ebp)
  800544:	ff 75 08             	pushl  0x8(%ebp)
  800547:	e8 84 ff ff ff       	call   8004d0 <memmove>
}
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800552:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800555:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800558:	8b 55 10             	mov    0x10(%ebp),%edx
  80055b:	4a                   	dec    %edx
  80055c:	83 fa ff             	cmp    $0xffffffff,%edx
  80055f:	74 1a                	je     80057b <memcmp+0x2d>
  800561:	8a 01                	mov    (%ecx),%al
  800563:	3a 03                	cmp    (%ebx),%al
  800565:	74 0c                	je     800573 <memcmp+0x25>
  800567:	0f b6 d0             	movzbl %al,%edx
  80056a:	0f b6 03             	movzbl (%ebx),%eax
  80056d:	29 c2                	sub    %eax,%edx
  80056f:	89 d0                	mov    %edx,%eax
  800571:	eb 0d                	jmp    800580 <memcmp+0x32>
  800573:	41                   	inc    %ecx
  800574:	43                   	inc    %ebx
  800575:	4a                   	dec    %edx
  800576:	83 fa ff             	cmp    $0xffffffff,%edx
  800579:	75 e6                	jne    800561 <memcmp+0x13>
	}

	return 0;
  80057b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800580:	5b                   	pop    %ebx
  800581:	c9                   	leave  
  800582:	c3                   	ret    

00800583 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800583:	55                   	push   %ebp
  800584:	89 e5                	mov    %esp,%ebp
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80058c:	89 c2                	mov    %eax,%edx
  80058e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800591:	39 d0                	cmp    %edx,%eax
  800593:	73 09                	jae    80059e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800595:	38 08                	cmp    %cl,(%eax)
  800597:	74 05                	je     80059e <memfind+0x1b>
  800599:	40                   	inc    %eax
  80059a:	39 d0                	cmp    %edx,%eax
  80059c:	72 f7                	jb     800595 <memfind+0x12>
			break;
	return (void *) s;
}
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    

008005a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	57                   	push   %edi
  8005a4:	56                   	push   %esi
  8005a5:	53                   	push   %ebx
  8005a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  8005af:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  8005b4:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  8005b9:	80 3a 20             	cmpb   $0x20,(%edx)
  8005bc:	74 05                	je     8005c3 <strtol+0x23>
  8005be:	80 3a 09             	cmpb   $0x9,(%edx)
  8005c1:	75 0b                	jne    8005ce <strtol+0x2e>
  8005c3:	42                   	inc    %edx
  8005c4:	80 3a 20             	cmpb   $0x20,(%edx)
  8005c7:	74 fa                	je     8005c3 <strtol+0x23>
  8005c9:	80 3a 09             	cmpb   $0x9,(%edx)
  8005cc:	74 f5                	je     8005c3 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  8005ce:	80 3a 2b             	cmpb   $0x2b,(%edx)
  8005d1:	75 03                	jne    8005d6 <strtol+0x36>
		s++;
  8005d3:	42                   	inc    %edx
  8005d4:	eb 0b                	jmp    8005e1 <strtol+0x41>
	else if (*s == '-')
  8005d6:	80 3a 2d             	cmpb   $0x2d,(%edx)
  8005d9:	75 06                	jne    8005e1 <strtol+0x41>
		s++, neg = 1;
  8005db:	42                   	inc    %edx
  8005dc:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8005e1:	85 c9                	test   %ecx,%ecx
  8005e3:	74 05                	je     8005ea <strtol+0x4a>
  8005e5:	83 f9 10             	cmp    $0x10,%ecx
  8005e8:	75 15                	jne    8005ff <strtol+0x5f>
  8005ea:	80 3a 30             	cmpb   $0x30,(%edx)
  8005ed:	75 10                	jne    8005ff <strtol+0x5f>
  8005ef:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8005f3:	75 0a                	jne    8005ff <strtol+0x5f>
		s += 2, base = 16;
  8005f5:	83 c2 02             	add    $0x2,%edx
  8005f8:	b9 10 00 00 00       	mov    $0x10,%ecx
  8005fd:	eb 14                	jmp    800613 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  8005ff:	85 c9                	test   %ecx,%ecx
  800601:	75 10                	jne    800613 <strtol+0x73>
  800603:	80 3a 30             	cmpb   $0x30,(%edx)
  800606:	75 05                	jne    80060d <strtol+0x6d>
		s++, base = 8;
  800608:	42                   	inc    %edx
  800609:	b1 08                	mov    $0x8,%cl
  80060b:	eb 06                	jmp    800613 <strtol+0x73>
	else if (base == 0)
  80060d:	85 c9                	test   %ecx,%ecx
  80060f:	75 02                	jne    800613 <strtol+0x73>
		base = 10;
  800611:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800613:	8a 02                	mov    (%edx),%al
  800615:	83 e8 30             	sub    $0x30,%eax
  800618:	3c 09                	cmp    $0x9,%al
  80061a:	77 08                	ja     800624 <strtol+0x84>
			dig = *s - '0';
  80061c:	0f be 02             	movsbl (%edx),%eax
  80061f:	83 e8 30             	sub    $0x30,%eax
  800622:	eb 20                	jmp    800644 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800624:	8a 02                	mov    (%edx),%al
  800626:	83 e8 61             	sub    $0x61,%eax
  800629:	3c 19                	cmp    $0x19,%al
  80062b:	77 08                	ja     800635 <strtol+0x95>
			dig = *s - 'a' + 10;
  80062d:	0f be 02             	movsbl (%edx),%eax
  800630:	83 e8 57             	sub    $0x57,%eax
  800633:	eb 0f                	jmp    800644 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800635:	8a 02                	mov    (%edx),%al
  800637:	83 e8 41             	sub    $0x41,%eax
  80063a:	3c 19                	cmp    $0x19,%al
  80063c:	77 12                	ja     800650 <strtol+0xb0>
			dig = *s - 'A' + 10;
  80063e:	0f be 02             	movsbl (%edx),%eax
  800641:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800644:	39 c8                	cmp    %ecx,%eax
  800646:	7d 08                	jge    800650 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800648:	42                   	inc    %edx
  800649:	0f af d9             	imul   %ecx,%ebx
  80064c:	01 c3                	add    %eax,%ebx
  80064e:	eb c3                	jmp    800613 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800650:	85 f6                	test   %esi,%esi
  800652:	74 02                	je     800656 <strtol+0xb6>
		*endptr = (char *) s;
  800654:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800656:	89 d8                	mov    %ebx,%eax
  800658:	85 ff                	test   %edi,%edi
  80065a:	74 02                	je     80065e <strtol+0xbe>
  80065c:	f7 d8                	neg    %eax
}
  80065e:	5b                   	pop    %ebx
  80065f:	5e                   	pop    %esi
  800660:	5f                   	pop    %edi
  800661:	c9                   	leave  
  800662:	c3                   	ret    
	...

00800664 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	57                   	push   %edi
  800668:	56                   	push   %esi
  800669:	53                   	push   %ebx
  80066a:	83 ec 04             	sub    $0x4,%esp
  80066d:	8b 55 08             	mov    0x8(%ebp),%edx
  800670:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800673:	bf 00 00 00 00       	mov    $0x0,%edi
  800678:	89 f8                	mov    %edi,%eax
  80067a:	89 fb                	mov    %edi,%ebx
  80067c:	89 fe                	mov    %edi,%esi
  80067e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800680:	83 c4 04             	add    $0x4,%esp
  800683:	5b                   	pop    %ebx
  800684:	5e                   	pop    %esi
  800685:	5f                   	pop    %edi
  800686:	c9                   	leave  
  800687:	c3                   	ret    

00800688 <sys_cgetc>:

int
sys_cgetc(void)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	57                   	push   %edi
  80068c:	56                   	push   %esi
  80068d:	53                   	push   %ebx
  80068e:	b8 01 00 00 00       	mov    $0x1,%eax
  800693:	bf 00 00 00 00       	mov    $0x0,%edi
  800698:	89 fa                	mov    %edi,%edx
  80069a:	89 f9                	mov    %edi,%ecx
  80069c:	89 fb                	mov    %edi,%ebx
  80069e:	89 fe                	mov    %edi,%esi
  8006a0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8006a2:	5b                   	pop    %ebx
  8006a3:	5e                   	pop    %esi
  8006a4:	5f                   	pop    %edi
  8006a5:	c9                   	leave  
  8006a6:	c3                   	ret    

008006a7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	57                   	push   %edi
  8006ab:	56                   	push   %esi
  8006ac:	53                   	push   %ebx
  8006ad:	83 ec 0c             	sub    $0xc,%esp
  8006b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8006b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8006bd:	89 f9                	mov    %edi,%ecx
  8006bf:	89 fb                	mov    %edi,%ebx
  8006c1:	89 fe                	mov    %edi,%esi
  8006c3:	cd 30                	int    $0x30
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	7e 17                	jle    8006e0 <sys_env_destroy+0x39>
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	6a 03                	push   $0x3
  8006cf:	68 30 2a 80 00       	push   $0x802a30
  8006d4:	6a 23                	push   $0x23
  8006d6:	68 4d 2a 80 00       	push   $0x802a4d
  8006db:	e8 a0 18 00 00       	call   801f80 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8006e0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006e3:	5b                   	pop    %ebx
  8006e4:	5e                   	pop    %esi
  8006e5:	5f                   	pop    %edi
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	57                   	push   %edi
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	b8 02 00 00 00       	mov    $0x2,%eax
  8006f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8006f8:	89 fa                	mov    %edi,%edx
  8006fa:	89 f9                	mov    %edi,%ecx
  8006fc:	89 fb                	mov    %edi,%ebx
  8006fe:	89 fe                	mov    %edi,%esi
  800700:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800702:	5b                   	pop    %ebx
  800703:	5e                   	pop    %esi
  800704:	5f                   	pop    %edi
  800705:	c9                   	leave  
  800706:	c3                   	ret    

00800707 <sys_yield>:

void
sys_yield(void)
{
  800707:	55                   	push   %ebp
  800708:	89 e5                	mov    %esp,%ebp
  80070a:	57                   	push   %edi
  80070b:	56                   	push   %esi
  80070c:	53                   	push   %ebx
  80070d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800712:	bf 00 00 00 00       	mov    $0x0,%edi
  800717:	89 fa                	mov    %edi,%edx
  800719:	89 f9                	mov    %edi,%ecx
  80071b:	89 fb                	mov    %edi,%ebx
  80071d:	89 fe                	mov    %edi,%esi
  80071f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800721:	5b                   	pop    %ebx
  800722:	5e                   	pop    %esi
  800723:	5f                   	pop    %edi
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	57                   	push   %edi
  80072a:	56                   	push   %esi
  80072b:	53                   	push   %ebx
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	8b 55 08             	mov    0x8(%ebp),%edx
  800732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800735:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800738:	b8 04 00 00 00       	mov    $0x4,%eax
  80073d:	bf 00 00 00 00       	mov    $0x0,%edi
  800742:	89 fe                	mov    %edi,%esi
  800744:	cd 30                	int    $0x30
  800746:	85 c0                	test   %eax,%eax
  800748:	7e 17                	jle    800761 <sys_page_alloc+0x3b>
  80074a:	83 ec 0c             	sub    $0xc,%esp
  80074d:	50                   	push   %eax
  80074e:	6a 04                	push   $0x4
  800750:	68 30 2a 80 00       	push   $0x802a30
  800755:	6a 23                	push   $0x23
  800757:	68 4d 2a 80 00       	push   $0x802a4d
  80075c:	e8 1f 18 00 00       	call   801f80 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800761:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800764:	5b                   	pop    %ebx
  800765:	5e                   	pop    %esi
  800766:	5f                   	pop    %edi
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	57                   	push   %edi
  80076d:	56                   	push   %esi
  80076e:	53                   	push   %ebx
  80076f:	83 ec 0c             	sub    $0xc,%esp
  800772:	8b 55 08             	mov    0x8(%ebp),%edx
  800775:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800778:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80077b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80077e:	8b 75 18             	mov    0x18(%ebp),%esi
  800781:	b8 05 00 00 00       	mov    $0x5,%eax
  800786:	cd 30                	int    $0x30
  800788:	85 c0                	test   %eax,%eax
  80078a:	7e 17                	jle    8007a3 <sys_page_map+0x3a>
  80078c:	83 ec 0c             	sub    $0xc,%esp
  80078f:	50                   	push   %eax
  800790:	6a 05                	push   $0x5
  800792:	68 30 2a 80 00       	push   $0x802a30
  800797:	6a 23                	push   $0x23
  800799:	68 4d 2a 80 00       	push   $0x802a4d
  80079e:	e8 dd 17 00 00       	call   801f80 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8007a3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8007a6:	5b                   	pop    %ebx
  8007a7:	5e                   	pop    %esi
  8007a8:	5f                   	pop    %edi
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	57                   	push   %edi
  8007af:	56                   	push   %esi
  8007b0:	53                   	push   %ebx
  8007b1:	83 ec 0c             	sub    $0xc,%esp
  8007b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8007b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ba:	b8 06 00 00 00       	mov    $0x6,%eax
  8007bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8007c4:	89 fb                	mov    %edi,%ebx
  8007c6:	89 fe                	mov    %edi,%esi
  8007c8:	cd 30                	int    $0x30
  8007ca:	85 c0                	test   %eax,%eax
  8007cc:	7e 17                	jle    8007e5 <sys_page_unmap+0x3a>
  8007ce:	83 ec 0c             	sub    $0xc,%esp
  8007d1:	50                   	push   %eax
  8007d2:	6a 06                	push   $0x6
  8007d4:	68 30 2a 80 00       	push   $0x802a30
  8007d9:	6a 23                	push   $0x23
  8007db:	68 4d 2a 80 00       	push   $0x802a4d
  8007e0:	e8 9b 17 00 00       	call   801f80 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8007e5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8007e8:	5b                   	pop    %ebx
  8007e9:	5e                   	pop    %esi
  8007ea:	5f                   	pop    %edi
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    

008007ed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	57                   	push   %edi
  8007f1:	56                   	push   %esi
  8007f2:	53                   	push   %ebx
  8007f3:	83 ec 0c             	sub    $0xc,%esp
  8007f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8007f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007fc:	b8 08 00 00 00       	mov    $0x8,%eax
  800801:	bf 00 00 00 00       	mov    $0x0,%edi
  800806:	89 fb                	mov    %edi,%ebx
  800808:	89 fe                	mov    %edi,%esi
  80080a:	cd 30                	int    $0x30
  80080c:	85 c0                	test   %eax,%eax
  80080e:	7e 17                	jle    800827 <sys_env_set_status+0x3a>
  800810:	83 ec 0c             	sub    $0xc,%esp
  800813:	50                   	push   %eax
  800814:	6a 08                	push   $0x8
  800816:	68 30 2a 80 00       	push   $0x802a30
  80081b:	6a 23                	push   $0x23
  80081d:	68 4d 2a 80 00       	push   $0x802a4d
  800822:	e8 59 17 00 00       	call   801f80 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800827:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80082a:	5b                   	pop    %ebx
  80082b:	5e                   	pop    %esi
  80082c:	5f                   	pop    %edi
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    

0080082f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	57                   	push   %edi
  800833:	56                   	push   %esi
  800834:	53                   	push   %ebx
  800835:	83 ec 0c             	sub    $0xc,%esp
  800838:	8b 55 08             	mov    0x8(%ebp),%edx
  80083b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083e:	b8 09 00 00 00       	mov    $0x9,%eax
  800843:	bf 00 00 00 00       	mov    $0x0,%edi
  800848:	89 fb                	mov    %edi,%ebx
  80084a:	89 fe                	mov    %edi,%esi
  80084c:	cd 30                	int    $0x30
  80084e:	85 c0                	test   %eax,%eax
  800850:	7e 17                	jle    800869 <sys_env_set_trapframe+0x3a>
  800852:	83 ec 0c             	sub    $0xc,%esp
  800855:	50                   	push   %eax
  800856:	6a 09                	push   $0x9
  800858:	68 30 2a 80 00       	push   $0x802a30
  80085d:	6a 23                	push   $0x23
  80085f:	68 4d 2a 80 00       	push   $0x802a4d
  800864:	e8 17 17 00 00       	call   801f80 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800869:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80086c:	5b                   	pop    %ebx
  80086d:	5e                   	pop    %esi
  80086e:	5f                   	pop    %edi
  80086f:	c9                   	leave  
  800870:	c3                   	ret    

00800871 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	57                   	push   %edi
  800875:	56                   	push   %esi
  800876:	53                   	push   %ebx
  800877:	83 ec 0c             	sub    $0xc,%esp
  80087a:	8b 55 08             	mov    0x8(%ebp),%edx
  80087d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800880:	b8 0a 00 00 00       	mov    $0xa,%eax
  800885:	bf 00 00 00 00       	mov    $0x0,%edi
  80088a:	89 fb                	mov    %edi,%ebx
  80088c:	89 fe                	mov    %edi,%esi
  80088e:	cd 30                	int    $0x30
  800890:	85 c0                	test   %eax,%eax
  800892:	7e 17                	jle    8008ab <sys_env_set_pgfault_upcall+0x3a>
  800894:	83 ec 0c             	sub    $0xc,%esp
  800897:	50                   	push   %eax
  800898:	6a 0a                	push   $0xa
  80089a:	68 30 2a 80 00       	push   $0x802a30
  80089f:	6a 23                	push   $0x23
  8008a1:	68 4d 2a 80 00       	push   $0x802a4d
  8008a6:	e8 d5 16 00 00       	call   801f80 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8008ab:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8008ae:	5b                   	pop    %ebx
  8008af:	5e                   	pop    %esi
  8008b0:	5f                   	pop    %edi
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	57                   	push   %edi
  8008b7:	56                   	push   %esi
  8008b8:	53                   	push   %ebx
  8008b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8008bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8008c5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8008ca:	be 00 00 00 00       	mov    $0x0,%esi
  8008cf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5f                   	pop    %edi
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    

008008d6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	57                   	push   %edi
  8008da:	56                   	push   %esi
  8008db:	53                   	push   %ebx
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e2:	b8 0d 00 00 00       	mov    $0xd,%eax
  8008e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ec:	89 f9                	mov    %edi,%ecx
  8008ee:	89 fb                	mov    %edi,%ebx
  8008f0:	89 fe                	mov    %edi,%esi
  8008f2:	cd 30                	int    $0x30
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	7e 17                	jle    80090f <sys_ipc_recv+0x39>
  8008f8:	83 ec 0c             	sub    $0xc,%esp
  8008fb:	50                   	push   %eax
  8008fc:	6a 0d                	push   $0xd
  8008fe:	68 30 2a 80 00       	push   $0x802a30
  800903:	6a 23                	push   $0x23
  800905:	68 4d 2a 80 00       	push   $0x802a4d
  80090a:	e8 71 16 00 00       	call   801f80 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80090f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5f                   	pop    %edi
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	57                   	push   %edi
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	83 ec 0c             	sub    $0xc,%esp
  800920:	8b 55 08             	mov    0x8(%ebp),%edx
  800923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800926:	b8 10 00 00 00       	mov    $0x10,%eax
  80092b:	bf 00 00 00 00       	mov    $0x0,%edi
  800930:	89 fb                	mov    %edi,%ebx
  800932:	89 fe                	mov    %edi,%esi
  800934:	cd 30                	int    $0x30
  800936:	85 c0                	test   %eax,%eax
  800938:	7e 17                	jle    800951 <sys_transmit_packet+0x3a>
  80093a:	83 ec 0c             	sub    $0xc,%esp
  80093d:	50                   	push   %eax
  80093e:	6a 10                	push   $0x10
  800940:	68 30 2a 80 00       	push   $0x802a30
  800945:	6a 23                	push   $0x23
  800947:	68 4d 2a 80 00       	push   $0x802a4d
  80094c:	e8 2f 16 00 00       	call   801f80 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800951:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800954:	5b                   	pop    %ebx
  800955:	5e                   	pop    %esi
  800956:	5f                   	pop    %edi
  800957:	c9                   	leave  
  800958:	c3                   	ret    

00800959 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	57                   	push   %edi
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	83 ec 0c             	sub    $0xc,%esp
  800962:	8b 55 08             	mov    0x8(%ebp),%edx
  800965:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800968:	b8 11 00 00 00       	mov    $0x11,%eax
  80096d:	bf 00 00 00 00       	mov    $0x0,%edi
  800972:	89 fb                	mov    %edi,%ebx
  800974:	89 fe                	mov    %edi,%esi
  800976:	cd 30                	int    $0x30
  800978:	85 c0                	test   %eax,%eax
  80097a:	7e 17                	jle    800993 <sys_receive_packet+0x3a>
  80097c:	83 ec 0c             	sub    $0xc,%esp
  80097f:	50                   	push   %eax
  800980:	6a 11                	push   $0x11
  800982:	68 30 2a 80 00       	push   $0x802a30
  800987:	6a 23                	push   $0x23
  800989:	68 4d 2a 80 00       	push   $0x802a4d
  80098e:	e8 ed 15 00 00       	call   801f80 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800993:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800996:	5b                   	pop    %ebx
  800997:	5e                   	pop    %esi
  800998:	5f                   	pop    %edi
  800999:	c9                   	leave  
  80099a:	c3                   	ret    

0080099b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	57                   	push   %edi
  80099f:	56                   	push   %esi
  8009a0:	53                   	push   %ebx
  8009a1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8009a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ab:	89 fa                	mov    %edi,%edx
  8009ad:	89 f9                	mov    %edi,%ecx
  8009af:	89 fb                	mov    %edi,%ebx
  8009b1:	89 fe                	mov    %edi,%esi
  8009b3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8009b5:	5b                   	pop    %ebx
  8009b6:	5e                   	pop    %esi
  8009b7:	5f                   	pop    %edi
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	57                   	push   %edi
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 0c             	sub    $0xc,%esp
  8009c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8009cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8009d0:	89 f9                	mov    %edi,%ecx
  8009d2:	89 fb                	mov    %edi,%ebx
  8009d4:	89 fe                	mov    %edi,%esi
  8009d6:	cd 30                	int    $0x30
  8009d8:	85 c0                	test   %eax,%eax
  8009da:	7e 17                	jle    8009f3 <sys_map_receive_buffers+0x39>
  8009dc:	83 ec 0c             	sub    $0xc,%esp
  8009df:	50                   	push   %eax
  8009e0:	6a 0e                	push   $0xe
  8009e2:	68 30 2a 80 00       	push   $0x802a30
  8009e7:	6a 23                	push   $0x23
  8009e9:	68 4d 2a 80 00       	push   $0x802a4d
  8009ee:	e8 8d 15 00 00       	call   801f80 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  8009f3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5f                   	pop    %edi
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	57                   	push   %edi
  8009ff:	56                   	push   %esi
  800a00:	53                   	push   %ebx
  800a01:	83 ec 0c             	sub    $0xc,%esp
  800a04:	8b 55 08             	mov    0x8(%ebp),%edx
  800a07:	b8 12 00 00 00       	mov    $0x12,%eax
  800a0c:	bf 00 00 00 00       	mov    $0x0,%edi
  800a11:	89 f9                	mov    %edi,%ecx
  800a13:	89 fb                	mov    %edi,%ebx
  800a15:	89 fe                	mov    %edi,%esi
  800a17:	cd 30                	int    $0x30
  800a19:	85 c0                	test   %eax,%eax
  800a1b:	7e 17                	jle    800a34 <sys_receive_packet_zerocopy+0x39>
  800a1d:	83 ec 0c             	sub    $0xc,%esp
  800a20:	50                   	push   %eax
  800a21:	6a 12                	push   $0x12
  800a23:	68 30 2a 80 00       	push   $0x802a30
  800a28:	6a 23                	push   $0x23
  800a2a:	68 4d 2a 80 00       	push   $0x802a4d
  800a2f:	e8 4c 15 00 00       	call   801f80 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800a34:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800a37:	5b                   	pop    %ebx
  800a38:	5e                   	pop    %esi
  800a39:	5f                   	pop    %edi
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	57                   	push   %edi
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 0c             	sub    $0xc,%esp
  800a45:	8b 55 08             	mov    0x8(%ebp),%edx
  800a48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4b:	b8 13 00 00 00       	mov    $0x13,%eax
  800a50:	bf 00 00 00 00       	mov    $0x0,%edi
  800a55:	89 fb                	mov    %edi,%ebx
  800a57:	89 fe                	mov    %edi,%esi
  800a59:	cd 30                	int    $0x30
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	7e 17                	jle    800a76 <sys_env_set_priority+0x3a>
  800a5f:	83 ec 0c             	sub    $0xc,%esp
  800a62:	50                   	push   %eax
  800a63:	6a 13                	push   $0x13
  800a65:	68 30 2a 80 00       	push   $0x802a30
  800a6a:	6a 23                	push   $0x23
  800a6c:	68 4d 2a 80 00       	push   $0x802a4d
  800a71:	e8 0a 15 00 00       	call   801f80 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800a76:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800a79:	5b                   	pop    %ebx
  800a7a:	5e                   	pop    %esi
  800a7b:	5f                   	pop    %edi
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    
	...

00800a80 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 0a 00 00 00       	call   800a98 <fd2num>
  800a8e:	c1 e0 16             	shl    $0x16,%eax
  800a91:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <fd2num>:

int
fd2num(struct Fd *fd)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	05 00 00 40 30       	add    $0x30400000,%eax
  800aa3:	c1 e8 0c             	shr    $0xc,%eax
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <fd_alloc>:

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
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	57                   	push   %edi
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
  800aae:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ab1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab6:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  800abb:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  800ac0:	89 c8                	mov    %ecx,%eax
  800ac2:	c1 e0 0c             	shl    $0xc,%eax
  800ac5:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800acb:	89 d0                	mov    %edx,%eax
  800acd:	c1 e8 16             	shr    $0x16,%eax
  800ad0:	8b 04 86             	mov    (%esi,%eax,4),%eax
  800ad3:	a8 01                	test   $0x1,%al
  800ad5:	74 0c                	je     800ae3 <fd_alloc+0x3b>
  800ad7:	89 d0                	mov    %edx,%eax
  800ad9:	c1 e8 0c             	shr    $0xc,%eax
  800adc:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  800adf:	a8 01                	test   $0x1,%al
  800ae1:	75 09                	jne    800aec <fd_alloc+0x44>
			*fd_store = fd;
  800ae3:	89 17                	mov    %edx,(%edi)
			return 0;
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aea:	eb 11                	jmp    800afd <fd_alloc+0x55>
  800aec:	41                   	inc    %ecx
  800aed:	83 f9 1f             	cmp    $0x1f,%ecx
  800af0:	7e ce                	jle    800ac0 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  800af2:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  800af8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800afd:	5b                   	pop    %ebx
  800afe:	5e                   	pop    %esi
  800aff:	5f                   	pop    %edi
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  800b08:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800b0d:	83 f8 1f             	cmp    $0x1f,%eax
  800b10:	77 3a                	ja     800b4c <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  800b12:	c1 e0 0c             	shl    $0xc,%eax
  800b15:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800b1b:	89 d0                	mov    %edx,%eax
  800b1d:	c1 e8 16             	shr    $0x16,%eax
  800b20:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800b27:	a8 01                	test   $0x1,%al
  800b29:	74 10                	je     800b3b <fd_lookup+0x39>
  800b2b:	89 d0                	mov    %edx,%eax
  800b2d:	c1 e8 0c             	shr    $0xc,%eax
  800b30:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800b37:	a8 01                	test   $0x1,%al
  800b39:	75 07                	jne    800b42 <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  800b3b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800b40:	eb 0a                	jmp    800b4c <fd_lookup+0x4a>
	}
	*fd_store = fd;
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	89 10                	mov    %edx,(%eax)
	return 0;
  800b47:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4c:	89 d0                	mov    %edx,%eax
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <fd_close>:

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
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	83 ec 10             	sub    $0x10,%esp
  800b58:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800b5b:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800b5e:	50                   	push   %eax
  800b5f:	56                   	push   %esi
  800b60:	e8 33 ff ff ff       	call   800a98 <fd2num>
  800b65:	89 04 24             	mov    %eax,(%esp)
  800b68:	e8 95 ff ff ff       	call   800b02 <fd_lookup>
  800b6d:	89 c3                	mov    %eax,%ebx
  800b6f:	83 c4 08             	add    $0x8,%esp
  800b72:	85 c0                	test   %eax,%eax
  800b74:	78 05                	js     800b7b <fd_close+0x2b>
  800b76:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  800b79:	74 0f                	je     800b8a <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800b7b:	89 d8                	mov    %ebx,%eax
  800b7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b81:	75 3a                	jne    800bbd <fd_close+0x6d>
  800b83:	b8 00 00 00 00       	mov    $0x0,%eax
  800b88:	eb 33                	jmp    800bbd <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800b90:	50                   	push   %eax
  800b91:	ff 36                	pushl  (%esi)
  800b93:	e8 2c 00 00 00       	call   800bc4 <dev_lookup>
  800b98:	89 c3                	mov    %eax,%ebx
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	85 c0                	test   %eax,%eax
  800b9f:	78 0f                	js     800bb0 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  800ba1:	83 ec 0c             	sub    $0xc,%esp
  800ba4:	56                   	push   %esi
  800ba5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  800ba8:	ff 50 10             	call   *0x10(%eax)
  800bab:	89 c3                	mov    %eax,%ebx
  800bad:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	56                   	push   %esi
  800bb4:	6a 00                	push   $0x0
  800bb6:	e8 f0 fb ff ff       	call   8007ab <sys_page_unmap>
	return r;
  800bbb:	89 d8                	mov    %ebx,%eax
}
  800bbd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <dev_lookup>:


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
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  800bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd4:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  800bdb:	74 1c                	je     800bf9 <dev_lookup+0x35>
  800bdd:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  800be2:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  800be5:	39 18                	cmp    %ebx,(%eax)
  800be7:	75 09                	jne    800bf2 <dev_lookup+0x2e>
			*dev = devtab[i];
  800be9:	89 06                	mov    %eax,(%esi)
			return 0;
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf0:	eb 29                	jmp    800c1b <dev_lookup+0x57>
  800bf2:	42                   	inc    %edx
  800bf3:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  800bf7:	75 e9                	jne    800be2 <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800bf9:	83 ec 04             	sub    $0x4,%esp
  800bfc:	53                   	push   %ebx
  800bfd:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  800c02:	8b 40 4c             	mov    0x4c(%eax),%eax
  800c05:	50                   	push   %eax
  800c06:	68 5c 2a 80 00       	push   $0x802a5c
  800c0b:	e8 60 14 00 00       	call   802070 <cprintf>
	*dev = 0;
  800c10:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  800c16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800c1b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <close>:

int
close(int fdnum)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c28:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800c2b:	50                   	push   %eax
  800c2c:	ff 75 08             	pushl  0x8(%ebp)
  800c2f:	e8 ce fe ff ff       	call   800b02 <fd_lookup>
  800c34:	83 c4 08             	add    $0x8,%esp
		return r;
  800c37:	89 c2                	mov    %eax,%edx
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	78 0f                	js     800c4c <close+0x2a>
	else
		return fd_close(fd, 1);
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	6a 01                	push   $0x1
  800c42:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  800c45:	e8 06 ff ff ff       	call   800b50 <fd_close>
  800c4a:	89 c2                	mov    %eax,%edx
}
  800c4c:	89 d0                	mov    %edx,%eax
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <close_all>:

void
close_all(void)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	53                   	push   %ebx
  800c54:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800c57:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	53                   	push   %ebx
  800c60:	e8 bd ff ff ff       	call   800c22 <close>
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	43                   	inc    %ebx
  800c69:	83 fb 1f             	cmp    $0x1f,%ebx
  800c6c:	7e ee                	jle    800c5c <close_all+0xc>
}
  800c6e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800c7c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800c7f:	50                   	push   %eax
  800c80:	ff 75 08             	pushl  0x8(%ebp)
  800c83:	e8 7a fe ff ff       	call   800b02 <fd_lookup>
  800c88:	89 c6                	mov    %eax,%esi
  800c8a:	83 c4 08             	add    $0x8,%esp
  800c8d:	85 f6                	test   %esi,%esi
  800c8f:	0f 88 f8 00 00 00    	js     800d8d <dup+0x11a>
		return r;
	close(newfdnum);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	e8 82 ff ff ff       	call   800c22 <close>

	newfd = INDEX2FD(newfdnum);
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	c1 e0 0c             	shl    $0xc,%eax
  800ca6:	2d 00 00 40 30       	sub    $0x30400000,%eax
  800cab:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  800cae:	83 c4 04             	add    $0x4,%esp
  800cb1:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800cb4:	e8 c7 fd ff ff       	call   800a80 <fd2data>
  800cb9:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800cbb:	83 c4 04             	add    $0x4,%esp
  800cbe:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800cc1:	e8 ba fd ff ff       	call   800a80 <fd2data>
  800cc6:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  800cc9:	89 f8                	mov    %edi,%eax
  800ccb:	c1 e8 16             	shr    $0x16,%eax
  800cce:	83 c4 10             	add    $0x10,%esp
  800cd1:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800cd8:	85 c0                	test   %eax,%eax
  800cda:	74 48                	je     800d24 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  800cdc:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  800ce1:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  800ce4:	89 d0                	mov    %edx,%eax
  800ce6:	c1 e8 0c             	shr    $0xc,%eax
  800ce9:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  800cf0:	a8 01                	test   $0x1,%al
  800cf2:	74 22                	je     800d16 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	25 07 0e 00 00       	and    $0xe07,%eax
  800cfc:	50                   	push   %eax
  800cfd:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  800d00:	01 d8                	add    %ebx,%eax
  800d02:	50                   	push   %eax
  800d03:	6a 00                	push   $0x0
  800d05:	52                   	push   %edx
  800d06:	6a 00                	push   $0x0
  800d08:	e8 5c fa ff ff       	call   800769 <sys_page_map>
  800d0d:	89 c6                	mov    %eax,%esi
  800d0f:	83 c4 20             	add    $0x20,%esp
  800d12:	85 c0                	test   %eax,%eax
  800d14:	78 3f                	js     800d55 <dup+0xe2>
  800d16:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800d1c:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  800d22:	7e bd                	jle    800ce1 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  800d2a:	89 d0                	mov    %edx,%eax
  800d2c:	c1 e8 0c             	shr    $0xc,%eax
  800d2f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800d36:	25 07 0e 00 00       	and    $0xe07,%eax
  800d3b:	50                   	push   %eax
  800d3c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800d3f:	6a 00                	push   $0x0
  800d41:	52                   	push   %edx
  800d42:	6a 00                	push   $0x0
  800d44:	e8 20 fa ff ff       	call   800769 <sys_page_map>
  800d49:	89 c6                	mov    %eax,%esi
  800d4b:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	85 f6                	test   %esi,%esi
  800d53:	79 38                	jns    800d8d <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800d5b:	6a 00                	push   $0x0
  800d5d:	e8 49 fa ff ff       	call   8007ab <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  800d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d67:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  800d6a:	83 ec 08             	sub    $0x8,%esp
  800d6d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  800d70:	01 d8                	add    %ebx,%eax
  800d72:	50                   	push   %eax
  800d73:	6a 00                	push   $0x0
  800d75:	e8 31 fa ff ff       	call   8007ab <sys_page_unmap>
  800d7a:	83 c4 10             	add    $0x10,%esp
  800d7d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800d83:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  800d89:	7e df                	jle    800d6a <dup+0xf7>
	return r;
  800d8b:	89 f0                	mov    %esi,%eax
}
  800d8d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	53                   	push   %ebx
  800d99:	83 ec 14             	sub    $0x14,%esp
  800d9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d9f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800da2:	50                   	push   %eax
  800da3:	53                   	push   %ebx
  800da4:	e8 59 fd ff ff       	call   800b02 <fd_lookup>
  800da9:	89 c2                	mov    %eax,%edx
  800dab:	83 c4 08             	add    $0x8,%esp
  800dae:	85 c0                	test   %eax,%eax
  800db0:	78 1a                	js     800dcc <read+0x37>
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800db8:	50                   	push   %eax
  800db9:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800dbc:	ff 30                	pushl  (%eax)
  800dbe:	e8 01 fe ff ff       	call   800bc4 <dev_lookup>
  800dc3:	89 c2                	mov    %eax,%edx
  800dc5:	83 c4 10             	add    $0x10,%esp
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	79 04                	jns    800dd0 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  800dcc:	89 d0                	mov    %edx,%eax
  800dce:	eb 50                	jmp    800e20 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800dd0:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800dd3:	8b 40 08             	mov    0x8(%eax),%eax
  800dd6:	83 e0 03             	and    $0x3,%eax
  800dd9:	83 f8 01             	cmp    $0x1,%eax
  800ddc:	75 1e                	jne    800dfc <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800dde:	83 ec 04             	sub    $0x4,%esp
  800de1:	53                   	push   %ebx
  800de2:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  800de7:	8b 40 4c             	mov    0x4c(%eax),%eax
  800dea:	50                   	push   %eax
  800deb:	68 9d 2a 80 00       	push   $0x802a9d
  800df0:	e8 7b 12 00 00       	call   802070 <cprintf>
		return -E_INVAL;
  800df5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dfa:	eb 24                	jmp    800e20 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  800dfc:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800dff:	ff 70 04             	pushl  0x4(%eax)
  800e02:	ff 75 10             	pushl  0x10(%ebp)
  800e05:	ff 75 0c             	pushl  0xc(%ebp)
  800e08:	50                   	push   %eax
  800e09:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800e0c:	ff 50 08             	call   *0x8(%eax)
  800e0f:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	85 c0                	test   %eax,%eax
  800e16:	78 06                	js     800e1e <read+0x89>
		fd->fd_offset += r;
  800e18:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800e1b:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  800e1e:	89 d0                	mov    %edx,%eax
}
  800e20:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e31:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800e34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e39:	39 f3                	cmp    %esi,%ebx
  800e3b:	73 25                	jae    800e62 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800e3d:	83 ec 04             	sub    $0x4,%esp
  800e40:	89 f0                	mov    %esi,%eax
  800e42:	29 d8                	sub    %ebx,%eax
  800e44:	50                   	push   %eax
  800e45:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  800e48:	50                   	push   %eax
  800e49:	ff 75 08             	pushl  0x8(%ebp)
  800e4c:	e8 44 ff ff ff       	call   800d95 <read>
		if (m < 0)
  800e51:	83 c4 10             	add    $0x10,%esp
  800e54:	85 c0                	test   %eax,%eax
  800e56:	78 0c                	js     800e64 <readn+0x3f>
			return m;
		if (m == 0)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	74 06                	je     800e62 <readn+0x3d>
  800e5c:	01 c3                	add    %eax,%ebx
  800e5e:	39 f3                	cmp    %esi,%ebx
  800e60:	72 db                	jb     800e3d <readn+0x18>
			break;
	}
	return tot;
  800e62:	89 d8                	mov    %ebx,%eax
}
  800e64:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 14             	sub    $0x14,%esp
  800e73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e76:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800e79:	50                   	push   %eax
  800e7a:	53                   	push   %ebx
  800e7b:	e8 82 fc ff ff       	call   800b02 <fd_lookup>
  800e80:	89 c2                	mov    %eax,%edx
  800e82:	83 c4 08             	add    $0x8,%esp
  800e85:	85 c0                	test   %eax,%eax
  800e87:	78 1a                	js     800ea3 <write+0x37>
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800e8f:	50                   	push   %eax
  800e90:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800e93:	ff 30                	pushl  (%eax)
  800e95:	e8 2a fd ff ff       	call   800bc4 <dev_lookup>
  800e9a:	89 c2                	mov    %eax,%edx
  800e9c:	83 c4 10             	add    $0x10,%esp
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	79 04                	jns    800ea7 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  800ea3:	89 d0                	mov    %edx,%eax
  800ea5:	eb 4b                	jmp    800ef2 <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ea7:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800eaa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800eae:	75 1e                	jne    800ece <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800eb0:	83 ec 04             	sub    $0x4,%esp
  800eb3:	53                   	push   %ebx
  800eb4:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  800eb9:	8b 40 4c             	mov    0x4c(%eax),%eax
  800ebc:	50                   	push   %eax
  800ebd:	68 b9 2a 80 00       	push   $0x802ab9
  800ec2:	e8 a9 11 00 00       	call   802070 <cprintf>
		return -E_INVAL;
  800ec7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ecc:	eb 24                	jmp    800ef2 <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  800ece:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800ed1:	ff 70 04             	pushl  0x4(%eax)
  800ed4:	ff 75 10             	pushl  0x10(%ebp)
  800ed7:	ff 75 0c             	pushl  0xc(%ebp)
  800eda:	50                   	push   %eax
  800edb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800ede:	ff 50 0c             	call   *0xc(%eax)
  800ee1:	89 c2                	mov    %eax,%edx
	if (r > 0)
  800ee3:	83 c4 10             	add    $0x10,%esp
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7e 06                	jle    800ef0 <write+0x84>
		fd->fd_offset += r;
  800eea:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800eed:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  800ef0:	89 d0                	mov    %edx,%eax
}
  800ef2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    

00800ef7 <seek>:

int
seek(int fdnum, off_t offset)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800efd:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800f00:	50                   	push   %eax
  800f01:	ff 75 08             	pushl  0x8(%ebp)
  800f04:	e8 f9 fb ff ff       	call   800b02 <fd_lookup>
  800f09:	83 c4 08             	add    $0x8,%esp
		return r;
  800f0c:	89 c2                	mov    %eax,%edx
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	78 0e                	js     800f20 <seek+0x29>
	fd->fd_offset = offset;
  800f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f15:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  800f18:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800f1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f20:	89 d0                	mov    %edx,%eax
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	53                   	push   %ebx
  800f28:	83 ec 14             	sub    $0x14,%esp
  800f2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f2e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800f31:	50                   	push   %eax
  800f32:	53                   	push   %ebx
  800f33:	e8 ca fb ff ff       	call   800b02 <fd_lookup>
  800f38:	83 c4 08             	add    $0x8,%esp
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	78 4e                	js     800f8d <ftruncate+0x69>
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800f45:	50                   	push   %eax
  800f46:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800f49:	ff 30                	pushl  (%eax)
  800f4b:	e8 74 fc ff ff       	call   800bc4 <dev_lookup>
  800f50:	83 c4 10             	add    $0x10,%esp
  800f53:	85 c0                	test   %eax,%eax
  800f55:	78 36                	js     800f8d <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800f57:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800f5a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800f5e:	75 1e                	jne    800f7e <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	53                   	push   %ebx
  800f64:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  800f69:	8b 40 4c             	mov    0x4c(%eax),%eax
  800f6c:	50                   	push   %eax
  800f6d:	68 7c 2a 80 00       	push   $0x802a7c
  800f72:	e8 f9 10 00 00       	call   802070 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  800f77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7c:	eb 0f                	jmp    800f8d <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  800f7e:	83 ec 08             	sub    $0x8,%esp
  800f81:	ff 75 0c             	pushl  0xc(%ebp)
  800f84:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800f87:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800f8a:	ff 50 1c             	call   *0x1c(%eax)
}
  800f8d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	53                   	push   %ebx
  800f96:	83 ec 14             	sub    $0x14,%esp
  800f99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f9c:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800f9f:	50                   	push   %eax
  800fa0:	ff 75 08             	pushl  0x8(%ebp)
  800fa3:	e8 5a fb ff ff       	call   800b02 <fd_lookup>
  800fa8:	83 c4 08             	add    $0x8,%esp
  800fab:	85 c0                	test   %eax,%eax
  800fad:	78 42                	js     800ff1 <fstat+0x5f>
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800fb5:	50                   	push   %eax
  800fb6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800fb9:	ff 30                	pushl  (%eax)
  800fbb:	e8 04 fc ff ff       	call   800bc4 <dev_lookup>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	78 2a                	js     800ff1 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  800fc7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800fca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800fd1:	00 00 00 
	stat->st_isdir = 0;
  800fd4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800fdb:	00 00 00 
	stat->st_dev = dev;
  800fde:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800fe1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	53                   	push   %ebx
  800feb:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800fee:	ff 50 14             	call   *0x14(%eax)
}
  800ff1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	56                   	push   %esi
  800ffa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	6a 00                	push   $0x0
  801000:	ff 75 08             	pushl  0x8(%ebp)
  801003:	e8 28 00 00 00       	call   801030 <open>
  801008:	89 c6                	mov    %eax,%esi
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	85 f6                	test   %esi,%esi
  80100f:	78 18                	js     801029 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	56                   	push   %esi
  801018:	e8 75 ff ff ff       	call   800f92 <fstat>
  80101d:	89 c3                	mov    %eax,%ebx
	close(fd);
  80101f:	89 34 24             	mov    %esi,(%esp)
  801022:	e8 fb fb ff ff       	call   800c22 <close>
	return r;
  801027:	89 d8                	mov    %ebx,%eax
}
  801029:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	53                   	push   %ebx
  801034:	83 ec 10             	sub    $0x10,%esp
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
  801037:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80103a:	50                   	push   %eax
  80103b:	e8 68 fa ff ff       	call   800aa8 <fd_alloc>
  801040:	89 c3                	mov    %eax,%ebx
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	85 db                	test   %ebx,%ebx
  801047:	78 36                	js     80107f <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801049:	83 ec 04             	sub    $0x4,%esp
  80104c:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	ff 75 08             	pushl  0x8(%ebp)
  801055:	e8 37 06 00 00       	call   801691 <fsipc_open>
  80105a:	89 c3                	mov    %eax,%ebx
  80105c:	83 c4 10             	add    $0x10,%esp
  80105f:	85 c0                	test   %eax,%eax
  801061:	79 11                	jns    801074 <open+0x44>
          fd_close(fd_store, 0);
  801063:	83 ec 08             	sub    $0x8,%esp
  801066:	6a 00                	push   $0x0
  801068:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80106b:	e8 e0 fa ff ff       	call   800b50 <fd_close>
          return r;
  801070:	89 d8                	mov    %ebx,%eax
  801072:	eb 0b                	jmp    80107f <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80107a:	e8 19 fa ff ff       	call   800a98 <fd2num>
}
  80107f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	53                   	push   %ebx
  801088:	83 ec 04             	sub    $0x4,%esp
  80108b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  80108e:	6a 01                	push   $0x1
  801090:	6a 00                	push   $0x0
  801092:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801098:	53                   	push   %ebx
  801099:	e8 e7 03 00 00       	call   801485 <funmap>
  80109e:	83 c4 10             	add    $0x10,%esp
          return r;
  8010a1:	89 c2                	mov    %eax,%edx
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	78 19                	js     8010c0 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8010a7:	83 ec 0c             	sub    $0xc,%esp
  8010aa:	ff 73 0c             	pushl  0xc(%ebx)
  8010ad:	e8 84 06 00 00       	call   801736 <fsipc_close>
  8010b2:	83 c4 10             	add    $0x10,%esp
          return r;
  8010b5:	89 c2                	mov    %eax,%edx
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	78 05                	js     8010c0 <file_close+0x3c>
        }
        return 0;
  8010bb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010c0:	89 d0                	mov    %edx,%eax
  8010c2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	8b 75 10             	mov    0x10(%ebp),%esi
  8010d3:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  8010df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e4:	39 d7                	cmp    %edx,%edi
  8010e6:	0f 87 95 00 00 00    	ja     801181 <file_read+0xba>
	if (offset + n > size)
  8010ec:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8010ef:	39 d0                	cmp    %edx,%eax
  8010f1:	76 04                	jbe    8010f7 <file_read+0x30>
		n = size - offset;
  8010f3:	89 d6                	mov    %edx,%esi
  8010f5:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	ff 75 08             	pushl  0x8(%ebp)
  8010fd:	e8 7e f9 ff ff       	call   800a80 <fd2data>
  801102:	89 c3                	mov    %eax,%ebx
  801104:	01 fb                	add    %edi,%ebx
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	eb 41                	jmp    80114c <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	c1 e8 16             	shr    $0x16,%eax
  801110:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 10                	je     80112b <file_read+0x64>
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	c1 e8 0c             	shr    $0xc,%eax
  801120:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801127:	a8 01                	test   $0x1,%al
  801129:	75 1b                	jne    801146 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801131:	50                   	push   %eax
  801132:	57                   	push   %edi
  801133:	ff 75 08             	pushl  0x8(%ebp)
  801136:	e8 d4 02 00 00       	call   80140f <fmap>
  80113b:	83 c4 10             	add    $0x10,%esp
              return r;
  80113e:	89 c1                	mov    %eax,%ecx
  801140:	85 c0                	test   %eax,%eax
  801142:	78 3d                	js     801181 <file_read+0xba>
  801144:	eb 1c                	jmp    801162 <file_read+0x9b>
  801146:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	ff 75 08             	pushl  0x8(%ebp)
  801152:	e8 29 f9 ff ff       	call   800a80 <fd2data>
  801157:	01 f8                	add    %edi,%eax
  801159:	01 f0                	add    %esi,%eax
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	39 d8                	cmp    %ebx,%eax
  801160:	77 a9                	ja     80110b <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801162:	83 ec 04             	sub    $0x4,%esp
  801165:	56                   	push   %esi
  801166:	83 ec 04             	sub    $0x4,%esp
  801169:	ff 75 08             	pushl  0x8(%ebp)
  80116c:	e8 0f f9 ff ff       	call   800a80 <fd2data>
  801171:	83 c4 08             	add    $0x8,%esp
  801174:	01 f8                	add    %edi,%eax
  801176:	50                   	push   %eax
  801177:	ff 75 0c             	pushl  0xc(%ebp)
  80117a:	e8 51 f3 ff ff       	call   8004d0 <memmove>
	return n;
  80117f:	89 f1                	mov    %esi,%ecx
}
  801181:	89 c8                	mov    %ecx,%eax
  801183:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	83 ec 18             	sub    $0x18,%esp
  801193:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801196:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801199:	50                   	push   %eax
  80119a:	ff 75 08             	pushl  0x8(%ebp)
  80119d:	e8 60 f9 ff ff       	call   800b02 <fd_lookup>
  8011a2:	83 c4 10             	add    $0x10,%esp
		return r;
  8011a5:	89 c2                	mov    %eax,%edx
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	0f 88 9f 00 00 00    	js     80124e <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8011af:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8011b2:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8011b4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8011b9:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  8011bf:	0f 85 89 00 00 00    	jne    80124e <read_map+0xc3>
	va = fd2data(fd) + offset;
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8011cb:	e8 b0 f8 ff ff       	call   800a80 <fd2data>
  8011d0:	89 c3                	mov    %eax,%ebx
  8011d2:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8011d4:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8011d7:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8011dc:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  8011e2:	7f 6a                	jg     80124e <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  8011e4:	89 d8                	mov    %ebx,%eax
  8011e6:	c1 e8 16             	shr    $0x16,%eax
  8011e9:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8011f0:	a8 01                	test   $0x1,%al
  8011f2:	74 10                	je     801204 <read_map+0x79>
  8011f4:	89 d8                	mov    %ebx,%eax
  8011f6:	c1 e8 0c             	shr    $0xc,%eax
  8011f9:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801200:	a8 01                	test   $0x1,%al
  801202:	75 19                	jne    80121d <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	8d 46 01             	lea    0x1(%esi),%eax
  80120a:	50                   	push   %eax
  80120b:	56                   	push   %esi
  80120c:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80120f:	e8 fb 01 00 00       	call   80140f <fmap>
  801214:	83 c4 10             	add    $0x10,%esp
            return r;
  801217:	89 c2                	mov    %eax,%edx
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 31                	js     80124e <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  80121d:	89 d8                	mov    %ebx,%eax
  80121f:	c1 e8 16             	shr    $0x16,%eax
  801222:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801229:	a8 01                	test   $0x1,%al
  80122b:	74 10                	je     80123d <read_map+0xb2>
  80122d:	89 d8                	mov    %ebx,%eax
  80122f:	c1 e8 0c             	shr    $0xc,%eax
  801232:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801239:	a8 01                	test   $0x1,%al
  80123b:	75 07                	jne    801244 <read_map+0xb9>
		return -E_NO_DISK;
  80123d:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801242:	eb 0a                	jmp    80124e <read_map+0xc3>

	*blk = (void*) va;
  801244:	8b 45 10             	mov    0x10(%ebp),%eax
  801247:	89 18                	mov    %ebx,(%eax)
	return 0;
  801249:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80124e:	89 d0                	mov    %edx,%eax
  801250:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	57                   	push   %edi
  80125b:	56                   	push   %esi
  80125c:	53                   	push   %ebx
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	8b 75 08             	mov    0x8(%ebp),%esi
  801263:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  80126c:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801271:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801277:	0f 87 bd 00 00 00    	ja     80133a <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  80127d:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801283:	73 17                	jae    80129c <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	52                   	push   %edx
  801289:	56                   	push   %esi
  80128a:	e8 fb 00 00 00       	call   80138a <file_trunc>
  80128f:	83 c4 10             	add    $0x10,%esp
			return r;
  801292:	89 c1                	mov    %eax,%ecx
  801294:	85 c0                	test   %eax,%eax
  801296:	0f 88 9e 00 00 00    	js     80133a <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  80129c:	83 ec 0c             	sub    $0xc,%esp
  80129f:	56                   	push   %esi
  8012a0:	e8 db f7 ff ff       	call   800a80 <fd2data>
  8012a5:	89 c3                	mov    %eax,%ebx
  8012a7:	01 fb                	add    %edi,%ebx
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	eb 42                	jmp    8012f0 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8012ae:	89 d8                	mov    %ebx,%eax
  8012b0:	c1 e8 16             	shr    $0x16,%eax
  8012b3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8012ba:	a8 01                	test   $0x1,%al
  8012bc:	74 10                	je     8012ce <file_write+0x77>
  8012be:	89 d8                	mov    %ebx,%eax
  8012c0:	c1 e8 0c             	shr    $0xc,%eax
  8012c3:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8012ca:	a8 01                	test   $0x1,%al
  8012cc:	75 1c                	jne    8012ea <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	8b 55 10             	mov    0x10(%ebp),%edx
  8012d4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  8012d7:	50                   	push   %eax
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	e8 30 01 00 00       	call   80140f <fmap>
  8012df:	83 c4 10             	add    $0x10,%esp
              return r;
  8012e2:	89 c1                	mov    %eax,%ecx
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 52                	js     80133a <file_write+0xe3>
  8012e8:	eb 1b                	jmp    801305 <file_write+0xae>
  8012ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012f0:	83 ec 0c             	sub    $0xc,%esp
  8012f3:	56                   	push   %esi
  8012f4:	e8 87 f7 ff ff       	call   800a80 <fd2data>
  8012f9:	01 f8                	add    %edi,%eax
  8012fb:	03 45 10             	add    0x10(%ebp),%eax
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	39 d8                	cmp    %ebx,%eax
  801303:	77 a9                	ja     8012ae <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	68 d6 2a 80 00       	push   $0x802ad6
  80130d:	e8 5e 0d 00 00       	call   802070 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801312:	83 c4 0c             	add    $0xc,%esp
  801315:	ff 75 10             	pushl  0x10(%ebp)
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	56                   	push   %esi
  80131c:	e8 5f f7 ff ff       	call   800a80 <fd2data>
  801321:	01 f8                	add    %edi,%eax
  801323:	89 04 24             	mov    %eax,(%esp)
  801326:	e8 a5 f1 ff ff       	call   8004d0 <memmove>
        cprintf("write done\n");
  80132b:	c7 04 24 e3 2a 80 00 	movl   $0x802ae3,(%esp)
  801332:	e8 39 0d 00 00       	call   802070 <cprintf>
	return n;
  801337:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  80133a:	89 c8                	mov    %ecx,%eax
  80133c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80133f:	5b                   	pop    %ebx
  801340:	5e                   	pop    %esi
  801341:	5f                   	pop    %edi
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
  801349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80134c:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  80134f:	83 ec 08             	sub    $0x8,%esp
  801352:	8d 43 10             	lea    0x10(%ebx),%eax
  801355:	50                   	push   %eax
  801356:	56                   	push   %esi
  801357:	e8 f8 ef ff ff       	call   800354 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  80135c:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801362:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801372:	0f 94 c0             	sete   %al
  801375:	0f b6 c0             	movzbl %al,%eax
  801378:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
  801383:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	57                   	push   %edi
  80138e:	56                   	push   %esi
  80138f:	53                   	push   %ebx
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	8b 75 08             	mov    0x8(%ebp),%esi
  801396:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801399:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80139e:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8013a4:	7f 5f                	jg     801405 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  8013a6:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	53                   	push   %ebx
  8013b0:	ff 76 0c             	pushl  0xc(%esi)
  8013b3:	e8 56 03 00 00       	call   80170e <fsipc_set_size>
  8013b8:	83 c4 10             	add    $0x10,%esp
		return r;
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 44                	js     801405 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  8013c1:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  8013c7:	74 19                	je     8013e2 <file_trunc+0x58>
  8013c9:	68 10 2b 80 00       	push   $0x802b10
  8013ce:	68 ef 2a 80 00       	push   $0x802aef
  8013d3:	68 dc 00 00 00       	push   $0xdc
  8013d8:	68 04 2b 80 00       	push   $0x802b04
  8013dd:	e8 9e 0b 00 00       	call   801f80 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	53                   	push   %ebx
  8013e6:	57                   	push   %edi
  8013e7:	56                   	push   %esi
  8013e8:	e8 22 00 00 00       	call   80140f <fmap>
  8013ed:	83 c4 10             	add    $0x10,%esp
		return r;
  8013f0:	89 c2                	mov    %eax,%edx
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 0f                	js     801405 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	53                   	push   %ebx
  8013f9:	57                   	push   %edi
  8013fa:	56                   	push   %esi
  8013fb:	e8 85 00 00 00       	call   801485 <funmap>

	return 0;
  801400:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801405:	89 d0                	mov    %edx,%eax
  801407:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80140a:	5b                   	pop    %ebx
  80140b:	5e                   	pop    %esi
  80140c:	5f                   	pop    %edi
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <fmap>:

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
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	57                   	push   %edi
  801413:	56                   	push   %esi
  801414:	53                   	push   %ebx
  801415:	83 ec 0c             	sub    $0xc,%esp
  801418:	8b 7d 08             	mov    0x8(%ebp),%edi
  80141b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  80141e:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801421:	7d 55                	jge    801478 <fmap+0x69>
          fma = fd2data(fd);
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	57                   	push   %edi
  801427:	e8 54 f6 ff ff       	call   800a80 <fd2data>
  80142c:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	8b 45 0c             	mov    0xc(%ebp),%eax
  801435:	05 ff 0f 00 00       	add    $0xfff,%eax
  80143a:	89 c3                	mov    %eax,%ebx
  80143c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801442:	39 f3                	cmp    %esi,%ebx
  801444:	7d 32                	jge    801478 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80144c:	01 d8                	add    %ebx,%eax
  80144e:	50                   	push   %eax
  80144f:	53                   	push   %ebx
  801450:	ff 77 0c             	pushl  0xc(%edi)
  801453:	e8 8b 02 00 00       	call   8016e3 <fsipc_map>
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	79 0f                	jns    80146e <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  80145f:	6a 00                	push   $0x0
  801461:	ff 75 0c             	pushl  0xc(%ebp)
  801464:	53                   	push   %ebx
  801465:	57                   	push   %edi
  801466:	e8 1a 00 00 00       	call   801485 <funmap>
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801474:	39 f3                	cmp    %esi,%ebx
  801476:	7c ce                	jl     801446 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801478:	b8 00 00 00 00       	mov    $0x0,%eax
  80147d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801480:	5b                   	pop    %ebx
  801481:	5e                   	pop    %esi
  801482:	5f                   	pop    %edi
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <funmap>:

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
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	57                   	push   %edi
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	83 ec 0c             	sub    $0xc,%esp
  80148e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801491:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801494:	39 f3                	cmp    %esi,%ebx
  801496:	0f 8d 80 00 00 00    	jge    80151c <funmap+0x97>
          fma = fd2data(fd);
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	ff 75 08             	pushl  0x8(%ebp)
  8014a2:	e8 d9 f5 ff ff       	call   800a80 <fd2data>
  8014a7:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8014b2:	89 c3                	mov    %eax,%ebx
  8014b4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8014ba:	39 f3                	cmp    %esi,%ebx
  8014bc:	7d 5e                	jge    80151c <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  8014be:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8014c1:	89 c2                	mov    %eax,%edx
  8014c3:	c1 ea 0c             	shr    $0xc,%edx
  8014c6:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8014cd:	a8 01                	test   $0x1,%al
  8014cf:	74 41                	je     801512 <funmap+0x8d>
              if (dirty) {
  8014d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8014d5:	74 21                	je     8014f8 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  8014d7:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8014de:	a8 40                	test   $0x40,%al
  8014e0:	74 16                	je     8014f8 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	53                   	push   %ebx
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	ff 70 0c             	pushl  0xc(%eax)
  8014ec:	e8 65 02 00 00       	call   801756 <fsipc_dirty>
  8014f1:	83 c4 10             	add    $0x10,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	78 29                	js     801521 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8014fe:	50                   	push   %eax
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	e8 e1 f1 ff ff       	call   8006e8 <sys_getenvid>
  801507:	89 04 24             	mov    %eax,(%esp)
  80150a:	e8 9c f2 ff ff       	call   8007ab <sys_page_unmap>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801518:	39 f3                	cmp    %esi,%ebx
  80151a:	7c a2                	jl     8014be <funmap+0x39>
            }
          }
        }

        return 0;
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801521:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801524:	5b                   	pop    %ebx
  801525:	5e                   	pop    %esi
  801526:	5f                   	pop    %edi
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <remove>:

// Delete a file
int
remove(const char *path)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 47 02 00 00       	call   80177e <fsipc_remove>
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  80153f:	e8 80 02 00 00       	call   8017c4 <fsipc_sync>
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    
	...

00801548 <writebuf>:


static void
writebuf(struct printbuf *b)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	53                   	push   %ebx
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (b->error > 0) {
  801552:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
  801556:	7e 2c                	jle    801584 <writebuf+0x3c>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	ff 73 04             	pushl  0x4(%ebx)
  80155e:	8d 43 10             	lea    0x10(%ebx),%eax
  801561:	50                   	push   %eax
  801562:	ff 33                	pushl  (%ebx)
  801564:	e8 03 f9 ff ff       	call   800e6c <write>
		if (result > 0)
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	85 c0                	test   %eax,%eax
  80156e:	7e 03                	jle    801573 <writebuf+0x2b>
			b->result += result;
  801570:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801573:	39 43 04             	cmp    %eax,0x4(%ebx)
  801576:	74 0c                	je     801584 <writebuf+0x3c>
			b->error = (result < 0 ? result : 0);
  801578:	85 c0                	test   %eax,%eax
  80157a:	7e 05                	jle    801581 <writebuf+0x39>
  80157c:	b8 00 00 00 00       	mov    $0x0,%eax
  801581:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801584:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <putch>:

static void
putch(int ch, void *thunk)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	53                   	push   %ebx
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801593:	8b 43 04             	mov    0x4(%ebx),%eax
  801596:	8b 55 08             	mov    0x8(%ebp),%edx
  801599:	88 54 18 10          	mov    %dl,0x10(%eax,%ebx,1)
  80159d:	40                   	inc    %eax
  80159e:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  8015a1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8015a6:	75 13                	jne    8015bb <putch+0x32>
		writebuf(b);
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	53                   	push   %ebx
  8015ac:	e8 97 ff ff ff       	call   801548 <writebuf>
		b->idx = 0;
  8015b1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  8015b8:	83 c4 10             	add    $0x10,%esp
	}
}
  8015bb:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	53                   	push   %ebx
  8015c4:	81 ec 14 01 00 00    	sub    $0x114,%esp
	struct printbuf b;

	b.fd = fd;
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	89 85 e8 fe ff ff    	mov    %eax,0xfffffee8(%ebp)
	b.idx = 0;
  8015d3:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  8015da:	00 00 00 
	b.result = 0;
  8015dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,0xfffffef0(%ebp)
  8015e4:	00 00 00 
	b.error = 1;
  8015e7:	c7 85 f4 fe ff ff 01 	movl   $0x1,0xfffffef4(%ebp)
  8015ee:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8015f1:	ff 75 10             	pushl  0x10(%ebp)
  8015f4:	ff 75 0c             	pushl  0xc(%ebp)
  8015f7:	8d 9d e8 fe ff ff    	lea    0xfffffee8(%ebp),%ebx
  8015fd:	53                   	push   %ebx
  8015fe:	68 89 15 80 00       	push   $0x801589
  801603:	e8 9a 0b 00 00       	call   8021a2 <vprintfmt>
	if (b.idx > 0)
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	83 bd ec fe ff ff 00 	cmpl   $0x0,0xfffffeec(%ebp)
  801612:	7e 0c                	jle    801620 <vfprintf+0x60>
		writebuf(&b);
  801614:	83 ec 0c             	sub    $0xc,%esp
  801617:	53                   	push   %ebx
  801618:	e8 2b ff ff ff       	call   801548 <writebuf>
  80161d:	83 c4 10             	add    $0x10,%esp

	return (b.result ? b.result : b.error);
  801620:	8b 85 f0 fe ff ff    	mov    0xfffffef0(%ebp),%eax
  801626:	85 c0                	test   %eax,%eax
  801628:	75 06                	jne    801630 <vfprintf+0x70>
  80162a:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
}
  801630:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80163b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80163e:	50                   	push   %eax
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	e8 76 ff ff ff       	call   8015c0 <vfprintf>
	va_end(ap);

	return cnt;
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <printf>:

int
printf(const char *fmt, ...)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801652:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801655:	50                   	push   %eax
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	6a 01                	push   $0x1
  80165b:	e8 60 ff ff ff       	call   8015c0 <vfprintf>
	va_end(ap);

	return cnt;
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    
	...

00801664 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80166a:	6a 07                	push   $0x7
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801677:	50                   	push   %eax
  801678:	e8 1e 0f 00 00       	call   80259b <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  80167d:	83 c4 0c             	add    $0xc,%esp
  801680:	ff 75 14             	pushl  0x14(%ebp)
  801683:	ff 75 10             	pushl  0x10(%ebp)
  801686:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801689:	50                   	push   %eax
  80168a:	e8 a9 0e 00 00       	call   802538 <ipc_recv>
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	83 ec 1c             	sub    $0x1c,%esp
  801699:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  80169c:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  8016a1:	56                   	push   %esi
  8016a2:	e8 71 ec ff ff       	call   800318 <strlen>
  8016a7:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8016aa:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8016af:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016b4:	7f 24                	jg     8016da <fsipc_open+0x49>
	strcpy(req->req_path, path);
  8016b6:	83 ec 08             	sub    $0x8,%esp
  8016b9:	56                   	push   %esi
  8016ba:	53                   	push   %ebx
  8016bb:	e8 94 ec ff ff       	call   800354 <strcpy>
	req->req_omode = omode;
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8016c9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016cc:	50                   	push   %eax
  8016cd:	ff 75 10             	pushl  0x10(%ebp)
  8016d0:	53                   	push   %ebx
  8016d1:	6a 01                	push   $0x1
  8016d3:	e8 8c ff ff ff       	call   801664 <fsipc>
  8016d8:	89 c2                	mov    %eax,%edx
}
  8016da:	89 d0                	mov    %edx,%eax
  8016dc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  8016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f4:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  8016f9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8016fc:	50                   	push   %eax
  8016fd:	ff 75 10             	pushl  0x10(%ebp)
  801700:	68 00 30 80 00       	push   $0x803000
  801705:	6a 02                	push   $0x2
  801707:	e8 58 ff ff ff       	call   801664 <fsipc>

	//return -E_UNSPECIFIED;
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	68 00 30 80 00       	push   $0x803000
  80172d:	6a 03                	push   $0x3
  80172f:	e8 30 ff ff ff       	call   801664 <fsipc>
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	68 00 30 80 00       	push   $0x803000
  80174d:	6a 04                	push   $0x4
  80174f:	e8 10 ff ff ff       	call   801664 <fsipc>
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	68 00 30 80 00       	push   $0x803000
  801775:	6a 05                	push   $0x5
  801777:	e8 e8 fe ff ff       	call   801664 <fsipc>
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	56                   	push   %esi
  801782:	53                   	push   %ebx
  801783:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801786:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  80178b:	83 ec 0c             	sub    $0xc,%esp
  80178e:	53                   	push   %ebx
  80178f:	e8 84 eb ff ff       	call   800318 <strlen>
  801794:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801797:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80179c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017a1:	7f 18                	jg     8017bb <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  8017a3:	83 ec 08             	sub    $0x8,%esp
  8017a6:	53                   	push   %ebx
  8017a7:	56                   	push   %esi
  8017a8:	e8 a7 eb ff ff       	call   800354 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	56                   	push   %esi
  8017b2:	6a 06                	push   $0x6
  8017b4:	e8 ab fe ff ff       	call   801664 <fsipc>
  8017b9:	89 c2                	mov    %eax,%edx
}
  8017bb:	89 d0                	mov    %edx,%eax
  8017bd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8017c0:	5b                   	pop    %ebx
  8017c1:	5e                   	pop    %esi
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	68 00 30 80 00       	push   $0x803000
  8017d3:	6a 07                	push   $0x7
  8017d5:	e8 8a fe ff ff       	call   801664 <fsipc>
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <isfree>:
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
	uintptr_t va, end_va = (uintptr_t) v + n;
  8017e4:	89 c1                	mov    %eax,%ecx
  8017e6:	03 4d 0c             	add    0xc(%ebp),%ecx

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8017e9:	89 c2                	mov    %eax,%edx
  8017eb:	39 c8                	cmp    %ecx,%eax
  8017ed:	73 3b                	jae    80182a <isfree+0x4e>
  8017ef:	bb 00 d0 7b ef       	mov    $0xef7bd000,%ebx
  8017f4:	be 00 00 40 ef       	mov    $0xef400000,%esi
		if (va >= (uintptr_t) mend
  8017f9:	39 15 44 60 80 00    	cmp    %edx,0x806044
  8017ff:	76 18                	jbe    801819 <isfree+0x3d>
  801801:	89 d0                	mov    %edx,%eax
  801803:	c1 e8 16             	shr    $0x16,%eax
  801806:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801809:	a8 01                	test   $0x1,%al
  80180b:	74 13                	je     801820 <isfree+0x44>
  80180d:	89 d0                	mov    %edx,%eax
  80180f:	c1 e8 0c             	shr    $0xc,%eax
  801812:	8b 04 86             	mov    (%esi,%eax,4),%eax
  801815:	a8 01                	test   $0x1,%al
  801817:	74 07                	je     801820 <isfree+0x44>
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P)))
			return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
  80181e:	eb 0f                	jmp    80182f <isfree+0x53>
  801820:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801826:	39 ca                	cmp    %ecx,%edx
  801828:	72 cf                	jb     8017f9 <isfree+0x1d>
	return 1;
  80182a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <malloc>:

void*
malloc(size_t n)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	57                   	push   %edi
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	83 ec 0c             	sub    $0xc,%esp
  80183c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  80183f:	83 3d a0 64 80 00 00 	cmpl   $0x0,0x8064a0
  801846:	75 0a                	jne    801852 <malloc+0x1f>
		mptr = mbegin;
  801848:	a1 40 60 80 00       	mov    0x806040,%eax
  80184d:	a3 a0 64 80 00       	mov    %eax,0x8064a0

	n = ROUNDUP(n, 4);
  801852:	8d 43 03             	lea    0x3(%ebx),%eax
  801855:	89 c3                	mov    %eax,%ebx
  801857:	83 e3 fc             	and    $0xfffffffc,%ebx

	if (n >= MAXMALLOC)
		return 0;
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
  80185f:	81 fb ff ff 0f 00    	cmp    $0xfffff,%ebx
  801865:	0f 87 46 01 00 00    	ja     8019b1 <malloc+0x17e>

	if ((uintptr_t) mptr % PGSIZE){
  80186b:	8b 0d a0 64 80 00    	mov    0x8064a0,%ecx
  801871:	f7 c1 ff 0f 00 00    	test   $0xfff,%ecx
  801877:	74 5b                	je     8018d4 <malloc+0xa1>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  801879:	8d 81 ff 0f 00 00    	lea    0xfff(%ecx),%eax
  80187f:	89 c6                	mov    %eax,%esi
  801881:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  801887:	89 ca                	mov    %ecx,%edx
  801889:	c1 ea 0c             	shr    $0xc,%edx
  80188c:	8d 44 0b 03          	lea    0x3(%ebx,%ecx,1),%eax
  801890:	c1 e8 0c             	shr    $0xc,%eax
  801893:	39 c2                	cmp    %eax,%edx
  801895:	75 18                	jne    8018af <malloc+0x7c>
			(*ref)++;
  801897:	ff 46 fc             	incl   0xfffffffc(%esi)
			v = mptr;
  80189a:	8b 15 a0 64 80 00    	mov    0x8064a0,%edx
			mptr += n;
  8018a0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8018a3:	a3 a0 64 80 00       	mov    %eax,0x8064a0
			return v;
  8018a8:	89 d0                	mov    %edx,%eax
  8018aa:	e9 02 01 00 00       	jmp    8019b1 <malloc+0x17e>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  8018af:	83 ec 0c             	sub    $0xc,%esp
  8018b2:	ff 35 a0 64 80 00    	pushl  0x8064a0
  8018b8:	e8 fc 00 00 00       	call   8019b9 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	a1 a0 64 80 00       	mov    0x8064a0,%eax
  8018c5:	05 00 10 00 00       	add    $0x1000,%eax
  8018ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018cf:	a3 a0 64 80 00       	mov    %eax,0x8064a0
	}

	/*
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we 
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  8018d4:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		if (isfree(mptr, n + 4))
  8018d9:	8d 43 04             	lea    0x4(%ebx),%eax
  8018dc:	50                   	push   %eax
  8018dd:	ff 35 a0 64 80 00    	pushl  0x8064a0
  8018e3:	e8 f4 fe ff ff       	call   8017dc <isfree>
  8018e8:	83 c4 08             	add    $0x8,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	75 31                	jne    801920 <malloc+0xed>
			break;
		mptr += PGSIZE;
  8018ef:	a1 a0 64 80 00       	mov    0x8064a0,%eax
  8018f4:	05 00 10 00 00       	add    $0x1000,%eax
  8018f9:	a3 a0 64 80 00       	mov    %eax,0x8064a0
		if (mptr == mend) {
  8018fe:	3b 05 44 60 80 00    	cmp    0x806044,%eax
  801904:	75 d3                	jne    8018d9 <malloc+0xa6>
			mptr = mbegin;
  801906:	a1 40 60 80 00       	mov    0x806040,%eax
  80190b:	a3 a0 64 80 00       	mov    %eax,0x8064a0
			if (++nwrap == 2)
  801910:	46                   	inc    %esi
  801911:	83 fe 02             	cmp    $0x2,%esi
  801914:	75 c3                	jne    8018d9 <malloc+0xa6>
				return 0;	/* out of address space */
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	e9 91 00 00 00       	jmp    8019b1 <malloc+0x17e>
		}
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  801920:	be 00 00 00 00       	mov    $0x0,%esi
  801925:	8d 43 04             	lea    0x4(%ebx),%eax
  801928:	89 c2                	mov    %eax,%edx
  80192a:	39 c6                	cmp    %eax,%esi
  80192c:	73 64                	jae    801992 <malloc+0x15f>
  80192e:	89 c7                	mov    %eax,%edi
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  801930:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
  801936:	39 d0                	cmp    %edx,%eax
  801938:	19 c0                	sbb    %eax,%eax
  80193a:	25 00 04 00 00       	and    $0x400,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	83 c8 07             	or     $0x7,%eax
  801945:	50                   	push   %eax
  801946:	89 f0                	mov    %esi,%eax
  801948:	03 05 a0 64 80 00    	add    0x8064a0,%eax
  80194e:	50                   	push   %eax
  80194f:	6a 00                	push   $0x0
  801951:	e8 d0 ed ff ff       	call   800726 <sys_page_alloc>
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	79 29                	jns    801986 <malloc+0x153>
			for (; i >= 0; i -= PGSIZE)
  80195d:	85 f6                	test   %esi,%esi
  80195f:	78 1e                	js     80197f <malloc+0x14c>
				sys_page_unmap(0, mptr + i);
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	89 f0                	mov    %esi,%eax
  801966:	03 05 a0 64 80 00    	add    0x8064a0,%eax
  80196c:	50                   	push   %eax
  80196d:	6a 00                	push   $0x0
  80196f:	e8 37 ee ff ff       	call   8007ab <sys_page_unmap>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  80197d:	79 e2                	jns    801961 <malloc+0x12e>
			return 0;	/* out of physical memory */
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
  801984:	eb 2b                	jmp    8019b1 <malloc+0x17e>
  801986:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80198c:	89 fa                	mov    %edi,%edx
  80198e:	39 fe                	cmp    %edi,%esi
  801990:	72 9e                	jb     801930 <malloc+0xfd>
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  801992:	89 f0                	mov    %esi,%eax
  801994:	03 05 a0 64 80 00    	add    0x8064a0,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  80199a:	c7 40 fc 02 00 00 00 	movl   $0x2,0xfffffffc(%eax)
	v = mptr;
  8019a1:	8b 15 a0 64 80 00    	mov    0x8064a0,%edx
	mptr += n;
  8019a7:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8019aa:	a3 a0 64 80 00       	mov    %eax,0x8064a0
	return v;
  8019af:	89 d0                	mov    %edx,%eax
}
  8019b1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5f                   	pop    %edi
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <free>:

void
free(void *v)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	53                   	push   %ebx
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	0f 84 aa 00 00 00    	je     801a75 <free+0xbc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8019cb:	39 05 40 60 80 00    	cmp    %eax,0x806040
  8019d1:	77 08                	ja     8019db <free+0x22>
  8019d3:	3b 05 44 60 80 00    	cmp    0x806044,%eax
  8019d9:	72 16                	jb     8019f1 <free+0x38>
  8019db:	68 34 2b 80 00       	push   $0x802b34
  8019e0:	68 ef 2a 80 00       	push   $0x802aef
  8019e5:	6a 7a                	push   $0x7a
  8019e7:	68 62 2b 80 00       	push   $0x802b62
  8019ec:	e8 8f 05 00 00       	call   801f80 <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  8019f1:	89 c3                	mov    %eax,%ebx
  8019f3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (vpt[VPN(c)] & PTE_CONTINUED) {
		sys_page_unmap(0, c);
		c += PGSIZE;
		assert(mbegin <= c && c < mend);
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	c1 e8 0c             	shr    $0xc,%eax
  8019fe:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a05:	f6 c4 04             	test   $0x4,%ah
  801a08:	74 4e                	je     801a58 <free+0x9f>
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	53                   	push   %ebx
  801a0e:	6a 00                	push   $0x0
  801a10:	e8 96 ed ff ff       	call   8007ab <sys_page_unmap>
  801a15:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	39 1d 40 60 80 00    	cmp    %ebx,0x806040
  801a24:	77 08                	ja     801a2e <free+0x75>
  801a26:	3b 1d 44 60 80 00    	cmp    0x806044,%ebx
  801a2c:	72 19                	jb     801a47 <free+0x8e>
  801a2e:	68 6f 2b 80 00       	push   $0x802b6f
  801a33:	68 ef 2a 80 00       	push   $0x802aef
  801a38:	68 81 00 00 00       	push   $0x81
  801a3d:	68 62 2b 80 00       	push   $0x802b62
  801a42:	e8 39 05 00 00       	call   801f80 <_panic>
  801a47:	89 d8                	mov    %ebx,%eax
  801a49:	c1 e8 0c             	shr    $0xc,%eax
  801a4c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a53:	f6 c4 04             	test   $0x4,%ah
  801a56:	75 b2                	jne    801a0a <free+0x51>
	}

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  801a58:	ff 8b fc 0f 00 00    	decl   0xffc(%ebx)
  801a5e:	83 bb fc 0f 00 00 00 	cmpl   $0x0,0xffc(%ebx)
  801a65:	75 0e                	jne    801a75 <free+0xbc>
		sys_page_unmap(0, c);	
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	53                   	push   %ebx
  801a6b:	6a 00                	push   $0x0
  801a6d:	e8 39 ed ff ff       	call   8007ab <sys_page_unmap>
  801a72:	83 c4 10             	add    $0x10,%esp
}
  801a75:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    
	...

00801a7c <pipe>:
};

int
pipe(int pfd[2])
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	57                   	push   %edi
  801a80:	56                   	push   %esi
  801a81:	53                   	push   %ebx
  801a82:	83 ec 18             	sub    $0x18,%esp
  801a85:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801a88:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801a8b:	50                   	push   %eax
  801a8c:	e8 17 f0 ff ff       	call   800aa8 <fd_alloc>
  801a91:	89 c3                	mov    %eax,%ebx
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	0f 88 25 01 00 00    	js     801bc3 <pipe+0x147>
  801a9e:	83 ec 04             	sub    $0x4,%esp
  801aa1:	68 07 04 00 00       	push   $0x407
  801aa6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801aa9:	6a 00                	push   $0x0
  801aab:	e8 76 ec ff ff       	call   800726 <sys_page_alloc>
  801ab0:	89 c3                	mov    %eax,%ebx
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	0f 88 06 01 00 00    	js     801bc3 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801abd:	83 ec 0c             	sub    $0xc,%esp
  801ac0:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801ac3:	50                   	push   %eax
  801ac4:	e8 df ef ff ff       	call   800aa8 <fd_alloc>
  801ac9:	89 c3                	mov    %eax,%ebx
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	0f 88 dd 00 00 00    	js     801bb3 <pipe+0x137>
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	68 07 04 00 00       	push   $0x407
  801ade:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801ae1:	6a 00                	push   $0x0
  801ae3:	e8 3e ec ff ff       	call   800726 <sys_page_alloc>
  801ae8:	89 c3                	mov    %eax,%ebx
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	0f 88 be 00 00 00    	js     801bb3 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801afb:	e8 80 ef ff ff       	call   800a80 <fd2data>
  801b00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b02:	83 c4 0c             	add    $0xc,%esp
  801b05:	68 07 04 00 00       	push   $0x407
  801b0a:	50                   	push   %eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	e8 14 ec ff ff       	call   800726 <sys_page_alloc>
  801b12:	89 c3                	mov    %eax,%ebx
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	85 c0                	test   %eax,%eax
  801b19:	0f 88 84 00 00 00    	js     801ba3 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	68 07 04 00 00       	push   $0x407
  801b27:	83 ec 0c             	sub    $0xc,%esp
  801b2a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801b2d:	e8 4e ef ff ff       	call   800a80 <fd2data>
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	50                   	push   %eax
  801b36:	6a 00                	push   $0x0
  801b38:	56                   	push   %esi
  801b39:	6a 00                	push   $0x0
  801b3b:	e8 29 ec ff ff       	call   800769 <sys_page_map>
  801b40:	89 c3                	mov    %eax,%ebx
  801b42:	83 c4 20             	add    $0x20,%esp
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 4c                	js     801b95 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b49:	8b 15 60 60 80 00    	mov    0x806060,%edx
  801b4f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801b52:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b54:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801b57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801b5e:	8b 15 60 60 80 00    	mov    0x806060,%edx
  801b64:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801b67:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b69:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801b6c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801b79:	e8 1a ef ff ff       	call   800a98 <fd2num>
  801b7e:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801b80:	83 c4 04             	add    $0x4,%esp
  801b83:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801b86:	e8 0d ef ff ff       	call   800a98 <fd2num>
  801b8b:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	eb 30                	jmp    801bc5 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	56                   	push   %esi
  801b99:	6a 00                	push   $0x0
  801b9b:	e8 0b ec ff ff       	call   8007ab <sys_page_unmap>
  801ba0:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801ba3:	83 ec 08             	sub    $0x8,%esp
  801ba6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801ba9:	6a 00                	push   $0x0
  801bab:	e8 fb eb ff ff       	call   8007ab <sys_page_unmap>
  801bb0:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801bb3:	83 ec 08             	sub    $0x8,%esp
  801bb6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801bb9:	6a 00                	push   $0x0
  801bbb:	e8 eb eb ff ff       	call   8007ab <sys_page_unmap>
  801bc0:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  801bc3:	89 d8                	mov    %ebx,%eax
}
  801bc5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5f                   	pop    %edi
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	57                   	push   %edi
  801bd1:	56                   	push   %esi
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 0c             	sub    $0xc,%esp
  801bd6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801bd9:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  801bde:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801be1:	83 ec 0c             	sub    $0xc,%esp
  801be4:	ff 75 08             	pushl  0x8(%ebp)
  801be7:	e8 08 0a 00 00       	call   8025f4 <pageref>
  801bec:	89 c3                	mov    %eax,%ebx
  801bee:	89 3c 24             	mov    %edi,(%esp)
  801bf1:	e8 fe 09 00 00       	call   8025f4 <pageref>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	39 c3                	cmp    %eax,%ebx
  801bfb:	0f 94 c0             	sete   %al
  801bfe:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801c01:	8b 0d a4 64 80 00    	mov    0x8064a4,%ecx
  801c07:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  801c0a:	39 c6                	cmp    %eax,%esi
  801c0c:	74 1b                	je     801c29 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  801c0e:	83 fa 01             	cmp    $0x1,%edx
  801c11:	75 c6                	jne    801bd9 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801c13:	6a 01                	push   $0x1
  801c15:	8b 41 58             	mov    0x58(%ecx),%eax
  801c18:	50                   	push   %eax
  801c19:	56                   	push   %esi
  801c1a:	68 8c 2b 80 00       	push   $0x802b8c
  801c1f:	e8 4c 04 00 00       	call   802070 <cprintf>
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	eb b0                	jmp    801bd9 <_pipeisclosed+0xc>
	}
}
  801c29:	89 d0                	mov    %edx,%eax
  801c2b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5f                   	pop    %edi
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c39:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801c3c:	50                   	push   %eax
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	e8 bd ee ff ff       	call   800b02 <fd_lookup>
  801c45:	83 c4 10             	add    $0x10,%esp
		return r;
  801c48:	89 c2                	mov    %eax,%edx
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	78 19                	js     801c67 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801c54:	e8 27 ee ff ff       	call   800a80 <fd2data>
	return _pipeisclosed(fd, p);
  801c59:	83 c4 08             	add    $0x8,%esp
  801c5c:	50                   	push   %eax
  801c5d:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801c60:	e8 68 ff ff ff       	call   801bcd <_pipeisclosed>
  801c65:	89 c2                	mov    %eax,%edx
}
  801c67:	89 d0                	mov    %edx,%eax
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	57                   	push   %edi
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	83 ec 18             	sub    $0x18,%esp
  801c74:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  801c77:	57                   	push   %edi
  801c78:	e8 03 ee ff ff       	call   800a80 <fd2data>
  801c7d:	89 c3                	mov    %eax,%ebx
	if (debug)
  801c7f:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801c88:	be 00 00 00 00       	mov    $0x0,%esi
  801c8d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c90:	73 55                	jae    801ce7 <piperead+0x7c>
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
  801c92:	8b 03                	mov    (%ebx),%eax
  801c94:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c97:	75 2c                	jne    801cc5 <piperead+0x5a>
  801c99:	85 f6                	test   %esi,%esi
  801c9b:	74 04                	je     801ca1 <piperead+0x36>
  801c9d:	89 f0                	mov    %esi,%eax
  801c9f:	eb 48                	jmp    801ce9 <piperead+0x7e>
  801ca1:	83 ec 08             	sub    $0x8,%esp
  801ca4:	53                   	push   %ebx
  801ca5:	57                   	push   %edi
  801ca6:	e8 22 ff ff ff       	call   801bcd <_pipeisclosed>
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	74 07                	je     801cb9 <piperead+0x4e>
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb7:	eb 30                	jmp    801ce9 <piperead+0x7e>
  801cb9:	e8 49 ea ff ff       	call   800707 <sys_yield>
  801cbe:	8b 03                	mov    (%ebx),%eax
  801cc0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cc3:	74 d4                	je     801c99 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cc5:	8b 13                	mov    (%ebx),%edx
  801cc7:	89 d0                	mov    %edx,%eax
  801cc9:	85 d2                	test   %edx,%edx
  801ccb:	79 03                	jns    801cd0 <piperead+0x65>
  801ccd:	8d 42 1f             	lea    0x1f(%edx),%eax
  801cd0:	83 e0 e0             	and    $0xffffffe0,%eax
  801cd3:	29 c2                	sub    %eax,%edx
  801cd5:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801cd9:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801cdc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801cdf:	ff 03                	incl   (%ebx)
  801ce1:	46                   	inc    %esi
  801ce2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ce5:	72 ab                	jb     801c92 <piperead+0x27>
	}
	return i;
  801ce7:	89 f0                	mov    %esi,%eax
}
  801ce9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801cec:	5b                   	pop    %ebx
  801ced:	5e                   	pop    %esi
  801cee:	5f                   	pop    %edi
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	57                   	push   %edi
  801cf5:	56                   	push   %esi
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 18             	sub    $0x18,%esp
  801cfa:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  801cfd:	57                   	push   %edi
  801cfe:	e8 7d ed ff ff       	call   800a80 <fd2data>
  801d03:	89 c3                	mov    %eax,%ebx
	if (debug)
  801d05:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801d0e:	be 00 00 00 00       	mov    $0x0,%esi
  801d13:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d16:	73 55                	jae    801d6d <pipewrite+0x7c>
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
  801d18:	8b 03                	mov    (%ebx),%eax
  801d1a:	83 c0 20             	add    $0x20,%eax
  801d1d:	39 43 04             	cmp    %eax,0x4(%ebx)
  801d20:	72 27                	jb     801d49 <pipewrite+0x58>
  801d22:	83 ec 08             	sub    $0x8,%esp
  801d25:	53                   	push   %ebx
  801d26:	57                   	push   %edi
  801d27:	e8 a1 fe ff ff       	call   801bcd <_pipeisclosed>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	74 07                	je     801d3a <pipewrite+0x49>
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
  801d38:	eb 35                	jmp    801d6f <pipewrite+0x7e>
  801d3a:	e8 c8 e9 ff ff       	call   800707 <sys_yield>
  801d3f:	8b 03                	mov    (%ebx),%eax
  801d41:	83 c0 20             	add    $0x20,%eax
  801d44:	39 43 04             	cmp    %eax,0x4(%ebx)
  801d47:	73 d9                	jae    801d22 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d49:	8b 53 04             	mov    0x4(%ebx),%edx
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	85 d2                	test   %edx,%edx
  801d50:	79 03                	jns    801d55 <pipewrite+0x64>
  801d52:	8d 42 1f             	lea    0x1f(%edx),%eax
  801d55:	83 e0 e0             	and    $0xffffffe0,%eax
  801d58:	29 c2                	sub    %eax,%edx
  801d5a:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  801d5d:	8a 04 31             	mov    (%ecx,%esi,1),%al
  801d60:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d64:	ff 43 04             	incl   0x4(%ebx)
  801d67:	46                   	inc    %esi
  801d68:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d6b:	72 ab                	jb     801d18 <pipewrite+0x27>
	}
	
	return i;
  801d6d:	89 f0                	mov    %esi,%eax
}
  801d6f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d72:	5b                   	pop    %ebx
  801d73:	5e                   	pop    %esi
  801d74:	5f                   	pop    %edi
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d7f:	83 ec 0c             	sub    $0xc,%esp
  801d82:	ff 75 08             	pushl  0x8(%ebp)
  801d85:	e8 f6 ec ff ff       	call   800a80 <fd2data>
  801d8a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d8c:	83 c4 08             	add    $0x8,%esp
  801d8f:	68 9f 2b 80 00       	push   $0x802b9f
  801d94:	53                   	push   %ebx
  801d95:	e8 ba e5 ff ff       	call   800354 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d9a:	8b 46 04             	mov    0x4(%esi),%eax
  801d9d:	2b 06                	sub    (%esi),%eax
  801d9f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801da5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dac:	00 00 00 
	stat->st_dev = &devpipe;
  801daf:	c7 83 88 00 00 00 60 	movl   $0x806060,0x88(%ebx)
  801db6:	60 80 00 
	return 0;
}
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801dc1:	5b                   	pop    %ebx
  801dc2:	5e                   	pop    %esi
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	53                   	push   %ebx
  801dc9:	83 ec 0c             	sub    $0xc,%esp
  801dcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dcf:	53                   	push   %ebx
  801dd0:	6a 00                	push   $0x0
  801dd2:	e8 d4 e9 ff ff       	call   8007ab <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dd7:	89 1c 24             	mov    %ebx,(%esp)
  801dda:	e8 a1 ec ff ff       	call   800a80 <fd2data>
  801ddf:	83 c4 08             	add    $0x8,%esp
  801de2:	50                   	push   %eax
  801de3:	6a 00                	push   $0x0
  801de5:	e8 c1 e9 ff ff       	call   8007ab <sys_page_unmap>
}
  801dea:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    
	...

00801df0 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801dfc:	6a 01                	push   $0x1
  801dfe:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801e01:	50                   	push   %eax
  801e02:	e8 5d e8 ff ff       	call   800664 <sys_cputs>
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <getchar>:

int
getchar(void)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e0f:	6a 01                	push   $0x1
  801e11:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801e14:	50                   	push   %eax
  801e15:	6a 00                	push   $0x0
  801e17:	e8 79 ef ff ff       	call   800d95 <read>
	if (r < 0)
  801e1c:	83 c4 10             	add    $0x10,%esp
		return r;
  801e1f:	89 c2                	mov    %eax,%edx
  801e21:	85 c0                	test   %eax,%eax
  801e23:	78 0d                	js     801e32 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  801e25:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	7e 04                	jle    801e32 <getchar+0x29>
	return c;
  801e2e:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  801e32:	89 d0                	mov    %edx,%eax
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <iscons>:


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
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e3c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	e8 ba ec ff ff       	call   800b02 <fd_lookup>
  801e48:	83 c4 10             	add    $0x10,%esp
		return r;
  801e4b:	89 c2                	mov    %eax,%edx
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	78 11                	js     801e62 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  801e51:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801e54:	8b 00                	mov    (%eax),%eax
  801e56:	3b 05 80 60 80 00    	cmp    0x806080,%eax
  801e5c:	0f 94 c0             	sete   %al
  801e5f:	0f b6 d0             	movzbl %al,%edx
}
  801e62:	89 d0                	mov    %edx,%eax
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <opencons>:

int
opencons(void)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e6c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e6f:	50                   	push   %eax
  801e70:	e8 33 ec ff ff       	call   800aa8 <fd_alloc>
  801e75:	83 c4 10             	add    $0x10,%esp
		return r;
  801e78:	89 c2                	mov    %eax,%edx
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 3c                	js     801eba <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 07 04 00 00       	push   $0x407
  801e86:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801e89:	6a 00                	push   $0x0
  801e8b:	e8 96 e8 ff ff       	call   800726 <sys_page_alloc>
  801e90:	83 c4 10             	add    $0x10,%esp
		return r;
  801e93:	89 c2                	mov    %eax,%edx
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 21                	js     801eba <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801e99:	a1 80 60 80 00       	mov    0x806080,%eax
  801e9e:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  801ea1:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  801ea3:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801ea6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801eb3:	e8 e0 eb ff ff       	call   800a98 <fd2num>
  801eb8:	89 c2                	mov    %eax,%edx
}
  801eba:	89 d0                	mov    %edx,%eax
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ecd:	74 2a                	je     801ef9 <cons_read+0x3b>
  801ecf:	eb 05                	jmp    801ed6 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801ed1:	e8 31 e8 ff ff       	call   800707 <sys_yield>
  801ed6:	e8 ad e7 ff ff       	call   800688 <sys_cgetc>
  801edb:	89 c2                	mov    %eax,%edx
  801edd:	85 c0                	test   %eax,%eax
  801edf:	74 f0                	je     801ed1 <cons_read+0x13>
	if (c < 0)
  801ee1:	85 d2                	test   %edx,%edx
  801ee3:	78 14                	js     801ef9 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	83 fa 04             	cmp    $0x4,%edx
  801eed:	74 0a                	je     801ef9 <cons_read+0x3b>
	*(char*)vbuf = c;
  801eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef2:	88 10                	mov    %dl,(%eax)
	return 1;
  801ef4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	57                   	push   %edi
  801eff:	56                   	push   %esi
  801f00:	53                   	push   %ebx
  801f01:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  801f07:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f0a:	be 00 00 00 00       	mov    $0x0,%esi
  801f0f:	39 fe                	cmp    %edi,%esi
  801f11:	73 3d                	jae    801f50 <cons_write+0x55>
		m = n - tot;
  801f13:	89 fb                	mov    %edi,%ebx
  801f15:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801f17:	83 fb 7f             	cmp    $0x7f,%ebx
  801f1a:	76 05                	jbe    801f21 <cons_write+0x26>
			m = sizeof(buf) - 1;
  801f1c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f21:	83 ec 04             	sub    $0x4,%esp
  801f24:	53                   	push   %ebx
  801f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f28:	01 f0                	add    %esi,%eax
  801f2a:	50                   	push   %eax
  801f2b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  801f31:	50                   	push   %eax
  801f32:	e8 99 e5 ff ff       	call   8004d0 <memmove>
		sys_cputs(buf, m);
  801f37:	83 c4 08             	add    $0x8,%esp
  801f3a:	53                   	push   %ebx
  801f3b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  801f41:	50                   	push   %eax
  801f42:	e8 1d e7 ff ff       	call   800664 <sys_cputs>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	01 de                	add    %ebx,%esi
  801f4c:	39 fe                	cmp    %edi,%esi
  801f4e:	72 c3                	jb     801f13 <cons_write+0x18>
	}
	return tot;
}
  801f50:	89 f0                	mov    %esi,%eax
  801f52:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5f                   	pop    %edi
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <cons_close>:

int
cons_close(struct Fd *fd)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f6a:	68 ab 2b 80 00       	push   $0x802bab
  801f6f:	ff 75 0c             	pushl  0xc(%ebp)
  801f72:	e8 dd e3 ff ff       	call   800354 <strcpy>
	return 0;
}
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    
	...

00801f80 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	53                   	push   %ebx
  801f84:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  801f87:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  801f8a:	83 3d a8 64 80 00 00 	cmpl   $0x0,0x8064a8
  801f91:	74 16                	je     801fa9 <_panic+0x29>
		cprintf("%s: ", argv0);
  801f93:	83 ec 08             	sub    $0x8,%esp
  801f96:	ff 35 a8 64 80 00    	pushl  0x8064a8
  801f9c:	68 b2 2b 80 00       	push   $0x802bb2
  801fa1:	e8 ca 00 00 00       	call   802070 <cprintf>
  801fa6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	ff 75 08             	pushl  0x8(%ebp)
  801faf:	ff 35 00 60 80 00    	pushl  0x806000
  801fb5:	68 b7 2b 80 00       	push   $0x802bb7
  801fba:	e8 b1 00 00 00       	call   802070 <cprintf>
	vcprintf(fmt, ap);
  801fbf:	83 c4 08             	add    $0x8,%esp
  801fc2:	53                   	push   %ebx
  801fc3:	ff 75 10             	pushl  0x10(%ebp)
  801fc6:	e8 54 00 00 00       	call   80201f <vcprintf>
	cprintf("\n");
  801fcb:	c7 04 24 9d 2b 80 00 	movl   $0x802b9d,(%esp)
  801fd2:	e8 99 00 00 00       	call   802070 <cprintf>

	// Cause a breakpoint exception
	while (1)
  801fd7:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  801fda:	cc                   	int3   
  801fdb:	eb fd                	jmp    801fda <_panic+0x5a>
  801fdd:	00 00                	add    %al,(%eax)
	...

00801fe0 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	53                   	push   %ebx
  801fe4:	83 ec 04             	sub    $0x4,%esp
  801fe7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801fea:	8b 03                	mov    (%ebx),%eax
  801fec:	8b 55 08             	mov    0x8(%ebp),%edx
  801fef:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  801ff3:	40                   	inc    %eax
  801ff4:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801ff6:	3d ff 00 00 00       	cmp    $0xff,%eax
  801ffb:	75 1a                	jne    802017 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  801ffd:	83 ec 08             	sub    $0x8,%esp
  802000:	68 ff 00 00 00       	push   $0xff
  802005:	8d 43 08             	lea    0x8(%ebx),%eax
  802008:	50                   	push   %eax
  802009:	e8 56 e6 ff ff       	call   800664 <sys_cputs>
		b->idx = 0;
  80200e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802014:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  802017:	ff 43 04             	incl   0x4(%ebx)
}
  80201a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  802028:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80202f:	00 00 00 
	b.cnt = 0;
  802032:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  802039:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80203c:	ff 75 0c             	pushl  0xc(%ebp)
  80203f:	ff 75 08             	pushl  0x8(%ebp)
  802042:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  802048:	50                   	push   %eax
  802049:	68 e0 1f 80 00       	push   $0x801fe0
  80204e:	e8 4f 01 00 00       	call   8021a2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  802053:	83 c4 08             	add    $0x8,%esp
  802056:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  80205c:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  802062:	50                   	push   %eax
  802063:	e8 fc e5 ff ff       	call   800664 <sys_cputs>

	return b.cnt;
  802068:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802076:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  802079:	50                   	push   %eax
  80207a:	ff 75 08             	pushl  0x8(%ebp)
  80207d:	e8 9d ff ff ff       	call   80201f <vcprintf>
	va_end(ap);

	return cnt;
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	57                   	push   %edi
  802088:	56                   	push   %esi
  802089:	53                   	push   %ebx
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	8b 75 10             	mov    0x10(%ebp),%esi
  802090:	8b 7d 14             	mov    0x14(%ebp),%edi
  802093:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802096:	8b 45 18             	mov    0x18(%ebp),%eax
  802099:	ba 00 00 00 00       	mov    $0x0,%edx
  80209e:	39 fa                	cmp    %edi,%edx
  8020a0:	77 39                	ja     8020db <printnum+0x57>
  8020a2:	72 04                	jb     8020a8 <printnum+0x24>
  8020a4:	39 f0                	cmp    %esi,%eax
  8020a6:	77 33                	ja     8020db <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	ff 75 20             	pushl  0x20(%ebp)
  8020ae:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8020b1:	50                   	push   %eax
  8020b2:	ff 75 18             	pushl  0x18(%ebp)
  8020b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8020b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	57                   	push   %edi
  8020c0:	56                   	push   %esi
  8020c1:	e8 76 05 00 00       	call   80263c <__udivdi3>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	52                   	push   %edx
  8020ca:	50                   	push   %eax
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	e8 ae ff ff ff       	call   802084 <printnum>
  8020d6:	83 c4 20             	add    $0x20,%esp
  8020d9:	eb 19                	jmp    8020f4 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8020db:	4b                   	dec    %ebx
  8020dc:	85 db                	test   %ebx,%ebx
  8020de:	7e 14                	jle    8020f4 <printnum+0x70>
  8020e0:	83 ec 08             	sub    $0x8,%esp
  8020e3:	ff 75 0c             	pushl  0xc(%ebp)
  8020e6:	ff 75 20             	pushl  0x20(%ebp)
  8020e9:	ff 55 08             	call   *0x8(%ebp)
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	4b                   	dec    %ebx
  8020f0:	85 db                	test   %ebx,%ebx
  8020f2:	7f ec                	jg     8020e0 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8020f4:	83 ec 08             	sub    $0x8,%esp
  8020f7:	ff 75 0c             	pushl  0xc(%ebp)
  8020fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8020fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	52                   	push   %edx
  802106:	50                   	push   %eax
  802107:	57                   	push   %edi
  802108:	56                   	push   %esi
  802109:	e8 3a 06 00 00       	call   802748 <__umoddi3>
  80210e:	83 c4 14             	add    $0x14,%esp
  802111:	0f be 80 cd 2c 80 00 	movsbl 0x802ccd(%eax),%eax
  802118:	50                   	push   %eax
  802119:	ff 55 08             	call   *0x8(%ebp)
}
  80211c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80211f:	5b                   	pop    %ebx
  802120:	5e                   	pop    %esi
  802121:	5f                   	pop    %edi
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80212a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80212d:	83 f8 01             	cmp    $0x1,%eax
  802130:	7e 0f                	jle    802141 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  802132:	8b 01                	mov    (%ecx),%eax
  802134:	83 c0 08             	add    $0x8,%eax
  802137:	89 01                	mov    %eax,(%ecx)
  802139:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80213c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80213f:	eb 24                	jmp    802165 <getuint+0x41>
	else if (lflag)
  802141:	85 c0                	test   %eax,%eax
  802143:	74 11                	je     802156 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  802145:	8b 01                	mov    (%ecx),%eax
  802147:	83 c0 04             	add    $0x4,%eax
  80214a:	89 01                	mov    %eax,(%ecx)
  80214c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80214f:	ba 00 00 00 00       	mov    $0x0,%edx
  802154:	eb 0f                	jmp    802165 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  802156:	8b 01                	mov    (%ecx),%eax
  802158:	83 c0 04             	add    $0x4,%eax
  80215b:	89 01                	mov    %eax,(%ecx)
  80215d:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  802160:	ba 00 00 00 00       	mov    $0x0,%edx
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	8b 55 08             	mov    0x8(%ebp),%edx
  80216d:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  802170:	83 f8 01             	cmp    $0x1,%eax
  802173:	7e 0f                	jle    802184 <getint+0x1d>
		return va_arg(*ap, long long);
  802175:	8b 02                	mov    (%edx),%eax
  802177:	83 c0 08             	add    $0x8,%eax
  80217a:	89 02                	mov    %eax,(%edx)
  80217c:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80217f:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  802182:	eb 1c                	jmp    8021a0 <getint+0x39>
	else if (lflag)
  802184:	85 c0                	test   %eax,%eax
  802186:	74 0d                	je     802195 <getint+0x2e>
		return va_arg(*ap, long);
  802188:	8b 02                	mov    (%edx),%eax
  80218a:	83 c0 04             	add    $0x4,%eax
  80218d:	89 02                	mov    %eax,(%edx)
  80218f:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  802192:	99                   	cltd   
  802193:	eb 0b                	jmp    8021a0 <getint+0x39>
	else
		return va_arg(*ap, int);
  802195:	8b 02                	mov    (%edx),%eax
  802197:	83 c0 04             	add    $0x4,%eax
  80219a:	89 02                	mov    %eax,(%edx)
  80219c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80219f:	99                   	cltd   
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	57                   	push   %edi
  8021a6:	56                   	push   %esi
  8021a7:	53                   	push   %ebx
  8021a8:	83 ec 1c             	sub    $0x1c,%esp
  8021ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8021ae:	0f b6 13             	movzbl (%ebx),%edx
  8021b1:	43                   	inc    %ebx
  8021b2:	83 fa 25             	cmp    $0x25,%edx
  8021b5:	74 1e                	je     8021d5 <vprintfmt+0x33>
  8021b7:	85 d2                	test   %edx,%edx
  8021b9:	0f 84 d7 02 00 00    	je     802496 <vprintfmt+0x2f4>
  8021bf:	83 ec 08             	sub    $0x8,%esp
  8021c2:	ff 75 0c             	pushl  0xc(%ebp)
  8021c5:	52                   	push   %edx
  8021c6:	ff 55 08             	call   *0x8(%ebp)
  8021c9:	83 c4 10             	add    $0x10,%esp
  8021cc:	0f b6 13             	movzbl (%ebx),%edx
  8021cf:	43                   	inc    %ebx
  8021d0:	83 fa 25             	cmp    $0x25,%edx
  8021d3:	75 e2                	jne    8021b7 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8021d5:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8021d9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8021e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  8021e5:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  8021ea:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8021f1:	0f b6 13             	movzbl (%ebx),%edx
  8021f4:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  8021f7:	43                   	inc    %ebx
  8021f8:	83 f8 55             	cmp    $0x55,%eax
  8021fb:	0f 87 70 02 00 00    	ja     802471 <vprintfmt+0x2cf>
  802201:	ff 24 85 5c 2d 80 00 	jmp    *0x802d5c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  802208:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  80220c:	eb e3                	jmp    8021f1 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80220e:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  802212:	eb dd                	jmp    8021f1 <vprintfmt+0x4f>

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
  802214:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  802219:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  80221c:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  802220:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  802223:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  802226:	83 f8 09             	cmp    $0x9,%eax
  802229:	77 27                	ja     802252 <vprintfmt+0xb0>
  80222b:	43                   	inc    %ebx
  80222c:	eb eb                	jmp    802219 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80222e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  802232:	8b 45 14             	mov    0x14(%ebp),%eax
  802235:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  802238:	eb 18                	jmp    802252 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80223a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80223e:	79 b1                	jns    8021f1 <vprintfmt+0x4f>
				width = 0;
  802240:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  802247:	eb a8                	jmp    8021f1 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  802249:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  802250:	eb 9f                	jmp    8021f1 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  802252:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  802256:	79 99                	jns    8021f1 <vprintfmt+0x4f>
				width = precision, precision = -1;
  802258:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80225b:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  802260:	eb 8f                	jmp    8021f1 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802262:	41                   	inc    %ecx
			goto reswitch;
  802263:	eb 8c                	jmp    8021f1 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802265:	83 ec 08             	sub    $0x8,%esp
  802268:	ff 75 0c             	pushl  0xc(%ebp)
  80226b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	ff 70 fc             	pushl  0xfffffffc(%eax)
  802275:	ff 55 08             	call   *0x8(%ebp)
			break;
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	e9 2e ff ff ff       	jmp    8021ae <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  802280:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  802284:	8b 45 14             	mov    0x14(%ebp),%eax
  802287:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  80228a:	85 c0                	test   %eax,%eax
  80228c:	79 02                	jns    802290 <vprintfmt+0xee>
				err = -err;
  80228e:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  802290:	83 f8 0e             	cmp    $0xe,%eax
  802293:	7f 0b                	jg     8022a0 <vprintfmt+0xfe>
  802295:	8b 3c 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edi
  80229c:	85 ff                	test   %edi,%edi
  80229e:	75 19                	jne    8022b9 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8022a0:	50                   	push   %eax
  8022a1:	68 de 2c 80 00       	push   $0x802cde
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	e8 ed 01 00 00       	call   80249e <printfmt>
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	e9 f5 fe ff ff       	jmp    8021ae <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8022b9:	57                   	push   %edi
  8022ba:	68 01 2b 80 00       	push   $0x802b01
  8022bf:	ff 75 0c             	pushl  0xc(%ebp)
  8022c2:	ff 75 08             	pushl  0x8(%ebp)
  8022c5:	e8 d4 01 00 00       	call   80249e <printfmt>
  8022ca:	83 c4 10             	add    $0x10,%esp
			break;
  8022cd:	e9 dc fe ff ff       	jmp    8021ae <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8022d2:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8022d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d9:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8022dc:	85 ff                	test   %edi,%edi
  8022de:	75 05                	jne    8022e5 <vprintfmt+0x143>
				p = "(null)";
  8022e0:	bf e7 2c 80 00       	mov    $0x802ce7,%edi
			if (width > 0 && padc != '-')
  8022e5:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8022e9:	7e 3b                	jle    802326 <vprintfmt+0x184>
  8022eb:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  8022ef:	74 35                	je     802326 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  8022f1:	83 ec 08             	sub    $0x8,%esp
  8022f4:	56                   	push   %esi
  8022f5:	57                   	push   %edi
  8022f6:	e8 36 e0 ff ff       	call   800331 <strnlen>
  8022fb:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  8022fe:	83 c4 10             	add    $0x10,%esp
  802301:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  802305:	7e 1f                	jle    802326 <vprintfmt+0x184>
  802307:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80230b:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80230e:	83 ec 08             	sub    $0x8,%esp
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  802317:	ff 55 08             	call   *0x8(%ebp)
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	ff 4d f0             	decl   0xfffffff0(%ebp)
  802320:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  802324:	7f e8                	jg     80230e <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802326:	0f be 17             	movsbl (%edi),%edx
  802329:	47                   	inc    %edi
  80232a:	85 d2                	test   %edx,%edx
  80232c:	74 44                	je     802372 <vprintfmt+0x1d0>
  80232e:	85 f6                	test   %esi,%esi
  802330:	78 03                	js     802335 <vprintfmt+0x193>
  802332:	4e                   	dec    %esi
  802333:	78 3d                	js     802372 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  802335:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  802339:	74 18                	je     802353 <vprintfmt+0x1b1>
  80233b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80233e:	83 f8 5e             	cmp    $0x5e,%eax
  802341:	76 10                	jbe    802353 <vprintfmt+0x1b1>
					putch('?', putdat);
  802343:	83 ec 08             	sub    $0x8,%esp
  802346:	ff 75 0c             	pushl  0xc(%ebp)
  802349:	6a 3f                	push   $0x3f
  80234b:	ff 55 08             	call   *0x8(%ebp)
  80234e:	83 c4 10             	add    $0x10,%esp
  802351:	eb 0d                	jmp    802360 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  802353:	83 ec 08             	sub    $0x8,%esp
  802356:	ff 75 0c             	pushl  0xc(%ebp)
  802359:	52                   	push   %edx
  80235a:	ff 55 08             	call   *0x8(%ebp)
  80235d:	83 c4 10             	add    $0x10,%esp
  802360:	ff 4d f0             	decl   0xfffffff0(%ebp)
  802363:	0f be 17             	movsbl (%edi),%edx
  802366:	47                   	inc    %edi
  802367:	85 d2                	test   %edx,%edx
  802369:	74 07                	je     802372 <vprintfmt+0x1d0>
  80236b:	85 f6                	test   %esi,%esi
  80236d:	78 c6                	js     802335 <vprintfmt+0x193>
  80236f:	4e                   	dec    %esi
  802370:	79 c3                	jns    802335 <vprintfmt+0x193>
			for (; width > 0; width--)
  802372:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  802376:	0f 8e 32 fe ff ff    	jle    8021ae <vprintfmt+0xc>
				putch(' ', putdat);
  80237c:	83 ec 08             	sub    $0x8,%esp
  80237f:	ff 75 0c             	pushl  0xc(%ebp)
  802382:	6a 20                	push   $0x20
  802384:	ff 55 08             	call   *0x8(%ebp)
  802387:	83 c4 10             	add    $0x10,%esp
  80238a:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80238d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  802391:	7f e9                	jg     80237c <vprintfmt+0x1da>
			break;
  802393:	e9 16 fe ff ff       	jmp    8021ae <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  802398:	51                   	push   %ecx
  802399:	8d 45 14             	lea    0x14(%ebp),%eax
  80239c:	50                   	push   %eax
  80239d:	e8 c5 fd ff ff       	call   802167 <getint>
  8023a2:	89 c6                	mov    %eax,%esi
  8023a4:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8023a6:	83 c4 08             	add    $0x8,%esp
  8023a9:	85 d2                	test   %edx,%edx
  8023ab:	79 15                	jns    8023c2 <vprintfmt+0x220>
				putch('-', putdat);
  8023ad:	83 ec 08             	sub    $0x8,%esp
  8023b0:	ff 75 0c             	pushl  0xc(%ebp)
  8023b3:	6a 2d                	push   $0x2d
  8023b5:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8023b8:	f7 de                	neg    %esi
  8023ba:	83 d7 00             	adc    $0x0,%edi
  8023bd:	f7 df                	neg    %edi
  8023bf:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8023c2:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8023c7:	eb 75                	jmp    80243e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8023c9:	51                   	push   %ecx
  8023ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8023cd:	50                   	push   %eax
  8023ce:	e8 51 fd ff ff       	call   802124 <getuint>
  8023d3:	89 c6                	mov    %eax,%esi
  8023d5:	89 d7                	mov    %edx,%edi
			base = 10;
  8023d7:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8023dc:	83 c4 08             	add    $0x8,%esp
  8023df:	eb 5d                	jmp    80243e <vprintfmt+0x29c>

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
  8023e1:	51                   	push   %ecx
  8023e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8023e5:	50                   	push   %eax
  8023e6:	e8 39 fd ff ff       	call   802124 <getuint>
  8023eb:	89 c6                	mov    %eax,%esi
  8023ed:	89 d7                	mov    %edx,%edi
			base = 8;
  8023ef:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  8023f4:	83 c4 08             	add    $0x8,%esp
  8023f7:	eb 45                	jmp    80243e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8023f9:	83 ec 08             	sub    $0x8,%esp
  8023fc:	ff 75 0c             	pushl  0xc(%ebp)
  8023ff:	6a 30                	push   $0x30
  802401:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  802404:	83 c4 08             	add    $0x8,%esp
  802407:	ff 75 0c             	pushl  0xc(%ebp)
  80240a:	6a 78                	push   $0x78
  80240c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80240f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  802413:	8b 45 14             	mov    0x14(%ebp),%eax
  802416:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  802419:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80241e:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  802423:	83 c4 10             	add    $0x10,%esp
  802426:	eb 16                	jmp    80243e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802428:	51                   	push   %ecx
  802429:	8d 45 14             	lea    0x14(%ebp),%eax
  80242c:	50                   	push   %eax
  80242d:	e8 f2 fc ff ff       	call   802124 <getuint>
  802432:	89 c6                	mov    %eax,%esi
  802434:	89 d7                	mov    %edx,%edi
			base = 16;
  802436:	ba 10 00 00 00       	mov    $0x10,%edx
  80243b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  802445:	50                   	push   %eax
  802446:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802449:	52                   	push   %edx
  80244a:	57                   	push   %edi
  80244b:	56                   	push   %esi
  80244c:	ff 75 0c             	pushl  0xc(%ebp)
  80244f:	ff 75 08             	pushl  0x8(%ebp)
  802452:	e8 2d fc ff ff       	call   802084 <printnum>
			break;
  802457:	83 c4 20             	add    $0x20,%esp
  80245a:	e9 4f fd ff ff       	jmp    8021ae <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80245f:	83 ec 08             	sub    $0x8,%esp
  802462:	ff 75 0c             	pushl  0xc(%ebp)
  802465:	52                   	push   %edx
  802466:	ff 55 08             	call   *0x8(%ebp)
			break;
  802469:	83 c4 10             	add    $0x10,%esp
  80246c:	e9 3d fd ff ff       	jmp    8021ae <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802471:	83 ec 08             	sub    $0x8,%esp
  802474:	ff 75 0c             	pushl  0xc(%ebp)
  802477:	6a 25                	push   $0x25
  802479:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80247c:	4b                   	dec    %ebx
  80247d:	83 c4 10             	add    $0x10,%esp
  802480:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  802484:	0f 84 24 fd ff ff    	je     8021ae <vprintfmt+0xc>
  80248a:	4b                   	dec    %ebx
  80248b:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80248f:	75 f9                	jne    80248a <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  802491:	e9 18 fd ff ff       	jmp    8021ae <vprintfmt+0xc>
		}
	}
}
  802496:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802499:	5b                   	pop    %ebx
  80249a:	5e                   	pop    %esi
  80249b:	5f                   	pop    %edi
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8024a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8024a7:	50                   	push   %eax
  8024a8:	ff 75 10             	pushl  0x10(%ebp)
  8024ab:	ff 75 0c             	pushl  0xc(%ebp)
  8024ae:	ff 75 08             	pushl  0x8(%ebp)
  8024b1:	e8 ec fc ff ff       	call   8021a2 <vprintfmt>
	va_end(ap);
}
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
  8024bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8024be:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  8024c1:	8b 0a                	mov    (%edx),%ecx
  8024c3:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8024c6:	73 07                	jae    8024cf <sprintputch+0x17>
		*b->buf++ = ch;
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	88 01                	mov    %al,(%ecx)
  8024cd:	ff 02                	incl   (%edx)
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	83 ec 18             	sub    $0x18,%esp
  8024d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8024dd:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8024e0:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  8024e4:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8024e7:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  8024ee:	85 d2                	test   %edx,%edx
  8024f0:	74 04                	je     8024f6 <vsnprintf+0x25>
  8024f2:	85 c9                	test   %ecx,%ecx
  8024f4:	7f 07                	jg     8024fd <vsnprintf+0x2c>
		return -E_INVAL;
  8024f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024fb:	eb 1d                	jmp    80251a <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8024fd:	ff 75 14             	pushl  0x14(%ebp)
  802500:	ff 75 10             	pushl  0x10(%ebp)
  802503:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  802506:	50                   	push   %eax
  802507:	68 b8 24 80 00       	push   $0x8024b8
  80250c:	e8 91 fc ff ff       	call   8021a2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802511:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  802514:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802517:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802522:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802525:	50                   	push   %eax
  802526:	ff 75 10             	pushl  0x10(%ebp)
  802529:	ff 75 0c             	pushl  0xc(%ebp)
  80252c:	ff 75 08             	pushl  0x8(%ebp)
  80252f:	e8 9d ff ff ff       	call   8024d1 <vsnprintf>
	va_end(ap);

	return rc;
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    
	...

00802538 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	56                   	push   %esi
  80253c:	53                   	push   %ebx
  80253d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802540:	8b 45 0c             	mov    0xc(%ebp),%eax
  802543:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  802546:	85 c0                	test   %eax,%eax
  802548:	75 12                	jne    80255c <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80254a:	83 ec 0c             	sub    $0xc,%esp
  80254d:	68 00 00 c0 ee       	push   $0xeec00000
  802552:	e8 7f e3 ff ff       	call   8008d6 <sys_ipc_recv>
  802557:	83 c4 10             	add    $0x10,%esp
  80255a:	eb 0c                	jmp    802568 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  80255c:	83 ec 0c             	sub    $0xc,%esp
  80255f:	50                   	push   %eax
  802560:	e8 71 e3 ff ff       	call   8008d6 <sys_ipc_recv>
  802565:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802568:	89 c2                	mov    %eax,%edx
  80256a:	85 c0                	test   %eax,%eax
  80256c:	78 24                	js     802592 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  80256e:	85 db                	test   %ebx,%ebx
  802570:	74 0a                	je     80257c <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802572:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  802577:	8b 40 74             	mov    0x74(%eax),%eax
  80257a:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  80257c:	85 f6                	test   %esi,%esi
  80257e:	74 0a                	je     80258a <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802580:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  802585:	8b 40 78             	mov    0x78(%eax),%eax
  802588:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  80258a:	a1 a4 64 80 00       	mov    0x8064a4,%eax
  80258f:	8b 50 70             	mov    0x70(%eax),%edx

}
  802592:	89 d0                	mov    %edx,%eax
  802594:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802597:	5b                   	pop    %ebx
  802598:	5e                   	pop    %esi
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <ipc_send>:

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
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	57                   	push   %edi
  80259f:	56                   	push   %esi
  8025a0:	53                   	push   %ebx
  8025a1:	83 ec 0c             	sub    $0xc,%esp
  8025a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025aa:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  8025ad:	85 db                	test   %ebx,%ebx
  8025af:	75 0a                	jne    8025bb <ipc_send+0x20>
    pg = (void *) UTOP;
  8025b1:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  8025b6:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  8025bb:	56                   	push   %esi
  8025bc:	53                   	push   %ebx
  8025bd:	57                   	push   %edi
  8025be:	ff 75 08             	pushl  0x8(%ebp)
  8025c1:	e8 ed e2 ff ff       	call   8008b3 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  8025c6:	83 c4 10             	add    $0x10,%esp
  8025c9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025cc:	75 07                	jne    8025d5 <ipc_send+0x3a>
      sys_yield();
  8025ce:	e8 34 e1 ff ff       	call   800707 <sys_yield>
  8025d3:	eb e6                	jmp    8025bb <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	79 12                	jns    8025eb <ipc_send+0x50>
  8025d9:	50                   	push   %eax
  8025da:	68 b4 2e 80 00       	push   $0x802eb4
  8025df:	6a 49                	push   $0x49
  8025e1:	68 d1 2e 80 00       	push   $0x802ed1
  8025e6:	e8 95 f9 ff ff       	call   801f80 <_panic>
    else break;
  }
}
  8025eb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8025ee:	5b                   	pop    %ebx
  8025ef:	5e                   	pop    %esi
  8025f0:	5f                   	pop    %edi
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    
	...

008025f4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8025fa:	89 c8                	mov    %ecx,%eax
  8025fc:	c1 e8 16             	shr    $0x16,%eax
  8025ff:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802606:	ba 00 00 00 00       	mov    $0x0,%edx
  80260b:	a8 01                	test   $0x1,%al
  80260d:	74 28                	je     802637 <pageref+0x43>
	pte = vpt[VPN(v)];
  80260f:	89 c8                	mov    %ecx,%eax
  802611:	c1 e8 0c             	shr    $0xc,%eax
  802614:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80261b:	ba 00 00 00 00       	mov    $0x0,%edx
  802620:	a8 01                	test   $0x1,%al
  802622:	74 13                	je     802637 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802624:	c1 e8 0c             	shr    $0xc,%eax
  802627:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80262a:	c1 e0 02             	shl    $0x2,%eax
  80262d:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802634:	0f b7 d0             	movzwl %ax,%edx
}
  802637:	89 d0                	mov    %edx,%eax
  802639:	c9                   	leave  
  80263a:	c3                   	ret    
	...

0080263c <__udivdi3>:
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	57                   	push   %edi
  802640:	56                   	push   %esi
  802641:	83 ec 14             	sub    $0x14,%esp
  802644:	8b 55 14             	mov    0x14(%ebp),%edx
  802647:	8b 75 08             	mov    0x8(%ebp),%esi
  80264a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80264d:	8b 45 10             	mov    0x10(%ebp),%eax
  802650:	85 d2                	test   %edx,%edx
  802652:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802655:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802658:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80265b:	89 fe                	mov    %edi,%esi
  80265d:	75 11                	jne    802670 <__udivdi3+0x34>
  80265f:	39 f8                	cmp    %edi,%eax
  802661:	76 4d                	jbe    8026b0 <__udivdi3+0x74>
  802663:	89 fa                	mov    %edi,%edx
  802665:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802668:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80266b:	89 c7                	mov    %eax,%edi
  80266d:	eb 09                	jmp    802678 <__udivdi3+0x3c>
  80266f:	90                   	nop    
  802670:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802673:	76 17                	jbe    80268c <__udivdi3+0x50>
  802675:	31 ff                	xor    %edi,%edi
  802677:	90                   	nop    
  802678:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80267f:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802682:	83 c4 14             	add    $0x14,%esp
  802685:	5e                   	pop    %esi
  802686:	89 f8                	mov    %edi,%eax
  802688:	5f                   	pop    %edi
  802689:	c9                   	leave  
  80268a:	c3                   	ret    
  80268b:	90                   	nop    
  80268c:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802690:	89 c7                	mov    %eax,%edi
  802692:	83 f7 1f             	xor    $0x1f,%edi
  802695:	75 4d                	jne    8026e4 <__udivdi3+0xa8>
  802697:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  80269a:	77 0a                	ja     8026a6 <__udivdi3+0x6a>
  80269c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80269f:	31 ff                	xor    %edi,%edi
  8026a1:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  8026a4:	72 d2                	jb     802678 <__udivdi3+0x3c>
  8026a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8026ab:	eb cb                	jmp    802678 <__udivdi3+0x3c>
  8026ad:	8d 76 00             	lea    0x0(%esi),%esi
  8026b0:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	75 0e                	jne    8026c5 <__udivdi3+0x89>
  8026b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bc:	31 c9                	xor    %ecx,%ecx
  8026be:	31 d2                	xor    %edx,%edx
  8026c0:	f7 f1                	div    %ecx
  8026c2:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8026c5:	89 f0                	mov    %esi,%eax
  8026c7:	31 d2                	xor    %edx,%edx
  8026c9:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8026cc:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8026cf:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8026d2:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8026d5:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8026d8:	83 c4 14             	add    $0x14,%esp
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	5e                   	pop    %esi
  8026de:	89 f8                	mov    %edi,%eax
  8026e0:	5f                   	pop    %edi
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    
  8026e3:	90                   	nop    
  8026e4:	b8 20 00 00 00       	mov    $0x20,%eax
  8026e9:	29 f8                	sub    %edi,%eax
  8026eb:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8026ee:	89 f9                	mov    %edi,%ecx
  8026f0:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8026f3:	d3 e2                	shl    %cl,%edx
  8026f5:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8026f8:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026fb:	d3 e8                	shr    %cl,%eax
  8026fd:	09 c2                	or     %eax,%edx
  8026ff:	89 f9                	mov    %edi,%ecx
  802701:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802704:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802707:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80270a:	89 f2                	mov    %esi,%edx
  80270c:	d3 ea                	shr    %cl,%edx
  80270e:	89 f9                	mov    %edi,%ecx
  802710:	d3 e6                	shl    %cl,%esi
  802712:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802715:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802718:	d3 e8                	shr    %cl,%eax
  80271a:	09 c6                	or     %eax,%esi
  80271c:	89 f9                	mov    %edi,%ecx
  80271e:	89 f0                	mov    %esi,%eax
  802720:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802723:	89 d6                	mov    %edx,%esi
  802725:	89 c7                	mov    %eax,%edi
  802727:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  80272a:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80272d:	f7 e7                	mul    %edi
  80272f:	39 f2                	cmp    %esi,%edx
  802731:	77 0f                	ja     802742 <__udivdi3+0x106>
  802733:	0f 85 3f ff ff ff    	jne    802678 <__udivdi3+0x3c>
  802739:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  80273c:	0f 86 36 ff ff ff    	jbe    802678 <__udivdi3+0x3c>
  802742:	4f                   	dec    %edi
  802743:	e9 30 ff ff ff       	jmp    802678 <__udivdi3+0x3c>

00802748 <__umoddi3>:
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	57                   	push   %edi
  80274c:	56                   	push   %esi
  80274d:	83 ec 30             	sub    $0x30,%esp
  802750:	8b 55 14             	mov    0x14(%ebp),%edx
  802753:	8b 45 10             	mov    0x10(%ebp),%eax
  802756:	89 d7                	mov    %edx,%edi
  802758:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  80275b:	89 c6                	mov    %eax,%esi
  80275d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	85 ff                	test   %edi,%edi
  802765:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  80276c:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802773:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802776:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802779:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80277c:	75 3e                	jne    8027bc <__umoddi3+0x74>
  80277e:	39 d6                	cmp    %edx,%esi
  802780:	0f 86 a2 00 00 00    	jbe    802828 <__umoddi3+0xe0>
  802786:	f7 f6                	div    %esi
  802788:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80278b:	85 c9                	test   %ecx,%ecx
  80278d:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802790:	74 1b                	je     8027ad <__umoddi3+0x65>
  802792:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802795:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802798:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80279f:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8027a2:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  8027a5:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  8027a8:	89 10                	mov    %edx,(%eax)
  8027aa:	89 48 04             	mov    %ecx,0x4(%eax)
  8027ad:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8027b0:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8027b3:	83 c4 30             	add    $0x30,%esp
  8027b6:	5e                   	pop    %esi
  8027b7:	5f                   	pop    %edi
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    
  8027ba:	89 f6                	mov    %esi,%esi
  8027bc:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  8027bf:	76 1f                	jbe    8027e0 <__umoddi3+0x98>
  8027c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c4:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8027c7:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8027ca:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  8027cd:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8027d0:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8027d3:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8027d6:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8027d9:	83 c4 30             	add    $0x30,%esp
  8027dc:	5e                   	pop    %esi
  8027dd:	5f                   	pop    %edi
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    
  8027e0:	0f bd c7             	bsr    %edi,%eax
  8027e3:	83 f0 1f             	xor    $0x1f,%eax
  8027e6:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8027e9:	75 61                	jne    80284c <__umoddi3+0x104>
  8027eb:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8027ee:	77 05                	ja     8027f5 <__umoddi3+0xad>
  8027f0:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8027f3:	72 10                	jb     802805 <__umoddi3+0xbd>
  8027f5:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8027f8:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027fb:	29 f0                	sub    %esi,%eax
  8027fd:	19 fa                	sbb    %edi,%edx
  8027ff:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802802:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802805:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802808:	85 d2                	test   %edx,%edx
  80280a:	74 a1                	je     8027ad <__umoddi3+0x65>
  80280c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80280f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802812:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802815:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802818:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80281b:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80281e:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802821:	89 01                	mov    %eax,(%ecx)
  802823:	89 51 04             	mov    %edx,0x4(%ecx)
  802826:	eb 85                	jmp    8027ad <__umoddi3+0x65>
  802828:	85 f6                	test   %esi,%esi
  80282a:	75 0b                	jne    802837 <__umoddi3+0xef>
  80282c:	b8 01 00 00 00       	mov    $0x1,%eax
  802831:	31 d2                	xor    %edx,%edx
  802833:	f7 f6                	div    %esi
  802835:	89 c6                	mov    %eax,%esi
  802837:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80283a:	89 fa                	mov    %edi,%edx
  80283c:	f7 f6                	div    %esi
  80283e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802841:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802844:	f7 f6                	div    %esi
  802846:	e9 3d ff ff ff       	jmp    802788 <__umoddi3+0x40>
  80284b:	90                   	nop    
  80284c:	b8 20 00 00 00       	mov    $0x20,%eax
  802851:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802854:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802857:	89 fa                	mov    %edi,%edx
  802859:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80285c:	d3 e2                	shl    %cl,%edx
  80285e:	89 f0                	mov    %esi,%eax
  802860:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802863:	d3 e8                	shr    %cl,%eax
  802865:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802868:	d3 e6                	shl    %cl,%esi
  80286a:	89 d7                	mov    %edx,%edi
  80286c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80286f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802872:	09 c7                	or     %eax,%edi
  802874:	d3 ea                	shr    %cl,%edx
  802876:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802879:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80287c:	d3 e0                	shl    %cl,%eax
  80287e:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802881:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802884:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802887:	d3 e8                	shr    %cl,%eax
  802889:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  80288c:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80288f:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802892:	f7 f7                	div    %edi
  802894:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802897:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  80289a:	f7 e6                	mul    %esi
  80289c:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  80289f:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  8028a2:	77 0a                	ja     8028ae <__umoddi3+0x166>
  8028a4:	75 12                	jne    8028b8 <__umoddi3+0x170>
  8028a6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028a9:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  8028ac:	76 0a                	jbe    8028b8 <__umoddi3+0x170>
  8028ae:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  8028b1:	29 f1                	sub    %esi,%ecx
  8028b3:	19 fa                	sbb    %edi,%edx
  8028b5:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  8028b8:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	0f 84 ea fe ff ff    	je     8027ad <__umoddi3+0x65>
  8028c3:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8028c6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028c9:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  8028cc:	19 d1                	sbb    %edx,%ecx
  8028ce:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  8028d1:	89 ca                	mov    %ecx,%edx
  8028d3:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8028d6:	d3 e2                	shl    %cl,%edx
  8028d8:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8028db:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8028de:	d3 e8                	shr    %cl,%eax
  8028e0:	09 c2                	or     %eax,%edx
  8028e2:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8028e5:	d3 e8                	shr    %cl,%eax
  8028e7:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8028ea:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8028ed:	e9 ad fe ff ff       	jmp    80279f <__umoddi3+0x57>
