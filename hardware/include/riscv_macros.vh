//-----------------------------------------------------------------------------------
// File Name    : riscv_macros.vh
//
// File Purpose : opcode mappings for the RISCV core
//
// NSF Award #  : 21143285
//-----------------------------------------------------------------------------------

`ifndef _RISCV_MACROS_VH_
`define _RISCV_MACROS_VH_

// instruction encodings
`define ENCODING_NONE                        128'b0000000000000000
`define ENCODING_LUI                         128'b0000000000000001
`define ENCODING_AUIPC                       128'b0000000000000010
`define ENCODING_ARITH_REG                   128'b0000000000000100
`define ENCODING_ARITH_IMM                   128'b0000000000001000
`define ENCODING_JAL                         128'b0000000000010000
`define ENCODING_JALR                        128'b0000000000100000
`define ENCODING_BRANCH                      128'b0000000001000000
`define ENCODING_LOAD                        128'b0000000010000000
`define ENCODING_STORE                       128'b0000000100000000
`define ENCODING_FLOAD                       128'b0000001000000000
`define ENCODING_FSTORE                      128'b0000010000000000
`define ENCODING_FMADD                       128'b0000100000000000
`define ENCODING_FMSUB                       128'b0001000000000000
`define ENCODING_FNMSUB                      128'b0010000000000000
`define ENCODING_FNMADD                      128'b0100000000000000
`define ENCODING_FARITH                      128'b1000000000000000
`define ENCODING_SYSTEM                      128'h00000000000000000000000000010000 // bit 16


// opcode encodings - I
`define RV32I_OPCODE_LUI                     7'b0110111
`define RV32I_OPCODE_AUIPC                   7'b0010111
`define RV32I_OPCODE_JAL                     7'b1101111
`define RV32I_OPCODE_JALR                    7'b1100111
`define RV32I_OPCODE_BRANCH                  7'b1100011
`define RV32I_OPCODE_LOAD                    7'b0000011
`define RV32I_OPCODE_STORE                   7'b0100011
`define RV32I_OPCODE_ARITH_IMM               7'b0010011
`define RV32I_OPCODE_ARITH_REG               7'b0110011 // note: also opcode for RV32M
`define RV32I_OPCODE_SYSTEM                  7'b1110011
//`define RV32I_OPCODE_FENCE                 7'b0001111
//`define RV32I_OPCODE_ENVCALL               7'b1110011



// opcode encodings - M
`define RV32M_OPCODE                         7'b0110011
`define RV32F_OPCODE_LOAD                    7'b0000111
`define RV32F_OPCODE_STORE                   7'b0100111
`define RV32F_OPCODE_FMADD                   7'b1000011
`define RV32F_OPCODE_FMSUB                   7'b1000111
`define RV32F_OPCODE_FNMSUB                  7'b1001011
`define RV32F_OPCODE_FNMADD                  7'b1001111
`define RV32F_OPCODE_ARITH                   7'b1010011

// opcode encodings - F
`define RV32F_OPCODE_LOAD                    7'b0000111
`define RV32F_OPCODE_STORE                   7'b0100111
`define RV32F_OPCODE_FMADD                   7'b1000011
`define RV32F_OPCODE_FMSUB                   7'b1000111
`define RV32F_OPCODE_FNMSUB                  7'b1001011
`define RV32F_OPCODE_FNMADD                  7'b1001111
`define RV32F_OPCODE_ARITH                   7'b1010011


// func3 encodings - I
`define RV32I_FUNC3_ARITH_ADDI               3'b000
`define RV32I_FUNC3_ARITH_SLLI               3'b001
`define RV32I_FUNC3_ARITH_SLTI               3'b010
`define RV32I_FUNC3_ARITH_SLTIU              3'b011
`define RV32I_FUNC3_ARITH_XORI               3'b100
`define RV32I_FUNC3_ARITH_SRLI               3'b101
`define RV32I_FUNC3_ARITH_SRAI               3'b101
`define RV32I_FUNC3_ARITH_ORI                3'b110
`define RV32I_FUNC3_ARITH_ANDI               3'b111
`define RV32I_FUNC3_ARITH_ADD                3'b000
`define RV32I_FUNC3_ARITH_SUB                3'b000
`define RV32I_FUNC3_ARITH_SLL                3'b001
`define RV32I_FUNC3_ARITH_SLT                3'b010
`define RV32I_FUNC3_ARITH_SLTU               3'b011
`define RV32I_FUNC3_ARITH_XOR                3'b100
`define RV32I_FUNC3_ARITH_SRL                3'b101
`define RV32I_FUNC3_ARITH_SRA                3'b101
`define RV32I_FUNC3_ARITH_OR                 3'b110
`define RV32I_FUNC3_ARITH_AND                3'b111
`define RV32I_FUNC3_BRANCH_BEQ               3'b000
`define RV32I_FUNC3_BRANCH_BNE               3'b001
`define RV32I_FUNC3_BRANCH_BLT               3'b100
`define RV32I_FUNC3_BRANCH_BGE               3'b101
`define RV32I_FUNC3_BRANCH_BLTU              3'b110
`define RV32I_FUNC3_BRANCH_BGEU              3'b111
`define RV32I_FUNC3_LOAD_BYTE                3'b000
`define RV32I_FUNC3_LOAD_HWORD               3'b001
`define RV32I_FUNC3_LOAD_WORD                3'b010
`define RV32I_FUNC3_LOAD_UBYTE               3'b100
`define RV32I_FUNC3_LOAD_UHWORD              3'b101
`define RV32I_FUNC3_STORE_BYTE               3'b000
`define RV32I_FUNC3_STORE_HWORD              3'b001
`define RV32I_FUNC3_STORE_WORD               3'b010

