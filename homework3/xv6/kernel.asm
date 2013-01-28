
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
  100016:	e8 a5 3e 00 00       	call   103ec0 <acquire>

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
  10004d:	e8 5e 31 00 00       	call   1031b0 <wakeup>

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
  10005e:	e9 0d 3e 00 00       	jmp    103e70 <release>
// Release the buffer b.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100063:	c7 04 24 80 5f 10 00 	movl   $0x105f80,(%esp)
  10006a:	e8 11 08 00 00       	call   100880 <panic>
  10006f:	90                   	nop    

00100070 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	53                   	push   %ebx
  100074:	83 ec 14             	sub    $0x14,%esp
  100077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
  10007a:	8b 03                	mov    (%ebx),%eax
  10007c:	a8 01                	test   $0x1,%al
  10007e:	74 26                	je     1000a6 <bwrite+0x36>
    panic("bwrite");
  b->flags |= B_DIRTY;
  100080:	83 c8 04             	or     $0x4,%eax
  100083:	89 03                	mov    %eax,(%ebx)
  iderw(b);
  100085:	89 1c 24             	mov    %ebx,(%esp)
  100088:	e8 e3 1e 00 00       	call   101f70 <iderw>
  cprintf("bwrite sector %d\n", b->sector);
  10008d:	8b 43 08             	mov    0x8(%ebx),%eax
  100090:	c7 04 24 8e 5f 10 00 	movl   $0x105f8e,(%esp)
  100097:	89 44 24 04          	mov    %eax,0x4(%esp)
  10009b:	e8 00 04 00 00       	call   1004a0 <cprintf>
}
  1000a0:	83 c4 14             	add    $0x14,%esp
  1000a3:	5b                   	pop    %ebx
  1000a4:	5d                   	pop    %ebp
  1000a5:	c3                   	ret    
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  1000a6:	c7 04 24 87 5f 10 00 	movl   $0x105f87,(%esp)
  1000ad:	e8 ce 07 00 00       	call   100880 <panic>
  1000b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1000b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  1000d6:	e8 e5 3d 00 00       	call   103ec0 <acquire>

 loop:
  // Try for cached block.
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  1000db:	8b 1d 54 95 10 00    	mov    0x109554,%ebx
  1000e1:	81 fb 44 95 10 00    	cmp    $0x109544,%ebx
  1000e7:	75 12                	jne    1000fb <bread+0x3b>
  1000e9:	eb 3d                	jmp    100128 <bread+0x68>
  1000eb:	90                   	nop    
  1000ec:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  10010c:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  100124:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  10015f:	e8 0c 3d 00 00       	call   103e70 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  100164:	f6 03 02             	testb  $0x2,(%ebx)
  100167:	75 08                	jne    100171 <bread+0xb1>
    iderw(b);
  100169:	89 1c 24             	mov    %ebx,(%esp)
  10016c:	e8 ff 1d 00 00       	call   101f70 <iderw>
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
  10017b:	c7 04 24 a0 5f 10 00 	movl   $0x105fa0,(%esp)
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
  100193:	e8 d8 3c 00 00       	call   103e70 <release>
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
  1001a6:	c7 44 24 04 b1 5f 10 	movl   $0x105fb1,0x4(%esp)
  1001ad:	00 
  1001ae:	c7 04 24 20 80 10 00 	movl   $0x108020,(%esp)
  1001b5:	e8 76 3b 00 00       	call   103d30 <initlock>

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
  1001d4:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  100216:	c7 44 24 04 b8 5f 10 	movl   $0x105fb8,0x4(%esp)
  10021d:	00 
  10021e:	c7 04 24 80 7f 10 00 	movl   $0x107f80,(%esp)
  100225:	e8 06 3b 00 00       	call   103d30 <initlock>
  initlock(&input.lock, "input");
  10022a:	c7 44 24 04 c0 5f 10 	movl   $0x105fc0,0x4(%esp)
  100231:	00 
  100232:	c7 04 24 60 97 10 00 	movl   $0x109760,(%esp)
  100239:	e8 f2 3a 00 00       	call   103d30 <initlock>

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
  100263:	e8 48 2a 00 00       	call   102cb0 <picenable>
  ioapicenable(IRQ_KBD, 0);
  100268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10026f:	00 
  100270:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100277:	e8 24 1f 00 00       	call   1021a0 <ioapicenable>
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
  10029a:	e8 41 51 00 00       	call   1053e0 <uartputc>
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
  100366:	e8 85 3c 00 00       	call   103ff0 <memmove>
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
  100389:	e8 d2 3b 00 00       	call   103f60 <memset>
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
  1003d1:	e8 ea 3a 00 00       	call   103ec0 <acquire>
  for(i = 0; i < n; i++)
  1003d6:	85 f6                	test   %esi,%esi
  1003d8:	7e 16                	jle    1003f0 <consolewrite+0x40>
  1003da:	31 db                	xor    %ebx,%ebx
  1003dc:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  1003f7:	e8 74 3a 00 00       	call   103e70 <release>
  ilock(ip);
  1003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ff:	89 04 24             	mov    %eax,(%esp)
  100402:	e8 c9 17 00 00       	call   101bd0 <ilock>

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
  100446:	0f b6 82 e0 5f 10 00 	movzbl 0x105fe0(%edx),%eax
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
  100499:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  1004dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  1004e0:	0f 84 9a 00 00 00    	je     100580 <cprintf+0xe0>
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
  1004e6:	b8 25 00 00 00       	mov    $0x25,%eax
  1004eb:	90                   	nop    
  1004ec:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  100531:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  100559:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  10056e:	e8 fd 38 00 00       	call   103e70 <release>
}
  100573:	83 c4 0c             	add    $0xc,%esp
  100576:	5b                   	pop    %ebx
  100577:	5e                   	pop    %esi
  100578:	5f                   	pop    %edi
  100579:	5d                   	pop    %ebp
  10057a:	c3                   	ret    
  10057b:	90                   	nop    
  10057c:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  10059c:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  1005cc:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  1005ef:	e8 cc 38 00 00       	call   103ec0 <acquire>
  1005f4:	8d 74 26 00          	lea    0x0(%esi),%esi
  1005f8:	e9 bc fe ff ff       	jmp    1004b9 <cprintf+0x19>
  1005fd:	8d 76 00             	lea    0x0(%esi),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
  100600:	bb c6 5f 10 00       	mov    $0x105fc6,%ebx
  100605:	eb ba                	jmp    1005c1 <cprintf+0x121>
  100607:	89 f6                	mov    %esi,%esi
  100609:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  100634:	e8 87 38 00 00       	call   103ec0 <acquire>
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
  1006b4:	e8 b7 37 00 00       	call   103e70 <release>
        ilock(ip);
  1006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bc:	89 04 24             	mov    %eax,(%esp)
  1006bf:	e8 0c 15 00 00       	call   101bd0 <ilock>
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
  1006e7:	e8 84 37 00 00       	call   103e70 <release>
  ilock(ip);
  1006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ef:	89 04 24             	mov    %eax,(%esp)
  1006f2:	e8 d9 14 00 00       	call   101bd0 <ilock>

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
  100705:	8d 74 26 00          	lea    0x0(%esi),%esi
  100709:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  100728:	e8 93 37 00 00       	call   103ec0 <acquire>
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
  100749:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  100750:	0f 84 c7 00 00 00    	je     10081d <consoleintr+0x10d>
  100756:	83 fb 08             	cmp    $0x8,%ebx
  100759:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  1007ca:	e8 e1 29 00 00       	call   1031b0 <wakeup>
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
  1007dc:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  1007ee:	e9 7d 36 00 00       	jmp    103e70 <release>
  1007f3:	90                   	nop    
  1007f4:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  100830:	e8 0b 34 00 00       	call   103c40 <procdump>
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
  100879:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  10089e:	c7 04 24 cd 5f 10 00 	movl   $0x105fcd,(%esp)
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
  1008cf:	e8 7c 34 00 00       	call   103d50 <getcallerpcs>
  1008d4:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  1008d8:	8b 03                	mov    (%ebx),%eax
  1008da:	83 c3 04             	add    $0x4,%ebx
  1008dd:	c7 04 24 dc 5f 10 00 	movl   $0x105fdc,(%esp)
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
  100912:	e8 69 15 00 00       	call   101e80 <namei>
  100917:	89 c6                	mov    %eax,%esi
  100919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10091e:	85 f6                	test   %esi,%esi
  100920:	74 48                	je     10096a <exec+0x6a>
    return -1;
  ilock(ip);
  100922:	89 34 24             	mov    %esi,(%esp)
  100925:	e8 a6 12 00 00       	call   101bd0 <ilock>

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
  100960:	e8 7b 11 00 00       	call   101ae0 <iunlockput>
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
  100994:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  1009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  100a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    arglen += strlen(argv[argc]) + 1;
  100a18:	89 14 24             	mov    %edx,(%esp)
  100a1b:	e8 20 37 00 00       	call   104140 <strlen>
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
  100a66:	e8 35 18 00 00       	call   1022a0 <kalloc>
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
  100a91:	e8 ca 34 00 00       	call   103f60 <memset>

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
  100b45:	e8 16 34 00 00       	call   103f60 <memset>
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
  100b60:	e8 eb 17 00 00       	call   102350 <kfree>
  100b65:	e9 ed fd ff ff       	jmp    100957 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100b6a:	89 34 24             	mov    %esi,(%esp)
  100b6d:	e8 6e 0f 00 00       	call   101ae0 <iunlockput>
  
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
  100bc5:	e8 76 35 00 00       	call   104140 <strlen>
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
  100be7:	e8 04 34 00 00       	call   103ff0 <memmove>
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
  100c63:	e8 98 34 00 00       	call   104100 <safestrcpy>

  // Commit to the new image.
  kfree(proc->mem, proc->sz);
  100c68:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  100c6f:	8b 42 04             	mov    0x4(%edx),%eax
  100c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c76:	8b 02                	mov    (%edx),%eax
  100c78:	89 04 24             	mov    %eax,(%esp)
  100c7b:	e8 d0 16 00 00       	call   102350 <kfree>
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
  100d00:	e8 cb 0e 00 00       	call   101bd0 <ilock>
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
  100d62:	e9 29 21 00 00       	jmp    102e90 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100d67:	c7 04 24 f1 5f 10 00 	movl   $0x105ff1,(%esp)
  100d6e:	e8 0d fb ff ff       	call   100880 <panic>
  100d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  100db0:	e8 1b 0e 00 00       	call   101bd0 <ilock>
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
  100e12:	e9 79 1f 00 00       	jmp    102d90 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100e17:	c7 04 24 fb 5f 10 00 	movl   $0x105ffb,(%esp)
  100e1e:	e8 5d fa ff ff       	call   100880 <panic>
  100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  100e56:	e8 75 0d 00 00       	call   101bd0 <ilock>
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
  100e91:	e8 2a 30 00 00       	call   103ec0 <acquire>
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
  100eaa:	e8 c1 2f 00 00       	call   103e70 <release>
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
  100eb7:	c7 04 24 04 60 10 00 	movl   $0x106004,(%esp)
  100ebe:	e8 bd f9 ff ff       	call   100880 <panic>
  100ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  100ee3:	e8 d8 2f 00 00       	call   103ec0 <acquire>
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
  100f10:	e8 5b 2f 00 00       	call   103e70 <release>
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
  100f29:	e8 42 2f 00 00       	call   103e70 <release>
  return 0;
}
  100f2e:	89 d8                	mov    %ebx,%eax
  100f30:	83 c4 04             	add    $0x4,%esp
  100f33:	5b                   	pop    %ebx
  100f34:	5d                   	pop    %ebp
  100f35:	c3                   	ret    
  100f36:	8d 76 00             	lea    0x0(%esi),%esi
  100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  100f59:	e8 62 2f 00 00       	call   103ec0 <acquire>
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
  100f86:	e9 e5 2e 00 00       	jmp    103e70 <release>
  100f8b:	90                   	nop    
  100f8c:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  100fb6:	e8 b5 2e 00 00       	call   103e70 <release>
  
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
  100fea:	e9 91 08 00 00       	jmp    101880 <iput>
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
  100fff:	e8 8c 1f 00 00       	call   102f90 <pipeclose>
  101004:	eb bf                	jmp    100fc5 <fileclose+0x85>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  101006:	c7 04 24 0c 60 10 00 	movl   $0x10600c,(%esp)
  10100d:	e8 6e f8 ff ff       	call   100880 <panic>
  101012:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101019:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  101026:	c7 44 24 04 16 60 10 	movl   $0x106016,0x4(%esp)
  10102d:	00 
  10102e:	c7 04 24 20 98 10 00 	movl   $0x109820,(%esp)
  101035:	e8 f6 2c 00 00       	call   103d30 <initlock>
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
  10106c:	8d 74 26 00          	lea    0x0(%esi),%esi

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
  101081:	e8 3a 2e 00 00       	call   103ec0 <acquire>
  ip->ref++;
  101086:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10108a:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101091:	e8 da 2d 00 00       	call   103e70 <release>
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
  1010bc:	e8 ff 2d 00 00       	call   103ec0 <acquire>
  1010c1:	eb 17                	jmp    1010da <iget+0x3a>
  1010c3:	90                   	nop    
  1010c4:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  1010fa:	e8 71 2d 00 00       	call   103e70 <release>
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
  101109:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  101121:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  10114b:	e8 20 2d 00 00       	call   103e70 <release>

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
  10115a:	c7 04 24 1d 60 10 00 	movl   $0x10601d,(%esp)
  101161:	e8 1a f7 ff ff       	call   100880 <panic>
  101166:	8d 76 00             	lea    0x0(%esi),%esi
  101169:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  1011a2:	e8 49 2e 00 00       	call   103ff0 <memmove>
  brelse(bp);
  1011a7:	89 1c 24             	mov    %ebx,(%esp)
  1011aa:	e8 51 ee ff ff       	call   100000 <brelse>
}
  1011af:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1011b2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1011b5:	89 ec                	mov    %ebp,%esp
  1011b7:	5d                   	pop    %ebp
  1011b8:	c3                   	ret    
  1011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

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
  1011d9:	0f 84 9c 00 00 00    	je     10127b <balloc+0xbb>
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
  10120c:	8d 74 26 00          	lea    0x0(%esi),%esi
    for(bi = 0; bi < BPB; bi++){
  101210:	83 c3 01             	add    $0x1,%ebx
  101213:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  101219:	74 45                	je     101260 <balloc+0xa0>
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
        bwrite(bp);
  101240:	89 3c 24             	mov    %edi,(%esp)
  101243:	e8 28 ee ff ff       	call   100070 <bwrite>
        brelse(bp);
  101248:	89 3c 24             	mov    %edi,(%esp)
  10124b:	e8 b0 ed ff ff       	call   100000 <brelse>
  101250:	8b 55 e0             	mov    -0x20(%ebp),%edx
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  101253:	83 c4 2c             	add    $0x2c,%esp
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  101256:	8d 04 13             	lea    (%ebx,%edx,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  101259:	5b                   	pop    %ebx
  10125a:	5e                   	pop    %esi
  10125b:	5f                   	pop    %edi
  10125c:	5d                   	pop    %ebp
  10125d:	c3                   	ret    
  10125e:	66 90                	xchg   %ax,%ax
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  101260:	89 3c 24             	mov    %edi,(%esp)
  101263:	e8 98 ed ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  101268:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  10126f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101272:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  101275:	0f 87 6b ff ff ff    	ja     1011e6 <balloc+0x26>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  10127b:	c7 04 24 2d 60 10 00 	movl   $0x10602d,(%esp)
  101282:	e8 f9 f5 ff ff       	call   100880 <panic>
  101287:	89 f6                	mov    %esi,%esi
  101289:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  1012af:	74 5f                	je     101310 <bmap+0x80>
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
  1012c6:	77 64                	ja     10132c <bmap+0x9c>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
  1012c8:	8b 40 4c             	mov    0x4c(%eax),%eax
  1012cb:	85 c0                	test   %eax,%eax
  1012cd:	74 51                	je     101320 <bmap+0x90>
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
  1012ea:	75 16                	jne    101302 <bmap+0x72>
      a[bn] = addr = balloc(ip->dev);
  1012ec:	8b 06                	mov    (%esi),%eax
  1012ee:	e8 cd fe ff ff       	call   1011c0 <balloc>
  1012f3:	89 c3                	mov    %eax,%ebx
  1012f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1012f8:	89 18                	mov    %ebx,(%eax)
      bwrite(bp);
  1012fa:	89 3c 24             	mov    %edi,(%esp)
  1012fd:	e8 6e ed ff ff       	call   100070 <bwrite>
    }
    brelse(bp);
  101302:	89 3c 24             	mov    %edi,(%esp)
  101305:	e8 f6 ec ff ff       	call   100000 <brelse>
  10130a:	eb a5                	jmp    1012b1 <bmap+0x21>
  10130c:	8d 74 26 00          	lea    0x0(%esi),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
  101310:	8b 00                	mov    (%eax),%eax
  101312:	e8 a9 fe ff ff       	call   1011c0 <balloc>
  101317:	89 c3                	mov    %eax,%ebx
  101319:	89 44 be 0c          	mov    %eax,0xc(%esi,%edi,4)
  10131d:	eb 92                	jmp    1012b1 <bmap+0x21>
  10131f:	90                   	nop    
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
  101320:	8b 06                	mov    (%esi),%eax
  101322:	e8 99 fe ff ff       	call   1011c0 <balloc>
  101327:	89 46 4c             	mov    %eax,0x4c(%esi)
  10132a:	eb a3                	jmp    1012cf <bmap+0x3f>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  10132c:	c7 04 24 43 60 10 00 	movl   $0x106043,(%esp)
  101333:	e8 48 f5 ff ff       	call   100880 <panic>
  101338:	90                   	nop    
  101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

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
  101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  101427:	e8 c4 2b 00 00       	call   103ff0 <memmove>
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
  1014bb:	e8 30 2b 00 00       	call   103ff0 <memmove>
  bwrite(bp);
  1014c0:	89 34 24             	mov    %esi,(%esp)
  1014c3:	e8 a8 eb ff ff       	call   100070 <bwrite>
  brelse(bp);
  1014c8:	89 75 08             	mov    %esi,0x8(%ebp)
}
  1014cb:	83 c4 10             	add    $0x10,%esp
  1014ce:	5b                   	pop    %ebx
  1014cf:	5e                   	pop    %esi
  1014d0:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  1014d1:	e9 2a eb ff ff       	jmp    100000 <brelse>
  1014d6:	8d 76 00             	lea    0x0(%esi),%esi
  1014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  10156d:	0f 84 8a 00 00 00    	je     1015fd <writei+0x11d>
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
  1015cf:	e8 1c 2a 00 00       	call   103ff0 <memmove>
    bwrite(bp);
  1015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015d7:	89 04 24             	mov    %eax,(%esp)
  1015da:	e8 91 ea ff ff       	call   100070 <bwrite>
    brelse(bp);
  1015df:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1015e2:	89 0c 24             	mov    %ecx,(%esp)
  1015e5:	e8 16 ea ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015ea:	01 7d ec             	add    %edi,-0x14(%ebp)
  1015ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015f0:	01 7d e8             	add    %edi,-0x18(%ebp)
  1015f3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1015f6:	77 88                	ja     101580 <writei+0xa0>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  1015f8:	3b 73 18             	cmp    0x18(%ebx),%esi
  1015fb:	77 08                	ja     101605 <writei+0x125>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1015fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101600:	e9 0d ff ff ff       	jmp    101512 <writei+0x32>
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  101605:	89 73 18             	mov    %esi,0x18(%ebx)
    iupdate(ip);
  101608:	89 1c 24             	mov    %ebx,(%esp)
  10160b:	e8 40 fe ff ff       	call   101450 <iupdate>
  101610:	eb eb                	jmp    1015fd <writei+0x11d>
  101612:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101619:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  10163b:	e8 20 2a 00 00       	call   104060 <strncmp>
}
  101640:	c9                   	leave  
  101641:	c3                   	ret    
  101642:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101649:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  1016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  1016e2:	e8 79 29 00 00       	call   104060 <strncmp>
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
  101748:	c7 04 24 56 60 10 00 	movl   $0x106056,(%esp)
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
  101782:	e8 39 27 00 00       	call   103ec0 <acquire>
  ip->flags &= ~I_BUSY;
  101787:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  10178b:	89 1c 24             	mov    %ebx,(%esp)
  10178e:	e8 1d 1a 00 00       	call   1031b0 <wakeup>
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
  10179f:	e9 cc 26 00 00       	jmp    103e70 <release>
  1017a4:	8d 74 26 00          	lea    0x0(%esi),%esi
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  1017a8:	c7 04 24 68 60 10 00 	movl   $0x106068,(%esp)
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
  1017f1:	e8 6a 27 00 00       	call   103f60 <memset>
  bwrite(bp);
  1017f6:	89 1c 24             	mov    %ebx,(%esp)
  1017f9:	e8 72 e8 ff ff       	call   100070 <bwrite>
  brelse(bp);
  1017fe:	89 1c 24             	mov    %ebx,(%esp)
  101801:	e8 fa e7 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101806:	89 f8                	mov    %edi,%eax
  101808:	8d 55 e8             	lea    -0x18(%ebp),%edx
  10180b:	e8 60 f9 ff ff       	call   101170 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101813:	89 f2                	mov    %esi,%edx
  101815:	c1 ea 0c             	shr    $0xc,%edx
  101818:	89 3c 24             	mov    %edi,(%esp)
  bi = b % BPB;
  10181b:	89 f7                	mov    %esi,%edi
  m = 1 << (bi % 8);
  10181d:	83 e6 07             	and    $0x7,%esi

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  101820:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101826:	c1 e8 03             	shr    $0x3,%eax
  101829:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  10182d:	89 44 24 04          	mov    %eax,0x4(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101831:	c1 ff 03             	sar    $0x3,%edi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101834:	e8 87 e8 ff ff       	call   1000c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
  101839:	89 f1                	mov    %esi,%ecx
  10183b:	ba 01 00 00 00       	mov    $0x1,%edx
  101840:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
  101842:	0f b6 74 38 18       	movzbl 0x18(%eax,%edi,1),%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101847:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101849:	89 f1                	mov    %esi,%ecx
  10184b:	0f b6 c1             	movzbl %cl,%eax
  10184e:	85 d0                	test   %edx,%eax
  101850:	74 22                	je     101874 <bfree+0xb4>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101852:	89 d0                	mov    %edx,%eax
  101854:	f7 d0                	not    %eax
  101856:	21 f0                	and    %esi,%eax
  101858:	88 44 3b 18          	mov    %al,0x18(%ebx,%edi,1)
  bwrite(bp);
  10185c:	89 1c 24             	mov    %ebx,(%esp)
  10185f:	e8 0c e8 ff ff       	call   100070 <bwrite>
  brelse(bp);
  101864:	89 1c 24             	mov    %ebx,(%esp)
  101867:	e8 94 e7 ff ff       	call   100000 <brelse>
}
  10186c:	83 c4 1c             	add    $0x1c,%esp
  10186f:	5b                   	pop    %ebx
  101870:	5e                   	pop    %esi
  101871:	5f                   	pop    %edi
  101872:	5d                   	pop    %ebp
  101873:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101874:	c7 04 24 70 60 10 00 	movl   $0x106070,(%esp)
  10187b:	e8 00 f0 ff ff       	call   100880 <panic>

00101880 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101880:	55                   	push   %ebp
  101881:	89 e5                	mov    %esp,%ebp
  101883:	57                   	push   %edi
  101884:	56                   	push   %esi
  101885:	53                   	push   %ebx
  101886:	83 ec 0c             	sub    $0xc,%esp
  101889:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  10188c:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101893:	e8 28 26 00 00       	call   103ec0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101898:	8b 46 08             	mov    0x8(%esi),%eax
  10189b:	83 f8 01             	cmp    $0x1,%eax
  10189e:	0f 85 ac 00 00 00    	jne    101950 <iput+0xd0>
  1018a4:	8b 56 0c             	mov    0xc(%esi),%edx
  1018a7:	f6 c2 02             	test   $0x2,%dl
  1018aa:	0f 84 a0 00 00 00    	je     101950 <iput+0xd0>
  1018b0:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  1018b5:	0f 85 95 00 00 00    	jne    101950 <iput+0xd0>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  1018bb:	f6 c2 01             	test   $0x1,%dl
  1018be:	66 90                	xchg   %ax,%ax
  1018c0:	0f 85 13 01 00 00    	jne    1019d9 <iput+0x159>
      panic("iput busy");
    ip->flags |= I_BUSY;
  1018c6:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  1018c9:	89 f3                	mov    %esi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  1018cb:	89 56 0c             	mov    %edx,0xc(%esi)
  1018ce:	8d 7e 30             	lea    0x30(%esi),%edi
    release(&icache.lock);
  1018d1:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  1018d8:	e8 93 25 00 00       	call   103e70 <release>
  1018dd:	eb 08                	jmp    1018e7 <iput+0x67>
  1018df:	90                   	nop    
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  1018e0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  1018e3:	39 fb                	cmp    %edi,%ebx
  1018e5:	74 20                	je     101907 <iput+0x87>
    if(ip->addrs[i]){
  1018e7:	8b 53 1c             	mov    0x1c(%ebx),%edx
  1018ea:	85 d2                	test   %edx,%edx
  1018ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  1018f0:	74 ee                	je     1018e0 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
  1018f2:	8b 06                	mov    (%esi),%eax
  1018f4:	e8 c7 fe ff ff       	call   1017c0 <bfree>
      ip->addrs[i] = 0;
  1018f9:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101900:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101903:	39 fb                	cmp    %edi,%ebx
  101905:	75 e0                	jne    1018e7 <iput+0x67>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
  101907:	8b 46 4c             	mov    0x4c(%esi),%eax
  10190a:	85 c0                	test   %eax,%eax
  10190c:	75 62                	jne    101970 <iput+0xf0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  10190e:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  101915:	89 34 24             	mov    %esi,(%esp)
  101918:	e8 33 fb ff ff       	call   101450 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  10191d:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101923:	89 34 24             	mov    %esi,(%esp)
  101926:	e8 25 fb ff ff       	call   101450 <iupdate>
    acquire(&icache.lock);
  10192b:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101932:	e8 89 25 00 00       	call   103ec0 <acquire>
    ip->flags = 0;
  101937:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
  10193e:	89 34 24             	mov    %esi,(%esp)
  101941:	e8 6a 18 00 00       	call   1031b0 <wakeup>
  101946:	8b 46 08             	mov    0x8(%esi),%eax
  101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  }
  ip->ref--;
  101950:	83 e8 01             	sub    $0x1,%eax
  101953:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
  101956:	c7 45 08 20 a2 10 00 	movl   $0x10a220,0x8(%ebp)
}
  10195d:	83 c4 0c             	add    $0xc,%esp
  101960:	5b                   	pop    %ebx
  101961:	5e                   	pop    %esi
  101962:	5f                   	pop    %edi
  101963:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101964:	e9 07 25 00 00       	jmp    103e70 <release>
  101969:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101970:	89 44 24 04          	mov    %eax,0x4(%esp)
  101974:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  101976:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101978:	89 04 24             	mov    %eax,(%esp)
  10197b:	e8 40 e7 ff ff       	call   1000c0 <bread>
    a = (uint*)bp->data;
  101980:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101982:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  101985:	83 c7 18             	add    $0x18,%edi
  101988:	31 c0                	xor    %eax,%eax
  10198a:	eb 11                	jmp    10199d <iput+0x11d>
  10198c:	8d 74 26 00          	lea    0x0(%esi),%esi
    for(j = 0; j < NINDIRECT; j++){
  101990:	83 c3 01             	add    $0x1,%ebx
  101993:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101999:	89 d8                	mov    %ebx,%eax
  10199b:	74 1b                	je     1019b8 <iput+0x138>
      if(a[j])
  10199d:	8b 14 87             	mov    (%edi,%eax,4),%edx
  1019a0:	85 d2                	test   %edx,%edx
  1019a2:	74 ec                	je     101990 <iput+0x110>
        bfree(ip->dev, a[j]);
  1019a4:	8b 06                	mov    (%esi),%eax
  1019a6:	e8 15 fe ff ff       	call   1017c0 <bfree>
  1019ab:	90                   	nop    
  1019ac:	8d 74 26 00          	lea    0x0(%esi),%esi
  1019b0:	eb de                	jmp    101990 <iput+0x110>
  1019b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
    brelse(bp);
  1019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019bb:	89 04 24             	mov    %eax,(%esp)
  1019be:	e8 3d e6 ff ff       	call   100000 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
  1019c3:	8b 56 4c             	mov    0x4c(%esi),%edx
  1019c6:	8b 06                	mov    (%esi),%eax
  1019c8:	e8 f3 fd ff ff       	call   1017c0 <bfree>
    ip->addrs[NDIRECT] = 0;
  1019cd:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  1019d4:	e9 35 ff ff ff       	jmp    10190e <iput+0x8e>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  1019d9:	c7 04 24 83 60 10 00 	movl   $0x106083,(%esp)
  1019e0:	e8 9b ee ff ff       	call   100880 <panic>
  1019e5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1019e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001019f0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  1019f0:	55                   	push   %ebp
  1019f1:	89 e5                	mov    %esp,%ebp
  1019f3:	57                   	push   %edi
  1019f4:	56                   	push   %esi
  1019f5:	53                   	push   %ebx
  1019f6:	83 ec 2c             	sub    $0x2c,%esp
  1019f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  1019fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1019ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101a06:	00 
  101a07:	89 3c 24             	mov    %edi,(%esp)
  101a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a0e:	e8 3d fc ff ff       	call   101650 <dirlookup>
  101a13:	85 c0                	test   %eax,%eax
  101a15:	0f 85 98 00 00 00    	jne    101ab3 <dirlink+0xc3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101a1b:	8b 47 18             	mov    0x18(%edi),%eax
  101a1e:	85 c0                	test   %eax,%eax
  101a20:	0f 84 9c 00 00 00    	je     101ac2 <dirlink+0xd2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101a26:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  101a29:	31 db                	xor    %ebx,%ebx
  101a2b:	eb 0b                	jmp    101a38 <dirlink+0x48>
  101a2d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101a30:	83 c3 10             	add    $0x10,%ebx
  101a33:	39 5f 18             	cmp    %ebx,0x18(%edi)
  101a36:	76 24                	jbe    101a5c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a38:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101a3f:	00 
  101a40:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101a44:	89 74 24 04          	mov    %esi,0x4(%esp)
  101a48:	89 3c 24             	mov    %edi,(%esp)
  101a4b:	e8 f0 f8 ff ff       	call   101340 <readi>
  101a50:	83 f8 10             	cmp    $0x10,%eax
  101a53:	75 52                	jne    101aa7 <dirlink+0xb7>
      panic("dirlink read");
    if(de.inum == 0)
  101a55:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  101a5a:	75 d4                	jne    101a30 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101a5f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101a66:	00 
  101a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  101a6e:	89 04 24             	mov    %eax,(%esp)
  101a71:	e8 3a 26 00 00       	call   1040b0 <strncpy>
  de.inum = inum;
  101a76:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101a81:	00 
  101a82:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101a86:	89 74 24 04          	mov    %esi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  101a8a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a8e:	89 3c 24             	mov    %edi,(%esp)
  101a91:	e8 4a fa ff ff       	call   1014e0 <writei>
    panic("dirlink");
  101a96:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a98:	83 f8 10             	cmp    $0x10,%eax
  101a9b:	75 2c                	jne    101ac9 <dirlink+0xd9>
    panic("dirlink");
  
  return 0;
}
  101a9d:	83 c4 2c             	add    $0x2c,%esp
  101aa0:	89 d0                	mov    %edx,%eax
  101aa2:	5b                   	pop    %ebx
  101aa3:	5e                   	pop    %esi
  101aa4:	5f                   	pop    %edi
  101aa5:	5d                   	pop    %ebp
  101aa6:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101aa7:	c7 04 24 8d 60 10 00 	movl   $0x10608d,(%esp)
  101aae:	e8 cd ed ff ff       	call   100880 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101ab3:	89 04 24             	mov    %eax,(%esp)
  101ab6:	e8 c5 fd ff ff       	call   101880 <iput>
  101abb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101ac0:	eb db                	jmp    101a9d <dirlink+0xad>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101ac2:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  101ac5:	31 db                	xor    %ebx,%ebx
  101ac7:	eb 93                	jmp    101a5c <dirlink+0x6c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101ac9:	c7 04 24 5a 66 10 00 	movl   $0x10665a,(%esp)
  101ad0:	e8 ab ed ff ff       	call   100880 <panic>
  101ad5:	8d 74 26 00          	lea    0x0(%esi),%esi
  101ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101ae0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101ae0:	55                   	push   %ebp
  101ae1:	89 e5                	mov    %esp,%ebp
  101ae3:	53                   	push   %ebx
  101ae4:	83 ec 04             	sub    $0x4,%esp
  101ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101aea:	89 1c 24             	mov    %ebx,(%esp)
  101aed:	e8 6e fc ff ff       	call   101760 <iunlock>
  iput(ip);
  101af2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101af5:	83 c4 04             	add    $0x4,%esp
  101af8:	5b                   	pop    %ebx
  101af9:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101afa:	e9 81 fd ff ff       	jmp    101880 <iput>
  101aff:	90                   	nop    

00101b00 <ialloc>:
static struct inode* iget(uint dev, uint inum);

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101b00:	55                   	push   %ebp
  101b01:	89 e5                	mov    %esp,%ebp
  101b03:	57                   	push   %edi
  101b04:	56                   	push   %esi
  101b05:	53                   	push   %ebx
  101b06:	83 ec 2c             	sub    $0x2c,%esp
  101b09:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101b0d:	8d 55 e8             	lea    -0x18(%ebp),%edx
static struct inode* iget(uint dev, uint inum);

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101b10:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101b14:	8b 45 08             	mov    0x8(%ebp),%eax
  101b17:	e8 54 f6 ff ff       	call   101170 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101b1c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  101b20:	0f 86 9a 00 00 00    	jbe    101bc0 <ialloc+0xc0>
  101b26:	bf 01 00 00 00       	mov    $0x1,%edi
  101b2b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  101b32:	eb 17                	jmp    101b4b <ialloc+0x4b>
  101b34:	8d 74 26 00          	lea    0x0(%esi),%esi
  101b38:	83 c7 01             	add    $0x1,%edi
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101b3b:	89 34 24             	mov    %esi,(%esp)
  101b3e:	e8 bd e4 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101b43:	3b 7d f0             	cmp    -0x10(%ebp),%edi
  101b46:	89 7d e0             	mov    %edi,-0x20(%ebp)
  101b49:	73 75                	jae    101bc0 <ialloc+0xc0>
    bp = bread(dev, IBLOCK(inum));
  101b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101b4e:	c1 e8 03             	shr    $0x3,%eax
  101b51:	83 c0 02             	add    $0x2,%eax
  101b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b58:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5b:	89 04 24             	mov    %eax,(%esp)
  101b5e:	e8 5d e5 ff ff       	call   1000c0 <bread>
  101b63:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
  101b65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101b68:	83 e0 07             	and    $0x7,%eax
  101b6b:	c1 e0 06             	shl    $0x6,%eax
  101b6e:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  101b72:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101b76:	75 c0                	jne    101b38 <ialloc+0x38>
      memset(dip, 0, sizeof(*dip));
  101b78:	89 1c 24             	mov    %ebx,(%esp)
  101b7b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101b82:	00 
  101b83:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101b8a:	00 
  101b8b:	e8 d0 23 00 00       	call   103f60 <memset>
      dip->type = type;
  101b90:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  101b94:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp);   // mark it allocated on the disk
  101b97:	89 34 24             	mov    %esi,(%esp)
  101b9a:	e8 d1 e4 ff ff       	call   100070 <bwrite>
      brelse(bp);
  101b9f:	89 34 24             	mov    %esi,(%esp)
  101ba2:	e8 59 e4 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  101ba7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	e8 ee f4 ff ff       	call   1010a0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101bb2:	83 c4 2c             	add    $0x2c,%esp
  101bb5:	5b                   	pop    %ebx
  101bb6:	5e                   	pop    %esi
  101bb7:	5f                   	pop    %edi
  101bb8:	5d                   	pop    %ebp
  101bb9:	c3                   	ret    
  101bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101bc0:	c7 04 24 9a 60 10 00 	movl   $0x10609a,(%esp)
  101bc7:	e8 b4 ec ff ff       	call   100880 <panic>
  101bcc:	8d 74 26 00          	lea    0x0(%esi),%esi

