`timescale 1ns/1ps

module bit_tx_engine (

    input logic clk,
    input logic rst_n,

    // ============================================================
    // TIMING CONTROL
    // ============================================================

    input logic scl_low_phase,
    input logic scl_high_phase,
    input logic sample_pulse,

    // ============================================================
    // SERIALIZER INPUT BIT
    // ============================================================

    input logic serial_bit,

    // ============================================================
    // OUTPUT TO LINE CONTROLLER
    // ------------------------------------------------------------
    // 1:
    //      pull SDA LOW
    //
    // 0:
    //      release SDA HIGH
    // ============================================================

    output logic sda_drive_low

);

    // ============================================================
    // SDA OUTPUT REGISTER
    // ------------------------------------------------------------
    // SDA may ONLY update during SCL LOW phase.
    //
    // During HIGH phase:
    // SDA must remain stable.
    // ============================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            sda_drive_low <= 1'b0;

        end
        else begin

            // ====================================================
            // UPDATE SDA ONLY DURING LOW PHASE
            // ====================================================

            if (scl_low_phase) begin

                // ================================================
                // I2C OPEN-DRAIN MAPPING
                //
                // serial_bit = 0:
                //      pull LOW
                //
                // serial_bit = 1:
                //      release HIGH
                // ================================================

                if (serial_bit == 1'b0)
                    sda_drive_low <= 1'b1;
                else
                    sda_drive_low <= 1'b0;

            end
        end
    end

endmodule