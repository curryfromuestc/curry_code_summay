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
    input en,
    input [7:0]data_in,
    output reg[223:0]data_out,
    output valid_out
    );

parameter threshold = 50;//!阈值

//!内部信号
reg [31:0] accumerlator;//!累加器,用于累加权重与数据相乘的结果
reg [6:0] addra;//!ROM的地址
wire douta_w;//!ROM的输出

reg [6:0] cout;//!统计从第一微秒到第120微妙的数据
reg [6:0] cout_us;//!每一微秒的八十个脉冲进行计数

parameter IDLE = 2'b00;//!空闲状态
parameter PRE = 2'b01;//!准备状态，判断前挡脉冲的状态
parameter DECODER = 2'b11;//!解码状态
parameter DONE = 2'b10;//!完成这包数据的解码的状态
reg [1:0] state,next_state;//!状态机的状态

reg valid_pre;//!上升沿有效的信号
reg valid_next;//!下降沿有效的信号
reg posi_pre,posi_nege;//!上升沿和下降沿的位置
reg valid_decoder;//!进入解码状态的有效信号

//!缓冲data_in
reg [7:0] data_in_pre_1,data_in_pre_2;

//!下一状态逻辑
always@(posedge clk or negedge rst_n)begin:next_state_logic
    if(~rst_n)
        state <= IDLE;
    else
        state <= next_state; 
end

//!状态转移逻辑
always @( *) begin:state_transfer_logic
    case(state)
        IDLE:begin
            if(en)begin
                if(valid_pre == 1)
                    next_state = PRE;
                else
                    next_state = IDLE; 
            end
            else
                next_state = IDLE;
        end
        PRE:begin
            if(cout == 7)
                next_state = DECODER;
	        else if(valid_pre == 0&&
		   ((cout == 1&&(cout_us == 2||cout_us == 0||cout_us == 1))
		   ||(cout == 0&&(cout_us == 77||cout_us == 78||cout_us == 79))
		   ||(cout == 4&&(cout_us == 39||cout_us == 40||cout_us == 41))
		   ||(cout == 3&&(cout_us == 39||cout_us == 40||cout_us == 41))))
		        next_state = IDLE;
            else if(valid_next&&(posi_nege-posi_pre)<29)
                next_state = IDLE;
            else
                next_state = PRE;
        end
        DECODER:begin
            if(cout == 119)
                next_state = DONE;
            else
                next_state = DECODER;
        end
        DONE:begin
            next_state = IDLE;
        end

    endcase
end

//-----------------输出逻辑-------------------
// always @(posedge clk or negedge rst_n) begin
//     if(~rst_n)begin
//         cout <= 0;
//         cout_us <= 0;
//     end
//     else begin
//         if(valid_pre)begin
//             if(cout_us<79)begin
//                 cout_us <= cout_us + 1;
//                 cout <= cout;
//             end
//             else begin
//                 cout_us <= 0;
//                 if(cout < 119)
//                     cout <= cout + 1;
//                 else
//                     cout <= 0;
//             end
//         end
//     end
// end
//!对数据进行打怕，然后比对，确定上升沿还有下降沿的位置
always @(posedge clk or negedge rst_n) begin:valid_logic
    if(~rst_n)begin
        data_in_pre_1 <= 0;
        data_in_pre_2 <= 0;
    end
    else begin
        data_in_pre_1 <= data_in;
        data_in_pre_2 <= data_in_pre_1;
        if((data_in_pre_1 - data_in_pre_2)>50
        &&((data_in_pre_1 - data_in)<50||(data_in - data_in_pre_2)<50))begin
            valid_pre <= 1;
            posi_pre <= cout_us;
        end
        else if((data_in_pre_2 - data_in_pre_1)>50
        &&((data_in_pre_1 - data_in)<50||(data_in - data_in_pre_1)<50))begin
            valid_next <= 1;
            posi_nege <= cout_us;
        end
        else
            valid_pre <= 0;
    end        