00101bd0 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101bd0:	55                   	push   %ebp
  101bd1:	89 e5                	mov    %esp,%ebp
  101bd3:	56                   	push   %esi
  101bd4:	53                   	push   %ebx
  101bd5:	83 ec 10             	sub    $0x10,%esp
  101bd8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101bdb:	85 f6                	test   %esi,%esi
  101bdd:	74 59                	je     101c38 <ilock+0x68>
  101bdf:	8b 46 08             	mov    0x8(%esi),%eax
  101be2:	85 c0                	test   %eax,%eax
  101be4:	7e 52                	jle    101c38 <ilock+0x68>
    panic("ilock");

  acquire(&icache.lock);
  101be6:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101bed:	e8 ce 22 00 00       	call   103ec0 <acquire>
  while(ip->flags & I_BUSY)
  101bf2:	8b 46 0c             	mov    0xc(%esi),%eax
  101bf5:	a8 01                	test   $0x1,%al
  101bf7:	74 1e                	je     101c17 <ilock+0x47>
  101bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
  101c00:	c7 44 24 04 20 a2 10 	movl   $0x10a220,0x4(%esp)
  101c07:	00 
  101c08:	89 34 24             	mov    %esi,(%esp)
  101c0b:	e8 10 18 00 00       	call   103420 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101c10:	8b 46 0c             	mov    0xc(%esi),%eax
  101c13:	a8 01                	test   $0x1,%al
  101c15:	75 e9                	jne    101c00 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101c17:	83 c8 01             	or     $0x1,%eax
  101c1a:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  101c1d:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101c24:	e8 47 22 00 00       	call   103e70 <release>

  if(!(ip->flags & I_VALID)){
  101c29:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101c2d:	74 19                	je     101c48 <ilock+0x78>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101c2f:	83 c4 10             	add    $0x10,%esp
  101c32:	5b                   	pop    %ebx
  101c33:	5e                   	pop    %esi
  101c34:	5d                   	pop    %ebp
  101c35:	c3                   	ret    
  101c36:	66 90                	xchg   %ax,%ax
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101c38:	c7 04 24 ac 60 10 00 	movl   $0x1060ac,(%esp)
  101c3f:	e8 3c ec ff ff       	call   100880 <panic>
  101c44:	8d 74 26 00          	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101c48:	8b 46 04             	mov    0x4(%esi),%eax
  101c4b:	c1 e8 03             	shr    $0x3,%eax
  101c4e:	83 c0 02             	add    $0x2,%eax
  101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c55:	8b 06                	mov    (%esi),%eax
  101c57:	89 04 24             	mov    %eax,(%esp)
  101c5a:	e8 61 e4 ff ff       	call   1000c0 <bread>
  101c5f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101c61:	8b 46 04             	mov    0x4(%esi),%eax
  101c64:	83 e0 07             	and    $0x7,%eax
  101c67:	c1 e0 06             	shl    $0x6,%eax
  101c6a:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  101c6e:	0f b7 10             	movzwl (%eax),%edx
  101c71:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  101c75:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101c79:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  101c7d:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101c81:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  101c85:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101c89:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  101c8d:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101c90:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101c93:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101c96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9a:	8d 46 1c             	lea    0x1c(%esi),%eax
  101c9d:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101ca4:	00 
  101ca5:	89 04 24             	mov    %eax,(%esp)
  101ca8:	e8 43 23 00 00       	call   103ff0 <memmove>
    brelse(bp);
  101cad:	89 1c 24             	mov    %ebx,(%esp)
  101cb0:	e8 4b e3 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101cb5:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    if(ip->type == 0)
  101cb9:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101cbe:	0f 85 6b ff ff ff    	jne    101c2f <ilock+0x5f>
      panic("ilock: no type");
  101cc4:	c7 04 24 b2 60 10 00 	movl   $0x1060b2,(%esp)
  101ccb:	e8 b0 eb ff ff       	call   100880 <panic>

00101cd0 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  101cd0:	55                   	push   %ebp
  101cd1:	89 e5                	mov    %esp,%ebp
  101cd3:	57                   	push   %edi
  101cd4:	56                   	push   %esi
  101cd5:	53                   	push   %ebx
  101cd6:	89 c3                	mov    %eax,%ebx
  101cd8:	83 ec 1c             	sub    $0x1c,%esp
  101cdb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  101cde:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101ce1:	80 38 2f             	cmpb   $0x2f,(%eax)
  101ce4:	0f 84 30 01 00 00    	je     101e1a <namex+0x14a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
  101cea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  101cf0:	8b 40 68             	mov    0x68(%eax),%eax
  101cf3:	89 04 24             	mov    %eax,(%esp)
  101cf6:	e8 75 f3 ff ff       	call   101070 <idup>
  101cfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101cfe:	eb 03                	jmp    101d03 <namex+0x33>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101d00:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101d03:	0f b6 03             	movzbl (%ebx),%eax
  101d06:	3c 2f                	cmp    $0x2f,%al
  101d08:	74 f6                	je     101d00 <namex+0x30>
    path++;
  if(*path == 0)
  101d0a:	84 c0                	test   %al,%al
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101d0c:	89 de                	mov    %ebx,%esi
    path++;
  if(*path == 0)
  101d0e:	75 1e                	jne    101d2e <namex+0x5e>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
  101d10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101d13:	85 c0                	test   %eax,%eax
  101d15:	0f 85 2c 01 00 00    	jne    101e47 <namex+0x177>
    iput(ip);
    return 0;
  }
  return ip;
}
  101d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101d1e:	83 c4 1c             	add    $0x1c,%esp
  101d21:	5b                   	pop    %ebx
  101d22:	5e                   	pop    %esi
  101d23:	5f                   	pop    %edi
  101d24:	5d                   	pop    %ebp
  101d25:	c3                   	ret    
  101d26:	66 90                	xchg   %ax,%ax
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  101d28:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101d2b:	0f b6 06             	movzbl (%esi),%eax
  101d2e:	3c 2f                	cmp    $0x2f,%al
  101d30:	74 04                	je     101d36 <namex+0x66>
  101d32:	84 c0                	test   %al,%al
  101d34:	75 f2                	jne    101d28 <namex+0x58>
    path++;
  len = path - s;
  101d36:	89 f2                	mov    %esi,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101d38:	89 f7                	mov    %esi,%edi
    path++;
  len = path - s;
  101d3a:	29 da                	sub    %ebx,%edx
  if(len >= DIRSIZ)
  101d3c:	83 fa 0d             	cmp    $0xd,%edx
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  len = path - s;
  101d3f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  if(len >= DIRSIZ)
  101d42:	0f 8e 90 00 00 00    	jle    101dd8 <namex+0x108>
    memmove(name, s, DIRSIZ);
  101d48:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101d4f:	00 
  101d50:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101d57:	89 04 24             	mov    %eax,(%esp)
  101d5a:	e8 91 22 00 00       	call   103ff0 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101d5f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  101d62:	75 0c                	jne    101d70 <namex+0xa0>
  101d64:	8d 74 26 00          	lea    0x0(%esi),%esi
    path++;
  101d68:	83 c7 01             	add    $0x1,%edi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101d6b:	80 3f 2f             	cmpb   $0x2f,(%edi)
  101d6e:	74 f8                	je     101d68 <namex+0x98>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
  101d70:	85 ff                	test   %edi,%edi
  101d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101d78:	74 96                	je     101d10 <namex+0x40>
    ilock(ip);
  101d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101d7d:	89 04 24             	mov    %eax,(%esp)
  101d80:	e8 4b fe ff ff       	call   101bd0 <ilock>
    if(ip->type != T_DIR){
  101d85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101d88:	66 83 7a 10 01       	cmpw   $0x1,0x10(%edx)
  101d8d:	75 71                	jne    101e00 <namex+0x130>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
  101d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101d92:	85 c0                	test   %eax,%eax
  101d94:	74 09                	je     101d9f <namex+0xcf>
  101d96:	80 3f 00             	cmpb   $0x0,(%edi)
  101d99:	0f 84 92 00 00 00    	je     101e31 <namex+0x161>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101d9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101da6:	00 
  101da7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101daa:	89 54 24 04          	mov    %edx,0x4(%esp)
  101dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101db1:	89 04 24             	mov    %eax,(%esp)
  101db4:	e8 97 f8 ff ff       	call   101650 <dirlookup>
  101db9:	85 c0                	test   %eax,%eax
  101dbb:	89 c3                	mov    %eax,%ebx
  101dbd:	74 3e                	je     101dfd <namex+0x12d>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101dc2:	89 04 24             	mov    %eax,(%esp)
  101dc5:	e8 16 fd ff ff       	call   101ae0 <iunlockput>
  101dca:	89 5d ec             	mov    %ebx,-0x14(%ebp)
  101dcd:	89 fb                	mov    %edi,%ebx
  101dcf:	e9 2f ff ff ff       	jmp    101d03 <namex+0x33>
  101dd4:	8d 74 26 00          	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101ddb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101ddf:	89 54 24 08          	mov    %edx,0x8(%esp)
  101de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101de6:	89 04 24             	mov    %eax,(%esp)
  101de9:	e8 02 22 00 00       	call   103ff0 <memmove>
    name[len] = 0;
  101dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101df1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101df4:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  101df8:	e9 62 ff ff ff       	jmp    101d5f <namex+0x8f>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101dfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101e00:	89 14 24             	mov    %edx,(%esp)
  101e03:	e8 d8 fc ff ff       	call   101ae0 <iunlockput>
  101e08:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101e12:	83 c4 1c             	add    $0x1c,%esp
  101e15:	5b                   	pop    %ebx
  101e16:	5e                   	pop    %esi
  101e17:	5f                   	pop    %edi
  101e18:	5d                   	pop    %ebp
  101e19:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  101e1a:	ba 01 00 00 00       	mov    $0x1,%edx
  101e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  101e24:	e8 77 f2 ff ff       	call   1010a0 <iget>
  101e29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101e2c:	e9 d2 fe ff ff       	jmp    101d03 <namex+0x33>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  101e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101e34:	89 04 24             	mov    %eax,(%esp)
  101e37:	e8 24 f9 ff ff       	call   101760 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101e3f:	83 c4 1c             	add    $0x1c,%esp
  101e42:	5b                   	pop    %ebx
  101e43:	5e                   	pop    %esi
  101e44:	5f                   	pop    %edi
  101e45:	5d                   	pop    %ebp
  101e46:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
  101e47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101e4a:	89 14 24             	mov    %edx,(%esp)
  101e4d:	e8 2e fa ff ff       	call   101880 <iput>
  101e52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101e59:	e9 bd fe ff ff       	jmp    101d1b <namex+0x4b>
  101e5e:	66 90                	xchg   %ax,%ax

00101e60 <nameiparent>:
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101e60:	55                   	push   %ebp
  return namex(path, 1, name);
  101e61:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101e66:	89 e5                	mov    %esp,%ebp
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return namex(path, 1, name);
}
  101e6e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
  101e6f:	e9 5c fe ff ff       	jmp    101cd0 <namex>
  101e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101e80 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  101e80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
  101e81:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  101e83:	89 e5                	mov    %esp,%ebp
  101e85:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
  101e88:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8b:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  101e8e:	e8 3d fe ff ff       	call   101cd0 <namex>
}
  101e93:	c9                   	leave  
  101e94:	c3                   	ret    
  101e95:	8d 74 26 00          	lea    0x0(%esi),%esi
  101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101ea0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  101ea0:	55                   	push   %ebp
  101ea1:	89 e5                	mov    %esp,%ebp
  101ea3:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
  101ea6:	c7 44 24 04 c1 60 10 	movl   $0x1060c1,0x4(%esp)
  101ead:	00 
  101eae:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  101eb5:	e8 76 1e 00 00       	call   103d30 <initlock>
}
  101eba:	c9                   	leave  
  101ebb:	c3                   	ret    
  101ebc:	90                   	nop    
  101ebd:	90                   	nop    
  101ebe:	90                   	nop    
  101ebf:	90                   	nop    

00101ec0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  101ec0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101ec1:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101ec6:	89 e5                	mov    %esp,%ebp
  101ec8:	56                   	push   %esi
  101ec9:	89 c6                	mov    %eax,%esi
  101ecb:	83 ec 04             	sub    $0x4,%esp
  if(b == 0)
  101ece:	85 c0                	test   %eax,%eax
  101ed0:	0f 84 88 00 00 00    	je     101f5e <idestart+0x9e>
  101ed6:	66 90                	xchg   %ax,%ax
  101ed8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  101ed9:	25 c0 00 00 00       	and    $0xc0,%eax
  101ede:	83 f8 40             	cmp    $0x40,%eax
  101ee1:	75 f5                	jne    101ed8 <idestart+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101ee3:	ba f6 03 00 00       	mov    $0x3f6,%edx
  101ee8:	31 c0                	xor    %eax,%eax
  101eea:	ee                   	out    %al,(%dx)
    panic("idestart");

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  101eeb:	ba f2 01 00 00       	mov    $0x1f2,%edx
  101ef0:	b8 01 00 00 00       	mov    $0x1,%eax
  101ef5:	ee                   	out    %al,(%dx)
  101ef6:	8b 4e 08             	mov    0x8(%esi),%ecx
  101ef9:	b2 f3                	mov    $0xf3,%dl
  101efb:	89 c8                	mov    %ecx,%eax
  101efd:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  101efe:	c1 e9 08             	shr    $0x8,%ecx
  101f01:	b2 f4                	mov    $0xf4,%dl
  101f03:	89 c8                	mov    %ecx,%eax
  101f05:	ee                   	out    %al,(%dx)
  101f06:	c1 e9 08             	shr    $0x8,%ecx
  101f09:	b2 f5                	mov    $0xf5,%dl
  101f0b:	89 c8                	mov    %ecx,%eax
  101f0d:	ee                   	out    %al,(%dx)
  101f0e:	8b 46 04             	mov    0x4(%esi),%eax
  101f11:	c1 e9 08             	shr    $0x8,%ecx
  101f14:	89 ca                	mov    %ecx,%edx
  101f16:	83 e2 0f             	and    $0xf,%edx
  101f19:	83 e0 01             	and    $0x1,%eax
  101f1c:	c1 e0 04             	shl    $0x4,%eax
  101f1f:	09 d0                	or     %edx,%eax
  101f21:	ba f6 01 00 00       	mov    $0x1f6,%edx
  101f26:	83 c8 e0             	or     $0xffffffe0,%eax
  101f29:	ee                   	out    %al,(%dx)
  101f2a:	f6 06 04             	testb  $0x4,(%esi)
  101f2d:	75 11                	jne    101f40 <idestart+0x80>
  101f2f:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101f34:	b8 20 00 00 00       	mov    $0x20,%eax
  101f39:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  101f3a:	83 c4 04             	add    $0x4,%esp
  101f3d:	5e                   	pop    %esi
  101f3e:	5d                   	pop    %ebp
  101f3f:	c3                   	ret    
  101f40:	b2 f7                	mov    $0xf7,%dl
  101f42:	b8 30 00 00 00       	mov    $0x30,%eax
  101f47:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
  101f48:	b9 80 00 00 00       	mov    $0x80,%ecx
  101f4d:	83 c6 18             	add    $0x18,%esi
  101f50:	ba f0 01 00 00       	mov    $0x1f0,%edx
  101f55:	fc                   	cld    
  101f56:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  101f58:	83 c4 04             	add    $0x4,%esp
  101f5b:	5e                   	pop    %esi
  101f5c:	5d                   	pop    %ebp
  101f5d:	c3                   	ret    
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  101f5e:	c7 04 24 c8 60 10 00 	movl   $0x1060c8,(%esp)
  101f65:	e8 16 e9 ff ff       	call   100880 <panic>
  101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00101f70 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
  101f70:	55                   	push   %ebp
  101f71:	89 e5                	mov    %esp,%ebp
  101f73:	53                   	push   %ebx
  101f74:	83 ec 14             	sub    $0x14,%esp
  101f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  101f7a:	8b 03                	mov    (%ebx),%eax
  101f7c:	a8 01                	test   $0x1,%al
  101f7e:	0f 84 90 00 00 00    	je     102014 <iderw+0xa4>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  101f84:	83 e0 06             	and    $0x6,%eax
  101f87:	83 f8 02             	cmp    $0x2,%eax
  101f8a:	0f 84 90 00 00 00    	je     102020 <iderw+0xb0>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
  101f90:	8b 53 04             	mov    0x4(%ebx),%edx
  101f93:	85 d2                	test   %edx,%edx
  101f95:	74 0d                	je     101fa4 <iderw+0x34>
  101f97:	a1 f8 7f 10 00       	mov    0x107ff8,%eax
  101f9c:	85 c0                	test   %eax,%eax
  101f9e:	0f 84 88 00 00 00    	je     10202c <iderw+0xbc>
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);
  101fa4:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  101fab:	e8 10 1f 00 00       	call   103ec0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  101fb0:	ba f4 7f 10 00       	mov    $0x107ff4,%edx
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);

  // Append b to idequeue.
  b->qnext = 0;
  101fb5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  101fbc:	a1 f4 7f 10 00       	mov    0x107ff4,%eax
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  101fc1:	85 c0                	test   %eax,%eax
  101fc3:	74 0d                	je     101fd2 <iderw+0x62>
  101fc5:	8d 76 00             	lea    0x0(%esi),%esi
  101fc8:	8d 50 14             	lea    0x14(%eax),%edx
  101fcb:	8b 40 14             	mov    0x14(%eax),%eax
  101fce:	85 c0                	test   %eax,%eax
  101fd0:	75 f6                	jne    101fc8 <iderw+0x58>
    ;
  *pp = b;
  101fd2:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(idequeue == b)
  101fd4:	39 1d f4 7f 10 00    	cmp    %ebx,0x107ff4
  101fda:	75 14                	jne    101ff0 <iderw+0x80>
  101fdc:	eb 2d                	jmp    10200b <iderw+0x9b>
  101fde:	66 90                	xchg   %ax,%ax
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &idelock);
  101fe0:	c7 44 24 04 c0 7f 10 	movl   $0x107fc0,0x4(%esp)
  101fe7:	00 
  101fe8:	89 1c 24             	mov    %ebx,(%esp)
  101feb:	e8 30 14 00 00       	call   103420 <sleep>
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  101ff0:	8b 03                	mov    (%ebx),%eax
  101ff2:	83 e0 06             	and    $0x6,%eax
  101ff5:	83 f8 02             	cmp    $0x2,%eax
  101ff8:	75 e6                	jne    101fe0 <iderw+0x70>
    sleep(b, &idelock);

  release(&idelock);
  101ffa:	c7 45 08 c0 7f 10 00 	movl   $0x107fc0,0x8(%ebp)
}
  102001:	83 c4 14             	add    $0x14,%esp
  102004:	5b                   	pop    %ebx
  102005:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &idelock);

  release(&idelock);
  102006:	e9 65 1e 00 00       	jmp    103e70 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  10200b:	89 d8                	mov    %ebx,%eax
  10200d:	e8 ae fe ff ff       	call   101ec0 <idestart>
  102012:	eb dc                	jmp    101ff0 <iderw+0x80>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  102014:	c7 04 24 d1 60 10 00 	movl   $0x1060d1,(%esp)
  10201b:	e8 60 e8 ff ff       	call   100880 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  102020:	c7 04 24 e5 60 10 00 	movl   $0x1060e5,(%esp)
  102027:	e8 54 e8 ff ff       	call   100880 <panic>
  if(b->dev != 0 && !havedisk1)
    panic("idrw: ide disk 1 not present");
  10202c:	c7 04 24 fa 60 10 00 	movl   $0x1060fa,(%esp)
  102033:	e8 48 e8 ff ff       	call   100880 <panic>
  102038:	90                   	nop    
  102039:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102040 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
  102040:	55                   	push   %ebp
  102041:	89 e5                	mov    %esp,%ebp
  102043:	57                   	push   %edi
  102044:	53                   	push   %ebx
  102045:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // Take first buffer off queue.
  acquire(&idelock);
  102048:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  10204f:	e8 6c 1e 00 00       	call   103ec0 <acquire>
  if((b = idequeue) == 0){
  102054:	8b 1d f4 7f 10 00    	mov    0x107ff4,%ebx
  10205a:	85 db                	test   %ebx,%ebx
  10205c:	74 7a                	je     1020d8 <ideintr+0x98>
    release(&idelock);
    cprintf("Spurious IDE interrupt.\n");
    return;
  }
  idequeue = b->qnext;
  10205e:	8b 43 14             	mov    0x14(%ebx),%eax
  102061:	a3 f4 7f 10 00       	mov    %eax,0x107ff4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
  102066:	8b 0b                	mov    (%ebx),%ecx
  102068:	f6 c1 04             	test   $0x4,%cl
  10206b:	74 33                	je     1020a0 <ideintr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  10206d:	83 c9 02             	or     $0x2,%ecx
  102070:	83 e1 fb             	and    $0xfffffffb,%ecx
  102073:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  102075:	89 1c 24             	mov    %ebx,(%esp)
  102078:	e8 33 11 00 00       	call   1031b0 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
  10207d:	a1 f4 7f 10 00       	mov    0x107ff4,%eax
  102082:	85 c0                	test   %eax,%eax
  102084:	74 05                	je     10208b <ideintr+0x4b>
    idestart(idequeue);
  102086:	e8 35 fe ff ff       	call   101ec0 <idestart>

  release(&idelock);
  10208b:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  102092:	e8 d9 1d 00 00       	call   103e70 <release>
}
  102097:	83 c4 10             	add    $0x10,%esp
  10209a:	5b                   	pop    %ebx
  10209b:	5f                   	pop    %edi
  10209c:	5d                   	pop    %ebp
  10209d:	c3                   	ret    
  10209e:	66 90                	xchg   %ax,%ax
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1020a0:	bf f7 01 00 00       	mov    $0x1f7,%edi
  1020a5:	8d 76 00             	lea    0x0(%esi),%esi
  1020a8:	89 fa                	mov    %edi,%edx
  1020aa:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  1020ab:	0f b6 d0             	movzbl %al,%edx
  1020ae:	89 d0                	mov    %edx,%eax
  1020b0:	25 c0 00 00 00       	and    $0xc0,%eax
  1020b5:	83 f8 40             	cmp    $0x40,%eax
  1020b8:	75 ee                	jne    1020a8 <ideintr+0x68>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
  1020ba:	83 e2 21             	and    $0x21,%edx
  1020bd:	75 ae                	jne    10206d <ideintr+0x2d>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
  1020bf:	8d 7b 18             	lea    0x18(%ebx),%edi
  1020c2:	b9 80 00 00 00       	mov    $0x80,%ecx
  1020c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
  1020cc:	fc                   	cld    
  1020cd:	f3 6d                	rep insl (%dx),%es:(%edi)
  1020cf:	8b 0b                	mov    (%ebx),%ecx
  1020d1:	eb 9a                	jmp    10206d <ideintr+0x2d>
  1020d3:	90                   	nop    
  1020d4:	8d 74 26 00          	lea    0x0(%esi),%esi
  struct buf *b;

  // Take first buffer off queue.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
  1020d8:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  1020df:	e8 8c 1d 00 00       	call   103e70 <release>
    cprintf("Spurious IDE interrupt.\n");
  1020e4:	c7 04 24 17 61 10 00 	movl   $0x106117,(%esp)
  1020eb:	e8 b0 e3 ff ff       	call   1004a0 <cprintf>
  1020f0:	eb a5                	jmp    102097 <ideintr+0x57>
  1020f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102100 <ideinit>:
  return 0;
}

void
ideinit(void)
{
  102100:	55                   	push   %ebp
  102101:	89 e5                	mov    %esp,%ebp
  102103:	53                   	push   %ebx
  102104:	83 ec 14             	sub    $0x14,%esp
  int i;

  initlock(&idelock, "ide");
  102107:	c7 44 24 04 30 61 10 	movl   $0x106130,0x4(%esp)
  10210e:	00 
  10210f:	c7 04 24 c0 7f 10 00 	movl   $0x107fc0,(%esp)
  102116:	e8 15 1c 00 00       	call   103d30 <initlock>
  picenable(IRQ_IDE);
  10211b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102122:	e8 89 0b 00 00       	call   102cb0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
  102127:	a1 40 b8 10 00       	mov    0x10b840,%eax
  10212c:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102133:	83 e8 01             	sub    $0x1,%eax
  102136:	89 44 24 04          	mov    %eax,0x4(%esp)
  10213a:	e8 61 00 00 00       	call   1021a0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10213f:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102144:	8d 74 26 00          	lea    0x0(%esi),%esi
  102148:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  102149:	25 c0 00 00 00       	and    $0xc0,%eax
  10214e:	83 f8 40             	cmp    $0x40,%eax
  102151:	75 f5                	jne    102148 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102153:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102158:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  10215d:	ee                   	out    %al,(%dx)
  10215e:	31 db                	xor    %ebx,%ebx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102160:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
  102165:	eb 0c                	jmp    102173 <ideinit+0x73>
  102167:	90                   	nop    
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  102168:	83 c3 01             	add    $0x1,%ebx
  10216b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  102171:	74 11                	je     102184 <ideinit+0x84>
  102173:	89 ca                	mov    %ecx,%edx
  102175:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  102176:	84 c0                	test   %al,%al
  102178:	74 ee                	je     102168 <ideinit+0x68>
      havedisk1 = 1;
  10217a:	c7 05 f8 7f 10 00 01 	movl   $0x1,0x107ff8
  102181:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102184:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102189:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  10218e:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  10218f:	83 c4 14             	add    $0x14,%esp
  102192:	5b                   	pop    %ebx
  102193:	5d                   	pop    %ebp
  102194:	c3                   	ret    
  102195:	90                   	nop    
  102196:	90                   	nop    
  102197:	90                   	nop    
  102198:	90                   	nop    
  102199:	90                   	nop    
  10219a:	90                   	nop    
  10219b:	90                   	nop    
  10219c:	90                   	nop    
  10219d:	90                   	nop    
  10219e:	90                   	nop    
  10219f:	90                   	nop    

001021a0 <ioapicenable>:
}

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
  1021a0:	8b 15 44 b2 10 00    	mov    0x10b244,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
  1021a6:	55                   	push   %ebp
  1021a7:	89 e5                	mov    %esp,%ebp
  1021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  1021ac:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
  1021ae:	53                   	push   %ebx
  1021af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  1021b2:	74 2b                	je     1021df <ioapicenable+0x3f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  1021b4:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
  1021b8:	8d 48 20             	lea    0x20(%eax),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021bb:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  1021c0:	c1 e3 18             	shl    $0x18,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021c3:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  1021c5:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021ca:	83 c2 01             	add    $0x1,%edx
  ioapic->data = data;
  1021cd:	89 48 10             	mov    %ecx,0x10(%eax)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1021d0:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  1021d5:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  1021d7:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  1021dc:	89 58 10             	mov    %ebx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
  1021df:	5b                   	pop    %ebx
  1021e0:	5d                   	pop    %ebp
  1021e1:	c3                   	ret    
  1021e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
  1021f0:	55                   	push   %ebp
  1021f1:	89 e5                	mov    %esp,%ebp
  1021f3:	56                   	push   %esi
  1021f4:	53                   	push   %ebx
  1021f5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  1021f8:	8b 0d 44 b2 10 00    	mov    0x10b244,%ecx
  1021fe:	85 c9                	test   %ecx,%ecx
  102200:	74 7e                	je     102280 <ioapicinit+0x90>
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  102202:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  102209:	00 00 00 
  return ioapic->data;
  10220c:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  102211:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  102218:	00 00 00 
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  10221b:	0f b6 15 40 b2 10 00 	movzbl 0x10b240,%edx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102222:	c7 05 f4 b1 10 00 00 	movl   $0xfec00000,0x10b1f4
  102229:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  10222c:	c1 e8 10             	shr    $0x10,%eax
  10222f:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
  102232:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  102237:	c1 e8 18             	shr    $0x18,%eax
  10223a:	39 c2                	cmp    %eax,%edx
  10223c:	75 4a                	jne    102288 <ioapicinit+0x98>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  10223e:	31 db                	xor    %ebx,%ebx
  102240:	b9 10 00 00 00       	mov    $0x10,%ecx
  102245:	8d 76 00             	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102248:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  10224d:	8d 53 20             	lea    0x20(%ebx),%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  102250:	83 c3 01             	add    $0x1,%ebx
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  102253:	81 ca 00 00 01 00    	or     $0x10000,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102259:	89 08                	mov    %ecx,(%eax)
  ioapic->data = data;
  10225b:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  102260:	89 50 10             	mov    %edx,0x10(%eax)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102263:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  102268:	8d 51 01             	lea    0x1(%ecx),%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10226b:	83 c1 02             	add    $0x2,%ecx
  10226e:	39 de                	cmp    %ebx,%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102270:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  102272:	a1 f4 b1 10 00       	mov    0x10b1f4,%eax
  102277:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10227e:	7d c8                	jge    102248 <ioapicinit+0x58>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
  102280:	83 c4 10             	add    $0x10,%esp
  102283:	5b                   	pop    %ebx
  102284:	5e                   	pop    %esi
  102285:	5d                   	pop    %ebp
  102286:	c3                   	ret    
  102287:	90                   	nop    

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  102288:	c7 04 24 34 61 10 00 	movl   $0x106134,(%esp)
  10228f:	e8 0c e2 ff ff       	call   1004a0 <cprintf>
  102294:	eb a8                	jmp    10223e <ioapicinit+0x4e>
  102296:	90                   	nop    
  102297:	90                   	nop    
  102298:	90                   	nop    
  102299:	90                   	nop    
  10229a:	90                   	nop    
  10229b:	90                   	nop    
  10229c:	90                   	nop    
  10229d:	90                   	nop    
  10229e:	90                   	nop    
  10229f:	90                   	nop    

001022a0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1022a0:	55                   	push   %ebp
  1022a1:	89 e5                	mov    %esp,%ebp
  1022a3:	53                   	push   %ebx
  1022a4:	83 ec 04             	sub    $0x4,%esp
  1022a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1022aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
  1022b0:	74 0e                	je     1022c0 <kalloc+0x20>
    panic("kalloc");
  1022b2:	c7 04 24 66 61 10 00 	movl   $0x106166,(%esp)
  1022b9:	e8 c2 e5 ff ff       	call   100880 <panic>
  1022be:	66 90                	xchg   %ax,%ax
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1022c0:	85 db                	test   %ebx,%ebx
  1022c2:	7e ee                	jle    1022b2 <kalloc+0x12>
    panic("kalloc");

  acquire(&kmem.lock);
  1022c4:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  1022cb:	e8 f0 1b 00 00       	call   103ec0 <acquire>
  1022d0:	8b 15 34 b2 10 00    	mov    0x10b234,%edx
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
  1022d6:	85 d2                	test   %edx,%edx
  1022d8:	74 1d                	je     1022f7 <kalloc+0x57>
    if(r->len >= n){
  1022da:	8b 42 04             	mov    0x4(%edx),%eax
  1022dd:	b9 34 b2 10 00       	mov    $0x10b234,%ecx
  1022e2:	39 c3                	cmp    %eax,%ebx
  1022e4:	7f 09                	jg     1022ef <kalloc+0x4f>
  1022e6:	eb 38                	jmp    102320 <kalloc+0x80>
  1022e8:	8b 42 04             	mov    0x4(%edx),%eax
  1022eb:	39 c3                	cmp    %eax,%ebx
  1022ed:	7e 31                	jle    102320 <kalloc+0x80>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
  1022ef:	89 d1                	mov    %edx,%ecx
  1022f1:	8b 12                	mov    (%edx),%edx
  1022f3:	85 d2                	test   %edx,%edx
  1022f5:	75 f1                	jne    1022e8 <kalloc+0x48>
      return p;
    }
  }
  release(&kmem.lock);

  cprintf("kalloc: out of memory\n");
  1022f7:	31 db                	xor    %ebx,%ebx
        *rp = r->next;
      release(&kmem.lock);
      return p;
    }
  }
  release(&kmem.lock);
  1022f9:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  102300:	e8 6b 1b 00 00       	call   103e70 <release>

  cprintf("kalloc: out of memory\n");
  102305:	c7 04 24 6d 61 10 00 	movl   $0x10616d,(%esp)
  10230c:	e8 8f e1 ff ff       	call   1004a0 <cprintf>
  return 0;
}
  102311:	89 d8                	mov    %ebx,%eax
  102313:	83 c4 04             	add    $0x4,%esp
  102316:	5b                   	pop    %ebx
  102317:	5d                   	pop    %ebp
  102318:	c3                   	ret    
  102319:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    panic("kalloc");

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len >= n){
      r->len -= n;
  102320:	29 d8                	sub    %ebx,%eax
      p = (char*)r + r->len;
      if(r->len == 0)
  102322:	85 c0                	test   %eax,%eax
    panic("kalloc");

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len >= n){
      r->len -= n;
  102324:	89 c3                	mov    %eax,%ebx
  102326:	89 42 04             	mov    %eax,0x4(%edx)
      p = (char*)r + r->len;
      if(r->len == 0)
  102329:	75 04                	jne    10232f <kalloc+0x8f>
        *rp = r->next;
  10232b:	8b 02                	mov    (%edx),%eax
  10232d:	89 01                	mov    %eax,(%ecx)

  acquire(&kmem.lock);
  for(rp=&kmem.freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len >= n){
      r->len -= n;
      p = (char*)r + r->len;
  10232f:	8d 1c 1a             	lea    (%edx,%ebx,1),%ebx
      if(r->len == 0)
        *rp = r->next;
      release(&kmem.lock);
  102332:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  102339:	e8 32 1b 00 00       	call   103e70 <release>
  }
  release(&kmem.lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10233e:	89 d8                	mov    %ebx,%eax
  102340:	83 c4 04             	add    $0x4,%esp
  102343:	5b                   	pop    %ebx
  102344:	5d                   	pop    %ebp
  102345:	c3                   	ret    
  102346:	8d 76 00             	lea    0x0(%esi),%esi
  102349:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102350 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102350:	55                   	push   %ebp
  102351:	89 e5                	mov    %esp,%ebp
  102353:	57                   	push   %edi
  102354:	56                   	push   %esi
  102355:	53                   	push   %ebx
  102356:	83 ec 1c             	sub    $0x1c,%esp
  102359:	8b 45 0c             	mov    0xc(%ebp),%eax
  10235c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  10235f:	85 c0                	test   %eax,%eax
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  102364:	7e 07                	jle    10236d <kfree+0x1d>
  102366:	a9 ff 0f 00 00       	test   $0xfff,%eax
  10236b:	74 13                	je     102380 <kfree+0x30>
    panic("kfree");
  10236d:	c7 04 24 84 61 10 00 	movl   $0x106184,(%esp)
  102374:	e8 07 e5 ff ff       	call   100880 <panic>
  102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  102380:	8b 45 f0             	mov    -0x10(%ebp),%eax

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102383:	bf 34 b2 10 00       	mov    $0x10b234,%edi

  if(len <= 0 || len % PAGE)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  102388:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10238f:	00 
  102390:	89 1c 24             	mov    %ebx,(%esp)
  102393:	89 44 24 08          	mov    %eax,0x8(%esp)
  102397:	e8 c4 1b 00 00       	call   103f60 <memset>

  acquire(&kmem.lock);
  10239c:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  1023a3:	e8 18 1b 00 00       	call   103ec0 <acquire>
  p = (struct run*)v;
  1023a8:	8b 15 34 b2 10 00    	mov    0x10b234,%edx
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023ae:	85 d2                	test   %edx,%edx
  1023b0:	74 7e                	je     102430 <kfree+0xe0>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023b5:	bf 34 b2 10 00       	mov    $0x10b234,%edi
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1023ba:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023bd:	39 d6                	cmp    %edx,%esi
  1023bf:	72 6f                	jb     102430 <kfree+0xe0>
    rend = (struct run*)((char*)r + r->len);
  1023c1:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  1023c4:	39 d3                	cmp    %edx,%ebx

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  1023c6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    if(r <= p && p < rend)
  1023c9:	73 5d                	jae    102428 <kfree+0xd8>
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
  1023cb:	39 d9                	cmp    %ebx,%ecx
  1023cd:	74 71                	je     102440 <kfree+0xf0>
        r->len += r->next->len;
        r->next = r->next->next;
      }
      goto out;
    }
    if(pend == r){  // p before r: expand p to include, replace r
  1023cf:	39 d6                	cmp    %edx,%esi
  1023d1:	bf 34 b2 10 00       	mov    $0x10b234,%edi
  1023d6:	74 30                	je     102408 <kfree+0xb8>
  memset(v, 1, len);

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023d8:	89 d7                	mov    %edx,%edi
  1023da:	8b 12                	mov    (%edx),%edx
  1023dc:	85 d2                	test   %edx,%edx
  1023de:	74 50                	je     102430 <kfree+0xe0>
  1023e0:	39 d6                	cmp    %edx,%esi
  1023e2:	72 4c                	jb     102430 <kfree+0xe0>
    rend = (struct run*)((char*)r + r->len);
  1023e4:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  1023e7:	39 d3                	cmp    %edx,%ebx

  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  1023e9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    if(r <= p && p < rend)
  1023ec:	72 12                	jb     102400 <kfree+0xb0>
  1023ee:	39 cb                	cmp    %ecx,%ebx
  1023f0:	73 0e                	jae    102400 <kfree+0xb0>
      panic("freeing free page");
  1023f2:	c7 04 24 8a 61 10 00 	movl   $0x10618a,(%esp)
  1023f9:	e8 82 e4 ff ff       	call   100880 <panic>
  1023fe:	66 90                	xchg   %ax,%ax
    if(rend == p){  // r before p: expand r to include p
  102400:	39 d9                	cmp    %ebx,%ecx
  102402:	74 3c                	je     102440 <kfree+0xf0>
        r->len += r->next->len;
        r->next = r->next->next;
      }
      goto out;
    }
    if(pend == r){  // p before r: expand p to include, replace r
  102404:	39 d6                	cmp    %edx,%esi
  102406:	75 d0                	jne    1023d8 <kfree+0x88>
      p->len = len + r->len;
  102408:	03 45 f0             	add    -0x10(%ebp),%eax
  10240b:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  10240e:	8b 06                	mov    (%esi),%eax
  102410:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  102412:	89 1f                	mov    %ebx,(%edi)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kmem.lock);
  102414:	c7 45 08 00 b2 10 00 	movl   $0x10b200,0x8(%ebp)
}
  10241b:	83 c4 1c             	add    $0x1c,%esp
  10241e:	5b                   	pop    %ebx
  10241f:	5e                   	pop    %esi
  102420:	5f                   	pop    %edi
  102421:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kmem.lock);
  102422:	e9 49 1a 00 00       	jmp    103e70 <release>
  102427:	90                   	nop    
  acquire(&kmem.lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102428:	39 cb                	cmp    %ecx,%ebx
  10242a:	72 c6                	jb     1023f2 <kfree+0xa2>
  10242c:	eb 9d                	jmp    1023cb <kfree+0x7b>
  10242e:	66 90                	xchg   %ax,%ax
      *rp = p;
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  p->next = r;
  102433:	89 13                	mov    %edx,(%ebx)
      *rp = p;
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102435:	89 43 04             	mov    %eax,0x4(%ebx)
  p->next = r;
  *rp = p;
  102438:	89 1f                	mov    %ebx,(%edi)
  10243a:	eb d8                	jmp    102414 <kfree+0xc4>
  10243c:	8d 74 26 00          	lea    0x0(%esi),%esi
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102440:	8b 0a                	mov    (%edx),%ecx
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
      r->len += len;
  102442:	03 45 f0             	add    -0x10(%ebp),%eax
      if(r->next && r->next == pend){  // r now next to r->next?
  102445:	85 c9                	test   %ecx,%ecx
  for(rp=&kmem.freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(rend == p){  // r before p: expand r to include p
      r->len += len;
  102447:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10244a:	74 c8                	je     102414 <kfree+0xc4>
  10244c:	39 ce                	cmp    %ecx,%esi
  10244e:	75 c4                	jne    102414 <kfree+0xc4>
        r->len += r->next->len;
  102450:	03 46 04             	add    0x4(%esi),%eax
  102453:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  102456:	8b 06                	mov    (%esi),%eax
  102458:	89 02                	mov    %eax,(%edx)
  10245a:	eb b8                	jmp    102414 <kfree+0xc4>
  10245c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102460 <kinit>:
// This code cheats by just considering one megabyte of
// pages after end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102460:	55                   	push   %ebp
  102461:	89 e5                	mov    %esp,%ebp
  102463:	83 ec 08             	sub    $0x8,%esp
  extern char end[];
  uint len;
  char *p;

  initlock(&kmem.lock, "kmem");
  102466:	c7 44 24 04 9c 61 10 	movl   $0x10619c,0x4(%esp)
  10246d:	00 
  10246e:	c7 04 24 00 b2 10 00 	movl   $0x10b200,(%esp)
  102475:	e8 b6 18 00 00       	call   103d30 <initlock>
  p = (char*)(((uint)end + PAGE) & ~(PAGE-1));
  len = 256*PAGE; // assume computer has 256 pages of RAM, 1 MB
  cprintf("mem = %d\n", len);
  10247a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  102481:	00 
  102482:	c7 04 24 a1 61 10 00 	movl   $0x1061a1,(%esp)
  102489:	e8 12 e0 ff ff       	call   1004a0 <cprintf>
  kfree(p, len);
  10248e:	b8 e4 ef 10 00       	mov    $0x10efe4,%eax
  102493:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102498:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10249f:	00 
  1024a0:	89 04 24             	mov    %eax,(%esp)
  1024a3:	e8 a8 fe ff ff       	call   102350 <kfree>
}
  1024a8:	c9                   	leave  
  1024a9:	c3                   	ret    
  1024aa:	90                   	nop    
  1024ab:	90                   	nop    
  1024ac:	90                   	nop    
  1024ad:	90                   	nop    
  1024ae:	90                   	nop    
  1024af:	90                   	nop    

001024b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
  1024b0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1024b1:	ba 64 00 00 00       	mov    $0x64,%edx
  1024b6:	89 e5                	mov    %esp,%ebp
  1024b8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  1024b9:	a8 01                	test   $0x1,%al
  1024bb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1024c0:	74 76                	je     102538 <kbdgetc+0x88>
  1024c2:	ba 60 00 00 00       	mov    $0x60,%edx
  1024c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  1024c8:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
  1024cb:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
  1024d1:	0f 84 99 00 00 00    	je     102570 <kbdgetc+0xc0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  1024d7:	84 c9                	test   %cl,%cl
  1024d9:	78 65                	js     102540 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  1024db:	a1 fc 7f 10 00       	mov    0x107ffc,%eax
  1024e0:	a8 40                	test   $0x40,%al
  1024e2:	74 0b                	je     1024ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  1024e4:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  1024e7:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  1024ea:	a3 fc 7f 10 00       	mov    %eax,0x107ffc
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1024ef:	0f b6 91 c0 62 10 00 	movzbl 0x1062c0(%ecx),%edx
  1024f6:	0f b6 81 c0 61 10 00 	movzbl 0x1061c0(%ecx),%eax
  1024fd:	0b 05 fc 7f 10 00    	or     0x107ffc,%eax
  102503:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  102505:	89 c2                	mov    %eax,%edx
  102507:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  10250a:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  10250c:	8b 14 95 c0 63 10 00 	mov    0x1063c0(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102513:	a3 fc 7f 10 00       	mov    %eax,0x107ffc
  c = charcode[shift & (CTL | SHIFT)][data];
  102518:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  10251c:	74 1a                	je     102538 <kbdgetc+0x88>
    if('a' <= c && c <= 'z')
  10251e:	8d 42 9f             	lea    -0x61(%edx),%eax
  102521:	83 f8 19             	cmp    $0x19,%eax
  102524:	76 5a                	jbe    102580 <kbdgetc+0xd0>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  102526:	8d 42 bf             	lea    -0x41(%edx),%eax
  102529:	83 f8 19             	cmp    $0x19,%eax
  10252c:	77 0a                	ja     102538 <kbdgetc+0x88>
      c += 'a' - 'A';
  10252e:	83 c2 20             	add    $0x20,%edx
  102531:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  }
  return c;
}
  102538:	89 d0                	mov    %edx,%eax
  10253a:	5d                   	pop    %ebp
  10253b:	c3                   	ret    
  10253c:	8d 74 26 00          	lea    0x0(%esi),%esi
  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  102540:	8b 15 fc 7f 10 00    	mov    0x107ffc,%edx
  102546:	f6 c2 40             	test   $0x40,%dl
  102549:	75 03                	jne    10254e <kbdgetc+0x9e>
  10254b:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  10254e:	0f b6 81 c0 61 10 00 	movzbl 0x1061c0(%ecx),%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102555:	5d                   	pop    %ebp
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
  102556:	83 c8 40             	or     $0x40,%eax
  102559:	0f b6 c0             	movzbl %al,%eax
  10255c:	f7 d0                	not    %eax
  10255e:	21 d0                	and    %edx,%eax
  102560:	31 d2                	xor    %edx,%edx
  102562:	a3 fc 7f 10 00       	mov    %eax,0x107ffc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102567:	89 d0                	mov    %edx,%eax
  102569:	c3                   	ret    
  10256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  102570:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102572:	89 d0                	mov    %edx,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  102574:	83 0d fc 7f 10 00 40 	orl    $0x40,0x107ffc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  10257b:	5d                   	pop    %ebp
  10257c:	c3                   	ret    
  10257d:	8d 76 00             	lea    0x0(%esi),%esi
  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
  102580:	83 ea 20             	sub    $0x20,%edx
  102583:	eb b3                	jmp    102538 <kbdgetc+0x88>
  102585:	8d 74 26 00          	lea    0x0(%esi),%esi
  102589:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102590 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
  102590:	55                   	push   %ebp
  102591:	89 e5                	mov    %esp,%ebp
  102593:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
  102596:	c7 04 24 b0 24 10 00 	movl   $0x1024b0,(%esp)
  10259d:	e8 6e e1 ff ff       	call   100710 <consoleintr>
}
  1025a2:	c9                   	leave  
  1025a3:	c3                   	ret    
  1025a4:	90                   	nop    
  1025a5:	90                   	nop    
  1025a6:	90                   	nop    
  1025a7:	90                   	nop    
  1025a8:	90                   	nop    
  1025a9:	90                   	nop    
  1025aa:	90                   	nop    
  1025ab:	90                   	nop    
  1025ac:	90                   	nop    
  1025ad:	90                   	nop    
  1025ae:	90                   	nop    
  1025af:	90                   	nop    

001025b0 <lapicinit>:
}

