
_rm:     file format elf32-i386

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
   d:	83 ec 28             	sub    $0x28,%esp
  10:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  13:	8b 19                	mov    (%ecx),%ebx
  15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  18:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1b:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1e:	8b 41 04             	mov    0x4(%ecx),%eax
  int i;

  if(argc < 2){
  21:	83 fb 01             	cmp    $0x1,%ebx
  24:	7f 19                	jg     3f <main+0x3f>
    printf(2, "Usage: rm files...\n");
  26:	c7 44 24 04 d0 07 00 	movl   $0x7d0,0x4(%esp)
  2d:	00 
  2e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  35:	e8 d6 03 00 00       	call   410 <printf>
    exit();
  3a:	e8 99 02 00 00       	call   2d8 <exit>
  3f:	8d 78 04             	lea    0x4(%eax),%edi
  42:	be 01 00 00 00       	mov    $0x1,%esi
  47:	90                   	nop    
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  48:	8b 07                	mov    (%edi),%eax
  4a:	89 04 24             	mov    %eax,(%esp)
  4d:	e8 d6 02 00 00       	call   328 <unlink>
  52:	85 c0                	test   %eax,%eax
  54:	78 0f                	js     65 <main+0x65>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  56:	83 c6 01             	add    $0x1,%esi
  59:	83 c7 04             	add    $0x4,%edi
  5c:	39 f3                	cmp    %esi,%ebx
  5e:	7f e8                	jg     48 <main+0x48>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  60:	e8 73 02 00 00       	call   2d8 <exit>
    exit();
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
      printf(2, "rm: %s failed to delete\n", argv[i]);
  65:	8b 07                	mov    (%edi),%eax
  67:	c7 44 24 04 e4 07 00 	movl   $0x7e4,0x4(%esp)
  6e:	00 
  6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  76:	89 44 24 08          	mov    %eax,0x8(%esp)
  7a:	e8 91 03 00 00       	call   410 <printf>
  7f:	eb df                	jmp    60 <main+0x60>
  81:	90                   	nop    
  82:	90                   	nop    
  83:	90                   	nop    
  84:	90                   	nop    
  85:	90                   	nop    
  86:	90                   	nop    
  87:	90                   	nop    
  88:	90                   	nop    
  89:	90                   	nop    
  8a:	90                   	nop    
  8b:	90                   	nop    
  8c:	90                   	nop    
  8d:	90                   	nop    
  8e:	90                   	nop    
  8f:	90                   	nop    

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  90:	55                   	push   %ebp
  91:	31 d2                	xor    %edx,%edx
  93:	89 e5                	mov    %esp,%ebp
  95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  98:	53                   	push   %ebx
  99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  9c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a0:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  a4:	88 04 13             	mov    %al,(%ebx,%edx,1)
  a7:	83 c2 01             	add    $0x1,%edx
  aa:	84 c0                	test   %al,%al
  ac:	75 f2                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  ae:	89 d8                	mov    %ebx,%eax
  b0:	5b                   	pop    %ebx
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    
  b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
  c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ca:	0f b6 02             	movzbl (%edx),%eax
  cd:	84 c0                	test   %al,%al
  cf:	75 14                	jne    e5 <strcmp+0x25>
  d1:	eb 2d                	jmp    100 <strcmp+0x40>
  d3:	90                   	nop    
  d4:	8d 74 26 00          	lea    0x0(%esi),%esi
    p++, q++;
  d8:	83 c2 01             	add    $0x1,%edx
  db:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  de:	0f b6 02             	movzbl (%edx),%eax
  e1:	84 c0                	test   %al,%al
  e3:	74 1b                	je     100 <strcmp+0x40>
  e5:	0f b6 19             	movzbl (%ecx),%ebx
  e8:	38 d8                	cmp    %bl,%al
  ea:	74 ec                	je     d8 <strcmp+0x18>
  ec:	0f b6 d0             	movzbl %al,%edx
  ef:	0f b6 c3             	movzbl %bl,%eax
  f2:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  f4:	89 d0                	mov    %edx,%eax
  f6:	5b                   	pop    %ebx
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 100:	0f b6 19             	movzbl (%ecx),%ebx
 103:	31 d2                	xor    %edx,%edx
 105:	0f b6 c3             	movzbl %bl,%eax
 108:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 10a:	89 d0                	mov    %edx,%eax
 10c:	5b                   	pop    %ebx
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    
 10f:	90                   	nop    

00000110 <strlen>:

uint
strlen(char *s)
{
 110:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 111:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 113:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 115:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 117:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 11a:	80 3a 00             	cmpb   $0x0,(%edx)
 11d:	74 0c                	je     12b <strlen+0x1b>
 11f:	90                   	nop    
 120:	83 c0 01             	add    $0x1,%eax
 123:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 127:	75 f7                	jne    120 <strlen+0x10>
 129:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 12b:	89 c8                	mov    %ecx,%eax
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
 12f:	90                   	nop    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 08             	sub    $0x8,%esp
 136:	89 1c 24             	mov    %ebx,(%esp)
 139:	8b 5d 08             	mov    0x8(%ebp),%ebx
 13c:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 140:	8b 4d 10             	mov    0x10(%ebp),%ecx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	89 df                	mov    %ebx,%edi
 148:	fc                   	cld    
 149:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 14b:	89 d8                	mov    %ebx,%eax
 14d:	8b 7c 24 04          	mov    0x4(%esp),%edi
 151:	8b 1c 24             	mov    (%esp),%ebx
 154:	89 ec                	mov    %ebp,%esp
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    
 158:	90                   	nop    
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	75 11                	jne    182 <strchr+0x22>
 171:	eb 25                	jmp    198 <strchr+0x38>
 173:	90                   	nop    
 174:	8d 74 26 00          	lea    0x0(%esi),%esi
 178:	83 c0 01             	add    $0x1,%eax
 17b:	0f b6 10             	movzbl (%eax),%edx
 17e:	84 d2                	test   %dl,%dl
 180:	74 16                	je     198 <strchr+0x38>
    if(*s == c)
 182:	38 ca                	cmp    %cl,%dl
 184:	8d 74 26 00          	lea    0x0(%esi),%esi
 188:	75 ee                	jne    178 <strchr+0x18>
      return (char*) s;
  return 0;
}
 18a:	5d                   	pop    %ebp
 18b:	90                   	nop    
 18c:	8d 74 26 00          	lea    0x0(%esi),%esi
 190:	c3                   	ret    
 191:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 198:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 19a:	5d                   	pop    %ebp
 19b:	90                   	nop    
 19c:	8d 74 26 00          	lea    0x0(%esi),%esi
 1a0:	c3                   	ret    
 1a1:	eb 0d                	jmp    1b0 <atoi>
 1a3:	90                   	nop    
 1a4:	90                   	nop    
 1a5:	90                   	nop    
 1a6:	90                   	nop    
 1a7:	90                   	nop    
 1a8:	90                   	nop    
 1a9:	90                   	nop    
 1aa:	90                   	nop    
 1ab:	90                   	nop    
 1ac:	90                   	nop    
 1ad:	90                   	nop    
 1ae:	90                   	nop    
 1af:	90                   	nop    

000001b0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1b0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b1:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	53                   	push   %ebx
 1b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b9:	0f b6 13             	movzbl (%ebx),%edx
 1bc:	8d 42 d0             	lea    -0x30(%edx),%eax
 1bf:	3c 09                	cmp    $0x9,%al
 1c1:	77 1c                	ja     1df <atoi+0x2f>
 1c3:	90                   	nop    
 1c4:	8d 74 26 00          	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 1c8:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 1cb:	0f be d2             	movsbl %dl,%edx
 1ce:	83 c3 01             	add    $0x1,%ebx
 1d1:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d5:	0f b6 13             	movzbl (%ebx),%edx
 1d8:	8d 42 d0             	lea    -0x30(%edx),%eax
 1db:	3c 09                	cmp    $0x9,%al
 1dd:	76 e9                	jbe    1c8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1df:	89 c8                	mov    %ecx,%eax
 1e1:	5b                   	pop    %ebx
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    
 1e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1f6:	56                   	push   %esi
 1f7:	8b 75 08             	mov    0x8(%ebp),%esi
 1fa:	53                   	push   %ebx
 1fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1fe:	85 c9                	test   %ecx,%ecx
 200:	7e 14                	jle    216 <memmove+0x26>
 202:	31 d2                	xor    %edx,%edx
 204:	8d 74 26 00          	lea    0x0(%esi),%esi
    *dst++ = *src++;
 208:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 20c:	88 04 16             	mov    %al,(%esi,%edx,1)
 20f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 212:	39 ca                	cmp    %ecx,%edx
 214:	75 f2                	jne    208 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 216:	89 f0                	mov    %esi,%eax
 218:	5b                   	pop    %ebx
 219:	5e                   	pop    %esi
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    
 21c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000220 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 229:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 22c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 22f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 23b:	00 
 23c:	89 04 24             	mov    %eax,(%esp)
 23f:	e8 d4 00 00 00       	call   318 <open>
  if(fd < 0)
 244:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 246:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 248:	78 19                	js     263 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 1c 24             	mov    %ebx,(%esp)
 250:	89 44 24 04          	mov    %eax,0x4(%esp)
 254:	e8 d7 00 00 00       	call   330 <fstat>
  close(fd);
 259:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 25c:	89 c6                	mov    %eax,%esi
  close(fd);
 25e:	e8 9d 00 00 00       	call   300 <close>
  return r;
}
 263:	89 f0                	mov    %esi,%eax
 265:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 268:	8b 75 fc             	mov    -0x4(%ebp),%esi
 26b:	89 ec                	mov    %ebp,%esp
 26d:	5d                   	pop    %ebp
 26e:	c3                   	ret    
 26f:	90                   	nop    

