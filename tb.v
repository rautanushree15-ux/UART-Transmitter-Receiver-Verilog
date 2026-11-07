`timescale 1ns / 1ps
// Engineer: Anushree Raut
// Create Date: 15.10.2026 14:20:30
// Design Name: 
// Module Name: tb

module tb_uart_top;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] data_in;

    wire tx;
    wire tx_busy;
    wire tx_done;
    wire rx_done;
    wire [7:0] data_out;

    uart_top dut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    // 100 MHz clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Initial reset only
    initial begin
        rst = 1;
        tx_start = 0;
        data_in = 0;

        repeat (5) @(negedge clk);
        rst = 0;
    end

    // Display received data
    always @(posedge rx_done) begin
        #1;
        $display("Received Data = %h", data_out);
    end

endmodule
