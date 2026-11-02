//-----------------------------------------------------------------------------------
// Filename     : build_macros.vh
//
// File purpose : Defines the hierarchy of compilation based off the user defined
//                macros in an instance of top.vh.
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------

`ifndef _BUILD_MACROS_VH_
`define _BUILD_MACROS_VH_

// formally derive the structure of the L1 ICACHE
`ifdef INST_CACHE_FA
    `define INST_CACHE_STRUCTURE         `ID_CACHE_FULLY_ASSOCIATIVE
`elsif INST_CACHE_2WAY
    `define INST_CACHE_STRUCTURE         `ID_CACHE_2WAY_SET_ASSOCIATIVE
`elsif INST_CACHE_4WAY
    `define INST_CACHE_STRUCTURE         `ID_CACHE_4WAY_SET_ASSOCIATIVE
`elsif INST_CACHE_8WAY
    `define INST_CACHE_STRUCTURE         `ID_CACHE_8WAY_SET_ASSOCIATIVE
`elsif INST_CACHE_16WAY
    `define INST_CACHE_STRUCTURE         `ID_CACHE_16WAY_SET_ASSOCIATIVE
`endif

// formally derive the eviction policy of the L1 ICACHE
`ifdef INST_POLICY_RANDOM
    `define INST_CACHE_POLICY             `ID_CACHE_RANDOM
    `define INST_CACHE_INIT             1'b0
`elsif INST_POLICY_FIFO
    `define INST_CACHE_POLICY             `ID_CACHE_FIFO
    `define INST_CACHE_INIT             1'b0
`elsif INST_POLICY_LRU
    `define INST_CACHE_POLICY             `ID_CACHE_LRU
    `define INST_CACHE_INIT             1'b0
`elsif INST_POLICY_PLRU
    `define INST_CACHE_POLICY             `ID_CACHE_PLRU
    `define INST_CACHE_INIT             1'b0
`elsif INST_POLICY_SRRIP
    `define INST_CACHE_POLICY             `ID_CACHE_SRRIP
    `define INST_CACHE_INIT             1'b0
`elsif INST_POLICY_MRU
    `define INST_CACHE_POLICY             `ID_CACHE_MRU
    `define INST_CACHE_INIT             1'b0
`endif

// formally derive the structure of the L1 DCACHE
`ifdef DATA_CACHE_FA
    `define DATA_CACHE_STRUCTURE         `ID_CACHE_FULLY_ASSOCIATIVE
`elsif DATA_CACHE_2WAY
    `define DATA_CACHE_STRUCTURE         `ID_CACHE_2WAY_SET_ASSOCIATIVE
`elsif DATA_CACHE_4WAY
    `define DATA_CACHE_STRUCTURE         `ID_CACHE_4WAY_SET_ASSOCIATIVE
`elsif DATA_CACHE_8WAY
    `define DATA_CACHE_STRUCTURE         `ID_CACHE_8WAY_SET_ASSOCIATIVE
`elsif DATA_CACHE_16WAY
    `define DATA_CACHE_STRUCTURE         `ID_CACHE_16WAY_SET_ASSOCIATIVE
`endif

// formally derive the eviction policy of the L1 DCACHE
`ifdef DATA_POLICY_RANDOM
    `define DATA_CACHE_POLICY             `ID_CACHE_RANDOM
    `define DATA_CACHE_INIT             1'b1
`elsif DATA_POLICY_FIFO
    `define DATA_CACHE_POLICY             `ID_CACHE_FIFO
    `define DATA_CACHE_INIT             1'b1
`elsif DATA_POLICY_LRU
    `define DATA_CACHE_POLICY             `ID_CACHE_LRU
    `define DATA_CACHE_INIT             1'b1
`elsif DATA_POLICY_PLRU
    `define DATA_CACHE_POLICY             `ID_CACHE_PLRU
    `define DATA_CACHE_INIT             1'b1
`elsif DATA_POLICY_SRRIP
    `define DATA_CACHE_POLICY             `ID_CACHE_SRRIP
    `define DATA_CACHE_INIT             1'b1
`elsif DATA_POLICY_MRU
    `define DATA_CACHE_POLICY             `ID_CACHE_MRU
    `define DATA_CACHE_INIT             1'b1
`elsif DATA_POLICY_DLEASE
    `define DATA_CACHE_POLICY             `ID_CACHE_DLEASE
    `define DATA_CACHE_INIT             1'b0
`elsif DATA_POLICY_SLIDER
    `define DATA_CACHE_POLICY             `ID_CACHE_SLIDER
    `define DATA_CACHE_INIT             1'b0
`endif

