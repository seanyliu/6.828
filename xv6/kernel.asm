
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <brelse>:
}

// Release the buffer b.
void
brelse(struct buf *b)
{
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	53                   	push   %ebx
  100004:	83 ec 04             	sub    $0x4,%esp
  100007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
  10000a:	f6 03 01             	testb  $0x1,(%ebx)
  10000d:	74 54                	je     100063 <brelse+0x63>
    panic("brelse");

  acquire(&bcache.lock);
  10000f:	c7 04 24 20 80 10 00 	movl   $0x108020,(%esp)
  100016:	e8 95 3e 00 00       	call   103eb0 <acquire>

  b->next->prev = b->prev;
  10001b:	8b 53 10             	mov    0x10(%ebx),%edx
  10001e:	8b 43 0c             	mov    0xc(%ebx),%eax
  b->next = bcache.head.next;
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  100021:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  if((b->flags & B_BUSY) == 0)
    panic("brelse");

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  100024:	89 42 0c             	mov    %eax,0xc(%edx)
  b->prev->next = b->next;
  100027:	8b 43 0c             	mov    0xc(%ebx),%eax
  b->next = bcache.head.next;
  b->prev = &bcache.head;
  10002a:	c7 43 0c 44 95 10 00 	movl   $0x109544,0xc(%ebx)
    panic("brelse");

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
  100034:	a1 54 95 10 00       	mov    0x109554,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
  10003c:	a1 54 95 10 00       	mov    0x109554,%eax
  bcache.head.next = b;
  100041:	89 1d 54 95 10 00    	mov    %ebx,0x109554

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bcache.head.next;
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);
  10004a:	89 1c 24             	mov    %ebx,(%esp)
  10004d:	e8 7e 31 00 00       	call   1031d0 <wakeup>

  release(&bcache.lock);
  100052:	c7 45 08 20 80 10 00 	movl   $0x108020,0x8(%ebp)
}
  100059:	83 c4 04             	add    $0x4,%esp
  10005c:	5b                   	pop    %ebx
  10005d:	5d                   	pop    %ebp
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);

  release(&bcache.lock);
  10005e:	e9 fd 3d 00 00       	jmp    103e60 <release>
// Release the buffer b.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100063:	c7 04 24 60 5f 10 00 	movl   $0x105f60,(%esp)
  10006a:	e8 11 08 00 00       	call   100880 <panic>
  10006f:	90                   	nop    

00100070 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b, char* caller)
{
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	53                   	push   %ebx
  100074:	83 ec 14             	sub    $0x14,%esp
  100077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("%s : bwrite sector %d\n", caller, b->sector);
  10007a:	8b 43 08             	mov    0x8(%ebx),%eax
  10007d:	89 44 24 08          	mov    %eax,0x8(%esp)
  100081:	8b 45 0c             	mov    0xc(%ebp),%eax
  100084:	c7 04 24 67 5f 10 00 	movl   $0x105f67,(%esp)
  10008b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10008f:	e8 0c 04 00 00       	call   1004a0 <cprintf>
  if((b->flags & B_BUSY) == 0)
  100094:	8b 03                	mov    (%ebx),%eax
  100096:	a8 01                	test   $0x1,%al
  100098:	74 12                	je     1000ac <bwrite+0x3c>
    panic("bwrite");
  b->flags |= B_DIRTY;
  10009a:	83 c8 04             	or     $0x4,%eax
  10009d:	89 03                	mov    %eax,(%ebx)
  iderw(b);
  10009f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  1000a2:	83 c4 14             	add    $0x14,%esp
  1000a5:	5b                   	pop    %ebx
  1000a6:	5d                   	pop    %ebp
{
  cprintf("%s : bwrite sector %d\n", caller, b->sector);
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
  1000a7:	e9 e4 1e 00 00       	jmp    101f90 <iderw>
void
bwrite(struct buf *b, char* caller)
{
  cprintf("%s : bwrite sector %d\n", caller, b->sector);
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  1000ac:	c7 04 24 7e 5f 10 00 	movl   $0x105f7e,(%esp)
  1000b3:	e8 c8 07 00 00       	call   100880 <panic>
  1000b8:	90                   	nop    
  1000b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001000c0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
  1000c0:	55                   	push   %ebp
  1000c1:	89 e5                	mov    %esp,%ebp
  1000c3:	57                   	push   %edi
  1000c4:	56                   	push   %esi
  1000c5:	53                   	push   %ebx
  1000c6:	83 ec 0c             	sub    $0xc,%esp
  1000c9:	8b 75 08             	mov    0x8(%ebp),%esi
  1000cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint sector)
{
  struct buf *b;

  acquire(&bcache.lock);
  1000cf:	c7 04 24 20 80 10 00 	movl   $0x108020,(%esp)
  1000d6:	e8 d5 3d 00 00       	call   103eb0 <acquire>

 loop:
  // Try for cached block.
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  1000db:	8b 1d 54 95 10 00    	mov    0x109554,%ebx
  1000e1:	81 fb 44 95 10 00    	cmp    $0x109544,%ebx
  1000e7:	75 12                	jne    1000fb <bread+0x3b>
  1000e9:	eb 3d                	jmp    100128 <bread+0x68>
  1000eb:	90                   	nop    
  1000ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000f0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000f3:	81 fb 44 95 10 00    	cmp    $0x109544,%ebx
  1000f9:	74 2d                	je     100128 <bread+0x68>
    if(b->dev == dev && b->sector == sector){
  1000fb:	3b 73 04             	cmp    0x4(%ebx),%esi
  1000fe:	66 90                	xchg   %ax,%ax
  100100:	75 ee                	jne    1000f0 <bread+0x30>
  100102:	3b 7b 08             	cmp    0x8(%ebx),%edi
  100105:	75 e9                	jne    1000f0 <bread+0x30>
      if(!(b->flags & B_BUSY)){
  100107:	8b 03                	mov    (%ebx),%eax
  100109:	a8 01                	test   $0x1,%al
  10010b:	90                   	nop    
  10010c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100110:	74 75                	je     100187 <bread+0xc7>
        b->flags |= B_BUSY;
        release(&bcache.lock);
        return b;
      }
      sleep(b, &bcache.lock);
  100112:	c7 44 24 04 20 80 10 	movl   $0x108020,0x4(%esp)
  100119:	00 
  10011a:	89 1c 24             	mov    %ebx,(%esp)
  10011d:	e8 fe 32 00 00       	call   103420 <sleep>
  100122:	eb b7                	jmp    1000db <bread+0x1b>
  100124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      goto loop;
    }
  }

  // Allocate fresh block.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  100128:	a1 50 95 10 00       	mov    0x109550,%eax
  10012d:	3d 44 95 10 00       	cmp    $0x109544,%eax
  100132:	75 0e                	jne    100142 <bread+0x82>
  100134:	eb 45                	jmp    10017b <bread+0xbb>
  100136:	66 90                	xchg   %ax,%ax
  100138:	8b 40 0c             	mov    0xc(%eax),%eax
  10013b:	3d 44 95 10 00       	cmp    $0x109544,%eax
  100140:	74 39                	je     10017b <bread+0xbb>
    if((b->flags & B_BUSY) == 0){
  100142:	f6 00 01             	testb  $0x1,(%eax)
  100145:	8d 76 00             	lea    0x0(%esi),%esi
  100148:	75 ee                	jne    100138 <bread+0x78>
      b->dev = dev;
  10014a:	89 70 04             	mov    %esi,0x4(%eax)
    }
  }

  // Allocate fresh block.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if((b->flags & B_BUSY) == 0){
  10014d:	89 c3                	mov    %eax,%ebx
      b->dev = dev;
      b->sector = sector;
  10014f:	89 78 08             	mov    %edi,0x8(%eax)
      b->flags = B_BUSY;
  100152:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
  100158:	c7 04 24 20 80 10 00 	movl   $0x108020,(%esp)
  10015f:	e8 fc 3c 00 00       	call   103e60 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  100164:	f6 03 02             	testb  $0x2,(%ebx)
  100167:	75 08                	jne    100171 <bread+0xb1>
    iderw(b);
  100169:	89 1c 24             	mov    %ebx,(%esp)
  10016c:	e8 1f 1e 00 00       	call   101f90 <iderw>
  return b;
}
  100171:	83 c4 0c             	add    $0xc,%esp
  100174:	89 d8                	mov    %ebx,%eax
  100176:	5b                   	pop    %ebx
  100177:	5e                   	pop    %esi
  100178:	5f                   	pop    %edi
  100179:	5d                   	pop    %ebp
  10017a:	c3                   	ret    
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
  10017b:	c7 04 24 85 5f 10 00 	movl   $0x105f85,(%esp)
  100182:	e8 f9 06 00 00       	call   100880 <panic>
 loop:
  // Try for cached block.
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->sector == sector){
      if(!(b->flags & B_BUSY)){
        b->flags |= B_BUSY;
  100187:	83 c8 01             	or     $0x1,%eax
  10018a:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
  10018c:	c7 04 24 20 80 10 00 	movl   $0x108020,(%esp)
  100193:	e8 c8 3c 00 00       	call   103e60 <release>
  100198:	eb ca                	jmp    100164 <bread+0xa4>
  10019a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001001a0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
  1001a0:	55                   	push   %ebp
  1001a1:	89 e5                	mov    %esp,%ebp
  1001a3:	83 ec 08             	sub    $0x8,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
  1001a6:	c7 44 24 04 96 5f 10 	movl   $0x105f96,0x4(%esp)
  1001ad:	00 
  1001ae:	c7 04 24 20 80 10 00 	movl   $0x108020,(%esp)
  1001b5:	e8 66 3b 00 00       	call   103d20 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  1001ba:	ba 54 80 10 00       	mov    $0x108054,%edx
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  1001bf:	c7 05 50 95 10 00 44 	movl   $0x109544,0x109550
  1001c6:	95 10 00 
  bcache.head.next = &bcache.head;
  1001c9:	c7 05 54 95 10 00 44 	movl   $0x109544,0x109554
  1001d0:	95 10 00 
  1001d3:	90                   	nop    
  1001d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
  1001d8:	a1 54 95 10 00       	mov    0x109554,%eax
    b->prev = &bcache.head;
  1001dd:	c7 42 0c 44 95 10 00 	movl   $0x109544,0xc(%edx)
    b->dev = -1;
  1001e4:	c7 42 04 ff ff ff ff 	movl   $0xffffffff,0x4(%edx)

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
  1001eb:	89 42 10             	mov    %eax,0x10(%edx)
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
  1001ee:	a1 54 95 10 00       	mov    0x109554,%eax
    bcache.head.next = b;
  1001f3:	89 15 54 95 10 00    	mov    %edx,0x109554
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
  1001f9:	89 50 0c             	mov    %edx,0xc(%eax)
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  1001fc:	81 c2 18 02 00 00    	add    $0x218,%edx
  100202:	81 fa 44 95 10 00    	cmp    $0x109544,%edx
  100208:	75 ce                	jne    1001d8 <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    
  10020c:	90                   	nop    
  10020d:	90                   	nop    
  10020e:	90                   	nop    
  10020f:	90                   	nop    

00100210 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
  100213:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
  100216:	c7 44 24 04 9d 5f 10 	movl   $0x105f9d,0x4(%esp)
  10021d:	00 
  10021e:	c7 04 24 80 7f 10 00 	movl   $0x107f80,(%esp)
  100225:	e8 f6 3a 00 00       	call   103d20 <initlock>
  initlock(&input.lock, "input");
  10022a:	c7 44 24 04 a5 5f 10 	movl   $0x105fa5,0x4(%esp)
  100231:	00 
  100232:	c7 04 24 60 97 10 00 	movl   $0x109760,(%esp)
  100239:	e8 e2 3a 00 00       	call   103d20 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
  10023e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
consoleinit(void)
{
  initlock(&cons.lock, "console");
  initlock(&input.lock, "input");

  devsw[CONSOLE].write = consolewrite;
  100245:	c7 05 cc a1 10 00 b0 	movl   $0x1003b0,0x10a1cc
  10024c:	03 10 00 
  devsw[CONSOLE].read = consoleread;
  10024f:	c7 05 c8 a1 10 00 10 	movl   $0x100610,0x10a1c8
  100256:	06 10 00 
  cons.locking = 1;
  100259:	c7 05 b4 7f 10 00 01 	movl   $0x1,0x107fb4
  100260:	00 00 00 

  picenable(IRQ_KBD);
  100263:	e8 68 2a 00 00       	call   102cd0 <picenable>
  ioapicenable(IRQ_KBD, 0);
  100268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10026f:	00 
  100270:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100277:	e8 44 1f 00 00       	call   1021c0 <ioapicenable>
}
  10027c:	c9                   	leave  
  10027d:	c3                   	ret    
  10027e:	66 90                	xchg   %ax,%ax

00100280 <consputc>:
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  100280:	55                   	push   %ebp
  100281:	89 e5                	mov    %esp,%ebp
  100283:	57                   	push   %edi
  100284:	56                   	push   %esi
  100285:	89 c6                	mov    %eax,%esi
  100287:	53                   	push   %ebx
  100288:	83 ec 0c             	sub    $0xc,%esp
  if(panicked){
  10028b:	a1 60 7f 10 00       	mov    0x107f60,%eax
  100290:	85 c0                	test   %eax,%eax
  100292:	74 03                	je     100297 <consputc+0x17>
}

static inline void
cli(void)
{
  asm volatile("cli");
  100294:	fa                   	cli    
  100295:	eb fe                	jmp    100295 <consputc+0x15>
    cli();
    for(;;)
      ;
  }

  uartputc(c);
  100297:	89 34 24             	mov    %esi,(%esp)
  10029a:	e8 31 51 00 00       	call   1053d0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10029f:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  1002a4:	b8 0e 00 00 00       	mov    $0xe,%eax
  1002a9:	89 ca                	mov    %ecx,%edx
  1002ab:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1002ac:	bf d5 03 00 00       	mov    $0x3d5,%edi
  1002b1:	89 fa                	mov    %edi,%edx
  1002b3:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  1002b4:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1002b7:	89 ca                	mov    %ecx,%edx
  1002b9:	c1 e3 08             	shl    $0x8,%ebx
  1002bc:	b8 0f 00 00 00       	mov    $0xf,%eax
  1002c1:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1002c2:	89 fa                	mov    %edi,%edx
  1002c4:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
  1002c5:	0f b6 c0             	movzbl %al,%eax
  1002c8:	09 c3                	or     %eax,%ebx

  if(c == '\n')
  1002ca:	83 fe 0a             	cmp    $0xa,%esi
  1002cd:	74 63                	je     100332 <consputc+0xb2>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
  1002cf:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  1002d5:	0f 84 b8 00 00 00    	je     100393 <consputc+0x113>
    if(pos > 0)
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  1002db:	89 f0                	mov    %esi,%eax
  1002dd:	66 25 ff 00          	and    $0xff,%ax
  1002e1:	80 cc 07             	or     $0x7,%ah
  1002e4:	66 89 84 1b 00 80 0b 	mov    %ax,0xb8000(%ebx,%ebx,1)
  1002eb:	00 
  1002ec:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
  1002ef:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  1002f5:	7f 52                	jg     100349 <consputc+0xc9>
  1002f7:	8d 34 1b             	lea    (%ebx,%ebx,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1002fa:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  1002ff:	b8 0e 00 00 00       	mov    $0xe,%eax
  100304:	89 ca                	mov    %ecx,%edx
  100306:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
  100307:	bf d5 03 00 00       	mov    $0x3d5,%edi
  10030c:	89 d8                	mov    %ebx,%eax
  10030e:	c1 f8 08             	sar    $0x8,%eax
  100311:	89 fa                	mov    %edi,%edx
  100313:	ee                   	out    %al,(%dx)
  100314:	b8 0f 00 00 00       	mov    $0xf,%eax
  100319:	89 ca                	mov    %ecx,%edx
  10031b:	ee                   	out    %al,(%dx)
  10031c:	89 d8                	mov    %ebx,%eax
  10031e:	89 fa                	mov    %edi,%edx
  100320:	ee                   	out    %al,(%dx)
  100321:	66 c7 86 00 80 0b 00 	movw   $0x720,0xb8000(%esi)
  100328:	20 07 
      ;
  }

  uartputc(c);
  cgaputc(c);
}
  10032a:	83 c4 0c             	add    $0xc,%esp
  10032d:	5b                   	pop    %ebx
  10032e:	5e                   	pop    %esi
  10032f:	5f                   	pop    %edi
  100330:	5d                   	pop    %ebp
  100331:	c3                   	ret    
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  100332:	89 d8                	mov    %ebx,%eax
  100334:	ba 67 66 66 66       	mov    $0x66666667,%edx
  100339:	f7 ea                	imul   %edx
  10033b:	c1 ea 05             	shr    $0x5,%edx
  10033e:	8d 14 92             	lea    (%edx,%edx,4),%edx
  100341:	c1 e2 04             	shl    $0x4,%edx
  100344:	8d 5a 50             	lea    0x50(%edx),%ebx
  100347:	eb a6                	jmp    1002ef <consputc+0x6f>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
  100349:	83 eb 50             	sub    $0x50,%ebx
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  10034c:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  100353:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100354:	8d 34 1b             	lea    (%ebx,%ebx,1),%esi
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  100357:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  10035e:	00 
  10035f:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  100366:	e8 75 3c 00 00       	call   103fe0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10036b:	b8 80 07 00 00       	mov    $0x780,%eax
  100370:	29 d8                	sub    %ebx,%eax
  100372:	01 c0                	add    %eax,%eax
  100374:	89 44 24 08          	mov    %eax,0x8(%esp)
  100378:	8d 86 00 80 0b 00    	lea    0xb8000(%esi),%eax
  10037e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100385:	00 
  100386:	89 04 24             	mov    %eax,(%esp)
  100389:	e8 c2 3b 00 00       	call   103f50 <memset>
  10038e:	e9 67 ff ff ff       	jmp    1002fa <consputc+0x7a>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0)
  100393:	85 db                	test   %ebx,%ebx
  100395:	0f 8e 5c ff ff ff    	jle    1002f7 <consputc+0x77>
      crt[--pos] = ' ' | 0x0700;
  10039b:	83 eb 01             	sub    $0x1,%ebx
  10039e:	66 c7 84 1b 00 80 0b 	movw   $0x720,0xb8000(%ebx,%ebx,1)
  1003a5:	00 20 07 
  1003a8:	e9 42 ff ff ff       	jmp    1002ef <consputc+0x6f>
  1003ad:	8d 76 00             	lea    0x0(%esi),%esi

001003b0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  1003b0:	55                   	push   %ebp
  1003b1:	89 e5                	mov    %esp,%ebp
  1003b3:	57                   	push   %edi
  1003b4:	56                   	push   %esi
  1003b5:	53                   	push   %ebx
  1003b6:	83 ec 0c             	sub    $0xc,%esp
  int i;

  iunlock(ip);
  1003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  1003bc:	8b 75 10             	mov    0x10(%ebp),%esi
  1003bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
  1003c2:	89 04 24             	mov    %eax,(%esp)
  1003c5:	e8 96 13 00 00       	call   101760 <iunlock>
  acquire(&cons.lock);
  1003ca:	c7 04 24 80 7f 10 00 	movl   $0x107f80,(%esp)
  1003d1:	e8 da 3a 00 00       	call   103eb0 <acquire>
  for(i = 0; i < n; i++)
  1003d6:	85 f6                	test   %esi,%esi
  1003d8:	7e 16                	jle    1003f0 <consolewrite+0x40>
  1003da:	31 db                	xor    %ebx,%ebx
  1003dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
  1003e0:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
  1003e4:	83 c3 01             	add    $0x1,%ebx
    consputc(buf[i] & 0xff);
  1003e7:	e8 94 fe ff ff       	call   100280 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
  1003ec:	39 de                	cmp    %ebx,%esi
  1003ee:	7f f0                	jg     1003e0 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  1003f0:	c7 04 24 80 7f 10 00 	movl   $0x107f80,(%esp)
  1003f7:	e8 64 3a 00 00       	call   103e60 <release>
  ilock(ip);
  1003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ff:	89 04 24             	mov    %eax,(%esp)
  100402:	e8 e9 17 00 00       	call   101bf0 <ilock>

  return n;
}
  100407:	83 c4 0c             	add    $0xc,%esp
  10040a:	89 f0                	mov    %esi,%eax
  10040c:	5b                   	pop    %ebx
  10040d:	5e                   	pop    %esi
  10040e:	5f                   	pop    %edi
  10040f:	5d                   	pop    %ebp
  100410:	c3                   	ret    
  100411:	eb 0d                	jmp    100420 <printint>
  100413:	90                   	nop    
  100414:	90                   	nop    
  100415:	90                   	nop    
  100416:	90                   	nop    
  100417:	90                   	nop    
  100418:	90                   	nop    
  100419:	90                   	nop    
  10041a:	90                   	nop    
  10041b:	90                   	nop    
  10041c:	90                   	nop    
  10041d:	90                   	nop    
  10041e:	90                   	nop    
  10041f:	90                   	nop    

00100420 <printint>:
	int locking;
} cons;

static void
printint(int xx, int base, int sgn)
{
  100420:	55                   	push   %ebp
  100421:	89 e5                	mov    %esp,%ebp
  100423:	57                   	push   %edi
  100424:	56                   	push   %esi
  100425:	89 d6                	mov    %edx,%esi
  100427:	53                   	push   %ebx
  100428:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  10042b:	85 c9                	test   %ecx,%ecx
  10042d:	74 04                	je     100433 <printint+0x13>
  10042f:	85 c0                	test   %eax,%eax
  100431:	78 58                	js     10048b <printint+0x6b>
    neg = 1;
    x = -xx;
  } else
    x = xx;
  100433:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  10043a:	31 db                	xor    %ebx,%ebx
  10043c:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  10043f:	90                   	nop    

  do{
    buf[i++] = digits[x % base];
  100440:	31 d2                	xor    %edx,%edx
  100442:	f7 f6                	div    %esi
  100444:	89 c1                	mov    %eax,%ecx
  100446:	0f b6 82 c5 5f 10 00 	movzbl 0x105fc5(%edx),%eax
  10044d:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  100450:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
  100453:	85 c9                	test   %ecx,%ecx
  100455:	89 c8                	mov    %ecx,%eax
  100457:	75 e7                	jne    100440 <printint+0x20>
  if(neg)
  100459:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10045c:	85 d2                	test   %edx,%edx
  10045e:	74 08                	je     100468 <printint+0x48>
    buf[i++] = '-';
  100460:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
  100465:	83 c3 01             	add    $0x1,%ebx

  while(--i >= 0)
  100468:	8d 73 ff             	lea    -0x1(%ebx),%esi
  10046b:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
  10046e:	66 90                	xchg   %ax,%ax
    consputc(buf[i]);
  100470:	0f be 03             	movsbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  100473:	83 ee 01             	sub    $0x1,%esi
  100476:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
  100479:	e8 02 fe ff ff       	call   100280 <consputc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  10047e:	83 fe ff             	cmp    $0xffffffff,%esi
  100481:	75 ed                	jne    100470 <printint+0x50>
    consputc(buf[i]);
}
  100483:	83 c4 1c             	add    $0x1c,%esp
  100486:	5b                   	pop    %ebx
  100487:	5e                   	pop    %esi
  100488:	5f                   	pop    %edi
  100489:	5d                   	pop    %ebp
  10048a:	c3                   	ret    
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  10048b:	f7 d8                	neg    %eax
  10048d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  100494:	eb a4                	jmp    10043a <printint+0x1a>
  100496:	8d 76 00             	lea    0x0(%esi),%esi
  100499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001004a0 <cprintf>:
}

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1004a0:	55                   	push   %ebp
  1004a1:	89 e5                	mov    %esp,%ebp
  1004a3:	57                   	push   %edi
  1004a4:	56                   	push   %esi
  1004a5:	53                   	push   %ebx
  1004a6:	83 ec 0c             	sub    $0xc,%esp
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  1004a9:	a1 b4 7f 10 00       	mov    0x107fb4,%eax
  if(locking)
  1004ae:	85 c0                	test   %eax,%eax
{
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  1004b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(locking)
  1004b3:	0f 85 2f 01 00 00    	jne    1005e8 <cprintf+0x148>
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  1004b9:	8b 55 08             	mov    0x8(%ebp),%edx
  1004bc:	0f b6 02             	movzbl (%edx),%eax
  1004bf:	85 c0                	test   %eax,%eax
  1004c1:	0f 84 99 00 00 00    	je     100560 <cprintf+0xc0>

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  1004c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  1004ca:	31 f6                	xor    %esi,%esi
  1004cc:	eb 3d                	jmp    10050b <cprintf+0x6b>
  1004ce:	66 90                	xchg   %ax,%ax
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
  1004d0:	83 fb 25             	cmp    $0x25,%ebx
  1004d3:	0f 84 c7 00 00 00    	je     1005a0 <cprintf+0x100>
  1004d9:	83 fb 64             	cmp    $0x64,%ebx
  1004dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1004e0:	0f 84 9a 00 00 00    	je     100580 <cprintf+0xe0>
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
  1004e6:	b8 25 00 00 00       	mov    $0x25,%eax
  1004eb:	90                   	nop    
  1004ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1004f0:	e8 8b fd ff ff       	call   100280 <consputc>
      consputc(c);
  1004f5:	89 d8                	mov    %ebx,%eax
  1004f7:	90                   	nop    
  1004f8:	e8 83 fd ff ff       	call   100280 <consputc>
  1004fd:	8b 55 08             	mov    0x8(%ebp),%edx
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100500:	83 c6 01             	add    $0x1,%esi
  100503:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
  100507:	85 c0                	test   %eax,%eax
  100509:	74 55                	je     100560 <cprintf+0xc0>
    if(c != '%'){
  10050b:	83 f8 25             	cmp    $0x25,%eax
  10050e:	75 e8                	jne    1004f8 <cprintf+0x58>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
  100510:	83 c6 01             	add    $0x1,%esi
  100513:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
  100517:	85 db                	test   %ebx,%ebx
  100519:	74 45                	je     100560 <cprintf+0xc0>
      break;
    switch(c){
  10051b:	83 fb 70             	cmp    $0x70,%ebx
  10051e:	74 1a                	je     10053a <cprintf+0x9a>
  100520:	7e ae                	jle    1004d0 <cprintf+0x30>
  100522:	83 fb 73             	cmp    $0x73,%ebx
  100525:	8d 76 00             	lea    0x0(%esi),%esi
  100528:	0f 84 8a 00 00 00    	je     1005b8 <cprintf+0x118>
  10052e:	83 fb 78             	cmp    $0x78,%ebx
  100531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100538:	75 ac                	jne    1004e6 <cprintf+0x46>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  10053a:	8b 07                	mov    (%edi),%eax
  10053c:	31 c9                	xor    %ecx,%ecx
  10053e:	ba 10 00 00 00       	mov    $0x10,%edx
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100543:	83 c6 01             	add    $0x1,%esi
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  100546:	83 c7 04             	add    $0x4,%edi
  100549:	e8 d2 fe ff ff       	call   100420 <printint>
  10054e:	8b 55 08             	mov    0x8(%ebp),%edx
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100551:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
  100555:	85 c0                	test   %eax,%eax
  100557:	75 b2                	jne    10050b <cprintf+0x6b>
  100559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc(c);
      break;
    }
  }

  if(locking)
  100560:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100563:	85 c9                	test   %ecx,%ecx
  100565:	74 0c                	je     100573 <cprintf+0xd3>
    release(&cons.lock);
  100567:	c7 04 24 80 7f 10 00 	movl   $0x107f80,(%esp)
  10056e:	e8 ed 38 00 00       	call   103e60 <release>
}
  100573:	83 c4 0c             	add    $0xc,%esp
  100576:	5b                   	pop    %ebx
  100577:	5e                   	pop    %esi
  100578:	5f                   	pop    %edi
  100579:	5d                   	pop    %ebp
  10057a:	c3                   	ret    
  10057b:	90                   	nop    
  10057c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
  100580:	8b 07                	mov    (%edi),%eax
  100582:	ba 0a 00 00 00       	mov    $0xa,%edx
  100587:	b9 01 00 00 00       	mov    $0x1,%ecx
  10058c:	83 c7 04             	add    $0x4,%edi
  10058f:	e8 8c fe ff ff       	call   100420 <printint>
  100594:	8b 55 08             	mov    0x8(%ebp),%edx
  100597:	e9 64 ff ff ff       	jmp    100500 <cprintf+0x60>
  10059c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
  1005a0:	b8 25 00 00 00       	mov    $0x25,%eax
  1005a5:	e8 d6 fc ff ff       	call   100280 <consputc>
  1005aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1005ad:	8d 76 00             	lea    0x0(%esi),%esi
  1005b0:	e9 4b ff ff ff       	jmp    100500 <cprintf+0x60>
  1005b5:	8d 76 00             	lea    0x0(%esi),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
  1005b8:	8b 1f                	mov    (%edi),%ebx
  1005ba:	83 c7 04             	add    $0x4,%edi
  1005bd:	85 db                	test   %ebx,%ebx
  1005bf:	74 3f                	je     100600 <cprintf+0x160>
        s = "(null)";
      for(; *s; s++)
  1005c1:	0f b6 03             	movzbl (%ebx),%eax
  1005c4:	84 c0                	test   %al,%al
  1005c6:	0f 84 34 ff ff ff    	je     100500 <cprintf+0x60>
  1005cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        consputc(*s);
  1005d0:	0f be c0             	movsbl %al,%eax
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
  1005d3:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
  1005d6:	e8 a5 fc ff ff       	call   100280 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
  1005db:	0f b6 03             	movzbl (%ebx),%eax
  1005de:	84 c0                	test   %al,%al
  1005e0:	75 ee                	jne    1005d0 <cprintf+0x130>
  1005e2:	e9 16 ff ff ff       	jmp    1004fd <cprintf+0x5d>
  1005e7:	90                   	nop    
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
  1005e8:	c7 04 24 80 7f 10 00 	movl   $0x107f80,(%esp)
  1005ef:	e8 bc 38 00 00       	call   103eb0 <acquire>
  1005f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1005f8:	e9 bc fe ff ff       	jmp    1004b9 <cprintf+0x19>
  1005fd:	8d 76 00             	lea    0x0(%esi),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
  100600:	bb ab 5f 10 00       	mov    $0x105fab,%ebx
  100605:	eb ba                	jmp    1005c1 <cprintf+0x121>
  100607:	89 f6                	mov    %esi,%esi
  100609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100610 <consoleread>:
  release(&input.lock);
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  100610:	55                   	push   %ebp
  100611:	89 e5                	mov    %esp,%ebp
  100613:	57                   	push   %edi
  100614:	56                   	push   %esi
  100615:	53                   	push   %ebx
  100616:	83 ec 0c             	sub    $0xc,%esp
  100619:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
  10061c:	8b 45 08             	mov    0x8(%ebp),%eax
  release(&input.lock);
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  10061f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint target;
  int c;

  iunlock(ip);
  100622:	89 04 24             	mov    %eax,(%esp)
  100625:	e8 36 11 00 00       	call   101760 <iunlock>
  target = n;
  10062a:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  acquire(&input.lock);
  10062d:	c7 04 24 60 97 10 00 	movl   $0x109760,(%esp)
  100634:	e8 77 38 00 00       	call   103eb0 <acquire>
  while(n > 0){
  100639:	85 db                	test   %ebx,%ebx
  10063b:	7f 2c                	jg     100669 <consoleread+0x59>
  10063d:	e9 bf 00 00 00       	jmp    100701 <consoleread+0xf1>
  100642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(input.r == input.w){
      if(proc->killed){
  100648:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10064e:	8b 70 24             	mov    0x24(%eax),%esi
  100651:	85 f6                	test   %esi,%esi
  100653:	75 53                	jne    1006a8 <consoleread+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  100655:	c7 44 24 04 60 97 10 	movl   $0x109760,0x4(%esp)
  10065c:	00 
  10065d:	c7 04 24 14 98 10 00 	movl   $0x109814,(%esp)
  100664:	e8 b7 2d 00 00       	call   103420 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100669:	8b 15 14 98 10 00    	mov    0x109814,%edx
  10066f:	3b 15 18 98 10 00    	cmp    0x109818,%edx
  100675:	74 d1                	je     100648 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  100677:	89 d0                	mov    %edx,%eax
  100679:	83 e0 7f             	and    $0x7f,%eax
  10067c:	0f b6 88 94 97 10 00 	movzbl 0x109794(%eax),%ecx
  100683:	8d 42 01             	lea    0x1(%edx),%eax
  100686:	a3 14 98 10 00       	mov    %eax,0x109814
  10068b:	0f be f1             	movsbl %cl,%esi
    if(c == C('D')){  // EOF
  10068e:	83 fe 04             	cmp    $0x4,%esi
  100691:	74 3b                	je     1006ce <consoleread+0xbe>
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
  100693:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
  100696:	83 fe 0a             	cmp    $0xa,%esi
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  100699:	88 0f                	mov    %cl,(%edi)
    --n;
    if(c == '\n')
  10069b:	74 3c                	je     1006d9 <consoleread+0xc9>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
  10069d:	85 db                	test   %ebx,%ebx
  10069f:	7e 38                	jle    1006d9 <consoleread+0xc9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1006a1:	83 c7 01             	add    $0x1,%edi
  1006a4:	eb c3                	jmp    100669 <consoleread+0x59>
  1006a6:	66 90                	xchg   %ax,%ax
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&input.lock);
  1006a8:	c7 04 24 60 97 10 00 	movl   $0x109760,(%esp)
        ilock(ip);
  1006af:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&input.lock);
  1006b4:	e8 a7 37 00 00       	call   103e60 <release>
        ilock(ip);
  1006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bc:	89 04 24             	mov    %eax,(%esp)
  1006bf:	e8 2c 15 00 00       	call   101bf0 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  1006c4:	83 c4 0c             	add    $0xc,%esp
  1006c7:	89 d8                	mov    %ebx,%eax
  1006c9:	5b                   	pop    %ebx
  1006ca:	5e                   	pop    %esi
  1006cb:	5f                   	pop    %edi
  1006cc:	5d                   	pop    %ebp
  1006cd:	c3                   	ret    
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
  1006ce:	39 5d f0             	cmp    %ebx,-0x10(%ebp)
  1006d1:	76 06                	jbe    1006d9 <consoleread+0xc9>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  1006d3:	89 15 14 98 10 00    	mov    %edx,0x109814
  1006d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006dc:	29 d8                	sub    %ebx,%eax
  1006de:	89 c3                	mov    %eax,%ebx
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  1006e0:	c7 04 24 60 97 10 00 	movl   $0x109760,(%esp)
  1006e7:	e8 74 37 00 00       	call   103e60 <release>
  ilock(ip);
  1006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ef:	89 04 24             	mov    %eax,(%esp)
  1006f2:	e8 f9 14 00 00       	call   101bf0 <ilock>

  return target - n;
}
  1006f7:	83 c4 0c             	add    $0xc,%esp
  1006fa:	89 d8                	mov    %ebx,%eax
  1006fc:	5b                   	pop    %ebx
  1006fd:	5e                   	pop    %esi
  1006fe:	5f                   	pop    %edi
  1006ff:	5d                   	pop    %ebp
  100700:	c3                   	ret    
  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
  100701:	31 db                	xor    %ebx,%ebx
  100703:	eb db                	jmp    1006e0 <consoleread+0xd0>
  100705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100710 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100710:	55                   	push   %ebp
  100711:	89 e5                	mov    %esp,%ebp
  100713:	57                   	push   %edi
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
  100714:	bf 90 97 10 00       	mov    $0x109790,%edi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100719:	56                   	push   %esi
  10071a:	53                   	push   %ebx
  10071b:	83 ec 0c             	sub    $0xc,%esp
  10071e:	8b 75 08             	mov    0x8(%ebp),%esi
  int c;

  acquire(&input.lock);
  100721:	c7 04 24 60 97 10 00 	movl   $0x109760,(%esp)
  100728:	e8 83 37 00 00       	call   103eb0 <acquire>
  10072d:	8d 76 00             	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
  100730:	ff d6                	call   *%esi
  100732:	85 c0                	test   %eax,%eax
  100734:	89 c3                	mov    %eax,%ebx
  100736:	0f 88 a4 00 00 00    	js     1007e0 <consoleintr+0xd0>
    switch(c){
  10073c:	83 fb 10             	cmp    $0x10,%ebx
  10073f:	90                   	nop    
  100740:	0f 84 ea 00 00 00    	je     100830 <consoleintr+0x120>
  100746:	83 fb 15             	cmp    $0x15,%ebx
  100749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100750:	0f 84 c7 00 00 00    	je     10081d <consoleintr+0x10d>
  100756:	83 fb 08             	cmp    $0x8,%ebx
  100759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100760:	0f 84 da 00 00 00    	je     100840 <consoleintr+0x130>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100766:	85 db                	test   %ebx,%ebx
  100768:	74 c6                	je     100730 <consoleintr+0x20>
  10076a:	8b 15 1c 98 10 00    	mov    0x10981c,%edx
  100770:	89 d0                	mov    %edx,%eax
  100772:	2b 05 14 98 10 00    	sub    0x109814,%eax
  100778:	83 f8 7f             	cmp    $0x7f,%eax
  10077b:	77 b3                	ja     100730 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
  10077d:	89 d0                	mov    %edx,%eax
  10077f:	83 e0 7f             	and    $0x7f,%eax
  100782:	88 5c 07 04          	mov    %bl,0x4(%edi,%eax,1)
  100786:	8d 42 01             	lea    0x1(%edx),%eax
  100789:	a3 1c 98 10 00       	mov    %eax,0x10981c
        consputc(c);
  10078e:	89 d8                	mov    %ebx,%eax
  100790:	e8 eb fa ff ff       	call   100280 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100795:	83 fb 0a             	cmp    $0xa,%ebx
  100798:	0f 84 ca 00 00 00    	je     100868 <consoleintr+0x158>
  10079e:	83 fb 04             	cmp    $0x4,%ebx
  1007a1:	0f 84 c1 00 00 00    	je     100868 <consoleintr+0x158>
  1007a7:	a1 14 98 10 00       	mov    0x109814,%eax
  1007ac:	8b 15 1c 98 10 00    	mov    0x10981c,%edx
  1007b2:	83 e8 80             	sub    $0xffffff80,%eax
  1007b5:	39 c2                	cmp    %eax,%edx
  1007b7:	0f 85 73 ff ff ff    	jne    100730 <consoleintr+0x20>
          input.w = input.e;
  1007bd:	89 15 18 98 10 00    	mov    %edx,0x109818
          wakeup(&input.r);
  1007c3:	c7 04 24 14 98 10 00 	movl   $0x109814,(%esp)
  1007ca:	e8 01 2a 00 00       	call   1031d0 <wakeup>
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
  1007cf:	ff d6                	call   *%esi
  1007d1:	85 c0                	test   %eax,%eax
  1007d3:	89 c3                	mov    %eax,%ebx
  1007d5:	0f 89 61 ff ff ff    	jns    10073c <consoleintr+0x2c>
  1007db:	90                   	nop    
  1007dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&input.lock);
  1007e0:	c7 45 08 60 97 10 00 	movl   $0x109760,0x8(%ebp)
}
  1007e7:	83 c4 0c             	add    $0xc,%esp
  1007ea:	5b                   	pop    %ebx
  1007eb:	5e                   	pop    %esi
  1007ec:	5f                   	pop    %edi
  1007ed:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
  1007ee:	e9 6d 36 00 00       	jmp    103e60 <release>
  1007f3:	90                   	nop    
  1007f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1007f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1007fb:	89 d0                	mov    %edx,%eax
  1007fd:	83 e0 7f             	and    $0x7f,%eax
  100800:	80 b8 94 97 10 00 0a 	cmpb   $0xa,0x109794(%eax)
  100807:	0f 84 23 ff ff ff    	je     100730 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
  10080d:	b8 00 01 00 00       	mov    $0x100,%eax
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  100812:	89 15 1c 98 10 00    	mov    %edx,0x10981c
        consputc(BACKSPACE);
  100818:	e8 63 fa ff ff       	call   100280 <consputc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  10081d:	a1 1c 98 10 00       	mov    0x10981c,%eax
  100822:	3b 05 18 98 10 00    	cmp    0x109818,%eax
  100828:	75 ce                	jne    1007f8 <consoleintr+0xe8>
  10082a:	e9 01 ff ff ff       	jmp    100730 <consoleintr+0x20>
  10082f:	90                   	nop    

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100830:	e8 fb 33 00 00       	call   103c30 <procdump>
  100835:	8d 76 00             	lea    0x0(%esi),%esi
  100838:	e9 f3 fe ff ff       	jmp    100730 <consoleintr+0x20>
  10083d:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  100840:	a1 1c 98 10 00       	mov    0x10981c,%eax
  100845:	3b 05 18 98 10 00    	cmp    0x109818,%eax
  10084b:	0f 84 df fe ff ff    	je     100730 <consoleintr+0x20>
        input.e--;
  100851:	83 e8 01             	sub    $0x1,%eax
  100854:	a3 1c 98 10 00       	mov    %eax,0x10981c
        consputc(BACKSPACE);
  100859:	b8 00 01 00 00       	mov    $0x100,%eax
  10085e:	e8 1d fa ff ff       	call   100280 <consputc>
  100863:	e9 c8 fe ff ff       	jmp    100730 <consoleintr+0x20>
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100868:	8b 15 1c 98 10 00    	mov    0x10981c,%edx
  10086e:	e9 4a ff ff ff       	jmp    1007bd <consoleintr+0xad>
  100873:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100880 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
  100880:	55                   	push   %ebp
  100881:	89 e5                	mov    %esp,%ebp
  100883:	53                   	push   %ebx
  100884:	83 ec 44             	sub    $0x44,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
  100887:	fa                   	cli    
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  100888:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  10088e:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
{
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
  100891:	c7 05 b4 7f 10 00 00 	movl   $0x0,0x107fb4
  100898:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
  10089b:	0f b6 00             	movzbl (%eax),%eax
  10089e:	c7 04 24 b2 5f 10 00 	movl   $0x105fb2,(%esp)
  1008a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008a9:	e8 f2 fb ff ff       	call   1004a0 <cprintf>
  cprintf(s);
  1008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1008b1:	89 04 24             	mov    %eax,(%esp)
  1008b4:	e8 e7 fb ff ff       	call   1004a0 <cprintf>
  cprintf("\n");
  1008b9:	c7 04 24 43 64 10 00 	movl   $0x106443,(%esp)
  1008c0:	e8 db fb ff ff       	call   1004a0 <cprintf>
  getcallerpcs(&s, pcs);
  1008c5:	8d 45 08             	lea    0x8(%ebp),%eax
  1008c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1008cc:	89 04 24             	mov    %eax,(%esp)
  1008cf:	e8 6c 34 00 00       	call   103d40 <getcallerpcs>
  1008d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  1008d8:	8b 03                	mov    (%ebx),%eax
  1008da:	83 c3 04             	add    $0x4,%ebx
  1008dd:	c7 04 24 c1 5f 10 00 	movl   $0x105fc1,(%esp)
  1008e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e8:	e8 b3 fb ff ff       	call   1004a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  1008ed:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1008f0:	39 c3                	cmp    %eax,%ebx
  1008f2:	75 e4                	jne    1008d8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  1008f4:	c7 05 60 7f 10 00 01 	movl   $0x1,0x107f60
  1008fb:	00 00 00 
  1008fe:	eb fe                	jmp    1008fe <panic+0x7e>

00100900 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  100900:	55                   	push   %ebp
  100901:	89 e5                	mov    %esp,%ebp
  100903:	57                   	push   %edi
  100904:	56                   	push   %esi
  100905:	53                   	push   %ebx
  100906:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  struct proghdr ph;

  mem = 0;
  sz = 0;

  if((ip = namei(path)) == 0)
  10090c:	8b 45 08             	mov    0x8(%ebp),%eax
  10090f:	89 04 24             	mov    %eax,(%esp)
  100912:	e8 89 15 00 00       	call   101ea0 <namei>
  100917:	89 c6                	mov    %eax,%esi
  100919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10091e:	85 f6                	test   %esi,%esi
  100920:	74 48                	je     10096a <exec+0x6a>
    return -1;
  ilock(ip);
  100922:	89 34 24             	mov    %esi,(%esp)
  100925:	e8 c6 12 00 00       	call   101bf0 <ilock>

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
  10092a:	8d 45 a0             	lea    -0x60(%ebp),%eax
  10092d:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  100934:	00 
  100935:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10093c:	00 
  10093d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100941:	89 34 24             	mov    %esi,(%esp)
  100944:	e8 f7 09 00 00       	call   101340 <readi>
  100949:	83 f8 33             	cmp    $0x33,%eax
  10094c:	76 09                	jbe    100957 <exec+0x57>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  10094e:	81 7d a0 7f 45 4c 46 	cmpl   $0x464c457f,-0x60(%ebp)
  100955:	74 21                	je     100978 <exec+0x78>
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  100957:	89 34 24             	mov    %esi,(%esp)
  10095a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100960:	e8 8b 11 00 00       	call   101af0 <iunlockput>
  100965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  10096a:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  100970:	5b                   	pop    %ebx
  100971:	5e                   	pop    %esi
  100972:	5f                   	pop    %edi
  100973:	5d                   	pop    %ebp
  100974:	c3                   	ret    
  100975:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
    goto bad;

  // Compute memory size of new process.
  // Program segments.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100978:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  10097d:	8b 7d bc             	mov    -0x44(%ebp),%edi
  100980:	c7 45 80 00 00 00 00 	movl   $0x0,-0x80(%ebp)
  100987:	74 67                	je     1009f0 <exec+0xf0>
  100989:	31 db                	xor    %ebx,%ebx
  10098b:	c7 45 80 00 00 00 00 	movl   $0x0,-0x80(%ebp)
  100992:	eb 0f                	jmp    1009a3 <exec+0xa3>
  100994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100998:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  10099c:	83 c3 01             	add    $0x1,%ebx
  10099f:	39 d8                	cmp    %ebx,%eax
  1009a1:	7e 4d                	jle    1009f0 <exec+0xf0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  1009a3:	89 d8                	mov    %ebx,%eax
  1009a5:	c1 e0 05             	shl    $0x5,%eax
  1009a8:	01 f8                	add    %edi,%eax
  1009aa:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1009ad:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  1009b4:	00 
  1009b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1009bd:	89 34 24             	mov    %esi,(%esp)
  1009c0:	e8 7b 09 00 00       	call   101340 <readi>
  1009c5:	83 f8 20             	cmp    $0x20,%eax
  1009c8:	75 8d                	jne    100957 <exec+0x57>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  1009ca:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  1009ce:	75 c8                	jne    100998 <exec+0x98>
      continue;
    if(ph.memsz < ph.filesz)
  1009d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  1009d6:	66 90                	xchg   %ax,%ax
  1009d8:	0f 82 79 ff ff ff    	jb     100957 <exec+0x57>
      goto bad;
    sz += ph.memsz;
  1009de:	01 45 80             	add    %eax,-0x80(%ebp)
  1009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1009e8:	eb ae                	jmp    100998 <exec+0x98>
  1009ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  1009f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1009f3:	31 db                	xor    %ebx,%ebx
  1009f5:	8b 11                	mov    (%ecx),%edx
  1009f7:	b9 04 00 00 00       	mov    $0x4,%ecx
  1009fc:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  100a03:	00 00 00 
  100a06:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)
  100a0d:	85 d2                	test   %edx,%edx
  100a0f:	74 3b                	je     100a4c <exec+0x14c>
  100a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    arglen += strlen(argv[argc]) + 1;
  100a18:	89 14 24             	mov    %edx,(%esp)
  100a1b:	e8 10 37 00 00       	call   104130 <strlen>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100a23:	83 85 7c ff ff ff 01 	addl   $0x1,-0x84(%ebp)
  100a2a:	8b bd 7c ff ff ff    	mov    -0x84(%ebp),%edi
  100a30:	8b 14 b9             	mov    (%ecx,%edi,4),%edx
    arglen += strlen(argv[argc]) + 1;
  100a33:	01 d8                	add    %ebx,%eax
  100a35:	8d 58 01             	lea    0x1(%eax),%ebx
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a38:	85 d2                	test   %edx,%edx
  100a3a:	75 dc                	jne    100a18 <exec+0x118>
  100a3c:	83 c0 04             	add    $0x4,%eax
  100a3f:	83 e0 fc             	and    $0xfffffffc,%eax
  100a42:	89 45 88             	mov    %eax,-0x78(%ebp)
  100a45:	8d 0c bd 04 00 00 00 	lea    0x4(,%edi,4),%ecx

  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  100a4c:	8b 7d 88             	mov    -0x78(%ebp),%edi
  100a4f:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  100a52:	8d 84 1f 07 20 00 00 	lea    0x2007(%edi,%ebx,1),%eax
  100a59:	01 c8                	add    %ecx,%eax
  100a5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  100a60:	89 45 8c             	mov    %eax,-0x74(%ebp)
  mem = kalloc(sz);
  100a63:	89 04 24             	mov    %eax,(%esp)
  100a66:	e8 55 18 00 00       	call   1022c0 <kalloc>
  if(mem == 0)
  100a6b:	85 c0                	test   %eax,%eax
  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  mem = kalloc(sz);
  100a6d:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  if(mem == 0)
  100a73:	0f 84 de fe ff ff    	je     100957 <exec+0x57>
    goto bad;
  memset(mem, 0, sz);
  100a79:	8b 45 8c             	mov    -0x74(%ebp),%eax
  100a7c:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  100a82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100a89:	00 
  100a8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a8e:	89 14 24             	mov    %edx,(%esp)
  100a91:	e8 ba 34 00 00       	call   103f50 <memset>

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100a96:	8b 45 bc             	mov    -0x44(%ebp),%eax
  100a99:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  100a9e:	0f 84 c6 00 00 00    	je     100b6a <exec+0x26a>
  100aa4:	89 c7                	mov    %eax,%edi
  100aa6:	31 db                	xor    %ebx,%ebx
  100aa8:	eb 18                	jmp    100ac2 <exec+0x1c2>
  100aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100ab0:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  100ab4:	83 c3 01             	add    $0x1,%ebx
  100ab7:	39 d8                	cmp    %ebx,%eax
  100ab9:	0f 8e ab 00 00 00    	jle    100b6a <exec+0x26a>
  100abf:	83 c7 20             	add    $0x20,%edi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100ac2:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  100ac5:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100acc:	00 
  100acd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100ad1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ad5:	89 34 24             	mov    %esi,(%esp)
  100ad8:	e8 63 08 00 00       	call   101340 <readi>
  100add:	83 f8 20             	cmp    $0x20,%eax
  100ae0:	75 6e                	jne    100b50 <exec+0x250>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100ae2:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  100ae6:	75 c8                	jne    100ab0 <exec+0x1b0>
      continue;
    if(ph.va + ph.memsz < ph.va || ph.va + ph.memsz > sz)
  100ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aeb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100aee:	89 c2                	mov    %eax,%edx
  100af0:	01 ca                	add    %ecx,%edx
  100af2:	72 5c                	jb     100b50 <exec+0x250>
  100af4:	39 55 8c             	cmp    %edx,-0x74(%ebp)
  100af7:	72 57                	jb     100b50 <exec+0x250>
      goto bad;
    if(ph.memsz < ph.filesz)
  100af9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100afc:	39 d0                	cmp    %edx,%eax
  100afe:	72 50                	jb     100b50 <exec+0x250>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
  100b00:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100b03:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100b07:	89 34 24             	mov    %esi,(%esp)
  100b0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b0e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100b14:	01 c8                	add    %ecx,%eax
  100b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1a:	e8 21 08 00 00       	call   101340 <readi>
  100b1f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100b22:	89 c2                	mov    %eax,%edx
  100b24:	75 2a                	jne    100b50 <exec+0x250>
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100b30:	00 
  100b31:	29 d0                	sub    %edx,%eax
  100b33:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b37:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100b3d:	03 55 dc             	add    -0x24(%ebp),%edx
  100b40:	01 d0                	add    %edx,%eax
  100b42:	89 04 24             	mov    %eax,(%esp)
  100b45:	e8 06 34 00 00       	call   103f50 <memset>
  100b4a:	e9 61 ff ff ff       	jmp    100ab0 <exec+0x1b0>
  100b4f:	90                   	nop    
  usegment();
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  100b50:	8b 4d 8c             	mov    -0x74(%ebp),%ecx
  100b53:	8b 9d 78 ff ff ff    	mov    -0x88(%ebp),%ebx
  100b59:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b5d:	89 1c 24             	mov    %ebx,(%esp)
  100b60:	e8 0b 18 00 00       	call   102370 <kfree>
  100b65:	e9 ed fd ff ff       	jmp    100957 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100b6a:	89 34 24             	mov    %esi,(%esp)
  100b6d:	e8 7e 0f 00 00       	call   101af0 <iunlockput>
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100b72:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  100b78:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  100b7b:	8b 7d 88             	mov    -0x78(%ebp),%edi

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100b7e:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100b84:	f7 d0                	not    %eax

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100b86:	8b 8d 78 ff ff ff    	mov    -0x88(%ebp),%ecx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100b8c:	8d 04 83             	lea    (%ebx,%eax,4),%eax
  100b8f:	29 f8                	sub    %edi,%eax
  100b91:	89 45 84             	mov    %eax,-0x7c(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100b94:	8d 04 90             	lea    (%eax,%edx,4),%eax
  for(i=argc-1; i>=0; i--){
  100b97:	83 ea 01             	sub    $0x1,%edx
  100b9a:	83 fa ff             	cmp    $0xffffffff,%edx
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100b9d:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
  for(i=argc-1; i>=0; i--){
  100ba4:	89 55 90             	mov    %edx,-0x70(%ebp)
  100ba7:	74 52                	je     100bfb <exec+0x2fb>
  100ba9:	8b 75 0c             	mov    0xc(%ebp),%esi
  100bac:	89 d0                	mov    %edx,%eax
  100bae:	89 cf                	mov    %ecx,%edi
  100bb0:	c1 e0 02             	shl    $0x2,%eax
  100bb3:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  100bb6:	01 c6                	add    %eax,%esi
  100bb8:	03 45 84             	add    -0x7c(%ebp),%eax
  100bbb:	01 c7                	add    %eax,%edi
  100bbd:	8d 76 00             	lea    0x0(%esi),%esi
    len = strlen(argv[i]) + 1;
  100bc0:	8b 06                	mov    (%esi),%eax
  100bc2:	89 04 24             	mov    %eax,(%esp)
  100bc5:	e8 66 35 00 00       	call   104130 <strlen>
    sp -= len;
  100bca:	83 c0 01             	add    $0x1,%eax
  100bcd:	29 c3                	sub    %eax,%ebx
    memmove(mem+sp, argv[i], len);
  100bcf:	89 44 24 08          	mov    %eax,0x8(%esp)
  100bd3:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100bd5:	83 ee 04             	sub    $0x4,%esi
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
  100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdc:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100be2:	01 d8                	add    %ebx,%eax
  100be4:	89 04 24             	mov    %eax,(%esp)
  100be7:	e8 f4 33 00 00       	call   103fe0 <memmove>
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100bec:	89 1f                	mov    %ebx,(%edi)
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100bee:	83 ef 04             	sub    $0x4,%edi
  100bf1:	83 6d 90 01          	subl   $0x1,-0x70(%ebp)
  100bf5:	83 7d 90 ff          	cmpl   $0xffffffff,-0x70(%ebp)
  100bf9:	75 c5                	jne    100bc0 <exec+0x2c0>
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100bfb:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  100bfe:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100c04:	89 5c 1f fc          	mov    %ebx,-0x4(%edi,%ebx,1)
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100c08:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  100c0e:	89 44 1f f8          	mov    %eax,-0x8(%edi,%ebx,1)
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc
  100c12:	8b 55 84             	mov    -0x7c(%ebp),%edx
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  100c15:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc
  100c18:	c7 44 17 f4 ff ff ff 	movl   $0xffffffff,-0xc(%edi,%edx,1)
  100c1f:	ff 

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  100c23:	83 eb 0c             	sub    $0xc,%ebx
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c26:	0f b6 11             	movzbl (%ecx),%edx
  100c29:	84 d2                	test   %dl,%dl
  100c2b:	74 1e                	je     100c4b <exec+0x34b>
  100c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100c30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100c33:	83 c0 01             	add    $0x1,%eax
  100c36:	eb 0a                	jmp    100c42 <exec+0x342>
  100c38:	0f b6 10             	movzbl (%eax),%edx
  100c3b:	83 c0 01             	add    $0x1,%eax
  100c3e:	84 d2                	test   %dl,%dl
  100c40:	74 09                	je     100c4b <exec+0x34b>
    if(*s == '/')
  100c42:	80 fa 2f             	cmp    $0x2f,%dl
  100c45:	75 f1                	jne    100c38 <exec+0x338>
  100c47:	89 c1                	mov    %eax,%ecx
  100c49:	eb ed                	jmp    100c38 <exec+0x338>
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
  100c4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100c51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c55:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100c5c:	00 
  100c5d:	83 c0 6c             	add    $0x6c,%eax
  100c60:	89 04 24             	mov    %eax,(%esp)
  100c63:	e8 88 34 00 00       	call   1040f0 <safestrcpy>

  // Commit to the new image.
  kfree(proc->mem, proc->sz);
  100c68:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  100c6f:	8b 42 04             	mov    0x4(%edx),%eax
  100c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c76:	8b 02                	mov    (%edx),%eax
  100c78:	89 04 24             	mov    %eax,(%esp)
  100c7b:	e8 f0 16 00 00       	call   102370 <kfree>
  proc->mem = mem;
  100c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100c86:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100c8c:	89 38                	mov    %edi,(%eax)
  proc->sz = sz;
  100c8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100c94:	8b 55 8c             	mov    -0x74(%ebp),%edx
  100c97:	89 50 04             	mov    %edx,0x4(%eax)
  proc->tf->eip = elf.entry;  // main
  100c9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100ca0:	8b 50 18             	mov    0x18(%eax),%edx
  100ca3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100ca6:	89 42 38             	mov    %eax,0x38(%edx)
  proc->tf->esp = sp;
  100ca9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100caf:	8b 40 18             	mov    0x18(%eax),%eax
  100cb2:	89 58 44             	mov    %ebx,0x44(%eax)
  usegment();
  100cb5:	e8 46 2c 00 00       	call   103900 <usegment>
  100cba:	31 c0                	xor    %eax,%eax
  100cbc:	e9 a9 fc ff ff       	jmp    10096a <exec+0x6a>
  100cc1:	90                   	nop    
  100cc2:	90                   	nop    
  100cc3:	90                   	nop    
  100cc4:	90                   	nop    
  100cc5:	90                   	nop    
  100cc6:	90                   	nop    
  100cc7:	90                   	nop    
  100cc8:	90                   	nop    
  100cc9:	90                   	nop    
  100cca:	90                   	nop    
  100ccb:	90                   	nop    
  100ccc:	90                   	nop    
  100ccd:	90                   	nop    
  100cce:	90                   	nop    
  100ccf:	90                   	nop    

00100cd0 <filewrite>:
}

// Write to file f.  Addr is kernel address.
int
filewrite(struct file *f, char *addr, int n)
{
  100cd0:	55                   	push   %ebp
  100cd1:	89 e5                	mov    %esp,%ebp
  100cd3:	83 ec 28             	sub    $0x28,%esp
  100cd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100cdc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100cdf:	8b 75 10             	mov    0x10(%ebp),%esi
  100ce2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100ce5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int r;

  if(f->writable == 0)
  100ce8:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100cec:	74 5a                	je     100d48 <filewrite+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100cee:	8b 03                	mov    (%ebx),%eax
  100cf0:	83 f8 01             	cmp    $0x1,%eax
  100cf3:	74 5b                	je     100d50 <filewrite+0x80>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100cf5:	83 f8 02             	cmp    $0x2,%eax
  100cf8:	75 6d                	jne    100d67 <filewrite+0x97>
    ilock(f->ip);
  100cfa:	8b 43 10             	mov    0x10(%ebx),%eax
  100cfd:	89 04 24             	mov    %eax,(%esp)
  100d00:	e8 eb 0e 00 00       	call   101bf0 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100d05:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100d09:	8b 43 14             	mov    0x14(%ebx),%eax
  100d0c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d10:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d14:	8b 43 10             	mov    0x10(%ebx),%eax
  100d17:	89 04 24             	mov    %eax,(%esp)
  100d1a:	e8 c1 07 00 00       	call   1014e0 <writei>
  100d1f:	85 c0                	test   %eax,%eax
  100d21:	89 c6                	mov    %eax,%esi
  100d23:	7e 03                	jle    100d28 <filewrite+0x58>
      f->off += r;
  100d25:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100d28:	8b 43 10             	mov    0x10(%ebx),%eax
  100d2b:	89 04 24             	mov    %eax,(%esp)
  100d2e:	e8 2d 0a 00 00       	call   101760 <iunlock>
    return r;
  }
  panic("filewrite");
}
  100d33:	89 f0                	mov    %esi,%eax
  100d35:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100d38:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100d3b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100d3e:	89 ec                	mov    %ebp,%esp
  100d40:	5d                   	pop    %ebp
  100d41:	c3                   	ret    
  100d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100d48:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100d4d:	eb e4                	jmp    100d33 <filewrite+0x63>
  100d4f:	90                   	nop    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100d50:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100d53:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100d56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100d59:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100d5c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100d5f:	89 ec                	mov    %ebp,%esp
  100d61:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100d62:	e9 49 21 00 00       	jmp    102eb0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100d67:	c7 04 24 d6 5f 10 00 	movl   $0x105fd6,(%esp)
  100d6e:	e8 0d fb ff ff       	call   100880 <panic>
  100d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100d80 <fileread>:
}

// Read from file f.  Addr is kernel address.
int
fileread(struct file *f, char *addr, int n)
{
  100d80:	55                   	push   %ebp
  100d81:	89 e5                	mov    %esp,%ebp
  100d83:	83 ec 28             	sub    $0x28,%esp
  100d86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100d8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100d8f:	8b 75 10             	mov    0x10(%ebp),%esi
  100d92:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100d95:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int r;

  if(f->readable == 0)
  100d98:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100d9c:	74 5a                	je     100df8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100d9e:	8b 03                	mov    (%ebx),%eax
  100da0:	83 f8 01             	cmp    $0x1,%eax
  100da3:	74 5b                	je     100e00 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100da5:	83 f8 02             	cmp    $0x2,%eax
  100da8:	75 6d                	jne    100e17 <fileread+0x97>
    ilock(f->ip);
  100daa:	8b 43 10             	mov    0x10(%ebx),%eax
  100dad:	89 04 24             	mov    %eax,(%esp)
  100db0:	e8 3b 0e 00 00       	call   101bf0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100db5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100db9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dbc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100dc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100dc4:	8b 43 10             	mov    0x10(%ebx),%eax
  100dc7:	89 04 24             	mov    %eax,(%esp)
  100dca:	e8 71 05 00 00       	call   101340 <readi>
  100dcf:	85 c0                	test   %eax,%eax
  100dd1:	89 c6                	mov    %eax,%esi
  100dd3:	7e 03                	jle    100dd8 <fileread+0x58>
      f->off += r;
  100dd5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100dd8:	8b 43 10             	mov    0x10(%ebx),%eax
  100ddb:	89 04 24             	mov    %eax,(%esp)
  100dde:	e8 7d 09 00 00       	call   101760 <iunlock>
    return r;
  }
  panic("fileread");
}
  100de3:	89 f0                	mov    %esi,%eax
  100de5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100de8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100deb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100dee:	89 ec                	mov    %ebp,%esp
  100df0:	5d                   	pop    %ebp
  100df1:	c3                   	ret    
  100df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100df8:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100dfd:	eb e4                	jmp    100de3 <fileread+0x63>
  100dff:	90                   	nop    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e00:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100e03:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e06:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e09:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e0c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100e0f:	89 ec                	mov    %ebp,%esp
  100e11:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e12:	e9 99 1f 00 00       	jmp    102db0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100e17:	c7 04 24 e0 5f 10 00 	movl   $0x105fe0,(%esp)
  100e1e:	e8 5d fa ff ff       	call   100880 <panic>
  100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100e30 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100e30:	55                   	push   %ebp
  if(f->type == FD_INODE){
  100e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100e36:	89 e5                	mov    %esp,%ebp
  100e38:	53                   	push   %ebx
  100e39:	83 ec 14             	sub    $0x14,%esp
  100e3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
  100e3f:	83 3b 02             	cmpl   $0x2,(%ebx)
  100e42:	74 0c                	je     100e50 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
  100e44:	83 c4 14             	add    $0x14,%esp
  100e47:	5b                   	pop    %ebx
  100e48:	5d                   	pop    %ebp
  100e49:	c3                   	ret    
  100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
  100e50:	8b 43 10             	mov    0x10(%ebx),%eax
  100e53:	89 04 24             	mov    %eax,(%esp)
  100e56:	e8 95 0d 00 00       	call   101bf0 <ilock>
    stati(f->ip, st);
  100e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e62:	8b 43 10             	mov    0x10(%ebx),%eax
  100e65:	89 04 24             	mov    %eax,(%esp)
  100e68:	e8 d3 01 00 00       	call   101040 <stati>
    iunlock(f->ip);
  100e6d:	8b 43 10             	mov    0x10(%ebx),%eax
  100e70:	89 04 24             	mov    %eax,(%esp)
  100e73:	e8 e8 08 00 00       	call   101760 <iunlock>
    return 0;
  }
  return -1;
}
  100e78:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
  100e7b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
  100e7d:	5b                   	pop    %ebx
  100e7e:	5d                   	pop    %ebp
  100e7f:	c3                   	ret    

00100e80 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  100e80:	55                   	push   %ebp
  100e81:	89 e5                	mov    %esp,%ebp
  100e83:	53                   	push   %ebx
  100e84:	83 ec 04             	sub    $0x4,%esp
  100e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
  100e8a:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  100e91:	e8 1a 30 00 00       	call   103eb0 <acquire>
  if(f->ref < 1)
  100e96:	8b 43 04             	mov    0x4(%ebx),%eax
  100e99:	85 c0                	test   %eax,%eax
  100e9b:	7e 1a                	jle    100eb7 <filedup+0x37>
    panic("filedup");
  f->ref++;
  100e9d:	83 c0 01             	add    $0x1,%eax
  100ea0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
  100ea3:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  100eaa:	e8 b1 2f 00 00       	call   103e60 <release>
  return f;
}
  100eaf:	89 d8                	mov    %ebx,%eax
  100eb1:	83 c4 04             	add    $0x4,%esp
  100eb4:	5b                   	pop    %ebx
  100eb5:	5d                   	pop    %ebp
  100eb6:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  100eb7:	c7 04 24 e9 5f 10 00 	movl   $0x105fe9,(%esp)
  100ebe:	e8 bd f9 ff ff       	call   100880 <panic>
  100ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100ed0 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  100ed0:	55                   	push   %ebp
  100ed1:	89 e5                	mov    %esp,%ebp
  100ed3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  100ed4:	bb 54 98 10 00       	mov    $0x109854,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  100ed9:	83 ec 04             	sub    $0x4,%esp
  struct file *f;

  acquire(&ftable.lock);
  100edc:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  100ee3:	e8 c8 2f 00 00       	call   103eb0 <acquire>
  100ee8:	eb 11                	jmp    100efb <filealloc+0x2b>
  100eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
  100ef0:	83 c3 18             	add    $0x18,%ebx
  100ef3:	81 fb b4 a1 10 00    	cmp    $0x10a1b4,%ebx
  100ef9:	74 25                	je     100f20 <filealloc+0x50>
    if(f->ref == 0){
  100efb:	8b 43 04             	mov    0x4(%ebx),%eax
  100efe:	85 c0                	test   %eax,%eax
  100f00:	75 ee                	jne    100ef0 <filealloc+0x20>
      f->ref = 1;
  100f02:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
  100f09:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  100f10:	e8 4b 2f 00 00       	call   103e60 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
  100f15:	89 d8                	mov    %ebx,%eax
  100f17:	83 c4 04             	add    $0x4,%esp
  100f1a:	5b                   	pop    %ebx
  100f1b:	5d                   	pop    %ebp
  100f1c:	c3                   	ret    
  100f1d:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  100f20:	31 db                	xor    %ebx,%ebx
  100f22:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  100f29:	e8 32 2f 00 00       	call   103e60 <release>
  return 0;
}
  100f2e:	89 d8                	mov    %ebx,%eax
  100f30:	83 c4 04             	add    $0x4,%esp
  100f33:	5b                   	pop    %ebx
  100f34:	5d                   	pop    %ebp
  100f35:	c3                   	ret    
  100f36:	8d 76 00             	lea    0x0(%esi),%esi
  100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100f40 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  100f40:	55                   	push   %ebp
  100f41:	89 e5                	mov    %esp,%ebp
  100f43:	83 ec 28             	sub    $0x28,%esp
  100f46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100f4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&ftable.lock);
  100f52:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  100f59:	e8 52 2f 00 00       	call   103eb0 <acquire>
  if(f->ref < 1)
  100f5e:	8b 43 04             	mov    0x4(%ebx),%eax
  100f61:	85 c0                	test   %eax,%eax
  100f63:	0f 8e 9d 00 00 00    	jle    101006 <fileclose+0xc6>
    panic("fileclose");
  if(--f->ref > 0){
  100f69:	83 e8 01             	sub    $0x1,%eax
  100f6c:	85 c0                	test   %eax,%eax
  100f6e:	89 43 04             	mov    %eax,0x4(%ebx)
  100f71:	74 1d                	je     100f90 <fileclose+0x50>
    release(&ftable.lock);
  100f73:	c7 45 08 20 98 10 00 	movl   $0x109820,0x8(%ebp)
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
}
  100f7a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f7d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100f80:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100f83:	89 ec                	mov    %ebp,%esp
  100f85:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
  100f86:	e9 d5 2e 00 00       	jmp    103e60 <release>
  100f8b:	90                   	nop    
  100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
  100f90:	8b 43 10             	mov    0x10(%ebx),%eax
  100f93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100f96:	8b 53 0c             	mov    0xc(%ebx),%edx
  100f99:	89 55 f0             	mov    %edx,-0x10(%ebp)
  100f9c:	8b 33                	mov    (%ebx),%esi
  100f9e:	0f b6 7b 09          	movzbl 0x9(%ebx),%edi
  f->ref = 0;
  100fa2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
  100fa9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
  100faf:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  100fb6:	e8 a5 2e 00 00       	call   103e60 <release>
  
  if(ff.type == FD_PIPE)
  100fbb:	83 fe 01             	cmp    $0x1,%esi
  100fbe:	74 30                	je     100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
  100fc0:	83 fe 02             	cmp    $0x2,%esi
  100fc3:	74 13                	je     100fd8 <fileclose+0x98>
    iput(ff.ip);
}
  100fc5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100fc8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100fcb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100fce:	89 ec                	mov    %ebp,%esp
  100fd0:	5d                   	pop    %ebp
  100fd1:	c3                   	ret    
  100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  100fd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
}
  100fdb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100fde:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100fe1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  100fe4:	89 55 08             	mov    %edx,0x8(%ebp)
}
  100fe7:	89 ec                	mov    %ebp,%esp
  100fe9:	5d                   	pop    %ebp
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  100fea:	e9 a1 08 00 00       	jmp    101890 <iput>
  100fef:	90                   	nop    
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  100ff0:	89 fa                	mov    %edi,%edx
  100ff2:	0f be c2             	movsbl %dl,%eax
  100ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ffc:	89 04 24             	mov    %eax,(%esp)
  100fff:	e8 ac 1f 00 00       	call   102fb0 <pipeclose>
  101004:	eb bf                	jmp    100fc5 <fileclose+0x85>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  101006:	c7 04 24 f1 5f 10 00 	movl   $0x105ff1,(%esp)
  10100d:	e8 6e f8 ff ff       	call   100880 <panic>
  101012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101020 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
  101020:	55                   	push   %ebp
  101021:	89 e5                	mov    %esp,%ebp
  101023:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
  101026:	c7 44 24 04 fb 5f 10 	movl   $0x105ffb,0x4(%esp)
  10102d:	00 
  10102e:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  101035:	e8 e6 2c 00 00       	call   103d20 <initlock>
}
  10103a:	c9                   	leave  
  10103b:	c3                   	ret    
  10103c:	90                   	nop    
  10103d:	90                   	nop    
  10103e:	90                   	nop    
  10103f:	90                   	nop    

00101040 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  101040:	55                   	push   %ebp
  101041:	89 e5                	mov    %esp,%ebp
  101043:	8b 55 08             	mov    0x8(%ebp),%edx
  101046:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  st->dev = ip->dev;
  101049:	8b 02                	mov    (%edx),%eax
  10104b:	89 41 04             	mov    %eax,0x4(%ecx)
  st->ino = ip->inum;
  10104e:	8b 42 04             	mov    0x4(%edx),%eax
  101051:	89 41 08             	mov    %eax,0x8(%ecx)
  st->type = ip->type;
  101054:	0f b7 42 10          	movzwl 0x10(%edx),%eax
  101058:	66 89 01             	mov    %ax,(%ecx)
  st->nlink = ip->nlink;
  10105b:	0f b7 42 16          	movzwl 0x16(%edx),%eax
  10105f:	66 89 41 0c          	mov    %ax,0xc(%ecx)
  st->size = ip->size;
  101063:	8b 42 18             	mov    0x18(%edx),%eax
  101066:	89 41 10             	mov    %eax,0x10(%ecx)
}
  101069:	5d                   	pop    %ebp
  10106a:	c3                   	ret    
  10106b:	90                   	nop    
  10106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101070 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101070:	55                   	push   %ebp
  101071:	89 e5                	mov    %esp,%ebp
  101073:	53                   	push   %ebx
  101074:	83 ec 04             	sub    $0x4,%esp
  101077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10107a:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101081:	e8 2a 2e 00 00       	call   103eb0 <acquire>
  ip->ref++;
  101086:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10108a:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101091:	e8 ca 2d 00 00       	call   103e60 <release>
  return ip;
}
  101096:	89 d8                	mov    %ebx,%eax
  101098:	83 c4 04             	add    $0x4,%esp
  10109b:	5b                   	pop    %ebx
  10109c:	5d                   	pop    %ebp
  10109d:	c3                   	ret    
  10109e:	66 90                	xchg   %ax,%ax

001010a0 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1010a0:	55                   	push   %ebp
  1010a1:	89 e5                	mov    %esp,%ebp
  1010a3:	57                   	push   %edi
  1010a4:	89 c7                	mov    %eax,%edi
  1010a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1010a7:	31 f6                	xor    %esi,%esi

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1010a9:	53                   	push   %ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1010aa:	bb 54 a2 10 00       	mov    $0x10a254,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1010af:	83 ec 0c             	sub    $0xc,%esp
  1010b2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1010b5:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  1010bc:	e8 ef 2d 00 00       	call   103eb0 <acquire>
  1010c1:	eb 17                	jmp    1010da <iget+0x3a>
  1010c3:	90                   	nop    
  1010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1010c8:	85 f6                	test   %esi,%esi
  1010ca:	74 44                	je     101110 <iget+0x70>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1010cc:	83 c3 50             	add    $0x50,%ebx
  1010cf:	81 fb f4 b1 10 00    	cmp    $0x10b1f4,%ebx
  1010d5:	8d 76 00             	lea    0x0(%esi),%esi
  1010d8:	74 4e                	je     101128 <iget+0x88>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1010da:	8b 43 08             	mov    0x8(%ebx),%eax
  1010dd:	85 c0                	test   %eax,%eax
  1010df:	7e e7                	jle    1010c8 <iget+0x28>
  1010e1:	39 3b                	cmp    %edi,(%ebx)
  1010e3:	75 e3                	jne    1010c8 <iget+0x28>
  1010e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1010e8:	39 53 04             	cmp    %edx,0x4(%ebx)
  1010eb:	75 db                	jne    1010c8 <iget+0x28>
      ip->ref++;
  1010ed:	83 c0 01             	add    $0x1,%eax
  1010f0:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
  1010f3:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  1010fa:	e8 61 2d 00 00       	call   103e60 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  1010ff:	83 c4 0c             	add    $0xc,%esp
  101102:	89 d8                	mov    %ebx,%eax
  101104:	5b                   	pop    %ebx
  101105:	5e                   	pop    %esi
  101106:	5f                   	pop    %edi
  101107:	5d                   	pop    %ebp
  101108:	c3                   	ret    
  101109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101110:	85 c0                	test   %eax,%eax
  101112:	75 b8                	jne    1010cc <iget+0x2c>
  101114:	89 de                	mov    %ebx,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101116:	83 c3 50             	add    $0x50,%ebx
  101119:	81 fb f4 b1 10 00    	cmp    $0x10b1f4,%ebx
  10111f:	75 b9                	jne    1010da <iget+0x3a>
  101121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101128:	85 f6                	test   %esi,%esi
  10112a:	74 2e                	je     10115a <iget+0xba>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  10112c:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
  10112e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101131:	89 f3                	mov    %esi,%ebx
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  101133:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  10113a:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101141:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101144:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  10114b:	e8 10 2d 00 00       	call   103e60 <release>

  return ip;
}
  101150:	83 c4 0c             	add    $0xc,%esp
  101153:	89 d8                	mov    %ebx,%eax
  101155:	5b                   	pop    %ebx
  101156:	5e                   	pop    %esi
  101157:	5f                   	pop    %edi
  101158:	5d                   	pop    %ebp
  101159:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  10115a:	c7 04 24 02 60 10 00 	movl   $0x106002,(%esp)
  101161:	e8 1a f7 ff ff       	call   100880 <panic>
  101166:	8d 76 00             	lea    0x0(%esi),%esi
  101169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101170 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  101170:	55                   	push   %ebp
  101171:	89 e5                	mov    %esp,%ebp
  101173:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
  101176:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10117d:	00 
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  10117e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101181:	89 75 fc             	mov    %esi,-0x4(%ebp)
  101184:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  101186:	89 04 24             	mov    %eax,(%esp)
  101189:	e8 32 ef ff ff       	call   1000c0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  10118e:	89 34 24             	mov    %esi,(%esp)
  101191:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101198:	00 
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  101199:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10119b:	8d 40 18             	lea    0x18(%eax),%eax
  10119e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1011a2:	e8 39 2e 00 00       	call   103fe0 <memmove>
  brelse(bp);
  1011a7:	89 1c 24             	mov    %ebx,(%esp)
  1011aa:	e8 51 ee ff ff       	call   100000 <brelse>
}
  1011af:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1011b2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1011b5:	89 ec                	mov    %ebp,%esp
  1011b7:	5d                   	pop    %ebp
  1011b8:	c3                   	ret    
  1011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001011c0 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  1011c0:	55                   	push   %ebp
  1011c1:	89 e5                	mov    %esp,%ebp
  1011c3:	57                   	push   %edi
  1011c4:	56                   	push   %esi
  1011c5:	53                   	push   %ebx
  1011c6:	83 ec 2c             	sub    $0x2c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  1011c9:	8d 55 e8             	lea    -0x18(%ebp),%edx
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  1011cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  1011cf:	e8 9c ff ff ff       	call   101170 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  1011d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1011d7:	85 c0                	test   %eax,%eax
  1011d9:	0f 84 a4 00 00 00    	je     101283 <balloc+0xc3>
  1011df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  1011e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1011e9:	31 db                	xor    %ebx,%ebx
  1011eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1011ee:	c1 e8 03             	shr    $0x3,%eax
  1011f1:	c1 fa 0c             	sar    $0xc,%edx
  1011f4:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  1011f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1011fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1011ff:	89 04 24             	mov    %eax,(%esp)
  101202:	e8 b9 ee ff ff       	call   1000c0 <bread>
  101207:	89 c7                	mov    %eax,%edi
  101209:	eb 10                	jmp    10121b <balloc+0x5b>
  10120b:	90                   	nop    
  10120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(bi = 0; bi < BPB; bi++){
  101210:	83 c3 01             	add    $0x1,%ebx
  101213:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  101219:	74 4d                	je     101268 <balloc+0xa8>
      m = 1 << (bi % 8);
  10121b:	89 d9                	mov    %ebx,%ecx
  10121d:	ba 01 00 00 00       	mov    $0x1,%edx
  101222:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101225:	89 de                	mov    %ebx,%esi
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  101227:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101229:	c1 fe 03             	sar    $0x3,%esi
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  10122c:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  10122e:	0f b6 54 37 18       	movzbl 0x18(%edi,%esi,1),%edx
  101233:	0f b6 c2             	movzbl %dl,%eax
  101236:	85 c8                	test   %ecx,%eax
  101238:	75 d6                	jne    101210 <balloc+0x50>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  10123a:	09 ca                	or     %ecx,%edx
  10123c:	88 54 37 18          	mov    %dl,0x18(%edi,%esi,1)
        bwrite(bp, "balloc");
  101240:	89 3c 24             	mov    %edi,(%esp)
  101243:	c7 44 24 04 12 60 10 	movl   $0x106012,0x4(%esp)
  10124a:	00 
  10124b:	e8 20 ee ff ff       	call   100070 <bwrite>
        brelse(bp);
  101250:	89 3c 24             	mov    %edi,(%esp)
  101253:	e8 a8 ed ff ff       	call   100000 <brelse>
  101258:	8b 55 e0             	mov    -0x20(%ebp),%edx
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  10125b:	83 c4 2c             	add    $0x2c,%esp
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp, "balloc");
        brelse(bp);
  10125e:	8d 04 13             	lea    (%ebx,%edx,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  101261:	5b                   	pop    %ebx
  101262:	5e                   	pop    %esi
  101263:	5f                   	pop    %edi
  101264:	5d                   	pop    %ebp
  101265:	c3                   	ret    
  101266:	66 90                	xchg   %ax,%ax
        bwrite(bp, "balloc");
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  101268:	89 3c 24             	mov    %edi,(%esp)
  10126b:	e8 90 ed ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  101270:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  101277:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10127a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10127d:	0f 87 63 ff ff ff    	ja     1011e6 <balloc+0x26>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  101283:	c7 04 24 19 60 10 00 	movl   $0x106019,(%esp)
  10128a:	e8 f1 f5 ff ff       	call   100880 <panic>
  10128f:	90                   	nop    

00101290 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  101290:	55                   	push   %ebp
  101291:	89 e5                	mov    %esp,%ebp
  101293:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101296:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  101299:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10129c:	89 c6                	mov    %eax,%esi
  10129e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1012a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  1012a4:	77 1a                	ja     1012c0 <bmap+0x30>
    if((addr = ip->addrs[bn]) == 0)
  1012a6:	8d 7a 04             	lea    0x4(%edx),%edi
  1012a9:	8b 5c b8 0c          	mov    0xc(%eax,%edi,4),%ebx
  1012ad:	85 db                	test   %ebx,%ebx
  1012af:	74 67                	je     101318 <bmap+0x88>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
  1012b1:	89 d8                	mov    %ebx,%eax
  1012b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1012b6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1012b9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1012bc:	89 ec                	mov    %ebp,%esp
  1012be:	5d                   	pop    %ebp
  1012bf:	c3                   	ret    
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
  1012c0:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
  1012c3:	83 fb 7f             	cmp    $0x7f,%ebx
  1012c6:	77 6c                	ja     101334 <bmap+0xa4>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
  1012c8:	8b 40 4c             	mov    0x4c(%eax),%eax
  1012cb:	85 c0                	test   %eax,%eax
  1012cd:	74 59                	je     101328 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
  1012cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1012d3:	8b 06                	mov    (%esi),%eax
  1012d5:	89 04 24             	mov    %eax,(%esp)
  1012d8:	e8 e3 ed ff ff       	call   1000c0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
  1012dd:	8d 5c 98 18          	lea    0x18(%eax,%ebx,4),%ebx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
  1012e1:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
  1012e3:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  1012e6:	8b 1b                	mov    (%ebx),%ebx
  1012e8:	85 db                	test   %ebx,%ebx
  1012ea:	75 1e                	jne    10130a <bmap+0x7a>
      a[bn] = addr = balloc(ip->dev);
  1012ec:	8b 06                	mov    (%esi),%eax
  1012ee:	e8 cd fe ff ff       	call   1011c0 <balloc>
  1012f3:	89 c3                	mov    %eax,%ebx
  1012f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1012f8:	89 18                	mov    %ebx,(%eax)
      bwrite(bp, "bmap");
  1012fa:	c7 44 24 04 2f 60 10 	movl   $0x10602f,0x4(%esp)
  101301:	00 
  101302:	89 3c 24             	mov    %edi,(%esp)
  101305:	e8 66 ed ff ff       	call   100070 <bwrite>
    }
    brelse(bp);
  10130a:	89 3c 24             	mov    %edi,(%esp)
  10130d:	e8 ee ec ff ff       	call   100000 <brelse>
  101312:	eb 9d                	jmp    1012b1 <bmap+0x21>
  101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
  101318:	8b 00                	mov    (%eax),%eax
  10131a:	e8 a1 fe ff ff       	call   1011c0 <balloc>
  10131f:	89 c3                	mov    %eax,%ebx
  101321:	89 44 be 0c          	mov    %eax,0xc(%esi,%edi,4)
  101325:	eb 8a                	jmp    1012b1 <bmap+0x21>
  101327:	90                   	nop    
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
  101328:	8b 06                	mov    (%esi),%eax
  10132a:	e8 91 fe ff ff       	call   1011c0 <balloc>
  10132f:	89 46 4c             	mov    %eax,0x4c(%esi)
  101332:	eb 9b                	jmp    1012cf <bmap+0x3f>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  101334:	c7 04 24 34 60 10 00 	movl   $0x106034,(%esp)
  10133b:	e8 40 f5 ff ff       	call   100880 <panic>

00101340 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101340:	55                   	push   %ebp
  101341:	89 e5                	mov    %esp,%ebp
  101343:	83 ec 28             	sub    $0x28,%esp
  101346:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101349:	8b 45 0c             	mov    0xc(%ebp),%eax
  10134c:	8b 7d 08             	mov    0x8(%ebp),%edi
  10134f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101352:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101355:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101358:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10135b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10135e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101361:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
  101366:	74 20                	je     101388 <readi+0x48>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101368:	8b 47 18             	mov    0x18(%edi),%eax
  10136b:	39 d8                	cmp    %ebx,%eax
  10136d:	73 49                	jae    1013b8 <readi+0x78>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10136f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101374:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101377:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10137a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10137d:	89 ec                	mov    %ebp,%esp
  10137f:	5d                   	pop    %ebp
  101380:	c3                   	ret    
  101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101388:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  10138c:	66 83 f8 09          	cmp    $0x9,%ax
  101390:	77 dd                	ja     10136f <readi+0x2f>
  101392:	98                   	cwtl   
  101393:	8b 0c c5 c0 a1 10 00 	mov    0x10a1c0(,%eax,8),%ecx
  10139a:	85 c9                	test   %ecx,%ecx
  10139c:	74 d1                	je     10136f <readi+0x2f>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  10139e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  1013a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1013a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1013a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1013aa:	89 45 10             	mov    %eax,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  1013ad:	89 ec                	mov    %ebp,%esp
  1013af:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1013b0:	ff e1                	jmp    *%ecx
  1013b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  if(off > ip->size || off + n < off)
  1013b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1013bb:	01 da                	add    %ebx,%edx
  1013bd:	72 b0                	jb     10136f <readi+0x2f>
    return -1;
  if(off + n > ip->size)
  1013bf:	39 d0                	cmp    %edx,%eax
  1013c1:	73 05                	jae    1013c8 <readi+0x88>
    n = ip->size - off;
  1013c3:	29 d8                	sub    %ebx,%eax
  1013c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1013c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1013cb:	85 d2                	test   %edx,%edx
  1013cd:	74 76                	je     101445 <readi+0x105>
  1013cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1013d6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  1013d8:	89 da                	mov    %ebx,%edx
  1013da:	89 f8                	mov    %edi,%eax
  1013dc:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1013df:	be 00 02 00 00       	mov    $0x200,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  1013e4:	e8 a7 fe ff ff       	call   101290 <bmap>
  1013e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1013ed:	8b 07                	mov    (%edi),%eax
  1013ef:	89 04 24             	mov    %eax,(%esp)
  1013f2:	e8 c9 ec ff ff       	call   1000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1013f7:	89 da                	mov    %ebx,%edx
  1013f9:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1013ff:	29 d6                	sub    %edx,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  101401:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  101404:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101407:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10140a:	39 c6                	cmp    %eax,%esi
  10140c:	76 02                	jbe    101410 <readi+0xd0>
  10140e:	89 c6                	mov    %eax,%esi
    memmove(dst, bp->data + off%BSIZE, m);
  101410:	89 74 24 08          	mov    %esi,0x8(%esp)
  101414:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101417:	01 f3                	add    %esi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  101419:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  10141d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101421:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101424:	89 04 24             	mov    %eax,(%esp)
  101427:	e8 b4 2b 00 00       	call   103fe0 <memmove>
    brelse(bp);
  10142c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10142f:	89 0c 24             	mov    %ecx,(%esp)
  101432:	e8 c9 eb ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101437:	01 75 ec             	add    %esi,-0x14(%ebp)
  10143a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10143d:	01 75 e8             	add    %esi,-0x18(%ebp)
  101440:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  101443:	77 93                	ja     1013d8 <readi+0x98>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101448:	e9 27 ff ff ff       	jmp    101374 <readi+0x34>
  10144d:	8d 76 00             	lea    0x0(%esi),%esi

00101450 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101450:	55                   	push   %ebp
  101451:	89 e5                	mov    %esp,%ebp
  101453:	56                   	push   %esi
  101454:	53                   	push   %ebx
  101455:	83 ec 10             	sub    $0x10,%esp
  101458:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10145b:	8b 43 04             	mov    0x4(%ebx),%eax
  10145e:	c1 e8 03             	shr    $0x3,%eax
  101461:	83 c0 02             	add    $0x2,%eax
  101464:	89 44 24 04          	mov    %eax,0x4(%esp)
  101468:	8b 03                	mov    (%ebx),%eax
  10146a:	89 04 24             	mov    %eax,(%esp)
  10146d:	e8 4e ec ff ff       	call   1000c0 <bread>
  101472:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101474:	8b 43 04             	mov    0x4(%ebx),%eax
  101477:	83 e0 07             	and    $0x7,%eax
  10147a:	c1 e0 06             	shl    $0x6,%eax
  10147d:	8d 54 06 18          	lea    0x18(%esi,%eax,1),%edx
  dip->type = ip->type;
  101481:	0f b7 43 10          	movzwl 0x10(%ebx),%eax
  101485:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
  101488:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  10148c:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
  101490:	0f b7 43 14          	movzwl 0x14(%ebx),%eax
  101494:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
  101498:	0f b7 43 16          	movzwl 0x16(%ebx),%eax
  10149c:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
  1014a0:	8b 43 18             	mov    0x18(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1014a3:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  1014a6:	89 42 08             	mov    %eax,0x8(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1014a9:	83 c2 0c             	add    $0xc,%edx
  1014ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1014b0:	89 14 24             	mov    %edx,(%esp)
  1014b3:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  1014ba:	00 
  1014bb:	e8 20 2b 00 00       	call   103fe0 <memmove>
  bwrite(bp, "iupdate");
  1014c0:	89 34 24             	mov    %esi,(%esp)
  1014c3:	c7 44 24 04 47 60 10 	movl   $0x106047,0x4(%esp)
  1014ca:	00 
  1014cb:	e8 a0 eb ff ff       	call   100070 <bwrite>
  brelse(bp);
  1014d0:	89 75 08             	mov    %esi,0x8(%ebp)
}
  1014d3:	83 c4 10             	add    $0x10,%esp
  1014d6:	5b                   	pop    %ebx
  1014d7:	5e                   	pop    %esi
  1014d8:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp, "iupdate");
  brelse(bp);
  1014d9:	e9 22 eb ff ff       	jmp    100000 <brelse>
  1014de:	66 90                	xchg   %ax,%ax

001014e0 <writei>:
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1014e0:	55                   	push   %ebp
  1014e1:	89 e5                	mov    %esp,%ebp
  1014e3:	83 ec 28             	sub    $0x28,%esp
  1014e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1014e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1014ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1014ef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1014f2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1014f5:	8b 75 10             	mov    0x10(%ebp),%esi
  1014f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1014fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1014fe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101501:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
  101506:	74 18                	je     101520 <writei+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
  101508:	39 73 18             	cmp    %esi,0x18(%ebx)
  10150b:	73 43                	jae    101550 <writei+0x70>

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  10150d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101512:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101515:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101518:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10151b:	89 ec                	mov    %ebp,%esp
  10151d:	5d                   	pop    %ebp
  10151e:	c3                   	ret    
  10151f:	90                   	nop    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101520:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101524:	66 83 f8 09          	cmp    $0x9,%ax
  101528:	77 e3                	ja     10150d <writei+0x2d>
  10152a:	98                   	cwtl   
  10152b:	8b 0c c5 c4 a1 10 00 	mov    0x10a1c4(,%eax,8),%ecx
  101532:	85 c9                	test   %ecx,%ecx
  101534:	74 d7                	je     10150d <writei+0x2d>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  101539:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10153c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10153f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101542:	89 45 10             	mov    %eax,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  101545:	89 ec                	mov    %ebp,%esp
  101547:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101548:	ff e1                	jmp    *%ecx
  10154a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  if(off > ip->size || off + n < off)
  101550:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101553:	01 f0                	add    %esi,%eax
  101555:	72 b6                	jb     10150d <writei+0x2d>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  101557:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10155c:	76 0a                	jbe    101568 <writei+0x88>
    n = MAXFILE*BSIZE - off;
  10155e:	c7 45 e4 00 18 01 00 	movl   $0x11800,-0x1c(%ebp)
  101565:	29 75 e4             	sub    %esi,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101568:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10156b:	85 c9                	test   %ecx,%ecx
  10156d:	0f 84 92 00 00 00    	je     101605 <writei+0x125>
  101573:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  10157a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  101580:	89 f2                	mov    %esi,%edx
  101582:	89 d8                	mov    %ebx,%eax
  101584:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  101587:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  10158c:	e8 ff fc ff ff       	call   101290 <bmap>
  101591:	89 44 24 04          	mov    %eax,0x4(%esp)
  101595:	8b 03                	mov    (%ebx),%eax
  101597:	89 04 24             	mov    %eax,(%esp)
  10159a:	e8 21 eb ff ff       	call   1000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  10159f:	89 f2                	mov    %esi,%edx
  1015a1:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1015a7:	29 d7                	sub    %edx,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  1015a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  1015ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1015af:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1015b2:	39 c7                	cmp    %eax,%edi
  1015b4:	76 02                	jbe    1015b8 <writei+0xd8>
  1015b6:	89 c7                	mov    %eax,%edi
    memmove(bp->data + off%BSIZE, src, m);
  1015b8:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1015bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015bf:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  1015c1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1015c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1015c8:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  1015cc:	89 04 24             	mov    %eax,(%esp)
  1015cf:	e8 0c 2a 00 00       	call   103fe0 <memmove>
    bwrite(bp, "writei");
  1015d4:	c7 44 24 04 8e 66 10 	movl   $0x10668e,0x4(%esp)
  1015db:	00 
  1015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015df:	89 04 24             	mov    %eax,(%esp)
  1015e2:	e8 89 ea ff ff       	call   100070 <bwrite>
    brelse(bp);
  1015e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1015ea:	89 0c 24             	mov    %ecx,(%esp)
  1015ed:	e8 0e ea ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015f2:	01 7d ec             	add    %edi,-0x14(%ebp)
  1015f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015f8:	01 7d e8             	add    %edi,-0x18(%ebp)
  1015fb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1015fe:	77 80                	ja     101580 <writei+0xa0>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp, "writei");
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101600:	3b 73 18             	cmp    0x18(%ebx),%esi
  101603:	77 08                	ja     10160d <writei+0x12d>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101608:	e9 05 ff ff ff       	jmp    101512 <writei+0x32>
    bwrite(bp, "writei");
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  10160d:	89 73 18             	mov    %esi,0x18(%ebx)
    iupdate(ip);
  101610:	89 1c 24             	mov    %ebx,(%esp)
  101613:	e8 38 fe ff ff       	call   101450 <iupdate>
  101618:	eb eb                	jmp    101605 <writei+0x125>
  10161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00101620 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101626:	8b 45 0c             	mov    0xc(%ebp),%eax
  101629:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101630:	00 
  101631:	89 44 24 04          	mov    %eax,0x4(%esp)
  101635:	8b 45 08             	mov    0x8(%ebp),%eax
  101638:	89 04 24             	mov    %eax,(%esp)
  10163b:	e8 10 2a 00 00       	call   104050 <strncmp>
}
  101640:	c9                   	leave  
  101641:	c3                   	ret    
  101642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101650 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101650:	55                   	push   %ebp
  101651:	89 e5                	mov    %esp,%ebp
  101653:	57                   	push   %edi
  101654:	56                   	push   %esi
  101655:	53                   	push   %ebx
  101656:	83 ec 2c             	sub    $0x2c,%esp
  101659:	8b 45 08             	mov    0x8(%ebp),%eax
  10165c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10165f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  101662:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101665:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101668:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  10166b:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  101670:	0f 85 d2 00 00 00    	jne    101748 <dirlookup+0xf8>
    panic("dirlookup not DIR");
  101676:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  10167d:	8b 78 18             	mov    0x18(%eax),%edi
  101680:	85 ff                	test   %edi,%edi
  101682:	0f 84 b6 00 00 00    	je     10173e <dirlookup+0xee>
    bp = bread(dp->dev, bmap(dp, off / BSIZE));
  101688:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10168b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10168e:	c1 ea 09             	shr    $0x9,%edx
  101691:	e8 fa fb ff ff       	call   101290 <bmap>
  101696:	89 44 24 04          	mov    %eax,0x4(%esp)
  10169a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10169d:	8b 02                	mov    (%edx),%eax
  10169f:	89 04 24             	mov    %eax,(%esp)
  1016a2:	e8 19 ea ff ff       	call   1000c0 <bread>
    for(de = (struct dirent*)bp->data;
  1016a7:	8d 48 18             	lea    0x18(%eax),%ecx

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE));
  1016aa:	89 c7                	mov    %eax,%edi
    for(de = (struct dirent*)bp->data;
  1016ac:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1016af:	89 cb                	mov    %ecx,%ebx
        de < (struct dirent*)(bp->data + BSIZE);
  1016b1:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  1016b7:	eb 0e                	jmp    1016c7 <dirlookup+0x77>
  1016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        de++){
  1016c0:	83 c3 10             	add    $0x10,%ebx
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1016c3:	39 f3                	cmp    %esi,%ebx
  1016c5:	74 59                	je     101720 <dirlookup+0xd0>
        de++){
      if(de->inum == 0)
  1016c7:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1016cb:	74 f3                	je     1016c0 <dirlookup+0x70>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
  1016cd:	8d 43 02             	lea    0x2(%ebx),%eax
  1016d0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1016d7:	00 
  1016d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1016df:	89 04 24             	mov    %eax,(%esp)
  1016e2:	e8 69 29 00 00       	call   104050 <strncmp>
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
        continue;
      if(namecmp(name, de->name) == 0){
  1016e7:	85 c0                	test   %eax,%eax
  1016e9:	75 d5                	jne    1016c0 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  1016eb:	8b 75 e0             	mov    -0x20(%ebp),%esi
  1016ee:	85 f6                	test   %esi,%esi
  1016f0:	74 0e                	je     101700 <dirlookup+0xb0>
          *poff = off + (uchar*)de - bp->data;
  1016f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1016f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1016f8:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  1016fb:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1016fe:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
  101700:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101703:	89 3c 24             	mov    %edi,(%esp)
  101706:	e8 f5 e8 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  10170b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10170e:	89 da                	mov    %ebx,%edx
  101710:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  101712:	83 c4 2c             	add    $0x2c,%esp
  101715:	5b                   	pop    %ebx
  101716:	5e                   	pop    %esi
  101717:	5f                   	pop    %edi
  101718:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101719:	e9 82 f9 ff ff       	jmp    1010a0 <iget>
  10171e:	66 90                	xchg   %ax,%ax
      }
    }
    brelse(bp);
  101720:	89 3c 24             	mov    %edi,(%esp)
  101723:	e8 d8 e8 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10172b:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  101732:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101735:	39 50 18             	cmp    %edx,0x18(%eax)
  101738:	0f 87 4a ff ff ff    	ja     101688 <dirlookup+0x38>
      }
    }
    brelse(bp);
  }
  return 0;
}
  10173e:	83 c4 2c             	add    $0x2c,%esp
  101741:	31 c0                	xor    %eax,%eax
  101743:	5b                   	pop    %ebx
  101744:	5e                   	pop    %esi
  101745:	5f                   	pop    %edi
  101746:	5d                   	pop    %ebp
  101747:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101748:	c7 04 24 4f 60 10 00 	movl   $0x10604f,(%esp)
  10174f:	e8 2c f1 ff ff       	call   100880 <panic>
  101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101760 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101760:	55                   	push   %ebp
  101761:	89 e5                	mov    %esp,%ebp
  101763:	53                   	push   %ebx
  101764:	83 ec 04             	sub    $0x4,%esp
  101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  10176a:	85 db                	test   %ebx,%ebx
  10176c:	74 3a                	je     1017a8 <iunlock+0x48>
  10176e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101772:	74 34                	je     1017a8 <iunlock+0x48>
  101774:	8b 43 08             	mov    0x8(%ebx),%eax
  101777:	85 c0                	test   %eax,%eax
  101779:	7e 2d                	jle    1017a8 <iunlock+0x48>
    panic("iunlock");

  acquire(&icache.lock);
  10177b:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101782:	e8 29 27 00 00       	call   103eb0 <acquire>
  ip->flags &= ~I_BUSY;
  101787:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  10178b:	89 1c 24             	mov    %ebx,(%esp)
  10178e:	e8 3d 1a 00 00       	call   1031d0 <wakeup>
  release(&icache.lock);
  101793:	c7 45 08 20 a2 10 00 	movl   $0x10a220,0x8(%ebp)
}
  10179a:	83 c4 04             	add    $0x4,%esp
  10179d:	5b                   	pop    %ebx
  10179e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  10179f:	e9 bc 26 00 00       	jmp    103e60 <release>
  1017a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  1017a8:	c7 04 24 61 60 10 00 	movl   $0x106061,(%esp)
  1017af:	e8 cc f0 ff ff       	call   100880 <panic>
  1017b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1017ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001017c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  1017c0:	55                   	push   %ebp
  1017c1:	89 e5                	mov    %esp,%ebp
  1017c3:	57                   	push   %edi
  1017c4:	89 c7                	mov    %eax,%edi
  1017c6:	56                   	push   %esi
  1017c7:	89 d6                	mov    %edx,%esi
  1017c9:	53                   	push   %ebx
  1017ca:	83 ec 1c             	sub    $0x1c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  1017cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1017d1:	89 04 24             	mov    %eax,(%esp)
  1017d4:	e8 e7 e8 ff ff       	call   1000c0 <bread>
  memset(bp->data, 0, BSIZE);
  1017d9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  1017e0:	00 
  1017e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1017e8:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  1017e9:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
  1017eb:	8d 40 18             	lea    0x18(%eax),%eax
  1017ee:	89 04 24             	mov    %eax,(%esp)
  1017f1:	e8 5a 27 00 00       	call   103f50 <memset>
  bwrite(bp, "bzero");
  1017f6:	89 1c 24             	mov    %ebx,(%esp)
  1017f9:	c7 44 24 04 69 60 10 	movl   $0x106069,0x4(%esp)
  101800:	00 
  101801:	e8 6a e8 ff ff       	call   100070 <bwrite>
  brelse(bp);
  101806:	89 1c 24             	mov    %ebx,(%esp)
  101809:	e8 f2 e7 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  10180e:	89 f8                	mov    %edi,%eax
  101810:	8d 55 e8             	lea    -0x18(%ebp),%edx
  101813:	e8 58 f9 ff ff       	call   101170 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10181b:	89 f2                	mov    %esi,%edx
  10181d:	c1 ea 0c             	shr    $0xc,%edx
  101820:	89 3c 24             	mov    %edi,(%esp)
  bi = b % BPB;
  101823:	89 f7                	mov    %esi,%edi
  m = 1 << (bi % 8);
  101825:	83 e6 07             	and    $0x7,%esi

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  101828:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  10182e:	c1 e8 03             	shr    $0x3,%eax
  101831:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101835:	89 44 24 04          	mov    %eax,0x4(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101839:	c1 ff 03             	sar    $0x3,%edi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  10183c:	e8 7f e8 ff ff       	call   1000c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
  101841:	89 f1                	mov    %esi,%ecx
  101843:	ba 01 00 00 00       	mov    $0x1,%edx
  101848:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
  10184a:	0f b6 74 38 18       	movzbl 0x18(%eax,%edi,1),%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  10184f:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101851:	89 f1                	mov    %esi,%ecx
  101853:	0f b6 c1             	movzbl %cl,%eax
  101856:	85 d0                	test   %edx,%eax
  101858:	74 2a                	je     101884 <bfree+0xc4>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  10185a:	89 d0                	mov    %edx,%eax
  10185c:	f7 d0                	not    %eax
  10185e:	21 f0                	and    %esi,%eax
  101860:	88 44 3b 18          	mov    %al,0x18(%ebx,%edi,1)
  bwrite(bp, "bfree");
  101864:	89 1c 24             	mov    %ebx,(%esp)
  101867:	c7 44 24 04 82 60 10 	movl   $0x106082,0x4(%esp)
  10186e:	00 
  10186f:	e8 fc e7 ff ff       	call   100070 <bwrite>
  brelse(bp);
  101874:	89 1c 24             	mov    %ebx,(%esp)
  101877:	e8 84 e7 ff ff       	call   100000 <brelse>
}
  10187c:	83 c4 1c             	add    $0x1c,%esp
  10187f:	5b                   	pop    %ebx
  101880:	5e                   	pop    %esi
  101881:	5f                   	pop    %edi
  101882:	5d                   	pop    %ebp
  101883:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101884:	c7 04 24 6f 60 10 00 	movl   $0x10606f,(%esp)
  10188b:	e8 f0 ef ff ff       	call   100880 <panic>

00101890 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101890:	55                   	push   %ebp
  101891:	89 e5                	mov    %esp,%ebp
  101893:	57                   	push   %edi
  101894:	56                   	push   %esi
  101895:	53                   	push   %ebx
  101896:	83 ec 0c             	sub    $0xc,%esp
  101899:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  10189c:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  1018a3:	e8 08 26 00 00       	call   103eb0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  1018a8:	8b 46 08             	mov    0x8(%esi),%eax
  1018ab:	83 f8 01             	cmp    $0x1,%eax
  1018ae:	0f 85 ac 00 00 00    	jne    101960 <iput+0xd0>
  1018b4:	8b 56 0c             	mov    0xc(%esi),%edx
  1018b7:	f6 c2 02             	test   $0x2,%dl
  1018ba:	0f 84 a0 00 00 00    	je     101960 <iput+0xd0>
  1018c0:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  1018c5:	0f 85 95 00 00 00    	jne    101960 <iput+0xd0>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  1018cb:	f6 c2 01             	test   $0x1,%dl
  1018ce:	66 90                	xchg   %ax,%ax
  1018d0:	0f 85 13 01 00 00    	jne    1019e9 <iput+0x159>
      panic("iput busy");
    ip->flags |= I_BUSY;
  1018d6:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  1018d9:	89 f3                	mov    %esi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  1018db:	89 56 0c             	mov    %edx,0xc(%esi)
  1018de:	8d 7e 30             	lea    0x30(%esi),%edi
    release(&icache.lock);
  1018e1:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  1018e8:	e8 73 25 00 00       	call   103e60 <release>
  1018ed:	eb 08                	jmp    1018f7 <iput+0x67>
  1018ef:	90                   	nop    
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  1018f0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  1018f3:	39 fb                	cmp    %edi,%ebx
  1018f5:	74 20                	je     101917 <iput+0x87>
    if(ip->addrs[i]){
  1018f7:	8b 53 1c             	mov    0x1c(%ebx),%edx
  1018fa:	85 d2                	test   %edx,%edx
  1018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101900:	74 ee                	je     1018f0 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
  101902:	8b 06                	mov    (%esi),%eax
  101904:	e8 b7 fe ff ff       	call   1017c0 <bfree>
      ip->addrs[i] = 0;
  101909:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101910:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101913:	39 fb                	cmp    %edi,%ebx
  101915:	75 e0                	jne    1018f7 <iput+0x67>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
  101917:	8b 46 4c             	mov    0x4c(%esi),%eax
  10191a:	85 c0                	test   %eax,%eax
  10191c:	75 62                	jne    101980 <iput+0xf0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  10191e:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  101925:	89 34 24             	mov    %esi,(%esp)
  101928:	e8 23 fb ff ff       	call   101450 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  10192d:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101933:	89 34 24             	mov    %esi,(%esp)
  101936:	e8 15 fb ff ff       	call   101450 <iupdate>
    acquire(&icache.lock);
  10193b:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101942:	e8 69 25 00 00       	call   103eb0 <acquire>
    ip->flags = 0;
  101947:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
  10194e:	89 34 24             	mov    %esi,(%esp)
  101951:	e8 7a 18 00 00       	call   1031d0 <wakeup>
  101956:	8b 46 08             	mov    0x8(%esi),%eax
  101959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  ip->ref--;
  101960:	83 e8 01             	sub    $0x1,%eax
  101963:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
  101966:	c7 45 08 20 a2 10 00 	movl   $0x10a220,0x8(%ebp)
}
  10196d:	83 c4 0c             	add    $0xc,%esp
  101970:	5b                   	pop    %ebx
  101971:	5e                   	pop    %esi
  101972:	5f                   	pop    %edi
  101973:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101974:	e9 e7 24 00 00       	jmp    103e60 <release>
  101979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101980:	89 44 24 04          	mov    %eax,0x4(%esp)
  101984:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  101986:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101988:	89 04 24             	mov    %eax,(%esp)
  10198b:	e8 30 e7 ff ff       	call   1000c0 <bread>
    a = (uint*)bp->data;
  101990:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101992:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  101995:	83 c7 18             	add    $0x18,%edi
  101998:	31 c0                	xor    %eax,%eax
  10199a:	eb 11                	jmp    1019ad <iput+0x11d>
  10199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(j = 0; j < NINDIRECT; j++){
  1019a0:	83 c3 01             	add    $0x1,%ebx
  1019a3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  1019a9:	89 d8                	mov    %ebx,%eax
  1019ab:	74 1b                	je     1019c8 <iput+0x138>
      if(a[j])
  1019ad:	8b 14 87             	mov    (%edi,%eax,4),%edx
  1019b0:	85 d2                	test   %edx,%edx
  1019b2:	74 ec                	je     1019a0 <iput+0x110>
        bfree(ip->dev, a[j]);
  1019b4:	8b 06                	mov    (%esi),%eax
  1019b6:	e8 05 fe ff ff       	call   1017c0 <bfree>
  1019bb:	90                   	nop    
  1019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1019c0:	eb de                	jmp    1019a0 <iput+0x110>
  1019c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
    brelse(bp);
  1019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019cb:	89 04 24             	mov    %eax,(%esp)
  1019ce:	e8 2d e6 ff ff       	call   100000 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
  1019d3:	8b 56 4c             	mov    0x4c(%esi),%edx
  1019d6:	8b 06                	mov    (%esi),%eax
  1019d8:	e8 e3 fd ff ff       	call   1017c0 <bfree>
    ip->addrs[NDIRECT] = 0;
  1019dd:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  1019e4:	e9 35 ff ff ff       	jmp    10191e <iput+0x8e>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  1019e9:	c7 04 24 88 60 10 00 	movl   $0x106088,(%esp)
  1019f0:	e8 8b ee ff ff       	call   100880 <panic>
  1019f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1019f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101a00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  101a00:	55                   	push   %ebp
  101a01:	89 e5                	mov    %esp,%ebp
  101a03:	57                   	push   %edi
  101a04:	56                   	push   %esi
  101a05:	53                   	push   %ebx
  101a06:	83 ec 2c             	sub    $0x2c,%esp
  101a09:	8b 7d 08             	mov    0x8(%ebp),%edi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101a0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101a16:	00 
  101a17:	89 3c 24             	mov    %edi,(%esp)
  101a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1e:	e8 2d fc ff ff       	call   101650 <dirlookup>
  101a23:	85 c0                	test   %eax,%eax
  101a25:	0f 85 98 00 00 00    	jne    101ac3 <dirlink+0xc3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101a2b:	8b 47 18             	mov    0x18(%edi),%eax
  101a2e:	85 c0                	test   %eax,%eax
  101a30:	0f 84 9c 00 00 00    	je     101ad2 <dirlink+0xd2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101a36:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  101a39:	31 db                	xor    %ebx,%ebx
  101a3b:	eb 0b                	jmp    101a48 <dirlink+0x48>
  101a3d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101a40:	83 c3 10             	add    $0x10,%ebx
  101a43:	39 5f 18             	cmp    %ebx,0x18(%edi)
  101a46:	76 24                	jbe    101a6c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a48:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101a4f:	00 
  101a50:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101a54:	89 74 24 04          	mov    %esi,0x4(%esp)
  101a58:	89 3c 24             	mov    %edi,(%esp)
  101a5b:	e8 e0 f8 ff ff       	call   101340 <readi>
  101a60:	83 f8 10             	cmp    $0x10,%eax
  101a63:	75 52                	jne    101ab7 <dirlink+0xb7>
      panic("dirlink read");
    if(de.inum == 0)
  101a65:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  101a6a:	75 d4                	jne    101a40 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101a6f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101a76:	00 
  101a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  101a7e:	89 04 24             	mov    %eax,(%esp)
  101a81:	e8 1a 26 00 00       	call   1040a0 <strncpy>
  de.inum = inum;
  101a86:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a8a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101a91:	00 
  101a92:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101a96:	89 74 24 04          	mov    %esi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  101a9a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a9e:	89 3c 24             	mov    %edi,(%esp)
  101aa1:	e8 3a fa ff ff       	call   1014e0 <writei>
    panic("dirlink");
  101aa6:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101aa8:	83 f8 10             	cmp    $0x10,%eax
  101aab:	75 2c                	jne    101ad9 <dirlink+0xd9>
    panic("dirlink");
  
  return 0;
}
  101aad:	83 c4 2c             	add    $0x2c,%esp
  101ab0:	89 d0                	mov    %edx,%eax
  101ab2:	5b                   	pop    %ebx
  101ab3:	5e                   	pop    %esi
  101ab4:	5f                   	pop    %edi
  101ab5:	5d                   	pop    %ebp
  101ab6:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101ab7:	c7 04 24 92 60 10 00 	movl   $0x106092,(%esp)
  101abe:	e8 bd ed ff ff       	call   100880 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101ac3:	89 04 24             	mov    %eax,(%esp)
  101ac6:	e8 c5 fd ff ff       	call   101890 <iput>
  101acb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101ad0:	eb db                	jmp    101aad <dirlink+0xad>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101ad2:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  101ad5:	31 db                	xor    %ebx,%ebx
  101ad7:	eb 93                	jmp    101a6c <dirlink+0x6c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101ad9:	c7 04 24 5a 66 10 00 	movl   $0x10665a,(%esp)
  101ae0:	e8 9b ed ff ff       	call   100880 <panic>
  101ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101af0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101af0:	55                   	push   %ebp
  101af1:	89 e5                	mov    %esp,%ebp
  101af3:	53                   	push   %ebx
  101af4:	83 ec 04             	sub    $0x4,%esp
  101af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101afa:	89 1c 24             	mov    %ebx,(%esp)
  101afd:	e8 5e fc ff ff       	call   101760 <iunlock>
  iput(ip);
  101b02:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101b05:	83 c4 04             	add    $0x4,%esp
  101b08:	5b                   	pop    %ebx
  101b09:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101b0a:	e9 81 fd ff ff       	jmp    101890 <iput>
  101b0f:	90                   	nop    

00101b10 <ialloc>:
static struct inode* iget(uint dev, uint inum);

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101b10:	55                   	push   %ebp
  101b11:	89 e5                	mov    %esp,%ebp
  101b13:	57                   	push   %edi
  101b14:	56                   	push   %esi
  101b15:	53                   	push   %ebx
  101b16:	83 ec 2c             	sub    $0x2c,%esp
  101b19:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101b1d:	8d 55 e8             	lea    -0x18(%ebp),%edx
static struct inode* iget(uint dev, uint inum);

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101b20:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	e8 44 f6 ff ff       	call   101170 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101b2c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  101b30:	0f 86 a2 00 00 00    	jbe    101bd8 <ialloc+0xc8>
  101b36:	be 01 00 00 00       	mov    $0x1,%esi
  101b3b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  101b42:	eb 17                	jmp    101b5b <ialloc+0x4b>
  101b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101b48:	83 c6 01             	add    $0x1,%esi
      dip->type = type;
      bwrite(bp, "ialloc");   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101b4b:	89 3c 24             	mov    %edi,(%esp)
  101b4e:	e8 ad e4 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101b53:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  101b56:	89 75 e0             	mov    %esi,-0x20(%ebp)
  101b59:	73 7d                	jae    101bd8 <ialloc+0xc8>
    bp = bread(dev, IBLOCK(inum));
  101b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101b5e:	c1 e8 03             	shr    $0x3,%eax
  101b61:	83 c0 02             	add    $0x2,%eax
  101b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	89 04 24             	mov    %eax,(%esp)
  101b6e:	e8 4d e5 ff ff       	call   1000c0 <bread>
  101b73:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
  101b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101b78:	83 e0 07             	and    $0x7,%eax
  101b7b:	c1 e0 06             	shl    $0x6,%eax
  101b7e:	8d 5c 07 18          	lea    0x18(%edi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  101b82:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101b86:	75 c0                	jne    101b48 <ialloc+0x38>
      memset(dip, 0, sizeof(*dip));
  101b88:	89 1c 24             	mov    %ebx,(%esp)
  101b8b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101b92:	00 
  101b93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101b9a:	00 
  101b9b:	e8 b0 23 00 00       	call   103f50 <memset>
      dip->type = type;
  101ba0:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  101ba4:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp, "ialloc");   // mark it allocated on the disk
  101ba7:	89 3c 24             	mov    %edi,(%esp)
  101baa:	c7 44 24 04 3c 66 10 	movl   $0x10663c,0x4(%esp)
  101bb1:	00 
  101bb2:	e8 b9 e4 ff ff       	call   100070 <bwrite>
      brelse(bp);
  101bb7:	89 3c 24             	mov    %edi,(%esp)
  101bba:	e8 41 e4 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  101bbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc5:	e8 d6 f4 ff ff       	call   1010a0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101bca:	83 c4 2c             	add    $0x2c,%esp
  101bcd:	5b                   	pop    %ebx
  101bce:	5e                   	pop    %esi
  101bcf:	5f                   	pop    %edi
  101bd0:	5d                   	pop    %ebp
  101bd1:	c3                   	ret    
  101bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101bd8:	c7 04 24 9f 60 10 00 	movl   $0x10609f,(%esp)
  101bdf:	e8 9c ec ff ff       	call   100880 <panic>
  101be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101bf0 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101bf0:	55                   	push   %ebp
  101bf1:	89 e5                	mov    %esp,%ebp
  101bf3:	56                   	push   %esi
  101bf4:	53                   	push   %ebx
  101bf5:	83 ec 10             	sub    $0x10,%esp
  101bf8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101bfb:	85 f6                	test   %esi,%esi
  101bfd:	74 59                	je     101c58 <ilock+0x68>
  101bff:	8b 46 08             	mov    0x8(%esi),%eax
  101c02:	85 c0                	test   %eax,%eax
  101c04:	7e 52                	jle    101c58 <ilock+0x68>
    panic("ilock");

  acquire(&icache.lock);
  101c06:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101c0d:	e8 9e 22 00 00       	call   103eb0 <acquire>
  while(ip->flags & I_BUSY)
  101c12:	8b 46 0c             	mov    0xc(%esi),%eax
  101c15:	a8 01                	test   $0x1,%al
  101c17:	74 1e                	je     101c37 <ilock+0x47>
  101c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101c20:	c7 44 24 04 20 a2 10 	movl   $0x10a220,0x4(%esp)
  101c27:	00 
  101c28:	89 34 24             	mov    %esi,(%esp)
  101c2b:	e8 f0 17 00 00       	call   103420 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101c30:	8b 46 0c             	mov    0xc(%esi),%eax
  101c33:	a8 01                	test   $0x1,%al
  101c35:	75 e9                	jne    101c20 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101c37:	83 c8 01             	or     $0x1,%eax
  101c3a:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  101c3d:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101c44:	e8 17 22 00 00       	call   103e60 <release>

  if(!(ip->flags & I_VALID)){
  101c49:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101c4d:	74 19                	je     101c68 <ilock+0x78>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101c4f:	83 c4 10             	add    $0x10,%esp
  101c52:	5b                   	pop    %ebx
  101c53:	5e                   	pop    %esi
  101c54:	5d                   	pop    %ebp
  101c55:	c3                   	ret    
  101c56:	66 90                	xchg   %ax,%ax
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101c58:	c7 04 24 b1 60 10 00 	movl   $0x1060b1,(%esp)
  101c5f:	e8 1c ec ff ff       	call   100880 <panic>
  101c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101c68:	8b 46 04             	mov    0x4(%esi),%eax
  101c6b:	c1 e8 03             	shr    $0x3,%eax
  101c6e:	83 c0 02             	add    $0x2,%eax
  101c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c75:	8b 06                	mov    (%esi),%eax
  101c77:	89 04 24             	mov    %eax,(%esp)
  101c7a:	e8 41 e4 ff ff       	call   1000c0 <bread>
  101c7f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101c81:	8b 46 04             	mov    0x4(%esi),%eax
  101c84:	83 e0 07             	and    $0x7,%eax
  101c87:	c1 e0 06             	shl    $0x6,%eax
  101c8a:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  101c8e:	0f b7 10             	movzwl (%eax),%edx
  101c91:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  101c95:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101c99:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  101c9d:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101ca1:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  101ca5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101ca9:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  101cad:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101cb0:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101cb3:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cba:	8d 46 1c             	lea    0x1c(%esi),%eax
  101cbd:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101cc4:	00 
  101cc5:	89 04 24             	mov    %eax,(%esp)
  101cc8:	e8 13 23 00 00       	call   103fe0 <memmove>
    brelse(bp);
  101ccd:	89 1c 24             	mov    %ebx,(%esp)
  101cd0:	e8 2b e3 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101cd5:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    if(ip->type == 0)
  101cd9:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101cde:	0f 85 6b ff ff ff    	jne    101c4f <ilock+0x5f>
      panic("ilock: no type");
  101ce4:	c7 04 24 b7 60 10 00 	movl   $0x1060b7,(%esp)
  101ceb:	e8 90 eb ff ff       	call   100880 <panic>

00101cf0 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  101cf0:	55                   	push   %ebp
  101cf1:	89 e5                	mov    %esp,%ebp
  101cf3:	57                   	push   %edi
  101cf4:	56                   	push   %esi
  101cf5:	53                   	push   %ebx
  101cf6:	89 c3                	mov    %eax,%ebx
  101cf8:	83 ec 1c             	sub    $0x1c,%esp
  101cfb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  101cfe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101d01:	80 38 2f             	cmpb   $0x2f,(%eax)
  101d04:	0f 84 30 01 00 00    	je     101e3a <namex+0x14a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
  101d0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  101d10:	8b 40 68             	mov    0x68(%eax),%eax
  101d13:	89 04 24             	mov    %eax,(%esp)
  101d16:	e8 55 f3 ff ff       	call   101070 <idup>
  101d1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101d1e:	eb 03                	jmp    101d23 <namex+0x33>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101d20:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101d23:	0f b6 03             	movzbl (%ebx),%eax
  101d26:	3c 2f                	cmp    $0x2f,%al
  101d28:	74 f6                	je     101d20 <namex+0x30>
    path++;
  if(*path == 0)
  101d2a:	84 c0                	test   %al,%al
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101d2c:	89 de                	mov    %ebx,%esi
    path++;
  if(*path == 0)
  101d2e:	75 1e                	jne    101d4e <namex+0x5e>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
  101d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101d33:	85 c0                	test   %eax,%eax
  101d35:	0f 85 2c 01 00 00    	jne    101e67 <namex+0x177>
    iput(ip);
    return 0;
  }
  return ip;
}
  101d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101d3e:	83 c4 1c             	add    $0x1c,%esp
  101d41:	5b                   	pop    %ebx
  101d42:	5e                   	pop    %esi
  101d43:	5f                   	pop    %edi
  101d44:	5d                   	pop    %ebp
  101d45:	c3                   	ret    
  101d46:	66 90                	xchg   %ax,%ax
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  101d48:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101d4b:	0f b6 06             	movzbl (%esi),%eax
  101d4e:	3c 2f                	cmp    $0x2f,%al
  101d50:	74 04                	je     101d56 <namex+0x66>
  101d52:	84 c0                	test   %al,%al
  101d54:	75 f2                	jne    101d48 <namex+0x58>
    path++;
  len = path - s;
  101d56:	89 f2                	mov    %esi,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101d58:	89 f7                	mov    %esi,%edi
    path++;
  len = path - s;
  101d5a:	29 da                	sub    %ebx,%edx
  if(len >= DIRSIZ)
  101d5c:	83 fa 0d             	cmp    $0xd,%edx
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  len = path - s;
  101d5f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  if(len >= DIRSIZ)
  101d62:	0f 8e 90 00 00 00    	jle    101df8 <namex+0x108>
    memmove(name, s, DIRSIZ);
  101d68:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101d6f:	00 
  101d70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101d77:	89 04 24             	mov    %eax,(%esp)
  101d7a:	e8 61 22 00 00       	call   103fe0 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101d7f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  101d82:	75 0c                	jne    101d90 <namex+0xa0>
  101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
  101d88:	83 c7 01             	add    $0x1,%edi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101d8b:	80 3f 2f             	cmpb   $0x2f,(%edi)
  101d8e:	74 f8                	je     101d88 <namex+0x98>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
  101d90:	85 ff                	test   %edi,%edi
  101d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101d98:	74 96                	je     101d30 <namex+0x40>
    ilock(ip);
  101d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101d9d:	89 04 24             	mov    %eax,(%esp)
  101da0:	e8 4b fe ff ff       	call   101bf0 <ilock>
    if(ip->type != T_DIR){
  101da5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101da8:	66 83 7a 10 01       	cmpw   $0x1,0x10(%edx)
  101dad:	75 71                	jne    101e20 <namex+0x130>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
  101daf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101db2:	85 c0                	test   %eax,%eax
  101db4:	74 09                	je     101dbf <namex+0xcf>
  101db6:	80 3f 00             	cmpb   $0x0,(%edi)
  101db9:	0f 84 92 00 00 00    	je     101e51 <namex+0x161>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101dbf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101dc6:	00 
  101dc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101dca:	89 54 24 04          	mov    %edx,0x4(%esp)
  101dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101dd1:	89 04 24             	mov    %eax,(%esp)
  101dd4:	e8 77 f8 ff ff       	call   101650 <dirlookup>
  101dd9:	85 c0                	test   %eax,%eax
  101ddb:	89 c3                	mov    %eax,%ebx
  101ddd:	74 3e                	je     101e1d <namex+0x12d>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101de2:	89 04 24             	mov    %eax,(%esp)
  101de5:	e8 06 fd ff ff       	call   101af0 <iunlockput>
  101dea:	89 5d ec             	mov    %ebx,-0x14(%ebp)
  101ded:	89 fb                	mov    %edi,%ebx
  101def:	e9 2f ff ff ff       	jmp    101d23 <namex+0x33>
  101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101dfb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101dff:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101e06:	89 04 24             	mov    %eax,(%esp)
  101e09:	e8 d2 21 00 00       	call   103fe0 <memmove>
    name[len] = 0;
  101e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101e11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101e14:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  101e18:	e9 62 ff ff ff       	jmp    101d7f <namex+0x8f>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101e1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101e20:	89 14 24             	mov    %edx,(%esp)
  101e23:	e8 c8 fc ff ff       	call   101af0 <iunlockput>
  101e28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101e32:	83 c4 1c             	add    $0x1c,%esp
  101e35:	5b                   	pop    %ebx
  101e36:	5e                   	pop    %esi
  101e37:	5f                   	pop    %edi
  101e38:	5d                   	pop    %ebp
  101e39:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  101e3a:	ba 01 00 00 00       	mov    $0x1,%edx
  101e3f:	b8 01 00 00 00       	mov    $0x1,%eax
  101e44:	e8 57 f2 ff ff       	call   1010a0 <iget>
  101e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101e4c:	e9 d2 fe ff ff       	jmp    101d23 <namex+0x33>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  101e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101e54:	89 04 24             	mov    %eax,(%esp)
  101e57:	e8 04 f9 ff ff       	call   101760 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101e5f:	83 c4 1c             	add    $0x1c,%esp
  101e62:	5b                   	pop    %ebx
  101e63:	5e                   	pop    %esi
  101e64:	5f                   	pop    %edi
  101e65:	5d                   	pop    %ebp
  101e66:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
  101e67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101e6a:	89 14 24             	mov    %edx,(%esp)
  101e6d:	e8 1e fa ff ff       	call   101890 <iput>
  101e72:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101e79:	e9 bd fe ff ff       	jmp    101d3b <namex+0x4b>
  101e7e:	66 90                	xchg   %ax,%ax

00101e80 <nameiparent>:
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101e80:	55                   	push   %ebp
  return namex(path, 1, name);
  101e81:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101e86:	89 e5                	mov    %esp,%ebp
  101e88:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return namex(path, 1, name);
}
  101e8e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
  101e8f:	e9 5c fe ff ff       	jmp    101cf0 <namex>
  101e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101ea0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  101ea0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
  101ea1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  101ea3:	89 e5                	mov    %esp,%ebp
  101ea5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
  101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  101eab:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  101eae:	e8 3d fe ff ff       	call   101cf0 <namex>
}
  101eb3:	c9                   	leave  
  101eb4:	c3                   	ret    
  101eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101ec0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  101ec0:	55                   	push   %ebp
  101ec1:	89 e5                	mov    %esp,%ebp
  101ec3:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
  101ec6:	c7 44 24 04 c6 60 10 	movl   $0x1060c6,0x4(%esp)
  101ecd:	00 
  101ece:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101ed5:	e8 46 1e 00 00       	call   103d20 <initlock>
}
  101eda:	c9                   	leave  
  101edb:	c3                   	ret    
  101edc:	90                   	nop    
  101edd:	90                   	nop    
  101ede:	90                   	nop    
  101edf:	90                   	nop    

00101ee0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  101ee0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101ee1:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101ee6:	89 e5                	mov    %esp,%ebp
  101ee8:	56                   	push   %esi
  101ee9:	89 c6                	mov    %eax,%esi
  101eeb:	83 ec 04             	sub    $0x4,%esp
  if(b == 0)
  101eee:	85 c0                	test   %eax,%eax
  101ef0:	0f 84 88 00 00 00    	je     101f7e <idestart+0x9e>
  101ef6:	66 90                	xchg   %ax,%ax
  101ef8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  101ef9:	25 c0 00 00 00       	and    $0xc0,%eax
  101efe:	83 f8 40             	cmp    $0x40,%eax
  101f01:	75 f5                	jne    101ef8 <idestart+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101f03:	ba f6 03 00 00       	mov    $0x3f6,%edx
  101f08:	31 c0                	xor    %eax,%eax
  101f0a:	ee                   	out    %al,(%dx)
    panic("idestart");

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  101f0b:	ba f2 01 00 00       	mov    $0x1f2,%edx
  101f10:	b8 01 00 00 00       	mov    $0x1,%eax
  101f15:	ee                   	out    %al,(%dx)
  101f16:	8b 4e 08             	mov    0x8(%esi),%ecx
  101f19:	b2 f3                	mov    $0xf3,%dl
  101f1b:	89 c8                	mov    %ecx,%eax
  101f1d:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  101f1e:	c1 e9 08             	shr    $0x8,%ecx
  101f21:	b2 f4                	mov    $0xf4,%dl
  101f23:	89 c8                	mov    %ecx,%eax
  101f25:	ee                   	out    %al,(%dx)
  101f26:	c1 e9 08             	shr    $0x8,%ecx
  101f29:	b2 f5                	mov    $0xf5,%dl
  101f2b:	89 c8                	mov    %ecx,%eax
  101f2d:	ee                   	out    %al,(%dx)
  101f2e:	8b 46 04             	mov    0x4(%esi),%eax
  101f31:	c1 e9 08             	shr    $0x8,%ecx
  101f34:	89 ca                	mov    %ecx,%edx
  101f36:	83 e2 0f             	and    $0xf,%edx
  101f39:	83 e0 01             	and    $0x1,%eax
  101f3c:	c1 e0 04             	shl    $0x4,%eax
  101f3f:	09 d0                	or     %edx,%eax
  101f41:	ba f6 01 00 00       	mov    $0x1f6,%edx
  101f46:	83 c8 e0             	or     $0xffffffe0,%eax
  101f49:	ee                   	out    %al,(%dx)
  101f4a:	f6 06 04             	testb  $0x4,(%esi)
  101f4d:	75 11                	jne    101f60 <idestart+0x80>
  101f4f:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101f54:	b8 20 00 00 00       	mov    $0x20,%eax
  101f59:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  101f5a:	83 c4 04             	add    $0x4,%esp
  101f5d:	5e                   	pop    %esi
  101f5e:	5d                   	pop    %ebp
  101f5f:	c3                   	ret    
  101f60:	b2 f7                	mov    $0xf7,%dl
  101f62:	b8 30 00 00 00       	mov    $0x30,%eax
  101f67:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
  101f68:	b9 80 00 00 00       	mov    $0x80,%ecx
  101f6d:	83 c6 18             	add    $0x18,%esi
  101f70:	ba f0 01 00 00       	mov    $0x1f0,%edx
  101f75:	fc                   	cld    
  101f76:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  101f78:	83 c4 04             	add    $0x4,%esp
  101f7b:	5e                   	pop    %esi
  101f7c:	5d                   	pop    %ebp
  101f7d:	c3                   	ret    
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  101f7e:	c7 04 24 cd 60 10 00 	movl   $0x1060cd,(%esp)
  101f85:	e8 f6 e8 ff ff       	call   100880 <panic>
  101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00101f90 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
  101f90:	55                   	push   %ebp
  101f91:	89 e5                	mov    %esp,%ebp
  101f93:	53                   	push   %ebx
  101f94:	83 ec 14             	sub    $0x14,%esp
  101f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  101f9a:	8b 03                	mov    (%ebx),%eax
  101f9c:	a8 01                	test   $0x1,%al
  101f9e:	0f 84 90 00 00 00    	je     102034 <iderw+0xa4>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  101fa4:	83 e0 06             	and    $0x6,%eax
  101fa7:	83 f8 02             	cmp    $0x2,%eax
  101faa:	0f 84 90 00 00 00    	je     102040 <iderw+0xb0>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
  101fb0:	8b 53 04             	mov    0x4(%ebx),%edx
  101fb3:	85 d2                	test   %edx,%edx
  101fb5:	74 0d                	je     101fc4 <iderw+0x34>
  101fb7:	a1 f8 7f 10 00       	mov    0x107ff8,%eax
  101fbc:	85 c0                	test   %eax,%eax
  101fbe:	0f 84 88 00 00 00    	je     10204c <iderw+0xbc>
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);
  101fc4:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  101fcb:	e8 e0 1e 00 00       	call   103eb0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  101fd0:	ba f4 7f 10 00       	mov    $0x107ff4,%edx
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);

  // Append b to idequeue.
  b->qnext = 0;
  101fd5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  101fdc:	a1 f4 7f 10 00       	mov    0x107ff4,%eax
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  101fe1:	85 c0                	test   %eax,%eax
  101fe3:	74 0d                	je     101ff2 <iderw+0x62>
  101fe5:	8d 76 00             	lea    0x0(%esi),%esi
  101fe8:	8d 50 14             	lea    0x14(%eax),%edx
  101feb:	8b 40 14             	mov    0x14(%eax),%eax
  101fee:	85 c0                	test   %eax,%eax
  101ff0:	75 f6                	jne    101fe8 <iderw+0x58>
    ;
  *pp = b;
  101ff2:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(idequeue == b)
  101ff4:	39 1d f4 7f 10 00    	cmp    %ebx,0x107ff4
  101ffa:	75 14                	jne    102010 <iderw+0x80>
  101ffc:	eb 2d                	jmp    10202b <iderw+0x9b>
  101ffe:	66 90                	xchg   %ax,%ax
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &idelock);
  102000:	c7 44 24 04 c0 7f 10 	movl   $0x107fc0,0x4(%esp)
  102007:	00 
  102008:	89 1c 24             	mov    %ebx,(%esp)
  10200b:	e8 10 14 00 00       	call   103420 <sleep>
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102010:	8b 03                	mov    (%ebx),%eax
  102012:	83 e0 06             	and    $0x6,%eax
  102015:	83 f8 02             	cmp    $0x2,%eax
  102018:	75 e6                	jne    102000 <iderw+0x70>
    sleep(b, &idelock);

  release(&idelock);
  10201a:	c7 45 08 c0 7f 10 00 	movl   $0x107fc0,0x8(%ebp)
}
  102021:	83 c4 14             	add    $0x14,%esp
  102024:	5b                   	pop    %ebx
  102025:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &idelock);

  release(&idelock);
  102026:	e9 35 1e 00 00       	jmp    103e60 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  10202b:	89 d8                	mov    %ebx,%eax
  10202d:	e8 ae fe ff ff       	call   101ee0 <idestart>
  102032:	eb dc                	jmp    102010 <iderw+0x80>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  102034:	c7 04 24 d6 60 10 00 	movl   $0x1060d6,(%esp)
  10203b:	e8 40 e8 ff ff       	call   100880 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  102040:	c7 04 24 ea 60 10 00 	movl   $0x1060ea,(%esp)
  102047:	e8 34 e8 ff ff       	call   100880 <panic>
  if(b->dev != 0 && !havedisk1)
    panic("idrw: ide disk 1 not present");
  10204c:	c7 04 24 ff 60 10 00 	movl   $0x1060ff,(%esp)
  102053:	e8 28 e8 ff ff       	call   100880 <panic>
  102058:	90                   	nop    
  102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102060 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
  102060:	55                   	push   %ebp
  102061:	89 e5                	mov    %esp,%ebp
  102063:	57                   	push   %edi
  102064:	53                   	push   %ebx
  102065:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // Take first buffer off queue.
  acquire(&idelock);
  102068:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  10206f:	e8 3c 1e 00 00       	call   103eb0 <acquire>
  if((b = idequeue) == 0){
  102074:	8b 1d f4 7f 10 00    	mov    0x107ff4,%ebx
  10207a:	85 db                	test   %ebx,%ebx
  10207c:	74 7a                	je     1020f8 <ideintr+0x98>
    release(&idelock);
    cprintf("Spurious IDE interrupt.\n");
    return;
  }
  idequeue = b->qnext;
  10207e:	8b 43 14             	mov    0x14(%ebx),%eax
  102081:	a3 f4 7f 10 00       	mov    %eax,0x107ff4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
  102086:	8b 0b                	mov    (%ebx),%ecx
  102088:	f6 c1 04             	test   $0x4,%cl
  10208b:	74 33                	je     1020c0 <ideintr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  10208d:	83 c9 02             	or     $0x2,%ecx
  102090:	83 e1 fb             	and    $0xfffffffb,%ecx
  102093:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  102095:	89 1c 24             	mov    %ebx,(%esp)
  102098:	e8 33 11 00 00       	call   1031d0 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
  10209d:	a1 f4 7f 10 00       	mov    0x107ff4,%eax
  1020a2:	85 c0                	test   %eax,%eax
  1020a4:	74 05                	je     1020ab <ideintr+0x4b>
    idestart(idequeue);
  1020a6:	e8 35 fe ff ff       	call   101ee0 <idestart>

  release(&idelock);
  1020ab:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  1020b2:	e8 a9 1d 00 00       	call   103e60 <release>
}
  1020b7:	83 c4 10             	add    $0x10,%esp
  1020ba:	5b                   	pop    %ebx
  1020bb:	5f                   	pop    %edi
  1020bc:	5d                   	pop    %ebp
  1020bd:	c3                   	ret    
  1020be:	66 90                	xchg   %ax,%ax
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1020c0:	bf f7 01 00 00       	mov    $0x1f7,%edi
  1020c5:	8d 76 00             	lea    0x0(%esi),%esi
  1020c8:	89 fa                	mov    %edi,%edx
  1020ca:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  1020cb:	0f b6 d0             	movzbl %al,%edx
  1020ce:	89 d0                	mov    %edx,%eax
  1020d0:	25 c0 00 00 00       	and    $0xc0,%eax
  1020d5:	83 f8 40             	cmp    $0x40,%eax
  1020d8:	75 ee                	jne    1020c8 <ideintr+0x68>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
  1020da:	83 e2 21             	and    $0x21,%edx
  1020dd:	75 ae                	jne    10208d <ideintr+0x2d>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
  1020df:	8d 7b 18             	lea    0x18(%ebx),%edi
  1020e2:	b9 80 00 00 00       	mov    $0x80,%ecx
  1020e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
  1020ec:	fc                   	cld    
  1020ed:	f3 6d                	rep insl (%dx),%es:(%edi)
  1020ef:	8b 0b                	mov    (%ebx),%ecx
  1020f1:	eb 9a                	jmp    10208d <ideintr+0x2d>
  1020f3:	90                   	nop    
  1020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct buf *b;

  // Take first buffer off queue.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
  1020f8:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  1020ff:	e8 5c 1d 00 00       	call   103e60 <release>
    cprintf("Spurious IDE interrupt.\n");
  102104:	c7 04 24 1c 61 10 00 	movl   $0x10611c,(%esp)
  10210b:	e8 90 e3 ff ff       	call   1004a0 <cprintf>
  102110:	eb a5                	jmp    1020b7 <ideintr+0x57>
  102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102120 <ideinit>:
  return 0;
}

void
ideinit(void)
{
  102120:	55                   	push   %ebp
  102121:	89 e5                	mov    %esp,%ebp
  102123:	53                   	push   %ebx
  102124:	83 ec 14             	sub    $0x14,%esp
  int i;

  initlock(&idelock, "ide");
  102127:	c7 44 24 04 35 61 10 	movl   $0x106135,0x4(%esp)
  10212e:	00 
  10212f:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  102136:	e8 e5 1b 00 00       	call   103d20 <initlock>
  picenable(IRQ_IDE);
  10213b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102142:	e8 89 0b 00 00       	call   102cd0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
  102147:	a1 40 b8 10 00       	mov    0x10b840,%eax
  10214c:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102153:	83 e8 01             	sub    $0x1,%eax
  102156:	89 44 24 04          	mov    %eax,0x4(%esp)
  10215a:	e8 61 00 00 00       	call   1021c0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10215f:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102168:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  102169:	25 c0 00 00 00       	and    $0xc0,%eax
  10216e:	83 f8 40             	cmp    $0x40,%eax
  102171:	75 f5                	jne    102168 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102173:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102178:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  10217d:	ee                   	out    %al,(%dx)
  10217e:	31 db                	xor    %ebx,%ebx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102180:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
  102185:	eb 0c                	jmp    102193 <ideinit+0x73>
  102187:	90                   	nop    
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  102188:	83 c3 01             	add    $0x1,%ebx
  10218b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  102191:	74 11                	je     1021a4 <ideinit+0x84>
  102193:	89 ca                	mov    %ecx,%edx
  102195:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  102196:	84 c0                	test   %al,%al
  102198:	74 ee                	je     102188 <ideinit+0x68>
      havedisk1 = 1;
  10219a:	c7 05 f8 7f 10 00 01 	movl   $0x1,0x107ff8
  1021a1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1021a4:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1021a9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1021ae:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1021af:	83 c4 14             	add    $0x14,%esp
  1021b2:	5b                   	pop    %ebx
  1021b3:	5d                   	pop    %ebp
  1021b4:	c3                   	ret    
  1021b5:	90                   	nop    
  1021b6:	90                   	nop    
  1021b7:	90                   	nop    
  1021b8:	90                   	nop    
  1021b9:	90                   	nop    
  1021ba:	90                   	nop    
  1021bb:	90                   	nop    
  1021bc:	90                   	nop    
  1021bd:	90                   	nop    
  1021be:	90                   	nop    
  1021bf:	90                   	nop    

001021c0 <ioapicenable>:
}

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
  1021c0:	8b 15 44 b2 10 00    	mov    0x10b244,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
  1021c6:	55                   	push   %ebp
  1021c7:	89 e5                	mov    %esp,%ebp
  1021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  1021cc:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
  1021ce:	53                   	push   %ebx
  1021cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  1021d2:	74 2b                	je     1021ff <ioapicenable+0x3f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  1021d4:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
  1021d8:	8d 48 20             	lea    0x20(%eax),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021db:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  1021e0:	c1 e3 18             	shl    $0x18,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021e3:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  1021e5:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021ea:	83 c2 01             	add    $0x1,%edx
  ioapic->data = data;
  1021ed:	89 48 10             	mov    %ecx,0x10(%eax)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021f0:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  1021f5:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  1021f7:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  1021fc:	89 58 10             	mov    %ebx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
  1021ff:	5b                   	pop    %ebx
  102200:	5d                   	pop    %ebp
  102201:	c3                   	ret    
  102202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102210 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
  102210:	55                   	push   %ebp
  102211:	89 e5                	mov    %esp,%ebp
  102213:	56                   	push   %esi
  102214:	53                   	push   %ebx
  102215:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  102218:	8b 0d 44 b2 10 00    	mov    0x10b244,%ecx
  10221e:	85 c9                	test   %ecx,%ecx
  102220:	74 7e                	je     1022a0 <ioapicinit+0x90>
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  102229:	00 00 00 
  return ioapic->data;
  10222c:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  102231:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  102238:	00 00 00 
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  10223b:	0f b6 15 40 b2 10 00 	movzbl 0x10b240,%edx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102242:	c7 05 f4 b1 10 00 00 	movl   $0xfec00000,0x10b1f4
  102249:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  10224c:	c1 e8 10             	shr    $0x10,%eax
  10224f:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
  102252:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  102257:	c1 e8 18             	shr    $0x18,%eax
  10225a:	39 c2                	cmp    %eax,%edx
  10225c:	75 4a                	jne    1022a8 <ioapicinit+0x98>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  10225e:	31 db                	xor    %ebx,%ebx
  102260:	b9 10 00 00 00       	mov    $0x10,%ecx
  102265:	8d 76 00             	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102268:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  10226d:	8d 53 20             	lea    0x20(%ebx),%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  102270:	83 c3 01             	add    $0x1,%ebx
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  102273:	81 ca 00 00 01 00    	or     $0x10000,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102279:	89 08                	mov    %ecx,(%eax)
  ioapic->data = data;
  10227b:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  102280:	89 50 10             	mov    %edx,0x10(%eax)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102283:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  102288:	8d 51 01             	lea    0x1(%ecx),%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10228b:	83 c1 02             	add    $0x2,%ecx
  10228e:	39 de                	cmp    %ebx,%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102290:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  102292:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  102297:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10229e:	7d c8                	jge    102268 <ioapicinit+0x58>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
  1022a0:	83 c4 10             	add    $0x10,%esp
  1022a3:	5b                   	pop    %ebx
  1022a4:	5e                   	pop    %esi
  1022a5:	5d                   	pop    %ebp
  1022a6:	c3                   	ret    
  1022a7:	90                   	nop    

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  1022a8:	c7 04 24 3c 61 10 00 	movl   $0x10613c,(%esp)
  1022af:	e8 ec e1 ff ff       	call   1004a0 <cprintf>
  1022b4:	eb a8                	jmp    10225e <ioapicinit+0x4e>
  1022b6:	90                   	nop    
  1022b7:	90                   	nop    
  1022b8:	90                   	nop    
  1022b9:	90                   	nop    
  1022ba:	90                   	nop    
  1022bb:	90                   	nop    
  1022bc:	90                   	nop    
  1022bd:	90                   	nop    
  1022be:	90                   	nop    
  1022bf:	90                   	nop    

001022c0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1022c0:	55                   	push   %ebp
  1022c1:	89 e5                	mov    %esp,%ebp
  1022c3:	53                   	push   %ebx
  1022c4:	83 ec 04             	sub    $0x4,%esp
  1022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1022ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
  1022d0:	74 0e                	je     1022e0 <kalloc+0x20>
    panic("kalloc");
  1022d2:	c7 04 24 6e 61 10 00 	movl   $0x10616e,(%esp)
  1022d9:	e8 a2 e5 ff ff       	call   100880 <panic>
  1022de:	66 90                	xchg   %ax,%ax
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1022e0:	85 db                	test   %ebx,%ebx
  1022e2:	7e ee                	jle    1022d2 <kalloc+0x12>
    panic("kalloc");

  acquire(&kmem.lock);
  1022e4:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  1022eb:	e8 c0 1b 00 00       	call   103eb0 <acquire>
  1022f0:	8b 15 34 b2 10 00    	mov    0x10b234,%edx
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
  1022f6:	85 d2                	test   %edx,%edx
  1022f8:	74 1d                	je     102317 <kalloc+0x57>
    if(r->len >= n){
  1022fa:	8b 42 04             	mov    0x4(%edx),%eax
  1022fd:	b9 34 b2 10 00       	mov    $0x10b234,%ecx
  102302:	39 c3                	cmp    %eax,%ebx
  102304:	7f 09                	jg     10230f <kalloc+0x4f>
  102306:	eb 38                	jmp    102340 <kalloc+0x80>
  102308:	8b 42 04             	mov    0x4(%edx),%eax
  10230b:	39 c3                	cmp    %eax,%ebx
  10230d:	7e 31                	jle    102340 <kalloc+0x80>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
  10230f:	89 d1                	mov    %edx,%ecx
  102311:	8b 12                	mov    (%edx),%edx
  102313:	85 d2                	test   %edx,%edx
  102315:	75 f1                	jne    102308 <kalloc+0x48>
      return p;
    }
  }
  release(&kmem.lock);

  cprintf("kalloc: out of memory\n");
  102317:	31 db                	xor    %ebx,%ebx
        *rp = r->next;
      release(&kmem.lock);
      return p;
    }
  }
  release(&kmem.lock);
  102319:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  102320:	e8 3b 1b 00 00       	call   103e60 <release>

  cprintf("kalloc: out of memory\n");
  102325:	c7 04 24 75 61 10 00 	movl   $0x106175,(%esp)
  10232c:	e8 6f e1 ff ff       	call   1004a0 <cprintf>
  return 0;
}
  102331:	89 d8                	mov    %ebx,%eax
  102333:	83 c4 04             	add    $0x4,%esp
  102336:	5b                   	pop    %ebx
  102337:	5d                   	pop    %ebp
  102338:	c3                   	ret    
  102339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("kalloc");

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len >= n){
      r->len -= n;
  102340:	29 d8                	sub    %ebx,%eax
      p = (char*)r + r->len;
      if(r->len == 0)
  102342:	85 c0                	test   %eax,%eax
    panic("kalloc");

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len >= n){
      r->len -= n;
  102344:	89 c3                	mov    %eax,%ebx
  102346:	89 42 04             	mov    %eax,0x4(%edx)
      p = (char*)r + r->len;
      if(r->len == 0)
  102349:	75 04                	jne    10234f <kalloc+0x8f>
        *rp = r->next;
  10234b:	8b 02                	mov    (%edx),%eax
  10234d:	89 01                	mov    %eax,(%ecx)

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len >= n){
      r->len -= n;
      p = (char*)r + r->len;
  10234f:	8d 1c 1a             	lea    (%edx,%ebx,1),%ebx
      if(r->len == 0)
        *rp = r->next;
      release(&kmem.lock);
  102352:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  102359:	e8 02 1b 00 00       	call   103e60 <release>
  }
  release(&kmem.lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10235e:	89 d8                	mov    %ebx,%eax
  102360:	83 c4 04             	add    $0x4,%esp
  102363:	5b                   	pop    %ebx
  102364:	5d                   	pop    %ebp
  102365:	c3                   	ret    
  102366:	8d 76 00             	lea    0x0(%esi),%esi
  102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102370 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102370:	55                   	push   %ebp
  102371:	89 e5                	mov    %esp,%ebp
  102373:	57                   	push   %edi
  102374:	56                   	push   %esi
  102375:	53                   	push   %ebx
  102376:	83 ec 1c             	sub    $0x1c,%esp
  102379:	8b 45 0c             	mov    0xc(%ebp),%eax
  10237c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  10237f:	85 c0                	test   %eax,%eax
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102381:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  102384:	7e 07                	jle    10238d <kfree+0x1d>
  102386:	a9 ff 0f 00 00       	test   $0xfff,%eax
  10238b:	74 13                	je     1023a0 <kfree+0x30>
    panic("kfree");
  10238d:	c7 04 24 8c 61 10 00 	movl   $0x10618c,(%esp)
  102394:	e8 e7 e4 ff ff       	call   100880 <panic>
  102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1023a0:	8b 45 f0             	mov    -0x10(%ebp),%eax

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023a3:	bf 34 b2 10 00       	mov    $0x10b234,%edi

  if(len <= 0 || len % PAGE)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1023a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1023af:	00 
  1023b0:	89 1c 24             	mov    %ebx,(%esp)
  1023b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1023b7:	e8 94 1b 00 00       	call   103f50 <memset>

  acquire(&kmem.lock);
  1023bc:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  1023c3:	e8 e8 1a 00 00       	call   103eb0 <acquire>
  p = (struct run*)v;
  1023c8:	8b 15 34 b2 10 00    	mov    0x10b234,%edx
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023ce:	85 d2                	test   %edx,%edx
  1023d0:	74 7e                	je     102450 <kfree+0xe0>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023d5:	bf 34 b2 10 00       	mov    $0x10b234,%edi
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1023da:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023dd:	39 d6                	cmp    %edx,%esi
  1023df:	72 6f                	jb     102450 <kfree+0xe0>
    rend = (struct run*)((char*)r + r->len);
  1023e1:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  1023e4:	39 d3                	cmp    %edx,%ebx

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  1023e6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    if(r <= p && p < rend)
  1023e9:	73 5d                	jae    102448 <kfree+0xd8>
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
  1023eb:	39 d9                	cmp    %ebx,%ecx
  1023ed:	74 71                	je     102460 <kfree+0xf0>
        r->len += r->next->len;
        r->next = r->next->next;
      }
      goto out;
    }
    if(pend == r){  // p before r: expand p to include, replace r
  1023ef:	39 d6                	cmp    %edx,%esi
  1023f1:	bf 34 b2 10 00       	mov    $0x10b234,%edi
  1023f6:	74 30                	je     102428 <kfree+0xb8>
  memset(v, 1, len);

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023f8:	89 d7                	mov    %edx,%edi
  1023fa:	8b 12                	mov    (%edx),%edx
  1023fc:	85 d2                	test   %edx,%edx
  1023fe:	74 50                	je     102450 <kfree+0xe0>
  102400:	39 d6                	cmp    %edx,%esi
  102402:	72 4c                	jb     102450 <kfree+0xe0>
    rend = (struct run*)((char*)r + r->len);
  102404:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102407:	39 d3                	cmp    %edx,%ebx

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  102409:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    if(r <= p && p < rend)
  10240c:	72 12                	jb     102420 <kfree+0xb0>
  10240e:	39 cb                	cmp    %ecx,%ebx
  102410:	73 0e                	jae    102420 <kfree+0xb0>
      panic("freeing free page");
  102412:	c7 04 24 92 61 10 00 	movl   $0x106192,(%esp)
  102419:	e8 62 e4 ff ff       	call   100880 <panic>
  10241e:	66 90                	xchg   %ax,%ax
    if(rend == p){  // r before p: expand r to include p
  102420:	39 d9                	cmp    %ebx,%ecx
  102422:	74 3c                	je     102460 <kfree+0xf0>
        r->len += r->next->len;
        r->next = r->next->next;
      }
      goto out;
    }
    if(pend == r){  // p before r: expand p to include, replace r
  102424:	39 d6                	cmp    %edx,%esi
  102426:	75 d0                	jne    1023f8 <kfree+0x88>
      p->len = len + r->len;
  102428:	03 45 f0             	add    -0x10(%ebp),%eax
  10242b:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  10242e:	8b 06                	mov    (%esi),%eax
  102430:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  102432:	89 1f                	mov    %ebx,(%edi)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kmem.lock);
  102434:	c7 45 08 00 b2 10 00 	movl   $0x10b200,0x8(%ebp)
}
  10243b:	83 c4 1c             	add    $0x1c,%esp
  10243e:	5b                   	pop    %ebx
  10243f:	5e                   	pop    %esi
  102440:	5f                   	pop    %edi
  102441:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kmem.lock);
  102442:	e9 19 1a 00 00       	jmp    103e60 <release>
  102447:	90                   	nop    
  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102448:	39 cb                	cmp    %ecx,%ebx
  10244a:	72 c6                	jb     102412 <kfree+0xa2>
  10244c:	eb 9d                	jmp    1023eb <kfree+0x7b>
  10244e:	66 90                	xchg   %ax,%ax
      *rp = p;
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  p->next = r;
  102453:	89 13                	mov    %edx,(%ebx)
      *rp = p;
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102455:	89 43 04             	mov    %eax,0x4(%ebx)
  p->next = r;
  *rp = p;
  102458:	89 1f                	mov    %ebx,(%edi)
  10245a:	eb d8                	jmp    102434 <kfree+0xc4>
  10245c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102460:	8b 0a                	mov    (%edx),%ecx
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
      r->len += len;
  102462:	03 45 f0             	add    -0x10(%ebp),%eax
      if(r->next && r->next == pend){  // r now next to r->next?
  102465:	85 c9                	test   %ecx,%ecx
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
      r->len += len;
  102467:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10246a:	74 c8                	je     102434 <kfree+0xc4>
  10246c:	39 ce                	cmp    %ecx,%esi
  10246e:	75 c4                	jne    102434 <kfree+0xc4>
        r->len += r->next->len;
  102470:	03 46 04             	add    0x4(%esi),%eax
  102473:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  102476:	8b 06                	mov    (%esi),%eax
  102478:	89 02                	mov    %eax,(%edx)
  10247a:	eb b8                	jmp    102434 <kfree+0xc4>
  10247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102480 <kinit>:
// This code cheats by just considering one megabyte of
// pages after end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102480:	55                   	push   %ebp
  102481:	89 e5                	mov    %esp,%ebp
  102483:	83 ec 08             	sub    $0x8,%esp
  extern char end[];
  uint len;
  char *p;

  initlock(&kmem.lock, "kmem");
  102486:	c7 44 24 04 a4 61 10 	movl   $0x1061a4,0x4(%esp)
  10248d:	00 
  10248e:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  102495:	e8 86 18 00 00       	call   103d20 <initlock>
  p = (char*)(((uint)end + PAGE) & ~(PAGE-1));
  len = 256*PAGE; // assume computer has 256 pages of RAM, 1 MB
  cprintf("mem = %d\n", len);
  10249a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1024a1:	00 
  1024a2:	c7 04 24 a9 61 10 00 	movl   $0x1061a9,(%esp)
  1024a9:	e8 f2 df ff ff       	call   1004a0 <cprintf>
  kfree(p, len);
  1024ae:	b8 e4 ef 10 00       	mov    $0x10efe4,%eax
  1024b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1024b8:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1024bf:	00 
  1024c0:	89 04 24             	mov    %eax,(%esp)
  1024c3:	e8 a8 fe ff ff       	call   102370 <kfree>
}
  1024c8:	c9                   	leave  
  1024c9:	c3                   	ret    
  1024ca:	90                   	nop    
  1024cb:	90                   	nop    
  1024cc:	90                   	nop    
  1024cd:	90                   	nop    
  1024ce:	90                   	nop    
  1024cf:	90                   	nop    

001024d0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
  1024d0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1024d1:	ba 64 00 00 00       	mov    $0x64,%edx
  1024d6:	89 e5                	mov    %esp,%ebp
  1024d8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  1024d9:	a8 01                	test   $0x1,%al
  1024db:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1024e0:	74 76                	je     102558 <kbdgetc+0x88>
  1024e2:	ba 60 00 00 00       	mov    $0x60,%edx
  1024e7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  1024e8:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
  1024eb:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
  1024f1:	0f 84 99 00 00 00    	je     102590 <kbdgetc+0xc0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  1024f7:	84 c9                	test   %cl,%cl
  1024f9:	78 65                	js     102560 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  1024fb:	a1 fc 7f 10 00       	mov    0x107ffc,%eax
  102500:	a8 40                	test   $0x40,%al
  102502:	74 0b                	je     10250f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  102504:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102507:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  10250a:	a3 fc 7f 10 00       	mov    %eax,0x107ffc
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  10250f:	0f b6 91 c0 62 10 00 	movzbl 0x1062c0(%ecx),%edx
  102516:	0f b6 81 c0 61 10 00 	movzbl 0x1061c0(%ecx),%eax
  10251d:	0b 05 fc 7f 10 00    	or     0x107ffc,%eax
  102523:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  102525:	89 c2                	mov    %eax,%edx
  102527:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  10252a:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  10252c:	8b 14 95 c0 63 10 00 	mov    0x1063c0(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102533:	a3 fc 7f 10 00       	mov    %eax,0x107ffc
  c = charcode[shift & (CTL | SHIFT)][data];
  102538:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  10253c:	74 1a                	je     102558 <kbdgetc+0x88>
    if('a' <= c && c <= 'z')
  10253e:	8d 42 9f             	lea    -0x61(%edx),%eax
  102541:	83 f8 19             	cmp    $0x19,%eax
  102544:	76 5a                	jbe    1025a0 <kbdgetc+0xd0>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  102546:	8d 42 bf             	lea    -0x41(%edx),%eax
  102549:	83 f8 19             	cmp    $0x19,%eax
  10254c:	77 0a                	ja     102558 <kbdgetc+0x88>
      c += 'a' - 'A';
  10254e:	83 c2 20             	add    $0x20,%edx
  102551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  return c;
}
  102558:	89 d0                	mov    %edx,%eax
  10255a:	5d                   	pop    %ebp
  10255b:	c3                   	ret    
  10255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  102560:	8b 15 fc 7f 10 00    	mov    0x107ffc,%edx
  102566:	f6 c2 40             	test   $0x40,%dl
  102569:	75 03                	jne    10256e <kbdgetc+0x9e>
  10256b:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  10256e:	0f b6 81 c0 61 10 00 	movzbl 0x1061c0(%ecx),%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102575:	5d                   	pop    %ebp
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
  102576:	83 c8 40             	or     $0x40,%eax
  102579:	0f b6 c0             	movzbl %al,%eax
  10257c:	f7 d0                	not    %eax
  10257e:	21 d0                	and    %edx,%eax
  102580:	31 d2                	xor    %edx,%edx
  102582:	a3 fc 7f 10 00       	mov    %eax,0x107ffc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102587:	89 d0                	mov    %edx,%eax
  102589:	c3                   	ret    
  10258a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  102590:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102592:	89 d0                	mov    %edx,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  102594:	83 0d fc 7f 10 00 40 	orl    $0x40,0x107ffc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  10259b:	5d                   	pop    %ebp
  10259c:	c3                   	ret    
  10259d:	8d 76 00             	lea    0x0(%esi),%esi
  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
  1025a0:	83 ea 20             	sub    $0x20,%edx
  1025a3:	eb b3                	jmp    102558 <kbdgetc+0x88>
  1025a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001025b0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
  1025b0:	55                   	push   %ebp
  1025b1:	89 e5                	mov    %esp,%ebp
  1025b3:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
  1025b6:	c7 04 24 d0 24 10 00 	movl   $0x1024d0,(%esp)
  1025bd:	e8 4e e1 ff ff       	call   100710 <consoleintr>
}
  1025c2:	c9                   	leave  
  1025c3:	c3                   	ret    
  1025c4:	90                   	nop    
  1025c5:	90                   	nop    
  1025c6:	90                   	nop    
  1025c7:	90                   	nop    
  1025c8:	90                   	nop    
  1025c9:	90                   	nop    
  1025ca:	90                   	nop    
  1025cb:	90                   	nop    
  1025cc:	90                   	nop    
  1025cd:	90                   	nop    
  1025ce:	90                   	nop    
  1025cf:	90                   	nop    

001025d0 <lapicinit>:
}

void
lapicinit(int c)
{
  if(!lapic) 
  1025d0:	a1 38 b2 10 00       	mov    0x10b238,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(int c)
{
  1025d5:	55                   	push   %ebp
  1025d6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1025d8:	85 c0                	test   %eax,%eax
  1025da:	0f 84 09 01 00 00    	je     1026e9 <lapicinit+0x119>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1025e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  1025e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1025ea:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1025ef:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1025f2:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1025f9:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1025fc:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102601:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102604:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  10260b:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  10260e:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102613:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102616:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10261d:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  102620:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102625:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102628:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10262f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  102632:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102637:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10263a:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102641:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  102644:	8b 15 38 b2 10 00    	mov    0x10b238,%edx
  10264a:	8b 42 20             	mov    0x20(%edx),%eax
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10264d:	8b 42 30             	mov    0x30(%edx),%eax
  102650:	c1 e8 10             	shr    $0x10,%eax
  102653:	3c 03                	cmp    $0x3,%al
  102655:	0f 87 95 00 00 00    	ja     1026f0 <lapicinit+0x120>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10265b:	c7 82 70 03 00 00 33 	movl   $0x33,0x370(%edx)
  102662:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102665:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10266a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10266d:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102677:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10267c:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10267f:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102686:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102689:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10268e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102691:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102698:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10269b:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1026a0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026a3:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  1026aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026ad:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1026b2:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026b5:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1026bc:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  1026bf:	8b 0d 38 b2 10 00    	mov    0x10b238,%ecx
  1026c5:	8b 41 20             	mov    0x20(%ecx),%eax
  1026c8:	8d 91 00 03 00 00    	lea    0x300(%ecx),%edx
  1026ce:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  1026d0:	8b 02                	mov    (%edx),%eax
  1026d2:	f6 c4 10             	test   $0x10,%ah
  1026d5:	75 f9                	jne    1026d0 <lapicinit+0x100>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026d7:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
  1026de:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026e1:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1026e6:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1026e9:	5d                   	pop    %ebp
  1026ea:	c3                   	ret    
  1026eb:	90                   	nop    
  1026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026f0:	c7 82 40 03 00 00 00 	movl   $0x10000,0x340(%edx)
  1026f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1026fa:	8b 15 38 b2 10 00    	mov    0x10b238,%edx
  102700:	8b 42 20             	mov    0x20(%edx),%eax
  102703:	e9 53 ff ff ff       	jmp    10265b <lapicinit+0x8b>
  102708:	90                   	nop    
  102709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102710 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
  102710:	a1 38 b2 10 00       	mov    0x10b238,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
  102715:	55                   	push   %ebp
  102716:	89 e5                	mov    %esp,%ebp
  if(lapic)
  102718:	85 c0                	test   %eax,%eax
  10271a:	74 12                	je     10272e <lapiceoi+0x1e>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10271c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102723:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102726:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10272b:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  10272e:	5d                   	pop    %ebp
  10272f:	c3                   	ret    

00102730 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  102730:	55                   	push   %ebp
  102731:	89 e5                	mov    %esp,%ebp
}
  102733:	5d                   	pop    %ebp
  102734:	c3                   	ret    
  102735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102740 <lapicstartap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
  102740:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102741:	ba 70 00 00 00       	mov    $0x70,%edx
  102746:	89 e5                	mov    %esp,%ebp
  102748:	b8 0f 00 00 00       	mov    $0xf,%eax
  10274d:	53                   	push   %ebx
  10274e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102751:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  102755:	ee                   	out    %al,(%dx)
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102756:	b8 0a 00 00 00       	mov    $0xa,%eax
  10275b:	b2 71                	mov    $0x71,%dl
  10275d:	ee                   	out    %al,(%dx)
  10275e:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102763:	c1 e3 18             	shl    $0x18,%ebx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102766:	c1 e9 04             	shr    $0x4,%ecx
  102769:	66 89 0d 69 04 00 00 	mov    %cx,0x469

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  102770:	c1 e9 08             	shr    $0x8,%ecx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102773:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  10277a:	00 00 

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  10277c:	80 cd 06             	or     $0x6,%ch
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10277f:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102785:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10278a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10278d:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
  102794:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102797:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10279c:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10279f:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
  1027a6:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027a9:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1027ae:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027b1:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027b7:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1027bc:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027c5:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1027ca:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027cd:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027d3:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1027d8:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027db:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027e1:	a1 38 b2 10 00       	mov    0x10b238,%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  1027e6:	5b                   	pop    %ebx
  1027e7:	5d                   	pop    %ebp

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  1027e8:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  1027eb:	c3                   	ret    
  1027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001027f0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
  1027f0:	55                   	push   %ebp
  1027f1:	89 e5                	mov    %esp,%ebp
  1027f3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1027f6:	9c                   	pushf  
  1027f7:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
  1027f8:	f6 c4 02             	test   $0x2,%ah
  1027fb:	74 12                	je     10280f <cpunum+0x1f>
    static int n;
    if(n++ == 0)
  1027fd:	8b 15 00 80 10 00    	mov    0x108000,%edx
  102803:	8d 42 01             	lea    0x1(%edx),%eax
  102806:	85 d2                	test   %edx,%edx
  102808:	a3 00 80 10 00       	mov    %eax,0x108000
  10280d:	74 19                	je     102828 <cpunum+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if(lapic)
  10280f:	8b 15 38 b2 10 00    	mov    0x10b238,%edx
  102815:	31 c0                	xor    %eax,%eax
  102817:	85 d2                	test   %edx,%edx
  102819:	74 06                	je     102821 <cpunum+0x31>
    return lapic[ID]>>24;
  10281b:	8b 42 20             	mov    0x20(%edx),%eax
  10281e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102821:	c9                   	leave  
  102822:	c3                   	ret    
  102823:	90                   	nop    
  102824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102828:	8b 45 04             	mov    0x4(%ebp),%eax
  10282b:	c7 04 24 d0 63 10 00 	movl   $0x1063d0,(%esp)
  102832:	89 44 24 04          	mov    %eax,0x4(%esp)
  102836:	e8 65 dc ff ff       	call   1004a0 <cprintf>
  10283b:	eb d2                	jmp    10280f <cpunum+0x1f>
  10283d:	90                   	nop    
  10283e:	90                   	nop    
  10283f:	90                   	nop    

00102840 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102840:	55                   	push   %ebp
  102841:	89 e5                	mov    %esp,%ebp
  102843:	53                   	push   %ebx
  102844:	83 ec 14             	sub    $0x14,%esp
  if(cpunum() != mpbcpu())
  102847:	e8 a4 ff ff ff       	call   1027f0 <cpunum>
  10284c:	89 c3                	mov    %eax,%ebx
  10284e:	e8 ed 01 00 00       	call   102a40 <mpbcpu>
  102853:	39 c3                	cmp    %eax,%ebx
  102855:	74 0d                	je     102864 <mpmain+0x24>
    lapicinit(cpunum());
  102857:	e8 94 ff ff ff       	call   1027f0 <cpunum>
  10285c:	89 04 24             	mov    %eax,(%esp)
  10285f:	e8 6c fd ff ff       	call   1025d0 <lapicinit>
  ksegment();
  102864:	e8 f7 12 00 00       	call   103b60 <ksegment>
  cprintf("cpu%d: mpmain\n", cpu->id);
  102869:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10286f:	0f b6 00             	movzbl (%eax),%eax
  102872:	c7 04 24 fc 63 10 00 	movl   $0x1063fc,(%esp)
  102879:	89 44 24 04          	mov    %eax,0x4(%esp)
  10287d:	e8 1e dc ff ff       	call   1004a0 <cprintf>
  idtinit();
  102882:	e8 e9 27 00 00       	call   105070 <idtinit>
  xchg(&cpu->booted, 1);
  102887:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10288d:	ba 01 00 00 00       	mov    $0x1,%edx
  102892:	8d 88 a8 00 00 00    	lea    0xa8(%eax),%ecx
  102898:	89 d0                	mov    %edx,%eax
  10289a:	f0 87 01             	lock xchg %eax,(%ecx)

  cprintf("cpu%d: scheduling\n", cpu->id);
  10289d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1028a3:	0f b6 00             	movzbl (%eax),%eax
  1028a6:	c7 04 24 0b 64 10 00 	movl   $0x10640b,(%esp)
  1028ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028b1:	e8 ea db ff ff       	call   1004a0 <cprintf>
  scheduler();
  1028b6:	e8 65 11 00 00       	call   103a20 <scheduler>
  1028bb:	90                   	nop    
  1028bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001028c0 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  1028c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  1028c4:	83 e4 f0             	and    $0xfffffff0,%esp
  1028c7:	ff 71 fc             	pushl  -0x4(%ecx)
  1028ca:	55                   	push   %ebp
  1028cb:	89 e5                	mov    %esp,%ebp
  1028cd:	53                   	push   %ebx
  1028ce:	51                   	push   %ecx
  1028cf:	83 ec 10             	sub    $0x10,%esp
  mpinit(); // collect info about this machine
  1028d2:	e8 f9 01 00 00       	call   102ad0 <mpinit>
  lapicinit(mpbcpu());
  1028d7:	e8 64 01 00 00       	call   102a40 <mpbcpu>
  1028dc:	89 04 24             	mov    %eax,(%esp)
  1028df:	e8 ec fc ff ff       	call   1025d0 <lapicinit>
  ksegment();
  1028e4:	e8 77 12 00 00       	call   103b60 <ksegment>
  picinit();       // interrupt controller
  1028e9:	e8 12 04 00 00       	call   102d00 <picinit>
  1028ee:	66 90                	xchg   %ax,%ax
  ioapicinit();    // another interrupt controller
  1028f0:	e8 1b f9 ff ff       	call   102210 <ioapicinit>
  1028f5:	8d 76 00             	lea    0x0(%esi),%esi
  consoleinit();   // I/O devices & their interrupts
  1028f8:	e8 13 d9 ff ff       	call   100210 <consoleinit>
  1028fd:	8d 76 00             	lea    0x0(%esi),%esi
  uartinit();      // serial port
  102900:	e8 2b 2b 00 00       	call   105430 <uartinit>
cprintf("cpus %p cpu %p\n", cpus, cpu);
  102905:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10290b:	c7 44 24 04 60 b2 10 	movl   $0x10b260,0x4(%esp)
  102912:	00 
  102913:	c7 04 24 1e 64 10 00 	movl   $0x10641e,(%esp)
  10291a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10291e:	e8 7d db ff ff       	call   1004a0 <cprintf>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
  102923:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  102929:	0f b6 00             	movzbl (%eax),%eax
  10292c:	c7 04 24 2e 64 10 00 	movl   $0x10642e,(%esp)
  102933:	89 44 24 04          	mov    %eax,0x4(%esp)
  102937:	e8 64 db ff ff       	call   1004a0 <cprintf>

  kinit();         // physical memory allocator
  10293c:	e8 3f fb ff ff       	call   102480 <kinit>
  pinit();         // process table
  102941:	e8 ba 13 00 00       	call   103d00 <pinit>
  102946:	66 90                	xchg   %ax,%ax
  tvinit();        // trap vectors
  102948:	e8 a3 29 00 00       	call   1052f0 <tvinit>
  10294d:	8d 76 00             	lea    0x0(%esi),%esi
  binit();         // buffer cache
  102950:	e8 4b d8 ff ff       	call   1001a0 <binit>
  102955:	8d 76 00             	lea    0x0(%esi),%esi
  fileinit();      // file table
  102958:	e8 c3 e6 ff ff       	call   101020 <fileinit>
  10295d:	8d 76 00             	lea    0x0(%esi),%esi
  iinit();         // inode cache
  102960:	e8 5b f5 ff ff       	call   101ec0 <iinit>
  102965:	8d 76 00             	lea    0x0(%esi),%esi
  ideinit();       // disk
  102968:	e8 b3 f7 ff ff       	call   102120 <ideinit>
  if(!ismp)
  10296d:	a1 44 b2 10 00       	mov    0x10b244,%eax
  102972:	85 c0                	test   %eax,%eax
  102974:	0f 84 ae 00 00 00    	je     102a28 <main+0x168>
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  10297a:	e8 91 0e 00 00       	call   103810 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  10297f:	c7 44 24 08 6a 00 00 	movl   $0x6a,0x8(%esp)
  102986:	00 
  102987:	c7 44 24 04 f4 7e 10 	movl   $0x107ef4,0x4(%esp)
  10298e:	00 
  10298f:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102996:	e8 45 16 00 00       	call   103fe0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  10299b:	69 05 40 b8 10 00 bc 	imul   $0xbc,0x10b840,%eax
  1029a2:	00 00 00 
  1029a5:	05 60 b2 10 00       	add    $0x10b260,%eax
  1029aa:	3d 60 b2 10 00       	cmp    $0x10b260,%eax
  1029af:	76 72                	jbe    102a23 <main+0x163>
  1029b1:	bb 60 b2 10 00       	mov    $0x10b260,%ebx
  1029b6:	66 90                	xchg   %ax,%ax
    if(c == cpus+cpunum())  // We've started already.
  1029b8:	e8 33 fe ff ff       	call   1027f0 <cpunum>
  1029bd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  1029c3:	05 60 b2 10 00       	add    $0x10b260,%eax
  1029c8:	39 c3                	cmp    %eax,%ebx
  1029ca:	74 3e                	je     102a0a <main+0x14a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  1029cc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1029d3:	e8 e8 f8 ff ff       	call   1022c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  1029d8:	c7 05 f8 6f 00 00 40 	movl   $0x102840,0x6ff8
  1029df:	28 10 00 
    if(c == cpus+cpunum())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  1029e2:	05 00 10 00 00       	add    $0x1000,%eax
  1029e7:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapicstartap(c->id, (uint)code);
  1029ec:	0f b6 03             	movzbl (%ebx),%eax
  1029ef:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  1029f6:	00 
  1029f7:	89 04 24             	mov    %eax,(%esp)
  1029fa:	e8 41 fd ff ff       	call   102740 <lapicstartap>
  1029ff:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102a00:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
  102a06:	85 c0                	test   %eax,%eax
  102a08:	74 f6                	je     102a00 <main+0x140>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102a0a:	69 05 40 b8 10 00 bc 	imul   $0xbc,0x10b840,%eax
  102a11:	00 00 00 
  102a14:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
  102a1a:	05 60 b2 10 00       	add    $0x10b260,%eax
  102a1f:	39 c3                	cmp    %eax,%ebx
  102a21:	72 95                	jb     1029b8 <main+0xf8>
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102a23:	e8 18 fe ff ff       	call   102840 <mpmain>
  binit();         // buffer cache
  fileinit();      // file table
  iinit();         // inode cache
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  102a28:	e8 e3 25 00 00       	call   105010 <timerinit>
  102a2d:	8d 76 00             	lea    0x0(%esi),%esi
  102a30:	e9 45 ff ff ff       	jmp    10297a <main+0xba>
  102a35:	90                   	nop    
  102a36:	90                   	nop    
  102a37:	90                   	nop    
  102a38:	90                   	nop    
  102a39:	90                   	nop    
  102a3a:	90                   	nop    
  102a3b:	90                   	nop    
  102a3c:	90                   	nop    
  102a3d:	90                   	nop    
  102a3e:	90                   	nop    
  102a3f:	90                   	nop    

00102a40 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
  102a40:	a1 04 80 10 00       	mov    0x108004,%eax
  102a45:	55                   	push   %ebp
  102a46:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102a48:	5d                   	pop    %ebp
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
  102a49:	2d 60 b2 10 00       	sub    $0x10b260,%eax
  102a4e:	c1 f8 02             	sar    $0x2,%eax
  102a51:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
  return bcpu-cpus;
}
  102a57:	c3                   	ret    
  102a58:	90                   	nop    
  102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102a60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uchar *addr, int len)
{
  102a60:	55                   	push   %ebp
  102a61:	89 e5                	mov    %esp,%ebp
  102a63:	56                   	push   %esi
  102a64:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102a65:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uchar *addr, int len)
{
  102a68:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102a6b:	39 f0                	cmp    %esi,%eax
  102a6d:	73 42                	jae    102ab1 <mpsearch1+0x51>
  102a6f:	89 c3                	mov    %eax,%ebx
  102a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102a78:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102a7f:	00 
  102a80:	c7 44 24 04 45 64 10 	movl   $0x106445,0x4(%esp)
  102a87:	00 
  102a88:	89 1c 24             	mov    %ebx,(%esp)
  102a8b:	e8 f0 14 00 00       	call   103f80 <memcmp>
  102a90:	85 c0                	test   %eax,%eax
  102a92:	75 16                	jne    102aaa <mpsearch1+0x4a>
  102a94:	31 d2                	xor    %edx,%edx
  102a96:	31 c9                	xor    %ecx,%ecx
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102a98:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102a9c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
  102a9f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102aa1:	83 fa 10             	cmp    $0x10,%edx
  102aa4:	75 f2                	jne    102a98 <mpsearch1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102aa6:	84 c9                	test   %cl,%cl
  102aa8:	74 10                	je     102aba <mpsearch1+0x5a>
mpsearch1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102aaa:	83 c3 10             	add    $0x10,%ebx
  102aad:	39 de                	cmp    %ebx,%esi
  102aaf:	77 c7                	ja     102a78 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102ab1:	83 c4 10             	add    $0x10,%esp
mpsearch1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102ab4:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102ab6:	5b                   	pop    %ebx
  102ab7:	5e                   	pop    %esi
  102ab8:	5d                   	pop    %ebp
  102ab9:	c3                   	ret    
  102aba:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102abd:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102abf:	5b                   	pop    %ebx
  102ac0:	5e                   	pop    %esi
  102ac1:	5d                   	pop    %ebp
  102ac2:	c3                   	ret    
  102ac3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102ad0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
  102ad0:	55                   	push   %ebp
  102ad1:	89 e5                	mov    %esp,%ebp
  102ad3:	57                   	push   %edi
  102ad4:	56                   	push   %esi
  102ad5:	53                   	push   %ebx
  102ad6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102ad9:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  102ae0:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  102ae7:	c7 05 04 80 10 00 60 	movl   $0x10b260,0x108004
  102aee:	b2 10 00 
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102af1:	c1 e1 08             	shl    $0x8,%ecx
  102af4:	09 c1                	or     %eax,%ecx
  102af6:	c1 e1 04             	shl    $0x4,%ecx
  102af9:	85 c9                	test   %ecx,%ecx
  102afb:	74 53                	je     102b50 <mpinit+0x80>
    if((mp = mpsearch1((uchar*)p, 1024)))
  102afd:	ba 00 04 00 00       	mov    $0x400,%edx
  102b02:	89 c8                	mov    %ecx,%eax
  102b04:	e8 57 ff ff ff       	call   102a60 <mpsearch1>
  102b09:	85 c0                	test   %eax,%eax
  102b0b:	89 c7                	mov    %eax,%edi
  102b0d:	74 6c                	je     102b7b <mpinit+0xab>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102b0f:	8b 5f 04             	mov    0x4(%edi),%ebx
  102b12:	85 db                	test   %ebx,%ebx
  102b14:	74 32                	je     102b48 <mpinit+0x78>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102b16:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102b1d:	00 
  102b1e:	c7 44 24 04 4a 64 10 	movl   $0x10644a,0x4(%esp)
  102b25:	00 
  102b26:	89 1c 24             	mov    %ebx,(%esp)
  102b29:	e8 52 14 00 00       	call   103f80 <memcmp>
  102b2e:	85 c0                	test   %eax,%eax
  102b30:	75 16                	jne    102b48 <mpinit+0x78>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102b32:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102b36:	3c 01                	cmp    $0x1,%al
  102b38:	74 66                	je     102ba0 <mpinit+0xd0>
  102b3a:	3c 04                	cmp    $0x4,%al
  102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102b40:	74 5e                	je     102ba0 <mpinit+0xd0>
  102b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102b48:	83 c4 1c             	add    $0x1c,%esp
  102b4b:	5b                   	pop    %ebx
  102b4c:	5e                   	pop    %esi
  102b4d:	5f                   	pop    %edi
  102b4e:	5d                   	pop    %ebp
  102b4f:	c3                   	ret    
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mpsearch1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1((uchar*)p-1024, 1024)))
  102b50:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102b57:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102b5e:	c1 e0 08             	shl    $0x8,%eax
  102b61:	09 d0                	or     %edx,%eax
  102b63:	ba 00 04 00 00       	mov    $0x400,%edx
  102b68:	c1 e0 0a             	shl    $0xa,%eax
  102b6b:	2d 00 04 00 00       	sub    $0x400,%eax
  102b70:	e8 eb fe ff ff       	call   102a60 <mpsearch1>
  102b75:	85 c0                	test   %eax,%eax
  102b77:	89 c7                	mov    %eax,%edi
  102b79:	75 94                	jne    102b0f <mpinit+0x3f>
      return mp;
  }
  return mpsearch1((uchar*)0xF0000, 0x10000);
  102b7b:	ba 00 00 01 00       	mov    $0x10000,%edx
  102b80:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102b85:	e8 d6 fe ff ff       	call   102a60 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102b8a:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mpsearch1((uchar*)0xF0000, 0x10000);
  102b8c:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102b8e:	0f 85 7b ff ff ff    	jne    102b0f <mpinit+0x3f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102b94:	83 c4 1c             	add    $0x1c,%esp
  102b97:	5b                   	pop    %ebx
  102b98:	5e                   	pop    %esi
  102b99:	5f                   	pop    %edi
  102b9a:	5d                   	pop    %ebp
  102b9b:	c3                   	ret    
  102b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102ba0:	0f b7 73 04          	movzwl 0x4(%ebx),%esi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ba4:	85 f6                	test   %esi,%esi
  102ba6:	74 15                	je     102bbd <mpinit+0xed>
  102ba8:	31 d2                	xor    %edx,%edx
  102baa:	31 c9                	xor    %ecx,%ecx
    sum += addr[i];
  102bac:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bb0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
  102bb3:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bb5:	39 d6                	cmp    %edx,%esi
  102bb7:	7f f3                	jg     102bac <mpinit+0xdc>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102bb9:	84 c9                	test   %cl,%cl
  102bbb:	75 8b                	jne    102b48 <mpinit+0x78>
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  102bbd:	c7 05 44 b2 10 00 01 	movl   $0x1,0x10b244
  102bc4:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102bc7:	8b 43 24             	mov    0x24(%ebx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102bca:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102bcd:	a3 38 b2 10 00       	mov    %eax,0x10b238
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102bd2:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  102bd6:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  102bd9:	39 c2                	cmp    %eax,%edx
  102bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bde:	73 5f                	jae    102c3f <mpinit+0x16f>
  102be0:	8b 35 04 80 10 00    	mov    0x108004,%esi
    switch(*p){
  102be6:	0f b6 02             	movzbl (%edx),%eax
  102be9:	3c 04                	cmp    $0x4,%al
  102beb:	76 2b                	jbe    102c18 <mpinit+0x148>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102bed:	0f b6 c0             	movzbl %al,%eax
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102bf0:	89 35 04 80 10 00    	mov    %esi,0x108004
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bfa:	c7 04 24 74 64 10 00 	movl   $0x106474,(%esp)
  102c01:	e8 9a d8 ff ff       	call   1004a0 <cprintf>
      panic("mpinit");
  102c06:	c7 04 24 6a 64 10 00 	movl   $0x10646a,(%esp)
  102c0d:	e8 6e dc ff ff       	call   100880 <panic>
  102c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102c18:	0f b6 c0             	movzbl %al,%eax
  102c1b:	ff 24 85 94 64 10 00 	jmp    *0x106494(,%eax,4)
  102c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
  102c28:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  102c2c:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
  102c2f:	a2 40 b2 10 00       	mov    %al,0x10b240
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c34:	39 55 f0             	cmp    %edx,-0x10(%ebp)
  102c37:	77 ad                	ja     102be6 <mpinit+0x116>
  102c39:	89 35 04 80 10 00    	mov    %esi,0x108004
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      panic("mpinit");
    }
  }
  if(mp->imcrp){
  102c3f:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
  102c43:	0f 84 ff fe ff ff    	je     102b48 <mpinit+0x78>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102c49:	ba 22 00 00 00       	mov    $0x22,%edx
  102c4e:	b8 70 00 00 00       	mov    $0x70,%eax
  102c53:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102c54:	b2 23                	mov    $0x23,%dl
  102c56:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102c57:	83 c8 01             	or     $0x1,%eax
  102c5a:	ee                   	out    %al,(%dx)
  102c5b:	e9 e8 fe ff ff       	jmp    102b48 <mpinit+0x78>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102c60:	83 c2 08             	add    $0x8,%edx
  102c63:	eb cf                	jmp    102c34 <mpinit+0x164>
  102c65:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102c68:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  102c6c:	a1 40 b8 10 00       	mov    0x10b840,%eax
  102c71:	0f b6 cb             	movzbl %bl,%ecx
  102c74:	39 c1                	cmp    %eax,%ecx
  102c76:	75 2b                	jne    102ca3 <mpinit+0x1d3>
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
  102c78:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102c7c:	74 0c                	je     102c8a <mpinit+0x1ba>
        bcpu = &cpus[ncpu];
  102c7e:	69 c1 bc 00 00 00    	imul   $0xbc,%ecx,%eax
  102c84:	8d b0 60 b2 10 00    	lea    0x10b260(%eax),%esi
      cpus[ncpu].id = ncpu;
  102c8a:	69 c1 bc 00 00 00    	imul   $0xbc,%ecx,%eax
      ncpu++;
      p += sizeof(struct mpproc);
  102c90:	83 c2 14             	add    $0x14,%edx
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      cpus[ncpu].id = ncpu;
  102c93:	88 98 60 b2 10 00    	mov    %bl,0x10b260(%eax)
      ncpu++;
  102c99:	8d 41 01             	lea    0x1(%ecx),%eax
  102c9c:	a3 40 b8 10 00       	mov    %eax,0x10b840
  102ca1:	eb 91                	jmp    102c34 <mpinit+0x164>
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102ca3:	89 35 04 80 10 00    	mov    %esi,0x108004
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
  102ca9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  102cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cb1:	c7 04 24 4f 64 10 00 	movl   $0x10644f,(%esp)
  102cb8:	e8 e3 d7 ff ff       	call   1004a0 <cprintf>
        panic("mpinit");
  102cbd:	c7 04 24 6a 64 10 00 	movl   $0x10646a,(%esp)
  102cc4:	e8 b7 db ff ff       	call   100880 <panic>
  102cc9:	90                   	nop    
  102cca:	90                   	nop    
  102ccb:	90                   	nop    
  102ccc:	90                   	nop    
  102ccd:	90                   	nop    
  102cce:	90                   	nop    
  102ccf:	90                   	nop    

00102cd0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
  102cd0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
  102cd1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
  102cd6:	89 e5                	mov    %esp,%ebp
  102cd8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
  102cdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102ce0:	d3 c0                	rol    %cl,%eax
  102ce2:	66 23 05 c0 7a 10 00 	and    0x107ac0,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
  102ce9:	66 a3 c0 7a 10 00    	mov    %ax,0x107ac0
  102cef:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
  102cf0:	66 c1 e8 08          	shr    $0x8,%ax
  102cf4:	b2 a1                	mov    $0xa1,%dl
  102cf6:	ee                   	out    %al,(%dx)
  102cf7:	5d                   	pop    %ebp
  102cf8:	c3                   	ret    
  102cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102d00 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
  102d00:	55                   	push   %ebp
  102d01:	b9 21 00 00 00       	mov    $0x21,%ecx
  102d06:	89 e5                	mov    %esp,%ebp
  102d08:	83 ec 0c             	sub    $0xc,%esp
  102d0b:	89 1c 24             	mov    %ebx,(%esp)
  102d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102d13:	89 ca                	mov    %ecx,%edx
  102d15:	89 74 24 04          	mov    %esi,0x4(%esp)
  102d19:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102d1d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102d1e:	bb a1 00 00 00       	mov    $0xa1,%ebx
  102d23:	89 da                	mov    %ebx,%edx
  102d25:	ee                   	out    %al,(%dx)
  102d26:	be 20 00 00 00       	mov    $0x20,%esi
  102d2b:	b8 11 00 00 00       	mov    $0x11,%eax
  102d30:	89 f2                	mov    %esi,%edx
  102d32:	ee                   	out    %al,(%dx)
  102d33:	b8 20 00 00 00       	mov    $0x20,%eax
  102d38:	89 ca                	mov    %ecx,%edx
  102d3a:	ee                   	out    %al,(%dx)
  102d3b:	b8 04 00 00 00       	mov    $0x4,%eax
  102d40:	ee                   	out    %al,(%dx)
  102d41:	bf 03 00 00 00       	mov    $0x3,%edi
  102d46:	89 f8                	mov    %edi,%eax
  102d48:	ee                   	out    %al,(%dx)
  102d49:	b1 a0                	mov    $0xa0,%cl
  102d4b:	b8 11 00 00 00       	mov    $0x11,%eax
  102d50:	89 ca                	mov    %ecx,%edx
  102d52:	ee                   	out    %al,(%dx)
  102d53:	b8 28 00 00 00       	mov    $0x28,%eax
  102d58:	89 da                	mov    %ebx,%edx
  102d5a:	ee                   	out    %al,(%dx)
  102d5b:	b8 02 00 00 00       	mov    $0x2,%eax
  102d60:	ee                   	out    %al,(%dx)
  102d61:	89 f8                	mov    %edi,%eax
  102d63:	ee                   	out    %al,(%dx)
  102d64:	bb 68 00 00 00       	mov    $0x68,%ebx
  102d69:	89 f2                	mov    %esi,%edx
  102d6b:	89 d8                	mov    %ebx,%eax
  102d6d:	ee                   	out    %al,(%dx)
  102d6e:	bf 0a 00 00 00       	mov    $0xa,%edi
  102d73:	89 f8                	mov    %edi,%eax
  102d75:	ee                   	out    %al,(%dx)
  102d76:	89 d8                	mov    %ebx,%eax
  102d78:	89 ca                	mov    %ecx,%edx
  102d7a:	ee                   	out    %al,(%dx)
  102d7b:	89 f8                	mov    %edi,%eax
  102d7d:	ee                   	out    %al,(%dx)
  102d7e:	0f b7 05 c0 7a 10 00 	movzwl 0x107ac0,%eax
  102d85:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102d89:	74 0a                	je     102d95 <picinit+0x95>
  102d8b:	b2 21                	mov    $0x21,%dl
  102d8d:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
  102d8e:	66 c1 e8 08          	shr    $0x8,%ax
  102d92:	b2 a1                	mov    $0xa1,%dl
  102d94:	ee                   	out    %al,(%dx)
  102d95:	8b 1c 24             	mov    (%esp),%ebx
  102d98:	8b 74 24 04          	mov    0x4(%esp),%esi
  102d9c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102da0:	89 ec                	mov    %ebp,%esp
  102da2:	5d                   	pop    %ebp
  102da3:	c3                   	ret    
  102da4:	90                   	nop    
  102da5:	90                   	nop    
  102da6:	90                   	nop    
  102da7:	90                   	nop    
  102da8:	90                   	nop    
  102da9:	90                   	nop    
  102daa:	90                   	nop    
  102dab:	90                   	nop    
  102dac:	90                   	nop    
  102dad:	90                   	nop    
  102dae:	90                   	nop    
  102daf:	90                   	nop    

00102db0 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102db0:	55                   	push   %ebp
  102db1:	89 e5                	mov    %esp,%ebp
  102db3:	57                   	push   %edi
  102db4:	56                   	push   %esi
  102db5:	53                   	push   %ebx
  102db6:	83 ec 0c             	sub    $0xc,%esp
  102db9:	8b 75 08             	mov    0x8(%ebp),%esi
  102dbc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
  102dbf:	89 34 24             	mov    %esi,(%esp)
  102dc2:	e8 e9 10 00 00       	call   103eb0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102dc7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
  102dcd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
  102dd3:	75 58                	jne    102e2d <piperead+0x7d>
  102dd5:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
  102ddb:	85 d2                	test   %edx,%edx
  102ddd:	74 4e                	je     102e2d <piperead+0x7d>
    if(proc->killed){
  102ddf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102de5:	8b 58 24             	mov    0x24(%eax),%ebx
  102de8:	85 db                	test   %ebx,%ebx
  102dea:	0f 85 a0 00 00 00    	jne    102e90 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  102df0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
  102df6:	eb 1b                	jmp    102e13 <piperead+0x63>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102df8:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
  102dfe:	85 d2                	test   %edx,%edx
  102e00:	74 2b                	je     102e2d <piperead+0x7d>
    if(proc->killed){
  102e02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102e08:	8b 48 24             	mov    0x24(%eax),%ecx
  102e0b:	85 c9                	test   %ecx,%ecx
  102e0d:	0f 85 7d 00 00 00    	jne    102e90 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  102e13:	89 74 24 04          	mov    %esi,0x4(%esp)
  102e17:	89 1c 24             	mov    %ebx,(%esp)
  102e1a:	e8 01 06 00 00       	call   103420 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102e1f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
  102e25:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
  102e2b:	74 cb                	je     102df8 <piperead+0x48>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102e2d:	85 ff                	test   %edi,%edi
  102e2f:	7e 76                	jle    102ea7 <piperead+0xf7>
    if(p->nread == p->nwrite)
  102e31:	31 db                	xor    %ebx,%ebx
  102e33:	89 c2                	mov    %eax,%edx
  102e35:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
  102e3b:	75 0b                	jne    102e48 <piperead+0x98>
  102e3d:	eb 68                	jmp    102ea7 <piperead+0xf7>
  102e3f:	90                   	nop    
  102e40:	39 96 38 02 00 00    	cmp    %edx,0x238(%esi)
  102e46:	74 22                	je     102e6a <piperead+0xba>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  102e48:	89 d0                	mov    %edx,%eax
  102e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102e4d:	83 c2 01             	add    $0x1,%edx
  102e50:	25 ff 01 00 00       	and    $0x1ff,%eax
  102e55:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
  102e5a:	88 04 19             	mov    %al,(%ecx,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102e5d:	83 c3 01             	add    $0x1,%ebx
  102e60:	39 df                	cmp    %ebx,%edi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  102e62:	89 96 34 02 00 00    	mov    %edx,0x234(%esi)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102e68:	7f d6                	jg     102e40 <piperead+0x90>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  102e6a:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
  102e70:	89 04 24             	mov    %eax,(%esp)
  102e73:	e8 58 03 00 00       	call   1031d0 <wakeup>
  release(&p->lock);
  102e78:	89 34 24             	mov    %esi,(%esp)
  102e7b:	e8 e0 0f 00 00       	call   103e60 <release>
  return i;
}
  102e80:	83 c4 0c             	add    $0xc,%esp
  102e83:	89 d8                	mov    %ebx,%eax
  102e85:	5b                   	pop    %ebx
  102e86:	5e                   	pop    %esi
  102e87:	5f                   	pop    %edi
  102e88:	5d                   	pop    %ebp
  102e89:	c3                   	ret    
  102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
  102e90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  102e95:	89 34 24             	mov    %esi,(%esp)
  102e98:	e8 c3 0f 00 00       	call   103e60 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
  102e9d:	83 c4 0c             	add    $0xc,%esp
  102ea0:	89 d8                	mov    %ebx,%eax
  102ea2:	5b                   	pop    %ebx
  102ea3:	5e                   	pop    %esi
  102ea4:	5f                   	pop    %edi
  102ea5:	5d                   	pop    %ebp
  102ea6:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102ea7:	31 db                	xor    %ebx,%ebx
  102ea9:	eb bf                	jmp    102e6a <piperead+0xba>
  102eab:	90                   	nop    
  102eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102eb0 <pipewrite>:
    release(&p->lock);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102eb0:	55                   	push   %ebp
  102eb1:	89 e5                	mov    %esp,%ebp
  102eb3:	57                   	push   %edi
  102eb4:	56                   	push   %esi
  102eb5:	53                   	push   %ebx
  102eb6:	83 ec 1c             	sub    $0x1c,%esp
  102eb9:	8b 75 08             	mov    0x8(%ebp),%esi
  int i;

  acquire(&p->lock);
  102ebc:	89 34 24             	mov    %esi,(%esp)
  102ebf:	8d be 34 02 00 00    	lea    0x234(%esi),%edi
  102ec5:	e8 e6 0f 00 00       	call   103eb0 <acquire>
  for(i = 0; i < n; i++){
  102eca:	8b 45 10             	mov    0x10(%ebp),%eax
  102ecd:	85 c0                	test   %eax,%eax
  102ecf:	0f 8e c7 00 00 00    	jle    102f9c <pipewrite+0xec>
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102ed5:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
  102edb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
  102ede:	8d be 34 02 00 00    	lea    0x234(%esi),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102ee4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102eeb:	8b 9e 34 02 00 00    	mov    0x234(%esi),%ebx
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
  102ef1:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
  102ef7:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  102efd:	39 c1                	cmp    %eax,%ecx
  102eff:	74 41                	je     102f42 <pipewrite+0x92>
  102f01:	eb 65                	jmp    102f68 <pipewrite+0xb8>
  102f03:	90                   	nop    
  102f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || proc->killed){
  102f08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102f0e:	8b 58 24             	mov    0x24(%eax),%ebx
  102f11:	85 db                	test   %ebx,%ebx
  102f13:	75 37                	jne    102f4c <pipewrite+0x9c>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
  102f15:	89 3c 24             	mov    %edi,(%esp)
  102f18:	e8 b3 02 00 00       	call   1031d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102f1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f20:	89 74 24 04          	mov    %esi,0x4(%esp)
  102f24:	89 14 24             	mov    %edx,(%esp)
  102f27:	e8 f4 04 00 00       	call   103420 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
  102f2c:	8b 9e 34 02 00 00    	mov    0x234(%esi),%ebx
  102f32:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
  102f38:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  102f3e:	39 c1                	cmp    %eax,%ecx
  102f40:	75 26                	jne    102f68 <pipewrite+0xb8>
      if(p->readopen == 0 || proc->killed){
  102f42:	8b 8e 3c 02 00 00    	mov    0x23c(%esi),%ecx
  102f48:	85 c9                	test   %ecx,%ecx
  102f4a:	75 bc                	jne    102f08 <pipewrite+0x58>
        release(&p->lock);
  102f4c:	89 34 24             	mov    %esi,(%esp)
  102f4f:	e8 0c 0f 00 00       	call   103e60 <release>
  102f54:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
  102f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  102f5e:	83 c4 1c             	add    $0x1c,%esp
  102f61:	5b                   	pop    %ebx
  102f62:	5e                   	pop    %esi
  102f63:	5f                   	pop    %edi
  102f64:	5d                   	pop    %ebp
  102f65:	c3                   	ret    
  102f66:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  102f68:	89 c8                	mov    %ecx,%eax
  102f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f6d:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f72:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f78:	0f b6 14 10          	movzbl (%eax,%edx,1),%edx
  102f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f7f:	88 54 06 34          	mov    %dl,0x34(%esi,%eax,1)
  102f83:	8d 41 01             	lea    0x1(%ecx),%eax
  102f86:	89 86 38 02 00 00    	mov    %eax,0x238(%esi)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102f8c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102f90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f93:	39 55 10             	cmp    %edx,0x10(%ebp)
  102f96:	0f 8f 55 ff ff ff    	jg     102ef1 <pipewrite+0x41>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  102f9c:	89 3c 24             	mov    %edi,(%esp)
  102f9f:	e8 2c 02 00 00       	call   1031d0 <wakeup>
  release(&p->lock);
  102fa4:	89 34 24             	mov    %esi,(%esp)
  102fa7:	e8 b4 0e 00 00       	call   103e60 <release>
  102fac:	eb ad                	jmp    102f5b <pipewrite+0xab>
  102fae:	66 90                	xchg   %ax,%ax

00102fb0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  102fb0:	55                   	push   %ebp
  102fb1:	89 e5                	mov    %esp,%ebp
  102fb3:	83 ec 18             	sub    $0x18,%esp
  102fb6:	89 75 fc             	mov    %esi,-0x4(%ebp)
  102fb9:	8b 75 08             	mov    0x8(%ebp),%esi
  102fbc:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  102fbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  acquire(&p->lock);
  102fc2:	89 34 24             	mov    %esi,(%esp)
  102fc5:	e8 e6 0e 00 00       	call   103eb0 <acquire>
  if(writable){
  102fca:	85 db                	test   %ebx,%ebx
  102fcc:	74 42                	je     103010 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
  102fce:	8d 86 34 02 00 00    	lea    0x234(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  102fd4:	c7 86 40 02 00 00 00 	movl   $0x0,0x240(%esi)
  102fdb:	00 00 00 
    wakeup(&p->nread);
  102fde:	89 04 24             	mov    %eax,(%esp)
  102fe1:	e8 ea 01 00 00       	call   1031d0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
  102fe6:	8b 86 3c 02 00 00    	mov    0x23c(%esi),%eax
  102fec:	85 c0                	test   %eax,%eax
  102fee:	75 0a                	jne    102ffa <pipeclose+0x4a>
  102ff0:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
  102ff6:	85 c0                	test   %eax,%eax
  102ff8:	74 36                	je     103030 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p, PAGE);
  } else
    release(&p->lock);
  102ffa:	89 75 08             	mov    %esi,0x8(%ebp)
}
  102ffd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  103000:	8b 75 fc             	mov    -0x4(%ebp),%esi
  103003:	89 ec                	mov    %ebp,%esp
  103005:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  } else
    release(&p->lock);
  103006:	e9 55 0e 00 00       	jmp    103e60 <release>
  10300b:	90                   	nop    
  10300c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  103010:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
  103016:	c7 86 3c 02 00 00 00 	movl   $0x0,0x23c(%esi)
  10301d:	00 00 00 
    wakeup(&p->nwrite);
  103020:	89 04 24             	mov    %eax,(%esp)
  103023:	e8 a8 01 00 00       	call   1031d0 <wakeup>
  103028:	eb bc                	jmp    102fe6 <pipeclose+0x36>
  10302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
  103030:	89 34 24             	mov    %esi,(%esp)
  103033:	e8 28 0e 00 00       	call   103e60 <release>
    kfree((char*)p, PAGE);
  } else
    release(&p->lock);
}
  103038:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  10303b:	89 75 08             	mov    %esi,0x8(%ebp)
  } else
    release(&p->lock);
}
  10303e:	8b 75 fc             	mov    -0x4(%ebp),%esi
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  103041:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
  } else
    release(&p->lock);
}
  103048:	89 ec                	mov    %ebp,%esp
  10304a:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  10304b:	e9 20 f3 ff ff       	jmp    102370 <kfree>

00103050 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103050:	55                   	push   %ebp
  103051:	89 e5                	mov    %esp,%ebp
  103053:	83 ec 18             	sub    $0x18,%esp
  103056:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103059:	8b 75 08             	mov    0x8(%ebp),%esi
  10305c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10305f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103062:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  103065:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10306b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  103071:	e8 5a de ff ff       	call   100ed0 <filealloc>
  103076:	85 c0                	test   %eax,%eax
  103078:	89 06                	mov    %eax,(%esi)
  10307a:	0f 84 ae 00 00 00    	je     10312e <pipealloc+0xde>
  103080:	e8 4b de ff ff       	call   100ed0 <filealloc>
  103085:	85 c0                	test   %eax,%eax
  103087:	89 07                	mov    %eax,(%edi)
  103089:	0f 84 91 00 00 00    	je     103120 <pipealloc+0xd0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  10308f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103096:	e8 25 f2 ff ff       	call   1022c0 <kalloc>
  10309b:	85 c0                	test   %eax,%eax
  10309d:	89 c3                	mov    %eax,%ebx
  10309f:	74 7f                	je     103120 <pipealloc+0xd0>
    goto bad;
  p->readopen = 1;
  1030a1:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
  1030a8:	00 00 00 
  p->writeopen = 1;
  1030ab:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
  1030b2:	00 00 00 
  p->nwrite = 0;
  1030b5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
  1030bc:	00 00 00 
  p->nread = 0;
  1030bf:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
  1030c6:	00 00 00 
  initlock(&p->lock, "pipe");
  1030c9:	89 04 24             	mov    %eax,(%esp)
  1030cc:	c7 44 24 04 a8 64 10 	movl   $0x1064a8,0x4(%esp)
  1030d3:	00 
  1030d4:	e8 47 0c 00 00       	call   103d20 <initlock>
  (*f0)->type = FD_PIPE;
  1030d9:	8b 06                	mov    (%esi),%eax
  1030db:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
  1030e1:	8b 06                	mov    (%esi),%eax
  1030e3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  1030e7:	8b 06                	mov    (%esi),%eax
  1030e9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1030ed:	8b 06                	mov    (%esi),%eax
  1030ef:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1030f2:	8b 07                	mov    (%edi),%eax
  1030f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
  1030fa:	8b 07                	mov    (%edi),%eax
  1030fc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  103100:	8b 07                	mov    (%edi),%eax
  103102:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  103106:	8b 07                	mov    (%edi),%eax
  103108:	89 58 0c             	mov    %ebx,0xc(%eax)
  10310b:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
  10310d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103110:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103113:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103116:	89 ec                	mov    %ebp,%esp
  103118:	5d                   	pop    %ebp
  103119:	c3                   	ret    
  10311a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0)
  103120:	8b 06                	mov    (%esi),%eax
  103122:	85 c0                	test   %eax,%eax
  103124:	74 08                	je     10312e <pipealloc+0xde>
    fileclose(*f0);
  103126:	89 04 24             	mov    %eax,(%esp)
  103129:	e8 12 de ff ff       	call   100f40 <fileclose>
  if(*f1)
  10312e:	8b 17                	mov    (%edi),%edx
  103130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103135:	85 d2                	test   %edx,%edx
  103137:	74 d4                	je     10310d <pipealloc+0xbd>
    fileclose(*f1);
  103139:	89 14 24             	mov    %edx,(%esp)
  10313c:	e8 ff dd ff ff       	call   100f40 <fileclose>
  103141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103146:	eb c5                	jmp    10310d <pipealloc+0xbd>
  103148:	90                   	nop    
  103149:	90                   	nop    
  10314a:	90                   	nop    
  10314b:	90                   	nop    
  10314c:	90                   	nop    
  10314d:	90                   	nop    
  10314e:	90                   	nop    
  10314f:	90                   	nop    

00103150 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103150:	55                   	push   %ebp
  103151:	89 e5                	mov    %esp,%ebp
  103153:	53                   	push   %ebx
  103154:	83 ec 04             	sub    $0x4,%esp
  103157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
  10315a:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103161:	e8 4a 0d 00 00       	call   103eb0 <acquire>
  103166:	ba 94 b8 10 00       	mov    $0x10b894,%edx
  10316b:	eb 0e                	jmp    10317b <kill+0x2b>
  10316d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103170:	83 c2 7c             	add    $0x7c,%edx
  103173:	81 fa 94 d7 10 00    	cmp    $0x10d794,%edx
  103179:	74 3d                	je     1031b8 <kill+0x68>
    if(p->pid == pid){
  10317b:	8b 42 10             	mov    0x10(%edx),%eax
  10317e:	39 d8                	cmp    %ebx,%eax
  103180:	75 ee                	jne    103170 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103182:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103186:	c7 42 24 01 00 00 00 	movl   $0x1,0x24(%edx)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10318d:	74 19                	je     1031a8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
  10318f:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103196:	e8 c5 0c 00 00       	call   103e60 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
  10319b:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
  10319e:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
  1031a0:	5b                   	pop    %ebx
  1031a1:	5d                   	pop    %ebp
  1031a2:	c3                   	ret    
  1031a3:	90                   	nop    
  1031a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1031a8:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  1031af:	eb de                	jmp    10318f <kill+0x3f>
  1031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  1031b8:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  1031bf:	e8 9c 0c 00 00       	call   103e60 <release>
  return -1;
}
  1031c4:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  1031c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1031cc:	5b                   	pop    %ebx
  1031cd:	5d                   	pop    %ebp
  1031ce:	c3                   	ret    
  1031cf:	90                   	nop    

001031d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1031d0:	55                   	push   %ebp
  1031d1:	89 e5                	mov    %esp,%ebp
  1031d3:	53                   	push   %ebx
  1031d4:	83 ec 04             	sub    $0x4,%esp
  1031d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
  1031da:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  1031e1:	e8 ca 0c 00 00       	call   103eb0 <acquire>
  1031e6:	b8 94 b8 10 00       	mov    $0x10b894,%eax
  1031eb:	eb 0d                	jmp    1031fa <wakeup+0x2a>
  1031ed:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1031f0:	83 c0 7c             	add    $0x7c,%eax
  1031f3:	3d 94 d7 10 00       	cmp    $0x10d794,%eax
  1031f8:	74 1e                	je     103218 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
  1031fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1031fe:	75 f0                	jne    1031f0 <wakeup+0x20>
  103200:	3b 58 20             	cmp    0x20(%eax),%ebx
  103203:	75 eb                	jne    1031f0 <wakeup+0x20>
      p->state = RUNNABLE;
  103205:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  10320c:	83 c0 7c             	add    $0x7c,%eax
  10320f:	3d 94 d7 10 00       	cmp    $0x10d794,%eax
  103214:	75 e4                	jne    1031fa <wakeup+0x2a>
  103216:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  103218:	c7 45 08 60 b8 10 00 	movl   $0x10b860,0x8(%ebp)
}
  10321f:	83 c4 04             	add    $0x4,%esp
  103222:	5b                   	pop    %ebx
  103223:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  103224:	e9 37 0c 00 00       	jmp    103e60 <release>
  103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103230 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103230:	55                   	push   %ebp
  103231:	89 e5                	mov    %esp,%ebp
  103233:	83 ec 08             	sub    $0x8,%esp
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
  103236:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10323d:	e8 1e 0c 00 00       	call   103e60 <release>
  
  // Return to "caller", actually trapret (see allocproc).
}
  103242:	c9                   	leave  
  103243:	c3                   	ret    
  103244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10324a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103250 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  103250:	55                   	push   %ebp
  103251:	89 e5                	mov    %esp,%ebp
  103253:	53                   	push   %ebx
  103254:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
  103257:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10325e:	e8 3d 0b 00 00       	call   103da0 <holding>
  103263:	85 c0                	test   %eax,%eax
  103265:	74 4e                	je     1032b5 <sched+0x65>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
  103267:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  10326e:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
  103275:	75 4a                	jne    1032c1 <sched+0x71>
    panic("sched locks");
  if(proc->state == RUNNING)
  103277:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  10327e:	83 79 0c 04          	cmpl   $0x4,0xc(%ecx)
  103282:	74 49                	je     1032cd <sched+0x7d>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103284:	9c                   	pushf  
  103285:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
  103286:	f6 c4 02             	test   $0x2,%ah
  103289:	75 4e                	jne    1032d9 <sched+0x89>
    panic("sched interruptible");

  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  10328b:	8b 42 04             	mov    0x4(%edx),%eax
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");

  intena = cpu->intena;
  10328e:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
  103294:	89 44 24 04          	mov    %eax,0x4(%esp)
  103298:	8d 41 1c             	lea    0x1c(%ecx),%eax
  10329b:	89 04 24             	mov    %eax,(%esp)
  10329e:	e8 a9 0e 00 00       	call   10414c <swtch>
  cpu->intena = intena;
  1032a3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1032a9:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  1032af:	83 c4 14             	add    $0x14,%esp
  1032b2:	5b                   	pop    %ebx
  1032b3:	5d                   	pop    %ebp
  1032b4:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  1032b5:	c7 04 24 ad 64 10 00 	movl   $0x1064ad,(%esp)
  1032bc:	e8 bf d5 ff ff       	call   100880 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  1032c1:	c7 04 24 bf 64 10 00 	movl   $0x1064bf,(%esp)
  1032c8:	e8 b3 d5 ff ff       	call   100880 <panic>
  if(proc->state == RUNNING)
    panic("sched running");
  1032cd:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1032d4:	e8 a7 d5 ff ff       	call   100880 <panic>
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  1032d9:	c7 04 24 d9 64 10 00 	movl   $0x1064d9,(%esp)
  1032e0:	e8 9b d5 ff ff       	call   100880 <panic>
  1032e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001032f0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  1032f0:	55                   	push   %ebp
  1032f1:	89 e5                	mov    %esp,%ebp
  1032f3:	56                   	push   %esi
  1032f4:	53                   	push   %ebx
  1032f5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
  1032f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1032fe:	3b 05 08 80 10 00    	cmp    0x108008,%eax
  103304:	75 0c                	jne    103312 <exit+0x22>
    panic("init exiting");
  103306:	c7 04 24 ed 64 10 00 	movl   $0x1064ed,(%esp)
  10330d:	e8 6e d5 ff ff       	call   100880 <panic>
  103312:	31 db                	xor    %ebx,%ebx
  103314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
  103318:	8d 73 08             	lea    0x8(%ebx),%esi
  10331b:	8b 54 b0 08          	mov    0x8(%eax,%esi,4),%edx
  10331f:	85 d2                	test   %edx,%edx
  103321:	74 1c                	je     10333f <exit+0x4f>
      fileclose(proc->ofile[fd]);
  103323:	89 14 24             	mov    %edx,(%esp)
  103326:	e8 15 dc ff ff       	call   100f40 <fileclose>
      proc->ofile[fd] = 0;
  10332b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103331:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
  103338:	00 
  103339:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  10333f:	83 c3 01             	add    $0x1,%ebx
  103342:	83 fb 10             	cmp    $0x10,%ebx
  103345:	75 d1                	jne    103318 <exit+0x28>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  103347:	8b 40 68             	mov    0x68(%eax),%eax
  10334a:	89 04 24             	mov    %eax,(%esp)
  10334d:	e8 3e e5 ff ff       	call   101890 <iput>
  proc->cwd = 0;
  103352:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103358:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
  10335f:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103366:	e8 45 0b 00 00       	call   103eb0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  10336b:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
  103372:	ba 94 b8 10 00       	mov    $0x10b894,%edx
  103377:	8b 43 14             	mov    0x14(%ebx),%eax
  10337a:	eb 0f                	jmp    10338b <exit+0x9b>
  10337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103380:	83 c2 7c             	add    $0x7c,%edx
  103383:	81 fa 94 d7 10 00    	cmp    $0x10d794,%edx
  103389:	74 17                	je     1033a2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
  10338b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
  10338f:	75 ef                	jne    103380 <exit+0x90>
  103391:	3b 42 20             	cmp    0x20(%edx),%eax
  103394:	75 ea                	jne    103380 <exit+0x90>
      p->state = RUNNABLE;
  103396:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  10339d:	8d 76 00             	lea    0x0(%esi),%esi
  1033a0:	eb de                	jmp    103380 <exit+0x90>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  1033a2:	8b 35 08 80 10 00    	mov    0x108008,%esi
  1033a8:	b9 94 b8 10 00       	mov    $0x10b894,%ecx
  1033ad:	eb 0c                	jmp    1033bb <exit+0xcb>
  1033af:	90                   	nop    

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1033b0:	83 c1 7c             	add    $0x7c,%ecx
  1033b3:	81 f9 94 d7 10 00    	cmp    $0x10d794,%ecx
  1033b9:	74 37                	je     1033f2 <exit+0x102>
    if(p->parent == proc){
  1033bb:	3b 59 14             	cmp    0x14(%ecx),%ebx
  1033be:	75 f0                	jne    1033b0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
  1033c0:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  1033c4:	89 71 14             	mov    %esi,0x14(%ecx)
      if(p->state == ZOMBIE)
  1033c7:	75 e7                	jne    1033b0 <exit+0xc0>
  1033c9:	b8 94 b8 10 00       	mov    $0x10b894,%eax
  1033ce:	eb 07                	jmp    1033d7 <exit+0xe7>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1033d0:	83 c0 7c             	add    $0x7c,%eax
  1033d3:	39 c2                	cmp    %eax,%edx
  1033d5:	74 d9                	je     1033b0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
  1033d7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1033db:	75 f3                	jne    1033d0 <exit+0xe0>
  1033dd:	3b 70 20             	cmp    0x20(%eax),%esi
  1033e0:	75 ee                	jne    1033d0 <exit+0xe0>
      p->state = RUNNABLE;
  1033e2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1033f0:	eb de                	jmp    1033d0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  1033f2:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  1033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sched();
  103400:	e8 4b fe ff ff       	call   103250 <sched>
  panic("zombie exit");
  103405:	c7 04 24 fa 64 10 00 	movl   $0x1064fa,(%esp)
  10340c:	e8 6f d4 ff ff       	call   100880 <panic>
  103411:	eb 0d                	jmp    103420 <sleep>
  103413:	90                   	nop    
  103414:	90                   	nop    
  103415:	90                   	nop    
  103416:	90                   	nop    
  103417:	90                   	nop    
  103418:	90                   	nop    
  103419:	90                   	nop    
  10341a:	90                   	nop    
  10341b:	90                   	nop    
  10341c:	90                   	nop    
  10341d:	90                   	nop    
  10341e:	90                   	nop    
  10341f:	90                   	nop    

00103420 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103420:	55                   	push   %ebp
  103421:	89 e5                	mov    %esp,%ebp
  103423:	56                   	push   %esi
  103424:	53                   	push   %ebx
  103425:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
  103428:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  10342e:	8b 75 08             	mov    0x8(%ebp),%esi
  103431:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
  103434:	85 c0                	test   %eax,%eax
  103436:	0f 84 95 00 00 00    	je     1034d1 <sleep+0xb1>
    panic("sleep");

  if(lk == 0)
  10343c:	85 db                	test   %ebx,%ebx
  10343e:	0f 84 99 00 00 00    	je     1034dd <sleep+0xbd>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
  103444:	81 fb 60 b8 10 00    	cmp    $0x10b860,%ebx
  10344a:	74 5c                	je     1034a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
  10344c:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103453:	e8 58 0a 00 00       	call   103eb0 <acquire>
    release(lk);
  103458:	89 1c 24             	mov    %ebx,(%esp)
  10345b:	e8 00 0a 00 00       	call   103e60 <release>
  }

  // Go to sleep.
  proc->chan = chan;
  103460:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103466:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
  103469:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10346f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103476:	e8 d5 fd ff ff       	call   103250 <sched>

  // Tidy up.
  proc->chan = 0;
  10347b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103481:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
  103488:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10348f:	e8 cc 09 00 00       	call   103e60 <release>
    acquire(lk);
  103494:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103497:	83 c4 10             	add    $0x10,%esp
  10349a:	5b                   	pop    %ebx
  10349b:	5e                   	pop    %esi
  10349c:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  10349d:	e9 0e 0a 00 00       	jmp    103eb0 <acquire>
  1034a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  1034a8:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
  1034ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1034b1:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  1034b8:	e8 93 fd ff ff       	call   103250 <sched>

  // Tidy up.
  proc->chan = 0;
  1034bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1034c3:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
  1034ca:	83 c4 10             	add    $0x10,%esp
  1034cd:	5b                   	pop    %ebx
  1034ce:	5e                   	pop    %esi
  1034cf:	5d                   	pop    %ebp
  1034d0:	c3                   	ret    
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
  1034d1:	c7 04 24 06 65 10 00 	movl   $0x106506,(%esp)
  1034d8:	e8 a3 d3 ff ff       	call   100880 <panic>

  if(lk == 0)
    panic("sleep without lk");
  1034dd:	c7 04 24 0c 65 10 00 	movl   $0x10650c,(%esp)
  1034e4:	e8 97 d3 ff ff       	call   100880 <panic>
  1034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001034f0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1034f0:	55                   	push   %ebp
  1034f1:	89 e5                	mov    %esp,%ebp
  1034f3:	56                   	push   %esi
  1034f4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  1034f5:	bb 94 b8 10 00       	mov    $0x10b894,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1034fa:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  1034fd:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103504:	e8 a7 09 00 00       	call   103eb0 <acquire>
  103509:	31 d2                	xor    %edx,%edx
  10350b:	90                   	nop    
  10350c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103510:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
  103516:	72 30                	jb     103548 <wait+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
  103518:	85 d2                	test   %edx,%edx
  10351a:	74 5c                	je     103578 <wait+0x88>
  10351c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103522:	8b 50 24             	mov    0x24(%eax),%edx
  103525:	85 d2                	test   %edx,%edx
  103527:	75 4f                	jne    103578 <wait+0x88>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  103529:	bb 94 b8 10 00       	mov    $0x10b894,%ebx
  10352e:	c7 44 24 04 60 b8 10 	movl   $0x10b860,0x4(%esp)
  103535:	00 
  103536:	89 04 24             	mov    %eax,(%esp)
  103539:	e8 e2 fe ff ff       	call   103420 <sleep>
  10353e:	31 d2                	xor    %edx,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103540:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
  103546:	73 d0                	jae    103518 <wait+0x28>
      if(p->parent != proc)
  103548:	8b 43 14             	mov    0x14(%ebx),%eax
  10354b:	65 3b 05 04 00 00 00 	cmp    %gs:0x4,%eax
  103552:	74 0c                	je     103560 <wait+0x70>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103554:	83 c3 7c             	add    $0x7c,%ebx
  103557:	eb b7                	jmp    103510 <wait+0x20>
  103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
  103560:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  103564:	74 2c                	je     103592 <wait+0xa2>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
  103566:	ba 01 00 00 00       	mov    $0x1,%edx
  10356b:	90                   	nop    
  10356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103570:	eb e2                	jmp    103554 <wait+0x64>
  103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  103578:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10357f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  103584:	e8 d7 08 00 00       	call   103e60 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
  103589:	83 c4 10             	add    $0x10,%esp
  10358c:	89 f0                	mov    %esi,%eax
  10358e:	5b                   	pop    %ebx
  10358f:	5e                   	pop    %esi
  103590:	5d                   	pop    %ebp
  103591:	c3                   	ret    
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->mem, p->sz);
  103592:	8b 43 04             	mov    0x4(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
  103595:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->mem, p->sz);
  103598:	89 44 24 04          	mov    %eax,0x4(%esp)
  10359c:	8b 03                	mov    (%ebx),%eax
  10359e:	89 04 24             	mov    %eax,(%esp)
  1035a1:	e8 ca ed ff ff       	call   102370 <kfree>
        kfree(p->kstack, KSTACKSIZE);
  1035a6:	8b 43 08             	mov    0x8(%ebx),%eax
  1035a9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1035b0:	00 
  1035b1:	89 04 24             	mov    %eax,(%esp)
  1035b4:	e8 b7 ed ff ff       	call   102370 <kfree>
        p->state = UNUSED;
  1035b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
  1035c0:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
  1035c7:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
  1035ce:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
  1035d2:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        release(&ptable.lock);
  1035d9:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  1035e0:	e8 7b 08 00 00       	call   103e60 <release>
  1035e5:	eb a2                	jmp    103589 <wait+0x99>
  1035e7:	89 f6                	mov    %esi,%esi
  1035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001035f0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  1035f0:	55                   	push   %ebp
  1035f1:	89 e5                	mov    %esp,%ebp
  1035f3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
  1035f6:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  1035fd:	e8 ae 08 00 00       	call   103eb0 <acquire>
  proc->state = RUNNABLE;
  103602:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103608:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  10360f:	e8 3c fc ff ff       	call   103250 <sched>
  release(&ptable.lock);
  103614:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10361b:	e8 40 08 00 00       	call   103e60 <release>
}
  103620:	c9                   	leave  
  103621:	c3                   	ret    
  103622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103630 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103630:	55                   	push   %ebp
  103631:	89 e5                	mov    %esp,%ebp
  103633:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  103634:	bb 94 b8 10 00       	mov    $0x10b894,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103639:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  10363c:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103643:	e8 68 08 00 00       	call   103eb0 <acquire>
  103648:	eb 15                	jmp    10365f <allocproc+0x2f>
  10364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103650:	83 c3 7c             	add    $0x7c,%ebx
  103653:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
  103659:	0f 84 89 00 00 00    	je     1036e8 <allocproc+0xb8>
    if(p->state == UNUSED)
  10365f:	8b 4b 0c             	mov    0xc(%ebx),%ecx
  103662:	85 c9                	test   %ecx,%ecx
  103664:	75 ea                	jne    103650 <allocproc+0x20>
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  103666:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  10366d:	a1 c4 7a 10 00       	mov    0x107ac4,%eax
  103672:	89 43 10             	mov    %eax,0x10(%ebx)
  103675:	83 c0 01             	add    $0x1,%eax
  103678:	a3 c4 7a 10 00       	mov    %eax,0x107ac4
  release(&ptable.lock);
  10367d:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103684:	e8 d7 07 00 00       	call   103e60 <release>

  // Allocate kernel stack if necessary.
  if((p->kstack = kalloc(KSTACKSIZE)) == 0){
  103689:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103690:	e8 2b ec ff ff       	call   1022c0 <kalloc>
  103695:	85 c0                	test   %eax,%eax
  103697:	89 c2                	mov    %eax,%edx
  103699:	89 43 08             	mov    %eax,0x8(%ebx)
  10369c:	74 60                	je     1036fe <allocproc+0xce>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  10369e:	8d 80 b4 0f 00 00    	lea    0xfb4(%eax),%eax
  p->tf = (struct trapframe*)sp;
  1036a4:	89 43 18             	mov    %eax,0x18(%ebx)
  // which returns to trapret (see below).
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  1036a7:	8d 82 9c 0f 00 00    	lea    0xf9c(%edx),%eax
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret (see below).
  sp -= 4;
  *(uint*)sp = (uint)trapret;
  1036ad:	c7 82 b0 0f 00 00 60 	movl   $0x105060,0xfb0(%edx)
  1036b4:	50 10 00 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  1036b7:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
  1036ba:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  1036c1:	00 
  1036c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036c9:	00 
  1036ca:	89 04 24             	mov    %eax,(%esp)
  1036cd:	e8 7e 08 00 00       	call   103f50 <memset>
  p->context->eip = (uint)forkret;
  1036d2:	8b 43 1c             	mov    0x1c(%ebx),%eax
  1036d5:	c7 40 10 30 32 10 00 	movl   $0x103230,0x10(%eax)
  return p;
}
  1036dc:	89 d8                	mov    %ebx,%eax
  1036de:	83 c4 14             	add    $0x14,%esp
  1036e1:	5b                   	pop    %ebx
  1036e2:	5d                   	pop    %ebp
  1036e3:	c3                   	ret    
  1036e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  1036e8:	31 db                	xor    %ebx,%ebx
  1036ea:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  1036f1:	e8 6a 07 00 00       	call   103e60 <release>
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  return p;
}
  1036f6:	89 d8                	mov    %ebx,%eax
  1036f8:	83 c4 14             	add    $0x14,%esp
  1036fb:	5b                   	pop    %ebx
  1036fc:	5d                   	pop    %ebp
  1036fd:	c3                   	ret    
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack if necessary.
  if((p->kstack = kalloc(KSTACKSIZE)) == 0){
    p->state = UNUSED;
  1036fe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  103705:	31 db                	xor    %ebx,%ebx
  103707:	eb d3                	jmp    1036dc <allocproc+0xac>
  103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103710 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  103710:	55                   	push   %ebp
  103711:	89 e5                	mov    %esp,%ebp
  103713:	57                   	push   %edi
  103714:	56                   	push   %esi
  103715:	53                   	push   %ebx
  103716:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103719:	e8 12 ff ff ff       	call   103630 <allocproc>
  10371e:	89 c3                	mov    %eax,%ebx
  103720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103725:	85 db                	test   %ebx,%ebx
  103727:	0f 84 a6 00 00 00    	je     1037d3 <fork+0xc3>
    return -1;

  // Copy process state from p.
  np->sz = proc->sz;
  10372d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103733:	8b 40 04             	mov    0x4(%eax),%eax
  103736:	89 43 04             	mov    %eax,0x4(%ebx)
  if((np->mem = kalloc(np->sz)) == 0){
  103739:	89 04 24             	mov    %eax,(%esp)
  10373c:	e8 7f eb ff ff       	call   1022c0 <kalloc>
  103741:	85 c0                	test   %eax,%eax
  103743:	89 c2                	mov    %eax,%edx
  103745:	89 03                	mov    %eax,(%ebx)
  103747:	0f 84 8e 00 00 00    	je     1037db <fork+0xcb>
    kfree(np->kstack, KSTACKSIZE);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  memmove(np->mem, proc->mem, np->sz);
  10374d:	8b 43 04             	mov    0x4(%ebx),%eax
  103750:	89 44 24 08          	mov    %eax,0x8(%esp)
  103754:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10375a:	8b 00                	mov    (%eax),%eax
  10375c:	89 14 24             	mov    %edx,(%esp)
  10375f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103763:	e8 78 08 00 00       	call   103fe0 <memmove>
  np->parent = proc;
  103768:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  *np->tf = *proc->tf;
  10376e:	b9 13 00 00 00       	mov    $0x13,%ecx
  103773:	8b 7b 18             	mov    0x18(%ebx),%edi
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  memmove(np->mem, proc->mem, np->sz);
  np->parent = proc;
  103776:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
  103779:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10377f:	8b 70 18             	mov    0x18(%eax),%esi
  103782:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  103784:	31 f6                	xor    %esi,%esi
  103786:	8b 43 18             	mov    0x18(%ebx),%eax
  103789:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  103790:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103797:	90                   	nop    

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
  103798:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
  10379c:	85 c0                	test   %eax,%eax
  10379e:	74 13                	je     1037b3 <fork+0xa3>
      np->ofile[i] = filedup(proc->ofile[i]);
  1037a0:	89 04 24             	mov    %eax,(%esp)
  1037a3:	e8 d8 d6 ff ff       	call   100e80 <filedup>
  1037a8:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  1037ac:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
  1037b3:	83 c6 01             	add    $0x1,%esi
  1037b6:	83 fe 10             	cmp    $0x10,%esi
  1037b9:	75 dd                	jne    103798 <fork+0x88>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  1037bb:	8b 42 68             	mov    0x68(%edx),%eax
  1037be:	89 04 24             	mov    %eax,(%esp)
  1037c1:	e8 aa d8 ff ff       	call   101070 <idup>
 
  pid = np->pid;
  np->state = RUNNABLE;
  1037c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  1037cd:	89 43 68             	mov    %eax,0x68(%ebx)
 
  pid = np->pid;
  1037d0:	8b 43 10             	mov    0x10(%ebx),%eax
  np->state = RUNNABLE;

  return pid;
}
  1037d3:	83 c4 0c             	add    $0xc,%esp
  1037d6:	5b                   	pop    %ebx
  1037d7:	5e                   	pop    %esi
  1037d8:	5f                   	pop    %edi
  1037d9:	5d                   	pop    %ebp
  1037da:	c3                   	ret    
    return -1;

  // Copy process state from p.
  np->sz = proc->sz;
  if((np->mem = kalloc(np->sz)) == 0){
    kfree(np->kstack, KSTACKSIZE);
  1037db:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1037e2:	00 
  1037e3:	8b 43 08             	mov    0x8(%ebx),%eax
  1037e6:	89 04 24             	mov    %eax,(%esp)
  1037e9:	e8 82 eb ff ff       	call   102370 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
  1037ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  // Copy process state from p.
  np->sz = proc->sz;
  if((np->mem = kalloc(np->sz)) == 0){
    kfree(np->kstack, KSTACKSIZE);
    np->kstack = 0;
  1037f3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
  1037fa:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  103801:	eb d0                	jmp    1037d3 <fork+0xc3>
  103803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103810 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  103810:	55                   	push   %ebp
  103811:	89 e5                	mov    %esp,%ebp
  103813:	53                   	push   %ebx
  103814:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  103817:	e8 14 fe ff ff       	call   103630 <allocproc>
  initproc = p;
  10381c:	a3 08 80 10 00       	mov    %eax,0x108008
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  103821:	89 c3                	mov    %eax,%ebx
  initproc = p;

  // Initialize memory from initcode.S
  p->sz = PAGE;
  103823:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
  p->mem = kalloc(p->sz);
  10382a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103831:	e8 8a ea ff ff       	call   1022c0 <kalloc>
  memset(p->mem, 0, p->sz);
  103836:	8b 53 04             	mov    0x4(%ebx),%edx
  p = allocproc();
  initproc = p;

  // Initialize memory from initcode.S
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  103839:	89 03                	mov    %eax,(%ebx)
  memset(p->mem, 0, p->sz);
  10383b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10383f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103846:	00 
  103847:	89 04 24             	mov    %eax,(%esp)
  10384a:	e8 01 07 00 00       	call   103f50 <memset>
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  10384f:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  103856:	00 
  103857:	c7 44 24 04 c8 7e 10 	movl   $0x107ec8,0x4(%esp)
  10385e:	00 
  10385f:	8b 03                	mov    (%ebx),%eax
  103861:	89 04 24             	mov    %eax,(%esp)
  103864:	e8 77 07 00 00       	call   103fe0 <memmove>

  memset(p->tf, 0, sizeof(*p->tf));
  103869:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
  103870:	00 
  103871:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103878:	00 
  103879:	8b 43 18             	mov    0x18(%ebx),%eax
  10387c:	89 04 24             	mov    %eax,(%esp)
  10387f:	e8 cc 06 00 00       	call   103f50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103884:	8b 43 18             	mov    0x18(%ebx),%eax
  103887:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10388d:	8b 43 18             	mov    0x18(%ebx),%eax
  103890:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
  103896:	8b 53 18             	mov    0x18(%ebx),%edx
  103899:	0f b7 42 2c          	movzwl 0x2c(%edx),%eax
  10389d:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
  1038a1:	8b 53 18             	mov    0x18(%ebx),%edx
  1038a4:	0f b7 42 2c          	movzwl 0x2c(%edx),%eax
  1038a8:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
  1038ac:	8b 43 18             	mov    0x18(%ebx),%eax
  1038af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = p->sz;
  1038b6:	8b 53 18             	mov    0x18(%ebx),%edx
  1038b9:	8b 43 04             	mov    0x4(%ebx),%eax
  1038bc:	89 42 44             	mov    %eax,0x44(%edx)
  p->tf->eip = 0;  // beginning of initcode.S
  1038bf:	8b 43 18             	mov    0x18(%ebx),%eax
  1038c2:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
  1038c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
  1038cc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1038d3:	00 
  1038d4:	c7 44 24 04 1d 65 10 	movl   $0x10651d,0x4(%esp)
  1038db:	00 
  1038dc:	89 04 24             	mov    %eax,(%esp)
  1038df:	e8 0c 08 00 00       	call   1040f0 <safestrcpy>
  p->cwd = namei("/");
  1038e4:	c7 04 24 26 65 10 00 	movl   $0x106526,(%esp)
  1038eb:	e8 b0 e5 ff ff       	call   101ea0 <namei>

  p->state = RUNNABLE;
  1038f0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  1038f7:	89 43 68             	mov    %eax,0x68(%ebx)

  p->state = RUNNABLE;
}
  1038fa:	83 c4 14             	add    $0x14,%esp
  1038fd:	5b                   	pop    %ebx
  1038fe:	5d                   	pop    %ebp
  1038ff:	c3                   	ret    

00103900 <usegment>:
}

// Set up CPU's segment descriptors and current process task state.
void
usegment(void)
{
  103900:	55                   	push   %ebp
  103901:	89 e5                	mov    %esp,%ebp
  103903:	83 ec 08             	sub    $0x8,%esp
  pushcli();
  103906:	e8 b5 04 00 00       	call   103dc0 <pushcli>
  cpu->gdt[SEG_UCODE] = SEG(STA_X|STA_R, proc->mem, proc->sz-1, DPL_USER);
  10390b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103912:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
  103919:	8b 42 04             	mov    0x4(%edx),%eax
  10391c:	8b 12                	mov    (%edx),%edx
  10391e:	c6 81 95 00 00 00 fa 	movb   $0xfa,0x95(%ecx)
  103925:	83 e8 01             	sub    $0x1,%eax
  103928:	c1 e8 0c             	shr    $0xc,%eax
  10392b:	66 89 81 90 00 00 00 	mov    %ax,0x90(%ecx)
  103932:	c1 e8 10             	shr    $0x10,%eax
  103935:	66 89 91 92 00 00 00 	mov    %dx,0x92(%ecx)
  10393c:	c1 ea 10             	shr    $0x10,%edx
  10393f:	83 c8 c0             	or     $0xffffffc0,%eax
  103942:	88 91 94 00 00 00    	mov    %dl,0x94(%ecx)
  103948:	c1 ea 08             	shr    $0x8,%edx
  10394b:	88 81 96 00 00 00    	mov    %al,0x96(%ecx)
  103951:	88 91 97 00 00 00    	mov    %dl,0x97(%ecx)
  cpu->gdt[SEG_UDATA] = SEG(STA_W, proc->mem, proc->sz-1, DPL_USER);
  103957:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10395e:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
  103965:	8b 42 04             	mov    0x4(%edx),%eax
  103968:	8b 12                	mov    (%edx),%edx
  10396a:	c6 81 9d 00 00 00 f2 	movb   $0xf2,0x9d(%ecx)
  103971:	83 e8 01             	sub    $0x1,%eax
  103974:	c1 e8 0c             	shr    $0xc,%eax
  103977:	66 89 81 98 00 00 00 	mov    %ax,0x98(%ecx)
  10397e:	c1 e8 10             	shr    $0x10,%eax
  103981:	66 89 91 9a 00 00 00 	mov    %dx,0x9a(%ecx)
  103988:	c1 ea 10             	shr    $0x10,%edx
  10398b:	83 c8 c0             	or     $0xffffffc0,%eax
  10398e:	88 91 9c 00 00 00    	mov    %dl,0x9c(%ecx)
  103994:	c1 ea 08             	shr    $0x8,%edx
  103997:	88 81 9e 00 00 00    	mov    %al,0x9e(%ecx)
  10399d:	88 91 9f 00 00 00    	mov    %dl,0x9f(%ecx)
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  1039a3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  1039aa:	8d 42 08             	lea    0x8(%edx),%eax
  1039ad:	66 89 82 a2 00 00 00 	mov    %ax,0xa2(%edx)
  1039b4:	c1 e8 10             	shr    $0x10,%eax
  1039b7:	88 82 a4 00 00 00    	mov    %al,0xa4(%edx)
  1039bd:	c1 e8 08             	shr    $0x8,%eax
  1039c0:	66 c7 82 a0 00 00 00 	movw   $0x67,0xa0(%edx)
  1039c7:	67 00 
  1039c9:	c6 82 a5 00 00 00 99 	movb   $0x99,0xa5(%edx)
  1039d0:	c6 82 a6 00 00 00 40 	movb   $0x40,0xa6(%edx)
  1039d7:	88 82 a7 00 00 00    	mov    %al,0xa7(%edx)
  cpu->gdt[SEG_TSS].s = 0;
  1039dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1039e3:	80 a0 a5 00 00 00 ef 	andb   $0xef,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  1039ea:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1039f0:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  1039f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1039fc:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103a03:	8b 40 08             	mov    0x8(%eax),%eax
  103a06:	05 00 10 00 00       	add    $0x1000,%eax
  103a0b:	89 42 0c             	mov    %eax,0xc(%edx)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103a0e:	b8 30 00 00 00       	mov    $0x30,%eax
  103a13:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
}
  103a16:	c9                   	leave  
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  ltr(SEG_TSS << 3);
  popcli();
  103a17:	e9 e4 03 00 00       	jmp    103e00 <popcli>
  103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103a20 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103a20:	55                   	push   %ebp
  103a21:	89 e5                	mov    %esp,%ebp
  103a23:	53                   	push   %ebx
  103a24:	83 ec 14             	sub    $0x14,%esp
  103a27:	90                   	nop    
}

static inline void
sti(void)
{
  asm volatile("sti");
  103a28:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
  103a29:	bb 94 b8 10 00       	mov    $0x10b894,%ebx
  103a2e:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103a35:	e8 76 04 00 00       	call   103eb0 <acquire>
  103a3a:	eb 0f                	jmp    103a4b <scheduler+0x2b>
  103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a40:	83 c3 7c             	add    $0x7c,%ebx
  103a43:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
  103a49:	74 55                	je     103aa0 <scheduler+0x80>
      if(p->state != RUNNABLE)
  103a4b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  103a4f:	90                   	nop    
  103a50:	75 ee                	jne    103a40 <scheduler+0x20>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
  103a52:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      usegment();
  103a59:	e8 a2 fe ff ff       	call   103900 <usegment>
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
  103a5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      usegment();
      p->state = RUNNING;
  103a64:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a6b:	83 c3 7c             	add    $0x7c,%ebx
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      usegment();
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
  103a6e:	8b 40 1c             	mov    0x1c(%eax),%eax
  103a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a75:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103a7b:	83 c0 04             	add    $0x4,%eax
  103a7e:	89 04 24             	mov    %eax,(%esp)
  103a81:	e8 c6 06 00 00       	call   10414c <swtch>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a86:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
  103a8c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  103a93:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a97:	75 b2                	jne    103a4b <scheduler+0x2b>
  103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
  103aa0:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103aa7:	e8 b4 03 00 00       	call   103e60 <release>
  103aac:	e9 77 ff ff ff       	jmp    103a28 <scheduler+0x8>
  103ab1:	eb 0d                	jmp    103ac0 <growproc>
  103ab3:	90                   	nop    
  103ab4:	90                   	nop    
  103ab5:	90                   	nop    
  103ab6:	90                   	nop    
  103ab7:	90                   	nop    
  103ab8:	90                   	nop    
  103ab9:	90                   	nop    
  103aba:	90                   	nop    
  103abb:	90                   	nop    
  103abc:	90                   	nop    
  103abd:	90                   	nop    
  103abe:	90                   	nop    
  103abf:	90                   	nop    

00103ac0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103ac0:	55                   	push   %ebp
  103ac1:	89 e5                	mov    %esp,%ebp
  103ac3:	56                   	push   %esi
  103ac4:	53                   	push   %ebx
  103ac5:	83 ec 10             	sub    $0x10,%esp
  char *newmem;

  newmem = kalloc(proc->sz + n);
  103ac8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103ace:	8b 75 08             	mov    0x8(%ebp),%esi
  char *newmem;

  newmem = kalloc(proc->sz + n);
  103ad1:	8b 50 04             	mov    0x4(%eax),%edx
  103ad4:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103ad7:	89 04 24             	mov    %eax,(%esp)
  103ada:	e8 e1 e7 ff ff       	call   1022c0 <kalloc>
  103adf:	89 c3                	mov    %eax,%ebx
  if(newmem == 0)
  103ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103ae6:	85 db                	test   %ebx,%ebx
  103ae8:	74 6c                	je     103b56 <growproc+0x96>
    return -1;
  memmove(newmem, proc->mem, proc->sz);
  103aea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103af1:	8b 42 04             	mov    0x4(%edx),%eax
  103af4:	89 44 24 08          	mov    %eax,0x8(%esp)
  103af8:	8b 02                	mov    (%edx),%eax
  103afa:	89 1c 24             	mov    %ebx,(%esp)
  103afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b01:	e8 da 04 00 00       	call   103fe0 <memmove>
  memset(newmem + proc->sz, 0, n);
  103b06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b0c:	89 74 24 08          	mov    %esi,0x8(%esp)
  103b10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b17:	00 
  103b18:	8b 50 04             	mov    0x4(%eax),%edx
  103b1b:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  103b1e:	89 04 24             	mov    %eax,(%esp)
  103b21:	e8 2a 04 00 00       	call   103f50 <memset>
  kfree(proc->mem, proc->sz);
  103b26:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103b2d:	8b 42 04             	mov    0x4(%edx),%eax
  103b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b34:	8b 02                	mov    (%edx),%eax
  103b36:	89 04 24             	mov    %eax,(%esp)
  103b39:	e8 32 e8 ff ff       	call   102370 <kfree>
  proc->mem = newmem;
  103b3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b44:	89 18                	mov    %ebx,(%eax)
  proc->sz += n;
  103b46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b4c:	01 70 04             	add    %esi,0x4(%eax)
  usegment();
  103b4f:	e8 ac fd ff ff       	call   103900 <usegment>
  103b54:	31 c0                	xor    %eax,%eax
  return 0;
}
  103b56:	83 c4 10             	add    $0x10,%esp
  103b59:	5b                   	pop    %ebx
  103b5a:	5e                   	pop    %esi
  103b5b:	5d                   	pop    %ebp
  103b5c:	c3                   	ret    
  103b5d:	8d 76 00             	lea    0x0(%esi),%esi

00103b60 <ksegment>:

// Set up CPU's kernel segment descriptors.
// Run once at boot time on each CPU.
void
ksegment(void)
{
  103b60:	55                   	push   %ebp
  103b61:	89 e5                	mov    %esp,%ebp
  103b63:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;

  c = &cpus[cpunum()];
  103b66:	e8 85 ec ff ff       	call   1027f0 <cpunum>
  103b6b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  103b71:	05 60 b2 10 00       	add    $0x10b260,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  103b76:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  103b7c:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
  103b83:	c1 ea 10             	shr    $0x10,%edx
  103b86:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
  103b8c:	c1 ea 08             	shr    $0x8,%edx
  103b8f:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
  103b95:	8d 50 70             	lea    0x70(%eax),%edx
ksegment(void)
{
  struct cpu *c;

  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103b98:	66 c7 40 78 0f 01    	movw   $0x10f,0x78(%eax)
  103b9e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
  103ba4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
  103ba8:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
  103bac:	c6 40 7e c0          	movb   $0xc0,0x7e(%eax)
  103bb0:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103bb4:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
  103bbb:	ff ff 
  103bbd:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
  103bc4:	00 00 
  103bc6:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
  103bcd:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
  103bd4:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  103bdb:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  103be2:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
  103be9:	00 00 
  103beb:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
  103bf2:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103bf9:	66 c7 45 fa 37 00    	movw   $0x37,-0x6(%ebp)
  pd[1] = (uint)p;
  103bff:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  103c03:	c1 ea 10             	shr    $0x10,%edx
  103c06:	66 89 55 fe          	mov    %dx,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103c0a:	8d 55 fa             	lea    -0x6(%ebp),%edx
  103c0d:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
  103c10:	ba 18 00 00 00       	mov    $0x18,%edx
  103c15:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
  103c17:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  103c1e:	00 00 00 00 
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
  103c22:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
  103c28:	c9                   	leave  
  103c29:	c3                   	ret    
  103c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103c30 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103c30:	55                   	push   %ebp
  103c31:	89 e5                	mov    %esp,%ebp
  103c33:	57                   	push   %edi
  103c34:	56                   	push   %esi
  103c35:	53                   	push   %ebx
  103c36:	bb 94 b8 10 00       	mov    $0x10b894,%ebx
  103c3b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103c3e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  103c41:	eb 4b                	jmp    103c8e <procdump+0x5e>
  103c43:	90                   	nop    
  103c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103c48:	8b 0c 85 68 65 10 00 	mov    0x106568(,%eax,4),%ecx
  103c4f:	85 c9                	test   %ecx,%ecx
  103c51:	74 47                	je     103c9a <procdump+0x6a>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103c53:	8b 53 10             	mov    0x10(%ebx),%edx
  103c56:	8d 43 6c             	lea    0x6c(%ebx),%eax
  103c59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103c61:	c7 04 24 2c 65 10 00 	movl   $0x10652c,(%esp)
  103c68:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c6c:	e8 2f c8 ff ff       	call   1004a0 <cprintf>
    if(p->state == SLEEPING){
  103c71:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  103c75:	74 31                	je     103ca8 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  103c77:	c7 04 24 43 64 10 00 	movl   $0x106443,(%esp)
  103c7e:	e8 1d c8 ff ff       	call   1004a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103c83:	83 c3 7c             	add    $0x7c,%ebx
  103c86:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
  103c8c:	74 5a                	je     103ce8 <procdump+0xb8>
    if(p->state == UNUSED)
  103c8e:	8b 43 0c             	mov    0xc(%ebx),%eax
  103c91:	85 c0                	test   %eax,%eax
  103c93:	74 ee                	je     103c83 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103c95:	83 f8 05             	cmp    $0x5,%eax
  103c98:	76 ae                	jbe    103c48 <procdump+0x18>
  103c9a:	b9 28 65 10 00       	mov    $0x106528,%ecx
  103c9f:	eb b2                	jmp    103c53 <procdump+0x23>
  103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103ca8:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103cab:	89 fe                	mov    %edi,%esi
  103cad:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  103cb4:	83 c0 08             	add    $0x8,%eax
  103cb7:	89 04 24             	mov    %eax,(%esp)
  103cba:	e8 81 00 00 00       	call   103d40 <getcallerpcs>
  103cbf:	90                   	nop    
      for(i=0; i<10 && pc[i] != 0; i++)
  103cc0:	8b 06                	mov    (%esi),%eax
  103cc2:	85 c0                	test   %eax,%eax
  103cc4:	74 b1                	je     103c77 <procdump+0x47>
        cprintf(" %p", pc[i]);
  103cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  103cca:	83 c6 04             	add    $0x4,%esi
  103ccd:	c7 04 24 c1 5f 10 00 	movl   $0x105fc1,(%esp)
  103cd4:	e8 c7 c7 ff ff       	call   1004a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
  103cd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  103cdc:	39 c6                	cmp    %eax,%esi
  103cde:	75 e0                	jne    103cc0 <procdump+0x90>
  103ce0:	eb 95                	jmp    103c77 <procdump+0x47>
  103ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
  103ce8:	83 c4 4c             	add    $0x4c,%esp
  103ceb:	5b                   	pop    %ebx
  103cec:	5e                   	pop    %esi
  103ced:	5f                   	pop    %edi
  103cee:	5d                   	pop    %ebp
  103cef:	90                   	nop    
  103cf0:	c3                   	ret    
  103cf1:	eb 0d                	jmp    103d00 <pinit>
  103cf3:	90                   	nop    
  103cf4:	90                   	nop    
  103cf5:	90                   	nop    
  103cf6:	90                   	nop    
  103cf7:	90                   	nop    
  103cf8:	90                   	nop    
  103cf9:	90                   	nop    
  103cfa:	90                   	nop    
  103cfb:	90                   	nop    
  103cfc:	90                   	nop    
  103cfd:	90                   	nop    
  103cfe:	90                   	nop    
  103cff:	90                   	nop    

00103d00 <pinit>:
extern void forkret(void);
extern void trapret(void);

void
pinit(void)
{
  103d00:	55                   	push   %ebp
  103d01:	89 e5                	mov    %esp,%ebp
  103d03:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
  103d06:	c7 44 24 04 35 65 10 	movl   $0x106535,0x4(%esp)
  103d0d:	00 
  103d0e:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103d15:	e8 06 00 00 00       	call   103d20 <initlock>
}
  103d1a:	c9                   	leave  
  103d1b:	c3                   	ret    
  103d1c:	90                   	nop    
  103d1d:	90                   	nop    
  103d1e:	90                   	nop    
  103d1f:	90                   	nop    

00103d20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  103d20:	55                   	push   %ebp
  103d21:	89 e5                	mov    %esp,%ebp
  103d23:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
  103d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
  103d29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  103d2f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
  103d32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
  103d39:	5d                   	pop    %ebp
  103d3a:	c3                   	ret    
  103d3b:	90                   	nop    
  103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103d40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103d40:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103d41:	31 d2                	xor    %edx,%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103d43:	89 e5                	mov    %esp,%ebp
  103d45:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103d46:	8b 4d 08             	mov    0x8(%ebp),%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103d49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103d4c:	83 e9 08             	sub    $0x8,%ecx
  103d4f:	eb 09                	jmp    103d5a <getcallerpcs+0x1a>
  103d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103d58:	89 c1                	mov    %eax,%ecx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  103d5a:	8d 41 ff             	lea    -0x1(%ecx),%eax
  103d5d:	83 f8 fd             	cmp    $0xfffffffd,%eax
  103d60:	77 16                	ja     103d78 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
  103d62:	8b 41 04             	mov    0x4(%ecx),%eax
  103d65:	89 04 93             	mov    %eax,(%ebx,%edx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103d68:	83 c2 01             	add    $0x1,%edx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103d6b:	8b 01                	mov    (%ecx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103d6d:	83 fa 0a             	cmp    $0xa,%edx
  103d70:	75 e6                	jne    103d58 <getcallerpcs+0x18>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  103d72:	5b                   	pop    %ebx
  103d73:	5d                   	pop    %ebp
  103d74:	c3                   	ret    
  103d75:	8d 76 00             	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103d78:	83 fa 09             	cmp    $0x9,%edx
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103d7b:	8d 04 93             	lea    (%ebx,%edx,4),%eax
  }
  for(; i < 10; i++)
  103d7e:	7f f2                	jg     103d72 <getcallerpcs+0x32>
  103d80:	83 c2 01             	add    $0x1,%edx
    pcs[i] = 0;
  103d83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103d89:	83 c0 04             	add    $0x4,%eax
  103d8c:	83 fa 09             	cmp    $0x9,%edx
  103d8f:	7e ef                	jle    103d80 <getcallerpcs+0x40>
    pcs[i] = 0;
}
  103d91:	5b                   	pop    %ebx
  103d92:	5d                   	pop    %ebp
  103d93:	c3                   	ret    
  103d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103da0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103da0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
  103da1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103da3:	89 e5                	mov    %esp,%ebp
  103da5:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
  103da8:	8b 0a                	mov    (%edx),%ecx
  103daa:	85 c9                	test   %ecx,%ecx
  103dac:	74 10                	je     103dbe <holding+0x1e>
  103dae:	8b 42 08             	mov    0x8(%edx),%eax
  103db1:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103db8:	0f 94 c0             	sete   %al
  103dbb:	0f b6 c0             	movzbl %al,%eax
}
  103dbe:	5d                   	pop    %ebp
  103dbf:	c3                   	ret    

00103dc0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  103dc0:	55                   	push   %ebp
  103dc1:	89 e5                	mov    %esp,%ebp
  103dc3:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103dc4:	9c                   	pushf  
  103dc5:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103dc6:	fa                   	cli    
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103dc7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103dcd:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
  103dd3:	8d 51 01             	lea    0x1(%ecx),%edx
  103dd6:	85 c9                	test   %ecx,%ecx
  103dd8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
  103dde:	75 12                	jne    103df2 <pushcli+0x32>
    cpu->intena = eflags & FL_IF;
  103de0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103de6:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103dec:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  103df2:	5b                   	pop    %ebx
  103df3:	5d                   	pop    %ebp
  103df4:	c3                   	ret    
  103df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103e00 <popcli>:

void
popcli(void)
{
  103e00:	55                   	push   %ebp
  103e01:	89 e5                	mov    %esp,%ebp
  103e03:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103e06:	9c                   	pushf  
  103e07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
  103e08:	f6 c4 02             	test   $0x2,%ah
  103e0b:	75 37                	jne    103e44 <popcli+0x44>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
  103e0d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103e14:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103e1a:	83 e8 01             	sub    $0x1,%eax
  103e1d:	85 c0                	test   %eax,%eax
  103e1f:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
  103e25:	78 29                	js     103e50 <popcli+0x50>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
  103e27:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103e2d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
  103e33:	85 d2                	test   %edx,%edx
  103e35:	75 0b                	jne    103e42 <popcli+0x42>
  103e37:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  103e3d:	85 c0                	test   %eax,%eax
  103e3f:	74 01                	je     103e42 <popcli+0x42>
}

static inline void
sti(void)
{
  asm volatile("sti");
  103e41:	fb                   	sti    
    sti();
}
  103e42:	c9                   	leave  
  103e43:	c3                   	ret    

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  103e44:	c7 04 24 80 65 10 00 	movl   $0x106580,(%esp)
  103e4b:	e8 30 ca ff ff       	call   100880 <panic>
  if(--cpu->ncli < 0)
    panic("popcli");
  103e50:	c7 04 24 97 65 10 00 	movl   $0x106597,(%esp)
  103e57:	e8 24 ca ff ff       	call   100880 <panic>
  103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103e60 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
  103e60:	55                   	push   %ebp
  103e61:	89 e5                	mov    %esp,%ebp
  103e63:	83 ec 08             	sub    $0x8,%esp
  103e66:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  103e69:	8b 0a                	mov    (%edx),%ecx
  103e6b:	85 c9                	test   %ecx,%ecx
  103e6d:	74 0c                	je     103e7b <release+0x1b>
  103e6f:	8b 42 08             	mov    0x8(%edx),%eax
  103e72:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103e79:	74 0d                	je     103e88 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
  103e7b:	c7 04 24 9e 65 10 00 	movl   $0x10659e,(%esp)
  103e82:	e8 f9 c9 ff ff       	call   100880 <panic>
  103e87:	90                   	nop    

  lk->pcs[0] = 0;
  103e88:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103e8f:	31 c0                	xor    %eax,%eax
  lk->cpu = 0;
  103e91:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
  103e98:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
}
  103e9b:	c9                   	leave  
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
  103e9c:	e9 5f ff ff ff       	jmp    103e00 <popcli>
  103ea1:	eb 0d                	jmp    103eb0 <acquire>
  103ea3:	90                   	nop    
  103ea4:	90                   	nop    
  103ea5:	90                   	nop    
  103ea6:	90                   	nop    
  103ea7:	90                   	nop    
  103ea8:	90                   	nop    
  103ea9:	90                   	nop    
  103eaa:	90                   	nop    
  103eab:	90                   	nop    
  103eac:	90                   	nop    
  103ead:	90                   	nop    
  103eae:	90                   	nop    
  103eaf:	90                   	nop    

00103eb0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  103eb0:	55                   	push   %ebp
  103eb1:	89 e5                	mov    %esp,%ebp
  103eb3:	53                   	push   %ebx
  103eb4:	83 ec 14             	sub    $0x14,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103eb7:	9c                   	pushf  
  103eb8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103eb9:	fa                   	cli    
{
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103eba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103ec0:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
  103ec6:	8d 51 01             	lea    0x1(%ecx),%edx
  103ec9:	85 c9                	test   %ecx,%ecx
  103ecb:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
  103ed1:	75 12                	jne    103ee5 <acquire+0x35>
    cpu->intena = eflags & FL_IF;
  103ed3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103ed9:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103edf:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
  103ee5:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  103ee8:	8b 1a                	mov    (%edx),%ebx
  103eea:	85 db                	test   %ebx,%ebx
  103eec:	74 0c                	je     103efa <acquire+0x4a>
  103eee:	8b 42 08             	mov    0x8(%edx),%eax
  103ef1:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103ef8:	74 46                	je     103f40 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103efa:	b9 01 00 00 00       	mov    $0x1,%ecx
  103eff:	eb 0a                	jmp    103f0b <acquire+0x5b>
  103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103f08:	8b 55 08             	mov    0x8(%ebp),%edx
  103f0b:	89 c8                	mov    %ecx,%eax
  103f0d:	f0 87 02             	lock xchg %eax,(%edx)
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
  103f10:	85 c0                	test   %eax,%eax
  103f12:	75 f4                	jne    103f08 <acquire+0x58>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  103f14:	8b 45 08             	mov    0x8(%ebp),%eax
  103f17:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103f1e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
  103f21:	8b 45 08             	mov    0x8(%ebp),%eax
  103f24:	83 c0 0c             	add    $0xc,%eax
  103f27:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f2b:	8d 45 08             	lea    0x8(%ebp),%eax
  103f2e:	89 04 24             	mov    %eax,(%esp)
  103f31:	e8 0a fe ff ff       	call   103d40 <getcallerpcs>
}
  103f36:	83 c4 14             	add    $0x14,%esp
  103f39:	5b                   	pop    %ebx
  103f3a:	5d                   	pop    %ebp
  103f3b:	c3                   	ret    
  103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
    panic("acquire");
  103f40:	c7 04 24 a6 65 10 00 	movl   $0x1065a6,(%esp)
  103f47:	e8 34 c9 ff ff       	call   100880 <panic>
  103f4c:	90                   	nop    
  103f4d:	90                   	nop    
  103f4e:	90                   	nop    
  103f4f:	90                   	nop    

00103f50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  103f50:	55                   	push   %ebp
  103f51:	89 e5                	mov    %esp,%ebp
  103f53:	83 ec 08             	sub    $0x8,%esp
  103f56:	89 1c 24             	mov    %ebx,(%esp)
  103f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  103f5c:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  103f60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  103f66:	89 df                	mov    %ebx,%edi
  103f68:	fc                   	cld    
  103f69:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  103f6b:	89 d8                	mov    %ebx,%eax
  103f6d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  103f71:	8b 1c 24             	mov    (%esp),%ebx
  103f74:	89 ec                	mov    %ebp,%esp
  103f76:	5d                   	pop    %ebp
  103f77:	c3                   	ret    
  103f78:	90                   	nop    
  103f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103f80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  103f80:	55                   	push   %ebp
  103f81:	89 e5                	mov    %esp,%ebp
  103f83:	57                   	push   %edi
  103f84:	56                   	push   %esi
  103f85:	53                   	push   %ebx
  103f86:	8b 55 10             	mov    0x10(%ebp),%edx
  103f89:	8b 7d 08             	mov    0x8(%ebp),%edi
  103f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103f8f:	85 d2                	test   %edx,%edx
  103f91:	74 2d                	je     103fc0 <memcmp+0x40>
    if(*s1 != *s2)
  103f93:	0f b6 1f             	movzbl (%edi),%ebx
  103f96:	0f b6 06             	movzbl (%esi),%eax
  103f99:	38 c3                	cmp    %al,%bl
  103f9b:	75 33                	jne    103fd0 <memcmp+0x50>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103f9d:	8d 4a ff             	lea    -0x1(%edx),%ecx
  103fa0:	31 d2                	xor    %edx,%edx
  103fa2:	eb 18                	jmp    103fbc <memcmp+0x3c>
  103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s1 != *s2)
  103fa8:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  103fad:	83 e9 01             	sub    $0x1,%ecx
  103fb0:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  103fb5:	83 c2 01             	add    $0x1,%edx
  103fb8:	38 c3                	cmp    %al,%bl
  103fba:	75 14                	jne    103fd0 <memcmp+0x50>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103fbc:	85 c9                	test   %ecx,%ecx
  103fbe:	75 e8                	jne    103fa8 <memcmp+0x28>
  103fc0:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  103fc2:	89 d0                	mov    %edx,%eax
  103fc4:	5b                   	pop    %ebx
  103fc5:	5e                   	pop    %esi
  103fc6:	5f                   	pop    %edi
  103fc7:	5d                   	pop    %ebp
  103fc8:	c3                   	ret    
  103fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  103fd0:	0f b6 d3             	movzbl %bl,%edx
  103fd3:	0f b6 c0             	movzbl %al,%eax
  103fd6:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  103fd8:	89 d0                	mov    %edx,%eax
  103fda:	5b                   	pop    %ebx
  103fdb:	5e                   	pop    %esi
  103fdc:	5f                   	pop    %edi
  103fdd:	5d                   	pop    %ebp
  103fde:	c3                   	ret    
  103fdf:	90                   	nop    

00103fe0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  103fe0:	55                   	push   %ebp
  103fe1:	89 e5                	mov    %esp,%ebp
  103fe3:	57                   	push   %edi
  103fe4:	56                   	push   %esi
  103fe5:	53                   	push   %ebx
  103fe6:	8b 75 08             	mov    0x8(%ebp),%esi
  103fe9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103fec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  103fef:	39 f1                	cmp    %esi,%ecx
  103ff1:	73 35                	jae    104028 <memmove+0x48>
  103ff3:	8d 3c 19             	lea    (%ecx,%ebx,1),%edi
  103ff6:	39 fe                	cmp    %edi,%esi
  103ff8:	73 2e                	jae    104028 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
  103ffa:	85 db                	test   %ebx,%ebx
  103ffc:	74 1d                	je     10401b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  103ffe:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  104001:	31 d2                	xor    %edx,%edx
  104003:	90                   	nop    
  104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  104008:	0f b6 44 17 ff       	movzbl -0x1(%edi,%edx,1),%eax
  10400d:	88 44 11 ff          	mov    %al,-0x1(%ecx,%edx,1)
  104011:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104014:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  104017:	85 c0                	test   %eax,%eax
  104019:	75 ed                	jne    104008 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  10401b:	89 f0                	mov    %esi,%eax
  10401d:	5b                   	pop    %ebx
  10401e:	5e                   	pop    %esi
  10401f:	5f                   	pop    %edi
  104020:	5d                   	pop    %ebp
  104021:	c3                   	ret    
  104022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104028:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  10402a:	85 db                	test   %ebx,%ebx
  10402c:	74 ed                	je     10401b <memmove+0x3b>
  10402e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104030:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  104034:	88 04 16             	mov    %al,(%esi,%edx,1)
  104037:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  10403a:	39 d3                	cmp    %edx,%ebx
  10403c:	75 f2                	jne    104030 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
  10403e:	89 f0                	mov    %esi,%eax
  104040:	5b                   	pop    %ebx
  104041:	5e                   	pop    %esi
  104042:	5f                   	pop    %edi
  104043:	5d                   	pop    %ebp
  104044:	c3                   	ret    
  104045:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104050 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104050:	55                   	push   %ebp
  104051:	89 e5                	mov    %esp,%ebp
  104053:	56                   	push   %esi
  104054:	53                   	push   %ebx
  104055:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10405b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10405e:	85 c9                	test   %ecx,%ecx
  104060:	75 1e                	jne    104080 <strncmp+0x30>
  104062:	eb 34                	jmp    104098 <strncmp+0x48>
  104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104068:	0f b6 16             	movzbl (%esi),%edx
  10406b:	38 d0                	cmp    %dl,%al
  10406d:	75 1b                	jne    10408a <strncmp+0x3a>
  10406f:	83 e9 01             	sub    $0x1,%ecx
  104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104078:	74 1e                	je     104098 <strncmp+0x48>
    n--, p++, q++;
  10407a:	83 c3 01             	add    $0x1,%ebx
  10407d:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104080:	0f b6 03             	movzbl (%ebx),%eax
  104083:	84 c0                	test   %al,%al
  104085:	75 e1                	jne    104068 <strncmp+0x18>
  104087:	0f b6 16             	movzbl (%esi),%edx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10408a:	0f b6 c8             	movzbl %al,%ecx
  10408d:	0f b6 c2             	movzbl %dl,%eax
  104090:	29 c1                	sub    %eax,%ecx
}
  104092:	89 c8                	mov    %ecx,%eax
  104094:	5b                   	pop    %ebx
  104095:	5e                   	pop    %esi
  104096:	5d                   	pop    %ebp
  104097:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104098:	31 c9                	xor    %ecx,%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  10409a:	89 c8                	mov    %ecx,%eax
  10409c:	5b                   	pop    %ebx
  10409d:	5e                   	pop    %esi
  10409e:	5d                   	pop    %ebp
  10409f:	c3                   	ret    

001040a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1040a0:	55                   	push   %ebp
  1040a1:	89 e5                	mov    %esp,%ebp
  1040a3:	56                   	push   %esi
  1040a4:	8b 75 08             	mov    0x8(%ebp),%esi
  1040a7:	53                   	push   %ebx
  1040a8:	8b 55 10             	mov    0x10(%ebp),%edx
  1040ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1040ae:	89 f1                	mov    %esi,%ecx
  1040b0:	eb 09                	jmp    1040bb <strncpy+0x1b>
  1040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1040b8:	83 c3 01             	add    $0x1,%ebx
  1040bb:	83 ea 01             	sub    $0x1,%edx
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  1040be:	8d 42 01             	lea    0x1(%edx),%eax
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1040c1:	85 c0                	test   %eax,%eax
  1040c3:	7e 0c                	jle    1040d1 <strncpy+0x31>
  1040c5:	0f b6 03             	movzbl (%ebx),%eax
  1040c8:	88 01                	mov    %al,(%ecx)
  1040ca:	83 c1 01             	add    $0x1,%ecx
  1040cd:	84 c0                	test   %al,%al
  1040cf:	75 e7                	jne    1040b8 <strncpy+0x18>
  1040d1:	31 c0                	xor    %eax,%eax
    ;
  while(n-- > 0)
  1040d3:	85 d2                	test   %edx,%edx
  1040d5:	7e 0c                	jle    1040e3 <strncpy+0x43>
  1040d7:	90                   	nop    
    *s++ = 0;
  1040d8:	c6 04 01 00          	movb   $0x0,(%ecx,%eax,1)
  1040dc:	83 c0 01             	add    $0x1,%eax
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1040df:	39 d0                	cmp    %edx,%eax
  1040e1:	75 f5                	jne    1040d8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  1040e3:	89 f0                	mov    %esi,%eax
  1040e5:	5b                   	pop    %ebx
  1040e6:	5e                   	pop    %esi
  1040e7:	5d                   	pop    %ebp
  1040e8:	c3                   	ret    
  1040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001040f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  1040f0:	55                   	push   %ebp
  1040f1:	89 e5                	mov    %esp,%ebp
  1040f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1040f6:	56                   	push   %esi
  1040f7:	8b 75 08             	mov    0x8(%ebp),%esi
  1040fa:	53                   	push   %ebx
  1040fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  1040fe:	85 c9                	test   %ecx,%ecx
  104100:	7e 1f                	jle    104121 <safestrcpy+0x31>
  104102:	89 f2                	mov    %esi,%edx
  104104:	eb 05                	jmp    10410b <safestrcpy+0x1b>
  104106:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104108:	83 c3 01             	add    $0x1,%ebx
  10410b:	83 e9 01             	sub    $0x1,%ecx
  10410e:	85 c9                	test   %ecx,%ecx
  104110:	7e 0c                	jle    10411e <safestrcpy+0x2e>
  104112:	0f b6 03             	movzbl (%ebx),%eax
  104115:	88 02                	mov    %al,(%edx)
  104117:	83 c2 01             	add    $0x1,%edx
  10411a:	84 c0                	test   %al,%al
  10411c:	75 ea                	jne    104108 <safestrcpy+0x18>
    ;
  *s = 0;
  10411e:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  104121:	89 f0                	mov    %esi,%eax
  104123:	5b                   	pop    %ebx
  104124:	5e                   	pop    %esi
  104125:	5d                   	pop    %ebp
  104126:	c3                   	ret    
  104127:	89 f6                	mov    %esi,%esi
  104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104130 <strlen>:

int
strlen(const char *s)
{
  104130:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104131:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104133:	89 e5                	mov    %esp,%ebp
  104135:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104138:	80 3a 00             	cmpb   $0x0,(%edx)
  10413b:	74 0c                	je     104149 <strlen+0x19>
  10413d:	8d 76 00             	lea    0x0(%esi),%esi
  104140:	83 c0 01             	add    $0x1,%eax
  104143:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104147:	75 f7                	jne    104140 <strlen+0x10>
    ;
  return n;
}
  104149:	5d                   	pop    %ebp
  10414a:	c3                   	ret    
  10414b:	90                   	nop    

0010414c <swtch>:
  10414c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104150:	8b 54 24 08          	mov    0x8(%esp),%edx
  104154:	55                   	push   %ebp
  104155:	53                   	push   %ebx
  104156:	56                   	push   %esi
  104157:	57                   	push   %edi
  104158:	89 20                	mov    %esp,(%eax)
  10415a:	89 d4                	mov    %edx,%esp
  10415c:	5f                   	pop    %edi
  10415d:	5e                   	pop    %esi
  10415e:	5b                   	pop    %ebx
  10415f:	5d                   	pop    %ebp
  104160:	c3                   	ret    
  104161:	90                   	nop    
  104162:	90                   	nop    
  104163:	90                   	nop    
  104164:	90                   	nop    
  104165:	90                   	nop    
  104166:	90                   	nop    
  104167:	90                   	nop    
  104168:	90                   	nop    
  104169:	90                   	nop    
  10416a:	90                   	nop    
  10416b:	90                   	nop    
  10416c:	90                   	nop    
  10416d:	90                   	nop    
  10416e:	90                   	nop    
  10416f:	90                   	nop    

00104170 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104170:	55                   	push   %ebp
  104171:	89 e5                	mov    %esp,%ebp
  104173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  104176:	8b 51 04             	mov    0x4(%ecx),%edx
  104179:	3b 55 0c             	cmp    0xc(%ebp),%edx
  10417c:	77 0a                	ja     104188 <fetchint+0x18>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  10417e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104183:	5d                   	pop    %ebp
  104184:	c3                   	ret    
  104185:	8d 76 00             	lea    0x0(%esi),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104188:	8b 45 0c             	mov    0xc(%ebp),%eax
  10418b:	83 c0 04             	add    $0x4,%eax
  10418e:	39 c2                	cmp    %eax,%edx
  104190:	72 ec                	jb     10417e <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104192:	8b 55 0c             	mov    0xc(%ebp),%edx
  104195:	8b 01                	mov    (%ecx),%eax
  104197:	8b 04 10             	mov    (%eax,%edx,1),%eax
  10419a:	8b 55 10             	mov    0x10(%ebp),%edx
  10419d:	89 02                	mov    %eax,(%edx)
  10419f:	31 c0                	xor    %eax,%eax
  return 0;
}
  1041a1:	5d                   	pop    %ebp
  1041a2:	c3                   	ret    
  1041a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001041b0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1041b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041b9:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  1041ba:	39 50 04             	cmp    %edx,0x4(%eax)
  1041bd:	77 09                	ja     1041c8 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1041bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1041c4:	5b                   	pop    %ebx
  1041c5:	5d                   	pop    %ebp
  1041c6:	c3                   	ret    
  1041c7:	90                   	nop    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  1041c8:	89 d3                	mov    %edx,%ebx
  1041ca:	8b 55 10             	mov    0x10(%ebp),%edx
  1041cd:	03 18                	add    (%eax),%ebx
  1041cf:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  1041d1:	8b 08                	mov    (%eax),%ecx
  1041d3:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  1041d6:	39 cb                	cmp    %ecx,%ebx
  1041d8:	73 e5                	jae    1041bf <fetchstr+0xf>
    if(*s == 0)
  1041da:	31 c0                	xor    %eax,%eax
  1041dc:	89 da                	mov    %ebx,%edx
  1041de:	80 3b 00             	cmpb   $0x0,(%ebx)
  1041e1:	74 e1                	je     1041c4 <fetchstr+0x14>
  1041e3:	90                   	nop    
  1041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1041e8:	83 c2 01             	add    $0x1,%edx
  1041eb:	39 d1                	cmp    %edx,%ecx
  1041ed:	76 d0                	jbe    1041bf <fetchstr+0xf>
    if(*s == 0)
  1041ef:	80 3a 00             	cmpb   $0x0,(%edx)
  1041f2:	75 f4                	jne    1041e8 <fetchstr+0x38>
  1041f4:	89 d0                	mov    %edx,%eax
  1041f6:	29 d8                	sub    %ebx,%eax
  1041f8:	eb ca                	jmp    1041c4 <fetchstr+0x14>
  1041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104200 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104200:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104207:	55                   	push   %ebp
  104208:	89 e5                	mov    %esp,%ebp
  10420a:	53                   	push   %ebx
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  10420b:	8b 41 18             	mov    0x18(%ecx),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10420e:	8b 59 04             	mov    0x4(%ecx),%ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104211:	8b 50 44             	mov    0x44(%eax),%edx
  104214:	8b 45 08             	mov    0x8(%ebp),%eax
  104217:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10421b:	39 da                	cmp    %ebx,%edx
  10421d:	72 09                	jb     104228 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10421f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
}
  104224:	5b                   	pop    %ebx
  104225:	5d                   	pop    %ebp
  104226:	c3                   	ret    
  104227:	90                   	nop    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104228:	8d 42 04             	lea    0x4(%edx),%eax
  10422b:	39 c3                	cmp    %eax,%ebx
  10422d:	72 f0                	jb     10421f <argint+0x1f>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10422f:	8b 01                	mov    (%ecx),%eax
  104231:	8b 04 10             	mov    (%eax,%edx,1),%eax
  104234:	8b 55 0c             	mov    0xc(%ebp),%edx
  104237:	89 02                	mov    %eax,(%edx)
  104239:	31 c0                	xor    %eax,%eax
  10423b:	eb e7                	jmp    104224 <argint+0x24>
  10423d:	8d 76 00             	lea    0x0(%esi),%esi

00104240 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104240:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104247:	55                   	push   %ebp
  104248:	89 e5                	mov    %esp,%ebp
  10424a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  10424b:	8b 41 18             	mov    0x18(%ecx),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10424e:	8b 59 04             	mov    0x4(%ecx),%ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104251:	8b 50 44             	mov    0x44(%eax),%edx
  104254:	8b 45 08             	mov    0x8(%ebp),%eax
  104257:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10425b:	39 da                	cmp    %ebx,%edx
  10425d:	73 07                	jae    104266 <argptr+0x26>
  10425f:	8d 42 04             	lea    0x4(%edx),%eax
  104262:	39 c3                	cmp    %eax,%ebx
  104264:	73 0a                	jae    104270 <argptr+0x30>
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
    return -1;
  *pp = proc->mem + i;
  return 0;
  104266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10426b:	5b                   	pop    %ebx
  10426c:	5d                   	pop    %ebp
  10426d:	c3                   	ret    
  10426e:	66 90                	xchg   %ax,%ax
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  104270:	8b 09                	mov    (%ecx),%ecx
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
  104272:	8b 14 11             	mov    (%ecx,%edx,1),%edx
  104275:	39 da                	cmp    %ebx,%edx
  104277:	73 ed                	jae    104266 <argptr+0x26>
  104279:	89 d0                	mov    %edx,%eax
  10427b:	03 45 10             	add    0x10(%ebp),%eax
  10427e:	39 d8                	cmp    %ebx,%eax
  104280:	73 e4                	jae    104266 <argptr+0x26>
    return -1;
  *pp = proc->mem + i;
  104282:	8d 04 11             	lea    (%ecx,%edx,1),%eax
  104285:	8b 55 0c             	mov    0xc(%ebp),%edx
  104288:	89 02                	mov    %eax,(%edx)
  10428a:	31 c0                	xor    %eax,%eax
  10428c:	eb dd                	jmp    10426b <argptr+0x2b>
  10428e:	66 90                	xchg   %ax,%ax

00104290 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104290:	55                   	push   %ebp
  104291:	89 e5                	mov    %esp,%ebp
  104293:	56                   	push   %esi
  104294:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104295:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
  10429c:	8b 43 18             	mov    0x18(%ebx),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10429f:	8b 4b 04             	mov    0x4(%ebx),%ecx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042a2:	8b 50 44             	mov    0x44(%eax),%edx
  1042a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1042a8:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042ac:	39 ca                	cmp    %ecx,%edx
  1042ae:	73 07                	jae    1042b7 <argstr+0x27>
  1042b0:	8d 42 04             	lea    0x4(%edx),%eax
  1042b3:	39 c1                	cmp    %eax,%ecx
  1042b5:	73 09                	jae    1042c0 <argstr+0x30>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1042b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  1042bc:	5b                   	pop    %ebx
  1042bd:	5e                   	pop    %esi
  1042be:	5d                   	pop    %ebp
  1042bf:	c3                   	ret    
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  1042c0:	8b 33                	mov    (%ebx),%esi
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
  1042c2:	8b 04 16             	mov    (%esi,%edx,1),%eax
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  1042c5:	39 c8                	cmp    %ecx,%eax
  1042c7:	73 ee                	jae    1042b7 <argstr+0x27>
    return -1;
  *pp = p->mem + addr;
  1042c9:	01 c6                	add    %eax,%esi
  1042cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042ce:	89 30                	mov    %esi,(%eax)
  ep = p->mem + p->sz;
  1042d0:	8b 0b                	mov    (%ebx),%ecx
  1042d2:	03 4b 04             	add    0x4(%ebx),%ecx
  for(s = *pp; s < ep; s++)
  1042d5:	39 ce                	cmp    %ecx,%esi
  1042d7:	73 de                	jae    1042b7 <argstr+0x27>
    if(*s == 0)
  1042d9:	31 c0                	xor    %eax,%eax
  1042db:	89 f2                	mov    %esi,%edx
  1042dd:	80 3e 00             	cmpb   $0x0,(%esi)
  1042e0:	75 10                	jne    1042f2 <argstr+0x62>
  1042e2:	eb d8                	jmp    1042bc <argstr+0x2c>
  1042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1042e8:	80 3a 00             	cmpb   $0x0,(%edx)
  1042eb:	90                   	nop    
  1042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1042f0:	74 16                	je     104308 <argstr+0x78>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1042f2:	83 c2 01             	add    $0x1,%edx
  1042f5:	39 d1                	cmp    %edx,%ecx
  1042f7:	90                   	nop    
  1042f8:	77 ee                	ja     1042e8 <argstr+0x58>
  1042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104300:	eb b5                	jmp    1042b7 <argstr+0x27>
  104302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
  104308:	89 d0                	mov    %edx,%eax
  10430a:	29 f0                	sub    %esi,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  10430c:	5b                   	pop    %ebx
  10430d:	5e                   	pop    %esi
  10430e:	5d                   	pop    %ebp
  10430f:	c3                   	ret    

00104310 <syscall>:
[SYS_write]   sys_write,
};

void
syscall(void)
{
  104310:	55                   	push   %ebp
  104311:	89 e5                	mov    %esp,%ebp
  104313:	53                   	push   %ebx
  104314:	83 ec 14             	sub    $0x14,%esp
  int num;
  
  num = proc->tf->eax;
  104317:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10431d:	8b 58 18             	mov    0x18(%eax),%ebx
  104320:	8b 4b 1c             	mov    0x1c(%ebx),%ecx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104323:	83 f9 14             	cmp    $0x14,%ecx
  104326:	77 18                	ja     104340 <syscall+0x30>
  104328:	8b 14 8d e0 65 10 00 	mov    0x1065e0(,%ecx,4),%edx
  10432f:	85 d2                	test   %edx,%edx
  104331:	74 0d                	je     104340 <syscall+0x30>
    proc->tf->eax = syscalls[num]();
  104333:	ff d2                	call   *%edx
  104335:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
  104338:	83 c4 14             	add    $0x14,%esp
  10433b:	5b                   	pop    %ebx
  10433c:	5d                   	pop    %ebp
  10433d:	c3                   	ret    
  10433e:	66 90                	xchg   %ax,%ax
  
  num = proc->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    proc->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104340:	8b 50 10             	mov    0x10(%eax),%edx
  104343:	83 c0 6c             	add    $0x6c,%eax
  104346:	89 44 24 08          	mov    %eax,0x8(%esp)
  10434a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10434e:	c7 04 24 ae 65 10 00 	movl   $0x1065ae,(%esp)
  104355:	89 54 24 04          	mov    %edx,0x4(%esp)
  104359:	e8 42 c1 ff ff       	call   1004a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  10435e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104364:	8b 40 18             	mov    0x18(%eax),%eax
  104367:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  10436e:	83 c4 14             	add    $0x14,%esp
  104371:	5b                   	pop    %ebx
  104372:	5d                   	pop    %ebp
  104373:	c3                   	ret    
  104374:	90                   	nop    
  104375:	90                   	nop    
  104376:	90                   	nop    
  104377:	90                   	nop    
  104378:	90                   	nop    
  104379:	90                   	nop    
  10437a:	90                   	nop    
  10437b:	90                   	nop    
  10437c:	90                   	nop    
  10437d:	90                   	nop    
  10437e:	90                   	nop    
  10437f:	90                   	nop    

00104380 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104380:	55                   	push   %ebp
  104381:	89 e5                	mov    %esp,%ebp
  104383:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104386:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104389:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  10438c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  10438f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104396:	00 
  104397:	89 44 24 04          	mov    %eax,0x4(%esp)
  10439b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1043a2:	e8 99 fe ff ff       	call   104240 <argptr>
  1043a7:	85 c0                	test   %eax,%eax
  1043a9:	79 15                	jns    1043c0 <sys_pipe+0x40>
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  1043ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
  1043b0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1043b3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1043b6:	89 ec                	mov    %ebp,%esp
  1043b8:	5d                   	pop    %ebp
  1043b9:	c3                   	ret    
  1043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  1043c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1043c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1043ca:	89 04 24             	mov    %eax,(%esp)
  1043cd:	e8 7e ec ff ff       	call   103050 <pipealloc>
  1043d2:	85 c0                	test   %eax,%eax
  1043d4:	78 d5                	js     1043ab <sys_pipe+0x2b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  1043d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  1043d9:	31 c9                	xor    %ecx,%ecx
  1043db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1043e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1043e8:	8b 5c 88 28          	mov    0x28(%eax,%ecx,4),%ebx
  1043ec:	85 db                	test   %ebx,%ebx
  1043ee:	74 28                	je     104418 <sys_pipe+0x98>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  1043f0:	83 c1 01             	add    $0x1,%ecx
  1043f3:	83 f9 10             	cmp    $0x10,%ecx
  1043f6:	75 f0                	jne    1043e8 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
  1043f8:	89 14 24             	mov    %edx,(%esp)
  1043fb:	e8 40 cb ff ff       	call   100f40 <fileclose>
    fileclose(wf);
  104400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104403:	89 04 24             	mov    %eax,(%esp)
  104406:	e8 35 cb ff ff       	call   100f40 <fileclose>
  10440b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104410:	eb 9e                	jmp    1043b0 <sys_pipe+0x30>
  104412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104418:	8d 59 08             	lea    0x8(%ecx),%ebx
  10441b:	89 54 98 08          	mov    %edx,0x8(%eax,%ebx,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  10441f:	8b 75 ec             	mov    -0x14(%ebp),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104422:	31 d2                	xor    %edx,%edx
  104424:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104430:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
  104435:	74 19                	je     104450 <sys_pipe+0xd0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104437:	83 c2 01             	add    $0x1,%edx
  10443a:	83 fa 10             	cmp    $0x10,%edx
  10443d:	75 f1                	jne    104430 <sys_pipe+0xb0>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
  10443f:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
  104446:	00 
  104447:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10444a:	eb ac                	jmp    1043f8 <sys_pipe+0x78>
  10444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104450:	89 74 90 28          	mov    %esi,0x28(%eax,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104457:	89 08                	mov    %ecx,(%eax)
  fd[1] = fd1;
  104459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10445c:	89 50 04             	mov    %edx,0x4(%eax)
  10445f:	31 c0                	xor    %eax,%eax
  104461:	e9 4a ff ff ff       	jmp    1043b0 <sys_pipe+0x30>
  104466:	8d 76 00             	lea    0x0(%esi),%esi
  104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104470 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104470:	55                   	push   %ebp
  104471:	89 e5                	mov    %esp,%ebp
  104473:	83 ec 28             	sub    $0x28,%esp
  104476:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104479:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10447b:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  10447e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104481:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104483:	89 54 24 04          	mov    %edx,0x4(%esp)
  104487:	89 04 24             	mov    %eax,(%esp)
  10448a:	e8 71 fd ff ff       	call   104200 <argint>
  10448f:	85 c0                	test   %eax,%eax
  104491:	79 15                	jns    1044a8 <argfd+0x38>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104493:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104498:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10449b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10449e:	89 ec                	mov    %ebp,%esp
  1044a0:	5d                   	pop    %ebp
  1044a1:	c3                   	ret    
  1044a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
  1044a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1044ab:	83 fa 0f             	cmp    $0xf,%edx
  1044ae:	77 e3                	ja     104493 <argfd+0x23>
  1044b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1044b6:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
  1044ba:	85 c9                	test   %ecx,%ecx
  1044bc:	74 d5                	je     104493 <argfd+0x23>
    return -1;
  if(pfd)
  1044be:	85 db                	test   %ebx,%ebx
  1044c0:	74 02                	je     1044c4 <argfd+0x54>
    *pfd = fd;
  1044c2:	89 13                	mov    %edx,(%ebx)
  if(pf)
  1044c4:	31 c0                	xor    %eax,%eax
  1044c6:	85 f6                	test   %esi,%esi
  1044c8:	74 ce                	je     104498 <argfd+0x28>
    *pf = f;
  1044ca:	89 0e                	mov    %ecx,(%esi)
  1044cc:	31 c0                	xor    %eax,%eax
  1044ce:	eb c8                	jmp    104498 <argfd+0x28>

001044d0 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  1044d0:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  1044d1:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  1044d3:	89 e5                	mov    %esp,%ebp
  1044d5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  1044d8:	8d 55 fc             	lea    -0x4(%ebp),%edx
  1044db:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  1044de:	e8 8d ff ff ff       	call   104470 <argfd>
  1044e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1044e8:	85 c0                	test   %eax,%eax
  1044ea:	78 1f                	js     10450b <sys_close+0x3b>
    return -1;
  proc->ofile[fd] = 0;
  1044ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044ef:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1044f6:	c7 44 82 28 00 00 00 	movl   $0x0,0x28(%edx,%eax,4)
  1044fd:	00 
  fileclose(f);
  1044fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104501:	89 04 24             	mov    %eax,(%esp)
  104504:	e8 37 ca ff ff       	call   100f40 <fileclose>
  104509:	31 d2                	xor    %edx,%edx
  return 0;
}
  10450b:	89 d0                	mov    %edx,%eax
  10450d:	c9                   	leave  
  10450e:	c3                   	ret    
  10450f:	90                   	nop    

00104510 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104510:	55                   	push   %ebp
  104511:	89 e5                	mov    %esp,%ebp
  104513:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104519:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10451c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10451f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104522:	89 44 24 04          	mov    %eax,0x4(%esp)
  104526:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10452d:	e8 5e fd ff ff       	call   104290 <argstr>
  104532:	85 c0                	test   %eax,%eax
  104534:	79 12                	jns    104548 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104536:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  10453b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10453e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104541:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104544:	89 ec                	mov    %ebp,%esp
  104546:	5d                   	pop    %ebp
  104547:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104548:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10454b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10454f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104556:	e8 a5 fc ff ff       	call   104200 <argint>
  10455b:	85 c0                	test   %eax,%eax
  10455d:	78 d7                	js     104536 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  10455f:	8d 7d 98             	lea    -0x68(%ebp),%edi
  104562:	31 db                	xor    %ebx,%ebx
  104564:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  10456b:	00 
  10456c:	31 f6                	xor    %esi,%esi
  10456e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104575:	00 
  104576:	89 3c 24             	mov    %edi,(%esp)
  104579:	e8 d2 f9 ff ff       	call   103f50 <memset>
  10457e:	eb 27                	jmp    1045a7 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
  104580:	8d 04 b7             	lea    (%edi,%esi,4),%eax
  104583:	89 44 24 08          	mov    %eax,0x8(%esp)
  104587:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10458d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104591:	89 04 24             	mov    %eax,(%esp)
  104594:	e8 17 fc ff ff       	call   1041b0 <fetchstr>
  104599:	85 c0                	test   %eax,%eax
  10459b:	78 99                	js     104536 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  10459d:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  1045a0:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1045a3:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
  1045a5:	74 8f                	je     104536 <sys_exec+0x26>
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
  1045a7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  1045aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045ae:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  1045b5:	03 45 ec             	add    -0x14(%ebp),%eax
  1045b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1045c2:	89 04 24             	mov    %eax,(%esp)
  1045c5:	e8 a6 fb ff ff       	call   104170 <fetchint>
  1045ca:	85 c0                	test   %eax,%eax
  1045cc:	0f 88 64 ff ff ff    	js     104536 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  1045d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1045d5:	85 d2                	test   %edx,%edx
  1045d7:	75 a7                	jne    104580 <sys_exec+0x70>
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1045d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  1045dc:	c7 44 9d 98 00 00 00 	movl   $0x0,-0x68(%ebp,%ebx,4)
  1045e3:	00 
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1045e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1045e8:	89 04 24             	mov    %eax,(%esp)
  1045eb:	e8 10 c3 ff ff       	call   100900 <exec>
  1045f0:	e9 46 ff ff ff       	jmp    10453b <sys_exec+0x2b>
  1045f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104600 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104600:	55                   	push   %ebp
  104601:	89 e5                	mov    %esp,%ebp
  104603:	53                   	push   %ebx
  104604:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104607:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10460a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10460e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104615:	e8 76 fc ff ff       	call   104290 <argstr>
  10461a:	85 c0                	test   %eax,%eax
  10461c:	79 12                	jns    104630 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  proc->cwd = ip;
  return 0;
  10461e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104623:	83 c4 24             	add    $0x24,%esp
  104626:	5b                   	pop    %ebx
  104627:	5d                   	pop    %ebp
  104628:	c3                   	ret    
  104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104633:	89 04 24             	mov    %eax,(%esp)
  104636:	e8 65 d8 ff ff       	call   101ea0 <namei>
  10463b:	85 c0                	test   %eax,%eax
  10463d:	89 c3                	mov    %eax,%ebx
  10463f:	74 dd                	je     10461e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104641:	89 04 24             	mov    %eax,(%esp)
  104644:	e8 a7 d5 ff ff       	call   101bf0 <ilock>
  if(ip->type != T_DIR){
  104649:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10464e:	75 26                	jne    104676 <sys_chdir+0x76>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104650:	89 1c 24             	mov    %ebx,(%esp)
  104653:	e8 08 d1 ff ff       	call   101760 <iunlock>
  iput(proc->cwd);
  104658:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10465e:	8b 40 68             	mov    0x68(%eax),%eax
  104661:	89 04 24             	mov    %eax,(%esp)
  104664:	e8 27 d2 ff ff       	call   101890 <iput>
  proc->cwd = ip;
  104669:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10466f:	89 58 68             	mov    %ebx,0x68(%eax)
  104672:	31 c0                	xor    %eax,%eax
  104674:	eb ad                	jmp    104623 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104676:	89 1c 24             	mov    %ebx,(%esp)
  104679:	e8 72 d4 ff ff       	call   101af0 <iunlockput>
  10467e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104683:	eb 9e                	jmp    104623 <sys_chdir+0x23>
  104685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104690 <create>:
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  104690:	55                   	push   %ebp
  104691:	89 e5                	mov    %esp,%ebp
  104693:	83 ec 48             	sub    $0x48,%esp
  104696:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  104699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10469c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10469f:	89 d7                	mov    %edx,%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046a1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1046a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046a7:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1046a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1046ac:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046b3:	89 04 24             	mov    %eax,(%esp)
  1046b6:	e8 c5 d7 ff ff       	call   101e80 <nameiparent>
  1046bb:	85 c0                	test   %eax,%eax
  1046bd:	89 c6                	mov    %eax,%esi
  1046bf:	74 4b                	je     10470c <create+0x7c>
    return 0;
  ilock(dp);
  1046c1:	89 04 24             	mov    %eax,(%esp)
  1046c4:	e8 27 d5 ff ff       	call   101bf0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
  1046c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1046cc:	8d 4d e2             	lea    -0x1e(%ebp),%ecx
  1046cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1046d7:	89 34 24             	mov    %esi,(%esp)
  1046da:	e8 71 cf ff ff       	call   101650 <dirlookup>
  1046df:	85 c0                	test   %eax,%eax
  1046e1:	89 c3                	mov    %eax,%ebx
  1046e3:	74 3b                	je     104720 <create+0x90>
    iunlockput(dp);
  1046e5:	89 34 24             	mov    %esi,(%esp)
  1046e8:	e8 03 d4 ff ff       	call   101af0 <iunlockput>
    ilock(ip);
  1046ed:	89 1c 24             	mov    %ebx,(%esp)
  1046f0:	e8 fb d4 ff ff       	call   101bf0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
  1046f5:	66 83 ff 02          	cmp    $0x2,%di
  1046f9:	75 07                	jne    104702 <create+0x72>
  1046fb:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
  104700:	74 0a                	je     10470c <create+0x7c>
      return ip;
    iunlockput(ip);
  104702:	89 1c 24             	mov    %ebx,(%esp)
  104705:	31 db                	xor    %ebx,%ebx
  104707:	e8 e4 d3 ff ff       	call   101af0 <iunlockput>
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);
  return ip;
}
  10470c:	89 d8                	mov    %ebx,%eax
  10470e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104711:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104714:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104717:	89 ec                	mov    %ebp,%esp
  104719:	5d                   	pop    %ebp
  10471a:	c3                   	ret    
  10471b:	90                   	nop    
  10471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  104720:	0f bf c7             	movswl %di,%eax
  104723:	89 44 24 04          	mov    %eax,0x4(%esp)
  104727:	8b 06                	mov    (%esi),%eax
  104729:	89 04 24             	mov    %eax,(%esp)
  10472c:	e8 df d3 ff ff       	call   101b10 <ialloc>
  104731:	85 c0                	test   %eax,%eax
  104733:	89 c3                	mov    %eax,%ebx
  104735:	0f 84 ac 00 00 00    	je     1047e7 <create+0x157>
    panic("create: ialloc");

  ilock(ip);
  10473b:	89 04 24             	mov    %eax,(%esp)
  10473e:	e8 ad d4 ff ff       	call   101bf0 <ilock>
  ip->major = major;
  104743:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104747:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  10474b:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
  ip->nlink = 1;
  10474f:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  104755:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104759:	89 1c 24             	mov    %ebx,(%esp)
  10475c:	e8 ef cc ff ff       	call   101450 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
  104761:	66 83 ef 01          	sub    $0x1,%di
  104765:	74 31                	je     104798 <create+0x108>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
  104767:	8b 43 04             	mov    0x4(%ebx),%eax
  10476a:	8d 4d e2             	lea    -0x1e(%ebp),%ecx
  10476d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104771:	89 34 24             	mov    %esi,(%esp)
  104774:	89 44 24 08          	mov    %eax,0x8(%esp)
  104778:	e8 83 d2 ff ff       	call   101a00 <dirlink>
  10477d:	85 c0                	test   %eax,%eax
  10477f:	78 72                	js     1047f3 <create+0x163>
    panic("create: dirlink");

  iunlockput(dp);
  104781:	89 34 24             	mov    %esi,(%esp)
  104784:	e8 67 d3 ff ff       	call   101af0 <iunlockput>
  104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104790:	e9 77 ff ff ff       	jmp    10470c <create+0x7c>
  104795:	8d 76 00             	lea    0x0(%esi),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104798:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  10479d:	89 34 24             	mov    %esi,(%esp)
  1047a0:	e8 ab cc ff ff       	call   101450 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1047a5:	8b 43 04             	mov    0x4(%ebx),%eax
  1047a8:	c7 44 24 04 44 66 10 	movl   $0x106644,0x4(%esp)
  1047af:	00 
  1047b0:	89 1c 24             	mov    %ebx,(%esp)
  1047b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047b7:	e8 44 d2 ff ff       	call   101a00 <dirlink>
  1047bc:	85 c0                	test   %eax,%eax
  1047be:	78 1b                	js     1047db <create+0x14b>
  1047c0:	8b 46 04             	mov    0x4(%esi),%eax
  1047c3:	c7 44 24 04 43 66 10 	movl   $0x106643,0x4(%esp)
  1047ca:	00 
  1047cb:	89 1c 24             	mov    %ebx,(%esp)
  1047ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047d2:	e8 29 d2 ff ff       	call   101a00 <dirlink>
  1047d7:	85 c0                	test   %eax,%eax
  1047d9:	79 8c                	jns    104767 <create+0xd7>
      panic("create dots");
  1047db:	c7 04 24 46 66 10 00 	movl   $0x106646,(%esp)
  1047e2:	e8 99 c0 ff ff       	call   100880 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
  1047e7:	c7 04 24 34 66 10 00 	movl   $0x106634,(%esp)
  1047ee:	e8 8d c0 ff ff       	call   100880 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
  1047f3:	c7 04 24 52 66 10 00 	movl   $0x106652,(%esp)
  1047fa:	e8 81 c0 ff ff       	call   100880 <panic>
  1047ff:	90                   	nop    

00104800 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
  104800:	55                   	push   %ebp
  104801:	89 e5                	mov    %esp,%ebp
  104803:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104806:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104809:	89 44 24 04          	mov    %eax,0x4(%esp)
  10480d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104814:	e8 77 fa ff ff       	call   104290 <argstr>
  104819:	85 c0                	test   %eax,%eax
  10481b:	79 0b                	jns    104828 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10481d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104822:	c9                   	leave  
  104823:	c3                   	ret    
  104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104828:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10482b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10482f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104836:	e8 c5 f9 ff ff       	call   104200 <argint>
  10483b:	85 c0                	test   %eax,%eax
  10483d:	78 de                	js     10481d <sys_mknod+0x1d>
  10483f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104842:	89 44 24 04          	mov    %eax,0x4(%esp)
  104846:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10484d:	e8 ae f9 ff ff       	call   104200 <argint>
  104852:	85 c0                	test   %eax,%eax
  104854:	78 c7                	js     10481d <sys_mknod+0x1d>
  104856:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  10485a:	0f bf 4d f8          	movswl -0x8(%ebp),%ecx
  10485e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104861:	89 14 24             	mov    %edx,(%esp)
  104864:	ba 03 00 00 00       	mov    $0x3,%edx
  104869:	e8 22 fe ff ff       	call   104690 <create>
  10486e:	85 c0                	test   %eax,%eax
  104870:	74 ab                	je     10481d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104872:	89 04 24             	mov    %eax,(%esp)
  104875:	e8 76 d2 ff ff       	call   101af0 <iunlockput>
  10487a:	31 c0                	xor    %eax,%eax
  return 0;
}
  10487c:	c9                   	leave  
  10487d:	8d 76 00             	lea    0x0(%esi),%esi
  104880:	c3                   	ret    
  104881:	eb 0d                	jmp    104890 <sys_mkdir>
  104883:	90                   	nop    
  104884:	90                   	nop    
  104885:	90                   	nop    
  104886:	90                   	nop    
  104887:	90                   	nop    
  104888:	90                   	nop    
  104889:	90                   	nop    
  10488a:	90                   	nop    
  10488b:	90                   	nop    
  10488c:	90                   	nop    
  10488d:	90                   	nop    
  10488e:	90                   	nop    
  10488f:	90                   	nop    

00104890 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
  104890:	55                   	push   %ebp
  104891:	89 e5                	mov    %esp,%ebp
  104893:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  104896:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104899:	89 44 24 04          	mov    %eax,0x4(%esp)
  10489d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048a4:	e8 e7 f9 ff ff       	call   104290 <argstr>
  1048a9:	85 c0                	test   %eax,%eax
  1048ab:	79 0b                	jns    1048b8 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  1048ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048b2:	c9                   	leave  
  1048b3:	c3                   	ret    
  1048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  1048b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1048bb:	31 c9                	xor    %ecx,%ecx
  1048bd:	ba 01 00 00 00       	mov    $0x1,%edx
  1048c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048c9:	e8 c2 fd ff ff       	call   104690 <create>
  1048ce:	85 c0                	test   %eax,%eax
  1048d0:	74 db                	je     1048ad <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1048d2:	89 04 24             	mov    %eax,(%esp)
  1048d5:	e8 16 d2 ff ff       	call   101af0 <iunlockput>
  1048da:	31 c0                	xor    %eax,%eax
  return 0;
}
  1048dc:	c9                   	leave  
  1048dd:	8d 76 00             	lea    0x0(%esi),%esi
  1048e0:	c3                   	ret    
  1048e1:	eb 0d                	jmp    1048f0 <sys_link>
  1048e3:	90                   	nop    
  1048e4:	90                   	nop    
  1048e5:	90                   	nop    
  1048e6:	90                   	nop    
  1048e7:	90                   	nop    
  1048e8:	90                   	nop    
  1048e9:	90                   	nop    
  1048ea:	90                   	nop    
  1048eb:	90                   	nop    
  1048ec:	90                   	nop    
  1048ed:	90                   	nop    
  1048ee:	90                   	nop    
  1048ef:	90                   	nop    

001048f0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  1048f0:	55                   	push   %ebp
  1048f1:	89 e5                	mov    %esp,%ebp
  1048f3:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  1048f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  1048f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1048fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1048ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104902:	89 44 24 04          	mov    %eax,0x4(%esp)
  104906:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10490d:	e8 7e f9 ff ff       	call   104290 <argstr>
  104912:	85 c0                	test   %eax,%eax
  104914:	79 12                	jns    104928 <sys_link+0x38>
bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104916:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10491b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10491e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104921:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104924:	89 ec                	mov    %ebp,%esp
  104926:	5d                   	pop    %ebp
  104927:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104928:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10492b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10492f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104936:	e8 55 f9 ff ff       	call   104290 <argstr>
  10493b:	85 c0                	test   %eax,%eax
  10493d:	78 d7                	js     104916 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  10493f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104942:	89 04 24             	mov    %eax,(%esp)
  104945:	e8 56 d5 ff ff       	call   101ea0 <namei>
  10494a:	85 c0                	test   %eax,%eax
  10494c:	89 c3                	mov    %eax,%ebx
  10494e:	74 c6                	je     104916 <sys_link+0x26>
    return -1;
  ilock(ip);
  104950:	89 04 24             	mov    %eax,(%esp)
  104953:	e8 98 d2 ff ff       	call   101bf0 <ilock>
  if(ip->type == T_DIR){
  104958:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10495d:	74 58                	je     1049b7 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  10495f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104964:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104967:	89 1c 24             	mov    %ebx,(%esp)
  10496a:	e8 e1 ca ff ff       	call   101450 <iupdate>
  iunlock(ip);
  10496f:	89 1c 24             	mov    %ebx,(%esp)
  104972:	e8 e9 cd ff ff       	call   101760 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10497a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  10497e:	89 04 24             	mov    %eax,(%esp)
  104981:	e8 fa d4 ff ff       	call   101e80 <nameiparent>
  104986:	85 c0                	test   %eax,%eax
  104988:	89 c6                	mov    %eax,%esi
  10498a:	74 16                	je     1049a2 <sys_link+0xb2>
    goto bad;
  ilock(dp);
  10498c:	89 04 24             	mov    %eax,(%esp)
  10498f:	e8 5c d2 ff ff       	call   101bf0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
  104994:	8b 06                	mov    (%esi),%eax
  104996:	3b 03                	cmp    (%ebx),%eax
  104998:	74 2f                	je     1049c9 <sys_link+0xd9>
    iunlockput(dp);
  10499a:	89 34 24             	mov    %esi,(%esp)
  10499d:	e8 4e d1 ff ff       	call   101af0 <iunlockput>
  iunlockput(dp);
  iput(ip);
  return 0;

bad:
  ilock(ip);
  1049a2:	89 1c 24             	mov    %ebx,(%esp)
  1049a5:	e8 46 d2 ff ff       	call   101bf0 <ilock>
  ip->nlink--;
  1049aa:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  1049af:	89 1c 24             	mov    %ebx,(%esp)
  1049b2:	e8 99 ca ff ff       	call   101450 <iupdate>
  iunlockput(ip);
  1049b7:	89 1c 24             	mov    %ebx,(%esp)
  1049ba:	e8 31 d1 ff ff       	call   101af0 <iunlockput>
  1049bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1049c4:	e9 52 ff ff ff       	jmp    10491b <sys_link+0x2b>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
  1049c9:	8b 43 04             	mov    0x4(%ebx),%eax
  1049cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1049d0:	89 34 24             	mov    %esi,(%esp)
  1049d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1049d7:	e8 24 d0 ff ff       	call   101a00 <dirlink>
  1049dc:	85 c0                	test   %eax,%eax
  1049de:	78 ba                	js     10499a <sys_link+0xaa>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  1049e0:	89 34 24             	mov    %esi,(%esp)
  1049e3:	e8 08 d1 ff ff       	call   101af0 <iunlockput>
  iput(ip);
  1049e8:	89 1c 24             	mov    %ebx,(%esp)
  1049eb:	e8 a0 ce ff ff       	call   101890 <iput>
  1049f0:	31 c0                	xor    %eax,%eax
  1049f2:	e9 24 ff ff ff       	jmp    10491b <sys_link+0x2b>
  1049f7:	89 f6                	mov    %esi,%esi
  1049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104a00 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104a00:	55                   	push   %ebp
  104a01:	89 e5                	mov    %esp,%ebp
  104a03:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104a09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104a0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104a0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a1d:	e8 6e f8 ff ff       	call   104290 <argstr>
  104a22:	85 c0                	test   %eax,%eax
  104a24:	79 1a                	jns    104a40 <sys_open+0x40>

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  104a26:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
}
  104a2b:	89 d8                	mov    %ebx,%eax
  104a2d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104a30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104a33:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104a36:	89 ec                	mov    %ebp,%esp
  104a38:	5d                   	pop    %ebp
  104a39:	c3                   	ret    
  104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a40:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a4e:	e8 ad f7 ff ff       	call   104200 <argint>
  104a53:	85 c0                	test   %eax,%eax
  104a55:	78 cf                	js     104a26 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  104a57:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  104a5b:	74 63                	je     104ac0 <sys_open+0xc0>
    if((ip = create(path, T_FILE, 0, 0)) == 0)
  104a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a60:	31 c9                	xor    %ecx,%ecx
  104a62:	ba 02 00 00 00       	mov    $0x2,%edx
  104a67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a6e:	e8 1d fc ff ff       	call   104690 <create>
  104a73:	85 c0                	test   %eax,%eax
  104a75:	89 c7                	mov    %eax,%edi
  104a77:	74 ad                	je     104a26 <sys_open+0x26>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104a79:	e8 52 c4 ff ff       	call   100ed0 <filealloc>
  104a7e:	85 c0                	test   %eax,%eax
  104a80:	89 c6                	mov    %eax,%esi
  104a82:	74 24                	je     104aa8 <sys_open+0xa8>
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104a84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104a8a:	31 db                	xor    %ebx,%ebx
  104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104a90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
  104a94:	85 d2                	test   %edx,%edx
  104a96:	74 60                	je     104af8 <sys_open+0xf8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104a98:	83 c3 01             	add    $0x1,%ebx
  104a9b:	83 fb 10             	cmp    $0x10,%ebx
  104a9e:	75 f0                	jne    104a90 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104aa0:	89 34 24             	mov    %esi,(%esp)
  104aa3:	e8 98 c4 ff ff       	call   100f40 <fileclose>
    iunlockput(ip);
  104aa8:	89 3c 24             	mov    %edi,(%esp)
  104aab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104ab0:	e8 3b d0 ff ff       	call   101af0 <iunlockput>
  104ab5:	e9 71 ff ff ff       	jmp    104a2b <sys_open+0x2b>
  104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ac3:	89 04 24             	mov    %eax,(%esp)
  104ac6:	e8 d5 d3 ff ff       	call   101ea0 <namei>
  104acb:	85 c0                	test   %eax,%eax
  104acd:	89 c7                	mov    %eax,%edi
  104acf:	0f 84 51 ff ff ff    	je     104a26 <sys_open+0x26>
      return -1;
    ilock(ip);
  104ad5:	89 04 24             	mov    %eax,(%esp)
  104ad8:	e8 13 d1 ff ff       	call   101bf0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
  104add:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  104ae2:	75 95                	jne    104a79 <sys_open+0x79>
  104ae4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  104ae7:	85 c9                	test   %ecx,%ecx
  104ae9:	74 8e                	je     104a79 <sys_open+0x79>
  104aeb:	90                   	nop    
  104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104af0:	eb b6                	jmp    104aa8 <sys_open+0xa8>
  104af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104af8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104afc:	89 3c 24             	mov    %edi,(%esp)
  104aff:	e8 5c cc ff ff       	call   101760 <iunlock>

  f->type = FD_INODE;
  104b04:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  104b0a:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  104b0d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  104b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b17:	83 f0 01             	xor    $0x1,%eax
  104b1a:	83 e0 01             	and    $0x1,%eax
  104b1d:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104b20:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  104b24:	0f 95 46 09          	setne  0x9(%esi)
  104b28:	e9 fe fe ff ff       	jmp    104a2b <sys_open+0x2b>
  104b2d:	8d 76 00             	lea    0x0(%esi),%esi

00104b30 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104b36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104b39:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b3c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b3f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b4d:	e8 3e f7 ff ff       	call   104290 <argstr>
  104b52:	85 c0                	test   %eax,%eax
  104b54:	79 12                	jns    104b68 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  104b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104b61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104b64:	89 ec                	mov    %ebp,%esp
  104b66:	5d                   	pop    %ebp
  104b67:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  104b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b6b:	8d 5d de             	lea    -0x22(%ebp),%ebx
  104b6e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104b72:	89 04 24             	mov    %eax,(%esp)
  104b75:	e8 06 d3 ff ff       	call   101e80 <nameiparent>
  104b7a:	85 c0                	test   %eax,%eax
  104b7c:	89 c7                	mov    %eax,%edi
  104b7e:	74 d6                	je     104b56 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  104b80:	89 04 24             	mov    %eax,(%esp)
  104b83:	e8 68 d0 ff ff       	call   101bf0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  104b88:	c7 44 24 04 44 66 10 	movl   $0x106644,0x4(%esp)
  104b8f:	00 
  104b90:	89 1c 24             	mov    %ebx,(%esp)
  104b93:	e8 88 ca ff ff       	call   101620 <namecmp>
  104b98:	85 c0                	test   %eax,%eax
  104b9a:	74 14                	je     104bb0 <sys_unlink+0x80>
  104b9c:	c7 44 24 04 43 66 10 	movl   $0x106643,0x4(%esp)
  104ba3:	00 
  104ba4:	89 1c 24             	mov    %ebx,(%esp)
  104ba7:	e8 74 ca ff ff       	call   101620 <namecmp>
  104bac:	85 c0                	test   %eax,%eax
  104bae:	75 18                	jne    104bc8 <sys_unlink+0x98>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  104bb0:	89 3c 24             	mov    %edi,(%esp)
  104bb3:	e8 38 cf ff ff       	call   101af0 <iunlockput>
  104bb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104bbd:	8d 76 00             	lea    0x0(%esi),%esi
  104bc0:	eb 99                	jmp    104b5b <sys_unlink+0x2b>
  104bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  104bc8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104bcb:	89 44 24 08          	mov    %eax,0x8(%esp)
  104bcf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104bd3:	89 3c 24             	mov    %edi,(%esp)
  104bd6:	e8 75 ca ff ff       	call   101650 <dirlookup>
  104bdb:	85 c0                	test   %eax,%eax
  104bdd:	89 c6                	mov    %eax,%esi
  104bdf:	74 cf                	je     104bb0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  104be1:	89 04 24             	mov    %eax,(%esp)
  104be4:	e8 07 d0 ff ff       	call   101bf0 <ilock>

  if(ip->nlink < 1)
  104be9:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  104bee:	0f 8e fe 00 00 00    	jle    104cf2 <sys_unlink+0x1c2>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  104bf4:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c00:	75 5b                	jne    104c5d <sys_unlink+0x12d>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  104c02:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  104c06:	66 90                	xchg   %ax,%ax
  104c08:	76 53                	jbe    104c5d <sys_unlink+0x12d>
  104c0a:	bb 20 00 00 00       	mov    $0x20,%ebx
  104c0f:	90                   	nop    
  104c10:	eb 10                	jmp    104c22 <sys_unlink+0xf2>
  104c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104c18:	83 c3 10             	add    $0x10,%ebx
  104c1b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  104c1e:	66 90                	xchg   %ax,%ax
  104c20:	73 3b                	jae    104c5d <sys_unlink+0x12d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104c22:	8d 45 be             	lea    -0x42(%ebp),%eax
  104c25:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104c2c:	00 
  104c2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c35:	89 34 24             	mov    %esi,(%esp)
  104c38:	e8 03 c7 ff ff       	call   101340 <readi>
  104c3d:	83 f8 10             	cmp    $0x10,%eax
  104c40:	0f 85 94 00 00 00    	jne    104cda <sys_unlink+0x1aa>
      panic("isdirempty: readi");
    if(de.inum != 0)
  104c46:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  104c4b:	74 cb                	je     104c18 <sys_unlink+0xe8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  104c4d:	89 34 24             	mov    %esi,(%esp)
  104c50:	e8 9b ce ff ff       	call   101af0 <iunlockput>
  104c55:	8d 76 00             	lea    0x0(%esi),%esi
  104c58:	e9 53 ff ff ff       	jmp    104bb0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  104c5d:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  104c60:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104c67:	00 
  104c68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c6f:	00 
  104c70:	89 1c 24             	mov    %ebx,(%esp)
  104c73:	e8 d8 f2 ff ff       	call   103f50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c7b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104c82:	00 
  104c83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104c87:	89 3c 24             	mov    %edi,(%esp)
  104c8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  104c8e:	e8 4d c8 ff ff       	call   1014e0 <writei>
  104c93:	83 f8 10             	cmp    $0x10,%eax
  104c96:	75 4e                	jne    104ce6 <sys_unlink+0x1b6>
    panic("unlink: writei");
  if(ip->type == T_DIR){
  104c98:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104c9d:	74 2a                	je     104cc9 <sys_unlink+0x199>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
  104c9f:	89 3c 24             	mov    %edi,(%esp)
  104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104ca8:	e8 43 ce ff ff       	call   101af0 <iunlockput>

  ip->nlink--;
  104cad:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  104cb2:	89 34 24             	mov    %esi,(%esp)
  104cb5:	e8 96 c7 ff ff       	call   101450 <iupdate>
  iunlockput(ip);
  104cba:	89 34 24             	mov    %esi,(%esp)
  104cbd:	e8 2e ce ff ff       	call   101af0 <iunlockput>
  104cc2:	31 c0                	xor    %eax,%eax
  104cc4:	e9 92 fe ff ff       	jmp    104b5b <sys_unlink+0x2b>

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
  104cc9:	66 83 6f 16 01       	subw   $0x1,0x16(%edi)
    iupdate(dp);
  104cce:	89 3c 24             	mov    %edi,(%esp)
  104cd1:	e8 7a c7 ff ff       	call   101450 <iupdate>
  104cd6:	66 90                	xchg   %ax,%ax
  104cd8:	eb c5                	jmp    104c9f <sys_unlink+0x16f>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  104cda:	c7 04 24 74 66 10 00 	movl   $0x106674,(%esp)
  104ce1:	e8 9a bb ff ff       	call   100880 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  104ce6:	c7 04 24 86 66 10 00 	movl   $0x106686,(%esp)
  104ced:	e8 8e bb ff ff       	call   100880 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  104cf2:	c7 04 24 62 66 10 00 	movl   $0x106662,(%esp)
  104cf9:	e8 82 bb ff ff       	call   100880 <panic>
  104cfe:	66 90                	xchg   %ax,%ax

00104d00 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  104d00:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d01:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  104d03:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d05:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  104d07:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d0a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104d0d:	e8 5e f7 ff ff       	call   104470 <argfd>
  104d12:	85 c0                	test   %eax,%eax
  104d14:	79 0a                	jns    104d20 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  104d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d1b:	c9                   	leave  
  104d1c:	c3                   	ret    
  104d1d:	8d 76 00             	lea    0x0(%esi),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d20:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104d23:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  104d2a:	00 
  104d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d36:	e8 05 f5 ff ff       	call   104240 <argptr>
  104d3b:	85 c0                	test   %eax,%eax
  104d3d:	78 d7                	js     104d16 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  104d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104d42:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104d49:	89 04 24             	mov    %eax,(%esp)
  104d4c:	e8 df c0 ff ff       	call   100e30 <filestat>
}
  104d51:	c9                   	leave  
  104d52:	c3                   	ret    
  104d53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104d60 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104d60:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d61:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104d63:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d65:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104d67:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d6a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104d6d:	e8 fe f6 ff ff       	call   104470 <argfd>
  104d72:	85 c0                	test   %eax,%eax
  104d74:	79 0a                	jns    104d80 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  104d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d7b:	c9                   	leave  
  104d7c:	c3                   	ret    
  104d7d:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d80:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d87:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104d8e:	e8 6d f4 ff ff       	call   104200 <argint>
  104d93:	85 c0                	test   %eax,%eax
  104d95:	78 df                	js     104d76 <sys_write+0x16>
  104d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104d9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104da1:	89 44 24 08          	mov    %eax,0x8(%esp)
  104da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  104dac:	e8 8f f4 ff ff       	call   104240 <argptr>
  104db1:	85 c0                	test   %eax,%eax
  104db3:	78 c1                	js     104d76 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  104db5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104db8:	89 44 24 08          	mov    %eax,0x8(%esp)
  104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  104dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104dc6:	89 04 24             	mov    %eax,(%esp)
  104dc9:	e8 02 bf ff ff       	call   100cd0 <filewrite>
}
  104dce:	c9                   	leave  
  104dcf:	c3                   	ret    

00104dd0 <sys_read>:
  return fd;
}

int
sys_read(void)
{
  104dd0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104dd1:	31 d2                	xor    %edx,%edx
  return fd;
}

int
sys_read(void)
{
  104dd3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104dd5:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
  104dd7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104dda:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104ddd:	e8 8e f6 ff ff       	call   104470 <argfd>
  104de2:	85 c0                	test   %eax,%eax
  104de4:	79 0a                	jns    104df0 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  104de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104deb:	c9                   	leave  
  104dec:	c3                   	ret    
  104ded:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104df0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104df3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104df7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104dfe:	e8 fd f3 ff ff       	call   104200 <argint>
  104e03:	85 c0                	test   %eax,%eax
  104e05:	78 df                	js     104de6 <sys_read+0x16>
  104e07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104e0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e11:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e1c:	e8 1f f4 ff ff       	call   104240 <argptr>
  104e21:	85 c0                	test   %eax,%eax
  104e23:	78 c1                	js     104de6 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  104e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104e28:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104e36:	89 04 24             	mov    %eax,(%esp)
  104e39:	e8 42 bf ff ff       	call   100d80 <fileread>
}
  104e3e:	c9                   	leave  
  104e3f:	c3                   	ret    

00104e40 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
  104e40:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104e41:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_dup(void)
{
  104e43:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104e45:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
  104e47:	53                   	push   %ebx
  104e48:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104e4b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104e4e:	e8 1d f6 ff ff       	call   104470 <argfd>
  104e53:	85 c0                	test   %eax,%eax
  104e55:	79 11                	jns    104e68 <sys_dup+0x28>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104e57:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
  104e5c:	89 d8                	mov    %ebx,%eax
  104e5e:	83 c4 14             	add    $0x14,%esp
  104e61:	5b                   	pop    %ebx
  104e62:	5d                   	pop    %ebp
  104e63:	c3                   	ret    
  104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  104e68:	8b 55 f8             	mov    -0x8(%ebp),%edx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104e6b:	31 db                	xor    %ebx,%ebx
  104e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104e73:	eb 0b                	jmp    104e80 <sys_dup+0x40>
  104e75:	8d 76 00             	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104e78:	83 c3 01             	add    $0x1,%ebx
  104e7b:	83 fb 10             	cmp    $0x10,%ebx
  104e7e:	74 d7                	je     104e57 <sys_dup+0x17>
    if(proc->ofile[fd] == 0){
  104e80:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
  104e84:	85 c9                	test   %ecx,%ecx
  104e86:	75 f0                	jne    104e78 <sys_dup+0x38>
      proc->ofile[fd] = f;
  104e88:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  104e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104e8f:	89 04 24             	mov    %eax,(%esp)
  104e92:	e8 e9 bf ff ff       	call   100e80 <filedup>
  104e97:	eb c3                	jmp    104e5c <sys_dup+0x1c>
  104e99:	90                   	nop    
  104e9a:	90                   	nop    
  104e9b:	90                   	nop    
  104e9c:	90                   	nop    
  104e9d:	90                   	nop    
  104e9e:	90                   	nop    
  104e9f:	90                   	nop    

00104ea0 <sys_getpid>:
}

int
sys_getpid(void)
{
  return proc->pid;
  104ea0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
  104ea6:	55                   	push   %ebp
  104ea7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
  104ea9:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
  104eaa:	8b 40 10             	mov    0x10(%eax),%eax
}
  104ead:	c3                   	ret    
  104eae:	66 90                	xchg   %ax,%ax

00104eb0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  104eb0:	55                   	push   %ebp
  104eb1:	89 e5                	mov    %esp,%ebp
  104eb3:	53                   	push   %ebx
  104eb4:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  104eb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104eba:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ebe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ec5:	e8 36 f3 ff ff       	call   104200 <argint>
  104eca:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104ecf:	85 c0                	test   %eax,%eax
  104ed1:	78 5b                	js     104f2e <sys_sleep+0x7e>
    return -1;
  acquire(&tickslock);
  104ed3:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  104eda:	e8 d1 ef ff ff       	call   103eb0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104edf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  104ee2:	8b 1d e0 df 10 00    	mov    0x10dfe0,%ebx
  while(ticks - ticks0 < n){
  104ee8:	85 d2                	test   %edx,%edx
  104eea:	7f 24                	jg     104f10 <sys_sleep+0x60>
  104eec:	eb 4a                	jmp    104f38 <sys_sleep+0x88>
  104eee:	66 90                	xchg   %ax,%ax
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  104ef0:	c7 44 24 04 a0 d7 10 	movl   $0x10d7a0,0x4(%esp)
  104ef7:	00 
  104ef8:	c7 04 24 e0 df 10 00 	movl   $0x10dfe0,(%esp)
  104eff:	e8 1c e5 ff ff       	call   103420 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104f04:	a1 e0 df 10 00       	mov    0x10dfe0,%eax
  104f09:	29 d8                	sub    %ebx,%eax
  104f0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  104f0e:	7d 28                	jge    104f38 <sys_sleep+0x88>
    if(proc->killed){
  104f10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104f16:	8b 40 24             	mov    0x24(%eax),%eax
  104f19:	85 c0                	test   %eax,%eax
  104f1b:	74 d3                	je     104ef0 <sys_sleep+0x40>
      release(&tickslock);
  104f1d:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  104f24:	e8 37 ef ff ff       	call   103e60 <release>
  104f29:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  104f2e:	83 c4 24             	add    $0x24,%esp
  104f31:	89 d0                	mov    %edx,%eax
  104f33:	5b                   	pop    %ebx
  104f34:	5d                   	pop    %ebp
  104f35:	c3                   	ret    
  104f36:	66 90                	xchg   %ax,%ax
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  104f38:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  104f3f:	e8 1c ef ff ff       	call   103e60 <release>
  104f44:	31 d2                	xor    %edx,%edx
  return 0;
}
  104f46:	83 c4 24             	add    $0x24,%esp
  104f49:	89 d0                	mov    %edx,%eax
  104f4b:	5b                   	pop    %ebx
  104f4c:	5d                   	pop    %ebp
  104f4d:	c3                   	ret    
  104f4e:	66 90                	xchg   %ax,%ax

00104f50 <sys_sbrk>:
  return proc->pid;
}

int
sys_sbrk(void)
{
  104f50:	55                   	push   %ebp
  104f51:	89 e5                	mov    %esp,%ebp
  104f53:	53                   	push   %ebx
  104f54:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  104f57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f65:	e8 96 f2 ff ff       	call   104200 <argint>
  104f6a:	85 c0                	test   %eax,%eax
  104f6c:	79 12                	jns    104f80 <sys_sbrk+0x30>
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
  104f6e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  104f73:	83 c4 24             	add    $0x24,%esp
  104f76:	89 d0                	mov    %edx,%eax
  104f78:	5b                   	pop    %ebx
  104f79:	5d                   	pop    %ebp
  104f7a:	c3                   	ret    
  104f7b:	90                   	nop    
  104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  104f80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104f86:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc(n) < 0)
  104f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104f8c:	89 04 24             	mov    %eax,(%esp)
  104f8f:	e8 2c eb ff ff       	call   103ac0 <growproc>
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  104f94:	89 da                	mov    %ebx,%edx
  if(growproc(n) < 0)
  104f96:	85 c0                	test   %eax,%eax
  104f98:	79 d9                	jns    104f73 <sys_sbrk+0x23>
  104f9a:	eb d2                	jmp    104f6e <sys_sbrk+0x1e>
  104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104fa0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  104fa0:	55                   	push   %ebp
  104fa1:	89 e5                	mov    %esp,%ebp
  104fa3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  104fa6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fb4:	e8 47 f2 ff ff       	call   104200 <argint>
  104fb9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104fbe:	85 c0                	test   %eax,%eax
  104fc0:	78 0d                	js     104fcf <sys_kill+0x2f>
    return -1;
  return kill(pid);
  104fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104fc5:	89 04 24             	mov    %eax,(%esp)
  104fc8:	e8 83 e1 ff ff       	call   103150 <kill>
  104fcd:	89 c2                	mov    %eax,%edx
}
  104fcf:	89 d0                	mov    %edx,%eax
  104fd1:	c9                   	leave  
  104fd2:	c3                   	ret    
  104fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104fe0 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
  104fe0:	55                   	push   %ebp
  104fe1:	89 e5                	mov    %esp,%ebp
  return wait();
}
  104fe3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  104fe4:	e9 07 e5 ff ff       	jmp    1034f0 <wait>
  104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104ff0 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
  104ff0:	55                   	push   %ebp
  104ff1:	89 e5                	mov    %esp,%ebp
  104ff3:	83 ec 08             	sub    $0x8,%esp
  exit();
  104ff6:	e8 f5 e2 ff ff       	call   1032f0 <exit>
  return 0;  // not reached
}
  104ffb:	31 c0                	xor    %eax,%eax
  104ffd:	c9                   	leave  
  104ffe:	c3                   	ret    
  104fff:	90                   	nop    

00105000 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105000:	55                   	push   %ebp
  105001:	89 e5                	mov    %esp,%ebp
  return fork();
}
  105003:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
  105004:	e9 07 e7 ff ff       	jmp    103710 <fork>
  105009:	90                   	nop    
  10500a:	90                   	nop    
  10500b:	90                   	nop    
  10500c:	90                   	nop    
  10500d:	90                   	nop    
  10500e:	90                   	nop    
  10500f:	90                   	nop    

00105010 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
  105010:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105011:	ba 43 00 00 00       	mov    $0x43,%edx
  105016:	89 e5                	mov    %esp,%ebp
  105018:	b8 34 00 00 00       	mov    $0x34,%eax
  10501d:	83 ec 08             	sub    $0x8,%esp
  105020:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
  105021:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105026:	b2 40                	mov    $0x40,%dl
  105028:	ee                   	out    %al,(%dx)
  105029:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10502e:	ee                   	out    %al,(%dx)
  10502f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105036:	e8 95 dc ff ff       	call   102cd0 <picenable>
}
  10503b:	c9                   	leave  
  10503c:	c3                   	ret    
  10503d:	90                   	nop    
  10503e:	90                   	nop    
  10503f:	90                   	nop    

00105040 <alltraps>:
  105040:	1e                   	push   %ds
  105041:	06                   	push   %es
  105042:	0f a0                	push   %fs
  105044:	0f a8                	push   %gs
  105046:	60                   	pusha  
  105047:	66 b8 10 00          	mov    $0x10,%ax
  10504b:	8e d8                	mov    %eax,%ds
  10504d:	8e c0                	mov    %eax,%es
  10504f:	66 b8 18 00          	mov    $0x18,%ax
  105053:	8e e0                	mov    %eax,%fs
  105055:	8e e8                	mov    %eax,%gs
  105057:	54                   	push   %esp
  105058:	e8 43 00 00 00       	call   1050a0 <trap>
  10505d:	83 c4 04             	add    $0x4,%esp

00105060 <trapret>:
  105060:	61                   	popa   
  105061:	0f a9                	pop    %gs
  105063:	0f a1                	pop    %fs
  105065:	07                   	pop    %es
  105066:	1f                   	pop    %ds
  105067:	83 c4 08             	add    $0x8,%esp
  10506a:	cf                   	iret   
  10506b:	90                   	nop    
  10506c:	90                   	nop    
  10506d:	90                   	nop    
  10506e:	90                   	nop    
  10506f:	90                   	nop    

00105070 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105070:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105071:	b8 e0 d7 10 00       	mov    $0x10d7e0,%eax
  105076:	89 e5                	mov    %esp,%ebp
  105078:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10507b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105081:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105085:	c1 e8 10             	shr    $0x10,%eax
  105088:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10508c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10508f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105092:	c9                   	leave  
  105093:	c3                   	ret    
  105094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10509a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001050a0 <trap>:

void
trap(struct trapframe *tf)
{
  1050a0:	55                   	push   %ebp
  1050a1:	89 e5                	mov    %esp,%ebp
  1050a3:	56                   	push   %esi
  1050a4:	53                   	push   %ebx
  1050a5:	83 ec 20             	sub    $0x20,%esp
  1050a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
  1050ab:	8b 4b 30             	mov    0x30(%ebx),%ecx
  1050ae:	83 f9 40             	cmp    $0x40,%ecx
  1050b1:	74 55                	je     105108 <trap+0x68>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1050b3:	8d 41 e0             	lea    -0x20(%ecx),%eax
  1050b6:	83 f8 1f             	cmp    $0x1f,%eax
  1050b9:	76 45                	jbe    105100 <trap+0x60>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
  1050bb:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
  1050c2:	85 f6                	test   %esi,%esi
  1050c4:	74 0a                	je     1050d0 <trap+0x30>
  1050c6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
  1050ca:	0f 85 c8 01 00 00    	jne    105298 <trap+0x1f8>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  1050d0:	8b 43 38             	mov    0x38(%ebx),%eax
  1050d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1050d7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1050dd:	0f b6 00             	movzbl (%eax),%eax
  1050e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1050e4:	c7 04 24 bc 66 10 00 	movl   $0x1066bc,(%esp)
  1050eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050ef:	e8 ac b3 ff ff       	call   1004a0 <cprintf>
              tf->trapno, cpu->id, tf->eip);
      panic("trap");
  1050f4:	c7 04 24 20 67 10 00 	movl   $0x106720,(%esp)
  1050fb:	e8 80 b7 ff ff       	call   100880 <panic>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105100:	ff 24 85 2c 67 10 00 	jmp    *0x10672c(,%eax,4)
  105107:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
  105108:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10510f:	8b 72 24             	mov    0x24(%edx),%esi
  105112:	85 f6                	test   %esi,%esi
  105114:	0f 85 3e 01 00 00    	jne    105258 <trap+0x1b8>
      exit();
    proc->tf = tf;
  10511a:	89 5a 18             	mov    %ebx,0x18(%edx)
    syscall();
  10511d:	e8 ee f1 ff ff       	call   104310 <syscall>
    if(proc->killed)
  105122:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105128:	8b 58 24             	mov    0x24(%eax),%ebx
  10512b:	85 db                	test   %ebx,%ebx
  10512d:	75 50                	jne    10517f <trap+0xdf>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
  10512f:	83 c4 20             	add    $0x20,%esp
  105132:	5b                   	pop    %ebx
  105133:	5e                   	pop    %esi
  105134:	5d                   	pop    %ebp
  105135:	c3                   	ret    
  105136:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  105138:	e8 23 cf ff ff       	call   102060 <ideintr>
    lapiceoi();
  10513d:	e8 ce d5 ff ff       	call   102710 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  105142:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  105149:	85 d2                	test   %edx,%edx
  10514b:	74 e2                	je     10512f <trap+0x8f>
  10514d:	8b 4a 24             	mov    0x24(%edx),%ecx
  105150:	85 c9                	test   %ecx,%ecx
  105152:	74 10                	je     105164 <trap+0xc4>
  105154:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  105158:	83 e0 03             	and    $0x3,%eax
  10515b:	83 f8 03             	cmp    $0x3,%eax
  10515e:	0f 84 14 01 00 00    	je     105278 <trap+0x1d8>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  105164:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
  105168:	74 26                	je     105190 <trap+0xf0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  10516a:	89 d0                	mov    %edx,%eax
  10516c:	8b 40 24             	mov    0x24(%eax),%eax
  10516f:	85 c0                	test   %eax,%eax
  105171:	74 bc                	je     10512f <trap+0x8f>
  105173:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  105177:	83 e0 03             	and    $0x3,%eax
  10517a:	83 f8 03             	cmp    $0x3,%eax
  10517d:	75 b0                	jne    10512f <trap+0x8f>
    exit();
}
  10517f:	83 c4 20             	add    $0x20,%esp
  105182:	5b                   	pop    %ebx
  105183:	5e                   	pop    %esi
  105184:	5d                   	pop    %ebp
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  105185:	e9 66 e1 ff ff       	jmp    1032f0 <exit>
  10518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  105190:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
  105194:	75 d4                	jne    10516a <trap+0xca>
    yield();
  105196:	e8 55 e4 ff ff       	call   1035f0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  10519b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1051a1:	85 c0                	test   %eax,%eax
  1051a3:	75 c7                	jne    10516c <trap+0xcc>
  1051a5:	eb 88                	jmp    10512f <trap+0x8f>
  1051a7:	90                   	nop    
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
  1051a8:	e8 03 d4 ff ff       	call   1025b0 <kbdintr>
  1051ad:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  1051b0:	e8 5b d5 ff ff       	call   102710 <lapiceoi>
  1051b5:	8d 76 00             	lea    0x0(%esi),%esi
  1051b8:	eb 88                	jmp    105142 <trap+0xa2>
  1051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
  1051c0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1051c6:	80 38 00             	cmpb   $0x0,(%eax)
  1051c9:	0f 85 6e ff ff ff    	jne    10513d <trap+0x9d>
      acquire(&tickslock);
  1051cf:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  1051d6:	e8 d5 ec ff ff       	call   103eb0 <acquire>
      ticks++;
  1051db:	83 05 e0 df 10 00 01 	addl   $0x1,0x10dfe0
      wakeup(&ticks);
  1051e2:	c7 04 24 e0 df 10 00 	movl   $0x10dfe0,(%esp)
  1051e9:	e8 e2 df ff ff       	call   1031d0 <wakeup>
      release(&tickslock);
  1051ee:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  1051f5:	e8 66 ec ff ff       	call   103e60 <release>
  1051fa:	e9 3e ff ff ff       	jmp    10513d <trap+0x9d>
  1051ff:	90                   	nop    
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105200:	8b 43 38             	mov    0x38(%ebx),%eax
  105203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105207:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  10520b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10520f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  105215:	0f b6 00             	movzbl (%eax),%eax
  105218:	c7 04 24 98 66 10 00 	movl   $0x106698,(%esp)
  10521f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105223:	e8 78 b2 ff ff       	call   1004a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
  105228:	e8 e3 d4 ff ff       	call   102710 <lapiceoi>
  10522d:	e9 10 ff ff ff       	jmp    105142 <trap+0xa2>
  105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105238:	90                   	nop    
  105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  105240:	e8 6b 01 00 00       	call   1053b0 <uartintr>
  105245:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105248:	e8 c3 d4 ff ff       	call   102710 <lapiceoi>
  10524d:	8d 76 00             	lea    0x0(%esi),%esi
  105250:	e9 ed fe ff ff       	jmp    105142 <trap+0xa2>
  105255:	8d 76 00             	lea    0x0(%esi),%esi
  105258:	90                   	nop    
  105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
  105260:	e8 8b e0 ff ff       	call   1032f0 <exit>
  105265:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105270:	e9 a5 fe ff ff       	jmp    10511a <trap+0x7a>
  105275:	8d 76 00             	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  105278:	e8 73 e0 ff ff       	call   1032f0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  10527d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  105284:	85 d2                	test   %edx,%edx
  105286:	0f 85 d8 fe ff ff    	jne    105164 <trap+0xc4>
  10528c:	e9 9e fe ff ff       	jmp    10512f <trap+0x8f>
  105291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu->id, tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105298:	8b 43 38             	mov    0x38(%ebx),%eax
  10529b:	8b 56 10             	mov    0x10(%esi),%edx
  10529e:	89 44 24 18          	mov    %eax,0x18(%esp)
  1052a2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1052a8:	0f b6 00             	movzbl (%eax),%eax
  1052ab:	89 44 24 14          	mov    %eax,0x14(%esp)
  1052af:	8b 43 34             	mov    0x34(%ebx),%eax
  1052b2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1052b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052ba:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1052c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1052c5:	8d 46 6c             	lea    0x6c(%esi),%eax
  1052c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052cc:	e8 cf b1 ff ff       	call   1004a0 <cprintf>
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip);
    proc->killed = 1;
  1052d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1052d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  1052de:	e9 5f fe ff ff       	jmp    105142 <trap+0xa2>
  1052e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052f0 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  1052f0:	55                   	push   %ebp
  1052f1:	31 d2                	xor    %edx,%edx
  1052f3:	89 e5                	mov    %esp,%ebp
  1052f5:	b9 e0 d7 10 00       	mov    $0x10d7e0,%ecx
  1052fa:	83 ec 08             	sub    $0x8,%esp
  1052fd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105300:	8b 04 95 c8 7a 10 00 	mov    0x107ac8(,%edx,4),%eax
  105307:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
  10530e:	66 89 04 d5 e0 d7 10 	mov    %ax,0x10d7e0(,%edx,8)
  105315:	00 
  105316:	c1 e8 10             	shr    $0x10,%eax
  105319:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
  10531e:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
  105323:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105328:	83 c2 01             	add    $0x1,%edx
  10532b:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  105331:	75 cd                	jne    105300 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105333:	a1 c8 7b 10 00       	mov    0x107bc8,%eax
  
  initlock(&tickslock, "time");
  105338:	c7 44 24 04 25 67 10 	movl   $0x106725,0x4(%esp)
  10533f:	00 
  105340:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105347:	66 c7 05 e2 d9 10 00 	movw   $0x8,0x10d9e2
  10534e:	08 00 
  105350:	66 a3 e0 d9 10 00    	mov    %ax,0x10d9e0
  105356:	c1 e8 10             	shr    $0x10,%eax
  105359:	c6 05 e4 d9 10 00 00 	movb   $0x0,0x10d9e4
  105360:	c6 05 e5 d9 10 00 ef 	movb   $0xef,0x10d9e5
  105367:	66 a3 e6 d9 10 00    	mov    %ax,0x10d9e6
  
  initlock(&tickslock, "time");
  10536d:	e8 ae e9 ff ff       	call   103d20 <initlock>
}
  105372:	c9                   	leave  
  105373:	c3                   	ret    
  105374:	90                   	nop    
  105375:	90                   	nop    
  105376:	90                   	nop    
  105377:	90                   	nop    
  105378:	90                   	nop    
  105379:	90                   	nop    
  10537a:	90                   	nop    
  10537b:	90                   	nop    
  10537c:	90                   	nop    
  10537d:	90                   	nop    
  10537e:	90                   	nop    
  10537f:	90                   	nop    

00105380 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
  105380:	a1 0c 80 10 00       	mov    0x10800c,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
  105385:	55                   	push   %ebp
  105386:	89 e5                	mov    %esp,%ebp
  if(!uart)
  105388:	85 c0                	test   %eax,%eax
  10538a:	75 0c                	jne    105398 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
  10538c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105391:	5d                   	pop    %ebp
  105392:	c3                   	ret    
  105393:	90                   	nop    
  105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  105398:	ba fd 03 00 00       	mov    $0x3fd,%edx
  10539d:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
  10539e:	a8 01                	test   $0x1,%al
  1053a0:	74 ea                	je     10538c <uartgetc+0xc>
  1053a2:	b2 f8                	mov    $0xf8,%dl
  1053a4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  1053a5:	0f b6 c0             	movzbl %al,%eax
}
  1053a8:	5d                   	pop    %ebp
  1053a9:	c3                   	ret    
  1053aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001053b0 <uartintr>:

void
uartintr(void)
{
  1053b0:	55                   	push   %ebp
  1053b1:	89 e5                	mov    %esp,%ebp
  1053b3:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
  1053b6:	c7 04 24 80 53 10 00 	movl   $0x105380,(%esp)
  1053bd:	e8 4e b3 ff ff       	call   100710 <consoleintr>
}
  1053c2:	c9                   	leave  
  1053c3:	c3                   	ret    
  1053c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1053ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001053d0 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
  1053d0:	55                   	push   %ebp
  1053d1:	89 e5                	mov    %esp,%ebp
  1053d3:	56                   	push   %esi
  1053d4:	be fd 03 00 00       	mov    $0x3fd,%esi
  1053d9:	53                   	push   %ebx
  int i;

  if(!uart)
    return;
  1053da:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
  1053dc:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  1053df:	8b 15 0c 80 10 00    	mov    0x10800c,%edx
  1053e5:	85 d2                	test   %edx,%edx
  1053e7:	75 21                	jne    10540a <uartputc+0x3a>
  1053e9:	eb 30                	jmp    10541b <uartputc+0x4b>
  1053eb:	90                   	nop    
  1053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  1053f0:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
  1053f3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1053fa:	e8 31 d3 ff ff       	call   102730 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  1053ff:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  105405:	8d 76 00             	lea    0x0(%esi),%esi
  105408:	74 07                	je     105411 <uartputc+0x41>
  10540a:	89 f2                	mov    %esi,%edx
  10540c:	ec                   	in     (%dx),%al
  10540d:	a8 20                	test   $0x20,%al
  10540f:	74 df                	je     1053f0 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105411:	ba f8 03 00 00       	mov    $0x3f8,%edx
  105416:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  10541a:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
  10541b:	83 c4 10             	add    $0x10,%esp
  10541e:	5b                   	pop    %ebx
  10541f:	5e                   	pop    %esi
  105420:	5d                   	pop    %ebp
  105421:	c3                   	ret    
  105422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105430 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  105430:	55                   	push   %ebp
  105431:	31 c9                	xor    %ecx,%ecx
  105433:	89 e5                	mov    %esp,%ebp
  105435:	89 c8                	mov    %ecx,%eax
  105437:	57                   	push   %edi
  105438:	bf fa 03 00 00       	mov    $0x3fa,%edi
  10543d:	56                   	push   %esi
  10543e:	89 fa                	mov    %edi,%edx
  105440:	53                   	push   %ebx
  105441:	83 ec 0c             	sub    $0xc,%esp
  105444:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  105445:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  10544a:	b2 fb                	mov    $0xfb,%dl
  10544c:	ee                   	out    %al,(%dx)
  10544d:	be f8 03 00 00       	mov    $0x3f8,%esi
  105452:	b8 0c 00 00 00       	mov    $0xc,%eax
  105457:	89 f2                	mov    %esi,%edx
  105459:	ee                   	out    %al,(%dx)
  10545a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
  10545f:	89 c8                	mov    %ecx,%eax
  105461:	89 da                	mov    %ebx,%edx
  105463:	ee                   	out    %al,(%dx)
  105464:	b8 03 00 00 00       	mov    $0x3,%eax
  105469:	b2 fb                	mov    $0xfb,%dl
  10546b:	ee                   	out    %al,(%dx)
  10546c:	b2 fc                	mov    $0xfc,%dl
  10546e:	89 c8                	mov    %ecx,%eax
  105470:	ee                   	out    %al,(%dx)
  105471:	b8 01 00 00 00       	mov    $0x1,%eax
  105476:	89 da                	mov    %ebx,%edx
  105478:	ee                   	out    %al,(%dx)
  105479:	b2 fd                	mov    $0xfd,%dl
  10547b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  10547c:	04 01                	add    $0x1,%al
  10547e:	74 55                	je     1054d5 <uartinit+0xa5>
    return;
  uart = 1;
  105480:	c7 05 0c 80 10 00 01 	movl   $0x1,0x10800c
  105487:	00 00 00 
  10548a:	89 fa                	mov    %edi,%edx
  10548c:	ec                   	in     (%dx),%al
  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  10548d:	89 f2                	mov    %esi,%edx
  10548f:	ec                   	in     (%dx),%al
  105490:	bb ac 67 10 00       	mov    $0x1067ac,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  105495:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10549c:	e8 2f d8 ff ff       	call   102cd0 <picenable>
  ioapicenable(IRQ_COM1, 0);
  1054a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1054a8:	00 
  1054a9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1054b0:	e8 0b cd ff ff       	call   1021c0 <ioapicenable>
  1054b5:	b8 78 00 00 00       	mov    $0x78,%eax
  1054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
  1054c0:	0f be c0             	movsbl %al,%eax
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1054c3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
  1054c6:	89 04 24             	mov    %eax,(%esp)
  1054c9:	e8 02 ff ff ff       	call   1053d0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1054ce:	0f b6 03             	movzbl (%ebx),%eax
  1054d1:	84 c0                	test   %al,%al
  1054d3:	75 eb                	jne    1054c0 <uartinit+0x90>
    uartputc(*p);
}
  1054d5:	83 c4 0c             	add    $0xc,%esp
  1054d8:	5b                   	pop    %ebx
  1054d9:	5e                   	pop    %esi
  1054da:	5f                   	pop    %edi
  1054db:	5d                   	pop    %ebp
  1054dc:	c3                   	ret    
  1054dd:	90                   	nop    
  1054de:	90                   	nop    
  1054df:	90                   	nop    

001054e0 <vector0>:
  1054e0:	6a 00                	push   $0x0
  1054e2:	6a 00                	push   $0x0
  1054e4:	e9 57 fb ff ff       	jmp    105040 <alltraps>

001054e9 <vector1>:
  1054e9:	6a 00                	push   $0x0
  1054eb:	6a 01                	push   $0x1
  1054ed:	e9 4e fb ff ff       	jmp    105040 <alltraps>

001054f2 <vector2>:
  1054f2:	6a 00                	push   $0x0
  1054f4:	6a 02                	push   $0x2
  1054f6:	e9 45 fb ff ff       	jmp    105040 <alltraps>

001054fb <vector3>:
  1054fb:	6a 00                	push   $0x0
  1054fd:	6a 03                	push   $0x3
  1054ff:	e9 3c fb ff ff       	jmp    105040 <alltraps>

00105504 <vector4>:
  105504:	6a 00                	push   $0x0
  105506:	6a 04                	push   $0x4
  105508:	e9 33 fb ff ff       	jmp    105040 <alltraps>

0010550d <vector5>:
  10550d:	6a 00                	push   $0x0
  10550f:	6a 05                	push   $0x5
  105511:	e9 2a fb ff ff       	jmp    105040 <alltraps>

00105516 <vector6>:
  105516:	6a 00                	push   $0x0
  105518:	6a 06                	push   $0x6
  10551a:	e9 21 fb ff ff       	jmp    105040 <alltraps>

0010551f <vector7>:
  10551f:	6a 00                	push   $0x0
  105521:	6a 07                	push   $0x7
  105523:	e9 18 fb ff ff       	jmp    105040 <alltraps>

00105528 <vector8>:
  105528:	6a 08                	push   $0x8
  10552a:	e9 11 fb ff ff       	jmp    105040 <alltraps>

0010552f <vector9>:
  10552f:	6a 00                	push   $0x0
  105531:	6a 09                	push   $0x9
  105533:	e9 08 fb ff ff       	jmp    105040 <alltraps>

00105538 <vector10>:
  105538:	6a 0a                	push   $0xa
  10553a:	e9 01 fb ff ff       	jmp    105040 <alltraps>

0010553f <vector11>:
  10553f:	6a 0b                	push   $0xb
  105541:	e9 fa fa ff ff       	jmp    105040 <alltraps>

00105546 <vector12>:
  105546:	6a 0c                	push   $0xc
  105548:	e9 f3 fa ff ff       	jmp    105040 <alltraps>

0010554d <vector13>:
  10554d:	6a 0d                	push   $0xd
  10554f:	e9 ec fa ff ff       	jmp    105040 <alltraps>

00105554 <vector14>:
  105554:	6a 0e                	push   $0xe
  105556:	e9 e5 fa ff ff       	jmp    105040 <alltraps>

0010555b <vector15>:
  10555b:	6a 00                	push   $0x0
  10555d:	6a 0f                	push   $0xf
  10555f:	e9 dc fa ff ff       	jmp    105040 <alltraps>

00105564 <vector16>:
  105564:	6a 00                	push   $0x0
  105566:	6a 10                	push   $0x10
  105568:	e9 d3 fa ff ff       	jmp    105040 <alltraps>

0010556d <vector17>:
  10556d:	6a 11                	push   $0x11
  10556f:	e9 cc fa ff ff       	jmp    105040 <alltraps>

00105574 <vector18>:
  105574:	6a 00                	push   $0x0
  105576:	6a 12                	push   $0x12
  105578:	e9 c3 fa ff ff       	jmp    105040 <alltraps>

0010557d <vector19>:
  10557d:	6a 00                	push   $0x0
  10557f:	6a 13                	push   $0x13
  105581:	e9 ba fa ff ff       	jmp    105040 <alltraps>

00105586 <vector20>:
  105586:	6a 00                	push   $0x0
  105588:	6a 14                	push   $0x14
  10558a:	e9 b1 fa ff ff       	jmp    105040 <alltraps>

0010558f <vector21>:
  10558f:	6a 00                	push   $0x0
  105591:	6a 15                	push   $0x15
  105593:	e9 a8 fa ff ff       	jmp    105040 <alltraps>

00105598 <vector22>:
  105598:	6a 00                	push   $0x0
  10559a:	6a 16                	push   $0x16
  10559c:	e9 9f fa ff ff       	jmp    105040 <alltraps>

001055a1 <vector23>:
  1055a1:	6a 00                	push   $0x0
  1055a3:	6a 17                	push   $0x17
  1055a5:	e9 96 fa ff ff       	jmp    105040 <alltraps>

001055aa <vector24>:
  1055aa:	6a 00                	push   $0x0
  1055ac:	6a 18                	push   $0x18
  1055ae:	e9 8d fa ff ff       	jmp    105040 <alltraps>

001055b3 <vector25>:
  1055b3:	6a 00                	push   $0x0
  1055b5:	6a 19                	push   $0x19
  1055b7:	e9 84 fa ff ff       	jmp    105040 <alltraps>

001055bc <vector26>:
  1055bc:	6a 00                	push   $0x0
  1055be:	6a 1a                	push   $0x1a
  1055c0:	e9 7b fa ff ff       	jmp    105040 <alltraps>

001055c5 <vector27>:
  1055c5:	6a 00                	push   $0x0
  1055c7:	6a 1b                	push   $0x1b
  1055c9:	e9 72 fa ff ff       	jmp    105040 <alltraps>

001055ce <vector28>:
  1055ce:	6a 00                	push   $0x0
  1055d0:	6a 1c                	push   $0x1c
  1055d2:	e9 69 fa ff ff       	jmp    105040 <alltraps>

001055d7 <vector29>:
  1055d7:	6a 00                	push   $0x0
  1055d9:	6a 1d                	push   $0x1d
  1055db:	e9 60 fa ff ff       	jmp    105040 <alltraps>

001055e0 <vector30>:
  1055e0:	6a 00                	push   $0x0
  1055e2:	6a 1e                	push   $0x1e
  1055e4:	e9 57 fa ff ff       	jmp    105040 <alltraps>

001055e9 <vector31>:
  1055e9:	6a 00                	push   $0x0
  1055eb:	6a 1f                	push   $0x1f
  1055ed:	e9 4e fa ff ff       	jmp    105040 <alltraps>

001055f2 <vector32>:
  1055f2:	6a 00                	push   $0x0
  1055f4:	6a 20                	push   $0x20
  1055f6:	e9 45 fa ff ff       	jmp    105040 <alltraps>

001055fb <vector33>:
  1055fb:	6a 00                	push   $0x0
  1055fd:	6a 21                	push   $0x21
  1055ff:	e9 3c fa ff ff       	jmp    105040 <alltraps>

00105604 <vector34>:
  105604:	6a 00                	push   $0x0
  105606:	6a 22                	push   $0x22
  105608:	e9 33 fa ff ff       	jmp    105040 <alltraps>

0010560d <vector35>:
  10560d:	6a 00                	push   $0x0
  10560f:	6a 23                	push   $0x23
  105611:	e9 2a fa ff ff       	jmp    105040 <alltraps>

00105616 <vector36>:
  105616:	6a 00                	push   $0x0
  105618:	6a 24                	push   $0x24
  10561a:	e9 21 fa ff ff       	jmp    105040 <alltraps>

0010561f <vector37>:
  10561f:	6a 00                	push   $0x0
  105621:	6a 25                	push   $0x25
  105623:	e9 18 fa ff ff       	jmp    105040 <alltraps>

00105628 <vector38>:
  105628:	6a 00                	push   $0x0
  10562a:	6a 26                	push   $0x26
  10562c:	e9 0f fa ff ff       	jmp    105040 <alltraps>

00105631 <vector39>:
  105631:	6a 00                	push   $0x0
  105633:	6a 27                	push   $0x27
  105635:	e9 06 fa ff ff       	jmp    105040 <alltraps>

0010563a <vector40>:
  10563a:	6a 00                	push   $0x0
  10563c:	6a 28                	push   $0x28
  10563e:	e9 fd f9 ff ff       	jmp    105040 <alltraps>

00105643 <vector41>:
  105643:	6a 00                	push   $0x0
  105645:	6a 29                	push   $0x29
  105647:	e9 f4 f9 ff ff       	jmp    105040 <alltraps>

0010564c <vector42>:
  10564c:	6a 00                	push   $0x0
  10564e:	6a 2a                	push   $0x2a
  105650:	e9 eb f9 ff ff       	jmp    105040 <alltraps>

00105655 <vector43>:
  105655:	6a 00                	push   $0x0
  105657:	6a 2b                	push   $0x2b
  105659:	e9 e2 f9 ff ff       	jmp    105040 <alltraps>

0010565e <vector44>:
  10565e:	6a 00                	push   $0x0
  105660:	6a 2c                	push   $0x2c
  105662:	e9 d9 f9 ff ff       	jmp    105040 <alltraps>

00105667 <vector45>:
  105667:	6a 00                	push   $0x0
  105669:	6a 2d                	push   $0x2d
  10566b:	e9 d0 f9 ff ff       	jmp    105040 <alltraps>

00105670 <vector46>:
  105670:	6a 00                	push   $0x0
  105672:	6a 2e                	push   $0x2e
  105674:	e9 c7 f9 ff ff       	jmp    105040 <alltraps>

00105679 <vector47>:
  105679:	6a 00                	push   $0x0
  10567b:	6a 2f                	push   $0x2f
  10567d:	e9 be f9 ff ff       	jmp    105040 <alltraps>

00105682 <vector48>:
  105682:	6a 00                	push   $0x0
  105684:	6a 30                	push   $0x30
  105686:	e9 b5 f9 ff ff       	jmp    105040 <alltraps>

0010568b <vector49>:
  10568b:	6a 00                	push   $0x0
  10568d:	6a 31                	push   $0x31
  10568f:	e9 ac f9 ff ff       	jmp    105040 <alltraps>

00105694 <vector50>:
  105694:	6a 00                	push   $0x0
  105696:	6a 32                	push   $0x32
  105698:	e9 a3 f9 ff ff       	jmp    105040 <alltraps>

0010569d <vector51>:
  10569d:	6a 00                	push   $0x0
  10569f:	6a 33                	push   $0x33
  1056a1:	e9 9a f9 ff ff       	jmp    105040 <alltraps>

001056a6 <vector52>:
  1056a6:	6a 00                	push   $0x0
  1056a8:	6a 34                	push   $0x34
  1056aa:	e9 91 f9 ff ff       	jmp    105040 <alltraps>

001056af <vector53>:
  1056af:	6a 00                	push   $0x0
  1056b1:	6a 35                	push   $0x35
  1056b3:	e9 88 f9 ff ff       	jmp    105040 <alltraps>

001056b8 <vector54>:
  1056b8:	6a 00                	push   $0x0
  1056ba:	6a 36                	push   $0x36
  1056bc:	e9 7f f9 ff ff       	jmp    105040 <alltraps>

001056c1 <vector55>:
  1056c1:	6a 00                	push   $0x0
  1056c3:	6a 37                	push   $0x37
  1056c5:	e9 76 f9 ff ff       	jmp    105040 <alltraps>

001056ca <vector56>:
  1056ca:	6a 00                	push   $0x0
  1056cc:	6a 38                	push   $0x38
  1056ce:	e9 6d f9 ff ff       	jmp    105040 <alltraps>

001056d3 <vector57>:
  1056d3:	6a 00                	push   $0x0
  1056d5:	6a 39                	push   $0x39
  1056d7:	e9 64 f9 ff ff       	jmp    105040 <alltraps>

001056dc <vector58>:
  1056dc:	6a 00                	push   $0x0
  1056de:	6a 3a                	push   $0x3a
  1056e0:	e9 5b f9 ff ff       	jmp    105040 <alltraps>

001056e5 <vector59>:
  1056e5:	6a 00                	push   $0x0
  1056e7:	6a 3b                	push   $0x3b
  1056e9:	e9 52 f9 ff ff       	jmp    105040 <alltraps>

001056ee <vector60>:
  1056ee:	6a 00                	push   $0x0
  1056f0:	6a 3c                	push   $0x3c
  1056f2:	e9 49 f9 ff ff       	jmp    105040 <alltraps>

001056f7 <vector61>:
  1056f7:	6a 00                	push   $0x0
  1056f9:	6a 3d                	push   $0x3d
  1056fb:	e9 40 f9 ff ff       	jmp    105040 <alltraps>

00105700 <vector62>:
  105700:	6a 00                	push   $0x0
  105702:	6a 3e                	push   $0x3e
  105704:	e9 37 f9 ff ff       	jmp    105040 <alltraps>

00105709 <vector63>:
  105709:	6a 00                	push   $0x0
  10570b:	6a 3f                	push   $0x3f
  10570d:	e9 2e f9 ff ff       	jmp    105040 <alltraps>

00105712 <vector64>:
  105712:	6a 00                	push   $0x0
  105714:	6a 40                	push   $0x40
  105716:	e9 25 f9 ff ff       	jmp    105040 <alltraps>

0010571b <vector65>:
  10571b:	6a 00                	push   $0x0
  10571d:	6a 41                	push   $0x41
  10571f:	e9 1c f9 ff ff       	jmp    105040 <alltraps>

00105724 <vector66>:
  105724:	6a 00                	push   $0x0
  105726:	6a 42                	push   $0x42
  105728:	e9 13 f9 ff ff       	jmp    105040 <alltraps>

0010572d <vector67>:
  10572d:	6a 00                	push   $0x0
  10572f:	6a 43                	push   $0x43
  105731:	e9 0a f9 ff ff       	jmp    105040 <alltraps>

00105736 <vector68>:
  105736:	6a 00                	push   $0x0
  105738:	6a 44                	push   $0x44
  10573a:	e9 01 f9 ff ff       	jmp    105040 <alltraps>

0010573f <vector69>:
  10573f:	6a 00                	push   $0x0
  105741:	6a 45                	push   $0x45
  105743:	e9 f8 f8 ff ff       	jmp    105040 <alltraps>

00105748 <vector70>:
  105748:	6a 00                	push   $0x0
  10574a:	6a 46                	push   $0x46
  10574c:	e9 ef f8 ff ff       	jmp    105040 <alltraps>

00105751 <vector71>:
  105751:	6a 00                	push   $0x0
  105753:	6a 47                	push   $0x47
  105755:	e9 e6 f8 ff ff       	jmp    105040 <alltraps>

0010575a <vector72>:
  10575a:	6a 00                	push   $0x0
  10575c:	6a 48                	push   $0x48
  10575e:	e9 dd f8 ff ff       	jmp    105040 <alltraps>

00105763 <vector73>:
  105763:	6a 00                	push   $0x0
  105765:	6a 49                	push   $0x49
  105767:	e9 d4 f8 ff ff       	jmp    105040 <alltraps>

0010576c <vector74>:
  10576c:	6a 00                	push   $0x0
  10576e:	6a 4a                	push   $0x4a
  105770:	e9 cb f8 ff ff       	jmp    105040 <alltraps>

00105775 <vector75>:
  105775:	6a 00                	push   $0x0
  105777:	6a 4b                	push   $0x4b
  105779:	e9 c2 f8 ff ff       	jmp    105040 <alltraps>

0010577e <vector76>:
  10577e:	6a 00                	push   $0x0
  105780:	6a 4c                	push   $0x4c
  105782:	e9 b9 f8 ff ff       	jmp    105040 <alltraps>

00105787 <vector77>:
  105787:	6a 00                	push   $0x0
  105789:	6a 4d                	push   $0x4d
  10578b:	e9 b0 f8 ff ff       	jmp    105040 <alltraps>

00105790 <vector78>:
  105790:	6a 00                	push   $0x0
  105792:	6a 4e                	push   $0x4e
  105794:	e9 a7 f8 ff ff       	jmp    105040 <alltraps>

00105799 <vector79>:
  105799:	6a 00                	push   $0x0
  10579b:	6a 4f                	push   $0x4f
  10579d:	e9 9e f8 ff ff       	jmp    105040 <alltraps>

001057a2 <vector80>:
  1057a2:	6a 00                	push   $0x0
  1057a4:	6a 50                	push   $0x50
  1057a6:	e9 95 f8 ff ff       	jmp    105040 <alltraps>

001057ab <vector81>:
  1057ab:	6a 00                	push   $0x0
  1057ad:	6a 51                	push   $0x51
  1057af:	e9 8c f8 ff ff       	jmp    105040 <alltraps>

001057b4 <vector82>:
  1057b4:	6a 00                	push   $0x0
  1057b6:	6a 52                	push   $0x52
  1057b8:	e9 83 f8 ff ff       	jmp    105040 <alltraps>

001057bd <vector83>:
  1057bd:	6a 00                	push   $0x0
  1057bf:	6a 53                	push   $0x53
  1057c1:	e9 7a f8 ff ff       	jmp    105040 <alltraps>

001057c6 <vector84>:
  1057c6:	6a 00                	push   $0x0
  1057c8:	6a 54                	push   $0x54
  1057ca:	e9 71 f8 ff ff       	jmp    105040 <alltraps>

001057cf <vector85>:
  1057cf:	6a 00                	push   $0x0
  1057d1:	6a 55                	push   $0x55
  1057d3:	e9 68 f8 ff ff       	jmp    105040 <alltraps>

001057d8 <vector86>:
  1057d8:	6a 00                	push   $0x0
  1057da:	6a 56                	push   $0x56
  1057dc:	e9 5f f8 ff ff       	jmp    105040 <alltraps>

001057e1 <vector87>:
  1057e1:	6a 00                	push   $0x0
  1057e3:	6a 57                	push   $0x57
  1057e5:	e9 56 f8 ff ff       	jmp    105040 <alltraps>

001057ea <vector88>:
  1057ea:	6a 00                	push   $0x0
  1057ec:	6a 58                	push   $0x58
  1057ee:	e9 4d f8 ff ff       	jmp    105040 <alltraps>

001057f3 <vector89>:
  1057f3:	6a 00                	push   $0x0
  1057f5:	6a 59                	push   $0x59
  1057f7:	e9 44 f8 ff ff       	jmp    105040 <alltraps>

001057fc <vector90>:
  1057fc:	6a 00                	push   $0x0
  1057fe:	6a 5a                	push   $0x5a
  105800:	e9 3b f8 ff ff       	jmp    105040 <alltraps>

00105805 <vector91>:
  105805:	6a 00                	push   $0x0
  105807:	6a 5b                	push   $0x5b
  105809:	e9 32 f8 ff ff       	jmp    105040 <alltraps>

0010580e <vector92>:
  10580e:	6a 00                	push   $0x0
  105810:	6a 5c                	push   $0x5c
  105812:	e9 29 f8 ff ff       	jmp    105040 <alltraps>

00105817 <vector93>:
  105817:	6a 00                	push   $0x0
  105819:	6a 5d                	push   $0x5d
  10581b:	e9 20 f8 ff ff       	jmp    105040 <alltraps>

00105820 <vector94>:
  105820:	6a 00                	push   $0x0
  105822:	6a 5e                	push   $0x5e
  105824:	e9 17 f8 ff ff       	jmp    105040 <alltraps>

00105829 <vector95>:
  105829:	6a 00                	push   $0x0
  10582b:	6a 5f                	push   $0x5f
  10582d:	e9 0e f8 ff ff       	jmp    105040 <alltraps>

00105832 <vector96>:
  105832:	6a 00                	push   $0x0
  105834:	6a 60                	push   $0x60
  105836:	e9 05 f8 ff ff       	jmp    105040 <alltraps>

0010583b <vector97>:
  10583b:	6a 00                	push   $0x0
  10583d:	6a 61                	push   $0x61
  10583f:	e9 fc f7 ff ff       	jmp    105040 <alltraps>

00105844 <vector98>:
  105844:	6a 00                	push   $0x0
  105846:	6a 62                	push   $0x62
  105848:	e9 f3 f7 ff ff       	jmp    105040 <alltraps>

0010584d <vector99>:
  10584d:	6a 00                	push   $0x0
  10584f:	6a 63                	push   $0x63
  105851:	e9 ea f7 ff ff       	jmp    105040 <alltraps>

00105856 <vector100>:
  105856:	6a 00                	push   $0x0
  105858:	6a 64                	push   $0x64
  10585a:	e9 e1 f7 ff ff       	jmp    105040 <alltraps>

0010585f <vector101>:
  10585f:	6a 00                	push   $0x0
  105861:	6a 65                	push   $0x65
  105863:	e9 d8 f7 ff ff       	jmp    105040 <alltraps>

00105868 <vector102>:
  105868:	6a 00                	push   $0x0
  10586a:	6a 66                	push   $0x66
  10586c:	e9 cf f7 ff ff       	jmp    105040 <alltraps>

00105871 <vector103>:
  105871:	6a 00                	push   $0x0
  105873:	6a 67                	push   $0x67
  105875:	e9 c6 f7 ff ff       	jmp    105040 <alltraps>

0010587a <vector104>:
  10587a:	6a 00                	push   $0x0
  10587c:	6a 68                	push   $0x68
  10587e:	e9 bd f7 ff ff       	jmp    105040 <alltraps>

00105883 <vector105>:
  105883:	6a 00                	push   $0x0
  105885:	6a 69                	push   $0x69
  105887:	e9 b4 f7 ff ff       	jmp    105040 <alltraps>

0010588c <vector106>:
  10588c:	6a 00                	push   $0x0
  10588e:	6a 6a                	push   $0x6a
  105890:	e9 ab f7 ff ff       	jmp    105040 <alltraps>

00105895 <vector107>:
  105895:	6a 00                	push   $0x0
  105897:	6a 6b                	push   $0x6b
  105899:	e9 a2 f7 ff ff       	jmp    105040 <alltraps>

0010589e <vector108>:
  10589e:	6a 00                	push   $0x0
  1058a0:	6a 6c                	push   $0x6c
  1058a2:	e9 99 f7 ff ff       	jmp    105040 <alltraps>

001058a7 <vector109>:
  1058a7:	6a 00                	push   $0x0
  1058a9:	6a 6d                	push   $0x6d
  1058ab:	e9 90 f7 ff ff       	jmp    105040 <alltraps>

001058b0 <vector110>:
  1058b0:	6a 00                	push   $0x0
  1058b2:	6a 6e                	push   $0x6e
  1058b4:	e9 87 f7 ff ff       	jmp    105040 <alltraps>

001058b9 <vector111>:
  1058b9:	6a 00                	push   $0x0
  1058bb:	6a 6f                	push   $0x6f
  1058bd:	e9 7e f7 ff ff       	jmp    105040 <alltraps>

001058c2 <vector112>:
  1058c2:	6a 00                	push   $0x0
  1058c4:	6a 70                	push   $0x70
  1058c6:	e9 75 f7 ff ff       	jmp    105040 <alltraps>

001058cb <vector113>:
  1058cb:	6a 00                	push   $0x0
  1058cd:	6a 71                	push   $0x71
  1058cf:	e9 6c f7 ff ff       	jmp    105040 <alltraps>

001058d4 <vector114>:
  1058d4:	6a 00                	push   $0x0
  1058d6:	6a 72                	push   $0x72
  1058d8:	e9 63 f7 ff ff       	jmp    105040 <alltraps>

001058dd <vector115>:
  1058dd:	6a 00                	push   $0x0
  1058df:	6a 73                	push   $0x73
  1058e1:	e9 5a f7 ff ff       	jmp    105040 <alltraps>

001058e6 <vector116>:
  1058e6:	6a 00                	push   $0x0
  1058e8:	6a 74                	push   $0x74
  1058ea:	e9 51 f7 ff ff       	jmp    105040 <alltraps>

001058ef <vector117>:
  1058ef:	6a 00                	push   $0x0
  1058f1:	6a 75                	push   $0x75
  1058f3:	e9 48 f7 ff ff       	jmp    105040 <alltraps>

001058f8 <vector118>:
  1058f8:	6a 00                	push   $0x0
  1058fa:	6a 76                	push   $0x76
  1058fc:	e9 3f f7 ff ff       	jmp    105040 <alltraps>

00105901 <vector119>:
  105901:	6a 00                	push   $0x0
  105903:	6a 77                	push   $0x77
  105905:	e9 36 f7 ff ff       	jmp    105040 <alltraps>

0010590a <vector120>:
  10590a:	6a 00                	push   $0x0
  10590c:	6a 78                	push   $0x78
  10590e:	e9 2d f7 ff ff       	jmp    105040 <alltraps>

00105913 <vector121>:
  105913:	6a 00                	push   $0x0
  105915:	6a 79                	push   $0x79
  105917:	e9 24 f7 ff ff       	jmp    105040 <alltraps>

0010591c <vector122>:
  10591c:	6a 00                	push   $0x0
  10591e:	6a 7a                	push   $0x7a
  105920:	e9 1b f7 ff ff       	jmp    105040 <alltraps>

00105925 <vector123>:
  105925:	6a 00                	push   $0x0
  105927:	6a 7b                	push   $0x7b
  105929:	e9 12 f7 ff ff       	jmp    105040 <alltraps>

0010592e <vector124>:
  10592e:	6a 00                	push   $0x0
  105930:	6a 7c                	push   $0x7c
  105932:	e9 09 f7 ff ff       	jmp    105040 <alltraps>

00105937 <vector125>:
  105937:	6a 00                	push   $0x0
  105939:	6a 7d                	push   $0x7d
  10593b:	e9 00 f7 ff ff       	jmp    105040 <alltraps>

00105940 <vector126>:
  105940:	6a 00                	push   $0x0
  105942:	6a 7e                	push   $0x7e
  105944:	e9 f7 f6 ff ff       	jmp    105040 <alltraps>

00105949 <vector127>:
  105949:	6a 00                	push   $0x0
  10594b:	6a 7f                	push   $0x7f
  10594d:	e9 ee f6 ff ff       	jmp    105040 <alltraps>

00105952 <vector128>:
  105952:	6a 00                	push   $0x0
  105954:	68 80 00 00 00       	push   $0x80
  105959:	e9 e2 f6 ff ff       	jmp    105040 <alltraps>

0010595e <vector129>:
  10595e:	6a 00                	push   $0x0
  105960:	68 81 00 00 00       	push   $0x81
  105965:	e9 d6 f6 ff ff       	jmp    105040 <alltraps>

0010596a <vector130>:
  10596a:	6a 00                	push   $0x0
  10596c:	68 82 00 00 00       	push   $0x82
  105971:	e9 ca f6 ff ff       	jmp    105040 <alltraps>

00105976 <vector131>:
  105976:	6a 00                	push   $0x0
  105978:	68 83 00 00 00       	push   $0x83
  10597d:	e9 be f6 ff ff       	jmp    105040 <alltraps>

00105982 <vector132>:
  105982:	6a 00                	push   $0x0
  105984:	68 84 00 00 00       	push   $0x84
  105989:	e9 b2 f6 ff ff       	jmp    105040 <alltraps>

0010598e <vector133>:
  10598e:	6a 00                	push   $0x0
  105990:	68 85 00 00 00       	push   $0x85
  105995:	e9 a6 f6 ff ff       	jmp    105040 <alltraps>

0010599a <vector134>:
  10599a:	6a 00                	push   $0x0
  10599c:	68 86 00 00 00       	push   $0x86
  1059a1:	e9 9a f6 ff ff       	jmp    105040 <alltraps>

001059a6 <vector135>:
  1059a6:	6a 00                	push   $0x0
  1059a8:	68 87 00 00 00       	push   $0x87
  1059ad:	e9 8e f6 ff ff       	jmp    105040 <alltraps>

001059b2 <vector136>:
  1059b2:	6a 00                	push   $0x0
  1059b4:	68 88 00 00 00       	push   $0x88
  1059b9:	e9 82 f6 ff ff       	jmp    105040 <alltraps>

001059be <vector137>:
  1059be:	6a 00                	push   $0x0
  1059c0:	68 89 00 00 00       	push   $0x89
  1059c5:	e9 76 f6 ff ff       	jmp    105040 <alltraps>

001059ca <vector138>:
  1059ca:	6a 00                	push   $0x0
  1059cc:	68 8a 00 00 00       	push   $0x8a
  1059d1:	e9 6a f6 ff ff       	jmp    105040 <alltraps>

001059d6 <vector139>:
  1059d6:	6a 00                	push   $0x0
  1059d8:	68 8b 00 00 00       	push   $0x8b
  1059dd:	e9 5e f6 ff ff       	jmp    105040 <alltraps>

001059e2 <vector140>:
  1059e2:	6a 00                	push   $0x0
  1059e4:	68 8c 00 00 00       	push   $0x8c
  1059e9:	e9 52 f6 ff ff       	jmp    105040 <alltraps>

001059ee <vector141>:
  1059ee:	6a 00                	push   $0x0
  1059f0:	68 8d 00 00 00       	push   $0x8d
  1059f5:	e9 46 f6 ff ff       	jmp    105040 <alltraps>

001059fa <vector142>:
  1059fa:	6a 00                	push   $0x0
  1059fc:	68 8e 00 00 00       	push   $0x8e
  105a01:	e9 3a f6 ff ff       	jmp    105040 <alltraps>

00105a06 <vector143>:
  105a06:	6a 00                	push   $0x0
  105a08:	68 8f 00 00 00       	push   $0x8f
  105a0d:	e9 2e f6 ff ff       	jmp    105040 <alltraps>

00105a12 <vector144>:
  105a12:	6a 00                	push   $0x0
  105a14:	68 90 00 00 00       	push   $0x90
  105a19:	e9 22 f6 ff ff       	jmp    105040 <alltraps>

00105a1e <vector145>:
  105a1e:	6a 00                	push   $0x0
  105a20:	68 91 00 00 00       	push   $0x91
  105a25:	e9 16 f6 ff ff       	jmp    105040 <alltraps>

00105a2a <vector146>:
  105a2a:	6a 00                	push   $0x0
  105a2c:	68 92 00 00 00       	push   $0x92
  105a31:	e9 0a f6 ff ff       	jmp    105040 <alltraps>

00105a36 <vector147>:
  105a36:	6a 00                	push   $0x0
  105a38:	68 93 00 00 00       	push   $0x93
  105a3d:	e9 fe f5 ff ff       	jmp    105040 <alltraps>

00105a42 <vector148>:
  105a42:	6a 00                	push   $0x0
  105a44:	68 94 00 00 00       	push   $0x94
  105a49:	e9 f2 f5 ff ff       	jmp    105040 <alltraps>

00105a4e <vector149>:
  105a4e:	6a 00                	push   $0x0
  105a50:	68 95 00 00 00       	push   $0x95
  105a55:	e9 e6 f5 ff ff       	jmp    105040 <alltraps>

00105a5a <vector150>:
  105a5a:	6a 00                	push   $0x0
  105a5c:	68 96 00 00 00       	push   $0x96
  105a61:	e9 da f5 ff ff       	jmp    105040 <alltraps>

00105a66 <vector151>:
  105a66:	6a 00                	push   $0x0
  105a68:	68 97 00 00 00       	push   $0x97
  105a6d:	e9 ce f5 ff ff       	jmp    105040 <alltraps>

00105a72 <vector152>:
  105a72:	6a 00                	push   $0x0
  105a74:	68 98 00 00 00       	push   $0x98
  105a79:	e9 c2 f5 ff ff       	jmp    105040 <alltraps>

00105a7e <vector153>:
  105a7e:	6a 00                	push   $0x0
  105a80:	68 99 00 00 00       	push   $0x99
  105a85:	e9 b6 f5 ff ff       	jmp    105040 <alltraps>

00105a8a <vector154>:
  105a8a:	6a 00                	push   $0x0
  105a8c:	68 9a 00 00 00       	push   $0x9a
  105a91:	e9 aa f5 ff ff       	jmp    105040 <alltraps>

00105a96 <vector155>:
  105a96:	6a 00                	push   $0x0
  105a98:	68 9b 00 00 00       	push   $0x9b
  105a9d:	e9 9e f5 ff ff       	jmp    105040 <alltraps>

00105aa2 <vector156>:
  105aa2:	6a 00                	push   $0x0
  105aa4:	68 9c 00 00 00       	push   $0x9c
  105aa9:	e9 92 f5 ff ff       	jmp    105040 <alltraps>

00105aae <vector157>:
  105aae:	6a 00                	push   $0x0
  105ab0:	68 9d 00 00 00       	push   $0x9d
  105ab5:	e9 86 f5 ff ff       	jmp    105040 <alltraps>

00105aba <vector158>:
  105aba:	6a 00                	push   $0x0
  105abc:	68 9e 00 00 00       	push   $0x9e
  105ac1:	e9 7a f5 ff ff       	jmp    105040 <alltraps>

00105ac6 <vector159>:
  105ac6:	6a 00                	push   $0x0
  105ac8:	68 9f 00 00 00       	push   $0x9f
  105acd:	e9 6e f5 ff ff       	jmp    105040 <alltraps>

00105ad2 <vector160>:
  105ad2:	6a 00                	push   $0x0
  105ad4:	68 a0 00 00 00       	push   $0xa0
  105ad9:	e9 62 f5 ff ff       	jmp    105040 <alltraps>

00105ade <vector161>:
  105ade:	6a 00                	push   $0x0
  105ae0:	68 a1 00 00 00       	push   $0xa1
  105ae5:	e9 56 f5 ff ff       	jmp    105040 <alltraps>

00105aea <vector162>:
  105aea:	6a 00                	push   $0x0
  105aec:	68 a2 00 00 00       	push   $0xa2
  105af1:	e9 4a f5 ff ff       	jmp    105040 <alltraps>

00105af6 <vector163>:
  105af6:	6a 00                	push   $0x0
  105af8:	68 a3 00 00 00       	push   $0xa3
  105afd:	e9 3e f5 ff ff       	jmp    105040 <alltraps>

00105b02 <vector164>:
  105b02:	6a 00                	push   $0x0
  105b04:	68 a4 00 00 00       	push   $0xa4
  105b09:	e9 32 f5 ff ff       	jmp    105040 <alltraps>

00105b0e <vector165>:
  105b0e:	6a 00                	push   $0x0
  105b10:	68 a5 00 00 00       	push   $0xa5
  105b15:	e9 26 f5 ff ff       	jmp    105040 <alltraps>

00105b1a <vector166>:
  105b1a:	6a 00                	push   $0x0
  105b1c:	68 a6 00 00 00       	push   $0xa6
  105b21:	e9 1a f5 ff ff       	jmp    105040 <alltraps>

00105b26 <vector167>:
  105b26:	6a 00                	push   $0x0
  105b28:	68 a7 00 00 00       	push   $0xa7
  105b2d:	e9 0e f5 ff ff       	jmp    105040 <alltraps>

00105b32 <vector168>:
  105b32:	6a 00                	push   $0x0
  105b34:	68 a8 00 00 00       	push   $0xa8
  105b39:	e9 02 f5 ff ff       	jmp    105040 <alltraps>

00105b3e <vector169>:
  105b3e:	6a 00                	push   $0x0
  105b40:	68 a9 00 00 00       	push   $0xa9
  105b45:	e9 f6 f4 ff ff       	jmp    105040 <alltraps>

00105b4a <vector170>:
  105b4a:	6a 00                	push   $0x0
  105b4c:	68 aa 00 00 00       	push   $0xaa
  105b51:	e9 ea f4 ff ff       	jmp    105040 <alltraps>

00105b56 <vector171>:
  105b56:	6a 00                	push   $0x0
  105b58:	68 ab 00 00 00       	push   $0xab
  105b5d:	e9 de f4 ff ff       	jmp    105040 <alltraps>

00105b62 <vector172>:
  105b62:	6a 00                	push   $0x0
  105b64:	68 ac 00 00 00       	push   $0xac
  105b69:	e9 d2 f4 ff ff       	jmp    105040 <alltraps>

00105b6e <vector173>:
  105b6e:	6a 00                	push   $0x0
  105b70:	68 ad 00 00 00       	push   $0xad
  105b75:	e9 c6 f4 ff ff       	jmp    105040 <alltraps>

00105b7a <vector174>:
  105b7a:	6a 00                	push   $0x0
  105b7c:	68 ae 00 00 00       	push   $0xae
  105b81:	e9 ba f4 ff ff       	jmp    105040 <alltraps>

00105b86 <vector175>:
  105b86:	6a 00                	push   $0x0
  105b88:	68 af 00 00 00       	push   $0xaf
  105b8d:	e9 ae f4 ff ff       	jmp    105040 <alltraps>

00105b92 <vector176>:
  105b92:	6a 00                	push   $0x0
  105b94:	68 b0 00 00 00       	push   $0xb0
  105b99:	e9 a2 f4 ff ff       	jmp    105040 <alltraps>

00105b9e <vector177>:
  105b9e:	6a 00                	push   $0x0
  105ba0:	68 b1 00 00 00       	push   $0xb1
  105ba5:	e9 96 f4 ff ff       	jmp    105040 <alltraps>

00105baa <vector178>:
  105baa:	6a 00                	push   $0x0
  105bac:	68 b2 00 00 00       	push   $0xb2
  105bb1:	e9 8a f4 ff ff       	jmp    105040 <alltraps>

00105bb6 <vector179>:
  105bb6:	6a 00                	push   $0x0
  105bb8:	68 b3 00 00 00       	push   $0xb3
  105bbd:	e9 7e f4 ff ff       	jmp    105040 <alltraps>

00105bc2 <vector180>:
  105bc2:	6a 00                	push   $0x0
  105bc4:	68 b4 00 00 00       	push   $0xb4
  105bc9:	e9 72 f4 ff ff       	jmp    105040 <alltraps>

00105bce <vector181>:
  105bce:	6a 00                	push   $0x0
  105bd0:	68 b5 00 00 00       	push   $0xb5
  105bd5:	e9 66 f4 ff ff       	jmp    105040 <alltraps>

00105bda <vector182>:
  105bda:	6a 00                	push   $0x0
  105bdc:	68 b6 00 00 00       	push   $0xb6
  105be1:	e9 5a f4 ff ff       	jmp    105040 <alltraps>

00105be6 <vector183>:
  105be6:	6a 00                	push   $0x0
  105be8:	68 b7 00 00 00       	push   $0xb7
  105bed:	e9 4e f4 ff ff       	jmp    105040 <alltraps>

00105bf2 <vector184>:
  105bf2:	6a 00                	push   $0x0
  105bf4:	68 b8 00 00 00       	push   $0xb8
  105bf9:	e9 42 f4 ff ff       	jmp    105040 <alltraps>

00105bfe <vector185>:
  105bfe:	6a 00                	push   $0x0
  105c00:	68 b9 00 00 00       	push   $0xb9
  105c05:	e9 36 f4 ff ff       	jmp    105040 <alltraps>

00105c0a <vector186>:
  105c0a:	6a 00                	push   $0x0
  105c0c:	68 ba 00 00 00       	push   $0xba
  105c11:	e9 2a f4 ff ff       	jmp    105040 <alltraps>

00105c16 <vector187>:
  105c16:	6a 00                	push   $0x0
  105c18:	68 bb 00 00 00       	push   $0xbb
  105c1d:	e9 1e f4 ff ff       	jmp    105040 <alltraps>

00105c22 <vector188>:
  105c22:	6a 00                	push   $0x0
  105c24:	68 bc 00 00 00       	push   $0xbc
  105c29:	e9 12 f4 ff ff       	jmp    105040 <alltraps>

00105c2e <vector189>:
  105c2e:	6a 00                	push   $0x0
  105c30:	68 bd 00 00 00       	push   $0xbd
  105c35:	e9 06 f4 ff ff       	jmp    105040 <alltraps>

00105c3a <vector190>:
  105c3a:	6a 00                	push   $0x0
  105c3c:	68 be 00 00 00       	push   $0xbe
  105c41:	e9 fa f3 ff ff       	jmp    105040 <alltraps>

00105c46 <vector191>:
  105c46:	6a 00                	push   $0x0
  105c48:	68 bf 00 00 00       	push   $0xbf
  105c4d:	e9 ee f3 ff ff       	jmp    105040 <alltraps>

00105c52 <vector192>:
  105c52:	6a 00                	push   $0x0
  105c54:	68 c0 00 00 00       	push   $0xc0
  105c59:	e9 e2 f3 ff ff       	jmp    105040 <alltraps>

00105c5e <vector193>:
  105c5e:	6a 00                	push   $0x0
  105c60:	68 c1 00 00 00       	push   $0xc1
  105c65:	e9 d6 f3 ff ff       	jmp    105040 <alltraps>

00105c6a <vector194>:
  105c6a:	6a 00                	push   $0x0
  105c6c:	68 c2 00 00 00       	push   $0xc2
  105c71:	e9 ca f3 ff ff       	jmp    105040 <alltraps>

00105c76 <vector195>:
  105c76:	6a 00                	push   $0x0
  105c78:	68 c3 00 00 00       	push   $0xc3
  105c7d:	e9 be f3 ff ff       	jmp    105040 <alltraps>

00105c82 <vector196>:
  105c82:	6a 00                	push   $0x0
  105c84:	68 c4 00 00 00       	push   $0xc4
  105c89:	e9 b2 f3 ff ff       	jmp    105040 <alltraps>

00105c8e <vector197>:
  105c8e:	6a 00                	push   $0x0
  105c90:	68 c5 00 00 00       	push   $0xc5
  105c95:	e9 a6 f3 ff ff       	jmp    105040 <alltraps>

00105c9a <vector198>:
  105c9a:	6a 00                	push   $0x0
  105c9c:	68 c6 00 00 00       	push   $0xc6
  105ca1:	e9 9a f3 ff ff       	jmp    105040 <alltraps>

00105ca6 <vector199>:
  105ca6:	6a 00                	push   $0x0
  105ca8:	68 c7 00 00 00       	push   $0xc7
  105cad:	e9 8e f3 ff ff       	jmp    105040 <alltraps>

00105cb2 <vector200>:
  105cb2:	6a 00                	push   $0x0
  105cb4:	68 c8 00 00 00       	push   $0xc8
  105cb9:	e9 82 f3 ff ff       	jmp    105040 <alltraps>

00105cbe <vector201>:
  105cbe:	6a 00                	push   $0x0
  105cc0:	68 c9 00 00 00       	push   $0xc9
  105cc5:	e9 76 f3 ff ff       	jmp    105040 <alltraps>

00105cca <vector202>:
  105cca:	6a 00                	push   $0x0
  105ccc:	68 ca 00 00 00       	push   $0xca
  105cd1:	e9 6a f3 ff ff       	jmp    105040 <alltraps>

00105cd6 <vector203>:
  105cd6:	6a 00                	push   $0x0
  105cd8:	68 cb 00 00 00       	push   $0xcb
  105cdd:	e9 5e f3 ff ff       	jmp    105040 <alltraps>

00105ce2 <vector204>:
  105ce2:	6a 00                	push   $0x0
  105ce4:	68 cc 00 00 00       	push   $0xcc
  105ce9:	e9 52 f3 ff ff       	jmp    105040 <alltraps>

00105cee <vector205>:
  105cee:	6a 00                	push   $0x0
  105cf0:	68 cd 00 00 00       	push   $0xcd
  105cf5:	e9 46 f3 ff ff       	jmp    105040 <alltraps>

00105cfa <vector206>:
  105cfa:	6a 00                	push   $0x0
  105cfc:	68 ce 00 00 00       	push   $0xce
  105d01:	e9 3a f3 ff ff       	jmp    105040 <alltraps>

00105d06 <vector207>:
  105d06:	6a 00                	push   $0x0
  105d08:	68 cf 00 00 00       	push   $0xcf
  105d0d:	e9 2e f3 ff ff       	jmp    105040 <alltraps>

00105d12 <vector208>:
  105d12:	6a 00                	push   $0x0
  105d14:	68 d0 00 00 00       	push   $0xd0
  105d19:	e9 22 f3 ff ff       	jmp    105040 <alltraps>

00105d1e <vector209>:
  105d1e:	6a 00                	push   $0x0
  105d20:	68 d1 00 00 00       	push   $0xd1
  105d25:	e9 16 f3 ff ff       	jmp    105040 <alltraps>

00105d2a <vector210>:
  105d2a:	6a 00                	push   $0x0
  105d2c:	68 d2 00 00 00       	push   $0xd2
  105d31:	e9 0a f3 ff ff       	jmp    105040 <alltraps>

00105d36 <vector211>:
  105d36:	6a 00                	push   $0x0
  105d38:	68 d3 00 00 00       	push   $0xd3
  105d3d:	e9 fe f2 ff ff       	jmp    105040 <alltraps>

00105d42 <vector212>:
  105d42:	6a 00                	push   $0x0
  105d44:	68 d4 00 00 00       	push   $0xd4
  105d49:	e9 f2 f2 ff ff       	jmp    105040 <alltraps>

00105d4e <vector213>:
  105d4e:	6a 00                	push   $0x0
  105d50:	68 d5 00 00 00       	push   $0xd5
  105d55:	e9 e6 f2 ff ff       	jmp    105040 <alltraps>

00105d5a <vector214>:
  105d5a:	6a 00                	push   $0x0
  105d5c:	68 d6 00 00 00       	push   $0xd6
  105d61:	e9 da f2 ff ff       	jmp    105040 <alltraps>

00105d66 <vector215>:
  105d66:	6a 00                	push   $0x0
  105d68:	68 d7 00 00 00       	push   $0xd7
  105d6d:	e9 ce f2 ff ff       	jmp    105040 <alltraps>

00105d72 <vector216>:
  105d72:	6a 00                	push   $0x0
  105d74:	68 d8 00 00 00       	push   $0xd8
  105d79:	e9 c2 f2 ff ff       	jmp    105040 <alltraps>

00105d7e <vector217>:
  105d7e:	6a 00                	push   $0x0
  105d80:	68 d9 00 00 00       	push   $0xd9
  105d85:	e9 b6 f2 ff ff       	jmp    105040 <alltraps>

00105d8a <vector218>:
  105d8a:	6a 00                	push   $0x0
  105d8c:	68 da 00 00 00       	push   $0xda
  105d91:	e9 aa f2 ff ff       	jmp    105040 <alltraps>

00105d96 <vector219>:
  105d96:	6a 00                	push   $0x0
  105d98:	68 db 00 00 00       	push   $0xdb
  105d9d:	e9 9e f2 ff ff       	jmp    105040 <alltraps>

00105da2 <vector220>:
  105da2:	6a 00                	push   $0x0
  105da4:	68 dc 00 00 00       	push   $0xdc
  105da9:	e9 92 f2 ff ff       	jmp    105040 <alltraps>

00105dae <vector221>:
  105dae:	6a 00                	push   $0x0
  105db0:	68 dd 00 00 00       	push   $0xdd
  105db5:	e9 86 f2 ff ff       	jmp    105040 <alltraps>

00105dba <vector222>:
  105dba:	6a 00                	push   $0x0
  105dbc:	68 de 00 00 00       	push   $0xde
  105dc1:	e9 7a f2 ff ff       	jmp    105040 <alltraps>

00105dc6 <vector223>:
  105dc6:	6a 00                	push   $0x0
  105dc8:	68 df 00 00 00       	push   $0xdf
  105dcd:	e9 6e f2 ff ff       	jmp    105040 <alltraps>

00105dd2 <vector224>:
  105dd2:	6a 00                	push   $0x0
  105dd4:	68 e0 00 00 00       	push   $0xe0
  105dd9:	e9 62 f2 ff ff       	jmp    105040 <alltraps>

00105dde <vector225>:
  105dde:	6a 00                	push   $0x0
  105de0:	68 e1 00 00 00       	push   $0xe1
  105de5:	e9 56 f2 ff ff       	jmp    105040 <alltraps>

00105dea <vector226>:
  105dea:	6a 00                	push   $0x0
  105dec:	68 e2 00 00 00       	push   $0xe2
  105df1:	e9 4a f2 ff ff       	jmp    105040 <alltraps>

00105df6 <vector227>:
  105df6:	6a 00                	push   $0x0
  105df8:	68 e3 00 00 00       	push   $0xe3
  105dfd:	e9 3e f2 ff ff       	jmp    105040 <alltraps>

00105e02 <vector228>:
  105e02:	6a 00                	push   $0x0
  105e04:	68 e4 00 00 00       	push   $0xe4
  105e09:	e9 32 f2 ff ff       	jmp    105040 <alltraps>

00105e0e <vector229>:
  105e0e:	6a 00                	push   $0x0
  105e10:	68 e5 00 00 00       	push   $0xe5
  105e15:	e9 26 f2 ff ff       	jmp    105040 <alltraps>

00105e1a <vector230>:
  105e1a:	6a 00                	push   $0x0
  105e1c:	68 e6 00 00 00       	push   $0xe6
  105e21:	e9 1a f2 ff ff       	jmp    105040 <alltraps>

00105e26 <vector231>:
  105e26:	6a 00                	push   $0x0
  105e28:	68 e7 00 00 00       	push   $0xe7
  105e2d:	e9 0e f2 ff ff       	jmp    105040 <alltraps>

00105e32 <vector232>:
  105e32:	6a 00                	push   $0x0
  105e34:	68 e8 00 00 00       	push   $0xe8
  105e39:	e9 02 f2 ff ff       	jmp    105040 <alltraps>

00105e3e <vector233>:
  105e3e:	6a 00                	push   $0x0
  105e40:	68 e9 00 00 00       	push   $0xe9
  105e45:	e9 f6 f1 ff ff       	jmp    105040 <alltraps>

00105e4a <vector234>:
  105e4a:	6a 00                	push   $0x0
  105e4c:	68 ea 00 00 00       	push   $0xea
  105e51:	e9 ea f1 ff ff       	jmp    105040 <alltraps>

00105e56 <vector235>:
  105e56:	6a 00                	push   $0x0
  105e58:	68 eb 00 00 00       	push   $0xeb
  105e5d:	e9 de f1 ff ff       	jmp    105040 <alltraps>

00105e62 <vector236>:
  105e62:	6a 00                	push   $0x0
  105e64:	68 ec 00 00 00       	push   $0xec
  105e69:	e9 d2 f1 ff ff       	jmp    105040 <alltraps>

00105e6e <vector237>:
  105e6e:	6a 00                	push   $0x0
  105e70:	68 ed 00 00 00       	push   $0xed
  105e75:	e9 c6 f1 ff ff       	jmp    105040 <alltraps>

00105e7a <vector238>:
  105e7a:	6a 00                	push   $0x0
  105e7c:	68 ee 00 00 00       	push   $0xee
  105e81:	e9 ba f1 ff ff       	jmp    105040 <alltraps>

00105e86 <vector239>:
  105e86:	6a 00                	push   $0x0
  105e88:	68 ef 00 00 00       	push   $0xef
  105e8d:	e9 ae f1 ff ff       	jmp    105040 <alltraps>

00105e92 <vector240>:
  105e92:	6a 00                	push   $0x0
  105e94:	68 f0 00 00 00       	push   $0xf0
  105e99:	e9 a2 f1 ff ff       	jmp    105040 <alltraps>

00105e9e <vector241>:
  105e9e:	6a 00                	push   $0x0
  105ea0:	68 f1 00 00 00       	push   $0xf1
  105ea5:	e9 96 f1 ff ff       	jmp    105040 <alltraps>

00105eaa <vector242>:
  105eaa:	6a 00                	push   $0x0
  105eac:	68 f2 00 00 00       	push   $0xf2
  105eb1:	e9 8a f1 ff ff       	jmp    105040 <alltraps>

00105eb6 <vector243>:
  105eb6:	6a 00                	push   $0x0
  105eb8:	68 f3 00 00 00       	push   $0xf3
  105ebd:	e9 7e f1 ff ff       	jmp    105040 <alltraps>

00105ec2 <vector244>:
  105ec2:	6a 00                	push   $0x0
  105ec4:	68 f4 00 00 00       	push   $0xf4
  105ec9:	e9 72 f1 ff ff       	jmp    105040 <alltraps>

00105ece <vector245>:
  105ece:	6a 00                	push   $0x0
  105ed0:	68 f5 00 00 00       	push   $0xf5
  105ed5:	e9 66 f1 ff ff       	jmp    105040 <alltraps>

00105eda <vector246>:
  105eda:	6a 00                	push   $0x0
  105edc:	68 f6 00 00 00       	push   $0xf6
  105ee1:	e9 5a f1 ff ff       	jmp    105040 <alltraps>

00105ee6 <vector247>:
  105ee6:	6a 00                	push   $0x0
  105ee8:	68 f7 00 00 00       	push   $0xf7
  105eed:	e9 4e f1 ff ff       	jmp    105040 <alltraps>

00105ef2 <vector248>:
  105ef2:	6a 00                	push   $0x0
  105ef4:	68 f8 00 00 00       	push   $0xf8
  105ef9:	e9 42 f1 ff ff       	jmp    105040 <alltraps>

00105efe <vector249>:
  105efe:	6a 00                	push   $0x0
  105f00:	68 f9 00 00 00       	push   $0xf9
  105f05:	e9 36 f1 ff ff       	jmp    105040 <alltraps>

00105f0a <vector250>:
  105f0a:	6a 00                	push   $0x0
  105f0c:	68 fa 00 00 00       	push   $0xfa
  105f11:	e9 2a f1 ff ff       	jmp    105040 <alltraps>

00105f16 <vector251>:
  105f16:	6a 00                	push   $0x0
  105f18:	68 fb 00 00 00       	push   $0xfb
  105f1d:	e9 1e f1 ff ff       	jmp    105040 <alltraps>

00105f22 <vector252>:
  105f22:	6a 00                	push   $0x0
  105f24:	68 fc 00 00 00       	push   $0xfc
  105f29:	e9 12 f1 ff ff       	jmp    105040 <alltraps>

00105f2e <vector253>:
  105f2e:	6a 00                	push   $0x0
  105f30:	68 fd 00 00 00       	push   $0xfd
  105f35:	e9 06 f1 ff ff       	jmp    105040 <alltraps>

00105f3a <vector254>:
  105f3a:	6a 00                	push   $0x0
  105f3c:	68 fe 00 00 00       	push   $0xfe
  105f41:	e9 fa f0 ff ff       	jmp    105040 <alltraps>

00105f46 <vector255>:
  105f46:	6a 00                	push   $0x0
  105f48:	68 ff 00 00 00       	push   $0xff
  105f4d:	e9 ee f0 ff ff       	jmp    105040 <alltraps>
