`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03.11.2020 15:41:50
// Design Name:
// Module Name: core_test
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


module core_test();

reg clk;
reg rst;

initial
  begin
    clk=0;
    rst=0;
    $readmemh("C:/Users/zhouzishun/Workspace/giteeRiscv/tinyriscv/tools/test.data",u_rom._rom);
    for(integer n=0;n<=7;n=n+1)   //把八个存储单元的数字都读取出来，若存的数不到八个单元输出x态，程序结果中会看到
      $display("%b",u_rom._rom[n]);
    # 9;
    rst=1;
  end

wire [31:0] rom;
wire [31:0] rom_addr;

core u_core(
       .clk                (clk                ),
       .rst                (rst                ),
       .ROM_i              (rom),
       .ROM_Addr_o         (rom_addr         ),
       .RAM_i              (RAM_i              ),
       .RAM_o              (RAM_o              ),
       .RAM_Write_Enable_o (RAM_Write_Enable_o ),
       .RAM_Addr_o         (RAM_Addr_o         )
     );

/*temp_rom rom_0(
           .addra(rom_addr),
           .clka(clk),
           .douta(rom)
         );*/
rom u_rom(
      .clk    (clk    ),
      .rst    (rst    ),
      //.we_i   (we_i   ),
      .addr_i (rom_addr),
      //.data_i (data_i ),
      .data_o (rom)
    );

always #1 clk=~clk;

endmodule
