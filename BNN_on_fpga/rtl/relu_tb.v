module relu_tb();

reg signed [31:0] din;
reg ivalid;
wire ovalid;
wire signed [31:0] dout;
reg clk;

relu relu_inst(
    .clk(clk),
    .din(din),
    .ivalid(ivalid),
    .ovalid(ovalid),
    .dout(dout)
);

initial begin
    clk = 0;
    din = 32'b0;
    ivalid = 0;
    #20 ivalid = 1;
    din = 32'b0;
    #20 din = 32'b1;
    #20 din = 32'b0;;

end

always begin
    #10 clk = ~clk;
end



endmodule