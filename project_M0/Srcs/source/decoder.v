`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 28.10.2020 17:22:55
// Design Name:
// Module Name: decoder
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

module decoder(
         input wire rst_n,
         input wire clk,
         input wire [`REG_BUS]Instruction_i,
         input wire [`REG_BUS]Opt1_i,
         input wire [`REG_BUS]Opt2_i,
         input wire [`REG_BUS]CSR_i,

         output reg [`OPT_BUS]Opt1_Addr_o,
         output reg [`OPT_BUS]Opt2_Addr_o,
         output reg [11:0]CSR_Addr_o,

         output reg [`REG_BUS]Opt1_o,
         output reg [`REG_BUS]Opt2_o,
         output reg [`REG_BUS]CSR_o,
         output reg [`OPT_BUS]Rd_Addr_o,
         output reg [`REG_BUS]Jump_Offset_o,
         output reg [`REG_BUS]Instruction_o,
         output reg [7:0]Inst_Type_o
       );

wire [6:0]Opt_Code;
wire [`OPT_BUS]Rd_Addr;
wire [2:0]Funct3;
wire [`OPT_BUS]Rs1_Addr;
wire [`OPT_BUS]Rs2_Addr;
wire [6:0]Funct7;
wire [11:0]CSR_Addr;

assign Opt_Code = Instruction_i[6:0];
assign Rd_Addr  = Instruction_i[11:7];
assign Funct3   = Instruction_i[14:12];
assign Rs1_Addr = Instruction_i[19:15];
assign Rs2_Addr = Instruction_i[24:20];
assign Funct7   = Instruction_i[31:25];
assign CSR_Addr = Instruction_i[31:20];

