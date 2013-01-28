
_cat:     file format elf32-i386

Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
   7:	8b 5d 08             	mov    0x8(%ebp),%ebx
   a:	eb 1c                	jmp    28 <cat+0x28>
   c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  10:	89 44 24 08          	mov    %eax,0x8(%esp)
  14:	c7 44 24 04 c0 08 00 	movl   $0x8c0,0x4(%esp)
  1b:	00 
  1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  23:	e8 50 03 00 00       	call   378 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2f:	00 
  30:	c7 44 24 04 c0 08 00 	movl   $0x8c0,0x4(%esp)
  37:	00 
  38:	89 1c 24             	mov    %ebx,(%esp)
  3b:	e8 30 03 00 00       	call   370 <read>
  40:	83 f8 00             	cmp    $0x0,%eax
  43:	7f cb                	jg     10 <cat+0x10>
    write(1, buf, n);
  if(n < 0){
  45:	75 0a                	jne    51 <cat+0x51>
    printf(1, "cat: read error\n");
    exit();
  }
}
  47:	83 c4 14             	add    $0x14,%esp
  4a:	5b                   	pop    %ebx
  4b:	5d                   	pop    %ebp
  4c:	8d 74 26 00          	lea    0x0(%esi),%esi
  50:	c3                   	ret    
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  if(n < 0){
    printf(1, "cat: read error\n");
  51:	c7 44 24 04 50 08 00 	movl   $0x850,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 2b 04 00 00       	call   490 <printf>
    exit();
  65:	e8 ee 02 00 00       	call   358 <exit>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000070 <main>:
  }
}

int
main(int argc, char *argv[])
{
  70:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  74:	83 e4 f0             	and    $0xfffffff0,%esp
  77:	ff 71 fc             	pushl  -0x4(%ecx)
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	57                   	push   %edi
  7e:	56                   	push   %esi
  int fd, i;

  if(argc <= 1){
    cat(0);
    exit();
  7f:	be 01 00 00 00       	mov    $0x1,%esi
  }
}

