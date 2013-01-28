
obj/user/idle:     file format elf32-i386

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
  80002c:	e8 1b 00 00 00       	call   80004c <libmain>
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
  800037:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003a:	c7 05 00 60 80 00 e0 	movl   $0x8023e0,0x806000
  800041:	23 80 00 

	// Loop forever, simply trying to yield to a different environment.
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800044:	e8 02 01 00 00       	call   80014b <sys_yield>

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800049:	cc                   	int3   
  80004a:	eb f8                	jmp    800044 <umain+0x10>

0080004c <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	56                   	push   %esi
  800050:	53                   	push   %ebx
  800051:	8b 75 08             	mov    0x8(%ebp),%esi
  800054:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  800057:	e8 d0 00 00 00       	call   80012c <sys_getenvid>
  80005c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800061:	c1 e0 07             	shl    $0x7,%eax
  800064:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800069:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006e:	85 f6                	test   %esi,%esi
  800070:	7e 07                	jle    800079 <libmain+0x2d>
		binaryname = argv[0];
  800072:	8b 03                	mov    (%ebx),%eax
  800074:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	53                   	push   %ebx
  80007d:	56                   	push   %esi
  80007e:	e8 b1 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800083:	e8 08 00 00 00       	call   800090 <exit>
}
  800088:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	c9                   	leave  
  80008e:	c3                   	ret    
	...

00800090 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800096:	e8 f9 05 00 00       	call   800694 <close_all>
	sys_env_destroy(0);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	e8 46 00 00 00       	call   8000eb <sys_env_destroy>
}
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    
	...

008000a8 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	57                   	push   %edi
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
  8000ae:	83 ec 04             	sub    $0x4,%esp
  8000b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8000bc:	89 f8                	mov    %edi,%eax
  8000be:	89 fb                	mov    %edi,%ebx
  8000c0:	89 fe                	mov    %edi,%esi
  8000c2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c4:	83 c4 04             	add    $0x4,%esp
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	c9                   	leave  
  8000cb:	c3                   	ret    

008000cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	57                   	push   %edi
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
  8000d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8000dc:	89 fa                	mov    %edi,%edx
  8000de:	89 f9                	mov    %edi,%ecx
  8000e0:	89 fb                	mov    %edi,%ebx
  8000e2:	89 fe                	mov    %edi,%esi
  8000e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	c9                   	leave  
  8000ea:	c3                   	ret    

008000eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fc:	bf 00 00 00 00       	mov    $0x0,%edi
  800101:	89 f9                	mov    %edi,%ecx
  800103:	89 fb                	mov    %edi,%ebx
  800105:	89 fe                	mov    %edi,%esi
  800107:	cd 30                	int    $0x30
  800109:	85 c0                	test   %eax,%eax
  80010b:	7e 17                	jle    800124 <sys_env_destroy+0x39>
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	50                   	push   %eax
  800111:	6a 03                	push   $0x3
  800113:	68 fc 23 80 00       	push   $0x8023fc
  800118:	6a 23                	push   $0x23
  80011a:	68 19 24 80 00       	push   $0x802419
  80011f:	e8 e4 14 00 00       	call   801608 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800124:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800127:	5b                   	pop    %ebx
  800128:	5e                   	pop    %esi
  800129:	5f                   	pop    %edi
  80012a:	c9                   	leave  
  80012b:	c3                   	ret    

0080012c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	57                   	push   %edi
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	b8 02 00 00 00       	mov    $0x2,%eax
  800137:	bf 00 00 00 00       	mov    $0x0,%edi
  80013c:	89 fa                	mov    %edi,%edx
  80013e:	89 f9                	mov    %edi,%ecx
  800140:	89 fb                	mov    %edi,%ebx
  800142:	89 fe                	mov    %edi,%esi
  800144:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	c9                   	leave  
  80014a:	c3                   	ret    

0080014b <sys_yield>:

void
sys_yield(void)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	57                   	push   %edi
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
  800151:	b8 0b 00 00 00       	mov    $0xb,%eax
  800156:	bf 00 00 00 00       	mov    $0x0,%edi
  80015b:	89 fa                	mov    %edi,%edx
  80015d:	89 f9                	mov    %edi,%ecx
  80015f:	89 fb                	mov    %edi,%ebx
  800161:	89 fe                	mov    %edi,%esi
  800163:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5f                   	pop    %edi
  800168:	c9                   	leave  
  800169:	c3                   	ret    

0080016a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	57                   	push   %edi
  80016e:	56                   	push   %esi
  80016f:	53                   	push   %ebx
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	8b 55 08             	mov    0x8(%ebp),%edx
  800176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800179:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017c:	b8 04 00 00 00       	mov    $0x4,%eax
  800181:	bf 00 00 00 00       	mov    $0x0,%edi
  800186:	89 fe                	mov    %edi,%esi
  800188:	cd 30                	int    $0x30
  80018a:	85 c0                	test   %eax,%eax
  80018c:	7e 17                	jle    8001a5 <sys_page_alloc+0x3b>
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	6a 04                	push   $0x4
  800194:	68 fc 23 80 00       	push   $0x8023fc
  800199:	6a 23                	push   $0x23
  80019b:	68 19 24 80 00       	push   $0x802419
  8001a0:	e8 63 14 00 00       	call   801608 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	57                   	push   %edi
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ca:	cd 30                	int    $0x30
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	7e 17                	jle    8001e7 <sys_page_map+0x3a>
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	50                   	push   %eax
  8001d4:	6a 05                	push   $0x5
  8001d6:	68 fc 23 80 00       	push   $0x8023fc
  8001db:	6a 23                	push   $0x23
  8001dd:	68 19 24 80 00       	push   $0x802419
  8001e2:	e8 21 14 00 00       	call   801608 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5e                   	pop    %esi
  8001ec:	5f                   	pop    %edi
  8001ed:	c9                   	leave  
  8001ee:	c3                   	ret    

008001ef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	57                   	push   %edi
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fe:	b8 06 00 00 00       	mov    $0x6,%eax
  800203:	bf 00 00 00 00       	mov    $0x0,%edi
  800208:	89 fb                	mov    %edi,%ebx
  80020a:	89 fe                	mov    %edi,%esi
  80020c:	cd 30                	int    $0x30
  80020e:	85 c0                	test   %eax,%eax
  800210:	7e 17                	jle    800229 <sys_page_unmap+0x3a>
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	6a 06                	push   $0x6
  800218:	68 fc 23 80 00       	push   $0x8023fc
  80021d:	6a 23                	push   $0x23
  80021f:	68 19 24 80 00       	push   $0x802419
  800224:	e8 df 13 00 00       	call   801608 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800229:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80022c:	5b                   	pop    %ebx
  80022d:	5e                   	pop    %esi
  80022e:	5f                   	pop    %edi
  80022f:	c9                   	leave  
  800230:	c3                   	ret    

00800231 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	57                   	push   %edi
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	8b 55 08             	mov    0x8(%ebp),%edx
  80023d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800240:	b8 08 00 00 00       	mov    $0x8,%eax
  800245:	bf 00 00 00 00       	mov    $0x0,%edi
  80024a:	89 fb                	mov    %edi,%ebx
  80024c:	89 fe                	mov    %edi,%esi
  80024e:	cd 30                	int    $0x30
  800250:	85 c0                	test   %eax,%eax
  800252:	7e 17                	jle    80026b <sys_env_set_status+0x3a>
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	50                   	push   %eax
  800258:	6a 08                	push   $0x8
  80025a:	68 fc 23 80 00       	push   $0x8023fc
  80025f:	6a 23                	push   $0x23
  800261:	68 19 24 80 00       	push   $0x802419
  800266:	e8 9d 13 00 00       	call   801608 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	c9                   	leave  
  800272:	c3                   	ret    

00800273 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 0c             	sub    $0xc,%esp
  80027c:	8b 55 08             	mov    0x8(%ebp),%edx
  80027f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800282:	b8 09 00 00 00       	mov    $0x9,%eax
  800287:	bf 00 00 00 00       	mov    $0x0,%edi
  80028c:	89 fb                	mov    %edi,%ebx
  80028e:	89 fe                	mov    %edi,%esi
  800290:	cd 30                	int    $0x30
  800292:	85 c0                	test   %eax,%eax
  800294:	7e 17                	jle    8002ad <sys_env_set_trapframe+0x3a>
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	50                   	push   %eax
  80029a:	6a 09                	push   $0x9
  80029c:	68 fc 23 80 00       	push   $0x8023fc
  8002a1:	6a 23                	push   $0x23
  8002a3:	68 19 24 80 00       	push   $0x802419
  8002a8:	e8 5b 13 00 00       	call   801608 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ad:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	57                   	push   %edi
  8002b9:	56                   	push   %esi
  8002ba:	53                   	push   %ebx
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ce:	89 fb                	mov    %edi,%ebx
  8002d0:	89 fe                	mov    %edi,%esi
  8002d2:	cd 30                	int    $0x30
  8002d4:	85 c0                	test   %eax,%eax
  8002d6:	7e 17                	jle    8002ef <sys_env_set_pgfault_upcall+0x3a>
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	6a 0a                	push   $0xa
  8002de:	68 fc 23 80 00       	push   $0x8023fc
  8002e3:	6a 23                	push   $0x23
  8002e5:	68 19 24 80 00       	push   $0x802419
  8002ea:	e8 19 13 00 00       	call   801608 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002ef:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800300:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800303:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800306:	8b 7d 14             	mov    0x14(%ebp),%edi
  800309:	b8 0c 00 00 00       	mov    $0xc,%eax
  80030e:	be 00 00 00 00       	mov    $0x0,%esi
  800313:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800315:	5b                   	pop    %ebx
  800316:	5e                   	pop    %esi
  800317:	5f                   	pop    %edi
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	8b 55 08             	mov    0x8(%ebp),%edx
  800326:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032b:	bf 00 00 00 00       	mov    $0x0,%edi
  800330:	89 f9                	mov    %edi,%ecx
  800332:	89 fb                	mov    %edi,%ebx
  800334:	89 fe                	mov    %edi,%esi
  800336:	cd 30                	int    $0x30
  800338:	85 c0                	test   %eax,%eax
  80033a:	7e 17                	jle    800353 <sys_ipc_recv+0x39>
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	6a 0d                	push   $0xd
  800342:	68 fc 23 80 00       	push   $0x8023fc
  800347:	6a 23                	push   $0x23
  800349:	68 19 24 80 00       	push   $0x802419
  80034e:	e8 b5 12 00 00       	call   801608 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800353:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	c9                   	leave  
  80035a:	c3                   	ret    

0080035b <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	57                   	push   %edi
  80035f:	56                   	push   %esi
  800360:	53                   	push   %ebx
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	8b 55 08             	mov    0x8(%ebp),%edx
  800367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036a:	b8 10 00 00 00       	mov    $0x10,%eax
  80036f:	bf 00 00 00 00       	mov    $0x0,%edi
  800374:	89 fb                	mov    %edi,%ebx
  800376:	89 fe                	mov    %edi,%esi
  800378:	cd 30                	int    $0x30
  80037a:	85 c0                	test   %eax,%eax
  80037c:	7e 17                	jle    800395 <sys_transmit_packet+0x3a>
  80037e:	83 ec 0c             	sub    $0xc,%esp
  800381:	50                   	push   %eax
  800382:	6a 10                	push   $0x10
  800384:	68 fc 23 80 00       	push   $0x8023fc
  800389:	6a 23                	push   $0x23
  80038b:	68 19 24 80 00       	push   $0x802419
  800390:	e8 73 12 00 00       	call   801608 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800395:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800398:	5b                   	pop    %ebx
  800399:	5e                   	pop    %esi
  80039a:	5f                   	pop    %edi
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	57                   	push   %edi
  8003a1:	56                   	push   %esi
  8003a2:	53                   	push   %ebx
  8003a3:	83 ec 0c             	sub    $0xc,%esp
  8003a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ac:	b8 11 00 00 00       	mov    $0x11,%eax
  8003b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8003b6:	89 fb                	mov    %edi,%ebx
  8003b8:	89 fe                	mov    %edi,%esi
  8003ba:	cd 30                	int    $0x30
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	7e 17                	jle    8003d7 <sys_receive_packet+0x3a>
  8003c0:	83 ec 0c             	sub    $0xc,%esp
  8003c3:	50                   	push   %eax
  8003c4:	6a 11                	push   $0x11
  8003c6:	68 fc 23 80 00       	push   $0x8023fc
  8003cb:	6a 23                	push   $0x23
  8003cd:	68 19 24 80 00       	push   $0x802419
  8003d2:	e8 31 12 00 00       	call   801608 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  8003d7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8003da:	5b                   	pop    %ebx
  8003db:	5e                   	pop    %esi
  8003dc:	5f                   	pop    %edi
  8003dd:	c9                   	leave  
  8003de:	c3                   	ret    

008003df <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	57                   	push   %edi
  8003e3:	56                   	push   %esi
  8003e4:	53                   	push   %ebx
  8003e5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8003ef:	89 fa                	mov    %edi,%edx
  8003f1:	89 f9                	mov    %edi,%ecx
  8003f3:	89 fb                	mov    %edi,%ebx
  8003f5:	89 fe                	mov    %edi,%esi
  8003f7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003f9:	5b                   	pop    %ebx
  8003fa:	5e                   	pop    %esi
  8003fb:	5f                   	pop    %edi
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	57                   	push   %edi
  800402:	56                   	push   %esi
  800403:	53                   	push   %ebx
  800404:	83 ec 0c             	sub    $0xc,%esp
  800407:	8b 55 08             	mov    0x8(%ebp),%edx
  80040a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80040f:	bf 00 00 00 00       	mov    $0x0,%edi
  800414:	89 f9                	mov    %edi,%ecx
  800416:	89 fb                	mov    %edi,%ebx
  800418:	89 fe                	mov    %edi,%esi
  80041a:	cd 30                	int    $0x30
  80041c:	85 c0                	test   %eax,%eax
  80041e:	7e 17                	jle    800437 <sys_map_receive_buffers+0x39>
  800420:	83 ec 0c             	sub    $0xc,%esp
  800423:	50                   	push   %eax
  800424:	6a 0e                	push   $0xe
  800426:	68 fc 23 80 00       	push   $0x8023fc
  80042b:	6a 23                	push   $0x23
  80042d:	68 19 24 80 00       	push   $0x802419
  800432:	e8 d1 11 00 00       	call   801608 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800437:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80043a:	5b                   	pop    %ebx
  80043b:	5e                   	pop    %esi
  80043c:	5f                   	pop    %edi
  80043d:	c9                   	leave  
  80043e:	c3                   	ret    

0080043f <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	57                   	push   %edi
  800443:	56                   	push   %esi
  800444:	53                   	push   %ebx
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	8b 55 08             	mov    0x8(%ebp),%edx
  80044b:	b8 12 00 00 00       	mov    $0x12,%eax
  800450:	bf 00 00 00 00       	mov    $0x0,%edi
  800455:	89 f9                	mov    %edi,%ecx
  800457:	89 fb                	mov    %edi,%ebx
  800459:	89 fe                	mov    %edi,%esi
  80045b:	cd 30                	int    $0x30
  80045d:	85 c0                	test   %eax,%eax
  80045f:	7e 17                	jle    800478 <sys_receive_packet_zerocopy+0x39>
  800461:	83 ec 0c             	sub    $0xc,%esp
  800464:	50                   	push   %eax
  800465:	6a 12                	push   $0x12
  800467:	68 fc 23 80 00       	push   $0x8023fc
  80046c:	6a 23                	push   $0x23
  80046e:	68 19 24 80 00       	push   $0x802419
  800473:	e8 90 11 00 00       	call   801608 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800478:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80047b:	5b                   	pop    %ebx
  80047c:	5e                   	pop    %esi
  80047d:	5f                   	pop    %edi
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    

00800480 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	57                   	push   %edi
  800484:	56                   	push   %esi
  800485:	53                   	push   %ebx
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	8b 55 08             	mov    0x8(%ebp),%edx
  80048c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048f:	b8 13 00 00 00       	mov    $0x13,%eax
  800494:	bf 00 00 00 00       	mov    $0x0,%edi
  800499:	89 fb                	mov    %edi,%ebx
  80049b:	89 fe                	mov    %edi,%esi
  80049d:	cd 30                	int    $0x30
  80049f:	85 c0                	test   %eax,%eax
  8004a1:	7e 17                	jle    8004ba <sys_env_set_priority+0x3a>
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	50                   	push   %eax
  8004a7:	6a 13                	push   $0x13
  8004a9:	68 fc 23 80 00       	push   $0x8023fc
  8004ae:	6a 23                	push   $0x23
  8004b0:	68 19 24 80 00       	push   $0x802419
  8004b5:	e8 4e 11 00 00       	call   801608 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8004ba:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8004bd:	5b                   	pop    %ebx
  8004be:	5e                   	pop    %esi
  8004bf:	5f                   	pop    %edi
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    
	...

