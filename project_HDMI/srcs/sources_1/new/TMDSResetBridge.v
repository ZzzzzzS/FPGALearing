`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2020 11:20:38
// Design Name: 
// Module Name: TMDSResetBridge
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


module TMDSResetBridge(
    input Clk,
    input a_Rst,
    output o_Rst
    );
reg OutReg;
assign o_Rst = OutReg;

initial begin
    OutReg=1'b1;
end

always @(posedge Clk or negedge a_Rst) begin
    if (a_Rst==1'b0) begin
        OutReg<=1'b1;
    end else begin
        OutReg<=1'b0; 
    end
end

endmodule
