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
    input wire[4:0]data_in,
    output reg data_out  
    );
    //定义寄存器，缓冲三列数据
    reg[4:0] data_buff_1,data_buff_2,data_buff_3,data_buff_4;//!缓存数据
    reg[4:0] data_in_add,data_buff_1_add,data_buff_2_add,data_buff_3_add,data_buff_4_add;//!缓存数据

    reg[4:0] data_out_pre;//!输出数据的缓存

    always @( *) begin
        case(data_in)
            5'b00000:data_in_add=0;
            5'b00001:data_in_add=1;
            5'b00010:data_in_add=1;
            5'b00011:data_in_add=2;
            5'b00100:data_in_add=1;
            5'b00101:data_in_add=2;
            5'b00110:data_in_add=2;
            5'b00111:data_in_add=3;
            5'b01000:data_in_add=1;
            5'b01001:data_in_add=2;
            5'b01010:data_in_add=2;
            5'b01011:data_in_add=3;
            5'b01100:data_in_add=2;
            5'b01101:data_in_add=3;
            5'b01110:data_in_add=3;
            5'b01111:data_in_add=4;
            5'b10000:data_in_add=1;
            5'b10001:data_in_add=2;
            5'b10010:data_in_add=2;
            5'b10011:data_in_add=3;
            5'b10100:data_in_add=2;
            5'b10101:data_in_add=3;
            5'b10110:data_in_add=3;
            5'b10111:data_in_add=4;
            5'b11000:data_in_add=2;
            5'b11001:data_in_add=3;
            5'b11010:data_in_add=3;
            5'b11011:data_in_add=4;
            5'b11100:data_in_add=3;
            5'b11101:data_in_add=4;
            5'b11110:data_in_add=4;
            5'b11111:data_in_add=5;
        endcase
        case(data_buff_1)
            5'b00000:data_buff_1_add=0;
            5'b00001:data_buff_1_add=1;
            5'b00010:data_buff_1_add=1;
            5'b00011:data_buff_1_add=2;
            5'b00100:data_buff_1_add=1;
            5'b00101:data_buff_1_add=2;
            5'b00110:data_buff_1_add=2;
            5'b00111:data_buff_1_add=3;
            5'b01000:data_buff_1_add=1;
            5'b01001:data_buff_1_add=2;
            5'b01010:data_buff_1_add=2;
            5'b01011:data_buff_1_add=3;
            5'b01100:data_buff_1_add=2;
            5'b01101:data_buff_1_add=3;
            5'b01110:data_buff_1_add=3;
            5'b01111:data_buff_1_add=4;
            5'b10000:data_buff_1_add=1;
            5'b10001:data_buff_1_add=2;
            5'b10010:data_buff_1_add=2;
            5'b10011:data_buff_1_add=3;
            5'b10100:data_buff_1_add=2;
            5'b10101:data_buff_1_add=3;
            5'b10110:data_buff_1_add=3;
            5'b10111:data_buff_1_add=4;
            5'b11000:data_buff_1_add=2;
            5'b11001:data_buff_1_add=3;
            5'b11010:data_buff_1_add=3;
            5'b11011:data_buff_1_add=4;
            5'b11100:data_buff_1_add=3;
            5'b11101:data_buff_1_add=4;
            5'b11110:data_buff_1_add=4;
            5'b11111:data_buff_1_add=5;
        endcase
        case(data_buff_2)
            5'b00000:data_buff_2_add=0;
            5'b00001:data_buff_2_add=1;
            5'b00010:data_buff_2_add=1;
            5'b00011:data_buff_2_add=2;
            5'b00100:data_buff_2_add=1;
            5'b00101:data_buff_2_add=2;
            5'b00110:data_buff_2_add=2;
            5'b00111:data_buff_2_add=3;
            5'b01000:data_buff_2_add=1;
            5'b01001:data_buff_2_add=2;
            5'b01010:data_buff_2_add=2;
            5'b01011:data_buff_2_add=3;
            5'b01100:data_buff_2_add=2;
            5'b01101:data_buff_2_add=3;
            5'b01110:data_buff_2_add=3;
            5'b01111:data_buff_2_add=4;
            5'b10000:data_buff_2_add=1;
            5'b10001:data_buff_2_add=2;
            5'b10010:data_buff_2_add=2;
            5'b10011:data_buff_2_add=3;
            5'b10100:data_buff_2_add=2;
            5'b10101:data_buff_2_add=3;
            5'b10110:data_buff_2_add=3;
            5'b10111:data_buff_2_add=4;
            5'b11000:data_buff_2_add=2;
            5'b11001:data_buff_2_add=3;
            5'b11010:data_buff_2_add=3;
            5'b11011:data_buff_2_add=4;
            5'b11100:data_buff_2_add=3;
            5'b11101:data_buff_2_add=4;
            5'b11110:data_buff_2_add=4;
            5'b11111:data_buff_2_add=5;
        endcase
        case(data_buff_3)
            5'b00000:data_buff_3_add=0;
            5'b00001:data_buff_3_add=1;
            5'b00010:data_buff_3_add=1;
            5'b00011:data_buff_3_add=2;
            5'b00100:data_buff_3_add=1;
            5'b00101:data_buff_3_add=2;
            5'b00110:data_buff_3_add=2;
            5'b00111:data_buff_3_add=3;
            5'b01000:data_buff_3_add=1;
            5'b01001:data_buff_3_add=2;
            5'b01010:data_buff_3_add=2;
            5'b01011:data_buff_3_add=3;
            5'b01100:data_buff_3_add=2;
            5'b01101:data_buff_3_add=3;
            5'b01110:data_buff_3_add=3;
            5'b01111:data_buff_3_add=4;
            5'b10000:data_buff_3_add=1;
            5'b10001:data_buff_3_add=2;
            5'b10010:data_buff_3_add=2;
            5'b10011:data_buff_3_add=3;
            5'b10100:data_buff_3_add=2;
            5'b10101:data_buff_3_add=3;
            5'b10110:data_buff_3_add=3;
            5'b10111:data_buff_3_add=4;
            5'b11000:data_buff_3_add=2;
            5'b11001:data_buff_3_add=3;
            5'b11010:data_buff_3_add=3;
            5'b11011:data_buff_3_add=4;
            5'b11100:data_buff_3_add=3;
            5'b11101:data_buff_3_add=4;
            5'b11110:data_buff_3_add=4;
            5'b11111:data_buff_3_add=5;
        endcase
        case(data_buff_4)
            5'b00000:data_buff_4_add=0;
            5'b00001:data_buff_4_add=1;
            5'b00010:data_buff_4_add=1;
            5'b00011:data_buff_4_add=2;
            5'b00100:data_buff_4_add=1;
            5'b00101:data_buff_4_add=2;
            5'b00110:data_buff_4_add=2;
            5'b00111:data_buff_4_add=3;
            5'b01000:data_buff_4_add=1;
            5'b01001:data_buff_4_add=2;
            5'b01010:data_buff_4_add=2;
            5'b01011:data_buff_4_add=3;
            5'b01100:data_buff_4_add=2;
            5'b01101:data_buff_4_add=3;
            5'b01110:data_buff_4_add=3;
            5'b01111:data_buff_4_add=4;
            5'b10000:data_buff_4_add=1;
            5'b10001:data_buff_4_add=2;
            5'b10010:data_buff_4_add=2;
            5'b10011:data_buff_4_add=3;
            5'b10100:data_buff_4_add=2;
            5'b10101:data_buff_4_add=3;
            5'b10110:data_buff_4_add=3;
            5'b10111:data_buff_4_add=4;
            5'b11000:data_buff_4_add=2;
            5'b11001:data_buff_4_add=3;
            5'b11010:data_buff_4_add=3;
            5'b11011:data_buff_4_add=4;
            5'b11100:data_buff_4_add=3;
            5'b11101:data_buff_4_add=4;
            5'b11110:data_buff_4_add=4;
            5'b11111:data_buff_4_add=5;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            data_buff_1<=0;
            data_buff_2<=0;
            data_buff_3<=0;
            data_buff_4<=0;
        end
        else begin
            if(en)begin
            data_buff_1<=data_in;
            data_buff_2<=data_buff_1;
            data_buff_3<=data_buff_2;
            data_buff_4<=data_buff_3;
            end
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            data_out_pre<=0;
        end
        else begin
            if(en)begin
            
                data_out_pre<=data_buff_1_add+data_buff_2_add+data_buff_3_add+data_buff_4_add+data_in_add;
            end
            else begin
                data_out_pre<= 0;
            end
        end
    end

    always @( *) begin
        if(data_out_pre>=23)
            data_out <= 1'b1;
        else
            data_out <= 1'b0;
    end
    
endmodule
