`timescale 1ns / 1ps

module tb_spi;
reg clk;
reg start;
reg [11:0] din;
wire cs;
wire mosi;
wire done;
wire sclk;
spi uut (
    .clk(clk),
    .start(start),
    .din(din),
    .cs(cs),
    .mosi(mosi),
    .done(done),
    .sclk(sclk)
);

always #5 clk = ~clk; // 100 MHz clock (10 ns period)

initial begin
    clk = 0;
    start = 0;
    din = 12'h0;
    #10;
    din = 12'hA5A;  // Example data to be sent
    start = 1;
    #200;
    start = 0;
    #100;
    din = 12'h3C3;
    #200;
    $finish;
end


initial begin
    $monitor("Time: %0t | clk: %b | start: %b | din: %h | cs: %b | mosi: %b | done: %b | sclk: %b",
             $time, clk, start, din, cs, mosi, done, sclk);
end

endmodule
