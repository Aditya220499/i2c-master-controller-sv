`timescale 1ns/1ps

module stop_gen (

    // ============================================================
    // STOP REQUEST
    // ============================================================

    input logic stop_enable,

    // ============================================================
    // OUTPUT DRIVE CONTROL
    // ============================================================

    output logic sda_drive_low,
    output logic scl_drive_low

);

    // ============================================================
    // STOP GENERATION
    // ------------------------------------------------------------
    // STOP condition:
    //
    // SDA transitions LOW -> HIGH
    // while SCL remains HIGH
    //
    // IMPORTANT:
    // We do NOT drive SDA HIGH.
    //
    // We RELEASE SDA.
    // Pull-up resistor restores HIGH.
    // ============================================================

    always_comb begin

        // ========================================================
        // DEFAULT:
        // release both lines
        // ========================================================

        sda_drive_low = 1'b0;
        scl_drive_low = 1'b0;

        // ========================================================
        // GENERATE STOP
        // ========================================================

        if (stop_enable) begin

            // Keep SCL released HIGH

            scl_drive_low = 1'b0;

            // Release SDA

            sda_drive_low = 1'b0;

        end
    end

endmodule
