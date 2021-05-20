`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04.11.2020 14:31:12
// Design Name:
// Module Name: rom
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

module rom(

         input wire clk,
         input wire rst,

         input wire we_i,                   // write enable
         input wire[`ROM_ADDR_BUS] addr_i,    // addr
         input wire[`REG_BUS] data_i,

         output reg[`REG_BUS] data_o         // read data

       );

reg[`REG_BUS] _rom[0:1023];


always @ (posedge clk)
  begin
    if (we_i == `TRUE)
      begin
        _rom[addr_i[31:2]] <= data_i;
      end
  end

always @ (*)
  begin
    if (rst == 0)
      begin
        data_o = `REG_ZERO;
      end
    else
      begin
        data_o = _rom[addr_i[31:2]];
      end
  end

endmodule
