//-----------------------------------------------------------------------------------
// Filename     : rtl.vh
//
// File purpose : includes for all possible RTL files in a project.
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------

`ifndef _RTL_VH_
`define _RTL_VH_

// top-level instances

// the etc
`include "../src/etc/etc_system.v"
`include "../src/etc/etc.v"
`include "../src/etc/fimo_int_mem_cycV.v"
`include "../src/etc/risc_fifo.v"
`include "../src/etc/risc_fimo.v"
`include "../src/etc/risc_mem_translation.v"
`include "../src/etc/uart_jtag_driver.v"
`include "../src/etc/uart_jtag_uart_0.v"
`include "../src/etc/write_translator.v"

// the peripheral memory
`include "../src/peripheral/peripheral_system_3.v"
//`include "../src/peripheral/peripheral_system_3_dual.v"

// the internal system(s)
`include "../src/internal/internal_system_2.sv"
`include "../src/internal/internal_system_2_multi_level.sv"
//`include "../src/internal/internal_system_2_multicore.v"

// risc-v core
`include "../src/core/branch_predictor_2b.v"
`include "../src/core/core_wdt.v"
`include "../src/core/dependency_handler.sv"
`include "../src/core/memory_reference_controller.v"
`include "../src/core/port_switch.sv"
`include "../src/core/riscv_alu_pipelined.sv"
`include "../src/core/riscv_32I_alu.sv"
`include "../src/core/riscv_32M_alu.sv"
`include "../src/core/riscv_32F_alu.sv"
`include "../src/core/riscv_alu_32M_converter.sv"
`include "../src/core/riscv_hart_6stage_pipeline.v"
`include "../src/core/riscv_hart_top.v"
`include "../src/core/instr_decode.sv"
`include "../src/core/stage3_csr_operation.v"
`include "../src/core/stage4_memory_operation.v"
`include "../src/core/target_address_generator.v"
`include "../src/core/udivider32b.v"
`include "../src/core/umultiplier32b.v"


// memory controller elements
`include "../src/mci/memory_controller_internal.v"
`include "../src/mci/memory_controller_internal_2level.v"
`include "../src/mci/mci_core_caches.sv"
`include "../src/mci/mci_caches_mem.sv"
`include "../src/mci/mci_cache_mem.sv"
`include "../src/mci/mci_caches_cache_sc.sv"
//`include "../src/mci/memory_controller_internal_multicore.v"
`include "../src/mci/txrx_buffer_L2_L1.v"
`include "../src/mci//txrx_buffer.v"

// ** cache components **

// l1 cache components
`include "../src/cache_l1/bram_32b_8kB.v"
`include "../src/cache_l1/cache_n_set_all.v"
`include "../src/cache_l1/tag_encoder.sv"
`include "../src/cache_l1/tag_memory_encoder.v"
//`include "../src/cache_l1/tag_memory_n_set_slice.v"
`include "../src/cache_l1/tag_memory_n_set.v"

// l2 cache components
`include "../src/cache_l2/cache_n_set_L2_all.v"
`include "../src/cache_l2/tag_memory_n_set_L2.v"
`include "../src/cache_l2/L2_cache.v"

// cache performance controllers
`include "../src/cpc/cache_performance_controller_all.v"
`include "../src/cpc/cache_performance_controller.v"

// l1 controllers
`include "../src/cont_l1/cache_contr.sv"
`include "../src/cont_l1/cache_contr_dlease.sv"
`include "../src/cont_l1/cache_contr_slider.sv"

// l2 controllers
`include "../src/cont_l2/cache_contr_l2.sv"
`include "../src/cont_l2/cache_contr_l2_dlease.sv"
`include "../src/cont_l2/cache_contr_l2_slider.sv"

