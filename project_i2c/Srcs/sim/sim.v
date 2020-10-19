`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2020 19:10:45
// Design Name: 
// Module Name: sim
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


module sim(

    );

reg clk;
wire SCL;
wire SDA;
reg button;
wire Valid;
initial begin
    clk=0;
    button=0;
end

top U1(
    .clk(clk),
    .button(button),
    .led(Valid),
    .SCL(SCL),
    .SDA(SDA)
);

always #1 begin clk <= ~clk;  button=1; end


endmodule
