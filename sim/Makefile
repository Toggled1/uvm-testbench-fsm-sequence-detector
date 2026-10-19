.DEFAULT_GOAL := build

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
VERILATOR ?= $(HOME)/.local/verilator-uvm/bin/verilator
UVM_HOME ?= $(HOME)/tools/uvm-verilator
JOBS ?= 2
RUN_ARGS ?=

BUILD_DIR := $(ROOT)/build/uvm
BINARY := $(BUILD_DIR)/Vtb_top
COVERAGE_FILE ?= $(ROOT)/build/coverage.dat

SOURCES := $(UVM_HOME)/src/uvm_pkg.sv \
           $(ROOT)/common/state_t_pkg.sv \
           $(ROOT)/common/sd_if.sv \
           $(ROOT)/design/src/seq_detector.sv \
           $(ROOT)/verif/src/sd_pkg.sv \
           $(ROOT)/verif/src/sd_checker.sv \
           $(ROOT)/verif/tb/tb_top.sv

CLASS_FILES := $(wildcard $(ROOT)/verif/src/*.sv $(ROOT)/verif/tb/*.sv)
UVM_HEADERS := $(shell find "$(UVM_HOME)/src" -type f -name '*.svh' 2>/dev/null)

FLAGS := --timing --assert --coverage -Wno-fatal --top-module tb_top \
         +define+UVM_NO_DPI \
         +incdir+$(UVM_HOME)/src \
         +incdir+$(ROOT)/verif/src +incdir+$(ROOT)/verif/tb

.PHONY: build run lint clean help

build: $(BINARY)

$(BINARY): $(SOURCES) $(CLASS_FILES) $(UVM_HEADERS) $(MAKEFILE_LIST) $(wildcard $(VERILATOR))
	mkdir -p "$(BUILD_DIR)"
	$(VERILATOR) --binary -j $(JOBS) $(FLAGS) --Mdir "$(BUILD_DIR)" $(SOURCES)

run: build
	"$(BINARY)" "+verilator+coverage+file+$(COVERAGE_FILE)" $(RUN_ARGS)

lint:
	$(VERILATOR) --lint-only $(FLAGS) $(SOURCES)

clean:
	rm -rf -- "$(BUILD_DIR)"

help:
	@printf '%s\n' \
	  'make -C sim         Build the UVM simulation (default).' \
	  'make -C sim run     Build if needed, then run.' \
	  'make -C sim lint    Lint the complete RTL/UVM project.' \
	  'make -C sim clean   Remove build/uvm only.' \
	  'Overrides: VERILATOR=/path/to/verilator UVM_HOME=/path/to/uvm JOBS=2' \
	  'Runtime options: make -C sim run RUN_ARGS="+verilator+seed+123"' \
	  'Coverage output: build/coverage.dat (override with COVERAGE_FILE=...)'

