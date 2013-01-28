
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 5a 02 00 00       	call   270 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0c                	jle    26 <main+0x26>
    sleep(5);  // Let child exit before parent.
  1a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  21:	e8 e2 02 00 00       	call   308 <sleep>
  exit();
  26:	e8 4d 02 00 00       	call   278 <exit>
  2b:	90                   	nop    
  2c:	90                   	nop    
  2d:	90                   	nop    
  2e:	90                   	nop    
  2f:	90                   	nop    

00000030 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  30:	55                   	push   %ebp
  31:	31 d2                	xor    %edx,%edx
  33:	89 e5                	mov    %esp,%ebp
  35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  38:	53                   	push   %ebx
  39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  44:	88 04 13             	mov    %al,(%ebx,%edx,1)
  47:	83 c2 01             	add    $0x1,%edx
  4a:	84 c0                	test   %al,%al
  4c:	75 f2                	jne    40 <strcpy+0x10>
    ;
  return os;
}
  4e:	89 d8                	mov    %ebx,%eax
  50:	5b                   	pop    %ebx
  51:	5d                   	pop    %ebp
  52:	c3                   	ret    
  53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 55 08             	mov    0x8(%ebp),%edx
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  6a:	0f b6 02             	movzbl (%edx),%eax
  6d:	84 c0                	test   %al,%al
  6f:	75 14                	jne    85 <strcmp+0x25>
  71:	eb 2d                	jmp    a0 <strcmp+0x40>
  73:	90                   	nop    
  74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  78:	83 c2 01             	add    $0x1,%edx
  7b:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  7e:	0f b6 02             	movzbl (%edx),%eax
  81:	84 c0                	test   %al,%al
  83:	74 1b                	je     a0 <strcmp+0x40>
  85:	0f b6 19             	movzbl (%ecx),%ebx
  88:	38 d8                	cmp    %bl,%al
  8a:	74 ec                	je     78 <strcmp+0x18>
  8c:	0f b6 d0             	movzbl %al,%edx
  8f:	0f b6 c3             	movzbl %bl,%eax
  92:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  94:	89 d0                	mov    %edx,%eax
  96:	5b                   	pop    %ebx
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a0:	0f b6 19             	movzbl (%ecx),%ebx
  a3:	31 d2                	xor    %edx,%edx
  a5:	0f b6 c3             	movzbl %bl,%eax
  a8:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  aa:	89 d0                	mov    %edx,%eax
  ac:	5b                   	pop    %ebx
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    
  af:	90                   	nop    

000000b0 <strlen>:

uint
strlen(char *s)
{
  b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  b1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  b3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
  b5:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ba:	80 3a 00             	cmpb   $0x0,(%edx)
  bd:	74 0c                	je     cb <strlen+0x1b>
  bf:	90                   	nop    
  c0:	83 c0 01             	add    $0x1,%eax
  c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c7:	75 f7                	jne    c0 <strlen+0x10>
  c9:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
  cb:	89 c8                	mov    %ecx,%eax
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    
  cf:	90                   	nop    

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	83 ec 08             	sub    $0x8,%esp
  d6:	89 1c 24             	mov    %ebx,(%esp)
  d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  e6:	89 df                	mov    %ebx,%edi
  e8:	fc                   	cld    
  e9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  eb:	89 d8                	mov    %ebx,%eax
  ed:	8b 7c 24 04          	mov    0x4(%esp),%edi
  f1:	8b 1c 24             	mov    (%esp),%ebx
  f4:	89 ec                	mov    %ebp,%esp
  f6:	5d                   	pop    %ebp
  f7:	c3                   	ret    
  f8:	90                   	nop    
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	75 11                	jne    122 <strchr+0x22>
 111:	eb 25                	jmp    138 <strchr+0x38>
 113:	90                   	nop    
 114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 118:	83 c0 01             	add    $0x1,%eax
 11b:	0f b6 10             	movzbl (%eax),%edx
 11e:	84 d2                	test   %dl,%dl
 120:	74 16                	je     138 <strchr+0x38>
    if(*s == c)
 122:	38 ca                	cmp    %cl,%dl
 124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 128:	75 ee                	jne    118 <strchr+0x18>
      return (char*) s;
  return 0;
}
 12a:	5d                   	pop    %ebp
 12b:	90                   	nop    
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 130:	c3                   	ret    
 131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 138:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 13a:	5d                   	pop    %ebp
 13b:	90                   	nop    
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 140:	c3                   	ret    
 141:	eb 0d                	jmp    150 <atoi>
 143:	90                   	nop    
 144:	90                   	nop    
 145:	90                   	nop    
 146:	90                   	nop    
 147:	90                   	nop    
 148:	90                   	nop    
 149:	90                   	nop    
 14a:	90                   	nop    
 14b:	90                   	nop    
 14c:	90                   	nop    
 14d:	90                   	nop    
 14e:	90                   	nop    
 14f:	90                   	nop    