00000270 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
 275:	31 f6                	xor    %esi,%esi
 277:	53                   	push   %ebx
 278:	83 ec 1c             	sub    $0x1c,%esp
 27b:	8b 7d 08             	mov    0x8(%ebp),%edi
 27e:	eb 06                	jmp    286 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 280:	3c 0d                	cmp    $0xd,%al
 282:	74 39                	je     2bd <gets+0x4d>
 284:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 286:	8d 5e 01             	lea    0x1(%esi),%ebx
 289:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 28c:	7d 31                	jge    2bf <gets+0x4f>
    cc = read(0, &c, 1);
 28e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 291:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 298:	00 
 299:	89 44 24 04          	mov    %eax,0x4(%esp)
 29d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2a4:	e8 47 00 00 00       	call   2f0 <read>
    if(cc < 1)
 2a9:	85 c0                	test   %eax,%eax
 2ab:	7e 12                	jle    2bf <gets+0x4f>
      break;
    buf[i++] = c;
 2ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2b1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 2b5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2b9:	3c 0a                	cmp    $0xa,%al
 2bb:	75 c3                	jne    280 <gets+0x10>
 2bd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2bf:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2c3:	89 f8                	mov    %edi,%eax
 2c5:	83 c4 1c             	add    $0x1c,%esp
 2c8:	5b                   	pop    %ebx
 2c9:	5e                   	pop    %esi
 2ca:	5f                   	pop    %edi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	90                   	nop    
 2ce:	90                   	nop    
 2cf:	90                   	nop    

