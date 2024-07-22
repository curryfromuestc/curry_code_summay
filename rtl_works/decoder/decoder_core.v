`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/10 22:16:06
// Design Name: 
// Module Name: decoder_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder_core(
    input clk,//!输入时钟
    input rst_n,
    input [79:0]data_in,
    input valid_in,
    output reg[223:0]data_out,
    output valid_out,
    output  reg valid_out_us
    );

//定义内部信号
reg valid_in_us;//检测valid_in信号的脉冲
reg valid_in_prev;
//定义ROM地址和数据输出信号
reg [6:0]addra;
reg douta; 
wire douta_w;
//定义一个计数器，用于输出数据，定义另外一个计数器，用于引导data——out的拼接
reg [6:0]cnt_data_out_us;  
//定义计算好的一微秒的数据
reg [1:0] data_out_us;
//定义一个累加器
reg [31:0] acumulator;

//定义计算的状态机
parameter IDLE = 2'b00,PROCESS_DATA = 2'b01,DONE = 2'b10;
reg [1:0] state,next_state;

//!检测valid_in信号的脉冲
always @(posedge clk or negedge rst_n)begin:valid_in_pulse
    if(~rst_n)begin
        valid_in_us <= 0;
        valid_in_prev <= 0;
    end
    else begin
        if(valid_in && ~valid_in_prev)begin
            valid_in_us <= 1; 
        end
        else begin
            valid_in_us <= 0;
        end
        valid_in_prev <= valid_in;
    end
end

/*计算的状态机****************************************************************************************************/
//状态机的转移逻辑
always @(*)begin
    if(~rst_n)begin
        state = IDLE;
        acumulator = 32'b00000000000000000000000000000000;
    end
    else begin
        case (state)
            IDLE :begin
                valid_out_us = 0;
                if(valid_in_us)begin
                    next_state = PROCESS_DATA;
                end
                else begin
                    next_state = IDLE;
                end
            end
            PROCESS_DATA :begin
                if(addra == 7'b1001111)begin
                    next_state = DONE;
                end
                else begin
                    next_state = PROCESS_DATA;
                    if(douta == 1)begin
                        acumulator = acumulator + data_in[addra];
                    end
                    else begin
                        acumulator = acumulator - data_in[addra];
                    end
                end
            end
            DONE :begin
                valid_out_us = 1;
                next_state = IDLE;
            end
        endcase
    end
end
//下一状态逻辑
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

//从ROM中读取权重的操作
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        addra <= 7'b0;
        douta <= 1'b0;
    end 
    else begin
        if(valid_in_us)begin
            if(addra < 7'b1001111)begin
                addra <= addra + 1;
                douta <= data_in[addra];
            end
            else begin
                addra <= 7'b0000000;
                douta <= 1'b0;
            end
        end
    end
end


/*所有计数器的增加逻辑****************************************************************************************************/

//cnt_data_out计数器的计数操作，在每读完一组权重过后加一
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        cnt_data_out_us <= 7'b0;
    end
    else begin
        if(addra == 7'b1001111)begin
            cnt_data_out_us <= cnt_data_out_us + 1;
        end
        else begin
            cnt_data_out_us <= cnt_data_out_us;
        end
    end
end

/*所有计数器的增加逻辑****************************************************************************************************/

//计算一微秒过后的累加器值，将其拼接到data_out_us里面
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        data_out_us <= 2'b0;
    end
    else begin
        if(valid_out_us)begin
            if(acumulator > 32'b00000000000000000000000000000000)
                data_out_us <= 2'b10;
            else
                data_out_us <= 2'b01;
        end
        else begin
            data_out_us <= 2'b0;
        end
    end
end


//data_out的输出操作，每计算完一微秒的数据过后，将其拼接到data_out里面
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        data_out <= 224'b0;
    end
    else begin
        if(valid_out_us)begin
            case (cnt_data_out_us)
                7'b0000000:data_out[1:0] <= data_out_us;
                7'b0000001:data_out[3:2] <= data_out_us;
                7'b0000010:data_out[5:4] <= data_out_us;
                7'b0000011:data_out[7:6] <= data_out_us;
                7'b0000100:data_out[9:8] <= data_out_us;
                7'b0000101:data_out[11:10] <= data_out_us;
                7'b0000110:data_out[13:12] <= data_out_us;
                7'b0000111:data_out[15:14] <= data_out_us;
                7'b0001000:data_out[17:16] <= data_out_us;
                7'b0001001:data_out[19:18] <= data_out_us;
                7'b0001010:data_out[21:20] <= data_out_us;
                7'b0001011:data_out[23:22] <= data_out_us;
                7'b0001100:data_out[25:24] <= data_out_us;
                7'b0001101:data_out[27:26] <= data_out_us;
                7'b0001110:data_out[29:28] <= data_out_us;
                7'b0001111:data_out[31:30] <= data_out_us;
                7'b0010000:data_out[33:32] <= data_out_us;
                7'b0010001:data_out[35:34] <= data_out_us;
                7'b0010010:data_out[37:36] <= data_out_us;
                7'b0010011:data_out[39:38] <= data_out_us;
                7'b0010100:data_out[41:40] <= data_out_us;
                7'b0010101:data_out[43:42] <= data_out_us;
                7'b0010110:data_out[45:44] <= data_out_us;
                7'b0010111:data_out[47:46] <= data_out_us;
                7'b0011000:data_out[49:48] <= data_out_us;
                7'b0011001:data_out[51:50] <= data_out_us;
                7'b0011010:data_out[53:52] <= data_out_us;
                7'b0011011:data_out[55:54] <= data_out_us;
                7'b0011100:data_out[57:56] <= data_out_us;
                7'b0011101:data_out[59:58] <= data_out_us;
                7'b0011110:data_out[61:60] <= data_out_us;
                7'b0011111:data_out[63:62] <= data_out_us;
                7'b0100000:data_out[65:64] <= data_out_us;
                7'b0100001:data_out[67:66] <= data_out_us;
                7'b0100010:data_out[69:68] <= data_out_us;
                7'b0100011:data_out[71:70] <= data_out_us;
                7'b0100100:data_out[73:72] <= data_out_us;
                7'b0100101:data_out[75:74] <= data_out_us;
                7'b0100110:data_out[77:76] <= data_out_us;
                7'b0100111:data_out[79:78] <= data_out_us;
                7'b0101000:data_out[81:80] <= data_out_us;
                7'b0101001:data_out[83:82] <= data_out_us;
                7'b0101010:data_out[85:84] <= data_out_us;
                7'b0101011:data_out[87:86] <= data_out_us;
                7'b0101100:data_out[89:88] <= data_out_us;
                7'b0101101:data_out[91:90] <= data_out_us;
                7'b0101110:data_out[93:92] <= data_out_us;
                7'b0101111:data_out[95:94] <= data_out_us;
                7'b0110000:data_out[97:96] <= data_out_us;
                7'b0110001:data_out[99:98] <= data_out_us;
                7'b0110010:data_out[101:100] <= data_out_us;
                7'b0110011:data_out[103:102] <= data_out_us;
                7'b0110100:data_out[105:104] <= data_out_us;
                7'b0110101:data_out[107:106] <= data_out_us;
                7'b0110110:data_out[109:108] <= data_out_us;
                7'b0110111:data_out[111:110] <= data_out_us;
                7'b0111000:data_out[113:112] <= data_out_us;
                7'b0111001:data_out[115:114] <= data_out_us;
                7'b0111010:data_out[117:116] <= data_out_us;
                7'b0111011:data_out[119:118] <= data_out_us;
                7'b0111100:data_out[121:120] <= data_out_us;
                7'b0111101:data_out[123:122] <= data_out_us;
                7'b0111110:data_out[125:124] <= data_out_us;
                7'b0111111:data_out[127:126] <= data_out_us;
                7'b1000000:data_out[129:128] <= data_out_us;
                7'b1000001:data_out[131:130] <= data_out_us;
                7'b1000010:data_out[133:132] <= data_out_us;
                7'b1000011:data_out[135:134] <= data_out_us;
                7'b1000100:data_out[137:136] <= data_out_us;
                7'b1000101:data_out[139:138] <= data_out_us;
                7'b1000110:data_out[141:140] <= data_out_us;
                7'b1000111:data_out[143:142] <= data_out_us;
                7'b1001000:data_out[145:144] <= data_out_us;
                7'b1001001:data_out[147:146] <= data_out_us;
                7'b1001010:data_out[149:148] <= data_out_us;
                7'b1001011:data_out[151:150] <= data_out_us;
                7'b1001100:data_out[153:152] <= data_out_us;
                7'b1001101:data_out[155:154] <= data_out_us;
                7'b1001110:data_out[157:156] <= data_out_us;
                7'b1001111:data_out[159:158] <= data_out_us;
                7'b1010000:data_out[161:160] <= data_out_us;
                7'b1010001:data_out[163:162] <= data_out_us;
                7'b1010010:data_out[165:164] <= data_out_us;
                7'b1010011:data_out[167:166] <= data_out_us;
                7'b1010100:data_out[169:168] <= data_out_us;
                7'b1010101:data_out[171:170] <= data_out_us;
                7'b1010110:data_out[173:172] <= data_out_us;
                7'b1010111:data_out[175:174] <= data_out_us;
                7'b1011000:data_out[177:176] <= data_out_us;
                7'b1011001:data_out[179:178] <= data_out_us;
                7'b1011010:data_out[181:180] <= data_out_us;
                7'b1011011:data_out[183:182] <= data_out_us;
                7'b1011100:data_out[185:184] <= data_out_us;
                7'b1011101:data_out[187:186] <= data_out_us;
                7'b1011110:data_out[189:188] <= data_out_us;
                7'b1011111:data_out[191:190] <= data_out_us;
                7'b1100000:data_out[193:192] <= data_out_us;
                7'b1100001:data_out[195:194] <= data_out_us;
                7'b1100010:data_out[197:196] <= data_out_us;
                7'b1100011:data_out[199:198] <= data_out_us;
                7'b1100100:data_out[201:200] <= data_out_us;
                7'b1100101:data_out[203:202] <= data_out_us;
                7'b1100110:data_out[205:204] <= data_out_us;
                7'b1100111:data_out[207:206] <= data_out_us;
                7'b1101000:data_out[209:208] <= data_out_us;
                7'b1101001:data_out[211:210] <= data_out_us;
                7'b1101010:data_out[213:212] <= data_out_us;
                7'b1101011:data_out[215:214] <= data_out_us;
                7'b1101100:data_out[217:216] <= data_out_us;
                7'b1101101:data_out[219:218] <= data_out_us;
                7'b1101110:data_out[221:220] <= data_out_us;
                7'b1101111:data_out[223:222] <= data_out_us;
            endcase
        end
    end
end

assign douta_w = douta;

//实例化ROM
blk_mem_gen_0 blk_mem_gen_0_inst (
    .clka(clk),
    .addra(addra),
    .douta(douta_w)
    );

endmodule
