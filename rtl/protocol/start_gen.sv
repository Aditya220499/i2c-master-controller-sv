`timescale 1ns/1ps

module start_gen (

    // ============================================================
    // START REQUEST
    // ============================================================

    input logic start_enable,

    // ============================================================
    // OUTPUT DRIVE CONTROL
    // ============================================================

    output logic sda_drive_low,
    output logic scl_drive_low

);

    // ============================================================
    // START GENERATION
    // ------------------------------------------------------------
    // START condition:
    //
    // SDA transitions HIGH -> LOW
    // while SCL remains HIGH
    //
    // IMPORTANT:
    // This block ONLY controls bus drive intent.
    //
    // Protocol legality checking belongs elsewhere.
    // ============================================================

    always_comb begin

        // ========================================================
        // DEFAULT:
        // release both lines
        // ========================================================

        sda_drive_low = 1'b0;
        scl_drive_low = 1'b0;

        // ========================================================
        // GENERATE START
        // ========================================================

        if (start_enable) begin

            // Keep SCL released HIGH

            scl_drive_low = 1'b0;

            // Pull SDA LOW

            sda_drive_low = 1'b1;

        end
    end

endmodule
