module top(
    input wire clk,
    input wire rstn,

    input wire start_cnn,
    input wire image_tvalid,
    input wire [7:0] image_tdata,
    output wire image_tready,

    input wire weight_tvalid,
    input wire weight_tdata,
    output wire weight_tready,

    input wire weightfc_tvalid,
    input wire weightfc_tdata,
    output wire weightfc_tready,

    output wire cnn_done,

    output wire result_tvalid,
    output wire signed [31:0] result_tdata,

    output wire [3:0] conv_cnt
);
reg image_ready;
reg weight_ready;
reg weightfc_ready;
reg result_valid_r;
reg weight_read_r;
reg cnn_done_r;
reg signed[31:0]result_data;

assign image_tready = image_ready;
assign weight_tready = weight_ready;
assign weightfc_tready = weightfc_ready;
assign result_tvalid = result_valid_r;
assign result_tdata = result_data;
assign cnn_done = cnn_done_r;

reg start_window;//!滑窗模块启动标志
reg start_conv;//!卷积模块启动标志

//-----------------输出有效标志位-----------------
wire [5:0] conv_wren;
wire [5:0] add_wren;
wire [5:0] relu_wren;
wire [5:0] polling_wren;
wire [9:0] fc_wren;


    
endmodule