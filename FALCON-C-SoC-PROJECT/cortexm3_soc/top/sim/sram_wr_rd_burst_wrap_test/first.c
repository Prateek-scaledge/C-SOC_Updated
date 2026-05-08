#include <stdint.h>

#define read_addr(addr)        (*(volatile uint32_t*)(addr))
#define write_addr(addr, val) ((*(volatile uint32_t*)(addr)) = (val))

#define SRAM_S_base_ADDR (uint32_t) (0x20000000)
#define debug_reg0       (uint32_t*) (0x00000FF0)

int main () 
{ 
    // Test start
    write_addr(debug_reg0, 0x00000001);

    // 1. Define a 16-byte aligned base address (Ends in 0x0)
    uint32_t wrap_base = SRAM_S_base_ADDR + 0x0100; 

    // 2. Start the burst in the middle of the 16-byte boundary (e.g., offset 0x04)
    uint32_t start_offset = 0x04; 

    // --- MIMIC WRAP4 WRITE ---
    for(int i = 0; i < 4; i++){
        // Modulo 16 forces the address to wrap back to 0x00 instead of crossing to 0x10
        uint32_t wrap_offset = (start_offset + (i * 4)) % 16; 
        write_addr(wrap_base + wrap_offset, 0x11110000 + i);
    }
		start_offset = 0x00;
    // --- MIMIC WRAP4 READ ---
    for(int i = 0; i < 4; i++){
        uint32_t wrap_offset = (start_offset + (i * 4)) % 16; 
        read_addr(wrap_base + wrap_offset);
    }

    // Test end
    write_addr(debug_reg0, 0x00000007);  
		for(int i = 0; i < 100; i++){
       
    }
    while(1);
}