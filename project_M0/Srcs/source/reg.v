`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30.10.2020 23:57:44
// Design Name:
// Module Name: regs
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

module regs(
         input clk,
         input rst,

         input [`OPT_BUS]Rs1_Addr_i,
         input [`OPT_BUS]Rs2_Addr_i,
         input [`OPT_BUS]Rd_Addr_i,

         input Write_Enable_i,

         input [`REG_BUS]Rd_i,
         output reg [`REG_BUS]Rs1_o,
         output reg [`REG_BUS]Rs2_o,

         input Jump_Enable_i,
         input Hold_Enable_i,
         input [`REG_BUS]Jump_Addr_i,
         output [`REG_BUS]PC_o

       );
reg [`REG_BUS] Regs[0:31];
reg [`REG_BUS] PC;
assign PC_o = PC;

/*initial
  begin
    for (integer i=0;i<32;i=i+1)
      begin
        Regs[i]=32'b0;
      end
    PC=32'b0;
  end
*/

always @(posedge clk or negedge rst)
  begin
    if (rst==0)
      begin
        PC<=`PC_RESET_VALUE;    //复位
      end
    else
      begin
        if (Hold_Enable_i==`TRUE)   //暂停
          begin
            PC<=PC;
          end
        else if (Jump_Enable_i==`TRUE) //跳转
          begin
            PC<=Jump_Addr_i;
          end
        else  //普通情况
          begin
            PC<=PC+32'd4;
          end
      end
  end

always @(posedge clk)
  begin
    Regs[Rd_Addr_i]<=Rd_i;
  end

always @(*)
  begin
    if (Rs1_Addr_i==`OPT_ZERO)
      begin
        Rs1_o=`REG_ZERO;
      end
    else if (Write_Enable_i==`TRUE && Rs1_Addr_i==Rd_Addr_i)
      begin
        Rs1_o=Rd_i;
      end
    else
      begin
        Rs1_o=Regs[Rs1_Addr_i];
      end
  end

always @(*)
  begin
    if (Rs2_Addr_i==`OPT_ZERO)
      begin
        Rs2_o=`REG_ZERO;
      end
    else if (Write_Enable_i==`TRUE && Rs2_Addr_i==Rd_Addr_i)
      begin
        Rs2_o=Rd_i;
      end
    else
      begin
        Rs2_o=Regs[Rs2_Addr_i];
      end
  end
endmodule
