module CNN(
    input wire clk,
    input wire rstn,
    input wire start,
    input wire signed [31:0] din,
    output wire [9:0] classes,
    output wire done,
    output wire din_ready,
    output wire conv1_done
);

reg signed [31:0] fmap_0 [143:0];
reg signed [31:0] fmap_1 [143:0];
reg signed [31:0] fmap_2 [143:0];
reg signed [31:0] fmap_3 [143:0];
reg signed [31:0] fmap_4 [143:0];
reg signed [31:0] fmap_5 [143:0];

reg signed [31:0] fmap_conv2_0 [15:0];
reg signed [31:0] fmap_conv2_1 [15:0];
reg signed [31:0] fmap_conv2_2 [15:0];
reg signed [31:0] fmap_conv2_3 [15:0];
reg signed [31:0] fmap_conv2_4 [15:0];
reg signed [31:0] fmap_conv2_5 [15:0];

reg signed [31:0] fmap_fc_0 [15:0];
reg signed [31:0] fmap_fc_1 [15:0];
reg signed [31:0] fmap_fc_2 [15:0];
reg signed [31:0] fmap_fc_3 [15:0];
reg signed [31:0] fmap_fc_4 [15:0];
reg signed [31:0] fmap_fc_5 [15:0];
reg signed [31:0] fmap_fc_6 [15:0];
reg signed [31:0] fmap_fc_7 [15:0];
reg signed [31:0] fmap_fc_8 [15:0];
reg signed [31:0] fmap_fc_9 [15:0];
reg signed [31:0] fmap_fc_10 [15:0];
reg signed [31:0] fmap_fc_11 [15:0];

reg signed [31:0] fc_out [9:0];

wire signed [31:0] image_in_0;
wire signed [31:0] image_in_1;
wire signed [31:0] image_in_2;
wire signed [31:0] image_in_3;
wire signed [31:0] image_in_4;
wire signed [31:0] image_in_5;

wire signed [31:0] fc_in_0;
wire signed [31:0] fc_in_1;
wire signed [31:0] fc_in_2;
wire signed [31:0] fc_in_3;
wire signed [31:0] fc_in_4;
wire signed [31:0] fc_in_5;
wire signed [31:0] fc_in_6;
wire signed [31:0] fc_in_7;
wire signed [31:0] fc_in_8;
wire signed [31:0] fc_in_9;
wire signed [31:0] fc_in_10;
wire signed [31:0] fc_in_11;

wire signed [31:0] conv_result_0;
wire signed [31:0] conv_result_1;
wire signed [31:0] conv_result_2;
wire signed [31:0] conv_result_3;
wire signed [31:0] conv_result_4;
wire signed [31:0] conv_result_5;

wire din_ready_0;
wire din_ready_1;
wire din_ready_2;
wire din_ready_3;
wire din_ready_4;
wire din_ready_5;

wire stage
wire [5:0] weight_en;
wire [9:0] weight_en_fc;
wire weight_c;
wire weight_fc;
wire [5:0] ovalid;
wire [5:0] conv_done;
wire [5:0] fc_ivalid;
wire [5:0] fc_ovalid;

parameter IDLE = 3'b000;
parameter CONV_1 = 3'b001;
parameter CONV_2 = 3'b010;
parameter ADD = 3'b011;
parameter FC = 3'b100;
parameter CLASSES = 3'b101;

wire compare_done;
wire add_done;

reg [2:0] state, next_state;
reg [7:0] conv_cnt;
reg [9:0] fmap_cnt;//!控制卷积输出的值保存到fmap中

// always @(posedge clk) begin
//     if(ovalid[0])
//         fmap_0[fmap_cnt] <= conv_result_0;
//     else
//         fmap_0[fmap_cnt] <= fmap_0[fmap_cnt];
//     if(ovalid[1])
//         fmap_1[fmap_cnt] <= conv_result_1;
//     else
//         fmap_1[fmap_cnt] <= fmap_1[fmap_cnt];
//     if(ovalid[2])
//         fmap_2[fmap_cnt] <= conv_result_2;
//     else
//         fmap_2[fmap_cnt] <= fmap_2[fmap_cnt];
//     if(ovalid[3])
//         fmap_3[fmap_cnt] <= conv_result_3;
//     else
//         fmap_3[fmap_cnt] <= fmap_3[fmap_cnt];
//     if(ovalid[4])
//         fmap_4[fmap_cnt] <= conv_result_4;
//     else
//         fmap_4[fmap_cnt] <= fmap_4[fmap_cnt];
//     if(ovalid[5])
//         fmap_5[fmap_cnt] <= conv_result_5;
//     else
//         fmap_5[fmap_cnt] <= fmap_5[fmap_cnt];
// end

