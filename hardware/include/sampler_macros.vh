//-----------------------------------------------------------------------------------
// Filename     : sampler_macros.vh
//
// File purpose : macro used to define sampler buffer size and LFSR period
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------

`ifndef _SAMPLER_MACROS_VH_
`define _SAMPLER_MACROS_VH_



`define BW_CACHE_TAG     23 // word address = [26:0] -> thus remove lower nibble to isolate block [26:4]
`define BW_CACHE_DATA    32
`define N_BUFFER_SAMPLER 13'h1FFF // buffer size



`ifdef MULTI_LEVEL_CACHE

`define LSFR_PERIOD      65536
`define SAMPLE_RATE_BW   `CLOG2(`LSFR_PERIOD)

`ifndef L2_POLICY_DLEASE

`define N_SAMPLER        64   // table entries
`define BW_SAMPLER       8

`else

`define N_SAMPLER        256  // table entries
`define BW_SAMPLER       6

`endif

`else

`define LSFR_PERIOD      65536
`define SAMPLE_RATE_BW   `CLOG2(`LSFR_PERIOD) + 1
`define N_SAMPLER        64 // table entries
`define BW_SAMPLER       8

`endif

`endif
