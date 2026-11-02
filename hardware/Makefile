PROJ_DIR = ./top
PLRU_PROJECTS      := system_fa_plru_perfected 
LEASE_PROJECTS     := system_fa_dynamic_lease_perfected
SLIDER_PROJECTS    := system_fa_slider_perfected
PLRU_ML_PROJECTS   := system_fa_plru_multi_level
LEASE_ML_PROJECTS  := system_fa_dynamic_lease_multi_level
SLIDER_ML_PROJECTS := system_fa_slider_multi_level
CWD := $(CURDIR)

LEASE_METRICS := TRACKER NONE TRACER
PLRU_METRICS := NONE SAMPLER TRACER
OPTS := NONE OPTIMIZED_EVICTION_STRATEGIES
CACHE_SIZE := 64 128

.PHONY: all all_sl all_ml plru lease plru_ml lease_ml slider_ml test logs Makefile clean slider



all: plru lease slider plru_ml lease_ml slider_ml

all_sl: plru lease slider

all_ml: plru_ml lease_ml slider_ml

plru: $(foreach proj, $(PLRU_PROJECTS), $(foreach met, $(PLRU_METRICS), $(foreach cs, $(CACHE_SIZE), $(proj)__$(met)__NONE__$(cs))))

lease: $(foreach proj, $(LEASE_PROJECTS), $(foreach met, $(LEASE_METRICS), $(foreach opt, $(OPTS), $(foreach cs, $(CACHE_SIZE), $(proj)__$(met)__$(opt)__$(cs)))))

slider: $(foreach proj, $(SLIDER_PROJECTS), $(foreach met, $(LEASE_METRICS), $(proj)__$(met)__NONE__128))

plru_ml: $(foreach proj, $(PLRU_ML_PROJECTS), $(foreach met, $(LEASE_METRICS), $(proj)__$(met)__NONE__128__256))

lease_ml: $(foreach proj, $(LEASE_ML_PROJECTS), $(foreach met, $(LEASE_METRICS), $(proj)__$(met)__NONE__128__256))

slider_ml: $(foreach proj, $(SLIDER_ML_PROJECTS), $(foreach met, $(LEASE_METRICS), $(proj)__$(met)__NONE__128))


test: system_fa_plru_perfected__TRACER__NONE__128

%: logs
	@echo "Building target: $@"
	$(eval PARTS := $(subst __, ,$@))		@# substitute __ for space because project dir has _ in name
	$(eval PROJ := $(word 1, $(PARTS)))
	$(eval MET := $(word 2, $(PARTS)))
	$(eval OPT := $(word 3, $(PARTS)))
	$(eval CS := $(word 4, $(PARTS)))



	@sh -c '\
		MACROS=""; \
		if [ "$(MET)" != "NONE" ]; then \
			MACROS="$$MACROS --verilog_macro=$(MET)"; \
		fi; \
		if [ "$(OPT)" != "NONE" ]; then \
			MACROS="$$MACROS --verilog_macro=$(OPT)"; \
		fi; \
		MACROS="$$MACROS --verilog_macro=INST_CACHE_BLOCK_CAPACITY=$(CS)"; \
		MACROS="$$MACROS --verilog_macro=DATA_CACHE_BLOCK_CAPACITY=$(CS)"; \
		echo "$$MACROS"; \
		cd "$(PROJ_DIR)/$(PROJ)/project"; \
		/opt/intelFPGA/22.1std/quartus/bin/quartus_map \
			--read_settings_files=on \
			--write_settings_files=off \
			$$MACROS \
			top -c top > $(CWD)/logs/top_$(MET)_$(OPT)_$(CS)_map.log; \
		/opt/intelFPGA/22.1std/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off top -c top > $(CWD)/logs/top_$(MET)_$(OPT)_$(CS)_fit.log; \
		/opt/intelFPGA/22.1std/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off top -c top > $(CWD)/logs/top_$(MET)_$(OPT)_$(CS)_asm.log; \
		cp output_files/top.sof output_files/top_$(MET)_$(OPT)_$(CS).sof; \
	'

# Needed for stupid reasons
Makefile:

logs: 
	@mkdir -p logs

clean:
	@rm -rf logs/
