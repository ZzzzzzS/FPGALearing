`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2020 18:29:15
// Design Name: 
// Module Name: TMDS
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


module TMDS(
    input [7:0]RedData,
    input [7:0]GreenData,
    input [7:0]BlueData,
    input H_Sync,
    input V_Sync,
    input DE,

    input PixelClock,
    input SerialClock,
    input Rst_n,

    output Oen,
    output TMDS_Clk_P,
    output TMDS_Clk_N,
    output [2:0]TMDS_Data_P,
    output [2:0]TMDS_Data_N
    );

wire [9:0]BlueP2S; //定义三条从Encoder到Serializer的线
wire [9:0]GreenP2S;
wire [9:0]RedP2S;

wire LostReset;

reg  OenReg;
assign Oen = OenReg;

always @(*) begin
    OenReg=1'b1;
end

initial begin
 OenReg=1;
end

//OenReg=1'b1;
//////////////////////////////////////////////////////////////////////////////////
//通道0
TMDSEncoder TMDSEncoder_0(
    .Clk(PixelClock),
    .Rst_n(Rst_n),

    .pC0(H_Sync),
    .pC1(V_Sync),
    .pVde(DE),
    .pDataIn(BlueData),

    .pDataOut(BlueP2S)
);


TMDSSerializer TMDSSerializer_0(
    .PixelClk(PixelClock),
    .SerialClk(SerialClock),
    .Rst_n(LostReset),
    .PaiallelData(BlueP2S),

    .SerialData_N(TMDS_Data_N[0]),
    .SerialData_P(TMDS_Data_P[0])
);

//////////////////////////////////////////////////////////////////////////////////
//通道1

TMDSEncoder TMDSEncoder_1(
    .Clk(PixelClock),
    .Rst_n(Rst_n),

    .pC0(1'd0),
    .pC1(1'd0),
    .pVde(DE),
    .pDataIn(GreenData),

    .pDataOut(GreenP2S)
);


TMDSSerializer TMDSSerializer_1(
    .PixelClk(PixelClock),
    .SerialClk(SerialClock),
    .Rst_n(LostReset),
    .PaiallelData(GreenP2S),

    .SerialData_N(TMDS_Data_N[1]),
    .SerialData_P(TMDS_Data_P[1])
);


//////////////////////////////////////////////////////////////////////////////////
//通道2

TMDSEncoder TMDSEncoder_2(
    .Clk(PixelClock),
    .Rst_n(Rst_n),

    .pC0(1'd0),
    .pC1(1'd0),
    .pVde(DE),
    .pDataIn(RedData),

    .pDataOut(RedP2S)
);


TMDSSerializer TMDSSerializer_2(
    .PixelClk(PixelClock),
    .SerialClk(SerialClock),
    .Rst_n(LostReset),
    .PaiallelData(RedP2S),

    .SerialData_N(TMDS_Data_N[2]),
    .SerialData_P(TMDS_Data_P[2])
);

//////////////////////////////////////////////////////////////////////////////////
//时钟通道
TMDSSerializer TMDS_CLK_0(
    .PixelClk(PixelClock),
    .SerialClk(SerialClock),
    .Rst_n(LostReset),
    .PaiallelData(10'b1111100000),
    
    .SerialData_N(TMDS_Clk_N),
    .SerialData_P(TMDS_Clk_P)
);

//////////////////////////////////////////////////////////////////////////////////
//复位

TMDSResetBridge TMDSResetBridge_0(
    .Clk(PixelClock),
    .a_Rst(Rst_n),
    .o_Rst(LostReset)
);
endmodule