// formally derive the structure of the L2 CACHE
// --> set to FA if not defined for compilation purposes
`ifdef MULTI_LEVEL_CACHE
    `ifdef L2_CACHE_FA
        `define L2_CACHE_STRUCTURE         `ID_CACHE_FULLY_ASSOCIATIVE
    `elsif L2_CACHE_2WAY
        `define L2_CACHE_STRUCTURE         `ID_CACHE_2WAY_SET_ASSOCIATIVE
    `elsif L2_CACHE_4WAY
        `define L2_CACHE_STRUCTURE         `ID_CACHE_4WAY_SET_ASSOCIATIVE
    `elsif L2_CACHE_8WAY
        `define L2_CACHE_STRUCTURE         `ID_CACHE_8WAY_SET_ASSOCIATIVE
    `elsif L2_CACHE_16WAY
        `define L2_CACHE_STRUCTURE         `ID_CACHE_16WAY_SET_ASSOCIATIVE
    `endif
`else
    `define L2_CACHE_STRUCTURE              `ID_CACHE_FULLY_ASSOCIATIVE
`endif

// formally derive the eviction policy of the L2 CACHE
// --> set to RANDOM if not defined for compilation purposes
`ifdef MULTI_LEVEL_CACHE
    `ifdef L2_POLICY_RANDOM
        `define L2_CACHE_POLICY             `ID_CACHE_RANDOM
        `define L2_CACHE_INIT             1'b1
    `elsif L2_POLICY_FIFO
        `define L2_CACHE_POLICY             `ID_CACHE_FIFO
        `define L2_CACHE_INIT             1'b1
    `elsif L2_POLICY_LRU
        `define L2_CACHE_POLICY             `ID_CACHE_LRU
        `define L2_CACHE_INIT             1'b1
    `elsif L2_POLICY_PLRU
        `define L2_CACHE_POLICY             `ID_CACHE_PLRU
        `define L2_CACHE_INIT             1'b1
    `elsif L2_POLICY_SRRIP
        `define L2_CACHE_POLICY             `ID_CACHE_SRRIP
        `define L2_CACHE_INIT             1'b1
    `elsif L2_POLICY_MRU
        `define L2_CACHE_POLICY             `ID_CACHE_MRU
        `define L2_CACHE_INIT             1'b1
    `elsif L2_POLICY_DLEASE
        `define L2_CACHE_POLICY             `ID_CACHE_DLEASE
        `define L2_CACHE_INIT             1'b0
    `elsif L2_POLICY_SLIDER
       `define L2_CACHE_POLICY            `ID_CACHE_SLIDER
       `define L2_CACHE_INIT           1'b0
    `endif
`else
    `define L2_CACHE_POLICY             `ID_CACHE_RANDOM
        `define L2_CACHE_INIT             1'b1
`endif


// figure out the set sizes of the L1-I, L1-D, and L2
`ifdef INST_CACHE_FA
    `define INST_CACHE_SET_SIZE    `INST_CACHE_BLOCK_CAPACITY
`else
    `define INST_CACHE_SET_SIZE    `INST_CACHE_STRUCTURE>>24
`endif
`ifdef L2_CACHE_FA
    `define L2_CACHE_SET_SIZE    `L2_CACHE_BLOCK_CAPACITY
`else
    `define L2_CACHE_SET_SIZE    `L2_CACHE_STRUCTURE>>24
`endif
`ifdef DATA_CACHE_FA
    `define DATA_CACHE_SET_SIZE    `DATA_CACHE_BLOCK_CAPACITY
`else
    `define DATA_CACHE_SET_SIZE    `DATA_CACHE_STRUCTURE>>24
`endif

// build optimized evictions - used to communicate with the proxy
`ifdef OPTIMIZED_EVICTION_STRATEGIES
    `define EVICTION_OPTIMIZATIONS 1
`else
    `define EVICTION_OPTIMIZATIONS 0
`endif

// used to communicate slider metrics to the proxy
`ifdef SLIDER
    `define SLIDER_PERF 1
`else
    `define SLIDER_PERF 0
`endif

// used to communicate L2 metrics to the proxy
`ifdef MULTI_LEVEL_CACHE
    `define L2_PRESENT 1
`else
    `define L2_PRESENT 0
`endif

`endif
