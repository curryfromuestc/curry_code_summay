`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/14 21:43:01
// Design Name: 
// Module Name: decoder_core_tb
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


module decoder_core_tb(

    );
    reg clk;
    reg rst_n;
    wire [79:0] data_in;
    reg valid_in;
    wire [223:0] data_out;
    wire valid_out;
    wire valid_out_us;
    reg [79:0]data_in_sum[111:0];
    reg [6:0] i;

    //生成时钟与复位信号
    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;
        #100;
        valid_in = 1;
    end
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end
    //读取txt文件当中的数据
    
    initial begin
        $readmemb("C:\\Users\\curry_yang\\code\\python_tools\\data.txt",data_in_sum);
    end

    assign  data_in = data_in_sum[i];
    
    always@(posedge clk or negedge rst_n)begin
        if(~rst_n) begin
            i <= 0;
            valid_in <= 0;
        end
        else begin
            if(valid_out_us)begin
                i <= i + 1;
                valid_in <= 1;
            end
            else begin
                i <= i;
                valid_in <= 0;
            end
        end
    end
 
    //当valid_out为1时，就停止仿真，并打印仿真完成
//    always@(posedge clk or negedge rst_n)begin
//        if(~rst_n) begin
//            $display("Simulation start");
//        end
//        else begin
//            if(valid_out) begin
//                $display("Sim ulation done");
//                $finish;
//            end
//        end
//    end
    
    //实例化模块
    decoder_core decoder_core_inst(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out),
        .valid_out_us(valid_out_us)
    );

endmodule
