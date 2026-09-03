ROOT      := $(abspath ..)
RTL_DIR   := $(ROOT)/rtl
TB_DIR    := $(ROOT)/tb
WAVES     := $(ROOT)/waves
BUILD     := $(ROOT)/sim/build

TOP       ?= tb
WAVE_FILE ?= $(WAVES)/dump.vcd

VERILATOR       ?= verilator
VERILATOR_FLAGS := --binary --trace --timing -j 0 -Wall \
                   --Mdir $(BUILD) \
                   -I$(RTL_DIR) -I$(TB_DIR) \
                   --top-module $(TOP)

SOURCES := $(RTL_DIR)/cpu.sv $(TB_DIR)/tb.sv

.PHONY: sim wave test clean tools

sim: $(WAVE_FILE)

$(WAVE_FILE): $(SOURCES) | $(WAVES) $(BUILD)
	@echo ">> Verilating $(TOP)"
	$(VERILATOR) $(VERILATOR_FLAGS) $(SOURCES)
	@echo ">> Running simulation"
	cd $(ROOT) && $(BUILD)/V$(TOP)

$(WAVES) $(BUILD):
	@mkdir -p $@

wave: $(WAVE_FILE)
	@echo ">> Wave file ready: $(WAVE_FILE)"
	@echo "   Open it in Cursor/VS Code with the Surfer extension"
	@echo "   (surfer-project.surfer, auto-installed by the devcontainer),"
	@echo "   or on your host with native Surfer:"
	@echo "     macOS:   open -a surfer $(WAVE_FILE)"
	@echo "     Linux:   surfer $(WAVE_FILE)"
	@echo "     Windows: surfer.exe $(WAVE_FILE)"

test: sim

tools:
	@command -v $(VERILATOR) >/dev/null && $(VERILATOR) --version || echo "verilator not found; use the devcontainer or install Verilator >= 5.0"

clean:
	rm -rf $(BUILD) $(WAVES)/*.vcd $(WAVES)/*.fst __pycache__ .pytest_cache
