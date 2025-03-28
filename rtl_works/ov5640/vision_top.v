module vision_top(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire[4:0]data_in,
    output wire[16:0] cout_six,
    output wire[16:0] cout_o,
    output wire[16:0] cout_four,
    output wire data_update,
    output wire stop  
);

wire[319:0] line_pixel_in;
wire start;
controller controller(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .data_in(data_in),
    .line_pixel(line_pixel_in),
    .start(start)
);


vision_core vision_core(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .line_pixel(line_pixel_in),
    .cout_six(cout_six),
    .cout_o(cout_o),
    .cout_four(cout_four),
    .data_update(data_update),
    .stop(stop)
);

endmodule