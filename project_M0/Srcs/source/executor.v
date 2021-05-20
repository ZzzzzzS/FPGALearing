`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 28.10.2020 17:25:55
// Design Name:
// Module Name: executor
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

module EX(
         input [`REG_BUS]Instruction_i,
         input [`REG_BUS]Opt1_i,
         input [`REG_BUS]Opt2_i,
         input [7:0]Inst_Type_i,

         input  [`OPT_BUS]Rd_Addr_i,
         output [`OPT_BUS]Rd_Addr_o,
         output [`REG_BUS]Rd_o,

         input  [`MEM_BUS]Read_Memory_Value_i,
         output [`MEM_BUS]Write_Memory_Value_o,
         output Write_Enable_o,
         output [`MEM_ADDR_BUS]Memory_Addr_o,

         input [`REG_BUS]PC_i,
         output Jump_Enable_o,
         input [`REG_BUS]Jump_Offset_i,
         output [`REG_BUS]Jump_Addr_o
       );


wire [`REG_BUS] ExUType_Rd,ExJMP_Rd,ExRW_Rd,ExCSR_Rd,ExALU0_Rd;
wire [`OPT_BUS] ExUType_Rd_Addr,ExJMP_Rd_Addr,ExRW_Rd_Addr,ExCSR_Rd_Addr,ExALU0_Rd_Addr;

reg [`REG_BUS]Rd;
reg [`OPT_BUS]Rd_Addr;

assign Rd_o = Rd;
assign Rd_Addr_o = Rd_Addr;


ExUType u_ExUType(
          .Enable        (Inst_Type_i[4]),
          .Instruction_i (Instruction_i ),
          .Opt1_i        (Opt1_i        ),
          .Rd_Addr_i     (Rd_Addr_i     ),
          .PC_i          (PC_i          ),
          .Rd_o          (ExUType_Rd    ),
          .Rd_Addr_o     (ExUType_Rd_Addr)
        );

ExJMP u_ExJMP(
        .Enable        (Inst_Type_i[2]),
        .Instruction_i (Instruction_i ),
        .Jump_Offset_i (Jump_Offset_i ),
        .Opt1_i        (Opt1_i        ),
        .Opt2_i        (Opt2_i        ),
        .Rd_Addr_i     (Rd_Addr_i     ),
        .PC_i          (PC_i          ),
        .Rd_o          (ExJMP_Rd      ),
        .Rd_Addr_o     (ExJMP_Rd_Addr ),
        .Jump_Enable_o (Jump_Enable_o ),
        .Jump_Addr_o   (Jump_Addr_o   )
      );

ExRW u_ExRW(
       .Enable               (Inst_Type_i[3]       ),
       .Instruction_i        (Instruction_i        ),
       .Opt1_i               (Opt1_i               ),
       .Opt2_i               (Opt2_i               ),
       .Rd_Addr_i            (Rd_Addr_i            ),
       .Rd_Addr_o            (ExRW_Rd_Addr         ),
       .Rd_o                 (ExRW_Rd              ),
       .Read_Memory_Value_i  (Read_Memory_Value_i  ),
       .Write_Memory_Value_o (Write_Memory_Value_o ),
       .Write_Enable_o       (Write_Enable_o       ),
       .Memory_Addr_o        (Memory_Addr_o        )
     );

ExCSR u_ExCSR(
        .Enable        (0             ),
        .Instruction_i (Instruction_i ),
        .Opt1_i        (Opt1_i        ),
        .Rd_Addr_i     (Rd_Addr_i     ),
        .CSR_Addr_i    (CSR_Addr_i    ),
        .CSR_Addr_o    (CSR_Addr_o    ),
        .CSR_o         (CSR_o         ),
        .Rd_Addr_o     (ExCSR_Rd_Addr ),
        .Rd_o          (ExCSR_Rd      )
      );

ExALU u_ExALU0(
        .Enable        (Inst_Type_i[0]),
        .Instruction_i (Instruction_i ),
        .Opt1_i        (Opt1_i        ),
        .Opt2_i        (Opt2_i        ),
        .Rd_Addr_i     (Rd_Addr_i     ),
        .Rd_o          (ExALU0_Rd     ),
        .Rd_Addr_o     (ExALU0_Rd_Addr)
      );

always @(*)
  begin
    case (Inst_Type_i)
      `ExALU_ENABLE:
        begin
          Rd=ExALU0_Rd;
          Rd_Addr=ExALU0_Rd_Addr;
        end
      `ExCSR_ENABLE:
        begin
          Rd=ExCSR_Rd;
          Rd_Addr=ExCSR_Rd_Addr;
        end
      `ExJMP_ENABLE:
        begin
          Rd=ExJMP_Rd;
          Rd_Addr=ExJMP_Rd_Addr;
        end
      `ExRW_ENABLE:
        begin
          Rd=ExRW_Rd;
          Rd_Addr=ExRW_Rd_Addr;
        end
      `ExUTYPE_ENABLE:
        begin
          Rd=ExUType_Rd;
          Rd_Addr=ExUType_Rd_Addr;
        end
      `ExFENCE_ENABLE:
        begin
          Rd=0;
          Rd_Addr=0; //TODO:
        end
      default:
        begin
          Rd=0;
          Rd_Addr=0;
        end
    endcase
  end


endmodule
