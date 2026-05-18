`timescale 1ns/1ps

module start_gen (

    // ============================================================
    // CONTROL
    // ============================================================

    input logic start_enable,

    // ============================================================
    // CURRENT BUS STATE
    // ------------------------------------------------------------
    // Observed bus values
    // ============================================================

    input logic scl_in,
    input logic sda_in,

    // ============================================================
    // OUTPUT DRIVE CONTROL
    // ------------------------------------------------------------
    // Drives connected to line controller
    // ============================================================

    output logic sda_drive_low,
    output logic scl_drive_low

);

    // ============================================================
    // DEFAULT BEHAVIOR
    // ------------------------------------------------------------
    // Keep both lines released unless START requested.
    // ============================================================

    always_comb begin

        // ========================================================
        // DEFAULT:
        // release lines
        // ========================================================

        sda_drive_low = 1'b0;
        scl_drive_low = 1'b0;

        // ========================================================
        // START CONDITION
        // --------------------------------------------------------
        // START:
        // SDA HIGH -> LOW
        // while SCL HIGH
        // ========================================================

        if (start_enable &&
            scl_in &&
            sda_in) begin

            // Keep SCL released HIGH

            scl_drive_low = 1'b0;

            // Pull SDA LOW

            sda_drive_low = 1'b1;

        end
    end

endmodule