// LAB 6: Your driver code here
#include <inc/x86.h>
#include <inc/assert.h>
#include <inc/string.h>
#include <kern/e100.h>
#include <kern/pci.h>
#include <kern/pcireg.h>
#include <kern/pmap.h>

// Challenge
#include <kern/env.h>

uint32_t *reg_base;
uint32_t *reg_size;
uint8_t  irq_line;
uint32_t iobase;

// DMA CU ring
struct tcb cu_cbl[DMA_CU_MAXCB];
int cbl_to_process;
int cbl_next_free;
struct rfd ru_rfa[DMA_CU_MAXCB];
int rfd_to_process;

// DMA RU ring
struct rfd rfa[DMA_RU_SIZE];

// Challenge
struct rbd rbds[DMA_RU_SIZE];
char*  buffer_zero;

/**
 * Attach the e100 device
 */
int
pci_e100_attach(struct pci_func *pcif)
{
  pci_func_enable(pcif);
  reg_base = pcif->reg_base;
  reg_size = pcif->reg_size;
  irq_line = pcif->irq_line;
  iobase = pcif->reg_base[1];

  // DEBUG: Verify valid iobase:
  // cprintf("hihihi %08x\n", reg_base[1]);
  // outputted reg_base[1]: 0000c040

  sw_reset_e100(iobase);

  init_cbl();
  e100_transmit_nop();
  cu_start(); // only start once, because must determine that all previously blocks were completed...too consuming.

  // Challenge: start these later
  //init_rfa();
  //ru_start();

  return 1;
}

/**
 * Initiates a reset of the device
 */
void sw_reset_e100(uint32_t base) {
  outl(base + CSR_PORT_OFFSET, 0x00000000); // write to the port

  // delay for 10us
  // see Intel manual 6.3.3.1
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
}



/**
 * Builds the CBL
 */
void init_cbl(void) {
  int tidx;
  int neighbor = 0;

  cbl_to_process = 0;
  cbl_next_free = 0;

  // clear all the memory
  memset(&cu_cbl, 0, DMA_CU_MAXCB * sizeof(struct tcb));

  // loop through array and set the links
  for (tidx = 0; tidx<DMA_CU_MAXCB; tidx++) {
    if (tidx == 0) {
      neighbor = DMA_CU_MAXCB - 1;
    } else {
      neighbor = tidx - 1;
    }
    cu_cbl[neighbor].cb_header.link = PADDR((uint32_t) &cu_cbl[tidx]);
    cu_cbl[tidx].cb_header.status = CB_STATUS_PROCESSED;

    // These values are always fixed for our purposes.  See page 92 of manual.
    // http://pdos.csail.mit.edu/6.828/2009/readings/8255X_OpenSDM.pdf
    cu_cbl[tidx].cb_header.cmd = 0; // change to 4 when ready to transmit
    //cu_cbl[tidx].tbd_array_addr = 0xFFFFFFFF;
    //cu_cbl[tidx].tbd_count = 0;
    cu_cbl[tidx].thrs = 0xE0;

    // Challenge
    cu_cbl[tidx].tbd_array_addr = PADDR(&cu_cbl[tidx].tbd);
    cu_cbl[tidx].tbd_count = 1; // 1:1 mapping
  }
}

/**
 * Builds the RFA
 */
