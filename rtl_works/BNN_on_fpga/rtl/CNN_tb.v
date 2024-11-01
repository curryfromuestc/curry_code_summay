module conv_mix_tb ();
parameter cycle = 20;
reg clk;
reg rstn;
reg start;
reg signed[31:0] image_in;
reg [9:0]classes;
wire done;
wire start_window;


integer fp_i;
integer count_w;
integer count_r;

reg [10:0] cnt_line;
reg [10:0] cnt_conv;
reg signed [31:0] conv_result_r [0:599];

CNN CNN_inst(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .din(image_in),
    .classes(classes),
    .done(done),
    .din_ready(start_window)
);

initial begin
    clk = 1;
    rstn = 0;
    #20;
    rstn = 1;
    start = 1;
end

initial begin
    fp_i = $fopen("C:\\Users\\21047\\Downloads\\test_image_txt.txt", "r");
end

always @(posedge clk) begin
    if(start_window == 1)
    begin
        count_w <= $fscanf(fp_i,"%b",image_in);
        cnt_line <= cnt_line + 1;
        if(cnt_line == 784) $display("image read done");
    end
end
integer i;
always @(posedge clk) begin
    if(done)
    begin
        for(i = 0; i < 10; i = i + 1)
        // $display("classes[%d] = %d", i, classes[i]);
        $display("classes[%d] = %d", i, classes[i]);
    end
end
    
endmodule