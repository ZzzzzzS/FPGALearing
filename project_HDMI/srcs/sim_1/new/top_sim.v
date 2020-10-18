`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2020 19:33:07
// Design Name: 
// Module Name: top_sim
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


module top_sim(

    );

reg sys_clk;
wire hdmi_oen;
wire TMDS_clk_n;
wire TMDS_clk_p;
wire [2:0]TMDS_data_n;
wire [2:0]TMDS_data_p;

top u1(
    .sys_clk(sys_clk),
    .hdmi_oen(hdmi_oen),
    .TMDS_clk_n(TMDS_clk_n),
    .TMDS_clk_p(TMDS_clk_p),
    .TMDS_data_n(TMDS_data_n),
    .TMDS_data_p(TMDS_data_p)
);


initial begin
 sys_clk=0;
end

always #1 begin
    sys_clk=~sys_clk;
end 

endmodule
