`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03.11.2020 12:22:00
// Design Name:
// Module Name: top
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

module top(
         input clk,
         input rst
       );

wire [`MEM_BUS] RAM_Read,RAM_Write;
wire [`MEM_ADDR_BUS] RAM_Addr;
wire RAM_Write_Enable;

wire [`REG_BUS] ROM_Read;
wire [`ROM_ADDR_BUS] ROM_Addr;

core u_core(
       .clk                (clk                ),
       .rst                (rst                ),
       .ROM_i              (ROM_Read           ),
       .ROM_Addr_o         (ROM_Addr           ),
       .RAM_i              (RAM_Read           ),
       .RAM_o              (RAM_Write          ),
       .RAM_Write_Enable_o (RAM_Write_Enable   ),
       .RAM_Addr_o         (RAM_Addr           )
     );

/*temp_ram ram(
           .clka(clk),
           .addra(RAM_Addr),
           .dina(RAM_Write),
           .douta(RAM_Read),
           .wea(RAM_Write_Enable)
         );*/

/*temp_rom rom(
           .addra(ROM_Addr),
           .clka(clk),
           .douta(ROM_Read)
         );*/

rom u_rom(
      .clk    (clk    ),
      .rst    (rst    ),
      //.we_i   (we_i   ),
      .addr_i (ROM_Addr),
      //.data_i (data_i ),
      .data_o (ROM_Read)
    );


ram u_ram(
      .clk          (clk          ),
      .Write_Enable (RAM_Write_Enable ),
      .Addr_i       (RAM_Addr      ),
      .Write_Data_i (RAM_Write ),
      .Read_Data_o  (RAM_Read  )
    );


endmodule
