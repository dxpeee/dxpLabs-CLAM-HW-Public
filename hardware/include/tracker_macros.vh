//-----------------------------------------------------------------------------------
// Filename     : tracker_macros.vh
//
// File purpose : macros used to define tracker buffer sizes
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------

`ifndef _TRACKER_MACROS_VH_
`define _TRACKER_MACROS_VH_

`ifdef MULTI_LEVEL_CACHE
    `define TRACKER_BUFFER_LIMIT 11'h52C
    `define TRACKER_OUT_SEL_WIDTH 6
`else
    `define TRACKER_BUFFER_LIMIT 13'h1249
    `define TRACKER_OUT_SEL_WIDTH 5
`endif

`define EVICT_TRACKER_OUT_SEL_WIDTH 3
`define EVICTION_TRACKER_BUFFER_LIMIT 16'hA3D7
`endif