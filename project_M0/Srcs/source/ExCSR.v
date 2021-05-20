`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01.11.2020 00:16:37
// Design Name:
// Module Name: ExCSR
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

`include "defines.v"

module ExCSR(
         input Enable,
         input [`REG_BUS]Instruction_i,
         input [`REG_BUS]Opt1_i,
         input [`OPT_BUS]Rd_Addr_i,

         input [`CSR_BUS]CSR_Addr_i,
         output [`CSR_BUS]CSR_Addr_o,
         output [`REG_BUS]CSR_o,

         output [`OPT_BUS]Rd_Addr_o,
         output [`REG_BUS]Rd_o
       );
endmodule
