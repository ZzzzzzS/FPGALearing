`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.11.2020 22:35:18
// Design Name:
// Module Name: Id2Ex
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

module Id2Ex(
         input clk,
         input rst,
         input hold,

         input [`REG_BUS]Instruction_i,
         input [`REG_BUS]Opt1_i,
         input [`REG_BUS]Opt2_i,
         input [7:0]Inst_Type_i,
         input  [`OPT_BUS]Rd_Addr_i,
         input [`REG_BUS]PC_i,
         input [`REG_BUS]Jump_Offset_i,

         output [`REG_BUS]Instruction_o,
         output [`REG_BUS]Opt1_o,
         output [`REG_BUS]Opt2_o,
         output [7:0]Inst_Type_o,
         output [`OPT_BUS]Rd_Addr_o,
         output [`REG_BUS]PC_o,
         output [`REG_BUS]Jump_Offset_o
       );

pipeline #(
           .WIDTH (32)
         )
         Instruct_pipeline(
           .clk        (clk        ),
           .rst        (rst        ),
           .hold       (hold       ),
           .InputData  (Instruction_i),
           .OutputData (Instruction_o)
         );

pipeline #(
           .WIDTH (32 )
         )
         Opt1_pipeline(
           .clk        (clk        ),
           .rst        (rst        ),
           .hold       (hold       ),
           .InputData  (Opt1_i     ),
           .OutputData (Opt1_o     )
         );

pipeline #(
           .WIDTH (32 )
         )
         Opt2_pipeline(
           .clk        (clk        ),
           .rst        (rst        ),
           .hold       (hold       ),
           .InputData  (Opt2_i     ),
           .OutputData (Opt2_o     )
         );

pipeline #(
           .WIDTH (8 )
         )
         Inst_Type_pipeline(
           .clk        (clk        ),
           .rst        (rst        ),
           .hold       (hold       ),
           .InputData  (Inst_Type_i),
           .OutputData (Inst_Type_o)
         );

pipeline #(
           .WIDTH (5 )
         )
         Rd_Addr_pipeline(
           .clk        (clk        ),
           .rst        (rst        ),
           .hold       (hold       ),
           .InputData  (Rd_Addr_i  ),
           .OutputData (Rd_Addr_o  )
         );

pipeline #(
           .WIDTH (32 )
         )
         PC_pipeline(
           .clk        (clk        ),
           .rst        (rst        ),
           .hold       (hold       ),
           .InputData  (PC_i       ),
           .OutputData (PC_o       )
         );

pipeline #(
           .WIDTH (32 )
         )
         Jump_Offset_pipeline(
           .clk        (clk        ),
           .rst        (rst        ),
           .hold       (hold       ),
           .InputData  (Jump_Offset_i),
           .OutputData (Jump_Offset_o)
         );

endmodule
