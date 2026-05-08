# ==========================================================
# Simulator Selection
# ==========================================================

USE_SIMULATOR ?= vcs
TOP            = cortexm3_soc_tb
TESTNAME       ?= ahb_base_test
HEXFILE_NAME  ?= mem_btb_wr_rd_test 

# ==========================================================
# Log Configuration
# ==========================================================

LOG_DIR = logs
SEED ?= 1

VCS_RUN_OPTS  = -l $(LOG_DIR)/sim_$(TESTNAME)_$(SEED).log

VCS_COMP_OPTS = -lca -sverilog \
                -l $(LOG_DIR)/compile.log \
                -debug_access+all \
                -ntb_opts uvm-1.2

# ==========================================================
# Source Files
# ==========================================================

SRC_FILES = \
    ../../../UART/UART_UVC/ENV/apb_defines.sv \
    ../../../UART/UART_UVC/ENV/uvc_pkg.sv \
    ../../../AHB/tb/ahb_pkg.sv \
    ../tb/$(TOP).sv

# ==========================================================
# Include Directories
# ==========================================================

INCDIRS = \
    +incdir+../rtl \
    +incdir+../../cm3_matrix/rtl \
    +incdir+../../cmsdk_ahb_to_sram/rtl \
    +incdir+../../cmsdk_fpga_sram/verilog \
    +incdir+../../CORTEXM3INTEGRATION/rtl \
    +incdir+../sim \
    +incdir+../tb \
    +incdir+../../../AHB/mas_agent \
    +incdir+../../../AHB/slv_agent \
    +incdir+../../../AHB/uvc \
    +incdir+../../../AHB/env \
    +incdir+../../../AHB/includes \
    +incdir+../../../AHB/src \
    +incdir+../../../AHB/test \
    +incdir+../../../AHB/seq \
    +incdir+../../../AHB/tb \
    +incdir+../../../AHB/HDL_interconnect \
    +incdir+../../../UART/UART_UVC/UART_TX_AGENT \
    +incdir+../../../UART/UART_UVC/UART_RX_AGENT \
    +incdir+../../../UART/UART_UVC/TEST \
    +incdir+../../../UART/UART_UVC/INCLUDE \
    +incdir+../../../UART/UART_UVC/SRC \
    +incdir+../../../UART/UART_UVC/TB \
    +incdir+../../../UART/UART_UVC/ENV \
    +incdir+../../../UART/TEST \
    +incdir+../../AHB_APB-RTL \
    +incdir+../../I2C \
    +incdir+../../UART \
    +incdir+../../MEMORY

# ==========================================================
# Defines
# ==========================================================

DEFINES = \
    +define+THR_SIZE=8 \
    +define+PWDATA_WIDTH=8 \
    +define+UVM_OBJECTION_TRACE

# ==========================================================
# Simulator Commands
# ==========================================================

ifeq ($(USE_SIMULATOR),questa)
COMP = vlog -sv -coveropt 3 +cover +acc
SIM  = vsim -vopt $(TOP)
COV_SIM = vsim -coverage -vopt $(TOP)
endif

ifeq ($(USE_SIMULATOR),vcs)
COMP = vcs -full64 $(VCS_COMP_OPTS) \
       -cm line+cond+fsm+branch+tgl
SIM  = ./simv $(VCS_RUN_OPTS)
endif

# ==========================================================
# Targets
# ==========================================================

.PHONY: comp sim cov regress clean

# ---------------- COMPILE ----------------

comp:
	rm image.hex
	rm disasm.txt
	rm first.c
	rm startup.s
	@echo "running hex file $(HEXFILE_NAME)"
	cp -r ../sim/$(HEXFILE_NAME)/image.hex image.hex 
	cp -r ../sim/$(HEXFILE_NAME)/disasm.txt disasm.txt 
	cp -r ../sim/$(HEXFILE_NAME)/first.c first.c 
	cp -r ../sim/$(HEXFILE_NAME)/startup.s startup.s 
	@mkdir -p $(LOG_DIR)
	$(COMP) $(INCDIRS) $(DEFINES) $(SRC_FILES)

# ---------------- SIMULATION ----------------

sim: comp
ifeq ($(USE_SIMULATOR),questa)
	$(SIM) -c -do "run -all; exit" +UVM_TESTNAME=$(TESTNAME)
else
	$(SIM) +UVM_TESTNAME=$(TESTNAME)
endif

# ---------------- COVERAGE ----------------

cov: comp
ifeq ($(USE_SIMULATOR),questa)
	$(COV_SIM) -c -do "coverage save -onexit test.ucdb; run -all; exit" +UVM_TESTNAME=$(TESTNAME)
else
	$(SIM) -cm line+cond+fsm+branch+tgl +UVM_TESTNAME=$(TESTNAME)
	urg -dir simv.vdb -report COVERAGE
endif

# ---------------- REGRESSION ----------------

regress: comp
ifeq ($(USE_SIMULATOR),questa)
	$(SIM) -c -do "coverage save -onexit test1.ucdb; run -all; exit" +UVM_TESTNAME=test1
	$(SIM) -c -do "coverage save -onexit test2.ucdb; run -all; exit" +UVM_TESTNAME=test2
	vcover merge merge.ucdb test1.ucdb test2.ucdb
	vcover report -html -htmldir COVERAGE merge.ucdb
else
	$(SIM) -cm line+cond+fsm+branch+tgl +UVM_TESTNAME=test1
	mv simv.vdb test1.vdb
	$(SIM) -cm line+cond+fsm+branch+tgl +UVM_TESTNAME=test2
	mv simv.vdb test2.vdb
	urg -dir test1.vdb test2.vdb -report COVERAGE
endif

# ---------------- CLEAN ----------------

clean:
	rm -rf work transcript vsim.wlf *.ucdb \
	       simv simv.daidir simv.vdb csrc \
	       DVEfiles COVERAGE logs