// FIFO policy logic
`include "../src/policy_fifo/n_set_cache_fifo_policy_controller.v"

// LRU policy logic
`include "../src/policy_lru/n_set_cache_lru_policy_controller.v"
`include "../src/policy_lru/lru_line_controller.v"

// MRU policy logic
`include "../src/policy_mru/n_set_cache_mru_policy_controller.v"
`include "../src/policy_mru/mru_line_controller.v"

// SRRIP policy logic
`include "../src/policy_srrip/n_set_cache_srrip_policy_controller.v"
`include "../src/policy_srrip/srrip_line_controller.v"

// RANDOM policy logic
`include "../src/policy_random/n_set_cache_random_policy_controller.v"

// PLRU policy logic
`include "../src/policy_plru/n_set_cache_plru_policy_controller.v"
`include "../src/policy_plru/plru_line_controller.v"

// DLEASE components
//`include "../src/dlease/lease_lookup_mux.v"
//`include "../src/dlease/lease_lookup_table_slice.v"
`include "../src/dlease/lease_lookup_table.v"
`include "../src/dlease/lease_registers.v"
`include "../src/dlease/lease_probability_controller.v"

// DLEASE policy logic
`include "../src/policy_dlease/policy_dlease.sv"

// SLIDER components
`include "../src/slider/allocation_window.v"
`include "../src/slider/div_2.v"
`include "../src/slider/div.v"
`include "../src/slider/forced_eviction_window.v"
`include "../src/slider/llt_cam.v"
`include "../src/slider/mapping.v"
`include "../src/slider/occupancy_calc.v"
`include "../src/slider/occupancy_controller.v"
`include "../src/slider/ones_counter.v"
`include "../src/slider/pri_enc.v"
`include "../src/slider/prob_calc.v"
`include "../src/slider/reducer.v"
`include "../src/slider/rolling_eviction_window.v"
`include "../src/slider/slider_table_del_cache_ram_2.v"
`include "../src/slider/slider_table_del_cache_ram.v"
`include "../src/slider/slider_table_del_lease_ram.v"
`include "../src/slider/slider_table_ref_id_ram.v"
`include "../src/slider/slider_table.v"
`include "../src/slider/slider_top.v"

// SLIDER policy logic
`include "../src/policy_slider/policy_slider.v"

// optimized eviction logic
`include "../src/opt_evict/choose_random_from_set.v"
`include "../src/opt_evict/count_set_ones.v"
`include "../src/opt_evict/furthest_reuse.v"
`include "../src/opt_evict/window_element.v"
`include "../src/opt_evict/window_search.v"

// OPTIMIZED DLEASE policy logic
`include "../src/policy_dlease_opt/policy_dlease_opt.v"

// OPTIMIZED SLIDER policy logic
// todo

// SAMPLER logic
`include "../src/sampler/lease_sampler_all.v"

// TRACER logic
`include "../src/tracer/tracer_all.sv"

// TRACKER logic
`include "../src/tracker/cache_line_tracker_4.v"
`include "../src/tracker/eviction_status_tracker.v"
`include "../src/tracker/needle_tracker.v"

// misc. logical blocks used across multiple pieces
`include "../src/misc/barrel_shifter.v"
`include "../src/misc/bram_64kB_32b.v"
`include "../src/misc/bram_128kB_32b.v"
`include "../src/misc/bram_128kB_64b.v"
`include "../src/misc/comparitor_4_to_1.v"
`include "../src/misc/DFF_Custom.v"
`include "../src/misc/identity_comparator.v"
`include "../src/misc/linear_shift_register_7b.v"
`include "../src/misc/linear_shift_register_9b.v"
`include "../src/misc/linear_shift_register_12b.v"
`include "../src/misc/memory_embedded.v"
`include "../src/misc/multi_detect_priority_encoder.v"
`include "../src/misc/multidetect_pri_enc.v"
`include "../src/misc/one_hot_decoder.v"
`include "../src/misc/priority_encoder.v"
`include "../src/misc/seeded_linear_shift_register_12b.v"
`include "../src/misc/seeded_linear_shift_register_16b.v"
`include "../src/misc/tag_match_encoder.v"

`include "../src/tb/model_ddr.sv"

`endif