00000150 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 150:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 151:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 153:	89 e5                	mov    %esp,%ebp
 155:	53                   	push   %ebx
 156:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 159:	0f b6 13             	movzbl (%ebx),%edx
 15c:	8d 42 d0             	lea    -0x30(%edx),%eax
 15f:	3c 09                	cmp    $0x9,%al
 161:	77 1c                	ja     17f <atoi+0x2f>
 163:	90                   	nop    
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 168:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 16b:	0f be d2             	movsbl %dl,%edx
 16e:	83 c3 01             	add    $0x1,%ebx
 171:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 175:	0f b6 13             	movzbl (%ebx),%edx
 178:	8d 42 d0             	lea    -0x30(%edx),%eax
 17b:	3c 09                	cmp    $0x9,%al
 17d:	76 e9                	jbe    168 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 17f:	89 c8                	mov    %ecx,%eax
 181:	5b                   	pop    %ebx
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000190 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 4d 10             	mov    0x10(%ebp),%ecx
 196:	56                   	push   %esi
 197:	8b 75 08             	mov    0x8(%ebp),%esi
 19a:	53                   	push   %ebx
 19b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 19e:	85 c9                	test   %ecx,%ecx
 1a0:	7e 14                	jle    1b6 <memmove+0x26>
 1a2:	31 d2                	xor    %edx,%edx
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 1a8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 1ac:	88 04 16             	mov    %al,(%esi,%edx,1)
 1af:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1b2:	39 ca                	cmp    %ecx,%edx
 1b4:	75 f2                	jne    1a8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1b6:	89 f0                	mov    %esi,%eax
 1b8:	5b                   	pop    %ebx
 1b9:	5e                   	pop    %esi
 1ba:	5d                   	pop    %ebp
 1bb:	c3                   	ret    
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001c0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1c9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1cc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1db:	00 
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 d4 00 00 00       	call   2b8 <open>
  if(fd < 0)
 1e4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1e8:	78 19                	js     203 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	89 1c 24             	mov    %ebx,(%esp)
 1f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f4:	e8 d7 00 00 00       	call   2d0 <fstat>
  close(fd);
 1f9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1fc:	89 c6                	mov    %eax,%esi
  close(fd);
 1fe:	e8 9d 00 00 00       	call   2a0 <close>
  return r;
}
 203:	89 f0                	mov    %esi,%eax
 205:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 208:	8b 75 fc             	mov    -0x4(%ebp),%esi
 20b:	89 ec                	mov    %ebp,%esp
 20d:	5d                   	pop    %ebp
 20e:	c3                   	ret    
 20f:	90                   	nop    