int
main(int argc, char *argv[])
{
  84:	53                   	push   %ebx
  85:	51                   	push   %ecx
  86:	83 ec 18             	sub    $0x18,%esp
  89:	8b 01                	mov    (%ecx),%eax
  8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8e:	8b 41 04             	mov    0x4(%ecx),%eax
  int fd, i;

  if(argc <= 1){
  91:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
    cat(0);
    exit();
  95:	8d 78 04             	lea    0x4(%eax),%edi
int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
  98:	7e 5d                	jle    f7 <main+0x87>
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  a7:	00 
  a8:	8b 07                	mov    (%edi),%eax
  aa:	89 04 24             	mov    %eax,(%esp)
  ad:	e8 e6 02 00 00       	call   398 <open>
  b2:	85 c0                	test   %eax,%eax
  b4:	89 c3                	mov    %eax,%ebx
  b6:	78 20                	js     d8 <main+0x68>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  b8:	89 04 24             	mov    %eax,(%esp)
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  bb:	83 c6 01             	add    $0x1,%esi
  be:	83 c7 04             	add    $0x4,%edi
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  c1:	e8 3a ff ff ff       	call   0 <cat>
    close(fd);
  c6:	89 1c 24             	mov    %ebx,(%esp)
  c9:	e8 b2 02 00 00       	call   380 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ce:	39 75 ec             	cmp    %esi,-0x14(%ebp)
  d1:	7f cd                	jg     a0 <main+0x30>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  d3:	e8 80 02 00 00       	call   358 <exit>
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
  d8:	8b 07                	mov    (%edi),%eax
  da:	c7 44 24 04 61 08 00 	movl   $0x861,0x4(%esp)
  e1:	00 
  e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	e8 9e 03 00 00       	call   490 <printf>
      exit();
  f2:	e8 61 02 00 00       	call   358 <exit>
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    cat(0);
  f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  fe:	e8 fd fe ff ff       	call   0 <cat>
    exit();
 103:	e8 50 02 00 00       	call   358 <exit>
 108:	90                   	nop    
 109:	90                   	nop    
 10a:	90                   	nop    
 10b:	90                   	nop    
 10c:	90                   	nop    
 10d:	90                   	nop    
 10e:	90                   	nop    
 10f:	90                   	nop    

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	31 d2                	xor    %edx,%edx
 113:	89 e5                	mov    %esp,%ebp
 115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 118:	53                   	push   %ebx
 119:	8b 5d 08             	mov    0x8(%ebp),%ebx
 11c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
 124:	88 04 13             	mov    %al,(%ebx,%edx,1)
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 c0                	test   %al,%al
 12c:	75 f2                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 12e:	89 d8                	mov    %ebx,%eax
 130:	5b                   	pop    %ebx
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    
 133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 55 08             	mov    0x8(%ebp),%edx
 147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 14a:	0f b6 02             	movzbl (%edx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 14                	jne    165 <strcmp+0x25>
 151:	eb 2d                	jmp    180 <strcmp+0x40>
 153:	90                   	nop    
 154:	8d 74 26 00          	lea    0x0(%esi),%esi
    p++, q++;
 158:	83 c2 01             	add    $0x1,%edx
 15b:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15e:	0f b6 02             	movzbl (%edx),%eax
 161:	84 c0                	test   %al,%al
 163:	74 1b                	je     180 <strcmp+0x40>
 165:	0f b6 19             	movzbl (%ecx),%ebx
 168:	38 d8                	cmp    %bl,%al
 16a:	74 ec                	je     158 <strcmp+0x18>
 16c:	0f b6 d0             	movzbl %al,%edx
 16f:	0f b6 c3             	movzbl %bl,%eax
 172:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 174:	89 d0                	mov    %edx,%eax
 176:	5b                   	pop    %ebx
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 180:	0f b6 19             	movzbl (%ecx),%ebx
 183:	31 d2                	xor    %edx,%edx
 185:	0f b6 c3             	movzbl %bl,%eax
 188:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 18a:	89 d0                	mov    %edx,%eax
 18c:	5b                   	pop    %ebx
 18d:	5d                   	pop    %ebp
 18e:	c3                   	ret    
 18f:	90                   	nop    

00000190 <strlen>:

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 191:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 193:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 195:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 197:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 19a:	80 3a 00             	cmpb   $0x0,(%edx)
 19d:	74 0c                	je     1ab <strlen+0x1b>
 19f:	90                   	nop    
 1a0:	83 c0 01             	add    $0x1,%eax
 1a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1a7:	75 f7                	jne    1a0 <strlen+0x10>
 1a9:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 1ab:	89 c8                	mov    %ecx,%eax
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret    
 1af:	90                   	nop    

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	83 ec 08             	sub    $0x8,%esp
 1b6:	89 1c 24             	mov    %ebx,(%esp)
 1b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	89 df                	mov    %ebx,%edi
 1c8:	fc                   	cld    
 1c9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1cb:	89 d8                	mov    %ebx,%eax
 1cd:	8b 7c 24 04          	mov    0x4(%esp),%edi
 1d1:	8b 1c 24             	mov    (%esp),%ebx
 1d4:	89 ec                	mov    %ebp,%esp
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    
 1d8:	90                   	nop    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	75 11                	jne    202 <strchr+0x22>
 1f1:	eb 25                	jmp    218 <strchr+0x38>
 1f3:	90                   	nop    
 1f4:	8d 74 26 00          	lea    0x0(%esi),%esi
 1f8:	83 c0 01             	add    $0x1,%eax
 1fb:	0f b6 10             	movzbl (%eax),%edx
 1fe:	84 d2                	test   %dl,%dl
 200:	74 16                	je     218 <strchr+0x38>
    if(*s == c)
 202:	38 ca                	cmp    %cl,%dl
 204:	8d 74 26 00          	lea    0x0(%esi),%esi
 208:	75 ee                	jne    1f8 <strchr+0x18>
      return (char*) s;
  return 0;
}
 20a:	5d                   	pop    %ebp
 20b:	90                   	nop    
 20c:	8d 74 26 00          	lea    0x0(%esi),%esi
 210:	c3                   	ret    
 211:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 218:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 21a:	5d                   	pop    %ebp
 21b:	90                   	nop    
 21c:	8d 74 26 00          	lea    0x0(%esi),%esi
 220:	c3                   	ret    
 221:	eb 0d                	jmp    230 <atoi>
 223:	90                   	nop    
 224:	90                   	nop    
 225:	90                   	nop    
 226:	90                   	nop    
 227:	90                   	nop    
 228:	90                   	nop    
 229:	90                   	nop    
 22a:	90                   	nop    
 22b:	90                   	nop    
 22c:	90                   	nop    
 22d:	90                   	nop    
 22e:	90                   	nop    
 22f:	90                   	nop    

00000230 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 231:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 233:	89 e5                	mov    %esp,%ebp
 235:	53                   	push   %ebx
 236:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 239:	0f b6 13             	movzbl (%ebx),%edx
 23c:	8d 42 d0             	lea    -0x30(%edx),%eax
 23f:	3c 09                	cmp    $0x9,%al
 241:	77 1c                	ja     25f <atoi+0x2f>
 243:	90                   	nop    
 244:	8d 74 26 00          	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 248:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 24b:	0f be d2             	movsbl %dl,%edx
 24e:	83 c3 01             	add    $0x1,%ebx
 251:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 255:	0f b6 13             	movzbl (%ebx),%edx
 258:	8d 42 d0             	lea    -0x30(%edx),%eax
 25b:	3c 09                	cmp    $0x9,%al
 25d:	76 e9                	jbe    248 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 25f:	89 c8                	mov    %ecx,%eax
 261:	5b                   	pop    %ebx
 262:	5d                   	pop    %ebp
 263:	c3                   	ret    
 264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 26a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000270 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 4d 10             	mov    0x10(%ebp),%ecx
 276:	56                   	push   %esi
 277:	8b 75 08             	mov    0x8(%ebp),%esi
 27a:	53                   	push   %ebx
 27b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 c9                	test   %ecx,%ecx
 280:	7e 14                	jle    296 <memmove+0x26>
 282:	31 d2                	xor    %edx,%edx
 284:	8d 74 26 00          	lea    0x0(%esi),%esi
    *dst++ = *src++;
 288:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 28c:	88 04 16             	mov    %al,(%esi,%edx,1)
 28f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 292:	39 ca                	cmp    %ecx,%edx
 294:	75 f2                	jne    288 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 296:	89 f0                	mov    %esi,%eax
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5d                   	pop    %ebp
 29b:	c3                   	ret    
 29c:	8d 74 26 00          	lea    0x0(%esi),%esi

000002a0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2af:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2bb:	00 
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 d4 00 00 00       	call   398 <open>
  if(fd < 0)
 2c4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2c8:	78 19                	js     2e3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 1c 24             	mov    %ebx,(%esp)
 2d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d4:	e8 d7 00 00 00       	call   3b0 <fstat>
  close(fd);
 2d9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2dc:	89 c6                	mov    %eax,%esi
  close(fd);
 2de:	e8 9d 00 00 00       	call   380 <close>
  return r;
}
 2e3:	89 f0                	mov    %esi,%eax
 2e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2eb:	89 ec                	mov    %ebp,%esp
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    
 2ef:	90                   	nop    

000002f0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	31 f6                	xor    %esi,%esi
 2f7:	53                   	push   %ebx
 2f8:	83 ec 1c             	sub    $0x1c,%esp
 2fb:	8b 7d 08             	mov    0x8(%ebp),%edi
 2fe:	eb 06                	jmp    306 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 300:	3c 0d                	cmp    $0xd,%al
 302:	74 39                	je     33d <gets+0x4d>
 304:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 306:	8d 5e 01             	lea    0x1(%esi),%ebx
 309:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 30c:	7d 31                	jge    33f <gets+0x4f>
    cc = read(0, &c, 1);
 30e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 311:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 318:	00 
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 324:	e8 47 00 00 00       	call   370 <read>
    if(cc < 1)
 329:	85 c0                	test   %eax,%eax
 32b:	7e 12                	jle    33f <gets+0x4f>
      break;
    buf[i++] = c;
 32d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 331:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 335:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 339:	3c 0a                	cmp    $0xa,%al
 33b:	75 c3                	jne    300 <gets+0x10>
 33d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 33f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 343:	89 f8                	mov    %edi,%eax
 345:	83 c4 1c             	add    $0x1c,%esp
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	90                   	nop    
 34e:	90                   	nop    
 34f:	90                   	nop    

00000350 <fork>:
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <exit>:
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <wait>:
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <pipe>:
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <read>:
 370:	b8 06 00 00 00       	mov    $0x6,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <write>:
 378:	b8 05 00 00 00       	mov    $0x5,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <close>:
 380:	b8 07 00 00 00       	mov    $0x7,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <kill>:
 388:	b8 08 00 00 00       	mov    $0x8,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <exec>:
 390:	b8 09 00 00 00       	mov    $0x9,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <open>:
 398:	b8 0a 00 00 00       	mov    $0xa,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mknod>:
 3a0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <unlink>:
 3a8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <fstat>:
 3b0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <link>:
 3b8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mkdir>:
 3c0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <chdir>:
 3c8:	b8 10 00 00 00       	mov    $0x10,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <dup>:
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getpid>:
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sbrk>:
 3e0:	b8 13 00 00 00       	mov    $0x13,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sleep>:
 3e8:	b8 14 00 00 00       	mov    $0x14,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	89 ce                	mov    %ecx,%esi
 3f7:	53                   	push   %ebx
 3f8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 401:	85 c9                	test   %ecx,%ecx
 403:	74 04                	je     409 <printint+0x19>
 405:	85 d2                	test   %edx,%edx
 407:	78 77                	js     480 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 409:	89 d0                	mov    %edx,%eax
 40b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 412:	31 db                	xor    %ebx,%ebx
 414:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 417:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 418:	31 d2                	xor    %edx,%edx
 41a:	f7 f6                	div    %esi
 41c:	89 c1                	mov    %eax,%ecx
 41e:	0f b6 82 7d 08 00 00 	movzbl 0x87d(%edx),%eax
 425:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 428:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 42b:	85 c9                	test   %ecx,%ecx
 42d:	89 c8                	mov    %ecx,%eax
 42f:	75 e7                	jne    418 <printint+0x28>
  if(neg)
 431:	8b 45 d0             	mov    -0x30(%ebp),%eax
 434:	85 c0                	test   %eax,%eax
 436:	74 08                	je     440 <printint+0x50>
    buf[i++] = '-';
 438:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 43d:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 440:	8d 73 ff             	lea    -0x1(%ebx),%esi
 443:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 446:	8d 7d f3             	lea    -0xd(%ebp),%edi
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 450:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 453:	83 ee 01             	sub    $0x1,%esi
 456:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 459:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 460:	00 
 461:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 465:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 468:	8b 45 cc             	mov    -0x34(%ebp),%eax
 46b:	89 04 24             	mov    %eax,(%esp)
 46e:	e8 05 ff ff ff       	call   378 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 473:	83 fe ff             	cmp    $0xffffffff,%esi
 476:	75 d8                	jne    450 <printint+0x60>
    putc(fd, buf[i]);
}
 478:	83 c4 3c             	add    $0x3c,%esp
 47b:	5b                   	pop    %ebx
 47c:	5e                   	pop    %esi
 47d:	5f                   	pop    %edi
 47e:	5d                   	pop    %ebp
 47f:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 480:	89 d0                	mov    %edx,%eax
 482:	f7 d8                	neg    %eax
 484:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 48b:	eb 85                	jmp    412 <printint+0x22>
 48d:	8d 76 00             	lea    0x0(%esi),%esi

