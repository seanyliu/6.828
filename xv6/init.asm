
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  12:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  19:	00 
  1a:	c7 04 24 60 08 00 00 	movl   $0x860,(%esp)
  21:	e8 82 03 00 00       	call   3a8 <open>
  26:	85 c0                	test   %eax,%eax
  28:	0f 88 b0 00 00 00    	js     de <main+0xde>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  35:	e8 a6 03 00 00       	call   3e0 <dup>
  dup(0);  // stderr
  3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  41:	e8 9a 03 00 00       	call   3e0 <dup>
  46:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  48:	c7 44 24 04 68 08 00 	movl   $0x868,0x4(%esp)
  4f:	00 
  50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  57:	e8 44 04 00 00       	call   4a0 <printf>
    pid = fork();
  5c:	e8 ff 02 00 00       	call   360 <fork>
    if(pid < 0){
  61:	83 f8 00             	cmp    $0x0,%eax
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  64:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  66:	7c 30                	jl     98 <main+0x98>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  68:	74 47                	je     b1 <main+0xb1>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  70:	e8 fb 02 00 00       	call   370 <wait>
  75:	85 c0                	test   %eax,%eax
  77:	90                   	nop    
  78:	78 ce                	js     48 <main+0x48>
  7a:	39 c3                	cmp    %eax,%ebx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	74 c6                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  82:	c7 44 24 04 a7 08 00 	movl   $0x8a7,0x4(%esp)
  89:	00 
  8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  91:	e8 0a 04 00 00       	call   4a0 <printf>
  96:	eb d2                	jmp    6a <main+0x6a>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  98:	c7 44 24 04 7b 08 00 	movl   $0x87b,0x4(%esp)
  9f:	00 
  a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a7:	e8 f4 03 00 00       	call   4a0 <printf>
      exit();
  ac:	e8 b7 02 00 00       	call   368 <exit>
    }
    if(pid == 0){
      exec("sh", argv);
  b1:	c7 44 24 04 c8 08 00 	movl   $0x8c8,0x4(%esp)
  b8:	00 
  b9:	c7 04 24 8e 08 00 00 	movl   $0x88e,(%esp)
  c0:	e8 db 02 00 00       	call   3a0 <exec>
      printf(1, "init: exec sh failed\n");
  c5:	c7 44 24 04 91 08 00 	movl   $0x891,0x4(%esp)
  cc:	00 
  cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d4:	e8 c7 03 00 00       	call   4a0 <printf>
      exit();
  d9:	e8 8a 02 00 00       	call   368 <exit>
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  e5:	00 
  e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  ed:	00 
  ee:	c7 04 24 60 08 00 00 	movl   $0x860,(%esp)
  f5:	e8 b6 02 00 00       	call   3b0 <mknod>
    open("console", O_RDWR);
  fa:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 101:	00 
 102:	c7 04 24 60 08 00 00 	movl   $0x860,(%esp)
 109:	e8 9a 02 00 00       	call   3a8 <open>
 10e:	e9 1b ff ff ff       	jmp    2e <main+0x2e>
 113:	90                   	nop    
 114:	90                   	nop    
 115:	90                   	nop    
 116:	90                   	nop    
 117:	90                   	nop    
 118:	90                   	nop    
 119:	90                   	nop    
 11a:	90                   	nop    
 11b:	90                   	nop    
 11c:	90                   	nop    
 11d:	90                   	nop    
 11e:	90                   	nop    
 11f:	90                   	nop    

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 120:	55                   	push   %ebp
 121:	31 d2                	xor    %edx,%edx
 123:	89 e5                	mov    %esp,%ebp
 125:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 128:	53                   	push   %ebx
 129:	8b 5d 08             	mov    0x8(%ebp),%ebx
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 130:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
 134:	88 04 13             	mov    %al,(%ebx,%edx,1)
 137:	83 c2 01             	add    $0x1,%edx
 13a:	84 c0                	test   %al,%al
 13c:	75 f2                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 13e:	89 d8                	mov    %ebx,%eax
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	8b 55 08             	mov    0x8(%ebp),%edx
 157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 15a:	0f b6 02             	movzbl (%edx),%eax
 15d:	84 c0                	test   %al,%al
 15f:	75 14                	jne    175 <strcmp+0x25>
 161:	eb 2d                	jmp    190 <strcmp+0x40>
 163:	90                   	nop    
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 168:	83 c2 01             	add    $0x1,%edx
 16b:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16e:	0f b6 02             	movzbl (%edx),%eax
 171:	84 c0                	test   %al,%al
 173:	74 1b                	je     190 <strcmp+0x40>
 175:	0f b6 19             	movzbl (%ecx),%ebx
 178:	38 d8                	cmp    %bl,%al
 17a:	74 ec                	je     168 <strcmp+0x18>
 17c:	0f b6 d0             	movzbl %al,%edx
 17f:	0f b6 c3             	movzbl %bl,%eax
 182:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 184:	89 d0                	mov    %edx,%eax
 186:	5b                   	pop    %ebx
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 190:	0f b6 19             	movzbl (%ecx),%ebx
 193:	31 d2                	xor    %edx,%edx
 195:	0f b6 c3             	movzbl %bl,%eax
 198:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 19a:	89 d0                	mov    %edx,%eax
 19c:	5b                   	pop    %ebx
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    
 19f:	90                   	nop    

000001a0 <strlen>:

uint
strlen(char *s)
{
 1a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1a1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1a5:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1aa:	80 3a 00             	cmpb   $0x0,(%edx)
 1ad:	74 0c                	je     1bb <strlen+0x1b>
 1af:	90                   	nop    
 1b0:	83 c0 01             	add    $0x1,%eax
 1b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1b7:	75 f7                	jne    1b0 <strlen+0x10>
 1b9:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 1bb:	89 c8                	mov    %ecx,%eax
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    
 1bf:	90                   	nop    

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 08             	sub    $0x8,%esp
 1c6:	89 1c 24             	mov    %ebx,(%esp)
 1c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d6:	89 df                	mov    %ebx,%edi
 1d8:	fc                   	cld    
 1d9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1db:	89 d8                	mov    %ebx,%eax
 1dd:	8b 7c 24 04          	mov    0x4(%esp),%edi
 1e1:	8b 1c 24             	mov    (%esp),%ebx
 1e4:	89 ec                	mov    %ebp,%esp
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    
 1e8:	90                   	nop    
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	75 11                	jne    212 <strchr+0x22>
 201:	eb 25                	jmp    228 <strchr+0x38>
 203:	90                   	nop    
 204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	84 d2                	test   %dl,%dl
 210:	74 16                	je     228 <strchr+0x38>
    if(*s == c)
 212:	38 ca                	cmp    %cl,%dl
 214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 218:	75 ee                	jne    208 <strchr+0x18>
      return (char*) s;
  return 0;
}
 21a:	5d                   	pop    %ebp
 21b:	90                   	nop    
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	c3                   	ret    
 221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 228:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 22a:	5d                   	pop    %ebp
 22b:	90                   	nop    
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 230:	c3                   	ret    
 231:	eb 0d                	jmp    240 <atoi>
 233:	90                   	nop    
 234:	90                   	nop    
 235:	90                   	nop    
 236:	90                   	nop    
 237:	90                   	nop    
 238:	90                   	nop    
 239:	90                   	nop    
 23a:	90                   	nop    
 23b:	90                   	nop    
 23c:	90                   	nop    
 23d:	90                   	nop    
 23e:	90                   	nop    
 23f:	90                   	nop    

00000240 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 241:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 243:	89 e5                	mov    %esp,%ebp
 245:	53                   	push   %ebx
 246:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 249:	0f b6 13             	movzbl (%ebx),%edx
 24c:	8d 42 d0             	lea    -0x30(%edx),%eax
 24f:	3c 09                	cmp    $0x9,%al
 251:	77 1c                	ja     26f <atoi+0x2f>
 253:	90                   	nop    
 254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 258:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 25b:	0f be d2             	movsbl %dl,%edx
 25e:	83 c3 01             	add    $0x1,%ebx
 261:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 265:	0f b6 13             	movzbl (%ebx),%edx
 268:	8d 42 d0             	lea    -0x30(%edx),%eax
 26b:	3c 09                	cmp    $0x9,%al
 26d:	76 e9                	jbe    258 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 26f:	89 c8                	mov    %ecx,%eax
 271:	5b                   	pop    %ebx
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    
 274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 27a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000280 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 4d 10             	mov    0x10(%ebp),%ecx
 286:	56                   	push   %esi
 287:	8b 75 08             	mov    0x8(%ebp),%esi
 28a:	53                   	push   %ebx
 28b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 c9                	test   %ecx,%ecx
 290:	7e 14                	jle    2a6 <memmove+0x26>
 292:	31 d2                	xor    %edx,%edx
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 298:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 29c:	88 04 16             	mov    %al,(%esi,%edx,1)
 29f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a2:	39 ca                	cmp    %ecx,%edx
 2a4:	75 f2                	jne    298 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2a6:	89 f0                	mov    %esi,%eax
 2a8:	5b                   	pop    %ebx
 2a9:	5e                   	pop    %esi
 2aa:	5d                   	pop    %ebp
 2ab:	c3                   	ret    
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002b0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2b9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2cb:	00 
 2cc:	89 04 24             	mov    %eax,(%esp)
 2cf:	e8 d4 00 00 00       	call   3a8 <open>
  if(fd < 0)
 2d4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2d8:	78 19                	js     2f3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2da:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dd:	89 1c 24             	mov    %ebx,(%esp)
 2e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e4:	e8 d7 00 00 00       	call   3c0 <fstat>
  close(fd);
 2e9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2ec:	89 c6                	mov    %eax,%esi
  close(fd);
 2ee:	e8 9d 00 00 00       	call   390 <close>
  return r;
}
 2f3:	89 f0                	mov    %esi,%eax
 2f5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2fb:	89 ec                	mov    %ebp,%esp
 2fd:	5d                   	pop    %ebp
 2fe:	c3                   	ret    
 2ff:	90                   	nop    

