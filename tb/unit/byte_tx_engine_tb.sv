`timescale 1ns/1ps

module byte_tx_engine_tb;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst_n;

    // ============================================================
    // CONTROL
    // ============================================================

    logic tx_start;

    // ============================================================
    // PHASE SIGNALS
    // ============================================================

    logic scl_low_phase;
    logic scl_high_phase;

    // ============================================================
    // SERIALIZER STATUS
    // ============================================================

    logic byte_done;

    // ============================================================
    // OUTPUTS
    // ============================================================

    logic load;
    logic shift_enable;

    logic tx_active;

    // ============================================================
    // DUT
    // ============================================================

    byte_tx_engine dut (

        .clk            (clk),
        .rst_n          (rst_n),

        .tx_start       (tx_start),

        .scl_low_phase  (scl_low_phase),
        .scl_high_phase (scl_high_phase),

        .byte_done      (byte_done),

        .load           (load),
        .shift_enable   (shift_enable),

        .tx_active      (tx_active)

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

        tx_start       = 0;

        scl_low_phase  = 0;
        scl_high_phase = 0;

        byte_done      = 0;

        wait(rst_n);

        // ========================================================
        // START BYTE TRANSMISSION
        // ========================================================

        @(negedge clk);

        tx_start = 1;

        @(posedge clk);

        @(negedge clk);

        tx_start = 0;

        // ========================================================
        // GENERATE BIT PHASES
        // ========================================================

        repeat(8) begin

            // LOW phase

            @(negedge clk);

            scl_low_phase = 1;

            @(posedge clk);

            @(negedge clk);

            scl_low_phase = 0;

            // HIGH phase

            scl_high_phase = 1;

            #20;

            scl_high_phase = 0;

        end

        // ========================================================
        // BYTE COMPLETE
        // ========================================================

        @(negedge clk);

        byte_done = 1;

        @(posedge clk);

        @(negedge clk);

        byte_done = 0;

        #50;

        $display("\n=================================");
        $display("BYTE TX ENGINE TEST COMPLETE");
        $display("=================================\n");

        $finish;

    end

endmodule