module SFTransform_v2 (
    input clk,
    input busy,
    input [7:0] signal_read,
    output reg [7:0] result
  );
//This version uses too much LUTM for RAM and no Block RAM.   
localparam SIZE = 128;//128
localparam WINDOW_WIDTH = 15;//center is at 7. With 7 values on each side. 
//reg [7:0]result_q;
localparam SIZE_C = 6; // reg size -1
localparam UPDATE = 7'b1111111;
localparam INIT = 7'b0;
//assign result = result_q;
//// I think I might need to just set up the whole transform in here to make things fast. //// 
//// Just have it output as a module. ////
reg [7:0] Sine [0:255];
reg [7:0] GaborW [0:WINDOW_WIDTH - 1];

/*
assign Sine[0] = 8'b01001011; assign GaborW[0] = 8'b00000100; //center value first to reduce number of adders.
assign Sine[1] = 8'b01001100; assign GaborW[1] = 8'b00001010;
assign Sine[2] = 8'b01001101; assign GaborW[2] = 8'b00010100; 
assign Sine[3] = 8'b01001110; assign GaborW[3] = 8'b00100100;
assign Sine[4] = 8'b01001111; assign GaborW[4] = 8'b00111000; 
assign Sine[5] = 8'b01010001; assign GaborW[5] = 8'b01001100; 
assign Sine[6] = 8'b01010010; assign GaborW[6] = 8'b01011100;
assign Sine[7] = 8'b01010011; assign GaborW[7] = 8'b01100100;  
assign Sine[8] = 8'b01010100; assign GaborW[8] = 8'b01011100; 
assign Sine[9] = 8'b01010101; assign GaborW[9] = 8'b01001100; 
assign Sine[10] = 8'b01010111; assign GaborW[10] = 8'b00111000; 
assign Sine[11] = 8'b01011000; assign GaborW[11] = 8'b00100100; 
assign Sine[12] = 8'b01011001; assign GaborW[12] = 8'b00010100;  
assign Sine[13] = 8'b01011010; assign GaborW[13] = 8'b00001010;
assign Sine[14] = 8'b01011011; assign GaborW[14] = 8'b00000100;
assign Sine[15] = 8'b01011100;  
assign Sine[16] = 8'b01011110;  
assign Sine[17] = 8'b01011111; 
assign Sine[18] = 8'b01100000; 
assign Sine[19] = 8'b01100001; 
assign Sine[20] = 8'b01100010; 
assign Sine[21] = 8'b01100011; 
assign Sine[22] = 8'b01100100;  
assign Sine[23] = 8'b01100101;  
assign Sine[24] = 8'b01100110; 
assign Sine[25] = 8'b01100111; 
assign Sine[26] = 8'b01101000; 
assign Sine[27] = 8'b01101001; 
assign Sine[28] = 8'b01101010; 
assign Sine[29] = 8'b01101011;  
assign Sine[30] = 8'b01101100; 
assign Sine[31] = 8'b01101101;  
assign Sine[32] = 8'b01101110; 
assign Sine[33] = 8'b01101111; 
assign Sine[34] = 8'b01110000;  
assign Sine[35] = 8'b01110000; 
assign Sine[36] = 8'b01110001; 
assign Sine[37] = 8'b01110010;  
assign Sine[38] = 8'b01110011;  
assign Sine[39] = 8'b01110011; 
assign Sine[40] = 8'b01110100;  
assign Sine[41] = 8'b01110101; 
assign Sine[42] = 8'b01110101;  
assign Sine[43] = 8'b01110110;
assign Sine[44] = 8'b01110111;
assign Sine[45] = 8'b01110111; 
assign Sine[46] = 8'b01111000; 
assign Sine[47] = 8'b01111000; 
assign Sine[48] = 8'b01111001; 
assign Sine[49] = 8'b01111001; 
assign Sine[50] = 8'b01111010; 
assign Sine[51] = 8'b01111010;  
assign Sine[52] = 8'b01111010;  
assign Sine[53] = 8'b01111011;
assign Sine[54] = 8'b01111011; 
assign Sine[55] = 8'b01111011; 
assign Sine[56] = 8'b01111100;  
assign Sine[57] = 8'b01111100; 
assign Sine[58] = 8'b01111100;
assign Sine[59] = 8'b01111100; 
assign Sine[60] = 8'b01111100; 
assign Sine[61] = 8'b01111100; 
assign Sine[62] = 8'b01111100; 
assign Sine[63] = 8'b01111100; 
assign Sine[64] = 8'b01111101; 
assign Sine[65] = 8'b01111100; 
assign Sine[66] = 8'b01111100;
assign Sine[67] = 8'b01111100; 
assign Sine[68] = 8'b01111100; 
assign Sine[69] = 8'b01111100; 
assign Sine[70] = 8'b01111100; 
assign Sine[71] = 8'b01111100;
assign Sine[72] = 8'b01111100; 
assign Sine[73] = 8'b01111011; 
assign Sine[74] = 8'b01111011;  
assign Sine[75] = 8'b01111011; 
assign Sine[76] = 8'b01111010; 
assign Sine[77] = 8'b01111010; 
assign Sine[78] = 8'b01111010;  
assign Sine[79] = 8'b01111001; 
assign Sine[80] = 8'b01111001;  
assign Sine[81] = 8'b01111000;  
assign Sine[82] = 8'b01111000;  
assign Sine[83] = 8'b01110111;  
assign Sine[84] = 8'b01110111; 
assign Sine[85] = 8'b01110110; 
assign Sine[86] = 8'b01110101; 
assign Sine[87] = 8'b01110101; 
assign Sine[88] = 8'b01110100; 
assign Sine[89] = 8'b01110011;
assign Sine[90] = 8'b01110011;  
assign Sine[91] = 8'b01110010; 
assign Sine[92] = 8'b01110001; 
assign Sine[93] = 8'b01110000;  
assign Sine[94] = 8'b01110000; 
assign Sine[95] = 8'b01101111;
assign Sine[96] = 8'b01101110; 
assign Sine[97] = 8'b01101101; 
assign Sine[98] = 8'b01101100;
assign Sine[99] = 8'b01101011; 
assign Sine[100] = 8'b01101010;
assign Sine[101] = 8'b01101001; 
assign Sine[102] = 8'b01101000; 
assign Sine[103] = 8'b01100111; 
assign Sine[104] = 8'b01100110; 
assign Sine[105] = 8'b01100101; 
assign Sine[106] = 8'b01100100; 
assign Sine[107] = 8'b01100011;  
assign Sine[108] = 8'b01100010;  
assign Sine[109] = 8'b01100001;  
assign Sine[110] = 8'b01100000; 
assign Sine[111] = 8'b01011111;  
assign Sine[112] = 8'b01011110;  
assign Sine[113] = 8'b01011100;  
assign Sine[114] = 8'b01011011;
assign Sine[115] = 8'b01011010;  
assign Sine[116] = 8'b01011001; 
assign Sine[117] = 8'b01011000; 
assign Sine[118] = 8'b01010111;  
assign Sine[119] = 8'b01010101; 
assign Sine[120] = 8'b01010100; 
assign Sine[121] = 8'b01010011;  
assign Sine[122] = 8'b01010010;  
assign Sine[123] = 8'b01010001; 
assign Sine[124] = 8'b01001111; 
assign Sine[125] = 8'b01001110; 
assign Sine[126] = 8'b01001101;  
assign Sine[127] = 8'b01001100; 
assign Sine[128] = 8'b01001011; 
assign Sine[129] = 8'b01001001;  
assign Sine[130] = 8'b01001000;  
assign Sine[131] = 8'b01000111; 
assign Sine[132] = 8'b01000110;  
assign Sine[133] = 8'b01000100; 
assign Sine[134] = 8'b01000011;  
assign Sine[135] = 8'b01000010;
assign Sine[136] = 8'b01000001; 
assign Sine[137] = 8'b01000000; 
assign Sine[138] = 8'b00111110; 
assign Sine[139] = 8'b00111101; 
assign Sine[140] = 8'b00111100; 
assign Sine[141] = 8'b00111011;  
assign Sine[142] = 8'b00111010; 
assign Sine[143] = 8'b00111001;  
assign Sine[144] = 8'b00110111; 
assign Sine[145] = 8'b00110110; 
assign Sine[146] = 8'b00110101; 
assign Sine[147] = 8'b00110100;  
assign Sine[148] = 8'b00110011; 
assign Sine[149] = 8'b00110010; 
assign Sine[150] = 8'b00110001; 
assign Sine[151] = 8'b00110000;  
assign Sine[152] = 8'b00101111; 
assign Sine[153] = 8'b00101110;  
assign Sine[154] = 8'b00101101; 
assign Sine[155] = 8'b00101100; 
assign Sine[156] = 8'b00101011;  
assign Sine[157] = 8'b00101010; 
assign Sine[158] = 8'b00101001; 
assign Sine[159] = 8'b00101000; 
assign Sine[160] = 8'b00100111;  
assign Sine[161] = 8'b00100110; 
assign Sine[162] = 8'b00100101;  
assign Sine[163] = 8'b00100101;  
assign Sine[164] = 8'b00100100; 
assign Sine[165] = 8'b00100011; 
assign Sine[166] = 8'b00100010;  
assign Sine[167] = 8'b00100010;  
assign Sine[168] = 8'b00100001;  
assign Sine[169] = 8'b00100000;  
assign Sine[170] = 8'b00100000; 
assign Sine[171] = 8'b00011111;  
assign Sine[172] = 8'b00011110;  
assign Sine[173] = 8'b00011110;  
assign Sine[174] = 8'b00011101;  
assign Sine[175] = 8'b00011101;  
assign Sine[176] = 8'b00011100;  
assign Sine[177] = 8'b00011100;  
assign Sine[178] = 8'b00011011;  
assign Sine[179] = 8'b00011011;  
assign Sine[180] = 8'b00011011;  
assign Sine[181] = 8'b00011010;  
assign Sine[182] = 8'b00011010;  
assign Sine[183] = 8'b00011010;
assign Sine[184] = 8'b00011001; 
assign Sine[185] = 8'b00011001; 
assign Sine[186] = 8'b00011001; 
assign Sine[187] = 8'b00011001; 
assign Sine[188] = 8'b00011001; 
assign Sine[189] = 8'b00011001; 
assign Sine[190] = 8'b00011001; 
assign Sine[191] = 8'b00011001; 
assign Sine[192] = 8'b00011001;
assign Sine[193] = 8'b00011001; 
assign Sine[194] = 8'b00011001; 
assign Sine[195] = 8'b00011001; 
assign Sine[196] = 8'b00011001; 
assign Sine[197] = 8'b00011001;  
assign Sine[198] = 8'b00011001;  
assign Sine[199] = 8'b00011001; 
assign Sine[200] = 8'b00011001; 
assign Sine[201] = 8'b00011010; 
assign Sine[202] = 8'b00011010; 
assign Sine[203] = 8'b00011010; 
assign Sine[204] = 8'b00011011; 
assign Sine[205] = 8'b00011011;
assign Sine[206] = 8'b00011011;  
assign Sine[207] = 8'b00011100;  
assign Sine[208] = 8'b00011100;  
assign Sine[209] = 8'b00011101;  
assign Sine[210] = 8'b00011101; 
assign Sine[211] = 8'b00011110;  
assign Sine[212] = 8'b00011110; 
assign Sine[213] = 8'b00011111; 
assign Sine[214] = 8'b00100000;  
assign Sine[215] = 8'b00100000; 
assign Sine[216] = 8'b00100001; 
assign Sine[217] = 8'b00100010; 
assign Sine[218] = 8'b00100010; 
assign Sine[219] = 8'b00100011; 
assign Sine[220] = 8'b00100100; 
assign Sine[221] = 8'b00100101;
assign Sine[222] = 8'b00100101;  
assign Sine[223] = 8'b00100110; 
assign Sine[224] = 8'b00100111; 
assign Sine[225] = 8'b00101000; 
assign Sine[226] = 8'b00101001;
assign Sine[227] = 8'b00101010;  
assign Sine[228] = 8'b00101011; 
assign Sine[229] = 8'b00101100; 
assign Sine[230] = 8'b00101101;  
assign Sine[231] = 8'b00101110; 
assign Sine[232] = 8'b00101111; 
assign Sine[233] = 8'b00110000;  
assign Sine[234] = 8'b00110001; 
assign Sine[235] = 8'b00110010; 
assign Sine[236] = 8'b00110011; 
assign Sine[237] = 8'b00110100;  
assign Sine[238] = 8'b00110101;  
assign Sine[239] = 8'b00110110; 
assign Sine[240] = 8'b00110111;  
assign Sine[241] = 8'b00111001; 
assign Sine[242] = 8'b00111010; 
assign Sine[243] = 8'b00111011; 
assign Sine[244] = 8'b00111100; 
assign Sine[245] = 8'b00111101; 
assign Sine[246] = 8'b00111110;  
assign Sine[247] = 8'b01000000;  
assign Sine[248] = 8'b01000001;  
assign Sine[249] = 8'b01000010; 
assign Sine[250] = 8'b01000011; 
assign Sine[251] = 8'b01000100; 
assign Sine[252] = 8'b01000110; 
assign Sine[253] = 8'b01000111;  
assign Sine[254] = 8'b01001000; 
assign Sine[255] = 8'b01001001;*/
  /* Combinational Logic */
  // This was an idea for individually grabbing the ROM data, but I think it would be too slow. 
  // If I come up with something more clever it could be used. 
  /*always @* begin
    Sine_out <= Sine[addr1];
    Window_out <= GaborW[addr2];
  end*/

