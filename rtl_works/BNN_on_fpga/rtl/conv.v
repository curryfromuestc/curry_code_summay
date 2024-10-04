module conv 
#(
   parameter K = 5,
   parameter S = 1 
)
(
    input wire clk,
    input wire rstn,
    input wire start,
    input wire weight_en,
    input weight,
    input [39:0] taps,
    input state,
    output signed [31:0] dout,
    output ovalid,
    output done
);
//------------------------变量定义----------------------------
reg [7:0] weight_addr = 8'd0;
reg [31:0] wt_data;

reg sum_valid;
reg sum_valid_ff;

reg [4:0] Ni; //! fmap的大小，输入图像的size
always @(*) begin
    if(!state)
        Ni = 28;
    else
        Ni = 12;
end
reg k00, k01, k02, k03, k04,
    k10, k11, k12, k13, k14,
    k20, k21, k22, k23, k24,
    k30, k31, k32, k33, k34,
    k40, k41, k42, k43, k44;//! 25个卷积核的权重，全是1bit
wire signed [7:0] m04,m14,m24,m34,m44;
reg signed [7:0] m00,m01,m02,m03,
    m10,m11,m12,m13,
    m20,m21,m22,m23,
    m30,m31,m32,m33,
    m40,m41,m42,m43;//! 缓存输入数据与权重矩阵重叠部分
reg signed [31:0] p00,p01,p02,p03,p04,
    p10,p11,p12,p13,p14,
    p20,p21,p22,p23,p24,
    p30,p31,p32,p33,p34,
    p40,p41,p42,p43,p44;//! 相乘的结果，流水线第一级
reg signed [31:0] sum000,sum001,sum002,sum003,sum004,
    sum010,sum011,sum012,sum013,sum014,
    sum020,sum021,sum022,sum023,sum024;//！ 流水线第二级
reg signed [31:0] sum100,sum101,sum102,sum103,sum104,
    sum110,sum111,sum112,sum113,sum114;//！ 流水线第三级
reg signed [31:0] sum200,sum201,sum202,sum203,sum204;//！ 流水线第四级
reg signed [31:0] sum30,sum21,sum32;//！ 流水线第五级
reg signed [31:0] sum40,sum41;//！ 流水线第六级

//----------------------------对输入矩阵进行赋值----------------------------
assign m04 = taps[39:32];
assign m14 = taps[31:24];
assign m24 = taps[23:16];
assign m34 = taps[15:8];
assign m44 = taps[7:0];

always @(posedge clk) begin
    {m00,m01,m02,m03} <= {m01,m02,m03,m04};
    {m10,m11,m12,m13} <= {m11,m12,m13,m14};
    {m20,m21,m22,m23} <= {m21,m22,m23,m24};
    {m30,m31,m32,m33} <= {m31,m32,m33,m34};
    {m40,m41,m42,m43} <= {m41,m42,m43,m44};
