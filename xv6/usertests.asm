
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 a8 45 00 00       	mov    0x45a8,%eax
       b:	c7 44 24 04 40 33 00 	movl   $0x3340,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 65 2f 00 00       	call   2f80 <printf>
  fd = open("echo", 0);
      1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      22:	00 
      23:	c7 04 24 4b 33 00 00 	movl   $0x334b,(%esp)
      2a:	e8 59 2e 00 00       	call   2e88 <open>
  if(fd < 0){
      2f:	85 c0                	test   %eax,%eax
      31:	78 37                	js     6a <opentest+0x6a>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 35 2e 00 00       	call   2e70 <close>
  fd = open("doesnotexist", 0);
      3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      42:	00 
      43:	c7 04 24 63 33 00 00 	movl   $0x3363,(%esp)
      4a:	e8 39 2e 00 00       	call   2e88 <open>
  if(fd >= 0){
      4f:	85 c0                	test   %eax,%eax
      51:	79 31                	jns    84 <opentest+0x84>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
      53:	a1 a8 45 00 00       	mov    0x45a8,%eax
      58:	c7 44 24 04 8e 33 00 	movl   $0x338e,0x4(%esp)
      5f:	00 
      60:	89 04 24             	mov    %eax,(%esp)
      63:	e8 18 2f 00 00       	call   2f80 <printf>
}
      68:	c9                   	leave  
      69:	c3                   	ret    
  int fd;

  printf(stdout, "open test\n");
  fd = open("echo", 0);
  if(fd < 0){
    printf(stdout, "open echo failed!\n");
      6a:	a1 a8 45 00 00       	mov    0x45a8,%eax
      6f:	c7 44 24 04 50 33 00 	movl   $0x3350,0x4(%esp)
      76:	00 
      77:	89 04 24             	mov    %eax,(%esp)
      7a:	e8 01 2f 00 00       	call   2f80 <printf>
    exit();
      7f:	e8 c4 2d 00 00       	call   2e48 <exit>
  }
  close(fd);
  fd = open("doesnotexist", 0);
  if(fd >= 0){
    printf(stdout, "open doesnotexist succeeded!\n");
      84:	a1 a8 45 00 00       	mov    0x45a8,%eax
      89:	c7 44 24 04 70 33 00 	movl   $0x3370,0x4(%esp)
      90:	00 
      91:	89 04 24             	mov    %eax,(%esp)
      94:	e8 e7 2e 00 00       	call   2f80 <printf>
    exit();
      99:	e8 aa 2d 00 00       	call   2e48 <exit>
      9e:	66 90                	xchg   %ax,%ax

000000a0 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
      a0:	55                   	push   %ebp
      a1:	89 e5                	mov    %esp,%ebp
      a3:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
      a4:	31 db                	xor    %ebx,%ebx
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
      a6:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
      a9:	c7 44 24 04 9c 33 00 	movl   $0x339c,0x4(%esp)
      b0:	00 
      b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      b8:	e8 c3 2e 00 00       	call   2f80 <printf>
      bd:	eb 13                	jmp    d2 <forktest+0x32>
      bf:	90                   	nop    

  for(n=0; n<1000; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
      c0:	0f 84 7e 00 00 00    	je     144 <forktest+0xa4>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
      c6:	83 c3 01             	add    $0x1,%ebx
      c9:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
      cf:	90                   	nop    
      d0:	74 5e                	je     130 <forktest+0x90>
      d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = fork();
      d8:	e8 63 2d 00 00       	call   2e40 <fork>
    if(pid < 0)
      dd:	83 f8 00             	cmp    $0x0,%eax
      e0:	7d de                	jge    c0 <forktest+0x20>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
      e2:	85 db                	test   %ebx,%ebx
      e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      e8:	74 18                	je     102 <forktest+0x62>
      ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
      f0:	e8 5b 2d 00 00       	call   2e50 <wait>
      f5:	85 c0                	test   %eax,%eax
      f7:	90                   	nop    
      f8:	78 4f                	js     149 <forktest+0xa9>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
      fa:	83 eb 01             	sub    $0x1,%ebx
      fd:	8d 76 00             	lea    0x0(%esi),%esi
     100:	75 ee                	jne    f0 <forktest+0x50>
     102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
     108:	e8 43 2d 00 00       	call   2e50 <wait>
     10d:	83 c0 01             	add    $0x1,%eax
     110:	75 50                	jne    162 <forktest+0xc2>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
     112:	c7 44 24 04 ce 33 00 	movl   $0x33ce,0x4(%esp)
     119:	00 
     11a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     121:	e8 5a 2e 00 00       	call   2f80 <printf>
}
     126:	83 c4 14             	add    $0x14,%esp
     129:	5b                   	pop    %ebx
     12a:	5d                   	pop    %ebp
     12b:	c3                   	ret    
     12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
     130:	c7 44 24 04 24 40 00 	movl   $0x4024,0x4(%esp)
     137:	00 
     138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     13f:	e8 3c 2e 00 00       	call   2f80 <printf>
    exit();
     144:	e8 ff 2c 00 00       	call   2e48 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
     149:	c7 44 24 04 a7 33 00 	movl   $0x33a7,0x4(%esp)
     150:	00 
     151:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     158:	e8 23 2e 00 00       	call   2f80 <printf>
      exit();
     15d:	e8 e6 2c 00 00       	call   2e48 <exit>
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
     162:	c7 44 24 04 bb 33 00 	movl   $0x33bb,0x4(%esp)
     169:	00 
     16a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     171:	e8 0a 2e 00 00       	call   2f80 <printf>
    exit();
     176:	e8 cd 2c 00 00       	call   2e48 <exit>
     17b:	90                   	nop    
     17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000180 <exitwait>:
}

// try to find any races between exit and wait
void
exitwait(void)
{
     180:	55                   	push   %ebp
     181:	89 e5                	mov    %esp,%ebp
     183:	56                   	push   %esi
     184:	31 f6                	xor    %esi,%esi
     186:	53                   	push   %ebx
     187:	83 ec 10             	sub    $0x10,%esp
     18a:	eb 1e                	jmp    1aa <exitwait+0x2a>
     18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     190:	0f 84 7d 00 00 00    	je     213 <exitwait+0x93>
      if(wait() != pid){
     196:	e8 b5 2c 00 00       	call   2e50 <wait>
     19b:	39 c3                	cmp    %eax,%ebx
     19d:	8d 76 00             	lea    0x0(%esi),%esi
     1a0:	75 36                	jne    1d8 <exitwait+0x58>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     1a2:	83 c6 01             	add    $0x1,%esi
     1a5:	83 fe 64             	cmp    $0x64,%esi
     1a8:	74 4e                	je     1f8 <exitwait+0x78>
     1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = fork();
     1b0:	e8 8b 2c 00 00       	call   2e40 <fork>
    if(pid < 0){
     1b5:	83 f8 00             	cmp    $0x0,%eax
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     1b8:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     1ba:	7d d4                	jge    190 <exitwait+0x10>
      printf(1, "fork failed\n");
     1bc:	c7 44 24 04 dc 33 00 	movl   $0x33dc,0x4(%esp)
     1c3:	00 
     1c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1cb:	e8 b0 2d 00 00       	call   2f80 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     1d0:	83 c4 10             	add    $0x10,%esp
     1d3:	5b                   	pop    %ebx
     1d4:	5e                   	pop    %esi
     1d5:	5d                   	pop    %ebp
     1d6:	c3                   	ret    
     1d7:	90                   	nop    
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
     1d8:	c7 44 24 04 e9 33 00 	movl   $0x33e9,0x4(%esp)
     1df:	00 
     1e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1e7:	e8 94 2d 00 00       	call   2f80 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     1ec:	83 c4 10             	add    $0x10,%esp
     1ef:	5b                   	pop    %ebx
     1f0:	5e                   	pop    %esi
     1f1:	5d                   	pop    %ebp
     1f2:	c3                   	ret    
     1f3:	90                   	nop    
     1f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     1f8:	c7 44 24 04 f9 33 00 	movl   $0x33f9,0x4(%esp)
     1ff:	00 
     200:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     207:	e8 74 2d 00 00       	call   2f80 <printf>
}
     20c:	83 c4 10             	add    $0x10,%esp
     20f:	5b                   	pop    %ebx
     210:	5e                   	pop    %esi
     211:	5d                   	pop    %ebp
     212:	c3                   	ret    
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
        return;
      }
    } else {
      exit();
     213:	e8 30 2c 00 00       	call   2e48 <exit>
     218:	90                   	nop    
     219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <fourteen>:
  printf(1, "bigfile test ok\n");
}

void
fourteen(void)
{
     220:	55                   	push   %ebp
     221:	89 e5                	mov    %esp,%ebp
     223:	83 ec 08             	sub    $0x8,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
     226:	c7 44 24 04 06 34 00 	movl   $0x3406,0x4(%esp)
     22d:	00 
     22e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     235:	e8 46 2d 00 00       	call   2f80 <printf>

  if(mkdir("12345678901234") != 0){
     23a:	c7 04 24 41 34 00 00 	movl   $0x3441,(%esp)
     241:	e8 6a 2c 00 00       	call   2eb0 <mkdir>
     246:	85 c0                	test   %eax,%eax
     248:	0f 85 9a 00 00 00    	jne    2e8 <fourteen+0xc8>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
     24e:	c7 04 24 48 40 00 00 	movl   $0x4048,(%esp)
     255:	e8 56 2c 00 00       	call   2eb0 <mkdir>
     25a:	85 c0                	test   %eax,%eax
     25c:	0f 85 9f 00 00 00    	jne    301 <fourteen+0xe1>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     262:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     269:	00 
     26a:	c7 04 24 98 40 00 00 	movl   $0x4098,(%esp)
     271:	e8 12 2c 00 00       	call   2e88 <open>
  if(fd < 0){
     276:	85 c0                	test   %eax,%eax
     278:	0f 88 9c 00 00 00    	js     31a <fourteen+0xfa>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 ea 2b 00 00       	call   2e70 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     286:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     28d:	00 
     28e:	c7 04 24 08 41 00 00 	movl   $0x4108,(%esp)
     295:	e8 ee 2b 00 00       	call   2e88 <open>
  if(fd < 0){
     29a:	85 c0                	test   %eax,%eax
     29c:	0f 88 91 00 00 00    	js     333 <fourteen+0x113>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
     2a2:	89 04 24             	mov    %eax,(%esp)
     2a5:	e8 c6 2b 00 00       	call   2e70 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
     2aa:	c7 04 24 32 34 00 00 	movl   $0x3432,(%esp)
     2b1:	e8 fa 2b 00 00       	call   2eb0 <mkdir>
     2b6:	85 c0                	test   %eax,%eax
     2b8:	0f 84 8e 00 00 00    	je     34c <fourteen+0x12c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
     2be:	c7 04 24 a4 41 00 00 	movl   $0x41a4,(%esp)
     2c5:	e8 e6 2b 00 00       	call   2eb0 <mkdir>
     2ca:	85 c0                	test   %eax,%eax
     2cc:	0f 84 93 00 00 00    	je     365 <fourteen+0x145>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
     2d2:	c7 44 24 04 50 34 00 	movl   $0x3450,0x4(%esp)
     2d9:	00 
     2da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2e1:	e8 9a 2c 00 00       	call   2f80 <printf>
}
     2e6:	c9                   	leave  
     2e7:	c3                   	ret    

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");

  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
     2e8:	c7 44 24 04 15 34 00 	movl   $0x3415,0x4(%esp)
     2ef:	00 
     2f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2f7:	e8 84 2c 00 00       	call   2f80 <printf>
    exit();
     2fc:	e8 47 2b 00 00       	call   2e48 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
     301:	c7 44 24 04 68 40 00 	movl   $0x4068,0x4(%esp)
     308:	00 
     309:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     310:	e8 6b 2c 00 00       	call   2f80 <printf>
    exit();
     315:	e8 2e 2b 00 00       	call   2e48 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
  if(fd < 0){
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
     31a:	c7 44 24 04 c8 40 00 	movl   $0x40c8,0x4(%esp)
     321:	00 
     322:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     329:	e8 52 2c 00 00       	call   2f80 <printf>
    exit();
     32e:	e8 15 2b 00 00       	call   2e48 <exit>
  }
  close(fd);
  fd = open("12345678901234/12345678901234/12345678901234", 0);
  if(fd < 0){
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
     333:	c7 44 24 04 38 41 00 	movl   $0x4138,0x4(%esp)
     33a:	00 
     33b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     342:	e8 39 2c 00 00       	call   2f80 <printf>
    exit();
     347:	e8 fc 2a 00 00       	call   2e48 <exit>
  }
  close(fd);

  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
     34c:	c7 44 24 04 74 41 00 	movl   $0x4174,0x4(%esp)
     353:	00 
     354:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     35b:	e8 20 2c 00 00       	call   2f80 <printf>
    exit();
     360:	e8 e3 2a 00 00       	call   2e48 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
     365:	c7 44 24 04 c4 41 00 	movl   $0x41c4,0x4(%esp)
     36c:	00 
     36d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     374:	e8 07 2c 00 00       	call   2f80 <printf>
    exit();
     379:	e8 ca 2a 00 00       	call   2e48 <exit>
     37e:	66 90                	xchg   %ax,%ax

00000380 <iref>:
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	53                   	push   %ebx
  int i, fd;

  printf(1, "empty file name\n");
     384:	31 db                	xor    %ebx,%ebx
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
     386:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(1, "empty file name\n");
     389:	c7 44 24 04 5d 34 00 	movl   $0x345d,0x4(%esp)
     390:	00 
     391:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     398:	e8 e3 2b 00 00       	call   2f80 <printf>
     39d:	8d 76 00             	lea    0x0(%esi),%esi

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
     3a0:	c7 04 24 6e 34 00 00 	movl   $0x346e,(%esp)
     3a7:	e8 04 2b 00 00       	call   2eb0 <mkdir>
     3ac:	85 c0                	test   %eax,%eax
     3ae:	0f 85 b2 00 00 00    	jne    466 <iref+0xe6>
      printf(1, "mkdir irefd failed\n");
      exit();
    }
    if(chdir("irefd") != 0){
     3b4:	c7 04 24 6e 34 00 00 	movl   $0x346e,(%esp)
     3bb:	e8 f8 2a 00 00       	call   2eb8 <chdir>
     3c0:	85 c0                	test   %eax,%eax
     3c2:	0f 85 b7 00 00 00    	jne    47f <iref+0xff>
      printf(1, "chdir irefd failed\n");
      exit();
    }

    mkdir("");
     3c8:	c7 04 24 1f 3f 00 00 	movl   $0x3f1f,(%esp)
     3cf:	e8 dc 2a 00 00       	call   2eb0 <mkdir>
    link("README", "");
     3d4:	c7 44 24 04 1f 3f 00 	movl   $0x3f1f,0x4(%esp)
     3db:	00 
     3dc:	c7 04 24 9c 34 00 00 	movl   $0x349c,(%esp)
     3e3:	e8 c0 2a 00 00       	call   2ea8 <link>
    fd = open("", O_CREATE);
     3e8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     3ef:	00 
     3f0:	c7 04 24 1f 3f 00 00 	movl   $0x3f1f,(%esp)
     3f7:	e8 8c 2a 00 00       	call   2e88 <open>
    if(fd >= 0)
     3fc:	85 c0                	test   %eax,%eax
     3fe:	78 08                	js     408 <iref+0x88>
      close(fd);
     400:	89 04 24             	mov    %eax,(%esp)
     403:	e8 68 2a 00 00       	call   2e70 <close>
    fd = open("xx", O_CREATE);
     408:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     40f:	00 
     410:	c7 04 24 0e 3a 00 00 	movl   $0x3a0e,(%esp)
     417:	e8 6c 2a 00 00       	call   2e88 <open>
    if(fd >= 0)
     41c:	85 c0                	test   %eax,%eax
     41e:	78 08                	js     428 <iref+0xa8>
      close(fd);
     420:	89 04 24             	mov    %eax,(%esp)
     423:	e8 48 2a 00 00       	call   2e70 <close>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
     428:	83 c3 01             	add    $0x1,%ebx
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
     42b:	c7 04 24 0e 3a 00 00 	movl   $0x3a0e,(%esp)
     432:	e8 61 2a 00 00       	call   2e98 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
     437:	83 fb 33             	cmp    $0x33,%ebx
     43a:	0f 85 60 ff ff ff    	jne    3a0 <iref+0x20>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
     440:	c7 04 24 a3 34 00 00 	movl   $0x34a3,(%esp)
     447:	e8 6c 2a 00 00       	call   2eb8 <chdir>
  printf(1, "empty file name OK\n");
     44c:	c7 44 24 04 a5 34 00 	movl   $0x34a5,0x4(%esp)
     453:	00 
     454:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     45b:	e8 20 2b 00 00       	call   2f80 <printf>
}
     460:	83 c4 14             	add    $0x14,%esp
     463:	5b                   	pop    %ebx
     464:	5d                   	pop    %ebp
     465:	c3                   	ret    
  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
     466:	c7 44 24 04 74 34 00 	movl   $0x3474,0x4(%esp)
     46d:	00 
     46e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     475:	e8 06 2b 00 00       	call   2f80 <printf>
      exit();
     47a:	e8 c9 29 00 00       	call   2e48 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
     47f:	c7 44 24 04 88 34 00 	movl   $0x3488,0x4(%esp)
     486:	00 
     487:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     48e:	e8 ed 2a 00 00       	call   2f80 <printf>
      exit();
     493:	e8 b0 29 00 00       	call   2e48 <exit>
     498:	90                   	nop    
     499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004a0 <rmdot>:
  printf(1, "fourteen ok\n");
}

void
rmdot(void)
{
     4a0:	55                   	push   %ebp
     4a1:	89 e5                	mov    %esp,%ebp
     4a3:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
     4a6:	c7 44 24 04 b9 34 00 	movl   $0x34b9,0x4(%esp)
     4ad:	00 
     4ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4b5:	e8 c6 2a 00 00       	call   2f80 <printf>
  if(mkdir("dots") != 0){
     4ba:	c7 04 24 c5 34 00 00 	movl   $0x34c5,(%esp)
     4c1:	e8 ea 29 00 00       	call   2eb0 <mkdir>
     4c6:	85 c0                	test   %eax,%eax
     4c8:	0f 85 a2 00 00 00    	jne    570 <rmdot+0xd0>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
     4ce:	c7 04 24 c5 34 00 00 	movl   $0x34c5,(%esp)
     4d5:	e8 de 29 00 00       	call   2eb8 <chdir>
     4da:	85 c0                	test   %eax,%eax
     4dc:	0f 85 a7 00 00 00    	jne    589 <rmdot+0xe9>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
     4e2:	c7 04 24 2c 39 00 00 	movl   $0x392c,(%esp)
     4e9:	e8 aa 29 00 00       	call   2e98 <unlink>
     4ee:	85 c0                	test   %eax,%eax
     4f0:	0f 84 ac 00 00 00    	je     5a2 <rmdot+0x102>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
     4f6:	c7 04 24 2b 39 00 00 	movl   $0x392b,(%esp)
     4fd:	e8 96 29 00 00       	call   2e98 <unlink>
     502:	85 c0                	test   %eax,%eax
     504:	0f 84 b1 00 00 00    	je     5bb <rmdot+0x11b>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
     50a:	c7 04 24 a3 34 00 00 	movl   $0x34a3,(%esp)
     511:	e8 a2 29 00 00       	call   2eb8 <chdir>
     516:	85 c0                	test   %eax,%eax
     518:	0f 85 b6 00 00 00    	jne    5d4 <rmdot+0x134>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
     51e:	c7 04 24 1d 35 00 00 	movl   $0x351d,(%esp)
     525:	e8 6e 29 00 00       	call   2e98 <unlink>
     52a:	85 c0                	test   %eax,%eax
     52c:	0f 84 bb 00 00 00    	je     5ed <rmdot+0x14d>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
     532:	c7 04 24 3b 35 00 00 	movl   $0x353b,(%esp)
     539:	e8 5a 29 00 00       	call   2e98 <unlink>
     53e:	85 c0                	test   %eax,%eax
     540:	0f 84 c0 00 00 00    	je     606 <rmdot+0x166>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
     546:	c7 04 24 c5 34 00 00 	movl   $0x34c5,(%esp)
     54d:	e8 46 29 00 00       	call   2e98 <unlink>
     552:	85 c0                	test   %eax,%eax
     554:	0f 85 c5 00 00 00    	jne    61f <rmdot+0x17f>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
     55a:	c7 44 24 04 70 35 00 	movl   $0x3570,0x4(%esp)
     561:	00 
     562:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     569:	e8 12 2a 00 00       	call   2f80 <printf>
}
     56e:	c9                   	leave  
     56f:	c3                   	ret    
void
rmdot(void)
{
  printf(1, "rmdot test\n");
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
     570:	c7 44 24 04 ca 34 00 	movl   $0x34ca,0x4(%esp)
     577:	00 
     578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     57f:	e8 fc 29 00 00       	call   2f80 <printf>
    exit();
     584:	e8 bf 28 00 00       	call   2e48 <exit>
  }
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
     589:	c7 44 24 04 dd 34 00 	movl   $0x34dd,0x4(%esp)
     590:	00 
     591:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     598:	e8 e3 29 00 00       	call   2f80 <printf>
    exit();
     59d:	e8 a6 28 00 00       	call   2e48 <exit>
  }
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
     5a2:	c7 44 24 04 f0 34 00 	movl   $0x34f0,0x4(%esp)
     5a9:	00 
     5aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5b1:	e8 ca 29 00 00       	call   2f80 <printf>
    exit();
     5b6:	e8 8d 28 00 00       	call   2e48 <exit>
  }
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
     5bb:	c7 44 24 04 fe 34 00 	movl   $0x34fe,0x4(%esp)
     5c2:	00 
     5c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5ca:	e8 b1 29 00 00       	call   2f80 <printf>
    exit();
     5cf:	e8 74 28 00 00       	call   2e48 <exit>
  }
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
     5d4:	c7 44 24 04 0d 35 00 	movl   $0x350d,0x4(%esp)
     5db:	00 
     5dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5e3:	e8 98 29 00 00       	call   2f80 <printf>
    exit();
     5e8:	e8 5b 28 00 00       	call   2e48 <exit>
  }
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
     5ed:	c7 44 24 04 24 35 00 	movl   $0x3524,0x4(%esp)
     5f4:	00 
     5f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5fc:	e8 7f 29 00 00       	call   2f80 <printf>
    exit();
     601:	e8 42 28 00 00       	call   2e48 <exit>
  }
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
     606:	c7 44 24 04 43 35 00 	movl   $0x3543,0x4(%esp)
     60d:	00 
     60e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     615:	e8 66 29 00 00       	call   2f80 <printf>
    exit();
     61a:	e8 29 28 00 00       	call   2e48 <exit>
  }
  if(unlink("dots") != 0){
    printf(1, "unlink dots failed!\n");
     61f:	c7 44 24 04 5b 35 00 	movl   $0x355b,0x4(%esp)
     626:	00 
     627:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     62e:	e8 4d 29 00 00       	call   2f80 <printf>
    exit();
     633:	e8 10 28 00 00       	call   2e48 <exit>
     638:	90                   	nop    
     639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000640 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	56                   	push   %esi
     644:	53                   	push   %ebx
     645:	83 ec 20             	sub    $0x20,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
     648:	c7 44 24 04 7a 35 00 	movl   $0x357a,0x4(%esp)
     64f:	00 
     650:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     657:	e8 24 29 00 00       	call   2f80 <printf>
  unlink("bd");
     65c:	c7 04 24 87 35 00 00 	movl   $0x3587,(%esp)
     663:	e8 30 28 00 00       	call   2e98 <unlink>

  fd = open("bd", O_CREATE);
     668:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     66f:	00 
     670:	c7 04 24 87 35 00 00 	movl   $0x3587,(%esp)
     677:	e8 0c 28 00 00       	call   2e88 <open>
  if(fd < 0){
     67c:	85 c0                	test   %eax,%eax
     67e:	0f 88 e6 00 00 00    	js     76a <bigdir+0x12a>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
     684:	89 04 24             	mov    %eax,(%esp)
     687:	31 db                	xor    %ebx,%ebx
     689:	e8 e2 27 00 00       	call   2e70 <close>
     68e:	8d 75 ee             	lea    -0x12(%ebp),%esi
     691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     698:	89 d8                	mov    %ebx,%eax
     69a:	c1 f8 06             	sar    $0x6,%eax
     69d:	83 c0 30             	add    $0x30,%eax
     6a0:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     6a3:	89 d8                	mov    %ebx,%eax
     6a5:	83 e0 3f             	and    $0x3f,%eax
     6a8:	83 c0 30             	add    $0x30,%eax
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
     6ab:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
     6af:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
     6b2:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
     6b6:	89 74 24 04          	mov    %esi,0x4(%esp)
     6ba:	c7 04 24 87 35 00 00 	movl   $0x3587,(%esp)
     6c1:	e8 e2 27 00 00       	call   2ea8 <link>
     6c6:	85 c0                	test   %eax,%eax
     6c8:	75 6c                	jne    736 <bigdir+0xf6>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
     6ca:	83 c3 01             	add    $0x1,%ebx
     6cd:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     6d3:	75 c3                	jne    698 <bigdir+0x58>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
     6d5:	c7 04 24 87 35 00 00 	movl   $0x3587,(%esp)
     6dc:	66 31 db             	xor    %bx,%bx
     6df:	e8 b4 27 00 00       	call   2e98 <unlink>
     6e4:	eb 0d                	jmp    6f3 <bigdir+0xb3>
     6e6:	66 90                	xchg   %ax,%ax
  for(i = 0; i < 500; i++){
     6e8:	83 c3 01             	add    $0x1,%ebx
     6eb:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     6f1:	74 5c                	je     74f <bigdir+0x10f>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     6f3:	89 d8                	mov    %ebx,%eax
     6f5:	c1 f8 06             	sar    $0x6,%eax
     6f8:	83 c0 30             	add    $0x30,%eax
     6fb:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     6fe:	89 d8                	mov    %ebx,%eax
     700:	83 e0 3f             	and    $0x3f,%eax
     703:	83 c0 30             	add    $0x30,%eax
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
     706:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
     70a:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
     70d:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
     711:	89 34 24             	mov    %esi,(%esp)
     714:	e8 7f 27 00 00       	call   2e98 <unlink>
     719:	85 c0                	test   %eax,%eax
     71b:	74 cb                	je     6e8 <bigdir+0xa8>
      printf(1, "bigdir unlink failed");
     71d:	c7 44 24 04 b4 35 00 	movl   $0x35b4,0x4(%esp)
     724:	00 
     725:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     72c:	e8 4f 28 00 00       	call   2f80 <printf>
      exit();
     731:	e8 12 27 00 00       	call   2e48 <exit>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
      printf(1, "bigdir link failed\n");
     736:	c7 44 24 04 a0 35 00 	movl   $0x35a0,0x4(%esp)
     73d:	00 
     73e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     745:	e8 36 28 00 00       	call   2f80 <printf>
      exit();
     74a:	e8 f9 26 00 00       	call   2e48 <exit>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
     74f:	c7 44 24 04 c9 35 00 	movl   $0x35c9,0x4(%esp)
     756:	00 
     757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     75e:	e8 1d 28 00 00       	call   2f80 <printf>
}
     763:	83 c4 20             	add    $0x20,%esp
     766:	5b                   	pop    %ebx
     767:	5e                   	pop    %esi
     768:	5d                   	pop    %ebp
     769:	c3                   	ret    
  printf(1, "bigdir test\n");
  unlink("bd");

  fd = open("bd", O_CREATE);
  if(fd < 0){
    printf(1, "bigdir create failed\n");
     76a:	c7 44 24 04 8a 35 00 	movl   $0x358a,0x4(%esp)
     771:	00 
     772:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     779:	e8 02 28 00 00       	call   2f80 <printf>
    exit();
     77e:	e8 c5 26 00 00       	call   2e48 <exit>
     783:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000790 <createdelete>:
}

// two processes create and delete different files in same directory
void
createdelete(void)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	57                   	push   %edi
     794:	56                   	push   %esi
     795:	53                   	push   %ebx
     796:	83 ec 3c             	sub    $0x3c,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     799:	c7 44 24 04 d4 35 00 	movl   $0x35d4,0x4(%esp)
     7a0:	00 
     7a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7a8:	e8 d3 27 00 00       	call   2f80 <printf>
  pid = fork();
     7ad:	e8 8e 26 00 00       	call   2e40 <fork>
  if(pid < 0){
     7b2:	85 c0                	test   %eax,%eax
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
     7b4:	89 c6                	mov    %eax,%esi
  if(pid < 0){
     7b6:	0f 88 6b 02 00 00    	js     a27 <createdelete+0x297>
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     7bc:	83 f8 01             	cmp    $0x1,%eax
     7bf:	19 c0                	sbb    %eax,%eax
  name[2] = '\0';
     7c1:	31 db                	xor    %ebx,%ebx
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     7c3:	83 e0 f3             	and    $0xfffffff3,%eax
     7c6:	83 c0 70             	add    $0x70,%eax
     7c9:	88 45 d4             	mov    %al,-0x2c(%ebp)
  name[2] = '\0';
     7cc:	c6 45 d6 00          	movb   $0x0,-0x2a(%ebp)
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     7d0:	8d 43 30             	lea    0x30(%ebx),%eax
     7d3:	88 45 d5             	mov    %al,-0x2b(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
     7d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
     7d9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7e0:	00 
     7e1:	89 04 24             	mov    %eax,(%esp)
     7e4:	e8 9f 26 00 00       	call   2e88 <open>
    if(fd < 0){
     7e9:	85 c0                	test   %eax,%eax
     7eb:	0f 88 dd 01 00 00    	js     9ce <createdelete+0x23e>
      printf(1, "create failed\n");
      exit();
    }
    close(fd);
     7f1:	89 04 24             	mov    %eax,(%esp)
     7f4:	e8 77 26 00 00       	call   2e70 <close>
    if(i > 0 && (i % 2 ) == 0){
     7f9:	85 db                	test   %ebx,%ebx
     7fb:	90                   	nop    
     7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     800:	0f 84 82 01 00 00    	je     988 <createdelete+0x1f8>
     806:	f6 c3 01             	test   $0x1,%bl
     809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     810:	0f 84 82 01 00 00    	je     998 <createdelete+0x208>
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
  for(i = 0; i < N; i++){
     816:	83 c3 01             	add    $0x1,%ebx
     819:	83 fb 13             	cmp    $0x13,%ebx
     81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     820:	7e ae                	jle    7d0 <createdelete+0x40>
        exit();
      }
    }
  }

  if(pid==0)
     822:	85 f6                	test   %esi,%esi
     824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     828:	0f 84 d4 01 00 00    	je     a02 <createdelete+0x272>
     82e:	66 90                	xchg   %ax,%ax
    exit();
  else
    wait();
     830:	e8 1b 26 00 00       	call   2e50 <wait>
     835:	31 db                	xor    %ebx,%ebx
     837:	90                   	nop    

  for(i = 0; i < N; i++){
    name[0] = 'p';
     838:	8d 7b 30             	lea    0x30(%ebx),%edi
    name[1] = '0' + i;
     83b:	89 f9                	mov    %edi,%ecx
    fd = open(name, 0);
     83d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  else
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
     840:	88 4d d5             	mov    %cl,-0x2b(%ebp)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
     843:	c6 45 d4 70          	movb   $0x70,-0x2c(%ebp)
    name[1] = '0' + i;
    fd = open(name, 0);
     847:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     84e:	00 
     84f:	89 04 24             	mov    %eax,(%esp)
     852:	e8 31 26 00 00       	call   2e88 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     857:	85 db                	test   %ebx,%ebx
     859:	0f 94 c2             	sete   %dl
     85c:	83 fb 09             	cmp    $0x9,%ebx
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    fd = open(name, 0);
     85f:	89 c1                	mov    %eax,%ecx
    if((i == 0 || i >= N/2) && fd < 0){
     861:	0f 9f c0             	setg   %al
     864:	08 c2                	or     %al,%dl
     866:	88 55 d3             	mov    %dl,-0x2d(%ebp)
     869:	74 08                	je     873 <createdelete+0xe3>
     86b:	85 c9                	test   %ecx,%ecx
     86d:	0f 88 74 01 00 00    	js     9e7 <createdelete+0x257>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     873:	8d 43 ff             	lea    -0x1(%ebx),%eax
     876:	83 f8 08             	cmp    $0x8,%eax
     879:	0f 96 c0             	setbe  %al
     87c:	89 c6                	mov    %eax,%esi
     87e:	89 c8                	mov    %ecx,%eax
     880:	f7 d0                	not    %eax
     882:	89 f2                	mov    %esi,%edx
     884:	c1 e8 1f             	shr    $0x1f,%eax
     887:	84 d2                	test   %dl,%dl
     889:	74 25                	je     8b0 <createdelete+0x120>
     88b:	84 c0                	test   %al,%al
     88d:	74 2d                	je     8bc <createdelete+0x12c>
      printf(1, "oops createdelete %s did exist\n", name);
     88f:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
     892:	89 4c 24 08          	mov    %ecx,0x8(%esp)
     896:	c7 44 24 04 1c 42 00 	movl   $0x421c,0x4(%esp)
     89d:	00 
     89e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8a5:	e8 d6 26 00 00       	call   2f80 <printf>
      exit();
     8aa:	e8 99 25 00 00       	call   2e48 <exit>
     8af:	90                   	nop    
    }
    if(fd >= 0)
     8b0:	84 c0                	test   %al,%al
     8b2:	74 08                	je     8bc <createdelete+0x12c>
      close(fd);
     8b4:	89 0c 24             	mov    %ecx,(%esp)
     8b7:	e8 b4 25 00 00       	call   2e70 <close>

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
     8bc:	8d 55 d4             	lea    -0x2c(%ebp),%edx
    }
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
    name[1] = '0' + i;
     8bf:	89 f8                	mov    %edi,%eax
    fd = open(name, 0);
     8c1:	89 14 24             	mov    %edx,(%esp)
      exit();
    }
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
     8c4:	c6 45 d4 63          	movb   $0x63,-0x2c(%ebp)
    name[1] = '0' + i;
     8c8:	88 45 d5             	mov    %al,-0x2b(%ebp)
    fd = open(name, 0);
     8cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8d2:	00 
     8d3:	e8 b0 25 00 00       	call   2e88 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     8d8:	80 7d d3 00          	cmpb   $0x0,-0x2d(%ebp)
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
     8dc:	89 c2                	mov    %eax,%edx
    if((i == 0 || i >= N/2) && fd < 0){
     8de:	74 08                	je     8e8 <createdelete+0x158>
     8e0:	85 c0                	test   %eax,%eax
     8e2:	0f 88 1f 01 00 00    	js     a07 <createdelete+0x277>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     8e8:	89 d0                	mov    %edx,%eax
     8ea:	89 f1                	mov    %esi,%ecx
     8ec:	f7 d0                	not    %eax
     8ee:	c1 e8 1f             	shr    $0x1f,%eax
     8f1:	84 c9                	test   %cl,%cl
     8f3:	74 2b                	je     920 <createdelete+0x190>
     8f5:	84 c0                	test   %al,%al
     8f7:	74 33                	je     92c <createdelete+0x19c>
      printf(1, "oops createdelete %s did exist\n", name);
     8f9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
     8fc:	89 44 24 08          	mov    %eax,0x8(%esp)
     900:	c7 44 24 04 1c 42 00 	movl   $0x421c,0x4(%esp)
     907:	00 
     908:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     90f:	e8 6c 26 00 00       	call   2f80 <printf>
      exit();
     914:	e8 2f 25 00 00       	call   2e48 <exit>
     919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    if(fd >= 0)
     920:	84 c0                	test   %al,%al
     922:	74 08                	je     92c <createdelete+0x19c>
      close(fd);
     924:	89 14 24             	mov    %edx,(%esp)
     927:	e8 44 25 00 00       	call   2e70 <close>
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
     92c:	83 c3 01             	add    $0x1,%ebx
     92f:	83 fb 14             	cmp    $0x14,%ebx
     932:	0f 85 00 ff ff ff    	jne    838 <createdelete+0xa8>
     938:	bb 30 00 00 00       	mov    $0x30,%ebx
     93d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    unlink(name);
     940:	8d 55 d4             	lea    -0x2c(%ebp),%edx
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
     943:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    unlink(name);
    name[0] = 'c';
    unlink(name);
     946:	83 c3 01             	add    $0x1,%ebx
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    unlink(name);
     949:	89 14 24             	mov    %edx,(%esp)
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
     94c:	c6 45 d4 70          	movb   $0x70,-0x2c(%ebp)
    name[1] = '0' + i;
    unlink(name);
     950:	e8 43 25 00 00       	call   2e98 <unlink>
    name[0] = 'c';
    unlink(name);
     955:	8d 4d d4             	lea    -0x2c(%ebp),%ecx

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    unlink(name);
    name[0] = 'c';
     958:	c6 45 d4 63          	movb   $0x63,-0x2c(%ebp)
    unlink(name);
     95c:	89 0c 24             	mov    %ecx,(%esp)
     95f:	e8 34 25 00 00       	call   2e98 <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
     964:	80 fb 44             	cmp    $0x44,%bl
     967:	75 d7                	jne    940 <createdelete+0x1b0>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
     969:	c7 44 24 04 f6 35 00 	movl   $0x35f6,0x4(%esp)
     970:	00 
     971:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     978:	e8 03 26 00 00       	call   2f80 <printf>
}
     97d:	83 c4 3c             	add    $0x3c,%esp
     980:	5b                   	pop    %ebx
     981:	5e                   	pop    %esi
     982:	5f                   	pop    %edi
     983:	5d                   	pop    %ebp
     984:	c3                   	ret    
     985:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
     988:	bb 01 00 00 00       	mov    $0x1,%ebx
     98d:	e9 3e fe ff ff       	jmp    7d0 <createdelete+0x40>
     992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "create failed\n");
      exit();
    }
    close(fd);
    if(i > 0 && (i % 2 ) == 0){
      name[1] = '0' + (i / 2);
     998:	89 d8                	mov    %ebx,%eax
     99a:	d1 f8                	sar    %eax
     99c:	83 c0 30             	add    $0x30,%eax
      if(unlink(name) < 0){
     99f:	8d 55 d4             	lea    -0x2c(%ebp),%edx
      printf(1, "create failed\n");
      exit();
    }
    close(fd);
    if(i > 0 && (i % 2 ) == 0){
      name[1] = '0' + (i / 2);
     9a2:	88 45 d5             	mov    %al,-0x2b(%ebp)
      if(unlink(name) < 0){
     9a5:	89 14 24             	mov    %edx,(%esp)
     9a8:	e8 eb 24 00 00       	call   2e98 <unlink>
     9ad:	85 c0                	test   %eax,%eax
     9af:	0f 89 61 fe ff ff    	jns    816 <createdelete+0x86>
        printf(1, "unlink failed\n");
     9b5:	c7 44 24 04 e7 35 00 	movl   $0x35e7,0x4(%esp)
     9bc:	00 
     9bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9c4:	e8 b7 25 00 00       	call   2f80 <printf>
        exit();
     9c9:	e8 7a 24 00 00       	call   2e48 <exit>
  name[2] = '\0';
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
    fd = open(name, O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "create failed\n");
     9ce:	c7 44 24 04 91 35 00 	movl   $0x3591,0x4(%esp)
     9d5:	00 
     9d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9dd:	e8 9e 25 00 00       	call   2f80 <printf>
      exit();
     9e2:	e8 61 24 00 00       	call   2e48 <exit>
  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     9e7:	8d 55 d4             	lea    -0x2c(%ebp),%edx
     9ea:	89 54 24 08          	mov    %edx,0x8(%esp)
     9ee:	c7 44 24 04 f8 41 00 	movl   $0x41f8,0x4(%esp)
     9f5:	00 
     9f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9fd:	e8 7e 25 00 00       	call   2f80 <printf>
      exit();
     a02:	e8 41 24 00 00       	call   2e48 <exit>

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     a07:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
     a0a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
     a0e:	c7 44 24 04 f8 41 00 	movl   $0x41f8,0x4(%esp)
     a15:	00 
     a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a1d:	e8 5e 25 00 00       	call   2f80 <printf>
      exit();
     a22:	e8 21 24 00 00       	call   2e48 <exit>
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
     a27:	c7 44 24 04 dc 33 00 	movl   $0x33dc,0x4(%esp)
     a2e:	00 
     a2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a36:	e8 45 25 00 00       	call   2f80 <printf>
    exit();
     a3b:	e8 08 24 00 00       	call   2e48 <exit>

00000a40 <dirtest>:
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
}

void dirtest(void)
{
     a40:	55                   	push   %ebp
     a41:	89 e5                	mov    %esp,%ebp
     a43:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     a46:	a1 a8 45 00 00       	mov    0x45a8,%eax
     a4b:	c7 44 24 04 07 36 00 	movl   $0x3607,0x4(%esp)
     a52:	00 
     a53:	89 04 24             	mov    %eax,(%esp)
     a56:	e8 25 25 00 00       	call   2f80 <printf>

  if(mkdir("dir0") < 0) {
     a5b:	c7 04 24 13 36 00 00 	movl   $0x3613,(%esp)
     a62:	e8 49 24 00 00       	call   2eb0 <mkdir>
     a67:	85 c0                	test   %eax,%eax
     a69:	78 47                	js     ab2 <dirtest+0x72>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0) {
     a6b:	c7 04 24 13 36 00 00 	movl   $0x3613,(%esp)
     a72:	e8 41 24 00 00       	call   2eb8 <chdir>
     a77:	85 c0                	test   %eax,%eax
     a79:	78 51                	js     acc <dirtest+0x8c>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0) {
     a7b:	c7 04 24 2b 39 00 00 	movl   $0x392b,(%esp)
     a82:	e8 31 24 00 00       	call   2eb8 <chdir>
     a87:	85 c0                	test   %eax,%eax
     a89:	78 5b                	js     ae6 <dirtest+0xa6>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0) {
     a8b:	c7 04 24 13 36 00 00 	movl   $0x3613,(%esp)
     a92:	e8 01 24 00 00       	call   2e98 <unlink>
     a97:	85 c0                	test   %eax,%eax
     a99:	78 65                	js     b00 <dirtest+0xc0>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test\n");
     a9b:	a1 a8 45 00 00       	mov    0x45a8,%eax
     aa0:	c7 44 24 04 07 36 00 	movl   $0x3607,0x4(%esp)
     aa7:	00 
     aa8:	89 04 24             	mov    %eax,(%esp)
     aab:	e8 d0 24 00 00       	call   2f80 <printf>
}
     ab0:	c9                   	leave  
     ab1:	c3                   	ret    
void dirtest(void)
{
  printf(stdout, "mkdir test\n");

  if(mkdir("dir0") < 0) {
    printf(stdout, "mkdir failed\n");
     ab2:	a1 a8 45 00 00       	mov    0x45a8,%eax
     ab7:	c7 44 24 04 18 36 00 	movl   $0x3618,0x4(%esp)
     abe:	00 
     abf:	89 04 24             	mov    %eax,(%esp)
     ac2:	e8 b9 24 00 00       	call   2f80 <printf>
    exit();
     ac7:	e8 7c 23 00 00       	call   2e48 <exit>
  }

  if(chdir("dir0") < 0) {
    printf(stdout, "chdir dir0 failed\n");
     acc:	a1 a8 45 00 00       	mov    0x45a8,%eax
     ad1:	c7 44 24 04 26 36 00 	movl   $0x3626,0x4(%esp)
     ad8:	00 
     ad9:	89 04 24             	mov    %eax,(%esp)
     adc:	e8 9f 24 00 00       	call   2f80 <printf>
    exit();
     ae1:	e8 62 23 00 00       	call   2e48 <exit>
  }

  if(chdir("..") < 0) {
    printf(stdout, "chdir .. failed\n");
     ae6:	a1 a8 45 00 00       	mov    0x45a8,%eax
     aeb:	c7 44 24 04 39 36 00 	movl   $0x3639,0x4(%esp)
     af2:	00 
     af3:	89 04 24             	mov    %eax,(%esp)
     af6:	e8 85 24 00 00       	call   2f80 <printf>
    exit();
     afb:	e8 48 23 00 00       	call   2e48 <exit>
  }

  if(unlink("dir0") < 0) {
    printf(stdout, "unlink dir0 failed\n");
     b00:	a1 a8 45 00 00       	mov    0x45a8,%eax
     b05:	c7 44 24 04 4a 36 00 	movl   $0x364a,0x4(%esp)
     b0c:	00 
     b0d:	89 04 24             	mov    %eax,(%esp)
     b10:	e8 6b 24 00 00       	call   2f80 <printf>
    exit();
     b15:	e8 2e 23 00 00       	call   2e48 <exit>
     b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000b20 <createtest>:
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     b20:	55                   	push   %ebp
     b21:	89 e5                	mov    %esp,%ebp
     b23:	53                   	push   %ebx
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
     b24:	bb 30 00 00 00       	mov    $0x30,%ebx
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     b29:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     b2c:	a1 a8 45 00 00       	mov    0x45a8,%eax
     b31:	c7 44 24 04 3c 42 00 	movl   $0x423c,0x4(%esp)
     b38:	00 
     b39:	89 04 24             	mov    %eax,(%esp)
     b3c:	e8 3f 24 00 00       	call   2f80 <printf>

  name[0] = 'a';
     b41:	c6 05 e0 4d 00 00 61 	movb   $0x61,0x4de0
  name[2] = '\0';
     b48:	c6 05 e2 4d 00 00 00 	movb   $0x0,0x4de2
     b4f:	90                   	nop    
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     b50:	88 1d e1 4d 00 00    	mov    %bl,0x4de1
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
     b56:	83 c3 01             	add    $0x1,%ebx

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
     b59:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b60:	00 
     b61:	c7 04 24 e0 4d 00 00 	movl   $0x4de0,(%esp)
     b68:	e8 1b 23 00 00       	call   2e88 <open>
    close(fd);
     b6d:	89 04 24             	mov    %eax,(%esp)
     b70:	e8 fb 22 00 00       	call   2e70 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     b75:	80 fb 64             	cmp    $0x64,%bl
     b78:	75 d6                	jne    b50 <createtest+0x30>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     b7a:	c6 05 e0 4d 00 00 61 	movb   $0x61,0x4de0
  name[2] = '\0';
     b81:	bb 30 00 00 00       	mov    $0x30,%ebx
     b86:	c6 05 e2 4d 00 00 00 	movb   $0x0,0x4de2
     b8d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     b90:	88 1d e1 4d 00 00    	mov    %bl,0x4de1
    unlink(name);
     b96:	83 c3 01             	add    $0x1,%ebx
     b99:	c7 04 24 e0 4d 00 00 	movl   $0x4de0,(%esp)
     ba0:	e8 f3 22 00 00       	call   2e98 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     ba5:	80 fb 64             	cmp    $0x64,%bl
     ba8:	75 e6                	jne    b90 <createtest+0x70>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     baa:	a1 a8 45 00 00       	mov    0x45a8,%eax
     baf:	c7 44 24 04 64 42 00 	movl   $0x4264,0x4(%esp)
     bb6:	00 
     bb7:	89 04 24             	mov    %eax,(%esp)
     bba:	e8 c1 23 00 00       	call   2f80 <printf>
}
     bbf:	83 c4 14             	add    $0x14,%esp
     bc2:	5b                   	pop    %ebx
     bc3:	5d                   	pop    %ebp
     bc4:	c3                   	ret    
     bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bd0 <dirfile>:
  printf(1, "rmdot ok\n");
}

void
dirfile(void)
{
     bd0:	55                   	push   %ebp
     bd1:	89 e5                	mov    %esp,%ebp
     bd3:	53                   	push   %ebx
     bd4:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "dir vs file\n");
     bd7:	c7 44 24 04 5e 36 00 	movl   $0x365e,0x4(%esp)
     bde:	00 
     bdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     be6:	e8 95 23 00 00       	call   2f80 <printf>

  fd = open("dirfile", O_CREATE);
     beb:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     bf2:	00 
     bf3:	c7 04 24 6b 36 00 00 	movl   $0x366b,(%esp)
     bfa:	e8 89 22 00 00       	call   2e88 <open>
  if(fd < 0){
     bff:	85 c0                	test   %eax,%eax
     c01:	0f 88 3a 01 00 00    	js     d41 <dirfile+0x171>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
     c07:	89 04 24             	mov    %eax,(%esp)
     c0a:	e8 61 22 00 00       	call   2e70 <close>
  if(chdir("dirfile") == 0){
     c0f:	c7 04 24 6b 36 00 00 	movl   $0x366b,(%esp)
     c16:	e8 9d 22 00 00       	call   2eb8 <chdir>
     c1b:	85 c0                	test   %eax,%eax
     c1d:	0f 84 37 01 00 00    	je     d5a <dirfile+0x18a>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
     c23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c2a:	00 
     c2b:	c7 04 24 a4 36 00 00 	movl   $0x36a4,(%esp)
     c32:	e8 51 22 00 00       	call   2e88 <open>
  if(fd >= 0){
     c37:	85 c0                	test   %eax,%eax
     c39:	0f 89 e9 00 00 00    	jns    d28 <dirfile+0x158>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
     c3f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     c46:	00 
     c47:	c7 04 24 a4 36 00 00 	movl   $0x36a4,(%esp)
     c4e:	e8 35 22 00 00       	call   2e88 <open>
  if(fd >= 0){
     c53:	85 c0                	test   %eax,%eax
     c55:	0f 89 cd 00 00 00    	jns    d28 <dirfile+0x158>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
     c5b:	c7 04 24 a4 36 00 00 	movl   $0x36a4,(%esp)
     c62:	e8 49 22 00 00       	call   2eb0 <mkdir>
     c67:	85 c0                	test   %eax,%eax
     c69:	0f 84 04 01 00 00    	je     d73 <dirfile+0x1a3>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
     c6f:	c7 04 24 a4 36 00 00 	movl   $0x36a4,(%esp)
     c76:	e8 1d 22 00 00       	call   2e98 <unlink>
     c7b:	85 c0                	test   %eax,%eax
     c7d:	0f 84 09 01 00 00    	je     d8c <dirfile+0x1bc>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
     c83:	c7 44 24 04 a4 36 00 	movl   $0x36a4,0x4(%esp)
     c8a:	00 
     c8b:	c7 04 24 9c 34 00 00 	movl   $0x349c,(%esp)
     c92:	e8 11 22 00 00       	call   2ea8 <link>
     c97:	85 c0                	test   %eax,%eax
     c99:	0f 84 06 01 00 00    	je     da5 <dirfile+0x1d5>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
     c9f:	c7 04 24 6b 36 00 00 	movl   $0x366b,(%esp)
     ca6:	e8 ed 21 00 00       	call   2e98 <unlink>
     cab:	85 c0                	test   %eax,%eax
     cad:	0f 85 0b 01 00 00    	jne    dbe <dirfile+0x1ee>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
     cb3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     cba:	00 
     cbb:	c7 04 24 2c 39 00 00 	movl   $0x392c,(%esp)
     cc2:	e8 c1 21 00 00       	call   2e88 <open>
  if(fd >= 0){
     cc7:	85 c0                	test   %eax,%eax
     cc9:	0f 89 08 01 00 00    	jns    dd7 <dirfile+0x207>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
     ccf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     cd6:	00 
     cd7:	c7 04 24 2c 39 00 00 	movl   $0x392c,(%esp)
     cde:	e8 a5 21 00 00       	call   2e88 <open>
  if(write(fd, "x", 1) > 0){
     ce3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     cea:	00 
     ceb:	c7 44 24 04 0f 3a 00 	movl   $0x3a0f,0x4(%esp)
     cf2:	00 
  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
     cf3:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
     cf5:	89 04 24             	mov    %eax,(%esp)
     cf8:	e8 6b 21 00 00       	call   2e68 <write>
     cfd:	85 c0                	test   %eax,%eax
     cff:	0f 8f eb 00 00 00    	jg     df0 <dirfile+0x220>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
     d05:	89 1c 24             	mov    %ebx,(%esp)
     d08:	e8 63 21 00 00       	call   2e70 <close>

  printf(1, "dir vs file OK\n");
     d0d:	c7 44 24 04 34 37 00 	movl   $0x3734,0x4(%esp)
     d14:	00 
     d15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d1c:	e8 5f 22 00 00       	call   2f80 <printf>
}
     d21:	83 c4 14             	add    $0x14,%esp
     d24:	5b                   	pop    %ebx
     d25:	5d                   	pop    %ebp
     d26:	c3                   	ret    
     d27:	90                   	nop    
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
     d28:	c7 44 24 04 af 36 00 	movl   $0x36af,0x4(%esp)
     d2f:	00 
     d30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d37:	e8 44 22 00 00       	call   2f80 <printf>
    exit();
     d3c:	e8 07 21 00 00       	call   2e48 <exit>

  printf(1, "dir vs file\n");

  fd = open("dirfile", O_CREATE);
  if(fd < 0){
    printf(1, "create dirfile failed\n");
     d41:	c7 44 24 04 73 36 00 	movl   $0x3673,0x4(%esp)
     d48:	00 
     d49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d50:	e8 2b 22 00 00       	call   2f80 <printf>
    exit();
     d55:	e8 ee 20 00 00       	call   2e48 <exit>
  }
  close(fd);
  if(chdir("dirfile") == 0){
    printf(1, "chdir dirfile succeeded!\n");
     d5a:	c7 44 24 04 8a 36 00 	movl   $0x368a,0x4(%esp)
     d61:	00 
     d62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d69:	e8 12 22 00 00       	call   2f80 <printf>
    exit();
     d6e:	e8 d5 20 00 00       	call   2e48 <exit>
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
     d73:	c7 44 24 04 cd 36 00 	movl   $0x36cd,0x4(%esp)
     d7a:	00 
     d7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d82:	e8 f9 21 00 00       	call   2f80 <printf>
    exit();
     d87:	e8 bc 20 00 00       	call   2e48 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
     d8c:	c7 44 24 04 ea 36 00 	movl   $0x36ea,0x4(%esp)
     d93:	00 
     d94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d9b:	e8 e0 21 00 00       	call   2f80 <printf>
    exit();
     da0:	e8 a3 20 00 00       	call   2e48 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
     da5:	c7 44 24 04 8c 42 00 	movl   $0x428c,0x4(%esp)
     dac:	00 
     dad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     db4:	e8 c7 21 00 00       	call   2f80 <printf>
    exit();
     db9:	e8 8a 20 00 00       	call   2e48 <exit>
  }
  if(unlink("dirfile") != 0){
    printf(1, "unlink dirfile failed!\n");
     dbe:	c7 44 24 04 08 37 00 	movl   $0x3708,0x4(%esp)
     dc5:	00 
     dc6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dcd:	e8 ae 21 00 00       	call   2f80 <printf>
    exit();
     dd2:	e8 71 20 00 00       	call   2e48 <exit>
  }

  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
     dd7:	c7 44 24 04 ac 42 00 	movl   $0x42ac,0x4(%esp)
     dde:	00 
     ddf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     de6:	e8 95 21 00 00       	call   2f80 <printf>
    exit();
     deb:	e8 58 20 00 00       	call   2e48 <exit>
  }
  fd = open(".", 0);
  if(write(fd, "x", 1) > 0){
    printf(1, "write . succeeded!\n");
     df0:	c7 44 24 04 20 37 00 	movl   $0x3720,0x4(%esp)
     df7:	00 
     df8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dff:	e8 7c 21 00 00       	call   2f80 <printf>
    exit();
     e04:	e8 3f 20 00 00       	call   2e48 <exit>
     e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000e10 <bigfile>:
  printf(1, "subdir ok\n");
}

void
bigfile(void)
{
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
     e13:	57                   	push   %edi
     e14:	56                   	push   %esi
     e15:	53                   	push   %ebx

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
     e16:	31 db                	xor    %ebx,%ebx
  printf(1, "subdir ok\n");
}

void
bigfile(void)
{
     e18:	83 ec 0c             	sub    $0xc,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
     e1b:	c7 44 24 04 44 37 00 	movl   $0x3744,0x4(%esp)
     e22:	00 
     e23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e2a:	e8 51 21 00 00       	call   2f80 <printf>

  unlink("bigfile");
     e2f:	c7 04 24 60 37 00 00 	movl   $0x3760,(%esp)
     e36:	e8 5d 20 00 00       	call   2e98 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
     e3b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e42:	00 
     e43:	c7 04 24 60 37 00 00 	movl   $0x3760,(%esp)
     e4a:	e8 39 20 00 00       	call   2e88 <open>
  if(fd < 0){
     e4f:	85 c0                	test   %eax,%eax
  int fd, i, total, cc;

  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
     e51:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     e53:	0f 88 73 01 00 00    	js     fcc <bigfile+0x1bc>
     e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
     e60:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
     e67:	00 
     e68:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     e6c:	c7 04 24 e0 45 00 00 	movl   $0x45e0,(%esp)
     e73:	e8 28 1e 00 00       	call   2ca0 <memset>
    if(write(fd, buf, 600) != 600){
     e78:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
     e7f:	00 
     e80:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
     e87:	00 
     e88:	89 34 24             	mov    %esi,(%esp)
     e8b:	e8 d8 1f 00 00       	call   2e68 <write>
     e90:	3d 58 02 00 00       	cmp    $0x258,%eax
     e95:	0f 85 e6 00 00 00    	jne    f81 <bigfile+0x171>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
     e9b:	83 c3 01             	add    $0x1,%ebx
     e9e:	83 fb 14             	cmp    $0x14,%ebx
     ea1:	75 bd                	jne    e60 <bigfile+0x50>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
     ea3:	89 34 24             	mov    %esi,(%esp)

  fd = open("bigfile", 0);
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
     ea6:	30 db                	xor    %bl,%bl
     ea8:	31 f6                	xor    %esi,%esi
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
     eaa:	e8 c1 1f 00 00       	call   2e70 <close>

  fd = open("bigfile", 0);
     eaf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     eb6:	00 
     eb7:	c7 04 24 60 37 00 00 	movl   $0x3760,(%esp)
     ebe:	e8 c5 1f 00 00       	call   2e88 <open>
  if(fd < 0){
     ec3:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  close(fd);

  fd = open("bigfile", 0);
     ec5:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     ec7:	79 38                	jns    f01 <bigfile+0xf1>
     ec9:	e9 17 01 00 00       	jmp    fe5 <bigfile+0x1d5>
     ece:	66 90                	xchg   %ax,%ax
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
     ed0:	3d 2c 01 00 00       	cmp    $0x12c,%eax
     ed5:	8d 76 00             	lea    0x0(%esi),%esi
     ed8:	0f 85 d5 00 00 00    	jne    fb3 <bigfile+0x1a3>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
     ede:	0f be 15 e0 45 00 00 	movsbl 0x45e0,%edx
     ee5:	89 d8                	mov    %ebx,%eax
     ee7:	d1 f8                	sar    %eax
     ee9:	39 c2                	cmp    %eax,%edx
     eeb:	75 7b                	jne    f68 <bigfile+0x158>
     eed:	0f be 05 0b 47 00 00 	movsbl 0x470b,%eax
     ef4:	39 c2                	cmp    %eax,%edx
     ef6:	75 70                	jne    f68 <bigfile+0x158>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
     ef8:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
     efe:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
     f01:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
     f08:	00 
     f09:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
     f10:	00 
     f11:	89 3c 24             	mov    %edi,(%esp)
     f14:	e8 47 1f 00 00       	call   2e60 <read>
    if(cc < 0){
     f19:	83 f8 00             	cmp    $0x0,%eax
     f1c:	7c 7c                	jl     f9a <bigfile+0x18a>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
     f1e:	75 b0                	jne    ed0 <bigfile+0xc0>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
     f20:	89 3c 24             	mov    %edi,(%esp)
     f23:	90                   	nop    
     f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f28:	e8 43 1f 00 00       	call   2e70 <close>
  if(total != 20*600){
     f2d:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
     f33:	90                   	nop    
     f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f38:	0f 85 c0 00 00 00    	jne    ffe <bigfile+0x1ee>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
     f3e:	c7 04 24 60 37 00 00 	movl   $0x3760,(%esp)
     f45:	e8 4e 1f 00 00       	call   2e98 <unlink>

  printf(1, "bigfile test ok\n");
     f4a:	c7 44 24 04 ef 37 00 	movl   $0x37ef,0x4(%esp)
     f51:	00 
     f52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f59:	e8 22 20 00 00       	call   2f80 <printf>
}
     f5e:	83 c4 0c             	add    $0xc,%esp
     f61:	5b                   	pop    %ebx
     f62:	5e                   	pop    %esi
     f63:	5f                   	pop    %edi
     f64:	5d                   	pop    %ebp
     f65:	c3                   	ret    
     f66:	66 90                	xchg   %ax,%ax
    if(cc != 300){
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
     f68:	c7 44 24 04 bc 37 00 	movl   $0x37bc,0x4(%esp)
     f6f:	00 
     f70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f77:	e8 04 20 00 00       	call   2f80 <printf>
      exit();
     f7c:	e8 c7 1e 00 00       	call   2e48 <exit>
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
     f81:	c7 44 24 04 68 37 00 	movl   $0x3768,0x4(%esp)
     f88:	00 
     f89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f90:	e8 eb 1f 00 00       	call   2f80 <printf>
      exit();
     f95:	e8 ae 1e 00 00       	call   2e48 <exit>
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    if(cc < 0){
      printf(1, "read bigfile failed\n");
     f9a:	c7 44 24 04 93 37 00 	movl   $0x3793,0x4(%esp)
     fa1:	00 
     fa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fa9:	e8 d2 1f 00 00       	call   2f80 <printf>
      exit();
     fae:	e8 95 1e 00 00       	call   2e48 <exit>
    }
    if(cc == 0)
      break;
    if(cc != 300){
      printf(1, "short read bigfile\n");
     fb3:	c7 44 24 04 a8 37 00 	movl   $0x37a8,0x4(%esp)
     fba:	00 
     fbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fc2:	e8 b9 1f 00 00       	call   2f80 <printf>
      exit();
     fc7:	e8 7c 1e 00 00       	call   2e48 <exit>
  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
     fcc:	c7 44 24 04 52 37 00 	movl   $0x3752,0x4(%esp)
     fd3:	00 
     fd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fdb:	e8 a0 1f 00 00       	call   2f80 <printf>
    exit();
     fe0:	e8 63 1e 00 00       	call   2e48 <exit>
  }
  close(fd);

  fd = open("bigfile", 0);
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
     fe5:	c7 44 24 04 7e 37 00 	movl   $0x377e,0x4(%esp)
     fec:	00 
     fed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff4:	e8 87 1f 00 00       	call   2f80 <printf>
    exit();
     ff9:	e8 4a 1e 00 00       	call   2e48 <exit>
    }
    total += cc;
  }
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
     ffe:	c7 44 24 04 d5 37 00 	movl   $0x37d5,0x4(%esp)
    1005:	00 
    1006:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    100d:	e8 6e 1f 00 00       	call   2f80 <printf>
    exit();
    1012:	e8 31 1e 00 00       	call   2e48 <exit>
    1017:	89 f6                	mov    %esi,%esi
    1019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001020 <subdir>:
  printf(1, "bigdir ok\n");
}

void
subdir(void)
{
    1020:	55                   	push   %ebp
    1021:	89 e5                	mov    %esp,%ebp
    1023:	53                   	push   %ebx
    1024:	83 ec 14             	sub    $0x14,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1027:	c7 44 24 04 00 38 00 	movl   $0x3800,0x4(%esp)
    102e:	00 
    102f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1036:	e8 45 1f 00 00       	call   2f80 <printf>

  unlink("ff");
    103b:	c7 04 24 89 38 00 00 	movl   $0x3889,(%esp)
    1042:	e8 51 1e 00 00       	call   2e98 <unlink>
  if(mkdir("dd") != 0){
    1047:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    104e:	e8 5d 1e 00 00       	call   2eb0 <mkdir>
    1053:	85 c0                	test   %eax,%eax
    1055:	0f 85 f6 03 00 00    	jne    1451 <subdir+0x431>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    105b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1062:	00 
    1063:	c7 04 24 5f 38 00 00 	movl   $0x385f,(%esp)
    106a:	e8 19 1e 00 00       	call   2e88 <open>
  if(fd < 0){
    106f:	85 c0                	test   %eax,%eax
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1071:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1073:	0f 88 f1 03 00 00    	js     146a <subdir+0x44a>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    1079:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1080:	00 
    1081:	c7 44 24 04 89 38 00 	movl   $0x3889,0x4(%esp)
    1088:	00 
    1089:	89 04 24             	mov    %eax,(%esp)
    108c:	e8 d7 1d 00 00       	call   2e68 <write>
  close(fd);
    1091:	89 1c 24             	mov    %ebx,(%esp)
    1094:	e8 d7 1d 00 00       	call   2e70 <close>
  
  if(unlink("dd") >= 0){
    1099:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    10a0:	e8 f3 1d 00 00       	call   2e98 <unlink>
    10a5:	85 c0                	test   %eax,%eax
    10a7:	0f 89 d6 03 00 00    	jns    1483 <subdir+0x463>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    10ad:	c7 04 24 3a 38 00 00 	movl   $0x383a,(%esp)
    10b4:	e8 f7 1d 00 00       	call   2eb0 <mkdir>
    10b9:	85 c0                	test   %eax,%eax
    10bb:	0f 85 db 03 00 00    	jne    149c <subdir+0x47c>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    10c1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10c8:	00 
    10c9:	c7 04 24 5c 38 00 00 	movl   $0x385c,(%esp)
    10d0:	e8 b3 1d 00 00       	call   2e88 <open>
  if(fd < 0){
    10d5:	85 c0                	test   %eax,%eax
  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    10d7:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    10d9:	0f 88 d6 03 00 00    	js     14b5 <subdir+0x495>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    10df:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    10e6:	00 
    10e7:	c7 44 24 04 7d 38 00 	movl   $0x387d,0x4(%esp)
    10ee:	00 
    10ef:	89 04 24             	mov    %eax,(%esp)
    10f2:	e8 71 1d 00 00       	call   2e68 <write>
  close(fd);
    10f7:	89 1c 24             	mov    %ebx,(%esp)
    10fa:	e8 71 1d 00 00       	call   2e70 <close>

  fd = open("dd/dd/../ff", 0);
    10ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1106:	00 
    1107:	c7 04 24 80 38 00 00 	movl   $0x3880,(%esp)
    110e:	e8 75 1d 00 00       	call   2e88 <open>
  if(fd < 0){
    1113:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
    1115:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1117:	0f 88 b1 03 00 00    	js     14ce <subdir+0x4ae>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    111d:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1124:	00 
    1125:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    112c:	00 
    112d:	89 04 24             	mov    %eax,(%esp)
    1130:	e8 2b 1d 00 00       	call   2e60 <read>
  if(cc != 2 || buf[0] != 'f'){
    1135:	83 f8 02             	cmp    $0x2,%eax
    1138:	75 09                	jne    1143 <subdir+0x123>
    113a:	80 3d e0 45 00 00 66 	cmpb   $0x66,0x45e0
    1141:	74 1d                	je     1160 <subdir+0x140>
    printf(1, "dd/dd/../ff wrong content\n");
    1143:	c7 44 24 04 a5 38 00 	movl   $0x38a5,0x4(%esp)
    114a:	00 
    114b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1152:	e8 29 1e 00 00       	call   2f80 <printf>
    exit();
    1157:	e8 ec 1c 00 00       	call   2e48 <exit>
    115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  close(fd);
    1160:	89 1c 24             	mov    %ebx,(%esp)
    1163:	e8 08 1d 00 00       	call   2e70 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1168:	c7 44 24 04 c0 38 00 	movl   $0x38c0,0x4(%esp)
    116f:	00 
    1170:	c7 04 24 5c 38 00 00 	movl   $0x385c,(%esp)
    1177:	e8 2c 1d 00 00       	call   2ea8 <link>
    117c:	85 c0                	test   %eax,%eax
    117e:	0f 85 95 03 00 00    	jne    1519 <subdir+0x4f9>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    1184:	c7 04 24 5c 38 00 00 	movl   $0x385c,(%esp)
    118b:	e8 08 1d 00 00       	call   2e98 <unlink>
    1190:	85 c0                	test   %eax,%eax
    1192:	0f 85 68 03 00 00    	jne    1500 <subdir+0x4e0>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    119f:	00 
    11a0:	c7 04 24 5c 38 00 00 	movl   $0x385c,(%esp)
    11a7:	e8 dc 1c 00 00       	call   2e88 <open>
    11ac:	85 c0                	test   %eax,%eax
    11ae:	0f 89 c9 03 00 00    	jns    157d <subdir+0x55d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    11b4:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    11bb:	e8 f8 1c 00 00       	call   2eb8 <chdir>
    11c0:	85 c0                	test   %eax,%eax
    11c2:	0f 85 9c 03 00 00    	jne    1564 <subdir+0x544>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    11c8:	c7 04 24 f4 38 00 00 	movl   $0x38f4,(%esp)
    11cf:	e8 e4 1c 00 00       	call   2eb8 <chdir>
    11d4:	85 c0                	test   %eax,%eax
    11d6:	0f 85 0b 03 00 00    	jne    14e7 <subdir+0x4c7>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    11dc:	c7 04 24 1a 39 00 00 	movl   $0x391a,(%esp)
    11e3:	e8 d0 1c 00 00       	call   2eb8 <chdir>
    11e8:	85 c0                	test   %eax,%eax
    11ea:	0f 85 f7 02 00 00    	jne    14e7 <subdir+0x4c7>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    11f0:	c7 04 24 29 39 00 00 	movl   $0x3929,(%esp)
    11f7:	e8 bc 1c 00 00       	call   2eb8 <chdir>
    11fc:	85 c0                	test   %eax,%eax
    11fe:	0f 85 47 03 00 00    	jne    154b <subdir+0x52b>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1204:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    120b:	00 
    120c:	c7 04 24 c0 38 00 00 	movl   $0x38c0,(%esp)
    1213:	e8 70 1c 00 00       	call   2e88 <open>
  if(fd < 0){
    1218:	85 c0                	test   %eax,%eax
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    121a:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    121c:	0f 88 10 03 00 00    	js     1532 <subdir+0x512>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1222:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1229:	00 
    122a:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    1231:	00 
    1232:	89 04 24             	mov    %eax,(%esp)
    1235:	e8 26 1c 00 00       	call   2e60 <read>
    123a:	83 f8 02             	cmp    $0x2,%eax
    123d:	0f 85 9e 03 00 00    	jne    15e1 <subdir+0x5c1>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1243:	89 1c 24             	mov    %ebx,(%esp)
    1246:	e8 25 1c 00 00       	call   2e70 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    124b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1252:	00 
    1253:	c7 04 24 5c 38 00 00 	movl   $0x385c,(%esp)
    125a:	e8 29 1c 00 00       	call   2e88 <open>
    125f:	85 c0                	test   %eax,%eax
    1261:	0f 89 61 03 00 00    	jns    15c8 <subdir+0x5a8>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1267:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    126e:	00 
    126f:	c7 04 24 74 39 00 00 	movl   $0x3974,(%esp)
    1276:	e8 0d 1c 00 00       	call   2e88 <open>
    127b:	85 c0                	test   %eax,%eax
    127d:	0f 89 2c 03 00 00    	jns    15af <subdir+0x58f>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1283:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    128a:	00 
    128b:	c7 04 24 99 39 00 00 	movl   $0x3999,(%esp)
    1292:	e8 f1 1b 00 00       	call   2e88 <open>
    1297:	85 c0                	test   %eax,%eax
    1299:	0f 89 f7 02 00 00    	jns    1596 <subdir+0x576>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    129f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    12a6:	00 
    12a7:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    12ae:	e8 d5 1b 00 00       	call   2e88 <open>
    12b3:	85 c0                	test   %eax,%eax
    12b5:	0f 89 71 03 00 00    	jns    162c <subdir+0x60c>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    12bb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    12c2:	00 
    12c3:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    12ca:	e8 b9 1b 00 00       	call   2e88 <open>
    12cf:	85 c0                	test   %eax,%eax
    12d1:	0f 89 3c 03 00 00    	jns    1613 <subdir+0x5f3>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    12d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    12de:	00 
    12df:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    12e6:	e8 9d 1b 00 00       	call   2e88 <open>
    12eb:	85 c0                	test   %eax,%eax
    12ed:	0f 89 07 03 00 00    	jns    15fa <subdir+0x5da>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    12f3:	c7 44 24 04 08 3a 00 	movl   $0x3a08,0x4(%esp)
    12fa:	00 
    12fb:	c7 04 24 74 39 00 00 	movl   $0x3974,(%esp)
    1302:	e8 a1 1b 00 00       	call   2ea8 <link>
    1307:	85 c0                	test   %eax,%eax
    1309:	0f 84 36 03 00 00    	je     1645 <subdir+0x625>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    130f:	c7 44 24 04 08 3a 00 	movl   $0x3a08,0x4(%esp)
    1316:	00 
    1317:	c7 04 24 99 39 00 00 	movl   $0x3999,(%esp)
    131e:	e8 85 1b 00 00       	call   2ea8 <link>
    1323:	85 c0                	test   %eax,%eax
    1325:	0f 84 7e 03 00 00    	je     16a9 <subdir+0x689>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    132b:	c7 44 24 04 c0 38 00 	movl   $0x38c0,0x4(%esp)
    1332:	00 
    1333:	c7 04 24 5f 38 00 00 	movl   $0x385f,(%esp)
    133a:	e8 69 1b 00 00       	call   2ea8 <link>
    133f:	85 c0                	test   %eax,%eax
    1341:	0f 84 49 03 00 00    	je     1690 <subdir+0x670>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1347:	c7 04 24 74 39 00 00 	movl   $0x3974,(%esp)
    134e:	e8 5d 1b 00 00       	call   2eb0 <mkdir>
    1353:	85 c0                	test   %eax,%eax
    1355:	0f 84 1c 03 00 00    	je     1677 <subdir+0x657>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    135b:	c7 04 24 99 39 00 00 	movl   $0x3999,(%esp)
    1362:	e8 49 1b 00 00       	call   2eb0 <mkdir>
    1367:	85 c0                	test   %eax,%eax
    1369:	0f 84 ef 02 00 00    	je     165e <subdir+0x63e>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    136f:	c7 04 24 c0 38 00 00 	movl   $0x38c0,(%esp)
    1376:	e8 35 1b 00 00       	call   2eb0 <mkdir>
    137b:	85 c0                	test   %eax,%eax
    137d:	0f 84 71 03 00 00    	je     16f4 <subdir+0x6d4>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1383:	c7 04 24 99 39 00 00 	movl   $0x3999,(%esp)
    138a:	e8 09 1b 00 00       	call   2e98 <unlink>
    138f:	85 c0                	test   %eax,%eax
    1391:	0f 84 44 03 00 00    	je     16db <subdir+0x6bb>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1397:	c7 04 24 74 39 00 00 	movl   $0x3974,(%esp)
    139e:	e8 f5 1a 00 00       	call   2e98 <unlink>
    13a3:	85 c0                	test   %eax,%eax
    13a5:	0f 84 17 03 00 00    	je     16c2 <subdir+0x6a2>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    13ab:	c7 04 24 5f 38 00 00 	movl   $0x385f,(%esp)
    13b2:	e8 01 1b 00 00       	call   2eb8 <chdir>
    13b7:	85 c0                	test   %eax,%eax
    13b9:	0f 84 67 03 00 00    	je     1726 <subdir+0x706>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    13bf:	c7 04 24 0b 3a 00 00 	movl   $0x3a0b,(%esp)
    13c6:	e8 ed 1a 00 00       	call   2eb8 <chdir>
    13cb:	85 c0                	test   %eax,%eax
    13cd:	0f 84 b7 03 00 00    	je     178a <subdir+0x76a>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    13d3:	c7 04 24 c0 38 00 00 	movl   $0x38c0,(%esp)
    13da:	e8 b9 1a 00 00       	call   2e98 <unlink>
    13df:	85 c0                	test   %eax,%eax
    13e1:	0f 85 19 01 00 00    	jne    1500 <subdir+0x4e0>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    13e7:	c7 04 24 5f 38 00 00 	movl   $0x385f,(%esp)
    13ee:	e8 a5 1a 00 00       	call   2e98 <unlink>
    13f3:	85 c0                	test   %eax,%eax
    13f5:	0f 85 76 03 00 00    	jne    1771 <subdir+0x751>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    13fb:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    1402:	e8 91 1a 00 00       	call   2e98 <unlink>
    1407:	85 c0                	test   %eax,%eax
    1409:	0f 84 49 03 00 00    	je     1758 <subdir+0x738>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    140f:	c7 04 24 3b 38 00 00 	movl   $0x383b,(%esp)
    1416:	e8 7d 1a 00 00       	call   2e98 <unlink>
    141b:	85 c0                	test   %eax,%eax
    141d:	0f 88 1c 03 00 00    	js     173f <subdir+0x71f>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1423:	c7 04 24 26 39 00 00 	movl   $0x3926,(%esp)
    142a:	e8 69 1a 00 00       	call   2e98 <unlink>
    142f:	85 c0                	test   %eax,%eax
    1431:	0f 88 d6 02 00 00    	js     170d <subdir+0x6ed>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1437:	c7 44 24 04 08 3b 00 	movl   $0x3b08,0x4(%esp)
    143e:	00 
    143f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1446:	e8 35 1b 00 00       	call   2f80 <printf>
}
    144b:	83 c4 14             	add    $0x14,%esp
    144e:	5b                   	pop    %ebx
    144f:	5d                   	pop    %ebp
    1450:	c3                   	ret    

  printf(1, "subdir test\n");

  unlink("ff");
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    1451:	c7 44 24 04 0d 38 00 	movl   $0x380d,0x4(%esp)
    1458:	00 
    1459:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1460:	e8 1b 1b 00 00       	call   2f80 <printf>
    exit();
    1465:	e8 de 19 00 00       	call   2e48 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/ff failed\n");
    146a:	c7 44 24 04 25 38 00 	movl   $0x3825,0x4(%esp)
    1471:	00 
    1472:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1479:	e8 02 1b 00 00       	call   2f80 <printf>
    exit();
    147e:	e8 c5 19 00 00       	call   2e48 <exit>
  }
  write(fd, "ff", 2);
  close(fd);
  
  if(unlink("dd") >= 0){
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1483:	c7 44 24 04 cc 42 00 	movl   $0x42cc,0x4(%esp)
    148a:	00 
    148b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1492:	e8 e9 1a 00 00       	call   2f80 <printf>
    exit();
    1497:	e8 ac 19 00 00       	call   2e48 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    149c:	c7 44 24 04 41 38 00 	movl   $0x3841,0x4(%esp)
    14a3:	00 
    14a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14ab:	e8 d0 1a 00 00       	call   2f80 <printf>
    exit();
    14b0:	e8 93 19 00 00       	call   2e48 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/dd/ff failed\n");
    14b5:	c7 44 24 04 65 38 00 	movl   $0x3865,0x4(%esp)
    14bc:	00 
    14bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14c4:	e8 b7 1a 00 00       	call   2f80 <printf>
    exit();
    14c9:	e8 7a 19 00 00       	call   2e48 <exit>
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/../ff failed\n");
    14ce:	c7 44 24 04 8c 38 00 	movl   $0x388c,0x4(%esp)
    14d5:	00 
    14d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14dd:	e8 9e 1a 00 00       	call   2f80 <printf>
    exit();
    14e2:	e8 61 19 00 00       	call   2e48 <exit>
  if(chdir("dd/../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    14e7:	c7 44 24 04 00 39 00 	movl   $0x3900,0x4(%esp)
    14ee:	00 
    14ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14f6:	e8 85 1a 00 00       	call   2f80 <printf>
    exit();
    14fb:	e8 48 19 00 00       	call   2e48 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    1500:	c7 44 24 04 cb 38 00 	movl   $0x38cb,0x4(%esp)
    1507:	00 
    1508:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    150f:	e8 6c 1a 00 00       	call   2f80 <printf>
    exit();
    1514:	e8 2f 19 00 00       	call   2e48 <exit>
    exit();
  }
  close(fd);

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1519:	c7 44 24 04 f4 42 00 	movl   $0x42f4,0x4(%esp)
    1520:	00 
    1521:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1528:	e8 53 1a 00 00       	call   2f80 <printf>
    exit();
    152d:	e8 16 19 00 00       	call   2e48 <exit>
    exit();
  }

  fd = open("dd/dd/ffff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    1532:	c7 44 24 04 41 39 00 	movl   $0x3941,0x4(%esp)
    1539:	00 
    153a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1541:	e8 3a 1a 00 00       	call   2f80 <printf>
    exit();
    1546:	e8 fd 18 00 00       	call   2e48 <exit>
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    154b:	c7 44 24 04 2e 39 00 	movl   $0x392e,0x4(%esp)
    1552:	00 
    1553:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    155a:	e8 21 1a 00 00       	call   2f80 <printf>
    exit();
    155f:	e8 e4 18 00 00       	call   2e48 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    printf(1, "chdir dd failed\n");
    1564:	c7 44 24 04 e3 38 00 	movl   $0x38e3,0x4(%esp)
    156b:	00 
    156c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1573:	e8 08 1a 00 00       	call   2f80 <printf>
    exit();
    1578:	e8 cb 18 00 00       	call   2e48 <exit>
  if(unlink("dd/dd/ff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    157d:	c7 44 24 04 18 43 00 	movl   $0x4318,0x4(%esp)
    1584:	00 
    1585:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    158c:	e8 ef 19 00 00       	call   2f80 <printf>
    exit();
    1591:	e8 b2 18 00 00       	call   2e48 <exit>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    1596:	c7 44 24 04 a2 39 00 	movl   $0x39a2,0x4(%esp)
    159d:	00 
    159e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15a5:	e8 d6 19 00 00       	call   2f80 <printf>
    exit();
    15aa:	e8 99 18 00 00       	call   2e48 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    15af:	c7 44 24 04 7d 39 00 	movl   $0x397d,0x4(%esp)
    15b6:	00 
    15b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15be:	e8 bd 19 00 00       	call   2f80 <printf>
    exit();
    15c3:	e8 80 18 00 00       	call   2e48 <exit>
    exit();
  }
  close(fd);

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    15c8:	c7 44 24 04 3c 43 00 	movl   $0x433c,0x4(%esp)
    15cf:	00 
    15d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15d7:	e8 a4 19 00 00       	call   2f80 <printf>
    exit();
    15dc:	e8 67 18 00 00       	call   2e48 <exit>
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    printf(1, "read dd/dd/ffff wrong len\n");
    15e1:	c7 44 24 04 59 39 00 	movl   $0x3959,0x4(%esp)
    15e8:	00 
    15e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15f0:	e8 8b 19 00 00       	call   2f80 <printf>
    exit();
    15f5:	e8 4e 18 00 00       	call   2e48 <exit>
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    15fa:	c7 44 24 04 ed 39 00 	movl   $0x39ed,0x4(%esp)
    1601:	00 
    1602:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1609:	e8 72 19 00 00       	call   2f80 <printf>
    exit();
    160e:	e8 35 18 00 00       	call   2e48 <exit>
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    1613:	c7 44 24 04 d4 39 00 	movl   $0x39d4,0x4(%esp)
    161a:	00 
    161b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1622:	e8 59 19 00 00       	call   2f80 <printf>
    exit();
    1627:	e8 1c 18 00 00       	call   2e48 <exit>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    162c:	c7 44 24 04 be 39 00 	movl   $0x39be,0x4(%esp)
    1633:	00 
    1634:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    163b:	e8 40 19 00 00       	call   2f80 <printf>
    exit();
    1640:	e8 03 18 00 00       	call   2e48 <exit>
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    1645:	c7 44 24 04 64 43 00 	movl   $0x4364,0x4(%esp)
    164c:	00 
    164d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1654:	e8 27 19 00 00       	call   2f80 <printf>
    exit();
    1659:	e8 ea 17 00 00       	call   2e48 <exit>
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    165e:	c7 44 24 04 2c 3a 00 	movl   $0x3a2c,0x4(%esp)
    1665:	00 
    1666:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    166d:	e8 0e 19 00 00       	call   2f80 <printf>
    exit();
    1672:	e8 d1 17 00 00       	call   2e48 <exit>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    1677:	c7 44 24 04 11 3a 00 	movl   $0x3a11,0x4(%esp)
    167e:	00 
    167f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1686:	e8 f5 18 00 00       	call   2f80 <printf>
    exit();
    168b:	e8 b8 17 00 00       	call   2e48 <exit>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    1690:	c7 44 24 04 ac 43 00 	movl   $0x43ac,0x4(%esp)
    1697:	00 
    1698:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    169f:	e8 dc 18 00 00       	call   2f80 <printf>
    exit();
    16a4:	e8 9f 17 00 00       	call   2e48 <exit>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    16a9:	c7 44 24 04 88 43 00 	movl   $0x4388,0x4(%esp)
    16b0:	00 
    16b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16b8:	e8 c3 18 00 00       	call   2f80 <printf>
    exit();
    16bd:	e8 86 17 00 00       	call   2e48 <exit>
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    16c2:	c7 44 24 04 80 3a 00 	movl   $0x3a80,0x4(%esp)
    16c9:	00 
    16ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16d1:	e8 aa 18 00 00       	call   2f80 <printf>
    exit();
    16d6:	e8 6d 17 00 00       	call   2e48 <exit>
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    16db:	c7 44 24 04 64 3a 00 	movl   $0x3a64,0x4(%esp)
    16e2:	00 
    16e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16ea:	e8 91 18 00 00       	call   2f80 <printf>
    exit();
    16ef:	e8 54 17 00 00       	call   2e48 <exit>
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    16f4:	c7 44 24 04 47 3a 00 	movl   $0x3a47,0x4(%esp)
    16fb:	00 
    16fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1703:	e8 78 18 00 00       	call   2f80 <printf>
    exit();
    1708:	e8 3b 17 00 00       	call   2e48 <exit>
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    printf(1, "unlink dd failed\n");
    170d:	c7 44 24 04 f6 3a 00 	movl   $0x3af6,0x4(%esp)
    1714:	00 
    1715:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    171c:	e8 5f 18 00 00       	call   2f80 <printf>
    exit();
    1721:	e8 22 17 00 00       	call   2e48 <exit>
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    1726:	c7 44 24 04 9c 3a 00 	movl   $0x3a9c,0x4(%esp)
    172d:	00 
    172e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1735:	e8 46 18 00 00       	call   2f80 <printf>
    exit();
    173a:	e8 09 17 00 00       	call   2e48 <exit>
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    173f:	c7 44 24 04 e1 3a 00 	movl   $0x3ae1,0x4(%esp)
    1746:	00 
    1747:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    174e:	e8 2d 18 00 00       	call   2f80 <printf>
    exit();
    1753:	e8 f0 16 00 00       	call   2e48 <exit>
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    1758:	c7 44 24 04 d0 43 00 	movl   $0x43d0,0x4(%esp)
    175f:	00 
    1760:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1767:	e8 14 18 00 00       	call   2f80 <printf>
    exit();
    176c:	e8 d7 16 00 00       	call   2e48 <exit>
  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    1771:	c7 44 24 04 cc 3a 00 	movl   $0x3acc,0x4(%esp)
    1778:	00 
    1779:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1780:	e8 fb 17 00 00       	call   2f80 <printf>
    exit();
    1785:	e8 be 16 00 00       	call   2e48 <exit>
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    printf(1, "chdir dd/xx succeeded!\n");
    178a:	c7 44 24 04 b4 3a 00 	movl   $0x3ab4,0x4(%esp)
    1791:	00 
    1792:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1799:	e8 e2 17 00 00       	call   2f80 <printf>
    exit();
    179e:	e8 a5 16 00 00       	call   2e48 <exit>
    17a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    17a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000017b0 <concreate>:
}

// test concurrent create and unlink of the same file
void
concreate(void)
{
    17b0:	55                   	push   %ebp
    17b1:	89 e5                	mov    %esp,%ebp
    17b3:	57                   	push   %edi
    17b4:	56                   	push   %esi
    17b5:	53                   	push   %ebx
    char name[14];
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
    17b6:	31 db                	xor    %ebx,%ebx
}

// test concurrent create and unlink of the same file
void
concreate(void)
{
    17b8:	83 ec 5c             	sub    $0x5c,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    17bb:	c7 44 24 04 13 3b 00 	movl   $0x3b13,0x4(%esp)
    17c2:	00 
    17c3:	8d 7d f1             	lea    -0xf(%ebp),%edi
    17c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17cd:	e8 ae 17 00 00       	call   2f80 <printf>
  file[0] = 'C';
    17d2:	c6 45 f1 43          	movb   $0x43,-0xf(%ebp)
  file[2] = '\0';
    17d6:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    17da:	eb 56                	jmp    1832 <concreate+0x82>
    17dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    17e0:	b8 56 55 55 55       	mov    $0x55555556,%eax
    17e5:	f7 eb                	imul   %ebx
    17e7:	89 d8                	mov    %ebx,%eax
    17e9:	c1 f8 1f             	sar    $0x1f,%eax
    17ec:	29 c2                	sub    %eax,%edx
    17ee:	89 d8                	mov    %ebx,%eax
    17f0:	8d 14 52             	lea    (%edx,%edx,2),%edx
    17f3:	29 d0                	sub    %edx,%eax
    17f5:	83 e8 01             	sub    $0x1,%eax
    17f8:	0f 84 82 00 00 00    	je     1880 <concreate+0xd0>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    17fe:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1805:	00 
    1806:	89 3c 24             	mov    %edi,(%esp)
    1809:	e8 7a 16 00 00       	call   2e88 <open>
      if(fd < 0){
    180e:	85 c0                	test   %eax,%eax
    1810:	0f 88 ee 01 00 00    	js     1a04 <concreate+0x254>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1816:	89 04 24             	mov    %eax,(%esp)
    1819:	e8 52 16 00 00       	call   2e70 <close>
    }
    if(pid == 0)
    181e:	85 f6                	test   %esi,%esi
    1820:	74 55                	je     1877 <concreate+0xc7>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1822:	83 c3 01             	add    $0x1,%ebx
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    1825:	e8 26 16 00 00       	call   2e50 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    182a:	83 fb 28             	cmp    $0x28,%ebx
    182d:	8d 76 00             	lea    0x0(%esi),%esi
    1830:	74 6e                	je     18a0 <concreate+0xf0>
    file[1] = '0' + i;
    1832:	8d 43 30             	lea    0x30(%ebx),%eax
    1835:	88 45 f2             	mov    %al,-0xe(%ebp)
    unlink(file);
    1838:	89 3c 24             	mov    %edi,(%esp)
    183b:	e8 58 16 00 00       	call   2e98 <unlink>
    pid = fork();
    1840:	e8 fb 15 00 00       	call   2e40 <fork>
    if(pid && (i % 3) == 1){
    1845:	85 c0                	test   %eax,%eax
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    1847:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    1849:	75 95                	jne    17e0 <concreate+0x30>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    184b:	b8 67 66 66 66       	mov    $0x66666667,%eax
    1850:	f7 eb                	imul   %ebx
    1852:	89 d8                	mov    %ebx,%eax
    1854:	c1 f8 1f             	sar    $0x1f,%eax
    1857:	d1 fa                	sar    %edx
    1859:	29 c2                	sub    %eax,%edx
    185b:	89 d8                	mov    %ebx,%eax
    185d:	8d 14 92             	lea    (%edx,%edx,4),%edx
    1860:	29 d0                	sub    %edx,%eax
    1862:	83 e8 01             	sub    $0x1,%eax
    1865:	75 97                	jne    17fe <concreate+0x4e>
      link("C0", file);
    1867:	89 7c 24 04          	mov    %edi,0x4(%esp)
    186b:	c7 04 24 23 3b 00 00 	movl   $0x3b23,(%esp)
    1872:	e8 31 16 00 00       	call   2ea8 <link>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
    1877:	e8 cc 15 00 00       	call   2e48 <exit>
    187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1880:	83 c3 01             	add    $0x1,%ebx
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    1883:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1887:	c7 04 24 23 3b 00 00 	movl   $0x3b23,(%esp)
    188e:	e8 15 16 00 00       	call   2ea8 <link>
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    1893:	e8 b8 15 00 00       	call   2e50 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1898:	83 fb 28             	cmp    $0x28,%ebx
    189b:	75 95                	jne    1832 <concreate+0x82>
    189d:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    18a0:	8d 45 b8             	lea    -0x48(%ebp),%eax
    18a3:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    18aa:	00 
    18ab:	8d 75 e0             	lea    -0x20(%ebp),%esi
    18ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18b5:	00 
    18b6:	89 04 24             	mov    %eax,(%esp)
    18b9:	e8 e2 13 00 00       	call   2ca0 <memset>
  fd = open(".", 0);
    18be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18c5:	00 
    18c6:	c7 04 24 2c 39 00 00 	movl   $0x392c,(%esp)
    18cd:	e8 b6 15 00 00       	call   2e88 <open>
    18d2:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
    18d9:	89 c3                	mov    %eax,%ebx
    18db:	90                   	nop    
    18dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    18e0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18e7:	00 
    18e8:	89 74 24 04          	mov    %esi,0x4(%esp)
    18ec:	89 1c 24             	mov    %ebx,(%esp)
    18ef:	e8 6c 15 00 00       	call   2e60 <read>
    18f4:	85 c0                	test   %eax,%eax
    18f6:	7e 40                	jle    1938 <concreate+0x188>
    if(de.inum == 0)
    18f8:	66 83 7d e0 00       	cmpw   $0x0,-0x20(%ebp)
    18fd:	74 e1                	je     18e0 <concreate+0x130>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    18ff:	80 7d e2 43          	cmpb   $0x43,-0x1e(%ebp)
    1903:	90                   	nop    
    1904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1908:	75 d6                	jne    18e0 <concreate+0x130>
    190a:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
    190e:	66 90                	xchg   %ax,%ax
    1910:	75 ce                	jne    18e0 <concreate+0x130>
      i = de.name[1] - '0';
    1912:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
    1916:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    1919:	83 f8 27             	cmp    $0x27,%eax
    191c:	0f 87 31 01 00 00    	ja     1a53 <concreate+0x2a3>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    1922:	80 7c 05 b8 00       	cmpb   $0x0,-0x48(%ebp,%eax,1)
    1927:	0f 85 46 01 00 00    	jne    1a73 <concreate+0x2c3>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    192d:	c6 44 05 b8 01       	movb   $0x1,-0x48(%ebp,%eax,1)
      n++;
    1932:	83 45 b0 01          	addl   $0x1,-0x50(%ebp)
    1936:	eb a8                	jmp    18e0 <concreate+0x130>
    }
  }
  close(fd);
    1938:	89 1c 24             	mov    %ebx,(%esp)

  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
    193b:	31 db                	xor    %ebx,%ebx
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    193d:	e8 2e 15 00 00       	call   2e70 <close>

  if(n != 40){
    1942:	83 7d b0 28          	cmpl   $0x28,-0x50(%ebp)
    1946:	74 3a                	je     1982 <concreate+0x1d2>
    1948:	e9 ed 00 00 00       	jmp    1a3a <concreate+0x28a>
    194d:	8d 76 00             	lea    0x0(%esi),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1950:	83 e8 01             	sub    $0x1,%eax
    1953:	90                   	nop    
    1954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1958:	74 76                	je     19d0 <concreate+0x220>
       ((i % 3) == 1 && pid != 0)){
      fd = open(file, 0);
      close(fd);
    } else {
      unlink(file);
    195a:	89 3c 24             	mov    %edi,(%esp)
    195d:	8d 76 00             	lea    0x0(%esi),%esi
    1960:	e8 33 15 00 00       	call   2e98 <unlink>
    }
    if(pid == 0)
    1965:	85 f6                	test   %esi,%esi
    1967:	90                   	nop    
    1968:	0f 84 09 ff ff ff    	je     1877 <concreate+0xc7>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    196e:	83 c3 01             	add    $0x1,%ebx
      unlink(file);
    }
    if(pid == 0)
      exit();
    else
      wait();
    1971:	e8 da 14 00 00       	call   2e50 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1976:	83 fb 28             	cmp    $0x28,%ebx
    1979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1980:	74 66                	je     19e8 <concreate+0x238>
    file[1] = '0' + i;
    1982:	8d 43 30             	lea    0x30(%ebx),%eax
    1985:	88 45 f2             	mov    %al,-0xe(%ebp)
    pid = fork();
    1988:	e8 b3 14 00 00       	call   2e40 <fork>
    if(pid < 0){
    198d:	85 c0                	test   %eax,%eax
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    198f:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    1991:	0f 88 8a 00 00 00    	js     1a21 <concreate+0x271>
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1997:	b8 56 55 55 55       	mov    $0x55555556,%eax
    199c:	f7 eb                	imul   %ebx
    199e:	89 d8                	mov    %ebx,%eax
    19a0:	c1 f8 1f             	sar    $0x1f,%eax
    19a3:	29 c2                	sub    %eax,%edx
    19a5:	89 d8                	mov    %ebx,%eax
    19a7:	8d 14 52             	lea    (%edx,%edx,2),%edx
    19aa:	29 d0                	sub    %edx,%eax
    19ac:	89 c2                	mov    %eax,%edx
    19ae:	09 f2                	or     %esi,%edx
    19b0:	75 9e                	jne    1950 <concreate+0x1a0>
       ((i % 3) == 1 && pid != 0)){
      fd = open(file, 0);
    19b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19b9:	00 
    19ba:	89 3c 24             	mov    %edi,(%esp)
    19bd:	e8 c6 14 00 00       	call   2e88 <open>
      close(fd);
    19c2:	89 04 24             	mov    %eax,(%esp)
    19c5:	e8 a6 14 00 00       	call   2e70 <close>
    19ca:	eb 99                	jmp    1965 <concreate+0x1b5>
    19cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    19d0:	85 f6                	test   %esi,%esi
    19d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    19d8:	74 80                	je     195a <concreate+0x1aa>
    19da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    19e0:	eb d0                	jmp    19b2 <concreate+0x202>
    19e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    19e8:	c7 44 24 04 78 3b 00 	movl   $0x3b78,0x4(%esp)
    19ef:	00 
    19f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19f7:	e8 84 15 00 00       	call   2f80 <printf>
}
    19fc:	83 c4 5c             	add    $0x5c,%esp
    19ff:	5b                   	pop    %ebx
    1a00:	5e                   	pop    %esi
    1a01:	5f                   	pop    %edi
    1a02:	5d                   	pop    %ebp
    1a03:	c3                   	ret    
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
    1a04:	89 7c 24 08          	mov    %edi,0x8(%esp)
    1a08:	c7 44 24 04 26 3b 00 	movl   $0x3b26,0x4(%esp)
    1a0f:	00 
    1a10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a17:	e8 64 15 00 00       	call   2f80 <printf>
        exit();
    1a1c:	e8 27 14 00 00       	call   2e48 <exit>

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    1a21:	c7 44 24 04 dc 33 00 	movl   $0x33dc,0x4(%esp)
    1a28:	00 
    1a29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a30:	e8 4b 15 00 00       	call   2f80 <printf>
      exit();
    1a35:	e8 0e 14 00 00       	call   2e48 <exit>
    }
  }
  close(fd);

  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    1a3a:	c7 44 24 04 f0 43 00 	movl   $0x43f0,0x4(%esp)
    1a41:	00 
    1a42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a49:	e8 32 15 00 00       	call   2f80 <printf>
    exit();
    1a4e:	e8 f5 13 00 00       	call   2e48 <exit>
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
    1a53:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1a56:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a5a:	c7 44 24 04 42 3b 00 	movl   $0x3b42,0x4(%esp)
    1a61:	00 
    1a62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a69:	e8 12 15 00 00       	call   2f80 <printf>
    1a6e:	e9 04 fe ff ff       	jmp    1877 <concreate+0xc7>
        exit();
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
    1a73:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1a76:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a7a:	c7 44 24 04 5b 3b 00 	movl   $0x3b5b,0x4(%esp)
    1a81:	00 
    1a82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a89:	e8 f2 14 00 00       	call   2f80 <printf>
        exit();
    1a8e:	e8 b5 13 00 00       	call   2e48 <exit>
    1a93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001aa0 <linktest>:
  printf(1, "unlinkread ok\n");
}

void
linktest(void)
{
    1aa0:	55                   	push   %ebp
    1aa1:	89 e5                	mov    %esp,%ebp
    1aa3:	53                   	push   %ebx
    1aa4:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "linktest\n");
    1aa7:	c7 44 24 04 86 3b 00 	movl   $0x3b86,0x4(%esp)
    1aae:	00 
    1aaf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ab6:	e8 c5 14 00 00       	call   2f80 <printf>

  unlink("lf1");
    1abb:	c7 04 24 90 3b 00 00 	movl   $0x3b90,(%esp)
    1ac2:	e8 d1 13 00 00       	call   2e98 <unlink>
  unlink("lf2");
    1ac7:	c7 04 24 94 3b 00 00 	movl   $0x3b94,(%esp)
    1ace:	e8 c5 13 00 00       	call   2e98 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1ad3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1ada:	00 
    1adb:	c7 04 24 90 3b 00 00 	movl   $0x3b90,(%esp)
    1ae2:	e8 a1 13 00 00       	call   2e88 <open>
  if(fd < 0){
    1ae7:	85 c0                	test   %eax,%eax
  printf(1, "linktest\n");

  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
    1ae9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1aeb:	0f 88 2e 01 00 00    	js     1c1f <linktest+0x17f>
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    1af1:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1af8:	00 
    1af9:	c7 44 24 04 ab 3b 00 	movl   $0x3bab,0x4(%esp)
    1b00:	00 
    1b01:	89 04 24             	mov    %eax,(%esp)
    1b04:	e8 5f 13 00 00       	call   2e68 <write>
    1b09:	83 f8 05             	cmp    $0x5,%eax
    1b0c:	0f 85 26 01 00 00    	jne    1c38 <linktest+0x198>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1b12:	89 1c 24             	mov    %ebx,(%esp)
    1b15:	e8 56 13 00 00       	call   2e70 <close>

  if(link("lf1", "lf2") < 0){
    1b1a:	c7 44 24 04 94 3b 00 	movl   $0x3b94,0x4(%esp)
    1b21:	00 
    1b22:	c7 04 24 90 3b 00 00 	movl   $0x3b90,(%esp)
    1b29:	e8 7a 13 00 00       	call   2ea8 <link>
    1b2e:	85 c0                	test   %eax,%eax
    1b30:	0f 88 1b 01 00 00    	js     1c51 <linktest+0x1b1>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    1b36:	c7 04 24 90 3b 00 00 	movl   $0x3b90,(%esp)
    1b3d:	e8 56 13 00 00       	call   2e98 <unlink>

  if(open("lf1", 0) >= 0){
    1b42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b49:	00 
    1b4a:	c7 04 24 90 3b 00 00 	movl   $0x3b90,(%esp)
    1b51:	e8 32 13 00 00       	call   2e88 <open>
    1b56:	85 c0                	test   %eax,%eax
    1b58:	0f 89 0c 01 00 00    	jns    1c6a <linktest+0x1ca>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1b5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b65:	00 
    1b66:	c7 04 24 94 3b 00 00 	movl   $0x3b94,(%esp)
    1b6d:	e8 16 13 00 00       	call   2e88 <open>
  if(fd < 0){
    1b72:	85 c0                	test   %eax,%eax
  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1b74:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b76:	0f 88 07 01 00 00    	js     1c83 <linktest+0x1e3>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1b7c:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1b83:	00 
    1b84:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    1b8b:	00 
    1b8c:	89 04 24             	mov    %eax,(%esp)
    1b8f:	e8 cc 12 00 00       	call   2e60 <read>
    1b94:	83 f8 05             	cmp    $0x5,%eax
    1b97:	0f 85 ff 00 00 00    	jne    1c9c <linktest+0x1fc>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    1b9d:	89 1c 24             	mov    %ebx,(%esp)
    1ba0:	e8 cb 12 00 00       	call   2e70 <close>

  if(link("lf2", "lf2") >= 0){
    1ba5:	c7 44 24 04 94 3b 00 	movl   $0x3b94,0x4(%esp)
    1bac:	00 
    1bad:	c7 04 24 94 3b 00 00 	movl   $0x3b94,(%esp)
    1bb4:	e8 ef 12 00 00       	call   2ea8 <link>
    1bb9:	85 c0                	test   %eax,%eax
    1bbb:	0f 89 f4 00 00 00    	jns    1cb5 <linktest+0x215>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    1bc1:	c7 04 24 94 3b 00 00 	movl   $0x3b94,(%esp)
    1bc8:	e8 cb 12 00 00       	call   2e98 <unlink>
  if(link("lf2", "lf1") >= 0){
    1bcd:	c7 44 24 04 90 3b 00 	movl   $0x3b90,0x4(%esp)
    1bd4:	00 
    1bd5:	c7 04 24 94 3b 00 00 	movl   $0x3b94,(%esp)
    1bdc:	e8 c7 12 00 00       	call   2ea8 <link>
    1be1:	85 c0                	test   %eax,%eax
    1be3:	0f 89 e5 00 00 00    	jns    1cce <linktest+0x22e>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    1be9:	c7 44 24 04 90 3b 00 	movl   $0x3b90,0x4(%esp)
    1bf0:	00 
    1bf1:	c7 04 24 2c 39 00 00 	movl   $0x392c,(%esp)
    1bf8:	e8 ab 12 00 00       	call   2ea8 <link>
    1bfd:	85 c0                	test   %eax,%eax
    1bff:	0f 89 e2 00 00 00    	jns    1ce7 <linktest+0x247>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    1c05:	c7 44 24 04 34 3c 00 	movl   $0x3c34,0x4(%esp)
    1c0c:	00 
    1c0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c14:	e8 67 13 00 00       	call   2f80 <printf>
}
    1c19:	83 c4 14             	add    $0x14,%esp
    1c1c:	5b                   	pop    %ebx
    1c1d:	5d                   	pop    %ebp
    1c1e:	c3                   	ret    
  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    1c1f:	c7 44 24 04 98 3b 00 	movl   $0x3b98,0x4(%esp)
    1c26:	00 
    1c27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c2e:	e8 4d 13 00 00       	call   2f80 <printf>
    exit();
    1c33:	e8 10 12 00 00       	call   2e48 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    printf(1, "write lf1 failed\n");
    1c38:	c7 44 24 04 b1 3b 00 	movl   $0x3bb1,0x4(%esp)
    1c3f:	00 
    1c40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c47:	e8 34 13 00 00       	call   2f80 <printf>
    exit();
    1c4c:	e8 f7 11 00 00       	call   2e48 <exit>
  }
  close(fd);

  if(link("lf1", "lf2") < 0){
    printf(1, "link lf1 lf2 failed\n");
    1c51:	c7 44 24 04 c3 3b 00 	movl   $0x3bc3,0x4(%esp)
    1c58:	00 
    1c59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c60:	e8 1b 13 00 00       	call   2f80 <printf>
    exit();
    1c65:	e8 de 11 00 00       	call   2e48 <exit>
  }
  unlink("lf1");

  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    1c6a:	c7 44 24 04 24 44 00 	movl   $0x4424,0x4(%esp)
    1c71:	00 
    1c72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c79:	e8 02 13 00 00       	call   2f80 <printf>
    exit();
    1c7e:	e8 c5 11 00 00       	call   2e48 <exit>
  }

  fd = open("lf2", 0);
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    1c83:	c7 44 24 04 d8 3b 00 	movl   $0x3bd8,0x4(%esp)
    1c8a:	00 
    1c8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c92:	e8 e9 12 00 00       	call   2f80 <printf>
    exit();
    1c97:	e8 ac 11 00 00       	call   2e48 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "read lf2 failed\n");
    1c9c:	c7 44 24 04 e9 3b 00 	movl   $0x3be9,0x4(%esp)
    1ca3:	00 
    1ca4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cab:	e8 d0 12 00 00       	call   2f80 <printf>
    exit();
    1cb0:	e8 93 11 00 00       	call   2e48 <exit>
  }
  close(fd);

  if(link("lf2", "lf2") >= 0){
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1cb5:	c7 44 24 04 fa 3b 00 	movl   $0x3bfa,0x4(%esp)
    1cbc:	00 
    1cbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cc4:	e8 b7 12 00 00       	call   2f80 <printf>
    exit();
    1cc9:	e8 7a 11 00 00       	call   2e48 <exit>
  }

  unlink("lf2");
  if(link("lf2", "lf1") >= 0){
    printf(1, "link non-existant succeeded! oops\n");
    1cce:	c7 44 24 04 4c 44 00 	movl   $0x444c,0x4(%esp)
    1cd5:	00 
    1cd6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cdd:	e8 9e 12 00 00       	call   2f80 <printf>
    exit();
    1ce2:	e8 61 11 00 00       	call   2e48 <exit>
  }

  if(link(".", "lf1") >= 0){
    printf(1, "link . lf1 succeeded! oops\n");
    1ce7:	c7 44 24 04 18 3c 00 	movl   $0x3c18,0x4(%esp)
    1cee:	00 
    1cef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cf6:	e8 85 12 00 00       	call   2f80 <printf>
    exit();
    1cfb:	e8 48 11 00 00       	call   2e48 <exit>

00001d00 <unlinkread>:
}

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1d00:	55                   	push   %ebp
    1d01:	89 e5                	mov    %esp,%ebp
    1d03:	56                   	push   %esi
    1d04:	53                   	push   %ebx
    1d05:	83 ec 10             	sub    $0x10,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1d08:	c7 44 24 04 41 3c 00 	movl   $0x3c41,0x4(%esp)
    1d0f:	00 
    1d10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d17:	e8 64 12 00 00       	call   2f80 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1d1c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d23:	00 
    1d24:	c7 04 24 52 3c 00 00 	movl   $0x3c52,(%esp)
    1d2b:	e8 58 11 00 00       	call   2e88 <open>
  if(fd < 0){
    1d30:	85 c0                	test   %eax,%eax
unlinkread(void)
{
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1d32:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d34:	0f 88 06 01 00 00    	js     1e40 <unlinkread+0x140>
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1d3a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1d41:	00 
    1d42:	c7 44 24 04 ab 3b 00 	movl   $0x3bab,0x4(%esp)
    1d49:	00 
    1d4a:	89 04 24             	mov    %eax,(%esp)
    1d4d:	e8 16 11 00 00       	call   2e68 <write>
  close(fd);
    1d52:	89 1c 24             	mov    %ebx,(%esp)
    1d55:	e8 16 11 00 00       	call   2e70 <close>

  fd = open("unlinkread", O_RDWR);
    1d5a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1d61:	00 
    1d62:	c7 04 24 52 3c 00 00 	movl   $0x3c52,(%esp)
    1d69:	e8 1a 11 00 00       	call   2e88 <open>
  if(fd < 0){
    1d6e:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
    1d70:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    1d72:	0f 88 e1 00 00 00    	js     1e59 <unlinkread+0x159>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    1d78:	c7 04 24 52 3c 00 00 	movl   $0x3c52,(%esp)
    1d7f:	e8 14 11 00 00       	call   2e98 <unlink>
    1d84:	85 c0                	test   %eax,%eax
    1d86:	0f 85 e6 00 00 00    	jne    1e72 <unlinkread+0x172>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1d8c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d93:	00 
    1d94:	c7 04 24 52 3c 00 00 	movl   $0x3c52,(%esp)
    1d9b:	e8 e8 10 00 00       	call   2e88 <open>
  write(fd1, "yyy", 3);
    1da0:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    1da7:	00 
    1da8:	c7 44 24 04 a9 3c 00 	movl   $0x3ca9,0x4(%esp)
    1daf:	00 
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1db0:	89 c3                	mov    %eax,%ebx
  write(fd1, "yyy", 3);
    1db2:	89 04 24             	mov    %eax,(%esp)
    1db5:	e8 ae 10 00 00       	call   2e68 <write>
  close(fd1);
    1dba:	89 1c 24             	mov    %ebx,(%esp)
    1dbd:	e8 ae 10 00 00       	call   2e70 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1dc2:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1dc9:	00 
    1dca:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    1dd1:	00 
    1dd2:	89 34 24             	mov    %esi,(%esp)
    1dd5:	e8 86 10 00 00       	call   2e60 <read>
    1dda:	83 f8 05             	cmp    $0x5,%eax
    1ddd:	0f 85 a8 00 00 00    	jne    1e8b <unlinkread+0x18b>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    1de3:	80 3d e0 45 00 00 68 	cmpb   $0x68,0x45e0
    1dea:	0f 85 b4 00 00 00    	jne    1ea4 <unlinkread+0x1a4>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    1df0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1df7:	00 
    1df8:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    1dff:	00 
    1e00:	89 34 24             	mov    %esi,(%esp)
    1e03:	e8 60 10 00 00       	call   2e68 <write>
    1e08:	83 f8 0a             	cmp    $0xa,%eax
    1e0b:	0f 85 ac 00 00 00    	jne    1ebd <unlinkread+0x1bd>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    1e11:	89 34 24             	mov    %esi,(%esp)
    1e14:	e8 57 10 00 00       	call   2e70 <close>
  unlink("unlinkread");
    1e19:	c7 04 24 52 3c 00 00 	movl   $0x3c52,(%esp)
    1e20:	e8 73 10 00 00       	call   2e98 <unlink>
  printf(1, "unlinkread ok\n");
    1e25:	c7 44 24 04 f4 3c 00 	movl   $0x3cf4,0x4(%esp)
    1e2c:	00 
    1e2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e34:	e8 47 11 00 00       	call   2f80 <printf>
}
    1e39:	83 c4 10             	add    $0x10,%esp
    1e3c:	5b                   	pop    %ebx
    1e3d:	5e                   	pop    %esi
    1e3e:	5d                   	pop    %ebp
    1e3f:	c3                   	ret    
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create unlinkread failed\n");
    1e40:	c7 44 24 04 5d 3c 00 	movl   $0x3c5d,0x4(%esp)
    1e47:	00 
    1e48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e4f:	e8 2c 11 00 00       	call   2f80 <printf>
    exit();
    1e54:	e8 ef 0f 00 00       	call   2e48 <exit>
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    1e59:	c7 44 24 04 77 3c 00 	movl   $0x3c77,0x4(%esp)
    1e60:	00 
    1e61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e68:	e8 13 11 00 00       	call   2f80 <printf>
    exit();
    1e6d:	e8 d6 0f 00 00       	call   2e48 <exit>
  }
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    1e72:	c7 44 24 04 8f 3c 00 	movl   $0x3c8f,0x4(%esp)
    1e79:	00 
    1e7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e81:	e8 fa 10 00 00       	call   2f80 <printf>
    exit();
    1e86:	e8 bd 0f 00 00       	call   2e48 <exit>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
  write(fd1, "yyy", 3);
  close(fd1);

  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    1e8b:	c7 44 24 04 ad 3c 00 	movl   $0x3cad,0x4(%esp)
    1e92:	00 
    1e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e9a:	e8 e1 10 00 00       	call   2f80 <printf>
    exit();
    1e9f:	e8 a4 0f 00 00       	call   2e48 <exit>
  }
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    1ea4:	c7 44 24 04 c4 3c 00 	movl   $0x3cc4,0x4(%esp)
    1eab:	00 
    1eac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eb3:	e8 c8 10 00 00       	call   2f80 <printf>
    exit();
    1eb8:	e8 8b 0f 00 00       	call   2e48 <exit>
  }
  if(write(fd, buf, 10) != 10){
    printf(1, "unlinkread write failed\n");
    1ebd:	c7 44 24 04 db 3c 00 	movl   $0x3cdb,0x4(%esp)
    1ec4:	00 
    1ec5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ecc:	e8 af 10 00 00       	call   2f80 <printf>
    exit();
    1ed1:	e8 72 0f 00 00       	call   2e48 <exit>
    1ed6:	8d 76 00             	lea    0x0(%esi),%esi
    1ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001ee0 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
    1ee0:	55                   	push   %ebp
    1ee1:	89 e5                	mov    %esp,%ebp
    1ee3:	57                   	push   %edi
    1ee4:	56                   	push   %esi
    1ee5:	53                   	push   %ebx
    1ee6:	83 ec 1c             	sub    $0x1c,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
    1ee9:	c7 44 24 04 03 3d 00 	movl   $0x3d03,0x4(%esp)
    1ef0:	00 
    1ef1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ef8:	e8 83 10 00 00       	call   2f80 <printf>

  unlink("f1");
    1efd:	c7 04 24 91 3b 00 00 	movl   $0x3b91,(%esp)
    1f04:	e8 8f 0f 00 00       	call   2e98 <unlink>
  unlink("f2");
    1f09:	c7 04 24 95 3b 00 00 	movl   $0x3b95,(%esp)
    1f10:	e8 83 0f 00 00       	call   2e98 <unlink>

  pid = fork();
    1f15:	e8 26 0f 00 00       	call   2e40 <fork>
  if(pid < 0){
    1f1a:	83 f8 00             	cmp    $0x0,%eax
  printf(1, "twofiles test\n");

  unlink("f1");
  unlink("f2");

  pid = fork();
    1f1d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    1f1f:	0f 8c 14 01 00 00    	jl     2039 <twofiles+0x159>
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
    1f25:	b8 91 3b 00 00       	mov    $0x3b91,%eax
    1f2a:	0f 84 e1 00 00 00    	je     2011 <twofiles+0x131>
  fd = open(fname, O_CREATE | O_RDWR);
    1f30:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1f37:	00 
    1f38:	89 04 24             	mov    %eax,(%esp)
    1f3b:	e8 48 0f 00 00       	call   2e88 <open>
  if(fd < 0){
    1f40:	85 c0                	test   %eax,%eax
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
    1f42:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    1f44:	0f 88 75 01 00 00    	js     20bf <twofiles+0x1df>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
    1f4a:	83 ff 01             	cmp    $0x1,%edi
    1f4d:	19 c0                	sbb    %eax,%eax
    1f4f:	31 db                	xor    %ebx,%ebx
    1f51:	83 e0 f3             	and    $0xfffffff3,%eax
    1f54:	83 c0 70             	add    $0x70,%eax
    1f57:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1f5e:	00 
    1f5f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1f63:	c7 04 24 e0 45 00 00 	movl   $0x45e0,(%esp)
    1f6a:	e8 31 0d 00 00       	call   2ca0 <memset>
    1f6f:	90                   	nop    
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
    1f70:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1f77:	00 
    1f78:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    1f7f:	00 
    1f80:	89 34 24             	mov    %esi,(%esp)
    1f83:	e8 e0 0e 00 00       	call   2e68 <write>
    1f88:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1f8d:	0f 85 0f 01 00 00    	jne    20a2 <twofiles+0x1c2>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    1f93:	83 c3 01             	add    $0x1,%ebx
    1f96:	83 fb 0c             	cmp    $0xc,%ebx
    1f99:	75 d5                	jne    1f70 <twofiles+0x90>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
    1f9b:	89 34 24             	mov    %esi,(%esp)
    1f9e:	e8 cd 0e 00 00       	call   2e70 <close>
  if(pid)
    1fa3:	85 ff                	test   %edi,%edi
    1fa5:	0f 84 89 00 00 00    	je     2034 <twofiles+0x154>
    wait();
    1fab:	e8 a0 0e 00 00       	call   2e50 <wait>
    1fb0:	31 f6                	xor    %esi,%esi
    1fb2:	b8 95 3b 00 00       	mov    $0x3b95,%eax
  else
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    1fb7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1fbe:	00 
    1fbf:	31 ff                	xor    %edi,%edi
    1fc1:	89 04 24             	mov    %eax,(%esp)
    1fc4:	e8 bf 0e 00 00       	call   2e88 <open>
    1fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1fcc:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1fd3:	00 
    1fd4:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    1fdb:	00 
    1fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1fdf:	89 04 24             	mov    %eax,(%esp)
    1fe2:	e8 79 0e 00 00       	call   2e60 <read>
    1fe7:	85 c0                	test   %eax,%eax
    1fe9:	89 c3                	mov    %eax,%ebx
    1feb:	7e 68                	jle    2055 <twofiles+0x175>
    1fed:	31 c9                	xor    %ecx,%ecx
    1fef:	90                   	nop    
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
    1ff0:	83 fe 01             	cmp    $0x1,%esi
    1ff3:	0f be 91 e0 45 00 00 	movsbl 0x45e0(%ecx),%edx
    1ffa:	19 c0                	sbb    %eax,%eax
    1ffc:	83 e0 f3             	and    $0xfffffff3,%eax
    1fff:	83 c0 70             	add    $0x70,%eax
    2002:	39 c2                	cmp    %eax,%edx
    2004:	75 1a                	jne    2020 <twofiles+0x140>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    2006:	83 c1 01             	add    $0x1,%ecx
    2009:	39 cb                	cmp    %ecx,%ebx
    200b:	7f e3                	jg     1ff0 <twofiles+0x110>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    200d:	01 df                	add    %ebx,%edi
    200f:	eb bb                	jmp    1fcc <twofiles+0xec>
  if(pid < 0){
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
    2011:	b8 95 3b 00 00       	mov    $0x3b95,%eax
    2016:	e9 15 ff ff ff       	jmp    1f30 <twofiles+0x50>
    201b:	90                   	nop    
    201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
    2020:	c7 44 24 04 23 3d 00 	movl   $0x3d23,0x4(%esp)
    2027:	00 
    2028:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    202f:	e8 4c 0f 00 00       	call   2f80 <printf>
          exit();
    2034:	e8 0f 0e 00 00       	call   2e48 <exit>
  unlink("f1");
  unlink("f2");

  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
    2039:	c7 44 24 04 dc 33 00 	movl   $0x33dc,0x4(%esp)
    2040:	00 
    2041:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2048:	e8 33 0f 00 00       	call   2f80 <printf>

  unlink("f1");
  unlink("f2");

  printf(1, "twofiles ok\n");
}
    204d:	83 c4 1c             	add    $0x1c,%esp
    2050:	5b                   	pop    %ebx
    2051:	5e                   	pop    %esi
    2052:	5f                   	pop    %edi
    2053:	5d                   	pop    %ebp
    2054:	c3                   	ret    
          exit();
        }
      }
      total += n;
    }
    close(fd);
    2055:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2058:	89 04 24             	mov    %eax,(%esp)
    205b:	e8 10 0e 00 00       	call   2e70 <close>
    if(total != 12*500){
    2060:	81 ff 70 17 00 00    	cmp    $0x1770,%edi
    2066:	75 7a                	jne    20e2 <twofiles+0x202>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    2068:	83 ee 01             	sub    $0x1,%esi
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
      exit();
    206b:	b8 91 3b 00 00       	mov    $0x3b91,%eax
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    2070:	75 66                	jne    20d8 <twofiles+0x1f8>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
    2072:	89 04 24             	mov    %eax,(%esp)
    2075:	e8 1e 0e 00 00       	call   2e98 <unlink>
  unlink("f2");
    207a:	c7 04 24 95 3b 00 00 	movl   $0x3b95,(%esp)
    2081:	e8 12 0e 00 00       	call   2e98 <unlink>

  printf(1, "twofiles ok\n");
    2086:	c7 44 24 04 40 3d 00 	movl   $0x3d40,0x4(%esp)
    208d:	00 
    208e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2095:	e8 e6 0e 00 00       	call   2f80 <printf>
}
    209a:	83 c4 1c             	add    $0x1c,%esp
    209d:	5b                   	pop    %ebx
    209e:	5e                   	pop    %esi
    209f:	5f                   	pop    %edi
    20a0:	5d                   	pop    %ebp
    20a1:	c3                   	ret    
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
    20a2:	89 44 24 08          	mov    %eax,0x8(%esp)
    20a6:	c7 44 24 04 12 3d 00 	movl   $0x3d12,0x4(%esp)
    20ad:	00 
    20ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20b5:	e8 c6 0e 00 00       	call   2f80 <printf>
      exit();
    20ba:	e8 89 0d 00 00       	call   2e48 <exit>
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create failed\n");
    20bf:	c7 44 24 04 91 35 00 	movl   $0x3591,0x4(%esp)
    20c6:	00 
    20c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20ce:	e8 ad 0e 00 00       	call   2f80 <printf>
    exit();
    20d3:	e8 70 0d 00 00       	call   2e48 <exit>
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
    20d8:	be 01 00 00 00       	mov    $0x1,%esi
    20dd:	e9 d5 fe ff ff       	jmp    1fb7 <twofiles+0xd7>
      }
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
    20e2:	89 7c 24 08          	mov    %edi,0x8(%esp)
    20e6:	c7 44 24 04 2f 3d 00 	movl   $0x3d2f,0x4(%esp)
    20ed:	00 
    20ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20f5:	e8 86 0e 00 00       	call   2f80 <printf>
      exit();
    20fa:	e8 49 0d 00 00       	call   2e48 <exit>
    20ff:	90                   	nop    

00002100 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    2100:	55                   	push   %ebp
    2101:	89 e5                	mov    %esp,%ebp
    2103:	57                   	push   %edi
    2104:	56                   	push   %esi
    2105:	53                   	push   %ebx
    2106:	83 ec 2c             	sub    $0x2c,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  unlink("sharedfd");
    2109:	c7 04 24 4d 3d 00 00 	movl   $0x3d4d,(%esp)
    2110:	e8 83 0d 00 00       	call   2e98 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    2115:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    211c:	00 
    211d:	c7 04 24 4d 3d 00 00 	movl   $0x3d4d,(%esp)
    2124:	e8 5f 0d 00 00       	call   2e88 <open>
  if(fd < 0){
    2129:	85 c0                	test   %eax,%eax
{
  int fd, pid, i, n, nc, np;
  char buf[10];

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
    212b:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    212d:	0f 88 25 01 00 00    	js     2258 <sharedfd+0x158>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    2133:	e8 08 0d 00 00       	call   2e40 <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2138:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    213f:	00 
    2140:	83 f8 01             	cmp    $0x1,%eax
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    2143:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2145:	19 c0                	sbb    %eax,%eax
    2147:	31 db                	xor    %ebx,%ebx
    2149:	83 e0 f3             	and    $0xfffffff3,%eax
    214c:	83 c0 70             	add    $0x70,%eax
    214f:	89 44 24 04          	mov    %eax,0x4(%esp)
    2153:	8d 45 ea             	lea    -0x16(%ebp),%eax
    2156:	89 04 24             	mov    %eax,(%esp)
    2159:	e8 42 0b 00 00       	call   2ca0 <memset>
    215e:	eb 0b                	jmp    216b <sharedfd+0x6b>
  for(i = 0; i < 1000; i++){
    2160:	83 c3 01             	add    $0x1,%ebx
    2163:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2169:	74 30                	je     219b <sharedfd+0x9b>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    216b:	8d 45 ea             	lea    -0x16(%ebp),%eax
    216e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2175:	00 
    2176:	89 44 24 04          	mov    %eax,0x4(%esp)
    217a:	89 34 24             	mov    %esi,(%esp)
    217d:	e8 e6 0c 00 00       	call   2e68 <write>
    2182:	83 f8 0a             	cmp    $0xa,%eax
    2185:	74 d9                	je     2160 <sharedfd+0x60>
      printf(1, "fstests: write sharedfd failed\n");
    2187:	c7 44 24 04 9c 44 00 	movl   $0x449c,0x4(%esp)
    218e:	00 
    218f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2196:	e8 e5 0d 00 00       	call   2f80 <printf>
      break;
    }
  }
  if(pid == 0)
    219b:	85 ff                	test   %edi,%edi
    219d:	0f 84 11 01 00 00    	je     22b4 <sharedfd+0x1b4>
    exit();
  else
    wait();
    21a3:	e8 a8 0c 00 00       	call   2e50 <wait>
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    21a8:	31 db                	xor    %ebx,%ebx
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    21aa:	89 34 24             	mov    %esi,(%esp)
  fd = open("sharedfd", 0);
  if(fd < 0){
    21ad:	31 f6                	xor    %esi,%esi
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    21af:	e8 bc 0c 00 00       	call   2e70 <close>
  fd = open("sharedfd", 0);
    21b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21bb:	00 
    21bc:	c7 04 24 4d 3d 00 00 	movl   $0x3d4d,(%esp)
    21c3:	e8 c0 0c 00 00       	call   2e88 <open>
  if(fd < 0){
    21c8:	85 c0                	test   %eax,%eax
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
    21ca:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    21cc:	0f 88 c6 00 00 00    	js     2298 <sharedfd+0x198>
    21d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    21d8:	8d 45 ea             	lea    -0x16(%ebp),%eax
    21db:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    21e2:	00 
    21e3:	89 44 24 04          	mov    %eax,0x4(%esp)
    21e7:	89 3c 24             	mov    %edi,(%esp)
    21ea:	e8 71 0c 00 00       	call   2e60 <read>
    21ef:	85 c0                	test   %eax,%eax
    21f1:	7e 25                	jle    2218 <sharedfd+0x118>
    21f3:	8d 55 ea             	lea    -0x16(%ebp),%edx
    21f6:	eb 14                	jmp    220c <sharedfd+0x10c>
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
        np++;
    21f8:	3c 70                	cmp    $0x70,%al
    21fa:	0f 94 c0             	sete   %al
    21fd:	0f b6 c0             	movzbl %al,%eax
    2200:	01 c3                	add    %eax,%ebx
    2202:	83 c2 01             	add    $0x1,%edx
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
    2205:	8d 45 f4             	lea    -0xc(%ebp),%eax
    2208:	39 c2                	cmp    %eax,%edx
    220a:	74 cc                	je     21d8 <sharedfd+0xd8>
      if(buf[i] == 'c')
    220c:	0f b6 02             	movzbl (%edx),%eax
    220f:	3c 63                	cmp    $0x63,%al
    2211:	75 e5                	jne    21f8 <sharedfd+0xf8>
        nc++;
    2213:	83 c6 01             	add    $0x1,%esi
    2216:	eb ea                	jmp    2202 <sharedfd+0x102>
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
    2218:	89 3c 24             	mov    %edi,(%esp)
    221b:	e8 50 0c 00 00       	call   2e70 <close>
  unlink("sharedfd");
    2220:	c7 04 24 4d 3d 00 00 	movl   $0x3d4d,(%esp)
    2227:	e8 6c 0c 00 00       	call   2e98 <unlink>
  if(nc == 10000 && np == 10000)
    222c:	81 fe 10 27 00 00    	cmp    $0x2710,%esi
    2232:	74 40                	je     2274 <sharedfd+0x174>
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
    2234:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    2238:	89 74 24 08          	mov    %esi,0x8(%esp)
    223c:	c7 44 24 04 63 3d 00 	movl   $0x3d63,0x4(%esp)
    2243:	00 
    2244:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    224b:	e8 30 0d 00 00       	call   2f80 <printf>
}
    2250:	83 c4 2c             	add    $0x2c,%esp
    2253:	5b                   	pop    %ebx
    2254:	5e                   	pop    %esi
    2255:	5f                   	pop    %edi
    2256:	5d                   	pop    %ebp
    2257:	c3                   	ret    
  char buf[10];

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    2258:	c7 44 24 04 70 44 00 	movl   $0x4470,0x4(%esp)
    225f:	00 
    2260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2267:	e8 14 0d 00 00       	call   2f80 <printf>
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    226c:	83 c4 2c             	add    $0x2c,%esp
    226f:	5b                   	pop    %ebx
    2270:	5e                   	pop    %esi
    2271:	5f                   	pop    %edi
    2272:	5d                   	pop    %ebp
    2273:	c3                   	ret    
        np++;
    }
  }
  close(fd);
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    2274:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    227a:	75 b8                	jne    2234 <sharedfd+0x134>
    printf(1, "sharedfd ok\n");
    227c:	c7 44 24 04 56 3d 00 	movl   $0x3d56,0x4(%esp)
    2283:	00 
    2284:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    228b:	e8 f0 0c 00 00       	call   2f80 <printf>
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    2290:	83 c4 2c             	add    $0x2c,%esp
    2293:	5b                   	pop    %ebx
    2294:	5e                   	pop    %esi
    2295:	5f                   	pop    %edi
    2296:	5d                   	pop    %ebp
    2297:	c3                   	ret    
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    2298:	c7 44 24 04 bc 44 00 	movl   $0x44bc,0x4(%esp)
    229f:	00 
    22a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22a7:	e8 d4 0c 00 00       	call   2f80 <printf>
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    22ac:	83 c4 2c             	add    $0x2c,%esp
    22af:	5b                   	pop    %ebx
    22b0:	5e                   	pop    %esi
    22b1:	5f                   	pop    %edi
    22b2:	5d                   	pop    %ebp
    22b3:	c3                   	ret    
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
    exit();
    22b4:	e8 8f 0b 00 00       	call   2e48 <exit>
    22b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000022c0 <writetest1>:
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
    22c0:	55                   	push   %ebp
    22c1:	89 e5                	mov    %esp,%ebp
    22c3:	56                   	push   %esi
    22c4:	53                   	push   %ebx
  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
    22c5:	31 db                	xor    %ebx,%ebx
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
    22c7:	83 ec 10             	sub    $0x10,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
    22ca:	a1 a8 45 00 00       	mov    0x45a8,%eax
    22cf:	c7 44 24 04 78 3d 00 	movl   $0x3d78,0x4(%esp)
    22d6:	00 
    22d7:	89 04 24             	mov    %eax,(%esp)
    22da:	e8 a1 0c 00 00       	call   2f80 <printf>

  fd = open("big", O_CREATE|O_RDWR);
    22df:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    22e6:	00 
    22e7:	c7 04 24 f2 3d 00 00 	movl   $0x3df2,(%esp)
    22ee:	e8 95 0b 00 00       	call   2e88 <open>
  if(fd < 0){
    22f3:	85 c0                	test   %eax,%eax
{
  int i, fd, n;

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
    22f5:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    22f7:	0f 88 56 01 00 00    	js     2453 <writetest1+0x193>
    22fd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++) {
    ((int*) buf)[0] = i;
    2300:	89 1d e0 45 00 00    	mov    %ebx,0x45e0
    if(write(fd, buf, 512) != 512) {
    2306:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    230d:	00 
    230e:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    2315:	00 
    2316:	89 34 24             	mov    %esi,(%esp)
    2319:	e8 4a 0b 00 00       	call   2e68 <write>
    231e:	3d 00 02 00 00       	cmp    $0x200,%eax
    2323:	0f 85 cc 00 00 00    	jne    23f5 <writetest1+0x135>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++) {
    2329:	83 c3 01             	add    $0x1,%ebx
    232c:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
    2332:	75 cc                	jne    2300 <writetest1+0x40>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
    2334:	89 34 24             	mov    %esi,(%esp)

  fd = open("big", O_RDONLY);
  if(fd < 0){
    printf(stdout, "error: open big failed!\n");
    exit();
    2337:	30 db                	xor    %bl,%bl
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
    2339:	e8 32 0b 00 00       	call   2e70 <close>

  fd = open("big", O_RDONLY);
    233e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2345:	00 
    2346:	c7 04 24 f2 3d 00 00 	movl   $0x3df2,(%esp)
    234d:	e8 36 0b 00 00       	call   2e88 <open>
  if(fd < 0){
    2352:	85 c0                	test   %eax,%eax
    }
  }

  close(fd);

  fd = open("big", O_RDONLY);
    2354:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2356:	79 3b                	jns    2393 <writetest1+0xd3>
    printf(stdout, "error: open big failed!\n");
    2358:	a1 a8 45 00 00       	mov    0x45a8,%eax
    235d:	c7 44 24 04 c0 3d 00 	movl   $0x3dc0,0x4(%esp)
    2364:	00 
    2365:	89 04 24             	mov    %eax,(%esp)
    2368:	e8 13 0c 00 00       	call   2f80 <printf>
    exit();
    236d:	e8 d6 0a 00 00       	call   2e48 <exit>
    2372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(n == MAXFILE - 1) {
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512) {
    2378:	3d 00 02 00 00       	cmp    $0x200,%eax
    237d:	0f 85 90 00 00 00    	jne    2413 <writetest1+0x153>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n) {
    2383:	a1 e0 45 00 00       	mov    0x45e0,%eax
    2388:	39 d8                	cmp    %ebx,%eax
    238a:	0f 85 a1 00 00 00    	jne    2431 <writetest1+0x171>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
    2390:	83 c3 01             	add    $0x1,%ebx
    exit();
  }

  n = 0;
  for(;;) {
    i = read(fd, buf, 512);
    2393:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    239a:	00 
    239b:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    23a2:	00 
    23a3:	89 34 24             	mov    %esi,(%esp)
    23a6:	e8 b5 0a 00 00       	call   2e60 <read>
    if(i == 0) {
    23ab:	85 c0                	test   %eax,%eax
    23ad:	75 c9                	jne    2378 <writetest1+0xb8>
      if(n == MAXFILE - 1) {
    23af:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
    23b5:	0f 84 b2 00 00 00    	je     246d <writetest1+0x1ad>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
    23bb:	89 34 24             	mov    %esi,(%esp)
    23be:	66 90                	xchg   %ax,%ax
    23c0:	e8 ab 0a 00 00       	call   2e70 <close>
  if(unlink("big") < 0) {
    23c5:	c7 04 24 f2 3d 00 00 	movl   $0x3df2,(%esp)
    23cc:	e8 c7 0a 00 00       	call   2e98 <unlink>
    23d1:	85 c0                	test   %eax,%eax
    23d3:	0f 88 b6 00 00 00    	js     248f <writetest1+0x1cf>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
    23d9:	a1 a8 45 00 00       	mov    0x45a8,%eax
    23de:	c7 44 24 04 19 3e 00 	movl   $0x3e19,0x4(%esp)
    23e5:	00 
    23e6:	89 04 24             	mov    %eax,(%esp)
    23e9:	e8 92 0b 00 00       	call   2f80 <printf>
}
    23ee:	83 c4 10             	add    $0x10,%esp
    23f1:	5b                   	pop    %ebx
    23f2:	5e                   	pop    %esi
    23f3:	5d                   	pop    %ebp
    23f4:	c3                   	ret    
  }

  for(i = 0; i < MAXFILE; i++) {
    ((int*) buf)[0] = i;
    if(write(fd, buf, 512) != 512) {
      printf(stdout, "error: write big file failed\n", i);
    23f5:	a1 a8 45 00 00       	mov    0x45a8,%eax
    23fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    23fe:	c7 44 24 04 a2 3d 00 	movl   $0x3da2,0x4(%esp)
    2405:	00 
    2406:	89 04 24             	mov    %eax,(%esp)
    2409:	e8 72 0b 00 00       	call   2f80 <printf>
      exit();
    240e:	e8 35 0a 00 00       	call   2e48 <exit>
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512) {
      printf(stdout, "read failed %d\n", i);
    2413:	89 44 24 08          	mov    %eax,0x8(%esp)
    2417:	a1 a8 45 00 00       	mov    0x45a8,%eax
    241c:	c7 44 24 04 f6 3d 00 	movl   $0x3df6,0x4(%esp)
    2423:	00 
    2424:	89 04 24             	mov    %eax,(%esp)
    2427:	e8 54 0b 00 00       	call   2f80 <printf>
      exit();
    242c:	e8 17 0a 00 00       	call   2e48 <exit>
    }
    if(((int*)buf)[0] != n) {
      printf(stdout, "read content of block %d is %d\n",
    2431:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2435:	a1 a8 45 00 00       	mov    0x45a8,%eax
    243a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    243e:	c7 44 24 04 e8 44 00 	movl   $0x44e8,0x4(%esp)
    2445:	00 
    2446:	89 04 24             	mov    %eax,(%esp)
    2449:	e8 32 0b 00 00       	call   2f80 <printf>
             n, ((int*)buf)[0]);
      exit();
    244e:	e8 f5 09 00 00       	call   2e48 <exit>

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    2453:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2458:	c7 44 24 04 88 3d 00 	movl   $0x3d88,0x4(%esp)
    245f:	00 
    2460:	89 04 24             	mov    %eax,(%esp)
    2463:	e8 18 0b 00 00       	call   2f80 <printf>
    exit();
    2468:	e8 db 09 00 00       	call   2e48 <exit>
  n = 0;
  for(;;) {
    i = read(fd, buf, 512);
    if(i == 0) {
      if(n == MAXFILE - 1) {
        printf(stdout, "read only %d blocks from big", n);
    246d:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2472:	c7 44 24 08 8b 00 00 	movl   $0x8b,0x8(%esp)
    2479:	00 
    247a:	c7 44 24 04 d9 3d 00 	movl   $0x3dd9,0x4(%esp)
    2481:	00 
    2482:	89 04 24             	mov    %eax,(%esp)
    2485:	e8 f6 0a 00 00       	call   2f80 <printf>
        exit();
    248a:	e8 b9 09 00 00       	call   2e48 <exit>
    }
    n++;
  }
  close(fd);
  if(unlink("big") < 0) {
    printf(stdout, "unlink big failed\n");
    248f:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2494:	c7 44 24 04 06 3e 00 	movl   $0x3e06,0x4(%esp)
    249b:	00 
    249c:	89 04 24             	mov    %eax,(%esp)
    249f:	e8 dc 0a 00 00       	call   2f80 <printf>
    exit();
    24a4:	e8 9f 09 00 00       	call   2e48 <exit>
    24a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000024b0 <writetest>:
  printf(stdout, "open test ok\n");
}

void
writetest(void)
{
    24b0:	55                   	push   %ebp
    24b1:	89 e5                	mov    %esp,%ebp
    24b3:	56                   	push   %esi
    24b4:	53                   	push   %ebx
    24b5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
    24b8:	a1 a8 45 00 00       	mov    0x45a8,%eax
    24bd:	c7 44 24 04 27 3e 00 	movl   $0x3e27,0x4(%esp)
    24c4:	00 
    24c5:	89 04 24             	mov    %eax,(%esp)
    24c8:	e8 b3 0a 00 00       	call   2f80 <printf>
  fd = open("small", O_CREATE|O_RDWR);
    24cd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    24d4:	00 
    24d5:	c7 04 24 38 3e 00 00 	movl   $0x3e38,(%esp)
    24dc:	e8 a7 09 00 00       	call   2e88 <open>
  if(fd >= 0){
    24e1:	85 c0                	test   %eax,%eax
{
  int fd;
  int i;

  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
    24e3:	89 c6                	mov    %eax,%esi
  if(fd >= 0){
    24e5:	0f 88 63 01 00 00    	js     264e <writetest+0x19e>
    printf(stdout, "creat small succeeded; ok\n");
    24eb:	a1 a8 45 00 00       	mov    0x45a8,%eax
    24f0:	31 db                	xor    %ebx,%ebx
    24f2:	c7 44 24 04 3e 3e 00 	movl   $0x3e3e,0x4(%esp)
    24f9:	00 
    24fa:	89 04 24             	mov    %eax,(%esp)
    24fd:	e8 7e 0a 00 00       	call   2f80 <printf>
    2502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++) {
    if(write(fd, "aaaaaaaaaa", 10) != 10) {
    2508:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    250f:	00 
    2510:	c7 44 24 04 75 3e 00 	movl   $0x3e75,0x4(%esp)
    2517:	00 
    2518:	89 34 24             	mov    %esi,(%esp)
    251b:	e8 48 09 00 00       	call   2e68 <write>
    2520:	83 f8 0a             	cmp    $0xa,%eax
    2523:	0f 85 e9 00 00 00    	jne    2612 <writetest+0x162>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
    2529:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2530:	00 
    2531:	c7 44 24 04 80 3e 00 	movl   $0x3e80,0x4(%esp)
    2538:	00 
    2539:	89 34 24             	mov    %esi,(%esp)
    253c:	e8 27 09 00 00       	call   2e68 <write>
    2541:	83 f8 0a             	cmp    $0xa,%eax
    2544:	0f 85 e6 00 00 00    	jne    2630 <writetest+0x180>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++) {
    254a:	83 c3 01             	add    $0x1,%ebx
    254d:	83 fb 64             	cmp    $0x64,%ebx
    2550:	75 b6                	jne    2508 <writetest+0x58>
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
    2552:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2557:	c7 44 24 04 8b 3e 00 	movl   $0x3e8b,0x4(%esp)
    255e:	00 
    255f:	89 04 24             	mov    %eax,(%esp)
    2562:	e8 19 0a 00 00       	call   2f80 <printf>
  close(fd);
    2567:	89 34 24             	mov    %esi,(%esp)
    256a:	e8 01 09 00 00       	call   2e70 <close>
  fd = open("small", O_RDONLY);
    256f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2576:	00 
    2577:	c7 04 24 38 3e 00 00 	movl   $0x3e38,(%esp)
    257e:	e8 05 09 00 00       	call   2e88 <open>
  if(fd >= 0){
    2583:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  printf(stdout, "writes ok\n");
  close(fd);
  fd = open("small", O_RDONLY);
    2585:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
    2587:	0f 88 db 00 00 00    	js     2668 <writetest+0x1b8>
    printf(stdout, "open small succeeded ok\n");
    258d:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2592:	c7 44 24 04 96 3e 00 	movl   $0x3e96,0x4(%esp)
    2599:	00 
    259a:	89 04 24             	mov    %eax,(%esp)
    259d:	e8 de 09 00 00       	call   2f80 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
    25a2:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
    25a9:	00 
    25aa:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    25b1:	00 
    25b2:	89 1c 24             	mov    %ebx,(%esp)
    25b5:	e8 a6 08 00 00       	call   2e60 <read>
  if(i == 2000) {
    25ba:	3d d0 07 00 00       	cmp    $0x7d0,%eax
    25bf:	0f 85 bd 00 00 00    	jne    2682 <writetest+0x1d2>
    printf(stdout, "read succeeded ok\n");
    25c5:	a1 a8 45 00 00       	mov    0x45a8,%eax
    25ca:	c7 44 24 04 ca 3e 00 	movl   $0x3eca,0x4(%esp)
    25d1:	00 
    25d2:	89 04 24             	mov    %eax,(%esp)
    25d5:	e8 a6 09 00 00       	call   2f80 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
    25da:	89 1c 24             	mov    %ebx,(%esp)
    25dd:	e8 8e 08 00 00       	call   2e70 <close>

  if(unlink("small") < 0) {
    25e2:	c7 04 24 38 3e 00 00 	movl   $0x3e38,(%esp)
    25e9:	e8 aa 08 00 00       	call   2e98 <unlink>
    25ee:	85 c0                	test   %eax,%eax
    25f0:	0f 88 a6 00 00 00    	js     269c <writetest+0x1ec>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
    25f6:	a1 a8 45 00 00       	mov    0x45a8,%eax
    25fb:	c7 44 24 04 f2 3e 00 	movl   $0x3ef2,0x4(%esp)
    2602:	00 
    2603:	89 04 24             	mov    %eax,(%esp)
    2606:	e8 75 09 00 00       	call   2f80 <printf>
}
    260b:	83 c4 10             	add    $0x10,%esp
    260e:	5b                   	pop    %ebx
    260f:	5e                   	pop    %esi
    2610:	5d                   	pop    %ebp
    2611:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++) {
    if(write(fd, "aaaaaaaaaa", 10) != 10) {
      printf(stdout, "error: write aa %d new file failed\n", i);
    2612:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2617:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    261b:	c7 44 24 04 08 45 00 	movl   $0x4508,0x4(%esp)
    2622:	00 
    2623:	89 04 24             	mov    %eax,(%esp)
    2626:	e8 55 09 00 00       	call   2f80 <printf>
      exit();
    262b:	e8 18 08 00 00       	call   2e48 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
      printf(stdout, "error: write bb %d new file failed\n", i);
    2630:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2635:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    2639:	c7 44 24 04 2c 45 00 	movl   $0x452c,0x4(%esp)
    2640:	00 
    2641:	89 04 24             	mov    %eax,(%esp)
    2644:	e8 37 09 00 00       	call   2f80 <printf>
      exit();
    2649:	e8 fa 07 00 00       	call   2e48 <exit>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    264e:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2653:	c7 44 24 04 59 3e 00 	movl   $0x3e59,0x4(%esp)
    265a:	00 
    265b:	89 04 24             	mov    %eax,(%esp)
    265e:	e8 1d 09 00 00       	call   2f80 <printf>
    exit();
    2663:	e8 e0 07 00 00       	call   2e48 <exit>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
    2668:	a1 a8 45 00 00       	mov    0x45a8,%eax
    266d:	c7 44 24 04 af 3e 00 	movl   $0x3eaf,0x4(%esp)
    2674:	00 
    2675:	89 04 24             	mov    %eax,(%esp)
    2678:	e8 03 09 00 00       	call   2f80 <printf>
    exit();
    267d:	e8 c6 07 00 00       	call   2e48 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000) {
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
    2682:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2687:	c7 44 24 04 6a 3c 00 	movl   $0x3c6a,0x4(%esp)
    268e:	00 
    268f:	89 04 24             	mov    %eax,(%esp)
    2692:	e8 e9 08 00 00       	call   2f80 <printf>
    exit();
    2697:	e8 ac 07 00 00       	call   2e48 <exit>
  }
  close(fd);

  if(unlink("small") < 0) {
    printf(stdout, "unlink small failed\n");
    269c:	a1 a8 45 00 00       	mov    0x45a8,%eax
    26a1:	c7 44 24 04 dd 3e 00 	movl   $0x3edd,0x4(%esp)
    26a8:	00 
    26a9:	89 04 24             	mov    %eax,(%esp)
    26ac:	e8 cf 08 00 00       	call   2f80 <printf>
    exit();
    26b1:	e8 92 07 00 00       	call   2e48 <exit>
    26b6:	8d 76 00             	lea    0x0(%esi),%esi
    26b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000026c0 <mem>:
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    26c0:	55                   	push   %ebp
    26c1:	89 e5                	mov    %esp,%ebp
    26c3:	56                   	push   %esi
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    26c4:	31 f6                	xor    %esi,%esi
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    26c6:	53                   	push   %ebx
    26c7:	83 ec 10             	sub    $0x10,%esp
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    26ca:	e8 71 07 00 00       	call   2e40 <fork>
    26cf:	85 c0                	test   %eax,%eax
    26d1:	74 09                	je     26dc <mem+0x1c>
    26d3:	eb 54                	jmp    2729 <mem+0x69>
    26d5:	8d 76 00             	lea    0x0(%esi),%esi
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
      *(char**) m2 = m1;
    26d8:	89 30                	mov    %esi,(%eax)
    26da:	89 c6                	mov    %eax,%esi
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
    26dc:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    26e3:	e8 78 0b 00 00       	call   3260 <malloc>
    26e8:	85 c0                	test   %eax,%eax
    26ea:	75 ec                	jne    26d8 <mem+0x18>
      *(char**) m2 = m1;
      m1 = m2;
    }
    while(m1) {
    26ec:	85 f6                	test   %esi,%esi
    26ee:	74 10                	je     2700 <mem+0x40>
      m2 = *(char**)m1;
    26f0:	8b 1e                	mov    (%esi),%ebx
      free(m1);
    26f2:	89 34 24             	mov    %esi,(%esp)
    26f5:	e8 c6 0a 00 00       	call   31c0 <free>
    26fa:	89 de                	mov    %ebx,%esi
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
      *(char**) m2 = m1;
      m1 = m2;
    }
    while(m1) {
    26fc:	85 f6                	test   %esi,%esi
    26fe:	75 f0                	jne    26f0 <mem+0x30>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    2700:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    2707:	e8 54 0b 00 00       	call   3260 <malloc>
    if(m1 == 0) {
    270c:	85 c0                	test   %eax,%eax
    270e:	75 24                	jne    2734 <mem+0x74>
      printf(1, "couldn't allocate mem?!!\n");
    2710:	c7 44 24 04 06 3f 00 	movl   $0x3f06,0x4(%esp)
    2717:	00 
    2718:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    271f:	e8 5c 08 00 00       	call   2f80 <printf>
      exit();
    2724:	e8 1f 07 00 00       	call   2e48 <exit>
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
  }
}
    2729:	83 c4 10             	add    $0x10,%esp
    272c:	5b                   	pop    %ebx
    272d:	5e                   	pop    %esi
    272e:	5d                   	pop    %ebp
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
    272f:	e9 1c 07 00 00       	jmp    2e50 <wait>
    m1 = malloc(1024*20);
    if(m1 == 0) {
      printf(1, "couldn't allocate mem?!!\n");
      exit();
    }
    free(m1);
    2734:	89 04 24             	mov    %eax,(%esp)
    2737:	e8 84 0a 00 00       	call   31c0 <free>
    printf(1, "mem ok\n");
    273c:	c7 44 24 04 20 3f 00 	movl   $0x3f20,0x4(%esp)
    2743:	00 
    2744:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    274b:	e8 30 08 00 00       	call   2f80 <printf>
    exit();
    2750:	e8 f3 06 00 00       	call   2e48 <exit>
    2755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002760 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    2760:	55                   	push   %ebp
    2761:	89 e5                	mov    %esp,%ebp
    2763:	57                   	push   %edi
    2764:	56                   	push   %esi
    2765:	53                   	push   %ebx
    2766:	83 ec 1c             	sub    $0x1c,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    2769:	8d 45 ec             	lea    -0x14(%ebp),%eax
    276c:	89 04 24             	mov    %eax,(%esp)
    276f:	e8 e4 06 00 00       	call   2e58 <pipe>
    2774:	85 c0                	test   %eax,%eax
    2776:	0f 85 3f 01 00 00    	jne    28bb <pipe1+0x15b>
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
    277c:	e8 bf 06 00 00       	call   2e40 <fork>
  seq = 0;
  if(pid == 0){
    2781:	83 f8 00             	cmp    $0x0,%eax
    2784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2788:	0f 84 83 00 00 00    	je     2811 <pipe1+0xb1>
    278e:	66 90                	xchg   %ax,%ax
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
    2790:	0f 8e 57 01 00 00    	jle    28ed <pipe1+0x18d>
    close(fds[1]);
    2796:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2799:	31 db                	xor    %ebx,%ebx
    279b:	be 01 00 00 00       	mov    $0x1,%esi
    27a0:	31 ff                	xor    %edi,%edi
    27a2:	89 04 24             	mov    %eax,(%esp)
    27a5:	e8 c6 06 00 00       	call   2e70 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
    27aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    27ad:	89 74 24 08          	mov    %esi,0x8(%esp)
    27b1:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    27b8:	00 
    27b9:	89 04 24             	mov    %eax,(%esp)
    27bc:	e8 9f 06 00 00       	call   2e60 <read>
    27c1:	85 c0                	test   %eax,%eax
    27c3:	0f 8e a4 00 00 00    	jle    286d <pipe1+0x10d>
    27c9:	31 d2                	xor    %edx,%edx
    27cb:	90                   	nop    
    27cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    27d0:	38 9a e0 45 00 00    	cmp    %bl,0x45e0(%edx)
    27d6:	75 1d                	jne    27f5 <pipe1+0x95>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    27d8:	83 c2 01             	add    $0x1,%edx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    27db:	83 c3 01             	add    $0x1,%ebx
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    27de:	39 d0                	cmp    %edx,%eax
    27e0:	7f ee                	jg     27d0 <pipe1+0x70>
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
      cc = cc * 2;
    27e2:	01 f6                	add    %esi,%esi
      if(cc > sizeof(buf))
    27e4:	81 fe 00 08 00 00    	cmp    $0x800,%esi
    27ea:	76 05                	jbe    27f1 <pipe1+0x91>
    27ec:	be 00 08 00 00       	mov    $0x800,%esi
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
    27f1:	01 c7                	add    %eax,%edi
    27f3:	eb b5                	jmp    27aa <pipe1+0x4a>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
    27f5:	c7 44 24 04 45 3f 00 	movl   $0x3f45,0x4(%esp)
    27fc:	00 
    27fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2804:	e8 77 07 00 00       	call   2f80 <printf>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
    2809:	83 c4 1c             	add    $0x1c,%esp
    280c:	5b                   	pop    %ebx
    280d:	5e                   	pop    %esi
    280e:	5f                   	pop    %edi
    280f:	5d                   	pop    %ebp
    2810:	c3                   	ret    
    exit();
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    2811:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2814:	31 db                	xor    %ebx,%ebx
    2816:	89 04 24             	mov    %eax,(%esp)
    2819:	e8 52 06 00 00       	call   2e70 <close>
    for(n = 0; n < 5; n++){
    281e:	31 d2                	xor    %edx,%edx
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
    2820:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
    2823:	88 82 e0 45 00 00    	mov    %al,0x45e0(%edx)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    2829:	83 c2 01             	add    $0x1,%edx
    282c:	81 fa 09 04 00 00    	cmp    $0x409,%edx
    2832:	75 ec                	jne    2820 <pipe1+0xc0>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    2834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    2837:	81 c3 09 04 00 00    	add    $0x409,%ebx
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    283d:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    2844:	00 
    2845:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    284c:	00 
    284d:	89 04 24             	mov    %eax,(%esp)
    2850:	e8 13 06 00 00       	call   2e68 <write>
    2855:	3d 09 04 00 00       	cmp    $0x409,%eax
    285a:	75 78                	jne    28d4 <pipe1+0x174>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
    285c:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
    2862:	75 ba                	jne    281e <pipe1+0xbe>
    2864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "pipe1 oops 3 total %d\n", total);
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    exit();
    2868:	e8 db 05 00 00       	call   2e48 <exit>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033)
    286d:	81 ff 2d 14 00 00    	cmp    $0x142d,%edi
    2873:	90                   	nop    
    2874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2878:	74 18                	je     2892 <pipe1+0x132>
      printf(1, "pipe1 oops 3 total %d\n", total);
    287a:	89 7c 24 08          	mov    %edi,0x8(%esp)
    287e:	c7 44 24 04 53 3f 00 	movl   $0x3f53,0x4(%esp)
    2885:	00 
    2886:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    288d:	e8 ee 06 00 00       	call   2f80 <printf>
    close(fds[0]);
    2892:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2895:	89 04 24             	mov    %eax,(%esp)
    2898:	e8 d3 05 00 00       	call   2e70 <close>
    wait();
    289d:	e8 ae 05 00 00       	call   2e50 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
    28a2:	c7 44 24 04 6a 3f 00 	movl   $0x3f6a,0x4(%esp)
    28a9:	00 
    28aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28b1:	e8 ca 06 00 00       	call   2f80 <printf>
    28b6:	e9 4e ff ff ff       	jmp    2809 <pipe1+0xa9>
{
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    28bb:	c7 44 24 04 28 3f 00 	movl   $0x3f28,0x4(%esp)
    28c2:	00 
    28c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28ca:	e8 b1 06 00 00       	call   2f80 <printf>
    exit();
    28cf:	e8 74 05 00 00       	call   2e48 <exit>
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
    28d4:	c7 44 24 04 37 3f 00 	movl   $0x3f37,0x4(%esp)
    28db:	00 
    28dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28e3:	e8 98 06 00 00       	call   2f80 <printf>
        exit();
    28e8:	e8 5b 05 00 00       	call   2e48 <exit>
    if(total != 5 * 1033)
      printf(1, "pipe1 oops 3 total %d\n", total);
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    28ed:	c7 44 24 04 74 3f 00 	movl   $0x3f74,0x4(%esp)
    28f4:	00 
    28f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28fc:	e8 7f 06 00 00       	call   2f80 <printf>
    2901:	e9 5e ff ff ff       	jmp    2864 <pipe1+0x104>
    2906:	8d 76 00             	lea    0x0(%esi),%esi
    2909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002910 <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    2910:	55                   	push   %ebp
    2911:	89 e5                	mov    %esp,%ebp
    2913:	57                   	push   %edi
    2914:	56                   	push   %esi
    2915:	53                   	push   %ebx
    2916:	83 ec 1c             	sub    $0x1c,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    2919:	c7 44 24 04 83 3f 00 	movl   $0x3f83,0x4(%esp)
    2920:	00 
    2921:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2928:	e8 53 06 00 00       	call   2f80 <printf>
  pid1 = fork();
    292d:	e8 0e 05 00 00       	call   2e40 <fork>
  if(pid1 == 0)
    2932:	85 c0                	test   %eax,%eax
{
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
  pid1 = fork();
    2934:	89 c7                	mov    %eax,%edi
  if(pid1 == 0)
    2936:	75 02                	jne    293a <preempt+0x2a>
    2938:	eb fe                	jmp    2938 <preempt+0x28>
    293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(;;)
      ;

  pid2 = fork();
    2940:	e8 fb 04 00 00       	call   2e40 <fork>
  if(pid2 == 0)
    2945:	85 c0                	test   %eax,%eax
  pid1 = fork();
  if(pid1 == 0)
    for(;;)
      ;

  pid2 = fork();
    2947:	89 c6                	mov    %eax,%esi
    2949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pid2 == 0)
    2950:	75 08                	jne    295a <preempt+0x4a>
    2952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2958:	eb f8                	jmp    2952 <preempt+0x42>
    for(;;)
      ;

  pipe(pfds);
    295a:	8d 45 ec             	lea    -0x14(%ebp),%eax
    295d:	89 04 24             	mov    %eax,(%esp)
    2960:	e8 f3 04 00 00       	call   2e58 <pipe>
  pid3 = fork();
    2965:	e8 d6 04 00 00       	call   2e40 <fork>
  if(pid3 == 0){
    296a:	85 c0                	test   %eax,%eax
  if(pid2 == 0)
    for(;;)
      ;

  pipe(pfds);
  pid3 = fork();
    296c:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
    296e:	75 4c                	jne    29bc <preempt+0xac>
    close(pfds[0]);
    2970:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2973:	89 04 24             	mov    %eax,(%esp)
    2976:	e8 f5 04 00 00       	call   2e70 <close>
    if(write(pfds[1], "x", 1) != 1)
    297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    297e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2985:	00 
    2986:	c7 44 24 04 0f 3a 00 	movl   $0x3a0f,0x4(%esp)
    298d:	00 
    298e:	89 04 24             	mov    %eax,(%esp)
    2991:	e8 d2 04 00 00       	call   2e68 <write>
    2996:	83 e8 01             	sub    $0x1,%eax
    2999:	74 14                	je     29af <preempt+0x9f>
      printf(1, "preempt write error");
    299b:	c7 44 24 04 8d 3f 00 	movl   $0x3f8d,0x4(%esp)
    29a2:	00 
    29a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29aa:	e8 d1 05 00 00       	call   2f80 <printf>
    close(pfds[1]);
    29af:	8b 45 f0             	mov    -0x10(%ebp),%eax
    29b2:	89 04 24             	mov    %eax,(%esp)
    29b5:	e8 b6 04 00 00       	call   2e70 <close>
    29ba:	eb fe                	jmp    29ba <preempt+0xaa>
    for(;;)
      ;
  }

  close(pfds[1]);
    29bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    29bf:	89 04 24             	mov    %eax,(%esp)
    29c2:	e8 a9 04 00 00       	call   2e70 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    29c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    29ca:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    29d1:	00 
    29d2:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
    29d9:	00 
    29da:	89 04 24             	mov    %eax,(%esp)
    29dd:	e8 7e 04 00 00       	call   2e60 <read>
    29e2:	83 e8 01             	sub    $0x1,%eax
    29e5:	74 1c                	je     2a03 <preempt+0xf3>
    printf(1, "preempt read error");
    29e7:	c7 44 24 04 a1 3f 00 	movl   $0x3fa1,0x4(%esp)
    29ee:	00 
    29ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29f6:	e8 85 05 00 00       	call   2f80 <printf>
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
    29fb:	83 c4 1c             	add    $0x1c,%esp
    29fe:	5b                   	pop    %ebx
    29ff:	5e                   	pop    %esi
    2a00:	5f                   	pop    %edi
    2a01:	5d                   	pop    %ebp
    2a02:	c3                   	ret    
  close(pfds[1]);
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    printf(1, "preempt read error");
    return;
  }
  close(pfds[0]);
    2a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2a06:	89 04 24             	mov    %eax,(%esp)
    2a09:	e8 62 04 00 00       	call   2e70 <close>
  printf(1, "kill... ");
    2a0e:	c7 44 24 04 b4 3f 00 	movl   $0x3fb4,0x4(%esp)
    2a15:	00 
    2a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a1d:	e8 5e 05 00 00       	call   2f80 <printf>
  kill(pid1);
    2a22:	89 3c 24             	mov    %edi,(%esp)
    2a25:	e8 4e 04 00 00       	call   2e78 <kill>
  kill(pid2);
    2a2a:	89 34 24             	mov    %esi,(%esp)
    2a2d:	e8 46 04 00 00       	call   2e78 <kill>
  kill(pid3);
    2a32:	89 1c 24             	mov    %ebx,(%esp)
    2a35:	e8 3e 04 00 00       	call   2e78 <kill>
  printf(1, "wait... ");
    2a3a:	c7 44 24 04 bd 3f 00 	movl   $0x3fbd,0x4(%esp)
    2a41:	00 
    2a42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a49:	e8 32 05 00 00       	call   2f80 <printf>
  wait();
    2a4e:	e8 fd 03 00 00       	call   2e50 <wait>
  wait();
    2a53:	e8 f8 03 00 00       	call   2e50 <wait>
  wait();
    2a58:	e8 f3 03 00 00       	call   2e50 <wait>
  printf(1, "preempt ok\n");
    2a5d:	c7 44 24 04 c6 3f 00 	movl   $0x3fc6,0x4(%esp)
    2a64:	00 
    2a65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a6c:	e8 0f 05 00 00       	call   2f80 <printf>
    2a71:	eb 88                	jmp    29fb <preempt+0xeb>
    2a73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002a80 <exectest>:
  printf(stdout, "mkdir test\n");
}

void
exectest(void)
{
    2a80:	55                   	push   %ebp
    2a81:	89 e5                	mov    %esp,%ebp
    2a83:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
    2a86:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2a8b:	c7 44 24 04 d2 3f 00 	movl   $0x3fd2,0x4(%esp)
    2a92:	00 
    2a93:	89 04 24             	mov    %eax,(%esp)
    2a96:	e8 e5 04 00 00       	call   2f80 <printf>
  if(exec("echo", echoargv) < 0) {
    2a9b:	c7 44 24 04 94 45 00 	movl   $0x4594,0x4(%esp)
    2aa2:	00 
    2aa3:	c7 04 24 4b 33 00 00 	movl   $0x334b,(%esp)
    2aaa:	e8 d1 03 00 00       	call   2e80 <exec>
    2aaf:	85 c0                	test   %eax,%eax
    2ab1:	78 02                	js     2ab5 <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
    2ab3:	c9                   	leave  
    2ab4:	c3                   	ret    
void
exectest(void)
{
  printf(stdout, "exec test\n");
  if(exec("echo", echoargv) < 0) {
    printf(stdout, "exec echo failed\n");
    2ab5:	a1 a8 45 00 00       	mov    0x45a8,%eax
    2aba:	c7 44 24 04 dd 3f 00 	movl   $0x3fdd,0x4(%esp)
    2ac1:	00 
    2ac2:	89 04 24             	mov    %eax,(%esp)
    2ac5:	e8 b6 04 00 00       	call   2f80 <printf>
    exit();
    2aca:	e8 79 03 00 00       	call   2e48 <exit>
    2acf:	90                   	nop    

00002ad0 <main>:
  printf(1, "fork test OK\n");
}

int
main(int argc, char *argv[])
{
    2ad0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    2ad4:	83 e4 f0             	and    $0xfffffff0,%esp
    2ad7:	ff 71 fc             	pushl  -0x4(%ecx)
    2ada:	55                   	push   %ebp
    2adb:	89 e5                	mov    %esp,%ebp
    2add:	51                   	push   %ecx
    2ade:	83 ec 14             	sub    $0x14,%esp
  printf(1, "usertests starting\n");
    2ae1:	c7 44 24 04 ef 3f 00 	movl   $0x3fef,0x4(%esp)
    2ae8:	00 
    2ae9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2af0:	e8 8b 04 00 00       	call   2f80 <printf>

  if(open("usertests.ran", 0) >= 0){
    2af5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2afc:	00 
    2afd:	c7 04 24 03 40 00 00 	movl   $0x4003,(%esp)
    2b04:	e8 7f 03 00 00       	call   2e88 <open>
    2b09:	85 c0                	test   %eax,%eax
    2b0b:	78 19                	js     2b26 <main+0x56>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    2b0d:	c7 44 24 04 50 45 00 	movl   $0x4550,0x4(%esp)
    2b14:	00 
    2b15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b1c:	e8 5f 04 00 00       	call   2f80 <printf>
    exit();
    2b21:	e8 22 03 00 00       	call   2e48 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    2b26:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2b2d:	00 
    2b2e:	c7 04 24 03 40 00 00 	movl   $0x4003,(%esp)
    2b35:	e8 4e 03 00 00       	call   2e88 <open>
    2b3a:	89 04 24             	mov    %eax,(%esp)
    2b3d:	e8 2e 03 00 00       	call   2e70 <close>

  opentest();
    2b42:	e8 b9 d4 ff ff       	call   0 <opentest>
  writetest();
    2b47:	e8 64 f9 ff ff       	call   24b0 <writetest>
    2b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  writetest1();
    2b50:	e8 6b f7 ff ff       	call   22c0 <writetest1>
    2b55:	8d 76 00             	lea    0x0(%esi),%esi
  createtest();
    2b58:	e8 c3 df ff ff       	call   b20 <createtest>
    2b5d:	8d 76 00             	lea    0x0(%esi),%esi

  mem();
    2b60:	e8 5b fb ff ff       	call   26c0 <mem>
    2b65:	8d 76 00             	lea    0x0(%esi),%esi
  pipe1();
    2b68:	e8 f3 fb ff ff       	call   2760 <pipe1>
    2b6d:	8d 76 00             	lea    0x0(%esi),%esi
  preempt();
    2b70:	e8 9b fd ff ff       	call   2910 <preempt>
    2b75:	8d 76 00             	lea    0x0(%esi),%esi
  exitwait();
    2b78:	e8 03 d6 ff ff       	call   180 <exitwait>
    2b7d:	8d 76 00             	lea    0x0(%esi),%esi

  rmdot();
    2b80:	e8 1b d9 ff ff       	call   4a0 <rmdot>
    2b85:	8d 76 00             	lea    0x0(%esi),%esi
  fourteen();
    2b88:	e8 93 d6 ff ff       	call   220 <fourteen>
    2b8d:	8d 76 00             	lea    0x0(%esi),%esi
  bigfile();
    2b90:	e8 7b e2 ff ff       	call   e10 <bigfile>
    2b95:	8d 76 00             	lea    0x0(%esi),%esi
  subdir();
    2b98:	e8 83 e4 ff ff       	call   1020 <subdir>
    2b9d:	8d 76 00             	lea    0x0(%esi),%esi
  concreate();
    2ba0:	e8 0b ec ff ff       	call   17b0 <concreate>
    2ba5:	8d 76 00             	lea    0x0(%esi),%esi
  linktest();
    2ba8:	e8 f3 ee ff ff       	call   1aa0 <linktest>
    2bad:	8d 76 00             	lea    0x0(%esi),%esi
  unlinkread();
    2bb0:	e8 4b f1 ff ff       	call   1d00 <unlinkread>
    2bb5:	8d 76 00             	lea    0x0(%esi),%esi
  createdelete();
    2bb8:	e8 d3 db ff ff       	call   790 <createdelete>
    2bbd:	8d 76 00             	lea    0x0(%esi),%esi
  twofiles();
    2bc0:	e8 1b f3 ff ff       	call   1ee0 <twofiles>
    2bc5:	8d 76 00             	lea    0x0(%esi),%esi
  sharedfd();
    2bc8:	e8 33 f5 ff ff       	call   2100 <sharedfd>
    2bcd:	8d 76 00             	lea    0x0(%esi),%esi
  dirfile();
    2bd0:	e8 fb df ff ff       	call   bd0 <dirfile>
    2bd5:	8d 76 00             	lea    0x0(%esi),%esi
  iref();
    2bd8:	e8 a3 d7 ff ff       	call   380 <iref>
    2bdd:	8d 76 00             	lea    0x0(%esi),%esi
  forktest();
    2be0:	e8 bb d4 ff ff       	call   a0 <forktest>
    2be5:	8d 76 00             	lea    0x0(%esi),%esi
  bigdir(); // slow
    2be8:	e8 53 da ff ff       	call   640 <bigdir>
    2bed:	8d 76 00             	lea    0x0(%esi),%esi

  exectest();
    2bf0:	e8 8b fe ff ff       	call   2a80 <exectest>
    2bf5:	8d 76 00             	lea    0x0(%esi),%esi

  exit();
    2bf8:	e8 4b 02 00 00       	call   2e48 <exit>
    2bfd:	90                   	nop    
    2bfe:	90                   	nop    
    2bff:	90                   	nop    

00002c00 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    2c00:	55                   	push   %ebp
    2c01:	31 d2                	xor    %edx,%edx
    2c03:	89 e5                	mov    %esp,%ebp
    2c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    2c08:	53                   	push   %ebx
    2c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
    2c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    2c10:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
    2c14:	88 04 13             	mov    %al,(%ebx,%edx,1)
    2c17:	83 c2 01             	add    $0x1,%edx
    2c1a:	84 c0                	test   %al,%al
    2c1c:	75 f2                	jne    2c10 <strcpy+0x10>
    ;
  return os;
}
    2c1e:	89 d8                	mov    %ebx,%eax
    2c20:	5b                   	pop    %ebx
    2c21:	5d                   	pop    %ebp
    2c22:	c3                   	ret    
    2c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002c30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    2c30:	55                   	push   %ebp
    2c31:	89 e5                	mov    %esp,%ebp
    2c33:	53                   	push   %ebx
    2c34:	8b 55 08             	mov    0x8(%ebp),%edx
    2c37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    2c3a:	0f b6 02             	movzbl (%edx),%eax
    2c3d:	84 c0                	test   %al,%al
    2c3f:	75 14                	jne    2c55 <strcmp+0x25>
    2c41:	eb 2d                	jmp    2c70 <strcmp+0x40>
    2c43:	90                   	nop    
    2c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
    2c48:	83 c2 01             	add    $0x1,%edx
    2c4b:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    2c4e:	0f b6 02             	movzbl (%edx),%eax
    2c51:	84 c0                	test   %al,%al
    2c53:	74 1b                	je     2c70 <strcmp+0x40>
    2c55:	0f b6 19             	movzbl (%ecx),%ebx
    2c58:	38 d8                	cmp    %bl,%al
    2c5a:	74 ec                	je     2c48 <strcmp+0x18>
    2c5c:	0f b6 d0             	movzbl %al,%edx
    2c5f:	0f b6 c3             	movzbl %bl,%eax
    2c62:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    2c64:	89 d0                	mov    %edx,%eax
    2c66:	5b                   	pop    %ebx
    2c67:	5d                   	pop    %ebp
    2c68:	c3                   	ret    
    2c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    2c70:	0f b6 19             	movzbl (%ecx),%ebx
    2c73:	31 d2                	xor    %edx,%edx
    2c75:	0f b6 c3             	movzbl %bl,%eax
    2c78:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    2c7a:	89 d0                	mov    %edx,%eax
    2c7c:	5b                   	pop    %ebx
    2c7d:	5d                   	pop    %ebp
    2c7e:	c3                   	ret    
    2c7f:	90                   	nop    

00002c80 <strlen>:

uint
strlen(char *s)
{
    2c80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
    2c81:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    2c83:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
    2c85:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    2c87:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    2c8a:	80 3a 00             	cmpb   $0x0,(%edx)
    2c8d:	74 0c                	je     2c9b <strlen+0x1b>
    2c8f:	90                   	nop    
    2c90:	83 c0 01             	add    $0x1,%eax
    2c93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    2c97:	75 f7                	jne    2c90 <strlen+0x10>
    2c99:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
    2c9b:	89 c8                	mov    %ecx,%eax
    2c9d:	5d                   	pop    %ebp
    2c9e:	c3                   	ret    
    2c9f:	90                   	nop    

00002ca0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    2ca0:	55                   	push   %ebp
    2ca1:	89 e5                	mov    %esp,%ebp
    2ca3:	83 ec 08             	sub    $0x8,%esp
    2ca6:	89 1c 24             	mov    %ebx,(%esp)
    2ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    2cac:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    2cb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
    2cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
    2cb6:	89 df                	mov    %ebx,%edi
    2cb8:	fc                   	cld    
    2cb9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    2cbb:	89 d8                	mov    %ebx,%eax
    2cbd:	8b 7c 24 04          	mov    0x4(%esp),%edi
    2cc1:	8b 1c 24             	mov    (%esp),%ebx
    2cc4:	89 ec                	mov    %ebp,%esp
    2cc6:	5d                   	pop    %ebp
    2cc7:	c3                   	ret    
    2cc8:	90                   	nop    
    2cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002cd0 <strchr>:

char*
strchr(const char *s, char c)
{
    2cd0:	55                   	push   %ebp
    2cd1:	89 e5                	mov    %esp,%ebp
    2cd3:	8b 45 08             	mov    0x8(%ebp),%eax
    2cd6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    2cda:	0f b6 10             	movzbl (%eax),%edx
    2cdd:	84 d2                	test   %dl,%dl
    2cdf:	75 11                	jne    2cf2 <strchr+0x22>
    2ce1:	eb 25                	jmp    2d08 <strchr+0x38>
    2ce3:	90                   	nop    
    2ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2ce8:	83 c0 01             	add    $0x1,%eax
    2ceb:	0f b6 10             	movzbl (%eax),%edx
    2cee:	84 d2                	test   %dl,%dl
    2cf0:	74 16                	je     2d08 <strchr+0x38>
    if(*s == c)
    2cf2:	38 ca                	cmp    %cl,%dl
    2cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2cf8:	75 ee                	jne    2ce8 <strchr+0x18>
      return (char*) s;
  return 0;
}
    2cfa:	5d                   	pop    %ebp
    2cfb:	90                   	nop    
    2cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2d00:	c3                   	ret    
    2d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    2d08:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
    2d0a:	5d                   	pop    %ebp
    2d0b:	90                   	nop    
    2d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2d10:	c3                   	ret    
    2d11:	eb 0d                	jmp    2d20 <atoi>
    2d13:	90                   	nop    
    2d14:	90                   	nop    
    2d15:	90                   	nop    
    2d16:	90                   	nop    
    2d17:	90                   	nop    
    2d18:	90                   	nop    
    2d19:	90                   	nop    
    2d1a:	90                   	nop    
    2d1b:	90                   	nop    
    2d1c:	90                   	nop    
    2d1d:	90                   	nop    
    2d1e:	90                   	nop    
    2d1f:	90                   	nop    

00002d20 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    2d20:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2d21:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
    2d23:	89 e5                	mov    %esp,%ebp
    2d25:	53                   	push   %ebx
    2d26:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2d29:	0f b6 13             	movzbl (%ebx),%edx
    2d2c:	8d 42 d0             	lea    -0x30(%edx),%eax
    2d2f:	3c 09                	cmp    $0x9,%al
    2d31:	77 1c                	ja     2d4f <atoi+0x2f>
    2d33:	90                   	nop    
    2d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
    2d38:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    2d3b:	0f be d2             	movsbl %dl,%edx
    2d3e:	83 c3 01             	add    $0x1,%ebx
    2d41:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2d45:	0f b6 13             	movzbl (%ebx),%edx
    2d48:	8d 42 d0             	lea    -0x30(%edx),%eax
    2d4b:	3c 09                	cmp    $0x9,%al
    2d4d:	76 e9                	jbe    2d38 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    2d4f:	89 c8                	mov    %ecx,%eax
    2d51:	5b                   	pop    %ebx
    2d52:	5d                   	pop    %ebp
    2d53:	c3                   	ret    
    2d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00002d60 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    2d60:	55                   	push   %ebp
    2d61:	89 e5                	mov    %esp,%ebp
    2d63:	8b 4d 10             	mov    0x10(%ebp),%ecx
    2d66:	56                   	push   %esi
    2d67:	8b 75 08             	mov    0x8(%ebp),%esi
    2d6a:	53                   	push   %ebx
    2d6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2d6e:	85 c9                	test   %ecx,%ecx
    2d70:	7e 14                	jle    2d86 <memmove+0x26>
    2d72:	31 d2                	xor    %edx,%edx
    2d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    2d78:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
    2d7c:	88 04 16             	mov    %al,(%esi,%edx,1)
    2d7f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2d82:	39 ca                	cmp    %ecx,%edx
    2d84:	75 f2                	jne    2d78 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    2d86:	89 f0                	mov    %esi,%eax
    2d88:	5b                   	pop    %ebx
    2d89:	5e                   	pop    %esi
    2d8a:	5d                   	pop    %ebp
    2d8b:	c3                   	ret    
    2d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00002d90 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    2d90:	55                   	push   %ebp
    2d91:	89 e5                	mov    %esp,%ebp
    2d93:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2d96:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    2d99:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    2d9c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    2d9f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2da4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2dab:	00 
    2dac:	89 04 24             	mov    %eax,(%esp)
    2daf:	e8 d4 00 00 00       	call   2e88 <open>
  if(fd < 0)
    2db4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2db6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    2db8:	78 19                	js     2dd3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    2dba:	8b 45 0c             	mov    0xc(%ebp),%eax
    2dbd:	89 1c 24             	mov    %ebx,(%esp)
    2dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
    2dc4:	e8 d7 00 00 00       	call   2ea0 <fstat>
  close(fd);
    2dc9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    2dcc:	89 c6                	mov    %eax,%esi
  close(fd);
    2dce:	e8 9d 00 00 00       	call   2e70 <close>
  return r;
}
    2dd3:	89 f0                	mov    %esi,%eax
    2dd5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    2dd8:	8b 75 fc             	mov    -0x4(%ebp),%esi
    2ddb:	89 ec                	mov    %ebp,%esp
    2ddd:	5d                   	pop    %ebp
    2dde:	c3                   	ret    
    2ddf:	90                   	nop    

00002de0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    2de0:	55                   	push   %ebp
    2de1:	89 e5                	mov    %esp,%ebp
    2de3:	57                   	push   %edi
    2de4:	56                   	push   %esi
    2de5:	31 f6                	xor    %esi,%esi
    2de7:	53                   	push   %ebx
    2de8:	83 ec 1c             	sub    $0x1c,%esp
    2deb:	8b 7d 08             	mov    0x8(%ebp),%edi
    2dee:	eb 06                	jmp    2df6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    2df0:	3c 0d                	cmp    $0xd,%al
    2df2:	74 39                	je     2e2d <gets+0x4d>
    2df4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2df6:	8d 5e 01             	lea    0x1(%esi),%ebx
    2df9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    2dfc:	7d 31                	jge    2e2f <gets+0x4f>
    cc = read(0, &c, 1);
    2dfe:	8d 45 f3             	lea    -0xd(%ebp),%eax
    2e01:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2e08:	00 
    2e09:	89 44 24 04          	mov    %eax,0x4(%esp)
    2e0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e14:	e8 47 00 00 00       	call   2e60 <read>
    if(cc < 1)
    2e19:	85 c0                	test   %eax,%eax
    2e1b:	7e 12                	jle    2e2f <gets+0x4f>
      break;
    buf[i++] = c;
    2e1d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    2e21:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    2e25:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    2e29:	3c 0a                	cmp    $0xa,%al
    2e2b:	75 c3                	jne    2df0 <gets+0x10>
    2e2d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    2e2f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    2e33:	89 f8                	mov    %edi,%eax
    2e35:	83 c4 1c             	add    $0x1c,%esp
    2e38:	5b                   	pop    %ebx
    2e39:	5e                   	pop    %esi
    2e3a:	5f                   	pop    %edi
    2e3b:	5d                   	pop    %ebp
    2e3c:	c3                   	ret    
    2e3d:	90                   	nop    
    2e3e:	90                   	nop    
    2e3f:	90                   	nop    

00002e40 <fork>:
    2e40:	b8 01 00 00 00       	mov    $0x1,%eax
    2e45:	cd 40                	int    $0x40
    2e47:	c3                   	ret    

00002e48 <exit>:
    2e48:	b8 02 00 00 00       	mov    $0x2,%eax
    2e4d:	cd 40                	int    $0x40
    2e4f:	c3                   	ret    

00002e50 <wait>:
    2e50:	b8 03 00 00 00       	mov    $0x3,%eax
    2e55:	cd 40                	int    $0x40
    2e57:	c3                   	ret    

00002e58 <pipe>:
    2e58:	b8 04 00 00 00       	mov    $0x4,%eax
    2e5d:	cd 40                	int    $0x40
    2e5f:	c3                   	ret    

00002e60 <read>:
    2e60:	b8 06 00 00 00       	mov    $0x6,%eax
    2e65:	cd 40                	int    $0x40
    2e67:	c3                   	ret    

00002e68 <write>:
    2e68:	b8 05 00 00 00       	mov    $0x5,%eax
    2e6d:	cd 40                	int    $0x40
    2e6f:	c3                   	ret    

00002e70 <close>:
    2e70:	b8 07 00 00 00       	mov    $0x7,%eax
    2e75:	cd 40                	int    $0x40
    2e77:	c3                   	ret    

00002e78 <kill>:
    2e78:	b8 08 00 00 00       	mov    $0x8,%eax
    2e7d:	cd 40                	int    $0x40
    2e7f:	c3                   	ret    

00002e80 <exec>:
    2e80:	b8 09 00 00 00       	mov    $0x9,%eax
    2e85:	cd 40                	int    $0x40
    2e87:	c3                   	ret    

00002e88 <open>:
    2e88:	b8 0a 00 00 00       	mov    $0xa,%eax
    2e8d:	cd 40                	int    $0x40
    2e8f:	c3                   	ret    

00002e90 <mknod>:
    2e90:	b8 0b 00 00 00       	mov    $0xb,%eax
    2e95:	cd 40                	int    $0x40
    2e97:	c3                   	ret    

00002e98 <unlink>:
    2e98:	b8 0c 00 00 00       	mov    $0xc,%eax
    2e9d:	cd 40                	int    $0x40
    2e9f:	c3                   	ret    

00002ea0 <fstat>:
    2ea0:	b8 0d 00 00 00       	mov    $0xd,%eax
    2ea5:	cd 40                	int    $0x40
    2ea7:	c3                   	ret    

00002ea8 <link>:
    2ea8:	b8 0e 00 00 00       	mov    $0xe,%eax
    2ead:	cd 40                	int    $0x40
    2eaf:	c3                   	ret    

00002eb0 <mkdir>:
    2eb0:	b8 0f 00 00 00       	mov    $0xf,%eax
    2eb5:	cd 40                	int    $0x40
    2eb7:	c3                   	ret    

00002eb8 <chdir>:
    2eb8:	b8 10 00 00 00       	mov    $0x10,%eax
    2ebd:	cd 40                	int    $0x40
    2ebf:	c3                   	ret    

00002ec0 <dup>:
    2ec0:	b8 11 00 00 00       	mov    $0x11,%eax
    2ec5:	cd 40                	int    $0x40
    2ec7:	c3                   	ret    

00002ec8 <getpid>:
    2ec8:	b8 12 00 00 00       	mov    $0x12,%eax
    2ecd:	cd 40                	int    $0x40
    2ecf:	c3                   	ret    

00002ed0 <sbrk>:
    2ed0:	b8 13 00 00 00       	mov    $0x13,%eax
    2ed5:	cd 40                	int    $0x40
    2ed7:	c3                   	ret    

00002ed8 <sleep>:
    2ed8:	b8 14 00 00 00       	mov    $0x14,%eax
    2edd:	cd 40                	int    $0x40
    2edf:	c3                   	ret    

00002ee0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    2ee0:	55                   	push   %ebp
    2ee1:	89 e5                	mov    %esp,%ebp
    2ee3:	57                   	push   %edi
    2ee4:	56                   	push   %esi
    2ee5:	89 ce                	mov    %ecx,%esi
    2ee7:	53                   	push   %ebx
    2ee8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    2eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    2eee:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    2ef1:	85 c9                	test   %ecx,%ecx
    2ef3:	74 04                	je     2ef9 <printint+0x19>
    2ef5:	85 d2                	test   %edx,%edx
    2ef7:	78 77                	js     2f70 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    2ef9:	89 d0                	mov    %edx,%eax
    2efb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    2f02:	31 db                	xor    %ebx,%ebx
    2f04:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    2f07:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    2f08:	31 d2                	xor    %edx,%edx
    2f0a:	f7 f6                	div    %esi
    2f0c:	89 c1                	mov    %eax,%ecx
    2f0e:	0f b6 82 83 45 00 00 	movzbl 0x4583(%edx),%eax
    2f15:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    2f18:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
    2f1b:	85 c9                	test   %ecx,%ecx
    2f1d:	89 c8                	mov    %ecx,%eax
    2f1f:	75 e7                	jne    2f08 <printint+0x28>
  if(neg)
    2f21:	8b 45 d0             	mov    -0x30(%ebp),%eax
    2f24:	85 c0                	test   %eax,%eax
    2f26:	74 08                	je     2f30 <printint+0x50>
    buf[i++] = '-';
    2f28:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
    2f2d:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
    2f30:	8d 73 ff             	lea    -0x1(%ebx),%esi
    2f33:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
    2f36:	8d 7d f3             	lea    -0xd(%ebp),%edi
    2f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
    2f40:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    2f43:	83 ee 01             	sub    $0x1,%esi
    2f46:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2f49:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2f50:	00 
    2f51:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
    2f55:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2f58:	8b 45 cc             	mov    -0x34(%ebp),%eax
    2f5b:	89 04 24             	mov    %eax,(%esp)
    2f5e:	e8 05 ff ff ff       	call   2e68 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    2f63:	83 fe ff             	cmp    $0xffffffff,%esi
    2f66:	75 d8                	jne    2f40 <printint+0x60>
    putc(fd, buf[i]);
}
    2f68:	83 c4 3c             	add    $0x3c,%esp
    2f6b:	5b                   	pop    %ebx
    2f6c:	5e                   	pop    %esi
    2f6d:	5f                   	pop    %edi
    2f6e:	5d                   	pop    %ebp
    2f6f:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    2f70:	89 d0                	mov    %edx,%eax
    2f72:	f7 d8                	neg    %eax
    2f74:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    2f7b:	eb 85                	jmp    2f02 <printint+0x22>
    2f7d:	8d 76 00             	lea    0x0(%esi),%esi

00002f80 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2f80:	55                   	push   %ebp
    2f81:	89 e5                	mov    %esp,%ebp
    2f83:	57                   	push   %edi
    2f84:	56                   	push   %esi
    2f85:	53                   	push   %ebx
    2f86:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2f89:	8b 55 0c             	mov    0xc(%ebp),%edx
    2f8c:	0f b6 02             	movzbl (%edx),%eax
    2f8f:	84 c0                	test   %al,%al
    2f91:	0f 84 e9 00 00 00    	je     3080 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    2f97:	8d 4d 10             	lea    0x10(%ebp),%ecx
    2f9a:	31 ff                	xor    %edi,%edi
    2f9c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    2f9f:	31 f6                	xor    %esi,%esi
    2fa1:	eb 21                	jmp    2fc4 <printf+0x44>
    2fa3:	90                   	nop    
    2fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    2fa8:	83 fb 25             	cmp    $0x25,%ebx
    2fab:	0f 85 d7 00 00 00    	jne    3088 <printf+0x108>
    2fb1:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2fb5:	83 c7 01             	add    $0x1,%edi
    2fb8:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
    2fbc:	84 c0                	test   %al,%al
    2fbe:	0f 84 bc 00 00 00    	je     3080 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
    2fc4:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    2fc6:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
    2fc9:	74 dd                	je     2fa8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    2fcb:	83 fe 25             	cmp    $0x25,%esi
    2fce:	75 e5                	jne    2fb5 <printf+0x35>
      if(c == 'd'){
    2fd0:	83 fb 64             	cmp    $0x64,%ebx
    2fd3:	90                   	nop    
    2fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2fd8:	0f 84 52 01 00 00    	je     3130 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    2fde:	83 fb 78             	cmp    $0x78,%ebx
    2fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2fe8:	0f 84 c2 00 00 00    	je     30b0 <printf+0x130>
    2fee:	83 fb 70             	cmp    $0x70,%ebx
    2ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2ff8:	0f 84 b2 00 00 00    	je     30b0 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    2ffe:	83 fb 73             	cmp    $0x73,%ebx
    3001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3008:	0f 84 ca 00 00 00    	je     30d8 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    300e:	83 fb 63             	cmp    $0x63,%ebx
    3011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3018:	0f 84 62 01 00 00    	je     3180 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    301e:	83 fb 25             	cmp    $0x25,%ebx
    3021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3028:	0f 84 2a 01 00 00    	je     3158 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    302e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3031:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3034:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3037:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    303b:	31 f6                	xor    %esi,%esi
    303d:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3041:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3048:	00 
    3049:	89 0c 24             	mov    %ecx,(%esp)
    304c:	e8 17 fe ff ff       	call   2e68 <write>
    3051:	8b 55 08             	mov    0x8(%ebp),%edx
    3054:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    3057:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    305a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3061:	00 
    3062:	89 44 24 04          	mov    %eax,0x4(%esp)
    3066:	89 14 24             	mov    %edx,(%esp)
    3069:	e8 fa fd ff ff       	call   2e68 <write>
    306e:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3071:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
    3075:	84 c0                	test   %al,%al
    3077:	0f 85 47 ff ff ff    	jne    2fc4 <printf+0x44>
    307d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    3080:	83 c4 2c             	add    $0x2c,%esp
    3083:	5b                   	pop    %ebx
    3084:	5e                   	pop    %esi
    3085:	5f                   	pop    %edi
    3086:	5d                   	pop    %ebp
    3087:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3088:	8b 55 08             	mov    0x8(%ebp),%edx
    308b:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    308e:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3091:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3098:	00 
    3099:	89 44 24 04          	mov    %eax,0x4(%esp)
    309d:	89 14 24             	mov    %edx,(%esp)
    30a0:	e8 c3 fd ff ff       	call   2e68 <write>
    30a5:	8b 55 0c             	mov    0xc(%ebp),%edx
    30a8:	e9 08 ff ff ff       	jmp    2fb5 <printf+0x35>
    30ad:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    30b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    30b3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    30b8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    30ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30c1:	8b 10                	mov    (%eax),%edx
    30c3:	8b 45 08             	mov    0x8(%ebp),%eax
    30c6:	e8 15 fe ff ff       	call   2ee0 <printint>
    30cb:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
    30ce:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
    30d2:	e9 de fe ff ff       	jmp    2fb5 <printf+0x35>
    30d7:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
    30d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    30db:	8b 19                	mov    (%ecx),%ebx
        ap++;
    30dd:	83 c1 04             	add    $0x4,%ecx
    30e0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
    30e3:	85 db                	test   %ebx,%ebx
    30e5:	0f 84 c5 00 00 00    	je     31b0 <printf+0x230>
          s = "(null)";
        while(*s != 0){
    30eb:	0f b6 03             	movzbl (%ebx),%eax
    30ee:	84 c0                	test   %al,%al
    30f0:	74 30                	je     3122 <printf+0x1a2>
    30f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    30f8:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    30fb:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
    30fe:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3101:	8d 45 f3             	lea    -0xd(%ebp),%eax
    3104:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    310b:	00 
    310c:	89 44 24 04          	mov    %eax,0x4(%esp)
    3110:	89 14 24             	mov    %edx,(%esp)
    3113:	e8 50 fd ff ff       	call   2e68 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3118:	0f b6 03             	movzbl (%ebx),%eax
    311b:	84 c0                	test   %al,%al
    311d:	75 d9                	jne    30f8 <printf+0x178>
    311f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3122:	31 f6                	xor    %esi,%esi
    3124:	e9 8c fe ff ff       	jmp    2fb5 <printf+0x35>
    3129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    3130:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3133:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    3138:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    313b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3142:	8b 10                	mov    (%eax),%edx
    3144:	8b 45 08             	mov    0x8(%ebp),%eax
    3147:	e8 94 fd ff ff       	call   2ee0 <printint>
    314c:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
    314f:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
    3153:	e9 5d fe ff ff       	jmp    2fb5 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3158:	8b 45 08             	mov    0x8(%ebp),%eax
    315b:	8d 4d f3             	lea    -0xd(%ebp),%ecx
    315e:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
    3160:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3164:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    316b:	00 
    316c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    3170:	89 04 24             	mov    %eax,(%esp)
    3173:	e8 f0 fc ff ff       	call   2e68 <write>
    3178:	8b 55 0c             	mov    0xc(%ebp),%edx
    317b:	e9 35 fe ff ff       	jmp    2fb5 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    3180:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
    3183:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3185:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    3188:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    318a:	89 14 24             	mov    %edx,(%esp)
    318d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3194:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    3195:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3198:	8d 45 f3             	lea    -0xd(%ebp),%eax
    319b:	89 44 24 04          	mov    %eax,0x4(%esp)
    319f:	e8 c4 fc ff ff       	call   2e68 <write>
    31a4:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    31a7:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
    31ab:	e9 05 fe ff ff       	jmp    2fb5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
    31b0:	bb 7c 45 00 00       	mov    $0x457c,%ebx
    31b5:	e9 31 ff ff ff       	jmp    30eb <printf+0x16b>
    31ba:	90                   	nop    
    31bb:	90                   	nop    
    31bc:	90                   	nop    
    31bd:	90                   	nop    
    31be:	90                   	nop    
    31bf:	90                   	nop    

000031c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    31c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    31c1:	8b 0d c8 45 00 00    	mov    0x45c8,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
    31c7:	89 e5                	mov    %esp,%ebp
    31c9:	57                   	push   %edi
    31ca:	56                   	push   %esi
    31cb:	53                   	push   %ebx
    31cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
    31cf:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    31d2:	39 d9                	cmp    %ebx,%ecx
    31d4:	73 24                	jae    31fa <free+0x3a>
    31d6:	66 90                	xchg   %ax,%ax
    31d8:	8b 11                	mov    (%ecx),%edx
    31da:	39 d3                	cmp    %edx,%ebx
    31dc:	72 2a                	jb     3208 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    31de:	39 d1                	cmp    %edx,%ecx
    31e0:	72 10                	jb     31f2 <free+0x32>
    31e2:	39 d9                	cmp    %ebx,%ecx
    31e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    31e8:	72 1e                	jb     3208 <free+0x48>
    31ea:	39 d3                	cmp    %edx,%ebx
    31ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    31f0:	72 16                	jb     3208 <free+0x48>
    31f2:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    31f4:	39 d9                	cmp    %ebx,%ecx
    31f6:	66 90                	xchg   %ax,%ax
    31f8:	72 de                	jb     31d8 <free+0x18>
    31fa:	8b 11                	mov    (%ecx),%edx
    31fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3200:	eb dc                	jmp    31de <free+0x1e>
    3202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    3208:	8b 73 04             	mov    0x4(%ebx),%esi
    320b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
    320e:	39 d0                	cmp    %edx,%eax
    3210:	74 1a                	je     322c <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3212:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
    3215:	8b 51 04             	mov    0x4(%ecx),%edx
    3218:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
    321b:	39 d8                	cmp    %ebx,%eax
    321d:	74 22                	je     3241 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    321f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
    3221:	89 0d c8 45 00 00    	mov    %ecx,0x45c8
}
    3227:	5b                   	pop    %ebx
    3228:	5e                   	pop    %esi
    3229:	5f                   	pop    %edi
    322a:	5d                   	pop    %ebp
    322b:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    322c:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
    322f:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    3231:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    3234:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    3237:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    323a:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
    323d:	39 d8                	cmp    %ebx,%eax
    323f:	75 de                	jne    321f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    3241:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    3244:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
    3247:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    3249:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    324c:	89 0d c8 45 00 00    	mov    %ecx,0x45c8
}
    3252:	5b                   	pop    %ebx
    3253:	5e                   	pop    %esi
    3254:	5f                   	pop    %edi
    3255:	5d                   	pop    %ebp
    3256:	c3                   	ret    
    3257:	89 f6                	mov    %esi,%esi
    3259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003260 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3260:	55                   	push   %ebp
    3261:	89 e5                	mov    %esp,%ebp
    3263:	57                   	push   %edi
    3264:	56                   	push   %esi
    3265:	53                   	push   %ebx
    3266:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3269:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    326c:	8b 15 c8 45 00 00    	mov    0x45c8,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3272:	83 c0 07             	add    $0x7,%eax
    3275:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
    3278:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    327a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
    327d:	0f 84 95 00 00 00    	je     3318 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3283:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
    3285:	8b 41 04             	mov    0x4(%ecx),%eax
    3288:	39 c3                	cmp    %eax,%ebx
    328a:	76 1f                	jbe    32ab <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
    328c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    3293:	90                   	nop    
    3294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
    3298:	3b 0d c8 45 00 00    	cmp    0x45c8,%ecx
    329e:	89 ca                	mov    %ecx,%edx
    32a0:	74 34                	je     32d6 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    32a2:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
    32a4:	8b 41 04             	mov    0x4(%ecx),%eax
    32a7:	39 c3                	cmp    %eax,%ebx
    32a9:	77 ed                	ja     3298 <malloc+0x38>
      if(p->s.size == nunits)
    32ab:	39 c3                	cmp    %eax,%ebx
    32ad:	74 21                	je     32d0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    32af:	29 d8                	sub    %ebx,%eax
    32b1:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
    32b4:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
    32b7:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
    32ba:	89 15 c8 45 00 00    	mov    %edx,0x45c8
      return (void*) (p + 1);
    32c0:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    32c3:	83 c4 0c             	add    $0xc,%esp
    32c6:	5b                   	pop    %ebx
    32c7:	5e                   	pop    %esi
    32c8:	5f                   	pop    %edi
    32c9:	5d                   	pop    %ebp
    32ca:	c3                   	ret    
    32cb:	90                   	nop    
    32cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    32d0:	8b 01                	mov    (%ecx),%eax
    32d2:	89 02                	mov    %eax,(%edx)
    32d4:	eb e4                	jmp    32ba <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
    32d6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
    32dc:	bf 00 10 00 00       	mov    $0x1000,%edi
    32e1:	b8 00 80 00 00       	mov    $0x8000,%eax
    32e6:	76 04                	jbe    32ec <malloc+0x8c>
    32e8:	89 df                	mov    %ebx,%edi
    32ea:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
    32ec:	89 04 24             	mov    %eax,(%esp)
    32ef:	e8 dc fb ff ff       	call   2ed0 <sbrk>
  if(p == (char*) -1)
    32f4:	83 f8 ff             	cmp    $0xffffffff,%eax
    32f7:	74 18                	je     3311 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    32f9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    32fc:	83 c0 08             	add    $0x8,%eax
    32ff:	89 04 24             	mov    %eax,(%esp)
    3302:	e8 b9 fe ff ff       	call   31c0 <free>
  return freep;
    3307:	8b 15 c8 45 00 00    	mov    0x45c8,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    330d:	85 d2                	test   %edx,%edx
    330f:	75 91                	jne    32a2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    3311:	31 c0                	xor    %eax,%eax
    3313:	eb ae                	jmp    32c3 <malloc+0x63>
    3315:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    3318:	c7 05 c8 45 00 00 c0 	movl   $0x45c0,0x45c8
    331f:	45 00 00 
    base.s.size = 0;
    3322:	ba c0 45 00 00       	mov    $0x45c0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    3327:	c7 05 c0 45 00 00 c0 	movl   $0x45c0,0x45c0
    332e:	45 00 00 
    base.s.size = 0;
    3331:	c7 05 c4 45 00 00 00 	movl   $0x0,0x45c4
    3338:	00 00 00 
    333b:	e9 43 ff ff ff       	jmp    3283 <malloc+0x23>
