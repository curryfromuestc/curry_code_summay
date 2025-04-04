module controller(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire[4:0]data_in,
    output reg[319:0] line_pixel,
    output reg start
);

wire data_out;
reg [8:0] col_counter;



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
	 line_pixel[1:0] = 2'b00;
	 line_pixel[319:318] = 2'b00;
    case(col_counter)
        9'd2:line_pixel[2] = data_out;
        9'd3:line_pixel[3] = data_out;
        9'd4:line_pixel[4] = data_out;
        9'd5:line_pixel[5] = data_out;
        9'd6:line_pixel[6] = data_out;
        9'd7:line_pixel[7] = data_out;
        9'd8:line_pixel[8] = data_out;
        9'd9:line_pixel[9] = data_out;
        9'd10:line_pixel[10] = data_out;
        9'd11: line_pixel[11] = data_out;
        9'd12: line_pixel[12] = data_out;
        9'd13: line_pixel[13] = data_out;
        9'd14: line_pixel[14] = data_out;
        9'd15: line_pixel[15] = data_out;
        9'd16: line_pixel[16] = data_out;
        9'd17: line_pixel[17] = data_out;
        9'd18: line_pixel[18] = data_out;
        9'd19: line_pixel[19] = data_out;
        9'd20: line_pixel[20] = data_out;
        9'd21: line_pixel[21] = data_out;
        9'd22: line_pixel[22] = data_out;
        9'd23: line_pixel[23] = data_out;
        9'd24: line_pixel[24] = data_out;
        9'd25: line_pixel[25] = data_out;
        9'd26: line_pixel[26] = data_out;
        9'd27: line_pixel[27] = data_out;
        9'd28: line_pixel[28] = data_out;
        9'd29: line_pixel[29] = data_out;
        9'd30: line_pixel[30] = data_out;
        9'd31: line_pixel[31] = data_out;
        9'd32: line_pixel[32] = data_out;
        9'd33: line_pixel[33] = data_out;
        9'd34: line_pixel[34] = data_out;
        9'd35: line_pixel[35] = data_out;
        9'd36: line_pixel[36] = data_out;
        9'd37: line_pixel[37] = data_out;
        9'd38: line_pixel[38] = data_out;
        9'd39: line_pixel[39] = data_out;
        9'd40: line_pixel[40] = data_out;
        9'd41: line_pixel[41] = data_out;
        9'd42: line_pixel[42] = data_out;
        9'd43: line_pixel[43] = data_out;
        9'd44: line_pixel[44] = data_out;
        9'd45: line_pixel[45] = data_out;
        9'd46: line_pixel[46] = data_out;
        9'd47: line_pixel[47] = data_out;
        9'd48: line_pixel[48] = data_out;
        9'd49: line_pixel[49] = data_out;
        9'd50: line_pixel[50] = data_out;
        9'd51: line_pixel[51] = data_out;
        9'd52: line_pixel[52] = data_out;
        9'd53: line_pixel[53] = data_out;
        9'd54: line_pixel[54] = data_out;
        9'd55: line_pixel[55] = data_out;
        9'd56: line_pixel[56] = data_out;
        9'd57: line_pixel[57] = data_out;
        9'd58: line_pixel[58] = data_out;
        9'd59: line_pixel[59] = data_out;
        9'd60: line_pixel[60] = data_out;
        9'd61: line_pixel[61] = data_out;
        9'd62: line_pixel[62] = data_out;
        9'd63: line_pixel[63] = data_out;
        9'd64: line_pixel[64] = data_out;
        9'd65: line_pixel[65] = data_out;
        9'd66: line_pixel[66] = data_out;
        9'd67: line_pixel[67] = data_out;
        9'd68: line_pixel[68] = data_out;
        9'd69: line_pixel[69] = data_out;
        9'd70: line_pixel[70] = data_out;
        9'd71: line_pixel[71] = data_out;
        9'd72: line_pixel[72] = data_out;
        9'd73: line_pixel[73] = data_out;
        9'd74: line_pixel[74] = data_out;
        9'd75: line_pixel[75] = data_out;
        9'd76: line_pixel[76] = data_out;
        9'd77: line_pixel[77] = data_out;
        9'd78: line_pixel[78] = data_out;
        9'd79: line_pixel[79] = data_out;
        9'd80: line_pixel[80] = data_out;
        9'd81: line_pixel[81] = data_out;
        9'd82: line_pixel[82] = data_out;
        9'd83: line_pixel[83] = data_out;
        9'd84: line_pixel[84] = data_out;
        9'd85: line_pixel[85] = data_out;
        9'd86: line_pixel[86] = data_out;
        9'd87: line_pixel[87] = data_out;
        9'd88: line_pixel[88] = data_out;
        9'd89: line_pixel[89] = data_out;
        9'd90: line_pixel[90] = data_out;
        9'd91: line_pixel[91] = data_out;
        9'd92: line_pixel[92] = data_out;
        9'd93: line_pixel[93] = data_out;
        9'd94: line_pixel[94] = data_out;
        9'd95: line_pixel[95] = data_out;
        9'd96: line_pixel[96] = data_out;
        9'd97: line_pixel[97] = data_out;
        9'd98: line_pixel[98] = data_out;
        9'd99: line_pixel[99] = data_out;
        9'd100: line_pixel[100] = data_out;
        9'd101: line_pixel[101] = data_out;
        9'd102: line_pixel[102] = data_out;
        9'd103: line_pixel[103] = data_out;
        9'd104: line_pixel[104] = data_out;
        9'd105: line_pixel[105] = data_out;
        9'd106: line_pixel[106] = data_out;
        9'd107: line_pixel[107] = data_out;
        9'd108: line_pixel[108] = data_out;
        9'd109: line_pixel[109] = data_out;
        9'd110: line_pixel[110] = data_out;
        9'd111: line_pixel[111] = data_out;
        9'd112: line_pixel[112] = data_out;
        9'd113: line_pixel[113] = data_out;
        9'd114: line_pixel[114] = data_out;
        9'd115: line_pixel[115] = data_out;
        9'd116: line_pixel[116] = data_out;
        9'd117: line_pixel[117] = data_out;
        9'd118: line_pixel[118] = data_out;
        9'd119: line_pixel[119] = data_out;
        9'd120: line_pixel[120] = data_out;
        9'd121: line_pixel[121] = data_out;
        9'd122: line_pixel[122] = data_out;
        9'd123: line_pixel[123] = data_out;
        9'd124: line_pixel[124] = data_out;
        9'd125: line_pixel[125] = data_out;
        9'd126: line_pixel[126] = data_out;
        9'd127: line_pixel[127] = data_out;
        9'd128: line_pixel[128] = data_out;
        9'd129: line_pixel[129] = data_out;
        9'd130: line_pixel[130] = data_out;
        9'd131: line_pixel[131] = data_out;
        9'd132: line_pixel[132] = data_out;
        9'd133: line_pixel[133] = data_out;
        9'd134: line_pixel[134] = data_out;
        9'd135: line_pixel[135] = data_out;
        9'd136: line_pixel[136] = data_out;
        9'd137: line_pixel[137] = data_out;
        9'd138: line_pixel[138] = data_out;
        9'd139: line_pixel[139] = data_out;
        9'd140: line_pixel[140] = data_out;
        9'd141: line_pixel[141] = data_out;
        9'd142: line_pixel[142] = data_out;
        9'd143: line_pixel[143] = data_out;
        9'd144: line_pixel[144] = data_out;
        9'd145: line_pixel[145] = data_out;
        9'd146: line_pixel[146] = data_out;
        9'd147: line_pixel[147] = data_out;
        9'd148: line_pixel[148] = data_out;
        9'd149: line_pixel[149] = data_out;
        9'd150: line_pixel[150] = data_out;
        9'd151: line_pixel[151] = data_out;
        9'd152: line_pixel[152] = data_out;
        9'd153: line_pixel[153] = data_out;
        9'd154: line_pixel[154] = data_out;
        9'd155: line_pixel[155] = data_out;
        9'd156: line_pixel[156] = data_out;
        9'd157: line_pixel[157] = data_out;
        9'd158: line_pixel[158] = data_out;
        9'd159: line_pixel[159] = data_out;
        9'd160: line_pixel[160] = data_out;
        9'd161: line_pixel[161] = data_out;
        9'd162: line_pixel[162] = data_out;
        9'd163: line_pixel[163] = data_out;
        9'd164: line_pixel[164] = data_out;
        9'd165: line_pixel[165] = data_out;
        9'd166: line_pixel[166] = data_out;
        9'd167: line_pixel[167] = data_out;
        9'd168: line_pixel[168] = data_out;
        9'd169: line_pixel[169] = data_out;
        9'd170: line_pixel[170] = data_out;
        9'd171: line_pixel[171] = data_out;
        9'd172: line_pixel[172] = data_out;
        9'd173: line_pixel[173] = data_out;
        9'd174: line_pixel[174] = data_out;
        9'd175: line_pixel[175] = data_out;
        9'd176: line_pixel[176] = data_out;
        9'd177: line_pixel[177] = data_out;
        9'd178: line_pixel[178] = data_out;
        9'd179: line_pixel[179] = data_out;
        9'd180: line_pixel[180] = data_out;
        9'd181: line_pixel[181] = data_out;
        9'd182: line_pixel[182] = data_out;
        9'd183: line_pixel[183] = data_out;
        9'd184: line_pixel[184] = data_out;
        9'd185: line_pixel[185] = data_out;
        9'd186: line_pixel[186] = data_out;
        9'd187: line_pixel[187] = data_out;
        9'd188: line_pixel[188] = data_out;
        9'd189: line_pixel[189] = data_out;
        9'd190: line_pixel[190] = data_out;
        9'd191: line_pixel[191] = data_out;
        9'd192: line_pixel[192] = data_out;
        9'd193: line_pixel[193] = data_out;
        9'd194: line_pixel[194] = data_out;
        9'd195: line_pixel[195] = data_out;
        9'd196: line_pixel[196] = data_out;
        9'd197: line_pixel[197] = data_out;
        9'd198: line_pixel[198] = data_out;
        9'd199: line_pixel[199] = data_out;
        9'd200: line_pixel[200] = data_out;
        9'd201: line_pixel[201] = data_out;
        9'd202: line_pixel[202] = data_out;
        9'd203: line_pixel[203] = data_out;
        9'd204: line_pixel[204] = data_out;
        9'd205: line_pixel[205] = data_out;
        9'd206: line_pixel[206] = data_out;
        9'd207: line_pixel[207] = data_out;
        9'd208: line_pixel[208] = data_out;
        9'd209: line_pixel[209] = data_out;
        9'd210: line_pixel[210] = data_out;
        9'd211: line_pixel[211] = data_out;
        9'd212: line_pixel[212] = data_out;
        9'd213: line_pixel[213] = data_out;
        9'd214: line_pixel[214] = data_out;
        9'd215: line_pixel[215] = data_out;
        9'd216: line_pixel[216] = data_out;
        9'd217: line_pixel[217] = data_out;
        9'd218: line_pixel[218] = data_out;
        9'd219: line_pixel[219] = data_out;
        9'd220: line_pixel[220] = data_out;
        9'd221: line_pixel[221] = data_out;
        9'd222: line_pixel[222] = data_out;
        9'd223: line_pixel[223] = data_out;
        9'd224: line_pixel[224] = data_out;
        9'd225: line_pixel[225] = data_out;
        9'd226: line_pixel[226] = data_out;
        9'd227: line_pixel[227] = data_out;
        9'd228: line_pixel[228] = data_out;
        9'd229: line_pixel[229] = data_out;
        9'd230: line_pixel[230] = data_out;
        9'd231: line_pixel[231] = data_out;
        9'd232: line_pixel[232] = data_out;
        9'd233: line_pixel[233] = data_out;
        9'd234: line_pixel[234] = data_out;
        9'd235: line_pixel[235] = data_out;
        9'd236: line_pixel[236] = data_out;
        9'd237: line_pixel[237] = data_out;
        9'd238: line_pixel[238] = data_out;
        9'd239: line_pixel[239] = data_out;
        9'd240: line_pixel[240] = data_out;
        9'd241: line_pixel[241] = data_out;
        9'd242: line_pixel[242] = data_out;
        9'd243: line_pixel[243] = data_out;
        9'd244: line_pixel[244] = data_out;
        9'd245: line_pixel[245] = data_out;
        9'd246: line_pixel[246] = data_out;
        9'd247: line_pixel[247] = data_out;
        9'd248: line_pixel[248] = data_out;
        9'd249: line_pixel[249] = data_out;
        9'd250: line_pixel[250] = data_out;
        9'd251: line_pixel[251] = data_out;
        9'd252: line_pixel[252] = data_out;
        9'd253: line_pixel[253] = data_out;
        9'd254: line_pixel[254] = data_out;
        9'd255: line_pixel[255] = data_out;
        9'd256: line_pixel[256] = data_out;
        9'd257: line_pixel[257] = data_out;
        9'd258: line_pixel[258] = data_out;
        9'd259: line_pixel[259] = data_out;
        9'd260: line_pixel[260] = data_out;
        9'd261: line_pixel[261] = data_out;
        9'd262: line_pixel[262] = data_out;
        9'd263: line_pixel[263] = data_out;
        9'd264: line_pixel[264] = data_out;
        9'd265: line_pixel[265] = data_out;
        9'd266: line_pixel[266] = data_out;
        9'd267: line_pixel[267] = data_out;
        9'd268: line_pixel[268] = data_out;
        9'd269: line_pixel[269] = data_out;
        9'd270: line_pixel[270] = data_out;
        9'd271: line_pixel[271] = data_out;
        9'd272: line_pixel[272] = data_out;
        9'd273: line_pixel[273] = data_out;
        9'd274: line_pixel[274] = data_out;
        9'd275: line_pixel[275] = data_out;
        9'd276: line_pixel[276] = data_out;
        9'd277: line_pixel[277] = data_out;
        9'd278: line_pixel[278] = data_out;
        9'd279: line_pixel[279] = data_out;
        9'd280: line_pixel[280] = data_out;
        9'd281: line_pixel[281] = data_out;
        9'd282: line_pixel[282] = data_out;
        9'd283: line_pixel[283] = data_out;
        9'd284: line_pixel[284] = data_out;
        9'd285: line_pixel[285] = data_out;
        9'd286: line_pixel[286] = data_out;
        9'd287: line_pixel[287] = data_out;
        9'd288: line_pixel[288] = data_out;
        9'd289: line_pixel[289] = data_out;
        9'd290: line_pixel[290] = data_out;
        9'd291: line_pixel[291] = data_out;
        9'd292: line_pixel[292] = data_out;
        9'd293: line_pixel[293] = data_out;
        9'd294: line_pixel[294] = data_out;
        9'd295: line_pixel[295] = data_out;
        9'd296: line_pixel[296] = data_out;
        9'd297: line_pixel[297] = data_out;
        9'd298: line_pixel[298] = data_out;
        9'd299: line_pixel[299] = data_out;
        9'd300: line_pixel[300] = data_out;
        9'd301: line_pixel[301] = data_out;
        9'd302: line_pixel[302] = data_out;
        9'd303: line_pixel[303] = data_out;
        9'd304: line_pixel[304] = data_out;
        9'd305: line_pixel[305] = data_out;
        9'd306: line_pixel[306] = data_out;
        9'd307: line_pixel[307] = data_out;
        9'd308: line_pixel[308] = data_out;
        9'd309: line_pixel[309] = data_out;
        9'd310: line_pixel[310] = data_out;
        9'd311: line_pixel[311] = data_out;
        9'd312: line_pixel[312] = data_out;
        9'd313: line_pixel[313] = data_out;
        9'd314: line_pixel[314] = data_out;
        9'd315: line_pixel[315] = data_out;
        9'd316: line_pixel[316] = data_out;
        9'd317: line_pixel[317] = data_out;
        default :line_pixel = 319'd0;
            
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