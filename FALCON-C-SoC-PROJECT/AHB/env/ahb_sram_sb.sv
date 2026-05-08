/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//NAME:-AKASH KUMAR SAHU
//FILE_NAME:-ahb_sram_sb.sv
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef AHB_SRAM_SB_SV
`define AHB_SRAM_SB_SV
typedef bit[9:0] addr_data_type;
class ahb_sram_sb extends uvm_scoreboard;  
  `uvm_component_utils(ahb_sram_sb)
  uvm_analysis_imp #(sram_transaction, ahb_sram_sb) item_collected_imp;
  
  bit [31:0] ref_mem [addr_data_type]; 

  int write_count;
  int read_count;
  int match_count;
  int mismatch_count;

  function new(string name = "ahb_sram_sb", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_imp = new("item_collected_imp", this);
  endfunction

  virtual function void write(sram_transaction tr); 
  `uvm_info("AHB SRAM SCOREBOARD","MONITOR WRITTING TO SBD...",UVM_NONE)
  tr.print();   
    if (tr.SRAMWREN == 1'b1) begin
      // WRITE OPERATION
      ref_mem[tr.SRAMADATA] = tr.SRAMWDATA;
      write_count++;     
      `uvm_info("AHB_SRAM_SB_WRITE", $sformatf("Wrote Data: %0h to Addr: %0h", tr.SRAMWDATA, tr.SRAMADATA), UVM_LOW)
    end else begin
      // READ OPERATION
      read_count++;     
      if (ref_mem.exists(tr.SRAMADATA)) begin           
        if (tr.SRAMRDATA == ref_mem[tr.SRAMADATA]) begin
          match_count++;
          `uvm_info("AHB_SRAM_SB_MATCH", $sformatf("Match at Addr: %0h | Exp: %0h | Act: %0h", tr.SRAMADATA, ref_mem[tr.SRAMADATA], tr.SRAMRDATA), UVM_LOW)
        end else begin
          mismatch_count++;
          `uvm_error("AHB_SRAM_SB_MISMATCH", $sformatf("Mismatch at Addr: %0h | Exp: %0h | Act: %0h", tr.SRAMADATA, ref_mem[tr.SRAMADATA], tr.SRAMRDATA))
        end        
      end else begin
        // for unitialized memory
        `uvm_warning("AHB_SRAM_SB_UNINIT", $sformatf("Read from uninitialized Addr: %0h. Actual Data Returned: %0h", tr.SRAMADATA, tr.SRAMRDATA))
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);    
    `uvm_info("AHB_SRAM_SB_REPORT", "\n=======================================", UVM_NONE)
    `uvm_info("AHB_SRAM_SB_REPORT", "     AHB SRAM SCOREBOARD SUMMARY      ", UVM_NONE)
    `uvm_info("AHB_SRAM_SB_REPORT", "=======================================", UVM_NONE)
    `uvm_info("AHB_SRAM_SB_REPORT", $sformatf(" Total Writes     : %0d", write_count), UVM_NONE)
    `uvm_info("AHB_SRAM_SB_REPORT", $sformatf(" Total Reads      : %0d", read_count), UVM_NONE)
    `uvm_info("AHB_SRAM_SB_REPORT", $sformatf(" Matches   : %0d", match_count), UVM_NONE)    
    if (mismatch_count > 0)
      `uvm_error("AHB_SRAM_SB_REPORT", $sformatf(" Mismatches: %0d\n+++++++++++++++++++++++++++++++++++++++FAIL++++++++++++++++++++++++++++++++++++++", mismatch_count))
    else
      `uvm_info("AHB_SRAM_SB_REPORT", $sformatf(" Mismatches: %0d\n+++++++++++++++++++++++++++++++++++++++PASS+++++++++++++++++++++++++++++++++++++++", mismatch_count), UVM_NONE)      
      `uvm_info("AHB_SRAM_SB_REPORT", "=======================================\n", UVM_NONE)
      
  endfunction

endclass : ahb_sram_sb

`endif
