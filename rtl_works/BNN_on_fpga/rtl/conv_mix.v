module conv_mix(
    input wire clk,
    input wire rstn,
    input wire start,//！启动信号，注意跟滑窗模块的启动信号时间不一�??
    input wire weight_en,//�?? 权重有效信号
    input weight,//�?? 以比特权�??
    input wire signed[31:0] din,
    input state,//�?? 状�?�信�??
    output wire ovalid,//�?? 输出有效信号
    output reg done,//�?? 卷积运算完成信号
    output wire din_ready,
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
//当state�??0时，滑窗模块启动时间相比卷积模块�??10个时钟周期，当state�??1时，滑窗模块启动时间相比卷积模块�??90个时钟周�??
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

assign din_ready = start_window;

reg signed[31:0] relu_dout;
reg relu_ovalid;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        relu_dout <= 32'b0;
        relu_ovalid <= 1'b0;
    end
    else begin
        if(conv_ovalid) begin
            relu_ovalid <= 1'b1;
            if(conv_dout[31]) begin
                relu_dout <= 32'b0;
            end else begin
                relu_dout <= conv_dout;
            end
        end 
        else begin
            relu_dout <= 32'b0;
            relu_ovalid <= 1'b0;
        end
    end
end

maxpool maxpool_inst(
    .clk(clk),
    .rstn(rstn),
    .ivalid(relu_ovalid),
    .state(state),
    .din(relu_dout),
    .ovalid(ovalid),
    .dout(dout)
);

reg [9:0]cnt_line;
always @(posedge clk or negedge rstn) begin
    if(!rstn)
        cnt_line <= 0;
    else begin
        if(relu_ovalid)
            cnt_line <= cnt_line + 1;
        else
            cnt_line <= cnt_line;
        end
end

always @( *) begin
    case(state)
    1'b0:begin
    if(cnt_line == 576)
        done <= 1;
    else
        done <= 0;
    end
    1'b1:begin
    if(cnt_line == 64)
        done <= 1;
    else
        done <= 0;
    end
    endcase
end



endmodule