00000210 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	56                   	push   %esi
 215:	31 f6                	xor    %esi,%esi
 217:	53                   	push   %ebx
 218:	83 ec 1c             	sub    $0x1c,%esp
 21b:	8b 7d 08             	mov    0x8(%ebp),%edi
 21e:	eb 06                	jmp    226 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 220:	3c 0d                	cmp    $0xd,%al
 222:	74 39                	je     25d <gets+0x4d>
 224:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 226:	8d 5e 01             	lea    0x1(%esi),%ebx
 229:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 22c:	7d 31                	jge    25f <gets+0x4f>
    cc = read(0, &c, 1);
 22e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 231:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 238:	00 
 239:	89 44 24 04          	mov    %eax,0x4(%esp)
 23d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 244:	e8 47 00 00 00       	call   290 <read>
    if(cc < 1)
 249:	85 c0                	test   %eax,%eax
 24b:	7e 12                	jle    25f <gets+0x4f>
      break;
    buf[i++] = c;
 24d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 251:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 255:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 259:	3c 0a                	cmp    $0xa,%al
 25b:	75 c3                	jne    220 <gets+0x10>
 25d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 25f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 263:	89 f8                	mov    %edi,%eax
 265:	83 c4 1c             	add    $0x1c,%esp
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5f                   	pop    %edi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	90                   	nop    
 26e:	90                   	nop    
 26f:	90                   	nop    

00000270 <fork>:
 270:	b8 01 00 00 00       	mov    $0x1,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <exit>:
 278:	b8 02 00 00 00       	mov    $0x2,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <wait>:
 280:	b8 03 00 00 00       	mov    $0x3,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <pipe>:
 288:	b8 04 00 00 00       	mov    $0x4,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <read>:
 290:	b8 06 00 00 00       	mov    $0x6,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <write>:
 298:	b8 05 00 00 00       	mov    $0x5,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <close>:
 2a0:	b8 07 00 00 00       	mov    $0x7,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <kill>:
 2a8:	b8 08 00 00 00       	mov    $0x8,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <exec>:
 2b0:	b8 09 00 00 00       	mov    $0x9,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <open>:
 2b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <mknod>:
 2c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <unlink>:
 2c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <fstat>:
 2d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <link>:
 2d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <mkdir>:
 2e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <chdir>:
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <dup>:
 2f0:	b8 11 00 00 00       	mov    $0x11,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <getpid>:
 2f8:	b8 12 00 00 00       	mov    $0x12,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <sbrk>:
 300:	b8 13 00 00 00       	mov    $0x13,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <sleep>:
 308:	b8 14 00 00 00       	mov    $0x14,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	89 ce                	mov    %ecx,%esi
 317:	53                   	push   %ebx
 318:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 31b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 31e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 321:	85 c9                	test   %ecx,%ecx
 323:	74 04                	je     329 <printint+0x19>
 325:	85 d2                	test   %edx,%edx
 327:	78 77                	js     3a0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 329:	89 d0                	mov    %edx,%eax
 32b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 332:	31 db                	xor    %ebx,%ebx
 334:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 337:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 338:	31 d2                	xor    %edx,%edx
 33a:	f7 f6                	div    %esi
 33c:	89 c1                	mov    %eax,%ecx
 33e:	0f b6 82 77 07 00 00 	movzbl 0x777(%edx),%eax
 345:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 348:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 34b:	85 c9                	test   %ecx,%ecx
 34d:	89 c8                	mov    %ecx,%eax
 34f:	75 e7                	jne    338 <printint+0x28>
  if(neg)
 351:	8b 45 d0             	mov    -0x30(%ebp),%eax
 354:	85 c0                	test   %eax,%eax
 356:	74 08                	je     360 <printint+0x50>
    buf[i++] = '-';
 358:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 35d:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 360:	8d 73 ff             	lea    -0x1(%ebx),%esi
 363:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 366:	8d 7d f3             	lea    -0xd(%ebp),%edi
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 370:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 373:	83 ee 01             	sub    $0x1,%esi
 376:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 379:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 380:	00 
 381:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 385:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 388:	8b 45 cc             	mov    -0x34(%ebp),%eax
 38b:	89 04 24             	mov    %eax,(%esp)
 38e:	e8 05 ff ff ff       	call   298 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 393:	83 fe ff             	cmp    $0xffffffff,%esi
 396:	75 d8                	jne    370 <printint+0x60>
    putc(fd, buf[i]);
}
 398:	83 c4 3c             	add    $0x3c,%esp
 39b:	5b                   	pop    %ebx
 39c:	5e                   	pop    %esi
 39d:	5f                   	pop    %edi
 39e:	5d                   	pop    %ebp
 39f:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3a0:	89 d0                	mov    %edx,%eax
 3a2:	f7 d8                	neg    %eax
 3a4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 3ab:	eb 85                	jmp    332 <printint+0x22>
 3ad:	8d 76 00             	lea    0x0(%esi),%esi