00000300 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
 305:	31 f6                	xor    %esi,%esi
 307:	53                   	push   %ebx
 308:	83 ec 1c             	sub    $0x1c,%esp
 30b:	8b 7d 08             	mov    0x8(%ebp),%edi
 30e:	eb 06                	jmp    316 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 310:	3c 0d                	cmp    $0xd,%al
 312:	74 39                	je     34d <gets+0x4d>
 314:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 316:	8d 5e 01             	lea    0x1(%esi),%ebx
 319:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 31c:	7d 31                	jge    34f <gets+0x4f>
    cc = read(0, &c, 1);
 31e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 321:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 328:	00 
 329:	89 44 24 04          	mov    %eax,0x4(%esp)
 32d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 334:	e8 47 00 00 00       	call   380 <read>
    if(cc < 1)
 339:	85 c0                	test   %eax,%eax
 33b:	7e 12                	jle    34f <gets+0x4f>
      break;
    buf[i++] = c;
 33d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 341:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 345:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 349:	3c 0a                	cmp    $0xa,%al
 34b:	75 c3                	jne    310 <gets+0x10>
 34d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 34f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 353:	89 f8                	mov    %edi,%eax
 355:	83 c4 1c             	add    $0x1c,%esp
 358:	5b                   	pop    %ebx
 359:	5e                   	pop    %esi
 35a:	5f                   	pop    %edi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	90                   	nop    
 35e:	90                   	nop    
 35f:	90                   	nop    

