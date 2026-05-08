/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  NAME      :- Pradip Prajapati
//  FILE_NAME :- ahb_mas_trans.sv
//  EDITED_BY :- Rajvi Padaria
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

class sram_transaction extends uvm_sequence_item;
  bit[9:0]  SRAMADATA;
  bit[31:0] SRAMWDATA;
  bit[31:0] SRAMRDATA;
  bit       SRAMWREN;
  
  `uvm_object_utils_begin(sram_transaction)
  `uvm_field_int(SRAMADATA,UVM_HEX)
  `uvm_field_int(SRAMWDATA,UVM_HEX)
  `uvm_field_int(SRAMRDATA,UVM_HEX)
  `uvm_field_int(SRAMWREN,UVM_BIN)
  `uvm_object_utils_end
 
  

  function new(string name = "sram_transaction");
    super.new(name);
  endfunction

endclass
