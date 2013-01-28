#include "ns.h"
#include "kern/e100.h"

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";

	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	int r;
	//struct jif_pkt* packet = (struct jif_pkt*) UTEMP;

        // Challenge
        // Allocate pages for which the RU can write to
        int curr_buffer = 0;
	struct jif_pkt* packet;
        int *packetidx = 0;
        struct Page *packetpage;
        int pidx;
        for (pidx = 0; pidx < DMA_RU_SIZE; pidx++) {
	  if ((r = sys_page_alloc(sys_getenvid(), UTEMP + (pidx * PGSIZE), PTE_P | PTE_W | PTE_U)) < 0) {
            // sys_page_alloc memsets to zero
	    panic("input: %e", r);
	  }
        }

        // Tell the kernel about the pages that we just made
        if ((r = sys_map_receive_buffers((char *)UTEMP)) < 0) {
          panic("input.c; failed to tell e100 about receive buffers: %e", r);
        }

	while(1) {
          // Keep checking if the current page has any packets
	  struct jif_pkt* packet = (struct jif_pkt*) (UTEMP + (curr_buffer * PGSIZE));
          if ((r = sys_receive_packet_zerocopy(&packet->jp_len)) < 0) {
            sys_yield();
          } else {
	    ipc_send(ns_envid, NSREQ_INPUT, packet, PTE_P | PTE_W | PTE_U);
            curr_buffer = (curr_buffer + 1) % DMA_RU_SIZE;
	  }
	}

        // Pre-challenge
        /*
	while(1) {
	  if ((r = sys_page_alloc(sys_getenvid(), UTEMP, PTE_P | PTE_W | PTE_U)) < 0) {
	    panic("input: %e", r);
	  }
	  if (sys_receive_packet(packet->jp_data, &packet->jp_len) == 0) {
	    ipc_send(ns_envid, NSREQ_INPUT, packet, PTE_P | PTE_W | PTE_U);
	  } else {
	    sys_yield();
	  }
	}
        */
}
