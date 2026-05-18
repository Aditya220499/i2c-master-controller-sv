`timescale 1ns/1ps

module stop_gen (

    // ============================================================
    // CONTROL
    // ============================================================

    input logic stop_enable,

    // ============================================================
    // OBSERVED BUS VALUES
    // ============================================================

    input logic scl_in,
    input logic sda_in,

    // ============================================================
    // OUTPUT DRIVE CONTROL
    // ============================================================

    output logic sda_drive_low,
    output logic scl_drive_low

);

    // ============================================================
    // STOP GENERATION
    // ============================================================

    always_comb begin

        // ========================================================
        // DEFAULT:
        // release both lines
        // ========================================================

        sda_drive_low = 1'b0;
        scl_drive_low = 1'b0;

        // ========================================================
        // STOP CONDITION
        // --------------------------------------------------------
        // STOP:
        // SDA LOW -> HIGH
        // while SCL HIGH
        //
        // IMPORTANT:
        // We do NOT drive HIGH.
        //
        // We RELEASE SDA,
        // then pull-up resistor raises line HIGH.
        // ========================================================

        if (stop_enable &&
            scl_in &&
            !sda_in) begin

            // Keep SCL HIGH

            scl_drive_low = 1'b0;

            // Release SDA

            sda_drive_low = 1'b0;

        end
    end

endmodule