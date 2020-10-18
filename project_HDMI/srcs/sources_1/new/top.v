`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2020 15:38:12
// Design Name: 
// Module Name: clock_gen
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


module top(
    input sys_clk,
    output hdmi_oen,
    output TMDS_clk_n,
    output TMDS_clk_p,
    output [2:0]TMDS_data_n,
    output [2:0]TMDS_data_p
    );

wire video_clk;
wire video_clk_5x;

wire video_de;
wire video_hs;
wire video_vs;

wire [7:0]video_r;
wire [7:0]video_g;
wire [7:0]video_b;

clk_wiz_0 clock_generator( //时钟发生模块
    .reset(0),
    .clk_in1(sys_clk),
    .clk_out1(video_clk),
    .clk_out2(video_clk_5x)
);

//`define IPCore
`ifdef IPCore
rgb2dvi_0 TMDS0(
    	// DVI 1.0 TMDS video interface
	.TMDS_Clk_p(TMDS_clk_p),
	.TMDS_Clk_n(TMDS_clk_n),
	.TMDS_Data_p(TMDS_data_p),
	.TMDS_Data_n(TMDS_data_n),
	.oen(hdmi_oen),
	//Auxiliary signals 
	.aRst_n(1'b1), //-asynchronous reset; must be reset when RefClk is not within spec
	
	// Video in
	.vid_pData({video_r,video_g,video_b}),
	.vid_pVDE(video_de),
	.vid_pHSync(video_hs),
	.vid_pVSync(video_vs),
	.PixelClk(video_clk),
	.SerialClk(video_clk_5x)// 5x PixelClk
);

`else
TMDS TMDS0(
    .RedData(video_r),
    .GreenData(video_g),
    .BlueData(video_b),
    .H_Sync(video_hs),
    .V_Sync(video_vs),
    .DE(video_de),

    .PixelClock(video_clk),
    .SerialClock(video_clk_5x),
    .Rst_n(1'b1),

    .Oen(hdmi_oen),
    .TMDS_Clk_P(TMDS_clk_p),
    .TMDS_Clk_N(TMDS_clk_n),
    .TMDS_Data_P(TMDS_data_p),
    .TMDS_Data_N(TMDS_data_n)
);
`endif


LineBuffer Buffer(
	.clk(video_clk),
//    .rst(sys_rst),

    .de(video_de),
    .hs(video_hs),
    .vs(video_vs),
    .red(video_r),
    .green(video_g),
    .blue(video_b)
);

endmodule