end
//------------------------读取权重矩阵---------------------------------
always @(posedge clk or negedge rstn) begin
    if(!rstn||!start)begin
        weight_addr <= 8'd0;
    end
    else begin
        if(weight_addr == 8'd25||!weight_en)
            weight_addr <= weight_addr;
        else
            weight_addr <= weight_addr + 8'd1; 
    end
end
always @(posedge clk) begin
    case(weight_addr)
        8'd0: k00 <= weight;
        8'd1: k01 <= weight;
        8'd2: k02 <= weight;
        8'd3: k03 <= weight;
        8'd4: k04 <= weight;
        8'd5: k10 <= weight;
        8'd6: k11 <= weight;
        8'd7: k12 <= weight;
        8'd8: k13 <= weight;
        8'd9: k14 <= weight;
        8'd10: k20 <= weight;
        8'd11: k21 <= weight;
        8'd12: k22 <= weight;
        8'd13: k23 <= weight;
        8'd14: k24 <= weight;
        8'd15: k30 <= weight;
        8'd16: k31 <= weight;
        8'd17: k32 <= weight;
        8'd18: k33 <= weight;
        8'd19: k34 <= weight;
        8'd20: k40 <= weight;
        8'd21: k41 <= weight;
        8'd22: k42 <= weight;
        8'd23: k43 <= weight;
        8'd24: k44 <= weight;
        default : ;
    endcase
end
//------------------------流水线第一级---------------------------------
always @(posedge clk) begin
    if(k00 == 1'b1)
        p00 <= {m00[7],24'b0,m00[6:0]};
    else
        p00 <= {~m00[7],24'b0,m00[6:0]};
end
always @(posedge clk) begin
    if(k01 == 1'b1)
        p01 <= {m01[7],24'b0,m01[6:0]};
    else
        p01 <= {~m01[7],24'b0,m01[6:0]};
end
always @(posedge clk) begin
    if(k02 == 1'b1)
        p02 <= {m02[7],24'b0,m02[6:0]};
    else
        p02 <= {~m02[7],24'b0,m02[6:0]};
end
always @(posedge clk) begin
    if(k03 == 1'b1)
        p03 <= {m03[7],24'b0,m03[6:0]};
    else
        p03 <= {~m03[7],24'b0,m03[6:0]};
end
always @(posedge clk) begin
    if(k04 == 1'b1)
        p04 <= {m04[7],24'b0,m04[6:0]};
    else
        p04 <= {~m04[7],24'b0,m04[6:0]};
end
always @(posedge clk) begin
    if(k10 == 1'b1)
        p10 <= {m10[7],24'b0,m10[6:0]};
    else
        p10 <= {~m10[7],24'b0,m10[6:0]};
end
always @(posedge clk) begin
    if(k11 == 1'b1)
        p11 <= {m11[7],24'b0,m11[6:0]};
    else
        p11 <= {~m11[7],24'b0,m11[6:0]};
end
always @(posedge clk) begin
    if(k12 == 1'b1)
        p12 <= {m12[7],24'b0,m12[6:0]};
    else
        p12 <= {~m12[7],24'b0,m12[6:0]};
end
always @(posedge clk) begin
    if(k13 == 1'b1)
        p13 <= {m13[7],24'b0,m13[6:0]};
    else
        p13 <= {~m13[7],24'b0,m13[6:0]};
end
always @(posedge clk) begin
    if(k14 == 1'b1)
        p14 <= {m14[7],24'b0,m14[6:0]};
    else
        p14 <= {~m14[7],24'b0,m14[6:0]};
end
always @(posedge clk) begin
    if(k20 == 1'b1)
        p20 <= {m20[7],24'b0,m20[6:0]};
    else
        p20 <= {~m20[7],24'b0,m20[6:0]};
end
always @(posedge clk) begin
    if(k21 == 1'b1)
        p21 <= {m21[7],24'b0,m21[6:0]};
    else
        p21 <= {~m21[7],24'b0,m21[6:0]};
end
always @(posedge clk) begin
    if(k22 == 1'b1)
        p22 <= {m22[7],24'b0,m22[6:0]};
    else
        p22 <= {~m22[7],24'b0,m22[6:0]};
end
always @(posedge clk) begin
    if(k23 == 1'b1)
        p23 <= {m23[7],24'b0,m23[6:0]};
    else
        p23 <= {~m23[7],24'b0,m23[6:0]};
end
always @(posedge clk) begin
    if(k24 == 1'b1)
        p24 <= {m24[7],24'b0,m24[6:0]};
    else
        p24 <= {~m24[7],24'b0,m24[6:0]};
end
always @(posedge clk) begin
    if(k30 == 1'b1)
        p30 <= {m30[7],24'b0,m30[6:0]};
    else
        p30 <= {~m30[7],24'b0,m30[6:0]};
end
always @(posedge clk) begin
    if(k31 == 1'b1)
        p31 <= {m31[7],24'b0,m31[6:0]};
    else
        p31 <= {~m31[7],24'b0,m31[6:0]};
end
always @(posedge clk) begin
    if(k32 == 1'b1)
        p32 <= {m32[7],24'b0,m32[6:0]};
    else
        p32 <= {~m32[7],24'b0,m32[6:0]};
end
always @(posedge clk) begin
    if(k33 == 1'b1)
        p33 <= {m33[7],24'b0,m33[6:0]};
    else
        p33 <= {~m33[7],24'b0,m33[6:0]};
end
always @(posedge clk) begin
    if(k34 == 1'b1)
        p34 <= {m34[7],24'b0,m34[6:0]};
    else
        p34 <= {~m34[7],24'b0,m34[6:0]};
end
always @(posedge clk) begin
    if(k40 == 1'b1)
        p40 <= {m40[7],24'b0,m40[6:0]};
    else
        p40 <= {~m40[7],24'b0,m40[6:0]};
end
always @(posedge clk) begin
    if(k41 == 1'b1)
        p41 <= {m41[7],24'b0,m41[6:0]};
    else
        p41 <= {~m41[7],24'b0,m41[6:0]};
end
always @(posedge clk) begin
    if(k42 == 1'b1)
        p42 <= {m42[7],24'b0,m42[6:0]};
    else
        p42 <= {~m42[7],24'b0,m42[6:0]};
end
always @(posedge clk) begin
    if(k43 == 1'b1)
        p43 <= {m43[7],24'b0,m43[6:0]};
    else
        p43 <= {~m43[7],24'b0,m43[6:0]};
end
always @(posedge clk) begin
    if(k44 == 1'b1)
        p44 <= {m44[7],24'b0,m44[6:0]};
    else
        p44 <= {~m44[7],24'b0,m44[6:0]};
end
//------------------------流水线第二级---------------------------------
always @(posedge clk) begin
    sum000 <= p00 + p10;
    sum001 <= p01 + p11;
    sum002 <= p02 + p12;
    sum003 <= p03 + p13;
    sum004 <= p04 + p14;
    sum010 <= p20 + p30;
    sum011 <= p21 + p31;
    sum012 <= p22 + p32;
    sum013 <= p23 + p33;
    sum014 <= p24 + p34;
    sum020 <= p40;
    sum021 <= p41;
    sum022 <= p42;
    sum023 <= p43;
    sum024 <= p44;
end
//------------------------流水线第三级---------------------------------
always @(posedge clk) begin
    
end
endmodule