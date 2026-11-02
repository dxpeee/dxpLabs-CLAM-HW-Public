//-----------------------------------------------------------------------------------
// Filename     : peripheral_macros.vh
//
// File purpose : all macros for the peripheral system.
//
// NSF Award #  : 2114285
//-----------------------------------------------------------------------------------

`ifndef _PERIPHERAL_VH_
`define _PERIPHERAL_VH_

// peripheral mapping
// ----------------------------------------------------

// read addresses for cache CPCs
`define COMM_ICACHE       30'h20000080 // read cache0 comm stuff here
`define COMM_DCACHE       30'h20000084 // read cache1 comm stuff here
`define COMM_L2           30'h20000092 // read cache L2 comm stuff here

// TODO - upgrade this after re-integrating mutlicore
`define COMM_CACHE2       30'h20000094 // read cache2 comm stuff here
`define COMM_CACHE3       30'h20000098 // read cache3 comm stuff here (2 and 3 are the caches for core1, naming scheme is a bit confusing. Change this during doc phase.
`define CPC_METRIC_SWITCH 30'h20000088 //switch between tracker, sampler, and L1 cache statistics


// read and write registers for the proxy
`define TIMER_CONTROL     30'h20000100
`define COMM_REGISTER0    30'h20000104 // tells the proxy if a benchmark finishes or ought to be restarted
`define COMM_REGISTER1    30'h20000108
`define COMM_REGISTER2    30'h2000010C
`define STATS_BASE        30'h20000120
`define STATS_BASE_C0     30'h20000120
`define STATS_BASE_C1     30'h20000122
`define COMM_CONTROL      30'h20000110 // processor controls upper 2B, user lower 2B
`define PHASE_REG         30'h20000150
`define RESET_CONTROL     30'h20000124
`define DDR_ACCESS        30'h20000128

`endif // _PERIPHERAL_VH_