void
lapicinit(int c)
{
  if(!lapic) 
  1025b0:	a1 38 b2 10 00       	mov    0x10b238,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(int c)
{
  1025b5:	55                   	push   %ebp
  1025b6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1025b8:	85 c0                	test   %eax,%eax
  1025ba:	0f 84 09 01 00 00    	je     1026c9 <lapicinit+0x119>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1025c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  1025c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1025ca:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1025cf:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1025d2:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1025d9:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1025dc:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1025e1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1025e4:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  1025eb:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  1025ee:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1025f3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1025f6:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  1025fd:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  102600:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102605:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102608:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10260f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  102612:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102617:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10261a:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102621:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  102624:	8b 15 38 b2 10 00    	mov    0x10b238,%edx
  10262a:	8b 42 20             	mov    0x20(%edx),%eax
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10262d:	8b 42 30             	mov    0x30(%edx),%eax
  102630:	c1 e8 10             	shr    $0x10,%eax
  102633:	3c 03                	cmp    $0x3,%al
  102635:	0f 87 95 00 00 00    	ja     1026d0 <lapicinit+0x120>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10263b:	c7 82 70 03 00 00 33 	movl   $0x33,0x370(%edx)
  102642:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102645:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10264a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10264d:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102657:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10265c:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10265f:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102666:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102669:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10266e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102671:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102678:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10267b:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102680:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102683:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  10268a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10268d:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102692:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102695:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  10269c:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  10269f:	8b 0d 38 b2 10 00    	mov    0x10b238,%ecx
  1026a5:	8b 41 20             	mov    0x20(%ecx),%eax
  1026a8:	8d 91 00 03 00 00    	lea    0x300(%ecx),%edx
  1026ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  1026b0:	8b 02                	mov    (%edx),%eax
  1026b2:	f6 c4 10             	test   $0x10,%ah
  1026b5:	75 f9                	jne    1026b0 <lapicinit+0x100>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026b7:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
  1026be:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026c1:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1026c6:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1026c9:	5d                   	pop    %ebp
  1026ca:	c3                   	ret    
  1026cb:	90                   	nop    
  1026cc:	8d 74 26 00          	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026d0:	c7 82 40 03 00 00 00 	movl   $0x10000,0x340(%edx)
  1026d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1026da:	8b 15 38 b2 10 00    	mov    0x10b238,%edx
  1026e0:	8b 42 20             	mov    0x20(%edx),%eax
  1026e3:	e9 53 ff ff ff       	jmp    10263b <lapicinit+0x8b>
  1026e8:	90                   	nop    
  1026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001026f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
  1026f0:	a1 38 b2 10 00       	mov    0x10b238,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
  1026f5:	55                   	push   %ebp
  1026f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
  1026f8:	85 c0                	test   %eax,%eax
  1026fa:	74 12                	je     10270e <lapiceoi+0x1e>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102703:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102706:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10270b:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  10270e:	5d                   	pop    %ebp
  10270f:	c3                   	ret    

00102710 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  102710:	55                   	push   %ebp
  102711:	89 e5                	mov    %esp,%ebp
}
  102713:	5d                   	pop    %ebp
  102714:	c3                   	ret    
  102715:	8d 74 26 00          	lea    0x0(%esi),%esi
  102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102720 <lapicstartap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
  102720:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102721:	ba 70 00 00 00       	mov    $0x70,%edx
  102726:	89 e5                	mov    %esp,%ebp
  102728:	b8 0f 00 00 00       	mov    $0xf,%eax
  10272d:	53                   	push   %ebx
  10272e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102731:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  102735:	ee                   	out    %al,(%dx)
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102736:	b8 0a 00 00 00       	mov    $0xa,%eax
  10273b:	b2 71                	mov    $0x71,%dl
  10273d:	ee                   	out    %al,(%dx)
  10273e:	a1 38 b2 10 00       	mov    0x10b238,%eax
  102743:	c1 e3 18             	shl    $0x18,%ebx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102746:	c1 e9 04             	shr    $0x4,%ecx
  102749:	66 89 0d 69 04 00 00 	mov    %cx,0x469

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  102750:	c1 e9 08             	shr    $0x8,%ecx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102753:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  10275a:	00 00 

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  10275c:	80 cd 06             	or     $0x6,%ch
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10275f:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102765:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10276a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10276d:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
  102774:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102777:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10277c:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10277f:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
  102786:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102789:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10278e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102791:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102797:	a1 38 b2 10 00       	mov    0x10b238,%eax
  10279c:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10279f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027a5:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1027aa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027ad:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027b3:	a1 38 b2 10 00       	mov    0x10b238,%eax
  1027b8:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027bb:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027c1:	a1 38 b2 10 00       	mov    0x10b238,%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  1027c6:	5b                   	pop    %ebx
  1027c7:	5d                   	pop    %ebp

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  1027c8:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  1027cb:	c3                   	ret    
  1027cc:	8d 74 26 00          	lea    0x0(%esi),%esi

001027d0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
  1027d0:	55                   	push   %ebp
  1027d1:	89 e5                	mov    %esp,%ebp
  1027d3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1027d6:	9c                   	pushf  
  1027d7:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
  1027d8:	f6 c4 02             	test   $0x2,%ah
  1027db:	74 12                	je     1027ef <cpunum+0x1f>
    static int n;
    if(n++ == 0)
  1027dd:	8b 15 00 80 10 00    	mov    0x108000,%edx
  1027e3:	8d 42 01             	lea    0x1(%edx),%eax
  1027e6:	85 d2                	test   %edx,%edx
  1027e8:	a3 00 80 10 00       	mov    %eax,0x108000
  1027ed:	74 19                	je     102808 <cpunum+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if(lapic)
  1027ef:	8b 15 38 b2 10 00    	mov    0x10b238,%edx
  1027f5:	31 c0                	xor    %eax,%eax
  1027f7:	85 d2                	test   %edx,%edx
  1027f9:	74 06                	je     102801 <cpunum+0x31>
    return lapic[ID]>>24;
  1027fb:	8b 42 20             	mov    0x20(%edx),%eax
  1027fe:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102801:	c9                   	leave  
  102802:	c3                   	ret    
  102803:	90                   	nop    
  102804:	8d 74 26 00          	lea    0x0(%esi),%esi
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102808:	8b 45 04             	mov    0x4(%ebp),%eax
  10280b:	c7 04 24 d0 63 10 00 	movl   $0x1063d0,(%esp)
  102812:	89 44 24 04          	mov    %eax,0x4(%esp)
  102816:	e8 85 dc ff ff       	call   1004a0 <cprintf>
  10281b:	eb d2                	jmp    1027ef <cpunum+0x1f>
  10281d:	90                   	nop    
  10281e:	90                   	nop    
  10281f:	90                   	nop    

00102820 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102820:	55                   	push   %ebp
  102821:	89 e5                	mov    %esp,%ebp
  102823:	53                   	push   %ebx
  102824:	83 ec 14             	sub    $0x14,%esp
  if(cpunum() != mpbcpu())
  102827:	e8 a4 ff ff ff       	call   1027d0 <cpunum>
  10282c:	89 c3                	mov    %eax,%ebx
  10282e:	e8 ed 01 00 00       	call   102a20 <mpbcpu>
  102833:	39 c3                	cmp    %eax,%ebx
  102835:	74 0d                	je     102844 <mpmain+0x24>
    lapicinit(cpunum());
  102837:	e8 94 ff ff ff       	call   1027d0 <cpunum>
  10283c:	89 04 24             	mov    %eax,(%esp)
  10283f:	e8 6c fd ff ff       	call   1025b0 <lapicinit>
  ksegment();
  102844:	e8 27 13 00 00       	call   103b70 <ksegment>
  cprintf("cpu%d: mpmain\n", cpu->id);
  102849:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10284f:	0f b6 00             	movzbl (%eax),%eax
  102852:	c7 04 24 fc 63 10 00 	movl   $0x1063fc,(%esp)
  102859:	89 44 24 04          	mov    %eax,0x4(%esp)
  10285d:	e8 3e dc ff ff       	call   1004a0 <cprintf>
  idtinit();
  102862:	e8 19 28 00 00       	call   105080 <idtinit>
  xchg(&cpu->booted, 1);
  102867:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10286d:	ba 01 00 00 00       	mov    $0x1,%edx
  102872:	8d 88 a8 00 00 00    	lea    0xa8(%eax),%ecx
  102878:	89 d0                	mov    %edx,%eax
  10287a:	f0 87 01             	lock xchg %eax,(%ecx)

  cprintf("cpu%d: scheduling\n", cpu->id);
  10287d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  102883:	0f b6 00             	movzbl (%eax),%eax
  102886:	c7 04 24 0b 64 10 00 	movl   $0x10640b,(%esp)
  10288d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102891:	e8 0a dc ff ff       	call   1004a0 <cprintf>
  scheduler();
  102896:	e8 85 11 00 00       	call   103a20 <scheduler>
  10289b:	90                   	nop    
  10289c:	8d 74 26 00          	lea    0x0(%esi),%esi

001028a0 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  1028a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  1028a4:	83 e4 f0             	and    $0xfffffff0,%esp
  1028a7:	ff 71 fc             	pushl  -0x4(%ecx)
  1028aa:	55                   	push   %ebp
  1028ab:	89 e5                	mov    %esp,%ebp
  1028ad:	53                   	push   %ebx
  1028ae:	51                   	push   %ecx
  1028af:	83 ec 10             	sub    $0x10,%esp
  mpinit(); // collect info about this machine
  1028b2:	e8 f9 01 00 00       	call   102ab0 <mpinit>
  lapicinit(mpbcpu());
  1028b7:	e8 64 01 00 00       	call   102a20 <mpbcpu>
  1028bc:	89 04 24             	mov    %eax,(%esp)
  1028bf:	e8 ec fc ff ff       	call   1025b0 <lapicinit>
  ksegment();
  1028c4:	e8 a7 12 00 00       	call   103b70 <ksegment>
  picinit();       // interrupt controller
  1028c9:	e8 12 04 00 00       	call   102ce0 <picinit>
  1028ce:	66 90                	xchg   %ax,%ax
  ioapicinit();    // another interrupt controller
  1028d0:	e8 1b f9 ff ff       	call   1021f0 <ioapicinit>
  1028d5:	8d 76 00             	lea    0x0(%esi),%esi
  consoleinit();   // I/O devices & their interrupts
  1028d8:	e8 33 d9 ff ff       	call   100210 <consoleinit>
  1028dd:	8d 76 00             	lea    0x0(%esi),%esi
  uartinit();      // serial port
  1028e0:	e8 5b 2b 00 00       	call   105440 <uartinit>
cprintf("cpus %p cpu %p\n", cpus, cpu);
  1028e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1028eb:	c7 44 24 04 60 b2 10 	movl   $0x10b260,0x4(%esp)
  1028f2:	00 
  1028f3:	c7 04 24 1e 64 10 00 	movl   $0x10641e,(%esp)
  1028fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1028fe:	e8 9d db ff ff       	call   1004a0 <cprintf>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
  102903:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  102909:	0f b6 00             	movzbl (%eax),%eax
  10290c:	c7 04 24 2e 64 10 00 	movl   $0x10642e,(%esp)
  102913:	89 44 24 04          	mov    %eax,0x4(%esp)
  102917:	e8 84 db ff ff       	call   1004a0 <cprintf>

  kinit();         // physical memory allocator
  10291c:	e8 3f fb ff ff       	call   102460 <kinit>
  pinit();         // process table
  102921:	e8 ea 13 00 00       	call   103d10 <pinit>
  102926:	66 90                	xchg   %ax,%ax
  tvinit();        // trap vectors
  102928:	e8 d3 29 00 00       	call   105300 <tvinit>
  10292d:	8d 76 00             	lea    0x0(%esi),%esi
  binit();         // buffer cache
  102930:	e8 6b d8 ff ff       	call   1001a0 <binit>
  102935:	8d 76 00             	lea    0x0(%esi),%esi
  fileinit();      // file table
  102938:	e8 e3 e6 ff ff       	call   101020 <fileinit>
  10293d:	8d 76 00             	lea    0x0(%esi),%esi
  iinit();         // inode cache
  102940:	e8 5b f5 ff ff       	call   101ea0 <iinit>
  102945:	8d 76 00             	lea    0x0(%esi),%esi
  ideinit();       // disk
  102948:	e8 b3 f7 ff ff       	call   102100 <ideinit>
  if(!ismp)
  10294d:	a1 44 b2 10 00       	mov    0x10b244,%eax
  102952:	85 c0                	test   %eax,%eax
  102954:	0f 84 ae 00 00 00    	je     102a08 <main+0x168>
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  10295a:	e8 b1 0e 00 00       	call   103810 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  10295f:	c7 44 24 08 6a 00 00 	movl   $0x6a,0x8(%esp)
  102966:	00 
  102967:	c7 44 24 04 f4 7e 10 	movl   $0x107ef4,0x4(%esp)
  10296e:	00 
  10296f:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102976:	e8 75 16 00 00       	call   103ff0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  10297b:	69 05 40 b8 10 00 bc 	imul   $0xbc,0x10b840,%eax
  102982:	00 00 00 
  102985:	05 60 b2 10 00       	add    $0x10b260,%eax
  10298a:	3d 60 b2 10 00       	cmp    $0x10b260,%eax
  10298f:	76 72                	jbe    102a03 <main+0x163>
  102991:	bb 60 b2 10 00       	mov    $0x10b260,%ebx
  102996:	66 90                	xchg   %ax,%ax
    if(c == cpus+cpunum())  // We've started already.
  102998:	e8 33 fe ff ff       	call   1027d0 <cpunum>
  10299d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  1029a3:	05 60 b2 10 00       	add    $0x10b260,%eax
  1029a8:	39 c3                	cmp    %eax,%ebx
  1029aa:	74 3e                	je     1029ea <main+0x14a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  1029ac:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1029b3:	e8 e8 f8 ff ff       	call   1022a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  1029b8:	c7 05 f8 6f 00 00 20 	movl   $0x102820,0x6ff8
  1029bf:	28 10 00 
    if(c == cpus+cpunum())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  1029c2:	05 00 10 00 00       	add    $0x1000,%eax
  1029c7:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapicstartap(c->id, (uint)code);
  1029cc:	0f b6 03             	movzbl (%ebx),%eax
  1029cf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  1029d6:	00 
  1029d7:	89 04 24             	mov    %eax,(%esp)
  1029da:	e8 41 fd ff ff       	call   102720 <lapicstartap>
  1029df:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  1029e0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
  1029e6:	85 c0                	test   %eax,%eax
  1029e8:	74 f6                	je     1029e0 <main+0x140>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  1029ea:	69 05 40 b8 10 00 bc 	imul   $0xbc,0x10b840,%eax
  1029f1:	00 00 00 
  1029f4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
  1029fa:	05 60 b2 10 00       	add    $0x10b260,%eax
  1029ff:	39 c3                	cmp    %eax,%ebx
  102a01:	72 95                	jb     102998 <main+0xf8>
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102a03:	e8 18 fe ff ff       	call   102820 <mpmain>
  binit();         // buffer cache
  fileinit();      // file table
  iinit();         // inode cache
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  102a08:	e8 13 26 00 00       	call   105020 <timerinit>
  102a0d:	8d 76 00             	lea    0x0(%esi),%esi
  102a10:	e9 45 ff ff ff       	jmp    10295a <main+0xba>
  102a15:	90                   	nop    
  102a16:	90                   	nop    
  102a17:	90                   	nop    
  102a18:	90                   	nop    
  102a19:	90                   	nop    
  102a1a:	90                   	nop    
  102a1b:	90                   	nop    
  102a1c:	90                   	nop    
  102a1d:	90                   	nop    
  102a1e:	90                   	nop    
  102a1f:	90                   	nop    

00102a20 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
  102a20:	a1 04 80 10 00       	mov    0x108004,%eax
  102a25:	55                   	push   %ebp
  102a26:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102a28:	5d                   	pop    %ebp
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
  102a29:	2d 60 b2 10 00       	sub    $0x10b260,%eax
  102a2e:	c1 f8 02             	sar    $0x2,%eax
  102a31:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
  return bcpu-cpus;
}
  102a37:	c3                   	ret    
  102a38:	90                   	nop    
  102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102a40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uchar *addr, int len)
{
  102a40:	55                   	push   %ebp
  102a41:	89 e5                	mov    %esp,%ebp
  102a43:	56                   	push   %esi
  102a44:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102a45:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uchar *addr, int len)
{
  102a48:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102a4b:	39 f0                	cmp    %esi,%eax
  102a4d:	73 42                	jae    102a91 <mpsearch1+0x51>
  102a4f:	89 c3                	mov    %eax,%ebx
  102a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102a58:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102a5f:	00 
  102a60:	c7 44 24 04 45 64 10 	movl   $0x106445,0x4(%esp)
  102a67:	00 
  102a68:	89 1c 24             	mov    %ebx,(%esp)
  102a6b:	e8 20 15 00 00       	call   103f90 <memcmp>
  102a70:	85 c0                	test   %eax,%eax
  102a72:	75 16                	jne    102a8a <mpsearch1+0x4a>
  102a74:	31 d2                	xor    %edx,%edx
  102a76:	31 c9                	xor    %ecx,%ecx
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102a78:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102a7c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
  102a7f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102a81:	83 fa 10             	cmp    $0x10,%edx
  102a84:	75 f2                	jne    102a78 <mpsearch1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102a86:	84 c9                	test   %cl,%cl
  102a88:	74 10                	je     102a9a <mpsearch1+0x5a>
mpsearch1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102a8a:	83 c3 10             	add    $0x10,%ebx
  102a8d:	39 de                	cmp    %ebx,%esi
  102a8f:	77 c7                	ja     102a58 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102a91:	83 c4 10             	add    $0x10,%esp
mpsearch1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102a94:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102a96:	5b                   	pop    %ebx
  102a97:	5e                   	pop    %esi
  102a98:	5d                   	pop    %ebp
  102a99:	c3                   	ret    
  102a9a:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102a9d:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102a9f:	5b                   	pop    %ebx
  102aa0:	5e                   	pop    %esi
  102aa1:	5d                   	pop    %ebp
  102aa2:	c3                   	ret    
  102aa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102ab0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
  102ab0:	55                   	push   %ebp
  102ab1:	89 e5                	mov    %esp,%ebp
  102ab3:	57                   	push   %edi
  102ab4:	56                   	push   %esi
  102ab5:	53                   	push   %ebx
  102ab6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102ab9:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  102ac0:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  102ac7:	c7 05 04 80 10 00 60 	movl   $0x10b260,0x108004
  102ace:	b2 10 00 
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102ad1:	c1 e1 08             	shl    $0x8,%ecx
  102ad4:	09 c1                	or     %eax,%ecx
  102ad6:	c1 e1 04             	shl    $0x4,%ecx
  102ad9:	85 c9                	test   %ecx,%ecx
  102adb:	74 53                	je     102b30 <mpinit+0x80>
    if((mp = mpsearch1((uchar*)p, 1024)))
  102add:	ba 00 04 00 00       	mov    $0x400,%edx
  102ae2:	89 c8                	mov    %ecx,%eax
  102ae4:	e8 57 ff ff ff       	call   102a40 <mpsearch1>
  102ae9:	85 c0                	test   %eax,%eax
  102aeb:	89 c7                	mov    %eax,%edi
  102aed:	74 6c                	je     102b5b <mpinit+0xab>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102aef:	8b 5f 04             	mov    0x4(%edi),%ebx
  102af2:	85 db                	test   %ebx,%ebx
  102af4:	74 32                	je     102b28 <mpinit+0x78>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102af6:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102afd:	00 
  102afe:	c7 44 24 04 4a 64 10 	movl   $0x10644a,0x4(%esp)
  102b05:	00 
  102b06:	89 1c 24             	mov    %ebx,(%esp)
  102b09:	e8 82 14 00 00       	call   103f90 <memcmp>
  102b0e:	85 c0                	test   %eax,%eax
  102b10:	75 16                	jne    102b28 <mpinit+0x78>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102b12:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102b16:	3c 01                	cmp    $0x1,%al
  102b18:	74 66                	je     102b80 <mpinit+0xd0>
  102b1a:	3c 04                	cmp    $0x4,%al
  102b1c:	8d 74 26 00          	lea    0x0(%esi),%esi
  102b20:	74 5e                	je     102b80 <mpinit+0xd0>
  102b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102b28:	83 c4 1c             	add    $0x1c,%esp
  102b2b:	5b                   	pop    %ebx
  102b2c:	5e                   	pop    %esi
  102b2d:	5f                   	pop    %edi
  102b2e:	5d                   	pop    %ebp
  102b2f:	c3                   	ret    
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mpsearch1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1((uchar*)p-1024, 1024)))
  102b30:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102b37:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102b3e:	c1 e0 08             	shl    $0x8,%eax
  102b41:	09 d0                	or     %edx,%eax
  102b43:	ba 00 04 00 00       	mov    $0x400,%edx
  102b48:	c1 e0 0a             	shl    $0xa,%eax
  102b4b:	2d 00 04 00 00       	sub    $0x400,%eax
  102b50:	e8 eb fe ff ff       	call   102a40 <mpsearch1>
  102b55:	85 c0                	test   %eax,%eax
  102b57:	89 c7                	mov    %eax,%edi
  102b59:	75 94                	jne    102aef <mpinit+0x3f>
      return mp;
  }
  return mpsearch1((uchar*)0xF0000, 0x10000);
  102b5b:	ba 00 00 01 00       	mov    $0x10000,%edx
  102b60:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102b65:	e8 d6 fe ff ff       	call   102a40 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102b6a:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mpsearch1((uchar*)0xF0000, 0x10000);
  102b6c:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102b6e:	0f 85 7b ff ff ff    	jne    102aef <mpinit+0x3f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102b74:	83 c4 1c             	add    $0x1c,%esp
  102b77:	5b                   	pop    %ebx
  102b78:	5e                   	pop    %esi
  102b79:	5f                   	pop    %edi
  102b7a:	5d                   	pop    %ebp
  102b7b:	c3                   	ret    
  102b7c:	8d 74 26 00          	lea    0x0(%esi),%esi
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102b80:	0f b7 73 04          	movzwl 0x4(%ebx),%esi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102b84:	85 f6                	test   %esi,%esi
  102b86:	74 15                	je     102b9d <mpinit+0xed>
  102b88:	31 d2                	xor    %edx,%edx
  102b8a:	31 c9                	xor    %ecx,%ecx
    sum += addr[i];
  102b8c:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102b90:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
  102b93:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102b95:	39 d6                	cmp    %edx,%esi
  102b97:	7f f3                	jg     102b8c <mpinit+0xdc>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102b99:	84 c9                	test   %cl,%cl
  102b9b:	75 8b                	jne    102b28 <mpinit+0x78>
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  102b9d:	c7 05 44 b2 10 00 01 	movl   $0x1,0x10b244
  102ba4:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102ba7:	8b 43 24             	mov    0x24(%ebx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102baa:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102bad:	a3 38 b2 10 00       	mov    %eax,0x10b238
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102bb2:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  102bb6:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  102bb9:	39 c2                	cmp    %eax,%edx
  102bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bbe:	73 5f                	jae    102c1f <mpinit+0x16f>
  102bc0:	8b 35 04 80 10 00    	mov    0x108004,%esi
    switch(*p){
  102bc6:	0f b6 02             	movzbl (%edx),%eax
  102bc9:	3c 04                	cmp    $0x4,%al
  102bcb:	76 2b                	jbe    102bf8 <mpinit+0x148>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102bcd:	0f b6 c0             	movzbl %al,%eax
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102bd0:	89 35 04 80 10 00    	mov    %esi,0x108004
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bda:	c7 04 24 74 64 10 00 	movl   $0x106474,(%esp)
  102be1:	e8 ba d8 ff ff       	call   1004a0 <cprintf>
      panic("mpinit");
  102be6:	c7 04 24 6a 64 10 00 	movl   $0x10646a,(%esp)
  102bed:	e8 8e dc ff ff       	call   100880 <panic>
  102bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102bf8:	0f b6 c0             	movzbl %al,%eax
  102bfb:	ff 24 85 94 64 10 00 	jmp    *0x106494(,%eax,4)
  102c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
  102c08:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  102c0c:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
  102c0f:	a2 40 b2 10 00       	mov    %al,0x10b240
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c14:	39 55 f0             	cmp    %edx,-0x10(%ebp)
  102c17:	77 ad                	ja     102bc6 <mpinit+0x116>
  102c19:	89 35 04 80 10 00    	mov    %esi,0x108004
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      panic("mpinit");
    }
  }
  if(mp->imcrp){
  102c1f:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
  102c23:	0f 84 ff fe ff ff    	je     102b28 <mpinit+0x78>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102c29:	ba 22 00 00 00       	mov    $0x22,%edx
  102c2e:	b8 70 00 00 00       	mov    $0x70,%eax
  102c33:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102c34:	b2 23                	mov    $0x23,%dl
  102c36:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102c37:	83 c8 01             	or     $0x1,%eax
  102c3a:	ee                   	out    %al,(%dx)
  102c3b:	e9 e8 fe ff ff       	jmp    102b28 <mpinit+0x78>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102c40:	83 c2 08             	add    $0x8,%edx
  102c43:	eb cf                	jmp    102c14 <mpinit+0x164>
  102c45:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102c48:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  102c4c:	a1 40 b8 10 00       	mov    0x10b840,%eax
  102c51:	0f b6 cb             	movzbl %bl,%ecx
  102c54:	39 c1                	cmp    %eax,%ecx
  102c56:	75 2b                	jne    102c83 <mpinit+0x1d3>
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
  102c58:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102c5c:	74 0c                	je     102c6a <mpinit+0x1ba>
        bcpu = &cpus[ncpu];
  102c5e:	69 c1 bc 00 00 00    	imul   $0xbc,%ecx,%eax
  102c64:	8d b0 60 b2 10 00    	lea    0x10b260(%eax),%esi
      cpus[ncpu].id = ncpu;
  102c6a:	69 c1 bc 00 00 00    	imul   $0xbc,%ecx,%eax
      ncpu++;
      p += sizeof(struct mpproc);
  102c70:	83 c2 14             	add    $0x14,%edx
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      cpus[ncpu].id = ncpu;
  102c73:	88 98 60 b2 10 00    	mov    %bl,0x10b260(%eax)
      ncpu++;
  102c79:	8d 41 01             	lea    0x1(%ecx),%eax
  102c7c:	a3 40 b8 10 00       	mov    %eax,0x10b840
  102c81:	eb 91                	jmp    102c14 <mpinit+0x164>
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102c83:	89 35 04 80 10 00    	mov    %esi,0x108004
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
  102c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  102c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c91:	c7 04 24 4f 64 10 00 	movl   $0x10644f,(%esp)
  102c98:	e8 03 d8 ff ff       	call   1004a0 <cprintf>
        panic("mpinit");
  102c9d:	c7 04 24 6a 64 10 00 	movl   $0x10646a,(%esp)
  102ca4:	e8 d7 db ff ff       	call   100880 <panic>
  102ca9:	90                   	nop    
  102caa:	90                   	nop    
  102cab:	90                   	nop    
  102cac:	90                   	nop    
  102cad:	90                   	nop    
  102cae:	90                   	nop    
  102caf:	90                   	nop    

00102cb0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
  102cb0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
  102cb1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
  102cb6:	89 e5                	mov    %esp,%ebp
  102cb8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
  102cbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102cc0:	d3 c0                	rol    %cl,%eax
  102cc2:	66 23 05 c0 7a 10 00 	and    0x107ac0,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
  102cc9:	66 a3 c0 7a 10 00    	mov    %ax,0x107ac0
  102ccf:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
  102cd0:	66 c1 e8 08          	shr    $0x8,%ax
  102cd4:	b2 a1                	mov    $0xa1,%dl
  102cd6:	ee                   	out    %al,(%dx)
  102cd7:	5d                   	pop    %ebp
  102cd8:	c3                   	ret    
  102cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102ce0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
  102ce0:	55                   	push   %ebp
  102ce1:	b9 21 00 00 00       	mov    $0x21,%ecx
  102ce6:	89 e5                	mov    %esp,%ebp
  102ce8:	83 ec 0c             	sub    $0xc,%esp
  102ceb:	89 1c 24             	mov    %ebx,(%esp)
  102cee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102cf3:	89 ca                	mov    %ecx,%edx
  102cf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  102cf9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102cfd:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102cfe:	bb a1 00 00 00       	mov    $0xa1,%ebx
  102d03:	89 da                	mov    %ebx,%edx
  102d05:	ee                   	out    %al,(%dx)
  102d06:	be 20 00 00 00       	mov    $0x20,%esi
  102d0b:	b8 11 00 00 00       	mov    $0x11,%eax
  102d10:	89 f2                	mov    %esi,%edx
  102d12:	ee                   	out    %al,(%dx)
  102d13:	b8 20 00 00 00       	mov    $0x20,%eax
  102d18:	89 ca                	mov    %ecx,%edx
  102d1a:	ee                   	out    %al,(%dx)
  102d1b:	b8 04 00 00 00       	mov    $0x4,%eax
  102d20:	ee                   	out    %al,(%dx)
  102d21:	bf 03 00 00 00       	mov    $0x3,%edi
  102d26:	89 f8                	mov    %edi,%eax
  102d28:	ee                   	out    %al,(%dx)
  102d29:	b1 a0                	mov    $0xa0,%cl
  102d2b:	b8 11 00 00 00       	mov    $0x11,%eax
  102d30:	89 ca                	mov    %ecx,%edx
  102d32:	ee                   	out    %al,(%dx)
  102d33:	b8 28 00 00 00       	mov    $0x28,%eax
  102d38:	89 da                	mov    %ebx,%edx
  102d3a:	ee                   	out    %al,(%dx)
  102d3b:	b8 02 00 00 00       	mov    $0x2,%eax
  102d40:	ee                   	out    %al,(%dx)
  102d41:	89 f8                	mov    %edi,%eax
  102d43:	ee                   	out    %al,(%dx)
  102d44:	bb 68 00 00 00       	mov    $0x68,%ebx
  102d49:	89 f2                	mov    %esi,%edx
  102d4b:	89 d8                	mov    %ebx,%eax
  102d4d:	ee                   	out    %al,(%dx)
  102d4e:	bf 0a 00 00 00       	mov    $0xa,%edi
  102d53:	89 f8                	mov    %edi,%eax
  102d55:	ee                   	out    %al,(%dx)
  102d56:	89 d8                	mov    %ebx,%eax
  102d58:	89 ca                	mov    %ecx,%edx
  102d5a:	ee                   	out    %al,(%dx)
  102d5b:	89 f8                	mov    %edi,%eax
  102d5d:	ee                   	out    %al,(%dx)
  102d5e:	0f b7 05 c0 7a 10 00 	movzwl 0x107ac0,%eax
  102d65:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102d69:	74 0a                	je     102d75 <picinit+0x95>
  102d6b:	b2 21                	mov    $0x21,%dl
  102d6d:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
  102d6e:	66 c1 e8 08          	shr    $0x8,%ax
  102d72:	b2 a1                	mov    $0xa1,%dl
  102d74:	ee                   	out    %al,(%dx)
  102d75:	8b 1c 24             	mov    (%esp),%ebx
  102d78:	8b 74 24 04          	mov    0x4(%esp),%esi
  102d7c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102d80:	89 ec                	mov    %ebp,%esp
  102d82:	5d                   	pop    %ebp
  102d83:	c3                   	ret    
  102d84:	90                   	nop    
  102d85:	90                   	nop    
  102d86:	90                   	nop    
  102d87:	90                   	nop    
  102d88:	90                   	nop    
  102d89:	90                   	nop    
  102d8a:	90                   	nop    
  102d8b:	90                   	nop    
  102d8c:	90                   	nop    
  102d8d:	90                   	nop    
  102d8e:	90                   	nop    
  102d8f:	90                   	nop    

00102d90 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102d90:	55                   	push   %ebp
  102d91:	89 e5                	mov    %esp,%ebp
  102d93:	57                   	push   %edi
  102d94:	56                   	push   %esi
  102d95:	53                   	push   %ebx
  102d96:	83 ec 0c             	sub    $0xc,%esp
  102d99:	8b 75 08             	mov    0x8(%ebp),%esi
  102d9c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
  102d9f:	89 34 24             	mov    %esi,(%esp)
  102da2:	e8 19 11 00 00       	call   103ec0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102da7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
  102dad:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
  102db3:	75 58                	jne    102e0d <piperead+0x7d>
  102db5:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
  102dbb:	85 d2                	test   %edx,%edx
  102dbd:	74 4e                	je     102e0d <piperead+0x7d>
    if(proc->killed){
  102dbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102dc5:	8b 58 24             	mov    0x24(%eax),%ebx
  102dc8:	85 db                	test   %ebx,%ebx
  102dca:	0f 85 a0 00 00 00    	jne    102e70 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  102dd0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
  102dd6:	eb 1b                	jmp    102df3 <piperead+0x63>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102dd8:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
  102dde:	85 d2                	test   %edx,%edx
  102de0:	74 2b                	je     102e0d <piperead+0x7d>
    if(proc->killed){
  102de2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102de8:	8b 48 24             	mov    0x24(%eax),%ecx
  102deb:	85 c9                	test   %ecx,%ecx
  102ded:	0f 85 7d 00 00 00    	jne    102e70 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  102df3:	89 74 24 04          	mov    %esi,0x4(%esp)
  102df7:	89 1c 24             	mov    %ebx,(%esp)
  102dfa:	e8 21 06 00 00       	call   103420 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102dff:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
  102e05:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
  102e0b:	74 cb                	je     102dd8 <piperead+0x48>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102e0d:	85 ff                	test   %edi,%edi
  102e0f:	7e 76                	jle    102e87 <piperead+0xf7>
    if(p->nread == p->nwrite)
  102e11:	31 db                	xor    %ebx,%ebx
  102e13:	89 c2                	mov    %eax,%edx
  102e15:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
  102e1b:	75 0b                	jne    102e28 <piperead+0x98>
  102e1d:	eb 68                	jmp    102e87 <piperead+0xf7>
  102e1f:	90                   	nop    
  102e20:	39 96 38 02 00 00    	cmp    %edx,0x238(%esi)
  102e26:	74 22                	je     102e4a <piperead+0xba>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  102e28:	89 d0                	mov    %edx,%eax
  102e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102e2d:	83 c2 01             	add    $0x1,%edx
  102e30:	25 ff 01 00 00       	and    $0x1ff,%eax
  102e35:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
  102e3a:	88 04 19             	mov    %al,(%ecx,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102e3d:	83 c3 01             	add    $0x1,%ebx
  102e40:	39 df                	cmp    %ebx,%edi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  102e42:	89 96 34 02 00 00    	mov    %edx,0x234(%esi)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102e48:	7f d6                	jg     102e20 <piperead+0x90>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  102e4a:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
  102e50:	89 04 24             	mov    %eax,(%esp)
  102e53:	e8 58 03 00 00       	call   1031b0 <wakeup>
  release(&p->lock);
  102e58:	89 34 24             	mov    %esi,(%esp)
  102e5b:	e8 10 10 00 00       	call   103e70 <release>
  return i;
}
  102e60:	83 c4 0c             	add    $0xc,%esp
  102e63:	89 d8                	mov    %ebx,%eax
  102e65:	5b                   	pop    %ebx
  102e66:	5e                   	pop    %esi
  102e67:	5f                   	pop    %edi
  102e68:	5d                   	pop    %ebp
  102e69:	c3                   	ret    
  102e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
  102e70:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  102e75:	89 34 24             	mov    %esi,(%esp)
  102e78:	e8 f3 0f 00 00       	call   103e70 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
  102e7d:	83 c4 0c             	add    $0xc,%esp
  102e80:	89 d8                	mov    %ebx,%eax
  102e82:	5b                   	pop    %ebx
  102e83:	5e                   	pop    %esi
  102e84:	5f                   	pop    %edi
  102e85:	5d                   	pop    %ebp
  102e86:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102e87:	31 db                	xor    %ebx,%ebx
  102e89:	eb bf                	jmp    102e4a <piperead+0xba>
  102e8b:	90                   	nop    
  102e8c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102e90 <pipewrite>:
    release(&p->lock);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102e90:	55                   	push   %ebp
  102e91:	89 e5                	mov    %esp,%ebp
  102e93:	57                   	push   %edi
  102e94:	56                   	push   %esi
  102e95:	53                   	push   %ebx
  102e96:	83 ec 1c             	sub    $0x1c,%esp
  102e99:	8b 75 08             	mov    0x8(%ebp),%esi
  int i;

  acquire(&p->lock);
  102e9c:	89 34 24             	mov    %esi,(%esp)
  102e9f:	8d be 34 02 00 00    	lea    0x234(%esi),%edi
  102ea5:	e8 16 10 00 00       	call   103ec0 <acquire>
  for(i = 0; i < n; i++){
  102eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  102ead:	85 c0                	test   %eax,%eax
  102eaf:	0f 8e c7 00 00 00    	jle    102f7c <pipewrite+0xec>
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102eb5:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
  102ebb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
  102ebe:	8d be 34 02 00 00    	lea    0x234(%esi),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102ec4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ecb:	8b 9e 34 02 00 00    	mov    0x234(%esi),%ebx
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
  102ed1:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
  102ed7:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  102edd:	39 c1                	cmp    %eax,%ecx
  102edf:	74 41                	je     102f22 <pipewrite+0x92>
  102ee1:	eb 65                	jmp    102f48 <pipewrite+0xb8>
  102ee3:	90                   	nop    
  102ee4:	8d 74 26 00          	lea    0x0(%esi),%esi
      if(p->readopen == 0 || proc->killed){
  102ee8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102eee:	8b 58 24             	mov    0x24(%eax),%ebx
  102ef1:	85 db                	test   %ebx,%ebx
  102ef3:	75 37                	jne    102f2c <pipewrite+0x9c>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
  102ef5:	89 3c 24             	mov    %edi,(%esp)
  102ef8:	e8 b3 02 00 00       	call   1031b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102efd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f00:	89 74 24 04          	mov    %esi,0x4(%esp)
  102f04:	89 14 24             	mov    %edx,(%esp)
  102f07:	e8 14 05 00 00       	call   103420 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
  102f0c:	8b 9e 34 02 00 00    	mov    0x234(%esi),%ebx
  102f12:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
  102f18:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  102f1e:	39 c1                	cmp    %eax,%ecx
  102f20:	75 26                	jne    102f48 <pipewrite+0xb8>
      if(p->readopen == 0 || proc->killed){
  102f22:	8b 8e 3c 02 00 00    	mov    0x23c(%esi),%ecx
  102f28:	85 c9                	test   %ecx,%ecx
  102f2a:	75 bc                	jne    102ee8 <pipewrite+0x58>
        release(&p->lock);
  102f2c:	89 34 24             	mov    %esi,(%esp)
  102f2f:	e8 3c 0f 00 00       	call   103e70 <release>
  102f34:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
  102f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  102f3e:	83 c4 1c             	add    $0x1c,%esp
  102f41:	5b                   	pop    %ebx
  102f42:	5e                   	pop    %esi
  102f43:	5f                   	pop    %edi
  102f44:	5d                   	pop    %ebp
  102f45:	c3                   	ret    
  102f46:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  102f48:	89 c8                	mov    %ecx,%eax
  102f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f4d:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f58:	0f b6 14 10          	movzbl (%eax,%edx,1),%edx
  102f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f5f:	88 54 06 34          	mov    %dl,0x34(%esi,%eax,1)
  102f63:	8d 41 01             	lea    0x1(%ecx),%eax
  102f66:	89 86 38 02 00 00    	mov    %eax,0x238(%esi)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102f6c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102f70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f73:	39 55 10             	cmp    %edx,0x10(%ebp)
  102f76:	0f 8f 55 ff ff ff    	jg     102ed1 <pipewrite+0x41>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  102f7c:	89 3c 24             	mov    %edi,(%esp)
  102f7f:	e8 2c 02 00 00       	call   1031b0 <wakeup>
  release(&p->lock);
  102f84:	89 34 24             	mov    %esi,(%esp)
  102f87:	e8 e4 0e 00 00       	call   103e70 <release>
  102f8c:	eb ad                	jmp    102f3b <pipewrite+0xab>
  102f8e:	66 90                	xchg   %ax,%ax

00102f90 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  102f90:	55                   	push   %ebp
  102f91:	89 e5                	mov    %esp,%ebp
  102f93:	83 ec 18             	sub    $0x18,%esp
  102f96:	89 75 fc             	mov    %esi,-0x4(%ebp)
  102f99:	8b 75 08             	mov    0x8(%ebp),%esi
  102f9c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  102f9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  acquire(&p->lock);
  102fa2:	89 34 24             	mov    %esi,(%esp)
  102fa5:	e8 16 0f 00 00       	call   103ec0 <acquire>
  if(writable){
  102faa:	85 db                	test   %ebx,%ebx
  102fac:	74 42                	je     102ff0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
  102fae:	8d 86 34 02 00 00    	lea    0x234(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  102fb4:	c7 86 40 02 00 00 00 	movl   $0x0,0x240(%esi)
  102fbb:	00 00 00 
    wakeup(&p->nread);
  102fbe:	89 04 24             	mov    %eax,(%esp)
  102fc1:	e8 ea 01 00 00       	call   1031b0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
  102fc6:	8b 86 3c 02 00 00    	mov    0x23c(%esi),%eax
  102fcc:	85 c0                	test   %eax,%eax
  102fce:	75 0a                	jne    102fda <pipeclose+0x4a>
  102fd0:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
  102fd6:	85 c0                	test   %eax,%eax
  102fd8:	74 36                	je     103010 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p, PAGE);
  } else
    release(&p->lock);
  102fda:	89 75 08             	mov    %esi,0x8(%ebp)
}
  102fdd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  102fe0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  102fe3:	89 ec                	mov    %ebp,%esp
  102fe5:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  } else
    release(&p->lock);
  102fe6:	e9 85 0e 00 00       	jmp    103e70 <release>
  102feb:	90                   	nop    
  102fec:	8d 74 26 00          	lea    0x0(%esi),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  102ff0:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
  102ff6:	c7 86 3c 02 00 00 00 	movl   $0x0,0x23c(%esi)
  102ffd:	00 00 00 
    wakeup(&p->nwrite);
  103000:	89 04 24             	mov    %eax,(%esp)
  103003:	e8 a8 01 00 00       	call   1031b0 <wakeup>
  103008:	eb bc                	jmp    102fc6 <pipeclose+0x36>
  10300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
  103010:	89 34 24             	mov    %esi,(%esp)
  103013:	e8 58 0e 00 00       	call   103e70 <release>
    kfree((char*)p, PAGE);
  } else
    release(&p->lock);
}
  103018:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  10301b:	89 75 08             	mov    %esi,0x8(%ebp)
  } else
    release(&p->lock);
}
  10301e:	8b 75 fc             	mov    -0x4(%ebp),%esi
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  103021:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
  } else
    release(&p->lock);
}
  103028:	89 ec                	mov    %ebp,%esp
  10302a:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p, PAGE);
  10302b:	e9 20 f3 ff ff       	jmp    102350 <kfree>

