/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  NAME      :- Pradip Prajapati
//  FILE_NAME :- AHB_master_monitor.sv
//  EDITED_BY :- Pradip Prajapati
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef SRAMS_MONITOR
`define SRAMS_MONITOR

class sram_monitor extends uvm_monitor;
 
  /** factory registration */
  `uvm_component_utils(sram_monitor)
  
  /** virtual interface handle */
  virtual sram_inf vif;
  
  /** transaction handle */
  sram_transaction strans_h;
  
  /** analysis port */
  uvm_analysis_port#(sram_transaction) item_collected_port;
  
  /** class constructor */
  extern function new(string name = "sram_monitor",uvm_component parent);
  
  /** build phase */
  extern function void build_phase(uvm_phase phase);
  
  /** run phase */
  extern task run_phase(uvm_phase phase);
  
  /** sample method */
  extern function void sample();

endclass : sram_monitor

/** class constructor */
function sram_monitor::new(string name = "sram_monitor",uvm_component parent);
  super.new(name,parent);
  item_collected_port = new("item_collected_port",this);
endfunction
 
/** build phase */
function void sram_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  //strans_h = sram_transaction::type_id::create("stran_h");
      
  if(!uvm_config_db#(virtual sram_inf)::get(this,"","sram_if",vif))
    `uvm_error(get_type_name(),"Not able to get the sram interface");
endfunction
    
/** run phase */
/** run phase */
task sram_monitor::run_phase(uvm_phase phase);
  
  
  // Variables to hold pipelined reads
  sram_transaction pipeline_tr;
  bit              read_pending = 0;
  super.run_phase(phase);
  forever begin
    // Wake up on EVERY clock edge without exception
    @(posedge vif.HCLK);
    
    // ---------------------------------------------------------
    // PHASE 2: Capture Read Data from the PREVIOUS cycle
    // ---------------------------------------------------------
    if (read_pending) begin
      pipeline_tr.SRAMRDATA = vif.SRAMRDATA;
      `uvm_info("SRAM_MON", $sformatf("Sampled READ - Addr: %0h, Data: %0h", pipeline_tr.SRAMADATA, pipeline_tr.SRAMRDATA), UVM_HIGH)
      item_collected_port.write(pipeline_tr);
      read_pending = 0; // Clear the flag
    end

    // ---------------------------------------------------------
    // PHASE 1: Capture Address/Control for the CURRENT cycle
    // ---------------------------------------------------------
    if (vif.SRAMCS === 1'b1) begin
      
      // Create a fresh transaction for this new cycle
      sram_transaction current_tr = sram_transaction::type_id::create("current_tr");
      
      current_tr.SRAMADATA = vif.SRAMADDR;
      current_tr.SRAMWREN  = vif.SRAMWEN;
      
      if (vif.SRAMWEN != 4'b0000) begin
        // WRITE: Address and Data are valid at the exact same time
        current_tr.SRAMWDATA = vif.SRAMWDATA;
        `uvm_info("SRAM_MON", $sformatf("Sampled WRITE - Addr: %0h, Data: %0h, WEN: %0b", current_tr.SRAMADATA, current_tr.SRAMWDATA, current_tr.SRAMWREN), UVM_HIGH)
        
        // Broadcast immediately
        item_collected_port.write(current_tr); 
      end 
      else begin
        // READ: Data won't be ready until next cycle!
        // Save this transaction into the pipeline buffer and set the flag
        pipeline_tr = current_tr;
        read_pending = 1; 
      end
    end
    
  end
endtask

//// You can delete the sample() function entirely!
//task sram_monitor::run_phase(uvm_phase phase);
//  super.run_phase(phase);
//  forever begin
//  @(posedge vif.HCLK)
//  `uvm_info("SRAM_MON","SRAMCS WAITING ...",UVM_NONE)
//  wait(vif.SRAMCS);
//  `uvm_info("SRAM_MON","SRAMCS CLEAR!!!!",UVM_NONE)
//  strans_h = sram_transaction::type_id::create("strans_h");
//  sample();
//  strans_h.print();
//  item_collected_port.write(strans_h);
//  `uvm_info("SRAM_MON","SRAM MONITOR SUCCESSFULLY BROADCASTED TO ANALYSIS PORT",UVM_NONE)
//  
//  end
//endtask
//    
function void sram_monitor::sample();
  strans_h.SRAMADATA = vif.SRAMADDR;
  strans_h.SRAMWDATA = vif.SRAMWDATA;
  strans_h.SRAMRDATA = vif.SRAMRDATA;
  strans_h.SRAMWREN  = vif.SRAMWEN;
endfunction

`endif

 