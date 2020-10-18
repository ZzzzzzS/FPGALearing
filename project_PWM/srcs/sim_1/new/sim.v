`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2020 12:51:04
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

`timescale 1 ps/ 1 ps

module sim();

reg clk;

reg [7:0]div;

reg rst;

wire pwm;

pwm t1(
    .clk(clk),
    .div(div),
    .pwm(pwm),
    .rst(rst)
);

initial begin
    div=8'd127;
    clk=1;
    rst=1;
end

always #1 begin clk=~clk; end

endmodule