// func3 encodings - M
`define RV32M_FUNC3_MUL                      3'b000
`define RV32M_FUNC3_MULH                     3'b001
`define RV32M_FUNC3_MULHSU                   3'b010
`define RV32M_FUNC3_MULHU                    3'b011
`define RV32M_FUNC3_DIV                      3'b100
`define RV32M_FUNC3_DIVU                     3'b101
`define RV32M_FUNC3_REM                      3'b110
`define RV32M_FUNC3_REMU                     3'b111

// func3 encodings - CSR
`define RV32Zicsr_FUNC3_CSRRW                3'b001
`define RV32Zicsr_FUNC3_CSRRS                3'b010
`define RV32Zicsr_FUNC3_CSRRC                3'b011
`define RV32Zicsr_FUNC3_CSRRWI               3'b101
`define RV32Zicsr_FUNC3_CSRRSI               3'b110
`define RV32Zicsr_FUNC3_CSRRCI               3'b111

// func5 encodings - F
`define RV32F_FUNC5_ADD                      5'b00000
`define RV32F_FUNC5_SUB                      5'b00001
`define RV32F_FUNC5_MUL                      5'b00010
`define RV32F_FUNC5_DIV                      5'b00011
`define RV32F_FUNC5_SGNJ                     5'b00100
`define RV32F_FUNC5_CMP                      5'b10100
`define RV32F_FUNC5_FCVT_FTI                 5'b11000
`define RV32F_FUNC5_SQRT                     5'b01011
`define RV32F_FUNC5_FMIN_MAX                 5'b00101
`define RV32F_FUNC5_MV_WX                    5'b11110
`define RV32F_FUNC5_CLASS                    5'b11100
`define RV32F_FUNC5_FCVT_ITF                 5'b11010
`define RV32F_FUNC5_RM_EQ                    3'b010
`define RV32F_FUNC5_RM_LT                    3'b001
`define RV32F_FUNC5_RM_LE                    3'b000
`define RV32F_FUNC5_RM_CLASS                 3'b001
`define RV32F_FUNCS_RM_MV_WX                 3'b000
`define RV32F_FUNC5_RM_MV_XW                 3'b000
`define RV32F_FUNC5_RM_MIN                   3'b000
`define RV32F_FUNC5_RM_MAX                   3'b001
`define RV32F_FUNC5_RS2_SGN                  5'b00000
`define RV32F_FUNC5_RS2_USGN                 5'b00001
`define RV32F_FUNC5_RM_SGNJ                  3'b000
`define RV32F_FUNC5_RM_SGNJN                 3'b001
`define RV32F_FUNC5_RM_SGNJX                 3'b010

// func7 encodings - I
`define RV32I_FUNC7_ARITH_REG0               7'b0000000
`define RV32I_FUNC7_ARITH_REG1               7'b0100000 // SUB and SRA
`define RV32M_FUNC7                          7'b0000001 // MUL, DIV, etc.

// pointer initializations
`define SP_BASE                              32'h1FFFFFFC
`define SP_BASE_DUALCORE                     32'h0FFFFFFC // Is placed at 10FFFFFC to account for halved RAM in dualcore implem.
`define OUTPUT_PERIPHERAL_BASE               32'h20000000 // byte addressable - read only
`define INPUT_PERIPHERAL_BASE                32'h20000100 // byte addressable - read and write

// state mappings
`define STATE_HART_PIPELINE_DEPENDENCY_STALL 5'b10000
`define STATE_HART_PIPELINE_JUMP             5'b00001

// size of branch prediction buffer
`define BRANCH_TABLE_BUFFER_SIZE             64


`endif // RISCV_H_
