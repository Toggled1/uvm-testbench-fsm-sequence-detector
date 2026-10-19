.DEFAULT_GOAL := build
SHELL := /bin/bash

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
VERILATOR ?= $(HOME)/.local/verilator-uvm/bin/verilator
VERILATOR_COVERAGE ?= $(dir $(VERILATOR))verilator_coverage
UVM_HOME ?= $(HOME)/tools/uvm-verilator
JOBS ?= 2
RUN_ARGS ?=
OPEN_COVERAGE ?= 1

BUILD_DIR := $(ROOT)/build/uvm
BINARY := $(BUILD_DIR)/Vtb_top
COVERAGE_FILE ?= $(ROOT)/build/coverage.dat
COVERAGE_INFO := $(ROOT)/build/coverage.info
COVERAGE_HTML := $(ROOT)/build/coverage-html

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

.PHONY: build run coverage coverage-open lint clean help

build: $(BINARY)

$(BINARY): $(SOURCES) $(CLASS_FILES) $(UVM_HEADERS) $(MAKEFILE_LIST) $(wildcard $(VERILATOR))
	mkdir -p "$(BUILD_DIR)"
	$(VERILATOR) --binary -j $(JOBS) $(FLAGS) --Mdir "$(BUILD_DIR)" $(SOURCES)

run: build
	"$(BINARY)" "+verilator+coverage+file+$(COVERAGE_FILE)" $(RUN_ARGS)
	$(MAKE) $(if $(filter 1,$(OPEN_COVERAGE)),coverage-open,coverage)

coverage:
	mkdir -p "$(ROOT)/build"
	"$(VERILATOR_COVERAGE)" --write-info "$(ROOT)/build/coverage-all.info" "$(COVERAGE_FILE)"
	lcov --quiet --extract "$(ROOT)/build/coverage-all.info" "$(ROOT)/*" --output-file "$(COVERAGE_INFO)"
	genhtml --quiet --prefix "$(ROOT)" --output-directory "$(COVERAGE_HTML)" "$(COVERAGE_INFO)"
	@printf 'Coverage report: %s/index.html\n' "$(COVERAGE_HTML)"

coverage-open: coverage
	@report="$(COVERAGE_HTML)/index.html"; \
	if command -v wslview >/dev/null 2>&1; then \
	  wslview "$$report"; \
	elif command -v powershell.exe >/dev/null 2>&1 && command -v wslpath >/dev/null 2>&1; then \
	  powershell.exe -NoProfile -NonInteractive -Command "Start-Process -FilePath '$$(wslpath -w "$$report")'"; \
	elif command -v xdg-open >/dev/null 2>&1; then \
	  xdg-open "$$report"; \
	else \
	  printf 'No browser launcher found. Open %s manually.\n' "$$report"; \
	fi || printf 'Browser launch failed. Open %s manually.\n' "$$report"

lint:
	$(VERILATOR) --lint-only $(FLAGS) $(SOURCES)

clean:
	rm -rf -- "$(BUILD_DIR)"

help:
	@printf '%s\n' \
	  'make -C sim         Build the UVM simulation (default).' \
	  'make -C sim run     Build, simulate, generate HTML coverage, and open it.' \
	  'make -C sim coverage       Generate HTML from existing coverage data.' \
	  'make -C sim coverage-open  Generate and open the coverage report.' \
	  'make -C sim run OPEN_COVERAGE=0  Generate the report without opening a browser.' \
	  'make -C sim lint    Lint the complete RTL/UVM project.' \
	  'make -C sim clean   Remove build/uvm only.' \
	  'Overrides: VERILATOR=/path/to/verilator UVM_HOME=/path/to/uvm JOBS=2' \
	  'Runtime options: make -C sim run RUN_ARGS="+verilator+seed+123"' \
	  'Coverage output: build/coverage.dat (override with COVERAGE_FILE=...)'