00103030 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103030:	55                   	push   %ebp
  103031:	89 e5                	mov    %esp,%ebp
  103033:	83 ec 18             	sub    $0x18,%esp
  103036:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103039:	8b 75 08             	mov    0x8(%ebp),%esi
  10303c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10303f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103042:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  103045:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10304b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  103051:	e8 7a de ff ff       	call   100ed0 <filealloc>
  103056:	85 c0                	test   %eax,%eax
  103058:	89 06                	mov    %eax,(%esi)
  10305a:	0f 84 ae 00 00 00    	je     10310e <pipealloc+0xde>
  103060:	e8 6b de ff ff       	call   100ed0 <filealloc>
  103065:	85 c0                	test   %eax,%eax
  103067:	89 07                	mov    %eax,(%edi)
  103069:	0f 84 91 00 00 00    	je     103100 <pipealloc+0xd0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  10306f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103076:	e8 25 f2 ff ff       	call   1022a0 <kalloc>
  10307b:	85 c0                	test   %eax,%eax
  10307d:	89 c3                	mov    %eax,%ebx
  10307f:	74 7f                	je     103100 <pipealloc+0xd0>
    goto bad;
  p->readopen = 1;
  103081:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
  103088:	00 00 00 
  p->writeopen = 1;
  10308b:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
  103092:	00 00 00 
  p->nwrite = 0;
  103095:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
  10309c:	00 00 00 
  p->nread = 0;
  10309f:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
  1030a6:	00 00 00 
  initlock(&p->lock, "pipe");
  1030a9:	89 04 24             	mov    %eax,(%esp)
  1030ac:	c7 44 24 04 a8 64 10 	movl   $0x1064a8,0x4(%esp)
  1030b3:	00 
  1030b4:	e8 77 0c 00 00       	call   103d30 <initlock>
  (*f0)->type = FD_PIPE;
  1030b9:	8b 06                	mov    (%esi),%eax
  1030bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
  1030c1:	8b 06                	mov    (%esi),%eax
  1030c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  1030c7:	8b 06                	mov    (%esi),%eax
  1030c9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1030cd:	8b 06                	mov    (%esi),%eax
  1030cf:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1030d2:	8b 07                	mov    (%edi),%eax
  1030d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
  1030da:	8b 07                	mov    (%edi),%eax
  1030dc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  1030e0:	8b 07                	mov    (%edi),%eax
  1030e2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1030e6:	8b 07                	mov    (%edi),%eax
  1030e8:	89 58 0c             	mov    %ebx,0xc(%eax)
  1030eb:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
  1030ed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1030f0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1030f3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1030f6:	89 ec                	mov    %ebp,%esp
  1030f8:	5d                   	pop    %ebp
  1030f9:	c3                   	ret    
  1030fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0)
  103100:	8b 06                	mov    (%esi),%eax
  103102:	85 c0                	test   %eax,%eax
  103104:	74 08                	je     10310e <pipealloc+0xde>
    fileclose(*f0);
  103106:	89 04 24             	mov    %eax,(%esp)
  103109:	e8 32 de ff ff       	call   100f40 <fileclose>
  if(*f1)
  10310e:	8b 17                	mov    (%edi),%edx
  103110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103115:	85 d2                	test   %edx,%edx
  103117:	74 d4                	je     1030ed <pipealloc+0xbd>
    fileclose(*f1);
  103119:	89 14 24             	mov    %edx,(%esp)
  10311c:	e8 1f de ff ff       	call   100f40 <fileclose>
  103121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103126:	eb c5                	jmp    1030ed <pipealloc+0xbd>
  103128:	90                   	nop    
  103129:	90                   	nop    
  10312a:	90                   	nop    
  10312b:	90                   	nop    
  10312c:	90                   	nop    
  10312d:	90                   	nop    
  10312e:	90                   	nop    
  10312f:	90                   	nop    

00103130 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103130:	55                   	push   %ebp
  103131:	89 e5                	mov    %esp,%ebp
  103133:	53                   	push   %ebx
  103134:	83 ec 04             	sub    $0x4,%esp
  103137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
  10313a:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103141:	e8 7a 0d 00 00       	call   103ec0 <acquire>
  103146:	ba 94 b8 10 00       	mov    $0x10b894,%edx
  10314b:	eb 0e                	jmp    10315b <kill+0x2b>
  10314d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103150:	83 c2 7c             	add    $0x7c,%edx
  103153:	81 fa 94 d7 10 00    	cmp    $0x10d794,%edx
  103159:	74 3d                	je     103198 <kill+0x68>
    if(p->pid == pid){
  10315b:	8b 42 10             	mov    0x10(%edx),%eax
  10315e:	39 d8                	cmp    %ebx,%eax
  103160:	75 ee                	jne    103150 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103162:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103166:	c7 42 24 01 00 00 00 	movl   $0x1,0x24(%edx)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10316d:	74 19                	je     103188 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
  10316f:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103176:	e8 f5 0c 00 00       	call   103e70 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
  10317b:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
  10317e:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
  103180:	5b                   	pop    %ebx
  103181:	5d                   	pop    %ebp
  103182:	c3                   	ret    
  103183:	90                   	nop    
  103184:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103188:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  10318f:	eb de                	jmp    10316f <kill+0x3f>
  103191:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  103198:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10319f:	e8 cc 0c 00 00       	call   103e70 <release>
  return -1;
}
  1031a4:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  1031a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1031ac:	5b                   	pop    %ebx
  1031ad:	5d                   	pop    %ebp
  1031ae:	c3                   	ret    
  1031af:	90                   	nop    

001031b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1031b0:	55                   	push   %ebp
  1031b1:	89 e5                	mov    %esp,%ebp
  1031b3:	53                   	push   %ebx
  1031b4:	83 ec 04             	sub    $0x4,%esp
  1031b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
  1031ba:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  1031c1:	e8 fa 0c 00 00       	call   103ec0 <acquire>
  1031c6:	b8 94 b8 10 00       	mov    $0x10b894,%eax
  1031cb:	eb 0d                	jmp    1031da <wakeup+0x2a>
  1031cd:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1031d0:	83 c0 7c             	add    $0x7c,%eax
  1031d3:	3d 94 d7 10 00       	cmp    $0x10d794,%eax
  1031d8:	74 1e                	je     1031f8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
  1031da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1031de:	75 f0                	jne    1031d0 <wakeup+0x20>
  1031e0:	3b 58 20             	cmp    0x20(%eax),%ebx
  1031e3:	75 eb                	jne    1031d0 <wakeup+0x20>
      p->state = RUNNABLE;
  1031e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1031ec:	83 c0 7c             	add    $0x7c,%eax
  1031ef:	3d 94 d7 10 00       	cmp    $0x10d794,%eax
  1031f4:	75 e4                	jne    1031da <wakeup+0x2a>
  1031f6:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  1031f8:	c7 45 08 60 b8 10 00 	movl   $0x10b860,0x8(%ebp)
}
  1031ff:	83 c4 04             	add    $0x4,%esp
  103202:	5b                   	pop    %ebx
  103203:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  103204:	e9 67 0c 00 00       	jmp    103e70 <release>
  103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103210 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103210:	55                   	push   %ebp
  103211:	89 e5                	mov    %esp,%ebp
  103213:	83 ec 08             	sub    $0x8,%esp
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
  103216:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10321d:	e8 4e 0c 00 00       	call   103e70 <release>
  
  // Return to "caller", actually trapret (see allocproc).
}
  103222:	c9                   	leave  
  103223:	c3                   	ret    
  103224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10322a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103230 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  103230:	55                   	push   %ebp
  103231:	89 e5                	mov    %esp,%ebp
  103233:	53                   	push   %ebx
  103234:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
  103237:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10323e:	e8 6d 0b 00 00       	call   103db0 <holding>
  103243:	85 c0                	test   %eax,%eax
  103245:	74 71                	je     1032b8 <sched+0x88>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
  103247:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  10324e:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
  103255:	75 6d                	jne    1032c4 <sched+0x94>
    panic("sched locks");
  if(proc->state == RUNNING)
  103257:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10325d:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103261:	74 6d                	je     1032d0 <sched+0xa0>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103263:	9c                   	pushf  
  103264:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
  103265:	f6 c4 02             	test   $0x2,%ah
  103268:	75 72                	jne    1032dc <sched+0xac>
    panic("sched interruptible");

  intena = cpu->intena;
  10326a:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  cprintf("c");
  103270:	c7 04 24 41 66 10 00 	movl   $0x106641,(%esp)
  103277:	e8 24 d2 ff ff       	call   1004a0 <cprintf>
  swtch(&proc->context, cpu->scheduler);
  10327c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103282:	8b 40 04             	mov    0x4(%eax),%eax
  103285:	89 44 24 04          	mov    %eax,0x4(%esp)
  103289:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10328f:	83 c0 1c             	add    $0x1c,%eax
  103292:	89 04 24             	mov    %eax,(%esp)
  103295:	e8 c2 0e 00 00       	call   10415c <swtch>
  cprintf("d");
  10329a:	c7 04 24 68 64 10 00 	movl   $0x106468,(%esp)
  1032a1:	e8 fa d1 ff ff       	call   1004a0 <cprintf>
  cpu->intena = intena;
  1032a6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1032ac:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  1032b2:	83 c4 14             	add    $0x14,%esp
  1032b5:	5b                   	pop    %ebx
  1032b6:	5d                   	pop    %ebp
  1032b7:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  1032b8:	c7 04 24 ad 64 10 00 	movl   $0x1064ad,(%esp)
  1032bf:	e8 bc d5 ff ff       	call   100880 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  1032c4:	c7 04 24 bf 64 10 00 	movl   $0x1064bf,(%esp)
  1032cb:	e8 b0 d5 ff ff       	call   100880 <panic>
  if(proc->state == RUNNING)
    panic("sched running");
  1032d0:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1032d7:	e8 a4 d5 ff ff       	call   100880 <panic>
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  1032dc:	c7 04 24 d9 64 10 00 	movl   $0x1064d9,(%esp)
  1032e3:	e8 98 d5 ff ff       	call   100880 <panic>
  1032e8:	90                   	nop    
  1032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

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
  103314:	8d 74 26 00          	lea    0x0(%esi),%esi

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
  10334d:	e8 2e e5 ff ff       	call   101880 <iput>
  proc->cwd = 0;
  103352:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103358:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
  10335f:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103366:	e8 55 0b 00 00       	call   103ec0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  10336b:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
  103372:	ba 94 b8 10 00       	mov    $0x10b894,%edx
  103377:	8b 43 14             	mov    0x14(%ebx),%eax
  10337a:	eb 0f                	jmp    10338b <exit+0x9b>
  10337c:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  1033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1033f0:	eb de                	jmp    1033d0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  1033f2:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  1033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  sched();
  103400:	e8 2b fe ff ff       	call   103230 <sched>
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
  103453:	e8 68 0a 00 00       	call   103ec0 <acquire>
    release(lk);
  103458:	89 1c 24             	mov    %ebx,(%esp)
  10345b:	e8 10 0a 00 00       	call   103e70 <release>
  }

  // Go to sleep.
  proc->chan = chan;
  103460:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103466:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
  103469:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10346f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103476:	e8 b5 fd ff ff       	call   103230 <sched>

  // Tidy up.
  proc->chan = 0;
  10347b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103481:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
  103488:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10348f:	e8 dc 09 00 00       	call   103e70 <release>
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
  10349d:	e9 1e 0a 00 00       	jmp    103ec0 <acquire>
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
  1034b8:	e8 73 fd ff ff       	call   103230 <sched>

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
  1034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

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
  103504:	e8 b7 09 00 00       	call   103ec0 <acquire>
  103509:	31 d2                	xor    %edx,%edx
  10350b:	90                   	nop    
  10350c:	8d 74 26 00          	lea    0x0(%esi),%esi
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
  103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
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
  10356c:	8d 74 26 00          	lea    0x0(%esi),%esi
  103570:	eb e2                	jmp    103554 <wait+0x64>
  103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  103578:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10357f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  103584:	e8 e7 08 00 00       	call   103e70 <release>
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
  1035a1:	e8 aa ed ff ff       	call   102350 <kfree>
        kfree(p->kstack, KSTACKSIZE);
  1035a6:	8b 43 08             	mov    0x8(%ebx),%eax
  1035a9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1035b0:	00 
  1035b1:	89 04 24             	mov    %eax,(%esp)
  1035b4:	e8 97 ed ff ff       	call   102350 <kfree>
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
  1035e0:	e8 8b 08 00 00       	call   103e70 <release>
  1035e5:	eb a2                	jmp    103589 <wait+0x99>
  1035e7:	89 f6                	mov    %esi,%esi
  1035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  1035fd:	e8 be 08 00 00       	call   103ec0 <acquire>
  proc->state = RUNNABLE;
  103602:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103608:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  10360f:	e8 1c fc ff ff       	call   103230 <sched>
  release(&ptable.lock);
  103614:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  10361b:	e8 50 08 00 00       	call   103e70 <release>
}
  103620:	c9                   	leave  
  103621:	c3                   	ret    
  103622:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103629:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  103643:	e8 78 08 00 00       	call   103ec0 <acquire>
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
  103684:	e8 e7 07 00 00       	call   103e70 <release>

  // Allocate kernel stack if necessary.
  if((p->kstack = kalloc(KSTACKSIZE)) == 0){
  103689:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103690:	e8 0b ec ff ff       	call   1022a0 <kalloc>
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
  1036ad:	c7 82 b0 0f 00 00 70 	movl   $0x105070,0xfb0(%edx)
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
  1036cd:	e8 8e 08 00 00       	call   103f60 <memset>
  p->context->eip = (uint)forkret;
  1036d2:	8b 43 1c             	mov    0x1c(%ebx),%eax
  1036d5:	c7 40 10 10 32 10 00 	movl   $0x103210,0x10(%eax)
  return p;
}
  1036dc:	89 d8                	mov    %ebx,%eax
  1036de:	83 c4 14             	add    $0x14,%esp
  1036e1:	5b                   	pop    %ebx
  1036e2:	5d                   	pop    %ebp
  1036e3:	c3                   	ret    
  1036e4:	8d 74 26 00          	lea    0x0(%esi),%esi

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  1036e8:	31 db                	xor    %ebx,%ebx
  1036ea:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  1036f1:	e8 7a 07 00 00       	call   103e70 <release>
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
  103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

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
  103719:	fc                   	cld    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10371a:	e8 11 ff ff ff       	call   103630 <allocproc>
  10371f:	89 c3                	mov    %eax,%ebx
  103721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103726:	85 db                	test   %ebx,%ebx
  103728:	0f 84 a5 00 00 00    	je     1037d3 <fork+0xc3>
    return -1;

  // Copy process state from p.
  np->sz = proc->sz;
  10372e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103734:	8b 40 04             	mov    0x4(%eax),%eax
  103737:	89 43 04             	mov    %eax,0x4(%ebx)
  if((np->mem = kalloc(np->sz)) == 0){
  10373a:	89 04 24             	mov    %eax,(%esp)
  10373d:	e8 5e eb ff ff       	call   1022a0 <kalloc>
  103742:	85 c0                	test   %eax,%eax
  103744:	89 c2                	mov    %eax,%edx
  103746:	89 03                	mov    %eax,(%ebx)
  103748:	0f 84 8d 00 00 00    	je     1037db <fork+0xcb>
    kfree(np->kstack, KSTACKSIZE);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  memmove(np->mem, proc->mem, np->sz);
  10374e:	8b 43 04             	mov    0x4(%ebx),%eax
  103751:	89 44 24 08          	mov    %eax,0x8(%esp)
  103755:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10375b:	8b 00                	mov    (%eax),%eax
  10375d:	89 14 24             	mov    %edx,(%esp)
  103760:	89 44 24 04          	mov    %eax,0x4(%esp)
  103764:	e8 87 08 00 00       	call   103ff0 <memmove>
  np->parent = proc;
  103769:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  *np->tf = *proc->tf;
  10376f:	b9 13 00 00 00       	mov    $0x13,%ecx
  103774:	8b 7b 18             	mov    0x18(%ebx),%edi
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  memmove(np->mem, proc->mem, np->sz);
  np->parent = proc;
  103777:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
  10377a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103780:	8b 70 18             	mov    0x18(%eax),%esi
  103783:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  103785:	31 f6                	xor    %esi,%esi
  103787:	8b 43 18             	mov    0x18(%ebx),%eax
  10378a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  103791:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

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
  1037e9:	e8 62 eb ff ff       	call   102350 <kfree>
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
  103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

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
  103831:	e8 6a ea ff ff       	call   1022a0 <kalloc>
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
  10384a:	e8 11 07 00 00       	call   103f60 <memset>
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  10384f:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  103856:	00 
  103857:	c7 44 24 04 c8 7e 10 	movl   $0x107ec8,0x4(%esp)
  10385e:	00 
  10385f:	8b 03                	mov    (%ebx),%eax
  103861:	89 04 24             	mov    %eax,(%esp)
  103864:	e8 87 07 00 00       	call   103ff0 <memmove>

  memset(p->tf, 0, sizeof(*p->tf));
  103869:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
  103870:	00 
  103871:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103878:	00 
  103879:	8b 43 18             	mov    0x18(%ebx),%eax
  10387c:	89 04 24             	mov    %eax,(%esp)
  10387f:	e8 dc 06 00 00       	call   103f60 <memset>
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
  1038df:	e8 1c 08 00 00       	call   104100 <safestrcpy>
  p->cwd = namei("/");
  1038e4:	c7 04 24 26 65 10 00 	movl   $0x106526,(%esp)
  1038eb:	e8 90 e5 ff ff       	call   101e80 <namei>

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
  103906:	e8 c5 04 00 00       	call   103dd0 <pushcli>
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
  103a17:	e9 f4 03 00 00       	jmp    103e10 <popcli>
  103a1c:	8d 74 26 00          	lea    0x0(%esi),%esi

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
  103a35:	e8 86 04 00 00       	call   103ec0 <acquire>
  103a3a:	eb 0f                	jmp    103a4b <scheduler+0x2b>
  103a3c:	8d 74 26 00          	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a40:	83 c3 7c             	add    $0x7c,%ebx
  103a43:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
  103a49:	74 6d                	je     103ab8 <scheduler+0x98>
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
  103a5e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a65:	83 c3 7c             	add    $0x7c,%ebx
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      usegment();
      p->state = RUNNING;
      cprintf("a");
  103a68:	c7 04 24 28 65 10 00 	movl   $0x106528,(%esp)
  103a6f:	e8 2c ca ff ff       	call   1004a0 <cprintf>
      swtch(&cpu->scheduler, proc->context);
  103a74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103a7a:	8b 40 1c             	mov    0x1c(%eax),%eax
  103a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a81:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103a87:	83 c0 04             	add    $0x4,%eax
  103a8a:	89 04 24             	mov    %eax,(%esp)
  103a8d:	e8 ca 06 00 00       	call   10415c <swtch>
      cprintf("b");
  103a92:	c7 04 24 2a 65 10 00 	movl   $0x10652a,(%esp)
  103a99:	e8 02 ca ff ff       	call   1004a0 <cprintf>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a9e:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
      swtch(&cpu->scheduler, proc->context);
      cprintf("b");

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
  103aa4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  103aab:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103aaf:	75 9a                	jne    103a4b <scheduler+0x2b>
  103ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
  103ab8:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103abf:	e8 ac 03 00 00       	call   103e70 <release>
  103ac4:	e9 5f ff ff ff       	jmp    103a28 <scheduler+0x8>
  103ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103ad0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103ad0:	55                   	push   %ebp
  103ad1:	89 e5                	mov    %esp,%ebp
  103ad3:	56                   	push   %esi
  103ad4:	53                   	push   %ebx
  103ad5:	83 ec 10             	sub    $0x10,%esp
  char *newmem;

  newmem = kalloc(proc->sz + n);
  103ad8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103ade:	8b 75 08             	mov    0x8(%ebp),%esi
  char *newmem;

  newmem = kalloc(proc->sz + n);
  103ae1:	8b 50 04             	mov    0x4(%eax),%edx
  103ae4:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103ae7:	89 04 24             	mov    %eax,(%esp)
  103aea:	e8 b1 e7 ff ff       	call   1022a0 <kalloc>
  103aef:	89 c3                	mov    %eax,%ebx
  if(newmem == 0)
  103af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103af6:	85 db                	test   %ebx,%ebx
  103af8:	74 6c                	je     103b66 <growproc+0x96>
    return -1;
  memmove(newmem, proc->mem, proc->sz);
  103afa:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103b01:	8b 42 04             	mov    0x4(%edx),%eax
  103b04:	89 44 24 08          	mov    %eax,0x8(%esp)
  103b08:	8b 02                	mov    (%edx),%eax
  103b0a:	89 1c 24             	mov    %ebx,(%esp)
  103b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b11:	e8 da 04 00 00       	call   103ff0 <memmove>
  memset(newmem + proc->sz, 0, n);
  103b16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b1c:	89 74 24 08          	mov    %esi,0x8(%esp)
  103b20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b27:	00 
  103b28:	8b 50 04             	mov    0x4(%eax),%edx
  103b2b:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  103b2e:	89 04 24             	mov    %eax,(%esp)
  103b31:	e8 2a 04 00 00       	call   103f60 <memset>
  kfree(proc->mem, proc->sz);
  103b36:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103b3d:	8b 42 04             	mov    0x4(%edx),%eax
  103b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b44:	8b 02                	mov    (%edx),%eax
  103b46:	89 04 24             	mov    %eax,(%esp)
  103b49:	e8 02 e8 ff ff       	call   102350 <kfree>
  proc->mem = newmem;
  103b4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b54:	89 18                	mov    %ebx,(%eax)
  proc->sz += n;
  103b56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b5c:	01 70 04             	add    %esi,0x4(%eax)
  usegment();
  103b5f:	e8 9c fd ff ff       	call   103900 <usegment>
  103b64:	31 c0                	xor    %eax,%eax
  return 0;
}
  103b66:	83 c4 10             	add    $0x10,%esp
  103b69:	5b                   	pop    %ebx
  103b6a:	5e                   	pop    %esi
  103b6b:	5d                   	pop    %ebp
  103b6c:	c3                   	ret    
  103b6d:	8d 76 00             	lea    0x0(%esi),%esi

00103b70 <ksegment>:

