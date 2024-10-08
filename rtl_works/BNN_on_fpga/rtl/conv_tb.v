module conv_tb();
    reg clk;
    reg rstn;
    reg start_conv;
    reg [7:0] image_in;
    reg start_window;
    reg state;
    reg [39:0] taps;
    reg weight_en;
    reg weight_c;
    reg signed [31:0] conv_result;
    reg conv_done;
    reg conv_ovalid;
    
    conv conv_inst(
        .clk(clk),
        .rstn(rstn),
        .start(start_conv),
        .weight_en(weight_en),
        .weight(weight_c),
        .taps(taps),
        .state(state),
        .dout(conv_result),
        .ovalid(conv_ovalid),
        .done(conv_done)
    );
    window window_inst(
        .clk(clk),
        .start(start_window),
        .din(image_in),
        .state(state),
        .taps(taps)
    );
endmodule