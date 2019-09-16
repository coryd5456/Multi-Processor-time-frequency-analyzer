module SFTransform_4 (
    input clk,
    input busy,
    input wire [7:0] signal_read,
    output reg [23:0] result
  );
//This version uses too much LUTM for RAM and no Block RAM.   
localparam NBITS = 12;
localparam SIZE = 128;//128
localparam WINDOW_WIDTH = 16;//center is at 7. With 7 values on each side. 
//reg [7:0]result_q;
localparam SIZE_C = 6; // reg size -1
localparam UPDATE = 7'b1111111;
localparam INIT = 7'b0;
//assign result = result_q;
//// I think I might need to just set up the whole transform in here to make things fast. //// 
//// Just have it output as a module. ////
reg [5:0] Sine [0:255];
reg [4:0] GaborW [0:WINDOW_WIDTH - 1];
//reg [4:0] GaborW [0:7];



reg [SIZE_C:0] counter = INIT;//7'b0  <========= update here
reg [7:0] addr2 = 8'b0;
reg [3:0] addr1 = 4'b0;
reg [7:0] data = 8'b0;
//assign data = signal_read;// could be the cause of LUTs
integer l;

reg [NBITS -1:0] sumS [0:WINDOW_WIDTH - 1];
reg [NBITS -1:0] sumC [0:WINDOW_WIDTH - 1];
reg [18:0] sumSS [0:WINDOW_WIDTH - 1];
reg [18:0] sumCC [0:WINDOW_WIDTH - 1];
reg [2:0] state = 3'b000;
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
/////////////////////////////////BLOCK RAM////////////////////////////////////////////  
  

reg [NBITS - 1:0]i_dataSW [0:WINDOW_WIDTH-1];
wire [NBITS - 1:0]o_dataSR [0:WINDOW_WIDTH-1];
wire [NBITS - 1:0]SSumResult [0:WINDOW_WIDTH-1];


reg [NBITS - 1:0]i_dataCW [0:WINDOW_WIDTH-1];
wire [NBITS - 1:0]o_dataCR [0:WINDOW_WIDTH-1];
wire [NBITS - 1:0]CSumResult [0:WINDOW_WIDTH-1];

reg i_write = 1'b0;

 

genvar i;
generate
  for (i = 0; i < WINDOW_WIDTH; i = i + 1  ) begin : SSumSRAM 
    // if unconnected message pops up, then these sizes aren't right
    SumSRAM_6 #(7,NBITS,SIZE)S_SRAM(
      .clk(clk),
      .clkCounter(busy),
      .i_addrC(counter),
      .i_addr(loop),
      .i_write(i_write),// 0 = write, 1 = read
      .i_data(i_dataSW[i]),
      .o_data(o_dataSR[i]),
      .o_dataCounter(SSumResult[i])
    );
  end
  for (i = 0; i < WINDOW_WIDTH; i = i + 1  ) begin : CSumSRAM
    
    SumSRAM_6 #(7,NBITS,SIZE) C_SRAM(
      .clk(clk),
      .clkCounter(busy),
      .i_addrC(counter),
      .i_addr(loop),
      .i_write(i_write),// 0 = write, 1 = read
      .i_data(i_dataCW[i]),
      .o_data(o_dataCR[i]),
      .o_dataCounter(CSumResult[i])
    );
  end
endgenerate


//////////////////////////////////////////////////////////////////////////////////////  
always @(negedge busy) begin // neg edge of busy is that we finished transmitting the last signal. 

    counter <= counter + 1'b1;  // Counter keeps track of which frequency value I am transmitting. 

                                    // on bit 128 I want to start the state machine. //7'b1111111 <========= update here
   if (counter == UPDATE) begin //This is to make sure that the Gabor transform is properly calculated with each new instant of time. 
      addr2 <= addr2 + 1'b1;        //Set counter for the calculation to shift
    //  if (addr1 == 4'b1111) begin   // addr2 keeps track of time instance. 256 of these
   //     addr1 <= 4'b0;              // addr1 keeps track of window instance. 15 of these
  //    end else begin                //
      addr1 <= addr1 + 1'b1;        // Sets which column of data is to be erased and transmited. 
  //    end                           //
   end                              //
  ////////Transmit Code/////////
  //Third State: Transmit data for 128 Bytes of data

  result <= ((SSumResult[addr1-4'b0111]*SSumResult[addr1-4'b0111] + CSumResult[addr1-4'b0111]*CSumResult[addr1-4'b0111])); 

  // always at negedge of busy I want to load in the next transmit bit.
  // ^^^^^^^^^^^^ this line is written correctly for grabbing the address of sum and the 8 bits of that word in that address. 
  //<== number of sites problem is left to resolve
  //So, it turns out that the number of sites is how many LUTs have the desired built in slice. 
  // I really need to tell this to go into a larger size block. 
