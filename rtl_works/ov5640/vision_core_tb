`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/19 15:47:53
// Design Name: 
// Module Name: vision_core_tb
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


module vision_core_tb(

    );
    reg clk;
    reg rst_n;
    reg [0:319] line_pixel_f[239:0];
    reg [319:0] line_pixel_in;
    reg  start;
    wire [16:0] cout_six;
    wire [16:0] cout_o;
    wire [16:0] cout_four;
    wire stop_o;
    
    wire data_update;

    reg [7:0] next_row;

initial begin
    $readmemb("C:\\Users\\curry_yang\\curry_code_summay\\rtl_works\\ov5640\\received_image_process.txt",line_pixel_f);
end

vision_core vision_core_tb(
    .line_pixel(line_pixel_in),
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .cout_six(cout_six),
    .cout_o(cout_o),
    .cout_four(cout_four),
    .data_update(data_update),
    .stop(stop_o)
);

initial begin                                                  
    clk = 0;
    rst_n=0;
    #100
    rst_n=1;
    #100
    start = 1;
    #100
    start = 0;

end

always begin                                                  
    #10 clk = ~clk;
end


always @(*) begin
    line_pixel_in <= line_pixel_f[next_row];
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        next_row <= 0;
    else if(data_update)
        next_row <= next_row + 1;
    else
        next_row <= next_row;
end

reg start_reg_1,start_reg_2;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        start <= 0;
        start_reg_1 <= 0;
        start_reg_2 <= 0;
    end
    else begin
        start_reg_2 <= start_reg_1;
        start <= start_reg_2;        
        if(data_update)begin
        start_reg_1 <= 1;
        end
        else begin
            start_reg_1 <= 0;
        end
    end
end

//!当stop拉高时，停止仿真
always @(posedge clk)begin
    if(stop_o)
        $finish;
end

endmodule