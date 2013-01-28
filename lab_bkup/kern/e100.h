#ifndef JOS_KERN_E100_H

#include <kern/pci.h>
#include <kern/pcireg.h>

#define JOS_KERN_E100_H

// LAB 6:

// Error messages
#define E100_NO_MEM			100

// Needed for attach
#define VENDOR_ID_E100			0x8086
#define DEVICE_ID_E100			0x1209

// Size of CBLs - arbirarily chosen
#define DMA_RU_SIZE			3
#define DMA_CU_MAXCB			128

// Size of packet
#define MAX_PKT_SIZE			1518

// CB statuses
#define CB_STATUS_PROCESSED		0x8000

// CU Commands
// page 46
#define CUC_NOP				0x0
#define CUC_CU_START			0x10
#define CUC_CU_RESUME			0x20
#define CUC_LOAD_DUMP_COUNTERS_ADDR 	0x40
#define CUC_DUMP_STAT_COUNTERS 		0x50
#define CUC_LOAD_CU_BASE 		0x60
#define CUC_DUMP_RESET_STAT_COUNTERS 	0x70
#define CUC_CU_STATIC_RESUME 		0xA0
#define RU_START			0x01

// CSR Addresses
// System control block addresses (base + these numbers)
// page 40
#define SCB_STATUS_OFFSET 		0x0
#define SCB_COMMAND_OFFSET	 	0x2
#define SCB_GENERAL_POINTER_OFFSET	0x4
#define CSR_PORT_OFFSET			0x8

// CU statuses
#define CU_STATUS_IDLE			0
#define CU_STATUS_SUSPENDED		1
#define CU_LPQ_ACTIVE			2
#define CU_HQP_ACTIVE			3

// TCB commands
// page 67
#define TCB_S				0x4000
#define TCB_NOP				0

// Challenge commands
#define TCBCOMMAND_TRANSMIT		0x4
#define TCBCOMMAND_SF			0x8 // flexible mode

// Challenge
struct rbd {
  uint32_t count;
  uint32_t link;
  uint32_t buffer_address;
  uint32_t size;
};
struct tbd {
  uint32_t buffer_address;
  uint32_t buffer_size;
};

// ======

// control block
struct cb {
  volatile uint16_t status;
  uint16_t cmd;
  uint32_t link;
};

// Transmit command block
struct tcb {
  struct cb cb_header;
  uint32_t tbd_array_addr;
  uint16_t tcb_byte_count;
  uint8_t thrs;
  uint8_t tbd_count;
  //char data[MAX_PKT_SIZE];
  // Challenge
  struct tbd tbd;
  struct tbd unused;
};

// receive frame descriptor header
struct rfd_header {
  volatile uint16_t status;
  uint16_t cmd;
  uint32_t link;
};

// receive frame descriptor
struct rfd {
  struct rfd_header header;
  uint32_t reserved;
  uint16_t count_f_eof;
  uint16_t size;
  char data[MAX_PKT_SIZE];
};


// Functions in e100.c
int pci_e100_attach (struct pci_func *pcif);
void sw_reset_e100(uint32_t base);
void init_cbl(void);
void init_rfa(void);
int e100_transmit_packet(char* packet, int pktsize);
int e100_receive_packet(char* packet, int* pktsize);
void e100_transmit_nop(void);
void cu_start(void);
void cu_resume(void);
void ru_start(void);

// Lab 6: Challenge
int e100_map_receive_buffers(char* first_buffer);
int e100_receive_packet_zerocopy(int *size);

#endif	// JOS_KERN_E100_H

