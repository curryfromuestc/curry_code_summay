module tb_down_counter;

    reg clk;
    reg reset;
    reg start;
    reg [1:0] mode;
    wire [15:0] count;
    wire interrupt;

    // 实例化计数器
    down_counter uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .mode(mode),
        .count(count),
        .interrupt(interrupt)
    );

    // 时钟生成
    always begin
        #5 clk = ~clk;
    end

    // 初始化信号
    initial begin
        reset = 1;
        start = 0;
        mode = 2'b00;
        #15
        reset = 0;
        start = 1;
    end

    // 测试用例
    initial begin
        // 测试Free running模式
        mode = 2'b00;
        #100
        
        // 测试Cyclic模式
        mode = 2'b01;
        #200
        
        // 测试Single模式
        mode = 2'b10;
        #300

        $stop;
    end

endmodule