008004c4 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8004ca:	ff 75 08             	pushl  0x8(%ebp)
  8004cd:	e8 0a 00 00 00       	call   8004dc <fd2num>
  8004d2:	c1 e0 16             	shl    $0x16,%eax
  8004d5:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <fd2num>:

int
fd2num(struct Fd *fd)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	05 00 00 40 30       	add    $0x30400000,%eax
  8004e7:	c1 e8 0c             	shr    $0xc,%eax
}
  8004ea:	c9                   	leave  
  8004eb:	c3                   	ret    

008004ec <fd_alloc>:

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
  8004ec:	55                   	push   %ebp
  8004ed:	89 e5                	mov    %esp,%ebp
  8004ef:	57                   	push   %edi
  8004f0:	56                   	push   %esi
  8004f1:	53                   	push   %ebx
  8004f2:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8004f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004fa:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  8004ff:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  800504:	89 c8                	mov    %ecx,%eax
  800506:	c1 e0 0c             	shl    $0xc,%eax
  800509:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  80050f:	89 d0                	mov    %edx,%eax
  800511:	c1 e8 16             	shr    $0x16,%eax
  800514:	8b 04 86             	mov    (%esi,%eax,4),%eax
  800517:	a8 01                	test   $0x1,%al
  800519:	74 0c                	je     800527 <fd_alloc+0x3b>
  80051b:	89 d0                	mov    %edx,%eax
  80051d:	c1 e8 0c             	shr    $0xc,%eax
  800520:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  800523:	a8 01                	test   $0x1,%al
  800525:	75 09                	jne    800530 <fd_alloc+0x44>
			*fd_store = fd;
  800527:	89 17                	mov    %edx,(%edi)
			return 0;
  800529:	b8 00 00 00 00       	mov    $0x0,%eax
  80052e:	eb 11                	jmp    800541 <fd_alloc+0x55>
  800530:	41                   	inc    %ecx
  800531:	83 f9 1f             	cmp    $0x1f,%ecx
  800534:	7e ce                	jle    800504 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  800536:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  80053c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800541:	5b                   	pop    %ebx
  800542:	5e                   	pop    %esi
  800543:	5f                   	pop    %edi
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80054c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800551:	83 f8 1f             	cmp    $0x1f,%eax
  800554:	77 3a                	ja     800590 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  800556:	c1 e0 0c             	shl    $0xc,%eax
  800559:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  80055f:	89 d0                	mov    %edx,%eax
  800561:	c1 e8 16             	shr    $0x16,%eax
  800564:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80056b:	a8 01                	test   $0x1,%al
  80056d:	74 10                	je     80057f <fd_lookup+0x39>
  80056f:	89 d0                	mov    %edx,%eax
  800571:	c1 e8 0c             	shr    $0xc,%eax
  800574:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80057b:	a8 01                	test   $0x1,%al
  80057d:	75 07                	jne    800586 <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80057f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800584:	eb 0a                	jmp    800590 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  800586:	8b 45 0c             	mov    0xc(%ebp),%eax
  800589:	89 10                	mov    %edx,(%eax)
	return 0;
  80058b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800590:	89 d0                	mov    %edx,%eax
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <fd_close>:

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
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
  800599:	83 ec 10             	sub    $0x10,%esp
  80059c:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80059f:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8005a2:	50                   	push   %eax
  8005a3:	56                   	push   %esi
  8005a4:	e8 33 ff ff ff       	call   8004dc <fd2num>
  8005a9:	89 04 24             	mov    %eax,(%esp)
  8005ac:	e8 95 ff ff ff       	call   800546 <fd_lookup>
  8005b1:	89 c3                	mov    %eax,%ebx
  8005b3:	83 c4 08             	add    $0x8,%esp
  8005b6:	85 c0                	test   %eax,%eax
  8005b8:	78 05                	js     8005bf <fd_close+0x2b>
  8005ba:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8005bd:	74 0f                	je     8005ce <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8005bf:	89 d8                	mov    %ebx,%eax
  8005c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c5:	75 3a                	jne    800601 <fd_close+0x6d>
  8005c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cc:	eb 33                	jmp    800601 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8005d4:	50                   	push   %eax
  8005d5:	ff 36                	pushl  (%esi)
  8005d7:	e8 2c 00 00 00       	call   800608 <dev_lookup>
  8005dc:	89 c3                	mov    %eax,%ebx
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	85 c0                	test   %eax,%eax
  8005e3:	78 0f                	js     8005f4 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8005e5:	83 ec 0c             	sub    $0xc,%esp
  8005e8:	56                   	push   %esi
  8005e9:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8005ec:	ff 50 10             	call   *0x10(%eax)
  8005ef:	89 c3                	mov    %eax,%ebx
  8005f1:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	56                   	push   %esi
  8005f8:	6a 00                	push   $0x0
  8005fa:	e8 f0 fb ff ff       	call   8001ef <sys_page_unmap>
	return r;
  8005ff:	89 d8                	mov    %ebx,%eax
}
  800601:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800604:	5b                   	pop    %ebx
  800605:	5e                   	pop    %esi
  800606:	c9                   	leave  
  800607:	c3                   	ret    

00800608 <dev_lookup>:


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
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  80060b:	56                   	push   %esi
  80060c:	53                   	push   %ebx
  80060d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800610:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  80061f:	74 1c                	je     80063d <dev_lookup+0x35>
  800621:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  800626:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  800629:	39 18                	cmp    %ebx,(%eax)
  80062b:	75 09                	jne    800636 <dev_lookup+0x2e>
			*dev = devtab[i];
  80062d:	89 06                	mov    %eax,(%esi)
			return 0;
  80062f:	b8 00 00 00 00       	mov    $0x0,%eax
  800634:	eb 29                	jmp    80065f <dev_lookup+0x57>
  800636:	42                   	inc    %edx
  800637:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80063b:	75 e9                	jne    800626 <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	53                   	push   %ebx
  800641:	a1 80 60 80 00       	mov    0x806080,%eax
  800646:	8b 40 4c             	mov    0x4c(%eax),%eax
  800649:	50                   	push   %eax
  80064a:	68 28 24 80 00       	push   $0x802428
  80064f:	e8 a4 10 00 00       	call   8016f8 <cprintf>
	*dev = 0;
  800654:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80065a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80065f:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800662:	5b                   	pop    %ebx
  800663:	5e                   	pop    %esi
  800664:	c9                   	leave  
  800665:	c3                   	ret    

00800666 <close>:

int
close(int fdnum)
{
  800666:	55                   	push   %ebp
  800667:	89 e5                	mov    %esp,%ebp
  800669:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80066c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80066f:	50                   	push   %eax
  800670:	ff 75 08             	pushl  0x8(%ebp)
  800673:	e8 ce fe ff ff       	call   800546 <fd_lookup>
  800678:	83 c4 08             	add    $0x8,%esp
		return r;
  80067b:	89 c2                	mov    %eax,%edx
  80067d:	85 c0                	test   %eax,%eax
  80067f:	78 0f                	js     800690 <close+0x2a>
	else
		return fd_close(fd, 1);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	6a 01                	push   $0x1
  800686:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  800689:	e8 06 ff ff ff       	call   800594 <fd_close>
  80068e:	89 c2                	mov    %eax,%edx
}
  800690:	89 d0                	mov    %edx,%eax
  800692:	c9                   	leave  
  800693:	c3                   	ret    

00800694 <close_all>:

void
close_all(void)
{
  800694:	55                   	push   %ebp
  800695:	89 e5                	mov    %esp,%ebp
  800697:	53                   	push   %ebx
  800698:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80069b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	e8 bd ff ff ff       	call   800666 <close>
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	43                   	inc    %ebx
  8006ad:	83 fb 1f             	cmp    $0x1f,%ebx
  8006b0:	7e ee                	jle    8006a0 <close_all+0xc>
}
  8006b2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	57                   	push   %edi
  8006bb:	56                   	push   %esi
  8006bc:	53                   	push   %ebx
  8006bd:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006c0:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8006c3:	50                   	push   %eax
  8006c4:	ff 75 08             	pushl  0x8(%ebp)
  8006c7:	e8 7a fe ff ff       	call   800546 <fd_lookup>
  8006cc:	89 c6                	mov    %eax,%esi
  8006ce:	83 c4 08             	add    $0x8,%esp
  8006d1:	85 f6                	test   %esi,%esi
  8006d3:	0f 88 f8 00 00 00    	js     8007d1 <dup+0x11a>
		return r;
	close(newfdnum);
  8006d9:	83 ec 0c             	sub    $0xc,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	e8 82 ff ff ff       	call   800666 <close>

	newfd = INDEX2FD(newfdnum);
  8006e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e7:	c1 e0 0c             	shl    $0xc,%eax
  8006ea:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8006ef:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8006f2:	83 c4 04             	add    $0x4,%esp
  8006f5:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8006f8:	e8 c7 fd ff ff       	call   8004c4 <fd2data>
  8006fd:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8006ff:	83 c4 04             	add    $0x4,%esp
  800702:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800705:	e8 ba fd ff ff       	call   8004c4 <fd2data>
  80070a:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  80070d:	89 f8                	mov    %edi,%eax
  80070f:	c1 e8 16             	shr    $0x16,%eax
  800712:	83 c4 10             	add    $0x10,%esp
  800715:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80071c:	85 c0                	test   %eax,%eax
  80071e:	74 48                	je     800768 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  800720:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  800725:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  800728:	89 d0                	mov    %edx,%eax
  80072a:	c1 e8 0c             	shr    $0xc,%eax
  80072d:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  800734:	a8 01                	test   $0x1,%al
  800736:	74 22                	je     80075a <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	25 07 0e 00 00       	and    $0xe07,%eax
  800740:	50                   	push   %eax
  800741:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  800744:	01 d8                	add    %ebx,%eax
  800746:	50                   	push   %eax
  800747:	6a 00                	push   $0x0
  800749:	52                   	push   %edx
  80074a:	6a 00                	push   $0x0
  80074c:	e8 5c fa ff ff       	call   8001ad <sys_page_map>
  800751:	89 c6                	mov    %eax,%esi
  800753:	83 c4 20             	add    $0x20,%esp
  800756:	85 c0                	test   %eax,%eax
  800758:	78 3f                	js     800799 <dup+0xe2>
  80075a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800760:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  800766:	7e bd                	jle    800725 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800768:	83 ec 0c             	sub    $0xc,%esp
  80076b:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80076e:	89 d0                	mov    %edx,%eax
  800770:	c1 e8 0c             	shr    $0xc,%eax
  800773:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80077a:	25 07 0e 00 00       	and    $0xe07,%eax
  80077f:	50                   	push   %eax
  800780:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800783:	6a 00                	push   $0x0
  800785:	52                   	push   %edx
  800786:	6a 00                	push   $0x0
  800788:	e8 20 fa ff ff       	call   8001ad <sys_page_map>
  80078d:	89 c6                	mov    %eax,%esi
  80078f:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800792:	8b 45 0c             	mov    0xc(%ebp),%eax
  800795:	85 f6                	test   %esi,%esi
  800797:	79 38                	jns    8007d1 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80079f:	6a 00                	push   $0x0
  8007a1:	e8 49 fa ff ff       	call   8001ef <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8007a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ab:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	50                   	push   %eax
  8007b7:	6a 00                	push   $0x0
  8007b9:	e8 31 fa ff ff       	call   8001ef <sys_page_unmap>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8007c7:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8007cd:	7e df                	jle    8007ae <dup+0xf7>
	return r;
  8007cf:	89 f0                	mov    %esi,%eax
}
  8007d1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8007d4:	5b                   	pop    %ebx
  8007d5:	5e                   	pop    %esi
  8007d6:	5f                   	pop    %edi
  8007d7:	c9                   	leave  
  8007d8:	c3                   	ret    

008007d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007d9:	55                   	push   %ebp
  8007da:	89 e5                	mov    %esp,%ebp
  8007dc:	53                   	push   %ebx
  8007dd:	83 ec 14             	sub    $0x14,%esp
  8007e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e3:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	53                   	push   %ebx
  8007e8:	e8 59 fd ff ff       	call   800546 <fd_lookup>
  8007ed:	89 c2                	mov    %eax,%edx
  8007ef:	83 c4 08             	add    $0x8,%esp
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	78 1a                	js     800810 <read+0x37>
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8007fc:	50                   	push   %eax
  8007fd:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800800:	ff 30                	pushl  (%eax)
  800802:	e8 01 fe ff ff       	call   800608 <dev_lookup>
  800807:	89 c2                	mov    %eax,%edx
  800809:	83 c4 10             	add    $0x10,%esp
  80080c:	85 c0                	test   %eax,%eax
  80080e:	79 04                	jns    800814 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  800810:	89 d0                	mov    %edx,%eax
  800812:	eb 50                	jmp    800864 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800814:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800817:	8b 40 08             	mov    0x8(%eax),%eax
  80081a:	83 e0 03             	and    $0x3,%eax
  80081d:	83 f8 01             	cmp    $0x1,%eax
  800820:	75 1e                	jne    800840 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	53                   	push   %ebx
  800826:	a1 80 60 80 00       	mov    0x806080,%eax
  80082b:	8b 40 4c             	mov    0x4c(%eax),%eax
  80082e:	50                   	push   %eax
  80082f:	68 69 24 80 00       	push   $0x802469
  800834:	e8 bf 0e 00 00       	call   8016f8 <cprintf>
		return -E_INVAL;
  800839:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083e:	eb 24                	jmp    800864 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  800840:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800843:	ff 70 04             	pushl  0x4(%eax)
  800846:	ff 75 10             	pushl  0x10(%ebp)
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	50                   	push   %eax
  80084d:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800850:	ff 50 08             	call   *0x8(%eax)
  800853:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	85 c0                	test   %eax,%eax
  80085a:	78 06                	js     800862 <read+0x89>
		fd->fd_offset += r;
  80085c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80085f:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  800862:	89 d0                	mov    %edx,%eax
}
  800864:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800867:	c9                   	leave  
  800868:	c3                   	ret    

00800869 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	57                   	push   %edi
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	83 ec 0c             	sub    $0xc,%esp
  800872:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800875:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800878:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087d:	39 f3                	cmp    %esi,%ebx
  80087f:	73 25                	jae    8008a6 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800881:	83 ec 04             	sub    $0x4,%esp
  800884:	89 f0                	mov    %esi,%eax
  800886:	29 d8                	sub    %ebx,%eax
  800888:	50                   	push   %eax
  800889:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80088c:	50                   	push   %eax
  80088d:	ff 75 08             	pushl  0x8(%ebp)
  800890:	e8 44 ff ff ff       	call   8007d9 <read>
		if (m < 0)
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	85 c0                	test   %eax,%eax
  80089a:	78 0c                	js     8008a8 <readn+0x3f>
			return m;
		if (m == 0)
  80089c:	85 c0                	test   %eax,%eax
  80089e:	74 06                	je     8008a6 <readn+0x3d>
  8008a0:	01 c3                	add    %eax,%ebx
  8008a2:	39 f3                	cmp    %esi,%ebx
  8008a4:	72 db                	jb     800881 <readn+0x18>
			break;
	}
	return tot;
  8008a6:	89 d8                	mov    %ebx,%eax
}
  8008a8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5f                   	pop    %edi
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	53                   	push   %ebx
  8008b4:	83 ec 14             	sub    $0x14,%esp
  8008b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008ba:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8008bd:	50                   	push   %eax
  8008be:	53                   	push   %ebx
  8008bf:	e8 82 fc ff ff       	call   800546 <fd_lookup>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	83 c4 08             	add    $0x8,%esp
  8008c9:	85 c0                	test   %eax,%eax
  8008cb:	78 1a                	js     8008e7 <write+0x37>
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8008d3:	50                   	push   %eax
  8008d4:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8008d7:	ff 30                	pushl  (%eax)
  8008d9:	e8 2a fd ff ff       	call   800608 <dev_lookup>
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	83 c4 10             	add    $0x10,%esp
  8008e3:	85 c0                	test   %eax,%eax
  8008e5:	79 04                	jns    8008eb <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8008e7:	89 d0                	mov    %edx,%eax
  8008e9:	eb 4b                	jmp    800936 <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008eb:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8008ee:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008f2:	75 1e                	jne    800912 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	a1 80 60 80 00       	mov    0x806080,%eax
  8008fd:	8b 40 4c             	mov    0x4c(%eax),%eax
  800900:	50                   	push   %eax
  800901:	68 85 24 80 00       	push   $0x802485
  800906:	e8 ed 0d 00 00       	call   8016f8 <cprintf>
		return -E_INVAL;
  80090b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800910:	eb 24                	jmp    800936 <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  800912:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800915:	ff 70 04             	pushl  0x4(%eax)
  800918:	ff 75 10             	pushl  0x10(%ebp)
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	50                   	push   %eax
  80091f:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800922:	ff 50 0c             	call   *0xc(%eax)
  800925:	89 c2                	mov    %eax,%edx
	if (r > 0)
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	85 c0                	test   %eax,%eax
  80092c:	7e 06                	jle    800934 <write+0x84>
		fd->fd_offset += r;
  80092e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800931:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  800934:	89 d0                	mov    %edx,%eax
}
  800936:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <seek>:

