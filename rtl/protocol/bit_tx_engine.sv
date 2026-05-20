`timescale 1ns/1ps

module bit_tx_engine (

    input logic clk,
    input logic rst_n,

    input logic scl_low_phase,
    input logic scl_high_phase,
    input logic sample_pulse,

    input logic serial_bit,

    // ============================================================
    // ACK PHASE
    // ------------------------------------------------------------
    // During ACK:
    // master MUST release SDA
    // ============================================================

    input logic ack_phase,

    output logic sda_drive_low

);

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            sda_drive_low <= 1'b0;

        end
        else begin

            // ====================================================
            // SDA updates only during LOW phase
            // ====================================================

            if (scl_low_phase) begin

                // ================================================
                // ACK phase:
                // release SDA for slave response
                // ================================================

                if (ack_phase) begin

                    sda_drive_low <= 1'b0;       // release line

                end

                // ================================================
                // NORMAL DATA TRANSMISSION
                // ================================================

                else begin

                    if (serial_bit == 1'b0)
                        sda_drive_low <= 1'b1;
                    else
                        sda_drive_low <= 1'b0;

                end
            end
        end
    end

endmodule