000002d0 <fork>:
 2d0:	b8 01 00 00 00       	mov    $0x1,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <exit>:
 2d8:	b8 02 00 00 00       	mov    $0x2,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <wait>:
 2e0:	b8 03 00 00 00       	mov    $0x3,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <pipe>:
 2e8:	b8 04 00 00 00       	mov    $0x4,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <read>:
 2f0:	b8 06 00 00 00       	mov    $0x6,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <write>:
 2f8:	b8 05 00 00 00       	mov    $0x5,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <close>:
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <kill>:
 308:	b8 08 00 00 00       	mov    $0x8,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <exec>:
 310:	b8 09 00 00 00       	mov    $0x9,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <open>:
 318:	b8 0a 00 00 00       	mov    $0xa,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <mknod>:
 320:	b8 0b 00 00 00       	mov    $0xb,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <unlink>:
 328:	b8 0c 00 00 00       	mov    $0xc,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <fstat>:
 330:	b8 0d 00 00 00       	mov    $0xd,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <link>:
 338:	b8 0e 00 00 00       	mov    $0xe,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <mkdir>:
 340:	b8 0f 00 00 00       	mov    $0xf,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <chdir>:
 348:	b8 10 00 00 00       	mov    $0x10,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <dup>:
 350:	b8 11 00 00 00       	mov    $0x11,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <getpid>:
 358:	b8 12 00 00 00       	mov    $0x12,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <sbrk>:
 360:	b8 13 00 00 00       	mov    $0x13,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <sleep>:
 368:	b8 14 00 00 00       	mov    $0x14,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	89 ce                	mov    %ecx,%esi
 377:	53                   	push   %ebx
 378:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 37e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 381:	85 c9                	test   %ecx,%ecx
 383:	74 04                	je     389 <printint+0x19>
 385:	85 d2                	test   %edx,%edx
 387:	78 77                	js     400 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 389:	89 d0                	mov    %edx,%eax
 38b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 392:	31 db                	xor    %ebx,%ebx
 394:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 397:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 398:	31 d2                	xor    %edx,%edx
 39a:	f7 f6                	div    %esi
 39c:	89 c1                	mov    %eax,%ecx
 39e:	0f b6 82 04 08 00 00 	movzbl 0x804(%edx),%eax
 3a5:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 3a8:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 3ab:	85 c9                	test   %ecx,%ecx
 3ad:	89 c8                	mov    %ecx,%eax
 3af:	75 e7                	jne    398 <printint+0x28>
  if(neg)
 3b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
 3b4:	85 c0                	test   %eax,%eax
 3b6:	74 08                	je     3c0 <printint+0x50>
    buf[i++] = '-';
 3b8:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 3bd:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 3c0:	8d 73 ff             	lea    -0x1(%ebx),%esi
 3c3:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 3c6:	8d 7d f3             	lea    -0xd(%ebp),%edi
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3d0:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3d3:	83 ee 01             	sub    $0x1,%esi
 3d6:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3e0:	00 
 3e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 3e5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
 3eb:	89 04 24             	mov    %eax,(%esp)
 3ee:	e8 05 ff ff ff       	call   2f8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3f3:	83 fe ff             	cmp    $0xffffffff,%esi
 3f6:	75 d8                	jne    3d0 <printint+0x60>
    putc(fd, buf[i]);
}
 3f8:	83 c4 3c             	add    $0x3c,%esp
 3fb:	5b                   	pop    %ebx
 3fc:	5e                   	pop    %esi
 3fd:	5f                   	pop    %edi
 3fe:	5d                   	pop    %ebp
 3ff:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 400:	89 d0                	mov    %edx,%eax
 402:	f7 d8                	neg    %eax
 404:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 40b:	eb 85                	jmp    392 <printint+0x22>
 40d:	8d 76 00             	lea    0x0(%esi),%esi

