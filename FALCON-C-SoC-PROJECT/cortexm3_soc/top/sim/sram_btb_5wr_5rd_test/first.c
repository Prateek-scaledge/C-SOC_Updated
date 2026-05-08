#include<stdio.h>
typedef unsigned int uint32_t;

#define read_addr(addr)        (*(volatile uint32_t*)addr)
#define write_addr(addr, val) ((*(volatile uint32_t*)addr) = (val))

#define SRAM_A_base_ADDR (uint32_t) (0x00000000)
#define debug_reg0 (uint32_t*) (SRAM_A_base_ADDR + 0x0ff0)

int main () 
{ 
    volatile uint32_t read_value = 0;
    uint32_t base_addr = SRAM_A_base_ADDR + 0x0100;  // Start at 0x100
    
    // Test start
    write_addr(debug_reg0, 0x00000001);
    
    // ========== 5 WRITES ==========
    // Write to addresses: 0x100, 0x104, 0x108, 0x10C, 0x110
    for(int i = 0; i < 5; i++){
        uint32_t addr = base_addr + (i * 4);      // Each write 4 bytes apart
        uint32_t data = 0xBADC0DE0 + i;           // Data: 0x0C0FFEE0, 0x0C0FFEE1, etc.
        write_addr(addr, data);
    }
    
    // ========== 5 READS ==========
    // Read from the same addresses
    for(int i = 0; i < 5; i++){
        uint32_t addr = base_addr + (i * 4);
        read_value = read_addr(addr);
    }
		base_addr = SRAM_A_base_ADDR + 0x0200;
      // --- DELAYED WRITE & READ ---
    for(int k=0; k<5; k++){                         // Fixed iterator from i++ to k++
			  uint32_t addr = base_addr + (k * 4); 
			  uint32_t data = 0x0C0FFEE0 + k;
        write_addr(addr, data); // Fixed letter 'O' to number '0'
        for(long int j=0; j<20; j++){}              // Short delay
        read_value = read_addr(addr);     // Removed the fatal while(1); trap
    }
    // Test end
    write_addr(debug_reg0, 0x00000007);
    
    // Small delay
    for(long int j = 0; j < 100; j++);
    
    while(1);
}