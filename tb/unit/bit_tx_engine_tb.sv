`timescale 1ns/1ps

module bit_tx_engine_tb;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst_n;

    // ============================================================
    // PHASE SIGNALS
    // ============================================================

    logic scl_low_phase;
    logic scl_high_phase;

    logic sample_pulse;

    // ============================================================
    // SERIAL INPUT BIT
    // ============================================================

    logic serial_bit;

    // ============================================================
    // DUT OUTPUT
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
    // CLOCK GENERATION
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
    // TASK:
    // SEND SINGLE BIT TIMING
    // ============================================================

    task send_bit(input logic bit_value);

        begin

            // ====================================================
            // LOW PHASE
            //
            // SDA allowed to change here
            // ====================================================

            @(negedge clk);

            scl_low_phase  = 1'b1;
            scl_high_phase = 1'b0;

            sample_pulse   = 1'b0;

            // Prepare next bit

            serial_bit = bit_value;

            // Hold LOW phase

            repeat(2) @(posedge clk);

            // ====================================================
            // HIGH PHASE
            //
            // SDA must remain stable
            // ====================================================

            @(negedge clk);

            scl_low_phase  = 1'b0;
            scl_high_phase = 1'b1;

            // Hold HIGH phase before sampling

            repeat(2) @(posedge clk);

            // ====================================================
            // SAMPLE EVENT
            //
            // Receiver samples SDA here
            // ====================================================

            @(negedge clk);

            sample_pulse = 1'b1;

            @(posedge clk);

            @(negedge clk);

            sample_pulse = 1'b0;

            // Hold HIGH after sample

            repeat(2) @(posedge clk);

            // End HIGH phase

            @(negedge clk);

            scl_high_phase = 1'b0;

        end

    endtask

    // ============================================================
    // TEST SEQUENCE
    // ============================================================

    initial begin

        // ========================================================
        // INITIAL CONDITIONS
        // ========================================================

        scl_low_phase  = 0;
        scl_high_phase = 0;

        sample_pulse   = 0;

        serial_bit     = 1'b1;

        wait(rst_n);

        // ========================================================
        // SEND BIT = 1
        // ========================================================

        send_bit(1'b1);

        // ========================================================
        // SEND BIT = 0
        // ========================================================

        send_bit(1'b0);

        // ========================================================
        // SEND BIT = 1
        // ========================================================

        send_bit(1'b1);

        #50;

        $display("\n=================================");
        $display("BIT TX ENGINE TEST COMPLETE");
        $display("=================================\n");

        $finish;

    end

endmodule