int
seek(int fdnum, off_t offset)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800941:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 f9 fb ff ff       	call   800546 <fd_lookup>
  80094d:	83 c4 08             	add    $0x8,%esp
		return r;
  800950:	89 c2                	mov    %eax,%edx
  800952:	85 c0                	test   %eax,%eax
  800954:	78 0e                	js     800964 <seek+0x29>
	fd->fd_offset = offset;
  800956:	8b 55 0c             	mov    0xc(%ebp),%edx
  800959:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80095c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80095f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800964:	89 d0                	mov    %edx,%eax
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	53                   	push   %ebx
  80096c:	83 ec 14             	sub    $0x14,%esp
  80096f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800972:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800975:	50                   	push   %eax
  800976:	53                   	push   %ebx
  800977:	e8 ca fb ff ff       	call   800546 <fd_lookup>
  80097c:	83 c4 08             	add    $0x8,%esp
  80097f:	85 c0                	test   %eax,%eax
  800981:	78 4e                	js     8009d1 <ftruncate+0x69>
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800989:	50                   	push   %eax
  80098a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80098d:	ff 30                	pushl  (%eax)
  80098f:	e8 74 fc ff ff       	call   800608 <dev_lookup>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	85 c0                	test   %eax,%eax
  800999:	78 36                	js     8009d1 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80099b:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80099e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009a2:	75 1e                	jne    8009c2 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	53                   	push   %ebx
  8009a8:	a1 80 60 80 00       	mov    0x806080,%eax
  8009ad:	8b 40 4c             	mov    0x4c(%eax),%eax
  8009b0:	50                   	push   %eax
  8009b1:	68 48 24 80 00       	push   $0x802448
  8009b6:	e8 3d 0d 00 00       	call   8016f8 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8009bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c0:	eb 0f                	jmp    8009d1 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8009cb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8009ce:	ff 50 1c             	call   *0x1c(%eax)
}
  8009d1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    

008009d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	53                   	push   %ebx
  8009da:	83 ec 14             	sub    $0x14,%esp
  8009dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009e0:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8009e3:	50                   	push   %eax
  8009e4:	ff 75 08             	pushl  0x8(%ebp)
  8009e7:	e8 5a fb ff ff       	call   800546 <fd_lookup>
  8009ec:	83 c4 08             	add    $0x8,%esp
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	78 42                	js     800a35 <fstat+0x5f>
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8009f9:	50                   	push   %eax
  8009fa:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8009fd:	ff 30                	pushl  (%eax)
  8009ff:	e8 04 fc ff ff       	call   800608 <dev_lookup>
  800a04:	83 c4 10             	add    $0x10,%esp
  800a07:	85 c0                	test   %eax,%eax
  800a09:	78 2a                	js     800a35 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  800a0b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a0e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a15:	00 00 00 
	stat->st_isdir = 0;
  800a18:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a1f:	00 00 00 
	stat->st_dev = dev;
  800a22:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800a25:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800a32:	ff 50 14             	call   *0x14(%eax)
}
  800a35:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	56                   	push   %esi
  800a3e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	6a 00                	push   $0x0
  800a44:	ff 75 08             	pushl  0x8(%ebp)
  800a47:	e8 28 00 00 00       	call   800a74 <open>
  800a4c:	89 c6                	mov    %eax,%esi
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	85 f6                	test   %esi,%esi
  800a53:	78 18                	js     800a6d <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	56                   	push   %esi
  800a5c:	e8 75 ff ff ff       	call   8009d6 <fstat>
  800a61:	89 c3                	mov    %eax,%ebx
	close(fd);
  800a63:	89 34 24             	mov    %esi,(%esp)
  800a66:	e8 fb fb ff ff       	call   800666 <close>
	return r;
  800a6b:	89 d8                	mov    %ebx,%eax
}
  800a6d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800a70:	5b                   	pop    %ebx
  800a71:	5e                   	pop    %esi
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	53                   	push   %ebx
  800a78:	83 ec 10             	sub    $0x10,%esp
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
  800a7b:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800a7e:	50                   	push   %eax
  800a7f:	e8 68 fa ff ff       	call   8004ec <fd_alloc>
  800a84:	89 c3                	mov    %eax,%ebx
  800a86:	83 c4 10             	add    $0x10,%esp
  800a89:	85 db                	test   %ebx,%ebx
  800a8b:	78 36                	js     800ac3 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  800a8d:	83 ec 04             	sub    $0x4,%esp
  800a90:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	ff 75 08             	pushl  0x8(%ebp)
  800a99:	e8 1b 05 00 00       	call   800fb9 <fsipc_open>
  800a9e:	89 c3                	mov    %eax,%ebx
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	85 c0                	test   %eax,%eax
  800aa5:	79 11                	jns    800ab8 <open+0x44>
          fd_close(fd_store, 0);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	6a 00                	push   $0x0
  800aac:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800aaf:	e8 e0 fa ff ff       	call   800594 <fd_close>
          return r;
  800ab4:	89 d8                	mov    %ebx,%eax
  800ab6:	eb 0b                	jmp    800ac3 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  800ab8:	83 ec 0c             	sub    $0xc,%esp
  800abb:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800abe:	e8 19 fa ff ff       	call   8004dc <fd2num>
}
  800ac3:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	53                   	push   %ebx
  800acc:	83 ec 04             	sub    $0x4,%esp
  800acf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  800ad2:	6a 01                	push   $0x1
  800ad4:	6a 00                	push   $0x0
  800ad6:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  800adc:	53                   	push   %ebx
  800add:	e8 e7 03 00 00       	call   800ec9 <funmap>
  800ae2:	83 c4 10             	add    $0x10,%esp
          return r;
  800ae5:	89 c2                	mov    %eax,%edx
  800ae7:	85 c0                	test   %eax,%eax
  800ae9:	78 19                	js     800b04 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  800aeb:	83 ec 0c             	sub    $0xc,%esp
  800aee:	ff 73 0c             	pushl  0xc(%ebx)
  800af1:	e8 68 05 00 00       	call   80105e <fsipc_close>
  800af6:	83 c4 10             	add    $0x10,%esp
          return r;
  800af9:	89 c2                	mov    %eax,%edx
  800afb:	85 c0                	test   %eax,%eax
  800afd:	78 05                	js     800b04 <file_close+0x3c>
        }
        return 0;
  800aff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b04:	89 d0                	mov    %edx,%eax
  800b06:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	57                   	push   %edi
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
  800b11:	83 ec 0c             	sub    $0xc,%esp
  800b14:	8b 75 10             	mov    0x10(%ebp),%esi
  800b17:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  800b23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b28:	39 d7                	cmp    %edx,%edi
  800b2a:	0f 87 95 00 00 00    	ja     800bc5 <file_read+0xba>
	if (offset + n > size)
  800b30:	8d 04 37             	lea    (%edi,%esi,1),%eax
  800b33:	39 d0                	cmp    %edx,%eax
  800b35:	76 04                	jbe    800b3b <file_read+0x30>
		n = size - offset;
  800b37:	89 d6                	mov    %edx,%esi
  800b39:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  800b3b:	83 ec 0c             	sub    $0xc,%esp
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 7e f9 ff ff       	call   8004c4 <fd2data>
  800b46:	89 c3                	mov    %eax,%ebx
  800b48:	01 fb                	add    %edi,%ebx
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	eb 41                	jmp    800b90 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  800b4f:	89 d8                	mov    %ebx,%eax
  800b51:	c1 e8 16             	shr    $0x16,%eax
  800b54:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800b5b:	a8 01                	test   $0x1,%al
  800b5d:	74 10                	je     800b6f <file_read+0x64>
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	c1 e8 0c             	shr    $0xc,%eax
  800b64:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800b6b:	a8 01                	test   $0x1,%al
  800b6d:	75 1b                	jne    800b8a <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	8d 04 37             	lea    (%edi,%esi,1),%eax
  800b75:	50                   	push   %eax
  800b76:	57                   	push   %edi
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 d4 02 00 00       	call   800e53 <fmap>
  800b7f:	83 c4 10             	add    $0x10,%esp
              return r;
  800b82:	89 c1                	mov    %eax,%ecx
  800b84:	85 c0                	test   %eax,%eax
  800b86:	78 3d                	js     800bc5 <file_read+0xba>
  800b88:	eb 1c                	jmp    800ba6 <file_read+0x9b>
  800b8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800b90:	83 ec 0c             	sub    $0xc,%esp
  800b93:	ff 75 08             	pushl  0x8(%ebp)
  800b96:	e8 29 f9 ff ff       	call   8004c4 <fd2data>
  800b9b:	01 f8                	add    %edi,%eax
  800b9d:	01 f0                	add    %esi,%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
  800ba2:	39 d8                	cmp    %ebx,%eax
  800ba4:	77 a9                	ja     800b4f <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  800ba6:	83 ec 04             	sub    $0x4,%esp
  800ba9:	56                   	push   %esi
  800baa:	83 ec 04             	sub    $0x4,%esp
  800bad:	ff 75 08             	pushl  0x8(%ebp)
  800bb0:	e8 0f f9 ff ff       	call   8004c4 <fd2data>
  800bb5:	83 c4 08             	add    $0x8,%esp
  800bb8:	01 f8                	add    %edi,%eax
  800bba:	50                   	push   %eax
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	e8 b5 12 00 00       	call   801e78 <memmove>
	return n;
  800bc3:	89 f1                	mov    %esi,%ecx
}
  800bc5:	89 c8                	mov    %ecx,%eax
  800bc7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800bca:	5b                   	pop    %ebx
  800bcb:	5e                   	pop    %esi
  800bcc:	5f                   	pop    %edi
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 18             	sub    $0x18,%esp
  800bd7:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800bda:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800bdd:	50                   	push   %eax
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 60 f9 ff ff       	call   800546 <fd_lookup>
  800be6:	83 c4 10             	add    $0x10,%esp
		return r;
  800be9:	89 c2                	mov    %eax,%edx
  800beb:	85 c0                	test   %eax,%eax
  800bed:	0f 88 9f 00 00 00    	js     800c92 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  800bf3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  800bf6:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  800bf8:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800bfd:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  800c03:	0f 85 89 00 00 00    	jne    800c92 <read_map+0xc3>
	va = fd2data(fd) + offset;
  800c09:	83 ec 0c             	sub    $0xc,%esp
  800c0c:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  800c0f:	e8 b0 f8 ff ff       	call   8004c4 <fd2data>
  800c14:	89 c3                	mov    %eax,%ebx
  800c16:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  800c18:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  800c1b:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  800c20:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  800c26:	7f 6a                	jg     800c92 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  800c28:	89 d8                	mov    %ebx,%eax
  800c2a:	c1 e8 16             	shr    $0x16,%eax
  800c2d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800c34:	a8 01                	test   $0x1,%al
  800c36:	74 10                	je     800c48 <read_map+0x79>
  800c38:	89 d8                	mov    %ebx,%eax
  800c3a:	c1 e8 0c             	shr    $0xc,%eax
  800c3d:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800c44:	a8 01                	test   $0x1,%al
  800c46:	75 19                	jne    800c61 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  800c48:	83 ec 04             	sub    $0x4,%esp
  800c4b:	8d 46 01             	lea    0x1(%esi),%eax
  800c4e:	50                   	push   %eax
  800c4f:	56                   	push   %esi
  800c50:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  800c53:	e8 fb 01 00 00       	call   800e53 <fmap>
  800c58:	83 c4 10             	add    $0x10,%esp
            return r;
  800c5b:	89 c2                	mov    %eax,%edx
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	78 31                	js     800c92 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  800c61:	89 d8                	mov    %ebx,%eax
  800c63:	c1 e8 16             	shr    $0x16,%eax
  800c66:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800c6d:	a8 01                	test   $0x1,%al
  800c6f:	74 10                	je     800c81 <read_map+0xb2>
  800c71:	89 d8                	mov    %ebx,%eax
  800c73:	c1 e8 0c             	shr    $0xc,%eax
  800c76:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800c7d:	a8 01                	test   $0x1,%al
  800c7f:	75 07                	jne    800c88 <read_map+0xb9>
		return -E_NO_DISK;
  800c81:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  800c86:	eb 0a                	jmp    800c92 <read_map+0xc3>

	*blk = (void*) va;
  800c88:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8b:	89 18                	mov    %ebx,(%eax)
	return 0;
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c92:	89 d0                	mov    %edx,%eax
  800c94:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
  800ca4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca7:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  800caa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cad:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  800cb0:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  800cb5:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800cbb:	0f 87 bd 00 00 00    	ja     800d7e <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  800cc1:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  800cc7:	73 17                	jae    800ce0 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	52                   	push   %edx
  800ccd:	56                   	push   %esi
  800cce:	e8 fb 00 00 00       	call   800dce <file_trunc>
  800cd3:	83 c4 10             	add    $0x10,%esp
			return r;
  800cd6:	89 c1                	mov    %eax,%ecx
  800cd8:	85 c0                	test   %eax,%eax
  800cda:	0f 88 9e 00 00 00    	js     800d7e <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  800ce0:	83 ec 0c             	sub    $0xc,%esp
  800ce3:	56                   	push   %esi
  800ce4:	e8 db f7 ff ff       	call   8004c4 <fd2data>
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	01 fb                	add    %edi,%ebx
  800ced:	83 c4 10             	add    $0x10,%esp
  800cf0:	eb 42                	jmp    800d34 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  800cf2:	89 d8                	mov    %ebx,%eax
  800cf4:	c1 e8 16             	shr    $0x16,%eax
  800cf7:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800cfe:	a8 01                	test   $0x1,%al
  800d00:	74 10                	je     800d12 <file_write+0x77>
  800d02:	89 d8                	mov    %ebx,%eax
  800d04:	c1 e8 0c             	shr    $0xc,%eax
  800d07:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800d0e:	a8 01                	test   $0x1,%al
  800d10:	75 1c                	jne    800d2e <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  800d12:	83 ec 04             	sub    $0x4,%esp
  800d15:	8b 55 10             	mov    0x10(%ebp),%edx
  800d18:	8d 04 17             	lea    (%edi,%edx,1),%eax
  800d1b:	50                   	push   %eax
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	e8 30 01 00 00       	call   800e53 <fmap>
  800d23:	83 c4 10             	add    $0x10,%esp
              return r;
  800d26:	89 c1                	mov    %eax,%ecx
  800d28:	85 c0                	test   %eax,%eax
  800d2a:	78 52                	js     800d7e <file_write+0xe3>
  800d2c:	eb 1b                	jmp    800d49 <file_write+0xae>
  800d2e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
  800d37:	56                   	push   %esi
  800d38:	e8 87 f7 ff ff       	call   8004c4 <fd2data>
  800d3d:	01 f8                	add    %edi,%eax
  800d3f:	03 45 10             	add    0x10(%ebp),%eax
  800d42:	83 c4 10             	add    $0x10,%esp
  800d45:	39 d8                	cmp    %ebx,%eax
  800d47:	77 a9                	ja     800cf2 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	68 a2 24 80 00       	push   $0x8024a2
  800d51:	e8 a2 09 00 00       	call   8016f8 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  800d56:	83 c4 0c             	add    $0xc,%esp
  800d59:	ff 75 10             	pushl  0x10(%ebp)
  800d5c:	ff 75 0c             	pushl  0xc(%ebp)
  800d5f:	56                   	push   %esi
  800d60:	e8 5f f7 ff ff       	call   8004c4 <fd2data>
  800d65:	01 f8                	add    %edi,%eax
  800d67:	89 04 24             	mov    %eax,(%esp)
  800d6a:	e8 09 11 00 00       	call   801e78 <memmove>
        cprintf("write done\n");
  800d6f:	c7 04 24 af 24 80 00 	movl   $0x8024af,(%esp)
  800d76:	e8 7d 09 00 00       	call   8016f8 <cprintf>
	return n;
  800d7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  800d7e:	89 c8                	mov    %ecx,%eax
  800d80:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d90:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	8d 43 10             	lea    0x10(%ebx),%eax
  800d99:	50                   	push   %eax
  800d9a:	56                   	push   %esi
  800d9b:	e8 5c 0f 00 00       	call   801cfc <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  800da0:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  800da6:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  800dac:	83 c4 10             	add    $0x10,%esp
  800daf:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  800db6:	0f 94 c0             	sete   %al
  800db9:	0f b6 c0             	movzbl %al,%eax
  800dbc:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc7:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	8b 75 08             	mov    0x8(%ebp),%esi
  800dda:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  800ddd:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  800de2:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  800de8:	7f 5f                	jg     800e49 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  800dea:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	53                   	push   %ebx
  800df4:	ff 76 0c             	pushl  0xc(%esi)
  800df7:	e8 3a 02 00 00       	call   801036 <fsipc_set_size>
  800dfc:	83 c4 10             	add    $0x10,%esp
		return r;
  800dff:	89 c2                	mov    %eax,%edx
  800e01:	85 c0                	test   %eax,%eax
  800e03:	78 44                	js     800e49 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  800e05:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  800e0b:	74 19                	je     800e26 <file_trunc+0x58>
  800e0d:	68 dc 24 80 00       	push   $0x8024dc
  800e12:	68 bb 24 80 00       	push   $0x8024bb
  800e17:	68 dc 00 00 00       	push   $0xdc
  800e1c:	68 d0 24 80 00       	push   $0x8024d0
  800e21:	e8 e2 07 00 00       	call   801608 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  800e26:	83 ec 04             	sub    $0x4,%esp
  800e29:	53                   	push   %ebx
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	e8 22 00 00 00       	call   800e53 <fmap>
  800e31:	83 c4 10             	add    $0x10,%esp
		return r;
  800e34:	89 c2                	mov    %eax,%edx
  800e36:	85 c0                	test   %eax,%eax
  800e38:	78 0f                	js     800e49 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  800e3a:	6a 00                	push   $0x0
  800e3c:	53                   	push   %ebx
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	e8 85 00 00 00       	call   800ec9 <funmap>

	return 0;
  800e44:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e49:	89 d0                	mov    %edx,%eax
  800e4b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <fmap>:

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
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e5f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  800e62:	39 75 0c             	cmp    %esi,0xc(%ebp)
  800e65:	7d 55                	jge    800ebc <fmap+0x69>
          fma = fd2data(fd);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	57                   	push   %edi
  800e6b:	e8 54 f6 ff ff       	call   8004c4 <fd2data>
  800e70:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e7e:	89 c3                	mov    %eax,%ebx
  800e80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800e86:	39 f3                	cmp    %esi,%ebx
  800e88:	7d 32                	jge    800ebc <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  800e8a:	83 ec 04             	sub    $0x4,%esp
  800e8d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  800e90:	01 d8                	add    %ebx,%eax
  800e92:	50                   	push   %eax
  800e93:	53                   	push   %ebx
  800e94:	ff 77 0c             	pushl  0xc(%edi)
  800e97:	e8 6f 01 00 00       	call   80100b <fsipc_map>
  800e9c:	83 c4 10             	add    $0x10,%esp
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	79 0f                	jns    800eb2 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  800ea3:	6a 00                	push   $0x0
  800ea5:	ff 75 0c             	pushl  0xc(%ebp)
  800ea8:	53                   	push   %ebx
  800ea9:	57                   	push   %edi
  800eaa:	e8 1a 00 00 00       	call   800ec9 <funmap>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800eb8:	39 f3                	cmp    %esi,%ebx
  800eba:	7c ce                	jl     800e8a <fmap+0x37>
            }
          }
        }

        return 0;
}
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <funmap>:

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
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
  800ed2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ed5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  800ed8:	39 f3                	cmp    %esi,%ebx
  800eda:	0f 8d 80 00 00 00    	jge    800f60 <funmap+0x97>
          fma = fd2data(fd);
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	ff 75 08             	pushl  0x8(%ebp)
  800ee6:	e8 d9 f5 ff ff       	call   8004c4 <fd2data>
  800eeb:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  800eed:	83 c4 10             	add    $0x10,%esp
  800ef0:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800ef6:	89 c3                	mov    %eax,%ebx
  800ef8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800efe:	39 f3                	cmp    %esi,%ebx
  800f00:	7d 5e                	jge    800f60 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  800f02:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  800f05:	89 c2                	mov    %eax,%edx
  800f07:	c1 ea 0c             	shr    $0xc,%edx
  800f0a:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  800f11:	a8 01                	test   $0x1,%al
  800f13:	74 41                	je     800f56 <funmap+0x8d>
              if (dirty) {
  800f15:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  800f19:	74 21                	je     800f3c <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  800f1b:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  800f22:	a8 40                	test   $0x40,%al
  800f24:	74 16                	je     800f3c <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	53                   	push   %ebx
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	ff 70 0c             	pushl  0xc(%eax)
  800f30:	e8 49 01 00 00       	call   80107e <fsipc_dirty>
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	78 29                	js     800f65 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  800f42:	50                   	push   %eax
  800f43:	83 ec 04             	sub    $0x4,%esp
  800f46:	e8 e1 f1 ff ff       	call   80012c <sys_getenvid>
  800f4b:	89 04 24             	mov    %eax,(%esp)
  800f4e:	e8 9c f2 ff ff       	call   8001ef <sys_page_unmap>
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f5c:	39 f3                	cmp    %esi,%ebx
  800f5e:	7c a2                	jl     800f02 <funmap+0x39>
            }
          }
        }

        return 0;
  800f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f65:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5f                   	pop    %edi
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <remove>:

