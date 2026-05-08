/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  NAME      :- Pradip Prajapati
//  FILE_NAME :- AHB_master_monitor.sv
//  EDITED_BY :- Pradip Prajapati
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef AHB_MASTER_MONITOR
`define AHB_MASTER_MONITOR

`define MAS_MON_CB mas_vif.ahb_mas_mon_cb

class ahb_mas_mon extends uvm_monitor;

  // Factory registration
  `uvm_component_param_utils(ahb_mas_mon)

  // Analysis port declarations
  uvm_analysis_port #(ahb_mas_trans) mas_ap_mon; // Broadcasts complete transactions to Scoreboard
  uvm_analysis_port #(ahb_mas_trans) mas_ap_ch;  // Broadcasts Address Phase 
  uvm_analysis_port #(ahb_mas_trans) mas_mon_cc; // Broadcasts for Coverage

  // Virtual interface
  virtual ahb_mas_inf mas_vif;

  // Standard UVM Methods
  extern function new(string name="ahb_mas_mon", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task capture_data_phase(ahb_mas_trans pipeline_tx);
  extern task reset_monitor();
  
endclass : ahb_mas_mon

// ----------------------------------------------------------------------------
// Method Implementations
// ----------------------------------------------------------------------------

function ahb_mas_mon::new(string name="ahb_mas_mon", uvm_component parent=null);
  super.new(name, parent);
  mas_ap_mon = new("mas_ap_mon", this);
  mas_ap_ch  = new("mas_ap_ch", this);
  mas_mon_cc = new("mas_mon_cc", this);
endfunction : new


function void ahb_mas_mon::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual ahb_mas_inf)::get(this, "", "mas_vif", mas_vif)) begin
    `uvm_fatal("MAS_MON", "Failed to get virtual interface from config DB!")
  end
endfunction : build_phase


// ------------------------------------------------------------------------
// RUN PHASE - Address Phase Capture
// ------------------------------------------------------------------------
task ahb_mas_mon::run_phase(uvm_phase phase);
  ahb_mas_trans current_addr_tx;
  
  forever begin
    @(`MAS_MON_CB);

    if (!mas_vif.hresetn) begin
      reset_monitor();
      continue;
    end

    // ADDRESS PHASE DETECTION: Check if bus is ready and a valid transfer is starting
    if (`MAS_MON_CB.HREADY === 1'b1 && 
       (`MAS_MON_CB.HTRANS == 2'b10 /*NONSEQ*/ || `MAS_MON_CB.HTRANS == 2'b11 /*SEQ*/)) begin
      
      // 1. Create a NEW transaction object for this specific transfer
      current_addr_tx = ahb_mas_trans::type_id::create("current_addr_tx");
      
      // 2. Capture Address Phase Signals
      current_addr_tx.HADDR       = `MAS_MON_CB.HADDR;
      current_addr_tx.HWRITE      = `MAS_MON_CB.HWRITE;
      current_addr_tx.hsize_type  = hsize_enum'(`MAS_MON_CB.HSIZE);
      current_addr_tx.hburst_type = hburst_enum'(`MAS_MON_CB.HBURST);
      current_addr_tx.htrans_type = {htrans_enum'(`MAS_MON_CB.HTRANS)};
      
      `uvm_info("MAS_MON", $sformatf("Address Phase Captured: 0x%0h", current_addr_tx.HADDR), UVM_HIGH)

      // Broadcast Address Phase 
      mas_ap_ch.write(current_addr_tx);

      // 3. Spawn a background process to handle the Data Phase
      // Passing the object to a separate task fixes the VCS [XMRE] error and ensures thread safety
      fork
        capture_data_phase(current_addr_tx);
      join_none 
    end
  end
endtask : run_phase


// ------------------------------------------------------------------------
// DATA PHASE CAPTURE TASK (Runs in the background)
// ------------------------------------------------------------------------
task ahb_mas_mon::capture_data_phase(ahb_mas_trans pipeline_tx);
  // Wait exactly 1 cycle to enter the Data Phase for THIS transaction
  @(`MAS_MON_CB);

  // Wait for any Slave Wait States (HREADY == 0)
  while (`MAS_MON_CB.HREADY === 1'b0) begin
     if (!mas_vif.hresetn) return; // Exit immediately if reset occurs during wait states
     @(`MAS_MON_CB);
  end

  // Capture Data Phase Signals once HREADY is high
  if (mas_vif.hresetn) begin
     pipeline_tx.HWDATA     = '{`MAS_MON_CB.HWDATA}; 
     pipeline_tx.HRDATA     = `MAS_MON_CB.HRDATA;
     pipeline_tx.hresp_type = hresp_enum'(`MAS_MON_CB.HRESP);

     `uvm_info("MAS_MON", $sformatf("Data Phase Completed for Addr: 0x%0h", pipeline_tx.HADDR), UVM_HIGH)

     // Only send to Scoreboard if the transfer was successful (OKAY response)
     // This prevents unmapped/error accesses from breaking Scoreboard queues
     if (pipeline_tx.hresp_type == OKAY) begin
         mas_ap_mon.write(pipeline_tx);
     end
     
     // Always send to coverage, even if it was an ERROR response
     mas_mon_cc.write(pipeline_tx);
     `uvm_info(get_full_name(),"MASTER MONITOR",UVM_LOW)
     pipeline_tx.print();
  end
endtask : capture_data_phase


// ------------------------------------------------------------------------
// RESET TASK
// ------------------------------------------------------------------------
task ahb_mas_mon::reset_monitor();
  `uvm_info("MAS_MON", "Monitor Reset detected.", UVM_MEDIUM)
  // Kills any pending capture_data_phase threads that are stuck waiting for HREADY
  disable fork; 
endtask : reset_monitor

`endif