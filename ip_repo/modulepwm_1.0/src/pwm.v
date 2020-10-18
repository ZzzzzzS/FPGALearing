`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2020 12:21:25
// Design Name: 
// Module Name: pwm
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


module pwm(
    input clk,
    //input rst,
    output reg pwm,
    input [7:0] div
    );
    reg [7:0]time_t;
    reg [7:0]duty;
    reg [6:0]count;
    reg [7:0]divcount;

    reg [8:0] clkdiv;
    reg clk_n;

    initial begin
        time_t=8'd0;
        duty=8'd0;
        count=7'd0;
        divcount=8'd0;
        pwm=0;
    end

    always @(posedge clk) begin
        clkdiv<=clkdiv+1;
        if(clkdiv==8'd0)begin
            clk_n <= ~clk_n;
        end else begin
            clk_n <= clk_n;
        end
    end

    always @(posedge clk) begin
        if(count<duty) begin
            pwm = 1;
        end else begin
            pwm = 0;
        end
        count<=count+7'd1;
    end

    always @(posedge clk_n) begin
        divcount<=divcount+8'd1;
        if(divcount==div) begin
            divcount<=8'd0;
            time_t<=time_t+8'd1;
        end else begin
            if(duty<8'd127) begin
                duty<=time_t;
            end else begin
                duty <= 8'd255-time_t;
            end
        end
    end

endmodule
