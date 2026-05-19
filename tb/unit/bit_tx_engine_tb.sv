`timescale 1ns/1ps

module bit_tx_engine_tb;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst_n;

    // ============================================================
    // PHASE CONTROL
    // ============================================================

    logic scl_low_phase;
    logic scl_high_phase;
    logic sample_pulse;

    // ============================================================
    // SERIAL INPUT BIT
    // ============================================================

    logic serial_bit;

    // ============================================================
    // OUTPUT
    // ============================================================

    logic sda_drive_low;

    // ============================================================
    // DUT
    // ============================================================

    bit_tx_engine dut (

        .clk            (clk),
        .rst_n          (rst_n),

        .scl_low_phase  (scl_low_phase),
        .scl_high_phase (scl_high_phase),
        .sample_pulse   (sample_pulse),

        .serial_bit     (serial_bit),

        .sda_drive_low  (sda_drive_low)

    );

    // ============================================================
    // CLOCK
    // ============================================================

    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end

    // ============================================================
    // RESET
    // ============================================================

    initial begin

        rst_n = 0;

        #20;

        rst_n = 1;

    end

    // ============================================================
    // TEST SEQUENCE
    // ============================================================

    initial begin

        scl_low_phase  = 0;
        scl_high_phase = 0;
        sample_pulse   = 0;

        serial_bit     = 1'b1;

        wait(rst_n);

        // ========================================================
        // SEND BIT = 1
        // ========================================================

        @(negedge clk);

        scl_low_phase = 1;

        serial_bit = 1'b1;

        @(posedge clk);

        scl_low_phase = 0;
        scl_high_phase = 1;

        #20;

        sample_pulse = 1;

        #10;

        sample_pulse = 0;

        scl_high_phase = 0;

        // ========================================================
        // SEND BIT = 0
        // ========================================================

        @(negedge clk);

        scl_low_phase = 1;

        serial_bit = 1'b0;

        @(posedge clk);

        scl_low_phase = 0;
        scl_high_phase = 1;

        #20;

        sample_pulse = 1;

        #10;

        sample_pulse = 0;

        scl_high_phase = 0;

        #50;

        $display("\n=================================");
        $display("BIT TRANSMIT TEST COMPLETE");
        $display("=================================\n");

        $finish;

    end

endmodule