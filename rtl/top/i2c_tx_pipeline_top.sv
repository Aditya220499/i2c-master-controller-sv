`timescale 1ns/1ps

module i2c_tx_pipeline_top (

    input logic clk,
    input logic rst_n,

    // ============================================================
    // TRANSACTION CONTROL
    // ============================================================

    input logic tx_start,

    // ============================================================
    // BYTE TO TRANSMIT
    // ============================================================

    input logic [7:0] tx_data,

    // ============================================================
    // SLAVE ACK EMULATION
    // ------------------------------------------------------------
    // Used by TB to emulate slave ACK behavior
    // ============================================================

    input logic slave_ack_drive_low,

    // ============================================================
    // DEBUG OUTPUTS
    // ============================================================

    output logic tx_active,

    output logic ack_received,

    output logic sda

);

    // ============================================================
    // INTERNAL SIGNALS
    // ============================================================

    logic tick;

    logic scl_low_phase;
    logic scl_high_phase;

    logic low_phase_start;

    logic sample_pulse;

    logic load;
    logic shift_enable;

    logic serial_bit;

    logic byte_done;

    logic ack_phase;

    logic sda_drive_low;

    // ============================================================
    // SHARED OPEN-DRAIN SDA BUS
    // ============================================================

    tri1 sda_wire;

    // ============================================================
    // MASTER DRIVE
    // ============================================================

    assign sda_wire =
        (sda_drive_low) ? 1'b0 : 1'bz;

    // ============================================================
    // SLAVE ACK DRIVE
    // ============================================================

    assign sda_wire =
        (slave_ack_drive_low) ? 1'b0 : 1'bz;

    // ============================================================
    // EXTERNAL DEBUG
    // ============================================================

    assign sda = sda_wire;

    // ============================================================
    // CLOCK ENABLE GENERATOR
    // ============================================================

    clock_enable_gen clk_gen (

        .clk    (clk),
        .rst_n  (rst_n),

        .tick   (tick)

    );

    // ============================================================
    // PHASE ENGINE
    // ============================================================

    phase_engine phase_engine_inst (

        .clk            (clk),
        .rst_n          (rst_n),

        .tick           (tick),

        .scl_low_phase  (scl_low_phase),
        .scl_high_phase (scl_high_phase),

        .low_phase_start (low_phase_start),

        .sample_pulse   (sample_pulse)

    );

    // ============================================================
    // SERIALIZER
    // ============================================================

    serializer serializer_inst (

        .clk            (clk),
        .rst_n          (rst_n),

        .load           (load),
        .shift_enable   (shift_enable),

        .tx_data        (tx_data),

        .serial_bit     (serial_bit),

        .byte_done      (byte_done)

    );

    // ============================================================
    // BIT TX ENGINE
    // ============================================================

    bit_tx_engine bit_tx_inst (

        .clk            (clk),
        .rst_n          (rst_n),

        .scl_low_phase  (scl_low_phase),
        .scl_high_phase (scl_high_phase),

        .sample_pulse   (sample_pulse),

        .serial_bit     (serial_bit),

        .ack_phase      (ack_phase),

        .sda_drive_low  (sda_drive_low)

    );

    // ============================================================
    // ACK HANDLER
    // ============================================================

    ack_handler ack_handler_inst (

        .clk            (clk),
        .rst_n          (rst_n),

        .ack_phase      (ack_phase),

        .sample_pulse   (sample_pulse),

        .sda_in         (sda_wire),

        .ack_received   (ack_received)

    );

    // ============================================================
    // BYTE TX ENGINE
    // ============================================================

    byte_tx_engine byte_tx_inst (

        .clk            (clk),
        .rst_n          (rst_n),

        .tx_start       (tx_start),

        .scl_low_phase  (scl_low_phase),
        .scl_high_phase (scl_high_phase),

        .low_phase_start (low_phase_start),

        .sample_pulse   (sample_pulse),

        .byte_done      (byte_done),

        .ack_received   (ack_received),

        .load           (load),
        .shift_enable   (shift_enable),

        .tx_active      (tx_active),

        .ack_phase      (ack_phase)

    );

endmodule
