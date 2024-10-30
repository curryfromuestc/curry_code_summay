module CNN(
    input wire clk,
    input wire rstn,
    input wire start,
    input wire signed [31:0] din,
    output wire [9:0] classes,
    output wire done,
    output wire din_ready
);

reg signed [31:0] fmap_0 [143:0];
reg signed [31:0] fmap_1 [143:0];
reg signed [31:0] fmap_2 [143:0];
reg signed [31:0] fmap_3 [143:0];
reg signed [31:0] fmap_4 [143:0];
reg signed [31:0] fmap_5 [143:0];

wire signed [31:0] conv_result_0;
wire signed [31:0] conv_result_1;
wire signed [31:0] conv_result_2;
wire signed [31:0] conv_result_3;
wire signed [31:0] conv_result_4;
wire signed [31:0] conv_result_5;

wire [5:0] weight_en;
wire weight_c;
wire [5:0] ovalid;
wire [5:0] conv_done;

parameter IDLE = 2'b00;
parameter CONV_1 = 2'b01;
parameter CONV_2 = 2'b10;
parameter FC = 2'b11;

reg [1:0] state, next_state;
reg [7:0] conv_cnt;
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
        CONV_2:
    endcase
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        conv_cnt <= 8'd0;
    else begin
        if(state == CONV_1)
    end
end

endmodule