end
//!不同状态的输出逻辑
always @(posedge clk or negedge rst_n) begin:output_logic
    if(~rst_n)begin
        cout_us <= 0;
        cout <= 0;
        addra <= 0;
        accumerlator <= 0;
    end
    else begin
        case(state)
            IDLE :begin
                if(valid_pre == 1)begin
                    if(cout_us == 79)begin
                        cout_us <= 0;
                        cout <= cout + 1;
                    end
                    else begin
                        cout <= cout;
                        cout_us <= cout_us + 1;
                    end
                end
                else begin
                    cout_us <= 0;
                    cout <= 0;
                end
            end
            PRE :begin
                if(cout_us == 79)begin
                    cout_us <= 0;
                    cout <= cout + 1;
                end
                else begin
                    cout <= cout;
                    cout_us <= cout_us + 1;
                end
            end
            DECODER :begin
                addra <= cout_us;
                if(douta_w == 1)begin
                    accumerlator <= accumerlator + data_in;
                end
                else
                    accumerlator <= accumerlator-data_in;
            end
            DONE :begin
                cout_us <= 0;
                cout <= 0;
            end
        endcase
    end
end

//!将累加器的值与训练出来的阈值进行比较，然后进行解码
always@(*)begin:decoder_logic
    case(cout)
        7'd7:begin
            if(accumerlator>threshold)
                data_out[1:0] = 2'b10;
            else
                data_out[1:0] = 2'b01;
        end
        7'd8:begin
            if(accumerlator>threshold)
                data_out[3:2] = 2'b10;
            else
                data_out[3:2] = 2'b01;
        end
        7'd9:begin
            if(accumerlator>threshold)
                data_out[5:4] = 2'b10;
            else
                data_out[5:4] = 2'b01;
        end
        7'd10:begin
            if(accumerlator>threshold)
                data_out[7:6] = 2'b10;
            else
                data_out[7:6] = 2'b01;
        end
        7'd11:begin
            if(accumerlator>threshold)
                data_out[9:8] = 2'b10;
            else
                data_out[9:8] = 2'b01;
        end
        7'd12:begin
            if(accumerlator>threshold)
                data_out[11:10] = 2'b10;
            else
                data_out[11:10] = 2'b01;
        end
        7'd13:begin
            if(accumerlator>threshold)
                data_out[13:12] = 2'b10;
            else
                data_out[13:12] = 2'b01;
        end
        7'd14:begin
            if(accumerlator>threshold)
                data_out[15:14] = 2'b10;
            else
                data_out[15:14] = 2'b01;
        end
        7'd15:begin
            if(accumerlator>threshold)
                data_out[17:16] = 2'b10;
            else
                data_out[17:16] = 2'b01;
        end
        7'd16:begin
            if(accumerlator>threshold)
                data_out[19:18] = 2'b10;
            else
                data_out[19:18] = 2'b01;
        end
        7'd17:begin
            if(accumerlator>threshold)
                data_out[21:20] = 2'b10;
            else
                data_out[21:20] = 2'b01;
        end
        7'd18:begin
            if(accumerlator>threshold)
                data_out[23:22] = 2'b10;
            else
                data_out[23:22] = 2'b01;
        end
        7'd19:begin
            if(accumerlator>threshold)
                data_out[25:24] = 2'b10;
            else
                data_out[25:24] = 2'b01;
        end
        7'd20:begin
            if(accumerlator>threshold)
                data_out[27:26] = 2'b10;
            else
                data_out[27:26] = 2'b01;
        end
        7'd21:begin
            if(accumerlator>threshold)
                data_out[29:28] = 2'b10;
            else
                data_out[29:28] = 2'b01;
        end
        7'd22:begin
            if(accumerlator>threshold)
                data_out[31:30] = 2'b10;
            else
                data_out[31:30] = 2'b01;
        end
        7'd23:begin
            if(accumerlator>threshold)
                data_out[33:32] = 2'b10;
            else
                data_out[33:32] = 2'b01;
        end
        7'd24:begin
            if(accumerlator>threshold)
                data_out[35:34] = 2'b10;
            else
                data_out[35:34] = 2'b01;
        end
        7'd20:begin
            if(accumerlator>threshold)
                data_out[27:26] = 2'b10;
            else
                data_out[27:26] = 2'b01;
        end
        7'd21:begin
            if(accumerlator>threshold)
                data_out[29:28] = 2'b10;
            else
                data_out[29:28] = 2'b01;
        end
        7'd22:begin
            if(accumerlator>threshold)
                data_out[31:30] = 2'b10;
            else
                data_out[31:30] = 2'b01;
        end
        7'd23:begin
            if(accumerlator>threshold)
                data_out[33:32] = 2'b10;
            else
                data_out[33:32] = 2'b01;
        end
        7'd24:begin
            if(accumerlator>threshold)
                data_out[35:34] = 2'b10;
            else
                data_out[35:34] = 2'b01;
        end
        7'd20:begin
            if(accumerlator>threshold)
                data_out[27:26] = 2'b10;
            else
                data_out[27:26] = 2'b01;
        end
        7'd21:begin
            if(accumerlator>threshold)
                data_out[29:28] = 2'b10;
            else
                data_out[29:28] = 2'b01;
        end
        7'd22:begin
            if(accumerlator>threshold)
                data_out[31:30] = 2'b10;
            else
                data_out[31:30] = 2'b01;
        end
        7'd23:begin
            if(accumerlator>threshold)
                data_out[33:32] = 2'b10;
            else
                data_out[33:32] = 2'b01;
        end
        7'd24:begin
            if(accumerlator>threshold)
                data_out[35:34] = 2'b10;
            else
                data_out[35:34] = 2'b01;
        end
        7'd25:begin
            if(accumerlator>threshold)
                data_out[37:36] = 2'b10;
            else
                data_out[37:36] = 2'b01;
        end
        7'd26:begin
            if(accumerlator>threshold)
                data_out[39:38] = 2'b10;
            else
                data_out[39:38] = 2'b01;
        end
        7'd27:begin
            if(accumerlator>threshold)
                data_out[41:40] = 2'b10;
            else
                data_out[41:40] = 2'b01;
        end
        7'd28:begin
            if(accumerlator>threshold)
                data_out[43:42] = 2'b10;
            else
                data_out[43:42] = 2'b01;
        end
        7'd29:begin
            if(accumerlator>threshold)
                data_out[45:44] = 2'b10;
            else
                data_out[45:44] = 2'b01;
        end
        7'd30:begin
            if(accumerlator>threshold)
                data_out[47:46] = 2'b10;
            else
                data_out[47:46] = 2'b01;
        end
        7'd31:begin
            if(accumerlator>threshold)
                data_out[49:48] = 2'b10;
            else
                data_out[49:48] = 2'b01;
        end
        7'd32:begin
            if(accumerlator>threshold)
                data_out[51:50] = 2'b10;
            else
                data_out[51:50] = 2'b01;
        end
        7'd33:begin
            if(accumerlator>threshold)
                data_out[53:52] = 2'b10;
            else
                data_out[53:52] = 2'b01;
        end
        7'd34:begin
            if(accumerlator>threshold)
                data_out[55:54] = 2'b10;
            else
                data_out[55:54] = 2'b01;
        end
        7'd35:begin
            if(accumerlator>threshold)
                data_out[57:56] = 2'b10;
            else
                data_out[57:56] = 2'b01;
        end
        7'd36:begin
            if(accumerlator>threshold)
                data_out[59:58] = 2'b10;
            else
                data_out[59:58] = 2'b01;
        end
        7'd37:begin
            if(accumerlator>threshold)
                data_out[61:60] = 2'b10;
            else
                data_out[61:60] = 2'b01;
        end
        7'd38:begin
            if(accumerlator>threshold)
                data_out[63:62] = 2'b10;
            else
                data_out[63:62] = 2'b01;
        end
        7'd39:begin
            if(accumerlator>threshold)
                data_out[65:64] = 2'b10;
            else
                data_out[65:64] = 2'b01;
        end
        7'd40:begin
            if(accumerlator>threshold)
                data_out[67:66] = 2'b10;
            else
                data_out[67:66] = 2'b01;
        end
        7'd41:begin
            if(accumerlator>threshold)
                data_out[69:68] = 2'b10;
            else
                data_out[69:68] = 2'b01;
        end
        7'd42:begin
            if(accumerlator>threshold)
                data_out[71:70] = 2'b10;
            else
                data_out[71:70] = 2'b01;
        end
        7'd43:begin
            if(accumerlator>threshold)
                data_out[73:72] = 2'b10;
            else
                data_out[73:72] = 2'b01;
        end
        7'd44:begin
            if(accumerlator>threshold)
                data_out[75:74] = 2'b10;
            else
                data_out[75:74] = 2'b01;
        end
        7'd45:begin
            if(accumerlator>threshold)
                data_out[77:76] = 2'b10;
            else
                data_out[77:76] = 2'b01;
        end
        7'd46:begin
            if(accumerlator>threshold)
                data_out[79:78] = 2'b10;
            else
                data_out[79:78] = 2'b01;
        end
        7'd47:begin
            if(accumerlator>threshold)
                data_out[81:80] = 2'b10;
            else
                data_out[81:80] = 2'b01;
        end
        7'd48:begin
            if(accumerlator>threshold)
                data_out[83:82] = 2'b10;
            else
                data_out[83:82] = 2'b01;
        end
        7'd49:begin
            if(accumerlator>threshold)
                data_out[85:84] = 2'b10;
            else
                data_out[85:84] = 2'b01;
        end
        7'd50:begin
            if(accumerlator>threshold)
                data_out[87:86] = 2'b10;
            else
                data_out[87:86] = 2'b01;
        end
        7'd51:begin
            if(accumerlator>threshold)
                data_out[89:88] = 2'b10;
            else
                data_out[89:88] = 2'b01;
        end
        7'd52:begin
            if(accumerlator>threshold)
                data_out[91:90] = 2'b10;
            else
                data_out[91:90] = 2'b01;
        end
        7'd53:begin
            if(accumerlator>threshold)
                data_out[93:92] = 2'b10;
            else
                data_out[93:92] = 2'b01;
        end
        7'd54:begin
            if(accumerlator>threshold)
                data_out[95:94] = 2'b10;
            else
                data_out[95:94] = 2'b01;
        end
        7'd55:begin
            if(accumerlator>threshold)
                data_out[97:96] = 2'b10;
            else
                data_out[97:96] = 2'b01;
        end
        7'd56:begin
            if(accumerlator>threshold)
                data_out[99:98] = 2'b10;
            else
                data_out[99:98] = 2'b01;
        end
        7'd57:begin
            if(accumerlator>threshold)
                data_out[101:100] = 2'b10;
            else
                data_out[101:100] = 2'b01;
        end
        7'd58:begin
            if(accumerlator>threshold)
                data_out[103:102] = 2'b10;
            else
                data_out[103:102] = 2'b01;
        end
        7'd59:begin
            if(accumerlator>threshold)
                data_out[105:104] = 2'b10;
            else
                data_out[105:104] = 2'b01;
        end
        7'd60:begin
            if(accumerlator>threshold)
                data_out[107:106] = 2'b10;
            else
                data_out[107:106] = 2'b01;
        end
        7'd61:begin
            if(accumerlator>threshold)
                data_out[109:108] = 2'b10;
            else
                data_out[109:108] = 2'b01;
        end
        7'd62:begin
            if(accumerlator>threshold)
                data_out[111:110] = 2'b10;
            else
                data_out[111:110] = 2'b01;
        end
        7'd63:begin
            if(accumerlator>threshold)
                data_out[113:112] = 2'b10;
            else
                data_out[113:112] = 2'b01;
        end
        7'd64:begin
            if(accumerlator>threshold)
                data_out[115:114] = 2'b10;
            else
                data_out[115:114] = 2'b01;
        end
        7'd65:begin
            if(accumerlator>threshold)
                data_out[117:116] = 2'b10;
            else
                data_out[117:116] = 2'b01;
        end
        7'd66:begin
            if(accumerlator>threshold)
                data_out[119:118] = 2'b10;
            else
                data_out[119:118] = 2'b01;
        end
        7'd67:begin
            if(accumerlator>threshold)
                data_out[121:120] = 2'b10;
            else
                data_out[121:120] = 2'b01;
        end
        7'd68:begin
            if(accumerlator>threshold)
                data_out[123:122] = 2'b10;
            else
                data_out[123:122] = 2'b01;
        end
        7'd69:begin
            if(accumerlator>threshold)
                data_out[125:124] = 2'b10;
            else
                data_out[125:124] = 2'b01;
        end
        7'd70:begin
            if(accumerlator>threshold)
                data_out[127:126] = 2'b10;
            else
                data_out[127:126] = 2'b01;
        end
        7'd71:begin
            if(accumerlator>threshold)
                data_out[129:128] = 2'b10;
            else
                data_out[129:128] = 2'b01;
        end
        7'd72:begin
            if(accumerlator>threshold)
                data_out[131:130] = 2'b10;
            else
                data_out[131:130] = 2'b01;
        end
        7'd73:begin
            if(accumerlator>threshold)
                data_out[133:132] = 2'b10;
            else
                data_out[133:132] = 2'b01;
        end
        7'd74:begin
            if(accumerlator>threshold)
                data_out[135:134] = 2'b10;
            else
                data_out[135:134] = 2'b01;
        end
        7'd75:begin
            if(accumerlator>threshold)
                data_out[137:136] = 2'b10;
            else
                data_out[137:136] = 2'b01;
        end
        7'd76:begin
            if(accumerlator>threshold)
                data_out[139:138] = 2'b10;
            else
                data_out[139:138] = 2'b01;
        end
        7'd77:begin
            if(accumerlator>threshold)
                data_out[141:140] = 2'b10;
            else
                data_out[141:140] = 2'b01;
        end
        7'd78:begin
            if(accumerlator>threshold)
                data_out[143:142] = 2'b10;
            else
                data_out[143:142] = 2'b01;
        end
        7'd79:begin
            if(accumerlator>threshold)
                data_out[145:144] = 2'b10;
            else
                data_out[145:144] = 2'b01;
        end
        7'd80:begin
            if(accumerlator>threshold)
                data_out[147:146] = 2'b10;
            else
                data_out[147:146] = 2'b01;
        end
        7'd81:begin
            if(accumerlator>threshold)
                data_out[149:148] = 2'b10;
            else
                data_out[149:148] = 2'b01;
        end
        7'd82:begin
            if(accumerlator>threshold)
                data_out[151:150] = 2'b10;
            else
                data_out[151:150] = 2'b01;
        end
        7'd83:begin
            if(accumerlator>threshold)
                data_out[153:152] = 2'b10;
            else
                data_out[153:152] = 2'b01;
        end
        7'd84:begin
            if(accumerlator>threshold)
                data_out[155:154] = 2'b10;
            else
                data_out[155:154] = 2'b01;
        end
        7'd85:begin
            if(accumerlator>threshold)
                data_out[157:156] = 2'b10;
            else
                data_out[157:156] = 2'b01;
        end
        7'd86:begin
            if(accumerlator>threshold)
                data_out[159:158] = 2'b10;
            else
                data_out[159:158] = 2'b01;
        end
        7'd87:begin
            if(accumerlator>threshold)
                data_out[161:160] = 2'b10;
            else
                data_out[161:160] = 2'b01;
        end
        7'd88:begin
            if(accumerlator>threshold)
                data_out[163:162] = 2'b10;
            else
                data_out[163:162] = 2'b01;
        end
        7'd89:begin
            if(accumerlator>threshold)
                data_out[165:164] = 2'b10;
            else
                data_out[165:164] = 2'b01;
        end
        7'd90:begin
            if(accumerlator>threshold)
                data_out[167:166] = 2'b10;
            else
                data_out[167:166] = 2'b01;
        end
        7'd91:begin
            if(accumerlator>threshold)
                data_out[169:168] = 2'b10;
            else
                data_out[169:168] = 2'b01;
        end
        7'd92:begin
            if(accumerlator>threshold)
                data_out[171:170] = 2'b10;
            else
                data_out[171:170] = 2'b01;
        end
        7'd93:begin
            if(accumerlator>threshold)
                data_out[173:172] = 2'b10;
            else
                data_out[173:172] = 2'b01;
        end
        7'd94:begin
            if(accumerlator>threshold)
                data_out[175:174] = 2'b10;
            else
                data_out[175:174] = 2'b01;
        end
        7'd95:begin
            if(accumerlator>threshold)
                data_out[177:176] = 2'b10;
            else
                data_out[177:176] = 2'b01;
        end
        7'd96:begin
            if(accumerlator>threshold)
                data_out[179:178] = 2'b10;
            else
                data_out[179:178] = 2'b01;
        end
        7'd97:begin
            if(accumerlator>threshold)
                data_out[181:180] = 2'b10;
            else
                data_out[181:180] = 2'b01;
        end
        7'd98:begin
            if(accumerlator>threshold)
                data_out[183:182] = 2'b10;
            else
                data_out[183:182] = 2'b01;
        end
        7'd99:begin
            if(accumerlator>threshold)
                data_out[185:184] = 2'b10;
            else
                data_out[185:184] = 2'b01;
        end
        7'd100:begin
            if(accumerlator>threshold)
                data_out[187:186] = 2'b10;
            else
                data_out[187:186] = 2'b01;
        end
        7'd101:begin
            if(accumerlator>threshold)
                data_out[189:188] = 2'b10;
            else
                data_out[189:188] = 2'b01;
        end
        7'd102:begin
            if(accumerlator>threshold)
                data_out[191:190] = 2'b10;
            else
                data_out[191:190] = 2'b01;
        end
        7'd103:begin
            if(accumerlator>threshold)
                data_out[193:192] = 2'b10;
            else
                data_out[193:192] = 2'b01;
        end
        7'd104:begin
            if(accumerlator>threshold)
                data_out[195:194] = 2'b10;
            else
                data_out[195:194] = 2'b01;
        end
        7'd105:begin
            if(accumerlator>threshold)
                data_out[197:196] = 2'b10;
            else
                data_out[197:196] = 2'b01;
        end
        7'd106:begin
            if(accumerlator>threshold)
                data_out[199:198] = 2'b10;
            else
                data_out[199:198] = 2'b01;
        end
        7'd106:begin
            if(accumerlator>threshold)
                data_out[199:198] = 2'b10;
            else
                data_out[199:198] = 2'b01;
        end
        7'd107:begin
            if(accumerlator>threshold)
                data_out[201:200] = 2'b10;
            else
                data_out[201:200] = 2'b01;
        end
        7'd108:begin
            if(accumerlator>threshold)
                data_out[203:202] = 2'b10;
            else
                data_out[203:202] = 2'b01;
        end
        7'd109:begin
            if(accumerlator>threshold)
                data_out[205:204] = 2'b10;
            else
                data_out[205:204] = 2'b01;
        end
        7'd110:begin
            if(accumerlator>threshold)
                data_out[207:206] = 2'b10;
            else
                data_out[207:206] = 2'b01;
        end
        7'd111:begin
            if(accumerlator>threshold)
                data_out[209:208] = 2'b10;
            else
                data_out[209:208] = 2'b01;
        end
        7'd112:begin
            if(accumerlator>threshold)
                data_out[211:210] = 2'b10;
            else
                data_out[211:210] = 2'b01;
        end
        7'd113:begin
            if(accumerlator>threshold)
                data_out[213:212] = 2'b10;
            else
                data_out[213:212] = 2'b01;
        end
        7'd114:begin
            if(accumerlator>threshold)
                data_out[215:214] = 2'b10;
            else
                data_out[215:214] = 2'b01;
        end
        7'd115:begin
            if(accumerlator>threshold)
                data_out[217:216] = 2'b10;
            else
                data_out[217:216] = 2'b01;
        end
        7'd116:begin
            if(accumerlator>threshold)
                data_out[219:218] = 2'b10;
            else
                data_out[219:218] = 2'b01;
        end
        7'd117:begin
            if(accumerlator>threshold)
                data_out[221:220] = 2'b10;
            else
                data_out[221:220] = 2'b01;
        end
        7'd118:begin
            if(accumerlator>threshold)
                data_out[223:222] = 2'b10;
            else
                data_out[223:222] = 2'b01;
        end
        default:begin
            data_out[223:0] = 0;
        end
        
        
        

    endcase
end



//!实例化ROM
blk_mem_gen_0 blk_mem_gen_0_inst (
    .clka(clk),
    .addra(addra),
    .douta(douta_w)
    );

endmodule
