module TransformROM (
    input clk,
    input [7:0] signal_read,
    output [7:0] result
  );
localparam SIZE = 64;
reg [7:0]result_q;

assign result = result_q;
//// I think I might need to just set up the whole transform in here to make things fast. //// 
//// Just have it output as a module. ////
wire [7:0] Sine [0:255];
wire [7:0] GaborW [0:255];


assign Sine[0] = 8'b01001011; assign GaborW[0] = 8'b00000000; 
assign Sine[1] = 8'b01001100; assign GaborW[1] = 8'b00000000; 
assign Sine[2] = 8'b01001101; assign GaborW[2] = 8'b00000000; 
assign Sine[3] = 8'b01001110; assign GaborW[3] = 8'b00000000; 
assign Sine[4] = 8'b01001111; assign GaborW[4] = 8'b00000000; 
assign Sine[5] = 8'b01010001; assign GaborW[5] = 8'b00000000; 
assign Sine[6] = 8'b01010010; assign GaborW[6] = 8'b00000000; 
assign Sine[7] = 8'b01010011; assign GaborW[7] = 8'b00000000; 
assign Sine[8] = 8'b01010100; assign GaborW[8] = 8'b00000000; 
assign Sine[9] = 8'b01010101; assign GaborW[9] = 8'b00000010; 
assign Sine[10] = 8'b01010111; assign GaborW[10] = 8'b00000101; 
assign Sine[11] = 8'b01011000; assign GaborW[11] = 8'b00001010; 
assign Sine[12] = 8'b01011001; assign GaborW[12] = 8'b00010010; 
assign Sine[13] = 8'b01011010; assign GaborW[13] = 8'b00011100; 
assign Sine[14] = 8'b01011011; assign GaborW[14] = 8'b00100110; 
assign Sine[15] = 8'b01011100; assign GaborW[15] = 8'b00101110; 
assign Sine[16] = 8'b01011110; assign GaborW[16] = 8'b00110010; 
assign Sine[17] = 8'b01011111; assign GaborW[17] = 8'b00101110; 
assign Sine[18] = 8'b01100000; assign GaborW[18] = 8'b00100110; 
assign Sine[19] = 8'b01100001; assign GaborW[19] = 8'b00011100; 
assign Sine[20] = 8'b01100010; assign GaborW[20] = 8'b00010010; 
assign Sine[21] = 8'b01100011; assign GaborW[21] = 8'b00001010; 
assign Sine[22] = 8'b01100100; assign GaborW[22] = 8'b00000101; 
assign Sine[23] = 8'b01100101; assign GaborW[23] = 8'b00000010; 
assign Sine[24] = 8'b01100110; assign GaborW[24] = 8'b00000000; 
assign Sine[25] = 8'b01100111; assign GaborW[25] = 8'b00000000; 
assign Sine[26] = 8'b01101000; assign GaborW[26] = 8'b00000000; 
assign Sine[27] = 8'b01101001; assign GaborW[27] = 8'b00000000; 
assign Sine[28] = 8'b01101010; assign GaborW[28] = 8'b00000000; 
assign Sine[29] = 8'b01101011; assign GaborW[29] = 8'b00000000; 
assign Sine[30] = 8'b01101100; assign GaborW[30] = 8'b00000000; 
assign Sine[31] = 8'b01101101; assign GaborW[31] = 8'b00000000; 
assign Sine[32] = 8'b01101110; assign GaborW[32] = 8'b00000000; 
assign Sine[33] = 8'b01101111; assign GaborW[33] = 8'b00000000; 
assign Sine[34] = 8'b01110000; assign GaborW[34] = 8'b00000000; 
assign Sine[35] = 8'b01110000; assign GaborW[35] = 8'b00000000; 
assign Sine[36] = 8'b01110001; assign GaborW[36] = 8'b00000000; 
assign Sine[37] = 8'b01110010; assign GaborW[37] = 8'b00000000; 
assign Sine[38] = 8'b01110011; assign GaborW[38] = 8'b00000000; 
assign Sine[39] = 8'b01110011; assign GaborW[39] = 8'b00000000; 
assign Sine[40] = 8'b01110100; assign GaborW[40] = 8'b00000000; 
assign Sine[41] = 8'b01110101; assign GaborW[41] = 8'b00000000; 
assign Sine[42] = 8'b01110101; assign GaborW[42] = 8'b00000000; 
assign Sine[43] = 8'b01110110; assign GaborW[43] = 8'b00000000; 
assign Sine[44] = 8'b01110111; assign GaborW[44] = 8'b00000000; 
assign Sine[45] = 8'b01110111; assign GaborW[45] = 8'b00000000; 
assign Sine[46] = 8'b01111000; assign GaborW[46] = 8'b00000000; 
assign Sine[47] = 8'b01111000; assign GaborW[47] = 8'b00000000; 
assign Sine[48] = 8'b01111001; assign GaborW[48] = 8'b00000000; 
assign Sine[49] = 8'b01111001; assign GaborW[49] = 8'b00000000; 
assign Sine[50] = 8'b01111010; assign GaborW[50] = 8'b00000000; 
assign Sine[51] = 8'b01111010; assign GaborW[51] = 8'b00000000; 
assign Sine[52] = 8'b01111010; assign GaborW[52] = 8'b00000000; 
assign Sine[53] = 8'b01111011; assign GaborW[53] = 8'b00000000; 
assign Sine[54] = 8'b01111011; assign GaborW[54] = 8'b00000000; 
assign Sine[55] = 8'b01111011; assign GaborW[55] = 8'b00000000; 
assign Sine[56] = 8'b01111100; assign GaborW[56] = 8'b00000000; 
assign Sine[57] = 8'b01111100; assign GaborW[57] = 8'b00000000; 
assign Sine[58] = 8'b01111100; assign GaborW[58] = 8'b00000000; 
assign Sine[59] = 8'b01111100; assign GaborW[59] = 8'b00000000; 
assign Sine[60] = 8'b01111100; assign GaborW[60] = 8'b00000000; 
assign Sine[61] = 8'b01111100; assign GaborW[61] = 8'b00000000; 
assign Sine[62] = 8'b01111100; assign GaborW[62] = 8'b00000000; 
assign Sine[63] = 8'b01111100; assign GaborW[63] = 8'b00000000; 
assign Sine[64] = 8'b01111101; assign GaborW[64] = 8'b00000000; 
assign Sine[65] = 8'b01111100; assign GaborW[65] = 8'b00000000; 
assign Sine[66] = 8'b01111100; assign GaborW[66] = 8'b00000000; 
assign Sine[67] = 8'b01111100; assign GaborW[67] = 8'b00000000; 
assign Sine[68] = 8'b01111100; assign GaborW[68] = 8'b00000000; 
assign Sine[69] = 8'b01111100; assign GaborW[69] = 8'b00000000; 
assign Sine[70] = 8'b01111100; assign GaborW[70] = 8'b00000000; 
assign Sine[71] = 8'b01111100; assign GaborW[71] = 8'b00000000; 
assign Sine[72] = 8'b01111100; assign GaborW[72] = 8'b00000000; 
assign Sine[73] = 8'b01111011; assign GaborW[73] = 8'b00000000; 
assign Sine[74] = 8'b01111011; assign GaborW[74] = 8'b00000000; 
assign Sine[75] = 8'b01111011; assign GaborW[75] = 8'b00000000; 
assign Sine[76] = 8'b01111010; assign GaborW[76] = 8'b00000000; 
assign Sine[77] = 8'b01111010; assign GaborW[77] = 8'b00000000; 
assign Sine[78] = 8'b01111010; assign GaborW[78] = 8'b00000000; 
assign Sine[79] = 8'b01111001; assign GaborW[79] = 8'b00000000; 
assign Sine[80] = 8'b01111001; assign GaborW[80] = 8'b00000000; 
assign Sine[81] = 8'b01111000; assign GaborW[81] = 8'b00000000; 
assign Sine[82] = 8'b01111000; assign GaborW[82] = 8'b00000000; 
assign Sine[83] = 8'b01110111; assign GaborW[83] = 8'b00000000; 
assign Sine[84] = 8'b01110111; assign GaborW[84] = 8'b00000000; 
assign Sine[85] = 8'b01110110; assign GaborW[85] = 8'b00000000; 
assign Sine[86] = 8'b01110101; assign GaborW[86] = 8'b00000000; 
assign Sine[87] = 8'b01110101; assign GaborW[87] = 8'b00000000; 
assign Sine[88] = 8'b01110100; assign GaborW[88] = 8'b00000000; 
assign Sine[89] = 8'b01110011; assign GaborW[89] = 8'b00000000; 
assign Sine[90] = 8'b01110011; assign GaborW[90] = 8'b00000000; 
assign Sine[91] = 8'b01110010; assign GaborW[91] = 8'b00000000; 
assign Sine[92] = 8'b01110001; assign GaborW[92] = 8'b00000000; 
assign Sine[93] = 8'b01110000; assign GaborW[93] = 8'b00000000; 
assign Sine[94] = 8'b01110000; assign GaborW[94] = 8'b00000000; 
assign Sine[95] = 8'b01101111; assign GaborW[95] = 8'b00000000; 
assign Sine[96] = 8'b01101110; assign GaborW[96] = 8'b00000000; 
assign Sine[97] = 8'b01101101; assign GaborW[97] = 8'b00000000; 
assign Sine[98] = 8'b01101100; assign GaborW[98] = 8'b00000000; 
assign Sine[99] = 8'b01101011; assign GaborW[99] = 8'b00000000; 
assign Sine[100] = 8'b01101010; assign GaborW[100] = 8'b00000000; 
assign Sine[101] = 8'b01101001; assign GaborW[101] = 8'b00000000; 
assign Sine[102] = 8'b01101000; assign GaborW[102] = 8'b00000000; 
assign Sine[103] = 8'b01100111; assign GaborW[103] = 8'b00000000; 
assign Sine[104] = 8'b01100110; assign GaborW[104] = 8'b00000000; 
assign Sine[105] = 8'b01100101; assign GaborW[105] = 8'b00000000; 
assign Sine[106] = 8'b01100100; assign GaborW[106] = 8'b00000000; 
assign Sine[107] = 8'b01100011; assign GaborW[107] = 8'b00000000; 
assign Sine[108] = 8'b01100010; assign GaborW[108] = 8'b00000000; 
assign Sine[109] = 8'b01100001; assign GaborW[109] = 8'b00000000; 
assign Sine[110] = 8'b01100000; assign GaborW[110] = 8'b00000000; 
assign Sine[111] = 8'b01011111; assign GaborW[111] = 8'b00000000; 
assign Sine[112] = 8'b01011110; assign GaborW[112] = 8'b00000000; 
assign Sine[113] = 8'b01011100; assign GaborW[113] = 8'b00000000; 
assign Sine[114] = 8'b01011011; assign GaborW[114] = 8'b00000000; 
assign Sine[115] = 8'b01011010; assign GaborW[115] = 8'b00000000; 
assign Sine[116] = 8'b01011001; assign GaborW[116] = 8'b00000000; 
assign Sine[117] = 8'b01011000; assign GaborW[117] = 8'b00000000; 
assign Sine[118] = 8'b01010111; assign GaborW[118] = 8'b00000000; 
assign Sine[119] = 8'b01010101; assign GaborW[119] = 8'b00000000; 
assign Sine[120] = 8'b01010100; assign GaborW[120] = 8'b00000000; 
assign Sine[121] = 8'b01010011; assign GaborW[121] = 8'b00000000; 
assign Sine[122] = 8'b01010010; assign GaborW[122] = 8'b00000000; 
assign Sine[123] = 8'b01010001; assign GaborW[123] = 8'b00000000; 
assign Sine[124] = 8'b01001111; assign GaborW[124] = 8'b00000000; 
assign Sine[125] = 8'b01001110; assign GaborW[125] = 8'b00000000; 
assign Sine[126] = 8'b01001101; assign GaborW[126] = 8'b00000000; 
assign Sine[127] = 8'b01001100; assign GaborW[127] = 8'b00000000; 
assign Sine[128] = 8'b01001011; assign GaborW[128] = 8'b00000000; 
assign Sine[129] = 8'b01001001; assign GaborW[129] = 8'b00000000; 
assign Sine[130] = 8'b01001000; assign GaborW[130] = 8'b00000000; 
assign Sine[131] = 8'b01000111; assign GaborW[131] = 8'b00000000; 
assign Sine[132] = 8'b01000110; assign GaborW[132] = 8'b00000000; 
assign Sine[133] = 8'b01000100; assign GaborW[133] = 8'b00000000; 
assign Sine[134] = 8'b01000011; assign GaborW[134] = 8'b00000000; 
assign Sine[135] = 8'b01000010; assign GaborW[135] = 8'b00000000; 
assign Sine[136] = 8'b01000001; assign GaborW[136] = 8'b00000000; 
assign Sine[137] = 8'b01000000; assign GaborW[137] = 8'b00000000; 
assign Sine[138] = 8'b00111110; assign GaborW[138] = 8'b00000000; 
assign Sine[139] = 8'b00111101; assign GaborW[139] = 8'b00000000; 
assign Sine[140] = 8'b00111100; assign GaborW[140] = 8'b00000000; 
assign Sine[141] = 8'b00111011; assign GaborW[141] = 8'b00000000; 
assign Sine[142] = 8'b00111010; assign GaborW[142] = 8'b00000000; 
assign Sine[143] = 8'b00111001; assign GaborW[143] = 8'b00000000; 
assign Sine[144] = 8'b00110111; assign GaborW[144] = 8'b00000000; 
assign Sine[145] = 8'b00110110; assign GaborW[145] = 8'b00000000; 
assign Sine[146] = 8'b00110101; assign GaborW[146] = 8'b00000000; 
assign Sine[147] = 8'b00110100; assign GaborW[147] = 8'b00000000; 
assign Sine[148] = 8'b00110011; assign GaborW[148] = 8'b00000000; 
assign Sine[149] = 8'b00110010; assign GaborW[149] = 8'b00000000; 
assign Sine[150] = 8'b00110001; assign GaborW[150] = 8'b00000000; 
assign Sine[151] = 8'b00110000; assign GaborW[151] = 8'b00000000; 
assign Sine[152] = 8'b00101111; assign GaborW[152] = 8'b00000000; 
assign Sine[153] = 8'b00101110; assign GaborW[153] = 8'b00000000; 
assign Sine[154] = 8'b00101101; assign GaborW[154] = 8'b00000000; 
assign Sine[155] = 8'b00101100; assign GaborW[155] = 8'b00000000; 
assign Sine[156] = 8'b00101011; assign GaborW[156] = 8'b00000000; 
assign Sine[157] = 8'b00101010; assign GaborW[157] = 8'b00000000; 
assign Sine[158] = 8'b00101001; assign GaborW[158] = 8'b00000000; 
assign Sine[159] = 8'b00101000; assign GaborW[159] = 8'b00000000; 
assign Sine[160] = 8'b00100111; assign GaborW[160] = 8'b00000000; 
assign Sine[161] = 8'b00100110; assign GaborW[161] = 8'b00000000; 
assign Sine[162] = 8'b00100101; assign GaborW[162] = 8'b00000000; 
assign Sine[163] = 8'b00100101; assign GaborW[163] = 8'b00000000; 
assign Sine[164] = 8'b00100100; assign GaborW[164] = 8'b00000000; 
assign Sine[165] = 8'b00100011; assign GaborW[165] = 8'b00000000; 
assign Sine[166] = 8'b00100010; assign GaborW[166] = 8'b00000000; 
assign Sine[167] = 8'b00100010; assign GaborW[167] = 8'b00000000; 
assign Sine[168] = 8'b00100001; assign GaborW[168] = 8'b00000000; 
assign Sine[169] = 8'b00100000; assign GaborW[169] = 8'b00000000; 
assign Sine[170] = 8'b00100000; assign GaborW[170] = 8'b00000000; 
assign Sine[171] = 8'b00011111; assign GaborW[171] = 8'b00000000; 
assign Sine[172] = 8'b00011110; assign GaborW[172] = 8'b00000000; 
assign Sine[173] = 8'b00011110; assign GaborW[173] = 8'b00000000; 
assign Sine[174] = 8'b00011101; assign GaborW[174] = 8'b00000000; 
assign Sine[175] = 8'b00011101; assign GaborW[175] = 8'b00000000; 
assign Sine[176] = 8'b00011100; assign GaborW[176] = 8'b00000000; 
assign Sine[177] = 8'b00011100; assign GaborW[177] = 8'b00000000; 
assign Sine[178] = 8'b00011011; assign GaborW[178] = 8'b00000000; 
assign Sine[179] = 8'b00011011; assign GaborW[179] = 8'b00000000; 
assign Sine[180] = 8'b00011011; assign GaborW[180] = 8'b00000000; 
assign Sine[181] = 8'b00011010; assign GaborW[181] = 8'b00000000; 
assign Sine[182] = 8'b00011010; assign GaborW[182] = 8'b00000000; 
assign Sine[183] = 8'b00011010; assign GaborW[183] = 8'b00000000; 
assign Sine[184] = 8'b00011001; assign GaborW[184] = 8'b00000000; 
assign Sine[185] = 8'b00011001; assign GaborW[185] = 8'b00000000; 
assign Sine[186] = 8'b00011001; assign GaborW[186] = 8'b00000000; 
assign Sine[187] = 8'b00011001; assign GaborW[187] = 8'b00000000; 
assign Sine[188] = 8'b00011001; assign GaborW[188] = 8'b00000000; 
assign Sine[189] = 8'b00011001; assign GaborW[189] = 8'b00000000; 
assign Sine[190] = 8'b00011001; assign GaborW[190] = 8'b00000000; 
assign Sine[191] = 8'b00011001; assign GaborW[191] = 8'b00000000; 
assign Sine[192] = 8'b00011001; assign GaborW[192] = 8'b00000000; 
assign Sine[193] = 8'b00011001; assign GaborW[193] = 8'b00000000; 
assign Sine[194] = 8'b00011001; assign GaborW[194] = 8'b00000000; 
assign Sine[195] = 8'b00011001; assign GaborW[195] = 8'b00000000; 
assign Sine[196] = 8'b00011001; assign GaborW[196] = 8'b00000000; 
assign Sine[197] = 8'b00011001; assign GaborW[197] = 8'b00000000; 
assign Sine[198] = 8'b00011001; assign GaborW[198] = 8'b00000000; 
assign Sine[199] = 8'b00011001; assign GaborW[199] = 8'b00000000; 
assign Sine[200] = 8'b00011001; assign GaborW[200] = 8'b00000000; 
assign Sine[201] = 8'b00011010; assign GaborW[201] = 8'b00000000; 
assign Sine[202] = 8'b00011010; assign GaborW[202] = 8'b00000000; 
assign Sine[203] = 8'b00011010; assign GaborW[203] = 8'b00000000; 
assign Sine[204] = 8'b00011011; assign GaborW[204] = 8'b00000000; 
assign Sine[205] = 8'b00011011; assign GaborW[205] = 8'b00000000; 
assign Sine[206] = 8'b00011011; assign GaborW[206] = 8'b00000000; 
assign Sine[207] = 8'b00011100; assign GaborW[207] = 8'b00000000; 
assign Sine[208] = 8'b00011100; assign GaborW[208] = 8'b00000000; 
assign Sine[209] = 8'b00011101; assign GaborW[209] = 8'b00000000; 
assign Sine[210] = 8'b00011101; assign GaborW[210] = 8'b00000000; 
assign Sine[211] = 8'b00011110; assign GaborW[211] = 8'b00000000; 
assign Sine[212] = 8'b00011110; assign GaborW[212] = 8'b00000000; 
assign Sine[213] = 8'b00011111; assign GaborW[213] = 8'b00000000; 
assign Sine[214] = 8'b00100000; assign GaborW[214] = 8'b00000000; 
assign Sine[215] = 8'b00100000; assign GaborW[215] = 8'b00000000; 
assign Sine[216] = 8'b00100001; assign GaborW[216] = 8'b00000000; 
assign Sine[217] = 8'b00100010; assign GaborW[217] = 8'b00000000; 
assign Sine[218] = 8'b00100010; assign GaborW[218] = 8'b00000000; 
assign Sine[219] = 8'b00100011; assign GaborW[219] = 8'b00000000; 
assign Sine[220] = 8'b00100100; assign GaborW[220] = 8'b00000000; 
assign Sine[221] = 8'b00100101; assign GaborW[221] = 8'b00000000; 
assign Sine[222] = 8'b00100101; assign GaborW[222] = 8'b00000000; 
assign Sine[223] = 8'b00100110; assign GaborW[223] = 8'b00000000; 
assign Sine[224] = 8'b00100111; assign GaborW[224] = 8'b00000000; 
assign Sine[225] = 8'b00101000; assign GaborW[225] = 8'b00000000; 
assign Sine[226] = 8'b00101001; assign GaborW[226] = 8'b00000000; 
assign Sine[227] = 8'b00101010; assign GaborW[227] = 8'b00000000; 
assign Sine[228] = 8'b00101011; assign GaborW[228] = 8'b00000000; 
assign Sine[229] = 8'b00101100; assign GaborW[229] = 8'b00000000; 
assign Sine[230] = 8'b00101101; assign GaborW[230] = 8'b00000000; 
assign Sine[231] = 8'b00101110; assign GaborW[231] = 8'b00000000; 
assign Sine[232] = 8'b00101111; assign GaborW[232] = 8'b00000000; 
assign Sine[233] = 8'b00110000; assign GaborW[233] = 8'b00000000; 
assign Sine[234] = 8'b00110001; assign GaborW[234] = 8'b00000000; 
assign Sine[235] = 8'b00110010; assign GaborW[235] = 8'b00000000; 
assign Sine[236] = 8'b00110011; assign GaborW[236] = 8'b00000000; 
assign Sine[237] = 8'b00110100; assign GaborW[237] = 8'b00000000; 
assign Sine[238] = 8'b00110101; assign GaborW[238] = 8'b00000000; 
assign Sine[239] = 8'b00110110; assign GaborW[239] = 8'b00000000; 
assign Sine[240] = 8'b00110111; assign GaborW[240] = 8'b00000000; 
assign Sine[241] = 8'b00111001; assign GaborW[241] = 8'b00000000; 
assign Sine[242] = 8'b00111010; assign GaborW[242] = 8'b00000000; 
assign Sine[243] = 8'b00111011; assign GaborW[243] = 8'b00000000; 
assign Sine[244] = 8'b00111100; assign GaborW[244] = 8'b00000000; 
assign Sine[245] = 8'b00111101; assign GaborW[245] = 8'b00000000; 
assign Sine[246] = 8'b00111110; assign GaborW[246] = 8'b00000000; 
assign Sine[247] = 8'b01000000; assign GaborW[247] = 8'b00000000; 
assign Sine[248] = 8'b01000001; assign GaborW[248] = 8'b00000000; 
assign Sine[249] = 8'b01000010; assign GaborW[249] = 8'b00000000; 
assign Sine[250] = 8'b01000011; assign GaborW[250] = 8'b00000000; 
assign Sine[251] = 8'b01000100; assign GaborW[251] = 8'b00000000; 
assign Sine[252] = 8'b01000110; assign GaborW[252] = 8'b00000000; 
assign Sine[253] = 8'b01000111; assign GaborW[253] = 8'b00000000; 
assign Sine[254] = 8'b01001000; assign GaborW[254] = 8'b00000000; 
assign Sine[255] = 8'b01001001; assign GaborW[255] = 8'b00000000; 
  /* Combinational Logic */
  // This was an idea for individually grabbing the ROM data, but I think it would be too slow. 
  // If I come up with something more clever it could be used. 
  /*always @* begin
    Sine_out <= Sine[addr1];
    Window_out <= GaborW[addr2];
  end*/
