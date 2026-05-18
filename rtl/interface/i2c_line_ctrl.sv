`timescale 1ns/1ps

module i2c_line_ctrl (

    // ============================================================
    // DRIVE REQUEST INPUTS
    // ------------------------------------------------------------
    // 1:
    //      actively pull line LOW
    //
    // 0:
    //      release line
    //
    // IMPORTANT:
    //      Controller NEVER actively drives HIGH.
    //
    //      HIGH level occurs because of pull-up resistor.
    // ============================================================

    input logic sda_drive_low,
    input logic scl_drive_low,

    // ============================================================
    // PHYSICAL I2C BUS LINES
    // ------------------------------------------------------------
    // Shared open-drain bus wires.
    // ============================================================

    inout wire sda,
    inout wire scl,

    // ============================================================
    // OBSERVED BUS VALUES
    // ------------------------------------------------------------
    // Actual electrical bus state.
    //
    // These signals are VERY important later for:
    //  - ACK detection
    //  - arbitration
    //  - clock stretching
    // ============================================================

    output logic sda_in,
    output logic scl_in

);

    // ============================================================
    // OPEN-DRAIN SDA DRIVER
    // ------------------------------------------------------------
    // drive_low = 1:
    //      connect SDA to GND
    //
    // drive_low = 0:
    //      disconnect from wire (high-Z)
    //
    // Pull-up resistor later restores HIGH level.
    // ============================================================

    assign sda = (sda_drive_low) ? 1'b0 : 1'bz;

    // ============================================================
    // OPEN-DRAIN SCL DRIVER
    // ============================================================

    assign scl = (scl_drive_low) ? 1'b0 : 1'bz;

    // ============================================================
    // BUS OBSERVATION
    // ------------------------------------------------------------
    // Sample actual bus voltage level.
    //
    // IMPORTANT:
    //      intended value != actual bus value
    //
    // Another device may:
    //  - hold bus LOW
    //  - stretch clock
    //  - win arbitration
    // ============================================================

    assign sda_in = sda;
    assign scl_in = scl;

endmodule