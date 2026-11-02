//-----------------------------------------------------------------------------------
// File Name    : etc_macros.vh
//
// File Purpose : macros used by the ETC. Mostly relating to JTAG-UART bridge.
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------
`ifndef _ETC_MACROS_VH_
`define _ETC_MACROS_VH_

`define UART_JTAG_N_BYTES_PER_PACKET  4
`define UART_JTAG_BW_BYTES_PER_PACKET 2
`define UART_JTAG_BW_PACKET           8 * `UART_JTAG_N_BYTES_PER_PACKET

`endif