void init_rfa(void) {
  int tidx;
  int neighbor = 0;

  rfd_to_process = 0;
  //cbl_to_process = 0;
  //cbl_next_free = 0;

  // clear all the memory
  memset(&ru_rfa, 0, DMA_RU_SIZE * sizeof(struct rfd));

  // Challenge
  memset(rbds, 0, DMA_RU_SIZE * sizeof(struct rbd));

  // loop through array and set the links
  for (tidx = 0; tidx<DMA_RU_SIZE; tidx++) {
    //cprintf("********* dma item: %d\n", tidx);
    if (tidx == 0) {
      neighbor = DMA_RU_SIZE - 1;
    } else {
      neighbor = tidx - 1;
    }
    ru_rfa[neighbor].header.link = PADDR((uint32_t) &ru_rfa[tidx]);
    //ru_rfa[tidx].size = 1518;

    // Challenge
    ru_rfa[tidx].size = 0;
    ru_rfa[tidx].header.cmd |= TCBCOMMAND_SF;
    ru_rfa[tidx].reserved = PADDR(&rbds[tidx]);
    rbds[tidx].count = MAX_PKT_SIZE;
    rbds[tidx].link = PADDR(&rbds[(tidx+1)%DMA_RU_SIZE]);
    rbds[tidx].size = MAX_PKT_SIZE;

    struct Page *buffer_page = page_lookup(curenv->env_pgdir, buffer_zero + (tidx * PGSIZE), NULL);
    rbds[tidx].buffer_address = page2pa(buffer_page) + sizeof(int);
    //ru_rfa[tidx].header.cmd = 0x8000;
    //ru_rfa[tidx].reserved = 0xffffffff;
    //ru_rfa[tidx].header.status = CB_STATUS_PROCESSED;

    // These values are always fixed for our purposes.  See page 92 of manual.
    // http://pdos.csail.mit.edu/6.828/2009/readings/8255X_OpenSDM.pdf
    //cu_cbl[tidx].cb_header.cmd = 0; // change to 4 when ready to transmit
    //cu_cbl[tidx].tbd_array_addr = 0xFFFFFFFF;
    //cu_cbl[tidx].tbd_count = 0;
    //cu_cbl[tidx].thrs = 0xE0;

  }
}

void e100_transmit_nop(void) {
  // Set a NOP
  cprintf("nop at cbl index: %08x\n", cbl_next_free);
  cu_cbl[cbl_next_free].cb_header.status = 0;
  cu_cbl[cbl_next_free].cb_header.cmd = TCB_NOP | TCB_S;
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB; // should be = 1
  cprintf("cbl_to_process now moved to: %08x\n", cbl_next_free);
}

/**
 * Transmit a packet
Modify this for the zero-copy write challenge question.  No longer perform a memmove, and instead just shove in the buffer.
 */
int e100_transmit_packet(char* packet, int pktsize) {
  int tcb_empty;
  char scb_issued;
  int cbl_prev = cbl_next_free;

  // Step 0: Move the 'head' to the next unprocessed packet
  int start = cbl_to_process;
  struct Page *page_to_free;
  while ((cu_cbl[cbl_to_process].cb_header.status == CB_STATUS_PROCESSED) && (cbl_to_process != cbl_next_free)) {

    // Challenge: free pages that you see have completed
    // Don't free here.  sys_ipc_ allocated it.
    //page_to_free = pa2page(cu_cbl[cbl_to_process].tbd_array_addr[cbl_to_process].buffer_address);
    //sys_page_unmap(&page_to_free);

    // shift the cbl_to_process index
    cbl_to_process = (cbl_to_process + 1) % DMA_CU_MAXCB;
    if (cbl_to_process == start) {
      // back to where we started.
      // everything is empty, so leave pointer
      // where it was.
      break;
    }
  }
  cprintf("transmit at cbl index: %08x\n", cbl_next_free);

  // Step 1: 
  // Check if there is room to copy in the packet 
  if (!(cu_cbl[cbl_next_free].cb_header.status & CB_STATUS_PROCESSED)) {
    // no memory because you've circled back on the DMA ring
    return -E100_NO_MEM;
  }

  cprintf("prior to writing memory");

  // Step 2:
  // Write the next TCB
  cu_cbl[cbl_next_free].cb_header.status = 0; // reset the CB's status
  //cu_cbl[cbl_next_free].cb_header.cmd = 0x4 | TCB_S; // transmit
  //cu_cbl[cbl_next_free].tcb_byte_count = pktsize;
  //memmove((void *)cu_cbl[cbl_next_free].data, (void *)packet, pktsize);

  // Challenge:
  cu_cbl[cbl_next_free].tcb_byte_count = 0;
  cu_cbl[cbl_next_free].cb_header.cmd = TCBCOMMAND_TRANSMIT | TCB_S | TCBCOMMAND_SF;
  cu_cbl[cbl_next_free].tbd.buffer_address = page2pa(page_lookup(curenv->env_pgdir, (void *)packet, 0)) + sizeof(int); // plus sizeof(int) because u need to avoid the packet size at the front
  cu_cbl[cbl_next_free].tbd.buffer_size = pktsize;

  // Step 3:
  // Set the suspend bit
  // Done in previous step
  //cu_cbl[cbl_next_free].cb_header.cmd |= TCB_S;
  
  // Step 4:
  // Clear the suspend bit of the TCB in the list (no longer last)
  if (cbl_next_free == 0) cbl_prev = DMA_CU_MAXCB - 1;
  else {
    cbl_prev = cbl_next_free - 1;
  }
  cprintf("cbl_prev: %08x", cbl_prev);
  cu_cbl[cbl_prev].cb_header.cmd &= ~TCB_S;

  // Move the next_free index
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB;

  cu_resume();
  //cu_start();
  return 0;
}


