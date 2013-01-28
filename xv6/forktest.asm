
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:
#include "stat.h"
#include "user.h"

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	89 1c 24             	mov    %ebx,(%esp)
   d:	e8 9e 01 00 00       	call   1b0 <strlen>
  12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  16:	89 44 24 08          	mov    %eax,0x8(%esp)
  1a:	8b 45 08             	mov    0x8(%ebp),%eax
  1d:	89 04 24             	mov    %eax,(%esp)
  20:	e8 73 03 00 00       	call   398 <write>
}
  25:	83 c4 14             	add    $0x14,%esp
  28:	5b                   	pop    %ebx
  29:	5d                   	pop    %ebp
  2a:	c3                   	ret    
  2b:	90                   	nop    
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000030 <forktest>:

void
forktest(void)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
  34:	31 db                	xor    %ebx,%ebx
  write(fd, s, strlen(s));
}

void
forktest(void)
{
  36:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
  39:	c7 44 24 04 10 04 00 	movl   $0x410,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 b3 ff ff ff       	call   0 <printf>
  4d:	eb 13                	jmp    62 <forktest+0x32>
  4f:	90                   	nop    

  for(n=0; n<1000; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
  50:	0f 84 7e 00 00 00    	je     d4 <forktest+0xa4>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
  56:	83 c3 01             	add    $0x1,%ebx
  59:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  5f:	90                   	nop    
  60:	74 5e                	je     c0 <forktest+0x90>
  62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = fork();
  68:	e8 03 03 00 00       	call   370 <fork>
    if(pid < 0)
  6d:	83 f8 00             	cmp    $0x0,%eax
  70:	7d de                	jge    50 <forktest+0x20>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
  72:	85 db                	test   %ebx,%ebx
  74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  78:	74 18                	je     92 <forktest+0x62>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
  80:	e8 fb 02 00 00       	call   380 <wait>
  85:	85 c0                	test   %eax,%eax
  87:	90                   	nop    
  88:	78 4f                	js     d9 <forktest+0xa9>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
  8a:	83 eb 01             	sub    $0x1,%ebx
  8d:	8d 76 00             	lea    0x0(%esi),%esi
  90:	75 ee                	jne    80 <forktest+0x50>
  92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  98:	e8 e3 02 00 00       	call   380 <wait>
  9d:	83 c0 01             	add    $0x1,%eax
  a0:	75 50                	jne    f2 <forktest+0xc2>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
  a2:	c7 44 24 04 42 04 00 	movl   $0x442,0x4(%esp)
  a9:	00 
  aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b1:	e8 4a ff ff ff       	call   0 <printf>
}
  b6:	83 c4 14             	add    $0x14,%esp
  b9:	5b                   	pop    %ebx
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
  c0:	c7 44 24 04 50 04 00 	movl   $0x450,0x4(%esp)
  c7:	00 
  c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cf:	e8 2c ff ff ff       	call   0 <printf>
    exit();
  d4:	e8 9f 02 00 00       	call   378 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
  d9:	c7 44 24 04 1b 04 00 	movl   $0x41b,0x4(%esp)
  e0:	00 
  e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e8:	e8 13 ff ff ff       	call   0 <printf>
      exit();
  ed:	e8 86 02 00 00       	call   378 <exit>
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
  f2:	c7 44 24 04 2f 04 00 	movl   $0x42f,0x4(%esp)
  f9:	00 
  fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 101:	e8 fa fe ff ff       	call   0 <printf>
    exit();
 106:	e8 6d 02 00 00       	call   378 <exit>
 10b:	90                   	nop    
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
 110:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 114:	83 e4 f0             	and    $0xfffffff0,%esp
 117:	ff 71 fc             	pushl  -0x4(%ecx)
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	51                   	push   %ecx
 11e:	83 ec 04             	sub    $0x4,%esp
  forktest();
 121:	e8 0a ff ff ff       	call   30 <forktest>
  exit();
 126:	e8 4d 02 00 00       	call   378 <exit>
 12b:	90                   	nop    
 12c:	90                   	nop    
 12d:	90                   	nop    
 12e:	90                   	nop    
 12f:	90                   	nop    

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 130:	55                   	push   %ebp
 131:	31 d2                	xor    %edx,%edx
 133:	89 e5                	mov    %esp,%ebp
 135:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 138:	53                   	push   %ebx
 139:	8b 5d 08             	mov    0x8(%ebp),%ebx
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 140:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
 144:	88 04 13             	mov    %al,(%ebx,%edx,1)
 147:	83 c2 01             	add    $0x1,%edx
 14a:	84 c0                	test   %al,%al
 14c:	75 f2                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 14e:	89 d8                	mov    %ebx,%eax
 150:	5b                   	pop    %ebx
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    
 153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 55 08             	mov    0x8(%ebp),%edx
 167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 16a:	0f b6 02             	movzbl (%edx),%eax
 16d:	84 c0                	test   %al,%al
 16f:	75 14                	jne    185 <strcmp+0x25>
 171:	eb 2d                	jmp    1a0 <strcmp+0x40>
 173:	90                   	nop    
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 178:	83 c2 01             	add    $0x1,%edx
 17b:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17e:	0f b6 02             	movzbl (%edx),%eax
 181:	84 c0                	test   %al,%al
 183:	74 1b                	je     1a0 <strcmp+0x40>
 185:	0f b6 19             	movzbl (%ecx),%ebx
 188:	38 d8                	cmp    %bl,%al
 18a:	74 ec                	je     178 <strcmp+0x18>
 18c:	0f b6 d0             	movzbl %al,%edx
 18f:	0f b6 c3             	movzbl %bl,%eax
 192:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 194:	89 d0                	mov    %edx,%eax
 196:	5b                   	pop    %ebx
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a0:	0f b6 19             	movzbl (%ecx),%ebx
 1a3:	31 d2                	xor    %edx,%edx
 1a5:	0f b6 c3             	movzbl %bl,%eax
 1a8:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1aa:	89 d0                	mov    %edx,%eax
 1ac:	5b                   	pop    %ebx
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret    
 1af:	90                   	nop    

000001b0 <strlen>:

uint
strlen(char *s)
{
 1b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1b1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1b3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1b5:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1ba:	80 3a 00             	cmpb   $0x0,(%edx)
 1bd:	74 0c                	je     1cb <strlen+0x1b>
 1bf:	90                   	nop    
 1c0:	83 c0 01             	add    $0x1,%eax
 1c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1c7:	75 f7                	jne    1c0 <strlen+0x10>
 1c9:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 1cb:	89 c8                	mov    %ecx,%eax
 1cd:	5d                   	pop    %ebp
 1ce:	c3                   	ret    
 1cf:	90                   	nop    

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 08             	sub    $0x8,%esp
 1d6:	89 1c 24             	mov    %ebx,(%esp)
 1d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	89 df                	mov    %ebx,%edi
 1e8:	fc                   	cld    
 1e9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1eb:	89 d8                	mov    %ebx,%eax
 1ed:	8b 7c 24 04          	mov    0x4(%esp),%edi
 1f1:	8b 1c 24             	mov    (%esp),%ebx
 1f4:	89 ec                	mov    %ebp,%esp
 1f6:	5d                   	pop    %ebp
 1f7:	c3                   	ret    
 1f8:	90                   	nop    
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 20a:	0f b6 10             	movzbl (%eax),%edx
 20d:	84 d2                	test   %dl,%dl
 20f:	75 11                	jne    222 <strchr+0x22>
 211:	eb 25                	jmp    238 <strchr+0x38>
 213:	90                   	nop    
 214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 218:	83 c0 01             	add    $0x1,%eax
 21b:	0f b6 10             	movzbl (%eax),%edx
 21e:	84 d2                	test   %dl,%dl
 220:	74 16                	je     238 <strchr+0x38>
    if(*s == c)
 222:	38 ca                	cmp    %cl,%dl
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 228:	75 ee                	jne    218 <strchr+0x18>
      return (char*) s;
  return 0;
}
 22a:	5d                   	pop    %ebp
 22b:	90                   	nop    
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 230:	c3                   	ret    
 231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 238:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 23a:	5d                   	pop    %ebp
 23b:	90                   	nop    
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 240:	c3                   	ret    
 241:	eb 0d                	jmp    250 <atoi>
 243:	90                   	nop    
 244:	90                   	nop    
 245:	90                   	nop    
 246:	90                   	nop    
 247:	90                   	nop    
 248:	90                   	nop    
 249:	90                   	nop    
 24a:	90                   	nop    
 24b:	90                   	nop    
 24c:	90                   	nop    
 24d:	90                   	nop    
 24e:	90                   	nop    
 24f:	90                   	nop    

00000250 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 251:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 253:	89 e5                	mov    %esp,%ebp
 255:	53                   	push   %ebx
 256:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 259:	0f b6 13             	movzbl (%ebx),%edx
 25c:	8d 42 d0             	lea    -0x30(%edx),%eax
 25f:	3c 09                	cmp    $0x9,%al
 261:	77 1c                	ja     27f <atoi+0x2f>
 263:	90                   	nop    
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 268:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 26b:	0f be d2             	movsbl %dl,%edx
 26e:	83 c3 01             	add    $0x1,%ebx
 271:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 275:	0f b6 13             	movzbl (%ebx),%edx
 278:	8d 42 d0             	lea    -0x30(%edx),%eax
 27b:	3c 09                	cmp    $0x9,%al
 27d:	76 e9                	jbe    268 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 27f:	89 c8                	mov    %ecx,%eax
 281:	5b                   	pop    %ebx
 282:	5d                   	pop    %ebp
 283:	c3                   	ret    
 284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 28a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000290 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 4d 10             	mov    0x10(%ebp),%ecx
 296:	56                   	push   %esi
 297:	8b 75 08             	mov    0x8(%ebp),%esi
 29a:	53                   	push   %ebx
 29b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c9                	test   %ecx,%ecx
 2a0:	7e 14                	jle    2b6 <memmove+0x26>
 2a2:	31 d2                	xor    %edx,%edx
 2a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2a8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 2ac:	88 04 16             	mov    %al,(%esi,%edx,1)
 2af:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b2:	39 ca                	cmp    %ecx,%edx
 2b4:	75 f2                	jne    2a8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2b6:	89 f0                	mov    %esi,%eax
 2b8:	5b                   	pop    %ebx
 2b9:	5e                   	pop    %esi
 2ba:	5d                   	pop    %ebp
 2bb:	c3                   	ret    
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2c9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2cc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2db:	00 
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 d4 00 00 00       	call   3b8 <open>
  if(fd < 0)
 2e4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2e8:	78 19                	js     303 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 1c 24             	mov    %ebx,(%esp)
 2f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f4:	e8 d7 00 00 00       	call   3d0 <fstat>
  close(fd);
 2f9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2fc:	89 c6                	mov    %eax,%esi
  close(fd);
 2fe:	e8 9d 00 00 00       	call   3a0 <close>
  return r;
}
 303:	89 f0                	mov    %esi,%eax
 305:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 308:	8b 75 fc             	mov    -0x4(%ebp),%esi
 30b:	89 ec                	mov    %ebp,%esp
 30d:	5d                   	pop    %ebp
 30e:	c3                   	ret    
 30f:	90                   	nop    

