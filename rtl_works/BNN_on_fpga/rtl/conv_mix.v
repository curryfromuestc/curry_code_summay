module conv_mix(
    input wire clk,
    input wire rstn,
    input wire start,//！启动信号，注意跟滑窗模块的启动信号时间不一�?
    input wire weight_en,//�? 权重有效信号
    input weight,//�? 以比特权�?
    input wire signed[31:0] din,
    input state,//�? 状�?�信�?
    output reg ovalid,//�? 输出有效信号
    output reg done,//�? 卷积运算完成信号
    output signed[31:0] dout
);
reg start_window;
wire [159:0] taps;
wire signed [31:0] conv_dout;
reg [7:0] cnt;//! 用于计数，工作时钟，控制滑窗模块启动时间
wire conv_ovalid;
wire conv_done;
window window_inst(
    .clk(clk),
    .start(start_window),
    .din(din),
    .state(state),
    .taps(taps)
);
conv conv_inst(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .weight_en(weight_en),
    .weight(weight),
    .taps(taps),
    .state(state),
    .dout(conv_dout),
    .ovalid(conv_ovalid),
    .done(conv_done)
);

//----------------------------控制滑窗模块启动时间----------------------------
//当state�?0时，滑窗模块启动时间相比卷积模块�?10个时钟周期，当state�?1时，滑窗模块启动时间相比卷积模块�?90个时钟周�?
always @(posedge clk) begin
    if (!rstn) begin
        cnt <= 8'd0;
        start_window <= 1'b0;
    end else begin
        if (state == 1'b0) begin
            if (cnt < 8'd9&&start) begin
                cnt <= cnt + 1;
                start_window <= 1'b0;
            end else begin
                cnt <= cnt;
                start_window <= start;
            end
        end else begin
            if (cnt < 8'd89&&start) begin
                cnt <= cnt + 1;
                start_window <= 1'b0;
            end else begin
                cnt <= cnt;
                start_window <= start;
            end
        end
    end
end

reg signed[31:0] relu_dout;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        ovalid <= 1'b0;
        done <= 1'b0;
        relu_dout <= 32'b0;
    end
    else begin
        done <= conv_done;
        if(conv_ovalid) begin
            ovalid <= 1'b1;
            if(conv_dout[31]) begin
                relu_dout <= 32'b0;
            end else begin
                relu_dout <= conv_dout;
            end
        end 
        else begin
            ovalid <= 1'b0;
            relu_dout <= 32'b0;
        end
    end
end

assign dout = relu_dout;


endmodule