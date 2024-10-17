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

//-----------------卷积计算结束标志位-----------------
wire [5:0] cpnv_done;

//----------------模块输入端口----------------
wire [39:0] taps;
reg signed[31:0] add_data[0:5];
reg signed[31:0] relu_data[0:5];

//-----------------模块输出端口--------------
wire signed [31:0] conv_result[0:5];
wire signed [31:0] add_result[0:5];
wire signed [31:0] relu_result[0:5];
wire signed [31:0] polling_result[0:5];
wire signed [31:0] fc_result[0:9];
reg signed [31:0] result_r0[0:9];
reg signed [31:0] result_r1[0:9];

reg [3:0] conv_counter = 4'd0;//!卷积计算次数计数

//feature_map读参数控制
reg [5:0] fmap_rdrst;
reg [5:0] fmap_rden;

//滑窗模块的输入端口
reg [7:0] image_in;                      

//状态控制
// 卷积模块：0:28x28(第一层卷积层)
reg state; 

reg [10:0] weight_counter;//!权值计数器

reg signed weight_c [0:5];//!卷积层权值
reg signed weight_fc [0:9];//!全连接层权值

reg [9:0] cnt;

reg [5:0] fmap_wren;
wire [31:0] fmap_dout[0:5];//!第一层输出的缓存

reg [11:0] s_fifo_valid;
reg signed [31:0] s_fifo_data [0:11];
wire [11:0] s_fifo_ready;
wire [11:0] m_fifo_valid;
wire signed [31:0] m_fifo_data [0:11];
reg [11:0] m_fifo_ready;

reg start_conv_ff_0;
reg start_conv_ff_1;
reg start_conv_ff_2;

wire start_conv_r;

reg [10:0] cnt_fc;
reg [9:0] weight_fc_en;

assign conv_cnt = conv_counter;

reg start_cnn_delay;
//加速器启动，打一拍
always @(posedge clk or negedge rstn)begin
    if(!rstn)
        start_cnn_delay <= 1'b0;
    else
        start_cnn_delay <= start_cnn;
    end
wire start_cnn_r;
assign start_cnn_r = start_cnn && ~start_cnn_delay; // 采样上升沿    

//--------------------结果计数--------------------
reg [9:0] conv_result_cnt;
always @(posedge clk) begin
    if(!start_conv)
        conv_result_cnt <= 10'd0;
    else
        if(conv_wren == 6'b111111)
            conv_result_cnt <= conv_result_cnt + 10'd1;
        else
            conv_result_cnt <= conv_result_cnt;
end
reg [6:0] add_result_cnt;
always@(posedge clk)
begin
    case(conv_counter)
    4'd4,4'd5,4'd6,4'd7,4'd8,4'd9,4'd10,4'd11,4'd12,4'd13:begin
        if(add_result_cnt == 7'd64)
            add_result_cnt <= 7'd0;
        else
            if(add_wren == 6'b111111)
                add_result_cnt <= add_result_cnt + 7'd1;
            else
                add_result_cnt <= add_result_cnt;
        end
    default:add_result_cnt <= 7'd0;
    endcase
end

endmodule