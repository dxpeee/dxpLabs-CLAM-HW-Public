//-----------------------------------------------------------------------------------
// Filename     : cache_macros.vh
//
// File purpose : Basic cache defines and address mappings.
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------

`ifndef _CACHE_MACROS_VH_
`define _CACHE_MACROS_VH_


`define CACHE_WORDS_PER_BLOCK               16                  // 16 words/block
`define BW_BLOCK                            4


// cache software information

// slider configuration
`define SLIDER_CONFIG_BASE_B                29'h01ff0000
`define SLIDER_CONFIG_BASE_W                27'h007fc000
`define SLIDER_TABLE_ADDR_BASE_B            29'h01ff0040
`define SLIDER_TABLE_ADDR_BASE_W            24'h007fc010

// Lease configuration
`define LEASE_CONFIG_BASE_B                 29'h01ff0000
`define LEASE_CONFIG_BASE_W                 27'h007fc000
`define LEASE_REF_ADDR_BASE_B               29'h01ff0040
`define LEASE_REF_ADDR_BASE_W               24'h007fc010

`define LEASE_CONFIG_BASE_B_C0              29'h00ff0000
`define LEASE_CONFIG_BASE_W_C0              27'h003fc000
`define LEASE_REF_ADDR_BASE_B_C0            29'h00ff0040
`define LEASE_REF_ADDR_BASE_W_C0            24'h003fc010

`define LEASE_CONFIG_BASE_B_C1              29'h10ff0000
`define LEASE_CONFIG_BASE_W_C1              27'h043fc000
`define LEASE_REF_ADDR_BASE_B_C1            29'h10ff0040
`define LEASE_REF_ADDR_BASE_W_C1            27'h043fc010

// misc cache information
// --> maps user defined options to numbers
`define ID_CACHE_RANDOM                     32'h00000000
`define ID_CACHE_FIFO                       32'h00000001
`define ID_CACHE_LRU                        32'h00000002
`define ID_CACHE_MRU                        32'h00000003
`define ID_CACHE_PLRU                       32'h00000004
`define ID_CACHE_SRRIP                      32'h00000005
`define ID_CACHE_DLEASE                     32'h00000008
`define ID_CACHE_SLIDER                     32'h00000009


`define ID_CACHE_FULLY_ASSOCIATIVE          32'h00000000
`define ID_CACHE_2WAY_SET_ASSOCIATIVE       32'h02000000
`define ID_CACHE_4WAY_SET_ASSOCIATIVE       32'h04000000
`define ID_CACHE_8WAY_SET_ASSOCIATIVE       32'h08000000
`define ID_CACHE_16WAY_SET_ASSOCIATIVE      32'h10000000

// derived cache macros - L-1 I
`define INST_BW_CACHE_CAPACITY              (`CLOG2(`INST_CACHE_BLOCK_CAPACITY))
`define INST_BW_CACHE_ADDR_FULL             (`INST_BW_CACHE_CAPACITY + `BW_BLOCK)
`define INST_BW_GRP                         (`CLOG2(`INST_CACHE_SET_SIZE))
`define INST_BW_SET                         (`INST_BW_CACHE_CAPACITY - `INST_BW_GRP)
`define INST_BW_TAG                         (`BW_WORD_ADDR - `BW_BLOCK - `INST_BW_SET)
`define INST_N_SET                          (2**(`INST_BW_SET))

// derived cache macros - L-1 D
`define DATA_BW_CACHE_CAPACITY              (`CLOG2(`DATA_CACHE_BLOCK_CAPACITY))
`define DATA_BW_CACHE_ADDR_FULL             (`DATA_BW_CACHE_CAPACITY + `BW_BLOCK)
`define DATA_BW_GRP                         (`CLOG2(`DATA_CACHE_SET_SIZE))
`define DATA_BW_SET                         (`DATA_BW_CACHE_CAPACITY - `DATA_BW_GRP)
`define DATA_BW_TAG                         (`BW_WORD_ADDR - `BW_BLOCK - `DATA_BW_SET)
`define DATA_N_SET                          (2**(`DATA_BW_SET))

// derived cache macros - L2
`define L2_BW_CACHE_CAPACITY                (`CLOG2(`L2_CACHE_BLOCK_CAPACITY))
`define L2_BW_CACHE_ADDR_FULL               (`L2_CACHE_BLOCK_CAPACITY + `BW_BLOCK)
`define L2_BW_GRP                           (`CLOG2(`L2_CACHE_SET_SIZE))
`define L2_BW_SET                           (`L2_BW_CACHE_CAPACITY - `L2_BW_GRP)
`define L2_BW_TAG                           (`BW_WORD_ADDR - `BW_BLOCK - `L2_BW_SET)
`define L2_N_SET                            (2**(`L2_BW_SET))

`define MIN_DATA_COLLECTION                 0
`define MAX_DATA_COLLECTION                 1

// derived slider macros
`define SLIDER_ADDR_BW                      8

`endif // _CACHE_H_