00000410 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 419:	8b 55 0c             	mov    0xc(%ebp),%edx
 41c:	0f b6 02             	movzbl (%edx),%eax
 41f:	84 c0                	test   %al,%al
 421:	0f 84 e9 00 00 00    	je     510 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 427:	8d 4d 10             	lea    0x10(%ebp),%ecx
 42a:	31 ff                	xor    %edi,%edi
 42c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 42f:	31 f6                	xor    %esi,%esi
 431:	eb 21                	jmp    454 <printf+0x44>
 433:	90                   	nop    
 434:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 438:	83 fb 25             	cmp    $0x25,%ebx
 43b:	0f 85 d7 00 00 00    	jne    518 <printf+0x108>
 441:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 445:	83 c7 01             	add    $0x1,%edi
 448:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 44c:	84 c0                	test   %al,%al
 44e:	0f 84 bc 00 00 00    	je     510 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 454:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 456:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 459:	74 dd                	je     438 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45b:	83 fe 25             	cmp    $0x25,%esi
 45e:	75 e5                	jne    445 <printf+0x35>
      if(c == 'd'){
 460:	83 fb 64             	cmp    $0x64,%ebx
 463:	90                   	nop    
 464:	8d 74 26 00          	lea    0x0(%esi),%esi
 468:	0f 84 52 01 00 00    	je     5c0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 46e:	83 fb 78             	cmp    $0x78,%ebx
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 478:	0f 84 c2 00 00 00    	je     540 <printf+0x130>
 47e:	83 fb 70             	cmp    $0x70,%ebx
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 488:	0f 84 b2 00 00 00    	je     540 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 48e:	83 fb 73             	cmp    $0x73,%ebx
 491:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 498:	0f 84 ca 00 00 00    	je     568 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 49e:	83 fb 63             	cmp    $0x63,%ebx
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 4a8:	0f 84 62 01 00 00    	je     610 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ae:	83 fb 25             	cmp    $0x25,%ebx
 4b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 4b8:	0f 84 2a 01 00 00    	je     5e8 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4be:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4c1:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c4:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c7:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4cb:	31 f6                	xor    %esi,%esi
 4cd:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d8:	00 
 4d9:	89 0c 24             	mov    %ecx,(%esp)
 4dc:	e8 17 fe ff ff       	call   2f8 <write>
 4e1:	8b 55 08             	mov    0x8(%ebp),%edx
 4e4:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4e7:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ea:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f1:	00 
 4f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f6:	89 14 24             	mov    %edx,(%esp)
 4f9:	e8 fa fd ff ff       	call   2f8 <write>
 4fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 501:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 505:	84 c0                	test   %al,%al
 507:	0f 85 47 ff ff ff    	jne    454 <printf+0x44>
 50d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 510:	83 c4 2c             	add    $0x2c,%esp
 513:	5b                   	pop    %ebx
 514:	5e                   	pop    %esi
 515:	5f                   	pop    %edi
 516:	5d                   	pop    %ebp
 517:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 518:	8b 55 08             	mov    0x8(%ebp),%edx
 51b:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 51e:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 521:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	89 14 24             	mov    %edx,(%esp)
 530:	e8 c3 fd ff ff       	call   2f8 <write>
 535:	8b 55 0c             	mov    0xc(%ebp),%edx
 538:	e9 08 ff ff ff       	jmp    445 <printf+0x35>
 53d:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 540:	8b 45 e0             	mov    -0x20(%ebp),%eax
 543:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 548:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 54a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 551:	8b 10                	mov    (%eax),%edx
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	e8 15 fe ff ff       	call   370 <printint>
 55b:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 55e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 562:	e9 de fe ff ff       	jmp    445 <printf+0x35>
 567:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 568:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 56b:	8b 19                	mov    (%ecx),%ebx
        ap++;
 56d:	83 c1 04             	add    $0x4,%ecx
 570:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 573:	85 db                	test   %ebx,%ebx
 575:	0f 84 c5 00 00 00    	je     640 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 57b:	0f b6 03             	movzbl (%ebx),%eax
 57e:	84 c0                	test   %al,%al
 580:	74 30                	je     5b2 <printf+0x1a2>
 582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 588:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 58b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 58e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 591:	8d 45 f3             	lea    -0xd(%ebp),%eax
 594:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 59b:	00 
 59c:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a0:	89 14 24             	mov    %edx,(%esp)
 5a3:	e8 50 fd ff ff       	call   2f8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a8:	0f b6 03             	movzbl (%ebx),%eax
 5ab:	84 c0                	test   %al,%al
 5ad:	75 d9                	jne    588 <printf+0x178>
 5af:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b2:	31 f6                	xor    %esi,%esi
 5b4:	e9 8c fe ff ff       	jmp    445 <printf+0x35>
 5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5c8:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5d2:	8b 10                	mov    (%eax),%edx
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	e8 94 fd ff ff       	call   370 <printint>
 5dc:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 5df:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 5e3:	e9 5d fe ff ff       	jmp    445 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 5ee:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 5f0:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5fb:	00 
 5fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 600:	89 04 24             	mov    %eax,(%esp)
 603:	e8 f0 fc ff ff       	call   2f8 <write>
 608:	8b 55 0c             	mov    0xc(%ebp),%edx
 60b:	e9 35 fe ff ff       	jmp    445 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 610:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 613:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 615:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 618:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61a:	89 14 24             	mov    %edx,(%esp)
 61d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 624:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 625:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 628:	8d 45 f3             	lea    -0xd(%ebp),%eax
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	e8 c4 fc ff ff       	call   2f8 <write>
 634:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 637:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 63b:	e9 05 fe ff ff       	jmp    445 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 640:	bb fd 07 00 00       	mov    $0x7fd,%ebx
 645:	e9 31 ff ff ff       	jmp    57b <printf+0x16b>
 64a:	90                   	nop    
 64b:	90                   	nop    
 64c:	90                   	nop    
 64d:	90                   	nop    
 64e:	90                   	nop    
 64f:	90                   	nop    

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	8b 0d 20 08 00 00    	mov    0x820,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 657:	89 e5                	mov    %esp,%ebp
 659:	57                   	push   %edi
 65a:	56                   	push   %esi
 65b:	53                   	push   %ebx
 65c:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 65f:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 662:	39 d9                	cmp    %ebx,%ecx
 664:	73 24                	jae    68a <free+0x3a>
 666:	66 90                	xchg   %ax,%ax
 668:	8b 11                	mov    (%ecx),%edx
 66a:	39 d3                	cmp    %edx,%ebx
 66c:	72 2a                	jb     698 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66e:	39 d1                	cmp    %edx,%ecx
 670:	72 10                	jb     682 <free+0x32>
 672:	39 d9                	cmp    %ebx,%ecx
 674:	8d 74 26 00          	lea    0x0(%esi),%esi
 678:	72 1e                	jb     698 <free+0x48>
 67a:	39 d3                	cmp    %edx,%ebx
 67c:	8d 74 26 00          	lea    0x0(%esi),%esi
 680:	72 16                	jb     698 <free+0x48>
 682:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 684:	39 d9                	cmp    %ebx,%ecx
 686:	66 90                	xchg   %ax,%ax
 688:	72 de                	jb     668 <free+0x18>
 68a:	8b 11                	mov    (%ecx),%edx
 68c:	8d 74 26 00          	lea    0x0(%esi),%esi
 690:	eb dc                	jmp    66e <free+0x1e>
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 73 04             	mov    0x4(%ebx),%esi
 69b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 69e:	39 d0                	cmp    %edx,%eax
 6a0:	74 1a                	je     6bc <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 6a5:	8b 51 04             	mov    0x4(%ecx),%edx
 6a8:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 6ab:	39 d8                	cmp    %ebx,%eax
 6ad:	74 22                	je     6d1 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6af:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 6b1:	89 0d 20 08 00 00    	mov    %ecx,0x820
}
 6b7:	5b                   	pop    %ebx
 6b8:	5e                   	pop    %esi
 6b9:	5f                   	pop    %edi
 6ba:	5d                   	pop    %ebp
 6bb:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6bc:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 6bf:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6c1:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c4:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6c7:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6ca:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 6cd:	39 d8                	cmp    %ebx,%eax
 6cf:	75 de                	jne    6af <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6d1:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6d4:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 6d7:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6d9:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6dc:	89 0d 20 08 00 00    	mov    %ecx,0x820
}
 6e2:	5b                   	pop    %ebx
 6e3:	5e                   	pop    %esi
 6e4:	5f                   	pop    %edi
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret    
 6e7:	89 f6                	mov    %esi,%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6fc:	8b 15 20 08 00 00    	mov    0x820,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	83 c0 07             	add    $0x7,%eax
 705:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 708:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 70d:	0f 84 95 00 00 00    	je     7a8 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 713:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 715:	8b 41 04             	mov    0x4(%ecx),%eax
 718:	39 c3                	cmp    %eax,%ebx
 71a:	76 1f                	jbe    73b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 71c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 723:	90                   	nop    
 724:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
    if(p == freep)
 728:	3b 0d 20 08 00 00    	cmp    0x820,%ecx
 72e:	89 ca                	mov    %ecx,%edx
 730:	74 34                	je     766 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 732:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 734:	8b 41 04             	mov    0x4(%ecx),%eax
 737:	39 c3                	cmp    %eax,%ebx
 739:	77 ed                	ja     728 <malloc+0x38>
      if(p->s.size == nunits)
 73b:	39 c3                	cmp    %eax,%ebx
 73d:	74 21                	je     760 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 73f:	29 d8                	sub    %ebx,%eax
 741:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 744:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 747:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 74a:	89 15 20 08 00 00    	mov    %edx,0x820
      return (void*) (p + 1);
 750:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 753:	83 c4 0c             	add    $0xc,%esp
 756:	5b                   	pop    %ebx
 757:	5e                   	pop    %esi
 758:	5f                   	pop    %edi
 759:	5d                   	pop    %ebp
 75a:	c3                   	ret    
 75b:	90                   	nop    
 75c:	8d 74 26 00          	lea    0x0(%esi),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 760:	8b 01                	mov    (%ecx),%eax
 762:	89 02                	mov    %eax,(%edx)
 764:	eb e4                	jmp    74a <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 766:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 76c:	bf 00 10 00 00       	mov    $0x1000,%edi
 771:	b8 00 80 00 00       	mov    $0x8000,%eax
 776:	76 04                	jbe    77c <malloc+0x8c>
 778:	89 df                	mov    %ebx,%edi
 77a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 77c:	89 04 24             	mov    %eax,(%esp)
 77f:	e8 dc fb ff ff       	call   360 <sbrk>
  if(p == (char*) -1)
 784:	83 f8 ff             	cmp    $0xffffffff,%eax
 787:	74 18                	je     7a1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 789:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 78c:	83 c0 08             	add    $0x8,%eax
 78f:	89 04 24             	mov    %eax,(%esp)
 792:	e8 b9 fe ff ff       	call   650 <free>
  return freep;
 797:	8b 15 20 08 00 00    	mov    0x820,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 79d:	85 d2                	test   %edx,%edx
 79f:	75 91                	jne    732 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7a1:	31 c0                	xor    %eax,%eax
 7a3:	eb ae                	jmp    753 <malloc+0x63>
 7a5:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7a8:	c7 05 20 08 00 00 18 	movl   $0x818,0x820
 7af:	08 00 00 
    base.s.size = 0;
 7b2:	ba 18 08 00 00       	mov    $0x818,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7b7:	c7 05 18 08 00 00 18 	movl   $0x818,0x818
 7be:	08 00 00 
    base.s.size = 0;
 7c1:	c7 05 1c 08 00 00 00 	movl   $0x0,0x81c
 7c8:	00 00 00 
 7cb:	e9 43 ff ff ff       	jmp    713 <malloc+0x23>
