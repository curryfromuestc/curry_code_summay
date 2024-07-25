`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/21 20:03:49
// Design Name: 
// Module Name: gaosi_filter
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


module gaosi_filter(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire data_in_1,
    input wire data_in_2,
    input wire data_in_3,
    input wire data_in_4,
    input wire data_in_5,
    output reg data_out_1,
    output reg data_out_2,
    output reg data_out_3,
    output reg data_out_4,
    output reg data_out_5  
    );
    //定义寄存器，缓冲三列数据
    reg data_buff_1_1,data_buff_1_2,data_buff_1_3,data_buff_1_4;//!缓存第一行的数据
    reg data_buff_2_1,data_buff_2_2,data_buff_2_3,data_buff_2_4;//!缓存第二行的数据
    reg data_buff_3_1,data_buff_3_2,data_buff_3_3,data_buff_3_4;//!缓存第三行的数据
    reg data_buff_4_1,data_buff_4_2,data_buff_4_3,data_buff_4_4;//!缓存第四行的数据
    reg data_buff_5_1,data_buff_5_2,data_buff_5_3,data_buff_5_4;//!缓存第五行的数据

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            data_buff_1_1<=0;
            data_buff_1_2<=0;
            data_buff_1_3<=0;
            data_buff_1_4<=0;
            data_buff_2_1<=0;
            data_buff_2_2<=0;
            data_buff_2_3<=0;
            data_buff_2_4<=0;
            data_buff_3_1<=0;
            data_buff_3_2<=0;
            data_buff_3_3<=0;
            data_buff_3_4<=0;
            data_buff_4_1<=0;
            data_buff_4_2<=0;
            data_buff_4_3<=0;
            data_buff_4_4<=0;
            data_buff_5_1<=0;
            data_buff_5_2<=0;
            data_buff_5_3<=0;
            data_buff_5_4<=0;
        end
        else begin
            if(en)begin
                data_buff_1_1<=data_in_1;
                data_buff_2_1<=data_in_2;
                data_buff_3_1<=data_in_3;
                data_buff_4_1<=data_in_4;
                data_buff_5_1<=data_in_5;
                data_buff_1_2<=data_buff_1_1;
                data_buff_2_2<=data_buff_2_1;
                data_buff_3_2<=data_buff_3_1;
                data_buff_4_2<=data_buff_4_1;
                data_buff_5_2<=data_buff_5_1;
                data_buff_1_3<=data_buff_1_2;
                data_buff_2_3<=data_buff_2_2;
                data_buff_3_3<=data_buff_3_2;
                data_buff_4_3<=data_buff_4_2;
                data_buff_5_3<=data_buff_5_2;
                data_buff_1_4<=data_buff_1_3;
                data_buff_2_4<=data_buff_2_3;
                data_buff_3_4<=data_buff_3_3;
                data_buff_4_4<=data_buff_4_3;
                data_buff_5_4<=data_buff_5_3;
            end
        end
    end
    

    
endmodule
