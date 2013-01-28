
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	31 f6                	xor    %esi,%esi
   7:	53                   	push   %ebx
   8:	83 ec 2c             	sub    $0x2c,%esp
   b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	8b 45 08             	mov    0x8(%ebp),%eax
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 60 09 00 	movl   $0x960,0x4(%esp)
  32:	00 
  33:	89 04 24             	mov    %eax,(%esp)
  36:	e8 c5 03 00 00       	call   400 <read>
  3b:	83 f8 00             	cmp    $0x0,%eax
  3e:	89 c7                	mov    %eax,%edi
  40:	7e 56                	jle    98 <wc+0x98>
  42:	31 db                	xor    %ebx,%ebx
  44:	eb 10                	jmp    56 <wc+0x56>
  46:	66 90                	xchg   %ax,%ax
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  4f:	83 c3 01             	add    $0x1,%ebx
  52:	39 df                	cmp    %ebx,%edi
  54:	7e 3d                	jle    93 <wc+0x93>
      c++;
      if(buf[i] == '\n')
  56:	0f be 83 60 09 00 00 	movsbl 0x960(%ebx),%eax
        l++;
  5d:	31 d2                	xor    %edx,%edx
      if(strchr(" \r\t\n\v", buf[i]))
  5f:	c7 04 24 e0 08 00 00 	movl   $0x8e0,(%esp)
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
  66:	3c 0a                	cmp    $0xa,%al
  68:	0f 94 c2             	sete   %dl
  6b:	01 d6                	add    %edx,%esi
      if(strchr(" \r\t\n\v", buf[i]))
  6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  71:	e8 fa 01 00 00       	call   270 <strchr>
  76:	85 c0                	test   %eax,%eax
  78:	75 ce                	jne    48 <wc+0x48>
        inword = 0;
      else if(!inword){
  7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7d:	85 c0                	test   %eax,%eax
  7f:	75 ce                	jne    4f <wc+0x4f>
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  81:	83 c3 01             	add    $0x1,%ebx
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
  84:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  88:	39 df                	cmp    %ebx,%edi
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
  8a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  91:	7f c3                	jg     56 <wc+0x56>
  93:	01 7d ec             	add    %edi,-0x14(%ebp)
  96:	eb 88                	jmp    20 <wc+0x20>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  98:	75 35                	jne    cf <wc+0xcf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 74 24 08          	mov    %esi,0x8(%esp)
  a1:	c7 44 24 04 f6 08 00 	movl   $0x8f6,0x4(%esp)
  a8:	00 
  a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b0:	89 44 24 14          	mov    %eax,0x14(%esp)
  b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  c2:	e8 59 04 00 00       	call   520 <printf>
}
  c7:	83 c4 2c             	add    $0x2c,%esp
  ca:	5b                   	pop    %ebx
  cb:	5e                   	pop    %esi
  cc:	5f                   	pop    %edi
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    
        inword = 1;
      }
    }
  }
  if(n < 0){
    printf(1, "wc: read error\n");
  cf:	c7 44 24 04 e6 08 00 	movl   $0x8e6,0x4(%esp)
  d6:	00 
  d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  de:	e8 3d 04 00 00       	call   520 <printf>
    exit();
  e3:	e8 00 03 00 00       	call   3e8 <exit>
  e8:	90                   	nop    
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000f0 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
  f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f4:	83 e4 f0             	and    $0xfffffff0,%esp
  f7:	ff 71 fc             	pushl  -0x4(%ecx)
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	57                   	push   %edi
  int fd, i;

  if(argc <= 1){
    wc(0, "");
    exit();
  fe:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	51                   	push   %ecx
 106:	83 ec 18             	sub    $0x18,%esp
 109:	8b 01                	mov    (%ecx),%eax
 10b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 10e:	8b 41 04             	mov    0x4(%ecx),%eax
  int fd, i;

  if(argc <= 1){
 111:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
    wc(0, "");
    exit();
 115:	8d 70 04             	lea    0x4(%eax),%esi
int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
 118:	7e 63                	jle    17d <main+0x8d>
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 120:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 127:	00 
 128:	8b 06                	mov    (%esi),%eax
 12a:	89 04 24             	mov    %eax,(%esp)
 12d:	e8 f6 02 00 00       	call   428 <open>
 132:	85 c0                	test   %eax,%eax
 134:	89 c3                	mov    %eax,%ebx
 136:	78 26                	js     15e <main+0x6e>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 138:	8b 06                	mov    (%esi),%eax
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 13a:	83 c7 01             	add    $0x1,%edi
 13d:	83 c6 04             	add    $0x4,%esi
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 140:	89 1c 24             	mov    %ebx,(%esp)
 143:	89 44 24 04          	mov    %eax,0x4(%esp)
 147:	e8 b4 fe ff ff       	call   0 <wc>
    close(fd);
 14c:	89 1c 24             	mov    %ebx,(%esp)
 14f:	e8 bc 02 00 00       	call   410 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 154:	39 7d ec             	cmp    %edi,-0x14(%ebp)
 157:	7f c7                	jg     120 <main+0x30>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 159:	e8 8a 02 00 00       	call   3e8 <exit>
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
 15e:	8b 06                	mov    (%esi),%eax
 160:	c7 44 24 04 03 09 00 	movl   $0x903,0x4(%esp)
 167:	00 
 168:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16f:	89 44 24 08          	mov    %eax,0x8(%esp)
 173:	e8 a8 03 00 00       	call   520 <printf>
      exit();
 178:	e8 6b 02 00 00       	call   3e8 <exit>
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    wc(0, "");
 17d:	c7 44 24 04 f5 08 00 	movl   $0x8f5,0x4(%esp)
 184:	00 
 185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 18c:	e8 6f fe ff ff       	call   0 <wc>
    exit();
 191:	e8 52 02 00 00       	call   3e8 <exit>
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

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1a0:	55                   	push   %ebp
 1a1:	31 d2                	xor    %edx,%edx
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1a8:	53                   	push   %ebx
 1a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
 1b4:	88 04 13             	mov    %al,(%ebx,%edx,1)
 1b7:	83 c2 01             	add    $0x1,%edx
 1ba:	84 c0                	test   %al,%al
 1bc:	75 f2                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1be:	89 d8                	mov    %ebx,%eax
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
 1d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1da:	0f b6 02             	movzbl (%edx),%eax
 1dd:	84 c0                	test   %al,%al
 1df:	75 14                	jne    1f5 <strcmp+0x25>
 1e1:	eb 2d                	jmp    210 <strcmp+0x40>
 1e3:	90                   	nop    
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 1e8:	83 c2 01             	add    $0x1,%edx
 1eb:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ee:	0f b6 02             	movzbl (%edx),%eax
 1f1:	84 c0                	test   %al,%al
 1f3:	74 1b                	je     210 <strcmp+0x40>
 1f5:	0f b6 19             	movzbl (%ecx),%ebx
 1f8:	38 d8                	cmp    %bl,%al
 1fa:	74 ec                	je     1e8 <strcmp+0x18>
 1fc:	0f b6 d0             	movzbl %al,%edx
 1ff:	0f b6 c3             	movzbl %bl,%eax
 202:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 204:	89 d0                	mov    %edx,%eax
 206:	5b                   	pop    %ebx
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 210:	0f b6 19             	movzbl (%ecx),%ebx
 213:	31 d2                	xor    %edx,%edx
 215:	0f b6 c3             	movzbl %bl,%eax
 218:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 21a:	89 d0                	mov    %edx,%eax
 21c:	5b                   	pop    %ebx
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret    
 21f:	90                   	nop    

00000220 <strlen>:

uint
strlen(char *s)
{
 220:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 221:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 223:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 225:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 227:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 22a:	80 3a 00             	cmpb   $0x0,(%edx)
 22d:	74 0c                	je     23b <strlen+0x1b>
 22f:	90                   	nop    
 230:	83 c0 01             	add    $0x1,%eax
 233:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 237:	75 f7                	jne    230 <strlen+0x10>
 239:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 23b:	89 c8                	mov    %ecx,%eax
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret    
 23f:	90                   	nop    

00000240 <memset>:

void*
memset(void *dst, int c, uint n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 08             	sub    $0x8,%esp
 246:	89 1c 24             	mov    %ebx,(%esp)
 249:	8b 5d 08             	mov    0x8(%ebp),%ebx
 24c:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 250:	8b 4d 10             	mov    0x10(%ebp),%ecx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	89 df                	mov    %ebx,%edi
 258:	fc                   	cld    
 259:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 25b:	89 d8                	mov    %ebx,%eax
 25d:	8b 7c 24 04          	mov    0x4(%esp),%edi
 261:	8b 1c 24             	mov    (%esp),%ebx
 264:	89 ec                	mov    %ebp,%esp
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	90                   	nop    
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 27a:	0f b6 10             	movzbl (%eax),%edx
 27d:	84 d2                	test   %dl,%dl
 27f:	75 11                	jne    292 <strchr+0x22>
 281:	eb 25                	jmp    2a8 <strchr+0x38>
 283:	90                   	nop    
 284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 288:	83 c0 01             	add    $0x1,%eax
 28b:	0f b6 10             	movzbl (%eax),%edx
 28e:	84 d2                	test   %dl,%dl
 290:	74 16                	je     2a8 <strchr+0x38>
    if(*s == c)
 292:	38 ca                	cmp    %cl,%dl
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 298:	75 ee                	jne    288 <strchr+0x18>
      return (char*) s;
  return 0;
}
 29a:	5d                   	pop    %ebp
 29b:	90                   	nop    
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a0:	c3                   	ret    
 2a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2a8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 2aa:	5d                   	pop    %ebp
 2ab:	90                   	nop    
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b0:	c3                   	ret    
 2b1:	eb 0d                	jmp    2c0 <atoi>
 2b3:	90                   	nop    
 2b4:	90                   	nop    
 2b5:	90                   	nop    
 2b6:	90                   	nop    
 2b7:	90                   	nop    
 2b8:	90                   	nop    
 2b9:	90                   	nop    
 2ba:	90                   	nop    
 2bb:	90                   	nop    
 2bc:	90                   	nop    
 2bd:	90                   	nop    
 2be:	90                   	nop    
 2bf:	90                   	nop    

000002c0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2c0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c1:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	53                   	push   %ebx
 2c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c9:	0f b6 13             	movzbl (%ebx),%edx
 2cc:	8d 42 d0             	lea    -0x30(%edx),%eax
 2cf:	3c 09                	cmp    $0x9,%al
 2d1:	77 1c                	ja     2ef <atoi+0x2f>
 2d3:	90                   	nop    
 2d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 2d8:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 2db:	0f be d2             	movsbl %dl,%edx
 2de:	83 c3 01             	add    $0x1,%ebx
 2e1:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e5:	0f b6 13             	movzbl (%ebx),%edx
 2e8:	8d 42 d0             	lea    -0x30(%edx),%eax
 2eb:	3c 09                	cmp    $0x9,%al
 2ed:	76 e9                	jbe    2d8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2ef:	89 c8                	mov    %ecx,%eax
 2f1:	5b                   	pop    %ebx
 2f2:	5d                   	pop    %ebp
 2f3:	c3                   	ret    
 2f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000300 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 4d 10             	mov    0x10(%ebp),%ecx
 306:	56                   	push   %esi
 307:	8b 75 08             	mov    0x8(%ebp),%esi
 30a:	53                   	push   %ebx
 30b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30e:	85 c9                	test   %ecx,%ecx
 310:	7e 14                	jle    326 <memmove+0x26>
 312:	31 d2                	xor    %edx,%edx
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 318:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 31c:	88 04 16             	mov    %al,(%esi,%edx,1)
 31f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 322:	39 ca                	cmp    %ecx,%edx
 324:	75 f2                	jne    318 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 326:	89 f0                	mov    %esi,%eax
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5d                   	pop    %ebp
 32b:	c3                   	ret    
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000330 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 336:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 339:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 33c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 33f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 344:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 34b:	00 
 34c:	89 04 24             	mov    %eax,(%esp)
 34f:	e8 d4 00 00 00       	call   428 <open>
  if(fd < 0)
 354:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 356:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 358:	78 19                	js     373 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	89 1c 24             	mov    %ebx,(%esp)
 360:	89 44 24 04          	mov    %eax,0x4(%esp)
 364:	e8 d7 00 00 00       	call   440 <fstat>
  close(fd);
 369:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 36c:	89 c6                	mov    %eax,%esi
  close(fd);
 36e:	e8 9d 00 00 00       	call   410 <close>
  return r;
}
 373:	89 f0                	mov    %esi,%eax
 375:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 378:	8b 75 fc             	mov    -0x4(%ebp),%esi
 37b:	89 ec                	mov    %ebp,%esp
 37d:	5d                   	pop    %ebp
 37e:	c3                   	ret    
 37f:	90                   	nop    

00000380 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	31 f6                	xor    %esi,%esi
 387:	53                   	push   %ebx
 388:	83 ec 1c             	sub    $0x1c,%esp
 38b:	8b 7d 08             	mov    0x8(%ebp),%edi
 38e:	eb 06                	jmp    396 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 390:	3c 0d                	cmp    $0xd,%al
 392:	74 39                	je     3cd <gets+0x4d>
 394:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	8d 5e 01             	lea    0x1(%esi),%ebx
 399:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 39c:	7d 31                	jge    3cf <gets+0x4f>
    cc = read(0, &c, 1);
 39e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 3a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a8:	00 
 3a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3b4:	e8 47 00 00 00       	call   400 <read>
    if(cc < 1)
 3b9:	85 c0                	test   %eax,%eax
 3bb:	7e 12                	jle    3cf <gets+0x4f>
      break;
    buf[i++] = c;
 3bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 3c1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 3c5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 3c9:	3c 0a                	cmp    $0xa,%al
 3cb:	75 c3                	jne    390 <gets+0x10>
 3cd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3cf:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3d3:	89 f8                	mov    %edi,%eax
 3d5:	83 c4 1c             	add    $0x1c,%esp
 3d8:	5b                   	pop    %ebx
 3d9:	5e                   	pop    %esi
 3da:	5f                   	pop    %edi
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
 3dd:	90                   	nop    
 3de:	90                   	nop    
 3df:	90                   	nop    

000003e0 <fork>:
 3e0:	b8 01 00 00 00       	mov    $0x1,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <exit>:
 3e8:	b8 02 00 00 00       	mov    $0x2,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <wait>:
 3f0:	b8 03 00 00 00       	mov    $0x3,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <pipe>:
 3f8:	b8 04 00 00 00       	mov    $0x4,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <read>:
 400:	b8 06 00 00 00       	mov    $0x6,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <write>:
 408:	b8 05 00 00 00       	mov    $0x5,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <close>:
 410:	b8 07 00 00 00       	mov    $0x7,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <kill>:
 418:	b8 08 00 00 00       	mov    $0x8,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <exec>:
 420:	b8 09 00 00 00       	mov    $0x9,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <open>:
 428:	b8 0a 00 00 00       	mov    $0xa,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <mknod>:
 430:	b8 0b 00 00 00       	mov    $0xb,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <unlink>:
 438:	b8 0c 00 00 00       	mov    $0xc,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <fstat>:
 440:	b8 0d 00 00 00       	mov    $0xd,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <link>:
 448:	b8 0e 00 00 00       	mov    $0xe,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <mkdir>:
 450:	b8 0f 00 00 00       	mov    $0xf,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <chdir>:
 458:	b8 10 00 00 00       	mov    $0x10,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <dup>:
 460:	b8 11 00 00 00       	mov    $0x11,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <getpid>:
 468:	b8 12 00 00 00       	mov    $0x12,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <sbrk>:
 470:	b8 13 00 00 00       	mov    $0x13,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <sleep>:
 478:	b8 14 00 00 00       	mov    $0x14,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	89 ce                	mov    %ecx,%esi
 487:	53                   	push   %ebx
 488:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 48e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 491:	85 c9                	test   %ecx,%ecx
 493:	74 04                	je     499 <printint+0x19>
 495:	85 d2                	test   %edx,%edx
 497:	78 77                	js     510 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 499:	89 d0                	mov    %edx,%eax
 49b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 4a2:	31 db                	xor    %ebx,%ebx
 4a4:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 4a7:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 4a8:	31 d2                	xor    %edx,%edx
 4aa:	f7 f6                	div    %esi
 4ac:	89 c1                	mov    %eax,%ecx
 4ae:	0f b6 82 1f 09 00 00 	movzbl 0x91f(%edx),%eax
 4b5:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 4b8:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 4bb:	85 c9                	test   %ecx,%ecx
 4bd:	89 c8                	mov    %ecx,%eax
 4bf:	75 e7                	jne    4a8 <printint+0x28>
  if(neg)
 4c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4c4:	85 c0                	test   %eax,%eax
 4c6:	74 08                	je     4d0 <printint+0x50>
    buf[i++] = '-';
 4c8:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 4cd:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 4d0:	8d 73 ff             	lea    -0x1(%ebx),%esi
 4d3:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 4d6:	8d 7d f3             	lea    -0xd(%ebp),%edi
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 4e0:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e3:	83 ee 01             	sub    $0x1,%esi
 4e6:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f0:	00 
 4f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 4f5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
 4fb:	89 04 24             	mov    %eax,(%esp)
 4fe:	e8 05 ff ff ff       	call   408 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 503:	83 fe ff             	cmp    $0xffffffff,%esi
 506:	75 d8                	jne    4e0 <printint+0x60>
    putc(fd, buf[i]);
}
 508:	83 c4 3c             	add    $0x3c,%esp
 50b:	5b                   	pop    %ebx
 50c:	5e                   	pop    %esi
 50d:	5f                   	pop    %edi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 510:	89 d0                	mov    %edx,%eax
 512:	f7 d8                	neg    %eax
 514:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 51b:	eb 85                	jmp    4a2 <printint+0x22>
 51d:	8d 76 00             	lea    0x0(%esi),%esi

00000520 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 529:	8b 55 0c             	mov    0xc(%ebp),%edx
 52c:	0f b6 02             	movzbl (%edx),%eax
 52f:	84 c0                	test   %al,%al
 531:	0f 84 e9 00 00 00    	je     620 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 537:	8d 4d 10             	lea    0x10(%ebp),%ecx
 53a:	31 ff                	xor    %edi,%edi
 53c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 53f:	31 f6                	xor    %esi,%esi
 541:	eb 21                	jmp    564 <printf+0x44>
 543:	90                   	nop    
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 548:	83 fb 25             	cmp    $0x25,%ebx
 54b:	0f 85 d7 00 00 00    	jne    628 <printf+0x108>
 551:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 555:	83 c7 01             	add    $0x1,%edi
 558:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 55c:	84 c0                	test   %al,%al
 55e:	0f 84 bc 00 00 00    	je     620 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 564:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 566:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 569:	74 dd                	je     548 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 56b:	83 fe 25             	cmp    $0x25,%esi
 56e:	75 e5                	jne    555 <printf+0x35>
      if(c == 'd'){
 570:	83 fb 64             	cmp    $0x64,%ebx
 573:	90                   	nop    
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 578:	0f 84 52 01 00 00    	je     6d0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 57e:	83 fb 78             	cmp    $0x78,%ebx
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	0f 84 c2 00 00 00    	je     650 <printf+0x130>
 58e:	83 fb 70             	cmp    $0x70,%ebx
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 598:	0f 84 b2 00 00 00    	je     650 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 59e:	83 fb 73             	cmp    $0x73,%ebx
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5a8:	0f 84 ca 00 00 00    	je     678 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ae:	83 fb 63             	cmp    $0x63,%ebx
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5b8:	0f 84 62 01 00 00    	je     720 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5be:	83 fb 25             	cmp    $0x25,%ebx
 5c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5c8:	0f 84 2a 01 00 00    	je     6f8 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5d1:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d4:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d7:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5db:	31 f6                	xor    %esi,%esi
 5dd:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e8:	00 
 5e9:	89 0c 24             	mov    %ecx,(%esp)
 5ec:	e8 17 fe ff ff       	call   408 <write>
 5f1:	8b 55 08             	mov    0x8(%ebp),%edx
 5f4:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5f7:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 601:	00 
 602:	89 44 24 04          	mov    %eax,0x4(%esp)
 606:	89 14 24             	mov    %edx,(%esp)
 609:	e8 fa fd ff ff       	call   408 <write>
 60e:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 611:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 615:	84 c0                	test   %al,%al
 617:	0f 85 47 ff ff ff    	jne    564 <printf+0x44>
 61d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 620:	83 c4 2c             	add    $0x2c,%esp
 623:	5b                   	pop    %ebx
 624:	5e                   	pop    %esi
 625:	5f                   	pop    %edi
 626:	5d                   	pop    %ebp
 627:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 628:	8b 55 08             	mov    0x8(%ebp),%edx
 62b:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 62e:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 631:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 638:	00 
 639:	89 44 24 04          	mov    %eax,0x4(%esp)
 63d:	89 14 24             	mov    %edx,(%esp)
 640:	e8 c3 fd ff ff       	call   408 <write>
 645:	8b 55 0c             	mov    0xc(%ebp),%edx
 648:	e9 08 ff ff ff       	jmp    555 <printf+0x35>
 64d:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 650:	8b 45 e0             	mov    -0x20(%ebp),%eax
 653:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 658:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 65a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 661:	8b 10                	mov    (%eax),%edx
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	e8 15 fe ff ff       	call   480 <printint>
 66b:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 66e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 672:	e9 de fe ff ff       	jmp    555 <printf+0x35>
 677:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 678:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 67b:	8b 19                	mov    (%ecx),%ebx
        ap++;
 67d:	83 c1 04             	add    $0x4,%ecx
 680:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 683:	85 db                	test   %ebx,%ebx
 685:	0f 84 c5 00 00 00    	je     750 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 68b:	0f b6 03             	movzbl (%ebx),%eax
 68e:	84 c0                	test   %al,%al
 690:	74 30                	je     6c2 <printf+0x1a2>
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 698:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 69b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 69e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6a1:	8d 45 f3             	lea    -0xd(%ebp),%eax
 6a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6ab:	00 
 6ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b0:	89 14 24             	mov    %edx,(%esp)
 6b3:	e8 50 fd ff ff       	call   408 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6b8:	0f b6 03             	movzbl (%ebx),%eax
 6bb:	84 c0                	test   %al,%al
 6bd:	75 d9                	jne    698 <printf+0x178>
 6bf:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6c2:	31 f6                	xor    %esi,%esi
 6c4:	e9 8c fe ff ff       	jmp    555 <printf+0x35>
 6c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 6d8:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
 6e7:	e8 94 fd ff ff       	call   480 <printint>
 6ec:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 6ef:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 6f3:	e9 5d fe ff ff       	jmp    555 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 6fe:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 700:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 704:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 70b:	00 
 70c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 710:	89 04 24             	mov    %eax,(%esp)
 713:	e8 f0 fc ff ff       	call   408 <write>
 718:	8b 55 0c             	mov    0xc(%ebp),%edx
 71b:	e9 35 fe ff ff       	jmp    555 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 720:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 723:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 725:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 728:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 72a:	89 14 24             	mov    %edx,(%esp)
 72d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 734:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 735:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 738:	8d 45 f3             	lea    -0xd(%ebp),%eax
 73b:	89 44 24 04          	mov    %eax,0x4(%esp)
 73f:	e8 c4 fc ff ff       	call   408 <write>
 744:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 747:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 74b:	e9 05 fe ff ff       	jmp    555 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 750:	bb 18 09 00 00       	mov    $0x918,%ebx
 755:	e9 31 ff ff ff       	jmp    68b <printf+0x16b>
 75a:	90                   	nop    
 75b:	90                   	nop    
 75c:	90                   	nop    
 75d:	90                   	nop    
 75e:	90                   	nop    
 75f:	90                   	nop    

00000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 761:	8b 0d 48 09 00 00    	mov    0x948,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 767:	89 e5                	mov    %esp,%ebp
 769:	57                   	push   %edi
 76a:	56                   	push   %esi
 76b:	53                   	push   %ebx
 76c:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 76f:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	39 d9                	cmp    %ebx,%ecx
 774:	73 24                	jae    79a <free+0x3a>
 776:	66 90                	xchg   %ax,%ax
 778:	8b 11                	mov    (%ecx),%edx
 77a:	39 d3                	cmp    %edx,%ebx
 77c:	72 2a                	jb     7a8 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	39 d1                	cmp    %edx,%ecx
 780:	72 10                	jb     792 <free+0x32>
 782:	39 d9                	cmp    %ebx,%ecx
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 788:	72 1e                	jb     7a8 <free+0x48>
 78a:	39 d3                	cmp    %edx,%ebx
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 790:	72 16                	jb     7a8 <free+0x48>
 792:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	39 d9                	cmp    %ebx,%ecx
 796:	66 90                	xchg   %ax,%ax
 798:	72 de                	jb     778 <free+0x18>
 79a:	8b 11                	mov    (%ecx),%edx
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7a0:	eb dc                	jmp    77e <free+0x1e>
 7a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a8:	8b 73 04             	mov    0x4(%ebx),%esi
 7ab:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 7ae:	39 d0                	cmp    %edx,%eax
 7b0:	74 1a                	je     7cc <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7b2:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 7b5:	8b 51 04             	mov    0x4(%ecx),%edx
 7b8:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 7bb:	39 d8                	cmp    %ebx,%eax
 7bd:	74 22                	je     7e1 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7bf:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 7c1:	89 0d 48 09 00 00    	mov    %ecx,0x948
}
 7c7:	5b                   	pop    %ebx
 7c8:	5e                   	pop    %esi
 7c9:	5f                   	pop    %edi
 7ca:	5d                   	pop    %ebp
 7cb:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7cc:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 7cf:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d1:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7d4:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7d7:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7da:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 7dd:	39 d8                	cmp    %ebx,%eax
 7df:	75 de                	jne    7bf <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e1:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e4:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 7e7:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e9:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	89 0d 48 09 00 00    	mov    %ecx,0x948
}
 7f2:	5b                   	pop    %ebx
 7f3:	5e                   	pop    %esi
 7f4:	5f                   	pop    %edi
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret    
 7f7:	89 f6                	mov    %esi,%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000800 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 809:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 80c:	8b 15 48 09 00 00    	mov    0x948,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	83 c0 07             	add    $0x7,%eax
 815:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 818:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 81d:	0f 84 95 00 00 00    	je     8b8 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 823:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 825:	8b 41 04             	mov    0x4(%ecx),%eax
 828:	39 c3                	cmp    %eax,%ebx
 82a:	76 1f                	jbe    84b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 82c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 833:	90                   	nop    
 834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 838:	3b 0d 48 09 00 00    	cmp    0x948,%ecx
 83e:	89 ca                	mov    %ecx,%edx
 840:	74 34                	je     876 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 844:	8b 41 04             	mov    0x4(%ecx),%eax
 847:	39 c3                	cmp    %eax,%ebx
 849:	77 ed                	ja     838 <malloc+0x38>
      if(p->s.size == nunits)
 84b:	39 c3                	cmp    %eax,%ebx
 84d:	74 21                	je     870 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 84f:	29 d8                	sub    %ebx,%eax
 851:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 854:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 857:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 85a:	89 15 48 09 00 00    	mov    %edx,0x948
      return (void*) (p + 1);
 860:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 863:	83 c4 0c             	add    $0xc,%esp
 866:	5b                   	pop    %ebx
 867:	5e                   	pop    %esi
 868:	5f                   	pop    %edi
 869:	5d                   	pop    %ebp
 86a:	c3                   	ret    
 86b:	90                   	nop    
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 870:	8b 01                	mov    (%ecx),%eax
 872:	89 02                	mov    %eax,(%edx)
 874:	eb e4                	jmp    85a <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 876:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 87c:	bf 00 10 00 00       	mov    $0x1000,%edi
 881:	b8 00 80 00 00       	mov    $0x8000,%eax
 886:	76 04                	jbe    88c <malloc+0x8c>
 888:	89 df                	mov    %ebx,%edi
 88a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 88c:	89 04 24             	mov    %eax,(%esp)
 88f:	e8 dc fb ff ff       	call   470 <sbrk>
  if(p == (char*) -1)
 894:	83 f8 ff             	cmp    $0xffffffff,%eax
 897:	74 18                	je     8b1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 899:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 89c:	83 c0 08             	add    $0x8,%eax
 89f:	89 04 24             	mov    %eax,(%esp)
 8a2:	e8 b9 fe ff ff       	call   760 <free>
  return freep;
 8a7:	8b 15 48 09 00 00    	mov    0x948,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8ad:	85 d2                	test   %edx,%edx
 8af:	75 91                	jne    842 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8b1:	31 c0                	xor    %eax,%eax
 8b3:	eb ae                	jmp    863 <malloc+0x63>
 8b5:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8b8:	c7 05 48 09 00 00 40 	movl   $0x940,0x948
 8bf:	09 00 00 
    base.s.size = 0;
 8c2:	ba 40 09 00 00       	mov    $0x940,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8c7:	c7 05 40 09 00 00 40 	movl   $0x940,0x940
 8ce:	09 00 00 
    base.s.size = 0;
 8d1:	c7 05 44 09 00 00 00 	movl   $0x0,0x944
 8d8:	00 00 00 
 8db:	e9 43 ff ff ff       	jmp    823 <malloc+0x23>
