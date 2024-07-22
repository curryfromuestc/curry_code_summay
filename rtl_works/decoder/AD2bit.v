module (
    input wire clk,
    input wire rst_n,
    input wire [15:0] ad_data,//!输入的16位ad数据
    input wire en,
    output reg [79:0] data_us,//!输出一微秒里面的80个脉冲
    output reg valid
);
endmodule