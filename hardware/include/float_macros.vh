//-----------------------------------------------------------------------------------
// File Name    : float_macros.sv
//
// File Purpose : macros that define latencies for floating point operations.
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------

`ifndef _FLOAT_MACROS_VH_
`define _FLOAT_MACROS_VH_

`define FSQRT_LATENCY        4'b0110
`define FMUL_LATENCY         4'b0010
`define FDIV_LATENCY         4'b1010
`define COMPARE_LATENCY      4'b0000
`define FADD_SUB_LATENCY     4'b0011
`define FMA_LATENCY          `FADD_SUB_LATENCY + `FMUL_LATENCY
`define FLOAT_TO_INT_LATENCY 4'b0001
`define INT_TO_FLOAT_LATENCY 4'b0001
`define CLASS_LATENCY        4'b0001

`endif
