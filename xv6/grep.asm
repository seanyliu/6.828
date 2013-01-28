
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  18:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1c:	89 3c 24             	mov    %edi,(%esp)
  1f:	e8 3c 00 00 00       	call   60 <matchhere>
  24:	85 c0                	test   %eax,%eax
  26:	75 20                	jne    48 <matchstar+0x48>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0f b6 03             	movzbl (%ebx),%eax
  2b:	84 c0                	test   %al,%al
  2d:	74 0f                	je     3e <matchstar+0x3e>
  2f:	0f be c0             	movsbl %al,%eax
  32:	83 c3 01             	add    $0x1,%ebx
  35:	39 f0                	cmp    %esi,%eax
  37:	74 df                	je     18 <matchstar+0x18>
  39:	83 fe 2e             	cmp    $0x2e,%esi
  3c:	74 da                	je     18 <matchstar+0x18>
  return 0;
}
  3e:	83 c4 0c             	add    $0xc,%esp
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  41:	31 c0                	xor    %eax,%eax
  return 0;
}
  43:	5b                   	pop    %ebx
  44:	5e                   	pop    %esi
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
  48:	83 c4 0c             	add    $0xc,%esp

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  4b:	b8 01 00 00 00       	mov    $0x1,%eax
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  return 0;
}
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5f                   	pop    %edi
  53:	5d                   	pop    %ebp
  54:	c3                   	ret    
  55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000060 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	83 ec 10             	sub    $0x10,%esp
  68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '\0')
  6e:	0f b6 0b             	movzbl (%ebx),%ecx
  71:	84 c9                	test   %cl,%cl
  73:	75 28                	jne    9d <matchhere+0x3d>
  75:	eb 59                	jmp    d0 <matchhere+0x70>
  77:	90                   	nop    
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	0f b6 16             	movzbl (%esi),%edx
  7b:	84 d2                	test   %dl,%dl
  7d:	74 41                	je     c0 <matchhere+0x60>
  7f:	80 f9 2e             	cmp    $0x2e,%cl
  82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  88:	74 08                	je     92 <matchhere+0x32>
  8a:	38 d1                	cmp    %dl,%cl
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  90:	75 2e                	jne    c0 <matchhere+0x60>
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  92:	0f b6 0b             	movzbl (%ebx),%ecx
  95:	84 c9                	test   %cl,%cl
  97:	90                   	nop    
  98:	74 36                	je     d0 <matchhere+0x70>
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  9a:	83 c6 01             	add    $0x1,%esi
// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
  9d:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
  a1:	8d 43 01             	lea    0x1(%ebx),%eax
  a4:	80 fa 2a             	cmp    $0x2a,%dl
  a7:	74 37                	je     e0 <matchhere+0x80>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
  a9:	80 f9 24             	cmp    $0x24,%cl
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  ac:	89 c3                	mov    %eax,%ebx
  if(re[0] == '$' && re[1] == '\0')
  ae:	75 c8                	jne    78 <matchhere+0x18>
  b0:	84 d2                	test   %dl,%dl
  b2:	75 c4                	jne    78 <matchhere+0x18>
    return *text == '\0';
  b4:	31 c0                	xor    %eax,%eax
  b6:	80 3e 00             	cmpb   $0x0,(%esi)
  b9:	0f 94 c0             	sete   %al
  bc:	eb 04                	jmp    c2 <matchhere+0x62>
  be:	66 90                	xchg   %ax,%ax
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  c0:	31 c0                	xor    %eax,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  c2:	83 c4 10             	add    $0x10,%esp
  c5:	5b                   	pop    %ebx
  c6:	5e                   	pop    %esi
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
  c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d0:	83 c4 10             	add    $0x10,%esp
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  d3:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  d8:	5b                   	pop    %ebx
  d9:	5e                   	pop    %esi
  da:	5d                   	pop    %ebp
  db:	c3                   	ret    
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  e0:	8d 43 02             	lea    0x2(%ebx),%eax
  e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  e7:	0f be c1             	movsbl %cl,%eax
  ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  ee:	89 04 24             	mov    %eax,(%esp)
  f1:	e8 0a ff ff ff       	call   0 <matchstar>
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  f6:	83 c4 10             	add    $0x10,%esp
  f9:	5b                   	pop    %ebx
  fa:	5e                   	pop    %esi
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi

00000100 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	83 ec 10             	sub    $0x10,%esp
 108:	8b 75 08             	mov    0x8(%ebp),%esi
 10b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
 10e:	80 3e 5e             	cmpb   $0x5e,(%esi)
 111:	75 08                	jne    11b <match+0x1b>
 113:	eb 37                	jmp    14c <match+0x4c>
 115:	8d 76 00             	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 118:	83 c3 01             	add    $0x1,%ebx
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
 11b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 11f:	89 34 24             	mov    %esi,(%esp)
 122:	e8 39 ff ff ff       	call   60 <matchhere>
 127:	85 c0                	test   %eax,%eax
 129:	75 15                	jne    140 <match+0x40>
      return 1;
  }while(*text++ != '\0');
 12b:	80 3b 00             	cmpb   $0x0,(%ebx)
 12e:	75 e8                	jne    118 <match+0x18>
  return 0;
}
 130:	83 c4 10             	add    $0x10,%esp
 133:	5b                   	pop    %ebx
 134:	5e                   	pop    %esi
 135:	5d                   	pop    %ebp
 136:	66 90                	xchg   %ax,%ax
 138:	c3                   	ret    
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 140:	83 c4 10             	add    $0x10,%esp
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 143:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
 148:	5b                   	pop    %ebx
 149:	5e                   	pop    %esi
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 14c:	8d 46 01             	lea    0x1(%esi),%eax
 14f:	89 45 08             	mov    %eax,0x8(%ebp)
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}
 152:	83 c4 10             	add    $0x10,%esp
 155:	5b                   	pop    %ebx
 156:	5e                   	pop    %esi
 157:	5d                   	pop    %ebp

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 158:	e9 03 ff ff ff       	jmp    60 <matchhere>
 15d:	8d 76 00             	lea    0x0(%esi),%esi

00000160 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	31 ff                	xor    %edi,%edi
 166:	56                   	push   %esi
 167:	53                   	push   %ebx
 168:	83 ec 1c             	sub    $0x1c,%esp
 16b:	90                   	nop    
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
 170:	b8 00 04 00 00       	mov    $0x400,%eax
 175:	29 f8                	sub    %edi,%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	8d 87 e0 0a 00 00    	lea    0xae0(%edi),%eax
 181:	89 44 24 04          	mov    %eax,0x4(%esp)
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	89 04 24             	mov    %eax,(%esp)
 18b:	e8 f0 03 00 00       	call   580 <read>
 190:	85 c0                	test   %eax,%eax
 192:	89 45 f0             	mov    %eax,-0x10(%ebp)
 195:	0f 8e a4 00 00 00    	jle    23f <grep+0xdf>
 19b:	be e0 0a 00 00       	mov    $0xae0,%esi
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
 1a0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 1a7:	00 
 1a8:	89 34 24             	mov    %esi,(%esp)
 1ab:	e8 40 02 00 00       	call   3f0 <strchr>
 1b0:	85 c0                	test   %eax,%eax
 1b2:	89 c3                	mov    %eax,%ebx
 1b4:	74 4a                	je     200 <grep+0xa0>
      *q = 0;
 1b6:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	89 74 24 04          	mov    %esi,0x4(%esp)
 1c0:	89 04 24             	mov    %eax,(%esp)
 1c3:	e8 38 ff ff ff       	call   100 <match>
 1c8:	85 c0                	test   %eax,%eax
 1ca:	75 0c                	jne    1d8 <grep+0x78>
 1cc:	83 c3 01             	add    $0x1,%ebx
        *q = '\n';
        write(1, p, q+1 - p);
 1cf:	89 de                	mov    %ebx,%esi
 1d1:	eb cd                	jmp    1a0 <grep+0x40>
 1d3:	90                   	nop    
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = 0;
      if(match(pattern, p)){
        *q = '\n';
 1d8:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 1db:	83 c3 01             	add    $0x1,%ebx
 1de:	89 d8                	mov    %ebx,%eax
 1e0:	29 f0                	sub    %esi,%eax
 1e2:	89 74 24 04          	mov    %esi,0x4(%esp)
 1e6:	89 de                	mov    %ebx,%esi
 1e8:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f3:	e8 90 03 00 00       	call   588 <write>
 1f8:	eb a6                	jmp    1a0 <grep+0x40>
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
      p = q+1;
    }
    if(p == buf)
 200:	81 fe e0 0a 00 00    	cmp    $0xae0,%esi
 206:	74 30                	je     238 <grep+0xd8>
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
 208:	03 7d f0             	add    -0x10(%ebp),%edi
      }
      p = q+1;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
 20b:	85 ff                	test   %edi,%edi
 20d:	8d 76 00             	lea    0x0(%esi),%esi
 210:	0f 8e 5a ff ff ff    	jle    170 <grep+0x10>
      m -= p - buf;
 216:	81 c7 e0 0a 00 00    	add    $0xae0,%edi
 21c:	29 f7                	sub    %esi,%edi
      memmove(buf, p, m);
 21e:	89 7c 24 08          	mov    %edi,0x8(%esp)
 222:	89 74 24 04          	mov    %esi,0x4(%esp)
 226:	c7 04 24 e0 0a 00 00 	movl   $0xae0,(%esp)
 22d:	e8 4e 02 00 00       	call   480 <memmove>
 232:	e9 39 ff ff ff       	jmp    170 <grep+0x10>
 237:	90                   	nop    
 238:	31 ff                	xor    %edi,%edi
 23a:	e9 31 ff ff ff       	jmp    170 <grep+0x10>
    }
  }
}
 23f:	83 c4 1c             	add    $0x1c,%esp
 242:	5b                   	pop    %ebx
 243:	5e                   	pop    %esi
 244:	5f                   	pop    %edi
 245:	5d                   	pop    %ebp
 246:	66 90                	xchg   %ax,%ax
 248:	c3                   	ret    
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000250 <main>:

