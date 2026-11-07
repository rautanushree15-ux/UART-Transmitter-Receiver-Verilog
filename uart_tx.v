`timescale 1ns / 1ps
// Engineer: Anushree Raut
// Create Date: 14.10.2026 14:27:26
// Module Name: uart_tx

module uart_tx(
    input clk, rst, tx_start,
    input [7:0] data_in,
    output reg tx, tx_busy, tx_done
);

reg [13:0] baud_counter;
reg [2:0] bit_index;
reg [7:0] data_reg;
reg [1:0] state;

localparam IDLE  = 2'b00,
           START = 2'b01,
           DATA  = 2'b10,
           STOP  = 2'b11;

always @(posedge clk) begin
    if (rst) begin
        state        <= IDLE;
        baud_counter <= 14'd0;
        bit_index    <= 3'd0;
        data_reg     <= 8'd0;
        tx           <= 1'b1;
        tx_busy      <= 1'b0;
        tx_done      <= 1'b0;
    end
    else begin
        tx_done <= 1'b0;

        case (state)

            IDLE: begin
                tx <= 1'b1;
                tx_busy <= 1'b0;

                if (tx_start) begin
                    data_reg <= data_in;
                    baud_counter <= 14'd0;
                    bit_index <= 3'd0;
                    tx_busy <= 1'b1;
                    state <= START;
                end
            end

            START: begin
                tx <= 1'b0;

                if (baud_counter == 14'd10416) begin
                    baud_counter <= 14'd0;
                    bit_index <= 3'd0;
                    tx <= data_reg[0];
                    state <= DATA;
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            DATA: begin
                tx <= data_reg[bit_index];

                if (baud_counter == 14'd10416) begin
                    baud_counter <= 14'd0;

                    if (bit_index == 3'd7) begin
                        tx <= 1'b1;
                        state <= STOP;
                    end
                    else begin
                        bit_index <= bit_index + 1'b1;
                        tx <= data_reg[bit_index + 1'b1];
                    end
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            STOP: begin
                tx <= 1'b1;

                if (baud_counter == 14'd10416) begin
                    baud_counter <= 14'd0;
                    state <= IDLE;
                    tx_busy <= 1'b0;
                    tx_done <= 1'b1;
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            default: begin
                state <= IDLE;
                baud_counter <= 14'd0;
                bit_index <= 3'd0;
                tx <= 1'b1;
                tx_busy <= 1'b0;
                tx_done <= 1'b0;
            end

        endcase
    end
end

endmodule

