#include <stdint.h>

#define read_addr(addr)       (*(volatile uint32_t *)addr)
#define write_addr(addr, val) ((*(volatile uint32_t *)addr) = (val))

#define SRAM_A_base_ADDR (uint32_t)(0x00000000)
#define debug_reg0       (uint32_t *)(SRAM_A_base_ADDR + 0x0FF0)

// Word-Aligned UART Offsets (Spaced by 0x04)
#define UART_BASE 0x40002000
#define UART_THR  (UART_BASE + 0x00) // Transmit Holding
#define UART_DLL  (UART_BASE + 0x00) // Divisor Latch LSB
#define UART_DLM  (UART_BASE + 0x04) // Divisor Latch MSB
#define UART_FCR  (UART_BASE + 0x08) // FIFO Control
#define UART_LCR  (UART_BASE + 0x0C) // Line Control
#define UART_MCR  (UART_BASE + 0x10) // Modem Control
#define UART_LSR  (UART_BASE + 0x14) // Line Status

int main () 
{ 
    uint32_t lsr_status;

    // Test start
    write_addr(debug_reg0, 0x00000001);
 
    // 1. Correct Initialization (DLAB = Bit 7)
    write_addr(UART_LCR, 0x00000080); // Enable DLAB
    write_addr(UART_DLM, 0x00000000); 
    write_addr(UART_DLL, 0x00000007); 
    write_addr(UART_LCR, 0x00000003); // Disable DLAB, Set 8-bit word

    // 2. Enable FIFOs (Bit 0) and Clear TX/RX FIFOs (Bits 1 & 2)
    write_addr(UART_FCR, 0x00000007); 

    // 3. Enable Internal Loopback (Bit 4 of MCR)
    write_addr(UART_MCR, 0x00000010);

    // 4. Force the Overflow (Write 18 bytes to a 16-byte FIFO)
    for(int j = 0; j < 18; j++) {
        write_addr(UART_THR, 0xAA); 
    }
    
    // 5. Hardware Delay
    for(volatile int i = 0; i < 500; i++);
    
    // 6. Verification: Check the Line Status Register
    lsr_status = read_addr(UART_LSR);

    // Check Overrun Error (OE) flag (Bit 1)
    if ((lsr_status & 0x02) == 0x02) {
        // OVERFLOW DETECTED
        write_addr(debug_reg0, 0x00000007); 
    } else {
        // OVERFLOW MISSED
        write_addr(debug_reg0, 0x0000000E); 
    }
		for(int i=0;i<20;i++){
		}
    // Safe trap
    while(1);
}