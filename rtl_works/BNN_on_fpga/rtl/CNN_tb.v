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

conv_mix conv_mix_inst(
    .clk(clk),
    .rstn(rstn),
    .start(start_conv),
    .weight_en(weight_en),
    .weight(weight_c),
    .din(image_in),
    .state(state),
    .ovalid(ovalid),
    .done(done),
    .dout(conv_result),
    .din_ready(start_window)
);

initial begin
    clk = 1;
    rstn = 0;
    state = 0;
    cnt_conv = 0;
    #20;
    weight_c = 1;
    rstn = 1;
    start_conv = 1;
    weight_en = 1;
    #(cycle*25);
    weight_en = 0;
end
always @(*) begin
    weight_c = ~weight[31];
end

integer w_i;
initial begin
    w_i = $fopen("C:\\Users\\21047\\Downloads\\test_conv1_weight_txt.txt", "r");
end
always @(posedge clk) begin
    if(weight_en == 1)begin
        count_r <= $fscanf(w_i,"%b",weight);
    end
end
initial begin
    cnt_line = 0;
//    start_window = 0;
//    #(20+90*cycle);
//    start_window = 1;
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
integer display_line = 0;
always @(posedge clk) begin
    if(ovalid&& !done)
    begin
        conv_result_r[cnt_conv] =  conv_result; 
        cnt_conv = cnt_conv + 1;
    end
    else begin
        if(done) // �??24x24二维矩阵形式打印卷积结果
        begin
            conv_result_r[cnt_conv] =  conv_result; // �??后一个结果，conv_ovalid �?? conv_done均为 1
            //$display("cnt_conv: %d  ", cnt_conv);
            $display("conv complete");
            if(state == 0)
            begin
                for(i=0;i<144;i=i+1)
                begin 
                    if(i == 0) $write("%d :", display_line);
                    
                    $write("%d ", conv_result_r[i]); // $write 不会自动换行
                
                    
                    if((i+1)%12 == 0)// 添加行号并换�??
                    begin
                        $display(" "); // 每行 24 个数�??
                        display_line = display_line + 1;
                        $write("%d :", display_line);
                    end
                end	
            end
            else if(state == 1)
            begin
                for(i=0;i<16;i=i+1)
                begin
                    if(i == 0) $write("%d :", display_line);
                    
                    $write("%d ", conv_result_r[i]); // $write 不会自动换行
                
                    
                    if((i+1)%4 == 0)// 添加行号并换�??
                    begin
                        $display(" "); // 每行 24 个数�??
                        display_line = display_line + 1;
                        $write("%d :", display_line);
                        end
                end	
            end
            //$finish;
        end
    end
end
always #10 clk <= ~clk; 
always @(posedge clk) begin
    if(done)begin
        start_conv <= 0;
    end
    else
        start_conv <= start_conv;
end
endmodule