always @(posedge clk) begin
    case(state)
    IDLE:begin
        fmap_cnt <= 10'd0;
    end
    CONV_1:begin
        if(ovalid == 6'b111111)begin
            fmap_cnt <= fmap_cnt + 1;
            
        end
        else if(fmap_cnt == 10'd144)
            fmap_cnt <= 10'd0;
        else
            fmap_cnt <= fmap_cnt;
    end
    CONV_2:begin
        if(ovalid == 6'b111111)
            fmap_cnt <= fmap_cnt + 1;
        else if(fmap_cnt == 10'd16)
            fmap_cnt <= 10'd0;
        else
            fmap_cnt <= fmap_cnt;
    end
    ADD:begin
        
    end
    FC:begin
        
    end
    CLASSES:begin
        
    end
    endcase
end

//----------------------------卷积模块例化----------------------------
conv_mix conv_mix_0(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .weight_en(weight_en[0]),
    .weight(weight_c),
    .din(image_in_0),
    .state(stage),
    .ovalid(ovalid[0]),
    .done(conv_done[0]),
    .dout(conv_result_0),
    .din_ready(din_ready_0)
);
conv_mix conv_mix_1(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .weight_en(weight_en[1]),
    .weight(weight_c),
    .din(image_in_1),
    .state(stage),
    .ovalid(ovalid[1]),
    .done(conv_done[1]),
    .dout(conv_result_1),
    .din_ready(din_ready_1)
);
conv_mix conv_mix_2(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .weight_en(weight_en[2]),
    .weight(weight_c),
    .din(image_in_2),
    .state(stage),
    .ovalid(ovalid[2]),
    .done(conv_done[2]),
    .dout(conv_result_2),
    .din_ready(din_ready_2)
);
conv_mix conv_mix_3(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .weight_en(weight_en[3]),
    .weight(weight_c),
    .din(image_in_3),
    .state(stage),
    .ovalid(ovalid[3]),
    .done(conv_done[3]),
    .dout(conv_result_3),
    .din_ready(din_ready_3)
);
conv_mix conv_mix_4(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .weight_en(weight_en[4]),
    .weight(weight_c),
    .din(image_in_4),
    .state(stage),
    .ovalid(ovalid[4]),
    .done(conv_done[4]),
    .dout(conv_result_4),
    .din_ready(din_ready_4)
);
conv_mix conv_mix_5(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .weight_en(weight_en[5]),
    .weight(weight_c),
    .din(image_in_5),
    .state(stage),
    .ovalid(ovalid[5]),
    .done(conv_done[5]),
    .dout(conv_result_5),
    .din_ready(din_ready_5)
);

fc_12 fc_12_inst0(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[0]),
    .ovalid(fc_ovalid),
    .dout(fc_out[0])
);
fc_12 fc_12_inst1(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[1]),
    .ovalid(fc_ovalid),
    .dout(fc_out[1])
);
fc_12 fc_12_inst2(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[2]),
    .ovalid(fc_ovalid),
    .dout(fc_out[2])
);
fc_12 fc_12_inst3(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[3]),
    .ovalid(fc_ovalid),
    .dout(fc_out[3])
);
fc_12 fc_12_inst4(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[4]),
    .ovalid(fc_ovalid),
    .dout(fc_out[4])
);
fc_12 fc_12_inst5(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[5]),
    .ovalid(fc_ovalid),
    .dout(fc_out[5])
);
fc_12 fc_12_inst6(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[6]),
    .ovalid(fc_ovalid),
    .dout(fc_out[6])
);
fc_12 fc_12_inst7(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[7]),
    .ovalid(fc_ovalid),
    .dout(fc_out[7])
);
fc_12 fc_12_inst8(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[8]),
    .ovalid(fc_ovalid),
    .dout(fc_out[8])
);
fc_12 fc_12_inst9(
    .clk(clk),
    .rstn(rstn),
    .ivalid(fc_ivalid),
    .din_0(fc_in_0),
    .din_1(fc_in_1),
    .din_2(fc_in_2),
    .din_3(fc_in_3),
    .din_4(fc_in_4),
    .din_5(fc_in_5),
    .din_6(fc_in_6),
    .din_7(fc_in_7),
    .din_8(fc_in_8),
    .din_9(fc_in_9),
    .din_10(fc_in_10),
    .din_11(fc_in_11),
    .weight(weight_fc),
    .weight_en(weight_en_fc[9]),
    .ovalid(fc_ovalid),
    .dout(fc_out[9])
);
//!状态转移逻辑
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        state <= IDLE;
    else
        state <= next_state;
end

//!下一状态逻辑
always @( *) begin
    case(state)
        IDLE:begin
            if(start)
                next_state = CONV_1;
            else
                next_state = IDLE;
        end
        CONV_1:begin
            if(conv_done == 6'b111111)
                next_state = CONV_2;
            else
                next_state = CONV_1;
        end
        CONV_2:begin
            if(conv_done == 6'b111111)
                next_state = ADD;
            else
                next_state = CONV_2; 
        end
        ADD:begin
            if(add_done)begin
                if(conv_cnt == 8'd13 )
                    next_state = FC;
                else
                    next_state = CONV_2;
            end
            else
                next_state = ADD;
        end
        FC:begin
            if(fc_ovalid == 6'b111111)
                next_state = CLASSES;
            else
                next_state = FC;
        end
        CLASSES:begin
            if(compare_done)
                next_state = IDLE;
            else
                next_state = CLASSES;
        end
    endcase
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        conv_cnt <= 8'd0;
    else begin
        if(conv_done == 6'b111111)
            conv_cnt <= conv_cnt + 1;
        else 
            conv_cnt <= conv_cnt;
    end
end

endmodule