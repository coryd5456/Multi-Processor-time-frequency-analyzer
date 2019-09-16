module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    
    output TX,
    output check
    //output [7:0] DAC
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;


//////////////test/////////////
/*
reg [7:0] a = 8'b11101011;
reg [7:0] b = 8'b11101011;
wire [15:0] c;
assign c = a*b;*/
//assign led = sample[9:2];
assign led = Signal_out;

//////////////////////////////



wire block = 1'b0;
wire busy;
wire [7:0] data;
wire [7:0] Signal_out;
wire new_data = 1'b1;
wire Q;

assign check = busy;
timing one (
  .clk(clk),
  .clk_out(Q)
);
//assign Q = busy;
//temporary
//wire [7:0] Sig;
// Create sqrt block that shifts value of 65 bit output after sqrt result 

Signal_ROM sine (
  .clk(busy),
  .Signal_out(Signal_out)
);


/*
always @(negedge busy) begin
data <= ~data;
end
*/

wire [23:0] checkSums;
assign data = checkSums[22:15];
serial_TX  #(250) txBlock (
         .clk(clk),
         .rst(rst),
         .tx(TX),
         .block(block),
         .busy(busy),
         .data(data),
         .new_data(new_data)
    );
////////////transform code///////////
SFTransform transform (
    .clk(Q),
    .busy(busy),
    .signal_read(Signal_out),
    .result(checkSums)
  );

//////////Matrix///////
/*
wire [7:0] M [3:0][3:0];

assign M[0][0] = 8'd0; assign M[0][1] = 8'd1; assign M[0][2] = 8'd2; assign M[0][3] = 8'd3;
assign M[1][0] = 8'd4; assign M[1][1] = 8'd5; assign M[1][2] = 8'd6; assign M[1][3] = 8'd7;
assign M[2][0] = 8'd8; assign M[2][1] = 8'd9; assign M[2][2] = 8'd10; assign M[2][3] = 8'd11;
assign M[3][0] = 8'd12; assign M[3][1] = 8'd13; assign M[3][2] = 8'd14; assign M[3][3] = 8'd15; 


////Data/////
//wire [7:0] test [3:0];

//assign test[0] = 8'b00001111; assign test[1] = 8'b00001111; assign test[2] = 8'b00001111; assign test[3] = 8'b00001111;

//////////////Matrix Multiply with Data////////
reg [15:0] result [3:0];
reg [7:0] Buffer [3:0];
reg [1:0] addr = 2'b00;
reg [7:0] data_q;
reg State = 0;
assign data = data_q;

always @(negedge busy) begin
addr = addr + 1'b1;
//Signal <= test[addr];

if (addr == 2'b00) begin
      result[0] = 16'b0;
      result[1] = 16'b0;
      result[2] = 16'b0;
      result[3] = 16'b0;

end


result[0] = M[0][addr]*Signal + result[0];
result[1] = M[1][addr]*Signal + result[1];
result[2] = M[2][addr]*Signal + result[2];
result[3] = M[3][addr]*Signal + result[3];


//////// On address = 4 I need to reset everything load in all the results to a buffer to be sent out on tx line//////I need some sinquencial nature here.

if (addr == 2'b11) begin
Buffer[0] <= result[0];
Buffer[1] <= result[1];
Buffer[2] <= result[2];
Buffer[3] <= result[3];
end

data_q <= Buffer[addr];

end

// For my Gabor transform, I am going to need a generate for loop. 
*/
/*
localparam WINDOW_WIDTH = 15;
localparam SIZE = 128;
reg [7:0]i_dataSW [0:WINDOW_WIDTH-1];
wire [7:0]o_dataSR [0:WINDOW_WIDTH-1];


reg [7:0]i_dataCW [0:WINDOW_WIDTH-1];
wire [7:0]o_dataCR [0:WINDOW_WIDTH-1];

reg [6:0]loop = 7'b0;
reg i_write = 1'b0;
reg [3:0] s = 4'b0; 
reg [7:0]DAC_q;
reg [7:0]led_q;

integer j;
always @(posedge Q) begin
  i_write <= i_write + 1'b1;
  
  if (i_write == 1'b0) begin
  
  loop <= loop + 1'b1;
  for (j = 0; j < WINDOW_WIDTH; j = j+1) begin
    i_dataS[j] <= 8'hF3 + j;
    i_dataC[j] <= 8'h3F + j;
  end 
  
  end else begin
  if (s == 4'b1110) begin
    s <= 4'b0;
  end else begin   
  s <= s + 1'b1;
  end
    DAC_q <= o_dataC[s];
    led_q <= o_dataS[s];
  end
  
end

assign led = led_q;
assign DAC = DAC_q;
 

genvar i;
generate
  for (i = 0; i < WINDOW_WIDTH; i = i + 1  ) begin : CSumSRAM 
    
    SumSRAM #(7,32,SIZE)S_SRAM(
      .clk(Q),
      .i_addr(loop),
      .i_write(i_write),// 0 = write, 1 = read
      .i_data(i_dataS[i]),
      .o_data(o_dataS[i])
    );
  end
  for (i = 0; i < WINDOW_WIDTH; i = i + 1  ) begin : SSumSRAM
    
    SumSRAM #(7,32,SIZE) C_SRAM(
      .clk(Q),
      .i_addr(loop),
      .i_write(i_write),// 0 = write, 1 = read
      .i_data(i_dataC[i]),
      .o_data(o_dataC[i])
    );
  end
endgenerate
*/



//////////////////////AVR Interface//////////////////

  wire [3:0] channel = 4'b0;
  wire new_sample;
  wire [9:0] sample;
  wire [3:0] sample_channel;
  
  avr_interface avr_interface (
    .clk(clk),
    .rst(rst),
    .cclk(cclk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_ss(spi_ss),
    .spi_channel(spi_channel),
    .tx(avr_rx),
    .rx(avr_tx),
    .channel(channel),
    .new_sample(new_sample),
    .sample(sample),
    .sample_channel(sample_channel),
    .tx_data(8'h00),
    .new_tx_data(1'b0),
    .tx_busy(),
    .tx_block(avr_rx_busy),
    .rx_data(),
    .new_rx_data()
  );



endmodule