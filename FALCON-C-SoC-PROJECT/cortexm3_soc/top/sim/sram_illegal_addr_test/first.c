#include<stdio.h>
typedef unsigned int uint32_t; 

//#define CPU_ID_REG_ADDR (uint32_t *) (0xE000ED00)
//#define GPIO_1 *((uint32_t *) (0x20000ff0))

#define read_addr(addr)       (*(volatile uint32_t *)addr)
#define write_addr(addr, val) ((*(volatile uint32_t *)addr) = (val))
	
#define SRAM_A_base_ADDR (uint32_t) (0x00000000)           //0001FFFF
#define SRAM_S_base_ADDR (uint32_t) (0x20000000)           //2000FFFF

#define debug_reg0 (uint32_t *) (SRAM_A_base_ADDR+0x0ff0)
#define debug_reg1 (uint32_t *) (SRAM_A_base_ADDR+0x0ff4)
#define debug_reg2 (uint32_t *) (SRAM_A_base_ADDR+0x0ff8)
#define debug_reg3 (uint32_t *) (SRAM_A_base_ADDR+0x0ffC)

int main () 
{ 
	uint32_t i;
	
	//Test start
	write_addr(debug_reg0, 0x00000001);
	
	for(i=0;i<16;i+=4){
		write_addr((0x2001fffa+i),(0x0babeee0+i));
		read_addr((0x2001fffa+i));
	}
	
	//Test end
	write_addr(debug_reg0, 0x00000007);

  //delay
	for(long int j=0;j<20;j++);  
	
	while(1);
}