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
	uint32_t i,j;
	uint32_t toggle_1=0xaaaaaaaa;
	uint32_t toggle_2=0x55555555;
	
	//Test start
	write_addr(debug_reg0, 0x00000001);
	
	for(i=0;i<16;i+=4){
		for(j=0;j<2;j++){
			if(j==0){
				write_addr((0x2000ff00+i),toggle_1);
				read_addr((0x2000ff00+i));
			}
			else {
				write_addr((0x2000ff00+i),toggle_2);
				read_addr((0x2000ff00+i));
			}
		}
	}
	
	//Test end
	write_addr(debug_reg0, 0x00000007);

  //delay
	for(long int j=0;j<20;j++);  
	
	while(1);
}