end

///////////////////////////Code for calculation/////////////////////////

always @(posedge clk) begin

  case (state)
   //ZERO STATE: Set idle waitig for transmit to finish. 
   3'b000: begin
            i_write <= 1'b0; // 0 means read
            if (counter == UPDATE && busy == 1'b0) begin //7'b1111111 <========= update here
              state <= 3'b001;
            end
         end
  //FIRST State: Erase previous transmitted row
  3'b001: begin
    data <= signal_read;
    i_write <= 1'b1; // 1 means write
    loop <= loop + 1'b1;
    //for (m = 0; m < 4; m = m +1 ) begin 

       i_dataSW[addr1-4'b0111] <= 12'b0; //32'b0 
       i_dataCW[addr1-4'b0111] <= 12'b0; //32'b0
    //end
    if (loop == 7'b1111111) begin
	 loop <= 7'b0;
    state <= 3'b010;
    end
  end

  //Second State: Get data point and calculate
  
  3'b010: begin
    //data <= signal_read;// Grab Data point
    
    
     for (l = 0; l < 8 ; l = l+1) begin : time_shift // GaborW[(addr1 +7 - l)/* shifted by l*/]
        //for (m = 0; m < 4 ; m = m + 1) begin : frequency  //(Sine[(addr2*m)&8'hFF /* finds addres of sine frequency m*/])  ) 
            sumSS [l] <=  (data *GaborW[(addr1 +7 -l)&4'hF/* shifted by l*/]*(Sine[((addr2 *loop)+ 8'h7F)&8'hFF /* finds addres of sine frequency m*/] ));    
            sumCC [l] <=  (data *GaborW[(addr1 +7 -l)&4'hF/* shifted by l*/]*(Sine[((addr2*loop )+ 8'h1F)&8'hFF/* finds addres of sine frequency m*/] ));
         //end //loop is my new m
      end
    state <= 3'b011;  
  end
  
    
  3'b011: begin
    //data <= signal_read;// Grab Data point
    i_write <= 1'b0;
 
     for (l = 8; l < WINDOW_WIDTH ; l = l+1) begin : time_shift7 // GaborW[(addr1 +7 - l)/* shifted by l*/]
        //for (m = 0; m < 4 ; m = m + 1) begin : frequency  //(Sine[(addr2*m)&8'hFF /* finds addres of sine frequency m*/])  ) 
            sumSS [l] <=  (data *GaborW[(addr1 +7 -l)&4'hF/* shifted by l*/]*(Sine[((addr2 *loop)+ 8'h7F)&8'hFF /* finds addres of sine frequency m*/] ));    
            sumCC [l] <=  (data *GaborW[(addr1 +7 -l)&4'hF/* shifted by l*/]*(Sine[((addr2*loop )+ 8'h1F)&8'hFF /* finds addres of sine frequency m*/] ));
         //end //loop is my new m
      end
    state <= 3'b100;  
  end
  
  
  3'b100: begin
    //data <= signal_read;// Grab Data point
    i_write <= 1'b1; // 0 means read
 
     for (l = 0; l < WINDOW_WIDTH ; l = l+1) begin : time_shift1 // GaborW[(addr1 +7 - l)/* shifted by l*/]
        //for (m = 0; m < 4 ; m = m + 1) begin : frequency  //(Sine[(addr2*m)&8'hFF /* finds addres of sine frequency m*/])  ) 
            sumS [l] <=  sumSS[l][18:12] + (o_dataSR[l]<<1) ;    
            sumC [l] <=  sumCC[l][18:12] + (o_dataCR[l]<<1) ;
            
            //sumS [l] <=  1'b1 + o_dataSR[l] ;    
            //sumC [l] <=  1'b1 + o_dataCR[l] ;
         
         //end //loop is my new m
      end
    state <= 3'b101;  
  end
  
    3'b101: begin
	 loop <= loop + 1'b1;
    //data <= signal_read;// Grab Data point
    i_write <= 1'b1; // 1 means write
     for (l = 0; l < WINDOW_WIDTH ; l = l+1) begin : time_shift2 // GaborW[(addr1 +7 - l)/* shifted by l*/]
          i_dataSW[l] <= sumS[l]>>1;
          i_dataCW[l] <= sumC[l]>>1;
      end
    if (loop == 7'b1111111) begin
    //loop <= 5'b0;
      state <= 3'b110;  
		loop <= 7'b0;
    end else begin
      state <= 3'b010;
    end
  end
	3'b110: begin //idle state #2
		if(counter == 7'b0) begin
			state <= 3'b000;
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
    //for (m = 0; m < SIZE ; m = m+1) begin 
          sumS[l] <= 12'b0;
          sumC[l] <= 12'b0;
			 sumSS[l] <= 19'b0;
			 sumCC[l] <= 19'b0;
			 i_dataSW[l] <= 12'b0;
			 i_dataCW[l] <= 12'b0;
    //end
  end 
  
  Sine[0] <= 6'b000000; 
  Sine[1] <= 6'b000000; 
  Sine[2] <= 6'b000001; 
  Sine[3] <= 6'b000010; 
  Sine[4] <= 6'b000011; 
  Sine[5] <= 6'b000011; 
  Sine[6] <= 6'b000100; 
  Sine[7] <= 6'b000101; 
  Sine[8] <= 6'b000110; 
  Sine[9] <= 6'b000110; 
  Sine[10] <= 6'b000111; 
  Sine[11] <= 6'b001000; 
  Sine[12] <= 6'b001000; 
  Sine[13] <= 6'b001001; 
  Sine[14] <= 6'b001010; 
  Sine[15] <= 6'b001011; 
  Sine[16] <= 6'b001011; 
  Sine[17] <= 6'b001100; 
  Sine[18] <= 6'b001101; 
  Sine[19] <= 6'b001101; 
  Sine[20] <= 6'b001110; 
  Sine[21] <= 6'b001111; 
  Sine[22] <= 6'b001111; 
  Sine[23] <= 6'b010000; 
  Sine[24] <= 6'b010001; 
  Sine[25] <= 6'b010001; 
  Sine[26] <= 6'b010010; 
  Sine[27] <= 6'b010011; 
  Sine[28] <= 6'b010011; 
  Sine[29] <= 6'b010100; 
  Sine[30] <= 6'b010100; 
  Sine[31] <= 6'b010101; 
  Sine[32] <= 6'b010101; 
  Sine[33] <= 6'b010110; 
  Sine[34] <= 6'b010110; 
  Sine[35] <= 6'b010111; 
  Sine[36] <= 6'b010111; 
  Sine[37] <= 6'b011000; 
  Sine[38] <= 6'b011000; 
  Sine[39] <= 6'b011001; 
  Sine[40] <= 6'b011001; 
  Sine[41] <= 6'b011010; 
  Sine[42] <= 6'b011010; 
  Sine[43] <= 6'b011010; 
  Sine[44] <= 6'b011011; 
  Sine[45] <= 6'b011011; 
  Sine[46] <= 6'b011100; 
  Sine[47] <= 6'b011100; 
  Sine[48] <= 6'b011100; 
  Sine[49] <= 6'b011100; 
  Sine[50] <= 6'b011101; 
  Sine[51] <= 6'b011101; 
  Sine[52] <= 6'b011101; 
  Sine[53] <= 6'b011101; 
  Sine[54] <= 6'b011110; 
  Sine[55] <= 6'b011110; 
  Sine[56] <= 6'b011110; 
  Sine[57] <= 6'b011110; 
  Sine[58] <= 6'b011110; 
  Sine[59] <= 6'b011110; 
  Sine[60] <= 6'b011110; 
  Sine[61] <= 6'b011110; 
  Sine[62] <= 6'b011110; 
  Sine[63] <= 6'b011110; 
  Sine[64] <= 6'b011111; 
  Sine[65] <= 6'b011110; 
  Sine[66] <= 6'b011110; 
  Sine[67] <= 6'b011110; 
  Sine[68] <= 6'b011110; 
  Sine[69] <= 6'b011110; 
  Sine[70] <= 6'b011110; 
  Sine[71] <= 6'b011110; 
  Sine[72] <= 6'b011110; 
  Sine[73] <= 6'b011110; 
  Sine[74] <= 6'b011110; 
  Sine[75] <= 6'b011101; 
  Sine[76] <= 6'b011101; 
  Sine[77] <= 6'b011101; 
  Sine[78] <= 6'b011101; 
  Sine[79] <= 6'b011100; 
  Sine[80] <= 6'b011100; 
  Sine[81] <= 6'b011100; 
  Sine[82] <= 6'b011100; 
  Sine[83] <= 6'b011011; 
  Sine[84] <= 6'b011011; 
  Sine[85] <= 6'b011010; 
  Sine[86] <= 6'b011010; 
  Sine[87] <= 6'b011010; 
  Sine[88] <= 6'b011001; 
  Sine[89] <= 6'b011001; 
  Sine[90] <= 6'b011000; 
  Sine[91] <= 6'b011000; 
  Sine[92] <= 6'b010111; 
  Sine[93] <= 6'b010111; 
  Sine[94] <= 6'b010110; 
  Sine[95] <= 6'b010110; 
  Sine[96] <= 6'b010101; 
  Sine[97] <= 6'b010101; 
  Sine[98] <= 6'b010100; 
  Sine[99] <= 6'b010100; 
  Sine[100] <= 6'b010011; 
  Sine[101] <= 6'b010011; 
  Sine[102] <= 6'b010010; 
  Sine[103] <= 6'b010001; 
  Sine[104] <= 6'b010001; 
  Sine[105] <= 6'b010000; 
  Sine[106] <= 6'b001111; 
  Sine[107] <= 6'b001111; 
  Sine[108] <= 6'b001110; 
  Sine[109] <= 6'b001101; 
  Sine[110] <= 6'b001101; 
  Sine[111] <= 6'b001100; 
  Sine[112] <= 6'b001011; 
  Sine[113] <= 6'b001011; 
  Sine[114] <= 6'b001010; 
  Sine[115] <= 6'b001001; 
  Sine[116] <= 6'b001000; 
  Sine[117] <= 6'b001000; 
  Sine[118] <= 6'b000111; 
  Sine[119] <= 6'b000110; 
  Sine[120] <= 6'b000110; 
  Sine[121] <= 6'b000101; 
  Sine[122] <= 6'b000100; 
  Sine[123] <= 6'b000011; 
  Sine[124] <= 6'b000011; 
  Sine[125] <= 6'b000010; 
  Sine[126] <= 6'b000001; 
  Sine[127] <= 6'b000000; 
  Sine[128] <= -1*6'b000000; 
  Sine[129] <= -1*6'b000000; 
  Sine[130] <= -1*6'b000001; 
  Sine[131] <= -1*6'b000010; 
  Sine[132] <= -1*6'b000011; 
  Sine[133] <= -1*6'b000011; 
  Sine[134] <= -1*6'b000100; 
  Sine[135] <= -1*6'b000101; 
  Sine[136] <= -1*6'b000110; 
  Sine[137] <= -1*6'b000110; 
  Sine[138] <= -1*6'b000111; 
  Sine[139] <= -1*6'b001000; 
  Sine[140] <= -1*6'b001000; 
  Sine[141] <= -1*6'b001001; 
  Sine[142] <= -1*6'b001010; 
  Sine[143] <= -1*6'b001011; 
  Sine[144] <= -1*6'b001011; 
  Sine[145] <= -1*6'b001100; 
  Sine[146] <= -1*6'b001101; 
  Sine[147] <= -1*6'b001101; 
  Sine[148] <= -1*6'b001110; 
  Sine[149] <= -1*6'b001111; 
  Sine[150] <= -1*6'b001111; 
  Sine[151] <= -1*6'b010000; 
  Sine[152] <= -1*6'b010001; 
  Sine[153] <= -1*6'b010001; 
  Sine[154] <= -1*6'b010010; 
  Sine[155] <= -1*6'b010011; 
  Sine[156] <= -1*6'b010011; 
  Sine[157] <= -1*6'b010100; 
  Sine[158] <= -1*6'b010100; 
  Sine[159] <= -1*6'b010101; 
  Sine[160] <= -1*6'b010101; 
  Sine[161] <= -1*6'b010110; 
  Sine[162] <= -1*6'b010110; 
  Sine[163] <= -1*6'b010111; 
  Sine[164] <= -1*6'b010111; 
  Sine[165] <= -1*6'b011000; 
  Sine[166] <= -1*6'b011000; 
  Sine[167] <= -1*6'b011001; 
  Sine[168] <= -1*6'b011001; 
  Sine[169] <= -1*6'b011010; 
  Sine[170] <= -1*6'b011010; 
  Sine[171] <= -1*6'b011010; 
  Sine[172] <= -1*6'b011011; 
  Sine[173] <= -1*6'b011011; 
  Sine[174] <= -1*6'b011100; 
  Sine[175] <= -1*6'b011100; 
  Sine[176] <= -1*6'b011100; 
  Sine[177] <= -1*6'b011100; 
  Sine[178] <= -1*6'b011101; 
  Sine[179] <= -1*6'b011101; 
  Sine[180] <= -1*6'b011101; 
  Sine[181] <= -1*6'b011101; 
  Sine[182] <= -1*6'b011110; 
  Sine[183] <= -1*6'b011110; 
  Sine[184] <= -1*6'b011110; 
  Sine[185] <= -1*6'b011110; 
  Sine[186] <= -1*6'b011110; 
  Sine[187] <= -1*6'b011110; 
  Sine[188] <= -1*6'b011110; 
  Sine[189] <= -1*6'b011110; 
  Sine[190] <= -1*6'b011110; 
  Sine[191] <= -1*6'b011110; 
  Sine[192] <= -1*6'b011111; 
  Sine[193] <= -1*6'b011110; 
  Sine[194] <= -1*6'b011110; 
  Sine[195] <= -1*6'b011110; 
  Sine[196] <= -1*6'b011110; 
  Sine[197] <= -1*6'b011110; 
  Sine[198] <= -1*6'b011110; 
  Sine[199] <= -1*6'b011110; 
  Sine[200] <= -1*6'b011110; 
  Sine[201] <= -1*6'b011110; 
  Sine[202] <= -1*6'b011110; 
  Sine[203] <= -1*6'b011101; 
  Sine[204] <= -1*6'b011101; 
  Sine[205] <= -1*6'b011101; 
  Sine[206] <= -1*6'b011101; 
  Sine[207] <= -1*6'b011100; 
  Sine[208] <= -1*6'b011100; 
  Sine[209] <= -1*6'b011100; 
  Sine[210] <= -1*6'b011100; 
  Sine[211] <= -1*6'b011011; 
  Sine[212] <= -1*6'b011011; 
  Sine[213] <= -1*6'b011010; 
  Sine[214] <= -1*6'b011010; 
  Sine[215] <= -1*6'b011010; 
  Sine[216] <= -1*6'b011001; 
  Sine[217] <= -1*6'b011001; 
  Sine[218] <= -1*6'b011000; 
  Sine[219] <= -1*6'b011000; 
  Sine[220] <= -1*6'b010111; 
  Sine[221] <= -1*6'b010111; 
  Sine[222] <= -1*6'b010110; 
  Sine[223] <= -1*6'b010110; 
  Sine[224] <= -1*6'b010101; 
  Sine[225] <= -1*6'b010101; 
  Sine[226] <= -1*6'b010100; 
  Sine[227] <= -1*6'b010100; 
  Sine[228] <= -1*6'b010011; 
  Sine[229] <= -1*6'b010011; 
  Sine[230] <= -1*6'b010010; 
  Sine[231] <= -1*6'b010001; 
  Sine[232] <= -1*6'b010001; 
  Sine[233] <= -1*6'b010000; 
  Sine[234] <= -1*6'b001111; 
  Sine[235] <= -1*6'b001111; 
  Sine[236] <= -1*6'b001110; 
  Sine[237] <= -1*6'b001101; 
  Sine[238] <= -1*6'b001101; 
  Sine[239] <= -1*6'b001100; 
  Sine[240] <= -1*6'b001011; 
  Sine[241] <= -1*6'b001011; 
  Sine[242] <= -1*6'b001010; 
  Sine[243] <= -1*6'b001001; 
  Sine[244] <= -1*6'b001000; 
  Sine[245] <= -1*6'b001000; 
  Sine[246] <= -1*6'b000111; 
  Sine[247] <= -1*6'b000110; 
  Sine[248] <= -1*6'b000110; 
  Sine[249] <= -1*6'b000101; 
  Sine[250] <= -1*6'b000100; 
  Sine[251] <= -1*6'b000011; 
  Sine[252] <= -1*6'b000011; 
  Sine[253] <= -1*6'b000010; 
  Sine[254] <= -1*6'b000001; 
  Sine[255] <= -1*6'b000000;
  
  
  GaborW[0] <= 5'b00001; //center value first to reduce number of adders.
  GaborW[1] <= 5'b00010;
  GaborW[2] <= 5'b00101; 
  GaborW[3] <= 5'b01001;
  GaborW[4] <= 5'b01110; 
  GaborW[5] <= 5'b10011; 
  GaborW[6] <= 5'b10111;
  GaborW[7] <= 5'b11001;//symetric, so I might be able to use half as many.   
  GaborW[8] <= 5'b11001;
  GaborW[9] <= 5'b10111; 
  GaborW[10] <= 5'b10011; 
  GaborW[11] <= 5'b01110; 
  GaborW[12] <= 5'b01001; 
  GaborW[13] <= 5'b00101;  
  GaborW[14] <= 5'b00010;
  GaborW[15] <= 5'b00001;
 end  
  

  
  
endmodule

