#include "ns.h"

#define PKTMAP		0x10000000


void
output(envid_t ns_envid)
{
  int r;
  envid_t fromenv;
  void *pg  = (void *)PKTMAP;
  struct jif_pkt *packet;

	binaryname = "ns_output";
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver

  while(1) {
    if ((r = ipc_recv(&fromenv, pg, NULL)) != NSREQ_OUTPUT) {
      panic("output.c error: %d", r);
    }
    if (ns_envid != fromenv) {
      panic("output.c didn't receive from right env");
    }
  
    packet = (struct jif_pkt*) pg;
    sys_transmit_packet(packet->jp_data, packet->jp_len);
  }
}