// Delete a file
int
remove(const char *path)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  800f73:	ff 75 08             	pushl  0x8(%ebp)
  800f76:	e8 2b 01 00 00       	call   8010a6 <fsipc_remove>
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    

00800f7d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  800f83:	e8 64 01 00 00       	call   8010ec <fsipc_sync>
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    
	...

00800f8c <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  800f92:	6a 07                	push   $0x7
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	ff 75 08             	pushl  0x8(%ebp)
  800f9a:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  800f9f:	50                   	push   %eax
  800fa0:	e8 ca 10 00 00       	call   80206f <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  800fa5:	83 c4 0c             	add    $0xc,%esp
  800fa8:	ff 75 14             	pushl  0x14(%ebp)
  800fab:	ff 75 10             	pushl  0x10(%ebp)
  800fae:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800fb1:	50                   	push   %eax
  800fb2:	e8 55 10 00 00       	call   80200c <ipc_recv>
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	56                   	push   %esi
  800fbd:	53                   	push   %ebx
  800fbe:	83 ec 1c             	sub    $0x1c,%esp
  800fc1:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  800fc4:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  800fc9:	56                   	push   %esi
  800fca:	e8 f1 0c 00 00       	call   801cc0 <strlen>
  800fcf:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  800fd2:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  800fd7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800fdc:	7f 24                	jg     801002 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  800fde:	83 ec 08             	sub    $0x8,%esp
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
  800fe3:	e8 14 0d 00 00       	call   801cfc <strcpy>
	req->req_omode = omode;
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  800ff1:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 10             	pushl  0x10(%ebp)
  800ff8:	53                   	push   %ebx
  800ff9:	6a 01                	push   $0x1
  800ffb:	e8 8c ff ff ff       	call   800f8c <fsipc>
  801000:	89 c2                	mov    %eax,%edx
}
  801002:	89 d0                	mov    %edx,%eax
  801004:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801021:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801024:	50                   	push   %eax
  801025:	ff 75 10             	pushl  0x10(%ebp)
  801028:	68 00 30 80 00       	push   $0x803000
  80102d:	6a 02                	push   $0x2
  80102f:	e8 58 ff ff ff       	call   800f8c <fsipc>

	//return -E_UNSPECIFIED;
}
  801034:	c9                   	leave  
  801035:	c3                   	ret    

00801036 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  80104c:	6a 00                	push   $0x0
  80104e:	6a 00                	push   $0x0
  801050:	68 00 30 80 00       	push   $0x803000
  801055:	6a 03                	push   $0x3
  801057:	e8 30 ff ff ff       	call   800f8c <fsipc>
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  80106c:	6a 00                	push   $0x0
  80106e:	6a 00                	push   $0x0
  801070:	68 00 30 80 00       	push   $0x803000
  801075:	6a 04                	push   $0x4
  801077:	e8 10 ff ff ff       	call   800f8c <fsipc>
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801094:	6a 00                	push   $0x0
  801096:	6a 00                	push   $0x0
  801098:	68 00 30 80 00       	push   $0x803000
  80109d:	6a 05                	push   $0x5
  80109f:	e8 e8 fe ff ff       	call   800f8c <fsipc>
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	56                   	push   %esi
  8010aa:	53                   	push   %ebx
  8010ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  8010ae:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	53                   	push   %ebx
  8010b7:	e8 04 0c 00 00       	call   801cc0 <strlen>
  8010bc:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8010bf:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8010c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8010c9:	7f 18                	jg     8010e3 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	53                   	push   %ebx
  8010cf:	56                   	push   %esi
  8010d0:	e8 27 0c 00 00       	call   801cfc <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8010d5:	6a 00                	push   $0x0
  8010d7:	6a 00                	push   $0x0
  8010d9:	56                   	push   %esi
  8010da:	6a 06                	push   $0x6
  8010dc:	e8 ab fe ff ff       	call   800f8c <fsipc>
  8010e1:	89 c2                	mov    %eax,%edx
}
  8010e3:	89 d0                	mov    %edx,%eax
  8010e5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	c9                   	leave  
  8010eb:	c3                   	ret    

008010ec <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	68 00 30 80 00       	push   $0x803000
  8010fb:	6a 07                	push   $0x7
  8010fd:	e8 8a fe ff ff       	call   800f8c <fsipc>
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <pipe>:
};

