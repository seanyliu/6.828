
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   b:	89 1c 24             	mov    %ebx,(%esp)
   e:	e8 cd 03 00 00       	call   3e0 <strlen>
  13:	01 d8                	add    %ebx,%eax
  15:	73 13                	jae    2a <fmtname+0x2a>
  17:	eb 19                	jmp    32 <fmtname+0x32>
  19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  20:	83 e8 01             	sub    $0x1,%eax
  23:	39 c3                	cmp    %eax,%ebx
  25:	8d 76 00             	lea    0x0(%esi),%esi
  28:	77 08                	ja     32 <fmtname+0x32>
  2a:	80 38 2f             	cmpb   $0x2f,(%eax)
  2d:	8d 76 00             	lea    0x0(%esi),%esi
  30:	75 ee                	jne    20 <fmtname+0x20>
    ;
  p++;
  32:	8d 70 01             	lea    0x1(%eax),%esi
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  35:	89 34 24             	mov    %esi,(%esp)
  38:	e8 a3 03 00 00       	call   3e0 <strlen>
  3d:	83 f8 0d             	cmp    $0xd,%eax
  40:	77 53                	ja     95 <fmtname+0x95>
    return p;
  memmove(buf, p, strlen(p));
  42:	89 34 24             	mov    %esi,(%esp)
  45:	e8 96 03 00 00       	call   3e0 <strlen>
  4a:	89 74 24 04          	mov    %esi,0x4(%esp)
  4e:	c7 04 24 04 0b 00 00 	movl   $0xb04,(%esp)
  55:	89 44 24 08          	mov    %eax,0x8(%esp)
  59:	e8 62 04 00 00       	call   4c0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  5e:	89 34 24             	mov    %esi,(%esp)
  61:	e8 7a 03 00 00       	call   3e0 <strlen>
  66:	89 34 24             	mov    %esi,(%esp)
  69:	be 04 0b 00 00       	mov    $0xb04,%esi
  6e:	89 c3                	mov    %eax,%ebx
  70:	e8 6b 03 00 00       	call   3e0 <strlen>
  75:	ba 0e 00 00 00       	mov    $0xe,%edx
  7a:	29 da                	sub    %ebx,%edx
  7c:	89 54 24 08          	mov    %edx,0x8(%esp)
  80:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  87:	00 
  88:	05 04 0b 00 00       	add    $0xb04,%eax
  8d:	89 04 24             	mov    %eax,(%esp)
  90:	e8 6b 03 00 00       	call   400 <memset>
  return buf;
}
  95:	83 c4 10             	add    $0x10,%esp
  98:	89 f0                	mov    %esi,%eax
  9a:	5b                   	pop    %ebx
  9b:	5e                   	pop    %esi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    
  9e:	66 90                	xchg   %ax,%ax

000000a0 <ls>:

