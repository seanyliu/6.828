
_kill:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	83 ec 18             	sub    $0x18,%esp
  10:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  13:	8b 19                	mov    (%ecx),%ebx
  15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  18:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1b:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1e:	8b 71 04             	mov    0x4(%ecx),%esi
  int i;

  if(argc < 1){
  21:	85 db                	test   %ebx,%ebx
  23:	7f 19                	jg     3e <main+0x3e>
    printf(2, "usage: kill pid...\n");
  25:	c7 44 24 04 b0 07 00 	movl   $0x7b0,0x4(%esp)
  2c:	00 
  2d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  34:	e8 b7 03 00 00       	call   3f0 <printf>
    exit();
  39:	e8 7a 02 00 00       	call   2b8 <exit>
  }
  for(i=1; i<argc; i++)
  3e:	83 fb 01             	cmp    $0x1,%ebx
{
  int i;

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  41:	bf 01 00 00 00       	mov    $0x1,%edi
  }
  for(i=1; i<argc; i++)
  46:	74 1a                	je     62 <main+0x62>
    kill(atoi(argv[i]));
  48:	8b 04 be             	mov    (%esi,%edi,4),%eax

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  4b:	83 c7 01             	add    $0x1,%edi
    kill(atoi(argv[i]));
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 3a 01 00 00       	call   190 <atoi>
  56:	89 04 24             	mov    %eax,(%esp)
  59:	e8 8a 02 00 00       	call   2e8 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  5e:	39 fb                	cmp    %edi,%ebx
  60:	7f e6                	jg     48 <main+0x48>
    kill(atoi(argv[i]));
  exit();
  62:	e8 51 02 00 00       	call   2b8 <exit>
  67:	90                   	nop    
  68:	90                   	nop    
  69:	90                   	nop    
  6a:	90                   	nop    
  6b:	90                   	nop    
  6c:	90                   	nop    
  6d:	90                   	nop    
  6e:	90                   	nop    
  6f:	90                   	nop    

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  70:	55                   	push   %ebp
  71:	31 d2                	xor    %edx,%edx
  73:	89 e5                	mov    %esp,%ebp
  75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  78:	53                   	push   %ebx
  79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  7c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  84:	88 04 13             	mov    %al,(%ebx,%edx,1)
  87:	83 c2 01             	add    $0x1,%edx
  8a:	84 c0                	test   %al,%al
  8c:	75 f2                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  8e:	89 d8                	mov    %ebx,%eax
  90:	5b                   	pop    %ebx
  91:	5d                   	pop    %ebp
  92:	c3                   	ret    
  93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  99:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 55 08             	mov    0x8(%ebp),%edx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	84 c0                	test   %al,%al
  af:	75 14                	jne    c5 <strcmp+0x25>
  b1:	eb 2d                	jmp    e0 <strcmp+0x40>
  b3:	90                   	nop    
  b4:	8d 74 26 00          	lea    0x0(%esi),%esi
    p++, q++;
  b8:	83 c2 01             	add    $0x1,%edx
  bb:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  be:	0f b6 02             	movzbl (%edx),%eax
  c1:	84 c0                	test   %al,%al
  c3:	74 1b                	je     e0 <strcmp+0x40>
  c5:	0f b6 19             	movzbl (%ecx),%ebx
  c8:	38 d8                	cmp    %bl,%al
  ca:	74 ec                	je     b8 <strcmp+0x18>
  cc:	0f b6 d0             	movzbl %al,%edx
  cf:	0f b6 c3             	movzbl %bl,%eax
  d2:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  d4:	89 d0                	mov    %edx,%eax
  d6:	5b                   	pop    %ebx
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e0:	0f b6 19             	movzbl (%ecx),%ebx
  e3:	31 d2                	xor    %edx,%edx
  e5:	0f b6 c3             	movzbl %bl,%eax
  e8:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  ea:	89 d0                	mov    %edx,%eax
  ec:	5b                   	pop    %ebx
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    
  ef:	90                   	nop    

000000f0 <strlen>:

