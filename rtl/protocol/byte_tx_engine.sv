`timescale 1ns/1ps

module byte_tx_engine (

    input logic clk,
    input logic rst_n,

    // ============================================================
    // TRANSMIT CONTROL
    // ============================================================

    input logic tx_start,

    // ============================================================
    // TIMING INPUTS
    // ============================================================

    input logic scl_low_phase,
    input logic scl_high_phase,

    // ============================================================
    // SERIALIZER STATUS
    // ============================================================

    input logic byte_done,

    // ============================================================
    // OUTPUT CONTROL
    // ============================================================

    output logic load,
    output logic shift_enable,

    output logic tx_active

);

    // ============================================================
    // INTERNAL SHIFT TRACKING
    // ============================================================

    logic shifting;

    // ============================================================
    // BYTE TRANSMIT CONTROL
    // ============================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            load         <= 1'b0;
            shift_enable <= 1'b0;

            tx_active    <= 1'b0;

            shifting     <= 1'b0;

        end
        else begin

            // ====================================================
            // DEFAULT PULSES LOW
            // ====================================================

            load         <= 1'b0;
            shift_enable <= 1'b0;

            // ====================================================
            // START BYTE TRANSMISSION
            // ====================================================

            if (tx_start && !tx_active) begin

                load      <= 1'b1;

                tx_active <= 1'b1;

                shifting  <= 1'b1;

            end

            // ====================================================
            // ACTIVE BYTE TRANSMISSION
            // ====================================================

            else if (shifting) begin

                // ================================================
                // SHIFT ONLY DURING LOW PHASE
                // ================================================

                if (scl_low_phase) begin

                    shift_enable <= 1'b1;

                end

                // ================================================
                // BYTE COMPLETE
                // ================================================

                if (byte_done) begin

                    tx_active <= 1'b0;

                    shifting  <= 1'b0;

                end
            end
        end
    end

endmodule