void
ls(char *path)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  ac:	8b 75 08             	mov    0x8(%ebp),%esi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b6:	00 
  b7:	89 34 24             	mov    %esi,(%esp)
  ba:	e8 29 05 00 00       	call   5e8 <open>
  bf:	85 c0                	test   %eax,%eax
  c1:	89 c7                	mov    %eax,%edi
  c3:	0f 88 8f 01 00 00    	js     258 <ls+0x1b8>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
  c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  d0:	89 3c 24             	mov    %edi,(%esp)
  d3:	e8 28 05 00 00       	call   600 <fstat>
  d8:	85 c0                	test   %eax,%eax
  da:	0f 88 c0 01 00 00    	js     2a0 <ls+0x200>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }
  
  switch(st.type){
  e0:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  e4:	66 83 f8 01          	cmp    $0x1,%ax
  e8:	74 5e                	je     148 <ls+0xa8>
  ea:	66 83 f8 02          	cmp    $0x2,%ax
  ee:	66 90                	xchg   %ax,%ax
  f0:	75 42                	jne    134 <ls+0x94>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  f5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  f8:	89 95 b8 fd ff ff    	mov    %edx,-0x248(%ebp)
  fe:	89 34 24             	mov    %esi,(%esp)
 101:	e8 fa fe ff ff       	call   0 <fmtname>
 106:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 10a:	8b 95 b8 fd ff ff    	mov    -0x248(%ebp),%edx
 110:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 117:	00 
 118:	c7 44 24 04 c8 0a 00 	movl   $0xac8,0x4(%esp)
 11f:	00 
 120:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 127:	89 54 24 10          	mov    %edx,0x10(%esp)
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	e8 ac 05 00 00       	call   6e0 <printf>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	89 3c 24             	mov    %edi,(%esp)
 137:	e8 94 04 00 00       	call   5d0 <close>
}
 13c:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 142:	5b                   	pop    %ebx
 143:	5e                   	pop    %esi
 144:	5f                   	pop    %edi
 145:	5d                   	pop    %ebp
 146:	c3                   	ret    
 147:	90                   	nop    
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 148:	89 34 24             	mov    %esi,(%esp)
 14b:	e8 90 02 00 00       	call   3e0 <strlen>
 150:	83 c0 10             	add    $0x10,%eax
 153:	3d 00 02 00 00       	cmp    $0x200,%eax
 158:	0f 87 22 01 00 00    	ja     280 <ls+0x1e0>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 15e:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 164:	89 74 24 04          	mov    %esi,0x4(%esp)
 168:	89 04 24             	mov    %eax,(%esp)
 16b:	e8 f0 01 00 00       	call   360 <strcpy>
    p = buf+strlen(buf);
 170:	8d 95 d0 fd ff ff    	lea    -0x230(%ebp),%edx
 176:	89 14 24             	mov    %edx,(%esp)
 179:	e8 62 02 00 00       	call   3e0 <strlen>
 17e:	8d 95 d0 fd ff ff    	lea    -0x230(%ebp),%edx
 184:	8d 04 02             	lea    (%edx,%eax,1),%eax
    *p++ = '/';
 187:	c6 00 2f             	movb   $0x2f,(%eax)
 18a:	83 c0 01             	add    $0x1,%eax
 18d:	89 85 bc fd ff ff    	mov    %eax,-0x244(%ebp)
 193:	90                   	nop    
 194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 198:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 19b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 1a2:	00 
 1a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a7:	89 3c 24             	mov    %edi,(%esp)
 1aa:	e8 11 04 00 00       	call   5c0 <read>
 1af:	83 f8 10             	cmp    $0x10,%eax
 1b2:	75 80                	jne    134 <ls+0x94>
      if(de.inum == 0)
 1b4:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
 1b9:	74 dd                	je     198 <ls+0xf8>
        continue;
      memmove(p, de.name, DIRSIZ);
 1bb:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 1be:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 1c5:	00 
 1c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ca:	8b 95 bc fd ff ff    	mov    -0x244(%ebp),%edx
 1d0:	89 14 24             	mov    %edx,(%esp)
 1d3:	e8 e8 02 00 00       	call   4c0 <memmove>
      p[DIRSIZ] = 0;
 1d8:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
      if(stat(buf, &st) < 0){
 1de:	8d 55 d0             	lea    -0x30(%ebp),%edx
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
 1e1:	c6 40 0e 00          	movb   $0x0,0xe(%eax)
      if(stat(buf, &st) < 0){
 1e5:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 1eb:	89 54 24 04          	mov    %edx,0x4(%esp)
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 f9 02 00 00       	call   4f0 <stat>
 1f7:	85 c0                	test   %eax,%eax
 1f9:	0f 88 d1 00 00 00    	js     2d0 <ls+0x230>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
 202:	0f bf 55 d0          	movswl -0x30(%ebp),%edx
 206:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 209:	89 85 c0 fd ff ff    	mov    %eax,-0x240(%ebp)
 20f:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 215:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 21b:	89 04 24             	mov    %eax,(%esp)
 21e:	e8 dd fd ff ff       	call   0 <fmtname>
 223:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 227:	8b 95 c0 fd ff ff    	mov    -0x240(%ebp),%edx
 22d:	89 54 24 10          	mov    %edx,0x10(%esp)
 231:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 237:	89 44 24 08          	mov    %eax,0x8(%esp)
 23b:	c7 44 24 04 c8 0a 00 	movl   $0xac8,0x4(%esp)
 242:	00 
 243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 24a:	89 54 24 0c          	mov    %edx,0xc(%esp)
 24e:	e8 8d 04 00 00       	call   6e0 <printf>
 253:	e9 40 ff ff ff       	jmp    198 <ls+0xf8>
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 258:	89 74 24 08          	mov    %esi,0x8(%esp)
 25c:	c7 44 24 04 a0 0a 00 	movl   $0xaa0,0x4(%esp)
 263:	00 
 264:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 26b:	e8 70 04 00 00       	call   6e0 <printf>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 270:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 276:	5b                   	pop    %ebx
 277:	5e                   	pop    %esi
 278:	5f                   	pop    %edi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret    
 27b:	90                   	nop    
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 280:	c7 44 24 04 d5 0a 00 	movl   $0xad5,0x4(%esp)
 287:	00 
 288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 28f:	e8 4c 04 00 00       	call   6e0 <printf>
 294:	e9 9b fe ff ff       	jmp    134 <ls+0x94>
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 2a0:	89 74 24 08          	mov    %esi,0x8(%esp)
 2a4:	c7 44 24 04 b4 0a 00 	movl   $0xab4,0x4(%esp)
 2ab:	00 
 2ac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2b3:	e8 28 04 00 00       	call   6e0 <printf>
    close(fd);
 2b8:	89 3c 24             	mov    %edi,(%esp)
 2bb:	e8 10 03 00 00       	call   5d0 <close>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 2c0:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    
 2cb:	90                   	nop    
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 2d0:	8d 95 d0 fd ff ff    	lea    -0x230(%ebp),%edx
 2d6:	89 54 24 08          	mov    %edx,0x8(%esp)
 2da:	c7 44 24 04 b4 0a 00 	movl   $0xab4,0x4(%esp)
 2e1:	00 
 2e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2e9:	e8 f2 03 00 00       	call   6e0 <printf>
 2ee:	e9 a5 fe ff ff       	jmp    198 <ls+0xf8>
 2f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000300 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
 300:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 304:	83 e4 f0             	and    $0xfffffff0,%esp
 307:	ff 71 fc             	pushl  -0x4(%ecx)
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	83 ec 18             	sub    $0x18,%esp
 310:	89 5d f4             	mov    %ebx,-0xc(%ebp)
 313:	8b 19                	mov    (%ecx),%ebx
 315:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 318:	89 75 f8             	mov    %esi,-0x8(%ebp)
 31b:	89 7d fc             	mov    %edi,-0x4(%ebp)
 31e:	8b 71 04             	mov    0x4(%ecx),%esi
  int i;

  if(argc < 2){
 321:	83 fb 01             	cmp    $0x1,%ebx
 324:	7f 11                	jg     337 <main+0x37>
    ls(".");
 326:	c7 04 24 e8 0a 00 00 	movl   $0xae8,(%esp)
 32d:	e8 6e fd ff ff       	call   a0 <ls>
    exit();
 332:	e8 71 02 00 00       	call   5a8 <exit>
 337:	bf 01 00 00 00       	mov    $0x1,%edi
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 340:	8b 04 be             	mov    (%esi,%edi,4),%eax

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 343:	83 c7 01             	add    $0x1,%edi
    ls(argv[i]);
 346:	89 04 24             	mov    %eax,(%esp)
 349:	e8 52 fd ff ff       	call   a0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 34e:	39 fb                	cmp    %edi,%ebx
 350:	7f ee                	jg     340 <main+0x40>
    ls(argv[i]);
  exit();
 352:	e8 51 02 00 00       	call   5a8 <exit>
 357:	90                   	nop    
 358:	90                   	nop    
 359:	90                   	nop    
 35a:	90                   	nop    
 35b:	90                   	nop    
 35c:	90                   	nop    
 35d:	90                   	nop    
 35e:	90                   	nop    
 35f:	90                   	nop    

00000360 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 360:	55                   	push   %ebp
 361:	31 d2                	xor    %edx,%edx
 363:	89 e5                	mov    %esp,%ebp
 365:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 368:	53                   	push   %ebx
 369:	8b 5d 08             	mov    0x8(%ebp),%ebx
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 370:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
 374:	88 04 13             	mov    %al,(%ebx,%edx,1)
 377:	83 c2 01             	add    $0x1,%edx
 37a:	84 c0                	test   %al,%al
 37c:	75 f2                	jne    370 <strcpy+0x10>
    ;
  return os;
}
 37e:	89 d8                	mov    %ebx,%eax
 380:	5b                   	pop    %ebx
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    
 383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 55 08             	mov    0x8(%ebp),%edx
 397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 39a:	0f b6 02             	movzbl (%edx),%eax
 39d:	84 c0                	test   %al,%al
 39f:	75 14                	jne    3b5 <strcmp+0x25>
 3a1:	eb 2d                	jmp    3d0 <strcmp+0x40>
 3a3:	90                   	nop    
 3a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 3a8:	83 c2 01             	add    $0x1,%edx
 3ab:	83 c1 01             	add    $0x1,%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ae:	0f b6 02             	movzbl (%edx),%eax
 3b1:	84 c0                	test   %al,%al
 3b3:	74 1b                	je     3d0 <strcmp+0x40>
 3b5:	0f b6 19             	movzbl (%ecx),%ebx
 3b8:	38 d8                	cmp    %bl,%al
 3ba:	74 ec                	je     3a8 <strcmp+0x18>
 3bc:	0f b6 d0             	movzbl %al,%edx
 3bf:	0f b6 c3             	movzbl %bl,%eax
 3c2:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3c4:	89 d0                	mov    %edx,%eax
 3c6:	5b                   	pop    %ebx
 3c7:	5d                   	pop    %ebp
 3c8:	c3                   	ret    
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3d0:	0f b6 19             	movzbl (%ecx),%ebx
 3d3:	31 d2                	xor    %edx,%edx
 3d5:	0f b6 c3             	movzbl %bl,%eax
 3d8:	29 c2                	sub    %eax,%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3da:	89 d0                	mov    %edx,%eax
 3dc:	5b                   	pop    %ebx
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	90                   	nop    

000003e0 <strlen>:

uint
strlen(char *s)
{
 3e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 3e5:	31 c9                	xor    %ecx,%ecx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3ea:	80 3a 00             	cmpb   $0x0,(%edx)
 3ed:	74 0c                	je     3fb <strlen+0x1b>
 3ef:	90                   	nop    
 3f0:	83 c0 01             	add    $0x1,%eax
 3f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3f7:	75 f7                	jne    3f0 <strlen+0x10>
 3f9:	89 c1                	mov    %eax,%ecx
    ;
  return n;
}
 3fb:	89 c8                	mov    %ecx,%eax
 3fd:	5d                   	pop    %ebp
 3fe:	c3                   	ret    
 3ff:	90                   	nop    

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 08             	sub    $0x8,%esp
 406:	89 1c 24             	mov    %ebx,(%esp)
 409:	8b 5d 08             	mov    0x8(%ebp),%ebx
 40c:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 410:	8b 4d 10             	mov    0x10(%ebp),%ecx
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	89 df                	mov    %ebx,%edi
 418:	fc                   	cld    
 419:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 41b:	89 d8                	mov    %ebx,%eax
 41d:	8b 7c 24 04          	mov    0x4(%esp),%edi
 421:	8b 1c 24             	mov    (%esp),%ebx
 424:	89 ec                	mov    %ebp,%esp
 426:	5d                   	pop    %ebp
 427:	c3                   	ret    
 428:	90                   	nop    
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000430 <strchr>:

char*
strchr(const char *s, char c)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 43a:	0f b6 10             	movzbl (%eax),%edx
 43d:	84 d2                	test   %dl,%dl
 43f:	75 11                	jne    452 <strchr+0x22>
 441:	eb 25                	jmp    468 <strchr+0x38>
 443:	90                   	nop    
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 448:	83 c0 01             	add    $0x1,%eax
 44b:	0f b6 10             	movzbl (%eax),%edx
 44e:	84 d2                	test   %dl,%dl
 450:	74 16                	je     468 <strchr+0x38>
    if(*s == c)
 452:	38 ca                	cmp    %cl,%dl
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 458:	75 ee                	jne    448 <strchr+0x18>
      return (char*) s;
  return 0;
}
 45a:	5d                   	pop    %ebp
 45b:	90                   	nop    
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 460:	c3                   	ret    
 461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 468:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 46a:	5d                   	pop    %ebp
 46b:	90                   	nop    
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 470:	c3                   	ret    
 471:	eb 0d                	jmp    480 <atoi>
 473:	90                   	nop    
 474:	90                   	nop    
 475:	90                   	nop    
 476:	90                   	nop    
 477:	90                   	nop    
 478:	90                   	nop    
 479:	90                   	nop    
 47a:	90                   	nop    
 47b:	90                   	nop    
 47c:	90                   	nop    
 47d:	90                   	nop    
 47e:	90                   	nop    
 47f:	90                   	nop    

00000480 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 480:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 481:	31 c9                	xor    %ecx,%ecx
  return r;
}

