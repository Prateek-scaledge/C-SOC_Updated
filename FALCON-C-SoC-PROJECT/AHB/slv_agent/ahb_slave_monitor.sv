`ifndef AHB_SLAVE_MONITOR
`define AHB_SLAVE_MONITOR

// ...Assuming the clocking block is defined in the interface as ahb_slv_mon_cb
`define SLV_MON_CB slv_vif.ahb_slv_mon_cb

class ahb_slv_mon extends uvm_monitor;

  // Factory registration
  `uvm_component_param_utils(ahb_slv_mon)

  // Analysis port declarations
  uvm_analysis_port #(ahb_slv_trans) slv_ap_mon; // Broadcasts Address Phase
  uvm_analysis_port #(ahb_slv_trans) slv_mon_sb; // Broadcasts Complete Transaction (Addr + Data)
  uvm_analysis_port #(ahb_slv_trans) slv_mon_cc; // Broadcasts for Coverage

  // Virtual interface
  virtual ahb_slv_inf slv_vif;

  // The Pipeline Queue: Crucial for holding transactions between Address and Data phases
  ahb_slv_trans pipeline_q[$];

  // Standard UVM Methods
  extern function new(string name="ahb_slv_mon", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task reset_monitor();
      
endclass : ahb_slv_mon

// ----------------------------------------------------------------------------
// Method Implementations
// ----------------------------------------------------------------------------

function ahb_slv_mon::new(string name="ahb_slv_mon", uvm_component parent=null);
  super.new(name, parent);
  slv_ap_mon = new("slv_ap_mon", this);
  slv_mon_sb = new("slv_mon_sb", this);
  slv_mon_cc = new("slv_mon_cc", this);
endfunction : new


function void ahb_slv_mon::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual ahb_slv_inf)::get(this, "", "slv_vif", slv_vif)) begin
    `uvm_fatal("SLV_MON", "Failed to get virtual interface from config DB!")
  end
endfunction : build_phase


task ahb_slv_mon::run_phase(uvm_phase phase);
  ahb_slv_trans current_addr_tx;
  ahb_slv_trans current_data_tx;

  forever begin
    // Synchronize to the clocking block
    @(`SLV_MON_CB);

    // 1. Handle Reset
    if (!slv_vif.hresetn) begin
      reset_monitor();
      continue; // Skip the rest of the loop while in reset
    end

    // ------------------------------------------------------------------------
    // 2. PROCESS DATA PHASE (Evaluates the transaction from the PREVIOUS cycle)
    // ------------------------------------------------------------------------
    // If there is a transaction waiting in the pipeline, and the bus is advancing (HREADY_IN is HIGH)
    if (pipeline_q.size() > 0 && `SLV_MON_CB.HREADY_IN === 1'b1) begin
      
      // Pop the transaction that was created during the previous address phase
      current_data_tx = pipeline_q.pop_front();
      
      // Capture the Data and Response signals that are valid NOW
      current_data_tx.HWDATA     = `SLV_MON_CB.HWDATA;
      current_data_tx.HRDATA     = `SLV_MON_CB.HRDATA;
      current_data_tx.hresp_type = hresp_enum'(`SLV_MON_CB.HRESP);
      current_data_tx.HREADYOUT  = `SLV_MON_CB.HREADYOUT;
      
      `uvm_info("SLV_MON", $sformatf("Data Phase Completed for Addr: 0x%0h", current_data_tx.HADDR), UVM_HIGH)
      
      // Only broadcast to the scoreboard if it was a successful transfer (OKAY)
      // This matches the Master Monitor logic and prevents queue desynchronization on ERRORs
      if (current_data_tx.hresp_type == OKAY) begin
          slv_mon_sb.write(current_data_tx);
      end
      
      // Always broadcast to coverage
      slv_mon_cc.write(current_data_tx);
      `uvm_info(get_full_name(),"SLAVE MONITOR DATA PHASE",UVM_LOW)
     current_data_tx.print();
    end

    // ------------------------------------------------------------------------
    // 3. PROCESS ADDRESS PHASE (Evaluates the signals for the CURRENT cycle)
    // ------------------------------------------------------------------------
    // Note the parentheses around the HTRANS check!
    if (`SLV_MON_CB.HREADY_IN === 1'b1 && 
       (`SLV_MON_CB.HTRANS == 2'b10 /*NONSEQ*/ || `SLV_MON_CB.HTRANS == 2'b11 /*SEQ*/)) begin
      
      // Create a BRAND NEW transaction object for this specific transfer
      current_addr_tx = ahb_slv_trans::type_id::create("current_addr_tx");
      
      // Capture the Address and Control signals
      current_addr_tx.HWRITE      = `SLV_MON_CB.HWRITE;
      current_addr_tx.HADDR       = `SLV_MON_CB.HADDR;
      current_addr_tx.hburst_type = hburst_enum'(`SLV_MON_CB.HBURST);
      current_addr_tx.hsize_type  = hsize_enum'(`SLV_MON_CB.HSIZE);
      
      // Dynamic array cast fix for [ICTA] error
      current_addr_tx.htrans_type = htrans_enum'(`SLV_MON_CB.HTRANS); 
      
      `uvm_info("SLV_MON", $sformatf("Address Phase Captured: 0x%0h", current_addr_tx.HADDR), UVM_HIGH)

      // Broadcast just the address phase 
      slv_ap_mon.write(current_addr_tx);

      // Push it into the pipeline queue. It will wait here until its Data Phase arrives
      pipeline_q.push_back(current_addr_tx);
      `uvm_info(get_full_name(),"SLAVE MONITOR ADDRESS PHASE",UVM_LOW)
     current_addr_tx.print();
    end
    
  end
endtask : run_phase


task ahb_slv_mon::reset_monitor();
  // Clear the pipeline queue so old transactions don't leak into the next test phase
  pipeline_q.delete();
  `uvm_info("SLV_MON", "Monitor Reset detected. Pipeline queue cleared.", UVM_MEDIUM)
  
  // Wait until reset is de-asserted (high) before returning to prevent cycle-skipping desync
  wait(slv_vif.hresetn === 1'b1);
endtask : reset_monitor

`endif