00000490 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 499:	8b 55 0c             	mov    0xc(%ebp),%edx
 49c:	0f b6 02             	movzbl (%edx),%eax
 49f:	84 c0                	test   %al,%al
 4a1:	0f 84 e9 00 00 00    	je     590 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4a7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4aa:	31 ff                	xor    %edi,%edi
 4ac:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 4af:	31 f6                	xor    %esi,%esi
 4b1:	eb 21                	jmp    4d4 <printf+0x44>
 4b3:	90                   	nop    
 4b4:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4b8:	83 fb 25             	cmp    $0x25,%ebx
 4bb:	0f 85 d7 00 00 00    	jne    598 <printf+0x108>
 4c1:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c5:	83 c7 01             	add    $0x1,%edi
 4c8:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 4cc:	84 c0                	test   %al,%al
 4ce:	0f 84 bc 00 00 00    	je     590 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 4d4:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4d6:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 4d9:	74 dd                	je     4b8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4db:	83 fe 25             	cmp    $0x25,%esi
 4de:	75 e5                	jne    4c5 <printf+0x35>
      if(c == 'd'){
 4e0:	83 fb 64             	cmp    $0x64,%ebx
 4e3:	90                   	nop    
 4e4:	8d 74 26 00          	lea    0x0(%esi),%esi
 4e8:	0f 84 52 01 00 00    	je     640 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4ee:	83 fb 78             	cmp    $0x78,%ebx
 4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 4f8:	0f 84 c2 00 00 00    	je     5c0 <printf+0x130>
 4fe:	83 fb 70             	cmp    $0x70,%ebx
 501:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 508:	0f 84 b2 00 00 00    	je     5c0 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 50e:	83 fb 73             	cmp    $0x73,%ebx
 511:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 518:	0f 84 ca 00 00 00    	je     5e8 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51e:	83 fb 63             	cmp    $0x63,%ebx
 521:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 528:	0f 84 62 01 00 00    	je     690 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 52e:	83 fb 25             	cmp    $0x25,%ebx
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 538:	0f 84 2a 01 00 00    	je     668 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 541:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 544:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 547:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54b:	31 f6                	xor    %esi,%esi
 54d:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 551:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 558:	00 
 559:	89 0c 24             	mov    %ecx,(%esp)
 55c:	e8 17 fe ff ff       	call   378 <write>
 561:	8b 55 08             	mov    0x8(%ebp),%edx
 564:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 567:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 571:	00 
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	89 14 24             	mov    %edx,(%esp)
 579:	e8 fa fd ff ff       	call   378 <write>
 57e:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 581:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 585:	84 c0                	test   %al,%al
 587:	0f 85 47 ff ff ff    	jne    4d4 <printf+0x44>
 58d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 590:	83 c4 2c             	add    $0x2c,%esp
 593:	5b                   	pop    %ebx
 594:	5e                   	pop    %esi
 595:	5f                   	pop    %edi
 596:	5d                   	pop    %ebp
 597:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 598:	8b 55 08             	mov    0x8(%ebp),%edx
 59b:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 59e:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5a8:	00 
 5a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ad:	89 14 24             	mov    %edx,(%esp)
 5b0:	e8 c3 fd ff ff       	call   378 <write>
 5b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b8:	e9 08 ff ff ff       	jmp    4c5 <printf+0x35>
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5c3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5c8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5d1:	8b 10                	mov    (%eax),%edx
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	e8 15 fe ff ff       	call   3f0 <printint>
 5db:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 5de:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 5e2:	e9 de fe ff ff       	jmp    4c5 <printf+0x35>
 5e7:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 5e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 5eb:	8b 19                	mov    (%ecx),%ebx
        ap++;
 5ed:	83 c1 04             	add    $0x4,%ecx
 5f0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 5f3:	85 db                	test   %ebx,%ebx
 5f5:	0f 84 c5 00 00 00    	je     6c0 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 5fb:	0f b6 03             	movzbl (%ebx),%eax
 5fe:	84 c0                	test   %al,%al
 600:	74 30                	je     632 <printf+0x1a2>
 602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 608:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 60b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 60e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 611:	8d 45 f3             	lea    -0xd(%ebp),%eax
 614:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 61b:	00 
 61c:	89 44 24 04          	mov    %eax,0x4(%esp)
 620:	89 14 24             	mov    %edx,(%esp)
 623:	e8 50 fd ff ff       	call   378 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 628:	0f b6 03             	movzbl (%ebx),%eax
 62b:	84 c0                	test   %al,%al
 62d:	75 d9                	jne    608 <printf+0x178>
 62f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 632:	31 f6                	xor    %esi,%esi
 634:	e9 8c fe ff ff       	jmp    4c5 <printf+0x35>
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 640:	8b 45 e0             	mov    -0x20(%ebp),%eax
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 648:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 64b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 652:	8b 10                	mov    (%eax),%edx
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	e8 94 fd ff ff       	call   3f0 <printint>
 65c:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 65f:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 663:	e9 5d fe ff ff       	jmp    4c5 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 66e:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 670:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 674:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 67b:	00 
 67c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 f0 fc ff ff       	call   378 <write>
 688:	8b 55 0c             	mov    0xc(%ebp),%edx
 68b:	e9 35 fe ff ff       	jmp    4c5 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 690:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 693:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 695:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 698:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 69a:	89 14 24             	mov    %edx,(%esp)
 69d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6a4:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6a8:	8d 45 f3             	lea    -0xd(%ebp),%eax
 6ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 6af:	e8 c4 fc ff ff       	call   378 <write>
 6b4:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6b7:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 6bb:	e9 05 fe ff ff       	jmp    4c5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 6c0:	bb 76 08 00 00       	mov    $0x876,%ebx
 6c5:	e9 31 ff ff ff       	jmp    5fb <printf+0x16b>
 6ca:	90                   	nop    
 6cb:	90                   	nop    
 6cc:	90                   	nop    
 6cd:	90                   	nop    
 6ce:	90                   	nop    
 6cf:	90                   	nop    

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	8b 0d a8 08 00 00    	mov    0x8a8,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d7:	89 e5                	mov    %esp,%ebp
 6d9:	57                   	push   %edi
 6da:	56                   	push   %esi
 6db:	53                   	push   %ebx
 6dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 6df:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	39 d9                	cmp    %ebx,%ecx
 6e4:	73 24                	jae    70a <free+0x3a>
 6e6:	66 90                	xchg   %ax,%ax
 6e8:	8b 11                	mov    (%ecx),%edx
 6ea:	39 d3                	cmp    %edx,%ebx
 6ec:	72 2a                	jb     718 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	39 d1                	cmp    %edx,%ecx
 6f0:	72 10                	jb     702 <free+0x32>
 6f2:	39 d9                	cmp    %ebx,%ecx
 6f4:	8d 74 26 00          	lea    0x0(%esi),%esi
 6f8:	72 1e                	jb     718 <free+0x48>
 6fa:	39 d3                	cmp    %edx,%ebx
 6fc:	8d 74 26 00          	lea    0x0(%esi),%esi
 700:	72 16                	jb     718 <free+0x48>
 702:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	39 d9                	cmp    %ebx,%ecx
 706:	66 90                	xchg   %ax,%ax
 708:	72 de                	jb     6e8 <free+0x18>
 70a:	8b 11                	mov    (%ecx),%edx
 70c:	8d 74 26 00          	lea    0x0(%esi),%esi
 710:	eb dc                	jmp    6ee <free+0x1e>
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 718:	8b 73 04             	mov    0x4(%ebx),%esi
 71b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 71e:	39 d0                	cmp    %edx,%eax
 720:	74 1a                	je     73c <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 722:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 725:	8b 51 04             	mov    0x4(%ecx),%edx
 728:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 72b:	39 d8                	cmp    %ebx,%eax
 72d:	74 22                	je     751 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 72f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 731:	89 0d a8 08 00 00    	mov    %ecx,0x8a8
}
 737:	5b                   	pop    %ebx
 738:	5e                   	pop    %esi
 739:	5f                   	pop    %edi
 73a:	5d                   	pop    %ebp
 73b:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73c:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 73f:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 741:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 744:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 747:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 74a:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 74d:	39 d8                	cmp    %ebx,%eax
 74f:	75 de                	jne    72f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 751:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 754:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 757:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 759:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 75c:	89 0d a8 08 00 00    	mov    %ecx,0x8a8
}
 762:	5b                   	pop    %ebx
 763:	5e                   	pop    %esi
 764:	5f                   	pop    %edi
 765:	5d                   	pop    %ebp
 766:	c3                   	ret    
 767:	89 f6                	mov    %esi,%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 77c:	8b 15 a8 08 00 00    	mov    0x8a8,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	83 c0 07             	add    $0x7,%eax
 785:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 788:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 78d:	0f 84 95 00 00 00    	je     828 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 795:	8b 41 04             	mov    0x4(%ecx),%eax
 798:	39 c3                	cmp    %eax,%ebx
 79a:	76 1f                	jbe    7bb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 79c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7a3:	90                   	nop    
 7a4:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
    if(p == freep)
 7a8:	3b 0d a8 08 00 00    	cmp    0x8a8,%ecx
 7ae:	89 ca                	mov    %ecx,%edx
 7b0:	74 34                	je     7e6 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 7b4:	8b 41 04             	mov    0x4(%ecx),%eax
 7b7:	39 c3                	cmp    %eax,%ebx
 7b9:	77 ed                	ja     7a8 <malloc+0x38>
      if(p->s.size == nunits)
 7bb:	39 c3                	cmp    %eax,%ebx
 7bd:	74 21                	je     7e0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7bf:	29 d8                	sub    %ebx,%eax
 7c1:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 7c4:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 7c7:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 7ca:	89 15 a8 08 00 00    	mov    %edx,0x8a8
      return (void*) (p + 1);
 7d0:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d3:	83 c4 0c             	add    $0xc,%esp
 7d6:	5b                   	pop    %ebx
 7d7:	5e                   	pop    %esi
 7d8:	5f                   	pop    %edi
 7d9:	5d                   	pop    %ebp
 7da:	c3                   	ret    
 7db:	90                   	nop    
 7dc:	8d 74 26 00          	lea    0x0(%esi),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7e0:	8b 01                	mov    (%ecx),%eax
 7e2:	89 02                	mov    %eax,(%edx)
 7e4:	eb e4                	jmp    7ca <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 7e6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 7ec:	bf 00 10 00 00       	mov    $0x1000,%edi
 7f1:	b8 00 80 00 00       	mov    $0x8000,%eax
 7f6:	76 04                	jbe    7fc <malloc+0x8c>
 7f8:	89 df                	mov    %ebx,%edi
 7fa:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 7fc:	89 04 24             	mov    %eax,(%esp)
 7ff:	e8 dc fb ff ff       	call   3e0 <sbrk>
  if(p == (char*) -1)
 804:	83 f8 ff             	cmp    $0xffffffff,%eax
 807:	74 18                	je     821 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 809:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 80c:	83 c0 08             	add    $0x8,%eax
 80f:	89 04 24             	mov    %eax,(%esp)
 812:	e8 b9 fe ff ff       	call   6d0 <free>
  return freep;
 817:	8b 15 a8 08 00 00    	mov    0x8a8,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 81d:	85 d2                	test   %edx,%edx
 81f:	75 91                	jne    7b2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 821:	31 c0                	xor    %eax,%eax
 823:	eb ae                	jmp    7d3 <malloc+0x63>
 825:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 828:	c7 05 a8 08 00 00 a0 	movl   $0x8a0,0x8a8
 82f:	08 00 00 
    base.s.size = 0;
 832:	ba a0 08 00 00       	mov    $0x8a0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 837:	c7 05 a0 08 00 00 a0 	movl   $0x8a0,0x8a0
 83e:	08 00 00 
    base.s.size = 0;
 841:	c7 05 a4 08 00 00 00 	movl   $0x0,0x8a4
 848:	00 00 00 
 84b:	e9 43 ff ff ff       	jmp    793 <malloc+0x23>
