`timescale 1ns / 1ps
// Engineer: Anushree Raut
// Create Date: 14.10.2026 22:40:54
// Design Name: 
// Module Name: uart_rx

module uart_rx(
    input clk, rst, rx,
    output reg [7:0] data_out,
    output reg rx_done
);

reg [13:0] baud_counter;
reg [2:0] bit_index;
reg [7:0] data_reg;
reg [1:0] state;

localparam S0 = 2'b00,  // IDLE
           S1 = 2'b01,  // START
           S2 = 2'b10,  // DATA
           S3 = 2'b11;  // STOP

always @(posedge clk) begin
    if (rst) begin
        state        <= S0;
        baud_counter <= 14'd0;
        bit_index    <= 3'd0;
        data_reg     <= 8'd0;
        data_out     <= 8'd0;
        rx_done      <= 1'b0;
    end
    else begin
        rx_done <= 1'b0;

        case (state)

            // S0: Wait for start bit
            S0: begin
                if (rx == 1'b0) begin
                    baud_counter <= 14'd0;
                    bit_index    <= 3'd0;
                    state        <= S1;
                end
            end

            // S1: Validate start bit at midpoint
            S1: begin
                if (baud_counter == 14'd5207) begin
                    baud_counter <= 14'd0;

                    if (rx == 1'b0)
                        state <= S2;
                    else
                        state <= S0;
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            // S2: Receive 8 data bits, LSB first
            S2: begin
                if (baud_counter == 14'd10416) begin
                    baud_counter <= 14'd0;
                    data_reg[bit_index] <= rx;

                    if (bit_index == 3'd7) begin
                        bit_index <= 3'd0;
                        state <= S3;
                    end
                    else begin
                        bit_index <= bit_index + 1'b1;
                    end
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            // S3: Validate stop bit
            S3: begin
                if (baud_counter == 14'd10416) begin
                    baud_counter <= 14'd0;

                    if (rx == 1'b1) begin
                        data_out <= data_reg;
                        rx_done <= 1'b1;
                    end

                    state <= S0;
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            default: begin
                state <= S0;
                baud_counter <= 14'd0;
                bit_index <= 3'd0;
            end

        endcase
    end
end

endmodule

