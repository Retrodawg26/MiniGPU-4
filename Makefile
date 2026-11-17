.PHONY: help mux arithmetic regfile controller test
.PHONY: lint lint-mux lint-arithmetic lint-regfile lint-controller clean

VERILATOR := verilator
VERILATOR_FLAGS := --binary --timing -Wall

MUX_DIR := sim/obj_mux2
ARITHMETIC_DIR := sim/obj_arithmetic_lane
REGFILE_DIR := sim/obj_vector_regfile
CONTROLLER_DIR := sim/obj_instruction_controller

MUX_RTL := practice/mux2.sv
MUX_TB := practice/tb_mux2.sv
ARITHMETIC_RTL := rtl/arithmetic_lane.sv
ARITHMETIC_TB := tb/tb_arithmetic_lane.sv
REGFILE_RTL := rtl/vector_regfile.sv
REGFILE_TB := tb/tb_vector_regfile.sv
CONTROLLER_RTL := rtl/instruction_controller.sv
CONTROLLER_TB := tb/tb_instruction_controller.sv

MUX_SIM := $(MUX_DIR)/Vtb_mux2
ARITHMETIC_SIM := $(ARITHMETIC_DIR)/Vtb_arithmetic_lane
REGFILE_SIM := $(REGFILE_DIR)/Vtb_vector_regfile
CONTROLLER_SIM := $(CONTROLLER_DIR)/Vtb_instruction_controller

help:
	@printf '%s\n' \
		"Available commands:" \
		"  make mux              Compile and run the MUX testbench" \
		"  make arithmetic       Compile and run the arithmetic lane testbench" \
		"  make regfile          Compile and run the vector register file testbench" \
		"  make controller       Compile and run the controller testbench with VCD tracing" \
		"  make test             Run all testbenches" \
		"  make lint             Lint all three RTL modules" \
		"  make lint-mux         Lint the MUX RTL" \
		"  make lint-arithmetic  Lint the arithmetic lane RTL" \
		"  make lint-regfile     Lint the vector register file RTL" \
		"  make lint-controller  Lint the instruction controller RTL" \
		"  make clean            Remove generated Verilator build files" \
		"  make help             Display this help message"

# Verilator creates the executable during its generated build process.
$(MUX_SIM): $(MUX_RTL) $(MUX_TB)
	@mkdir -p $(MUX_DIR)
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module tb_mux2 \
		--Mdir $(MUX_DIR) $(MUX_RTL) $(MUX_TB)

$(ARITHMETIC_SIM): $(ARITHMETIC_RTL) $(ARITHMETIC_TB)
	@mkdir -p $(ARITHMETIC_DIR)
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module tb_arithmetic_lane \
		--Mdir $(ARITHMETIC_DIR) $(ARITHMETIC_RTL) $(ARITHMETIC_TB)

$(REGFILE_SIM): $(REGFILE_RTL) $(REGFILE_TB)
	@mkdir -p $(REGFILE_DIR)
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module tb_vector_regfile \
		--Mdir $(REGFILE_DIR) $(REGFILE_RTL) $(REGFILE_TB)

# This testbench uses $dumpvars, so tracing must be enabled at compile time.
$(CONTROLLER_SIM): $(CONTROLLER_RTL) $(CONTROLLER_TB)
	@mkdir -p $(CONTROLLER_DIR)
	$(VERILATOR) $(VERILATOR_FLAGS) --trace --top-module tb_instruction_controller \
		--Mdir $(CONTROLLER_DIR) $(CONTROLLER_RTL) $(CONTROLLER_TB)

mux: $(MUX_SIM)
	@echo "== PASS/FAIL: MUX testbench ==" 
	./$(MUX_SIM)

arithmetic: $(ARITHMETIC_SIM)
	@echo "== PASS/FAIL: arithmetic lane testbench ==" 
	./$(ARITHMETIC_SIM)

regfile: $(REGFILE_SIM)
	@echo "== PASS/FAIL: vector register file testbench ==" 
	./$(REGFILE_SIM)

controller: $(CONTROLLER_SIM)
	@echo "== PASS/FAIL: instruction controller testbench =="
	./$(CONTROLLER_SIM)

test: mux arithmetic regfile controller
	@echo "All testbenches passed."

lint-mux:
	$(VERILATOR) --lint-only -Wall $(MUX_RTL)

lint-arithmetic:
	$(VERILATOR) --lint-only -Wall $(ARITHMETIC_RTL)

lint-regfile:
	$(VERILATOR) --lint-only -Wall $(REGFILE_RTL)

lint-controller:
	$(VERILATOR) --lint-only -Wall $(CONTROLLER_RTL)

lint: lint-mux lint-arithmetic lint-regfile lint-controller

clean:
	rm -rf $(MUX_DIR) $(ARITHMETIC_DIR) $(REGFILE_DIR) $(CONTROLLER_DIR)
