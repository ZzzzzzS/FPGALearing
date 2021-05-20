`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30.10.2020 17:07:48
// Design Name:
// Module Name: pipeline
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

module pipeline
       #(parameter WIDTH=32)
       (
         input clk,
         input rst,
         input hold,
         input [WIDTH-1:0]InputData,
         output reg [WIDTH-1:0]OutputData
       );
always @(posedge clk or negedge rst)
  begin
    if (rst==0)
      begin
        OutputData<=0;
      end
    else
      begin
        if(hold==`TRUE)
          begin
            OutputData<=OutputData;
          end
        else
          begin
            OutputData<=InputData;
          end
      end
  end
endmodule
