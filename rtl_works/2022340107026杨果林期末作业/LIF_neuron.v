module LIF_neuron (
    input wire clk,
    input wire reset,
    input wire x1,
    input wire x2,
    input wire [31:0] s1,
    input wire [31:0] s2,
    input wire [31:0] alpha,
    output reg spike
);

    reg signed[31:0] membrane_potential;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            membrane_potential <= 32'sd0;
            spike <= 1'b0;
        end else begin
            // 更新膜电位
            membrane_potential <= membrane_potential + (x1 ? s1 : 32'd0) + (x2 ? s2 : 32'd0) - alpha;

            // 检查是否产生脉冲
            if (membrane_potential >= 32'sd1) begin
                spike <= 1'b1;
                membrane_potential <= 32'sd0; // 重置膜电位
            end else begin
                spike <= 1'b0;
            end
        end
    end

endmodule
