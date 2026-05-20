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
    // ACK STATUS
    // ============================================================

    logic ack_received;

    // ============================================================
    // DUT OUTPUTS
    // ============================================================

    logic load;
    logic shift_enable;

    logic tx_active;

    logic ack_phase;

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

        .ack_received   (ack_received),

        .load           (load),
        .shift_enable   (shift_enable),

        .tx_active      (tx_active),

        .ack_phase      (ack_phase)

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
    // GENERATE ONE CLOCK BIT PERIOD
    // ============================================================

    task bit_period;

        begin

            // LOW PHASE

            @(negedge clk);

            scl_low_phase = 1;
            scl_high_phase = 0;

            repeat(2) @(posedge clk);

            // HIGH PHASE

            @(negedge clk);

            scl_low_phase = 0;
            scl_high_phase = 1;

            repeat(2) @(posedge clk);

            @(negedge clk);

            scl_high_phase = 0;

        end

    endtask

    // ============================================================
    // TEST
    // ============================================================

    initial begin

        tx_start       = 0;

        scl_low_phase  = 0;
        scl_high_phase = 0;

        byte_done      = 0;

        ack_received   = 0;

        wait(rst_n);

        // ========================================================
        // START TX
        // ========================================================

        @(negedge clk);

        tx_start = 1;

        @(posedge clk);

        @(negedge clk);

        tx_start = 0;

        // ========================================================
        // 8 DATA BIT PERIODS
        // ========================================================

        repeat(8) begin

            bit_period();

        end

        // ========================================================
        // DATA BYTE COMPLETE
        // ========================================================

        @(negedge clk);

        byte_done = 1;

        @(posedge clk);

        @(negedge clk);

        byte_done = 0;

        // ========================================================
        // ACK CLOCK (9th CLOCK)
        // ========================================================

        bit_period();

        // ========================================================
        // ACK RECEIVED
        // ========================================================

        @(negedge clk);

        ack_received = 1;

        @(posedge clk);

        @(negedge clk);

        ack_received = 0;

        #50;

        $display("\n=================================");
        $display("BYTE TX ENGINE TB COMPLETE");
        $display("=================================\n");

        $finish;

    end

endmodule