int
pipe(int pfd[2])
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	57                   	push   %edi
  801108:	56                   	push   %esi
  801109:	53                   	push   %ebx
  80110a:	83 ec 18             	sub    $0x18,%esp
  80110d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801110:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801113:	50                   	push   %eax
  801114:	e8 d3 f3 ff ff       	call   8004ec <fd_alloc>
  801119:	89 c3                	mov    %eax,%ebx
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	85 c0                	test   %eax,%eax
  801120:	0f 88 25 01 00 00    	js     80124b <pipe+0x147>
  801126:	83 ec 04             	sub    $0x4,%esp
  801129:	68 07 04 00 00       	push   $0x407
  80112e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801131:	6a 00                	push   $0x0
  801133:	e8 32 f0 ff ff       	call   80016a <sys_page_alloc>
  801138:	89 c3                	mov    %eax,%ebx
  80113a:	83 c4 10             	add    $0x10,%esp
  80113d:	85 c0                	test   %eax,%eax
  80113f:	0f 88 06 01 00 00    	js     80124b <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801145:	83 ec 0c             	sub    $0xc,%esp
  801148:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  80114b:	50                   	push   %eax
  80114c:	e8 9b f3 ff ff       	call   8004ec <fd_alloc>
  801151:	89 c3                	mov    %eax,%ebx
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	0f 88 dd 00 00 00    	js     80123b <pipe+0x137>
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	68 07 04 00 00       	push   $0x407
  801166:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801169:	6a 00                	push   $0x0
  80116b:	e8 fa ef ff ff       	call   80016a <sys_page_alloc>
  801170:	89 c3                	mov    %eax,%ebx
  801172:	83 c4 10             	add    $0x10,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	0f 88 be 00 00 00    	js     80123b <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801183:	e8 3c f3 ff ff       	call   8004c4 <fd2data>
  801188:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80118a:	83 c4 0c             	add    $0xc,%esp
  80118d:	68 07 04 00 00       	push   $0x407
  801192:	50                   	push   %eax
  801193:	6a 00                	push   $0x0
  801195:	e8 d0 ef ff ff       	call   80016a <sys_page_alloc>
  80119a:	89 c3                	mov    %eax,%ebx
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	0f 88 84 00 00 00    	js     80122b <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011a7:	83 ec 0c             	sub    $0xc,%esp
  8011aa:	68 07 04 00 00       	push   $0x407
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8011b5:	e8 0a f3 ff ff       	call   8004c4 <fd2data>
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	50                   	push   %eax
  8011be:	6a 00                	push   $0x0
  8011c0:	56                   	push   %esi
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 e5 ef ff ff       	call   8001ad <sys_page_map>
  8011c8:	89 c3                	mov    %eax,%ebx
  8011ca:	83 c4 20             	add    $0x20,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 4c                	js     80121d <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8011d1:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8011d7:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8011da:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8011dc:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8011df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8011e6:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8011ec:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8011ef:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8011f1:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8011f4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801201:	e8 d6 f2 ff ff       	call   8004dc <fd2num>
  801206:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80120e:	e8 c9 f2 ff ff       	call   8004dc <fd2num>
  801213:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801216:	b8 00 00 00 00       	mov    $0x0,%eax
  80121b:	eb 30                	jmp    80124d <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	56                   	push   %esi
  801221:	6a 00                	push   $0x0
  801223:	e8 c7 ef ff ff       	call   8001ef <sys_page_unmap>
  801228:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801231:	6a 00                	push   $0x0
  801233:	e8 b7 ef ff ff       	call   8001ef <sys_page_unmap>
  801238:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801241:	6a 00                	push   $0x0
  801243:	e8 a7 ef ff ff       	call   8001ef <sys_page_unmap>
  801248:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  80124b:	89 d8                	mov    %ebx,%eax
}
  80124d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801250:	5b                   	pop    %ebx
  801251:	5e                   	pop    %esi
  801252:	5f                   	pop    %edi
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	57                   	push   %edi
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801261:	a1 80 60 80 00       	mov    0x806080,%eax
  801266:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	ff 75 08             	pushl  0x8(%ebp)
  80126f:	e8 54 0e 00 00       	call   8020c8 <pageref>
  801274:	89 c3                	mov    %eax,%ebx
  801276:	89 3c 24             	mov    %edi,(%esp)
  801279:	e8 4a 0e 00 00       	call   8020c8 <pageref>
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	39 c3                	cmp    %eax,%ebx
  801283:	0f 94 c0             	sete   %al
  801286:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801289:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  80128f:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  801292:	39 c6                	cmp    %eax,%esi
  801294:	74 1b                	je     8012b1 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  801296:	83 fa 01             	cmp    $0x1,%edx
  801299:	75 c6                	jne    801261 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80129b:	6a 01                	push   $0x1
  80129d:	8b 41 58             	mov    0x58(%ecx),%eax
  8012a0:	50                   	push   %eax
  8012a1:	56                   	push   %esi
  8012a2:	68 04 25 80 00       	push   $0x802504
  8012a7:	e8 4c 04 00 00       	call   8016f8 <cprintf>
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	eb b0                	jmp    801261 <_pipeisclosed+0xc>
	}
}
  8012b1:	89 d0                	mov    %edx,%eax
  8012b3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c1:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8012c4:	50                   	push   %eax
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 79 f2 ff ff       	call   800546 <fd_lookup>
  8012cd:	83 c4 10             	add    $0x10,%esp
		return r;
  8012d0:	89 c2                	mov    %eax,%edx
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 19                	js     8012ef <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8012d6:	83 ec 0c             	sub    $0xc,%esp
  8012d9:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8012dc:	e8 e3 f1 ff ff       	call   8004c4 <fd2data>
	return _pipeisclosed(fd, p);
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	50                   	push   %eax
  8012e5:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8012e8:	e8 68 ff ff ff       	call   801255 <_pipeisclosed>
  8012ed:	89 c2                	mov    %eax,%edx
}
  8012ef:	89 d0                	mov    %edx,%eax
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	57                   	push   %edi
  8012f7:	56                   	push   %esi
  8012f8:	53                   	push   %ebx
  8012f9:	83 ec 18             	sub    $0x18,%esp
  8012fc:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  8012ff:	57                   	push   %edi
  801300:	e8 bf f1 ff ff       	call   8004c4 <fd2data>
  801305:	89 c3                	mov    %eax,%ebx
	if (debug)
  801307:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80130a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130d:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801310:	be 00 00 00 00       	mov    $0x0,%esi
  801315:	3b 75 10             	cmp    0x10(%ebp),%esi
  801318:	73 55                	jae    80136f <piperead+0x7c>
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
  80131a:	8b 03                	mov    (%ebx),%eax
  80131c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80131f:	75 2c                	jne    80134d <piperead+0x5a>
  801321:	85 f6                	test   %esi,%esi
  801323:	74 04                	je     801329 <piperead+0x36>
  801325:	89 f0                	mov    %esi,%eax
  801327:	eb 48                	jmp    801371 <piperead+0x7e>
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	53                   	push   %ebx
  80132d:	57                   	push   %edi
  80132e:	e8 22 ff ff ff       	call   801255 <_pipeisclosed>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	74 07                	je     801341 <piperead+0x4e>
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
  80133f:	eb 30                	jmp    801371 <piperead+0x7e>
  801341:	e8 05 ee ff ff       	call   80014b <sys_yield>
  801346:	8b 03                	mov    (%ebx),%eax
  801348:	3b 43 04             	cmp    0x4(%ebx),%eax
  80134b:	74 d4                	je     801321 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80134d:	8b 13                	mov    (%ebx),%edx
  80134f:	89 d0                	mov    %edx,%eax
  801351:	85 d2                	test   %edx,%edx
  801353:	79 03                	jns    801358 <piperead+0x65>
  801355:	8d 42 1f             	lea    0x1f(%edx),%eax
  801358:	83 e0 e0             	and    $0xffffffe0,%eax
  80135b:	29 c2                	sub    %eax,%edx
  80135d:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801361:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801364:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801367:	ff 03                	incl   (%ebx)
  801369:	46                   	inc    %esi
  80136a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80136d:	72 ab                	jb     80131a <piperead+0x27>
	}
	return i;
  80136f:	89 f0                	mov    %esi,%eax
}
  801371:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801374:	5b                   	pop    %ebx
  801375:	5e                   	pop    %esi
  801376:	5f                   	pop    %edi
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	57                   	push   %edi
  80137d:	56                   	push   %esi
  80137e:	53                   	push   %ebx
  80137f:	83 ec 18             	sub    $0x18,%esp
  801382:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  801385:	57                   	push   %edi
  801386:	e8 39 f1 ff ff       	call   8004c4 <fd2data>
  80138b:	89 c3                	mov    %eax,%ebx
	if (debug)
  80138d:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801390:	8b 45 0c             	mov    0xc(%ebp),%eax
  801393:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801396:	be 00 00 00 00       	mov    $0x0,%esi
  80139b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80139e:	73 55                	jae    8013f5 <pipewrite+0x7c>
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
  8013a0:	8b 03                	mov    (%ebx),%eax
  8013a2:	83 c0 20             	add    $0x20,%eax
  8013a5:	39 43 04             	cmp    %eax,0x4(%ebx)
  8013a8:	72 27                	jb     8013d1 <pipewrite+0x58>
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	53                   	push   %ebx
  8013ae:	57                   	push   %edi
  8013af:	e8 a1 fe ff ff       	call   801255 <_pipeisclosed>
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 07                	je     8013c2 <pipewrite+0x49>
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c0:	eb 35                	jmp    8013f7 <pipewrite+0x7e>
  8013c2:	e8 84 ed ff ff       	call   80014b <sys_yield>
  8013c7:	8b 03                	mov    (%ebx),%eax
  8013c9:	83 c0 20             	add    $0x20,%eax
  8013cc:	39 43 04             	cmp    %eax,0x4(%ebx)
  8013cf:	73 d9                	jae    8013aa <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8013d1:	8b 53 04             	mov    0x4(%ebx),%edx
  8013d4:	89 d0                	mov    %edx,%eax
  8013d6:	85 d2                	test   %edx,%edx
  8013d8:	79 03                	jns    8013dd <pipewrite+0x64>
  8013da:	8d 42 1f             	lea    0x1f(%edx),%eax
  8013dd:	83 e0 e0             	and    $0xffffffe0,%eax
  8013e0:	29 c2                	sub    %eax,%edx
  8013e2:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8013e5:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8013e8:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8013ec:	ff 43 04             	incl   0x4(%ebx)
  8013ef:	46                   	inc    %esi
  8013f0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013f3:	72 ab                	jb     8013a0 <pipewrite+0x27>
	}
	
	return i;
  8013f5:	89 f0                	mov    %esi,%eax
}
  8013f7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5f                   	pop    %edi
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801407:	83 ec 0c             	sub    $0xc,%esp
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	e8 b2 f0 ff ff       	call   8004c4 <fd2data>
  801412:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801414:	83 c4 08             	add    $0x8,%esp
  801417:	68 17 25 80 00       	push   $0x802517
  80141c:	53                   	push   %ebx
  80141d:	e8 da 08 00 00       	call   801cfc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801422:	8b 46 04             	mov    0x4(%esi),%eax
  801425:	2b 06                	sub    (%esi),%eax
  801427:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80142d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801434:	00 00 00 
	stat->st_dev = &devpipe;
  801437:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  80143e:	60 80 00 
	return 0;
}
  801441:	b8 00 00 00 00       	mov    $0x0,%eax
  801446:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801449:	5b                   	pop    %ebx
  80144a:	5e                   	pop    %esi
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	53                   	push   %ebx
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801457:	53                   	push   %ebx
  801458:	6a 00                	push   $0x0
  80145a:	e8 90 ed ff ff       	call   8001ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80145f:	89 1c 24             	mov    %ebx,(%esp)
  801462:	e8 5d f0 ff ff       	call   8004c4 <fd2data>
  801467:	83 c4 08             	add    $0x8,%esp
  80146a:	50                   	push   %eax
  80146b:	6a 00                	push   $0x0
  80146d:	e8 7d ed ff ff       	call   8001ef <sys_page_unmap>
}
  801472:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801475:	c9                   	leave  
  801476:	c3                   	ret    
	...

00801478 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801484:	6a 01                	push   $0x1
  801486:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801489:	50                   	push   %eax
  80148a:	e8 19 ec ff ff       	call   8000a8 <sys_cputs>
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <getchar>:

int
getchar(void)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801497:	6a 01                	push   $0x1
  801499:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  80149c:	50                   	push   %eax
  80149d:	6a 00                	push   $0x0
  80149f:	e8 35 f3 ff ff       	call   8007d9 <read>
	if (r < 0)
  8014a4:	83 c4 10             	add    $0x10,%esp
		return r;
  8014a7:	89 c2                	mov    %eax,%edx
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 0d                	js     8014ba <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8014ad:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	7e 04                	jle    8014ba <getchar+0x29>
	return c;
  8014b6:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  8014ba:	89 d0                	mov    %edx,%eax
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <iscons>:


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
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014c4:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8014c7:	50                   	push   %eax
  8014c8:	ff 75 08             	pushl  0x8(%ebp)
  8014cb:	e8 76 f0 ff ff       	call   800546 <fd_lookup>
  8014d0:	83 c4 10             	add    $0x10,%esp
		return r;
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	78 11                	js     8014ea <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8014d9:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  8014e4:	0f 94 c0             	sete   %al
  8014e7:	0f b6 d0             	movzbl %al,%edx
}
  8014ea:	89 d0                	mov    %edx,%eax
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <opencons>:

int
opencons(void)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8014f4:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8014f7:	50                   	push   %eax
  8014f8:	e8 ef ef ff ff       	call   8004ec <fd_alloc>
  8014fd:	83 c4 10             	add    $0x10,%esp
		return r;
  801500:	89 c2                	mov    %eax,%edx
  801502:	85 c0                	test   %eax,%eax
  801504:	78 3c                	js     801542 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801506:	83 ec 04             	sub    $0x4,%esp
  801509:	68 07 04 00 00       	push   $0x407
  80150e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801511:	6a 00                	push   $0x0
  801513:	e8 52 ec ff ff       	call   80016a <sys_page_alloc>
  801518:	83 c4 10             	add    $0x10,%esp
		return r;
  80151b:	89 c2                	mov    %eax,%edx
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 21                	js     801542 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801521:	a1 60 60 80 00       	mov    0x806060,%eax
  801526:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  801529:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80152b:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80152e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80153b:	e8 9c ef ff ff       	call   8004dc <fd2num>
  801540:	89 c2                	mov    %eax,%edx
}
  801542:	89 d0                	mov    %edx,%eax
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax
  801551:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801555:	74 2a                	je     801581 <cons_read+0x3b>
  801557:	eb 05                	jmp    80155e <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801559:	e8 ed eb ff ff       	call   80014b <sys_yield>
  80155e:	e8 69 eb ff ff       	call   8000cc <sys_cgetc>
  801563:	89 c2                	mov    %eax,%edx
  801565:	85 c0                	test   %eax,%eax
  801567:	74 f0                	je     801559 <cons_read+0x13>
	if (c < 0)
  801569:	85 d2                	test   %edx,%edx
  80156b:	78 14                	js     801581 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
  801572:	83 fa 04             	cmp    $0x4,%edx
  801575:	74 0a                	je     801581 <cons_read+0x3b>
	*(char*)vbuf = c;
  801577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157a:	88 10                	mov    %dl,(%eax)
	return 1;
  80157c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	57                   	push   %edi
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80158f:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801592:	be 00 00 00 00       	mov    $0x0,%esi
  801597:	39 fe                	cmp    %edi,%esi
  801599:	73 3d                	jae    8015d8 <cons_write+0x55>
		m = n - tot;
  80159b:	89 fb                	mov    %edi,%ebx
  80159d:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80159f:	83 fb 7f             	cmp    $0x7f,%ebx
  8015a2:	76 05                	jbe    8015a9 <cons_write+0x26>
			m = sizeof(buf) - 1;
  8015a4:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	53                   	push   %ebx
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	01 f0                	add    %esi,%eax
  8015b2:	50                   	push   %eax
  8015b3:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8015b9:	50                   	push   %eax
  8015ba:	e8 b9 08 00 00       	call   801e78 <memmove>
		sys_cputs(buf, m);
  8015bf:	83 c4 08             	add    $0x8,%esp
  8015c2:	53                   	push   %ebx
  8015c3:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8015c9:	50                   	push   %eax
  8015ca:	e8 d9 ea ff ff       	call   8000a8 <sys_cputs>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	01 de                	add    %ebx,%esi
  8015d4:	39 fe                	cmp    %edi,%esi
  8015d6:	72 c3                	jb     80159b <cons_write+0x18>
	}
	return tot;
}
  8015d8:	89 f0                	mov    %esi,%eax
  8015da:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <cons_close>:

int
cons_close(struct Fd *fd)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8015f2:	68 23 25 80 00       	push   $0x802523
  8015f7:	ff 75 0c             	pushl  0xc(%ebp)
  8015fa:	e8 fd 06 00 00       	call   801cfc <strcpy>
	return 0;
}
  8015ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801604:	c9                   	leave  
  801605:	c3                   	ret    
	...

00801608 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	53                   	push   %ebx
  80160c:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  80160f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  801612:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  801619:	74 16                	je     801631 <_panic+0x29>
		cprintf("%s: ", argv0);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	ff 35 84 60 80 00    	pushl  0x806084
  801624:	68 2a 25 80 00       	push   $0x80252a
  801629:	e8 ca 00 00 00       	call   8016f8 <cprintf>
  80162e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	ff 35 00 60 80 00    	pushl  0x806000
  80163d:	68 2f 25 80 00       	push   $0x80252f
  801642:	e8 b1 00 00 00       	call   8016f8 <cprintf>
	vcprintf(fmt, ap);
  801647:	83 c4 08             	add    $0x8,%esp
  80164a:	53                   	push   %ebx
  80164b:	ff 75 10             	pushl  0x10(%ebp)
  80164e:	e8 54 00 00 00       	call   8016a7 <vcprintf>
	cprintf("\n");
  801653:	c7 04 24 15 25 80 00 	movl   $0x802515,(%esp)
  80165a:	e8 99 00 00 00       	call   8016f8 <cprintf>

	// Cause a breakpoint exception
	while (1)
  80165f:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  801662:	cc                   	int3   
  801663:	eb fd                	jmp    801662 <_panic+0x5a>
  801665:	00 00                	add    %al,(%eax)
	...

