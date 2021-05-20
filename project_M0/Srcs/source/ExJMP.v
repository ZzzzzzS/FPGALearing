`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 31.10.2020 16:47:04
// Design Name:
// Module Name: ExJMP
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

module ExJMP(
         input Enable,

         input [`REG_BUS]Instruction_i,
         input [`REG_BUS]Jump_Offset_i,
         input [`REG_BUS]Opt1_i,
         input [`REG_BUS]Opt2_i,
         input [`OPT_BUS]Rd_Addr_i,
         input [`REG_BUS]PC_i,

         output [`REG_BUS]Rd_o,
         output [`OPT_BUS]Rd_Addr_o,
         output Jump_Enable_o,
         output [`REG_BUS]Jump_Addr_o
       );

wire [`COD_BUS]Opt_Code=Instruction_i[6:0];
wire [`FUNCT3_BUS]Funct3=Instruction_i[14:12];

reg [`REG_BUS]Rd;
reg [`OPT_BUS]Rd_Addr;
reg Jump_Enable;
reg [`REG_BUS]Jump_Addr;

assign Rd_o = Rd;
assign Rd_Addr_o = Rd_Addr;
assign Jump_Enable_o = Jump_Enable;
assign Jump_Addr_o = Jump_Addr;

always @(*)
  begin
    if (Enable==`TRUE)
      begin
        case (Opt_Code)
          `B_TYPE_JUMP:
            begin
              case (Funct3)
                `B_JUMP_BEQ:
                  begin
                    if (Opt1_i==Opt2_i)
                      begin
                        Jump_Addr=PC_i+Jump_Offset_i;
                        Jump_Enable=`TRUE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                    else
                      begin
                        Jump_Addr=`REG_ZERO;
                        Jump_Enable=`FALSE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                  end
                `B_JUMP_BNE:
                  begin
                    if (Opt1_i!=Opt2_i)
                      begin
                        Jump_Addr=PC_i+Jump_Offset_i;
                        Jump_Enable=`TRUE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                    else
                      begin
                        Jump_Addr=`REG_ZERO;
                        Jump_Enable=`FALSE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                  end
                `B_JUMP_BLT:
                  begin
                    if ($signed(Opt1_i)<$signed(Opt2_i))
                      begin
                        Jump_Addr=PC_i+Jump_Offset_i;
                        Jump_Enable=`TRUE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                    else
                      begin
                        Jump_Addr=`REG_ZERO;
                        Jump_Enable=`FALSE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                  end
                `B_JUMP_BGE:
                  begin
                    if ($signed(Opt1_i)>=$signed(Opt2_i))
                      begin
                        Jump_Addr=PC_i+Jump_Offset_i;
                        Jump_Enable=`TRUE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                    else
                      begin
                        Jump_Addr=`REG_ZERO;
                        Jump_Enable=`FALSE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                  end
                `B_JUMP_BLTU:
                  begin
                    if (Opt1_i<Opt2_i)
                      begin
                        Jump_Addr=PC_i+Jump_Offset_i;
                        Jump_Enable=`TRUE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                    else
                      begin
                        Jump_Addr=`REG_ZERO;
                        Jump_Enable=`FALSE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                  end
                `B_JUMP_BGEU:
                  begin
                    if (Opt1_i>=Opt2_i)
                      begin
                        Jump_Addr=PC_i+Jump_Offset_i;
                        Jump_Enable=`TRUE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                    else
                      begin
                        Jump_Addr=`REG_ZERO;
                        Jump_Enable=`FALSE;
                        Rd=`REG_ZERO;
                        Rd_Addr=`OPT_ZERO;
                      end
                  end
                default:
                  begin
                    Jump_Addr=`REG_ZERO;
                    Jump_Enable=`FALSE;
                    Rd=`REG_ZERO;
                    Rd_Addr=`OPT_ZERO;
                  end
              endcase
            end
          `J_TYPE_JAL:
            begin
              Jump_Enable=`TRUE;
              Jump_Addr=PC_i+Jump_Offset_i;
              Rd=PC_i+32'd4;
              Rd_Addr=Rd_Addr_i;
            end
          `I_TYPE_JALR:
            begin
              Jump_Enable=`TRUE;
              Jump_Addr=PC_i+Opt1_i+$signed(Jump_Offset_i);
              Rd=PC_i+32'd4;
              Rd_Addr=Rd_Addr_i;
            end
          default:
            begin
              Jump_Addr=`REG_ZERO;
              Jump_Enable=`FALSE;
              Rd=`REG_ZERO;
              Rd_Addr=`OPT_ZERO;
            end
        endcase
      end
    else
      begin
        Jump_Addr=`REG_ZERO;
        Jump_Enable=`FALSE;
        Rd=`REG_ZERO;
        Rd_Addr=`OPT_ZERO;
      end
  end
endmodule