// Set up CPU's kernel segment descriptors.
// Run once at boot time on each CPU.
void
ksegment(void)
{
  103b70:	55                   	push   %ebp
  103b71:	89 e5                	mov    %esp,%ebp
  103b73:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;

  c = &cpus[cpunum()];
  103b76:	e8 55 ec ff ff       	call   1027d0 <cpunum>
  103b7b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  103b81:	05 60 b2 10 00       	add    $0x10b260,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  103b86:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  103b8c:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
  103b93:	c1 ea 10             	shr    $0x10,%edx
  103b96:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
  103b9c:	c1 ea 08             	shr    $0x8,%edx
  103b9f:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
  103ba5:	8d 50 70             	lea    0x70(%eax),%edx
ksegment(void)
{
  struct cpu *c;

  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103ba8:	66 c7 40 78 0f 01    	movw   $0x10f,0x78(%eax)
  103bae:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
  103bb4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
  103bb8:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
  103bbc:	c6 40 7e c0          	movb   $0xc0,0x7e(%eax)
  103bc0:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103bc4:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
  103bcb:	ff ff 
  103bcd:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
  103bd4:	00 00 
  103bd6:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
  103bdd:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
  103be4:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  103beb:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  103bf2:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
  103bf9:	00 00 
  103bfb:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
  103c02:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103c09:	66 c7 45 fa 37 00    	movw   $0x37,-0x6(%ebp)
  pd[1] = (uint)p;
  103c0f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  103c13:	c1 ea 10             	shr    $0x10,%edx
  103c16:	66 89 55 fe          	mov    %dx,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103c1a:	8d 55 fa             	lea    -0x6(%ebp),%edx
  103c1d:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
  103c20:	ba 18 00 00 00       	mov    $0x18,%edx
  103c25:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
  103c27:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  103c2e:	00 00 00 00 
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
  103c32:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
  103c38:	c9                   	leave  
  103c39:	c3                   	ret    
  103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103c40 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103c40:	55                   	push   %ebp
  103c41:	89 e5                	mov    %esp,%ebp
  103c43:	57                   	push   %edi
  103c44:	56                   	push   %esi
  103c45:	53                   	push   %ebx
  103c46:	bb 94 b8 10 00       	mov    $0x10b894,%ebx
  103c4b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103c4e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  103c51:	eb 4b                	jmp    103c9e <procdump+0x5e>
  103c53:	90                   	nop    
  103c54:	8d 74 26 00          	lea    0x0(%esi),%esi
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103c58:	8b 0c 85 6c 65 10 00 	mov    0x10656c(,%eax,4),%ecx
  103c5f:	85 c9                	test   %ecx,%ecx
  103c61:	74 47                	je     103caa <procdump+0x6a>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103c63:	8b 53 10             	mov    0x10(%ebx),%edx
  103c66:	8d 43 6c             	lea    0x6c(%ebx),%eax
  103c69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103c71:	c7 04 24 30 65 10 00 	movl   $0x106530,(%esp)
  103c78:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c7c:	e8 1f c8 ff ff       	call   1004a0 <cprintf>
    if(p->state == SLEEPING){
  103c81:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  103c85:	74 31                	je     103cb8 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  103c87:	c7 04 24 43 64 10 00 	movl   $0x106443,(%esp)
  103c8e:	e8 0d c8 ff ff       	call   1004a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103c93:	83 c3 7c             	add    $0x7c,%ebx
  103c96:	81 fb 94 d7 10 00    	cmp    $0x10d794,%ebx
  103c9c:	74 5a                	je     103cf8 <procdump+0xb8>
    if(p->state == UNUSED)
  103c9e:	8b 43 0c             	mov    0xc(%ebx),%eax
  103ca1:	85 c0                	test   %eax,%eax
  103ca3:	74 ee                	je     103c93 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103ca5:	83 f8 05             	cmp    $0x5,%eax
  103ca8:	76 ae                	jbe    103c58 <procdump+0x18>
  103caa:	b9 2c 65 10 00       	mov    $0x10652c,%ecx
  103caf:	eb b2                	jmp    103c63 <procdump+0x23>
  103cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103cb8:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103cbb:	89 fe                	mov    %edi,%esi
  103cbd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  103cc4:	83 c0 08             	add    $0x8,%eax
  103cc7:	89 04 24             	mov    %eax,(%esp)
  103cca:	e8 81 00 00 00       	call   103d50 <getcallerpcs>
  103ccf:	90                   	nop    
      for(i=0; i<10 && pc[i] != 0; i++)
  103cd0:	8b 06                	mov    (%esi),%eax
  103cd2:	85 c0                	test   %eax,%eax
  103cd4:	74 b1                	je     103c87 <procdump+0x47>
        cprintf(" %p", pc[i]);
  103cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  103cda:	83 c6 04             	add    $0x4,%esi
  103cdd:	c7 04 24 dc 5f 10 00 	movl   $0x105fdc,(%esp)
  103ce4:	e8 b7 c7 ff ff       	call   1004a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
  103ce9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  103cec:	39 c6                	cmp    %eax,%esi
  103cee:	75 e0                	jne    103cd0 <procdump+0x90>
  103cf0:	eb 95                	jmp    103c87 <procdump+0x47>
  103cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
  103cf8:	83 c4 4c             	add    $0x4c,%esp
  103cfb:	5b                   	pop    %ebx
  103cfc:	5e                   	pop    %esi
  103cfd:	5f                   	pop    %edi
  103cfe:	5d                   	pop    %ebp
  103cff:	90                   	nop    
  103d00:	c3                   	ret    
  103d01:	eb 0d                	jmp    103d10 <pinit>
  103d03:	90                   	nop    
  103d04:	90                   	nop    
  103d05:	90                   	nop    
  103d06:	90                   	nop    
  103d07:	90                   	nop    
  103d08:	90                   	nop    
  103d09:	90                   	nop    
  103d0a:	90                   	nop    
  103d0b:	90                   	nop    
  103d0c:	90                   	nop    
  103d0d:	90                   	nop    
  103d0e:	90                   	nop    
  103d0f:	90                   	nop    

00103d10 <pinit>:
extern void forkret(void);
extern void trapret(void);

void
pinit(void)
{
  103d10:	55                   	push   %ebp
  103d11:	89 e5                	mov    %esp,%ebp
  103d13:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
  103d16:	c7 44 24 04 39 65 10 	movl   $0x106539,0x4(%esp)
  103d1d:	00 
  103d1e:	c7 04 24 60 b8 10 00 	movl   $0x10b860,(%esp)
  103d25:	e8 06 00 00 00       	call   103d30 <initlock>
}
  103d2a:	c9                   	leave  
  103d2b:	c3                   	ret    
  103d2c:	90                   	nop    
  103d2d:	90                   	nop    
  103d2e:	90                   	nop    
  103d2f:	90                   	nop    

00103d30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  103d30:	55                   	push   %ebp
  103d31:	89 e5                	mov    %esp,%ebp
  103d33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
  103d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
  103d39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  103d3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
  103d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
  103d49:	5d                   	pop    %ebp
  103d4a:	c3                   	ret    
  103d4b:	90                   	nop    
  103d4c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103d50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103d50:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103d51:	31 d2                	xor    %edx,%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103d53:	89 e5                	mov    %esp,%ebp
  103d55:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103d56:	8b 4d 08             	mov    0x8(%ebp),%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103d59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103d5c:	83 e9 08             	sub    $0x8,%ecx
  103d5f:	eb 09                	jmp    103d6a <getcallerpcs+0x1a>
  103d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103d68:	89 c1                	mov    %eax,%ecx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  103d6a:	8d 41 ff             	lea    -0x1(%ecx),%eax
  103d6d:	83 f8 fd             	cmp    $0xfffffffd,%eax
  103d70:	77 16                	ja     103d88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
  103d72:	8b 41 04             	mov    0x4(%ecx),%eax
  103d75:	89 04 93             	mov    %eax,(%ebx,%edx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103d78:	83 c2 01             	add    $0x1,%edx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103d7b:	8b 01                	mov    (%ecx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103d7d:	83 fa 0a             	cmp    $0xa,%edx
  103d80:	75 e6                	jne    103d68 <getcallerpcs+0x18>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  103d82:	5b                   	pop    %ebx
  103d83:	5d                   	pop    %ebp
  103d84:	c3                   	ret    
  103d85:	8d 76 00             	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103d88:	83 fa 09             	cmp    $0x9,%edx
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103d8b:	8d 04 93             	lea    (%ebx,%edx,4),%eax
  }
  for(; i < 10; i++)
  103d8e:	7f f2                	jg     103d82 <getcallerpcs+0x32>
  103d90:	83 c2 01             	add    $0x1,%edx
    pcs[i] = 0;
  103d93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103d99:	83 c0 04             	add    $0x4,%eax
  103d9c:	83 fa 09             	cmp    $0x9,%edx
  103d9f:	7e ef                	jle    103d90 <getcallerpcs+0x40>
    pcs[i] = 0;
}
  103da1:	5b                   	pop    %ebx
  103da2:	5d                   	pop    %ebp
  103da3:	c3                   	ret    
  103da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103db0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103db0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
  103db1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103db3:	89 e5                	mov    %esp,%ebp
  103db5:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
  103db8:	8b 0a                	mov    (%edx),%ecx
  103dba:	85 c9                	test   %ecx,%ecx
  103dbc:	74 10                	je     103dce <holding+0x1e>
  103dbe:	8b 42 08             	mov    0x8(%edx),%eax
  103dc1:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103dc8:	0f 94 c0             	sete   %al
  103dcb:	0f b6 c0             	movzbl %al,%eax
}
  103dce:	5d                   	pop    %ebp
  103dcf:	c3                   	ret    

00103dd0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  103dd0:	55                   	push   %ebp
  103dd1:	89 e5                	mov    %esp,%ebp
  103dd3:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103dd4:	9c                   	pushf  
  103dd5:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103dd6:	fa                   	cli    
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103dd7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103ddd:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
  103de3:	8d 51 01             	lea    0x1(%ecx),%edx
  103de6:	85 c9                	test   %ecx,%ecx
  103de8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
  103dee:	75 12                	jne    103e02 <pushcli+0x32>
    cpu->intena = eflags & FL_IF;
  103df0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103df6:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103dfc:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  103e02:	5b                   	pop    %ebx
  103e03:	5d                   	pop    %ebp
  103e04:	c3                   	ret    
  103e05:	8d 74 26 00          	lea    0x0(%esi),%esi
  103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103e10 <popcli>:

void
popcli(void)
{
  103e10:	55                   	push   %ebp
  103e11:	89 e5                	mov    %esp,%ebp
  103e13:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103e16:	9c                   	pushf  
  103e17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
  103e18:	f6 c4 02             	test   $0x2,%ah
  103e1b:	75 37                	jne    103e54 <popcli+0x44>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
  103e1d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103e24:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103e2a:	83 e8 01             	sub    $0x1,%eax
  103e2d:	85 c0                	test   %eax,%eax
  103e2f:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
  103e35:	78 29                	js     103e60 <popcli+0x50>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
  103e37:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103e3d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
  103e43:	85 d2                	test   %edx,%edx
  103e45:	75 0b                	jne    103e52 <popcli+0x42>
  103e47:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  103e4d:	85 c0                	test   %eax,%eax
  103e4f:	74 01                	je     103e52 <popcli+0x42>
}

static inline void
sti(void)
{
  asm volatile("sti");
  103e51:	fb                   	sti    
    sti();
}
  103e52:	c9                   	leave  
  103e53:	c3                   	ret    

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  103e54:	c7 04 24 84 65 10 00 	movl   $0x106584,(%esp)
  103e5b:	e8 20 ca ff ff       	call   100880 <panic>
  if(--cpu->ncli < 0)
    panic("popcli");
  103e60:	c7 04 24 9b 65 10 00 	movl   $0x10659b,(%esp)
  103e67:	e8 14 ca ff ff       	call   100880 <panic>
  103e6c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103e70 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
  103e70:	55                   	push   %ebp
  103e71:	89 e5                	mov    %esp,%ebp
  103e73:	83 ec 08             	sub    $0x8,%esp
  103e76:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  103e79:	8b 0a                	mov    (%edx),%ecx
  103e7b:	85 c9                	test   %ecx,%ecx
  103e7d:	74 0c                	je     103e8b <release+0x1b>
  103e7f:	8b 42 08             	mov    0x8(%edx),%eax
  103e82:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103e89:	74 0d                	je     103e98 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
  103e8b:	c7 04 24 a2 65 10 00 	movl   $0x1065a2,(%esp)
  103e92:	e8 e9 c9 ff ff       	call   100880 <panic>
  103e97:	90                   	nop    

  lk->pcs[0] = 0;
  103e98:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103e9f:	31 c0                	xor    %eax,%eax
  lk->cpu = 0;
  103ea1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
  103ea8:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
}
  103eab:	c9                   	leave  
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
  103eac:	e9 5f ff ff ff       	jmp    103e10 <popcli>
  103eb1:	eb 0d                	jmp    103ec0 <acquire>
  103eb3:	90                   	nop    
  103eb4:	90                   	nop    
  103eb5:	90                   	nop    
  103eb6:	90                   	nop    
  103eb7:	90                   	nop    
  103eb8:	90                   	nop    
  103eb9:	90                   	nop    
  103eba:	90                   	nop    
  103ebb:	90                   	nop    
  103ebc:	90                   	nop    
  103ebd:	90                   	nop    
  103ebe:	90                   	nop    
  103ebf:	90                   	nop    

00103ec0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  103ec0:	55                   	push   %ebp
  103ec1:	89 e5                	mov    %esp,%ebp
  103ec3:	53                   	push   %ebx
  103ec4:	83 ec 14             	sub    $0x14,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103ec7:	9c                   	pushf  
  103ec8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103ec9:	fa                   	cli    
{
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103eca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103ed0:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
  103ed6:	8d 51 01             	lea    0x1(%ecx),%edx
  103ed9:	85 c9                	test   %ecx,%ecx
  103edb:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
  103ee1:	75 12                	jne    103ef5 <acquire+0x35>
    cpu->intena = eflags & FL_IF;
  103ee3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103ee9:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103eef:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
  103ef5:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  103ef8:	8b 1a                	mov    (%edx),%ebx
  103efa:	85 db                	test   %ebx,%ebx
  103efc:	74 0c                	je     103f0a <acquire+0x4a>
  103efe:	8b 42 08             	mov    0x8(%edx),%eax
  103f01:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103f08:	74 46                	je     103f50 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103f0a:	b9 01 00 00 00       	mov    $0x1,%ecx
  103f0f:	eb 0a                	jmp    103f1b <acquire+0x5b>
  103f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103f18:	8b 55 08             	mov    0x8(%ebp),%edx
  103f1b:	89 c8                	mov    %ecx,%eax
  103f1d:	f0 87 02             	lock xchg %eax,(%edx)
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
  103f20:	85 c0                	test   %eax,%eax
  103f22:	75 f4                	jne    103f18 <acquire+0x58>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  103f24:	8b 45 08             	mov    0x8(%ebp),%eax
  103f27:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103f2e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
  103f31:	8b 45 08             	mov    0x8(%ebp),%eax
  103f34:	83 c0 0c             	add    $0xc,%eax
  103f37:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f3b:	8d 45 08             	lea    0x8(%ebp),%eax
  103f3e:	89 04 24             	mov    %eax,(%esp)
  103f41:	e8 0a fe ff ff       	call   103d50 <getcallerpcs>
}
  103f46:	83 c4 14             	add    $0x14,%esp
  103f49:	5b                   	pop    %ebx
  103f4a:	5d                   	pop    %ebp
  103f4b:	c3                   	ret    
  103f4c:	8d 74 26 00          	lea    0x0(%esi),%esi
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
    panic("acquire");
  103f50:	c7 04 24 aa 65 10 00 	movl   $0x1065aa,(%esp)
  103f57:	e8 24 c9 ff ff       	call   100880 <panic>
  103f5c:	90                   	nop    
  103f5d:	90                   	nop    
  103f5e:	90                   	nop    
  103f5f:	90                   	nop    

00103f60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  103f60:	55                   	push   %ebp
  103f61:	89 e5                	mov    %esp,%ebp
  103f63:	83 ec 08             	sub    $0x8,%esp
  103f66:	89 1c 24             	mov    %ebx,(%esp)
  103f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  103f6c:	89 7c 24 04          	mov    %edi,0x4(%esp)
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  103f70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  103f76:	89 df                	mov    %ebx,%edi
  103f78:	fc                   	cld    
  103f79:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  103f7b:	89 d8                	mov    %ebx,%eax
  103f7d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  103f81:	8b 1c 24             	mov    (%esp),%ebx
  103f84:	89 ec                	mov    %ebp,%esp
  103f86:	5d                   	pop    %ebp
  103f87:	c3                   	ret    
  103f88:	90                   	nop    
  103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103f90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  103f90:	55                   	push   %ebp
  103f91:	89 e5                	mov    %esp,%ebp
  103f93:	57                   	push   %edi
  103f94:	56                   	push   %esi
  103f95:	53                   	push   %ebx
  103f96:	8b 55 10             	mov    0x10(%ebp),%edx
  103f99:	8b 7d 08             	mov    0x8(%ebp),%edi
  103f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103f9f:	85 d2                	test   %edx,%edx
  103fa1:	74 2d                	je     103fd0 <memcmp+0x40>
    if(*s1 != *s2)
  103fa3:	0f b6 1f             	movzbl (%edi),%ebx
  103fa6:	0f b6 06             	movzbl (%esi),%eax
  103fa9:	38 c3                	cmp    %al,%bl
  103fab:	75 33                	jne    103fe0 <memcmp+0x50>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103fad:	8d 4a ff             	lea    -0x1(%edx),%ecx
  103fb0:	31 d2                	xor    %edx,%edx
  103fb2:	eb 18                	jmp    103fcc <memcmp+0x3c>
  103fb4:	8d 74 26 00          	lea    0x0(%esi),%esi
    if(*s1 != *s2)
  103fb8:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  103fbd:	83 e9 01             	sub    $0x1,%ecx
  103fc0:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  103fc5:	83 c2 01             	add    $0x1,%edx
  103fc8:	38 c3                	cmp    %al,%bl
  103fca:	75 14                	jne    103fe0 <memcmp+0x50>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103fcc:	85 c9                	test   %ecx,%ecx
  103fce:	75 e8                	jne    103fb8 <memcmp+0x28>
  103fd0:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  103fd2:	89 d0                	mov    %edx,%eax
  103fd4:	5b                   	pop    %ebx
  103fd5:	5e                   	pop    %esi
  103fd6:	5f                   	pop    %edi
  103fd7:	5d                   	pop    %ebp
  103fd8:	c3                   	ret    
  103fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  103fe0:	0f b6 d3             	movzbl %bl,%edx
  103fe3:	0f b6 c0             	movzbl %al,%eax
  103fe6:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  103fe8:	89 d0                	mov    %edx,%eax
  103fea:	5b                   	pop    %ebx
  103feb:	5e                   	pop    %esi
  103fec:	5f                   	pop    %edi
  103fed:	5d                   	pop    %ebp
  103fee:	c3                   	ret    
  103fef:	90                   	nop    

00103ff0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  103ff0:	55                   	push   %ebp
  103ff1:	89 e5                	mov    %esp,%ebp
  103ff3:	57                   	push   %edi
  103ff4:	56                   	push   %esi
  103ff5:	53                   	push   %ebx
  103ff6:	8b 75 08             	mov    0x8(%ebp),%esi
  103ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103ffc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  103fff:	39 f1                	cmp    %esi,%ecx
  104001:	73 35                	jae    104038 <memmove+0x48>
  104003:	8d 3c 19             	lea    (%ecx,%ebx,1),%edi
  104006:	39 fe                	cmp    %edi,%esi
  104008:	73 2e                	jae    104038 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
  10400a:	85 db                	test   %ebx,%ebx
  10400c:	74 1d                	je     10402b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  10400e:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  104011:	31 d2                	xor    %edx,%edx
  104013:	90                   	nop    
  104014:	8d 74 26 00          	lea    0x0(%esi),%esi
    while(n-- > 0)
      *--d = *--s;
  104018:	0f b6 44 17 ff       	movzbl -0x1(%edi,%edx,1),%eax
  10401d:	88 44 11 ff          	mov    %al,-0x1(%ecx,%edx,1)
  104021:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104024:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  104027:	85 c0                	test   %eax,%eax
  104029:	75 ed                	jne    104018 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  10402b:	89 f0                	mov    %esi,%eax
  10402d:	5b                   	pop    %ebx
  10402e:	5e                   	pop    %esi
  10402f:	5f                   	pop    %edi
  104030:	5d                   	pop    %ebp
  104031:	c3                   	ret    
  104032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104038:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  10403a:	85 db                	test   %ebx,%ebx
  10403c:	74 ed                	je     10402b <memmove+0x3b>
  10403e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104040:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  104044:	88 04 16             	mov    %al,(%esi,%edx,1)
  104047:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  10404a:	39 d3                	cmp    %edx,%ebx
  10404c:	75 f2                	jne    104040 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
  10404e:	89 f0                	mov    %esi,%eax
  104050:	5b                   	pop    %ebx
  104051:	5e                   	pop    %esi
  104052:	5f                   	pop    %edi
  104053:	5d                   	pop    %ebp
  104054:	c3                   	ret    
  104055:	8d 74 26 00          	lea    0x0(%esi),%esi
  104059:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104060 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104060:	55                   	push   %ebp
  104061:	89 e5                	mov    %esp,%ebp
  104063:	56                   	push   %esi
  104064:	53                   	push   %ebx
  104065:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104068:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10406b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10406e:	85 c9                	test   %ecx,%ecx
  104070:	75 1e                	jne    104090 <strncmp+0x30>
  104072:	eb 34                	jmp    1040a8 <strncmp+0x48>
  104074:	8d 74 26 00          	lea    0x0(%esi),%esi
  104078:	0f b6 16             	movzbl (%esi),%edx
  10407b:	38 d0                	cmp    %dl,%al
  10407d:	75 1b                	jne    10409a <strncmp+0x3a>
  10407f:	83 e9 01             	sub    $0x1,%ecx
  104082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104088:	74 1e                	je     1040a8 <strncmp+0x48>
    n--, p++, q++;
  10408a:	83 c3 01             	add    $0x1,%ebx
  10408d:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104090:	0f b6 03             	movzbl (%ebx),%eax
  104093:	84 c0                	test   %al,%al
  104095:	75 e1                	jne    104078 <strncmp+0x18>
  104097:	0f b6 16             	movzbl (%esi),%edx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10409a:	0f b6 c8             	movzbl %al,%ecx
  10409d:	0f b6 c2             	movzbl %dl,%eax
  1040a0:	29 c1                	sub    %eax,%ecx
}
  1040a2:	89 c8                	mov    %ecx,%eax
  1040a4:	5b                   	pop    %ebx
  1040a5:	5e                   	pop    %esi
  1040a6:	5d                   	pop    %ebp
  1040a7:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1040a8:	31 c9                	xor    %ecx,%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1040aa:	89 c8                	mov    %ecx,%eax
  1040ac:	5b                   	pop    %ebx
  1040ad:	5e                   	pop    %esi
  1040ae:	5d                   	pop    %ebp
  1040af:	c3                   	ret    

001040b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1040b0:	55                   	push   %ebp
  1040b1:	89 e5                	mov    %esp,%ebp
  1040b3:	56                   	push   %esi
  1040b4:	8b 75 08             	mov    0x8(%ebp),%esi
  1040b7:	53                   	push   %ebx
  1040b8:	8b 55 10             	mov    0x10(%ebp),%edx
  1040bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1040be:	89 f1                	mov    %esi,%ecx
  1040c0:	eb 09                	jmp    1040cb <strncpy+0x1b>
  1040c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1040c8:	83 c3 01             	add    $0x1,%ebx
  1040cb:	83 ea 01             	sub    $0x1,%edx
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  1040ce:	8d 42 01             	lea    0x1(%edx),%eax
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1040d1:	85 c0                	test   %eax,%eax
  1040d3:	7e 0c                	jle    1040e1 <strncpy+0x31>
  1040d5:	0f b6 03             	movzbl (%ebx),%eax
  1040d8:	88 01                	mov    %al,(%ecx)
  1040da:	83 c1 01             	add    $0x1,%ecx
  1040dd:	84 c0                	test   %al,%al
  1040df:	75 e7                	jne    1040c8 <strncpy+0x18>
  1040e1:	31 c0                	xor    %eax,%eax
    ;
  while(n-- > 0)
  1040e3:	85 d2                	test   %edx,%edx
  1040e5:	7e 0c                	jle    1040f3 <strncpy+0x43>
  1040e7:	90                   	nop    
    *s++ = 0;
  1040e8:	c6 04 01 00          	movb   $0x0,(%ecx,%eax,1)
  1040ec:	83 c0 01             	add    $0x1,%eax
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1040ef:	39 d0                	cmp    %edx,%eax
  1040f1:	75 f5                	jne    1040e8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  1040f3:	89 f0                	mov    %esi,%eax
  1040f5:	5b                   	pop    %ebx
  1040f6:	5e                   	pop    %esi
  1040f7:	5d                   	pop    %ebp
  1040f8:	c3                   	ret    
  1040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104100 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104100:	55                   	push   %ebp
  104101:	89 e5                	mov    %esp,%ebp
  104103:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104106:	56                   	push   %esi
  104107:	8b 75 08             	mov    0x8(%ebp),%esi
  10410a:	53                   	push   %ebx
  10410b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  10410e:	85 c9                	test   %ecx,%ecx
  104110:	7e 1f                	jle    104131 <safestrcpy+0x31>
  104112:	89 f2                	mov    %esi,%edx
  104114:	eb 05                	jmp    10411b <safestrcpy+0x1b>
  104116:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104118:	83 c3 01             	add    $0x1,%ebx
  10411b:	83 e9 01             	sub    $0x1,%ecx
  10411e:	85 c9                	test   %ecx,%ecx
  104120:	7e 0c                	jle    10412e <safestrcpy+0x2e>
  104122:	0f b6 03             	movzbl (%ebx),%eax
  104125:	88 02                	mov    %al,(%edx)
  104127:	83 c2 01             	add    $0x1,%edx
  10412a:	84 c0                	test   %al,%al
  10412c:	75 ea                	jne    104118 <safestrcpy+0x18>
    ;
  *s = 0;
  10412e:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  104131:	89 f0                	mov    %esi,%eax
  104133:	5b                   	pop    %ebx
  104134:	5e                   	pop    %esi
  104135:	5d                   	pop    %ebp
  104136:	c3                   	ret    
  104137:	89 f6                	mov    %esi,%esi
  104139:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104140 <strlen>:

int
strlen(const char *s)
{
  104140:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104141:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104143:	89 e5                	mov    %esp,%ebp
  104145:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104148:	80 3a 00             	cmpb   $0x0,(%edx)
  10414b:	74 0c                	je     104159 <strlen+0x19>
  10414d:	8d 76 00             	lea    0x0(%esi),%esi
  104150:	83 c0 01             	add    $0x1,%eax
  104153:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104157:	75 f7                	jne    104150 <strlen+0x10>
    ;
  return n;
}
  104159:	5d                   	pop    %ebp
  10415a:	c3                   	ret    
  10415b:	90                   	nop    

0010415c <swtch>:
  10415c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104160:	8b 54 24 08          	mov    0x8(%esp),%edx
  104164:	55                   	push   %ebp
  104165:	53                   	push   %ebx
  104166:	56                   	push   %esi
  104167:	57                   	push   %edi
  104168:	89 20                	mov    %esp,(%eax)
  10416a:	89 d4                	mov    %edx,%esp
  10416c:	5f                   	pop    %edi
  10416d:	5e                   	pop    %esi
  10416e:	5b                   	pop    %ebx
  10416f:	5d                   	pop    %ebp
  104170:	c3                   	ret    
  104171:	90                   	nop    
  104172:	90                   	nop    
  104173:	90                   	nop    
  104174:	90                   	nop    
  104175:	90                   	nop    
  104176:	90                   	nop    
  104177:	90                   	nop    
  104178:	90                   	nop    
  104179:	90                   	nop    
  10417a:	90                   	nop    
  10417b:	90                   	nop    
  10417c:	90                   	nop    
  10417d:	90                   	nop    
  10417e:	90                   	nop    
  10417f:	90                   	nop    

00104180 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104180:	55                   	push   %ebp
  104181:	89 e5                	mov    %esp,%ebp
  104183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  104186:	8b 51 04             	mov    0x4(%ecx),%edx
  104189:	3b 55 0c             	cmp    0xc(%ebp),%edx
  10418c:	77 0a                	ja     104198 <fetchint+0x18>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  10418e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104193:	5d                   	pop    %ebp
  104194:	c3                   	ret    
  104195:	8d 76 00             	lea    0x0(%esi),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104198:	8b 45 0c             	mov    0xc(%ebp),%eax
  10419b:	83 c0 04             	add    $0x4,%eax
  10419e:	39 c2                	cmp    %eax,%edx
  1041a0:	72 ec                	jb     10418e <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1041a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041a5:	8b 01                	mov    (%ecx),%eax
  1041a7:	8b 04 10             	mov    (%eax,%edx,1),%eax
  1041aa:	8b 55 10             	mov    0x10(%ebp),%edx
  1041ad:	89 02                	mov    %eax,(%edx)
  1041af:	31 c0                	xor    %eax,%eax
  return 0;
}
  1041b1:	5d                   	pop    %ebp
  1041b2:	c3                   	ret    
  1041b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001041c0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1041c0:	55                   	push   %ebp
  1041c1:	89 e5                	mov    %esp,%ebp
  1041c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1041c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041c9:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  1041ca:	39 50 04             	cmp    %edx,0x4(%eax)
  1041cd:	77 09                	ja     1041d8 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1041cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1041d4:	5b                   	pop    %ebx
  1041d5:	5d                   	pop    %ebp
  1041d6:	c3                   	ret    
  1041d7:	90                   	nop    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  1041d8:	89 d3                	mov    %edx,%ebx
  1041da:	8b 55 10             	mov    0x10(%ebp),%edx
  1041dd:	03 18                	add    (%eax),%ebx
  1041df:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  1041e1:	8b 08                	mov    (%eax),%ecx
  1041e3:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  1041e6:	39 cb                	cmp    %ecx,%ebx
  1041e8:	73 e5                	jae    1041cf <fetchstr+0xf>
    if(*s == 0)
  1041ea:	31 c0                	xor    %eax,%eax
  1041ec:	89 da                	mov    %ebx,%edx
  1041ee:	80 3b 00             	cmpb   $0x0,(%ebx)
  1041f1:	74 e1                	je     1041d4 <fetchstr+0x14>
  1041f3:	90                   	nop    
  1041f4:	8d 74 26 00          	lea    0x0(%esi),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1041f8:	83 c2 01             	add    $0x1,%edx
  1041fb:	39 d1                	cmp    %edx,%ecx
  1041fd:	76 d0                	jbe    1041cf <fetchstr+0xf>
    if(*s == 0)
  1041ff:	80 3a 00             	cmpb   $0x0,(%edx)
  104202:	75 f4                	jne    1041f8 <fetchstr+0x38>
  104204:	89 d0                	mov    %edx,%eax
  104206:	29 d8                	sub    %ebx,%eax
  104208:	eb ca                	jmp    1041d4 <fetchstr+0x14>
  10420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104210 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104210:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104217:	55                   	push   %ebp
  104218:	89 e5                	mov    %esp,%ebp
  10421a:	53                   	push   %ebx
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  10421b:	8b 41 18             	mov    0x18(%ecx),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10421e:	8b 59 04             	mov    0x4(%ecx),%ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104221:	8b 50 44             	mov    0x44(%eax),%edx
  104224:	8b 45 08             	mov    0x8(%ebp),%eax
  104227:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10422b:	39 da                	cmp    %ebx,%edx
  10422d:	72 09                	jb     104238 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10422f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
}
  104234:	5b                   	pop    %ebx
  104235:	5d                   	pop    %ebp
  104236:	c3                   	ret    
  104237:	90                   	nop    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104238:	8d 42 04             	lea    0x4(%edx),%eax
  10423b:	39 c3                	cmp    %eax,%ebx
  10423d:	72 f0                	jb     10422f <argint+0x1f>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10423f:	8b 01                	mov    (%ecx),%eax
  104241:	8b 04 10             	mov    (%eax,%edx,1),%eax
  104244:	8b 55 0c             	mov    0xc(%ebp),%edx
  104247:	89 02                	mov    %eax,(%edx)
  104249:	31 c0                	xor    %eax,%eax
  10424b:	eb e7                	jmp    104234 <argint+0x24>
  10424d:	8d 76 00             	lea    0x0(%esi),%esi

00104250 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104250:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104257:	55                   	push   %ebp
  104258:	89 e5                	mov    %esp,%ebp
  10425a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  10425b:	8b 41 18             	mov    0x18(%ecx),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10425e:	8b 59 04             	mov    0x4(%ecx),%ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104261:	8b 50 44             	mov    0x44(%eax),%edx
  104264:	8b 45 08             	mov    0x8(%ebp),%eax
  104267:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10426b:	39 da                	cmp    %ebx,%edx
  10426d:	73 07                	jae    104276 <argptr+0x26>
  10426f:	8d 42 04             	lea    0x4(%edx),%eax
  104272:	39 c3                	cmp    %eax,%ebx
  104274:	73 0a                	jae    104280 <argptr+0x30>
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
    return -1;
  *pp = proc->mem + i;
  return 0;
  104276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10427b:	5b                   	pop    %ebx
  10427c:	5d                   	pop    %ebp
  10427d:	c3                   	ret    
  10427e:	66 90                	xchg   %ax,%ax
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  104280:	8b 09                	mov    (%ecx),%ecx
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
  104282:	8b 14 11             	mov    (%ecx,%edx,1),%edx
  104285:	39 da                	cmp    %ebx,%edx
  104287:	73 ed                	jae    104276 <argptr+0x26>
  104289:	89 d0                	mov    %edx,%eax
  10428b:	03 45 10             	add    0x10(%ebp),%eax
  10428e:	39 d8                	cmp    %ebx,%eax
  104290:	73 e4                	jae    104276 <argptr+0x26>
    return -1;
  *pp = proc->mem + i;
  104292:	8d 04 11             	lea    (%ecx,%edx,1),%eax
  104295:	8b 55 0c             	mov    0xc(%ebp),%edx
  104298:	89 02                	mov    %eax,(%edx)
  10429a:	31 c0                	xor    %eax,%eax
  10429c:	eb dd                	jmp    10427b <argptr+0x2b>
  10429e:	66 90                	xchg   %ax,%ax

001042a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  1042a0:	55                   	push   %ebp
  1042a1:	89 e5                	mov    %esp,%ebp
  1042a3:	56                   	push   %esi
  1042a4:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042a5:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
  1042ac:	8b 43 18             	mov    0x18(%ebx),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042af:	8b 4b 04             	mov    0x4(%ebx),%ecx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042b2:	8b 50 44             	mov    0x44(%eax),%edx
  1042b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b8:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042bc:	39 ca                	cmp    %ecx,%edx
  1042be:	73 07                	jae    1042c7 <argstr+0x27>
  1042c0:	8d 42 04             	lea    0x4(%edx),%eax
  1042c3:	39 c1                	cmp    %eax,%ecx
  1042c5:	73 09                	jae    1042d0 <argstr+0x30>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1042c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  1042cc:	5b                   	pop    %ebx
  1042cd:	5e                   	pop    %esi
  1042ce:	5d                   	pop    %ebp
  1042cf:	c3                   	ret    
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  1042d0:	8b 33                	mov    (%ebx),%esi
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
  1042d2:	8b 04 16             	mov    (%esi,%edx,1),%eax
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  1042d5:	39 c8                	cmp    %ecx,%eax
  1042d7:	73 ee                	jae    1042c7 <argstr+0x27>
    return -1;
  *pp = p->mem + addr;
  1042d9:	01 c6                	add    %eax,%esi
  1042db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042de:	89 30                	mov    %esi,(%eax)
  ep = p->mem + p->sz;
  1042e0:	8b 0b                	mov    (%ebx),%ecx
  1042e2:	03 4b 04             	add    0x4(%ebx),%ecx
  for(s = *pp; s < ep; s++)
  1042e5:	39 ce                	cmp    %ecx,%esi
  1042e7:	73 de                	jae    1042c7 <argstr+0x27>
    if(*s == 0)
  1042e9:	31 c0                	xor    %eax,%eax
  1042eb:	89 f2                	mov    %esi,%edx
  1042ed:	80 3e 00             	cmpb   $0x0,(%esi)
  1042f0:	75 10                	jne    104302 <argstr+0x62>
  1042f2:	eb d8                	jmp    1042cc <argstr+0x2c>
  1042f4:	8d 74 26 00          	lea    0x0(%esi),%esi
  1042f8:	80 3a 00             	cmpb   $0x0,(%edx)
  1042fb:	90                   	nop    
  1042fc:	8d 74 26 00          	lea    0x0(%esi),%esi
  104300:	74 16                	je     104318 <argstr+0x78>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104302:	83 c2 01             	add    $0x1,%edx
  104305:	39 d1                	cmp    %edx,%ecx
  104307:	90                   	nop    
  104308:	77 ee                	ja     1042f8 <argstr+0x58>
  10430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104310:	eb b5                	jmp    1042c7 <argstr+0x27>
  104312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
  104318:	89 d0                	mov    %edx,%eax
  10431a:	29 f0                	sub    %esi,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  10431c:	5b                   	pop    %ebx
  10431d:	5e                   	pop    %esi
  10431e:	5d                   	pop    %ebp
  10431f:	c3                   	ret    

00104320 <syscall>:
[SYS_write]   sys_write,
};

