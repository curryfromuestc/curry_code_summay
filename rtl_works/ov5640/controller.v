module controller(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire row_update,
    output wire[319:0] line_pixel,
    output reg start
);

wire data_out;
reg [8:0] col_counter;

assign line_pixel[1:0] = 2'b00;
assign line_pixel[319:318] = 2'b00;

//!例化高斯滤波器
gaosi_filter gaosi_filter_inst(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .data_in(data_in),
    .data_out(data_out)
);

endmodule