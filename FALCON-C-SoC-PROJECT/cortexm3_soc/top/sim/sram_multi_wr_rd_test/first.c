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
 
    // --- 5 WRITE ---
    // Writing 0x0C0FFEE0 to our 10-bit address in SRAM_A
    for(int i=0; i<5; i++){
        write_addr(target_address, 0x0C0FFEE0 + i); // Fixed letter 'O' to number '0'
        target_address = target_address + 0x0020;
    }
 
    // --- 5 READ ---
    // Reading from that exact same address to verify
    target_address = SRAM_A_base_ADDR + 0x0100;
    for(int q=0; q<5; q++){
        read_value = read_addr(target_address);
        target_address = target_address + 0x0020;
    }
 
    // --- DELAYED WRITE & READ ---
    target_address = SRAM_A_base_ADDR + 0x0300;
    for(int k=0; k<5; k++){                         // Fixed iterator from i++ to k++
        write_addr(target_address, 0x0C0FFEE0 + k); // Fixed letter 'O' to number '0'
        for(long int j=0; j<50; j++);               // Short delay
        read_value = read_addr(target_address);     // Removed the fatal while(1); trap
        target_address = target_address + 0x0020;
    }
 
    // Test end: Signal to the logic analyzer/debugger
    write_addr(debug_reg0, 0x00000007);  
 
    // delay
    for(long int j=0; j<100; j++);
 
    // Safely trap the processor at the end of the test
    while(1);
}