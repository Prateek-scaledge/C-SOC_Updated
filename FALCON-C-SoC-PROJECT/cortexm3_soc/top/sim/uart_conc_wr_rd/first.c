#include <stdio.h>

typedef unsigned int uint32_t;

#define read_addr(addr)       (*(volatile uint32_t *)(addr))
#define write_addr(addr, val) ((*(volatile uint32_t *)(addr)) = (val))

// SoC and UART Base Addresses
#define UART_BASE         0x40002000
#define DEBUG_REG         (0x00000FF0) // C-SV Handshaking

// UART Register Offsets 
#define UART_DLL          (UART_BASE + 0x00) // Divisor LSB (when DLAB=1)
#define UART_IER          (UART_BASE + 0x04) // Interrupt Enable Register
#define UART_FCR          (UART_BASE + 0x08) // FIFO Control Register
#define UART_LCR          (UART_BASE + 0x0C) // Line Control Register
#define UART_SCR          (UART_BASE + 0x1C) // Scratch Pad Register

int main() {
    uint32_t read_data;
    uint32_t test_pattern = 0xAA;

    // 1. Initial Reset is handled by the Testbench/Hardware
    write_addr(DEBUG_REG, 0x1); // Signal start of Test_021

    // 2. Set registers of UART: Enable DLAB to allow writing to DLL 
    // LCR[7] = 1 (DLAB)
    write_addr(UART_LCR, 0x80);

    // 3 & 4. Concurrent Write/Read in strictly increasing address order
    
    // --- Transaction 1: DLL (Offset 0x00) ---
    write_addr(UART_DLL, test_pattern);
    read_data = read_addr(UART_DLL); // Immediate read back
    
    // --- Transaction 2: IER (Offset 0x04) ---
    // Note: DLAB must be 0 to access IER. We toggle it for this specific register. 
    write_addr(UART_LCR, 0x00); 
    write_addr(UART_IER, 0x07);
    read_data = read_addr(UART_IER); // Immediate read back

    // --- Transaction 3: SCR (Offset 0x1C) ---
    write_addr(UART_SCR, 0x55);
    read_data = read_addr(UART_SCR); // Immediate read back

    // Final verification: Signal test completion to SystemVerilog testbench
    write_addr(DEBUG_REG, 0x7); 

    while(1); // Final loop to prevent further execution
    return 0;
}