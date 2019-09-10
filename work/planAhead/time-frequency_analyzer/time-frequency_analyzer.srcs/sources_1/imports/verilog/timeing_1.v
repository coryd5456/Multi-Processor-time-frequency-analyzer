module timing_1 (
    input clk,  // clock
    output clk_out
  );
//25_000_000
  reg [4:0] counter = 5'b0;//register to keep track of counting index
  reg clk_out_q = 1'b0;
  assign clk_out = clk_out_q;
  
  /* Sequential Logic */
  always @(posedge clk) begin
    
    if (counter == 5'd25) begin // underscores are ignored
      counter <= 5'b0;
      clk_out_q <= ~clk_out_q;
    end else begin 
      counter <= counter + 1'b1;
    end
  end
  
endmodule