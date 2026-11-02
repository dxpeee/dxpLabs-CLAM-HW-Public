//-----------------------------------------------------------------------------------
// Filename     : macros.vh
//
// File purpose : includes all derived macros in a project.
//
// NSF Award #  : 2114285
//-----------------------------------------------------------------------------------

`ifndef _MACROS_VH_
`define _MACROS_VH_

// system wide general memory parameters
`define BW_BYTE_ADDR  29 // 512MB
`define BW_WORD_ADDR  27 // 128MW (W = 32b)

// include all macros used in the ETC
`include "etc_macros.vh"

// include all macros used in the HART core
`include "riscv_macros.vh"

// include all macros used by the floating point units in the HART core
`include "float_macros.vh"

// include all macros used in the peripheral system
`include "peripheral_macros.vh"

// include all macros used in the Sampler
`include "sampler_macros.vh"

// include all macros used in the Tracker
`include "tracker_macros.vh"

// include all macros used in the Tracer
`include "tracer_macros.vh"

// include macros used in the memory controller
`include "exception_macros.vh"

// pull in a manually created $clog2 macro
// --> done to comply with Verilog-2001 standards
`include "clog2.vh"

// define some constant macros that are used to construct caches
`include "cache_macros.vh"

// define the system build
`include "build_macros.vh"


`endif