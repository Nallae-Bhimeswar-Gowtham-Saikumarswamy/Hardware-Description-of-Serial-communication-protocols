`timescale 1ns / 1ps 

module top(
    input clk,
    input start,
    input [7:0] txin,
    output reg tx, 
    input rx,
    output [7:0] rxout,
    output rxdone, txdone
    );
    
 parameter CLK_FREQ = 100_000;    
 parameter BAUD_RATE = 9600;      
 
 parameter BAUD_TICK_COUNT = CLK_FREQ / BAUD_RATE;
 
 reg bit_done = 0;
 integer count = 0;
 parameter IDLE = 0, SEND = 1, CHECK = 2;
 reg [1:0] state = IDLE;
 

 always @(posedge clk)
 begin
    if (state == IDLE)
    begin 
        count <= 0;
    end
    else 
    begin
        if (count == BAUD_TICK_COUNT)
        begin
            bit_done <= 1'b1;
            count    <= 0;  
        end
        else
        begin
            count    <= count + 1;
            bit_done <= 1'b0;  
        end    
    end
 end
 

 reg [9:0] tx_data; // 10-bit frame: start bit, data, stop bit
 integer bit_index = 0;
 reg [9:0] shift_tx = 0;
 
 always @(posedge clk)
 begin
    case (state)
    IDLE : 
    begin
        tx        <= 1'b1;
        tx_data   <= 0;
        bit_index <= 0;
        shift_tx  <= 0;
        
        if (start == 1'b1)
        begin
            tx_data <= {1'b1, txin, 1'b0}; // Concatenate stop bit, data, and start bit
            state   <= SEND;
        end
        else
        begin           
            state <= IDLE;
        end
    end
 
    SEND: 
    begin
        tx        <= tx_data[bit_index];
        state     <= CHECK;
        shift_tx  <= {tx_data[bit_index], shift_tx[9:1]};
    end 
  
    CHECK: 
    begin
        if (bit_index <= 9) // Transmit 10 bits
        begin
            if (bit_done == 1'b1)
            begin
                state <= SEND;
                bit_index <= bit_index + 1;
            end
        end
        else
        begin
            state <= IDLE;
            bit_index <= 0;
        end
    end
 
    default: state <= IDLE;
    endcase
 end
 
assign txdone = (bit_index == 9 && bit_done == 1'b1) ? 1'b1 : 1'b0;
 

 integer rx_count = 0;
 integer rx_index = 0;
 parameter RX_IDLE = 0, RX_WAIT = 1, RX_RECV = 2, RX_CHECK = 3;
 reg [1:0] rx_state = RX_IDLE;
 reg [9:0] rx_data;
 
 always @(posedge clk)
 begin
    case (rx_state)
    RX_IDLE : 
    begin
        rx_data  <= 0;
        rx_index <= 0;
        rx_count <= 0;
        
        if (rx == 1'b0) // Detect start bit
        begin
            rx_state <= RX_WAIT;
        end
        else
        begin
            rx_state <= RX_IDLE;
        end
    end
     
    RX_WAIT : 
    begin
        if (rx_count < BAUD_TICK_COUNT / 2)
        begin
            rx_count <= rx_count + 1;
            rx_state <= RX_WAIT;
        end
        else
        begin
            rx_count <= 0;
            rx_state <= RX_RECV;
            rx_data  <= {rx, rx_data[9:1]}; 
        end
    end
 
    RX_RECV : 
    begin
        if (rx_index <= 9) 
        begin
            if (bit_done == 1'b1) 
            begin
                rx_index <= rx_index + 1;
                rx_state <= RX_WAIT;
            end
        end
        else
        begin
            rx_state <= RX_IDLE;
            rx_index <= 0;
        end
    end
 
    default: rx_state <= RX_IDLE;
    endcase
 end
 
assign rxout = rx_data[8:1]; 
assign rxdone = (rx_index == 9 && bit_done == 1'b1) ? 1'b1 : 1'b0;
 
endmodule