int
atoi(const char *s)
{
 483:	89 e5                	mov    %esp,%ebp
 485:	53                   	push   %ebx
 486:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 489:	0f b6 13             	movzbl (%ebx),%edx
 48c:	8d 42 d0             	lea    -0x30(%edx),%eax
 48f:	3c 09                	cmp    $0x9,%al
 491:	77 1c                	ja     4af <atoi+0x2f>
 493:	90                   	nop    
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 498:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 49b:	0f be d2             	movsbl %dl,%edx
 49e:	83 c3 01             	add    $0x1,%ebx
 4a1:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a5:	0f b6 13             	movzbl (%ebx),%edx
 4a8:	8d 42 d0             	lea    -0x30(%edx),%eax
 4ab:	3c 09                	cmp    $0x9,%al
 4ad:	76 e9                	jbe    498 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 4af:	89 c8                	mov    %ecx,%eax
 4b1:	5b                   	pop    %ebx
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
 4b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000004c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4c6:	56                   	push   %esi
 4c7:	8b 75 08             	mov    0x8(%ebp),%esi
 4ca:	53                   	push   %ebx
 4cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ce:	85 c9                	test   %ecx,%ecx
 4d0:	7e 14                	jle    4e6 <memmove+0x26>
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4d8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 4dc:	88 04 16             	mov    %al,(%esi,%edx,1)
 4df:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4e2:	39 ca                	cmp    %ecx,%edx
 4e4:	75 f2                	jne    4d8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 4e6:	89 f0                	mov    %esi,%eax
 4e8:	5b                   	pop    %ebx
 4e9:	5e                   	pop    %esi
 4ea:	5d                   	pop    %ebp
 4eb:	c3                   	ret    
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004f0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4f9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 4fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 4ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 504:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 50b:	00 
 50c:	89 04 24             	mov    %eax,(%esp)
 50f:	e8 d4 00 00 00       	call   5e8 <open>
  if(fd < 0)
 514:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 516:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 518:	78 19                	js     533 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 1c 24             	mov    %ebx,(%esp)
 520:	89 44 24 04          	mov    %eax,0x4(%esp)
 524:	e8 d7 00 00 00       	call   600 <fstat>
  close(fd);
 529:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 52c:	89 c6                	mov    %eax,%esi
  close(fd);
 52e:	e8 9d 00 00 00       	call   5d0 <close>
  return r;
}
 533:	89 f0                	mov    %esi,%eax
 535:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 538:	8b 75 fc             	mov    -0x4(%ebp),%esi
 53b:	89 ec                	mov    %ebp,%esp
 53d:	5d                   	pop    %ebp
 53e:	c3                   	ret    
 53f:	90                   	nop    

