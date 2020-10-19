`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2020 18:48:25
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


module top(
    input  clk,
    input  button,
    output led,
    output SCL,
    inout  SDA
    );

//////////////////////////////////////////////////////////////////////////////////
wire SCLWire,SDA_In_Wire,SDA_Out_Wire,SDA_Ctrl_Wire;
wire ValidWire;

assign SDA = SDA_Ctrl_Wire?1'bz:SDA_Out_Wire;
assign SDA = SDA_In_Wire;
//////////////////////////////////////////////////////////////////////////////////
reg led_reg;
assign led = led_reg;
reg clk_Div;
reg [15:0]DivCount;
parameter Div=125;

//////////////////////////////////////////////////////////////////////////////////
initial begin
led_reg=0;
clk_Div=0;
DivCount=0;
end
//////////////////////////////////////////////////////////////////////////////////

i2c i2c_inst(
    /*input  clk,

    output SCL,
    output SDA_Out,
    input  SDA_In,
    output reg SDA_R_W,
 
    input  R_W,             //读写信号线 0为写 1为读
    input  [6:0]Address,    //写地址
    input  [7:0]WriteValue, //写的值
    output [7:0]ReadValue,  //读的值

    input  Start,           //读写准备信号，0-1跳变有效
    output Ready,           //读写完成信号，0-1跳变有效
    output Valid            //从设备响应信号*/
    
    .SDA_In(SDA_In_Wire),
    .SDA_Out(SDA_Out_Wire),
    .SDA_R_W(SDA_Ctrl_Wire),
    .SCL(SCL),
    .Valid(ValidWire),
    .Start(button),
    .Address(7'b1010000),
    .R_W(1),


    .clk(clk_Div)
);


always @(posedge clk) begin
    if (DivCount==16'd125) begin
        DivCount <= 16'd0;
        clk_Div <= ~clk_Div;
    end else begin
        clk_Div <= clk_Div + 16'd1;
    end
end

always @(*) begin
    if(ValidWire==1)
        led_reg <= 1;
    else
        led_reg <= led_reg; 
end

endmodule
