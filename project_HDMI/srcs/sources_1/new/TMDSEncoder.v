`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2020 18:29:15
// Design Name: 
// Module Name: TMDSEncoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 核心算法参考《Digital Visual Interface DVI Revision 1.0》.Page 29
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TMDSEncoder(
    input Clk,
    input Rst_n,

    input pC0,
    input pC1,
    input pVde,
    input [7:0]pDataIn,

    output [9:0]pDataOut
    );

integer cnt_t;
integer cnt_t_1;

reg [9:0]pDataOutReg;
assign pDataOut = pDataOutReg;

//定义流水线寄存器
reg [8:0] q_m_1,q_m_2;
reg pC0_1,pC0_2;
reg pC1_1,pC1_2;
reg pVde_1,pVde_2;
reg signed [3:0]cnt_2,cnt_3;
reg [9:0]q_out_2;

//////////////////////////////////////////////////////////////////////////////////
function [3:0]N1; //计算1的个数
    input [7:0]D;
    reg N1Reg;
    begin:N1Block
        integer i;
        for (i=0;i<8;i=i+1) begin
            N1Reg=N1Reg+D[i];
        end
        N1=N1Reg;
    end
endfunction

function [3:0]N0; //计算0的个数
    input [7:0]D;
    reg N0Reg;
    begin:N0Block
        integer i;
        for (i=0;i<8;i=i+1) begin
            N0Reg=N0Reg+(~D[i]);
        end
        N0=N0Reg;
    end
endfunction

//////////////////////////////////////////////////////////////////////////////////
//第一级流水线，选择计算方式并计算前八位

always @(posedge Clk) begin
    pVde_1 <= pVde;
    pC0_1  <= pC0;
    pC1_1  <= pC1;

    Stage1(pDataIn,q_m_1);
end

function [8:0]XOR; //异或运算
    input [7:0]D;
    begin:XORBlock
        integer i;
        XOR[0]=D[0];
        XOR[8]=1;
        for (i=1;i<8;i=i+1) begin
            XOR[i]=XOR[i-1]^D[i];
        end
    end
endfunction

function [8:0]XNOR; //同或运算
    input [7:0]D;
    begin:XNORBlock
        integer i;
        XNOR[0]=D[0];
        XNOR[8]=0;
        for (i=1;i<8;i=i+1) begin
            XNOR[i]=XNOR[i-1]^~D[i];
        end
    end
endfunction

task Stage1;
input  [7:0]D;
output [8:0]q_m;
reg [3:0]N1D;
reg [3:0]N0D;
begin
    if ((N1(D)>4'd4) || (N1(D)==4'd4 && D[0]==0)) begin
        q_m<=XNOR(pDataIn);
    end else begin
        q_m<=XOR(pDataIn);
    end
end
endtask

//////////////////////////////////////////////////////////////////////////////////
//第二级流水

always @(posedge Clk) begin
    pC0_2  <= pC0_1;
    pC1_2  <= pC1_1;
    pVde_2 <= pVde_1;
    q_m_2  <= q_m_1;

    Stage2(cnt_2,pC0_2,pC1_2,pVde_2,q_m_2,q_out_2,cnt_3);
end

task Stage2;
input signed [3:0]cnt1;
input pC0,pC1,pVde;
input [8:0]q_m;
output [9:0]q_out;
output signed [3:0]cnt;
begin
    if (pVde==1) begin
        if ((cnt1==0)||(N1(q_m[7:0])==N0(q_m[7:0]))) begin
            q_out[9] <= ~q_m[8];
            q_out[8] <=  q_m[8];
            if (q_m[8]==0) begin
                q_out[7:0] <= ~q_m[7:0];
                cnt <= cnt1 + N0(q_m[7:0]) - N1(q_m[7:0]);
            end else begin
                q_out[7:0] <= q_m[7:0];
                cnt <= cnt1 + N1(q_m[7:0]) - N0(q_m[7:0]);
            end
        end else begin
            if((cnt1>0 && (N1(q_m[7:0]) > N0(q_m[7:0]))) || (cnt1<0 && (N0(q_m[7:0]) > N1(q_m[7:0])))) begin
                q_out[9]   <=  1;
                q_out[8]   <=  q_m[8];
                q_out[7:0] <= ~q_m[7:0];
                cnt        <=  cnt1 + q_m[8] + q_m[8] + N0(q_m[7:0]) - N1(q_m[7:0]);
            end else begin
                q_out[9]   <=  0;
                q_out[8]   <=  q_m[8];
                q_out[7:0] <=  q_m[7:0];
                cnt        <=  cnt1 - (~q_m[8]) - (~q_m[8]) + N1(q_m[7:0]) - N0(q_m[7:0]);
            end
        end 
    end else begin
        case ({pC1,pC0})
            2'b00  : q_out <= 10'b0010101011;
            2'b01  : q_out <= 10'b1101010100;
            2'b10  : q_out <= 10'b0010101010;
            2'b11  : q_out <= 10'b1101010101;
            default: q_out <= 10'b0010101011;
        endcase
        cnt <= 4'd0;
    end
end
endtask

//////////////////////////////////////////////////////////////////////////////////
//第三级流水
always @(posedge Clk) begin
    cnt_2 <= cnt_3;
    pDataOutReg <= q_out_2;
end
endmodule
