package apb_defines_pkg;
	 
	 //Enum that indicates the transaction type

   typedef enum bit {READ,WRITE} trans_kind_e;
   typedef enum bit[2:0]{IDLEE,START,DATA,PARITY,STOP} state;

//---------------------------------------------------------- LCR CONFIGURATION ----------------------------------------------------------------------
  
    //word length select   00 = 5 bit  01 = 6 bit 10 = 7 bit 11 = 8 bit 
    typedef enum int {FIVE_BIT,SIX_BIT,SEVEN_BIT,EIGHT_BIT}word_length;

    //stop bit   1 = 2 stop bit and if this bit is 0 = 1 stop bit

    typedef enum bit{ONE_STOP_BIT,TWO_STOP_BIT} stop_bit;

    typedef enum bit {MSB_2_LSB,LSB_2_MSB} shifting;

    typedef enum bit{ONE_START_BIT,TWO_START_BIT} start_bit;
    //parity bit disable this bit is 1 = parity on and 0 =  off
    typedef enum bit {PARITY_DISABLE,PARITY_ENABLE} parity;
    

    //EVEN OR ODD PAITY if this bit is 1 = even parity and 0 means odd 
    //but this applicable only if parity is enable a stick parity is off when LCR's
    //5th bit low and it's    on when it 5th bit 1 but this is true only when parity bit is enable which is LCR's 3rd bit
    typedef enum bit {EVEN_PARITY,ODD_PARITY} parity_types;


    //DLAB Disable so we can Acess RBR THR IER if this bit is 1 means DLL we have which is important is baud rate
    typedef enum bit {SET_REG,SET_BAUD_RATE} dlab_bit;

//-------------------------------------------------------------------------------------------------------------------------------------------------------


//---------------------------------------------------------- LSR CONFIGURATION ---------------------------------------------------------------------------
    
    // LSR 0th bit 0 menas reciever buffer is empty and this bit is 1 means that reciever buffer is full this request to please read 
    typedef enum bit {RBR_BUFFER_NOT_EMPTY,RBR_BUFFER_EMPTY} rbr_buffer;
  
    // it check  transmiton holding register is empty or not if yes then 
    // intrupt will be generated and that will be given by making LSR's 6th bit 1 and IER's appropiate bit enable
    // Monitoring purpose please set according whenever it need
    typedef enum bit {THR_BUFFER_NOT_EMPTY,THR_BUFFER_EMPTY} thr_buffer;
    
    // 0 over run is never detected if this bit is 1 than over run error can occure
    // when rx buffer is full still data not read and it is override from shift register
    typedef enum bit {NO_OVER_RUN_ERROR,OVER_RUN_ERROR_OCCURE} is_over_run_error;


    // if this bit is 1 than and if parity calculation if error occure than this will generate intrupt if IER respective bit 1 if. 
    typedef enum bit {NO_PARITY_ERROR_OCCURE,PARITY_ERROR_OCCURE} is_parity_error;
 

    typedef enum bit {NO_FRAMING_ERROR,FRAMING_ERROR_OCCURE} is_framing_error;
    typedef enum bit {NO_BREAK_ERROR,BREAK_ERROR_OCCURE} is_break_error;
    typedef enum bit {ANY_BUFFER_HAVE_DATA,BOTH_BUFFER_EMPTY} rx_tx_data_available;
    typedef enum bit {NO_ERROR_OCCURE,ERROR_OCCURE} any_error;

//---------------------------------------------------------------------------------------------------------------------------------------------------------
    


//---------------------------------------------------------- IER CONFIGURATION ------------------------------------------------------------------------------
    //if this bit is 1 only if when RBR reg is FULL. after that intrupt has to be generate that will indicate system to read data.
    //if this bit is not set than intrupt will not be generate
    typedef enum bit {NO_INTRUPT_FOR_RBR,INTRUPT_FOR_RBR} intrupt_for_rbr;
        
    //if this bit is 1 than  if thr reg is empty than intrupt generate that will indicate system
    //to fill next data. if this bit is not set than intrupt will not be generate
    typedef enum bit {NO_INTRUPT_FOR_THR,INTRUPT_FOR_THR} intrupt_for_thr;
   

    // ELSI bit of ier it will enable or disble lsr's error intrupts //LSR error like parity,framing,break. if this error is 
    // generated. then error intrupt will be only generated when this elsi bit   set 
    typedef enum bit {LSR_ERROR_INTRUPT_ENABLE,LSR_ERROR_INTRUPT_ISABLE} lsr_error_intrupt;  
 //----------------------------------------------------------------------------------------------------------------------------------------------------------


    
//---------------------------------------------------------------- FCR CONFIG -------------------------------------------------------------------------------
  typedef enum bit {FIFO_MODE_ON,FIFO_MODE_OFF} fifo_mode;
  
  

   typedef enum bit[2:0] {WRITE_OF,WRITE_ON,READ_ON,READ_OF,SIM_WR}write_read;

endpackage
