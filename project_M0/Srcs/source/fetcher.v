`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 28.10.2020 17:25:55
// Design Name:
// Module Name: fetcher
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

module fetcher(
         input Hold_Flag_i,
         input clk,
         input rst,

         input [`REG_BUS]Instruction_i,
         output [`REG_BUS]Instruction_o,

         input [`ROM_ADDR_BUS]PC_i,
         output[`ROM_ADDR_BUS]PC_o
       );



pipeline #(
           .WIDTH (32)
         )
         inst_ff(
           .clk        (clk),
           .rst        (rst),
           .hold       (Hold_Flag_i),
           .InputData  (Instruction_i),
           .OutputData (Instruction_o)
         );

pipeline #(
           .WIDTH (32)
         )
         inst_addr_ff(
           .clk        (clk),
           .rst        (rst),
           .hold       (Hold_Flag_i),
           .InputData  (PC_i),
           .OutputData (PC_o)
         );


//assign Instruction_o = Instruction_i;
//assign PC_o = PC_i;

endmodule