int
main(int argc, char *argv[])
{
 250:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 254:	83 e4 f0             	and    $0xfffffff0,%esp
 257:	ff 71 fc             	pushl  -0x4(%ecx)
 25a:	55                   	push   %ebp
 25b:	89 e5                	mov    %esp,%ebp
 25d:	57                   	push   %edi
 25e:	56                   	push   %esi
 25f:	53                   	push   %ebx
 260:	51                   	push   %ecx
 261:	83 ec 18             	sub    $0x18,%esp
 264:	8b 01                	mov    (%ecx),%eax
 266:	89 45 e8             	mov    %eax,-0x18(%ebp)
 269:	8b 41 04             	mov    0x4(%ecx),%eax
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 26c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
 270:	0f 8e 8d 00 00 00    	jle    303 <main+0xb3>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 276:	8b 50 04             	mov    0x4(%eax),%edx
  
  if(argc <= 2){
    grep(pattern, 0);
    exit();
 279:	8d 78 08             	lea    0x8(%eax),%edi
 27c:	be 02 00 00 00       	mov    $0x2,%esi
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
 281:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 285:	89 55 ec             	mov    %edx,-0x14(%ebp)
  
  if(argc <= 2){
 288:	74 64                	je     2ee <main+0x9e>
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 290:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 297:	00 
 298:	8b 07                	mov    (%edi),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 06 03 00 00       	call   5a8 <open>
 2a2:	85 c0                	test   %eax,%eax
 2a4:	89 c3                	mov    %eax,%ebx
 2a6:	78 27                	js     2cf <main+0x7f>
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 2a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 2af:	83 c6 01             	add    $0x1,%esi
 2b2:	83 c7 04             	add    $0x4,%edi
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 2b5:	89 04 24             	mov    %eax,(%esp)
 2b8:	e8 a3 fe ff ff       	call   160 <grep>
    close(fd);
 2bd:	89 1c 24             	mov    %ebx,(%esp)
 2c0:	e8 cb 02 00 00       	call   590 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 2c5:	39 75 e8             	cmp    %esi,-0x18(%ebp)
 2c8:	7f c6                	jg     290 <main+0x40>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 2ca:	e8 99 02 00 00       	call   568 <exit>
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
 2cf:	8b 07                	mov    (%edi),%eax
 2d1:	c7 44 24 04 80 0a 00 	movl   $0xa80,0x4(%esp)
 2d8:	00 
 2d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2e0:	89 44 24 08          	mov    %eax,0x8(%esp)
 2e4:	e8 b7 03 00 00       	call   6a0 <printf>
      exit();
 2e9:	e8 7a 02 00 00       	call   568 <exit>
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
    grep(pattern, 0);
 2ee:	89 14 24             	mov    %edx,(%esp)
 2f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2f8:	00 
 2f9:	e8 62 fe ff ff       	call   160 <grep>
    exit();
 2fe:	e8 65 02 00 00       	call   568 <exit>
{
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
 303:	c7 44 24 04 60 0a 00 	movl   $0xa60,0x4(%esp)
 30a:	00 
 30b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 312:	e8 89 03 00 00       	call   6a0 <printf>
    exit();
 317:	e8 4c 02 00 00       	call   568 <exit>
 31c:	90                   	nop    
 31d:	90                   	nop    
 31e:	90                   	nop    
 31f:	90                   	nop    

00000320 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 320:	55                   	push   %ebp
 321:	31 d2                	xor    %edx,%edx
 323:	89 e5                	mov    %esp,%ebp
 325:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 328:	53                   	push   %ebx
 329:	8b 5d 08             	mov    0x8(%ebp),%ebx
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 330:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
 334:	88 04 13             	mov    %al,(%ebx,%edx,1)
 337:	83 c2 01             	add    $0x1,%edx
 33a:	84 c0                	test   %al,%al
 33c:	75 f2                	jne    330 <strcpy+0x10>
    ;
  return os;
}
 33e:	89 d8                	mov    %ebx,%eax
 340:	5b                   	pop    %ebx
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 55 08             	mov    0x8(%ebp),%edx
 357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 35a:	0f b6 02             	movzbl (%edx),%eax
 35d:	84 c0                	test   %al,%al
 35f:	75 14                	jne    375 <strcmp+0x25>
 361:	eb 2d                	jmp    390 <strcmp+0x40>
 363:	90                   	nop    
 364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 368:	83 c2 01             	add    $0x1,%edx
 36b:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 36e:	0f b6 02             	movzbl (%edx),%eax
 371:	84 c0                	test   %al,%al
 373:	74 1b                	je     390 <strcmp+0x40>
 375:	0f b6 19             	movzbl (%ecx),%ebx
 378:	38 d8                	cmp    %bl,%al
 37a:	74 ec                	je     368 <strcmp+0x18>
 37c:	0f b6 d0             	movzbl %al,%edx
 37f:	0f b6 c3             	movzbl %bl,%eax
 382:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 384:	89 d0                	mov    %edx,%eax
 386:	5b                   	pop    %ebx
 387:	5d                   	pop    %ebp
 388:	c3                   	ret    
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 390:	0f b6 19             	movzbl (%ecx),%ebx
 393:	31 d2                	xor    %edx,%edx
 395:	0f b6 c3             	movzbl %bl,%eax
 398:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 39a:	89 d0                	mov    %edx,%eax
 39c:	5b                   	pop    %ebx
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret    
 39f:	90                   	nop    

000003a0 <strlen>:

uint
strlen(char *s)
{
 3a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3a1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3a3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 3a5:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3aa:	80 3a 00             	cmpb   $0x0,(%edx)
 3ad:	74 0c                	je     3bb <strlen+0x1b>
 3af:	90                   	nop    
 3b0:	83 c0 01             	add    $0x1,%eax
 3b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3b7:	75 f7                	jne    3b0 <strlen+0x10>
 3b9:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 3bb:	89 c8                	mov    %ecx,%eax
 3bd:	5d                   	pop    %ebp
 3be:	c3                   	ret    
 3bf:	90                   	nop    

000003c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 08             	sub    $0x8,%esp
 3c6:	89 1c 24             	mov    %ebx,(%esp)
 3c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	89 df                	mov    %ebx,%edi
 3d8:	fc                   	cld    
 3d9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3db:	89 d8                	mov    %ebx,%eax
 3dd:	8b 7c 24 04          	mov    0x4(%esp),%edi
 3e1:	8b 1c 24             	mov    (%esp),%ebx
 3e4:	89 ec                	mov    %ebp,%esp
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    
 3e8:	90                   	nop    
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3fa:	0f b6 10             	movzbl (%eax),%edx
 3fd:	84 d2                	test   %dl,%dl
 3ff:	75 11                	jne    412 <strchr+0x22>
 401:	eb 25                	jmp    428 <strchr+0x38>
 403:	90                   	nop    
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 408:	83 c0 01             	add    $0x1,%eax
 40b:	0f b6 10             	movzbl (%eax),%edx
 40e:	84 d2                	test   %dl,%dl
 410:	74 16                	je     428 <strchr+0x38>
    if(*s == c)
 412:	38 ca                	cmp    %cl,%dl
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 418:	75 ee                	jne    408 <strchr+0x18>
      return (char*) s;
  return 0;
}
 41a:	5d                   	pop    %ebp
 41b:	90                   	nop    
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 420:	c3                   	ret    
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 428:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 42a:	5d                   	pop    %ebp
 42b:	90                   	nop    
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 430:	c3                   	ret    
 431:	eb 0d                	jmp    440 <atoi>
 433:	90                   	nop    
 434:	90                   	nop    
 435:	90                   	nop    
 436:	90                   	nop    
 437:	90                   	nop    
 438:	90                   	nop    
 439:	90                   	nop    
 43a:	90                   	nop    
 43b:	90                   	nop    
 43c:	90                   	nop    
 43d:	90                   	nop    
 43e:	90                   	nop    
 43f:	90                   	nop    

00000440 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 440:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 441:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 443:	89 e5                	mov    %esp,%ebp
 445:	53                   	push   %ebx
 446:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 449:	0f b6 13             	movzbl (%ebx),%edx
 44c:	8d 42 d0             	lea    -0x30(%edx),%eax
 44f:	3c 09                	cmp    $0x9,%al
 451:	77 1c                	ja     46f <atoi+0x2f>
 453:	90                   	nop    
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 458:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 45b:	0f be d2             	movsbl %dl,%edx
 45e:	83 c3 01             	add    $0x1,%ebx
 461:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 465:	0f b6 13             	movzbl (%ebx),%edx
 468:	8d 42 d0             	lea    -0x30(%edx),%eax
 46b:	3c 09                	cmp    $0x9,%al
 46d:	76 e9                	jbe    458 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 46f:	89 c8                	mov    %ecx,%eax
 471:	5b                   	pop    %ebx
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
 474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 47a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000480 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	8b 4d 10             	mov    0x10(%ebp),%ecx
 486:	56                   	push   %esi
 487:	8b 75 08             	mov    0x8(%ebp),%esi
 48a:	53                   	push   %ebx
 48b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	85 c9                	test   %ecx,%ecx
 490:	7e 14                	jle    4a6 <memmove+0x26>
 492:	31 d2                	xor    %edx,%edx
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 498:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 49c:	88 04 16             	mov    %al,(%esi,%edx,1)
 49f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4a2:	39 ca                	cmp    %ecx,%edx
 4a4:	75 f2                	jne    498 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 4a6:	89 f0                	mov    %esi,%eax
 4a8:	5b                   	pop    %ebx
 4a9:	5e                   	pop    %esi
 4aa:	5d                   	pop    %ebp
 4ab:	c3                   	ret    
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4b9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 4bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 4bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4cb:	00 
 4cc:	89 04 24             	mov    %eax,(%esp)
 4cf:	e8 d4 00 00 00       	call   5a8 <open>
  if(fd < 0)
 4d4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 4d8:	78 19                	js     4f3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	89 1c 24             	mov    %ebx,(%esp)
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	e8 d7 00 00 00       	call   5c0 <fstat>
  close(fd);
 4e9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 4ec:	89 c6                	mov    %eax,%esi
  close(fd);
 4ee:	e8 9d 00 00 00       	call   590 <close>
  return r;
}
 4f3:	89 f0                	mov    %esi,%eax
 4f5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 4f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 4fb:	89 ec                	mov    %ebp,%esp
 4fd:	5d                   	pop    %ebp
 4fe:	c3                   	ret    
 4ff:	90                   	nop    

00000500 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	31 f6                	xor    %esi,%esi
 507:	53                   	push   %ebx
 508:	83 ec 1c             	sub    $0x1c,%esp
 50b:	8b 7d 08             	mov    0x8(%ebp),%edi
 50e:	eb 06                	jmp    516 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 510:	3c 0d                	cmp    $0xd,%al
 512:	74 39                	je     54d <gets+0x4d>
 514:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 516:	8d 5e 01             	lea    0x1(%esi),%ebx
 519:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 51c:	7d 31                	jge    54f <gets+0x4f>
    cc = read(0, &c, 1);
 51e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 521:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 534:	e8 47 00 00 00       	call   580 <read>
    if(cc < 1)
 539:	85 c0                	test   %eax,%eax
 53b:	7e 12                	jle    54f <gets+0x4f>
      break;
    buf[i++] = c;
 53d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 541:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 545:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 549:	3c 0a                	cmp    $0xa,%al
 54b:	75 c3                	jne    510 <gets+0x10>
 54d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 54f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 553:	89 f8                	mov    %edi,%eax
 555:	83 c4 1c             	add    $0x1c,%esp
 558:	5b                   	pop    %ebx
 559:	5e                   	pop    %esi
 55a:	5f                   	pop    %edi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    
 55d:	90                   	nop    
 55e:	90                   	nop    
 55f:	90                   	nop    

00000560 <fork>:
 560:	b8 01 00 00 00       	mov    $0x1,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <exit>:
 568:	b8 02 00 00 00       	mov    $0x2,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <wait>:
 570:	b8 03 00 00 00       	mov    $0x3,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <pipe>:
 578:	b8 04 00 00 00       	mov    $0x4,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <read>:
 580:	b8 06 00 00 00       	mov    $0x6,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <write>:
 588:	b8 05 00 00 00       	mov    $0x5,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <close>:
 590:	b8 07 00 00 00       	mov    $0x7,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <kill>:
 598:	b8 08 00 00 00       	mov    $0x8,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <exec>:
 5a0:	b8 09 00 00 00       	mov    $0x9,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <open>:
 5a8:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <mknod>:
 5b0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <unlink>:
 5b8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <fstat>:
 5c0:	b8 0d 00 00 00       	mov    $0xd,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <link>:
 5c8:	b8 0e 00 00 00       	mov    $0xe,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <mkdir>:
 5d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <chdir>:
 5d8:	b8 10 00 00 00       	mov    $0x10,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <dup>:
 5e0:	b8 11 00 00 00       	mov    $0x11,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <getpid>:
 5e8:	b8 12 00 00 00       	mov    $0x12,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <sbrk>:
 5f0:	b8 13 00 00 00       	mov    $0x13,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <sleep>:
 5f8:	b8 14 00 00 00       	mov    $0x14,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	89 ce                	mov    %ecx,%esi
 607:	53                   	push   %ebx
 608:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 60b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 60e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 611:	85 c9                	test   %ecx,%ecx
 613:	74 04                	je     619 <printint+0x19>
 615:	85 d2                	test   %edx,%edx
 617:	78 77                	js     690 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 619:	89 d0                	mov    %edx,%eax
 61b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 622:	31 db                	xor    %ebx,%ebx
 624:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 627:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 628:	31 d2                	xor    %edx,%edx
 62a:	f7 f6                	div    %esi
 62c:	89 c1                	mov    %eax,%ecx
 62e:	0f b6 82 9d 0a 00 00 	movzbl 0xa9d(%edx),%eax
 635:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 638:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 63b:	85 c9                	test   %ecx,%ecx
 63d:	89 c8                	mov    %ecx,%eax
 63f:	75 e7                	jne    628 <printint+0x28>
  if(neg)
 641:	8b 45 d0             	mov    -0x30(%ebp),%eax
 644:	85 c0                	test   %eax,%eax
 646:	74 08                	je     650 <printint+0x50>
    buf[i++] = '-';
 648:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 64d:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 650:	8d 73 ff             	lea    -0x1(%ebx),%esi
 653:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 656:	8d 7d f3             	lea    -0xd(%ebp),%edi
 659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 660:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 663:	83 ee 01             	sub    $0x1,%esi
 666:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 669:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 670:	00 
 671:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 675:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 678:	8b 45 cc             	mov    -0x34(%ebp),%eax
 67b:	89 04 24             	mov    %eax,(%esp)
 67e:	e8 05 ff ff ff       	call   588 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 683:	83 fe ff             	cmp    $0xffffffff,%esi
 686:	75 d8                	jne    660 <printint+0x60>
    putc(fd, buf[i]);
}
 688:	83 c4 3c             	add    $0x3c,%esp
 68b:	5b                   	pop    %ebx
 68c:	5e                   	pop    %esi
 68d:	5f                   	pop    %edi
 68e:	5d                   	pop    %ebp
 68f:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 690:	89 d0                	mov    %edx,%eax
 692:	f7 d8                	neg    %eax
 694:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 69b:	eb 85                	jmp    622 <printint+0x22>
 69d:	8d 76 00             	lea    0x0(%esi),%esi

000006a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ac:	0f b6 02             	movzbl (%edx),%eax
 6af:	84 c0                	test   %al,%al
 6b1:	0f 84 e9 00 00 00    	je     7a0 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 6b7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 6ba:	31 ff                	xor    %edi,%edi
 6bc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 6bf:	31 f6                	xor    %esi,%esi
 6c1:	eb 21                	jmp    6e4 <printf+0x44>
 6c3:	90                   	nop    
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6c8:	83 fb 25             	cmp    $0x25,%ebx
 6cb:	0f 85 d7 00 00 00    	jne    7a8 <printf+0x108>
 6d1:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d5:	83 c7 01             	add    $0x1,%edi
 6d8:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 6dc:	84 c0                	test   %al,%al
 6de:	0f 84 bc 00 00 00    	je     7a0 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 6e4:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 6e6:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 6e9:	74 dd                	je     6c8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6eb:	83 fe 25             	cmp    $0x25,%esi
 6ee:	75 e5                	jne    6d5 <printf+0x35>
      if(c == 'd'){
 6f0:	83 fb 64             	cmp    $0x64,%ebx
 6f3:	90                   	nop    
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6f8:	0f 84 52 01 00 00    	je     850 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6fe:	83 fb 78             	cmp    $0x78,%ebx
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 708:	0f 84 c2 00 00 00    	je     7d0 <printf+0x130>
 70e:	83 fb 70             	cmp    $0x70,%ebx
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 718:	0f 84 b2 00 00 00    	je     7d0 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 71e:	83 fb 73             	cmp    $0x73,%ebx
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 728:	0f 84 ca 00 00 00    	je     7f8 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 72e:	83 fb 63             	cmp    $0x63,%ebx
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 738:	0f 84 62 01 00 00    	je     8a0 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 73e:	83 fb 25             	cmp    $0x25,%ebx
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 748:	0f 84 2a 01 00 00    	je     878 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 74e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 751:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 754:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 757:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 75b:	31 f6                	xor    %esi,%esi
 75d:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 761:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 768:	00 
 769:	89 0c 24             	mov    %ecx,(%esp)
 76c:	e8 17 fe ff ff       	call   588 <write>
 771:	8b 55 08             	mov    0x8(%ebp),%edx
 774:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 777:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 77a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 781:	00 
 782:	89 44 24 04          	mov    %eax,0x4(%esp)
 786:	89 14 24             	mov    %edx,(%esp)
 789:	e8 fa fd ff ff       	call   588 <write>
 78e:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 791:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 795:	84 c0                	test   %al,%al
 797:	0f 85 47 ff ff ff    	jne    6e4 <printf+0x44>
 79d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a0:	83 c4 2c             	add    $0x2c,%esp
 7a3:	5b                   	pop    %ebx
 7a4:	5e                   	pop    %esi
 7a5:	5f                   	pop    %edi
 7a6:	5d                   	pop    %ebp
 7a7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7a8:	8b 55 08             	mov    0x8(%ebp),%edx
 7ab:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 7ae:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7b8:	00 
 7b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7bd:	89 14 24             	mov    %edx,(%esp)
 7c0:	e8 c3 fd ff ff       	call   588 <write>
 7c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c8:	e9 08 ff ff ff       	jmp    6d5 <printf+0x35>
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 7d3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 7d8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7e1:	8b 10                	mov    (%eax),%edx
 7e3:	8b 45 08             	mov    0x8(%ebp),%eax
 7e6:	e8 15 fe ff ff       	call   600 <printint>
 7eb:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 7ee:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 7f2:	e9 de fe ff ff       	jmp    6d5 <printf+0x35>
 7f7:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 7f8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 7fb:	8b 19                	mov    (%ecx),%ebx
        ap++;
 7fd:	83 c1 04             	add    $0x4,%ecx
 800:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 803:	85 db                	test   %ebx,%ebx
 805:	0f 84 c5 00 00 00    	je     8d0 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 80b:	0f b6 03             	movzbl (%ebx),%eax
 80e:	84 c0                	test   %al,%al
 810:	74 30                	je     842 <printf+0x1a2>
 812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 818:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 81b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 81e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 821:	8d 45 f3             	lea    -0xd(%ebp),%eax
 824:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 82b:	00 
 82c:	89 44 24 04          	mov    %eax,0x4(%esp)
 830:	89 14 24             	mov    %edx,(%esp)
 833:	e8 50 fd ff ff       	call   588 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 838:	0f b6 03             	movzbl (%ebx),%eax
 83b:	84 c0                	test   %al,%al
 83d:	75 d9                	jne    818 <printf+0x178>
 83f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 842:	31 f6                	xor    %esi,%esi
 844:	e9 8c fe ff ff       	jmp    6d5 <printf+0x35>
 849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 850:	8b 45 e0             	mov    -0x20(%ebp),%eax
 853:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 858:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 85b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 862:	8b 10                	mov    (%eax),%edx
 864:	8b 45 08             	mov    0x8(%ebp),%eax
 867:	e8 94 fd ff ff       	call   600 <printint>
 86c:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 86f:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 873:	e9 5d fe ff ff       	jmp    6d5 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 878:	8b 45 08             	mov    0x8(%ebp),%eax
 87b:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 87e:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 880:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 884:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 88b:	00 
 88c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 890:	89 04 24             	mov    %eax,(%esp)
 893:	e8 f0 fc ff ff       	call   588 <write>
 898:	8b 55 0c             	mov    0xc(%ebp),%edx
 89b:	e9 35 fe ff ff       	jmp    6d5 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8a0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 8a3:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8a5:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8a8:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8aa:	89 14 24             	mov    %edx,(%esp)
 8ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8b4:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8b5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8b8:	8d 45 f3             	lea    -0xd(%ebp),%eax
 8bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bf:	e8 c4 fc ff ff       	call   588 <write>
 8c4:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 8c7:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 8cb:	e9 05 fe ff ff       	jmp    6d5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 8d0:	bb 96 0a 00 00       	mov    $0xa96,%ebx
 8d5:	e9 31 ff ff ff       	jmp    80b <printf+0x16b>
 8da:	90                   	nop    
 8db:	90                   	nop    
 8dc:	90                   	nop    
 8dd:	90                   	nop    
 8de:	90                   	nop    
 8df:	90                   	nop    

000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e1:	8b 0d c8 0a 00 00    	mov    0xac8,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e7:	89 e5                	mov    %esp,%ebp
 8e9:	57                   	push   %edi
 8ea:	56                   	push   %esi
 8eb:	53                   	push   %ebx
 8ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 8ef:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f2:	39 d9                	cmp    %ebx,%ecx
 8f4:	73 24                	jae    91a <free+0x3a>
 8f6:	66 90                	xchg   %ax,%ax
 8f8:	8b 11                	mov    (%ecx),%edx
 8fa:	39 d3                	cmp    %edx,%ebx
 8fc:	72 2a                	jb     928 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fe:	39 d1                	cmp    %edx,%ecx
 900:	72 10                	jb     912 <free+0x32>
 902:	39 d9                	cmp    %ebx,%ecx
 904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 908:	72 1e                	jb     928 <free+0x48>
 90a:	39 d3                	cmp    %edx,%ebx
 90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 910:	72 16                	jb     928 <free+0x48>
 912:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 914:	39 d9                	cmp    %ebx,%ecx
 916:	66 90                	xchg   %ax,%ax
 918:	72 de                	jb     8f8 <free+0x18>
 91a:	8b 11                	mov    (%ecx),%edx
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 920:	eb dc                	jmp    8fe <free+0x1e>
 922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 928:	8b 73 04             	mov    0x4(%ebx),%esi
 92b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 92e:	39 d0                	cmp    %edx,%eax
 930:	74 1a                	je     94c <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 932:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 935:	8b 51 04             	mov    0x4(%ecx),%edx
 938:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 93b:	39 d8                	cmp    %ebx,%eax
 93d:	74 22                	je     961 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 93f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 941:	89 0d c8 0a 00 00    	mov    %ecx,0xac8
}
 947:	5b                   	pop    %ebx
 948:	5e                   	pop    %esi
 949:	5f                   	pop    %edi
 94a:	5d                   	pop    %ebp
 94b:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 94c:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 94f:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 951:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 954:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 957:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 95a:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 95d:	39 d8                	cmp    %ebx,%eax
 95f:	75 de                	jne    93f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 961:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 964:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 967:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 969:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 96c:	89 0d c8 0a 00 00    	mov    %ecx,0xac8
}
 972:	5b                   	pop    %ebx
 973:	5e                   	pop    %esi
 974:	5f                   	pop    %edi
 975:	5d                   	pop    %ebp
 976:	c3                   	ret    
 977:	89 f6                	mov    %esi,%esi
 979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000980 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	56                   	push   %esi
 985:	53                   	push   %ebx
 986:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 989:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 98c:	8b 15 c8 0a 00 00    	mov    0xac8,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 992:	83 c0 07             	add    $0x7,%eax
 995:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 998:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 99d:	0f 84 95 00 00 00    	je     a38 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 9a5:	8b 41 04             	mov    0x4(%ecx),%eax
 9a8:	39 c3                	cmp    %eax,%ebx
 9aa:	76 1f                	jbe    9cb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 9ac:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9b3:	90                   	nop    
 9b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 9b8:	3b 0d c8 0a 00 00    	cmp    0xac8,%ecx
 9be:	89 ca                	mov    %ecx,%edx
 9c0:	74 34                	je     9f6 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c2:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 9c4:	8b 41 04             	mov    0x4(%ecx),%eax
 9c7:	39 c3                	cmp    %eax,%ebx
 9c9:	77 ed                	ja     9b8 <malloc+0x38>
      if(p->s.size == nunits)
 9cb:	39 c3                	cmp    %eax,%ebx
 9cd:	74 21                	je     9f0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 9cf:	29 d8                	sub    %ebx,%eax
 9d1:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 9d4:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 9d7:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 9da:	89 15 c8 0a 00 00    	mov    %edx,0xac8
      return (void*) (p + 1);
 9e0:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9e3:	83 c4 0c             	add    $0xc,%esp
 9e6:	5b                   	pop    %ebx
 9e7:	5e                   	pop    %esi
 9e8:	5f                   	pop    %edi
 9e9:	5d                   	pop    %ebp
 9ea:	c3                   	ret    
 9eb:	90                   	nop    
 9ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 9f0:	8b 01                	mov    (%ecx),%eax
 9f2:	89 02                	mov    %eax,(%edx)
 9f4:	eb e4                	jmp    9da <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 9f6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 9fc:	bf 00 10 00 00       	mov    $0x1000,%edi
 a01:	b8 00 80 00 00       	mov    $0x8000,%eax
 a06:	76 04                	jbe    a0c <malloc+0x8c>
 a08:	89 df                	mov    %ebx,%edi
 a0a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 a0c:	89 04 24             	mov    %eax,(%esp)
 a0f:	e8 dc fb ff ff       	call   5f0 <sbrk>
  if(p == (char*) -1)
 a14:	83 f8 ff             	cmp    $0xffffffff,%eax
 a17:	74 18                	je     a31 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a19:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 a1c:	83 c0 08             	add    $0x8,%eax
 a1f:	89 04 24             	mov    %eax,(%esp)
 a22:	e8 b9 fe ff ff       	call   8e0 <free>
  return freep;
 a27:	8b 15 c8 0a 00 00    	mov    0xac8,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a2d:	85 d2                	test   %edx,%edx
 a2f:	75 91                	jne    9c2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a31:	31 c0                	xor    %eax,%eax
 a33:	eb ae                	jmp    9e3 <malloc+0x63>
 a35:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a38:	c7 05 c8 0a 00 00 c0 	movl   $0xac0,0xac8
 a3f:	0a 00 00 
    base.s.size = 0;
 a42:	ba c0 0a 00 00       	mov    $0xac0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a47:	c7 05 c0 0a 00 00 c0 	movl   $0xac0,0xac0
 a4e:	0a 00 00 
    base.s.size = 0;
 a51:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 a58:	00 00 00 
 a5b:	e9 43 ff ff ff       	jmp    9a3 <malloc+0x23>