reg [SIZE_C:0] counter = INIT;//7'b0  <========= update here
reg [7:0] addr2 = 8'b0;
reg [3:0] addr1 = 4'b0;
//wire [7:0] data;
//assign data = signal_read;// could be the cause of LUTs
integer l,m;
reg [7:0] sumS [0:WINDOW_WIDTH - 1][0:SIZE - 1];
reg [7:0] sumC [0:WINDOW_WIDTH - 1][0:SIZE - 1];
reg [1:0] state = 2'b00;
reg [6:0] loop = 7'b0;
//reg [5:0]S = 6'b0;
//reg [7:0] array1 [0:2] = { 8'haa, 8'hbb, 8'hcc }; 
//reg [7:0] array2 [2:0] = { 8'haa, 8'hbb, 8'hcc }; 
//This ^ doesn't work
//reg [8999:0] more_parity = {4500{2'b10}};
// This reg assignment works ^.
  ///////////////sudo playing with code//////////////////
  
  
// idea: I can set a sinquencial block for busy signal seperate to a clock signal.
// build: state machine that uses the results of that busy signal counter.  
  
  
always @(negedge busy) begin // neg edge of busy is that we finished transmitting the last signal. 

counter <= counter + 1'b1;  // Counter keeps track of which frequency value I am transmitting. 

                                    // on bit 128 I want to start the state machine. //7'b1111111 <========= update here
   if (counter == UPDATE) begin //This is to make sure that the Gabor transform is properly calculated with each new instant of time. 
      addr2 <= addr2 + 1'b1;        //Set counter for the calculation to shift
      if (addr1 == 4'b1110) begin   // addr2 keeps track of time instance. 256 of these
        addr1 <= 4'b0;              // addr1 keeps track of window instance. 15 of these
      end else begin                //
      addr1 <= addr1 + 1'b1;        // Sets which column of data is to be erased and transmited. 
      end                           //
   end                              //
  ////////Transmit Code/////////
  //Third State: Transmit data for 128 Bytes of data
  result <= ((sumS[addr1][counter]/*sumS[addr1][counter]*/) + (sumC[addr1][counter]*sumC[addr1][counter])); // always at negedge of busy I want to load in the next transmit bit.
  // ^^^^^^^^^^^^ this line is written correctly for grabbing the address of sum and the 8 bits of that word in that address. 
  //<== number of sites problem is left to resolve
  //So, it turns out that the number of sites is how many LUTs have the desired built in slice. 
    
end

///////////////////////////Code for calculation/////////////////////////

always @(posedge clk) begin

  case (state)
   //ZERO STATE: Set idle waitig for transmit to finish. 
   2'b00: begin
            if (counter == UPDATE) begin //7'b1111111 <========= update here
              state <= 2'b01;
            end
         end
  //FIRST State: Erase previous transmitted row
  2'b01: begin
    
    loop <= loop + 1'b1;
    //for (m = 0; m < 4; m = m +1 ) begin 
       sumS[addr1][loop] <= 8'b0; //32'b0 
       sumC[addr1][loop] <= 8'b0; //32'b0
    //end
    if (loop == 7'b1111111) begin
    //S <= 7'b0;
    state <= 2'b10;
    end
  end

  //Second State: Get data point and calculate
  2'b10: begin
    //data <= signal_read;// Grab Data point
    loop <= loop + 1'b1;
     for (l = 0; l < WINDOW_WIDTH ; l = l+1) begin : time_shift // GaborW[(addr1 +7 - l)/* shifted by l*/]
        //for (m = 0; m < 4 ; m = m + 1) begin : frequency  //(Sine[(addr2*m)&8'hFF /* finds addres of sine frequency m*/])  ) 
            sumS [l][loop] <=  (signal_read *GaborW[(addr1 +7 - l)/* shifted by l*/]*(Sine[((addr2 +8'h7F)*loop)&8'hFF /* finds addres of sine frequency m*/] - 8'd75)) + sumS[l][loop] ;    
        //end //loop is my new m
      end
    if (loop == 7'b1111111) begin
    //loop <= 5'b0;
    state <= 2'b11;  
    end
  end
  
    2'b11: begin
    //data <= signal_read;// Grab Data point
    loop <= loop + 1'b1;
     for (l = 0; l < WINDOW_WIDTH ; l = l+1) begin : time_shift2 // GaborW[(addr1 +7 - l)/* shifted by l*/]
        //for (m = 0; m < 4 ; m = m + 1) begin : frequency  //(Sine[(addr2*m)&8'hFF /* finds addres of sine frequency m*/])  ) 
            sumC [l][loop] <=  ((signal_read *GaborW[(addr1 +7 - l)/* shifted by l*/]*(Sine[((addr2+8'h1F)*loop)&8'hFF /* finds addres of sine frequency m*/] - 8'd75))) + sumC[l][loop] ;    
        //end //loop is my new m
        //I need to get block RAM down to free up LUTM
      end
    if (loop == 7'b1111111) begin
    //loop <= 5'b0;
    state <= 2'b00;  
    end
  end
endcase
   
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
   
   
   //sum[0][] <= data*GaborW[addr1 - 0/* shifted by 0*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[0][];
   //sum[1][] <= data*GaborW[addr1 - 1/* shifted by 1*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[1][];
   //sum[2][] <= data*GaborW[addr1 - 2/* shifted by 2*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[2][];
   //sum[3][] <= data*GaborW[addr1 - 3/* shifted by 3*/] * Sine[addr1*m /* finds addres of sine frequency m*/] + sum[3][]; 
  
   //Alternative option, I build an array of the values pre multiplied ahead of time GE[l,m] and multiply through that way
   // for each l and each m. This method is less flexible, and would require more space, but would take less DSP operations.
   // sum[l][m] = data * G[l][m] + sum[l][m]
   
 initial begin // sets all initial values to 0. 
 for (l = 0; l < WINDOW_WIDTH ; l = l+1) begin 
    for (m = 0; m < SIZE ; m = m+1) begin 
          sumS[l][m] = 8'b0;
          sumC[l][m] = 8'b0;
    end
  end 
  
  Sine[0] <= 8'b01001011; 
  Sine[1] <= 8'b01001100; 
  Sine[2] <= 8'b01001101; 
  Sine[3] <= 8'b01001110; 
  Sine[4] <= 8'b01001111; 
  Sine[5] <= 8'b01010001; 
  Sine[6] <= 8'b01010010; 
  Sine[7] <= 8'b01010011; 
  Sine[8] <= 8'b01010100; 
  Sine[9] <= 8'b01010101; 
  Sine[10] <= 8'b01010111; 
  Sine[11] <= 8'b01011000; 
  Sine[12] <= 8'b01011001; 
  Sine[13] <= 8'b01011010; 
  Sine[14] <= 8'b01011011; 
  Sine[15] <= 8'b01011100; 
  Sine[16] <= 8'b01011110; 
  Sine[17] <= 8'b01011111; 
  Sine[18] <= 8'b01100000; 
  Sine[19] <= 8'b01100001; 
  Sine[20] <= 8'b01100010; 
  Sine[21] <= 8'b01100011; 
  Sine[22] <= 8'b01100100; 
  Sine[23] <= 8'b01100101; 
  Sine[24] <= 8'b01100110; 
  Sine[25] <= 8'b01100111; 
  Sine[26] <= 8'b01101000; 
  Sine[27] <= 8'b01101001; 
  Sine[28] <= 8'b01101010; 
  Sine[29] <= 8'b01101011; 
  Sine[30] <= 8'b01101100; 
  Sine[31] <= 8'b01101101; 
  Sine[32] <= 8'b01101110; 
  Sine[33] <= 8'b01101111; 
  Sine[34] <= 8'b01110000; 
  Sine[35] <= 8'b01110000; 
  Sine[36] <= 8'b01110001; 
  Sine[37] <= 8'b01110010; 
  Sine[38] <= 8'b01110011; 
  Sine[39] <= 8'b01110011; 
  Sine[40] <= 8'b01110100; 
  Sine[41] <= 8'b01110101; 
  Sine[42] <= 8'b01110101; 
  Sine[43] <= 8'b01110110; 
  Sine[44] <= 8'b01110111; 
  Sine[45] <= 8'b01110111; 
  Sine[46] <= 8'b01111000; 
  Sine[47] <= 8'b01111000; 
  Sine[48] <= 8'b01111001; 
  Sine[49] <= 8'b01111001; 
  Sine[50] <= 8'b01111010; 
  Sine[51] <= 8'b01111010; 
  Sine[52] <= 8'b01111010; 
  Sine[53] <= 8'b01111011; 
  Sine[54] <= 8'b01111011; 
  Sine[55] <= 8'b01111011; 
  Sine[56] <= 8'b01111100; 
  Sine[57] <= 8'b01111100; 
  Sine[58] <= 8'b01111100; 
  Sine[59] <= 8'b01111100; 
  Sine[60] <= 8'b01111100; 
  Sine[61] <= 8'b01111100; 
  Sine[62] <= 8'b01111100; 
  Sine[63] <= 8'b01111100; 
  Sine[64] <= 8'b01111101; 
  Sine[65] <= 8'b01111100; 
  Sine[66] <= 8'b01111100; 
  Sine[67] <= 8'b01111100; 
  Sine[68] <= 8'b01111100; 
  Sine[69] <= 8'b01111100; 
  Sine[70] <= 8'b01111100; 
  Sine[71] <= 8'b01111100; 
  Sine[72] <= 8'b01111100; 
  Sine[73] <= 8'b01111011; 
  Sine[74] <= 8'b01111011; 
  Sine[75] <= 8'b01111011; 
  Sine[76] <= 8'b01111010; 
  Sine[77] <= 8'b01111010; 
  Sine[78] <= 8'b01111010; 
  Sine[79] <= 8'b01111001; 
  Sine[80] <= 8'b01111001; 
  Sine[81] <= 8'b01111000; 
  Sine[82] <= 8'b01111000; 
  Sine[83] <= 8'b01110111; 
  Sine[84] <= 8'b01110111; 
  Sine[85] <= 8'b01110110; 
  Sine[86] <= 8'b01110101; 
  Sine[87] <= 8'b01110101; 
  Sine[88] <= 8'b01110100; 
  Sine[89] <= 8'b01110011; 
  Sine[90] <= 8'b01110011; 
  Sine[91] <= 8'b01110010; 
  Sine[92] <= 8'b01110001; 
  Sine[93] <= 8'b01110000; 
  Sine[94] <= 8'b01110000; 
  Sine[95] <= 8'b01101111; 
  Sine[96] <= 8'b01101110; 
  Sine[97] <= 8'b01101101; 
  Sine[98] <= 8'b01101100; 
  Sine[99] <= 8'b01101011; 
  Sine[100] <= 8'b01101010; 
  Sine[101] <= 8'b01101001; 
  Sine[102] <= 8'b01101000; 
  Sine[103] <= 8'b01100111; 
  Sine[104] <= 8'b01100110; 
  Sine[105] <= 8'b01100101; 
  Sine[106] <= 8'b01100100; 
  Sine[107] <= 8'b01100011; 
  Sine[108] <= 8'b01100010; 
  Sine[109] <= 8'b01100001; 
  Sine[110] <= 8'b01100000; 
  Sine[111] <= 8'b01011111; 
  Sine[112] <= 8'b01011110; 
  Sine[113] <= 8'b01011100; 
  Sine[114] <= 8'b01011011; 
  Sine[115] <= 8'b01011010; 
  Sine[116] <= 8'b01011001; 
  Sine[117] <= 8'b01011000; 
  Sine[118] <= 8'b01010111; 
  Sine[119] <= 8'b01010101; 
  Sine[120] <= 8'b01010100; 
  Sine[121] <= 8'b01010011; 
  Sine[122] <= 8'b01010010; 
  Sine[123] <= 8'b01010001; 
  Sine[124] <= 8'b01001111; 
  Sine[125] <= 8'b01001110; 
  Sine[126] <= 8'b01001101; 
  Sine[127] <= 8'b01001100; 
  Sine[128] <= 8'b01001011; 
  Sine[129] <= 8'b01001001; 
  Sine[130] <= 8'b01001000; 
  Sine[131] <= 8'b01000111; 
  Sine[132] <= 8'b01000110; 
  Sine[133] <= 8'b01000100; 
  Sine[134] <= 8'b01000011; 
  Sine[135] <= 8'b01000010; 
  Sine[136] <= 8'b01000001; 
  Sine[137] <= 8'b01000000; 
  Sine[138] <= 8'b00111110; 
  Sine[139] <= 8'b00111101; 
  Sine[140] <= 8'b00111100; 
  Sine[141] <= 8'b00111011; 
  Sine[142] <= 8'b00111010; 
  Sine[143] <= 8'b00111001; 
  Sine[144] <= 8'b00110111; 
  Sine[145] <= 8'b00110110; 
  Sine[146] <= 8'b00110101; 
  Sine[147] <= 8'b00110100; 
  Sine[148] <= 8'b00110011; 
  Sine[149] <= 8'b00110010; 
  Sine[150] <= 8'b00110001; 
  Sine[151] <= 8'b00110000; 
  Sine[152] <= 8'b00101111; 
  Sine[153] <= 8'b00101110; 
  Sine[154] <= 8'b00101101; 
  Sine[155] <= 8'b00101100; 
  Sine[156] <= 8'b00101011; 
  Sine[157] <= 8'b00101010; 
  Sine[158] <= 8'b00101001; 
  Sine[159] <= 8'b00101000; 
  Sine[160] <= 8'b00100111; 
  Sine[161] <= 8'b00100110; 
  Sine[162] <= 8'b00100101; 
  Sine[163] <= 8'b00100101; 
  Sine[164] <= 8'b00100100; 
  Sine[165] <= 8'b00100011; 
  Sine[166] <= 8'b00100010; 
  Sine[167] <= 8'b00100010; 
  Sine[168] <= 8'b00100001; 
  Sine[169] <= 8'b00100000; 
  Sine[170] <= 8'b00100000; 
  Sine[171] <= 8'b00011111; 
  Sine[172] <= 8'b00011110; 
  Sine[173] <= 8'b00011110; 
  Sine[174] <= 8'b00011101; 
  Sine[175] <= 8'b00011101; 
  Sine[176] <= 8'b00011100; 
  Sine[177] <= 8'b00011100; 
  Sine[178] <= 8'b00011011; 
  Sine[179] <= 8'b00011011; 
  Sine[180] <= 8'b00011011; 
  Sine[181] <= 8'b00011010; 
  Sine[182] <= 8'b00011010; 
  Sine[183] <= 8'b00011010; 
  Sine[184] <= 8'b00011001; 
  Sine[185] <= 8'b00011001; 
  Sine[186] <= 8'b00011001; 
  Sine[187] <= 8'b00011001; 
  Sine[188] <= 8'b00011001; 
  Sine[189] <= 8'b00011001; 
  Sine[190] <= 8'b00011001; 
  Sine[191] <= 8'b00011001; 
  Sine[192] <= 8'b00011001; 
  Sine[193] <= 8'b00011001; 
  Sine[194] <= 8'b00011001; 
  Sine[195] <= 8'b00011001; 
  Sine[196] <= 8'b00011001; 
  Sine[197] <= 8'b00011001; 
  Sine[198] <= 8'b00011001; 
  Sine[199] <= 8'b00011001; 
  Sine[200] <= 8'b00011001; 
  Sine[201] <= 8'b00011010; 
  Sine[202] <= 8'b00011010; 
  Sine[203] <= 8'b00011010; 
  Sine[204] <= 8'b00011011; 
  Sine[205] <= 8'b00011011; 
  Sine[206] <= 8'b00011011; 
  Sine[207] <= 8'b00011100; 
  Sine[208] <= 8'b00011100; 
  Sine[209] <= 8'b00011101; 
  Sine[210] <= 8'b00011101; 
  Sine[211] <= 8'b00011110; 
  Sine[212] <= 8'b00011110; 
  Sine[213] <= 8'b00011111; 
  Sine[214] <= 8'b00100000; 
  Sine[215] <= 8'b00100000; 
  Sine[216] <= 8'b00100001; 
  Sine[217] <= 8'b00100010; 
  Sine[218] <= 8'b00100010; 
  Sine[219] <= 8'b00100011; 
  Sine[220] <= 8'b00100100; 
  Sine[221] <= 8'b00100101; 
  Sine[222] <= 8'b00100101; 
  Sine[223] <= 8'b00100110; 
  Sine[224] <= 8'b00100111; 
  Sine[225] <= 8'b00101000; 
  Sine[226] <= 8'b00101001; 
  Sine[227] <= 8'b00101010; 
  Sine[228] <= 8'b00101011; 
  Sine[229] <= 8'b00101100; 
  Sine[230] <= 8'b00101101; 
  Sine[231] <= 8'b00101110; 
  Sine[232] <= 8'b00101111; 
  Sine[233] <= 8'b00110000; 
  Sine[234] <= 8'b00110001; 
  Sine[235] <= 8'b00110010; 
  Sine[236] <= 8'b00110011; 
  Sine[237] <= 8'b00110100; 
  Sine[238] <= 8'b00110101; 
  Sine[239] <= 8'b00110110; 
  Sine[240] <= 8'b00110111; 
  Sine[241] <= 8'b00111001; 
  Sine[242] <= 8'b00111010; 
  Sine[243] <= 8'b00111011; 
  Sine[244] <= 8'b00111100; 
  Sine[245] <= 8'b00111101; 
  Sine[246] <= 8'b00111110; 
  Sine[247] <= 8'b01000000; 
  Sine[248] <= 8'b01000001; 
  Sine[249] <= 8'b01000010; 
  Sine[250] <= 8'b01000011; 
  Sine[251] <= 8'b01000100; 
  Sine[252] <= 8'b01000110; 
  Sine[253] <= 8'b01000111; 
  Sine[254] <= 8'b01001000; 
  Sine[255] <= 8'b01001001;  
  
  
  GaborW[0] <= 8'b00000100; //center value first to reduce number of adders.
  GaborW[1] <= 8'b00001010;
  GaborW[2] <= 8'b00010100; 
  GaborW[3] <= 8'b00100100;
  GaborW[4] <= 8'b00111000; 
  GaborW[5] <= 8'b01001100; 
  GaborW[6] <= 8'b01011100;
  GaborW[7] <= 8'b01100100;  
  GaborW[8] <= 8'b01011100; 
  GaborW[9] <= 8'b01001100; 
  GaborW[10] <= 8'b00111000; 
  GaborW[11] <= 8'b00100100; 
  GaborW[12] <= 8'b00010100;  
  GaborW[13] <= 8'b00001010;
  GaborW[14] <= 8'b00000100;
 end  
  

  
  
endmodule

