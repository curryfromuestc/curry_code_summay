module relu
(
    input clk,
    input signed [31:0] din,  
    input ivalid,
    output reg ovalid,   
    output reg signed [31:0] dout
);

	reg wren;
	reg [31:0] dout_r;
	reg [31:0] dout_delay;
	
	

	// 正数不变，负数为0
	always@(posedge clk)begin
		if(din[31])
			dout_r <= 0;
		else
			dout_r <= din;
	end
	// 延迟一拍
	always@(posedge clk)begin
		dout_delay <= dout_r;
	end

	
	// 输入有效，输出就有效
	always@(posedge clk)begin
		if(ivalid)
			wren <= 1'b1;
		else
			wren <= 1'b0;
	end
	
	always@(posedge clk)begin
		ovalid <= wren;
	end
	
endmodule
