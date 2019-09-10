module serial_TX #(
        parameter CLK_PER_BIT = 5208
    )(
        input clk,
        input rst,
        output tx,
        input block,
        output busy,
        input [7:0] data,
        input new_data
    );

    // clog2 is 'ceiling of log base 2' which gives you the number of bits needed to store a value
    parameter CTR_SIZE = $clog2(CLK_PER_BIT);

    localparam STATE_SIZE = 2;
    localparam IDLE = 2'd0, //Each of these is a named state.
    START_BIT = 2'd1,//state 1
    DATA = 2'd2,//state 2
    STOP_BIT = 2'd3; // state 3

    reg [CTR_SIZE-1:0] ctr_d, ctr_q;
    reg [2:0] bit_ctr_d, bit_ctr_q;
    reg [7:0] data_d, data_q;
    reg [STATE_SIZE-1:0] state_d, state_q = IDLE;//state selection register (or special function register)
    reg tx_d, tx_q; //register for data to be put into for going out the tx wire
    reg busy_d, busy_q; //register for busy signal
    reg block_d, block_q; //input register for input from AVR

    assign tx = tx_q; //assigns tx_q register to tx output wire
    assign busy = busy_q; //assigns busy_q register as output to the busy wire.
    
    always @(*) begin //updates inputs?
        block_d = block;
        ctr_d = ctr_q;
        bit_ctr_d = bit_ctr_q;
        data_d = data_q;
        state_d = state_q;
        busy_d = busy_q;

        case (state_q)
            IDLE: begin
                if (block_q) begin
                    busy_d = 1'b1; //Line is busy High = do not send
                    tx_d = 1'b1; //idle state is tx line = HIGH for not sending (stay idle)
                end else begin
                    busy_d = 1'b1; // Low = no longer busy
                    tx_d = 1'b1; //
                    bit_ctr_d = 3'b0;
                    ctr_d = 1'b0;
                    if (new_data) begin // new data line = 1 when high on AVR
                        data_d = data; //loads new data in from data input to data_d register
                        state_d = START_BIT;  //move state to START_BIT
                        busy_d = 1'b1; // now sending
                    end
                end
            end
            START_BIT: begin
                busy_d = 1'b1; //now sending
                ctr_d = ctr_q + 1'b1; //
                tx_d = 1'b0; // sends a single 0 down Tx line
                if (ctr_q == CLK_PER_BIT - 1) begin
                    ctr_d = 1'b0; 
                    state_d = DATA; // move to data state
                end
            end
            DATA: begin //Note: this is the section of code where the byte is being sent. 
                busy_d = 1'b1; //still sending
                tx_d = data_q[bit_ctr_q];//sends the [bit_ctr_q] bit down the tx line
                ctr_d = ctr_q + 1'b1; // incriments to the next data bit
                if (ctr_q == CLK_PER_BIT - 1) begin
                    ctr_d = 1'b0;
                    bit_ctr_d = bit_ctr_q + 1'b1;
                    if (bit_ctr_q == 7) begin
                        state_d = STOP_BIT; // move to STOP_BIT state
                    end
                end
            end
            STOP_BIT: begin
                busy_d = 1'b0; // still sending
                tx_d = 1'b1; // sends stop bit down data line
                ctr_d = ctr_q + 1'b1; // increases ctr_d 
                if (ctr_q == CLK_PER_BIT - 1) begin
                    state_d = IDLE; // Go back to idle state
                end
            end
            default: begin
                state_d = IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            state_q <= IDLE;
            tx_q <= 1'b1;
        end else begin
            state_q <= state_d; // selects state of what tx_d need to be. 
            tx_q <= tx_d; // transmits based on state
        end
        // These are all assigned based on the state machine. 
        block_q <= block_d;
        data_q <= data_d;
        bit_ctr_q <= bit_ctr_d;
        ctr_q <= ctr_d;
        busy_q <= busy_d;
    end

endmodule