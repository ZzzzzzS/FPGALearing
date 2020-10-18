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


module LineBuffer(
    input clk,
    input rst,

    output  de,
    output reg hs,
    output reg vs,
    output reg [7:0]red,
    output reg [7:0]green,
    output reg [7:0]blue
    );

parameter H_ACTIVE = 16'd1280;           //horizontal active time (pixels)
parameter H_FP = 16'd110;                //horizontal front porch (pixels)
parameter H_SYNC = 16'd40;               //horizontal sync time(pixels)
parameter H_BP = 16'd220;                //horizontal back porch (pixels)
parameter V_ACTIVE = 16'd720;            //vertical active Time (lines)
parameter V_FP  = 16'd5;                 //vertical front porch (lines)
parameter V_SYNC  = 16'd5;               //vertical sync time (lines)
parameter V_BP  = 16'd20;                //vertical back porch (lines)
parameter HS_POL = 1'b1;                 //horizontal sync polarity, 1 : POSITIVE,0 : NEGATIVE;
parameter VS_POL = 1'b1;                 //vertical sync polarity, 1 : POSITIVE,0 : NEGATIVE;

parameter H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;//horizontal total time (pixels)
parameter V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;//vertical total time (lines)
parameter H_N_ACTV = H_FP + H_SYNC + H_BP; //同步时间，active信号不激活
parameter V_N_ACTV = V_FP + V_SYNC + V_BP; //同步时间，active信号不激活 

reg [16:0]pix_cnt; //计算行位置
reg [16:0]line_cnt; //计算列位置

reg [16:0]X_Point;
reg [16:0]Y_Point;

reg h_actv;//行激活时间
reg v_actv;//列激活时间

assign de = h_actv & v_actv; //de信号使能=行列都激活时


initial begin
    pix_cnt=0;
    line_cnt=0;
    X_Point=0;
    Y_Point=0;
    h_actv=0;
    v_actv=0;
    hs=0;
    vs=0;
    red=0;
    green=0;
    blue=0;
end


always @(posedge clk or posedge rst) begin //处理行位置信号
    if (rst) begin
        pix_cnt<=0;
    end else begin
         if (pix_cnt<H_TOTAL-1) begin
             pix_cnt<=pix_cnt+1;
         end else begin
             pix_cnt <= 0;
         end
    end
end

always @(posedge clk or posedge rst) begin //处理列位置信号
    if (rst) begin
        line_cnt<=0;
    end else begin
        if (pix_cnt==H_TOTAL-1) begin
            if (line_cnt<V_TOTAL-1) begin
                line_cnt<=line_cnt+1;
            end else begin
                line_cnt <= 0;
            end 
        end
    end
end

always @(posedge clk or posedge rst) begin //处理行激活信号
    if(rst) begin
        h_actv<=0;
        X_Point<=0;
    end else begin
         if (pix_cnt<H_N_ACTV) begin //同步时间
             h_actv<=0;
             X_Point<=0;
         end else begin         //显示时间
             h_actv <= 1;
             X_Point<=pix_cnt-H_N_ACTV;
         end
    end
end

always @(posedge clk or posedge rst) begin //处理列激活信号
    if(rst) begin
        v_actv<=0;
        Y_Point<=0;
    end else begin
         if (line_cnt<V_N_ACTV) begin //同步时间
             v_actv<=0;
             Y_Point<=0;
         end else begin //显示时间
             v_actv <= 1;
             Y_Point<=line_cnt-V_N_ACTV;
         end
    end
end

always @(posedge clk or posedge rst) begin //处理行同步信号
    if (rst) begin
        hs<=0;
    end else begin
        if (pix_cnt<H_FP) begin
            hs<=~HS_POL;
        end else if(pix_cnt>=H_FP&&pix_cnt<=(H_FP+H_SYNC)) begin
            hs <= HS_POL;
        end else if( pix_cnt>(H_FP+H_SYNC)) begin
            hs<=~HS_POL;
        end else begin
            hs <= hs;
        end
    end
end

always @(posedge clk or posedge rst) begin //处理场同步信号
    if (rst) begin
        vs<=0;
    end else begin
        if (line_cnt<V_FP) begin
            vs<=~VS_POL;
        end else if(line_cnt>=V_FP&&line_cnt<=(V_FP+V_SYNC)) begin
            vs <= VS_POL;
        end else if(line_cnt>(V_FP+V_SYNC)) begin
            vs<=~VS_POL;
        end else begin
            vs <= vs;
        end
    end
end


always @(posedge clk or posedge rst) begin
    if (rst) begin
        red<=7'd0;
        green<=7'd0;
        blue<=7'd0;
    end else if (h_actv&v_actv) begin
        if (Y_Point<240) begin
            red<=255;
            green<=0;
            blue<=0;
        end else if(Y_Point>=240&&Y_Point<480) begin
            red<=0;
            green<=255;
            blue<=0;
        end else if(Y_Point>=480&&Y_Point<720) begin
            red<=0;
            green<=0;
            blue<=255;
        end else begin
            red<=255;
            green<=255;
            blue<=255;
        end
    end else begin
        red<=red;
        green<=green;
        blue<=blue;
    end
end


endmodule