00000540 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	31 f6                	xor    %esi,%esi
 547:	53                   	push   %ebx
 548:	83 ec 1c             	sub    $0x1c,%esp
 54b:	8b 7d 08             	mov    0x8(%ebp),%edi
 54e:	eb 06                	jmp    556 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 550:	3c 0d                	cmp    $0xd,%al
 552:	74 39                	je     58d <gets+0x4d>
 554:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 556:	8d 5e 01             	lea    0x1(%esi),%ebx
 559:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 55c:	7d 31                	jge    58f <gets+0x4f>
    cc = read(0, &c, 1);
 55e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 561:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 568:	00 
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 574:	e8 47 00 00 00       	call   5c0 <read>
    if(cc < 1)
 579:	85 c0                	test   %eax,%eax
 57b:	7e 12                	jle    58f <gets+0x4f>
      break;
    buf[i++] = c;
 57d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 581:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 585:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 589:	3c 0a                	cmp    $0xa,%al
 58b:	75 c3                	jne    550 <gets+0x10>
 58d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 58f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 593:	89 f8                	mov    %edi,%eax
 595:	83 c4 1c             	add    $0x1c,%esp
 598:	5b                   	pop    %ebx
 599:	5e                   	pop    %esi
 59a:	5f                   	pop    %edi
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    
 59d:	90                   	nop    
 59e:	90                   	nop    
 59f:	90                   	nop    

