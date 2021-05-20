`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04.11.2020 14:01:23
// Design Name:
// Module Name: ram
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

module ram(
         input clk,

         input Write_Enable,
         input [`MEM_ADDR_BUS] Addr_i,
         input [`MEM_BUS] Write_Data_i,
         output reg [`MEM_BUS] Read_Data_o
       );

reg [`MEM_BUS] RAM_Regs[0:1023];

always @(posedge clk)
  begin
    if(Write_Enable)
      begin
        RAM_Regs[Addr_i[31:2]] <= Write_Data_i;
      end
  end

always @(*)
  begin
    Read_Data_o=RAM_Regs[Addr_i[31:2]];
  end

endmodule
