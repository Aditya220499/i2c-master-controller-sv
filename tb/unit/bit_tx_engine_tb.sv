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
    // SERIAL DATA
    // ============================================================

    logic serial_bit;

    // ============================================================
    // ACK PHASE
    // ============================================================

    logic ack_phase;

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

        .ack_phase      (ack_phase),

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
    // TASK:
    // SEND NORMAL DATA BIT
    // ============================================================

    task send_bit(input logic bit_value);

        begin

            @(negedge clk);

            scl_low_phase  = 1;
            scl_high_phase = 0;

            sample_pulse   = 0;

            ack_phase      = 0;

            serial_bit     = bit_value;

            repeat(2) @(posedge clk);

            @(negedge clk);

            scl_low_phase  = 0;
            scl_high_phase = 1;

            repeat(2) @(posedge clk);

            @(negedge clk);

            sample_pulse = 1;

            @(posedge clk);

            @(negedge clk);

            sample_pulse = 0;

            repeat(2) @(posedge clk);

            @(negedge clk);

            scl_high_phase = 0;

        end

    endtask

    // ============================================================
    // TASK:
    // ACK CYCLE
    // ============================================================

    task ack_cycle;

        begin

            @(negedge clk);

            scl_low_phase  = 1;
            scl_high_phase = 0;

            // ====================================================
            // ENTER ACK PHASE
            // ----------------------------------------------------
            // Master MUST release SDA
            // ====================================================

            ack_phase = 1;

            repeat(2) @(posedge clk);

            @(negedge clk);

            scl_low_phase  = 0;
            scl_high_phase = 1;

            repeat(2) @(posedge clk);

            @(negedge clk);

            sample_pulse = 1;

            @(posedge clk);

            @(negedge clk);

            sample_pulse = 0;

            repeat(2) @(posedge clk);

            @(negedge clk);

            scl_high_phase = 0;

            ack_phase = 0;

        end

    endtask

    // ============================================================
    // TEST SEQUENCE
    // ============================================================

    initial begin

        scl_low_phase  = 0;
        scl_high_phase = 0;

        sample_pulse   = 0;

        serial_bit     = 1;

        ack_phase      = 0;

        wait(rst_n);

        // ========================================================
        // NORMAL BIT TESTS
        // ========================================================

        send_bit(1'b1);

        send_bit(1'b0);

        send_bit(1'b1);

        // ========================================================
        // ACK PHASE TEST
        // ========================================================

        ack_cycle();

        #50;

        $display("\n=================================");
        $display("BIT TX ENGINE TB COMPLETE");
        $display("=================================\n");

        $finish;

    end

endmodule