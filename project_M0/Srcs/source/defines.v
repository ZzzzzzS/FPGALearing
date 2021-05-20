`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 28.10.2020 18:11:06
// Design Name:
// Module Name: defines
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
//定义是否允许执行
`define ExALU_ENABLE    8'b00000001 //0
`define ExCSR_ENABLE    8'b00000010 //1
`define ExJMP_ENABLE    8'b00000100 //2
`define ExRW_ENABLE     8'b00001000 //3
`define ExUTYPE_ENABLE  8'b00010000 //4
`define ExFENCE_ENABLE  8'b00100000 //5
//定义指令集 RV32I
`define B_TYPE_JUMP  7'b1100011
`define I_TYPE_LOAD  7'b0000011
`define I_TYPE_ALU   7'b0010011
`define I_TYPE_CSR   7'b1110011
`define I_TYPE_FENCE 7'b0001111
`define S_TYPE_STORE 7'b0100011
`define R_TYPE_ALU   7'b0110011

`define U_TYPE_LUI   7'b0110111
`define U_TYPE_AUIPC 7'b0010111
`define J_TYPE_JAL   7'b1101111
`define I_TYPE_JALR  7'b1100111
`define I_TYPE_ECALL  32'h73
`define I_TYPE_EBREAK 32'h00100073

//B type
`define B_JUMP_BEQ  3'b000
`define B_JUMP_BNE  3'b001
`define B_JUMP_BLT  3'b100
`define B_JUMP_BGE  3'b101
`define B_JUMP_BLTU 3'b110
`define B_JUMP_BGEU 3'b111

//I Load Type
`define I_LOAD_LB   3'b000
`define I_LOAD_LH   3'b001
`define I_LOAD_LW   3'b010
`define I_LOAD_LBU  3'b100
`define I_LOAD_LHU  3'b101

//I R ALU Type
`define I_R_ALU_ADSUB 3'b000
`define I_R_ALU_SLTI  3'b010
`define I_R_ALU_SLTIU 3'b011
`define I_R_ALU_XORI  3'b100
`define I_R_ALU_ORI   3'b110
`define I_R_ALU_ANDI  3'b111
`define I_R_ALU_SLLI  3'b001
`define I_R_ALU_SRLAI 3'b101

//I CSR Type
`define I_CSR_CSRRW  3'b001
`define I_CSR_CSRRS  3'b010
`define I_CSR_CSRRC  3'b011
`define I_CSR_CSRRWI 3'b101
`define I_CSR_CSRRSI 3'b110
`define I_CSR_CSRRCI 3'b111

//I FENCE Type
`define I_FENCE_FENCE  3'b000
`define I_FENCE_FENCEI 3'b001

//S STORE TYPE
`define S_STORE_SB  3'b000
`define S_STORE_SH  3'b001
`define S_STORE_SW  3'b010

`define R_FUNCT7_0  7'b0000000
`define R_FUNCT7_1  7'b0100000
//////////////////////////////////////////////////////////////////////////////////
//定义总线宽度
`define REG_BUS     31:0 //寄存器宽度
`define OPT_BUS      4:0 //操作数地址宽度
`define COD_BUS      6:0 //指令宽度
`define FUNCT3_BUS   2:0 //Funct3宽度
`define CSR_BUS     11:0 //CSR寄存器地址宽度

`define MEM_BUS         31:0 //访存宽度
`define MEM_ADDR_BUS    31:0 //内存地址
`define ROM_ADDR_BUS    31:0 //rom地址
//////////////////////////////////////////////////////////////////////////////////
//定义0
`define REG_ZERO    32'b0
`define FUNCT3_ZERO 3'b0
`define OPT_ZERO    5'b0
`define MEM_ZERO    32'b0
//////////////////////////////////////////////////////////////////////////////////
//定义寄存器数量
`define REG_NUMBER  32
//////////////////////////////////////////////////////////////////////////////////
//定义寄存器初值
`define PC_RESET_VALUE  32'b0
`define REG_RESET_VALUE 32'b0
`define MEM_RESET_ADDR  32'b0
//////////////////////////////////////////////////////////////////////////////////
//定义杂项
`define TRUE    1
`define FALSE   0
