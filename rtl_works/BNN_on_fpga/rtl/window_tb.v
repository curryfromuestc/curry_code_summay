module window_tb();
    //输入
    reg clk;
    reg start;
    reg [7:0] din;
    reg state;
    //输出
    wire [39:0] taps;

    //文件指针
    integer fp_i;
    integer count_w;

    //读取行技术
    reg[10:0]cnt_line;

    //实例化
    window window_inst(
        .clk(clk),
        .start(start),
        .din(din),
        .state(state),
        .taps(taps)
    );
endmodule