#include<stdio.h>
typedef unsigned int uint32_t; 

#define read_addr(addr)        (*(volatile uint32_t*)addr)
#define write_addr(addr, val) ((*(volatile uint32_t*)addr) = (val))
	
// Only using SRAM_A base address
#define SRAM_A_base_ADDR (uint32_t) (0x00000000)

// Debug register remains so your testbench knows when the test starts/ends
#define debug_reg0 (uint32_t*) (SRAM_A_base_ADDR+0x0ff0)

int main () 
{ 
	uint32_t read_value = 0;
	
	// Define a valid 10-bit address inside SRAM_A (Max is 0x3FC for word-aligned)
	// We will use 0x100 (which is 256 in decimal).
	uint32_t target_address = SRAM_A_base_ADDR + 0x0100; 
	
	// Test start: Signal to the logic analyzer/debugger
	write_addr(debug_reg0, 0x00000001);
	
	// --- SINGLE WRITE ---
	// Writing 0xDEADBEEF to our 10-bit address in SRAM_A
	write_addr(target_address, 0x0BAD1DEA);
	
	// --- SINGLE READ ---
	// Reading from that exact same address to verify
	//read_value = read_addr(target_address);
	
	// INITIATE RESET
	write_addr(debug_reg0, 0x00000005);
	while(read_addr(debug_reg0)!=0x00000008)
	{}
		
	//READ AFTER RESET
	read_value = read_addr(target_address);
	// Test end: Signal to the logic analyzer/debugger
	write_addr(debug_reg0, 0x00000007);  

	// delay
	for(long int j=0; j<100; j++);
	
	while(1);
}