uint
strlen(char *s)
{
  f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  f1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  f3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
  f5:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  f7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  fa:	80 3a 00             	cmpb   $0x0,(%edx)
  fd:	74 0c                	je     10b <strlen+0x1b>
  ff:	90                   	nop    
 100:	83 c0 01             	add    $0x1,%eax
 103:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 107:	75 f7                	jne    100 <strlen+0x10>
 109:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 10b:	89 c8                	mov    %ecx,%eax
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    
 10f:	90                   	nop    

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 ec 08             	sub    $0x8,%esp
 116:	89 1c 24             	mov    %ebx,(%esp)
 119:	8b 5d 08             	mov    0x8(%ebp),%ebx
 11c:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 120:	8b 4d 10             	mov    0x10(%ebp),%ecx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 df                	mov    %ebx,%edi
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 12b:	89 d8                	mov    %ebx,%eax
 12d:	8b 7c 24 04          	mov    0x4(%esp),%edi
 131:	8b 1c 24             	mov    (%esp),%ebx
 134:	89 ec                	mov    %ebp,%esp
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    
 138:	90                   	nop    
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 11                	jne    162 <strchr+0x22>
 151:	eb 25                	jmp    178 <strchr+0x38>
 153:	90                   	nop    
 154:	8d 74 26 00          	lea    0x0(%esi),%esi
 158:	83 c0 01             	add    $0x1,%eax
 15b:	0f b6 10             	movzbl (%eax),%edx
 15e:	84 d2                	test   %dl,%dl
 160:	74 16                	je     178 <strchr+0x38>
    if(*s == c)
 162:	38 ca                	cmp    %cl,%dl
 164:	8d 74 26 00          	lea    0x0(%esi),%esi
 168:	75 ee                	jne    158 <strchr+0x18>
      return (char*) s;
  return 0;
}
 16a:	5d                   	pop    %ebp
 16b:	90                   	nop    
 16c:	8d 74 26 00          	lea    0x0(%esi),%esi
 170:	c3                   	ret    
 171:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 178:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 17a:	5d                   	pop    %ebp
 17b:	90                   	nop    
 17c:	8d 74 26 00          	lea    0x0(%esi),%esi
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <atoi>
 183:	90                   	nop    
 184:	90                   	nop    
 185:	90                   	nop    
 186:	90                   	nop    
 187:	90                   	nop    
 188:	90                   	nop    
 189:	90                   	nop    
 18a:	90                   	nop    
 18b:	90                   	nop    
 18c:	90                   	nop    
 18d:	90                   	nop    
 18e:	90                   	nop    
 18f:	90                   	nop    

00000190 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 190:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 191:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 193:	89 e5                	mov    %esp,%ebp
 195:	53                   	push   %ebx
 196:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 199:	0f b6 13             	movzbl (%ebx),%edx
 19c:	8d 42 d0             	lea    -0x30(%edx),%eax
 19f:	3c 09                	cmp    $0x9,%al
 1a1:	77 1c                	ja     1bf <atoi+0x2f>
 1a3:	90                   	nop    
 1a4:	8d 74 26 00          	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 1a8:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 1ab:	0f be d2             	movsbl %dl,%edx
 1ae:	83 c3 01             	add    $0x1,%ebx
 1b1:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b5:	0f b6 13             	movzbl (%ebx),%edx
 1b8:	8d 42 d0             	lea    -0x30(%edx),%eax
 1bb:	3c 09                	cmp    $0x9,%al
 1bd:	76 e9                	jbe    1a8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1bf:	89 c8                	mov    %ecx,%eax
 1c1:	5b                   	pop    %ebx
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1d6:	56                   	push   %esi
 1d7:	8b 75 08             	mov    0x8(%ebp),%esi
 1da:	53                   	push   %ebx
 1db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1de:	85 c9                	test   %ecx,%ecx
 1e0:	7e 14                	jle    1f6 <memmove+0x26>
 1e2:	31 d2                	xor    %edx,%edx
 1e4:	8d 74 26 00          	lea    0x0(%esi),%esi
    *dst++ = *src++;
 1e8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 1ec:	88 04 16             	mov    %al,(%esi,%edx,1)
 1ef:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f2:	39 ca                	cmp    %ecx,%edx
 1f4:	75 f2                	jne    1e8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1f6:	89 f0                	mov    %esi,%eax
 1f8:	5b                   	pop    %ebx
 1f9:	5e                   	pop    %esi
 1fa:	5d                   	pop    %ebp
 1fb:	c3                   	ret    
 1fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00000200 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 209:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 20c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 20f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21b:	00 
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 d4 00 00 00       	call   2f8 <open>
  if(fd < 0)
 224:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 228:	78 19                	js     243 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 1c 24             	mov    %ebx,(%esp)
 230:	89 44 24 04          	mov    %eax,0x4(%esp)
 234:	e8 d7 00 00 00       	call   310 <fstat>
  close(fd);
 239:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 23c:	89 c6                	mov    %eax,%esi
  close(fd);
 23e:	e8 9d 00 00 00       	call   2e0 <close>
  return r;
}
 243:	89 f0                	mov    %esi,%eax
 245:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 248:	8b 75 fc             	mov    -0x4(%ebp),%esi
 24b:	89 ec                	mov    %ebp,%esp
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret    
 24f:	90                   	nop    