/*
int e100_transmit_packet(char* packet, int pktsize) {
  int tcb_empty;
  char scb_issued;
  int cbl_prev = cbl_next_free;

  // Step 0: Move the 'head' to the next unprocessed packet
  int start = cbl_to_process;
  while ((cu_cbl[cbl_to_process].cb_header.status == CB_STATUS_PROCESSED) && (cbl_to_process != cbl_next_free)) {
    // shift the cbl_to_process index
    cbl_to_process = (cbl_to_process + 1) % DMA_CU_MAXCB;
    if (cbl_to_process == start) {
      // back to where we started.
      // everything is empty, so leave pointer
      // where it was.
      break;
    }
  }
  cprintf("transmit at cbl index: %08x\n", cbl_next_free);

  // Step 1: 
  // Check if there is room to copy in the packet 
  if (!(cu_cbl[cbl_next_free].cb_header.status & CB_STATUS_PROCESSED)) {
    // no memory because you've circled back on the DMA ring
    return -E100_NO_MEM;
  }

  cprintf("prior to writing memory");

  // Step 2:
  // Write the next TCB
  cu_cbl[cbl_next_free].cb_header.status = 0; // reset the CB's status
  cu_cbl[cbl_next_free].cb_header.cmd = 0x4 | TCB_S; // transmit
  cu_cbl[cbl_next_free].tcb_byte_count = pktsize;
  memmove((void *)cu_cbl[cbl_next_free].data, (void *)packet, pktsize);

  // Link the previous TCB to this one if the head is not equal to this
  //if (cbl_to_process != cbl_next_free) {
  //  if (cbl_next_free == 0) cbl_prev = DMA_CU_MAXCB - 1;
  //  else {
  //    cbl_prev = cbl_next_free - 1;
  //  }
  //  cprintf("SET LINK: %08x\n", PADDR((uint32_t)&cu_cbl[cbl_next_free]));
  //  cu_cbl[cbl_prev].cb_header.link = PADDR((uint32_t)&cu_cbl[cbl_next_free]);
  //}
  //cprintf("cbl_to_process %08x\n", cbl_to_process);
  //cprintf("cbl_next_free %08x\n", cbl_next_free);
  //cprintf("cbl_to_process link: %08x\n", cu_cbl[cbl_next_free].cb_header.link);

  // Step 3:
  // Set the suspend bit
  cu_cbl[cbl_next_free].cb_header.cmd |= TCB_S;
  
  // Step 4:
  // Clear the suspend bit of the TCB in the list (no longer last)
  if (cbl_next_free == 0) cbl_prev = DMA_CU_MAXCB - 1;
  else {
    cbl_prev = cbl_next_free - 1;
  }
  cprintf("cbl_prev: %08x", cbl_prev);
  cu_cbl[cbl_prev].cb_header.cmd &= ~TCB_S;

  // Move the next_free index
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB;

  cu_resume();
  //cu_start();
  return 0;
}
*/

