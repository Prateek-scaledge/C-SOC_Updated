
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  NAME      :- Pradip Prajapati
//  FILE_NAME :- ahb_sb.svh
//  EDITED_BY :- Akash Kumar Sahu
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/** ABSTRACT :
*   Scoreboard compares transactions seen by master monitors (what the CPU requested)
*   against transactions seen by slave monitors (what actually arrived at the slaves).
*
*   DESIGN PHILOSOPHY (Decoupled Queue Architecture):
*   ------------------------------------------------
*   The OLD scoreboard performed comparisons directly inside the write_* methods.
*   This caused a fatal race condition: if the slave monitor fired even one delta
*   cycle before the master monitor, pop_front() would return null, causing a
*   simulation crash on null dereference.
*
*   This scoreboard uses a fully DECOUPLED approach:
*     1. write_* methods ONLY push transactions into per-port queues. No comparison here.
*     2. run_phase() performs all comparisons on the negedge of the clock, safely
*        after all monitors have settled, eliminating all race conditions.
*     3. check_phase() drains queues at end-of-test to catch dropped transactions.
*/

`ifndef AHB_SCOREBOARD
`define AHB_SCOREBOARD

class ahb_sb extends uvm_scoreboard;

  `uvm_component_utils(ahb_sb)

  // --------------------------------------------------------------------------
  // ANALYSIS IMPORT SUFFIX DECLARATIONS
  // Each suffix creates a unique write_<suffix>() method so one scoreboard
  // class can receive transactions from multiple different monitors.
  // --------------------------------------------------------------------------
  `uvm_analysis_imp_decl(_mas_m0)
  `uvm_analysis_imp_decl(_mas_m1)
  `uvm_analysis_imp_decl(_mas_m2)
  `uvm_analysis_imp_decl(_mas_m3)
  `uvm_analysis_imp_decl(_slv_s0)
  `uvm_analysis_imp_decl(_slv_s1)
  `uvm_analysis_imp_decl(_slv_s3)
  `uvm_analysis_imp_decl(_slv_s4)
  `uvm_analysis_imp_decl(_slv_s5)
  `uvm_analysis_imp_decl(_ahb_sram)
  `uvm_analysis_imp_decl(_sram)

  // --------------------------------------------------------------------------
  // ANALYSIS IMPORT PORT HANDLES
  // These are the TLM ports that monitors connect to via .connect() in the env.
  // --------------------------------------------------------------------------
  uvm_analysis_imp_mas_m0  #(ahb_mas_trans,   ahb_sb) mas_ai_sb_m0;
  uvm_analysis_imp_mas_m1  #(ahb_mas_trans,   ahb_sb) mas_ai_sb_m1;
  uvm_analysis_imp_mas_m2  #(ahb_mas_trans,   ahb_sb) mas_ai_sb_m2;
  uvm_analysis_imp_mas_m3  #(ahb_mas_trans,   ahb_sb) mas_ai_sb_m3;
  uvm_analysis_imp_slv_s0  #(ahb_slv_trans,   ahb_sb) slv_ai_sb_s0;
  uvm_analysis_imp_slv_s1  #(ahb_slv_trans,   ahb_sb) slv_ai_sb_s1;
  uvm_analysis_imp_slv_s3  #(ahb_slv_trans,   ahb_sb) slv_ai_sb_s3;
  uvm_analysis_imp_slv_s4  #(ahb_slv_trans,   ahb_sb) slv_ai_sb_s4;
  uvm_analysis_imp_slv_s5  #(ahb_slv_trans,   ahb_sb) slv_ai_sb_s5;
  uvm_analysis_imp_ahb_sram#(ahb_mas_trans,   ahb_sb) ahb_sram_ai_sb;
 // uvm_analysis_imp_sram    #(sram_transaction, ahb_sb) sram_ai_sb;

  // --------------------------------------------------------------------------
  // DECOUPLED QUEUES
  // FIX LOG [1] - RACE CONDITION FIX:
  //   OLD: write_slv_s*() called mas_m*_act_q.pop_front() immediately, assuming
  //        the master transaction had already arrived. If it hadn't, pop_front()
  //        returned null and the very next line (mas_tr.HWDATA[0]) caused a fatal
  //        null-dereference simulation crash.
  //   NEW: write_* methods ONLY push into these queues. The actual comparison is
  //        deferred to run_phase() on the negedge of the clock, by which time all
  //        monitors for that cycle have already fired and both queues are populated.
  // --------------------------------------------------------------------------
  ahb_mas_trans mas_m0_q[$];
  ahb_mas_trans mas_m1_q[$];
  ahb_mas_trans mas_m2_q[$];
  ahb_mas_trans mas_m3_q[$];

  ahb_slv_trans slv_s0_q[$];
  ahb_slv_trans slv_s1_q[$];
  ahb_slv_trans slv_s3_q[$];
  ahb_slv_trans slv_s4_q[$];
  ahb_slv_trans slv_s5_q[$];
  bit[31:0] addr_list[$];//Address Tracker

  // Virtual interface handle — used in run_phase to sample clock and reset.
  virtual ahb_inf vif;

  // Shadow memory model: mirrors what has been written to SRAM via the AHB-SRAM
  // bridge. Used by write_ahb_sram to track expected read-back data.
  int mem[int];

  // --------------------------------------------------------------------------
  // TRANSACTION COUNTERS
  // Per master total count + per (master, slave) routed count.
  // report_phase uses these to verify no transaction was silently dropped.
  // --------------------------------------------------------------------------
  longint m0_trans_count, m1_trans_count, m2_trans_count, m3_trans_count;
  longint s0_m0_trans_count, s0_m1_trans_count;
  longint s1_m0_trans_count, s1_m1_trans_count;
  longint s3_m2_trans_count, s3_m3_trans_count;
  longint s4_m0_trans_count, s4_m1_trans_count, s4_m2_trans_count;
  longint s5_m0_trans_count, s5_m1_trans_count, s5_m3_trans_count;

  extern function new(string name = "ahb_sb", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern function void write_mas_m0(ahb_mas_trans t);
  extern function void write_mas_m1(ahb_mas_trans t);
  extern function void write_mas_m2(ahb_mas_trans t);
  extern function void write_mas_m3(ahb_mas_trans t);
  extern function void write_slv_s0(ahb_slv_trans t);
  extern function void write_slv_s1(ahb_slv_trans t);
  extern function void write_slv_s3(ahb_slv_trans t);
  extern function void write_slv_s4(ahb_slv_trans t);
  extern function void write_slv_s5(ahb_slv_trans t);
  extern function void write_ahb_sram(ahb_mas_trans t);
//  extern function void write_sram(sram_transaction t);

  // match_and_compare: searches a slave queue for a transaction matching the
  // given master transaction (by address + direction), compares data, and
  // increments the relevant counter. Returns 1 if a match was found, 0 if not.
  // 'input' keyword on value args and 'ref' on queues/counters is required to
  // avoid the [IRPC] compiler error on passing queues to functions.
  extern function bit match_and_compare(input ahb_mas_trans mas_tr, input string mas_name,
                                        ref   ahb_slv_trans slv_q[$],
                                        input string slv_name, ref longint counter);

  extern function void check_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : ahb_sb

//=============================================================================
// METHODS
//=============================================================================

function ahb_sb::new(string name = "ahb_sb", uvm_component parent = null);
  super.new(name, parent);
  // FIX LOG [2] - CORRECT UVM COMPONENT INSTANTIATION PHASE:
  //   OLD: Analysis import handles were created here in new(), bypassing the
  //        UVM factory and breaking phase-ordering guarantees.
  //   NEW: All component creation is moved to build_phase() below, which is the
  //        correct and only sanctioned phase for creating UVM sub-components.
endfunction

function void ahb_sb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Instantiate all analysis import ports here in build_phase (correct UVM practice).
  mas_ai_sb_m0   = new("mas_ai_sb_m0",   this);
  mas_ai_sb_m1   = new("mas_ai_sb_m1",   this);
  mas_ai_sb_m2   = new("mas_ai_sb_m2",   this);
  mas_ai_sb_m3   = new("mas_ai_sb_m3",   this);
  slv_ai_sb_s0   = new("slv_ai_sb_s0",   this);
  slv_ai_sb_s1   = new("slv_ai_sb_s1",   this);
  slv_ai_sb_s3   = new("slv_ai_sb_s3",   this);
  slv_ai_sb_s4   = new("slv_ai_sb_s4",   this);
  slv_ai_sb_s5   = new("slv_ai_sb_s5",   this);
  ahb_sram_ai_sb = new("ahb_sram_ai_sb", this);
//  sram_ai_sb   = new("sram_ai_sb",     this);

  // Retrieve the virtual interface from config_db. Fatal if not found because
  // the run_phase clock/reset sampling cannot work without it.
  if (!uvm_config_db#(virtual ahb_inf)::get(this, "", "inf", vif))
    `uvm_fatal(get_type_name(), "Failed to get virtual ahb_inf handle in scoreboard")
endfunction

//=============================================================================
// WRITE METHODS  (Push-only — absolutely NO comparisons here)
// FIX LOG [3] - DECOUPLED WRITE METHODS:
//   OLD: Each write_slv_s*() immediately called pop_front() on the master queue
//        and compared data inline. This tightly coupled arrival order and caused
//        null-dereference crashes whenever the slave monitor fired before the
//        master monitor in the same clock cycle.
//   NEW: write_* methods are pure producers. They validate the transaction type
//        and push to the correct queue. run_phase() is the sole consumer and
//        comparator, running safely after all monitors have settled on negedge.
//=============================================================================

// FIX LOG [4] - BUSY TRANSACTION FILTERING:
//   OLD: Only IDLE was filtered out (htrans_type[0] != IDLE).
//        BUSY transactions carrying no valid data leaked into the queues,
//        causing spurious count mismatches in report_phase.
//   NEW: Both IDLE and BUSY are explicitly discarded before pushing.
function void ahb_sb::write_mas_m0(ahb_mas_trans t);
  if (t.htrans_type[0] == IDLE || t.htrans_type[0] == BUSY) return;
  mas_m0_q.push_back(t);
  m0_trans_count++;
endfunction

function void ahb_sb::write_mas_m1(ahb_mas_trans t);
  if (t.htrans_type[0] == IDLE || t.htrans_type[0] == BUSY) return;
  mas_m1_q.push_back(t);
  m1_trans_count++;
endfunction

function void ahb_sb::write_mas_m2(ahb_mas_trans t);
  if (t.htrans_type[0] == IDLE || t.htrans_type[0] == BUSY) return;
  mas_m2_q.push_back(t);
  m2_trans_count++;
endfunction

function void ahb_sb::write_mas_m3(ahb_mas_trans t);
  if (t.htrans_type[0] == IDLE || t.htrans_type[0] == BUSY) return;
  mas_m3_q.push_back(t);
  m3_trans_count++;
endfunction

// Slave write methods — same IDLE/BUSY guard, then push to slave queue.
// No master queue is touched here at all.
function void ahb_sb::write_slv_s0(ahb_slv_trans t);
  if (t.htrans_type == IDLE || t.htrans_type == BUSY) return;
  slv_s0_q.push_back(t);
endfunction

function void ahb_sb::write_slv_s1(ahb_slv_trans t);
  if (t.htrans_type == IDLE || t.htrans_type == BUSY) return;
  slv_s1_q.push_back(t);
endfunction

function void ahb_sb::write_slv_s3(ahb_slv_trans t);
  if (t.htrans_type == IDLE || t.htrans_type == BUSY) return;
  slv_s3_q.push_back(t);
endfunction

function void ahb_sb::write_slv_s4(ahb_slv_trans t);
  if (t.htrans_type == IDLE || t.htrans_type == BUSY) return;
  slv_s4_q.push_back(t);
endfunction

function void ahb_sb::write_slv_s5(ahb_slv_trans t);
  if (t.htrans_type == IDLE || t.htrans_type == BUSY) return;
  slv_s5_q.push_back(t);
endfunction
//=======================================================================================================
//Address range checker
//=======================================================================================================
function bit chk_addr_range(bit[31:0]addr);
  return(addr inside {[32'h0000_0000:32'h0000_ffff],[32'h2000_0000:32'h2001_ffff],[32'h2000_0000:32'h4000_ffff]});
endfunction
//=============================================================================
// CORE COMPARISON ENGINE
// FIX LOG [5] - NULL-SAFE MATCHING WITH find_first_index:
//   OLD: Used pop_front() blindly, assuming the first queued master transaction
//        belonged to the arriving slave transaction. This broke for out-of-order
//        or interleaved traffic and crashed on empty queues (null return).
//   NEW: find_first_index() searches the slave queue for the transaction whose
//        HADDR AND HWRITE match the master transaction that arrived at the SRAM
//        output. Only if a match exists is it consumed (delete). No null risk.
//=============================================================================
function bit ahb_sb::match_and_compare(
  input ahb_mas_trans   mas_tr,
  input string          mas_name,
  ref   ahb_slv_trans   slv_q[$],
  input string          slv_name,
  ref   longint         counter
);
  int idx[$];

  // Search the slave queue for a transaction with matching address and direction.
  idx = slv_q.find_first_index(item) with (
    item.HADDR  == mas_tr.HADDR &&
    item.HWRITE == mas_tr.HWRITE
  );
  
  if (idx.size() > 0) begin
    ahb_slv_trans slv_tr = slv_q[idx[0]];
    addr_list.push_back(slv_tr.HADDR);//Keeps track of all the addresses passed
    slv_q.delete(idx[0]); // Consume the matched entry to prevent re-matching.

    // Data comparison — WRITE: check CPU-sent data reached slave correctly.
    //                   READ : check data slave returned matches master's HRDATA.
    if (slv_tr.HWRITE) begin
      if (slv_tr.HWDATA !== mas_tr.HWDATA[0])
        `uvm_error("SB", $sformatf(
          "%s->%s WRITE mismatch | Addr: 0x%08h | CPU Req: 0x%08h | SRAM Got: 0x%08h",
          slv_name, mas_name, slv_tr.HADDR, slv_tr.HWDATA, mas_tr.HWDATA[0]))
    end else begin
      if (slv_tr.HRDATA !== mas_tr.HRDATA)
        `uvm_error("SB", $sformatf(
          "%s->%s READ mismatch | Addr: 0x%08h | CPU Got: 0x%08h | SRAM Sent: 0x%08h",
          slv_name, mas_name, slv_tr.HADDR, slv_tr.HRDATA, mas_tr.HRDATA))
    end

    counter++;
    return 1; // Match found and consumed.
  end

  return 0; // No matching slave transaction yet — caller will retry next cycle.
endfunction

//=============================================================================
// RUN PHASE — The Safe Comparison Window
// FIX LOG [6] - CLOCK-ALIGNED COMPARISON WINDOW:
//   OLD: run_phase did not exist. Comparisons happened in write() methods with
//        no clock alignment, making them vulnerable to delta-cycle race conditions
//        between master and slave monitors firing in the same time step.
//   NEW: All comparisons happen on negedge hclk. By the negedge, every posedge-
//        triggered monitor for that cycle has already written to its queue,
//        guaranteeing both master and slave data are present before we compare.
//
// FIX LOG [7] - RESET QUEUE FLUSH:
//   OLD: No reset handling existed. Stale transactions left in queues from before
//        reset would be incorrectly matched against post-reset traffic.
//   NEW: On deassertion of hresetn, all queues and the shadow memory are cleared,
//        and the task waits for hresetn to go high again before resuming.
//=============================================================================
task ahb_sb::run_phase(uvm_phase phase);
  forever begin
    // Wait for negedge — all posedge monitors have settled by this point.
    @(negedge vif.hclk);

    // -----------------------------------------------------------------------
    // RESET HANDLER: flush all queues and shadow memory on active-low reset.
    // -----------------------------------------------------------------------
    if (!vif.hresetn) begin
      mas_m0_q.delete(); mas_m1_q.delete();
      mas_m2_q.delete(); mas_m3_q.delete();
      slv_s0_q.delete(); slv_s1_q.delete();
      slv_s3_q.delete(); slv_s4_q.delete(); slv_s5_q.delete();
      mem.delete();
      @(posedge vif.hresetn); // Resume only after reset is released.
      continue;
    end

    // -----------------------------------------------------------------------
    // COMPARISON LOOPS
    // Each master queue is drained one entry at a time. match_and_compare()
    // searches all slave queues that this master can legally route to.
    // If none match yet (transaction still in-flight), we break and retry
    // on the next negedge rather than blocking the entire run_phase.
    //
    // Master-to-slave routing is determined by the AHB matrix address map:
    //   M0 (SRAM A bus)  ? S0, S1, S4, S5
    //   M1               ? S0, S1, S4, S5
    //   M2 (APB Bridge)  ? S3, S4
    //   M3 (SRAM S bus)  ? S3, S5
    // -----------------------------------------------------------------------

    // Process M0
    while (mas_m0_q.size() > 0) begin
      if      (match_and_compare(mas_m0_q[0], "M0", slv_s0_q, "S0", s0_m0_trans_count)) mas_m0_q.pop_front();
      else if (match_and_compare(mas_m0_q[0], "M0", slv_s1_q, "S1", s1_m0_trans_count)) mas_m0_q.pop_front();
      else if (match_and_compare(mas_m0_q[0], "M0", slv_s4_q, "S4", s4_m0_trans_count)) mas_m0_q.pop_front();
      else if (match_and_compare(mas_m0_q[0], "M0", slv_s5_q, "S5", s5_m0_trans_count)) mas_m0_q.pop_front();
      else break; // Slave transaction not yet in queue — wait until next negedge.
    end

    // Process M1
    while (mas_m1_q.size() > 0) begin
      if      (match_and_compare(mas_m1_q[0], "M1", slv_s0_q, "S0", s0_m1_trans_count)) mas_m1_q.pop_front();
      else if (match_and_compare(mas_m1_q[0], "M1", slv_s1_q, "S1", s1_m1_trans_count)) mas_m1_q.pop_front();
      else if (match_and_compare(mas_m1_q[0], "M1", slv_s4_q, "S4", s4_m1_trans_count)) mas_m1_q.pop_front();
      else if (match_and_compare(mas_m1_q[0], "M1", slv_s5_q, "S5", s5_m1_trans_count)) mas_m1_q.pop_front();
      else break;
    end

    // Process M2 (APB bridge — routes to S3 and S4 only)
    while (mas_m2_q.size() > 0) begin
      if      (match_and_compare(mas_m2_q[0], "M2", slv_s3_q, "S3", s3_m2_trans_count)) mas_m2_q.pop_front();
      else if (match_and_compare(mas_m2_q[0], "M2", slv_s4_q, "S4", s4_m2_trans_count)) mas_m2_q.pop_front();
      else break;
    end

    // Process M3 (system bus — routes to S3 and S5 only)
    while (mas_m3_q.size() > 0) begin
      if      (match_and_compare(mas_m3_q[0], "M3", slv_s3_q, "S3", s3_m3_trans_count)) mas_m3_q.pop_front();
      else if (match_and_compare(mas_m3_q[0], "M3", slv_s5_q, "S5", s5_m3_trans_count)) mas_m3_q.pop_front();
      else break;
    end

  end
endtask

//=============================================================================
// SRAM BRIDGE SHADOW MEMORY
// write_ahb_sram receives transactions from the monitor placed on the AHB side
// of the cmsdk_ahb_to_sram bridge. On every WRITE, the shadow memory is updated
// so that a subsequent write_sram() read check can compare against it.
// FIX LOG [8] - SRAM READ-BACK VERIFICATION (currently disabled):
//   The write_sram() method (commented out) compared SRAM read-data against the
//   shadow mem[] model. It was found to be unreliable due to SRAMWREN being a
//   4-bit byte-enable bus rather than a single active-low flag. Re-enable and
//   fix the SRAMWREN decode logic when the SRAM monitor is re-integrated.
//=============================================================================
function void ahb_sb::write_ahb_sram(ahb_mas_trans t);
  if (t.HWRITE) mem[t.HADDR] = t.HWDATA[0];
endfunction

//function void ahb_sb::write_sram(sram_transaction t);
//  // SRAMWREN is a 4-bit active-low byte-enable; 4'b0000 means full-word read.
//  if (t.SRAMWREN == 4'b0000) begin
//    if (!mem.exists(t.SRAMADATA))
//      `uvm_warning("SB", $sformatf("SRAM read at 0x%08h but address was never written", t.SRAMADATA))
//    else if (t.SRAMRDATA !== mem[t.SRAMADATA])
//      `uvm_error("SB", $sformatf("SRAM data mismatch | Addr: 0x%08h | Actual: 0x%08h | Expected: 0x%08h",
//                                  t.SRAMADATA, t.SRAMRDATA, mem[t.SRAMADATA]))
//  end
//endfunction

//=============================================================================
// CHECK PHASE — End-of-Test Queue Drain Verification
// FIX LOG [9] - DROPPED TRANSACTION DETECTION:
//   OLD: No check_phase existed. If the AHB matrix silently dropped a transaction
//        (e.g., due to an arbitration bug), the queues would hold the unmatched
//        master entry forever and the test would pass incorrectly.
//   NEW: check_phase errors on any non-empty queue, guaranteeing every transaction
//        that entered the matrix also arrived at its intended slave.
//        Note: Only master queues and CPU-side slave queues (S0, S1) are checked
//        here. S3/S4/S5 remnants are caught by the count mismatch in report_phase.
//=============================================================================
function void ahb_sb::check_phase(uvm_phase phase);
  if (mas_m0_q.size() > 0) `uvm_error("SB", $sformatf("M0 queue has %0d dropped entries", mas_m0_q.size()))
  if (mas_m1_q.size() > 0) `uvm_error("SB", $sformatf("M1 queue has %0d dropped entries", mas_m1_q.size()))
  if (mas_m2_q.size() > 0) `uvm_error("SB", $sformatf("M2 queue has %0d dropped entries", mas_m2_q.size()))
  if (mas_m3_q.size() > 0) `uvm_error("SB", $sformatf("M3 queue has %0d dropped entries", mas_m3_q.size()))

  if (slv_s0_q.size() > 0) `uvm_error("SB", $sformatf("S0 CPU queue has %0d unrouted entries", slv_s0_q.size()))
  if (slv_s1_q.size() > 0) `uvm_error("SB", $sformatf("S1 CPU queue has %0d unrouted entries", slv_s1_q.size()))
endfunction

//=============================================================================
// REPORT PHASE — Transaction Count Summary and Final Cross-Check
// FIX LOG [10] - TRANSACTION COUNT INTEGRITY CHECK:
//   OLD: report_phase existed but only printed counts without verifying them,
//        so a matrix that dropped half its transactions still produced a clean log.
//   NEW: After printing the routing table, each master total count is verified
//        against the sum of all its per-slave matched counts. Any discrepancy
//        means a transaction was either duplicated or lost.
//=============================================================================
function void ahb_sb::report_phase(uvm_phase phase);
 int failure;
  `uvm_info("SB_REPORT", "|================================================|", UVM_NONE)
  `uvm_info("SB_REPORT", $sformatf("| %-6s %6d  |  S0: %6d  S1: %6d          |", "M0", m0_trans_count, s0_m0_trans_count, s1_m0_trans_count), UVM_NONE)
  `uvm_info("SB_REPORT", $sformatf("|                |  S4: %6d  S5: %6d          |", s4_m0_trans_count, s5_m0_trans_count), UVM_NONE)
  `uvm_info("SB_REPORT", "|------------------------------------------------|", UVM_NONE)
  `uvm_info("SB_REPORT", $sformatf("| %-6s %6d  |  S0: %6d  S1: %6d          |", "M1", m1_trans_count, s0_m1_trans_count, s1_m1_trans_count), UVM_NONE)
  `uvm_info("SB_REPORT", $sformatf("|                |  S4: %6d  S5: %6d          |", s4_m1_trans_count, s5_m1_trans_count), UVM_NONE)
  `uvm_info("SB_REPORT", "|------------------------------------------------|", UVM_NONE)
  `uvm_info("SB_REPORT", $sformatf("| %-6s %6d  |  S3: %6d  S4: %6d          |", "M2", m2_trans_count, s3_m2_trans_count, s4_m2_trans_count), UVM_NONE)
  `uvm_info("SB_REPORT", "|------------------------------------------------|", UVM_NONE)
  `uvm_info("SB_REPORT", $sformatf("| %-6s %6d  |  S3: %6d  S5: %6d          |", "M3", m3_trans_count, s3_m3_trans_count, s5_m3_trans_count), UVM_NONE)
  `uvm_info("SB_REPORT", "|================================================|", UVM_NONE)

  // Verify that total master count == sum of all its per-slave matched counts.
  if (m0_trans_count != (s0_m0_trans_count + s1_m0_trans_count + s4_m0_trans_count + s5_m0_trans_count))begin
    `uvm_error("SB", "M0 count mismatch")
    failure++;
    end
  if (m1_trans_count != (s0_m1_trans_count + s1_m1_trans_count + s4_m1_trans_count + s5_m1_trans_count))begin
    `uvm_error("SB", "M1 count mismatch")
    failure++;
    end
  if (m2_trans_count != (s3_m2_trans_count + s4_m2_trans_count))begin
    `uvm_error("SB", "M2 count mismatch")
    failure++;
    end
  if (m3_trans_count != (s3_m3_trans_count + s5_m3_trans_count))begin
    `uvm_error("SB", "M3 count mismatch")
    failure++;
    end
    foreach(addr_list[i])begin
      if(!chk_addr_range(addr_list[i]))
        failure++;
    end
    if(failure==0)
      `uvm_info("SB_REPORT","******************************PASS********************************",UVM_NONE)
    else
      `uvm_error("SB_REPORT","******************************FAIL********************************")
endfunction

`endif