00000250 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
 255:	31 f6                	xor    %esi,%esi
 257:	53                   	push   %ebx
 258:	83 ec 1c             	sub    $0x1c,%esp
 25b:	8b 7d 08             	mov    0x8(%ebp),%edi
 25e:	eb 06                	jmp    266 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 260:	3c 0d                	cmp    $0xd,%al
 262:	74 39                	je     29d <gets+0x4d>
 264:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 266:	8d 5e 01             	lea    0x1(%esi),%ebx
 269:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 26c:	7d 31                	jge    29f <gets+0x4f>
    cc = read(0, &c, 1);
 26e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 271:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 278:	00 
 279:	89 44 24 04          	mov    %eax,0x4(%esp)
 27d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 284:	e8 47 00 00 00       	call   2d0 <read>
    if(cc < 1)
 289:	85 c0                	test   %eax,%eax
 28b:	7e 12                	jle    29f <gets+0x4f>
      break;
    buf[i++] = c;
 28d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 291:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 299:	3c 0a                	cmp    $0xa,%al
 29b:	75 c3                	jne    260 <gets+0x10>
 29d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 29f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2a3:	89 f8                	mov    %edi,%eax
 2a5:	83 c4 1c             	add    $0x1c,%esp
 2a8:	5b                   	pop    %ebx
 2a9:	5e                   	pop    %esi
 2aa:	5f                   	pop    %edi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	90                   	nop    
 2ae:	90                   	nop    
 2af:	90                   	nop    

000002b0 <fork>:
 2b0:	b8 01 00 00 00       	mov    $0x1,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <exit>:
 2b8:	b8 02 00 00 00       	mov    $0x2,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <wait>:
 2c0:	b8 03 00 00 00       	mov    $0x3,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <pipe>:
 2c8:	b8 04 00 00 00       	mov    $0x4,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <read>:
 2d0:	b8 06 00 00 00       	mov    $0x6,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <write>:
 2d8:	b8 05 00 00 00       	mov    $0x5,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <close>:
 2e0:	b8 07 00 00 00       	mov    $0x7,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <kill>:
 2e8:	b8 08 00 00 00       	mov    $0x8,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <exec>:
 2f0:	b8 09 00 00 00       	mov    $0x9,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <open>:
 2f8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <mknod>:
 300:	b8 0b 00 00 00       	mov    $0xb,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <unlink>:
 308:	b8 0c 00 00 00       	mov    $0xc,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <fstat>:
 310:	b8 0d 00 00 00       	mov    $0xd,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <link>:
 318:	b8 0e 00 00 00       	mov    $0xe,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <mkdir>:
 320:	b8 0f 00 00 00       	mov    $0xf,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <chdir>:
 328:	b8 10 00 00 00       	mov    $0x10,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <dup>:
 330:	b8 11 00 00 00       	mov    $0x11,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <getpid>:
 338:	b8 12 00 00 00       	mov    $0x12,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <sbrk>:
 340:	b8 13 00 00 00       	mov    $0x13,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sleep>:
 348:	b8 14 00 00 00       	mov    $0x14,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	89 ce                	mov    %ecx,%esi
 357:	53                   	push   %ebx
 358:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 35e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 361:	85 c9                	test   %ecx,%ecx
 363:	74 04                	je     369 <printint+0x19>
 365:	85 d2                	test   %edx,%edx
 367:	78 77                	js     3e0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 369:	89 d0                	mov    %edx,%eax
 36b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 372:	31 db                	xor    %ebx,%ebx
 374:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 377:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 378:	31 d2                	xor    %edx,%edx
 37a:	f7 f6                	div    %esi
 37c:	89 c1                	mov    %eax,%ecx
 37e:	0f b6 82 cb 07 00 00 	movzbl 0x7cb(%edx),%eax
 385:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 388:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 38b:	85 c9                	test   %ecx,%ecx
 38d:	89 c8                	mov    %ecx,%eax
 38f:	75 e7                	jne    378 <printint+0x28>
  if(neg)
 391:	8b 45 d0             	mov    -0x30(%ebp),%eax
 394:	85 c0                	test   %eax,%eax
 396:	74 08                	je     3a0 <printint+0x50>
    buf[i++] = '-';
 398:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 39d:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 3a0:	8d 73 ff             	lea    -0x1(%ebx),%esi
 3a3:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 3a6:	8d 7d f3             	lea    -0xd(%ebp),%edi
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3b0:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3b3:	83 ee 01             	sub    $0x1,%esi
 3b6:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3b9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c0:	00 
 3c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 3c5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
 3cb:	89 04 24             	mov    %eax,(%esp)
 3ce:	e8 05 ff ff ff       	call   2d8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3d3:	83 fe ff             	cmp    $0xffffffff,%esi
 3d6:	75 d8                	jne    3b0 <printint+0x60>
    putc(fd, buf[i]);
}
 3d8:	83 c4 3c             	add    $0x3c,%esp
 3db:	5b                   	pop    %ebx
 3dc:	5e                   	pop    %esi
 3dd:	5f                   	pop    %edi
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3e0:	89 d0                	mov    %edx,%eax
 3e2:	f7 d8                	neg    %eax
 3e4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 3eb:	eb 85                	jmp    372 <printint+0x22>
 3ed:	8d 76 00             	lea    0x0(%esi),%esi