00000360 <fork>:
 360:	b8 01 00 00 00       	mov    $0x1,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <exit>:
 368:	b8 02 00 00 00       	mov    $0x2,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <wait>:
 370:	b8 03 00 00 00       	mov    $0x3,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <pipe>:
 378:	b8 04 00 00 00       	mov    $0x4,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <read>:
 380:	b8 06 00 00 00       	mov    $0x6,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <write>:
 388:	b8 05 00 00 00       	mov    $0x5,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <close>:
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <kill>:
 398:	b8 08 00 00 00       	mov    $0x8,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <exec>:
 3a0:	b8 09 00 00 00       	mov    $0x9,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <open>:
 3a8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <mknod>:
 3b0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <unlink>:
 3b8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <fstat>:
 3c0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <link>:
 3c8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mkdir>:
 3d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <chdir>:
 3d8:	b8 10 00 00 00       	mov    $0x10,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <dup>:
 3e0:	b8 11 00 00 00       	mov    $0x11,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <getpid>:
 3e8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <sbrk>:
 3f0:	b8 13 00 00 00       	mov    $0x13,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <sleep>:
 3f8:	b8 14 00 00 00       	mov    $0x14,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	89 ce                	mov    %ecx,%esi
 407:	53                   	push   %ebx
 408:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 40e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 411:	85 c9                	test   %ecx,%ecx
 413:	74 04                	je     419 <printint+0x19>
 415:	85 d2                	test   %edx,%edx
 417:	78 77                	js     490 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 419:	89 d0                	mov    %edx,%eax
 41b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 422:	31 db                	xor    %ebx,%ebx
 424:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 427:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 428:	31 d2                	xor    %edx,%edx
 42a:	f7 f6                	div    %esi
 42c:	89 c1                	mov    %eax,%ecx
 42e:	0f b6 82 b7 08 00 00 	movzbl 0x8b7(%edx),%eax
 435:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 438:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 43b:	85 c9                	test   %ecx,%ecx
 43d:	89 c8                	mov    %ecx,%eax
 43f:	75 e7                	jne    428 <printint+0x28>
  if(neg)
 441:	8b 45 d0             	mov    -0x30(%ebp),%eax
 444:	85 c0                	test   %eax,%eax
 446:	74 08                	je     450 <printint+0x50>
    buf[i++] = '-';
 448:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 44d:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 450:	8d 73 ff             	lea    -0x1(%ebx),%esi
 453:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 456:	8d 7d f3             	lea    -0xd(%ebp),%edi
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 460:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 463:	83 ee 01             	sub    $0x1,%esi
 466:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 469:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 470:	00 
 471:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 475:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 478:	8b 45 cc             	mov    -0x34(%ebp),%eax
 47b:	89 04 24             	mov    %eax,(%esp)
 47e:	e8 05 ff ff ff       	call   388 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 483:	83 fe ff             	cmp    $0xffffffff,%esi
 486:	75 d8                	jne    460 <printint+0x60>
    putc(fd, buf[i]);
}
 488:	83 c4 3c             	add    $0x3c,%esp
 48b:	5b                   	pop    %ebx
 48c:	5e                   	pop    %esi
 48d:	5f                   	pop    %edi
 48e:	5d                   	pop    %ebp
 48f:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 490:	89 d0                	mov    %edx,%eax
 492:	f7 d8                	neg    %eax
 494:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 49b:	eb 85                	jmp    422 <printint+0x22>
 49d:	8d 76 00             	lea    0x0(%esi),%esi

