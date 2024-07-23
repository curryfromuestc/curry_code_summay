`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/10 22:16:06
// Design Name: 
// Module Name: decoder_core
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


module decoder_core(
    input clk,//!输入时钟
    input rst_n,
    input en,
    input [7:0]data_in,
    output reg[223:0]data_out,
    output valid_out
    );

//!内部信号
reg [31:0] accumerlator;
reg [6:0] addra;
wire douta_w;

reg [6:0] cout;//!统计从第一微秒到第120微妙的数据
reg [6:0] cout_us;//!每一微秒的八十个脉冲进行计数

parameter IDLE = 2'b00,//!空闲状态
          PRE = 2'b01,//!准备状态，判断前挡脉冲的状态
          DECODER = 2'b11,//!解码状态
          DONE = 2'b10;//!完成这包数据的解码的状态
reg [1:0] state,next_state;//!状态机的状态

reg[1:0]valid_pre;
reg valid_decoder;

//!下一状态逻辑
always@(posedge clk or negedge rst_n)begin
    if(~rst_n)
        state <= IDLE;
    else
        state <= next_state; 
end

//!状态转移逻辑
always @( *) begin
    case(state)
        IDLE:begin
            if(en)begin
                if(valid_pre == 2'b10)
                    next_state = PRE;
                else
                    next_state = IDLE; 
            end
            else
                next_state = IDLE;
        end
        PRE:begin
            if(cout == 7)
                next_state = DECODER;
            else
                next_state = PRE;
        end
        DECODER:begin
            if(cout == 119)
                next_state = DONE;
            else
                next_state = DECODER;
        end
        DONE:begin
            next_state = IDLE;
        end

    endcase
end

//-----------------输出逻辑-------------------
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        cout <= 0;
        cout_us <= 0;
    end
    else begin
        if(cout_us<79)begin
            cout_us <= cout_us + 1;
            cout <= cout;
        end
        else begin
            cout_us <= 0;
            if(cout < 119)
                cout <= cout + 1;
            else
                cout <= 0;
        end
    end
end



//实例化ROM
blk_mem_gen_0 blk_mem_gen_0_inst (
    .clka(clk),
    .addra(addra),
    .douta(douta_w)
    );

endmodule