000003b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 3bc:	0f b6 02             	movzbl (%edx),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	0f 84 e9 00 00 00    	je     4b0 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3c7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3ca:	31 ff                	xor    %edi,%edi
 3cc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 3cf:	31 f6                	xor    %esi,%esi
 3d1:	eb 21                	jmp    3f4 <printf+0x44>
 3d3:	90                   	nop    
 3d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3d8:	83 fb 25             	cmp    $0x25,%ebx
 3db:	0f 85 d7 00 00 00    	jne    4b8 <printf+0x108>
 3e1:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e5:	83 c7 01             	add    $0x1,%edi
 3e8:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 3ec:	84 c0                	test   %al,%al
 3ee:	0f 84 bc 00 00 00    	je     4b0 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 3f4:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3f6:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 3f9:	74 dd                	je     3d8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3fb:	83 fe 25             	cmp    $0x25,%esi
 3fe:	75 e5                	jne    3e5 <printf+0x35>
      if(c == 'd'){
 400:	83 fb 64             	cmp    $0x64,%ebx
 403:	90                   	nop    
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 408:	0f 84 52 01 00 00    	je     560 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 40e:	83 fb 78             	cmp    $0x78,%ebx
 411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 418:	0f 84 c2 00 00 00    	je     4e0 <printf+0x130>
 41e:	83 fb 70             	cmp    $0x70,%ebx
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	0f 84 b2 00 00 00    	je     4e0 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 42e:	83 fb 73             	cmp    $0x73,%ebx
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 438:	0f 84 ca 00 00 00    	je     508 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 43e:	83 fb 63             	cmp    $0x63,%ebx
 441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 448:	0f 84 62 01 00 00    	je     5b0 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 44e:	83 fb 25             	cmp    $0x25,%ebx
 451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 458:	0f 84 2a 01 00 00    	je     588 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 45e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 461:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 464:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 467:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 46b:	31 f6                	xor    %esi,%esi
 46d:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 471:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 478:	00 
 479:	89 0c 24             	mov    %ecx,(%esp)
 47c:	e8 17 fe ff ff       	call   298 <write>
 481:	8b 55 08             	mov    0x8(%ebp),%edx
 484:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 487:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 48a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 491:	00 
 492:	89 44 24 04          	mov    %eax,0x4(%esp)
 496:	89 14 24             	mov    %edx,(%esp)
 499:	e8 fa fd ff ff       	call   298 <write>
 49e:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a1:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 4a5:	84 c0                	test   %al,%al
 4a7:	0f 85 47 ff ff ff    	jne    3f4 <printf+0x44>
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4b0:	83 c4 2c             	add    $0x2c,%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b8:	8b 55 08             	mov    0x8(%ebp),%edx
 4bb:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4be:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c8:	00 
 4c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cd:	89 14 24             	mov    %edx,(%esp)
 4d0:	e8 c3 fd ff ff       	call   298 <write>
 4d5:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d8:	e9 08 ff ff ff       	jmp    3e5 <printf+0x35>
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4e3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4e8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4f1:	8b 10                	mov    (%eax),%edx
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	e8 15 fe ff ff       	call   310 <printint>
 4fb:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 4fe:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 502:	e9 de fe ff ff       	jmp    3e5 <printf+0x35>
 507:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 508:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 50b:	8b 19                	mov    (%ecx),%ebx
        ap++;
 50d:	83 c1 04             	add    $0x4,%ecx
 510:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 513:	85 db                	test   %ebx,%ebx
 515:	0f 84 c5 00 00 00    	je     5e0 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 51b:	0f b6 03             	movzbl (%ebx),%eax
 51e:	84 c0                	test   %al,%al
 520:	74 30                	je     552 <printf+0x1a2>
 522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 528:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 52b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 52e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 531:	8d 45 f3             	lea    -0xd(%ebp),%eax
 534:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 53b:	00 
 53c:	89 44 24 04          	mov    %eax,0x4(%esp)
 540:	89 14 24             	mov    %edx,(%esp)
 543:	e8 50 fd ff ff       	call   298 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 548:	0f b6 03             	movzbl (%ebx),%eax
 54b:	84 c0                	test   %al,%al
 54d:	75 d9                	jne    528 <printf+0x178>
 54f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 552:	31 f6                	xor    %esi,%esi
 554:	e9 8c fe ff ff       	jmp    3e5 <printf+0x35>
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 560:	8b 45 e0             	mov    -0x20(%ebp),%eax
 563:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 568:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 56b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 572:	8b 10                	mov    (%eax),%edx
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	e8 94 fd ff ff       	call   310 <printint>
 57c:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 57f:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 583:	e9 5d fe ff ff       	jmp    3e5 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 58e:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 590:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 594:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 59b:	00 
 59c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 5a0:	89 04 24             	mov    %eax,(%esp)
 5a3:	e8 f0 fc ff ff       	call   298 <write>
 5a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ab:	e9 35 fe ff ff       	jmp    3e5 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 5b3:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b5:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5b8:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ba:	89 14 24             	mov    %edx,(%esp)
 5bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c4:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5c5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c8:	8d 45 f3             	lea    -0xd(%ebp),%eax
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	e8 c4 fc ff ff       	call   298 <write>
 5d4:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5d7:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 5db:	e9 05 fe ff ff       	jmp    3e5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 5e0:	bb 70 07 00 00       	mov    $0x770,%ebx
 5e5:	e9 31 ff ff ff       	jmp    51b <printf+0x16b>
 5ea:	90                   	nop    
 5eb:	90                   	nop    
 5ec:	90                   	nop    
 5ed:	90                   	nop    
 5ee:	90                   	nop    
 5ef:	90                   	nop    

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8b 0d 90 07 00 00    	mov    0x790,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f7:	89 e5                	mov    %esp,%ebp
 5f9:	57                   	push   %edi
 5fa:	56                   	push   %esi
 5fb:	53                   	push   %ebx
 5fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 5ff:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 602:	39 d9                	cmp    %ebx,%ecx
 604:	73 24                	jae    62a <free+0x3a>
 606:	66 90                	xchg   %ax,%ax
 608:	8b 11                	mov    (%ecx),%edx
 60a:	39 d3                	cmp    %edx,%ebx
 60c:	72 2a                	jb     638 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60e:	39 d1                	cmp    %edx,%ecx
 610:	72 10                	jb     622 <free+0x32>
 612:	39 d9                	cmp    %ebx,%ecx
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 618:	72 1e                	jb     638 <free+0x48>
 61a:	39 d3                	cmp    %edx,%ebx
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 620:	72 16                	jb     638 <free+0x48>
 622:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	39 d9                	cmp    %ebx,%ecx
 626:	66 90                	xchg   %ax,%ax
 628:	72 de                	jb     608 <free+0x18>
 62a:	8b 11                	mov    (%ecx),%edx
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 630:	eb dc                	jmp    60e <free+0x1e>
 632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 73 04             	mov    0x4(%ebx),%esi
 63b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 63e:	39 d0                	cmp    %edx,%eax
 640:	74 1a                	je     65c <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 642:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 645:	8b 51 04             	mov    0x4(%ecx),%edx
 648:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 64b:	39 d8                	cmp    %ebx,%eax
 64d:	74 22                	je     671 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 64f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 651:	89 0d 90 07 00 00    	mov    %ecx,0x790
}
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 65c:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 65f:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 661:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 664:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 667:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 66a:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 66d:	39 d8                	cmp    %ebx,%eax
 66f:	75 de                	jne    64f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 671:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 674:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 677:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 679:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 67c:	89 0d 90 07 00 00    	mov    %ecx,0x790
}
 682:	5b                   	pop    %ebx
 683:	5e                   	pop    %esi
 684:	5f                   	pop    %edi
 685:	5d                   	pop    %ebp
 686:	c3                   	ret    
 687:	89 f6                	mov    %esi,%esi
 689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 15 90 07 00 00    	mov    0x790,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	83 c0 07             	add    $0x7,%eax
 6a5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 6a8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6aa:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 6ad:	0f 84 95 00 00 00    	je     748 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6b5:	8b 41 04             	mov    0x4(%ecx),%eax
 6b8:	39 c3                	cmp    %eax,%ebx
 6ba:	76 1f                	jbe    6db <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 6bc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6c3:	90                   	nop    
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 6c8:	3b 0d 90 07 00 00    	cmp    0x790,%ecx
 6ce:	89 ca                	mov    %ecx,%edx
 6d0:	74 34                	je     706 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d2:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6d4:	8b 41 04             	mov    0x4(%ecx),%eax
 6d7:	39 c3                	cmp    %eax,%ebx
 6d9:	77 ed                	ja     6c8 <malloc+0x38>
      if(p->s.size == nunits)
 6db:	39 c3                	cmp    %eax,%ebx
 6dd:	74 21                	je     700 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6df:	29 d8                	sub    %ebx,%eax
 6e1:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 6e4:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 6e7:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 6ea:	89 15 90 07 00 00    	mov    %edx,0x790
      return (void*) (p + 1);
 6f0:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6f3:	83 c4 0c             	add    $0xc,%esp
 6f6:	5b                   	pop    %ebx
 6f7:	5e                   	pop    %esi
 6f8:	5f                   	pop    %edi
 6f9:	5d                   	pop    %ebp
 6fa:	c3                   	ret    
 6fb:	90                   	nop    
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 700:	8b 01                	mov    (%ecx),%eax
 702:	89 02                	mov    %eax,(%edx)
 704:	eb e4                	jmp    6ea <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 706:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 70c:	bf 00 10 00 00       	mov    $0x1000,%edi
 711:	b8 00 80 00 00       	mov    $0x8000,%eax
 716:	76 04                	jbe    71c <malloc+0x8c>
 718:	89 df                	mov    %ebx,%edi
 71a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 dc fb ff ff       	call   300 <sbrk>
  if(p == (char*) -1)
 724:	83 f8 ff             	cmp    $0xffffffff,%eax
 727:	74 18                	je     741 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 729:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 72c:	83 c0 08             	add    $0x8,%eax
 72f:	89 04 24             	mov    %eax,(%esp)
 732:	e8 b9 fe ff ff       	call   5f0 <free>
  return freep;
 737:	8b 15 90 07 00 00    	mov    0x790,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 73d:	85 d2                	test   %edx,%edx
 73f:	75 91                	jne    6d2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 741:	31 c0                	xor    %eax,%eax
 743:	eb ae                	jmp    6f3 <malloc+0x63>
 745:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 748:	c7 05 90 07 00 00 88 	movl   $0x788,0x790
 74f:	07 00 00 
    base.s.size = 0;
 752:	ba 88 07 00 00       	mov    $0x788,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 757:	c7 05 88 07 00 00 88 	movl   $0x788,0x788
 75e:	07 00 00 
    base.s.size = 0;
 761:	c7 05 8c 07 00 00 00 	movl   $0x0,0x78c
 768:	00 00 00 
 76b:	e9 43 ff ff ff       	jmp    6b3 <malloc+0x23>