000004a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ac:	0f b6 02             	movzbl (%edx),%eax
 4af:	84 c0                	test   %al,%al
 4b1:	0f 84 e9 00 00 00    	je     5a0 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4b7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4ba:	31 ff                	xor    %edi,%edi
 4bc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 4bf:	31 f6                	xor    %esi,%esi
 4c1:	eb 21                	jmp    4e4 <printf+0x44>
 4c3:	90                   	nop    
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c8:	83 fb 25             	cmp    $0x25,%ebx
 4cb:	0f 85 d7 00 00 00    	jne    5a8 <printf+0x108>
 4d1:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d5:	83 c7 01             	add    $0x1,%edi
 4d8:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 4dc:	84 c0                	test   %al,%al
 4de:	0f 84 bc 00 00 00    	je     5a0 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 4e4:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4e6:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 4e9:	74 dd                	je     4c8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4eb:	83 fe 25             	cmp    $0x25,%esi
 4ee:	75 e5                	jne    4d5 <printf+0x35>
      if(c == 'd'){
 4f0:	83 fb 64             	cmp    $0x64,%ebx
 4f3:	90                   	nop    
 4f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f8:	0f 84 52 01 00 00    	je     650 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4fe:	83 fb 78             	cmp    $0x78,%ebx
 501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 508:	0f 84 c2 00 00 00    	je     5d0 <printf+0x130>
 50e:	83 fb 70             	cmp    $0x70,%ebx
 511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 518:	0f 84 b2 00 00 00    	je     5d0 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 51e:	83 fb 73             	cmp    $0x73,%ebx
 521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 528:	0f 84 ca 00 00 00    	je     5f8 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52e:	83 fb 63             	cmp    $0x63,%ebx
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 538:	0f 84 62 01 00 00    	je     6a0 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 53e:	83 fb 25             	cmp    $0x25,%ebx
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 548:	0f 84 2a 01 00 00    	je     678 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 54e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 551:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 554:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 557:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55b:	31 f6                	xor    %esi,%esi
 55d:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 561:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 568:	00 
 569:	89 0c 24             	mov    %ecx,(%esp)
 56c:	e8 17 fe ff ff       	call   388 <write>
 571:	8b 55 08             	mov    0x8(%ebp),%edx
 574:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 577:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 57a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 581:	00 
 582:	89 44 24 04          	mov    %eax,0x4(%esp)
 586:	89 14 24             	mov    %edx,(%esp)
 589:	e8 fa fd ff ff       	call   388 <write>
 58e:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 591:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 595:	84 c0                	test   %al,%al
 597:	0f 85 47 ff ff ff    	jne    4e4 <printf+0x44>
 59d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a0:	83 c4 2c             	add    $0x2c,%esp
 5a3:	5b                   	pop    %ebx
 5a4:	5e                   	pop    %esi
 5a5:	5f                   	pop    %edi
 5a6:	5d                   	pop    %ebp
 5a7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a8:	8b 55 08             	mov    0x8(%ebp),%edx
 5ab:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5ae:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b8:	00 
 5b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bd:	89 14 24             	mov    %edx,(%esp)
 5c0:	e8 c3 fd ff ff       	call   388 <write>
 5c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c8:	e9 08 ff ff ff       	jmp    4d5 <printf+0x35>
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5d3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5d8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5e1:	8b 10                	mov    (%eax),%edx
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	e8 15 fe ff ff       	call   400 <printint>
 5eb:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 5ee:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 5f2:	e9 de fe ff ff       	jmp    4d5 <printf+0x35>
 5f7:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 5f8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 5fb:	8b 19                	mov    (%ecx),%ebx
        ap++;
 5fd:	83 c1 04             	add    $0x4,%ecx
 600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 603:	85 db                	test   %ebx,%ebx
 605:	0f 84 c5 00 00 00    	je     6d0 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 60b:	0f b6 03             	movzbl (%ebx),%eax
 60e:	84 c0                	test   %al,%al
 610:	74 30                	je     642 <printf+0x1a2>
 612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 618:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 61b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 61e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 621:	8d 45 f3             	lea    -0xd(%ebp),%eax
 624:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 62b:	00 
 62c:	89 44 24 04          	mov    %eax,0x4(%esp)
 630:	89 14 24             	mov    %edx,(%esp)
 633:	e8 50 fd ff ff       	call   388 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 638:	0f b6 03             	movzbl (%ebx),%eax
 63b:	84 c0                	test   %al,%al
 63d:	75 d9                	jne    618 <printf+0x178>
 63f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 642:	31 f6                	xor    %esi,%esi
 644:	e9 8c fe ff ff       	jmp    4d5 <printf+0x35>
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 650:	8b 45 e0             	mov    -0x20(%ebp),%eax
 653:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 658:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 65b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 662:	8b 10                	mov    (%eax),%edx
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	e8 94 fd ff ff       	call   400 <printint>
 66c:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 66f:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 673:	e9 5d fe ff ff       	jmp    4d5 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 67e:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 680:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 684:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 68b:	00 
 68c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 690:	89 04 24             	mov    %eax,(%esp)
 693:	e8 f0 fc ff ff       	call   388 <write>
 698:	8b 55 0c             	mov    0xc(%ebp),%edx
 69b:	e9 35 fe ff ff       	jmp    4d5 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 6a3:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6a5:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a8:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6aa:	89 14 24             	mov    %edx,(%esp)
 6ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b4:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6b5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6b8:	8d 45 f3             	lea    -0xd(%ebp),%eax
 6bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bf:	e8 c4 fc ff ff       	call   388 <write>
 6c4:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6c7:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 6cb:	e9 05 fe ff ff       	jmp    4d5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 6d0:	bb b0 08 00 00       	mov    $0x8b0,%ebx
 6d5:	e9 31 ff ff ff       	jmp    60b <printf+0x16b>
 6da:	90                   	nop    
 6db:	90                   	nop    
 6dc:	90                   	nop    
 6dd:	90                   	nop    
 6de:	90                   	nop    
 6df:	90                   	nop    

000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	8b 0d d8 08 00 00    	mov    0x8d8,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e7:	89 e5                	mov    %esp,%ebp
 6e9:	57                   	push   %edi
 6ea:	56                   	push   %esi
 6eb:	53                   	push   %ebx
 6ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 6ef:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	39 d9                	cmp    %ebx,%ecx
 6f4:	73 24                	jae    71a <free+0x3a>
 6f6:	66 90                	xchg   %ax,%ax
 6f8:	8b 11                	mov    (%ecx),%edx
 6fa:	39 d3                	cmp    %edx,%ebx
 6fc:	72 2a                	jb     728 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fe:	39 d1                	cmp    %edx,%ecx
 700:	72 10                	jb     712 <free+0x32>
 702:	39 d9                	cmp    %ebx,%ecx
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 708:	72 1e                	jb     728 <free+0x48>
 70a:	39 d3                	cmp    %edx,%ebx
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 710:	72 16                	jb     728 <free+0x48>
 712:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	39 d9                	cmp    %ebx,%ecx
 716:	66 90                	xchg   %ax,%ax
 718:	72 de                	jb     6f8 <free+0x18>
 71a:	8b 11                	mov    (%ecx),%edx
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 720:	eb dc                	jmp    6fe <free+0x1e>
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 728:	8b 73 04             	mov    0x4(%ebx),%esi
 72b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 72e:	39 d0                	cmp    %edx,%eax
 730:	74 1a                	je     74c <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 732:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 735:	8b 51 04             	mov    0x4(%ecx),%edx
 738:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 73b:	39 d8                	cmp    %ebx,%eax
 73d:	74 22                	je     761 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 73f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 741:	89 0d d8 08 00 00    	mov    %ecx,0x8d8
}
 747:	5b                   	pop    %ebx
 748:	5e                   	pop    %esi
 749:	5f                   	pop    %edi
 74a:	5d                   	pop    %ebp
 74b:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74c:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 74f:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 751:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 754:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 757:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 75a:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 75d:	39 d8                	cmp    %ebx,%eax
 75f:	75 de                	jne    73f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 761:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 764:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 767:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 769:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 76c:	89 0d d8 08 00 00    	mov    %ecx,0x8d8
}
 772:	5b                   	pop    %ebx
 773:	5e                   	pop    %esi
 774:	5f                   	pop    %edi
 775:	5d                   	pop    %ebp
 776:	c3                   	ret    
 777:	89 f6                	mov    %esi,%esi
 779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 78c:	8b 15 d8 08 00 00    	mov    0x8d8,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	83 c0 07             	add    $0x7,%eax
 795:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 798:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 79d:	0f 84 95 00 00 00    	je     838 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 7a5:	8b 41 04             	mov    0x4(%ecx),%eax
 7a8:	39 c3                	cmp    %eax,%ebx
 7aa:	76 1f                	jbe    7cb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 7ac:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7b3:	90                   	nop    
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 7b8:	3b 0d d8 08 00 00    	cmp    0x8d8,%ecx
 7be:	89 ca                	mov    %ecx,%edx
 7c0:	74 34                	je     7f6 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 7c4:	8b 41 04             	mov    0x4(%ecx),%eax
 7c7:	39 c3                	cmp    %eax,%ebx
 7c9:	77 ed                	ja     7b8 <malloc+0x38>
      if(p->s.size == nunits)
 7cb:	39 c3                	cmp    %eax,%ebx
 7cd:	74 21                	je     7f0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7cf:	29 d8                	sub    %ebx,%eax
 7d1:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 7d4:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 7d7:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 7da:	89 15 d8 08 00 00    	mov    %edx,0x8d8
      return (void*) (p + 1);
 7e0:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e3:	83 c4 0c             	add    $0xc,%esp
 7e6:	5b                   	pop    %ebx
 7e7:	5e                   	pop    %esi
 7e8:	5f                   	pop    %edi
 7e9:	5d                   	pop    %ebp
 7ea:	c3                   	ret    
 7eb:	90                   	nop    
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7f0:	8b 01                	mov    (%ecx),%eax
 7f2:	89 02                	mov    %eax,(%edx)
 7f4:	eb e4                	jmp    7da <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 7f6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 7fc:	bf 00 10 00 00       	mov    $0x1000,%edi
 801:	b8 00 80 00 00       	mov    $0x8000,%eax
 806:	76 04                	jbe    80c <malloc+0x8c>
 808:	89 df                	mov    %ebx,%edi
 80a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 80c:	89 04 24             	mov    %eax,(%esp)
 80f:	e8 dc fb ff ff       	call   3f0 <sbrk>
  if(p == (char*) -1)
 814:	83 f8 ff             	cmp    $0xffffffff,%eax
 817:	74 18                	je     831 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 819:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 81c:	83 c0 08             	add    $0x8,%eax
 81f:	89 04 24             	mov    %eax,(%esp)
 822:	e8 b9 fe ff ff       	call   6e0 <free>
  return freep;
 827:	8b 15 d8 08 00 00    	mov    0x8d8,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 82d:	85 d2                	test   %edx,%edx
 82f:	75 91                	jne    7c2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 831:	31 c0                	xor    %eax,%eax
 833:	eb ae                	jmp    7e3 <malloc+0x63>
 835:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 838:	c7 05 d8 08 00 00 d0 	movl   $0x8d0,0x8d8
 83f:	08 00 00 
    base.s.size = 0;
 842:	ba d0 08 00 00       	mov    $0x8d0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 847:	c7 05 d0 08 00 00 d0 	movl   $0x8d0,0x8d0
 84e:	08 00 00 
    base.s.size = 0;
 851:	c7 05 d4 08 00 00 00 	movl   $0x0,0x8d4
 858:	00 00 00 
 85b:	e9 43 ff ff ff       	jmp    7a3 <malloc+0x23>
