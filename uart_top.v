`timescale 1ns / 1ps
// Engineer: Anushree Raut
// Create Date: 15.10.2026 14:02:12
// Design Name: 
// Module Name: uart_top


module uart_top(
    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,

    output tx,
    output tx_busy,
    output tx_done,
    output [7:0] data_out,
    output rx_done
);

// Internal wire connecting TX to RX
wire serial_line;

// UART Transmitter instance
uart_tx transmitter (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(serial_line),  //connects transmitter output to signal
    .tx_busy(tx_busy),
    .tx_done(tx_done)
);

// UART Receiver instance
uart_rx receiver (
    .clk(clk),
    .rst(rst),
    .rx(serial_line),  //connects rx input to signal
    .data_out(data_out),
    .rx_done(rx_done)
);

// Expose the transmitted serial signal
assign tx = serial_line;  //connects to tx

endmodule
