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

wire signed [31:0] image_in_0;
wire signed [31:0] image_in_1;
wire signed [31:0] image_in_2;
wire signed [31:0] image_in_3;
wire signed [31:0] image_in_4;
wire signed [31:0] image_in_5;

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
wire weight_c;
wire [5:0] ovalid;
wire [5:0] conv_done;

parameter IDLE = 3'b000;
parameter CONV_1 = 3'b001;
parameter CONV_2 = 3'b010;
parameter FC = 3'b011;
parameter CLASSES = 3'b100;

reg [2:0] state, next_state;
reg [7:0] conv_cnt;


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
            if(conv_cnt == 8'd13)
                next_state = FC;
            else
                next_state = CONV_2; 
        end
        FC:begin
            
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