module top(
    input wire clk,
    input wire rstn,

    input wire start_cnn,
    input wire image_tvalid,
    input wire [31:0] image_tdata,
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
reg image_ready;//!图像数据准备标志位，在滑窗模块开始信号拉高过后启动
reg weight_ready;//！卷积权值准备标志位，在卷积模块开始信号拉高过后启动
reg weightfc_ready;//！全连接权值准备标志位，在卷积模块开始信号拉高过后启动
reg result_valid_r;
reg weight_rerd_r;
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
wire [5:0] conv_wren;//!卷积输出有效标志位，接在卷积模块的ovlaid上
wire [5:0] add_wren;//！累加输出有效标志位，接在累加模块的ovlaid上
wire [5:0] relu_wren;//！激活函数输出有效标志位，接在激活函数模块的ovlaid上
wire [5:0] pooling_wren;//！池化输出有效标志位，接在池化模块的ovlaid上
wire [9:0] fc_wren;//！全连接输出有效标志位，接在全连接模块的ovlaid上

//-----------------卷积计算结束标志位-----------------
wire [5:0] conv_done;

//----------------模块输入端口----------------
wire [159:0] taps;
reg signed[31:0] add_data[0:5];//！累加模块输入数据，从m_fifo中读取
reg signed[31:0] relu_data[0:5];//!relu模块输入数据，来自累加模块

//-----------------模块输出端口--------------
wire signed [31:0] conv_result[0:5];
wire signed [31:0] add_result[0:5];
wire signed [31:0] relu_result[0:5];
wire signed [31:0] pooling_result[0:5];
wire signed [31:0] fc_result[0:9];
reg signed [31:0] result_r0[0:9];//！fc输出数据第一波缓存
reg signed [31:0] result_r1[0:9];//！fc输出数据第二波缓存

reg [3:0] conv_counter = 4'd0;//!卷积计算次数计数

//feature_map读参数控制
reg [5:0] fmap_rdrst;
reg [5:0] fmap_rden;

//滑窗模块的输入端口
reg signed[31:0] image_in;                      

//状态控制
// 卷积模块：0:28x28(第一层卷积层)
reg state; 

reg [10:0] weight_counter;//!权值计数器

reg signed weight_c [0:5];//!卷积层权值
reg signed weight_fc [0:9];//!全连接层权值

reg [9:0] cnt;

reg [5:0] fmap_wren;
wire signed[31:0] fmap_dout[0:5];//!第一层输出的缓存

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
//六个卷积模块计算
reg [9:0] conv_result_cnt;//！统计卷积模块输出个数
always @(posedge clk) begin
    if(!start_conv)
        conv_result_cnt <= 10'd0;
    else
        if(conv_wren == 6'b111111)
            conv_result_cnt <= conv_result_cnt + 10'd1;
        else
            conv_result_cnt <= conv_result_cnt;
end
//累积模块，用于累积第二层的权重结果
reg [6:0] add_result_cnt;
always@(posedge clk)
begin
    case(conv_counter)
    4'd4,4'd5,4'd6,4'd7,4'd8,4'd9,4'd10,4'd11,4'd12,4'd13:begin
        if(add_result_cnt == 7'd64)//第二层卷积出来过后，每一个featuremap一共有是8*8个数据，所以是64个数据
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
//池化模块计算
reg [7:0] pooling_result_cnt;//！第一层池化完后是12*12个数据，所以是144个数据，第二层是4*4个数据，所以是16个数据
always@(posedge clk) begin
    case(conv_counter)
    4'd1:begin
        if(pooling_result_cnt == 8'd144)
            pooling_result_cnt <= 8'd0;
        else
            if(pooling_wren == 6'b111111)
                pooling_result_cnt <= pooling_result_cnt + 8'd1;
            else
                pooling_result_cnt <= pooling_result_cnt;
        end 
        4'd12,4'd13:begin
			if(pooling_result_cnt == 8'd16)
				pooling_result_cnt <= 8'd0;
			else
				if(pooling_wren == 6'b111111)
					pooling_result_cnt <= pooling_result_cnt + 8'd1;
				else
					pooling_result_cnt <= pooling_result_cnt;
			end
		default:pooling_result_cnt <= 8'd0;
		endcase    
    end
//-----------------全连接层模块计算----------------        
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        cnt_fc <= 0;
    else
    begin
        if(cnt_fc == 11'd1923)// 完成全连接计算
            cnt_fc <= cnt_fc;
        else if(start_cnn_delay)//卷积一开始，就给fc存权重
            cnt_fc <= cnt_fc + 1'b1;
    end
end
//完成十个全连接的计算
always@(posedge clk)begin
    if(cnt_fc <= 11'd1)
        weight_fc_en <= 10'b0000000000;
    else if(cnt_fc <= 11'd193)
        weight_fc_en <= 10'b0000000001;
    else if(cnt_fc <= 11'd385)
        weight_fc_en <= 10'b0000000010;
    else if(cnt_fc <= 11'd577)
        weight_fc_en <= 10'b0000000100;
    else if(cnt_fc <= 11'd769)
        weight_fc_en <= 10'b0000001000;
    else if(cnt_fc <= 11'd961)
        weight_fc_en <= 10'b0000010000;
    else if(cnt_fc <= 11'd1153)
        weight_fc_en <= 10'b0000100000;
    else if(cnt_fc <= 11'd1345)
        weight_fc_en <= 10'b0001000000;
    else if(cnt_fc <= 11'd1537)
        weight_fc_en <= 10'b0010000000;
    else if(cnt_fc <= 11'd1729)
        weight_fc_en <= 10'b0100000000;
    else if(cnt_fc <= 11'd1921)
        weight_fc_en <= 10'b1000000000;
    else
        weight_fc_en <= 10'b0000000000;
end
//全连接权重加载
always@(posedge clk or negedge rstn)
	begin
		if(!rstn)
			weightfc_ready <= 1'b0;
		else
			begin
				if(cnt_fc >= 11'd1921)
					weightfc_ready <= 1'b0;
				else if(cnt_fc == 11'd0)
					weightfc_ready <= 1'b0;
				else
					weightfc_ready <= 1'b1;
			end
	end
//--------------------卷积循环次数计数----------------------
reg start_conv_delay;
always@(posedge clk or negedge rstn)begin
if(!rstn)
    start_conv_delay <= 0;
else
    start_conv_delay <= start_conv;
end

assign start_conv_r = start_conv && (~start_conv_delay); // 采样上升沿

// 1~13
always@(posedge clk) 
if(cnn_done)
    conv_counter <= 4'd0;
else if(start_conv_r)// 开始一次卷积，计数+1
    conv_counter <= conv_counter + 1;
always @(*) begin
    case(conv_counter)
    4'd0,4'd1:
        state = 0;
    default :
        state = 1;
    endcase
end
//----------卷积权重读取-----------------
always@(posedge clk or negedge rstn)
	if(!rstn)
		weight_ready <= 1'b0;
	else
		begin
			if(!start_conv || cnt >= 10'd150) // cnt =150时，卷积模块权重加载好了
				weight_ready <= 1'b0;
			else
				weight_ready <= 1'b1; // 卷积模块启动且 cnt <
		end                      
    
always@(posedge clk or negedge rstn)begin
	if(!rstn)
		weight_rerd_r <= 0;
	else
		if(cnn_done)
			weight_rerd_r <= 1;
		else
			weight_rerd_r <= 0;
end
always@(posedge clk or negedge rstn)begin
	if(!rstn)
		weight_counter <= 0;
	else if(cnn_done)
		weight_counter <= 0;
	else if(weight_tvalid && weight_tready)
		weight_counter <= weight_counter + 1;
end
always@(posedge clk)
	begin
	//**********************第一次卷积循环*********************//
		if(weight_counter <= 11'd24)                                    
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd49)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd74)
			weight_c[2] <= weight_tdata;    
		else if(weight_counter <= 11'd99)
			weight_c[3] <= weight_tdata;
		else if(weight_counter <= 11'd124)
			weight_c[4] <= weight_tdata;
		else if(weight_counter <= 11'd149)
			weight_c[5] <= weight_tdata;
	//**********************第二次卷积循环*********************//
		else if(weight_counter <= 11'd174)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd199)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd224)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd249)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd274)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd299)
			weight_c[5] <= weight_tdata;             
	//**********************第三次卷积循环*********************//        
		else if(weight_counter <= 11'd324)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd349)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd374)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd399)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd424)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd449)
			weight_c[5] <= weight_tdata;                 
	//**********************第四次卷积循环*********************//        
		else if(weight_counter <= 11'd474)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd499)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd524)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd549)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd574)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd599)
			weight_c[5] <= weight_tdata;         
	//**********************第五次卷积循环*********************//               
		else if(weight_counter <= 11'd624)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd649)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd674)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd699)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd724)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd749)
			weight_c[5] <= weight_tdata;        
	//**********************第六次卷积循环*********************//         
		else if(weight_counter <= 11'd774)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd799)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd824)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd849)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd874)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd899)
			weight_c[5] <= weight_tdata; 
	//**********************第七次卷积循环*********************// 
		else if(weight_counter <= 11'd924)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd949)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd974)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd999)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd1024)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd1049)
			weight_c[5] <= weight_tdata; 
	//**********************第八次卷积循环*********************// 
		else if(weight_counter <= 11'd1074)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd1099)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd1124)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd1149)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd1174)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd1199)
			weight_c[5] <= weight_tdata; 
	//**********************第九次卷积循环*********************// 
		else if(weight_counter <= 11'd1224)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd1249)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd1274)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd1299)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd1324)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd1349)
			weight_c[5] <= weight_tdata; 
	//**********************第十次卷积循环*********************// 
		else if(weight_counter <= 11'd1374)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd1399)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd1424)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd1449)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd1474)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd1499)
			weight_c[5] <= weight_tdata; 
	//**********************第十一次卷积循环*********************// 
		else if(weight_counter <= 11'd1524)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd1549)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd1574)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd1599)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd1624)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd1649)
			weight_c[5] <= weight_tdata; 
	//**********************第十二次卷积循环*********************// 
		else if(weight_counter <= 11'd1674)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd1699)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd1724)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd1749)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd1774)
			weight_c[4] <= weight_tdata; 
		else if(weight_counter <= 11'd1799)
			weight_c[5] <= weight_tdata; 
	//**********************第十三次卷积循环*********************// 
		else if(weight_counter <= 11'd1824)
			weight_c[0] <= weight_tdata;
		else if(weight_counter <= 11'd1849)
			weight_c[1] <= weight_tdata;
		else if(weight_counter <= 11'd1874)
			weight_c[2] <= weight_tdata;        
		else if(weight_counter <= 11'd1899)
			weight_c[3] <= weight_tdata;        
		else if(weight_counter <= 11'd1924)
			weight_c[4] <= weight_tdata; 
		else
			weight_c[5] <= weight_tdata;
	end
//-------------------滑窗输入------------------
always@(posedge clk)begin
    case(conv_counter)
        4'd1:if(!start_window) image_ready <= 1'b0;
            else image_ready <= 1'b1;  // 滑窗模块，接收图像数据
        4'd2,4'd3:if(!start_window) fmap_rden <= 6'b000000;
            else fmap_rden <= 6'b000001; // 读 Feature Map             
        4'd4,4'd5:if(!start_window) fmap_rden <= 6'b000000;
            else fmap_rden <= 6'b000010;
        4'd6,4'd7:if(!start_window) fmap_rden <= 6'b000000;
            else fmap_rden <= 6'b000100;
        4'd8,4'd9:if(!start_window) fmap_rden <= 6'b000000;
            else fmap_rden <= 6'b001000;
        4'd10,4'd11:if(!start_window) fmap_rden <= 6'b000000;
            else fmap_rden <= 6'b010000;
        4'd12,4'd13:if(!start_window) fmap_rden <= 6'b000000;
            else fmap_rden <= 6'b100000;
        default:begin
                image_ready <= 1'b0;
                fmap_rden <= 6'b000000;
                end
    endcase
end
// fmap 读地址复位
always@(posedge clk)
begin
    case(conv_counter)
        4'd2:if(conv_done == 6'b111111)  fmap_rdrst <= 6'b000001;
            else fmap_rdrst <= 6'b000000;            
        4'd4:if(conv_done == 6'b111111)  fmap_rdrst <= 6'b000010;
            else fmap_rdrst <= 6'b000000;
        4'd6:if(conv_done == 6'b111111)  fmap_rdrst <= 6'b000100;
            else fmap_rdrst <= 6'b000000;
        4'd8:if(conv_done == 6'b111111)  fmap_rdrst <= 6'b001000;
            else fmap_rdrst <= 6'b000000;
        4'd10:if(conv_done == 6'b111111) fmap_rdrst <= 6'b010000;
            else fmap_rdrst <= 6'b000000;
        4'd12:if(conv_done == 6'b111111) fmap_rdrst <= 6'b100000;
            else fmap_rdrst <= 6'b000000;
        default:fmap_rdrst <= 6'b000000;
    endcase
end
always@(posedge clk)
	begin
		case(conv_counter)
			4'd1:		image_in <= image_tdata; 
			4'd2,4'd3:  image_in <= fmap_dout[0];
			4'd4,4'd5:  image_in <= fmap_dout[1];
			4'd6,4'd7:  image_in <= fmap_dout[2];
			4'd8,4'd9:  image_in <= fmap_dout[3];
			4'd10,4'd11:image_in <= fmap_dout[4];
			4'd12,4'd13:image_in <= fmap_dout[5];
			default:image_in <= 32'd0;
		endcase
	end
// 卷积模块工作周期计数
always@(posedge clk or negedge rstn)
begin
if(!rstn)
    cnt <= 10'd0;
else
    if(!start_conv)
        cnt <= 10'd0;
    else 
        cnt <= cnt + 10'd1;
end
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        start_window <= 0;
    else begin
        if(conv_done == 6'b111111)
            start_window <= 0;
        else begin
            case(state)
                1'b0: if(cnt == 10'd11) start_window <= 1; // 延迟 10个时钟周期用于数据和权重对齐
                1'b1: if(cnt == 10'd91) start_window <= 1;
            endcase
        end
    end
end
window window_inst(
		.clk  (clk),
		.start(start_window),
		.state(state),
		.din  (image_in),
		.taps (taps)
	);
always@(posedge clk or negedge rstn)begin
if(!rstn)
    start_conv <= 0;
else begin
    case(conv_counter)
        4'd0:begin
            // 6个卷积模块都完成卷积计算
            if(conv_done[0] && conv_done[1] && conv_done[2] && conv_done[3] && conv_done[4] && conv_done[5])
                start_conv <= 0;
            else 
                if(start_cnn_delay && ~cnn_done)// 卷积加速开始且未完成
                    start_conv <= 1;  // 第一次卷积循环
                else
                    start_conv <= start_conv;
            end
        4'd1:begin
            if(conv_done[0] && conv_done[1] && conv_done[2] && conv_done[3] && conv_done[4] && conv_done[5])
                start_conv <= 0;
            else 
                if(pooling_result_cnt == 8'd144)
                    start_conv <= 1; // 第二次
                else
                    start_conv <= start_conv;
            end
        4'd2,4'd3:begin
                if(conv_done[0] && conv_done[1] && conv_done[2] && conv_done[3] && conv_done[4] && conv_done[5])
                    start_conv <= 0;
                else
                    if(conv_result_cnt == 10'd64)
                        start_conv <= 1;
                    else
                        start_conv <= start_conv;
                end
        4'd4,4'd5,4'd6,4'd7,4'd8,4'd9,4'd10,4'd11:begin
                                                if(conv_done[0] && conv_done[1] && conv_done[2] && conv_done[3] && conv_done[4] && conv_done[5])
                                                    start_conv <= 0;
                                                else
                                                    if(add_result_cnt == 7'd64)
                                                        start_conv <= 1;
                                                    else
                                                        start_conv <= start_conv;
                                                end
        4'd12:begin
            if(conv_done[0] && conv_done[1] && conv_done[2] && conv_done[3] && conv_done[4] && conv_done[5])
                start_conv <= 0; 
            else
                if(fc_wren == 10'b1111111111)// 十个全连接模块输出均有效，即第12次卷积循环下的全连接层计算完毕才开始第13次卷积循环的计算
                    start_conv <= 1; // 第十三次
                else
                    start_conv <= start_conv;
            end
        4'd13:begin
            if(conv_done[0] && conv_done[1] && conv_done[2] && conv_done[3] && conv_done[4] && conv_done[5])
                start_conv <= 0;
            else
                if(fc_wren == 10'b1111111111)
                    start_conv <= start_conv;
            end
        default:start_conv <= 0;      
    endcase
    end
end
// 卷积模块权重读取使能
	// 0~5
reg [5:0] weight_en = 6'b000000;
always@(posedge clk)
begin
    if(cnt == 10'd0)
        weight_en <= 6'b000001; 
    else if(cnt == 10'd25)
        weight_en <= 6'b000010;
    else if(cnt == 10'd50)
        weight_en <= 6'b000100;
    else if(cnt == 10'd75)
        weight_en <= 6'b001000;
    else if(cnt == 10'd100)
        weight_en <= 6'b010000;
    else if(cnt == 10'd125)
        weight_en <= 6'b100000;
    else if(cnt == 10'd150) // 权重缓存完毕
        weight_en <= 6'b000000;	
    else
        weight_en <= weight_en; // 其他情况保持原值
end
genvar i;
generate
    for(i=0;i<=5;i=i+1)
        begin:conv_inst
            conv u_conv(.clk(clk),
                        .rstn(rstn),
                        .start(start_conv),
                        .weight_en(weight_en[i]),
                        .weight(weight_c[i]),
                        .taps(taps),
                        .state(state),
                        .dout(conv_result[i]),
                        .ovalid(conv_wren[i]),
                        .done(conv_done[i]));
            end
endgenerate
//缓存第二层中间参数
always@(posedge clk)begin
	case(conv_counter)
		4'd2:if(conv_wren == 6'b111111) s_fifo_valid <= 12'b000000111111;
			else s_fifo_valid <= 12'b000000000000;
		4'd3:if(conv_wren == 6'b111111) s_fifo_valid <= 12'b111111000000;
			else s_fifo_valid <= 12'b000000000000;
		4'd4,4'd6,4'd8,4'd10:if(add_wren == 6'b111111) s_fifo_valid <= 12'b000000111111;
			else s_fifo_valid <= 12'b000000000000;
		4'd5,4'd7,4'd9,4'd11:if(add_wren == 6'b111111) s_fifo_valid <= 12'b111111000000;
			else s_fifo_valid <= 12'b000000000000;
		default:s_fifo_valid <= 12'b000000000000;     
	endcase
end
always @(posedge clk) begin
    case(conv_counter)
        4'd2:begin
            s_fifo_data[0] <= conv_result[0];
            s_fifo_data[1] <= conv_result[1];
            s_fifo_data[2] <= conv_result[2];
            s_fifo_data[3] <= conv_result[3];
            s_fifo_data[4] <= conv_result[4];
            s_fifo_data[5] <= conv_result[5]; 
        end
        4'd3:begin
            s_fifo_data[6] <= conv_result[0];
            s_fifo_data[7] <= conv_result[1];
            s_fifo_data[8] <= conv_result[2];
            s_fifo_data[9] <= conv_result[3];
            s_fifo_data[10] <= conv_result[4];
            s_fifo_data[11] <= conv_result[5]; 
        end
        4'd4,4'd6,4'd8,4'd10:begin
            s_fifo_data[0] <= add_result[0];
            s_fifo_data[1] <= add_result[1];
            s_fifo_data[2] <= add_result[2];
            s_fifo_data[3] <= add_result[3];
            s_fifo_data[4] <= add_result[4];
            s_fifo_data[5] <= add_result[5]; 
        end
        4'd5,4'd7,4'd9,4'd11:begin
            s_fifo_data[6] <= add_result[0];
            s_fifo_data[7] <= add_result[1];
            s_fifo_data[8] <= add_result[2];
            s_fifo_data[9] <= add_result[3];
            s_fifo_data[10] <= add_result[4];
            s_fifo_data[11] <= add_result[5]; 
        end
        default:begin
            s_fifo_data[0] <= 32'd0;
            s_fifo_data[1] <= 32'd0;
            s_fifo_data[2] <= 32'd0;
            s_fifo_data[3] <= 32'd0;
            s_fifo_data[4] <= 32'd0;
            s_fifo_data[5] <= 32'd0;
            s_fifo_data[6] <= 32'd0;
            s_fifo_data[7] <= 32'd0;
            s_fifo_data[8] <= 32'd0;
            s_fifo_data[9] <= 32'd0;
            s_fifo_data[10] <= 32'd0;
            s_fifo_data[11] <= 32'd0;
        end
    endcase
end
//读出第二层中间参数，进行累加
always @(posedge clk) begin
    case(conv_counter)
    4'd4,4'd6,4'd8,4'd10,4'd12:if(conv_wren == 6'b111111) m_fifo_ready <= 12'b000000111111;
         else if(conv_wren == 6'b000000) m_fifo_ready <= 12'b000000000000;
    4'd5,4'd7,4'd9,4'd11,4'd13:if(conv_wren == 6'b111111) m_fifo_ready <= 12'b111111000000;
         else if(conv_wren == 6'b000000) m_fifo_ready <= 12'b000000000000;
    default:m_fifo_ready <= 12'b000000000000;
    endcase
end
//--------读出参数--------
always @(posedge clk) begin
    case(conv_counter)
    4'd4,4'd6,4'd8,4'd10,4'd12:begin
        if (m_fifo_valid[0] && m_fifo_ready[0])
            add_data[0] <= m_fifo_data[0];
        else
            add_data[0] <= 32'd0;

        if (m_fifo_valid[1] && m_fifo_ready[1])
            add_data[1] <= m_fifo_data[1];
        else
            add_data[1] <= 32'd0;

        if (m_fifo_valid[2] && m_fifo_ready[2])
            add_data[2] <= m_fifo_data[2];
        else
            add_data[2] <= 32'd0;

        if (m_fifo_valid[3] && m_fifo_ready[3])
            add_data[3] <= m_fifo_data[3];
        else
            add_data[3] <= 32'd0;

        if (m_fifo_valid[4] && m_fifo_ready[4])
            add_data[4] <= m_fifo_data[4];
        else
            add_data[4] <= 32'd0;

        if (m_fifo_valid[5] && m_fifo_ready[5])
            add_data[5] <= m_fifo_data[5];
        else
            add_data[5] <= 32'd0;
    end
    4'd5,4'd7,4'd9,4'd11,4'd13:begin
        if (m_fifo_valid[6] && m_fifo_ready[6])
            add_data[0] <= m_fifo_data[6];
        else
            add_data[0] <= 32'd0;

        if (m_fifo_valid[7] && m_fifo_ready[7])
            add_data[1] <= m_fifo_data[7];
        else
            add_data[1] <= 32'd0;

        if (m_fifo_valid[8] && m_fifo_ready[8])
            add_data[2] <= m_fifo_data[8];
        else
            add_data[2] <= 32'd0;

        if (m_fifo_valid[9] && m_fifo_ready[9])
            add_data[3] <= m_fifo_data[9];
        else
            add_data[3] <= 32'd0;

        if (m_fifo_valid[10] && m_fifo_ready[10])
            add_data[4] <= m_fifo_data[10];
        else
            add_data[4] <= 32'd0;

        if (m_fifo_valid[11] && m_fifo_ready[11])
            add_data[5] <= m_fifo_data[11];
        else
            add_data[5] <= 32'd0;
    end
    endcase
end
reg reset_fifo;
always@(posedge clk or negedge rstn)
if(!rstn)
    reset_fifo <= 0;
else
    if(cnn_done)
        reset_fifo <= 0;
    else
        reset_fifo <= 1;
//----------参数缓存----------
genvar a;
generate
	for(a= 0;a<=11;a=a+1)begin
		user_fifo_ip fifo_inst(
			.s_axis_aresetn(reset_fifo),          // input wire s_axis_aresetn
			.s_axis_aclk(clk),                // input wire s_axis_aclk
			.s_axis_tvalid(s_fifo_valid[a]),            // input wire s_axis_tvalid
			.s_axis_tready(s_fifo_ready[a]),            // output wire s_axis_tready
			.s_axis_tdata(s_fifo_data[a]),              // input wire [31 : 0] s_axis_tdata
			.m_axis_tvalid(m_fifo_valid[a]),            // output wire m_axis_tvalid
			.m_axis_tready(m_fifo_ready[a]),            // input wire m_axis_tready
			.m_axis_tdata(m_fifo_data[a])             // output wire [31 : 0] m_axis_tdata
		);
	end
endgenerate
//----------累加模块------------
reg ivalid_add;
always @(posedge clk) begin
	case(conv_counter)
	4'd4,4'd5,4'd6,4'd7,4'd8,4'd9,4'd10,4'd11,4'd12,4'd13:if(conv_wren == 6'b111111) ivalid_add <= 1'b1;
															else ivalid_add <= 1'b0;
	default:ivalid_add <= 1'b0;
	endcase
end
genvar b;
generate
	for(b=0;b<=5;b=b+1)begin
		add u_add(
			.clk(clk),
			.ivalid(ivalid_add),
			.din_0(conv_result[b]),
			.din_1(add_data[b]),
			.ovalid(add_wren[b]),
			.dout(add_result[b])
		);
	end
endgenerate
//---------判断ReLU模块何时运行----------
reg ivalid_relu;
always@(posedge clk)begin
	case(conv_counter)
	4'd1:if(conv_wren == 6'b111111) ivalid_relu <= 1'b1;
		else ivalid_relu <= 1'b0;
	4'd12,4'd13:if(add_wren == 6'b111111) ivalid_relu <= 1'b1;
		else ivalid_relu <= 1'b0;
	default:ivalid_relu <= 1'b0;
	endcase
end
//----------ReLU模块数据端口接口----------
always @(posedge clk) begin
	case(conv_counter)
	4'd1:begin
		relu_data[0] <= conv_result[0];
		relu_data[1] <= conv_result[1];
		relu_data[2] <= conv_result[2];
		relu_data[3] <= conv_result[3];
		relu_data[4] <= conv_result[4];
		relu_data[5] <= conv_result[5];
	end
	4'd12,4'd13:begin
		relu_data[0] <= add_result[0];
		relu_data[1] <= add_result[1];
		relu_data[2] <= add_result[2];
		relu_data[3] <= add_result[3];
		relu_data[4] <= add_result[4];
		relu_data[5] <= add_result[5];
	end
	default:begin
		relu_data[0] <= 32'd0;
		relu_data[1] <= 32'd0;
		relu_data[2] <= 32'd0;
		relu_data[3] <= 32'd0;
		relu_data[4] <= 32'd0;
		relu_data[5] <= 32'd0;
	end
	endcase
end
//----------例化ReLU模块----------
genvar c;
generate
	for(c=0;c<=5;c=c+1)begin
		relu u_relu(
			.clk(clk),
			.ivalid(ivalid_relu),
			.din(relu_data[c]),
			.ovalid(relu_wren[c]),
			.dout(relu_result[c])
		);
	end
endgenerate
//-------只有处在第一卷积循环、第12,13次卷积循环且激活模块完成计算时才启动池化模块-------
reg ivalid_pooling;
always@(posedge clk)
begin
	case(conv_counter)
		4'd1,4'd12,4'd13:
			if(relu_wren == 6'b111111) 
				ivalid_pooling <= 1'b1;
			else 
				ivalid_pooling <= 1'b0;
		default:ivalid_pooling <= 1'b0;
		endcase
end
genvar d;
generate
	for(d=0;d<=5;d=d+1)begin
		maxpool u_pooling(
			.clk(clk),
			.rstn(rstn),
			.ivalid(ivalid_pooling),
			.state(state),
			.din(relu_result[d]),
			.ovalid(pooling_wren[d]),
			.dout(pooling_result[d]) 
		);
	end
endgenerate
//==========================================================
//Layer1 Feature Map 缓存
//************第一层结果缓存**************//
// 只在第一次卷积循环且池化完成后才写入 fmap
always@(posedge clk)
if(conv_counter == 4'd1 && pooling_wren == 6'b111111)
    fmap_wren <= 6'b111111;
else
    fmap_wren <= 6'b000000;

// 一次卷积加速后复位 fmap
reg reset_fmap;
always@(posedge clk or negedge rstn)begin
if(!rstn)
    reset_fmap <= 0;
else
    if(cnn_done)
        reset_fmap <= 0;
    else
        reset_fmap <= 1;
end
genvar e;
generate
    for(e=0;e<=5;e=e+1)
        begin:fmap_inst
            FIFO_fmap u_FIFO_fmap (
              .clk(clk),
              .rstn(reset_fmap),
              .din(pooling_result[e]),
              .wr_en(fmap_wren[e]),
              .rd_en(fmap_rden[e]),
              .rd_rst(fmap_rdrst[e]),     
              .dout(fmap_dout[e]),
              .full(),
              .empty()
            );
        end
endgenerate
//------------------全连接成---------------
//开始之前，需要1920个时钟周期加载权重
always @(posedge clk) begin
	if(cnt_fc<=11'd1)begin
		weight_fc[0] <= 1'd0;
		weight_fc[1] <= 1'd0;
		weight_fc[2] <= 1'd0;
		weight_fc[3] <= 1'd0;
		weight_fc[4] <= 1'd0;
		weight_fc[5] <= 1'd0;
		weight_fc[6] <= 1'd0;
		weight_fc[7] <= 1'd0;
		weight_fc[8] <= 1'd0;
		weight_fc[9] <= 1'd0;
	end
	else if(cnt_fc <= 11'd193)
		weight_fc[0] <= weightfc_tdata;
	else if(cnt_fc <= 11'd385)
		weight_fc[1] <= weightfc_tdata;
	else if(cnt_fc <= 11'd577)
		weight_fc[2] <= weightfc_tdata;
	else if(cnt_fc <= 11'd769)
		weight_fc[3] <= weightfc_tdata;
	else if(cnt_fc <= 11'd961)
		weight_fc[4] <= weightfc_tdata;
	else if(cnt_fc <= 11'd1153)
		weight_fc[5] <= weightfc_tdata;
	else if(cnt_fc <= 11'd1345)
		weight_fc[6] <= weightfc_tdata;
	else if(cnt_fc <= 11'd1537)
		weight_fc[7] <= weightfc_tdata;
	else if(cnt_fc <= 11'd1729)
		weight_fc[8] <= weightfc_tdata;
	else if(cnt_fc <= 11'd1921)
		weight_fc[9] <= weightfc_tdata;
end
// 第12，13次卷积循环时，使能全连接模块输入端口
reg ivalid_fc;
always@(posedge clk)begin
	case(conv_counter)
	4'd12,4'd13:if(pooling_wren == 6'b111111) ivalid_fc <= 1;
		else ivalid_fc <= 0;
	default:ivalid_fc <= 0;
	endcase
end
genvar f;
generate
	for(f=0;f<10;f=f+1)
		begin:fullconnect_inst
			fc u_fullconnect(
				.clk(clk),
				.rstn(rstn),
				.ivalid(ivalid_fc),
				.din_0(pooling_result[0]),
				.din_1(pooling_result[1]),
				.din_2(pooling_result[2]),
				.din_3(pooling_result[3]),
				.din_4(pooling_result[4]),
				.din_5(pooling_result[5]),
				.weight(weight_fc[f]),
				.weight_en(weight_fc_en[f]),
				.ovalid(fc_wren[f]),
				.dout(fc_result[f])
			);
		end
endgenerate
//----------全连接层计算结果----------
integer r;
always@(posedge clk)begin
	case(conv_counter)
	4'd12:if(fc_wren == 10'b1111111111)
		begin
			result_r0[0] <= fc_result[0];
			result_r0[1] <= fc_result[1];
			result_r0[2] <= fc_result[2];
			result_r0[3] <= fc_result[3];
			result_r0[4] <= fc_result[4];
			result_r0[5] <= fc_result[5];
			result_r0[6] <= fc_result[6];
			result_r0[7] <= fc_result[7];
			result_r0[8] <= fc_result[8];
			result_r0[9] <= fc_result[9];
		end
	4'd13:if(fc_wren == 10'b1111111111)
		begin
			result_r1[0] <= fc_result[0] + result_r0[0];
			result_r1[1] <= fc_result[1] + result_r0[1];
			result_r1[2] <= fc_result[2] + result_r0[2];
			result_r1[3] <= fc_result[3] + result_r0[3];
			result_r1[4] <= fc_result[4] + result_r0[4];
			result_r1[5] <= fc_result[5] + result_r0[5];
			result_r1[6] <= fc_result[6] + result_r0[6];
			result_r1[7] <= fc_result[7] + result_r0[7];
			result_r1[8] <= fc_result[8] + result_r0[8];
			result_r1[9] <= fc_result[9] + result_r0[9];
		end
	default:begin
			result_r0[0] <= 0;
			result_r0[1] <= 0;
			result_r0[2] <= 0;
			result_r0[3] <= 0;
			result_r0[4] <= 0;
			result_r0[5] <= 0;
			result_r0[6] <= 0;
			result_r0[7] <= 0;
			result_r0[8] <= 0;
			result_r0[9] <= 0;
			result_r1[0] <= 0;
			result_r1[1] <= 0;
			result_r1[2] <= 0;
			result_r1[3] <= 0;
			result_r1[4] <= 0;
			result_r1[5] <= 0;
			result_r1[6] <= 0;
			result_r1[7] <= 0;
			result_r1[8] <= 0;
			result_r1[9] <= 0;
			end
	endcase
end

reg result_valid;
reg [3:0] cnt4;
always @(posedge clk or negedge rstn) begin
	if(!rstn)
    result_valid <= 0;
	else begin
		if(!start_cnn_delay)
			result_valid <= 0;
		else if(cnt4 > 4'd10)
			result_valid <= 0; 
		else if(conv_counter == 4'd13 && fc_wren == 10'b1111111111)
			result_valid <= 1; 
	end
end
always@(posedge clk or negedge rstn)
	begin
	if(!rstn)
		cnn_done_r <= 0;
	else
		if(start_cnn_r)
			cnn_done_r <= 0;
		else if(cnt4 == 4'd10)
			cnn_done_r <= 1; // 卷积加速完成
	end
   
	always@(posedge clk or negedge rstn)
	begin
	if(!rstn)
		cnt4 <= 0;
	else
		if(!result_valid)
			cnt4 <= 0;
		else
			cnt4 <= cnt4 + 1;
	end

always@(posedge clk or negedge rstn)
begin
if(!rstn)
    result_valid_r <= 1'b0;
else    
    if(cnt4 == 4'd0)
        result_valid_r <= 1'b0;
    else if(cnt4 <= 4'd10)
        result_valid_r <= 1'b1;
    else
        result_valid_r <= 1'b0;
end

always@(posedge clk)
begin
if(cnt4 > 4'd0 && cnt4 <= 4'd10)
    result_data <= result_r1[cnt4-1];
else
    result_data <= 0;
end
endmodule