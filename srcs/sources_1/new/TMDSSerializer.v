`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2020 18:29:53
// Design Name: 
// Module Name: TMDSSerializer
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


module TMDSSerializer(
    input PixelClk,
    input SerialClk,
    input Rst_n,
    input [9:0]PaiallelData,

    output SerialData_N,
    output SerialData_P
    );

TMDS_P2S TMDS_P2S_1(
    .clk_in(SerialClk),
    .clk_div_in(PixelClk),
    .data_out_from_device(PaiallelData),
    .io_reset(Rst_n),
    
    .data_out_to_pins_p(SerialData_P),
    .data_out_to_pins_n(SerialData_N)
);

endmodule