void
syscall(void)
{
  104320:	55                   	push   %ebp
  104321:	89 e5                	mov    %esp,%ebp
  104323:	53                   	push   %ebx
  104324:	83 ec 14             	sub    $0x14,%esp
  int num;
  
  num = proc->tf->eax;
  104327:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10432d:	8b 58 18             	mov    0x18(%eax),%ebx
  104330:	8b 4b 1c             	mov    0x1c(%ebx),%ecx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104333:	83 f9 14             	cmp    $0x14,%ecx
  104336:	77 18                	ja     104350 <syscall+0x30>
  104338:	8b 14 8d e0 65 10 00 	mov    0x1065e0(,%ecx,4),%edx
  10433f:	85 d2                	test   %edx,%edx
  104341:	74 0d                	je     104350 <syscall+0x30>
    proc->tf->eax = syscalls[num]();
  104343:	ff d2                	call   *%edx
  104345:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
  104348:	83 c4 14             	add    $0x14,%esp
  10434b:	5b                   	pop    %ebx
  10434c:	5d                   	pop    %ebp
  10434d:	c3                   	ret    
  10434e:	66 90                	xchg   %ax,%ax
  
  num = proc->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    proc->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104350:	8b 50 10             	mov    0x10(%eax),%edx
  104353:	83 c0 6c             	add    $0x6c,%eax
  104356:	89 44 24 08          	mov    %eax,0x8(%esp)
  10435a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10435e:	c7 04 24 b2 65 10 00 	movl   $0x1065b2,(%esp)
  104365:	89 54 24 04          	mov    %edx,0x4(%esp)
  104369:	e8 32 c1 ff ff       	call   1004a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  10436e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104374:	8b 40 18             	mov    0x18(%eax),%eax
  104377:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  10437e:	83 c4 14             	add    $0x14,%esp
  104381:	5b                   	pop    %ebx
  104382:	5d                   	pop    %ebp
  104383:	c3                   	ret    
  104384:	90                   	nop    
  104385:	90                   	nop    
  104386:	90                   	nop    
  104387:	90                   	nop    
  104388:	90                   	nop    
  104389:	90                   	nop    
  10438a:	90                   	nop    
  10438b:	90                   	nop    
  10438c:	90                   	nop    
  10438d:	90                   	nop    
  10438e:	90                   	nop    
  10438f:	90                   	nop    

00104390 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104390:	55                   	push   %ebp
  104391:	89 e5                	mov    %esp,%ebp
  104393:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104396:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104399:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  10439c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  10439f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  1043a6:	00 
  1043a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1043b2:	e8 99 fe ff ff       	call   104250 <argptr>
  1043b7:	85 c0                	test   %eax,%eax
  1043b9:	79 15                	jns    1043d0 <sys_pipe+0x40>
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  1043bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
  1043c0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1043c3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1043c6:	89 ec                	mov    %ebp,%esp
  1043c8:	5d                   	pop    %ebp
  1043c9:	c3                   	ret    
  1043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  1043d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1043d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1043da:	89 04 24             	mov    %eax,(%esp)
  1043dd:	e8 4e ec ff ff       	call   103030 <pipealloc>
  1043e2:	85 c0                	test   %eax,%eax
  1043e4:	78 d5                	js     1043bb <sys_pipe+0x2b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  1043e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  1043e9:	31 c9                	xor    %ecx,%ecx
  1043eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1043f8:	8b 5c 88 28          	mov    0x28(%eax,%ecx,4),%ebx
  1043fc:	85 db                	test   %ebx,%ebx
  1043fe:	74 28                	je     104428 <sys_pipe+0x98>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104400:	83 c1 01             	add    $0x1,%ecx
  104403:	83 f9 10             	cmp    $0x10,%ecx
  104406:	75 f0                	jne    1043f8 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
  104408:	89 14 24             	mov    %edx,(%esp)
  10440b:	e8 30 cb ff ff       	call   100f40 <fileclose>
    fileclose(wf);
  104410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104413:	89 04 24             	mov    %eax,(%esp)
  104416:	e8 25 cb ff ff       	call   100f40 <fileclose>
  10441b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104420:	eb 9e                	jmp    1043c0 <sys_pipe+0x30>
  104422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104428:	8d 59 08             	lea    0x8(%ecx),%ebx
  10442b:	89 54 98 08          	mov    %edx,0x8(%eax,%ebx,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  10442f:	8b 75 ec             	mov    -0x14(%ebp),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104432:	31 d2                	xor    %edx,%edx
  104434:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104440:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
  104445:	74 19                	je     104460 <sys_pipe+0xd0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104447:	83 c2 01             	add    $0x1,%edx
  10444a:	83 fa 10             	cmp    $0x10,%edx
  10444d:	75 f1                	jne    104440 <sys_pipe+0xb0>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
  10444f:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
  104456:	00 
  104457:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10445a:	eb ac                	jmp    104408 <sys_pipe+0x78>
  10445c:	8d 74 26 00          	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104460:	89 74 90 28          	mov    %esi,0x28(%eax,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104467:	89 08                	mov    %ecx,(%eax)
  fd[1] = fd1;
  104469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10446c:	89 50 04             	mov    %edx,0x4(%eax)
  10446f:	31 c0                	xor    %eax,%eax
  104471:	e9 4a ff ff ff       	jmp    1043c0 <sys_pipe+0x30>
  104476:	8d 76 00             	lea    0x0(%esi),%esi
  104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104480 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104480:	55                   	push   %ebp
  104481:	89 e5                	mov    %esp,%ebp
  104483:	83 ec 28             	sub    $0x28,%esp
  104486:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104489:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10448b:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  10448e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104491:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104493:	89 54 24 04          	mov    %edx,0x4(%esp)
  104497:	89 04 24             	mov    %eax,(%esp)
  10449a:	e8 71 fd ff ff       	call   104210 <argint>
  10449f:	85 c0                	test   %eax,%eax
  1044a1:	79 15                	jns    1044b8 <argfd+0x38>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  1044a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  1044a8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1044ab:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1044ae:	89 ec                	mov    %ebp,%esp
  1044b0:	5d                   	pop    %ebp
  1044b1:	c3                   	ret    
  1044b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
  1044b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1044bb:	83 fa 0f             	cmp    $0xf,%edx
  1044be:	77 e3                	ja     1044a3 <argfd+0x23>
  1044c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1044c6:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
  1044ca:	85 c9                	test   %ecx,%ecx
  1044cc:	74 d5                	je     1044a3 <argfd+0x23>
    return -1;
  if(pfd)
  1044ce:	85 db                	test   %ebx,%ebx
  1044d0:	74 02                	je     1044d4 <argfd+0x54>
    *pfd = fd;
  1044d2:	89 13                	mov    %edx,(%ebx)
  if(pf)
  1044d4:	31 c0                	xor    %eax,%eax
  1044d6:	85 f6                	test   %esi,%esi
  1044d8:	74 ce                	je     1044a8 <argfd+0x28>
    *pf = f;
  1044da:	89 0e                	mov    %ecx,(%esi)
  1044dc:	31 c0                	xor    %eax,%eax
  1044de:	eb c8                	jmp    1044a8 <argfd+0x28>

001044e0 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  1044e0:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  1044e1:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  1044e3:	89 e5                	mov    %esp,%ebp
  1044e5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  1044e8:	8d 55 fc             	lea    -0x4(%ebp),%edx
  1044eb:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  1044ee:	e8 8d ff ff ff       	call   104480 <argfd>
  1044f3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1044f8:	85 c0                	test   %eax,%eax
  1044fa:	78 1f                	js     10451b <sys_close+0x3b>
    return -1;
  proc->ofile[fd] = 0;
  1044fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044ff:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104506:	c7 44 82 28 00 00 00 	movl   $0x0,0x28(%edx,%eax,4)
  10450d:	00 
  fileclose(f);
  10450e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104511:	89 04 24             	mov    %eax,(%esp)
  104514:	e8 27 ca ff ff       	call   100f40 <fileclose>
  104519:	31 d2                	xor    %edx,%edx
  return 0;
}
  10451b:	89 d0                	mov    %edx,%eax
  10451d:	c9                   	leave  
  10451e:	c3                   	ret    
  10451f:	90                   	nop    

00104520 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104520:	55                   	push   %ebp
  104521:	89 e5                	mov    %esp,%ebp
  104523:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104526:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104529:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10452c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10452f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104532:	89 44 24 04          	mov    %eax,0x4(%esp)
  104536:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10453d:	e8 5e fd ff ff       	call   1042a0 <argstr>
  104542:	85 c0                	test   %eax,%eax
  104544:	79 12                	jns    104558 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104546:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  10454b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10454e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104551:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104554:	89 ec                	mov    %ebp,%esp
  104556:	5d                   	pop    %ebp
  104557:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104558:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10455b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10455f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104566:	e8 a5 fc ff ff       	call   104210 <argint>
  10456b:	85 c0                	test   %eax,%eax
  10456d:	78 d7                	js     104546 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  10456f:	8d 7d 98             	lea    -0x68(%ebp),%edi
  104572:	31 db                	xor    %ebx,%ebx
  104574:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  10457b:	00 
  10457c:	31 f6                	xor    %esi,%esi
  10457e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104585:	00 
  104586:	89 3c 24             	mov    %edi,(%esp)
  104589:	e8 d2 f9 ff ff       	call   103f60 <memset>
  10458e:	eb 27                	jmp    1045b7 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
  104590:	8d 04 b7             	lea    (%edi,%esi,4),%eax
  104593:	89 44 24 08          	mov    %eax,0x8(%esp)
  104597:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10459d:	89 54 24 04          	mov    %edx,0x4(%esp)
  1045a1:	89 04 24             	mov    %eax,(%esp)
  1045a4:	e8 17 fc ff ff       	call   1041c0 <fetchstr>
  1045a9:	85 c0                	test   %eax,%eax
  1045ab:	78 99                	js     104546 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1045ad:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  1045b0:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1045b3:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
  1045b5:	74 8f                	je     104546 <sys_exec+0x26>
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
  1045b7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  1045ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045be:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  1045c5:	03 45 ec             	add    -0x14(%ebp),%eax
  1045c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1045d2:	89 04 24             	mov    %eax,(%esp)
  1045d5:	e8 a6 fb ff ff       	call   104180 <fetchint>
  1045da:	85 c0                	test   %eax,%eax
  1045dc:	0f 88 64 ff ff ff    	js     104546 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  1045e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1045e5:	85 d2                	test   %edx,%edx
  1045e7:	75 a7                	jne    104590 <sys_exec+0x70>
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1045e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  1045ec:	c7 44 9d 98 00 00 00 	movl   $0x0,-0x68(%ebp,%ebx,4)
  1045f3:	00 
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1045f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1045f8:	89 04 24             	mov    %eax,(%esp)
  1045fb:	e8 00 c3 ff ff       	call   100900 <exec>
  104600:	e9 46 ff ff ff       	jmp    10454b <sys_exec+0x2b>
  104605:	8d 74 26 00          	lea    0x0(%esi),%esi
  104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104610 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104610:	55                   	push   %ebp
  104611:	89 e5                	mov    %esp,%ebp
  104613:	53                   	push   %ebx
  104614:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104617:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10461a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10461e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104625:	e8 76 fc ff ff       	call   1042a0 <argstr>
  10462a:	85 c0                	test   %eax,%eax
  10462c:	79 12                	jns    104640 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  proc->cwd = ip;
  return 0;
  10462e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104633:	83 c4 24             	add    $0x24,%esp
  104636:	5b                   	pop    %ebx
  104637:	5d                   	pop    %ebp
  104638:	c3                   	ret    
  104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104640:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104643:	89 04 24             	mov    %eax,(%esp)
  104646:	e8 35 d8 ff ff       	call   101e80 <namei>
  10464b:	85 c0                	test   %eax,%eax
  10464d:	89 c3                	mov    %eax,%ebx
  10464f:	74 dd                	je     10462e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104651:	89 04 24             	mov    %eax,(%esp)
  104654:	e8 77 d5 ff ff       	call   101bd0 <ilock>
  if(ip->type != T_DIR){
  104659:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10465e:	75 26                	jne    104686 <sys_chdir+0x76>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104660:	89 1c 24             	mov    %ebx,(%esp)
  104663:	e8 f8 d0 ff ff       	call   101760 <iunlock>
  iput(proc->cwd);
  104668:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10466e:	8b 40 68             	mov    0x68(%eax),%eax
  104671:	89 04 24             	mov    %eax,(%esp)
  104674:	e8 07 d2 ff ff       	call   101880 <iput>
  proc->cwd = ip;
  104679:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10467f:	89 58 68             	mov    %ebx,0x68(%eax)
  104682:	31 c0                	xor    %eax,%eax
  104684:	eb ad                	jmp    104633 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104686:	89 1c 24             	mov    %ebx,(%esp)
  104689:	e8 52 d4 ff ff       	call   101ae0 <iunlockput>
  10468e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104693:	eb 9e                	jmp    104633 <sys_chdir+0x23>
  104695:	8d 74 26 00          	lea    0x0(%esi),%esi
  104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001046a0 <create>:
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1046a0:	55                   	push   %ebp
  1046a1:	89 e5                	mov    %esp,%ebp
  1046a3:	83 ec 48             	sub    $0x48,%esp
  1046a6:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  1046a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1046ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1046af:	89 d7                	mov    %edx,%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046b1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1046b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046b7:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1046b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1046bc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046bf:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046c3:	89 04 24             	mov    %eax,(%esp)
  1046c6:	e8 95 d7 ff ff       	call   101e60 <nameiparent>
  1046cb:	85 c0                	test   %eax,%eax
  1046cd:	89 c6                	mov    %eax,%esi
  1046cf:	74 4b                	je     10471c <create+0x7c>
    return 0;
  ilock(dp);
  1046d1:	89 04 24             	mov    %eax,(%esp)
  1046d4:	e8 f7 d4 ff ff       	call   101bd0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
  1046d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1046dc:	8d 4d e2             	lea    -0x1e(%ebp),%ecx
  1046df:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1046e7:	89 34 24             	mov    %esi,(%esp)
  1046ea:	e8 61 cf ff ff       	call   101650 <dirlookup>
  1046ef:	85 c0                	test   %eax,%eax
  1046f1:	89 c3                	mov    %eax,%ebx
  1046f3:	74 3b                	je     104730 <create+0x90>
    iunlockput(dp);
  1046f5:	89 34 24             	mov    %esi,(%esp)
  1046f8:	e8 e3 d3 ff ff       	call   101ae0 <iunlockput>
    ilock(ip);
  1046fd:	89 1c 24             	mov    %ebx,(%esp)
  104700:	e8 cb d4 ff ff       	call   101bd0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
  104705:	66 83 ff 02          	cmp    $0x2,%di
  104709:	75 07                	jne    104712 <create+0x72>
  10470b:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
  104710:	74 0a                	je     10471c <create+0x7c>
      return ip;
    iunlockput(ip);
  104712:	89 1c 24             	mov    %ebx,(%esp)
  104715:	31 db                	xor    %ebx,%ebx
  104717:	e8 c4 d3 ff ff       	call   101ae0 <iunlockput>
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);
  return ip;
}
  10471c:	89 d8                	mov    %ebx,%eax
  10471e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104721:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104724:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104727:	89 ec                	mov    %ebp,%esp
  104729:	5d                   	pop    %ebp
  10472a:	c3                   	ret    
  10472b:	90                   	nop    
  10472c:	8d 74 26 00          	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  104730:	0f bf c7             	movswl %di,%eax
  104733:	89 44 24 04          	mov    %eax,0x4(%esp)
  104737:	8b 06                	mov    (%esi),%eax
  104739:	89 04 24             	mov    %eax,(%esp)
  10473c:	e8 bf d3 ff ff       	call   101b00 <ialloc>
  104741:	85 c0                	test   %eax,%eax
  104743:	89 c3                	mov    %eax,%ebx
  104745:	0f 84 ac 00 00 00    	je     1047f7 <create+0x157>
    panic("create: ialloc");

  ilock(ip);
  10474b:	89 04 24             	mov    %eax,(%esp)
  10474e:	e8 7d d4 ff ff       	call   101bd0 <ilock>
  ip->major = major;
  104753:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104757:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  10475b:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
  ip->nlink = 1;
  10475f:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  104765:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104769:	89 1c 24             	mov    %ebx,(%esp)
  10476c:	e8 df cc ff ff       	call   101450 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
  104771:	66 83 ef 01          	sub    $0x1,%di
  104775:	74 31                	je     1047a8 <create+0x108>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
  104777:	8b 43 04             	mov    0x4(%ebx),%eax
  10477a:	8d 4d e2             	lea    -0x1e(%ebp),%ecx
  10477d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104781:	89 34 24             	mov    %esi,(%esp)
  104784:	89 44 24 08          	mov    %eax,0x8(%esp)
  104788:	e8 63 d2 ff ff       	call   1019f0 <dirlink>
  10478d:	85 c0                	test   %eax,%eax
  10478f:	78 72                	js     104803 <create+0x163>
    panic("create: dirlink");

  iunlockput(dp);
  104791:	89 34 24             	mov    %esi,(%esp)
  104794:	e8 47 d3 ff ff       	call   101ae0 <iunlockput>
  104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1047a0:	e9 77 ff ff ff       	jmp    10471c <create+0x7c>
  1047a5:	8d 76 00             	lea    0x0(%esi),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1047a8:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  1047ad:	89 34 24             	mov    %esi,(%esp)
  1047b0:	e8 9b cc ff ff       	call   101450 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1047b5:	8b 43 04             	mov    0x4(%ebx),%eax
  1047b8:	c7 44 24 04 44 66 10 	movl   $0x106644,0x4(%esp)
  1047bf:	00 
  1047c0:	89 1c 24             	mov    %ebx,(%esp)
  1047c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047c7:	e8 24 d2 ff ff       	call   1019f0 <dirlink>
  1047cc:	85 c0                	test   %eax,%eax
  1047ce:	78 1b                	js     1047eb <create+0x14b>
  1047d0:	8b 46 04             	mov    0x4(%esi),%eax
  1047d3:	c7 44 24 04 43 66 10 	movl   $0x106643,0x4(%esp)
  1047da:	00 
  1047db:	89 1c 24             	mov    %ebx,(%esp)
  1047de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047e2:	e8 09 d2 ff ff       	call   1019f0 <dirlink>
  1047e7:	85 c0                	test   %eax,%eax
  1047e9:	79 8c                	jns    104777 <create+0xd7>
      panic("create dots");
  1047eb:	c7 04 24 46 66 10 00 	movl   $0x106646,(%esp)
  1047f2:	e8 89 c0 ff ff       	call   100880 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
  1047f7:	c7 04 24 34 66 10 00 	movl   $0x106634,(%esp)
  1047fe:	e8 7d c0 ff ff       	call   100880 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
  104803:	c7 04 24 52 66 10 00 	movl   $0x106652,(%esp)
  10480a:	e8 71 c0 ff ff       	call   100880 <panic>
  10480f:	90                   	nop    

00104810 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
  104810:	55                   	push   %ebp
  104811:	89 e5                	mov    %esp,%ebp
  104813:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104816:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104819:	89 44 24 04          	mov    %eax,0x4(%esp)
  10481d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104824:	e8 77 fa ff ff       	call   1042a0 <argstr>
  104829:	85 c0                	test   %eax,%eax
  10482b:	79 0b                	jns    104838 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10482d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104832:	c9                   	leave  
  104833:	c3                   	ret    
  104834:	8d 74 26 00          	lea    0x0(%esi),%esi
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104838:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10483b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10483f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104846:	e8 c5 f9 ff ff       	call   104210 <argint>
  10484b:	85 c0                	test   %eax,%eax
  10484d:	78 de                	js     10482d <sys_mknod+0x1d>
  10484f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104852:	89 44 24 04          	mov    %eax,0x4(%esp)
  104856:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10485d:	e8 ae f9 ff ff       	call   104210 <argint>
  104862:	85 c0                	test   %eax,%eax
  104864:	78 c7                	js     10482d <sys_mknod+0x1d>
  104866:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  10486a:	0f bf 4d f8          	movswl -0x8(%ebp),%ecx
  10486e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104871:	89 14 24             	mov    %edx,(%esp)
  104874:	ba 03 00 00 00       	mov    $0x3,%edx
  104879:	e8 22 fe ff ff       	call   1046a0 <create>
  10487e:	85 c0                	test   %eax,%eax
  104880:	74 ab                	je     10482d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104882:	89 04 24             	mov    %eax,(%esp)
  104885:	e8 56 d2 ff ff       	call   101ae0 <iunlockput>
  10488a:	31 c0                	xor    %eax,%eax
  return 0;
}
  10488c:	c9                   	leave  
  10488d:	8d 76 00             	lea    0x0(%esi),%esi
  104890:	c3                   	ret    
  104891:	eb 0d                	jmp    1048a0 <sys_mkdir>
  104893:	90                   	nop    
  104894:	90                   	nop    
  104895:	90                   	nop    
  104896:	90                   	nop    
  104897:	90                   	nop    
  104898:	90                   	nop    
  104899:	90                   	nop    
  10489a:	90                   	nop    
  10489b:	90                   	nop    
  10489c:	90                   	nop    
  10489d:	90                   	nop    
  10489e:	90                   	nop    
  10489f:	90                   	nop    

001048a0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
  1048a0:	55                   	push   %ebp
  1048a1:	89 e5                	mov    %esp,%ebp
  1048a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  1048a6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1048a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048b4:	e8 e7 f9 ff ff       	call   1042a0 <argstr>
  1048b9:	85 c0                	test   %eax,%eax
  1048bb:	79 0b                	jns    1048c8 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  1048bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048c2:	c9                   	leave  
  1048c3:	c3                   	ret    
  1048c4:	8d 74 26 00          	lea    0x0(%esi),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  1048c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1048cb:	31 c9                	xor    %ecx,%ecx
  1048cd:	ba 01 00 00 00       	mov    $0x1,%edx
  1048d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048d9:	e8 c2 fd ff ff       	call   1046a0 <create>
  1048de:	85 c0                	test   %eax,%eax
  1048e0:	74 db                	je     1048bd <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1048e2:	89 04 24             	mov    %eax,(%esp)
  1048e5:	e8 f6 d1 ff ff       	call   101ae0 <iunlockput>
  1048ea:	31 c0                	xor    %eax,%eax
  return 0;
}
  1048ec:	c9                   	leave  
  1048ed:	8d 76 00             	lea    0x0(%esi),%esi
  1048f0:	c3                   	ret    
  1048f1:	eb 0d                	jmp    104900 <sys_link>
  1048f3:	90                   	nop    
  1048f4:	90                   	nop    
  1048f5:	90                   	nop    
  1048f6:	90                   	nop    
  1048f7:	90                   	nop    
  1048f8:	90                   	nop    
  1048f9:	90                   	nop    
  1048fa:	90                   	nop    
  1048fb:	90                   	nop    
  1048fc:	90                   	nop    
  1048fd:	90                   	nop    
  1048fe:	90                   	nop    
  1048ff:	90                   	nop    

00104900 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104900:	55                   	push   %ebp
  104901:	89 e5                	mov    %esp,%ebp
  104903:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104906:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104909:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10490c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10490f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104912:	89 44 24 04          	mov    %eax,0x4(%esp)
  104916:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10491d:	e8 7e f9 ff ff       	call   1042a0 <argstr>
  104922:	85 c0                	test   %eax,%eax
  104924:	79 12                	jns    104938 <sys_link+0x38>
bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10492b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10492e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104931:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104934:	89 ec                	mov    %ebp,%esp
  104936:	5d                   	pop    %ebp
  104937:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104938:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10493b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10493f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104946:	e8 55 f9 ff ff       	call   1042a0 <argstr>
  10494b:	85 c0                	test   %eax,%eax
  10494d:	78 d7                	js     104926 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  10494f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104952:	89 04 24             	mov    %eax,(%esp)
  104955:	e8 26 d5 ff ff       	call   101e80 <namei>
  10495a:	85 c0                	test   %eax,%eax
  10495c:	89 c3                	mov    %eax,%ebx
  10495e:	74 c6                	je     104926 <sys_link+0x26>
    return -1;
  ilock(ip);
  104960:	89 04 24             	mov    %eax,(%esp)
  104963:	e8 68 d2 ff ff       	call   101bd0 <ilock>
  if(ip->type == T_DIR){
  104968:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10496d:	74 58                	je     1049c7 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  10496f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104974:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104977:	89 1c 24             	mov    %ebx,(%esp)
  10497a:	e8 d1 ca ff ff       	call   101450 <iupdate>
  iunlock(ip);
  10497f:	89 1c 24             	mov    %ebx,(%esp)
  104982:	e8 d9 cd ff ff       	call   101760 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10498a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  10498e:	89 04 24             	mov    %eax,(%esp)
  104991:	e8 ca d4 ff ff       	call   101e60 <nameiparent>
  104996:	85 c0                	test   %eax,%eax
  104998:	89 c6                	mov    %eax,%esi
  10499a:	74 16                	je     1049b2 <sys_link+0xb2>
    goto bad;
  ilock(dp);
  10499c:	89 04 24             	mov    %eax,(%esp)
  10499f:	e8 2c d2 ff ff       	call   101bd0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
  1049a4:	8b 06                	mov    (%esi),%eax
  1049a6:	3b 03                	cmp    (%ebx),%eax
  1049a8:	74 2f                	je     1049d9 <sys_link+0xd9>
    iunlockput(dp);
  1049aa:	89 34 24             	mov    %esi,(%esp)
  1049ad:	e8 2e d1 ff ff       	call   101ae0 <iunlockput>
  iunlockput(dp);
  iput(ip);
  return 0;

bad:
  ilock(ip);
  1049b2:	89 1c 24             	mov    %ebx,(%esp)
  1049b5:	e8 16 d2 ff ff       	call   101bd0 <ilock>
  ip->nlink--;
  1049ba:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  1049bf:	89 1c 24             	mov    %ebx,(%esp)
  1049c2:	e8 89 ca ff ff       	call   101450 <iupdate>
  iunlockput(ip);
  1049c7:	89 1c 24             	mov    %ebx,(%esp)
  1049ca:	e8 11 d1 ff ff       	call   101ae0 <iunlockput>
  1049cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1049d4:	e9 52 ff ff ff       	jmp    10492b <sys_link+0x2b>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
  1049d9:	8b 43 04             	mov    0x4(%ebx),%eax
  1049dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1049e0:	89 34 24             	mov    %esi,(%esp)
  1049e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1049e7:	e8 04 d0 ff ff       	call   1019f0 <dirlink>
  1049ec:	85 c0                	test   %eax,%eax
  1049ee:	78 ba                	js     1049aa <sys_link+0xaa>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  1049f0:	89 34 24             	mov    %esi,(%esp)
  1049f3:	e8 e8 d0 ff ff       	call   101ae0 <iunlockput>
  iput(ip);
  1049f8:	89 1c 24             	mov    %ebx,(%esp)
  1049fb:	e8 80 ce ff ff       	call   101880 <iput>
  104a00:	31 c0                	xor    %eax,%eax
  104a02:	e9 24 ff ff ff       	jmp    10492b <sys_link+0x2b>
  104a07:	89 f6                	mov    %esi,%esi
  104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104a10 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104a10:	55                   	push   %ebp
  104a11:	89 e5                	mov    %esp,%ebp
  104a13:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104a19:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104a1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104a1f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a2d:	e8 6e f8 ff ff       	call   1042a0 <argstr>
  104a32:	85 c0                	test   %eax,%eax
  104a34:	79 1a                	jns    104a50 <sys_open+0x40>

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  104a36:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
}
  104a3b:	89 d8                	mov    %ebx,%eax
  104a3d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104a40:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104a43:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104a46:	89 ec                	mov    %ebp,%esp
  104a48:	5d                   	pop    %ebp
  104a49:	c3                   	ret    
  104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a5e:	e8 ad f7 ff ff       	call   104210 <argint>
  104a63:	85 c0                	test   %eax,%eax
  104a65:	78 cf                	js     104a36 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  104a67:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  104a6b:	74 63                	je     104ad0 <sys_open+0xc0>
    if((ip = create(path, T_FILE, 0, 0)) == 0)
  104a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a70:	31 c9                	xor    %ecx,%ecx
  104a72:	ba 02 00 00 00       	mov    $0x2,%edx
  104a77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a7e:	e8 1d fc ff ff       	call   1046a0 <create>
  104a83:	85 c0                	test   %eax,%eax
  104a85:	89 c7                	mov    %eax,%edi
  104a87:	74 ad                	je     104a36 <sys_open+0x26>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104a89:	e8 42 c4 ff ff       	call   100ed0 <filealloc>
  104a8e:	85 c0                	test   %eax,%eax
  104a90:	89 c6                	mov    %eax,%esi
  104a92:	74 24                	je     104ab8 <sys_open+0xa8>
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104a94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104a9a:	31 db                	xor    %ebx,%ebx
  104a9c:	8d 74 26 00          	lea    0x0(%esi),%esi
  104aa0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
  104aa4:	85 d2                	test   %edx,%edx
  104aa6:	74 60                	je     104b08 <sys_open+0xf8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104aa8:	83 c3 01             	add    $0x1,%ebx
  104aab:	83 fb 10             	cmp    $0x10,%ebx
  104aae:	75 f0                	jne    104aa0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104ab0:	89 34 24             	mov    %esi,(%esp)
  104ab3:	e8 88 c4 ff ff       	call   100f40 <fileclose>
    iunlockput(ip);
  104ab8:	89 3c 24             	mov    %edi,(%esp)
  104abb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104ac0:	e8 1b d0 ff ff       	call   101ae0 <iunlockput>
  104ac5:	e9 71 ff ff ff       	jmp    104a3b <sys_open+0x2b>
  104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad3:	89 04 24             	mov    %eax,(%esp)
  104ad6:	e8 a5 d3 ff ff       	call   101e80 <namei>
  104adb:	85 c0                	test   %eax,%eax
  104add:	89 c7                	mov    %eax,%edi
  104adf:	0f 84 51 ff ff ff    	je     104a36 <sys_open+0x26>
      return -1;
    ilock(ip);
  104ae5:	89 04 24             	mov    %eax,(%esp)
  104ae8:	e8 e3 d0 ff ff       	call   101bd0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
  104aed:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  104af2:	75 95                	jne    104a89 <sys_open+0x79>
  104af4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  104af7:	85 c9                	test   %ecx,%ecx
  104af9:	74 8e                	je     104a89 <sys_open+0x79>
  104afb:	90                   	nop    
  104afc:	8d 74 26 00          	lea    0x0(%esi),%esi
  104b00:	eb b6                	jmp    104ab8 <sys_open+0xa8>
  104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104b08:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104b0c:	89 3c 24             	mov    %edi,(%esp)
  104b0f:	e8 4c cc ff ff       	call   101760 <iunlock>

  f->type = FD_INODE;
  104b14:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  104b1a:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  104b1d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  104b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b27:	83 f0 01             	xor    $0x1,%eax
  104b2a:	83 e0 01             	and    $0x1,%eax
  104b2d:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104b30:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  104b34:	0f 95 46 09          	setne  0x9(%esi)
  104b38:	e9 fe fe ff ff       	jmp    104a3b <sys_open+0x2b>
  104b3d:	8d 76 00             	lea    0x0(%esi),%esi

00104b40 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104b40:	55                   	push   %ebp
  104b41:	89 e5                	mov    %esp,%ebp
  104b43:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104b46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104b49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b5d:	e8 3e f7 ff ff       	call   1042a0 <argstr>
  104b62:	85 c0                	test   %eax,%eax
  104b64:	79 12                	jns    104b78 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  104b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104b71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104b74:	89 ec                	mov    %ebp,%esp
  104b76:	5d                   	pop    %ebp
  104b77:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  104b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b7b:	8d 5d de             	lea    -0x22(%ebp),%ebx
  104b7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104b82:	89 04 24             	mov    %eax,(%esp)
  104b85:	e8 d6 d2 ff ff       	call   101e60 <nameiparent>
  104b8a:	85 c0                	test   %eax,%eax
  104b8c:	89 c7                	mov    %eax,%edi
  104b8e:	74 d6                	je     104b66 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  104b90:	89 04 24             	mov    %eax,(%esp)
  104b93:	e8 38 d0 ff ff       	call   101bd0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  104b98:	c7 44 24 04 44 66 10 	movl   $0x106644,0x4(%esp)
  104b9f:	00 
  104ba0:	89 1c 24             	mov    %ebx,(%esp)
  104ba3:	e8 78 ca ff ff       	call   101620 <namecmp>
  104ba8:	85 c0                	test   %eax,%eax
  104baa:	74 14                	je     104bc0 <sys_unlink+0x80>
  104bac:	c7 44 24 04 43 66 10 	movl   $0x106643,0x4(%esp)
  104bb3:	00 
  104bb4:	89 1c 24             	mov    %ebx,(%esp)
  104bb7:	e8 64 ca ff ff       	call   101620 <namecmp>
  104bbc:	85 c0                	test   %eax,%eax
  104bbe:	75 18                	jne    104bd8 <sys_unlink+0x98>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  104bc0:	89 3c 24             	mov    %edi,(%esp)
  104bc3:	e8 18 cf ff ff       	call   101ae0 <iunlockput>
  104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104bcd:	8d 76 00             	lea    0x0(%esi),%esi
  104bd0:	eb 99                	jmp    104b6b <sys_unlink+0x2b>
  104bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  104bd8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104bdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  104bdf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104be3:	89 3c 24             	mov    %edi,(%esp)
  104be6:	e8 65 ca ff ff       	call   101650 <dirlookup>
  104beb:	85 c0                	test   %eax,%eax
  104bed:	89 c6                	mov    %eax,%esi
  104bef:	74 cf                	je     104bc0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  104bf1:	89 04 24             	mov    %eax,(%esp)
  104bf4:	e8 d7 cf ff ff       	call   101bd0 <ilock>

  if(ip->nlink < 1)
  104bf9:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  104bfe:	0f 8e fe 00 00 00    	jle    104d02 <sys_unlink+0x1c2>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  104c04:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104c10:	75 5b                	jne    104c6d <sys_unlink+0x12d>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  104c12:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  104c16:	66 90                	xchg   %ax,%ax
  104c18:	76 53                	jbe    104c6d <sys_unlink+0x12d>
  104c1a:	bb 20 00 00 00       	mov    $0x20,%ebx
  104c1f:	90                   	nop    
  104c20:	eb 10                	jmp    104c32 <sys_unlink+0xf2>
  104c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104c28:	83 c3 10             	add    $0x10,%ebx
  104c2b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  104c2e:	66 90                	xchg   %ax,%ax
  104c30:	73 3b                	jae    104c6d <sys_unlink+0x12d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104c32:	8d 45 be             	lea    -0x42(%ebp),%eax
  104c35:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104c3c:	00 
  104c3d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c45:	89 34 24             	mov    %esi,(%esp)
  104c48:	e8 f3 c6 ff ff       	call   101340 <readi>
  104c4d:	83 f8 10             	cmp    $0x10,%eax
  104c50:	0f 85 94 00 00 00    	jne    104cea <sys_unlink+0x1aa>
      panic("isdirempty: readi");
    if(de.inum != 0)
  104c56:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  104c5b:	74 cb                	je     104c28 <sys_unlink+0xe8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  104c5d:	89 34 24             	mov    %esi,(%esp)
  104c60:	e8 7b ce ff ff       	call   101ae0 <iunlockput>
  104c65:	8d 76 00             	lea    0x0(%esi),%esi
  104c68:	e9 53 ff ff ff       	jmp    104bc0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  104c6d:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  104c70:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104c77:	00 
  104c78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c7f:	00 
  104c80:	89 1c 24             	mov    %ebx,(%esp)
  104c83:	e8 d8 f2 ff ff       	call   103f60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c8b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104c92:	00 
  104c93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104c97:	89 3c 24             	mov    %edi,(%esp)
  104c9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  104c9e:	e8 3d c8 ff ff       	call   1014e0 <writei>
  104ca3:	83 f8 10             	cmp    $0x10,%eax
  104ca6:	75 4e                	jne    104cf6 <sys_unlink+0x1b6>
    panic("unlink: writei");
  if(ip->type == T_DIR){
  104ca8:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104cad:	74 2a                	je     104cd9 <sys_unlink+0x199>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
  104caf:	89 3c 24             	mov    %edi,(%esp)
  104cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104cb8:	e8 23 ce ff ff       	call   101ae0 <iunlockput>

  ip->nlink--;
  104cbd:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  104cc2:	89 34 24             	mov    %esi,(%esp)
  104cc5:	e8 86 c7 ff ff       	call   101450 <iupdate>
  iunlockput(ip);
  104cca:	89 34 24             	mov    %esi,(%esp)
  104ccd:	e8 0e ce ff ff       	call   101ae0 <iunlockput>
  104cd2:	31 c0                	xor    %eax,%eax
  104cd4:	e9 92 fe ff ff       	jmp    104b6b <sys_unlink+0x2b>

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
  104cd9:	66 83 6f 16 01       	subw   $0x1,0x16(%edi)
    iupdate(dp);
  104cde:	89 3c 24             	mov    %edi,(%esp)
  104ce1:	e8 6a c7 ff ff       	call   101450 <iupdate>
  104ce6:	66 90                	xchg   %ax,%ax
  104ce8:	eb c5                	jmp    104caf <sys_unlink+0x16f>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  104cea:	c7 04 24 74 66 10 00 	movl   $0x106674,(%esp)
  104cf1:	e8 8a bb ff ff       	call   100880 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  104cf6:	c7 04 24 86 66 10 00 	movl   $0x106686,(%esp)
  104cfd:	e8 7e bb ff ff       	call   100880 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  104d02:	c7 04 24 62 66 10 00 	movl   $0x106662,(%esp)
  104d09:	e8 72 bb ff ff       	call   100880 <panic>
  104d0e:	66 90                	xchg   %ax,%ax

00104d10 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  104d10:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d11:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  104d13:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d15:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  104d17:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d1a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104d1d:	e8 5e f7 ff ff       	call   104480 <argfd>
  104d22:	85 c0                	test   %eax,%eax
  104d24:	79 0a                	jns    104d30 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  104d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d2b:	c9                   	leave  
  104d2c:	c3                   	ret    
  104d2d:	8d 76 00             	lea    0x0(%esi),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104d30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104d33:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  104d3a:	00 
  104d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d46:	e8 05 f5 ff ff       	call   104250 <argptr>
  104d4b:	85 c0                	test   %eax,%eax
  104d4d:	78 d7                	js     104d26 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  104d4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104d59:	89 04 24             	mov    %eax,(%esp)
  104d5c:	e8 cf c0 ff ff       	call   100e30 <filestat>
}
  104d61:	c9                   	leave  
  104d62:	c3                   	ret    
  104d63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104d70 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104d70:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d71:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104d73:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d75:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104d77:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d7a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104d7d:	e8 fe f6 ff ff       	call   104480 <argfd>
  104d82:	85 c0                	test   %eax,%eax
  104d84:	79 0a                	jns    104d90 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  104d86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d8b:	c9                   	leave  
  104d8c:	c3                   	ret    
  104d8d:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104d90:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d97:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104d9e:	e8 6d f4 ff ff       	call   104210 <argint>
  104da3:	85 c0                	test   %eax,%eax
  104da5:	78 df                	js     104d86 <sys_write+0x16>
  104da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104daa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104db1:	89 44 24 08          	mov    %eax,0x8(%esp)
  104db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104db8:	89 44 24 04          	mov    %eax,0x4(%esp)
  104dbc:	e8 8f f4 ff ff       	call   104250 <argptr>
  104dc1:	85 c0                	test   %eax,%eax
  104dc3:	78 c1                	js     104d86 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  104dc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104dc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  104dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  104dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104dd6:	89 04 24             	mov    %eax,(%esp)
  104dd9:	e8 f2 be ff ff       	call   100cd0 <filewrite>
}
  104dde:	c9                   	leave  
  104ddf:	c3                   	ret    

00104de0 <sys_read>:
  return fd;
}

int
sys_read(void)
{
  104de0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104de1:	31 d2                	xor    %edx,%edx
  return fd;
}

int
sys_read(void)
{
  104de3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104de5:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
  104de7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104dea:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104ded:	e8 8e f6 ff ff       	call   104480 <argfd>
  104df2:	85 c0                	test   %eax,%eax
  104df4:	79 0a                	jns    104e00 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  104df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104dfb:	c9                   	leave  
  104dfc:	c3                   	ret    
  104dfd:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104e00:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e07:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104e0e:	e8 fd f3 ff ff       	call   104210 <argint>
  104e13:	85 c0                	test   %eax,%eax
  104e15:	78 df                	js     104df6 <sys_read+0x16>
  104e17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104e1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e21:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104e28:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e2c:	e8 1f f4 ff ff       	call   104250 <argptr>
  104e31:	85 c0                	test   %eax,%eax
  104e33:	78 c1                	js     104df6 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  104e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104e38:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104e46:	89 04 24             	mov    %eax,(%esp)
  104e49:	e8 32 bf ff ff       	call   100d80 <fileread>
}
  104e4e:	c9                   	leave  
  104e4f:	c3                   	ret    

00104e50 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
  104e50:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104e51:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_dup(void)
{
  104e53:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104e55:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
  104e57:	53                   	push   %ebx
  104e58:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104e5b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104e5e:	e8 1d f6 ff ff       	call   104480 <argfd>
  104e63:	85 c0                	test   %eax,%eax
  104e65:	79 11                	jns    104e78 <sys_dup+0x28>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104e67:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
  104e6c:	89 d8                	mov    %ebx,%eax
  104e6e:	83 c4 14             	add    $0x14,%esp
  104e71:	5b                   	pop    %ebx
  104e72:	5d                   	pop    %ebp
  104e73:	c3                   	ret    
  104e74:	8d 74 26 00          	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  104e78:	8b 55 f8             	mov    -0x8(%ebp),%edx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104e7b:	31 db                	xor    %ebx,%ebx
  104e7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104e83:	eb 0b                	jmp    104e90 <sys_dup+0x40>
  104e85:	8d 76 00             	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104e88:	83 c3 01             	add    $0x1,%ebx
  104e8b:	83 fb 10             	cmp    $0x10,%ebx
  104e8e:	74 d7                	je     104e67 <sys_dup+0x17>
    if(proc->ofile[fd] == 0){
  104e90:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
  104e94:	85 c9                	test   %ecx,%ecx
  104e96:	75 f0                	jne    104e88 <sys_dup+0x38>
      proc->ofile[fd] = f;
  104e98:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  104e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104e9f:	89 04 24             	mov    %eax,(%esp)
  104ea2:	e8 d9 bf ff ff       	call   100e80 <filedup>
  104ea7:	eb c3                	jmp    104e6c <sys_dup+0x1c>
  104ea9:	90                   	nop    
  104eaa:	90                   	nop    
  104eab:	90                   	nop    
  104eac:	90                   	nop    
  104ead:	90                   	nop    
  104eae:	90                   	nop    
  104eaf:	90                   	nop    

00104eb0 <sys_getpid>:
}

int
sys_getpid(void)
{
  return proc->pid;
  104eb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
  104eb6:	55                   	push   %ebp
  104eb7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
  104eb9:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
  104eba:	8b 40 10             	mov    0x10(%eax),%eax
}
  104ebd:	c3                   	ret    
  104ebe:	66 90                	xchg   %ax,%ax

00104ec0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  104ec0:	55                   	push   %ebp
  104ec1:	89 e5                	mov    %esp,%ebp
  104ec3:	53                   	push   %ebx
  104ec4:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  104ec7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104eca:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ece:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ed5:	e8 36 f3 ff ff       	call   104210 <argint>
  104eda:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104edf:	85 c0                	test   %eax,%eax
  104ee1:	78 5b                	js     104f3e <sys_sleep+0x7e>
    return -1;
  acquire(&tickslock);
  104ee3:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  104eea:	e8 d1 ef ff ff       	call   103ec0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104eef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  104ef2:	8b 1d e0 df 10 00    	mov    0x10dfe0,%ebx
  while(ticks - ticks0 < n){
  104ef8:	85 d2                	test   %edx,%edx
  104efa:	7f 24                	jg     104f20 <sys_sleep+0x60>
  104efc:	eb 4a                	jmp    104f48 <sys_sleep+0x88>
  104efe:	66 90                	xchg   %ax,%ax
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  104f00:	c7 44 24 04 a0 d7 10 	movl   $0x10d7a0,0x4(%esp)
  104f07:	00 
  104f08:	c7 04 24 e0 df 10 00 	movl   $0x10dfe0,(%esp)
  104f0f:	e8 0c e5 ff ff       	call   103420 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104f14:	a1 e0 df 10 00       	mov    0x10dfe0,%eax
  104f19:	29 d8                	sub    %ebx,%eax
  104f1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  104f1e:	7d 28                	jge    104f48 <sys_sleep+0x88>
    if(proc->killed){
  104f20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104f26:	8b 40 24             	mov    0x24(%eax),%eax
  104f29:	85 c0                	test   %eax,%eax
  104f2b:	74 d3                	je     104f00 <sys_sleep+0x40>
      release(&tickslock);
  104f2d:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  104f34:	e8 37 ef ff ff       	call   103e70 <release>
  104f39:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  104f3e:	83 c4 24             	add    $0x24,%esp
  104f41:	89 d0                	mov    %edx,%eax
  104f43:	5b                   	pop    %ebx
  104f44:	5d                   	pop    %ebp
  104f45:	c3                   	ret    
  104f46:	66 90                	xchg   %ax,%ax
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  104f48:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  104f4f:	e8 1c ef ff ff       	call   103e70 <release>
  104f54:	31 d2                	xor    %edx,%edx
  return 0;
}
  104f56:	83 c4 24             	add    $0x24,%esp
  104f59:	89 d0                	mov    %edx,%eax
  104f5b:	5b                   	pop    %ebx
  104f5c:	5d                   	pop    %ebp
  104f5d:	c3                   	ret    
  104f5e:	66 90                	xchg   %ax,%ax

00104f60 <sys_sbrk>:
  return proc->pid;
}

int
sys_sbrk(void)
{
  104f60:	55                   	push   %ebp
  104f61:	89 e5                	mov    %esp,%ebp
  104f63:	53                   	push   %ebx
  104f64:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  104f67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f75:	e8 96 f2 ff ff       	call   104210 <argint>
  104f7a:	85 c0                	test   %eax,%eax
  104f7c:	79 12                	jns    104f90 <sys_sbrk+0x30>
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
  104f7e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  104f83:	83 c4 24             	add    $0x24,%esp
  104f86:	89 d0                	mov    %edx,%eax
  104f88:	5b                   	pop    %ebx
  104f89:	5d                   	pop    %ebp
  104f8a:	c3                   	ret    
  104f8b:	90                   	nop    
  104f8c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  104f90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104f96:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc(n) < 0)
  104f99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104f9c:	89 04 24             	mov    %eax,(%esp)
  104f9f:	e8 2c eb ff ff       	call   103ad0 <growproc>
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  104fa4:	89 da                	mov    %ebx,%edx
  if(growproc(n) < 0)
  104fa6:	85 c0                	test   %eax,%eax
  104fa8:	79 d9                	jns    104f83 <sys_sbrk+0x23>
  104faa:	eb d2                	jmp    104f7e <sys_sbrk+0x1e>
  104fac:	8d 74 26 00          	lea    0x0(%esi),%esi

00104fb0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  104fb0:	55                   	push   %ebp
  104fb1:	89 e5                	mov    %esp,%ebp
  104fb3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  104fb6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fc4:	e8 47 f2 ff ff       	call   104210 <argint>
  104fc9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104fce:	85 c0                	test   %eax,%eax
  104fd0:	78 0d                	js     104fdf <sys_kill+0x2f>
    return -1;
  return kill(pid);
  104fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104fd5:	89 04 24             	mov    %eax,(%esp)
  104fd8:	e8 53 e1 ff ff       	call   103130 <kill>
  104fdd:	89 c2                	mov    %eax,%edx
}
  104fdf:	89 d0                	mov    %edx,%eax
  104fe1:	c9                   	leave  
  104fe2:	c3                   	ret    
  104fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104ff0 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
  104ff0:	55                   	push   %ebp
  104ff1:	89 e5                	mov    %esp,%ebp
  return wait();
}
  104ff3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  104ff4:	e9 f7 e4 ff ff       	jmp    1034f0 <wait>
  104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105000 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
  105000:	55                   	push   %ebp
  105001:	89 e5                	mov    %esp,%ebp
  105003:	83 ec 08             	sub    $0x8,%esp
  exit();
  105006:	e8 e5 e2 ff ff       	call   1032f0 <exit>
  return 0;  // not reached
}
  10500b:	31 c0                	xor    %eax,%eax
  10500d:	c9                   	leave  
  10500e:	c3                   	ret    
  10500f:	90                   	nop    