00801668 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	53                   	push   %ebx
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801672:	8b 03                	mov    (%ebx),%eax
  801674:	8b 55 08             	mov    0x8(%ebp),%edx
  801677:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80167b:	40                   	inc    %eax
  80167c:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80167e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801683:	75 1a                	jne    80169f <putch+0x37>
		sys_cputs(b->buf, b->idx);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	68 ff 00 00 00       	push   $0xff
  80168d:	8d 43 08             	lea    0x8(%ebx),%eax
  801690:	50                   	push   %eax
  801691:	e8 12 ea ff ff       	call   8000a8 <sys_cputs>
		b->idx = 0;
  801696:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80169c:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80169f:	ff 43 04             	incl   0x4(%ebx)
}
  8016a2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016b0:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  8016b7:	00 00 00 
	b.cnt = 0;
  8016ba:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  8016c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  8016d0:	50                   	push   %eax
  8016d1:	68 68 16 80 00       	push   $0x801668
  8016d6:	e8 4f 01 00 00       	call   80182a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8016db:	83 c4 08             	add    $0x8,%esp
  8016de:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8016e4:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8016ea:	50                   	push   %eax
  8016eb:	e8 b8 e9 ff ff       	call   8000a8 <sys_cputs>

	return b.cnt;
  8016f0:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801701:	50                   	push   %eax
  801702:	ff 75 08             	pushl  0x8(%ebp)
  801705:	e8 9d ff ff ff       	call   8016a7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	57                   	push   %edi
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	8b 75 10             	mov    0x10(%ebp),%esi
  801718:	8b 7d 14             	mov    0x14(%ebp),%edi
  80171b:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80171e:	8b 45 18             	mov    0x18(%ebp),%eax
  801721:	ba 00 00 00 00       	mov    $0x0,%edx
  801726:	39 fa                	cmp    %edi,%edx
  801728:	77 39                	ja     801763 <printnum+0x57>
  80172a:	72 04                	jb     801730 <printnum+0x24>
  80172c:	39 f0                	cmp    %esi,%eax
  80172e:	77 33                	ja     801763 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	ff 75 20             	pushl  0x20(%ebp)
  801736:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  801739:	50                   	push   %eax
  80173a:	ff 75 18             	pushl  0x18(%ebp)
  80173d:	8b 45 18             	mov    0x18(%ebp),%eax
  801740:	ba 00 00 00 00       	mov    $0x0,%edx
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	57                   	push   %edi
  801748:	56                   	push   %esi
  801749:	e8 c2 09 00 00       	call   802110 <__udivdi3>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	52                   	push   %edx
  801752:	50                   	push   %eax
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	ff 75 08             	pushl  0x8(%ebp)
  801759:	e8 ae ff ff ff       	call   80170c <printnum>
  80175e:	83 c4 20             	add    $0x20,%esp
  801761:	eb 19                	jmp    80177c <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801763:	4b                   	dec    %ebx
  801764:	85 db                	test   %ebx,%ebx
  801766:	7e 14                	jle    80177c <printnum+0x70>
  801768:	83 ec 08             	sub    $0x8,%esp
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	ff 75 20             	pushl  0x20(%ebp)
  801771:	ff 55 08             	call   *0x8(%ebp)
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	4b                   	dec    %ebx
  801778:	85 db                	test   %ebx,%ebx
  80177a:	7f ec                	jg     801768 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80177c:	83 ec 08             	sub    $0x8,%esp
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	8b 45 18             	mov    0x18(%ebp),%eax
  801785:	ba 00 00 00 00       	mov    $0x0,%edx
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	52                   	push   %edx
  80178e:	50                   	push   %eax
  80178f:	57                   	push   %edi
  801790:	56                   	push   %esi
  801791:	e8 86 0a 00 00       	call   80221c <__umoddi3>
  801796:	83 c4 14             	add    $0x14,%esp
  801799:	0f be 80 45 26 80 00 	movsbl 0x802645(%eax),%eax
  8017a0:	50                   	push   %eax
  8017a1:	ff 55 08             	call   *0x8(%ebp)
}
  8017a4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8017a7:	5b                   	pop    %ebx
  8017a8:	5e                   	pop    %esi
  8017a9:	5f                   	pop    %edi
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8017b5:	83 f8 01             	cmp    $0x1,%eax
  8017b8:	7e 0f                	jle    8017c9 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  8017ba:	8b 01                	mov    (%ecx),%eax
  8017bc:	83 c0 08             	add    $0x8,%eax
  8017bf:	89 01                	mov    %eax,(%ecx)
  8017c1:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8017c4:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8017c7:	eb 24                	jmp    8017ed <getuint+0x41>
	else if (lflag)
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	74 11                	je     8017de <getuint+0x32>
		return va_arg(*ap, unsigned long);
  8017cd:	8b 01                	mov    (%ecx),%eax
  8017cf:	83 c0 04             	add    $0x4,%eax
  8017d2:	89 01                	mov    %eax,(%ecx)
  8017d4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8017d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dc:	eb 0f                	jmp    8017ed <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8017de:	8b 01                	mov    (%ecx),%eax
  8017e0:	83 c0 04             	add    $0x4,%eax
  8017e3:	89 01                	mov    %eax,(%ecx)
  8017e5:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8017e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8017f8:	83 f8 01             	cmp    $0x1,%eax
  8017fb:	7e 0f                	jle    80180c <getint+0x1d>
		return va_arg(*ap, long long);
  8017fd:	8b 02                	mov    (%edx),%eax
  8017ff:	83 c0 08             	add    $0x8,%eax
  801802:	89 02                	mov    %eax,(%edx)
  801804:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  801807:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80180a:	eb 1c                	jmp    801828 <getint+0x39>
	else if (lflag)
  80180c:	85 c0                	test   %eax,%eax
  80180e:	74 0d                	je     80181d <getint+0x2e>
		return va_arg(*ap, long);
  801810:	8b 02                	mov    (%edx),%eax
  801812:	83 c0 04             	add    $0x4,%eax
  801815:	89 02                	mov    %eax,(%edx)
  801817:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80181a:	99                   	cltd   
  80181b:	eb 0b                	jmp    801828 <getint+0x39>
	else
		return va_arg(*ap, int);
  80181d:	8b 02                	mov    (%edx),%eax
  80181f:	83 c0 04             	add    $0x4,%eax
  801822:	89 02                	mov    %eax,(%edx)
  801824:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801827:	99                   	cltd   
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	57                   	push   %edi
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	83 ec 1c             	sub    $0x1c,%esp
  801833:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  801836:	0f b6 13             	movzbl (%ebx),%edx
  801839:	43                   	inc    %ebx
  80183a:	83 fa 25             	cmp    $0x25,%edx
  80183d:	74 1e                	je     80185d <vprintfmt+0x33>
  80183f:	85 d2                	test   %edx,%edx
  801841:	0f 84 d7 02 00 00    	je     801b1e <vprintfmt+0x2f4>
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	52                   	push   %edx
  80184e:	ff 55 08             	call   *0x8(%ebp)
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	0f b6 13             	movzbl (%ebx),%edx
  801857:	43                   	inc    %ebx
  801858:	83 fa 25             	cmp    $0x25,%edx
  80185b:	75 e2                	jne    80183f <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  80185d:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  801861:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  801868:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  80186d:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  801872:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801879:	0f b6 13             	movzbl (%ebx),%edx
  80187c:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  80187f:	43                   	inc    %ebx
  801880:	83 f8 55             	cmp    $0x55,%eax
  801883:	0f 87 70 02 00 00    	ja     801af9 <vprintfmt+0x2cf>
  801889:	ff 24 85 dc 26 80 00 	jmp    *0x8026dc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  801890:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  801894:	eb e3                	jmp    801879 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801896:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  80189a:	eb dd                	jmp    801879 <vprintfmt+0x4f>

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
  80189c:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8018a1:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8018a4:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8018a8:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8018ab:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8018ae:	83 f8 09             	cmp    $0x9,%eax
  8018b1:	77 27                	ja     8018da <vprintfmt+0xb0>
  8018b3:	43                   	inc    %ebx
  8018b4:	eb eb                	jmp    8018a1 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8018b6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8018ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bd:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  8018c0:	eb 18                	jmp    8018da <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  8018c2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8018c6:	79 b1                	jns    801879 <vprintfmt+0x4f>
				width = 0;
  8018c8:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  8018cf:	eb a8                	jmp    801879 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  8018d1:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8018d8:	eb 9f                	jmp    801879 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8018da:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8018de:	79 99                	jns    801879 <vprintfmt+0x4f>
				width = precision, precision = -1;
  8018e0:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8018e3:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8018e8:	eb 8f                	jmp    801879 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8018ea:	41                   	inc    %ecx
			goto reswitch;
  8018eb:	eb 8c                	jmp    801879 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8018f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fa:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8018fd:	ff 55 08             	call   *0x8(%ebp)
			break;
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	e9 2e ff ff ff       	jmp    801836 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801908:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80190c:	8b 45 14             	mov    0x14(%ebp),%eax
  80190f:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  801912:	85 c0                	test   %eax,%eax
  801914:	79 02                	jns    801918 <vprintfmt+0xee>
				err = -err;
  801916:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801918:	83 f8 0e             	cmp    $0xe,%eax
  80191b:	7f 0b                	jg     801928 <vprintfmt+0xfe>
  80191d:	8b 3c 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edi
  801924:	85 ff                	test   %edi,%edi
  801926:	75 19                	jne    801941 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  801928:	50                   	push   %eax
  801929:	68 56 26 80 00       	push   $0x802656
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	e8 ed 01 00 00       	call   801b26 <printfmt>
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	e9 f5 fe ff ff       	jmp    801836 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  801941:	57                   	push   %edi
  801942:	68 cd 24 80 00       	push   $0x8024cd
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	e8 d4 01 00 00       	call   801b26 <printfmt>
  801952:	83 c4 10             	add    $0x10,%esp
			break;
  801955:	e9 dc fe ff ff       	jmp    801836 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80195a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80195e:	8b 45 14             	mov    0x14(%ebp),%eax
  801961:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  801964:	85 ff                	test   %edi,%edi
  801966:	75 05                	jne    80196d <vprintfmt+0x143>
				p = "(null)";
  801968:	bf 5f 26 80 00       	mov    $0x80265f,%edi
			if (width > 0 && padc != '-')
  80196d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801971:	7e 3b                	jle    8019ae <vprintfmt+0x184>
  801973:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  801977:	74 35                	je     8019ae <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	56                   	push   %esi
  80197d:	57                   	push   %edi
  80197e:	e8 56 03 00 00       	call   801cd9 <strnlen>
  801983:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80198d:	7e 1f                	jle    8019ae <vprintfmt+0x184>
  80198f:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  801993:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  801996:	83 ec 08             	sub    $0x8,%esp
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  80199f:	ff 55 08             	call   *0x8(%ebp)
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8019a8:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8019ac:	7f e8                	jg     801996 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019ae:	0f be 17             	movsbl (%edi),%edx
  8019b1:	47                   	inc    %edi
  8019b2:	85 d2                	test   %edx,%edx
  8019b4:	74 44                	je     8019fa <vprintfmt+0x1d0>
  8019b6:	85 f6                	test   %esi,%esi
  8019b8:	78 03                	js     8019bd <vprintfmt+0x193>
  8019ba:	4e                   	dec    %esi
  8019bb:	78 3d                	js     8019fa <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  8019bd:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  8019c1:	74 18                	je     8019db <vprintfmt+0x1b1>
  8019c3:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  8019c6:	83 f8 5e             	cmp    $0x5e,%eax
  8019c9:	76 10                	jbe    8019db <vprintfmt+0x1b1>
					putch('?', putdat);
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	6a 3f                	push   $0x3f
  8019d3:	ff 55 08             	call   *0x8(%ebp)
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	eb 0d                	jmp    8019e8 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8019db:	83 ec 08             	sub    $0x8,%esp
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	52                   	push   %edx
  8019e2:	ff 55 08             	call   *0x8(%ebp)
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8019eb:	0f be 17             	movsbl (%edi),%edx
  8019ee:	47                   	inc    %edi
  8019ef:	85 d2                	test   %edx,%edx
  8019f1:	74 07                	je     8019fa <vprintfmt+0x1d0>
  8019f3:	85 f6                	test   %esi,%esi
  8019f5:	78 c6                	js     8019bd <vprintfmt+0x193>
  8019f7:	4e                   	dec    %esi
  8019f8:	79 c3                	jns    8019bd <vprintfmt+0x193>
			for (; width > 0; width--)
  8019fa:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8019fe:	0f 8e 32 fe ff ff    	jle    801836 <vprintfmt+0xc>
				putch(' ', putdat);
  801a04:	83 ec 08             	sub    $0x8,%esp
  801a07:	ff 75 0c             	pushl  0xc(%ebp)
  801a0a:	6a 20                	push   $0x20
  801a0c:	ff 55 08             	call   *0x8(%ebp)
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	ff 4d f0             	decl   0xfffffff0(%ebp)
  801a15:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801a19:	7f e9                	jg     801a04 <vprintfmt+0x1da>
			break;
  801a1b:	e9 16 fe ff ff       	jmp    801836 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801a20:	51                   	push   %ecx
  801a21:	8d 45 14             	lea    0x14(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	e8 c5 fd ff ff       	call   8017ef <getint>
  801a2a:	89 c6                	mov    %eax,%esi
  801a2c:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  801a2e:	83 c4 08             	add    $0x8,%esp
  801a31:	85 d2                	test   %edx,%edx
  801a33:	79 15                	jns    801a4a <vprintfmt+0x220>
				putch('-', putdat);
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	6a 2d                	push   $0x2d
  801a3d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801a40:	f7 de                	neg    %esi
  801a42:	83 d7 00             	adc    $0x0,%edi
  801a45:	f7 df                	neg    %edi
  801a47:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  801a4a:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  801a4f:	eb 75                	jmp    801ac6 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801a51:	51                   	push   %ecx
  801a52:	8d 45 14             	lea    0x14(%ebp),%eax
  801a55:	50                   	push   %eax
  801a56:	e8 51 fd ff ff       	call   8017ac <getuint>
  801a5b:	89 c6                	mov    %eax,%esi
  801a5d:	89 d7                	mov    %edx,%edi
			base = 10;
  801a5f:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  801a64:	83 c4 08             	add    $0x8,%esp
  801a67:	eb 5d                	jmp    801ac6 <vprintfmt+0x29c>

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
  801a69:	51                   	push   %ecx
  801a6a:	8d 45 14             	lea    0x14(%ebp),%eax
  801a6d:	50                   	push   %eax
  801a6e:	e8 39 fd ff ff       	call   8017ac <getuint>
  801a73:	89 c6                	mov    %eax,%esi
  801a75:	89 d7                	mov    %edx,%edi
			base = 8;
  801a77:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  801a7c:	83 c4 08             	add    $0x8,%esp
  801a7f:	eb 45                	jmp    801ac6 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	6a 30                	push   $0x30
  801a89:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801a8c:	83 c4 08             	add    $0x8,%esp
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	6a 78                	push   $0x78
  801a94:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  801a97:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9e:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  801aa1:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801aa6:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	eb 16                	jmp    801ac6 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801ab0:	51                   	push   %ecx
  801ab1:	8d 45 14             	lea    0x14(%ebp),%eax
  801ab4:	50                   	push   %eax
  801ab5:	e8 f2 fc ff ff       	call   8017ac <getuint>
  801aba:	89 c6                	mov    %eax,%esi
  801abc:	89 d7                	mov    %edx,%edi
			base = 16;
  801abe:	ba 10 00 00 00       	mov    $0x10,%edx
  801ac3:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  801acd:	50                   	push   %eax
  801ace:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801ad1:	52                   	push   %edx
  801ad2:	57                   	push   %edi
  801ad3:	56                   	push   %esi
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	e8 2d fc ff ff       	call   80170c <printnum>
			break;
  801adf:	83 c4 20             	add    $0x20,%esp
  801ae2:	e9 4f fd ff ff       	jmp    801836 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ae7:	83 ec 08             	sub    $0x8,%esp
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	52                   	push   %edx
  801aee:	ff 55 08             	call   *0x8(%ebp)
			break;
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	e9 3d fd ff ff       	jmp    801836 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801af9:	83 ec 08             	sub    $0x8,%esp
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	6a 25                	push   $0x25
  801b01:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b04:	4b                   	dec    %ebx
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  801b0c:	0f 84 24 fd ff ff    	je     801836 <vprintfmt+0xc>
  801b12:	4b                   	dec    %ebx
  801b13:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  801b17:	75 f9                	jne    801b12 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  801b19:	e9 18 fd ff ff       	jmp    801836 <vprintfmt+0xc>
		}
	}
}
  801b1e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801b21:	5b                   	pop    %ebx
  801b22:	5e                   	pop    %esi
  801b23:	5f                   	pop    %edi
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  801b2c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801b2f:	50                   	push   %eax
  801b30:	ff 75 10             	pushl  0x10(%ebp)
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	e8 ec fc ff ff       	call   80182a <vprintfmt>
	va_end(ap);
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  801b46:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  801b49:	8b 0a                	mov    (%edx),%ecx
  801b4b:	3b 4a 04             	cmp    0x4(%edx),%ecx
  801b4e:	73 07                	jae    801b57 <sprintputch+0x17>
		*b->buf++ = ch;
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	88 01                	mov    %al,(%ecx)
  801b55:	ff 02                	incl   (%edx)
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 18             	sub    $0x18,%esp
  801b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b65:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  801b68:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  801b6c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  801b6f:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  801b76:	85 d2                	test   %edx,%edx
  801b78:	74 04                	je     801b7e <vsnprintf+0x25>
  801b7a:	85 c9                	test   %ecx,%ecx
  801b7c:	7f 07                	jg     801b85 <vsnprintf+0x2c>
		return -E_INVAL;
  801b7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b83:	eb 1d                	jmp    801ba2 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b85:	ff 75 14             	pushl  0x14(%ebp)
  801b88:	ff 75 10             	pushl  0x10(%ebp)
  801b8b:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  801b8e:	50                   	push   %eax
  801b8f:	68 40 1b 80 00       	push   $0x801b40
  801b94:	e8 91 fc ff ff       	call   80182a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b99:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  801b9c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b9f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801baa:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bad:	50                   	push   %eax
  801bae:	ff 75 10             	pushl  0x10(%ebp)
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	e8 9d ff ff ff       	call   801b59 <vsnprintf>
	va_end(ap);

	return rc;
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    
	...