00000310 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	31 f6                	xor    %esi,%esi
 317:	53                   	push   %ebx
 318:	83 ec 1c             	sub    $0x1c,%esp
 31b:	8b 7d 08             	mov    0x8(%ebp),%edi
 31e:	eb 06                	jmp    326 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 320:	3c 0d                	cmp    $0xd,%al
 322:	74 39                	je     35d <gets+0x4d>
 324:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 326:	8d 5e 01             	lea    0x1(%esi),%ebx
 329:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 32c:	7d 31                	jge    35f <gets+0x4f>
    cc = read(0, &c, 1);
 32e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 331:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 338:	00 
 339:	89 44 24 04          	mov    %eax,0x4(%esp)
 33d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 344:	e8 47 00 00 00       	call   390 <read>
    if(cc < 1)
 349:	85 c0                	test   %eax,%eax
 34b:	7e 12                	jle    35f <gets+0x4f>
      break;
    buf[i++] = c;
 34d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 351:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 355:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 359:	3c 0a                	cmp    $0xa,%al
 35b:	75 c3                	jne    320 <gets+0x10>
 35d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 35f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 363:	89 f8                	mov    %edi,%eax
 365:	83 c4 1c             	add    $0x1c,%esp
 368:	5b                   	pop    %ebx
 369:	5e                   	pop    %esi
 36a:	5f                   	pop    %edi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    
 36d:	90                   	nop    
 36e:	90                   	nop    
 36f:	90                   	nop    

00000370 <fork>:
 370:	b8 01 00 00 00       	mov    $0x1,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <exit>:
 378:	b8 02 00 00 00       	mov    $0x2,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <wait>:
 380:	b8 03 00 00 00       	mov    $0x3,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <pipe>:
 388:	b8 04 00 00 00       	mov    $0x4,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <read>:
 390:	b8 06 00 00 00       	mov    $0x6,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <write>:
 398:	b8 05 00 00 00       	mov    $0x5,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <close>:
 3a0:	b8 07 00 00 00       	mov    $0x7,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <kill>:
 3a8:	b8 08 00 00 00       	mov    $0x8,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <exec>:
 3b0:	b8 09 00 00 00       	mov    $0x9,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <open>:
 3b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mknod>:
 3c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <unlink>:
 3c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <fstat>:
 3d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <link>:
 3d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <mkdir>:
 3e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <chdir>:
 3e8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <dup>:
 3f0:	b8 11 00 00 00       	mov    $0x11,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <getpid>:
 3f8:	b8 12 00 00 00       	mov    $0x12,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sbrk>:
 400:	b8 13 00 00 00       	mov    $0x13,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sleep>:
 408:	b8 14 00 00 00       	mov    $0x14,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    