00105010 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105010:	55                   	push   %ebp
  105011:	89 e5                	mov    %esp,%ebp
  return fork();
}
  105013:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
  105014:	e9 f7 e6 ff ff       	jmp    103710 <fork>
  105019:	90                   	nop    
  10501a:	90                   	nop    
  10501b:	90                   	nop    
  10501c:	90                   	nop    
  10501d:	90                   	nop    
  10501e:	90                   	nop    
  10501f:	90                   	nop    

00105020 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
  105020:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105021:	ba 43 00 00 00       	mov    $0x43,%edx
  105026:	89 e5                	mov    %esp,%ebp
  105028:	b8 34 00 00 00       	mov    $0x34,%eax
  10502d:	83 ec 08             	sub    $0x8,%esp
  105030:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
  105031:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105036:	b2 40                	mov    $0x40,%dl
  105038:	ee                   	out    %al,(%dx)
  105039:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10503e:	ee                   	out    %al,(%dx)
  10503f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105046:	e8 65 dc ff ff       	call   102cb0 <picenable>
}
  10504b:	c9                   	leave  
  10504c:	c3                   	ret    
  10504d:	90                   	nop    
  10504e:	90                   	nop    
  10504f:	90                   	nop    

00105050 <alltraps>:
  105050:	1e                   	push   %ds
  105051:	06                   	push   %es
  105052:	0f a0                	push   %fs
  105054:	0f a8                	push   %gs
  105056:	60                   	pusha  
  105057:	66 b8 10 00          	mov    $0x10,%ax
  10505b:	8e d8                	mov    %eax,%ds
  10505d:	8e c0                	mov    %eax,%es
  10505f:	66 b8 18 00          	mov    $0x18,%ax
  105063:	8e e0                	mov    %eax,%fs
  105065:	8e e8                	mov    %eax,%gs
  105067:	54                   	push   %esp
  105068:	e8 43 00 00 00       	call   1050b0 <trap>
  10506d:	83 c4 04             	add    $0x4,%esp

00105070 <trapret>:
  105070:	61                   	popa   
  105071:	0f a9                	pop    %gs
  105073:	0f a1                	pop    %fs
  105075:	07                   	pop    %es
  105076:	1f                   	pop    %ds
  105077:	83 c4 08             	add    $0x8,%esp
  10507a:	cf                   	iret   
  10507b:	90                   	nop    
  10507c:	90                   	nop    
  10507d:	90                   	nop    
  10507e:	90                   	nop    
  10507f:	90                   	nop    

00105080 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105080:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105081:	b8 e0 d7 10 00       	mov    $0x10d7e0,%eax
  105086:	89 e5                	mov    %esp,%ebp
  105088:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10508b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105091:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105095:	c1 e8 10             	shr    $0x10,%eax
  105098:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10509c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10509f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  1050a2:	c9                   	leave  
  1050a3:	c3                   	ret    
  1050a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1050aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001050b0 <trap>:

void
trap(struct trapframe *tf)
{
  1050b0:	55                   	push   %ebp
  1050b1:	89 e5                	mov    %esp,%ebp
  1050b3:	56                   	push   %esi
  1050b4:	53                   	push   %ebx
  1050b5:	83 ec 20             	sub    $0x20,%esp
  1050b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
  1050bb:	8b 4b 30             	mov    0x30(%ebx),%ecx
  1050be:	83 f9 40             	cmp    $0x40,%ecx
  1050c1:	74 55                	je     105118 <trap+0x68>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1050c3:	8d 41 e0             	lea    -0x20(%ecx),%eax
  1050c6:	83 f8 1f             	cmp    $0x1f,%eax
  1050c9:	76 45                	jbe    105110 <trap+0x60>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
  1050cb:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
  1050d2:	85 f6                	test   %esi,%esi
  1050d4:	74 0a                	je     1050e0 <trap+0x30>
  1050d6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
  1050da:	0f 85 c8 01 00 00    	jne    1052a8 <trap+0x1f8>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  1050e0:	8b 43 38             	mov    0x38(%ebx),%eax
  1050e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1050e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1050ed:	0f b6 00             	movzbl (%eax),%eax
  1050f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1050f4:	c7 04 24 bc 66 10 00 	movl   $0x1066bc,(%esp)
  1050fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050ff:	e8 9c b3 ff ff       	call   1004a0 <cprintf>
              tf->trapno, cpu->id, tf->eip);
      panic("trap");
  105104:	c7 04 24 20 67 10 00 	movl   $0x106720,(%esp)
  10510b:	e8 70 b7 ff ff       	call   100880 <panic>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105110:	ff 24 85 2c 67 10 00 	jmp    *0x10672c(,%eax,4)
  105117:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
  105118:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10511f:	8b 72 24             	mov    0x24(%edx),%esi
  105122:	85 f6                	test   %esi,%esi
  105124:	0f 85 3e 01 00 00    	jne    105268 <trap+0x1b8>
      exit();
    proc->tf = tf;
  10512a:	89 5a 18             	mov    %ebx,0x18(%edx)
    syscall();
  10512d:	e8 ee f1 ff ff       	call   104320 <syscall>
    if(proc->killed)
  105132:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105138:	8b 58 24             	mov    0x24(%eax),%ebx
  10513b:	85 db                	test   %ebx,%ebx
  10513d:	75 50                	jne    10518f <trap+0xdf>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
  10513f:	83 c4 20             	add    $0x20,%esp
  105142:	5b                   	pop    %ebx
  105143:	5e                   	pop    %esi
  105144:	5d                   	pop    %ebp
  105145:	c3                   	ret    
  105146:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  105148:	e8 f3 ce ff ff       	call   102040 <ideintr>
    lapiceoi();
  10514d:	e8 9e d5 ff ff       	call   1026f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  105152:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  105159:	85 d2                	test   %edx,%edx
  10515b:	74 e2                	je     10513f <trap+0x8f>
  10515d:	8b 4a 24             	mov    0x24(%edx),%ecx
  105160:	85 c9                	test   %ecx,%ecx
  105162:	74 10                	je     105174 <trap+0xc4>
  105164:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  105168:	83 e0 03             	and    $0x3,%eax
  10516b:	83 f8 03             	cmp    $0x3,%eax
  10516e:	0f 84 14 01 00 00    	je     105288 <trap+0x1d8>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  105174:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
  105178:	74 26                	je     1051a0 <trap+0xf0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  10517a:	89 d0                	mov    %edx,%eax
  10517c:	8b 40 24             	mov    0x24(%eax),%eax
  10517f:	85 c0                	test   %eax,%eax
  105181:	74 bc                	je     10513f <trap+0x8f>
  105183:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  105187:	83 e0 03             	and    $0x3,%eax
  10518a:	83 f8 03             	cmp    $0x3,%eax
  10518d:	75 b0                	jne    10513f <trap+0x8f>
    exit();
}
  10518f:	83 c4 20             	add    $0x20,%esp
  105192:	5b                   	pop    %ebx
  105193:	5e                   	pop    %esi
  105194:	5d                   	pop    %ebp
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  105195:	e9 56 e1 ff ff       	jmp    1032f0 <exit>
  10519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  1051a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
  1051a4:	75 d4                	jne    10517a <trap+0xca>
    yield();
  1051a6:	e8 45 e4 ff ff       	call   1035f0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  1051ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1051b1:	85 c0                	test   %eax,%eax
  1051b3:	75 c7                	jne    10517c <trap+0xcc>
  1051b5:	eb 88                	jmp    10513f <trap+0x8f>
  1051b7:	90                   	nop    
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
  1051b8:	e8 d3 d3 ff ff       	call   102590 <kbdintr>
  1051bd:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  1051c0:	e8 2b d5 ff ff       	call   1026f0 <lapiceoi>
  1051c5:	8d 76 00             	lea    0x0(%esi),%esi
  1051c8:	eb 88                	jmp    105152 <trap+0xa2>
  1051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
  1051d0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1051d6:	80 38 00             	cmpb   $0x0,(%eax)
  1051d9:	0f 85 6e ff ff ff    	jne    10514d <trap+0x9d>
      acquire(&tickslock);
  1051df:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  1051e6:	e8 d5 ec ff ff       	call   103ec0 <acquire>
      ticks++;
  1051eb:	83 05 e0 df 10 00 01 	addl   $0x1,0x10dfe0
      wakeup(&ticks);
  1051f2:	c7 04 24 e0 df 10 00 	movl   $0x10dfe0,(%esp)
  1051f9:	e8 b2 df ff ff       	call   1031b0 <wakeup>
      release(&tickslock);
  1051fe:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
  105205:	e8 66 ec ff ff       	call   103e70 <release>
  10520a:	e9 3e ff ff ff       	jmp    10514d <trap+0x9d>
  10520f:	90                   	nop    
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105210:	8b 43 38             	mov    0x38(%ebx),%eax
  105213:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105217:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  10521b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10521f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  105225:	0f b6 00             	movzbl (%eax),%eax
  105228:	c7 04 24 98 66 10 00 	movl   $0x106698,(%esp)
  10522f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105233:	e8 68 b2 ff ff       	call   1004a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
  105238:	e8 b3 d4 ff ff       	call   1026f0 <lapiceoi>
  10523d:	e9 10 ff ff ff       	jmp    105152 <trap+0xa2>
  105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105248:	90                   	nop    
  105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  105250:	e8 6b 01 00 00       	call   1053c0 <uartintr>
  105255:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105258:	e8 93 d4 ff ff       	call   1026f0 <lapiceoi>
  10525d:	8d 76 00             	lea    0x0(%esi),%esi
  105260:	e9 ed fe ff ff       	jmp    105152 <trap+0xa2>
  105265:	8d 76 00             	lea    0x0(%esi),%esi
  105268:	90                   	nop    
  105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
  105270:	e8 7b e0 ff ff       	call   1032f0 <exit>
  105275:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10527c:	8d 74 26 00          	lea    0x0(%esi),%esi
  105280:	e9 a5 fe ff ff       	jmp    10512a <trap+0x7a>
  105285:	8d 76 00             	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  105288:	e8 63 e0 ff ff       	call   1032f0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  10528d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  105294:	85 d2                	test   %edx,%edx
  105296:	0f 85 d8 fe ff ff    	jne    105174 <trap+0xc4>
  10529c:	e9 9e fe ff ff       	jmp    10513f <trap+0x8f>
  1052a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu->id, tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1052a8:	8b 43 38             	mov    0x38(%ebx),%eax
  1052ab:	8b 56 10             	mov    0x10(%esi),%edx
  1052ae:	89 44 24 18          	mov    %eax,0x18(%esp)
  1052b2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1052b8:	0f b6 00             	movzbl (%eax),%eax
  1052bb:	89 44 24 14          	mov    %eax,0x14(%esp)
  1052bf:	8b 43 34             	mov    0x34(%ebx),%eax
  1052c2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1052c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052ca:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1052d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1052d5:	8d 46 6c             	lea    0x6c(%esi),%eax
  1052d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052dc:	e8 bf b1 ff ff       	call   1004a0 <cprintf>
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip);
    proc->killed = 1;
  1052e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1052e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  1052ee:	e9 5f fe ff ff       	jmp    105152 <trap+0xa2>
  1052f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105300 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105300:	55                   	push   %ebp
  105301:	31 d2                	xor    %edx,%edx
  105303:	89 e5                	mov    %esp,%ebp
  105305:	b9 e0 d7 10 00       	mov    $0x10d7e0,%ecx
  10530a:	83 ec 08             	sub    $0x8,%esp
  10530d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105310:	8b 04 95 c8 7a 10 00 	mov    0x107ac8(,%edx,4),%eax
  105317:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
  10531e:	66 89 04 d5 e0 d7 10 	mov    %ax,0x10d7e0(,%edx,8)
  105325:	00 
  105326:	c1 e8 10             	shr    $0x10,%eax
  105329:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
  10532e:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
  105333:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105338:	83 c2 01             	add    $0x1,%edx
  10533b:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  105341:	75 cd                	jne    105310 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105343:	a1 c8 7b 10 00       	mov    0x107bc8,%eax
  
  initlock(&tickslock, "time");
  105348:	c7 44 24 04 25 67 10 	movl   $0x106725,0x4(%esp)
  10534f:	00 
  105350:	c7 04 24 a0 d7 10 00 	movl   $0x10d7a0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105357:	66 c7 05 e2 d9 10 00 	movw   $0x8,0x10d9e2
  10535e:	08 00 
  105360:	66 a3 e0 d9 10 00    	mov    %ax,0x10d9e0
  105366:	c1 e8 10             	shr    $0x10,%eax
  105369:	c6 05 e4 d9 10 00 00 	movb   $0x0,0x10d9e4
  105370:	c6 05 e5 d9 10 00 ef 	movb   $0xef,0x10d9e5
  105377:	66 a3 e6 d9 10 00    	mov    %ax,0x10d9e6
  
  initlock(&tickslock, "time");
  10537d:	e8 ae e9 ff ff       	call   103d30 <initlock>
}
  105382:	c9                   	leave  
  105383:	c3                   	ret    
  105384:	90                   	nop    
  105385:	90                   	nop    
  105386:	90                   	nop    
  105387:	90                   	nop    
  105388:	90                   	nop    
  105389:	90                   	nop    
  10538a:	90                   	nop    
  10538b:	90                   	nop    
  10538c:	90                   	nop    
  10538d:	90                   	nop    
  10538e:	90                   	nop    
  10538f:	90                   	nop    

00105390 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
  105390:	a1 0c 80 10 00       	mov    0x10800c,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
  105395:	55                   	push   %ebp
  105396:	89 e5                	mov    %esp,%ebp
  if(!uart)
  105398:	85 c0                	test   %eax,%eax
  10539a:	75 0c                	jne    1053a8 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
  10539c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1053a1:	5d                   	pop    %ebp
  1053a2:	c3                   	ret    
  1053a3:	90                   	nop    
  1053a4:	8d 74 26 00          	lea    0x0(%esi),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1053a8:	ba fd 03 00 00       	mov    $0x3fd,%edx
  1053ad:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
  1053ae:	a8 01                	test   $0x1,%al
  1053b0:	74 ea                	je     10539c <uartgetc+0xc>
  1053b2:	b2 f8                	mov    $0xf8,%dl
  1053b4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  1053b5:	0f b6 c0             	movzbl %al,%eax
}
  1053b8:	5d                   	pop    %ebp
  1053b9:	c3                   	ret    
  1053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001053c0 <uartintr>:

void
uartintr(void)
{
  1053c0:	55                   	push   %ebp
  1053c1:	89 e5                	mov    %esp,%ebp
  1053c3:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
  1053c6:	c7 04 24 90 53 10 00 	movl   $0x105390,(%esp)
  1053cd:	e8 3e b3 ff ff       	call   100710 <consoleintr>
}
  1053d2:	c9                   	leave  
  1053d3:	c3                   	ret    
  1053d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1053da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001053e0 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
  1053e0:	55                   	push   %ebp
  1053e1:	89 e5                	mov    %esp,%ebp
  1053e3:	56                   	push   %esi
  1053e4:	be fd 03 00 00       	mov    $0x3fd,%esi
  1053e9:	53                   	push   %ebx
  int i;

  if(!uart)
    return;
  1053ea:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
  1053ec:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  1053ef:	8b 15 0c 80 10 00    	mov    0x10800c,%edx
  1053f5:	85 d2                	test   %edx,%edx
  1053f7:	75 21                	jne    10541a <uartputc+0x3a>
  1053f9:	eb 30                	jmp    10542b <uartputc+0x4b>
  1053fb:	90                   	nop    
  1053fc:	8d 74 26 00          	lea    0x0(%esi),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  105400:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
  105403:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10540a:	e8 01 d3 ff ff       	call   102710 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  10540f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  105415:	8d 76 00             	lea    0x0(%esi),%esi
  105418:	74 07                	je     105421 <uartputc+0x41>
  10541a:	89 f2                	mov    %esi,%edx
  10541c:	ec                   	in     (%dx),%al
  10541d:	a8 20                	test   $0x20,%al
  10541f:	74 df                	je     105400 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105421:	ba f8 03 00 00       	mov    $0x3f8,%edx
  105426:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  10542a:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
  10542b:	83 c4 10             	add    $0x10,%esp
  10542e:	5b                   	pop    %ebx
  10542f:	5e                   	pop    %esi
  105430:	5d                   	pop    %ebp
  105431:	c3                   	ret    
  105432:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105440 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  105440:	55                   	push   %ebp
  105441:	31 c9                	xor    %ecx,%ecx
  105443:	89 e5                	mov    %esp,%ebp
  105445:	89 c8                	mov    %ecx,%eax
  105447:	57                   	push   %edi
  105448:	bf fa 03 00 00       	mov    $0x3fa,%edi
  10544d:	56                   	push   %esi
  10544e:	89 fa                	mov    %edi,%edx
  105450:	53                   	push   %ebx
  105451:	83 ec 0c             	sub    $0xc,%esp
  105454:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  105455:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  10545a:	b2 fb                	mov    $0xfb,%dl
  10545c:	ee                   	out    %al,(%dx)
  10545d:	be f8 03 00 00       	mov    $0x3f8,%esi
  105462:	b8 0c 00 00 00       	mov    $0xc,%eax
  105467:	89 f2                	mov    %esi,%edx
  105469:	ee                   	out    %al,(%dx)
  10546a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
  10546f:	89 c8                	mov    %ecx,%eax
  105471:	89 da                	mov    %ebx,%edx
  105473:	ee                   	out    %al,(%dx)
  105474:	b8 03 00 00 00       	mov    $0x3,%eax
  105479:	b2 fb                	mov    $0xfb,%dl
  10547b:	ee                   	out    %al,(%dx)
  10547c:	b2 fc                	mov    $0xfc,%dl
  10547e:	89 c8                	mov    %ecx,%eax
  105480:	ee                   	out    %al,(%dx)
  105481:	b8 01 00 00 00       	mov    $0x1,%eax
  105486:	89 da                	mov    %ebx,%edx
  105488:	ee                   	out    %al,(%dx)
  105489:	b2 fd                	mov    $0xfd,%dl
  10548b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  10548c:	04 01                	add    $0x1,%al
  10548e:	74 55                	je     1054e5 <uartinit+0xa5>
    return;
  uart = 1;
  105490:	c7 05 0c 80 10 00 01 	movl   $0x1,0x10800c
  105497:	00 00 00 
  10549a:	89 fa                	mov    %edi,%edx
  10549c:	ec                   	in     (%dx),%al
  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  10549d:	89 f2                	mov    %esi,%edx
  10549f:	ec                   	in     (%dx),%al
  1054a0:	bb ac 67 10 00       	mov    $0x1067ac,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  1054a5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1054ac:	e8 ff d7 ff ff       	call   102cb0 <picenable>
  ioapicenable(IRQ_COM1, 0);
  1054b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1054b8:	00 
  1054b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1054c0:	e8 db cc ff ff       	call   1021a0 <ioapicenable>
  1054c5:	b8 78 00 00 00       	mov    $0x78,%eax
  1054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
  1054d0:	0f be c0             	movsbl %al,%eax
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1054d3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
  1054d6:	89 04 24             	mov    %eax,(%esp)
  1054d9:	e8 02 ff ff ff       	call   1053e0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1054de:	0f b6 03             	movzbl (%ebx),%eax
  1054e1:	84 c0                	test   %al,%al
  1054e3:	75 eb                	jne    1054d0 <uartinit+0x90>
    uartputc(*p);
}
  1054e5:	83 c4 0c             	add    $0xc,%esp
  1054e8:	5b                   	pop    %ebx
  1054e9:	5e                   	pop    %esi
  1054ea:	5f                   	pop    %edi
  1054eb:	5d                   	pop    %ebp
  1054ec:	c3                   	ret    
  1054ed:	90                   	nop    
  1054ee:	90                   	nop    
  1054ef:	90                   	nop    

001054f0 <vector0>:
  1054f0:	6a 00                	push   $0x0
  1054f2:	6a 00                	push   $0x0
  1054f4:	e9 57 fb ff ff       	jmp    105050 <alltraps>

001054f9 <vector1>:
  1054f9:	6a 00                	push   $0x0
  1054fb:	6a 01                	push   $0x1
  1054fd:	e9 4e fb ff ff       	jmp    105050 <alltraps>

00105502 <vector2>:
  105502:	6a 00                	push   $0x0
  105504:	6a 02                	push   $0x2
  105506:	e9 45 fb ff ff       	jmp    105050 <alltraps>

0010550b <vector3>:
  10550b:	6a 00                	push   $0x0
  10550d:	6a 03                	push   $0x3
  10550f:	e9 3c fb ff ff       	jmp    105050 <alltraps>

00105514 <vector4>:
  105514:	6a 00                	push   $0x0
  105516:	6a 04                	push   $0x4
  105518:	e9 33 fb ff ff       	jmp    105050 <alltraps>

0010551d <vector5>:
  10551d:	6a 00                	push   $0x0
  10551f:	6a 05                	push   $0x5
  105521:	e9 2a fb ff ff       	jmp    105050 <alltraps>

00105526 <vector6>:
  105526:	6a 00                	push   $0x0
  105528:	6a 06                	push   $0x6
  10552a:	e9 21 fb ff ff       	jmp    105050 <alltraps>

0010552f <vector7>:
  10552f:	6a 00                	push   $0x0
  105531:	6a 07                	push   $0x7
  105533:	e9 18 fb ff ff       	jmp    105050 <alltraps>

00105538 <vector8>:
  105538:	6a 08                	push   $0x8
  10553a:	e9 11 fb ff ff       	jmp    105050 <alltraps>

0010553f <vector9>:
  10553f:	6a 00                	push   $0x0
  105541:	6a 09                	push   $0x9
  105543:	e9 08 fb ff ff       	jmp    105050 <alltraps>

00105548 <vector10>:
  105548:	6a 0a                	push   $0xa
  10554a:	e9 01 fb ff ff       	jmp    105050 <alltraps>

0010554f <vector11>:
  10554f:	6a 0b                	push   $0xb
  105551:	e9 fa fa ff ff       	jmp    105050 <alltraps>

00105556 <vector12>:
  105556:	6a 0c                	push   $0xc
  105558:	e9 f3 fa ff ff       	jmp    105050 <alltraps>

0010555d <vector13>:
  10555d:	6a 0d                	push   $0xd
  10555f:	e9 ec fa ff ff       	jmp    105050 <alltraps>

00105564 <vector14>:
  105564:	6a 0e                	push   $0xe
  105566:	e9 e5 fa ff ff       	jmp    105050 <alltraps>

0010556b <vector15>:
  10556b:	6a 00                	push   $0x0
  10556d:	6a 0f                	push   $0xf
  10556f:	e9 dc fa ff ff       	jmp    105050 <alltraps>

00105574 <vector16>:
  105574:	6a 00                	push   $0x0
  105576:	6a 10                	push   $0x10
  105578:	e9 d3 fa ff ff       	jmp    105050 <alltraps>

0010557d <vector17>:
  10557d:	6a 11                	push   $0x11
  10557f:	e9 cc fa ff ff       	jmp    105050 <alltraps>

00105584 <vector18>:
  105584:	6a 00                	push   $0x0
  105586:	6a 12                	push   $0x12
  105588:	e9 c3 fa ff ff       	jmp    105050 <alltraps>

0010558d <vector19>:
  10558d:	6a 00                	push   $0x0
  10558f:	6a 13                	push   $0x13
  105591:	e9 ba fa ff ff       	jmp    105050 <alltraps>

00105596 <vector20>:
  105596:	6a 00                	push   $0x0
  105598:	6a 14                	push   $0x14
  10559a:	e9 b1 fa ff ff       	jmp    105050 <alltraps>

0010559f <vector21>:
  10559f:	6a 00                	push   $0x0
  1055a1:	6a 15                	push   $0x15
  1055a3:	e9 a8 fa ff ff       	jmp    105050 <alltraps>

001055a8 <vector22>:
  1055a8:	6a 00                	push   $0x0
  1055aa:	6a 16                	push   $0x16
  1055ac:	e9 9f fa ff ff       	jmp    105050 <alltraps>

001055b1 <vector23>:
  1055b1:	6a 00                	push   $0x0
  1055b3:	6a 17                	push   $0x17
  1055b5:	e9 96 fa ff ff       	jmp    105050 <alltraps>

001055ba <vector24>:
  1055ba:	6a 00                	push   $0x0
  1055bc:	6a 18                	push   $0x18
  1055be:	e9 8d fa ff ff       	jmp    105050 <alltraps>

001055c3 <vector25>:
  1055c3:	6a 00                	push   $0x0
  1055c5:	6a 19                	push   $0x19
  1055c7:	e9 84 fa ff ff       	jmp    105050 <alltraps>

001055cc <vector26>:
  1055cc:	6a 00                	push   $0x0
  1055ce:	6a 1a                	push   $0x1a
  1055d0:	e9 7b fa ff ff       	jmp    105050 <alltraps>

001055d5 <vector27>:
  1055d5:	6a 00                	push   $0x0
  1055d7:	6a 1b                	push   $0x1b
  1055d9:	e9 72 fa ff ff       	jmp    105050 <alltraps>

001055de <vector28>:
  1055de:	6a 00                	push   $0x0
  1055e0:	6a 1c                	push   $0x1c
  1055e2:	e9 69 fa ff ff       	jmp    105050 <alltraps>

001055e7 <vector29>:
  1055e7:	6a 00                	push   $0x0
  1055e9:	6a 1d                	push   $0x1d
  1055eb:	e9 60 fa ff ff       	jmp    105050 <alltraps>

001055f0 <vector30>:
  1055f0:	6a 00                	push   $0x0
  1055f2:	6a 1e                	push   $0x1e
  1055f4:	e9 57 fa ff ff       	jmp    105050 <alltraps>

001055f9 <vector31>:
  1055f9:	6a 00                	push   $0x0
  1055fb:	6a 1f                	push   $0x1f
  1055fd:	e9 4e fa ff ff       	jmp    105050 <alltraps>

00105602 <vector32>:
  105602:	6a 00                	push   $0x0
  105604:	6a 20                	push   $0x20
  105606:	e9 45 fa ff ff       	jmp    105050 <alltraps>

0010560b <vector33>:
  10560b:	6a 00                	push   $0x0
  10560d:	6a 21                	push   $0x21
  10560f:	e9 3c fa ff ff       	jmp    105050 <alltraps>

00105614 <vector34>:
  105614:	6a 00                	push   $0x0
  105616:	6a 22                	push   $0x22
  105618:	e9 33 fa ff ff       	jmp    105050 <alltraps>

0010561d <vector35>:
  10561d:	6a 00                	push   $0x0
  10561f:	6a 23                	push   $0x23
  105621:	e9 2a fa ff ff       	jmp    105050 <alltraps>

00105626 <vector36>:
  105626:	6a 00                	push   $0x0
  105628:	6a 24                	push   $0x24
  10562a:	e9 21 fa ff ff       	jmp    105050 <alltraps>

0010562f <vector37>:
  10562f:	6a 00                	push   $0x0
  105631:	6a 25                	push   $0x25
  105633:	e9 18 fa ff ff       	jmp    105050 <alltraps>

00105638 <vector38>:
  105638:	6a 00                	push   $0x0
  10563a:	6a 26                	push   $0x26
  10563c:	e9 0f fa ff ff       	jmp    105050 <alltraps>

00105641 <vector39>:
  105641:	6a 00                	push   $0x0
  105643:	6a 27                	push   $0x27
  105645:	e9 06 fa ff ff       	jmp    105050 <alltraps>

0010564a <vector40>:
  10564a:	6a 00                	push   $0x0
  10564c:	6a 28                	push   $0x28
  10564e:	e9 fd f9 ff ff       	jmp    105050 <alltraps>

00105653 <vector41>:
  105653:	6a 00                	push   $0x0
  105655:	6a 29                	push   $0x29
  105657:	e9 f4 f9 ff ff       	jmp    105050 <alltraps>

0010565c <vector42>:
  10565c:	6a 00                	push   $0x0
  10565e:	6a 2a                	push   $0x2a
  105660:	e9 eb f9 ff ff       	jmp    105050 <alltraps>

00105665 <vector43>:
  105665:	6a 00                	push   $0x0
  105667:	6a 2b                	push   $0x2b
  105669:	e9 e2 f9 ff ff       	jmp    105050 <alltraps>

0010566e <vector44>:
  10566e:	6a 00                	push   $0x0
  105670:	6a 2c                	push   $0x2c
  105672:	e9 d9 f9 ff ff       	jmp    105050 <alltraps>

00105677 <vector45>:
  105677:	6a 00                	push   $0x0
  105679:	6a 2d                	push   $0x2d
  10567b:	e9 d0 f9 ff ff       	jmp    105050 <alltraps>

00105680 <vector46>:
  105680:	6a 00                	push   $0x0
  105682:	6a 2e                	push   $0x2e
  105684:	e9 c7 f9 ff ff       	jmp    105050 <alltraps>

00105689 <vector47>:
  105689:	6a 00                	push   $0x0
  10568b:	6a 2f                	push   $0x2f
  10568d:	e9 be f9 ff ff       	jmp    105050 <alltraps>

00105692 <vector48>:
  105692:	6a 00                	push   $0x0
  105694:	6a 30                	push   $0x30
  105696:	e9 b5 f9 ff ff       	jmp    105050 <alltraps>

0010569b <vector49>:
  10569b:	6a 00                	push   $0x0
  10569d:	6a 31                	push   $0x31
  10569f:	e9 ac f9 ff ff       	jmp    105050 <alltraps>

001056a4 <vector50>:
  1056a4:	6a 00                	push   $0x0
  1056a6:	6a 32                	push   $0x32
  1056a8:	e9 a3 f9 ff ff       	jmp    105050 <alltraps>

001056ad <vector51>:
  1056ad:	6a 00                	push   $0x0
  1056af:	6a 33                	push   $0x33
  1056b1:	e9 9a f9 ff ff       	jmp    105050 <alltraps>

001056b6 <vector52>:
  1056b6:	6a 00                	push   $0x0
  1056b8:	6a 34                	push   $0x34
  1056ba:	e9 91 f9 ff ff       	jmp    105050 <alltraps>

001056bf <vector53>:
  1056bf:	6a 00                	push   $0x0
  1056c1:	6a 35                	push   $0x35
  1056c3:	e9 88 f9 ff ff       	jmp    105050 <alltraps>

001056c8 <vector54>:
  1056c8:	6a 00                	push   $0x0
  1056ca:	6a 36                	push   $0x36
  1056cc:	e9 7f f9 ff ff       	jmp    105050 <alltraps>

001056d1 <vector55>:
  1056d1:	6a 00                	push   $0x0
  1056d3:	6a 37                	push   $0x37
  1056d5:	e9 76 f9 ff ff       	jmp    105050 <alltraps>

001056da <vector56>:
  1056da:	6a 00                	push   $0x0
  1056dc:	6a 38                	push   $0x38
  1056de:	e9 6d f9 ff ff       	jmp    105050 <alltraps>

001056e3 <vector57>:
  1056e3:	6a 00                	push   $0x0
  1056e5:	6a 39                	push   $0x39
  1056e7:	e9 64 f9 ff ff       	jmp    105050 <alltraps>

001056ec <vector58>:
  1056ec:	6a 00                	push   $0x0
  1056ee:	6a 3a                	push   $0x3a
  1056f0:	e9 5b f9 ff ff       	jmp    105050 <alltraps>

001056f5 <vector59>:
  1056f5:	6a 00                	push   $0x0
  1056f7:	6a 3b                	push   $0x3b
  1056f9:	e9 52 f9 ff ff       	jmp    105050 <alltraps>

001056fe <vector60>:
  1056fe:	6a 00                	push   $0x0
  105700:	6a 3c                	push   $0x3c
  105702:	e9 49 f9 ff ff       	jmp    105050 <alltraps>

00105707 <vector61>:
  105707:	6a 00                	push   $0x0
  105709:	6a 3d                	push   $0x3d
  10570b:	e9 40 f9 ff ff       	jmp    105050 <alltraps>

00105710 <vector62>:
  105710:	6a 00                	push   $0x0
  105712:	6a 3e                	push   $0x3e
  105714:	e9 37 f9 ff ff       	jmp    105050 <alltraps>

00105719 <vector63>:
  105719:	6a 00                	push   $0x0
  10571b:	6a 3f                	push   $0x3f
  10571d:	e9 2e f9 ff ff       	jmp    105050 <alltraps>

00105722 <vector64>:
  105722:	6a 00                	push   $0x0
  105724:	6a 40                	push   $0x40
  105726:	e9 25 f9 ff ff       	jmp    105050 <alltraps>

0010572b <vector65>:
  10572b:	6a 00                	push   $0x0
  10572d:	6a 41                	push   $0x41
  10572f:	e9 1c f9 ff ff       	jmp    105050 <alltraps>

00105734 <vector66>:
  105734:	6a 00                	push   $0x0
  105736:	6a 42                	push   $0x42
  105738:	e9 13 f9 ff ff       	jmp    105050 <alltraps>

0010573d <vector67>:
  10573d:	6a 00                	push   $0x0
  10573f:	6a 43                	push   $0x43
  105741:	e9 0a f9 ff ff       	jmp    105050 <alltraps>

00105746 <vector68>:
  105746:	6a 00                	push   $0x0
  105748:	6a 44                	push   $0x44
  10574a:	e9 01 f9 ff ff       	jmp    105050 <alltraps>

0010574f <vector69>:
  10574f:	6a 00                	push   $0x0
  105751:	6a 45                	push   $0x45
  105753:	e9 f8 f8 ff ff       	jmp    105050 <alltraps>

00105758 <vector70>:
  105758:	6a 00                	push   $0x0
  10575a:	6a 46                	push   $0x46
  10575c:	e9 ef f8 ff ff       	jmp    105050 <alltraps>

00105761 <vector71>:
  105761:	6a 00                	push   $0x0
  105763:	6a 47                	push   $0x47
  105765:	e9 e6 f8 ff ff       	jmp    105050 <alltraps>

0010576a <vector72>:
  10576a:	6a 00                	push   $0x0
  10576c:	6a 48                	push   $0x48
  10576e:	e9 dd f8 ff ff       	jmp    105050 <alltraps>

00105773 <vector73>:
  105773:	6a 00                	push   $0x0
  105775:	6a 49                	push   $0x49
  105777:	e9 d4 f8 ff ff       	jmp    105050 <alltraps>

0010577c <vector74>:
  10577c:	6a 00                	push   $0x0
  10577e:	6a 4a                	push   $0x4a
  105780:	e9 cb f8 ff ff       	jmp    105050 <alltraps>

00105785 <vector75>:
  105785:	6a 00                	push   $0x0
  105787:	6a 4b                	push   $0x4b
  105789:	e9 c2 f8 ff ff       	jmp    105050 <alltraps>

0010578e <vector76>:
  10578e:	6a 00                	push   $0x0
  105790:	6a 4c                	push   $0x4c
  105792:	e9 b9 f8 ff ff       	jmp    105050 <alltraps>

00105797 <vector77>:
  105797:	6a 00                	push   $0x0
  105799:	6a 4d                	push   $0x4d
  10579b:	e9 b0 f8 ff ff       	jmp    105050 <alltraps>

001057a0 <vector78>:
  1057a0:	6a 00                	push   $0x0
  1057a2:	6a 4e                	push   $0x4e
  1057a4:	e9 a7 f8 ff ff       	jmp    105050 <alltraps>

