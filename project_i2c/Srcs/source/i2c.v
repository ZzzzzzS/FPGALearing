`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2020 18:47:08
// Design Name: 
// Module Name: i2c
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


module i2c(
    input  clk,

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
    output Valid            //从设备响应信号
    );

//////////////////////////////////////////////////////////////////////////////////
localparam WRITE = 0;
localparam READ  = 1;
//////////////////////////////////////////////////////////////////////////////////
//定义状态机的状态
localparam HOLDON        = 0;
localparam START         = 1;
localparam WRITE_ADDRESS = 2;
localparam ADDRESS_ACK   = 3;
localparam WRITE_VALUE   = 4;
localparam READ_VALUE    = 5;
localparam VALUE_ACK     = 6;
localparam READ_ACK      = 7;
//////////////////////////////////////////////////////////////////////////////////
reg [2:0]state;
reg [2:0]next_state;

reg LastStart;  //Start信号的上一个状态

reg [2:0]BitsRemain; //发送或者接受剩余的bits

//////////////////////////////////////////////////////////////////////////////////
localparam NO_ACK   = 0;
localparam NACK     = 1;
localparam ACK      = 2;
reg [1:0]ACK_State;
//////////////////////////////////////////////////////////////////////////////////
reg SDA_In_Reg; 
reg SDA_Out_Reg;
assign SDA_In = SDA_In_Reg;
assign SDA_Out = SDA_Out_Reg;

reg SCL_Reg;
assign SCL = SCL_Reg;


reg [7:0]WriteReg;
reg [7:0]ReadReg;

reg ReadyReg;
assign Ready = ReadyReg;
assign Valid = ACK_State[0]; //根据ACK信号直接判断是否有效
//////////////////////////////////////////////////////////////////////////////////
initial begin
state=HOLDON;
next_state=HOLDON;
LastStart=0;
SCL_Reg=1;
SDA_Out_Reg=1;
SDA_In_Reg=1;
SDA_R_W=WRITE;
ACK_State=NO_ACK;
BitsRemain=0;
end
//////////////////////////////////////////////////////////////////////////////////
always @(posedge clk) begin
    state<=next_state;
    LastStart<=Start;
end

always @(*) begin
    case (state)
        HOLDON:         begin if(LastStart==0 && Start==1)  next_state <= START;            else next_state <= HOLDON;          end
        START:          begin                               next_state <= WRITE_ADDRESS;                                        end
        WRITE_ADDRESS:  begin if(BitsRemain==3'd0)          next_state <= ADDRESS_ACK;      else next_state <= WRITE_ADDRESS;   end
        ADDRESS_ACK:    begin if(ACK_State == ACK)begin 
                                                    if (R_W==1) next_state <= READ_VALUE;
                                                    else        next_state <= WRITE_VALUE;
                        end else if(ACK_State == NACK)          next_state <= HOLDON;       else next_state <= ADDRESS_ACK;     end
        WRITE_VALUE:    begin if(BitsRemain==3'd0)          next_state <= VALUE_ACK;        else next_state <= WRITE_VALUE;     end
        READ_VALUE:     begin if(BitsRemain==3'd0)          next_state <= READ_ACK;         else next_state <= READ_VALUE;      end
        VALUE_ACK:      begin if(ACK_State==ACK)            next_state <= HOLDON;           else next_state <= VALUE_ACK;       end
        READ_ACK:       begin if(ACK_State==ACK)            next_state <= HOLDON;           else next_state <= READ_ACK;        end
        default:        begin                               next_state <= HOLDON;                                               end 
    endcase
end


always @(posedge clk) begin  
    //发送地址或数据
    if (state == WRITE_ADDRESS || state == WRITE_VALUE) begin
        if (SCL_Reg==1) begin //SCL低电平，输出SDA
            SCL_Reg     <= 0;
            SDA_Out_Reg <= WriteReg[7];
        end else begin        //SCL高电平，所存SDA，准备下一个SDA
            SCL_Reg     <= 1;
            BitsRemain  <= BitsRemain - 3'd1;
            WriteReg    <= {WriteReg[6:0],WriteReg[7]};
        end
        ACK_State       <= NO_ACK;
        SDA_R_W         <= WRITE;
    end

    //接收数据
    else if(state == READ_VALUE) begin
         if (SCL_Reg==1) begin //SCL低电平，处理接收数据
            SCL_Reg     <= 0;
            ReadReg     <= {ReadReg[6:0],ReadReg[7]};
         end else begin //SCL高电平，接收数据
            SCL_Reg     <= 1;
            ReadReg[0]  <= SDA_In_Reg;
            BitsRemain  <= BitsRemain - 3'd1;
         end
         ACK_State      <= NO_ACK;
         SDA_R_W        <= READ;
    end

    //接收写入地址或者写入数据的ACK
    else if (state==ADDRESS_ACK || state==VALUE_ACK) begin
        if (SCL_Reg==1) begin //SCL低电平时改变SDA脚方向，准备接受ACK
            SCL_Reg     <= 0;
            SDA_R_W     <= READ;
            ACK_State   <= NO_ACK;
        end else begin
            SCL_Reg     <= 1;
            if (SDA_In_Reg==0) begin
                ACK_State <= ACK;
                WriteReg  <= WriteValue; //收到ACK信号就准备写入数据
            end else begin
                ACK_State <= NACK;
            end
        end
        BitsRemain <= 3'd8;
    end

    //发送读取数据的ACK
    else if(state == READ_ACK) begin
        if (SCL_Reg==1) begin //SCL低电平时改变SDA脚方向，准备发送ACK
            SCL_Reg <= 0;
            SDA_R_W <= WRITE;
            ACK_State <= NO_ACK;
            SDA_Out_Reg <= 1;
        end else begin
            SCL_Reg <= 1;
            ACK_State <= ACK;
        end
        BitsRemain <= 3'd8;
    end

    //开始状态
    else if(state == START) begin
        SDA_R_W     <= WRITE; 
        SDA_Out_Reg <= 0; 
        SCL_Reg     <= 1; 
        BitsRemain  <= 3'd8;  
        WriteReg    <= {Address,R_W};
        ACK_State   <= NO_ACK;

        ReadyReg    <= 0;
    end

    //空闲状态
    else begin
        SDA_R_W     <= WRITE;
        SDA_Out_Reg <= 1;
        SCL_Reg     <= 1;
        ACK_State   <= NO_ACK;

        ReadyReg    <= 0;
    end

end

endmodule
