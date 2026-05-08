#include <stdio.h>

typedef unsigned int uint32_t;

#define read_addr(addr)       (*(volatile uint32_t *)(addr))
#define write_addr(addr, val) ((*(volatile uint32_t *)(addr)) = (val))

// SoC Specific Addresses [cite: 1351, 1373]
#define UART_BASE         0x40002000
#define SRAM_S_BASE       0x20000000
#define DEBUG_REG         (0x00000FF0) // C-SV Handshaking

// UART Registers 
#define UART_RBR          (UART_BASE + 0x00)
#define UART_THR          (UART_BASE + 0x00)
#define UART_IER          (UART_BASE + 0x04)
#define UART_FCR          (UART_BASE + 0x08)
#define UART_LCR          (UART_BASE + 0x0C)
#define UART_SCR          (UART_BASE + 0x1C)
#define UART_PWREMU_MGMT  (UART_BASE + 0x30) // Power & Emulation Management

// State tracking in SRAM to survive reset reboot
#define TEST_STATE        (uint32_t *)(SRAM_S_BASE + 0x10)

int main() {
    uint32_t val;

    // 1. Generate clk and initial reset (Handled by Testbench/Hardware)
    if (read_addr(TEST_STATE) != 0xABCD1234) {
        
        // --- PRE-RESET PHASE ---
        write_addr(DEBUG_REG, 0x1); // Signal test start

        // Configure UART: Enable FIFOs and set TX/RX trigger levels [cite: 160]
        // FCR: Bit 0=FIFO Enable, Bits 6-7=RX Trigger Level [cite: 526]
        write_addr(UART_FCR, 0x07); 

        // 2. Generate write transfers
        // Writing to Scratchpad (SCR) and IER to verify reset clears them 
        write_addr(UART_SCR, 0x55);
        write_addr(UART_IER, 0x07);

        // 3. Generate read transfers to verify initial writes
        val = read_addr(UART_SCR);
        val = read_addr(UART_IER);

        // 4. Apply Reset via PWREMU_MGMT 
        // UTRST (Bit 13) controls the UART reset state. 
        // Setting it to 0 places UART in reset; setting to 1 takes it out.
        // Taking it out of reset triggers a UTXEVT to the DMA.
        write_addr(UART_PWREMU_MGMT, 0x0000); // Put UART in reset
        
        // Update state and signal TB if hardware-level reset is needed
        write_addr(TEST_STATE, 0xABCD1234);
        write_addr(DEBUG_REG, 0x2); // Trigger TB Hardware Reset
        
        while(1); // Wait for reset
    } else {
        
        // --- POST-RESET PHASE ---
        // 5. Generate read transfers to verify reset defaults
        // After reset, registers like SCR and IER should return to default (0x0)
        uint32_t post_scr = read_addr(UART_SCR);
        uint32_t post_ier = read_addr(UART_IER);

        // Take UART out of reset to trigger DMA UTXEVT 
        write_addr(UART_PWREMU_MGMT, 0x2000); // Set UTRST bit to 1

        // Final status check
        if (post_scr == 0 && post_ier == 0) {
            write_addr(DEBUG_REG, 0x7); // Test Passed
        } else {
            write_addr(DEBUG_REG, 0xE); // Test Failed
        }
        
        while(1);
    }
    return 0;
}