reg [7:0] Buffer [0:SIZE - 1][0:SIZE - 1];
reg [5:0] addr1 = 5'b0;
reg [5:0] addr2 = 5'b0;
reg [7:0] data = 8'b0;

reg [31:0] sum [0:SIZE - 1][0:SIZE - 1];
//reg [7:0] array1 [0:2] = { 8'haa, 8'hbb, 8'hcc }; 
//reg [7:0] array2 [2:0] = { 8'haa, 8'hbb, 8'hcc }; 
//This ^ doesn't work
//reg [8999:0] more_parity = {4500{2'b10}};
// This reg assignment works ^.
  ///////////////sudo playing with code//////////////////
always @(negedge clk) begin 
   data <= signal_read;// Grab Data point
   addr1 <= addr1 + 1'b1;
   if (addr1 == 6'd63) begin
      addr2 <= addr2 + 1'b1;
   end
  // result_q <= Buffer[addr1][addr2];
  result_q <= Buffer[addr1][addr2];
 end  
   //addr1 keeps track of time instance. 
   //we need to multiply that one data point by everything we can//
   //generate for loop//
   // for each l 0 to 239// do this
   //sum[l] <= data*GaborW[addr1 - l/* shifted by l*/] + sum[l]; 
   
   // Example with numbers
   //sum[0] <= data*GaborW[addr1 - 0/* shifted by 0*/] + sum[0];
   //sum[1] <= data*GaborW[addr1 - 1/* shifted by 1*/] + sum[1];
   //sum[2] <= data*GaborW[addr1 - 2/* shifted by 2*/] + sum[2];
   //sum[3] <= data*GaborW[addr1 - 3/* shifted by 3*/] + sum[3]; 
   // I'll need to set up an array of this for sine and window.

genvar l,m;    
// set value low for checking compiler errors    
generate     
  for (l = 0; l < SIZE ; l = l+1) begin : time_shift
    for (m = 0; m < SIZE ; m = m+1)begin : frequency
      always @(negedge clk) begin  // define wires R,S try hidden variable approach. 
        /*if (addr1 == 3'b000) begin
          sum[m][l] <= 32'b0;
        end*/ 
        if (addr1 == 6'b0) begin
          sum[l][m] <= 32'b0;
        end 
        else if (GaborW[addr1 -l] == 8'h00 ) begin
          sum [l][m] <= sum[l][m];
        
       end else if (addr1 == 6'd63) begin
           Buffer[l][m] <= sum[l][m][30:23];
        end else begin 
          sum [l][m] <= ( data * GaborW[(addr1 - l)/* shifted by l*/] * (Sine[(addr1*m)&8'hFF /* finds addres of sine frequency m*/] -8'd75) )+ sum[l][m] ;     
        end 
         
       /* if (addr1 == 6'd15) begin
           Buffer[l][m] = sum[l][m][30:23];
        end */  
      end
    end
  end        
endgenerate 
   
   
   //sum[0][] <= data*GaborW[addr1 - 0/* shifted by 0*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[0][];
   //sum[1][] <= data*GaborW[addr1 - 1/* shifted by 1*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[1][];
   //sum[2][] <= data*GaborW[addr1 - 2/* shifted by 2*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[2][];
   //sum[3][] <= data*GaborW[addr1 - 3/* shifted by 3*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[3][]; 
  
   //Alternative option, I build an array of the values pre multiplied ahead of time GE[l,m] and multiply through that way
   // for each l and each m. This method is less flexible, and would require more space, but would take less DSP operations.
   // sum[l][m] = data * G[l][m] + sum[l][m]
   
   
  

  
  
endmodule
