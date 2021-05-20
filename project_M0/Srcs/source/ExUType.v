`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 31.10.2020 18:13:31
// Design Name:
// Module Name: ExUType
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

module ExUType(
         input Enable,

         input [`REG_BUS]Instruction_i,
         input [`REG_BUS]Opt1_i,
         input [`OPT_BUS]Rd_Addr_i,
         input [`REG_BUS]PC_i,

         output [`REG_BUS]Rd_o,
         output [`OPT_BUS]Rd_Addr_o
       );

wire [`COD_BUS]Opt_Code=Instruction_i[6:0];

reg [`REG_BUS]Rd;
reg [`OPT_BUS]Rd_Addr;
assign Rd_o = Rd;
assign Rd_Addr_o = Rd_Addr;

always @(*)
  begin
    if (Enable==`TRUE)
      begin
        Rd_Addr=Rd_Addr_i;
        case (Opt_Code)
          `U_TYPE_LUI:
            begin
              Rd=Opt1_i;
            end
          `U_TYPE_AUIPC:
            begin
              Rd=Opt1_i+PC_i;
            end
          default:
            begin
              Rd=`REG_ZERO;
            end
        endcase
      end
    else
      begin
        Rd=`REG_ZERO;
        Rd_Addr=`REG_ZERO;
      end
  end
endmodule
