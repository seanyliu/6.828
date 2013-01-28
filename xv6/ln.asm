
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	83 ec 18             	sub    $0x18,%esp
  if(argc != 3){
  10:	83 39 03             	cmpl   $0x3,(%ecx)
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  13:	89 4d f8             	mov    %ecx,-0x8(%ebp)
  16:	89 5d fc             	mov    %ebx,-0x4(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  1c:	74 19                	je     37 <main+0x37>
    printf(2, "Usage: ln old new\n");
  1e:	c7 44 24 04 c0 07 00 	movl   $0x7c0,0x4(%esp)
  25:	00 
  26:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  2d:	e8 ce 03 00 00       	call   400 <printf>
    exit();
  32:	e8 91 02 00 00       	call   2c8 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  37:	8b 43 08             	mov    0x8(%ebx),%eax
  3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  3e:	8b 43 04             	mov    0x4(%ebx),%eax
  41:	89 04 24             	mov    %eax,(%esp)
  44:	e8 df 02 00 00       	call   328 <link>
  49:	85 c0                	test   %eax,%eax
  4b:	78 05                	js     52 <main+0x52>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  4d:	e8 76 02 00 00       	call   2c8 <exit>
  if(argc != 3){
    printf(2, "Usage: ln old new\n");
    exit();
  }
  if(link(argv[1], argv[2]) < 0)
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  52:	8b 43 08             	mov    0x8(%ebx),%eax
  55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  59:	8b 43 04             	mov    0x4(%ebx),%eax
  5c:	c7 44 24 04 d3 07 00 	movl   $0x7d3,0x4(%esp)
  63:	00 
  64:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  6f:	e8 8c 03 00 00       	call   400 <printf>
  74:	eb d7                	jmp    4d <main+0x4d>
  76:	90                   	nop    
  77:	90                   	nop    
  78:	90                   	nop    
  79:	90                   	nop    
  7a:	90                   	nop    
  7b:	90                   	nop    
  7c:	90                   	nop    
  7d:	90                   	nop    
  7e:	90                   	nop    
  7f:	90                   	nop    

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  80:	55                   	push   %ebp
  81:	31 d2                	xor    %edx,%edx
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  88:	53                   	push   %ebx
  89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  94:	88 04 13             	mov    %al,(%ebx,%edx,1)
  97:	83 c2 01             	add    $0x1,%edx
  9a:	84 c0                	test   %al,%al
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	89 d8                	mov    %ebx,%eax
  a0:	5b                   	pop    %ebx
  a1:	5d                   	pop    %ebp
  a2:	c3                   	ret    
  a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 55 08             	mov    0x8(%ebp),%edx
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ba:	0f b6 02             	movzbl (%edx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 14                	jne    d5 <strcmp+0x25>
  c1:	eb 2d                	jmp    f0 <strcmp+0x40>
  c3:	90                   	nop    
  c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  c8:	83 c2 01             	add    $0x1,%edx
  cb:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	0f b6 02             	movzbl (%edx),%eax
  d1:	84 c0                	test   %al,%al
  d3:	74 1b                	je     f0 <strcmp+0x40>
  d5:	0f b6 19             	movzbl (%ecx),%ebx
  d8:	38 d8                	cmp    %bl,%al
  da:	74 ec                	je     c8 <strcmp+0x18>
  dc:	0f b6 d0             	movzbl %al,%edx
  df:	0f b6 c3             	movzbl %bl,%eax
  e2:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  e4:	89 d0                	mov    %edx,%eax
  e6:	5b                   	pop    %ebx
  e7:	5d                   	pop    %ebp
  e8:	c3                   	ret    
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f0:	0f b6 19             	movzbl (%ecx),%ebx
  f3:	31 d2                	xor    %edx,%edx
  f5:	0f b6 c3             	movzbl %bl,%eax
  f8:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  fa:	89 d0                	mov    %edx,%eax
  fc:	5b                   	pop    %ebx
  fd:	5d                   	pop    %ebp
  fe:	c3                   	ret    
  ff:	90                   	nop    

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 101:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 103:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 105:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 107:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 10a:	80 3a 00             	cmpb   $0x0,(%edx)
 10d:	74 0c                	je     11b <strlen+0x1b>
 10f:	90                   	nop    
 110:	83 c0 01             	add    $0x1,%eax
 113:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 117:	75 f7                	jne    110 <strlen+0x10>
 119:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 11b:	89 c8                	mov    %ecx,%eax
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    
 11f:	90                   	nop    

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 08             	sub    $0x8,%esp
 126:	89 1c 24             	mov    %ebx,(%esp)
 129:	8b 5d 08             	mov    0x8(%ebp),%ebx
 12c:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 130:	8b 4d 10             	mov    0x10(%ebp),%ecx
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	89 df                	mov    %ebx,%edi
 138:	fc                   	cld    
 139:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 13b:	89 d8                	mov    %ebx,%eax
 13d:	8b 7c 24 04          	mov    0x4(%esp),%edi
 141:	8b 1c 24             	mov    (%esp),%ebx
 144:	89 ec                	mov    %ebp,%esp
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    
 148:	90                   	nop    
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 11                	jne    172 <strchr+0x22>
 161:	eb 25                	jmp    188 <strchr+0x38>
 163:	90                   	nop    
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 168:	83 c0 01             	add    $0x1,%eax
 16b:	0f b6 10             	movzbl (%eax),%edx
 16e:	84 d2                	test   %dl,%dl
 170:	74 16                	je     188 <strchr+0x38>
    if(*s == c)
 172:	38 ca                	cmp    %cl,%dl
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 178:	75 ee                	jne    168 <strchr+0x18>
      return (char*) s;
  return 0;
}
 17a:	5d                   	pop    %ebp
 17b:	90                   	nop    
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 180:	c3                   	ret    
 181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 188:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 18a:	5d                   	pop    %ebp
 18b:	90                   	nop    
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 190:	c3                   	ret    
 191:	eb 0d                	jmp    1a0 <atoi>
 193:	90                   	nop    
 194:	90                   	nop    
 195:	90                   	nop    
 196:	90                   	nop    
 197:	90                   	nop    
 198:	90                   	nop    
 199:	90                   	nop    
 19a:	90                   	nop    
 19b:	90                   	nop    
 19c:	90                   	nop    
 19d:	90                   	nop    
 19e:	90                   	nop    
 19f:	90                   	nop    

000001a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1a0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a1:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	53                   	push   %ebx
 1a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a9:	0f b6 13             	movzbl (%ebx),%edx
 1ac:	8d 42 d0             	lea    -0x30(%edx),%eax
 1af:	3c 09                	cmp    $0x9,%al
 1b1:	77 1c                	ja     1cf <atoi+0x2f>
 1b3:	90                   	nop    
 1b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 1b8:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 1bb:	0f be d2             	movsbl %dl,%edx
 1be:	83 c3 01             	add    $0x1,%ebx
 1c1:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c5:	0f b6 13             	movzbl (%ebx),%edx
 1c8:	8d 42 d0             	lea    -0x30(%edx),%eax
 1cb:	3c 09                	cmp    $0x9,%al
 1cd:	76 e9                	jbe    1b8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1cf:	89 c8                	mov    %ecx,%eax
 1d1:	5b                   	pop    %ebx
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001e0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1e6:	56                   	push   %esi
 1e7:	8b 75 08             	mov    0x8(%ebp),%esi
 1ea:	53                   	push   %ebx
 1eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ee:	85 c9                	test   %ecx,%ecx
 1f0:	7e 14                	jle    206 <memmove+0x26>
 1f2:	31 d2                	xor    %edx,%edx
 1f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 1f8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 1fc:	88 04 16             	mov    %al,(%esi,%edx,1)
 1ff:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 202:	39 ca                	cmp    %ecx,%edx
 204:	75 f2                	jne    1f8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 206:	89 f0                	mov    %esi,%eax
 208:	5b                   	pop    %ebx
 209:	5e                   	pop    %esi
 20a:	5d                   	pop    %ebp
 20b:	c3                   	ret    
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000210 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 216:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 219:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 21c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 21f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 224:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 22b:	00 
 22c:	89 04 24             	mov    %eax,(%esp)
 22f:	e8 d4 00 00 00       	call   308 <open>
  if(fd < 0)
 234:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 236:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 238:	78 19                	js     253 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	89 1c 24             	mov    %ebx,(%esp)
 240:	89 44 24 04          	mov    %eax,0x4(%esp)
 244:	e8 d7 00 00 00       	call   320 <fstat>
  close(fd);
 249:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 24c:	89 c6                	mov    %eax,%esi
  close(fd);
 24e:	e8 9d 00 00 00       	call   2f0 <close>
  return r;
}
 253:	89 f0                	mov    %esi,%eax
 255:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 258:	8b 75 fc             	mov    -0x4(%ebp),%esi
 25b:	89 ec                	mov    %ebp,%esp
 25d:	5d                   	pop    %ebp
 25e:	c3                   	ret    
 25f:	90                   	nop    

00000260 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	56                   	push   %esi
 265:	31 f6                	xor    %esi,%esi
 267:	53                   	push   %ebx
 268:	83 ec 1c             	sub    $0x1c,%esp
 26b:	8b 7d 08             	mov    0x8(%ebp),%edi
 26e:	eb 06                	jmp    276 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 270:	3c 0d                	cmp    $0xd,%al
 272:	74 39                	je     2ad <gets+0x4d>
 274:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	8d 5e 01             	lea    0x1(%esi),%ebx
 279:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 27c:	7d 31                	jge    2af <gets+0x4f>
    cc = read(0, &c, 1);
 27e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 281:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 288:	00 
 289:	89 44 24 04          	mov    %eax,0x4(%esp)
 28d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 294:	e8 47 00 00 00       	call   2e0 <read>
    if(cc < 1)
 299:	85 c0                	test   %eax,%eax
 29b:	7e 12                	jle    2af <gets+0x4f>
      break;
    buf[i++] = c;
 29d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2a1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 2a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2a9:	3c 0a                	cmp    $0xa,%al
 2ab:	75 c3                	jne    270 <gets+0x10>
 2ad:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2af:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2b3:	89 f8                	mov    %edi,%eax
 2b5:	83 c4 1c             	add    $0x1c,%esp
 2b8:	5b                   	pop    %ebx
 2b9:	5e                   	pop    %esi
 2ba:	5f                   	pop    %edi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	90                   	nop    
 2be:	90                   	nop    
 2bf:	90                   	nop    

000002c0 <fork>:
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
 2e0:	b8 06 00 00 00       	mov    $0x6,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
 2e8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
 2f0:	b8 07 00 00 00       	mov    $0x7,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
 2f8:	b8 08 00 00 00       	mov    $0x8,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
 300:	b8 09 00 00 00       	mov    $0x9,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
 308:	b8 0a 00 00 00       	mov    $0xa,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
 310:	b8 0b 00 00 00       	mov    $0xb,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
 318:	b8 0c 00 00 00       	mov    $0xc,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
 320:	b8 0d 00 00 00       	mov    $0xd,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
 328:	b8 0e 00 00 00       	mov    $0xe,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
 330:	b8 0f 00 00 00       	mov    $0xf,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
 338:	b8 10 00 00 00       	mov    $0x10,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
 340:	b8 11 00 00 00       	mov    $0x11,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getpid>:
 348:	b8 12 00 00 00       	mov    $0x12,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sbrk>:
 350:	b8 13 00 00 00       	mov    $0x13,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sleep>:
 358:	b8 14 00 00 00       	mov    $0x14,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	89 ce                	mov    %ecx,%esi
 367:	53                   	push   %ebx
 368:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 36e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 371:	85 c9                	test   %ecx,%ecx
 373:	74 04                	je     379 <printint+0x19>
 375:	85 d2                	test   %edx,%edx
 377:	78 77                	js     3f0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 379:	89 d0                	mov    %edx,%eax
 37b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 382:	31 db                	xor    %ebx,%ebx
 384:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 387:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 388:	31 d2                	xor    %edx,%edx
 38a:	f7 f6                	div    %esi
 38c:	89 c1                	mov    %eax,%ecx
 38e:	0f b6 82 ee 07 00 00 	movzbl 0x7ee(%edx),%eax
 395:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 398:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 39b:	85 c9                	test   %ecx,%ecx
 39d:	89 c8                	mov    %ecx,%eax
 39f:	75 e7                	jne    388 <printint+0x28>
  if(neg)
 3a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
 3a4:	85 c0                	test   %eax,%eax
 3a6:	74 08                	je     3b0 <printint+0x50>
    buf[i++] = '-';
 3a8:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 3ad:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 3b0:	8d 73 ff             	lea    -0x1(%ebx),%esi
 3b3:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 3b6:	8d 7d f3             	lea    -0xd(%ebp),%edi
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3c0:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3c3:	83 ee 01             	sub    $0x1,%esi
 3c6:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d0:	00 
 3d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 3d5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
 3db:	89 04 24             	mov    %eax,(%esp)
 3de:	e8 05 ff ff ff       	call   2e8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3e3:	83 fe ff             	cmp    $0xffffffff,%esi
 3e6:	75 d8                	jne    3c0 <printint+0x60>
    putc(fd, buf[i]);
}
 3e8:	83 c4 3c             	add    $0x3c,%esp
 3eb:	5b                   	pop    %ebx
 3ec:	5e                   	pop    %esi
 3ed:	5f                   	pop    %edi
 3ee:	5d                   	pop    %ebp
 3ef:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3f0:	89 d0                	mov    %edx,%eax
 3f2:	f7 d8                	neg    %eax
 3f4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 3fb:	eb 85                	jmp    382 <printint+0x22>
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 55 0c             	mov    0xc(%ebp),%edx
 40c:	0f b6 02             	movzbl (%edx),%eax
 40f:	84 c0                	test   %al,%al
 411:	0f 84 e9 00 00 00    	je     500 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 417:	8d 4d 10             	lea    0x10(%ebp),%ecx
 41a:	31 ff                	xor    %edi,%edi
 41c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 41f:	31 f6                	xor    %esi,%esi
 421:	eb 21                	jmp    444 <printf+0x44>
 423:	90                   	nop    
 424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 428:	83 fb 25             	cmp    $0x25,%ebx
 42b:	0f 85 d7 00 00 00    	jne    508 <printf+0x108>
 431:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 435:	83 c7 01             	add    $0x1,%edi
 438:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 43c:	84 c0                	test   %al,%al
 43e:	0f 84 bc 00 00 00    	je     500 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 444:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 446:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 449:	74 dd                	je     428 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 44b:	83 fe 25             	cmp    $0x25,%esi
 44e:	75 e5                	jne    435 <printf+0x35>
      if(c == 'd'){
 450:	83 fb 64             	cmp    $0x64,%ebx
 453:	90                   	nop    
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 458:	0f 84 52 01 00 00    	je     5b0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 45e:	83 fb 78             	cmp    $0x78,%ebx
 461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 468:	0f 84 c2 00 00 00    	je     530 <printf+0x130>
 46e:	83 fb 70             	cmp    $0x70,%ebx
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 478:	0f 84 b2 00 00 00    	je     530 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 47e:	83 fb 73             	cmp    $0x73,%ebx
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 488:	0f 84 ca 00 00 00    	je     558 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 48e:	83 fb 63             	cmp    $0x63,%ebx
 491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 498:	0f 84 62 01 00 00    	je     600 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 49e:	83 fb 25             	cmp    $0x25,%ebx
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4a8:	0f 84 2a 01 00 00    	je     5d8 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4b1:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b4:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b7:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4bb:	31 f6                	xor    %esi,%esi
 4bd:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c8:	00 
 4c9:	89 0c 24             	mov    %ecx,(%esp)
 4cc:	e8 17 fe ff ff       	call   2e8 <write>
 4d1:	8b 55 08             	mov    0x8(%ebp),%edx
 4d4:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4d7:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e1:	00 
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	89 14 24             	mov    %edx,(%esp)
 4e9:	e8 fa fd ff ff       	call   2e8 <write>
 4ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f1:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 4f5:	84 c0                	test   %al,%al
 4f7:	0f 85 47 ff ff ff    	jne    444 <printf+0x44>
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 500:	83 c4 2c             	add    $0x2c,%esp
 503:	5b                   	pop    %ebx
 504:	5e                   	pop    %esi
 505:	5f                   	pop    %edi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 508:	8b 55 08             	mov    0x8(%ebp),%edx
 50b:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 50e:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 511:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 518:	00 
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	89 14 24             	mov    %edx,(%esp)
 520:	e8 c3 fd ff ff       	call   2e8 <write>
 525:	8b 55 0c             	mov    0xc(%ebp),%edx
 528:	e9 08 ff ff ff       	jmp    435 <printf+0x35>
 52d:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 530:	8b 45 e0             	mov    -0x20(%ebp),%eax
 533:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 538:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 53a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 541:	8b 10                	mov    (%eax),%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	e8 15 fe ff ff       	call   360 <printint>
 54b:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 54e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 552:	e9 de fe ff ff       	jmp    435 <printf+0x35>
 557:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 558:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 55b:	8b 19                	mov    (%ecx),%ebx
        ap++;
 55d:	83 c1 04             	add    $0x4,%ecx
 560:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 563:	85 db                	test   %ebx,%ebx
 565:	0f 84 c5 00 00 00    	je     630 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 56b:	0f b6 03             	movzbl (%ebx),%eax
 56e:	84 c0                	test   %al,%al
 570:	74 30                	je     5a2 <printf+0x1a2>
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 578:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 57b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 57e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 581:	8d 45 f3             	lea    -0xd(%ebp),%eax
 584:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58b:	00 
 58c:	89 44 24 04          	mov    %eax,0x4(%esp)
 590:	89 14 24             	mov    %edx,(%esp)
 593:	e8 50 fd ff ff       	call   2e8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 598:	0f b6 03             	movzbl (%ebx),%eax
 59b:	84 c0                	test   %al,%al
 59d:	75 d9                	jne    578 <printf+0x178>
 59f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a2:	31 f6                	xor    %esi,%esi
 5a4:	e9 8c fe ff ff       	jmp    435 <printf+0x35>
 5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5b8:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5c2:	8b 10                	mov    (%eax),%edx
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	e8 94 fd ff ff       	call   360 <printint>
 5cc:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 5cf:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 5d3:	e9 5d fe ff ff       	jmp    435 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 5de:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 5e0:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5eb:	00 
 5ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 5f0:	89 04 24             	mov    %eax,(%esp)
 5f3:	e8 f0 fc ff ff       	call   2e8 <write>
 5f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fb:	e9 35 fe ff ff       	jmp    435 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 600:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 603:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 605:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 608:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 60a:	89 14 24             	mov    %edx,(%esp)
 60d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 614:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 615:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 618:	8d 45 f3             	lea    -0xd(%ebp),%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	e8 c4 fc ff ff       	call   2e8 <write>
 624:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 627:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 62b:	e9 05 fe ff ff       	jmp    435 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 630:	bb e7 07 00 00       	mov    $0x7e7,%ebx
 635:	e9 31 ff ff ff       	jmp    56b <printf+0x16b>
 63a:	90                   	nop    
 63b:	90                   	nop    
 63c:	90                   	nop    
 63d:	90                   	nop    
 63e:	90                   	nop    
 63f:	90                   	nop    

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	8b 0d 08 08 00 00    	mov    0x808,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 647:	89 e5                	mov    %esp,%ebp
 649:	57                   	push   %edi
 64a:	56                   	push   %esi
 64b:	53                   	push   %ebx
 64c:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 64f:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	39 d9                	cmp    %ebx,%ecx
 654:	73 24                	jae    67a <free+0x3a>
 656:	66 90                	xchg   %ax,%ax
 658:	8b 11                	mov    (%ecx),%edx
 65a:	39 d3                	cmp    %edx,%ebx
 65c:	72 2a                	jb     688 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65e:	39 d1                	cmp    %edx,%ecx
 660:	72 10                	jb     672 <free+0x32>
 662:	39 d9                	cmp    %ebx,%ecx
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 668:	72 1e                	jb     688 <free+0x48>
 66a:	39 d3                	cmp    %edx,%ebx
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 670:	72 16                	jb     688 <free+0x48>
 672:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 674:	39 d9                	cmp    %ebx,%ecx
 676:	66 90                	xchg   %ax,%ax
 678:	72 de                	jb     658 <free+0x18>
 67a:	8b 11                	mov    (%ecx),%edx
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 680:	eb dc                	jmp    65e <free+0x1e>
 682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 688:	8b 73 04             	mov    0x4(%ebx),%esi
 68b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 68e:	39 d0                	cmp    %edx,%eax
 690:	74 1a                	je     6ac <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 692:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 695:	8b 51 04             	mov    0x4(%ecx),%edx
 698:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 69b:	39 d8                	cmp    %ebx,%eax
 69d:	74 22                	je     6c1 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 69f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 6a1:	89 0d 08 08 00 00    	mov    %ecx,0x808
}
 6a7:	5b                   	pop    %ebx
 6a8:	5e                   	pop    %esi
 6a9:	5f                   	pop    %edi
 6aa:	5d                   	pop    %ebp
 6ab:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ac:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 6af:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b1:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6b4:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6b7:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6ba:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 6bd:	39 d8                	cmp    %ebx,%eax
 6bf:	75 de                	jne    69f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6c1:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c4:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 6c7:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c9:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6cc:	89 0d 08 08 00 00    	mov    %ecx,0x808
}
 6d2:	5b                   	pop    %ebx
 6d3:	5e                   	pop    %esi
 6d4:	5f                   	pop    %edi
 6d5:	5d                   	pop    %ebp
 6d6:	c3                   	ret    
 6d7:	89 f6                	mov    %esi,%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ec:	8b 15 08 08 00 00    	mov    0x808,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	83 c0 07             	add    $0x7,%eax
 6f5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 6f8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fa:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 6fd:	0f 84 95 00 00 00    	je     798 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 703:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 705:	8b 41 04             	mov    0x4(%ecx),%eax
 708:	39 c3                	cmp    %eax,%ebx
 70a:	76 1f                	jbe    72b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 70c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 713:	90                   	nop    
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 718:	3b 0d 08 08 00 00    	cmp    0x808,%ecx
 71e:	89 ca                	mov    %ecx,%edx
 720:	74 34                	je     756 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 722:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 724:	8b 41 04             	mov    0x4(%ecx),%eax
 727:	39 c3                	cmp    %eax,%ebx
 729:	77 ed                	ja     718 <malloc+0x38>
      if(p->s.size == nunits)
 72b:	39 c3                	cmp    %eax,%ebx
 72d:	74 21                	je     750 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 72f:	29 d8                	sub    %ebx,%eax
 731:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 734:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 737:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 73a:	89 15 08 08 00 00    	mov    %edx,0x808
      return (void*) (p + 1);
 740:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 743:	83 c4 0c             	add    $0xc,%esp
 746:	5b                   	pop    %ebx
 747:	5e                   	pop    %esi
 748:	5f                   	pop    %edi
 749:	5d                   	pop    %ebp
 74a:	c3                   	ret    
 74b:	90                   	nop    
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 750:	8b 01                	mov    (%ecx),%eax
 752:	89 02                	mov    %eax,(%edx)
 754:	eb e4                	jmp    73a <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 756:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 75c:	bf 00 10 00 00       	mov    $0x1000,%edi
 761:	b8 00 80 00 00       	mov    $0x8000,%eax
 766:	76 04                	jbe    76c <malloc+0x8c>
 768:	89 df                	mov    %ebx,%edi
 76a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 dc fb ff ff       	call   350 <sbrk>
  if(p == (char*) -1)
 774:	83 f8 ff             	cmp    $0xffffffff,%eax
 777:	74 18                	je     791 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 779:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 77c:	83 c0 08             	add    $0x8,%eax
 77f:	89 04 24             	mov    %eax,(%esp)
 782:	e8 b9 fe ff ff       	call   640 <free>
  return freep;
 787:	8b 15 08 08 00 00    	mov    0x808,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 78d:	85 d2                	test   %edx,%edx
 78f:	75 91                	jne    722 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 791:	31 c0                	xor    %eax,%eax
 793:	eb ae                	jmp    743 <malloc+0x63>
 795:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 798:	c7 05 08 08 00 00 00 	movl   $0x800,0x808
 79f:	08 00 00 
    base.s.size = 0;
 7a2:	ba 00 08 00 00       	mov    $0x800,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7a7:	c7 05 00 08 00 00 00 	movl   $0x800,0x800
 7ae:	08 00 00 
    base.s.size = 0;
 7b1:	c7 05 04 08 00 00 00 	movl   $0x0,0x804
 7b8:	00 00 00 
 7bb:	e9 43 ff ff ff       	jmp    703 <malloc+0x23>