00801bc0 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  801bc8:	83 ec 0c             	sub    $0xc,%esp
  801bcb:	56                   	push   %esi
  801bcc:	e8 ef 00 00 00       	call   801cc0 <strlen>
  char letter;
  int hexnum = 0;
  801bd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  801bd6:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	89 c2                	mov    %eax,%edx
  801be0:	4a                   	dec    %edx
  801be1:	0f 88 d0 00 00 00    	js     801cb7 <strtoint+0xf7>
    letter = string[cidx];
  801be7:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  801bea:	85 d2                	test   %edx,%edx
  801bec:	75 12                	jne    801c00 <strtoint+0x40>
      if (letter != '0') {
  801bee:	3c 30                	cmp    $0x30,%al
  801bf0:	0f 84 ba 00 00 00    	je     801cb0 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  801bf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bfb:	e9 b9 00 00 00       	jmp    801cb9 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  801c00:	83 fa 01             	cmp    $0x1,%edx
  801c03:	75 12                	jne    801c17 <strtoint+0x57>
      if (letter != 'x') {
  801c05:	3c 78                	cmp    $0x78,%al
  801c07:	0f 84 a3 00 00 00    	je     801cb0 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  801c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c12:	e9 a2 00 00 00       	jmp    801cb9 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  801c17:	0f be c0             	movsbl %al,%eax
  801c1a:	83 e8 30             	sub    $0x30,%eax
  801c1d:	83 f8 36             	cmp    $0x36,%eax
  801c20:	0f 87 80 00 00 00    	ja     801ca6 <strtoint+0xe6>
  801c26:	ff 24 85 34 28 80 00 	jmp    *0x802834(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  801c2d:	01 cb                	add    %ecx,%ebx
          break;
  801c2f:	eb 7c                	jmp    801cad <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  801c31:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  801c34:	eb 77                	jmp    801cad <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  801c36:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  801c39:	01 c3                	add    %eax,%ebx
          break;
  801c3b:	eb 70                	jmp    801cad <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  801c3d:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  801c40:	eb 6b                	jmp    801cad <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  801c42:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  801c45:	01 c3                	add    %eax,%ebx
          break;
  801c47:	eb 64                	jmp    801cad <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  801c49:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  801c4c:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  801c4f:	eb 5c                	jmp    801cad <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  801c51:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  801c58:	29 c8                	sub    %ecx,%eax
  801c5a:	01 c3                	add    %eax,%ebx
          break;
  801c5c:	eb 4f                	jmp    801cad <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  801c5e:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  801c61:	eb 4a                	jmp    801cad <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  801c63:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  801c66:	01 c3                	add    %eax,%ebx
          break;
  801c68:	eb 43                	jmp    801cad <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  801c6a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  801c6d:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  801c70:	eb 3b                	jmp    801cad <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  801c72:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  801c75:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  801c78:	01 c3                	add    %eax,%ebx
          break;
  801c7a:	eb 31                	jmp    801cad <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  801c7c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  801c7f:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  801c82:	eb 29                	jmp    801cad <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  801c84:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  801c87:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  801c8a:	01 c3                	add    %eax,%ebx
          break;
  801c8c:	eb 1f                	jmp    801cad <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  801c8e:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  801c95:	29 c8                	sub    %ecx,%eax
  801c97:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  801c9a:	eb 11                	jmp    801cad <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  801c9c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  801c9f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801ca2:	01 c3                	add    %eax,%ebx
          break;
  801ca4:	eb 07                	jmp    801cad <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  801ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cab:	eb 0c                	jmp    801cb9 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  801cad:	c1 e1 04             	shl    $0x4,%ecx
  801cb0:	4a                   	dec    %edx
  801cb1:	0f 89 30 ff ff ff    	jns    801be7 <strtoint+0x27>
    }
  }

  return hexnum;
  801cb7:	89 d8                	mov    %ebx,%eax
}
  801cb9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <strlen>:





int
strlen(const char *s)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	80 3a 00             	cmpb   $0x0,(%edx)
  801cce:	74 07                	je     801cd7 <strlen+0x17>
		n++;
  801cd0:	40                   	inc    %eax
  801cd1:	42                   	inc    %edx
  801cd2:	80 3a 00             	cmpb   $0x0,(%edx)
  801cd5:	75 f9                	jne    801cd0 <strlen+0x10>
	return n;
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	85 d2                	test   %edx,%edx
  801ce9:	74 0f                	je     801cfa <strnlen+0x21>
  801ceb:	80 39 00             	cmpb   $0x0,(%ecx)
  801cee:	74 0a                	je     801cfa <strnlen+0x21>
		n++;
  801cf0:	40                   	inc    %eax
  801cf1:	41                   	inc    %ecx
  801cf2:	4a                   	dec    %edx
  801cf3:	74 05                	je     801cfa <strnlen+0x21>
  801cf5:	80 39 00             	cmpb   $0x0,(%ecx)
  801cf8:	75 f6                	jne    801cf0 <strnlen+0x17>
	return n;
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	53                   	push   %ebx
  801d00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d03:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  801d06:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  801d08:	8a 02                	mov    (%edx),%al
  801d0a:	42                   	inc    %edx
  801d0b:	88 01                	mov    %al,(%ecx)
  801d0d:	41                   	inc    %ecx
  801d0e:	84 c0                	test   %al,%al
  801d10:	75 f6                	jne    801d08 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801d12:	89 d8                	mov    %ebx,%eax
  801d14:	5b                   	pop    %ebx
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	57                   	push   %edi
  801d1b:	56                   	push   %esi
  801d1c:	53                   	push   %ebx
  801d1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d23:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  801d26:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  801d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d2d:	39 f3                	cmp    %esi,%ebx
  801d2f:	73 10                	jae    801d41 <strncpy+0x2a>
		*dst++ = *src;
  801d31:	8a 02                	mov    (%edx),%al
  801d33:	88 01                	mov    %al,(%ecx)
  801d35:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d36:	80 3a 01             	cmpb   $0x1,(%edx)
  801d39:	83 da ff             	sbb    $0xffffffff,%edx
  801d3c:	43                   	inc    %ebx
  801d3d:	39 f3                	cmp    %esi,%ebx
  801d3f:	72 f0                	jb     801d31 <strncpy+0x1a>
	}
	return ret;
}
  801d41:	89 f8                	mov    %edi,%eax
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	56                   	push   %esi
  801d4c:	53                   	push   %ebx
  801d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d53:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  801d56:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  801d58:	85 d2                	test   %edx,%edx
  801d5a:	74 19                	je     801d75 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801d5c:	4a                   	dec    %edx
  801d5d:	74 13                	je     801d72 <strlcpy+0x2a>
  801d5f:	80 39 00             	cmpb   $0x0,(%ecx)
  801d62:	74 0e                	je     801d72 <strlcpy+0x2a>
  801d64:	8a 01                	mov    (%ecx),%al
  801d66:	41                   	inc    %ecx
  801d67:	88 03                	mov    %al,(%ebx)
  801d69:	43                   	inc    %ebx
  801d6a:	4a                   	dec    %edx
  801d6b:	74 05                	je     801d72 <strlcpy+0x2a>
  801d6d:	80 39 00             	cmpb   $0x0,(%ecx)
  801d70:	75 f2                	jne    801d64 <strlcpy+0x1c>
		*dst = '\0';
  801d72:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  801d75:	89 d8                	mov    %ebx,%eax
  801d77:	29 f0                	sub    %esi,%eax
}
  801d79:	5b                   	pop    %ebx
  801d7a:	5e                   	pop    %esi
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	8b 55 08             	mov    0x8(%ebp),%edx
  801d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  801d86:	80 3a 00             	cmpb   $0x0,(%edx)
  801d89:	74 13                	je     801d9e <strcmp+0x21>
  801d8b:	8a 02                	mov    (%edx),%al
  801d8d:	3a 01                	cmp    (%ecx),%al
  801d8f:	75 0d                	jne    801d9e <strcmp+0x21>
  801d91:	42                   	inc    %edx
  801d92:	41                   	inc    %ecx
  801d93:	80 3a 00             	cmpb   $0x0,(%edx)
  801d96:	74 06                	je     801d9e <strcmp+0x21>
  801d98:	8a 02                	mov    (%edx),%al
  801d9a:	3a 01                	cmp    (%ecx),%al
  801d9c:	74 f3                	je     801d91 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d9e:	0f b6 02             	movzbl (%edx),%eax
  801da1:	0f b6 11             	movzbl (%ecx),%edx
  801da4:	29 d0                	sub    %edx,%eax
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	53                   	push   %ebx
  801dac:	8b 55 08             	mov    0x8(%ebp),%edx
  801daf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801db2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  801db5:	85 c9                	test   %ecx,%ecx
  801db7:	74 1f                	je     801dd8 <strncmp+0x30>
  801db9:	80 3a 00             	cmpb   $0x0,(%edx)
  801dbc:	74 16                	je     801dd4 <strncmp+0x2c>
  801dbe:	8a 02                	mov    (%edx),%al
  801dc0:	3a 03                	cmp    (%ebx),%al
  801dc2:	75 10                	jne    801dd4 <strncmp+0x2c>
  801dc4:	42                   	inc    %edx
  801dc5:	43                   	inc    %ebx
  801dc6:	49                   	dec    %ecx
  801dc7:	74 0f                	je     801dd8 <strncmp+0x30>
  801dc9:	80 3a 00             	cmpb   $0x0,(%edx)
  801dcc:	74 06                	je     801dd4 <strncmp+0x2c>
  801dce:	8a 02                	mov    (%edx),%al
  801dd0:	3a 03                	cmp    (%ebx),%al
  801dd2:	74 f0                	je     801dc4 <strncmp+0x1c>
	if (n == 0)
  801dd4:	85 c9                	test   %ecx,%ecx
  801dd6:	75 07                	jne    801ddf <strncmp+0x37>
		return 0;
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddd:	eb 0a                	jmp    801de9 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ddf:	0f b6 12             	movzbl (%edx),%edx
  801de2:	0f b6 03             	movzbl (%ebx),%eax
  801de5:	29 c2                	sub    %eax,%edx
  801de7:	89 d0                	mov    %edx,%eax
}
  801de9:	5b                   	pop    %ebx
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  801df5:	80 38 00             	cmpb   $0x0,(%eax)
  801df8:	74 0a                	je     801e04 <strchr+0x18>
		if (*s == c)
  801dfa:	38 10                	cmp    %dl,(%eax)
  801dfc:	74 0b                	je     801e09 <strchr+0x1d>
  801dfe:	40                   	inc    %eax
  801dff:	80 38 00             	cmpb   $0x0,(%eax)
  801e02:	75 f6                	jne    801dfa <strchr+0xe>
			return (char *) s;
	return 0;
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  801e14:	80 38 00             	cmpb   $0x0,(%eax)
  801e17:	74 0a                	je     801e23 <strfind+0x18>
		if (*s == c)
  801e19:	38 10                	cmp    %dl,(%eax)
  801e1b:	74 06                	je     801e23 <strfind+0x18>
  801e1d:	40                   	inc    %eax
  801e1e:	80 38 00             	cmpb   $0x0,(%eax)
  801e21:	75 f6                	jne    801e19 <strfind+0xe>
			break;
	return (char *) s;
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	57                   	push   %edi
  801e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  801e2f:	89 f8                	mov    %edi,%eax
  801e31:	85 c9                	test   %ecx,%ecx
  801e33:	74 40                	je     801e75 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  801e35:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801e3b:	75 30                	jne    801e6d <memset+0x48>
  801e3d:	f6 c1 03             	test   $0x3,%cl
  801e40:	75 2b                	jne    801e6d <memset+0x48>
		c &= 0xFF;
  801e42:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4c:	c1 e0 18             	shl    $0x18,%eax
  801e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e52:	c1 e2 10             	shl    $0x10,%edx
  801e55:	09 d0                	or     %edx,%eax
  801e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5a:	c1 e2 08             	shl    $0x8,%edx
  801e5d:	09 d0                	or     %edx,%eax
  801e5f:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  801e62:	c1 e9 02             	shr    $0x2,%ecx
  801e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e68:	fc                   	cld    
  801e69:	f3 ab                	repz stos %eax,%es:(%edi)
  801e6b:	eb 06                	jmp    801e73 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e70:	fc                   	cld    
  801e71:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801e73:	89 f8                	mov    %edi,%eax
}
  801e75:	5f                   	pop    %edi
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	57                   	push   %edi
  801e7c:	56                   	push   %esi
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  801e83:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  801e86:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  801e88:	39 c6                	cmp    %eax,%esi
  801e8a:	73 33                	jae    801ebf <memmove+0x47>
  801e8c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e8f:	39 c2                	cmp    %eax,%edx
  801e91:	76 2c                	jbe    801ebf <memmove+0x47>
		s += n;
  801e93:	89 d6                	mov    %edx,%esi
		d += n;
  801e95:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e98:	f6 c2 03             	test   $0x3,%dl
  801e9b:	75 1b                	jne    801eb8 <memmove+0x40>
  801e9d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801ea3:	75 13                	jne    801eb8 <memmove+0x40>
  801ea5:	f6 c1 03             	test   $0x3,%cl
  801ea8:	75 0e                	jne    801eb8 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  801eaa:	83 ef 04             	sub    $0x4,%edi
  801ead:	83 ee 04             	sub    $0x4,%esi
  801eb0:	c1 e9 02             	shr    $0x2,%ecx
  801eb3:	fd                   	std    
  801eb4:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  801eb6:	eb 27                	jmp    801edf <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801eb8:	4f                   	dec    %edi
  801eb9:	4e                   	dec    %esi
  801eba:	fd                   	std    
  801ebb:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  801ebd:	eb 20                	jmp    801edf <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801ebf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801ec5:	75 15                	jne    801edc <memmove+0x64>
  801ec7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801ecd:	75 0d                	jne    801edc <memmove+0x64>
  801ecf:	f6 c1 03             	test   $0x3,%cl
  801ed2:	75 08                	jne    801edc <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  801ed4:	c1 e9 02             	shr    $0x2,%ecx
  801ed7:	fc                   	cld    
  801ed8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  801eda:	eb 03                	jmp    801edf <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801edc:	fc                   	cld    
  801edd:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801edf:	5e                   	pop    %esi
  801ee0:	5f                   	pop    %edi
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <memcpy>:

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
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801ee6:	ff 75 10             	pushl  0x10(%ebp)
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	e8 84 ff ff ff       	call   801e78 <memmove>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  801efa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  801efd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f00:	8b 55 10             	mov    0x10(%ebp),%edx
  801f03:	4a                   	dec    %edx
  801f04:	83 fa ff             	cmp    $0xffffffff,%edx
  801f07:	74 1a                	je     801f23 <memcmp+0x2d>
  801f09:	8a 01                	mov    (%ecx),%al
  801f0b:	3a 03                	cmp    (%ebx),%al
  801f0d:	74 0c                	je     801f1b <memcmp+0x25>
  801f0f:	0f b6 d0             	movzbl %al,%edx
  801f12:	0f b6 03             	movzbl (%ebx),%eax
  801f15:	29 c2                	sub    %eax,%edx
  801f17:	89 d0                	mov    %edx,%eax
  801f19:	eb 0d                	jmp    801f28 <memcmp+0x32>
  801f1b:	41                   	inc    %ecx
  801f1c:	43                   	inc    %ebx
  801f1d:	4a                   	dec    %edx
  801f1e:	83 fa ff             	cmp    $0xffffffff,%edx
  801f21:	75 e6                	jne    801f09 <memcmp+0x13>
	}

	return 0;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f28:	5b                   	pop    %ebx
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f39:	39 d0                	cmp    %edx,%eax
  801f3b:	73 09                	jae    801f46 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f3d:	38 08                	cmp    %cl,(%eax)
  801f3f:	74 05                	je     801f46 <memfind+0x1b>
  801f41:	40                   	inc    %eax
  801f42:	39 d0                	cmp    %edx,%eax
  801f44:	72 f7                	jb     801f3d <memfind+0x12>
			break;
	return (void *) s;
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	57                   	push   %edi
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
  801f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f51:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f54:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  801f57:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  801f5c:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  801f61:	80 3a 20             	cmpb   $0x20,(%edx)
  801f64:	74 05                	je     801f6b <strtol+0x23>
  801f66:	80 3a 09             	cmpb   $0x9,(%edx)
  801f69:	75 0b                	jne    801f76 <strtol+0x2e>
  801f6b:	42                   	inc    %edx
  801f6c:	80 3a 20             	cmpb   $0x20,(%edx)
  801f6f:	74 fa                	je     801f6b <strtol+0x23>
  801f71:	80 3a 09             	cmpb   $0x9,(%edx)
  801f74:	74 f5                	je     801f6b <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  801f76:	80 3a 2b             	cmpb   $0x2b,(%edx)
  801f79:	75 03                	jne    801f7e <strtol+0x36>
		s++;
  801f7b:	42                   	inc    %edx
  801f7c:	eb 0b                	jmp    801f89 <strtol+0x41>
	else if (*s == '-')
  801f7e:	80 3a 2d             	cmpb   $0x2d,(%edx)
  801f81:	75 06                	jne    801f89 <strtol+0x41>
		s++, neg = 1;
  801f83:	42                   	inc    %edx
  801f84:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f89:	85 c9                	test   %ecx,%ecx
  801f8b:	74 05                	je     801f92 <strtol+0x4a>
  801f8d:	83 f9 10             	cmp    $0x10,%ecx
  801f90:	75 15                	jne    801fa7 <strtol+0x5f>
  801f92:	80 3a 30             	cmpb   $0x30,(%edx)
  801f95:	75 10                	jne    801fa7 <strtol+0x5f>
  801f97:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801f9b:	75 0a                	jne    801fa7 <strtol+0x5f>
		s += 2, base = 16;
  801f9d:	83 c2 02             	add    $0x2,%edx
  801fa0:	b9 10 00 00 00       	mov    $0x10,%ecx
  801fa5:	eb 14                	jmp    801fbb <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  801fa7:	85 c9                	test   %ecx,%ecx
  801fa9:	75 10                	jne    801fbb <strtol+0x73>
  801fab:	80 3a 30             	cmpb   $0x30,(%edx)
  801fae:	75 05                	jne    801fb5 <strtol+0x6d>
		s++, base = 8;
  801fb0:	42                   	inc    %edx
  801fb1:	b1 08                	mov    $0x8,%cl
  801fb3:	eb 06                	jmp    801fbb <strtol+0x73>
	else if (base == 0)
  801fb5:	85 c9                	test   %ecx,%ecx
  801fb7:	75 02                	jne    801fbb <strtol+0x73>
		base = 10;
  801fb9:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fbb:	8a 02                	mov    (%edx),%al
  801fbd:	83 e8 30             	sub    $0x30,%eax
  801fc0:	3c 09                	cmp    $0x9,%al
  801fc2:	77 08                	ja     801fcc <strtol+0x84>
			dig = *s - '0';
  801fc4:	0f be 02             	movsbl (%edx),%eax
  801fc7:	83 e8 30             	sub    $0x30,%eax
  801fca:	eb 20                	jmp    801fec <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  801fcc:	8a 02                	mov    (%edx),%al
  801fce:	83 e8 61             	sub    $0x61,%eax
  801fd1:	3c 19                	cmp    $0x19,%al
  801fd3:	77 08                	ja     801fdd <strtol+0x95>
			dig = *s - 'a' + 10;
  801fd5:	0f be 02             	movsbl (%edx),%eax
  801fd8:	83 e8 57             	sub    $0x57,%eax
  801fdb:	eb 0f                	jmp    801fec <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  801fdd:	8a 02                	mov    (%edx),%al
  801fdf:	83 e8 41             	sub    $0x41,%eax
  801fe2:	3c 19                	cmp    $0x19,%al
  801fe4:	77 12                	ja     801ff8 <strtol+0xb0>
			dig = *s - 'A' + 10;
  801fe6:	0f be 02             	movsbl (%edx),%eax
  801fe9:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  801fec:	39 c8                	cmp    %ecx,%eax
  801fee:	7d 08                	jge    801ff8 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  801ff0:	42                   	inc    %edx
  801ff1:	0f af d9             	imul   %ecx,%ebx
  801ff4:	01 c3                	add    %eax,%ebx
  801ff6:	eb c3                	jmp    801fbb <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ff8:	85 f6                	test   %esi,%esi
  801ffa:	74 02                	je     801ffe <strtol+0xb6>
		*endptr = (char *) s;
  801ffc:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801ffe:	89 d8                	mov    %ebx,%eax
  802000:	85 ff                	test   %edi,%edi
  802002:	74 02                	je     802006 <strtol+0xbe>
  802004:	f7 d8                	neg    %eax
}
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5f                   	pop    %edi
  802009:	c9                   	leave  
  80200a:	c3                   	ret    
	...

