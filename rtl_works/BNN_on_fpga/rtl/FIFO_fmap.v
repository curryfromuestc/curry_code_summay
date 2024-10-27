module FIFO_fmap
( 	
    input  clk,
	input  rstn,
	input  signed[31:0] din,
	input  wr_en, // 写使能
	input  rd_en, // 读使能
	input  rd_rst, // 读地址复位
	output empty,
	output full,
	output signed[31:0] dout
);
	reg [7:0] rd_ptr, wr_ptr;
	reg signed[31:0] mem [0:149];// 深度为 150
	reg signed[31:0] dout_r;
	
	assign empty = (wr_ptr == rd_ptr); // 当读和写地址一致时，说明数据都被读出去了，所以为空
	assign full  = ((wr_ptr - rd_ptr) == 8'd150);
	
	// 写使能延迟一拍
	reg wr_en_delay;
	always@(posedge clk)begin
		if(!rstn)
			wr_en_delay <= 0;
		else
			wr_en_delay <= wr_en;
	end
	
	// 写指针递增	
	always @(posedge clk or negedge rstn) 
	begin
		if(!rstn) 
			wr_ptr <= 0;
		else if(!full && wr_en_delay)// 非满且写使能
			wr_ptr <= wr_ptr + 1;
	end
	
	// 写操作
	always @(posedge clk) 
	begin
	if(rstn && wr_en_delay && !full)
		mem[wr_ptr] <= din;
	end
	
	// 读指针递增
	always @(posedge clk or negedge rstn) 
	begin
		if(!rstn)
			rd_ptr <= 0;
		else
			if(rd_rst)	
				rd_ptr <= 0;
			else if(!empty && rd_en)// 非空且读使能
				rd_ptr <= rd_ptr + 1;
	end
	
	// 读操作
	always @(posedge clk or negedge rstn)begin
		if(!rstn)
			dout_r <= 0;
		else if(rd_en && !empty)
			dout_r <= mem[rd_ptr];
	end
	
	assign dout = dout_r;

endmodule 
