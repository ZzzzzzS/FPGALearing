`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 31.10.2020 21:41:12
// Design Name:
// Module Name: ExRW
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

`include "defines.v"

module ExRW(
         input Enable,

         input [`REG_BUS]Instruction_i,
         input [`REG_BUS]Opt1_i,
         input [`REG_BUS]Opt2_i,

         input  [`OPT_BUS]Rd_Addr_i,
         output [`OPT_BUS]Rd_Addr_o,
         output [`REG_BUS]Rd_o,

         input  [`MEM_BUS]Read_Memory_Value_i,
         output [`MEM_BUS]Write_Memory_Value_o,
         output Write_Enable_o,
         output [`MEM_ADDR_BUS]Memory_Addr_o
       );

wire [`COD_BUS]Opt_Code = Instruction_i[6:0];
wire [2:0]Funct3        = Instruction_i[14:12];

reg [`OPT_BUS]Rd_Addr;
reg [`REG_BUS]Rd;
reg [`MEM_BUS]Write_Memory_Value;
reg Write_Enable;
reg [`MEM_ADDR_BUS]Memory_Addr;

assign Rd_Addr_o = Rd_Addr;
assign Rd_o = Rd;
assign Write_Memory_Value_o  = Write_Memory_Value;
assign Write_Enable_o   = Write_Enable;
assign Memory_Addr_o    = Memory_Addr & 32'hFFFFFFFC; //保证访问的地址是对齐的

always @(*)
  begin
    if (Enable==`TRUE)
      begin
        case (Opt_Code)
          `I_TYPE_LOAD:
            begin
              Write_Memory_Value  = `MEM_ZERO;
              Memory_Addr   = Opt1_i; //会自动修正到对齐的地址
              Write_Enable  = `FALSE;
              case (Funct3)
                `I_LOAD_LB:
                  begin
                    case (Opt1_i[1:0]) //确定读取的字节属于字的哪个位置
                      2'd0:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={{24{Read_Memory_Value_i[7]}},Read_Memory_Value_i[7:0]};
                        end
                      2'd1:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={{24{Read_Memory_Value_i[15]}},Read_Memory_Value_i[15:8]};
                        end
                      2'd2:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={{24{Read_Memory_Value_i[23]}},Read_Memory_Value_i[23:16]};
                        end
                      2'd3:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={{24{Read_Memory_Value_i[31]}},Read_Memory_Value_i[31:24]};
                        end
                    endcase
                  end
                `I_LOAD_LH:
                  begin
                    case(Opt1_i[1]) //确定读取的半字属于字的哪个位置，非对齐访问将自动修正
                      1'b1:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={{16{Read_Memory_Value_i[31]}},Read_Memory_Value_i[31:16]};
                        end
                      1'b0:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={{16{Read_Memory_Value_i[15]}},Read_Memory_Value_i[15:0]};
                        end
                    endcase
                  end
                `I_LOAD_LW:
                  begin
                    Rd_Addr=Rd_Addr_i;
                    Rd=Read_Memory_Value_i;
                  end
                `I_LOAD_LBU:
                  begin
                    case (Opt1_i[1:0]) //确定读取的字节属于字的哪个位置
                      2'd0:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={24'b0,Read_Memory_Value_i[7:0]};
                        end
                      2'd1:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={24'b0,Read_Memory_Value_i[15:8]};
                        end
                      2'd2:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={24'b0,Read_Memory_Value_i[23:16]};
                        end
                      2'd3:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={24'b0,Read_Memory_Value_i[31:24]};
                        end
                    endcase
                  end
                `I_LOAD_LHU:
                  begin
                    case(Opt1_i[1]) //确定读取的半字属于字的哪个位置，非对齐访问将自动修正
                      1'b1:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={16'b0,Read_Memory_Value_i[31:16]};
                        end
                      1'b0:
                        begin
                          Rd_Addr=Rd_Addr_i;
                          Rd={16'b0,Read_Memory_Value_i[15:0]};
                        end
                    endcase
                  end
                default:
                  begin
                    Rd_Addr   = `OPT_ZERO;
                    Rd        = `REG_ZERO;
                  end
              endcase
            end
          `S_TYPE_STORE:
            begin
              Memory_Addr  = Opt1_i;
              Write_Enable = `TRUE;
              Rd_Addr   = `OPT_ZERO;
              Rd        = `REG_ZERO;
              case (Funct3)
                `S_STORE_SB:
                  begin
                    case (Opt1_i[1:0])
                      2'd0:
                        begin
                          Write_Memory_Value={Read_Memory_Value_i[31:8],Opt2_i[7:0]};
                        end
                      2'd1:
                        begin
                          Write_Memory_Value={Read_Memory_Value_i[31:16],Opt2_i[7:0],Read_Memory_Value_i[7:0]};
                        end
                      2'd2:
                        begin
                          Write_Memory_Value={Read_Memory_Value_i[31:24],Opt2_i[7:0],Read_Memory_Value_i[15:0]};
                        end
                      2'd3:
                        begin
                          Write_Memory_Value={Opt2_i[7:0],Read_Memory_Value_i[23:0]};
                        end
                    endcase
                  end
                `S_STORE_SH:
                  begin
                    case (Opt1_i[1]) //没有被对齐的写入将被修正
                      1'b0:
                        begin
                          Write_Memory_Value={Read_Memory_Value_i[31:16],Opt2_i[15:0]};
                        end
                      1'b1:
                        begin
                          Write_Memory_Value={Opt2_i[15:0],Read_Memory_Value_i[15:0]};
                        end
                    endcase
                  end
                `S_STORE_SW:
                  begin
                    Write_Memory_Value=Opt2_i;
                  end
                default:
                  begin
                    Write_Memory_Value  = `MEM_ZERO;
                  end
              endcase
            end
          default:
            begin
              Rd_Addr   = `OPT_ZERO;
              Rd        = `REG_ZERO;
              Memory_Addr   = `MEM_RESET_ADDR;
              Write_Memory_Value  = `MEM_ZERO;
              Write_Enable = `FALSE;
            end
        endcase
      end
    else
      begin
        Rd_Addr   = `OPT_ZERO;
        Rd        = `REG_ZERO;
        Memory_Addr   = `MEM_RESET_ADDR;
        Write_Memory_Value  = `MEM_ZERO;
        Write_Enable = `FALSE;
      end
  end

endmodule