always @(*)
  begin
    Instruction_o=Instruction_i;

    case (Opt_Code)
      `I_TYPE_ALU:
        begin
          Opt1_Addr_o=Rs1_Addr;
          Opt1_o=Opt1_i;
          Opt2_Addr_o=`OPT_ZERO;
          Opt2_o={{20{Instruction_i[31]}},Instruction_i[31:20]};
          Rd_Addr_o=Rd_Addr;
          Jump_Offset_o=`REG_ZERO;
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Inst_Type_o=`ExALU_ENABLE;
        end
      `R_TYPE_ALU:
        begin
          Opt1_Addr_o=Rs1_Addr;
          Opt1_o=Opt1_i;
          Opt2_Addr_o=Rs2_Addr;
          Opt2_o=Opt2_i;
          Rd_Addr_o=Rd_Addr;
          Jump_Offset_o=`REG_ZERO;
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Inst_Type_o=`ExALU_ENABLE;
        end
      `B_TYPE_JUMP:
        begin
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Rd_Addr_o=`OPT_ZERO;
          Opt1_Addr_o=Rs1_Addr;
          Opt1_o=Opt1_i;
          Opt2_Addr_o=Rs2_Addr;
          Opt2_o=Opt2_i;
          Jump_Offset_o={{20{Instruction_i[31]}},Instruction_i[7],Instruction_i[30:25],Instruction_i[11:8],1'b0};
          //拼接跳转地址，最低位为0代表地址乘以2,剩余高位全部补成第12位的值,方便有符号数的长度转化
          Inst_Type_o=`ExJMP_ENABLE;
        end
      `J_TYPE_JAL:
        begin
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Rd_Addr_o=Rd_Addr;
          Opt1_o=`REG_ZERO;
          Opt2_o=`REG_ZERO;
          Opt1_Addr_o=`OPT_ZERO;
          Opt2_Addr_o=`OPT_ZERO;
          Jump_Offset_o={{12{Instruction_i[31]}},Instruction_i[19:12],Instruction_i[20],Instruction_i[30:21],1'b0};
          //拼接跳转地址，最低位为0代表地址乘以2
          Inst_Type_o=`ExJMP_ENABLE;
        end
      `I_TYPE_JALR:
        begin
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Rd_Addr_o=Rd_Addr;
          Opt1_o=Opt1_i;
          Opt2_o=`REG_ZERO;
          Opt1_Addr_o=Rs1_Addr;
          Opt2_Addr_o=`OPT_ZERO;
          Jump_Offset_o={{20{Instruction_i[31]}},Instruction_i[31:20]};
          Inst_Type_o=`ExJMP_ENABLE;
        end
      `U_TYPE_LUI:
        begin
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Rd_Addr_o=Rd_Addr;
          Opt1_o={Instruction_i[31:12],12'b0};
          Opt2_o=`REG_ZERO;
          Opt1_Addr_o=`OPT_ZERO;
          Opt2_Addr_o=`OPT_ZERO;
          Jump_Offset_o=`REG_ZERO;
          Inst_Type_o=`ExUTYPE_ENABLE;
        end
      `U_TYPE_AUIPC:
        begin
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Rd_Addr_o=Rd_Addr;
          Opt1_o={Instruction_i[31:12],12'b0};
          Opt2_o=`REG_ZERO;
          Opt1_Addr_o=`OPT_ZERO;
          Opt2_Addr_o=`OPT_ZERO;
          Jump_Offset_o=`REG_ZERO;
          Inst_Type_o=`ExUTYPE_ENABLE;
        end
      `I_TYPE_LOAD:
        begin
          Inst_Type_o=`ExRW_ENABLE;
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Rd_Addr_o=Rd_Addr;
          Opt2_Addr_o=`OPT_ZERO;
          Opt2_o=`REG_ZERO;
          Jump_Offset_o=`REG_ZERO;
          case (Funct3)
            `I_LOAD_LB,`I_LOAD_LH,`I_LOAD_LW:
              begin
                Opt1_Addr_o=Rs1_Addr;
                Opt1_o=Opt1_i+$signed(Instruction_i[31:20]);
              end
            `I_LOAD_LBU,`I_LOAD_LHU:
              begin
                Opt1_Addr_o=Rs1_Addr;
                Opt1_o=Opt1_i+{{20{Instruction_i[31]}},Instruction_i[31:20]};
              end
            default:
              begin
                Opt1_o=`REG_ZERO;
                Opt1_Addr_o=`OPT_ZERO;
              end
          endcase
        end
      `S_TYPE_STORE:
        begin
          Inst_Type_o=`ExRW_ENABLE;
          CSR_Addr_o=12'b0;
          CSR_o=`REG_ZERO;
          Rd_Addr_o=`OPT_ZERO;
          Jump_Offset_o=`REG_ZERO;
          Opt1_Addr_o=Rs1_Addr;
          Opt2_Addr_o=Rs2_Addr;
          Opt2_o=Opt2_i;
          Opt1_o=Opt1_i+$signed({Instruction_i[31:25],Instruction_i[11:7]});
        end
      `I_TYPE_FENCE:
        begin
          Inst_Type_o=`ExFENCE_ENABLE;
          CSR_o=`REG_ZERO;
          CSR_Addr_o=12'b0;
          Rd_Addr_o=`OPT_ZERO;
          Jump_Offset_o=`REG_ZERO;
          Opt1_o=`REG_ZERO;
          Opt2_o=`REG_ZERO;
          Opt1_Addr_o=`OPT_ZERO;
          Opt2_Addr_o=`OPT_ZERO;
        end
      `I_TYPE_CSR:
        begin
          Inst_Type_o=`ExCSR_ENABLE;
          case (Funct3)
            `I_CSR_CSRRW,`I_CSR_CSRRS,`I_CSR_CSRRC:
              begin
                Opt1_Addr_o=Rs1_Addr;
                Opt1_o=Opt1_i;
              end
            `I_CSR_CSRRWI,`I_CSR_CSRRSI,`I_CSR_CSRRCI:
              begin
                Opt1_o=Instruction_i[19:15];
                Opt1_Addr_o=`OPT_ZERO;
              end
            default:
              begin
                Opt1_o=`REG_ZERO;
                Opt1_Addr_o=`OPT_ZERO;
              end
          endcase
          CSR_Addr_o=CSR_Addr;
          CSR_o=CSR_i;
          Rd_Addr_o=Rd_Addr;
          Opt2_Addr_o=`OPT_ZERO;
          Opt2_o=`REG_ZERO;
          Jump_Offset_o=`REG_ZERO;
        end
      default:
        begin
          Inst_Type_o=8'b0;
          CSR_Addr_o=12'b0;
          CSR_o=`REG_ZERO;
          Rd_Addr_o=`OPT_ZERO;
          Jump_Offset_o=`REG_ZERO;
          Opt1_o=`REG_ZERO;
          Opt2_o=`REG_ZERO;
          Opt1_Addr_o=`OPT_ZERO;
          Opt2_Addr_o=`OPT_ZERO;
        end
    endcase
  end

endmodule
