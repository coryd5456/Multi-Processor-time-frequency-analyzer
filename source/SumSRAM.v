module SumSRAM #(parameter ADDR_WIDTH = 7,DATA_WIDTH = 8, DEPTH = 128)( 
  input wire clk,
  input wire clkCounter,
  input wire [ADDR_WIDTH -1:0] i_addrC,
  input wire [ADDR_WIDTH -1:0] i_addr,
  input wire i_write,
  input wire [DATA_WIDTH - 1:0] i_data,
  output reg [DATA_WIDTH - 1: 0] o_data,
  output reg [DATA_WIDTH - 1: 0] o_dataCounter

);
reg [DATA_WIDTH -1:0] SumSRAM [0: DEPTH -1];

  always @(posedge clk) begin
    if (i_write) begin
      SumSRAM[i_addr] <= i_data;
    end 
    else begin
      o_data <= SumSRAM[i_addr];
    end
  end
  
   always @(negedge clkCounter) begin
      o_dataCounter <= SumSRAM[i_addrC];
  end
  
integer k; 
initial begin
  for (k = 0; k < DEPTH; k = k + 1) begin
    SumSRAM[k] <= 0;
  end
end  
endmodule
