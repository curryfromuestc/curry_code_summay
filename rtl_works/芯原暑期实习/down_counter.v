module down_counter (
    input wire clk,          // 时钟信号
    input wire reset,        // 复位信号，高电平有效
    input wire [1:0] mode,   // 工作模式选择：00-Free running，01-Cyclic，10-Single
    input wire start,        // 启动信号，高电平有效
    output reg [15:0] count, // 计数器输出
    output reg interrupt     // 中断信号，高电平有效
);

    // 工作模式定义
    parameter FREE_RUNNING = 2'b00;
    parameter CYCLIC = 2'b01;
    parameter SINGLE = 2'b10;

    // 初始计数值
    reg [15:0] initial_value = 16'hFFFF;

    // 中断信号逻辑
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= initial_value;
            interrupt <= 0;
        end else if (start) begin
            case (mode)
                FREE_RUNNING: begin
                    count <= count - 1;
                    interrupt <= 0;
                end
                CYCLIC: begin
                    if (count == 0) begin
                        count <= initial_value;
                        interrupt <= 1;
                    end else begin
                        count <= count - 1;
                        interrupt <= 0;
                    end
                end
                SINGLE: begin
                    if (count != 0) begin
                        count <= count - 1;
                        interrupt <= 0;
                    end else begin
                        interrupt <= 1;
                    end
                end
                default: begin
                    count <= count;
                    interrupt <= 0;
                end
            endcase
        end
    end

endmodule
