module controller(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire row_update,
    output wire[319:0] line_pixel,
    output reg start
);

wire data_out;
reg [8:0] col_counter;

assign line_pixel[1:0] = 2'b00;
assign line_pixel[319:318] = 2'b00;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        col_counter <= 9'd0;
    else begin
        if(en) begin
            if(col_counter < 9'd319)
                col_counter <= col_counter + 1;
            else
                col_counter <= 9'd0;
        end
        else
            col_counter <= 9'd0;
    end
end

always @( *) begin
    case(col_counter)
        9'd2:line_pixel[2] = data_out;
        9'd3:line_pixel[3] = data_out;
        9'd4:line_pixel[4] = data_out;
        9'd5:lin_pixel[5] = data_out;
        9'd6:lin_pixel[6] = data_out;
        9'd7:lin_pixel[7] = data_out;
        9'd8:lin_pixel[8] = data_out;
        9'd9:lin_pixel[9] = data_out;
        9'd10:lin_pixel[10] = data_out;
        9'd11: lin_pixel[11] = data_out;
        9'd12: lin_pixel[12] = data_out;
        9'd13: lin_pixel[13] = data_out;
        9'd14: lin_pixel[14] = data_out;
        9'd15: lin_pixel[15] = data_out;
        9'd16: lin_pixel[16] = data_out;
        9'd17: lin_pixel[17] = data_out;
        9'd18: lin_pixel[18] = data_out;
        9'd19: lin_pixel[19] = data_out;
        9'd20: lin_pixel[20] = data_out;
        9'd21: lin_pixel[21] = data_out;
        9'd22: lin_pixel[22] = data_out;
        9'd23: lin_pixel[23] = data_out;
        9'd24: lin_pixel[24] = data_out;
        9'd25: lin_pixel[25] = data_out;
        9'd26: lin_pixel[26] = data_out;
        9'd27: lin_pixel[27] = data_out;
        9'd28: lin_pixel[28] = data_out;
        9'd29: lin_pixel[29] = data_out;
        9'd30: lin_pixel[30] = data_out;
        9'd31: lin_pixel[31] = data_out;
        9'd32: lin_pixel[32] = data_out;
        9'd33: lin_pixel[33] = data_out;
        9'd34: lin_pixel[34] = data_out;
        9'd35: lin_pixel[35] = data_out;
        9'd36: lin_pixel[36] = data_out;
        9'd37: lin_pixel[37] = data_out;
        9'd38: lin_pixel[38] = data_out;
        9'd39: lin_pixel[39] = data_out;
        9'd40: lin_pixel[40] = data_out;
        9'd41: lin_pixel[41] = data_out;
        9'd42: lin_pixel[42] = data_out;
        9'd43: lin_pixel[43] = data_out;
        9'd44: lin_pixel[44] = data_out;
        9'd45: lin_pixel[45] = data_out;
        9'd46: lin_pixel[46] = data_out;
        9'd47: lin_pixel[47] = data_out;
        9'd48: lin_pixel[48] = data_out;
        9'd49: lin_pixel[49] = data_out;
        9'd50: lin_pixel[50] = data_out;
        9'd51: lin_pixel[51] = data_out;
        9'd52: lin_pixel[52] = data_out;
        9'd53: lin_pixel[53] = data_out;
        9'd54: lin_pixel[54] = data_out;
        9'd55: lin_pixel[55] = data_out;
        9'd56: lin_pixel[56] = data_out;
        9'd57: lin_pixel[57] = data_out;
        9'd58: lin_pixel[58] = data_out;
        9'd59: lin_pixel[59] = data_out;
        9'd60: lin_pixel[60] = data_out;
        9'd61: lin_pixel[61] = data_out;
        9'd62: lin_pixel[62] = data_out;
        9'd63: lin_pixel[63] = data_out;
        9'd64: lin_pixel[64] = data_out;
        9'd65: lin_pixel[65] = data_out;
        9'd66: lin_pixel[66] = data_out;
        9'd67: lin_pixel[67] = data_out;
        9'd68: lin_pixel[68] = data_out;
        9'd69: lin_pixel[69] = data_out;
        9'd70: lin_pixel[70] = data_out;
        9'd71: lin_pixel[71] = data_out;
        9'd72: lin_pixel[72] = data_out;
        9'd73: lin_pixel[73] = data_out;
        9'd74: lin_pixel[74] = data_out;
        9'd75: lin_pixel[75] = data_out;
        9'd76: lin_pixel[76] = data_out;
        9'd77: lin_pixel[77] = data_out;
        9'd78: lin_pixel[78] = data_out;
        9'd79: lin_pixel[79] = data_out;
        9'd80: lin_pixel[80] = data_out;
        9'd81: lin_pixel[81] = data_out;
        9'd82: lin_pixel[82] = data_out;
        9'd83: lin_pixel[83] = data_out;
        9'd84: lin_pixel[84] = data_out;
        9'd85: lin_pixel[85] = data_out;
        9'd86: lin_pixel[86] = data_out;
        9'd87: lin_pixel[87] = data_out;
        9'd88: lin_pixel[88] = data_out;
        9'd89: lin_pixel[89] = data_out;
        9'd90: lin_pixel[90] = data_out;
        9'd91: lin_pixel[91] = data_out;
        9'd92: lin_pixel[92] = data_out;
        9'd93: lin_pixel[93] = data_out;
        9'd94: lin_pixel[94] = data_out;
        9'd95: lin_pixel[95] = data_out;
        9'd96: lin_pixel[96] = data_out;
        9'd97: lin_pixel[97] = data_out;
        9'd98: lin_pixel[98] = data_out;
        9'd99: lin_pixel[99] = data_out;
        9'd100: lin_pixel[100] = data_out;
        9'd101: lin_pixel[101] = data_out;
        9'd102: lin_pixel[102] = data_out;
        9'd103: lin_pixel[103] = data_out;
        9'd104: lin_pixel[104] = data_out;
        9'd105: lin_pixel[105] = data_out;
        9'd106: lin_pixel[106] = data_out;
        9'd107: lin_pixel[107] = data_out;
        9'd108: lin_pixel[108] = data_out;
        9'd109: lin_pixel[109] = data_out;
        9'd110: lin_pixel[110] = data_out;
        9'd111: lin_pixel[111] = data_out;
        9'd112: lin_pixel[112] = data_out;
        9'd113: lin_pixel[113] = data_out;
        9'd114: lin_pixel[114] = data_out;
        9'd115: lin_pixel[115] = data_out;
        9'd116: lin_pixel[116] = data_out;
        9'd117: lin_pixel[117] = data_out;
        9'd118: lin_pixel[118] = data_out;
        9'd119: lin_pixel[119] = data_out;
        9'd120: lin_pixel[120] = data_out;
        9'd121: lin_pixel[121] = data_out;
        9'd122: lin_pixel[122] = data_out;
        9'd123: lin_pixel[123] = data_out;
        9'd124: lin_pixel[124] = data_out;
        9'd125: lin_pixel[125] = data_out;
        9'd126: lin_pixel[126] = data_out;
        9'd127: lin_pixel[127] = data_out;
        9'd128: lin_pixel[128] = data_out;
        9'd129: lin_pixel[129] = data_out;
        9'd130: lin_pixel[130] = data_out;
        9'd131: lin_pixel[131] = data_out;
        9'd132: lin_pixel[132] = data_out;
        9'd133: lin_pixel[133] = data_out;
        9'd134: lin_pixel[134] = data_out;
        9'd135: lin_pixel[135] = data_out;
        9'd136: lin_pixel[136] = data_out;
        9'd137: lin_pixel[137] = data_out;
        9'd138: lin_pixel[138] = data_out;
        9'd139: lin_pixel[139] = data_out;
        9'd140: lin_pixel[140] = data_out;
        9'd141: lin_pixel[141] = data_out;
        9'd142: lin_pixel[142] = data_out;
        9'd143: lin_pixel[143] = data_out;
        9'd144: lin_pixel[144] = data_out;
        9'd145: lin_pixel[145] = data_out;
        9'd146: lin_pixel[146] = data_out;
        9'd147: lin_pixel[147] = data_out;
        9'd148: lin_pixel[148] = data_out;
        9'd149: lin_pixel[149] = data_out;
        9'd150: lin_pixel[150] = data_out;
        9'd151: lin_pixel[151] = data_out;
        9'd152: lin_pixel[152] = data_out;
        9'd153: lin_pixel[153] = data_out;
        9'd154: lin_pixel[154] = data_out;
        9'd155: lin_pixel[155] = data_out;
        9'd156: lin_pixel[156] = data_out;
        9'd157: lin_pixel[157] = data_out;
        9'd158: lin_pixel[158] = data_out;
        9'd159: lin_pixel[159] = data_out;
        9'd160: lin_pixel[160] = data_out;
        9'd161: lin_pixel[161] = data_out;
        9'd162: lin_pixel[162] = data_out;
        9'd163: lin_pixel[163] = data_out;
        9'd164: lin_pixel[164] = data_out;
        9'd165: lin_pixel[165] = data_out;
        9'd166: lin_pixel[166] = data_out;
        9'd167: lin_pixel[167] = data_out;
        9'd168: lin_pixel[168] = data_out;
        9'd169: lin_pixel[169] = data_out;
        9'd170: lin_pixel[170] = data_out;
        9'd171: lin_pixel[171] = data_out;
        9'd172: lin_pixel[172] = data_out;
        9'd173: lin_pixel[173] = data_out;
        9'd174: lin_pixel[174] = data_out;
        9'd175: lin_pixel[175] = data_out;
        9'd176: lin_pixel[176] = data_out;
        9'd177: lin_pixel[177] = data_out;
        9'd178: lin_pixel[178] = data_out;
        9'd179: lin_pixel[179] = data_out;
        9'd180: lin_pixel[180] = data_out;
        9'd181: lin_pixel[181] = data_out;
        9'd182: lin_pixel[182] = data_out;
        9'd183: lin_pixel[183] = data_out;
        9'd184: lin_pixel[184] = data_out;
        9'd185: lin_pixel[185] = data_out;
        9'd186: lin_pixel[186] = data_out;
        9'd187: lin_pixel[187] = data_out;
        9'd188: lin_pixel[188] = data_out;
        9'd189: lin_pixel[189] = data_out;
        9'd190: lin_pixel[190] = data_out;
        9'd191: lin_pixel[191] = data_out;
        9'd192: lin_pixel[192] = data_out;
        9'd193: lin_pixel[193] = data_out;
        9'd194: lin_pixel[194] = data_out;
        9'd195: lin_pixel[195] = data_out;
        9'd196: lin_pixel[196] = data_out;
        9'd197: lin_pixel[197] = data_out;
        9'd198: lin_pixel[198] = data_out;
        9'd199: lin_pixel[199] = data_out;
        9'd200: lin_pixel[200] = data_out;
        9'd201: lin_pixel[201] = data_out;
        9'd202: lin_pixel[202] = data_out;
        9'd203: lin_pixel[203] = data_out;
        9'd204: lin_pixel[204] = data_out;
        9'd205: lin_pixel[205] = data_out;
        9'd206: lin_pixel[206] = data_out;
        9'd207: lin_pixel[207] = data_out;
        9'd208: lin_pixel[208] = data_out;
        9'd209: lin_pixel[209] = data_out;
        9'd210: lin_pixel[210] = data_out;
        9'd211: lin_pixel[211] = data_out;
        9'd212: lin_pixel[212] = data_out;
        9'd213: lin_pixel[213] = data_out;
        9'd214: lin_pixel[214] = data_out;
        9'd215: lin_pixel[215] = data_out;
        9'd216: lin_pixel[216] = data_out;
        9'd217: lin_pixel[217] = data_out;
        9'd218: lin_pixel[218] = data_out;
        9'd219: lin_pixel[219] = data_out;
        9'd220: lin_pixel[220] = data_out;
        9'd221: lin_pixel[221] = data_out;
        9'd222: lin_pixel[222] = data_out;
        9'd223: lin_pixel[223] = data_out;
        9'd224: lin_pixel[224] = data_out;
        9'd225: lin_pixel[225] = data_out;
        9'd226: lin_pixel[226] = data_out;
        9'd227: lin_pixel[227] = data_out;
        9'd228: lin_pixel[228] = data_out;
        9'd229: lin_pixel[229] = data_out;
        9'd230: lin_pixel[230] = data_out;
        9'd231: lin_pixel[231] = data_out;
        9'd232: lin_pixel[232] = data_out;
        9'd233: lin_pixel[233] = data_out;
        9'd234: lin_pixel[234] = data_out;
        9'd235: lin_pixel[235] = data_out;
        9'd236: lin_pixel[236] = data_out;
        9'd237: lin_pixel[237] = data_out;
        9'd238: lin_pixel[238] = data_out;
        9'd239: lin_pixel[239] = data_out;
        9'd240: lin_pixel[240] = data_out;
        9'd241: lin_pixel[241] = data_out;
        9'd242: lin_pixel[242] = data_out;
        9'd243: lin_pixel[243] = data_out;
        9'd244: lin_pixel[244] = data_out;
        9'd245: lin_pixel[245] = data_out;
        9'd246: lin_pixel[246] = data_out;
        9'd247: lin_pixel[247] = data_out;
        9'd248: lin_pixel[248] = data_out;
        9'd249: lin_pixel[249] = data_out;
        9'd250: lin_pixel[250] = data_out;
        9'd251: lin_pixel[251] = data_out;
        9'd252: lin_pixel[252] = data_out;
        9'd253: lin_pixel[253] = data_out;
        9'd254: lin_pixel[254] = data_out;
        9'd255: lin_pixel[255] = data_out;
        9'd256: lin_pixel[256] = data_out;
        9'd257: lin_pixel[257] = data_out;
        9'd258: lin_pixel[258] = data_out;
        9'd259: lin_pixel[259] = data_out;
        9'd260: lin_pixel[260] = data_out;
        9'd261: lin_pixel[261] = data_out;
        9'd262: lin_pixel[262] = data_out;
        9'd263: lin_pixel[263] = data_out;
        9'd264: lin_pixel[264] = data_out;
        9'd265: lin_pixel[265] = data_out;
        9'd266: lin_pixel[266] = data_out;
        9'd267: lin_pixel[267] = data_out;
        9'd268: lin_pixel[268] = data_out;
        9'd269: lin_pixel[269] = data_out;
        9'd270: lin_pixel[270] = data_out;
        9'd271: lin_pixel[271] = data_out;
        9'd272: lin_pixel[272] = data_out;
        9'd273: lin_pixel[273] = data_out;
        9'd274: lin_pixel[274] = data_out;
        9'd275: lin_pixel[275] = data_out;
        9'd276: lin_pixel[276] = data_out;
        9'd277: lin_pixel[277] = data_out;
        9'd278: lin_pixel[278] = data_out;
        9'd279: lin_pixel[279] = data_out;
        9'd280: lin_pixel[280] = data_out;
        9'd281: lin_pixel[281] = data_out;
        9'd282: lin_pixel[282] = data_out;
        9'd283: lin_pixel[283] = data_out;
        9'd284: lin_pixel[284] = data_out;
        9'd285: lin_pixel[285] = data_out;
        9'd286: lin_pixel[286] = data_out;
        9'd287: lin_pixel[287] = data_out;
        9'd288: lin_pixel[288] = data_out;
        9'd289: lin_pixel[289] = data_out;
        9'd290: lin_pixel[290] = data_out;
        9'd291: lin_pixel[291] = data_out;
        9'd292: lin_pixel[292] = data_out;
        9'd293: lin_pixel[293] = data_out;
        9'd294: lin_pixel[294] = data_out;
        9'd295: lin_pixel[295] = data_out;
        9'd296: lin_pixel[296] = data_out;
        9'd297: lin_pixel[297] = data_out;
        9'd298: lin_pixel[298] = data_out;
        9'd299: lin_pixel[299] = data_out;
        9'd300: lin_pixel[300] = data_out;
        9'd301: lin_pixel[301] = data_out;
        9'd302: lin_pixel[302] = data_out;
        9'd303: lin_pixel[303] = data_out;
        9'd304: lin_pixel[304] = data_out;
        9'd305: lin_pixel[305] = data_out;
        9'd306: lin_pixel[306] = data_out;
        9'd307: lin_pixel[307] = data_out;
        9'd308: lin_pixel[308] = data_out;
        9'd309: lin_pixel[309] = data_out;
        9'd310: lin_pixel[310] = data_out;
        9'd311: lin_pixel[311] = data_out;
        9'd312: lin_pixel[312] = data_out;
        9'd313: lin_pixel[313] = data_out;
        9'd314: lin_pixel[314] = data_out;
        9'd315: lin_pixel[315] = data_out;
        9'd316: lin_pixel[316] = data_out;
        9'd317: lin_pixel[317] = data_out;
        default :lin_pixel = 319'd0;
            
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        start <= 0;
    else begin
        if(col_counter<=1)
            start <= 1;
        else
            start <= 0;
        end
    
end

//!例化高斯滤波器
gaosi_filter gaosi_filter_inst(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .data_in(data_in),
    .data_out(data_out)
);

endmodule