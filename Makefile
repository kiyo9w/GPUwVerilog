# Makefile

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/src/compute_core.v \
                 $(shell pwd)/src/scheduler.v \
                 $(shell pwd)/src/fetcher.v \
                 $(shell pwd)/src/decoder.v \
                 $(shell pwd)/src/alu.v
TOPLEVEL = compute_core
MODULE = testbench.test_execution

SIM = icarus
COMPILE_ARGS += -g2012

# Paths
export PYTHONPATH := $(PYTHONPATH):$(shell pwd):$(shell pwd)/helpers

include $(shell cocotb-config --makefiles)/Makefile.sim