000003f0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 3fc:	0f b6 02             	movzbl (%edx),%eax
 3ff:	84 c0                	test   %al,%al
 401:	0f 84 e9 00 00 00    	je     4f0 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 407:	8d 4d 10             	lea    0x10(%ebp),%ecx
 40a:	31 ff                	xor    %edi,%edi
 40c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 40f:	31 f6                	xor    %esi,%esi
 411:	eb 21                	jmp    434 <printf+0x44>
 413:	90                   	nop    
 414:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 418:	83 fb 25             	cmp    $0x25,%ebx
 41b:	0f 85 d7 00 00 00    	jne    4f8 <printf+0x108>
 421:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 425:	83 c7 01             	add    $0x1,%edi
 428:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 42c:	84 c0                	test   %al,%al
 42e:	0f 84 bc 00 00 00    	je     4f0 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 434:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 436:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 439:	74 dd                	je     418 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 43b:	83 fe 25             	cmp    $0x25,%esi
 43e:	75 e5                	jne    425 <printf+0x35>
      if(c == 'd'){
 440:	83 fb 64             	cmp    $0x64,%ebx
 443:	90                   	nop    
 444:	8d 74 26 00          	lea    0x0(%esi),%esi
 448:	0f 84 52 01 00 00    	je     5a0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 44e:	83 fb 78             	cmp    $0x78,%ebx
 451:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 458:	0f 84 c2 00 00 00    	je     520 <printf+0x130>
 45e:	83 fb 70             	cmp    $0x70,%ebx
 461:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 468:	0f 84 b2 00 00 00    	je     520 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 46e:	83 fb 73             	cmp    $0x73,%ebx
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 478:	0f 84 ca 00 00 00    	je     548 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 47e:	83 fb 63             	cmp    $0x63,%ebx
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 488:	0f 84 62 01 00 00    	je     5f0 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 48e:	83 fb 25             	cmp    $0x25,%ebx
 491:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 498:	0f 84 2a 01 00 00    	je     5c8 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 49e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4a1:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a4:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a7:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ab:	31 f6                	xor    %esi,%esi
 4ad:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b8:	00 
 4b9:	89 0c 24             	mov    %ecx,(%esp)
 4bc:	e8 17 fe ff ff       	call   2d8 <write>
 4c1:	8b 55 08             	mov    0x8(%ebp),%edx
 4c4:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4c7:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d1:	00 
 4d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d6:	89 14 24             	mov    %edx,(%esp)
 4d9:	e8 fa fd ff ff       	call   2d8 <write>
 4de:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e1:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 4e5:	84 c0                	test   %al,%al
 4e7:	0f 85 47 ff ff ff    	jne    434 <printf+0x44>
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4f0:	83 c4 2c             	add    $0x2c,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8b 55 08             	mov    0x8(%ebp),%edx
 4fb:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4fe:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 501:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 508:	00 
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	89 14 24             	mov    %edx,(%esp)
 510:	e8 c3 fd ff ff       	call   2d8 <write>
 515:	8b 55 0c             	mov    0xc(%ebp),%edx
 518:	e9 08 ff ff ff       	jmp    425 <printf+0x35>
 51d:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 520:	8b 45 e0             	mov    -0x20(%ebp),%eax
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 528:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 52a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 531:	8b 10                	mov    (%eax),%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 15 fe ff ff       	call   350 <printint>
 53b:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 53e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 542:	e9 de fe ff ff       	jmp    425 <printf+0x35>
 547:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 548:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 54b:	8b 19                	mov    (%ecx),%ebx
        ap++;
 54d:	83 c1 04             	add    $0x4,%ecx
 550:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 553:	85 db                	test   %ebx,%ebx
 555:	0f 84 c5 00 00 00    	je     620 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 55b:	0f b6 03             	movzbl (%ebx),%eax
 55e:	84 c0                	test   %al,%al
 560:	74 30                	je     592 <printf+0x1a2>
 562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 568:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 56b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 56e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 571:	8d 45 f3             	lea    -0xd(%ebp),%eax
 574:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 57b:	00 
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	89 14 24             	mov    %edx,(%esp)
 583:	e8 50 fd ff ff       	call   2d8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 588:	0f b6 03             	movzbl (%ebx),%eax
 58b:	84 c0                	test   %al,%al
 58d:	75 d9                	jne    568 <printf+0x178>
 58f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 592:	31 f6                	xor    %esi,%esi
 594:	e9 8c fe ff ff       	jmp    425 <printf+0x35>
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5a8:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5b2:	8b 10                	mov    (%eax),%edx
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	e8 94 fd ff ff       	call   350 <printint>
 5bc:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 5bf:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 5c3:	e9 5d fe ff ff       	jmp    425 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 5ce:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 5d0:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5db:	00 
 5dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 5e0:	89 04 24             	mov    %eax,(%esp)
 5e3:	e8 f0 fc ff ff       	call   2d8 <write>
 5e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5eb:	e9 35 fe ff ff       	jmp    425 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 5f3:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f5:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5f8:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5fa:	89 14 24             	mov    %edx,(%esp)
 5fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 604:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 605:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 608:	8d 45 f3             	lea    -0xd(%ebp),%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	e8 c4 fc ff ff       	call   2d8 <write>
 614:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 617:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 61b:	e9 05 fe ff ff       	jmp    425 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 620:	bb c4 07 00 00       	mov    $0x7c4,%ebx
 625:	e9 31 ff ff ff       	jmp    55b <printf+0x16b>
 62a:	90                   	nop    
 62b:	90                   	nop    
 62c:	90                   	nop    
 62d:	90                   	nop    
 62e:	90                   	nop    
 62f:	90                   	nop    

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	8b 0d e4 07 00 00    	mov    0x7e4,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 637:	89 e5                	mov    %esp,%ebp
 639:	57                   	push   %edi
 63a:	56                   	push   %esi
 63b:	53                   	push   %ebx
 63c:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 63f:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 642:	39 d9                	cmp    %ebx,%ecx
 644:	73 24                	jae    66a <free+0x3a>
 646:	66 90                	xchg   %ax,%ax
 648:	8b 11                	mov    (%ecx),%edx
 64a:	39 d3                	cmp    %edx,%ebx
 64c:	72 2a                	jb     678 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64e:	39 d1                	cmp    %edx,%ecx
 650:	72 10                	jb     662 <free+0x32>
 652:	39 d9                	cmp    %ebx,%ecx
 654:	8d 74 26 00          	lea    0x0(%esi),%esi
 658:	72 1e                	jb     678 <free+0x48>
 65a:	39 d3                	cmp    %edx,%ebx
 65c:	8d 74 26 00          	lea    0x0(%esi),%esi
 660:	72 16                	jb     678 <free+0x48>
 662:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 664:	39 d9                	cmp    %ebx,%ecx
 666:	66 90                	xchg   %ax,%ax
 668:	72 de                	jb     648 <free+0x18>
 66a:	8b 11                	mov    (%ecx),%edx
 66c:	8d 74 26 00          	lea    0x0(%esi),%esi
 670:	eb dc                	jmp    64e <free+0x1e>
 672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 678:	8b 73 04             	mov    0x4(%ebx),%esi
 67b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 67e:	39 d0                	cmp    %edx,%eax
 680:	74 1a                	je     69c <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 682:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 685:	8b 51 04             	mov    0x4(%ecx),%edx
 688:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 68b:	39 d8                	cmp    %ebx,%eax
 68d:	74 22                	je     6b1 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 68f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 691:	89 0d e4 07 00 00    	mov    %ecx,0x7e4
}
 697:	5b                   	pop    %ebx
 698:	5e                   	pop    %esi
 699:	5f                   	pop    %edi
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69c:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 69f:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a1:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6a4:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6a7:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6aa:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 6ad:	39 d8                	cmp    %ebx,%eax
 6af:	75 de                	jne    68f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6b1:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6b4:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 6b7:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6b9:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6bc:	89 0d e4 07 00 00    	mov    %ecx,0x7e4
}
 6c2:	5b                   	pop    %ebx
 6c3:	5e                   	pop    %esi
 6c4:	5f                   	pop    %edi
 6c5:	5d                   	pop    %ebp
 6c6:	c3                   	ret    
 6c7:	89 f6                	mov    %esi,%esi
 6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6dc:	8b 15 e4 07 00 00    	mov    0x7e4,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	83 c0 07             	add    $0x7,%eax
 6e5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 6e8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ea:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 6ed:	0f 84 95 00 00 00    	je     788 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6f5:	8b 41 04             	mov    0x4(%ecx),%eax
 6f8:	39 c3                	cmp    %eax,%ebx
 6fa:	76 1f                	jbe    71b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 6fc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 703:	90                   	nop    
 704:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
    if(p == freep)
 708:	3b 0d e4 07 00 00    	cmp    0x7e4,%ecx
 70e:	89 ca                	mov    %ecx,%edx
 710:	74 34                	je     746 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 712:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 714:	8b 41 04             	mov    0x4(%ecx),%eax
 717:	39 c3                	cmp    %eax,%ebx
 719:	77 ed                	ja     708 <malloc+0x38>
      if(p->s.size == nunits)
 71b:	39 c3                	cmp    %eax,%ebx
 71d:	74 21                	je     740 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 71f:	29 d8                	sub    %ebx,%eax
 721:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 724:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 727:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 72a:	89 15 e4 07 00 00    	mov    %edx,0x7e4
      return (void*) (p + 1);
 730:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 733:	83 c4 0c             	add    $0xc,%esp
 736:	5b                   	pop    %ebx
 737:	5e                   	pop    %esi
 738:	5f                   	pop    %edi
 739:	5d                   	pop    %ebp
 73a:	c3                   	ret    
 73b:	90                   	nop    
 73c:	8d 74 26 00          	lea    0x0(%esi),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 740:	8b 01                	mov    (%ecx),%eax
 742:	89 02                	mov    %eax,(%edx)
 744:	eb e4                	jmp    72a <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 746:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 74c:	bf 00 10 00 00       	mov    $0x1000,%edi
 751:	b8 00 80 00 00       	mov    $0x8000,%eax
 756:	76 04                	jbe    75c <malloc+0x8c>
 758:	89 df                	mov    %ebx,%edi
 75a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 75c:	89 04 24             	mov    %eax,(%esp)
 75f:	e8 dc fb ff ff       	call   340 <sbrk>
  if(p == (char*) -1)
 764:	83 f8 ff             	cmp    $0xffffffff,%eax
 767:	74 18                	je     781 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 769:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 76c:	83 c0 08             	add    $0x8,%eax
 76f:	89 04 24             	mov    %eax,(%esp)
 772:	e8 b9 fe ff ff       	call   630 <free>
  return freep;
 777:	8b 15 e4 07 00 00    	mov    0x7e4,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 77d:	85 d2                	test   %edx,%edx
 77f:	75 91                	jne    712 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 781:	31 c0                	xor    %eax,%eax
 783:	eb ae                	jmp    733 <malloc+0x63>
 785:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 788:	c7 05 e4 07 00 00 dc 	movl   $0x7dc,0x7e4
 78f:	07 00 00 
    base.s.size = 0;
 792:	ba dc 07 00 00       	mov    $0x7dc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 797:	c7 05 dc 07 00 00 dc 	movl   $0x7dc,0x7dc
 79e:	07 00 00 
    base.s.size = 0;
 7a1:	c7 05 e0 07 00 00 00 	movl   $0x0,0x7e0
 7a8:	00 00 00 
 7ab:	e9 43 ff ff ff       	jmp    6f3 <malloc+0x23>
