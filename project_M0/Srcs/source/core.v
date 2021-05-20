`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03.11.2020 12:17:26
// Design Name:
// Module Name: core
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

module core(
         input clk,
         input rst,

         input [`REG_BUS]ROM_i,
         output [`MEM_ADDR_BUS]ROM_Addr_o,

         input [`MEM_BUS]RAM_i,
         output [`MEM_BUS]RAM_o,
         output RAM_Write_Enable_o,
         output [`MEM_ADDR_BUS]RAM_Addr_o
       );

//取址器相关
wire [`REG_BUS] ROM2If_Inst;
wire [`ROM_ADDR_BUS]If2ROM_ExPip_PC;
wire [`REG_BUS] If2Id_Inst;
wire [`REG_BUS] Regs2If_PC;
assign ROM_Addr_o = Regs2If_PC;

//TODO:HOLDFLAG

//译码器相关
wire [`REG_BUS]Regs2Id_Opt1 , Regs2Id_Opt2;
wire [`OPT_BUS]Id2Regs_Opt1_Addr , Id2Regs_Opt2_Addr;
wire [`REG_BUS]Id2ExPip_Opt1 , Id2ExPip_Opt2;
wire [`REG_BUS]Id2ExPip_Inst;
wire [`REG_BUS]Id2ExPip_Jump_Offset;
wire [`OPT_BUS]Id2ExPip_Rd_Addr;
wire [7:0]Id2ExPip_InstType;
//TODO:HOLDFLAG
//执行器相关
wire [`REG_BUS]ExPip2Ex_Opt1,ExPip2Ex_Opt2;
wire [`REG_BUS]Expip2Ex_Inst;
wire [`OPT_BUS]ExPip2Ex_Rd_Addr;
wire [7:0]ExPip2Ex_InstType;
wire [`REG_BUS]ExPip2Ex_Jump_Offset;
wire [`REG_BUS]ExPip2Ex_PC;
wire [`OPT_BUS]Ex2Regs_Rd_Addr;
wire [`REG_BUS]Ex2Regs_Rd;
wire [`REG_BUS]Ex2Regs_Jump_Addr;
wire [`MEM_ADDR_BUS]Ex2Out_RAM_Addr;
wire [`MEM_BUS]Ex2Out_RAM_Write;
wire Ex2Out_RAM_WriteEnable;
assign RAM_o = Ex2Out_RAM_Write;
assign RAM_Addr_o = Ex2Out_RAM_Addr;
assign RAM_Write_Enable_o = Ex2Out_RAM_WriteEnable;



fetcher u_fetcher(
          //TODO:.Hold_Flag_i   (Hold_Flag_i   ),
          .clk           (clk           ),
          .rst           (rst           ),
          .Instruction_i (ROM_i         ),
          .Instruction_o (If2Id_Inst    ),
          .PC_i          (Regs2If_PC    ),
          .PC_o          (If2ROM_ExPip_PC)
        );
decoder u_decoder(
          .rst_n         (rst           ),
          .clk           (clk           ),
          .Instruction_i (If2Id_Inst    ),
          .Opt1_i        (Regs2Id_Opt1  ),
          .Opt2_i        (Regs2Id_Opt2  ),
          //TODO:.CSR_i         (CSR_i         ),
          .Opt1_Addr_o   (Id2Regs_Opt1_Addr),
          .Opt2_Addr_o   (Id2Regs_Opt2_Addr),
          //TODO:.CSR_Addr_o    (CSR_Addr_o    ),
          .Opt1_o        (Id2ExPip_Opt1 ),
          .Opt2_o        (Id2ExPip_Opt2 ),
          //TODO:.CSR_o         (CSR_o         ),
          .Rd_Addr_o     (Id2ExPip_Rd_Addr),
          .Jump_Offset_o (Id2ExPip_Jump_Offset),
          .Instruction_o (Id2ExPip_Inst ),
          .Inst_Type_o   (Id2ExPip_InstType)
        );
Id2Ex u_Id2Ex(
        .clk           (clk             ),
        .rst           (rst             ),
        //TODO:.hold          (hold          ),
        .Instruction_i (Id2ExPip_Inst   ),
        .Opt1_i        (Id2ExPip_Opt1   ),
        .Opt2_i        (Id2ExPip_Opt2   ),
        .Inst_Type_i   (Id2ExPip_InstType),
        .Rd_Addr_i     (Id2ExPip_Rd_Addr),
        .PC_i          (If2ROM_ExPip_PC ),
        .Jump_Offset_i (Id2ExPip_Jump_Offset),
        .Instruction_o (Expip2Ex_Inst   ),
        .Opt1_o        (ExPip2Ex_Opt1   ),
        .Opt2_o        (ExPip2Ex_Opt2   ),
        .Inst_Type_o   (ExPip2Ex_InstType),
        .Rd_Addr_o     (ExPip2Ex_Rd_Addr),
        .PC_o          (ExPip2Ex_PC     ),
        .Jump_Offset_o (ExPip2Ex_Jump_Offset)
      );

EX u_EX(
     .Instruction_i        (Expip2Ex_Inst       ),
     .Opt1_i               (ExPip2Ex_Opt1       ),
     .Opt2_i               (ExPip2Ex_Opt2       ),
     .Inst_Type_i          (ExPip2Ex_InstType   ),
     .Rd_Addr_i            (ExPip2Ex_Rd_Addr    ),
     .Rd_Addr_o            (Ex2Regs_Rd_Addr     ),
     .Rd_o                 (Ex2Regs_Rd          ),
     .Read_Memory_Value_i  (RAM_i               ),
     .Write_Memory_Value_o (Ex2Out_RAM_Write    ),
     .Write_Enable_o       (Ex2Out_RAM_WriteEnable),
     .Memory_Addr_o        (Ex2Out_RAM_Addr     ),
     .PC_i                 (ExPip2Ex_PC         ),
     //TODO:.Jump_Enable_o        (),
     .Jump_Offset_i        (ExPip2Ex_Jump_Offset),
     .Jump_Addr_o          (Ex2Regs_Jump_Addr   )
   );

regs u_regs(
       .clk            (clk             ),
       .rst            (rst             ),
       .Rs1_Addr_i     (Id2Regs_Opt1_Addr),
       .Rs2_Addr_i     (Id2Regs_Opt2_Addr),
       .Rd_Addr_i      (Ex2Regs_Rd_Addr ),
       .Write_Enable_i (1),//TODO:
       .Rd_i           (Ex2Regs_Rd      ),
       .Rs1_o          (Regs2Id_Opt1    ),
       .Rs2_o          (Regs2Id_Opt2    ),
       //TODO:.Jump_Enable_i  (Jump_Enable_i  ),
       //TODO:.Hold_Enable_i  (Hold_Enable_i  ),
       .Jump_Addr_i    (Ex2Regs_Jump_Addr),
       .PC_o           (Regs2If_PC      )
     );

endmodule