0080200c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	56                   	push   %esi
  802010:	53                   	push   %ebx
  802011:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 12                	jne    802030 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80201e:	83 ec 0c             	sub    $0xc,%esp
  802021:	68 00 00 c0 ee       	push   $0xeec00000
  802026:	e8 ef e2 ff ff       	call   80031a <sys_ipc_recv>
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	eb 0c                	jmp    80203c <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	50                   	push   %eax
  802034:	e8 e1 e2 ff ff       	call   80031a <sys_ipc_recv>
  802039:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  80203c:	89 c2                	mov    %eax,%edx
  80203e:	85 c0                	test   %eax,%eax
  802040:	78 24                	js     802066 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802042:	85 db                	test   %ebx,%ebx
  802044:	74 0a                	je     802050 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802046:	a1 80 60 80 00       	mov    0x806080,%eax
  80204b:	8b 40 74             	mov    0x74(%eax),%eax
  80204e:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802050:	85 f6                	test   %esi,%esi
  802052:	74 0a                	je     80205e <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802054:	a1 80 60 80 00       	mov    0x806080,%eax
  802059:	8b 40 78             	mov    0x78(%eax),%eax
  80205c:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  80205e:	a1 80 60 80 00       	mov    0x806080,%eax
  802063:	8b 50 70             	mov    0x70(%eax),%edx

}
  802066:	89 d0                	mov    %edx,%eax
  802068:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <ipc_send>:

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
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	57                   	push   %edi
  802073:	56                   	push   %esi
  802074:	53                   	push   %ebx
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80207b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80207e:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802081:	85 db                	test   %ebx,%ebx
  802083:	75 0a                	jne    80208f <ipc_send+0x20>
    pg = (void *) UTOP;
  802085:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80208a:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80208f:	56                   	push   %esi
  802090:	53                   	push   %ebx
  802091:	57                   	push   %edi
  802092:	ff 75 08             	pushl  0x8(%ebp)
  802095:	e8 5d e2 ff ff       	call   8002f7 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020a0:	75 07                	jne    8020a9 <ipc_send+0x3a>
      sys_yield();
  8020a2:	e8 a4 e0 ff ff       	call   80014b <sys_yield>
  8020a7:	eb e6                	jmp    80208f <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	79 12                	jns    8020bf <ipc_send+0x50>
  8020ad:	50                   	push   %eax
  8020ae:	68 10 29 80 00       	push   $0x802910
  8020b3:	6a 49                	push   $0x49
  8020b5:	68 2d 29 80 00       	push   $0x80292d
  8020ba:	e8 49 f5 ff ff       	call   801608 <_panic>
    else break;
  }
}
  8020bf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020c2:	5b                   	pop    %ebx
  8020c3:	5e                   	pop    %esi
  8020c4:	5f                   	pop    %edi
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    
	...

008020c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8020ce:	89 c8                	mov    %ecx,%eax
  8020d0:	c1 e8 16             	shr    $0x16,%eax
  8020d3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8020da:	ba 00 00 00 00       	mov    $0x0,%edx
  8020df:	a8 01                	test   $0x1,%al
  8020e1:	74 28                	je     80210b <pageref+0x43>
	pte = vpt[VPN(v)];
  8020e3:	89 c8                	mov    %ecx,%eax
  8020e5:	c1 e8 0c             	shr    $0xc,%eax
  8020e8:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8020ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f4:	a8 01                	test   $0x1,%al
  8020f6:	74 13                	je     80210b <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8020f8:	c1 e8 0c             	shr    $0xc,%eax
  8020fb:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8020fe:	c1 e0 02             	shl    $0x2,%eax
  802101:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802108:	0f b7 d0             	movzwl %ax,%edx
}
  80210b:	89 d0                	mov    %edx,%eax
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    
	...

00802110 <__udivdi3>:
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	57                   	push   %edi
  802114:	56                   	push   %esi
  802115:	83 ec 14             	sub    $0x14,%esp
  802118:	8b 55 14             	mov    0x14(%ebp),%edx
  80211b:	8b 75 08             	mov    0x8(%ebp),%esi
  80211e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802121:	8b 45 10             	mov    0x10(%ebp),%eax
  802124:	85 d2                	test   %edx,%edx
  802126:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802129:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80212c:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80212f:	89 fe                	mov    %edi,%esi
  802131:	75 11                	jne    802144 <__udivdi3+0x34>
  802133:	39 f8                	cmp    %edi,%eax
  802135:	76 4d                	jbe    802184 <__udivdi3+0x74>
  802137:	89 fa                	mov    %edi,%edx
  802139:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80213c:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80213f:	89 c7                	mov    %eax,%edi
  802141:	eb 09                	jmp    80214c <__udivdi3+0x3c>
  802143:	90                   	nop    
  802144:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802147:	76 17                	jbe    802160 <__udivdi3+0x50>
  802149:	31 ff                	xor    %edi,%edi
  80214b:	90                   	nop    
  80214c:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802153:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802156:	83 c4 14             	add    $0x14,%esp
  802159:	5e                   	pop    %esi
  80215a:	89 f8                	mov    %edi,%eax
  80215c:	5f                   	pop    %edi
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    
  80215f:	90                   	nop    
  802160:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802164:	89 c7                	mov    %eax,%edi
  802166:	83 f7 1f             	xor    $0x1f,%edi
  802169:	75 4d                	jne    8021b8 <__udivdi3+0xa8>
  80216b:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  80216e:	77 0a                	ja     80217a <__udivdi3+0x6a>
  802170:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802173:	31 ff                	xor    %edi,%edi
  802175:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802178:	72 d2                	jb     80214c <__udivdi3+0x3c>
  80217a:	bf 01 00 00 00       	mov    $0x1,%edi
  80217f:	eb cb                	jmp    80214c <__udivdi3+0x3c>
  802181:	8d 76 00             	lea    0x0(%esi),%esi
  802184:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802187:	85 c0                	test   %eax,%eax
  802189:	75 0e                	jne    802199 <__udivdi3+0x89>
  80218b:	b8 01 00 00 00       	mov    $0x1,%eax
  802190:	31 c9                	xor    %ecx,%ecx
  802192:	31 d2                	xor    %edx,%edx
  802194:	f7 f1                	div    %ecx
  802196:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802199:	89 f0                	mov    %esi,%eax
  80219b:	31 d2                	xor    %edx,%edx
  80219d:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8021a0:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8021a3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8021a6:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8021a9:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8021ac:	83 c4 14             	add    $0x14,%esp
  8021af:	89 c7                	mov    %eax,%edi
  8021b1:	5e                   	pop    %esi
  8021b2:	89 f8                	mov    %edi,%eax
  8021b4:	5f                   	pop    %edi
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    
  8021b7:	90                   	nop    
  8021b8:	b8 20 00 00 00       	mov    $0x20,%eax
  8021bd:	29 f8                	sub    %edi,%eax
  8021bf:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8021c2:	89 f9                	mov    %edi,%ecx
  8021c4:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8021c7:	d3 e2                	shl    %cl,%edx
  8021c9:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8021cc:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8021cf:	d3 e8                	shr    %cl,%eax
  8021d1:	09 c2                	or     %eax,%edx
  8021d3:	89 f9                	mov    %edi,%ecx
  8021d5:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8021d8:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8021db:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8021de:	89 f2                	mov    %esi,%edx
  8021e0:	d3 ea                	shr    %cl,%edx
  8021e2:	89 f9                	mov    %edi,%ecx
  8021e4:	d3 e6                	shl    %cl,%esi
  8021e6:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8021e9:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8021ec:	d3 e8                	shr    %cl,%eax
  8021ee:	09 c6                	or     %eax,%esi
  8021f0:	89 f9                	mov    %edi,%ecx
  8021f2:	89 f0                	mov    %esi,%eax
  8021f4:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8021f7:	89 d6                	mov    %edx,%esi
  8021f9:	89 c7                	mov    %eax,%edi
  8021fb:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8021fe:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802201:	f7 e7                	mul    %edi
  802203:	39 f2                	cmp    %esi,%edx
  802205:	77 0f                	ja     802216 <__udivdi3+0x106>
  802207:	0f 85 3f ff ff ff    	jne    80214c <__udivdi3+0x3c>
  80220d:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802210:	0f 86 36 ff ff ff    	jbe    80214c <__udivdi3+0x3c>
  802216:	4f                   	dec    %edi
  802217:	e9 30 ff ff ff       	jmp    80214c <__udivdi3+0x3c>

0080221c <__umoddi3>:
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	57                   	push   %edi
  802220:	56                   	push   %esi
  802221:	83 ec 30             	sub    $0x30,%esp
  802224:	8b 55 14             	mov    0x14(%ebp),%edx
  802227:	8b 45 10             	mov    0x10(%ebp),%eax
  80222a:	89 d7                	mov    %edx,%edi
  80222c:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  80222f:	89 c6                	mov    %eax,%esi
  802231:	8b 55 0c             	mov    0xc(%ebp),%edx
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	85 ff                	test   %edi,%edi
  802239:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802240:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802247:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  80224a:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80224d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802250:	75 3e                	jne    802290 <__umoddi3+0x74>
  802252:	39 d6                	cmp    %edx,%esi
  802254:	0f 86 a2 00 00 00    	jbe    8022fc <__umoddi3+0xe0>
  80225a:	f7 f6                	div    %esi
  80225c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80225f:	85 c9                	test   %ecx,%ecx
  802261:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802264:	74 1b                	je     802281 <__umoddi3+0x65>
  802266:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802269:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  80226c:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802273:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802276:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802279:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  80227c:	89 10                	mov    %edx,(%eax)
  80227e:	89 48 04             	mov    %ecx,0x4(%eax)
  802281:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802284:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802287:	83 c4 30             	add    $0x30,%esp
  80228a:	5e                   	pop    %esi
  80228b:	5f                   	pop    %edi
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    
  80228e:	89 f6                	mov    %esi,%esi
  802290:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802293:	76 1f                	jbe    8022b4 <__umoddi3+0x98>
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
  802298:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80229b:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80229e:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  8022a1:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8022a4:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8022a7:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8022aa:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8022ad:	83 c4 30             	add    $0x30,%esp
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    
  8022b4:	0f bd c7             	bsr    %edi,%eax
  8022b7:	83 f0 1f             	xor    $0x1f,%eax
  8022ba:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8022bd:	75 61                	jne    802320 <__umoddi3+0x104>
  8022bf:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8022c2:	77 05                	ja     8022c9 <__umoddi3+0xad>
  8022c4:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8022c7:	72 10                	jb     8022d9 <__umoddi3+0xbd>
  8022c9:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8022cc:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8022cf:	29 f0                	sub    %esi,%eax
  8022d1:	19 fa                	sbb    %edi,%edx
  8022d3:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8022d6:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8022d9:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8022dc:	85 d2                	test   %edx,%edx
  8022de:	74 a1                	je     802281 <__umoddi3+0x65>
  8022e0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8022e3:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8022e6:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8022e9:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8022ec:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8022ef:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8022f2:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8022f5:	89 01                	mov    %eax,(%ecx)
  8022f7:	89 51 04             	mov    %edx,0x4(%ecx)
  8022fa:	eb 85                	jmp    802281 <__umoddi3+0x65>
  8022fc:	85 f6                	test   %esi,%esi
  8022fe:	75 0b                	jne    80230b <__umoddi3+0xef>
  802300:	b8 01 00 00 00       	mov    $0x1,%eax
  802305:	31 d2                	xor    %edx,%edx
  802307:	f7 f6                	div    %esi
  802309:	89 c6                	mov    %eax,%esi
  80230b:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80230e:	89 fa                	mov    %edi,%edx
  802310:	f7 f6                	div    %esi
  802312:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802315:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802318:	f7 f6                	div    %esi
  80231a:	e9 3d ff ff ff       	jmp    80225c <__umoddi3+0x40>
  80231f:	90                   	nop    
  802320:	b8 20 00 00 00       	mov    $0x20,%eax
  802325:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802328:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  80232b:	89 fa                	mov    %edi,%edx
  80232d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802330:	d3 e2                	shl    %cl,%edx
  802332:	89 f0                	mov    %esi,%eax
  802334:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802337:	d3 e8                	shr    %cl,%eax
  802339:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80233c:	d3 e6                	shl    %cl,%esi
  80233e:	89 d7                	mov    %edx,%edi
  802340:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802343:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802346:	09 c7                	or     %eax,%edi
  802348:	d3 ea                	shr    %cl,%edx
  80234a:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80234d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802350:	d3 e0                	shl    %cl,%eax
  802352:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802355:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802358:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80235b:	d3 e8                	shr    %cl,%eax
  80235d:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802360:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802363:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802366:	f7 f7                	div    %edi
  802368:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80236b:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  80236e:	f7 e6                	mul    %esi
  802370:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802373:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802376:	77 0a                	ja     802382 <__umoddi3+0x166>
  802378:	75 12                	jne    80238c <__umoddi3+0x170>
  80237a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80237d:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802380:	76 0a                	jbe    80238c <__umoddi3+0x170>
  802382:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802385:	29 f1                	sub    %esi,%ecx
  802387:	19 fa                	sbb    %edi,%edx
  802389:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  80238c:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80238f:	85 c0                	test   %eax,%eax
  802391:	0f 84 ea fe ff ff    	je     802281 <__umoddi3+0x65>
  802397:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80239a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80239d:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  8023a0:	19 d1                	sbb    %edx,%ecx
  8023a2:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  8023a5:	89 ca                	mov    %ecx,%edx
  8023a7:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8023aa:	d3 e2                	shl    %cl,%edx
  8023ac:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8023af:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8023b2:	d3 e8                	shr    %cl,%eax
  8023b4:	09 c2                	or     %eax,%edx
  8023b6:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8023b9:	d3 e8                	shr    %cl,%eax
  8023bb:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8023be:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8023c1:	e9 ad fe ff ff       	jmp    802273 <__umoddi3+0x57>
