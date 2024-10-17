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
    
endmodule