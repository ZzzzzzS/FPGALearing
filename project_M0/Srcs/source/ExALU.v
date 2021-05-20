`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30.10.2020 20:21:23
// Design Name:
// Module Name: ExALU
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

module ExALU(
         input Enable,

         input [`REG_BUS]Instruction_i,
         input [`REG_BUS]Opt1_i,
         input [`REG_BUS]Opt2_i,
         input [`OPT_BUS]Rd_Addr_i,

         output [`REG_BUS]Rd_o,
         output [`OPT_BUS]Rd_Addr_o
       );

wire [2:0]Funct3=Instruction_i[14:12];
wire [6:0]Funct7=Instruction_i[31:25];
wire [6:0]Opt_Code=Instruction_i[6:0];

reg [`REG_BUS]Rd;
assign Rd_o = Rd;

reg [`OPT_BUS]Rd_Addr;
assign Rd_Addr_o = Rd_Addr;

initial
  begin
    Rd=0;
  end

always @(*)
  begin
    if (Enable==`TRUE)
      begin
        Rd_Addr=Rd_Addr_i;
        case (Funct3)
          `I_R_ALU_ADSUB:
            begin
              if (Funct7==7'b0100000 && Opt_Code==`R_TYPE_ALU)
                begin
                  Rd=Opt1_i-Opt2_i;
                end
              else
                begin
                  Rd=Opt1_i+Opt2_i;
                end
            end
          `I_R_ALU_SLTI:
            begin
              if($signed(Opt1_i)<$signed(Opt2_i))
                Rd=32'b1;
              else
                Rd=32'b0;
            end
          `I_R_ALU_SLTIU:
            begin
              if(Opt1_i<Opt2_i)
                Rd=32'b1;
              else
                Rd=32'b0;
            end
          `I_R_ALU_XORI:
            begin
              Rd=Opt1_i^Opt2_i;
            end
          `I_R_ALU_ORI:
            begin
              Rd=Opt1_i | Opt2_i;
            end
          `I_R_ALU_ANDI:
            begin
              Rd=Opt1_i & Opt2_i;
            end
          `I_R_ALU_SLLI:
            begin
              Rd=Opt1_i << Opt2_i[4:0];
            end
          `I_R_ALU_SRLAI:
            begin
              case (Funct7)
                7'b0100000:
                  begin
                    Rd=$signed(Opt1_i) >>> Opt2_i[4:0];
                    // >>>是算数右移指令，必须要有符号数才会算数右移，否则还是逻辑右移
                  end
                7'b0000000:
                  begin
                    Rd=Opt1_i >> Opt2_i[4:0];
                  end
                default:
                  begin
                    Rd=`REG_ZERO;
                  end
              endcase
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
        Rd_Addr=0;
      end
  end
endmodule