000005a0 <fork>:
 5a0:	b8 01 00 00 00       	mov    $0x1,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <exit>:
 5a8:	b8 02 00 00 00       	mov    $0x2,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <wait>:
 5b0:	b8 03 00 00 00       	mov    $0x3,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <pipe>:
 5b8:	b8 04 00 00 00       	mov    $0x4,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <read>:
 5c0:	b8 06 00 00 00       	mov    $0x6,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <write>:
 5c8:	b8 05 00 00 00       	mov    $0x5,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <close>:
 5d0:	b8 07 00 00 00       	mov    $0x7,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <kill>:
 5d8:	b8 08 00 00 00       	mov    $0x8,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <exec>:
 5e0:	b8 09 00 00 00       	mov    $0x9,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <open>:
 5e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <mknod>:
 5f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <unlink>:
 5f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <fstat>:
 600:	b8 0d 00 00 00       	mov    $0xd,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <link>:
 608:	b8 0e 00 00 00       	mov    $0xe,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <mkdir>:
 610:	b8 0f 00 00 00       	mov    $0xf,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <chdir>:
 618:	b8 10 00 00 00       	mov    $0x10,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <dup>:
 620:	b8 11 00 00 00       	mov    $0x11,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <getpid>:
 628:	b8 12 00 00 00       	mov    $0x12,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <sbrk>:
 630:	b8 13 00 00 00       	mov    $0x13,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <sleep>:
 638:	b8 14 00 00 00       	mov    $0x14,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	89 ce                	mov    %ecx,%esi
 647:	53                   	push   %ebx
 648:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 64b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 64e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 651:	85 c9                	test   %ecx,%ecx
 653:	74 04                	je     659 <printint+0x19>
 655:	85 d2                	test   %edx,%edx
 657:	78 77                	js     6d0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 659:	89 d0                	mov    %edx,%eax
 65b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 662:	31 db                	xor    %ebx,%ebx
 664:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 667:	90                   	nop    
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 668:	31 d2                	xor    %edx,%edx
 66a:	f7 f6                	div    %esi
 66c:	89 c1                	mov    %eax,%ecx
 66e:	0f b6 82 f1 0a 00 00 	movzbl 0xaf1(%edx),%eax
 675:	88 04 1f             	mov    %al,(%edi,%ebx,1)
 678:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 67b:	85 c9                	test   %ecx,%ecx
 67d:	89 c8                	mov    %ecx,%eax
 67f:	75 e7                	jne    668 <printint+0x28>
  if(neg)
 681:	8b 45 d0             	mov    -0x30(%ebp),%eax
 684:	85 c0                	test   %eax,%eax
 686:	74 08                	je     690 <printint+0x50>
    buf[i++] = '-';
 688:	c6 44 1d e3 2d       	movb   $0x2d,-0x1d(%ebp,%ebx,1)
 68d:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
 690:	8d 73 ff             	lea    -0x1(%ebx),%esi
 693:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
 696:	8d 7d f3             	lea    -0xd(%ebp),%edi
 699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 6a0:	0f b6 03             	movzbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6a3:	83 ee 01             	sub    $0x1,%esi
 6a6:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6a9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b0:	00 
 6b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
 6b5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
 6bb:	89 04 24             	mov    %eax,(%esp)
 6be:	e8 05 ff ff ff       	call   5c8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6c3:	83 fe ff             	cmp    $0xffffffff,%esi
 6c6:	75 d8                	jne    6a0 <printint+0x60>
    putc(fd, buf[i]);
}
 6c8:	83 c4 3c             	add    $0x3c,%esp
 6cb:	5b                   	pop    %ebx
 6cc:	5e                   	pop    %esi
 6cd:	5f                   	pop    %edi
 6ce:	5d                   	pop    %ebp
 6cf:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6d0:	89 d0                	mov    %edx,%eax
 6d2:	f7 d8                	neg    %eax
 6d4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
 6db:	eb 85                	jmp    662 <printint+0x22>
 6dd:	8d 76 00             	lea    0x0(%esi),%esi