001057a9 <vector79>:
  1057a9:	6a 00                	push   $0x0
  1057ab:	6a 4f                	push   $0x4f
  1057ad:	e9 9e f8 ff ff       	jmp    105050 <alltraps>

001057b2 <vector80>:
  1057b2:	6a 00                	push   $0x0
  1057b4:	6a 50                	push   $0x50
  1057b6:	e9 95 f8 ff ff       	jmp    105050 <alltraps>

001057bb <vector81>:
  1057bb:	6a 00                	push   $0x0
  1057bd:	6a 51                	push   $0x51
  1057bf:	e9 8c f8 ff ff       	jmp    105050 <alltraps>

001057c4 <vector82>:
  1057c4:	6a 00                	push   $0x0
  1057c6:	6a 52                	push   $0x52
  1057c8:	e9 83 f8 ff ff       	jmp    105050 <alltraps>

001057cd <vector83>:
  1057cd:	6a 00                	push   $0x0
  1057cf:	6a 53                	push   $0x53
  1057d1:	e9 7a f8 ff ff       	jmp    105050 <alltraps>

001057d6 <vector84>:
  1057d6:	6a 00                	push   $0x0
  1057d8:	6a 54                	push   $0x54
  1057da:	e9 71 f8 ff ff       	jmp    105050 <alltraps>

001057df <vector85>:
  1057df:	6a 00                	push   $0x0
  1057e1:	6a 55                	push   $0x55
  1057e3:	e9 68 f8 ff ff       	jmp    105050 <alltraps>

001057e8 <vector86>:
  1057e8:	6a 00                	push   $0x0
  1057ea:	6a 56                	push   $0x56
  1057ec:	e9 5f f8 ff ff       	jmp    105050 <alltraps>

001057f1 <vector87>:
  1057f1:	6a 00                	push   $0x0
  1057f3:	6a 57                	push   $0x57
  1057f5:	e9 56 f8 ff ff       	jmp    105050 <alltraps>

001057fa <vector88>:
  1057fa:	6a 00                	push   $0x0
  1057fc:	6a 58                	push   $0x58
  1057fe:	e9 4d f8 ff ff       	jmp    105050 <alltraps>

00105803 <vector89>:
  105803:	6a 00                	push   $0x0
  105805:	6a 59                	push   $0x59
  105807:	e9 44 f8 ff ff       	jmp    105050 <alltraps>

0010580c <vector90>:
  10580c:	6a 00                	push   $0x0
  10580e:	6a 5a                	push   $0x5a
  105810:	e9 3b f8 ff ff       	jmp    105050 <alltraps>

00105815 <vector91>:
  105815:	6a 00                	push   $0x0
  105817:	6a 5b                	push   $0x5b
  105819:	e9 32 f8 ff ff       	jmp    105050 <alltraps>

0010581e <vector92>:
  10581e:	6a 00                	push   $0x0
  105820:	6a 5c                	push   $0x5c
  105822:	e9 29 f8 ff ff       	jmp    105050 <alltraps>

00105827 <vector93>:
  105827:	6a 00                	push   $0x0
  105829:	6a 5d                	push   $0x5d
  10582b:	e9 20 f8 ff ff       	jmp    105050 <alltraps>

00105830 <vector94>:
  105830:	6a 00                	push   $0x0
  105832:	6a 5e                	push   $0x5e
  105834:	e9 17 f8 ff ff       	jmp    105050 <alltraps>

00105839 <vector95>:
  105839:	6a 00                	push   $0x0
  10583b:	6a 5f                	push   $0x5f
  10583d:	e9 0e f8 ff ff       	jmp    105050 <alltraps>

00105842 <vector96>:
  105842:	6a 00                	push   $0x0
  105844:	6a 60                	push   $0x60
  105846:	e9 05 f8 ff ff       	jmp    105050 <alltraps>

0010584b <vector97>:
  10584b:	6a 00                	push   $0x0
  10584d:	6a 61                	push   $0x61
  10584f:	e9 fc f7 ff ff       	jmp    105050 <alltraps>

00105854 <vector98>:
  105854:	6a 00                	push   $0x0
  105856:	6a 62                	push   $0x62
  105858:	e9 f3 f7 ff ff       	jmp    105050 <alltraps>

0010585d <vector99>:
  10585d:	6a 00                	push   $0x0
  10585f:	6a 63                	push   $0x63
  105861:	e9 ea f7 ff ff       	jmp    105050 <alltraps>

00105866 <vector100>:
  105866:	6a 00                	push   $0x0
  105868:	6a 64                	push   $0x64
  10586a:	e9 e1 f7 ff ff       	jmp    105050 <alltraps>

0010586f <vector101>:
  10586f:	6a 00                	push   $0x0
  105871:	6a 65                	push   $0x65
  105873:	e9 d8 f7 ff ff       	jmp    105050 <alltraps>

00105878 <vector102>:
  105878:	6a 00                	push   $0x0
  10587a:	6a 66                	push   $0x66
  10587c:	e9 cf f7 ff ff       	jmp    105050 <alltraps>

00105881 <vector103>:
  105881:	6a 00                	push   $0x0
  105883:	6a 67                	push   $0x67
  105885:	e9 c6 f7 ff ff       	jmp    105050 <alltraps>

0010588a <vector104>:
  10588a:	6a 00                	push   $0x0
  10588c:	6a 68                	push   $0x68
  10588e:	e9 bd f7 ff ff       	jmp    105050 <alltraps>

00105893 <vector105>:
  105893:	6a 00                	push   $0x0
  105895:	6a 69                	push   $0x69
  105897:	e9 b4 f7 ff ff       	jmp    105050 <alltraps>

0010589c <vector106>:
  10589c:	6a 00                	push   $0x0
  10589e:	6a 6a                	push   $0x6a
  1058a0:	e9 ab f7 ff ff       	jmp    105050 <alltraps>

001058a5 <vector107>:
  1058a5:	6a 00                	push   $0x0
  1058a7:	6a 6b                	push   $0x6b
  1058a9:	e9 a2 f7 ff ff       	jmp    105050 <alltraps>

001058ae <vector108>:
  1058ae:	6a 00                	push   $0x0
  1058b0:	6a 6c                	push   $0x6c
  1058b2:	e9 99 f7 ff ff       	jmp    105050 <alltraps>

001058b7 <vector109>:
  1058b7:	6a 00                	push   $0x0
  1058b9:	6a 6d                	push   $0x6d
  1058bb:	e9 90 f7 ff ff       	jmp    105050 <alltraps>

001058c0 <vector110>:
  1058c0:	6a 00                	push   $0x0
  1058c2:	6a 6e                	push   $0x6e
  1058c4:	e9 87 f7 ff ff       	jmp    105050 <alltraps>

001058c9 <vector111>:
  1058c9:	6a 00                	push   $0x0
  1058cb:	6a 6f                	push   $0x6f
  1058cd:	e9 7e f7 ff ff       	jmp    105050 <alltraps>

001058d2 <vector112>:
  1058d2:	6a 00                	push   $0x0
  1058d4:	6a 70                	push   $0x70
  1058d6:	e9 75 f7 ff ff       	jmp    105050 <alltraps>

001058db <vector113>:
  1058db:	6a 00                	push   $0x0
  1058dd:	6a 71                	push   $0x71
  1058df:	e9 6c f7 ff ff       	jmp    105050 <alltraps>

001058e4 <vector114>:
  1058e4:	6a 00                	push   $0x0
  1058e6:	6a 72                	push   $0x72
  1058e8:	e9 63 f7 ff ff       	jmp    105050 <alltraps>

001058ed <vector115>:
  1058ed:	6a 00                	push   $0x0
  1058ef:	6a 73                	push   $0x73
  1058f1:	e9 5a f7 ff ff       	jmp    105050 <alltraps>

001058f6 <vector116>:
  1058f6:	6a 00                	push   $0x0
  1058f8:	6a 74                	push   $0x74
  1058fa:	e9 51 f7 ff ff       	jmp    105050 <alltraps>

001058ff <vector117>:
  1058ff:	6a 00                	push   $0x0
  105901:	6a 75                	push   $0x75
  105903:	e9 48 f7 ff ff       	jmp    105050 <alltraps>

00105908 <vector118>:
  105908:	6a 00                	push   $0x0
  10590a:	6a 76                	push   $0x76
  10590c:	e9 3f f7 ff ff       	jmp    105050 <alltraps>

00105911 <vector119>:
  105911:	6a 00                	push   $0x0
  105913:	6a 77                	push   $0x77
  105915:	e9 36 f7 ff ff       	jmp    105050 <alltraps>

0010591a <vector120>:
  10591a:	6a 00                	push   $0x0
  10591c:	6a 78                	push   $0x78
  10591e:	e9 2d f7 ff ff       	jmp    105050 <alltraps>

00105923 <vector121>:
  105923:	6a 00                	push   $0x0
  105925:	6a 79                	push   $0x79
  105927:	e9 24 f7 ff ff       	jmp    105050 <alltraps>

0010592c <vector122>:
  10592c:	6a 00                	push   $0x0
  10592e:	6a 7a                	push   $0x7a
  105930:	e9 1b f7 ff ff       	jmp    105050 <alltraps>

00105935 <vector123>:
  105935:	6a 00                	push   $0x0
  105937:	6a 7b                	push   $0x7b
  105939:	e9 12 f7 ff ff       	jmp    105050 <alltraps>

0010593e <vector124>:
  10593e:	6a 00                	push   $0x0
  105940:	6a 7c                	push   $0x7c
  105942:	e9 09 f7 ff ff       	jmp    105050 <alltraps>

00105947 <vector125>:
  105947:	6a 00                	push   $0x0
  105949:	6a 7d                	push   $0x7d
  10594b:	e9 00 f7 ff ff       	jmp    105050 <alltraps>

00105950 <vector126>:
  105950:	6a 00                	push   $0x0
  105952:	6a 7e                	push   $0x7e
  105954:	e9 f7 f6 ff ff       	jmp    105050 <alltraps>

00105959 <vector127>:
  105959:	6a 00                	push   $0x0
  10595b:	6a 7f                	push   $0x7f
  10595d:	e9 ee f6 ff ff       	jmp    105050 <alltraps>

00105962 <vector128>:
  105962:	6a 00                	push   $0x0
  105964:	68 80 00 00 00       	push   $0x80
  105969:	e9 e2 f6 ff ff       	jmp    105050 <alltraps>

0010596e <vector129>:
  10596e:	6a 00                	push   $0x0
  105970:	68 81 00 00 00       	push   $0x81
  105975:	e9 d6 f6 ff ff       	jmp    105050 <alltraps>

0010597a <vector130>:
  10597a:	6a 00                	push   $0x0
  10597c:	68 82 00 00 00       	push   $0x82
  105981:	e9 ca f6 ff ff       	jmp    105050 <alltraps>

00105986 <vector131>:
  105986:	6a 00                	push   $0x0
  105988:	68 83 00 00 00       	push   $0x83
  10598d:	e9 be f6 ff ff       	jmp    105050 <alltraps>

00105992 <vector132>:
  105992:	6a 00                	push   $0x0
  105994:	68 84 00 00 00       	push   $0x84
  105999:	e9 b2 f6 ff ff       	jmp    105050 <alltraps>

0010599e <vector133>:
  10599e:	6a 00                	push   $0x0
  1059a0:	68 85 00 00 00       	push   $0x85
  1059a5:	e9 a6 f6 ff ff       	jmp    105050 <alltraps>

001059aa <vector134>:
  1059aa:	6a 00                	push   $0x0
  1059ac:	68 86 00 00 00       	push   $0x86
  1059b1:	e9 9a f6 ff ff       	jmp    105050 <alltraps>

001059b6 <vector135>:
  1059b6:	6a 00                	push   $0x0
  1059b8:	68 87 00 00 00       	push   $0x87
  1059bd:	e9 8e f6 ff ff       	jmp    105050 <alltraps>

001059c2 <vector136>:
  1059c2:	6a 00                	push   $0x0
  1059c4:	68 88 00 00 00       	push   $0x88
  1059c9:	e9 82 f6 ff ff       	jmp    105050 <alltraps>

001059ce <vector137>:
  1059ce:	6a 00                	push   $0x0
  1059d0:	68 89 00 00 00       	push   $0x89
  1059d5:	e9 76 f6 ff ff       	jmp    105050 <alltraps>

001059da <vector138>:
  1059da:	6a 00                	push   $0x0
  1059dc:	68 8a 00 00 00       	push   $0x8a
  1059e1:	e9 6a f6 ff ff       	jmp    105050 <alltraps>

001059e6 <vector139>:
  1059e6:	6a 00                	push   $0x0
  1059e8:	68 8b 00 00 00       	push   $0x8b
  1059ed:	e9 5e f6 ff ff       	jmp    105050 <alltraps>

001059f2 <vector140>:
  1059f2:	6a 00                	push   $0x0
  1059f4:	68 8c 00 00 00       	push   $0x8c
  1059f9:	e9 52 f6 ff ff       	jmp    105050 <alltraps>

001059fe <vector141>:
  1059fe:	6a 00                	push   $0x0
  105a00:	68 8d 00 00 00       	push   $0x8d
  105a05:	e9 46 f6 ff ff       	jmp    105050 <alltraps>

00105a0a <vector142>:
  105a0a:	6a 00                	push   $0x0
  105a0c:	68 8e 00 00 00       	push   $0x8e
  105a11:	e9 3a f6 ff ff       	jmp    105050 <alltraps>

00105a16 <vector143>:
  105a16:	6a 00                	push   $0x0
  105a18:	68 8f 00 00 00       	push   $0x8f
  105a1d:	e9 2e f6 ff ff       	jmp    105050 <alltraps>

00105a22 <vector144>:
  105a22:	6a 00                	push   $0x0
  105a24:	68 90 00 00 00       	push   $0x90
  105a29:	e9 22 f6 ff ff       	jmp    105050 <alltraps>

00105a2e <vector145>:
  105a2e:	6a 00                	push   $0x0
  105a30:	68 91 00 00 00       	push   $0x91
  105a35:	e9 16 f6 ff ff       	jmp    105050 <alltraps>

00105a3a <vector146>:
  105a3a:	6a 00                	push   $0x0
  105a3c:	68 92 00 00 00       	push   $0x92
  105a41:	e9 0a f6 ff ff       	jmp    105050 <alltraps>

00105a46 <vector147>:
  105a46:	6a 00                	push   $0x0
  105a48:	68 93 00 00 00       	push   $0x93
  105a4d:	e9 fe f5 ff ff       	jmp    105050 <alltraps>

00105a52 <vector148>:
  105a52:	6a 00                	push   $0x0
  105a54:	68 94 00 00 00       	push   $0x94
  105a59:	e9 f2 f5 ff ff       	jmp    105050 <alltraps>

00105a5e <vector149>:
  105a5e:	6a 00                	push   $0x0
  105a60:	68 95 00 00 00       	push   $0x95
  105a65:	e9 e6 f5 ff ff       	jmp    105050 <alltraps>

00105a6a <vector150>:
  105a6a:	6a 00                	push   $0x0
  105a6c:	68 96 00 00 00       	push   $0x96
  105a71:	e9 da f5 ff ff       	jmp    105050 <alltraps>

00105a76 <vector151>:
  105a76:	6a 00                	push   $0x0
  105a78:	68 97 00 00 00       	push   $0x97
  105a7d:	e9 ce f5 ff ff       	jmp    105050 <alltraps>

00105a82 <vector152>:
  105a82:	6a 00                	push   $0x0
  105a84:	68 98 00 00 00       	push   $0x98
  105a89:	e9 c2 f5 ff ff       	jmp    105050 <alltraps>

00105a8e <vector153>:
  105a8e:	6a 00                	push   $0x0
  105a90:	68 99 00 00 00       	push   $0x99
  105a95:	e9 b6 f5 ff ff       	jmp    105050 <alltraps>

00105a9a <vector154>:
  105a9a:	6a 00                	push   $0x0
  105a9c:	68 9a 00 00 00       	push   $0x9a
  105aa1:	e9 aa f5 ff ff       	jmp    105050 <alltraps>

00105aa6 <vector155>:
  105aa6:	6a 00                	push   $0x0
  105aa8:	68 9b 00 00 00       	push   $0x9b
  105aad:	e9 9e f5 ff ff       	jmp    105050 <alltraps>

00105ab2 <vector156>:
  105ab2:	6a 00                	push   $0x0
  105ab4:	68 9c 00 00 00       	push   $0x9c
  105ab9:	e9 92 f5 ff ff       	jmp    105050 <alltraps>

00105abe <vector157>:
  105abe:	6a 00                	push   $0x0
  105ac0:	68 9d 00 00 00       	push   $0x9d
  105ac5:	e9 86 f5 ff ff       	jmp    105050 <alltraps>

00105aca <vector158>:
  105aca:	6a 00                	push   $0x0
  105acc:	68 9e 00 00 00       	push   $0x9e
  105ad1:	e9 7a f5 ff ff       	jmp    105050 <alltraps>

00105ad6 <vector159>:
  105ad6:	6a 00                	push   $0x0
  105ad8:	68 9f 00 00 00       	push   $0x9f
  105add:	e9 6e f5 ff ff       	jmp    105050 <alltraps>

00105ae2 <vector160>:
  105ae2:	6a 00                	push   $0x0
  105ae4:	68 a0 00 00 00       	push   $0xa0
  105ae9:	e9 62 f5 ff ff       	jmp    105050 <alltraps>

00105aee <vector161>:
  105aee:	6a 00                	push   $0x0
  105af0:	68 a1 00 00 00       	push   $0xa1
  105af5:	e9 56 f5 ff ff       	jmp    105050 <alltraps>

00105afa <vector162>:
  105afa:	6a 00                	push   $0x0
  105afc:	68 a2 00 00 00       	push   $0xa2
  105b01:	e9 4a f5 ff ff       	jmp    105050 <alltraps>

00105b06 <vector163>:
  105b06:	6a 00                	push   $0x0
  105b08:	68 a3 00 00 00       	push   $0xa3
  105b0d:	e9 3e f5 ff ff       	jmp    105050 <alltraps>

00105b12 <vector164>:
  105b12:	6a 00                	push   $0x0
  105b14:	68 a4 00 00 00       	push   $0xa4
  105b19:	e9 32 f5 ff ff       	jmp    105050 <alltraps>

00105b1e <vector165>:
  105b1e:	6a 00                	push   $0x0
  105b20:	68 a5 00 00 00       	push   $0xa5
  105b25:	e9 26 f5 ff ff       	jmp    105050 <alltraps>

00105b2a <vector166>:
  105b2a:	6a 00                	push   $0x0
  105b2c:	68 a6 00 00 00       	push   $0xa6
  105b31:	e9 1a f5 ff ff       	jmp    105050 <alltraps>

00105b36 <vector167>:
  105b36:	6a 00                	push   $0x0
  105b38:	68 a7 00 00 00       	push   $0xa7
  105b3d:	e9 0e f5 ff ff       	jmp    105050 <alltraps>

00105b42 <vector168>:
  105b42:	6a 00                	push   $0x0
  105b44:	68 a8 00 00 00       	push   $0xa8
  105b49:	e9 02 f5 ff ff       	jmp    105050 <alltraps>

00105b4e <vector169>:
  105b4e:	6a 00                	push   $0x0
  105b50:	68 a9 00 00 00       	push   $0xa9
  105b55:	e9 f6 f4 ff ff       	jmp    105050 <alltraps>

00105b5a <vector170>:
  105b5a:	6a 00                	push   $0x0
  105b5c:	68 aa 00 00 00       	push   $0xaa
  105b61:	e9 ea f4 ff ff       	jmp    105050 <alltraps>

00105b66 <vector171>:
  105b66:	6a 00                	push   $0x0
  105b68:	68 ab 00 00 00       	push   $0xab
  105b6d:	e9 de f4 ff ff       	jmp    105050 <alltraps>

00105b72 <vector172>:
  105b72:	6a 00                	push   $0x0
  105b74:	68 ac 00 00 00       	push   $0xac
  105b79:	e9 d2 f4 ff ff       	jmp    105050 <alltraps>

00105b7e <vector173>:
  105b7e:	6a 00                	push   $0x0
  105b80:	68 ad 00 00 00       	push   $0xad
  105b85:	e9 c6 f4 ff ff       	jmp    105050 <alltraps>

00105b8a <vector174>:
  105b8a:	6a 00                	push   $0x0
  105b8c:	68 ae 00 00 00       	push   $0xae
  105b91:	e9 ba f4 ff ff       	jmp    105050 <alltraps>

00105b96 <vector175>:
  105b96:	6a 00                	push   $0x0
  105b98:	68 af 00 00 00       	push   $0xaf
  105b9d:	e9 ae f4 ff ff       	jmp    105050 <alltraps>

00105ba2 <vector176>:
  105ba2:	6a 00                	push   $0x0
  105ba4:	68 b0 00 00 00       	push   $0xb0
  105ba9:	e9 a2 f4 ff ff       	jmp    105050 <alltraps>

00105bae <vector177>:
  105bae:	6a 00                	push   $0x0
  105bb0:	68 b1 00 00 00       	push   $0xb1
  105bb5:	e9 96 f4 ff ff       	jmp    105050 <alltraps>

00105bba <vector178>:
  105bba:	6a 00                	push   $0x0
  105bbc:	68 b2 00 00 00       	push   $0xb2
  105bc1:	e9 8a f4 ff ff       	jmp    105050 <alltraps>

00105bc6 <vector179>:
  105bc6:	6a 00                	push   $0x0
  105bc8:	68 b3 00 00 00       	push   $0xb3
  105bcd:	e9 7e f4 ff ff       	jmp    105050 <alltraps>

00105bd2 <vector180>:
  105bd2:	6a 00                	push   $0x0
  105bd4:	68 b4 00 00 00       	push   $0xb4
  105bd9:	e9 72 f4 ff ff       	jmp    105050 <alltraps>

00105bde <vector181>:
  105bde:	6a 00                	push   $0x0
  105be0:	68 b5 00 00 00       	push   $0xb5
  105be5:	e9 66 f4 ff ff       	jmp    105050 <alltraps>

00105bea <vector182>:
  105bea:	6a 00                	push   $0x0
  105bec:	68 b6 00 00 00       	push   $0xb6
  105bf1:	e9 5a f4 ff ff       	jmp    105050 <alltraps>

00105bf6 <vector183>:
  105bf6:	6a 00                	push   $0x0
  105bf8:	68 b7 00 00 00       	push   $0xb7
  105bfd:	e9 4e f4 ff ff       	jmp    105050 <alltraps>

00105c02 <vector184>:
  105c02:	6a 00                	push   $0x0
  105c04:	68 b8 00 00 00       	push   $0xb8
  105c09:	e9 42 f4 ff ff       	jmp    105050 <alltraps>

00105c0e <vector185>:
  105c0e:	6a 00                	push   $0x0
  105c10:	68 b9 00 00 00       	push   $0xb9
  105c15:	e9 36 f4 ff ff       	jmp    105050 <alltraps>

00105c1a <vector186>:
  105c1a:	6a 00                	push   $0x0
  105c1c:	68 ba 00 00 00       	push   $0xba
  105c21:	e9 2a f4 ff ff       	jmp    105050 <alltraps>

00105c26 <vector187>:
  105c26:	6a 00                	push   $0x0
  105c28:	68 bb 00 00 00       	push   $0xbb
  105c2d:	e9 1e f4 ff ff       	jmp    105050 <alltraps>

00105c32 <vector188>:
  105c32:	6a 00                	push   $0x0
  105c34:	68 bc 00 00 00       	push   $0xbc
  105c39:	e9 12 f4 ff ff       	jmp    105050 <alltraps>

00105c3e <vector189>:
  105c3e:	6a 00                	push   $0x0
  105c40:	68 bd 00 00 00       	push   $0xbd
  105c45:	e9 06 f4 ff ff       	jmp    105050 <alltraps>

00105c4a <vector190>:
  105c4a:	6a 00                	push   $0x0
  105c4c:	68 be 00 00 00       	push   $0xbe
  105c51:	e9 fa f3 ff ff       	jmp    105050 <alltraps>

00105c56 <vector191>:
  105c56:	6a 00                	push   $0x0
  105c58:	68 bf 00 00 00       	push   $0xbf
  105c5d:	e9 ee f3 ff ff       	jmp    105050 <alltraps>

00105c62 <vector192>:
  105c62:	6a 00                	push   $0x0
  105c64:	68 c0 00 00 00       	push   $0xc0
  105c69:	e9 e2 f3 ff ff       	jmp    105050 <alltraps>

00105c6e <vector193>:
  105c6e:	6a 00                	push   $0x0
  105c70:	68 c1 00 00 00       	push   $0xc1
  105c75:	e9 d6 f3 ff ff       	jmp    105050 <alltraps>

00105c7a <vector194>:
  105c7a:	6a 00                	push   $0x0
  105c7c:	68 c2 00 00 00       	push   $0xc2
  105c81:	e9 ca f3 ff ff       	jmp    105050 <alltraps>

00105c86 <vector195>:
  105c86:	6a 00                	push   $0x0
  105c88:	68 c3 00 00 00       	push   $0xc3
  105c8d:	e9 be f3 ff ff       	jmp    105050 <alltraps>

00105c92 <vector196>:
  105c92:	6a 00                	push   $0x0
  105c94:	68 c4 00 00 00       	push   $0xc4
  105c99:	e9 b2 f3 ff ff       	jmp    105050 <alltraps>

00105c9e <vector197>:
  105c9e:	6a 00                	push   $0x0
  105ca0:	68 c5 00 00 00       	push   $0xc5
  105ca5:	e9 a6 f3 ff ff       	jmp    105050 <alltraps>

00105caa <vector198>:
  105caa:	6a 00                	push   $0x0
  105cac:	68 c6 00 00 00       	push   $0xc6
  105cb1:	e9 9a f3 ff ff       	jmp    105050 <alltraps>

00105cb6 <vector199>:
  105cb6:	6a 00                	push   $0x0
  105cb8:	68 c7 00 00 00       	push   $0xc7
  105cbd:	e9 8e f3 ff ff       	jmp    105050 <alltraps>

00105cc2 <vector200>:
  105cc2:	6a 00                	push   $0x0
  105cc4:	68 c8 00 00 00       	push   $0xc8
  105cc9:	e9 82 f3 ff ff       	jmp    105050 <alltraps>

00105cce <vector201>:
  105cce:	6a 00                	push   $0x0
  105cd0:	68 c9 00 00 00       	push   $0xc9
  105cd5:	e9 76 f3 ff ff       	jmp    105050 <alltraps>

00105cda <vector202>:
  105cda:	6a 00                	push   $0x0
  105cdc:	68 ca 00 00 00       	push   $0xca
  105ce1:	e9 6a f3 ff ff       	jmp    105050 <alltraps>

00105ce6 <vector203>:
  105ce6:	6a 00                	push   $0x0
  105ce8:	68 cb 00 00 00       	push   $0xcb
  105ced:	e9 5e f3 ff ff       	jmp    105050 <alltraps>

00105cf2 <vector204>:
  105cf2:	6a 00                	push   $0x0
  105cf4:	68 cc 00 00 00       	push   $0xcc
  105cf9:	e9 52 f3 ff ff       	jmp    105050 <alltraps>

00105cfe <vector205>:
  105cfe:	6a 00                	push   $0x0
  105d00:	68 cd 00 00 00       	push   $0xcd
  105d05:	e9 46 f3 ff ff       	jmp    105050 <alltraps>

00105d0a <vector206>:
  105d0a:	6a 00                	push   $0x0
  105d0c:	68 ce 00 00 00       	push   $0xce
  105d11:	e9 3a f3 ff ff       	jmp    105050 <alltraps>

00105d16 <vector207>:
  105d16:	6a 00                	push   $0x0
  105d18:	68 cf 00 00 00       	push   $0xcf
  105d1d:	e9 2e f3 ff ff       	jmp    105050 <alltraps>

00105d22 <vector208>:
  105d22:	6a 00                	push   $0x0
  105d24:	68 d0 00 00 00       	push   $0xd0
  105d29:	e9 22 f3 ff ff       	jmp    105050 <alltraps>

00105d2e <vector209>:
  105d2e:	6a 00                	push   $0x0
  105d30:	68 d1 00 00 00       	push   $0xd1
  105d35:	e9 16 f3 ff ff       	jmp    105050 <alltraps>

00105d3a <vector210>:
  105d3a:	6a 00                	push   $0x0
  105d3c:	68 d2 00 00 00       	push   $0xd2
  105d41:	e9 0a f3 ff ff       	jmp    105050 <alltraps>

00105d46 <vector211>:
  105d46:	6a 00                	push   $0x0
  105d48:	68 d3 00 00 00       	push   $0xd3
  105d4d:	e9 fe f2 ff ff       	jmp    105050 <alltraps>

00105d52 <vector212>:
  105d52:	6a 00                	push   $0x0
  105d54:	68 d4 00 00 00       	push   $0xd4
  105d59:	e9 f2 f2 ff ff       	jmp    105050 <alltraps>

00105d5e <vector213>:
  105d5e:	6a 00                	push   $0x0
  105d60:	68 d5 00 00 00       	push   $0xd5
  105d65:	e9 e6 f2 ff ff       	jmp    105050 <alltraps>

00105d6a <vector214>:
  105d6a:	6a 00                	push   $0x0
  105d6c:	68 d6 00 00 00       	push   $0xd6
  105d71:	e9 da f2 ff ff       	jmp    105050 <alltraps>

00105d76 <vector215>:
  105d76:	6a 00                	push   $0x0
  105d78:	68 d7 00 00 00       	push   $0xd7
  105d7d:	e9 ce f2 ff ff       	jmp    105050 <alltraps>

00105d82 <vector216>:
  105d82:	6a 00                	push   $0x0
  105d84:	68 d8 00 00 00       	push   $0xd8
  105d89:	e9 c2 f2 ff ff       	jmp    105050 <alltraps>

00105d8e <vector217>:
  105d8e:	6a 00                	push   $0x0
  105d90:	68 d9 00 00 00       	push   $0xd9
  105d95:	e9 b6 f2 ff ff       	jmp    105050 <alltraps>

00105d9a <vector218>:
  105d9a:	6a 00                	push   $0x0
  105d9c:	68 da 00 00 00       	push   $0xda
  105da1:	e9 aa f2 ff ff       	jmp    105050 <alltraps>

00105da6 <vector219>:
  105da6:	6a 00                	push   $0x0
  105da8:	68 db 00 00 00       	push   $0xdb
  105dad:	e9 9e f2 ff ff       	jmp    105050 <alltraps>

00105db2 <vector220>:
  105db2:	6a 00                	push   $0x0
  105db4:	68 dc 00 00 00       	push   $0xdc
  105db9:	e9 92 f2 ff ff       	jmp    105050 <alltraps>

00105dbe <vector221>:
  105dbe:	6a 00                	push   $0x0
  105dc0:	68 dd 00 00 00       	push   $0xdd
  105dc5:	e9 86 f2 ff ff       	jmp    105050 <alltraps>

00105dca <vector222>:
  105dca:	6a 00                	push   $0x0
  105dcc:	68 de 00 00 00       	push   $0xde
  105dd1:	e9 7a f2 ff ff       	jmp    105050 <alltraps>

00105dd6 <vector223>:
  105dd6:	6a 00                	push   $0x0
  105dd8:	68 df 00 00 00       	push   $0xdf
  105ddd:	e9 6e f2 ff ff       	jmp    105050 <alltraps>

00105de2 <vector224>:
  105de2:	6a 00                	push   $0x0
  105de4:	68 e0 00 00 00       	push   $0xe0
  105de9:	e9 62 f2 ff ff       	jmp    105050 <alltraps>

00105dee <vector225>:
  105dee:	6a 00                	push   $0x0
  105df0:	68 e1 00 00 00       	push   $0xe1
  105df5:	e9 56 f2 ff ff       	jmp    105050 <alltraps>

00105dfa <vector226>:
  105dfa:	6a 00                	push   $0x0
  105dfc:	68 e2 00 00 00       	push   $0xe2
  105e01:	e9 4a f2 ff ff       	jmp    105050 <alltraps>

00105e06 <vector227>:
  105e06:	6a 00                	push   $0x0
  105e08:	68 e3 00 00 00       	push   $0xe3
  105e0d:	e9 3e f2 ff ff       	jmp    105050 <alltraps>

00105e12 <vector228>:
  105e12:	6a 00                	push   $0x0
  105e14:	68 e4 00 00 00       	push   $0xe4
  105e19:	e9 32 f2 ff ff       	jmp    105050 <alltraps>

00105e1e <vector229>:
  105e1e:	6a 00                	push   $0x0
  105e20:	68 e5 00 00 00       	push   $0xe5
  105e25:	e9 26 f2 ff ff       	jmp    105050 <alltraps>

00105e2a <vector230>:
  105e2a:	6a 00                	push   $0x0
  105e2c:	68 e6 00 00 00       	push   $0xe6
  105e31:	e9 1a f2 ff ff       	jmp    105050 <alltraps>

00105e36 <vector231>:
  105e36:	6a 00                	push   $0x0
  105e38:	68 e7 00 00 00       	push   $0xe7
  105e3d:	e9 0e f2 ff ff       	jmp    105050 <alltraps>

00105e42 <vector232>:
  105e42:	6a 00                	push   $0x0
  105e44:	68 e8 00 00 00       	push   $0xe8
  105e49:	e9 02 f2 ff ff       	jmp    105050 <alltraps>

00105e4e <vector233>:
  105e4e:	6a 00                	push   $0x0
  105e50:	68 e9 00 00 00       	push   $0xe9
  105e55:	e9 f6 f1 ff ff       	jmp    105050 <alltraps>

00105e5a <vector234>:
  105e5a:	6a 00                	push   $0x0
  105e5c:	68 ea 00 00 00       	push   $0xea
  105e61:	e9 ea f1 ff ff       	jmp    105050 <alltraps>

00105e66 <vector235>:
  105e66:	6a 00                	push   $0x0
  105e68:	68 eb 00 00 00       	push   $0xeb
  105e6d:	e9 de f1 ff ff       	jmp    105050 <alltraps>

00105e72 <vector236>:
  105e72:	6a 00                	push   $0x0
  105e74:	68 ec 00 00 00       	push   $0xec
  105e79:	e9 d2 f1 ff ff       	jmp    105050 <alltraps>

00105e7e <vector237>:
  105e7e:	6a 00                	push   $0x0
  105e80:	68 ed 00 00 00       	push   $0xed
  105e85:	e9 c6 f1 ff ff       	jmp    105050 <alltraps>

00105e8a <vector238>:
  105e8a:	6a 00                	push   $0x0
  105e8c:	68 ee 00 00 00       	push   $0xee
  105e91:	e9 ba f1 ff ff       	jmp    105050 <alltraps>

00105e96 <vector239>:
  105e96:	6a 00                	push   $0x0
  105e98:	68 ef 00 00 00       	push   $0xef
  105e9d:	e9 ae f1 ff ff       	jmp    105050 <alltraps>

00105ea2 <vector240>:
  105ea2:	6a 00                	push   $0x0
  105ea4:	68 f0 00 00 00       	push   $0xf0
  105ea9:	e9 a2 f1 ff ff       	jmp    105050 <alltraps>

00105eae <vector241>:
  105eae:	6a 00                	push   $0x0
  105eb0:	68 f1 00 00 00       	push   $0xf1
  105eb5:	e9 96 f1 ff ff       	jmp    105050 <alltraps>

00105eba <vector242>:
  105eba:	6a 00                	push   $0x0
  105ebc:	68 f2 00 00 00       	push   $0xf2
  105ec1:	e9 8a f1 ff ff       	jmp    105050 <alltraps>

00105ec6 <vector243>:
  105ec6:	6a 00                	push   $0x0
  105ec8:	68 f3 00 00 00       	push   $0xf3
  105ecd:	e9 7e f1 ff ff       	jmp    105050 <alltraps>

00105ed2 <vector244>:
  105ed2:	6a 00                	push   $0x0
  105ed4:	68 f4 00 00 00       	push   $0xf4
  105ed9:	e9 72 f1 ff ff       	jmp    105050 <alltraps>

00105ede <vector245>:
  105ede:	6a 00                	push   $0x0
  105ee0:	68 f5 00 00 00       	push   $0xf5
  105ee5:	e9 66 f1 ff ff       	jmp    105050 <alltraps>

00105eea <vector246>:
  105eea:	6a 00                	push   $0x0
  105eec:	68 f6 00 00 00       	push   $0xf6
  105ef1:	e9 5a f1 ff ff       	jmp    105050 <alltraps>

00105ef6 <vector247>:
  105ef6:	6a 00                	push   $0x0
  105ef8:	68 f7 00 00 00       	push   $0xf7
  105efd:	e9 4e f1 ff ff       	jmp    105050 <alltraps>

00105f02 <vector248>:
  105f02:	6a 00                	push   $0x0
  105f04:	68 f8 00 00 00       	push   $0xf8
  105f09:	e9 42 f1 ff ff       	jmp    105050 <alltraps>

00105f0e <vector249>:
  105f0e:	6a 00                	push   $0x0
  105f10:	68 f9 00 00 00       	push   $0xf9
  105f15:	e9 36 f1 ff ff       	jmp    105050 <alltraps>

00105f1a <vector250>:
  105f1a:	6a 00                	push   $0x0
  105f1c:	68 fa 00 00 00       	push   $0xfa
  105f21:	e9 2a f1 ff ff       	jmp    105050 <alltraps>

00105f26 <vector251>:
  105f26:	6a 00                	push   $0x0
  105f28:	68 fb 00 00 00       	push   $0xfb
  105f2d:	e9 1e f1 ff ff       	jmp    105050 <alltraps>

00105f32 <vector252>:
  105f32:	6a 00                	push   $0x0
  105f34:	68 fc 00 00 00       	push   $0xfc
  105f39:	e9 12 f1 ff ff       	jmp    105050 <alltraps>

00105f3e <vector253>:
  105f3e:	6a 00                	push   $0x0
  105f40:	68 fd 00 00 00       	push   $0xfd
  105f45:	e9 06 f1 ff ff       	jmp    105050 <alltraps>

00105f4a <vector254>:
  105f4a:	6a 00                	push   $0x0
  105f4c:	68 fe 00 00 00       	push   $0xfe
  105f51:	e9 fa f0 ff ff       	jmp    105050 <alltraps>

00105f56 <vector255>:
  105f56:	6a 00                	push   $0x0
  105f58:	68 ff 00 00 00       	push   $0xff
  105f5d:	e9 ee f0 ff ff       	jmp    105050 <alltraps>