/**
 * Start the CU.  Only do this if the CU is
 * idle or suspended
 */
void cu_start(void) {
  cprintf("Entering start CU\n");
  char cu_status;
  char scb_issued;

  // Start the CU if it's idle
  cu_status = inb(iobase + SCB_STATUS_OFFSET);

  // Step 4:
  // Restart CU if idle or suspended
  // Page 46, must do this check
  if ((cu_status>>4 == CU_STATUS_IDLE) || (cu_status>>4 == CU_STATUS_SUSPENDED)) {
    cprintf("Starting CU...\n");

    outl(iobase + SCB_GENERAL_POINTER_OFFSET, PADDR(&cu_cbl[cbl_to_process]));
    outb(iobase + SCB_COMMAND_OFFSET, CUC_CU_START);

    // wait until command goes through, pg. 45
    // The Command byte is cleared by the 8255x indicating command acceptance.
    do {
      scb_issued = inb(iobase + SCB_COMMAND_OFFSET);
    } while (scb_issued != 0);

    cprintf("CU Started.\n");
  }

}

void ru_start(void) {
  outl(iobase + SCB_GENERAL_POINTER_OFFSET, PADDR(&ru_rfa[rfd_to_process]));
  outb(iobase + SCB_COMMAND_OFFSET, RU_START);
}

/**
 * Resume the CU, since it goes inactive after completing each operation.
 */
void cu_resume(void) {
  char cu_status;
  char scb_issued;

  // Start the CU if it's idle
  cu_status = inb(iobase + SCB_STATUS_OFFSET);

  cprintf("Resuming CU...\n");
  outb(iobase + SCB_COMMAND_OFFSET, CUC_CU_RESUME);

  // wait until command goes through, pg. 45
  // The Command byte is cleared by the 8255x indicating command acceptance.
  do {
    scb_issued = inb(iobase + SCB_COMMAND_OFFSET);
  } while (scb_issued != 0);

  cprintf("CU resumed.\n");
}

int
e100_receive_packet_zerocopy(int* size) {
  if (ru_rfa[rfd_to_process].header.status & CB_STATUS_PROCESSED) {
    //struct jif_pkt* packet;
    //packet = (struct jif_pkt*) (&buffer_zero + (rfd_to_process * PGSIZE));
    *size = rbds[rfd_to_process].count & 0x3fff;
    //*(int *)(&buffer_zero + (rfd_to_process * PGSIZE)) = size;
    ru_rfa[rfd_to_process].header.status = 0;
    rfd_to_process = (rfd_to_process + 1) % DMA_RU_SIZE;
    return 0;
  }
  return -1;
}

int
e100_receive_packet(char *packet, int *size) {

  uint32_t packet_paddr;
  void *packet_obj;

  if (ru_rfa[rfd_to_process].header.status & CB_STATUS_PROCESSED) {
    *size = ru_rfa[rfd_to_process].count_f_eof & 0x3fff;
    memmove(packet, ru_rfa[rfd_to_process].data, *size);

    // Challenge
    // We want the equivalent of:
    //memmove(packet, KADDR(rbds[rfd_to_process].buffer_address), *size);
    // Turns out, very hard to do in exo kernel.
    ru_rfa[rfd_to_process].header.status = 0;
    rfd_to_process = (rfd_to_process + 1) % DMA_RU_SIZE;
    return 0;
  }
  return -1;
}

int
e100_map_receive_buffers(char *first_buffer) {
  buffer_zero = first_buffer;
  init_rfa();
  ru_start();
  return 0;
}