000006e0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ec:	0f b6 02             	movzbl (%edx),%eax
 6ef:	84 c0                	test   %al,%al
 6f1:	0f 84 e9 00 00 00    	je     7e0 <printf+0x100>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 6f7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 6fa:	31 ff                	xor    %edi,%edi
 6fc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
 6ff:	31 f6                	xor    %esi,%esi
 701:	eb 21                	jmp    724 <printf+0x44>
 703:	90                   	nop    
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 708:	83 fb 25             	cmp    $0x25,%ebx
 70b:	0f 85 d7 00 00 00    	jne    7e8 <printf+0x108>
 711:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 715:	83 c7 01             	add    $0x1,%edi
 718:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 71c:	84 c0                	test   %al,%al
 71e:	0f 84 bc 00 00 00    	je     7e0 <printf+0x100>
    c = fmt[i] & 0xff;
    if(state == 0){
 724:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 726:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 729:	74 dd                	je     708 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72b:	83 fe 25             	cmp    $0x25,%esi
 72e:	75 e5                	jne    715 <printf+0x35>
      if(c == 'd'){
 730:	83 fb 64             	cmp    $0x64,%ebx
 733:	90                   	nop    
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 738:	0f 84 52 01 00 00    	je     890 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 73e:	83 fb 78             	cmp    $0x78,%ebx
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 748:	0f 84 c2 00 00 00    	je     810 <printf+0x130>
 74e:	83 fb 70             	cmp    $0x70,%ebx
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 758:	0f 84 b2 00 00 00    	je     810 <printf+0x130>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 75e:	83 fb 73             	cmp    $0x73,%ebx
 761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 768:	0f 84 ca 00 00 00    	je     838 <printf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76e:	83 fb 63             	cmp    $0x63,%ebx
 771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 778:	0f 84 62 01 00 00    	je     8e0 <printf+0x200>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 77e:	83 fb 25             	cmp    $0x25,%ebx
 781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 788:	0f 84 2a 01 00 00    	je     8b8 <printf+0x1d8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 78e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 791:	8d 55 f3             	lea    -0xd(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 794:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 797:	89 54 24 04          	mov    %edx,0x4(%esp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 79b:	31 f6                	xor    %esi,%esi
 79d:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a8:	00 
 7a9:	89 0c 24             	mov    %ecx,(%esp)
 7ac:	e8 17 fe ff ff       	call   5c8 <write>
 7b1:	8b 55 08             	mov    0x8(%ebp),%edx
 7b4:	8d 45 f3             	lea    -0xd(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7b7:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7ba:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7c1:	00 
 7c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c6:	89 14 24             	mov    %edx,(%esp)
 7c9:	e8 fa fd ff ff       	call   5c8 <write>
 7ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d1:	0f b6 04 3a          	movzbl (%edx,%edi,1),%eax
 7d5:	84 c0                	test   %al,%al
 7d7:	0f 85 47 ff ff ff    	jne    724 <printf+0x44>
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e0:	83 c4 2c             	add    $0x2c,%esp
 7e3:	5b                   	pop    %ebx
 7e4:	5e                   	pop    %esi
 7e5:	5f                   	pop    %edi
 7e6:	5d                   	pop    %ebp
 7e7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7e8:	8b 55 08             	mov    0x8(%ebp),%edx
 7eb:	8d 45 f3             	lea    -0xd(%ebp),%eax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 7ee:	88 5d f3             	mov    %bl,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7f8:	00 
 7f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fd:	89 14 24             	mov    %edx,(%esp)
 800:	e8 c3 fd ff ff       	call   5c8 <write>
 805:	8b 55 0c             	mov    0xc(%ebp),%edx
 808:	e9 08 ff ff ff       	jmp    715 <printf+0x35>
 80d:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 810:	8b 45 e0             	mov    -0x20(%ebp),%eax
 813:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 818:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 81a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 821:	8b 10                	mov    (%eax),%edx
 823:	8b 45 08             	mov    0x8(%ebp),%eax
 826:	e8 15 fe ff ff       	call   640 <printint>
 82b:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 82e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 832:	e9 de fe ff ff       	jmp    715 <printf+0x35>
 837:	90                   	nop    
      } else if(c == 's'){
        s = (char*)*ap;
 838:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 83b:	8b 19                	mov    (%ecx),%ebx
        ap++;
 83d:	83 c1 04             	add    $0x4,%ecx
 840:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        if(s == 0)
 843:	85 db                	test   %ebx,%ebx
 845:	0f 84 c5 00 00 00    	je     910 <printf+0x230>
          s = "(null)";
        while(*s != 0){
 84b:	0f b6 03             	movzbl (%ebx),%eax
 84e:	84 c0                	test   %al,%al
 850:	74 30                	je     882 <printf+0x1a2>
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 858:	8b 55 08             	mov    0x8(%ebp),%edx
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 85b:	83 c3 01             	add    $0x1,%ebx
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 85e:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 861:	8d 45 f3             	lea    -0xd(%ebp),%eax
 864:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 86b:	00 
 86c:	89 44 24 04          	mov    %eax,0x4(%esp)
 870:	89 14 24             	mov    %edx,(%esp)
 873:	e8 50 fd ff ff       	call   5c8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 878:	0f b6 03             	movzbl (%ebx),%eax
 87b:	84 c0                	test   %al,%al
 87d:	75 d9                	jne    858 <printf+0x178>
 87f:	8b 55 0c             	mov    0xc(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 882:	31 f6                	xor    %esi,%esi
 884:	e9 8c fe ff ff       	jmp    715 <printf+0x35>
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 890:	8b 45 e0             	mov    -0x20(%ebp),%eax
 893:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 898:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 89b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8a2:	8b 10                	mov    (%eax),%edx
 8a4:	8b 45 08             	mov    0x8(%ebp),%eax
 8a7:	e8 94 fd ff ff       	call   640 <printint>
 8ac:	8b 55 0c             	mov    0xc(%ebp),%edx
        ap++;
 8af:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 8b3:	e9 5d fe ff ff       	jmp    715 <printf+0x35>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8b8:	8b 45 08             	mov    0x8(%ebp),%eax
 8bb:	8d 4d f3             	lea    -0xd(%ebp),%ecx
 8be:	31 f6                	xor    %esi,%esi
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 8c0:	c6 45 f3 25          	movb   $0x25,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8cb:	00 
 8cc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8d0:	89 04 24             	mov    %eax,(%esp)
 8d3:	e8 f0 fc ff ff       	call   5c8 <write>
 8d8:	8b 55 0c             	mov    0xc(%ebp),%edx
 8db:	e9 35 fe ff ff       	jmp    715 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        ap++;
 8e3:	31 f6                	xor    %esi,%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8e5:	8b 55 08             	mov    0x8(%ebp),%edx
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8e8:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8ea:	89 14 24             	mov    %edx,(%esp)
 8ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8f4:	00 
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8f5:	88 45 f3             	mov    %al,-0xd(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8f8:	8d 45 f3             	lea    -0xd(%ebp),%eax
 8fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ff:	e8 c4 fc ff ff       	call   5c8 <write>
 904:	8b 55 0c             	mov    0xc(%ebp),%edx
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 907:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
 90b:	e9 05 fe ff ff       	jmp    715 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 910:	bb ea 0a 00 00       	mov    $0xaea,%ebx
 915:	e9 31 ff ff ff       	jmp    84b <printf+0x16b>
 91a:	90                   	nop    
 91b:	90                   	nop    
 91c:	90                   	nop    
 91d:	90                   	nop    
 91e:	90                   	nop    
 91f:	90                   	nop    

00000920 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 920:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 921:	8b 0d 1c 0b 00 00    	mov    0xb1c,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 927:	89 e5                	mov    %esp,%ebp
 929:	57                   	push   %edi
 92a:	56                   	push   %esi
 92b:	53                   	push   %ebx
 92c:	8b 7d 08             	mov    0x8(%ebp),%edi
  Header *bp, *p;

  bp = (Header*) ap - 1;
 92f:	8d 5f f8             	lea    -0x8(%edi),%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	39 d9                	cmp    %ebx,%ecx
 934:	73 24                	jae    95a <free+0x3a>
 936:	66 90                	xchg   %ax,%ax
 938:	8b 11                	mov    (%ecx),%edx
 93a:	39 d3                	cmp    %edx,%ebx
 93c:	72 2a                	jb     968 <free+0x48>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93e:	39 d1                	cmp    %edx,%ecx
 940:	72 10                	jb     952 <free+0x32>
 942:	39 d9                	cmp    %ebx,%ecx
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 948:	72 1e                	jb     968 <free+0x48>
 94a:	39 d3                	cmp    %edx,%ebx
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 950:	72 16                	jb     968 <free+0x48>
 952:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 954:	39 d9                	cmp    %ebx,%ecx
 956:	66 90                	xchg   %ax,%ax
 958:	72 de                	jb     938 <free+0x18>
 95a:	8b 11                	mov    (%ecx),%edx
 95c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 960:	eb dc                	jmp    93e <free+0x1e>
 962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 968:	8b 73 04             	mov    0x4(%ebx),%esi
 96b:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 96e:	39 d0                	cmp    %edx,%eax
 970:	74 1a                	je     98c <free+0x6c>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 972:	89 57 f8             	mov    %edx,-0x8(%edi)
  if(p + p->s.size == bp){
 975:	8b 51 04             	mov    0x4(%ecx),%edx
 978:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 97b:	39 d8                	cmp    %ebx,%eax
 97d:	74 22                	je     9a1 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 97f:	89 19                	mov    %ebx,(%ecx)
  freep = p;
 981:	89 0d 1c 0b 00 00    	mov    %ecx,0xb1c
}
 987:	5b                   	pop    %ebx
 988:	5e                   	pop    %esi
 989:	5f                   	pop    %edi
 98a:	5d                   	pop    %ebp
 98b:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 98c:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 98f:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 991:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 994:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 997:	89 47 f8             	mov    %eax,-0x8(%edi)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 99a:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 99d:	39 d8                	cmp    %ebx,%eax
 99f:	75 de                	jne    97f <free+0x5f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9a1:	8b 47 f8             	mov    -0x8(%edi),%eax
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9a4:	03 53 04             	add    0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
 9a7:	89 01                	mov    %eax,(%ecx)
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9a9:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 9ac:	89 0d 1c 0b 00 00    	mov    %ecx,0xb1c
}
 9b2:	5b                   	pop    %ebx
 9b3:	5e                   	pop    %esi
 9b4:	5f                   	pop    %edi
 9b5:	5d                   	pop    %ebp
 9b6:	c3                   	ret    
 9b7:	89 f6                	mov    %esi,%esi
 9b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9cc:	8b 15 1c 0b 00 00    	mov    0xb1c,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	83 c0 07             	add    $0x7,%eax
 9d5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 9d8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9da:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 9dd:	0f 84 95 00 00 00    	je     a78 <malloc+0xb8>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 9e5:	8b 41 04             	mov    0x4(%ecx),%eax
 9e8:	39 c3                	cmp    %eax,%ebx
 9ea:	76 1f                	jbe    a0b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 9ec:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9f3:	90                   	nop    
 9f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 9f8:	3b 0d 1c 0b 00 00    	cmp    0xb1c,%ecx
 9fe:	89 ca                	mov    %ecx,%edx
 a00:	74 34                	je     a36 <malloc+0x76>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a02:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 a04:	8b 41 04             	mov    0x4(%ecx),%eax
 a07:	39 c3                	cmp    %eax,%ebx
 a09:	77 ed                	ja     9f8 <malloc+0x38>
      if(p->s.size == nunits)
 a0b:	39 c3                	cmp    %eax,%ebx
 a0d:	74 21                	je     a30 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a0f:	29 d8                	sub    %ebx,%eax
 a11:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 a14:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 a17:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 a1a:	89 15 1c 0b 00 00    	mov    %edx,0xb1c
      return (void*) (p + 1);
 a20:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a23:	83 c4 0c             	add    $0xc,%esp
 a26:	5b                   	pop    %ebx
 a27:	5e                   	pop    %esi
 a28:	5f                   	pop    %edi
 a29:	5d                   	pop    %ebp
 a2a:	c3                   	ret    
 a2b:	90                   	nop    
 a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a30:	8b 01                	mov    (%ecx),%eax
 a32:	89 02                	mov    %eax,(%edx)
 a34:	eb e4                	jmp    a1a <malloc+0x5a>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 a36:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 a3c:	bf 00 10 00 00       	mov    $0x1000,%edi
 a41:	b8 00 80 00 00       	mov    $0x8000,%eax
 a46:	76 04                	jbe    a4c <malloc+0x8c>
 a48:	89 df                	mov    %ebx,%edi
 a4a:	89 f0                	mov    %esi,%eax
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 a4c:	89 04 24             	mov    %eax,(%esp)
 a4f:	e8 dc fb ff ff       	call   630 <sbrk>
  if(p == (char*) -1)
 a54:	83 f8 ff             	cmp    $0xffffffff,%eax
 a57:	74 18                	je     a71 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a59:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 a5c:	83 c0 08             	add    $0x8,%eax
 a5f:	89 04 24             	mov    %eax,(%esp)
 a62:	e8 b9 fe ff ff       	call   920 <free>
  return freep;
 a67:	8b 15 1c 0b 00 00    	mov    0xb1c,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a6d:	85 d2                	test   %edx,%edx
 a6f:	75 91                	jne    a02 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a71:	31 c0                	xor    %eax,%eax
 a73:	eb ae                	jmp    a23 <malloc+0x63>
 a75:	8d 76 00             	lea    0x0(%esi),%esi
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a78:	c7 05 1c 0b 00 00 14 	movl   $0xb14,0xb1c
 a7f:	0b 00 00 
    base.s.size = 0;
 a82:	ba 14 0b 00 00       	mov    $0xb14,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a87:	c7 05 14 0b 00 00 14 	movl   $0xb14,0xb14
 a8e:	0b 00 00 
    base.s.size = 0;
 a91:	c7 05 18 0b 00 00 00 	movl   $0x0,0xb18
 a98:	00 00 00 
 a9b:	e9 43 ff ff ff       	jmp    9e3 <malloc+0x23>
