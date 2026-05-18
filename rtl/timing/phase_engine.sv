`timescale 1ns/1ps

module phase_engine_tb;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst_n;

    // ============================================================
    // TICK
    // ============================================================

    logic tick;

    // ============================================================
    // DUT OUTPUTS
    // ============================================================

    logic scl_internal;

    logic scl_low_phase;
    logic scl_high_phase;

    logic sample_pulse;

    logic [2:0] debug_subphase;

    // ============================================================
    // DUT
    // ============================================================

    phase_engine dut (

        .clk             (clk),
        .rst_n           (rst_n),

        .tick            (tick),

        .scl_internal    (scl_internal),

        .scl_low_phase   (scl_low_phase),
        .scl_high_phase  (scl_high_phase),

        .sample_pulse    (sample_pulse),

        .debug_subphase  (debug_subphase)

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
    // SYNCHRONOUS TICK GENERATION
    // ============================================================

    initial begin

        tick = 0;

        wait(rst_n);

        forever begin

            repeat(4) @(posedge clk);

            tick <= 1'b1;

            @(posedge clk);

            tick <= 1'b0;

        end
    end

    // ============================================================
    // DEBUG MONITOR
    // ============================================================

    always @(posedge clk) begin

        if (tick) begin

            $display(
                "[TIME=%0t] subphase=%0d | scl=%0b | sample=%0b",
                $time,
                debug_subphase,
                scl_internal,
                sample_pulse
            );

        end
    end

    // ============================================================
    // SIMULATION END
    // ============================================================

    initial begin

        #1000;

        $display("\n==================================");
        $display("PHASE ENGINE SIMULATION COMPLETE");
        $display("==================================\n");

        $finish;

    end

endmodule
