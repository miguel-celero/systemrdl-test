# Define the SystemRDL source file
TOP_NAME 	  := fir_filter
REGMAP_NAME   := $(TOP_NAME)_regmap
REGFILE_NAME  := $(TOP_NAME)_regfile
SYSTEMRDL_TOP := $(REGMAP_NAME).rdl
SYSTEMRDL_RFL := $(REGFILE_NAME).rdl
SYSTEMRDL_SRC := $(SYSTEMRDL_TOP) $(SYSTEMRDL_RFL)

# Define output directories
OUTPUT_DIR := output
RTL_DIR := $(OUTPUT_DIR)/rtl
UVM_DIR := $(OUTPUT_DIR)/uvm
DOC_DIR := $(OUTPUT_DIR)/doc
SW_DIR := $(OUTPUT_DIR)/sw

# Define output files
RTL_PATH := $(RTL_DIR)/$(REGMAP_NAME).sv
UVM_PATH := $(UVM_DIR)/$(REGMAP_NAME).sv
DOC_PATH := $(DOC_DIR)/index.html
SW_PATH := $(SW_DIR)/$(REGMAP_NAME).h

# Define CPU interface type (modify as needed)
# CPU_IF := passthrough
CPU_IF := axi4-lite

# Default target
all: $(RTL_PATH) $(UVM_PATH) $(DOC_PATH) $(SW_PATH)

# Create output directories
$(OUTPUT_DIR):
	mkdir -p $(RTL_DIR) $(UVM_DIR) $(DOC_DIR) $(SW_DIR)

# Generate SystemVerilog RAL model (regblock)
$(RTL_PATH): $(SYSTEMRDL_SRC) | $(OUTPUT_DIR)
	@echo "Generating SystemVerilog RAL model (regblock)..."
	peakrdl regblock -o $(RTL_DIR) --cpuif $(CPU_IF) $(SYSTEMRDL_TOP)

# Generate UVM model
$(UVM_PATH): $(SYSTEMRDL_SRC) | $(OUTPUT_DIR)
	@echo "Generating UVM model..."
	peakrdl uvm $(SYSTEMRDL_TOP) -o $(UVM_PATH)

# Generate HTML documentation
$(DOC_PATH): $(SYSTEMRDL_SRC) | $(OUTPUT_DIR)
	@echo "Generating HTML documentation..."
	peakrdl html $(SYSTEMRDL_TOP) -o $(DOC_DIR)

# Generate C headers
$(SW_PATH): $(SYSTEMRDL_SRC) | $(OUTPUT_DIR)
	@echo "Generating C headers..."
	peakrdl c-header $(SYSTEMRDL_TOP) -o $(SW_PATH)

# Clean generated files
clean:
	@echo "Cleaning up..."
	rm -rf $(OUTPUT_DIR)

# Help target
help:
	@echo "Available targets:"
	@echo "  all      : Generate all outputs (default)"
	@echo "  clean    : Remove generated files"
	@echo "  help     : Display this help message"

.PHONY: all clean help
