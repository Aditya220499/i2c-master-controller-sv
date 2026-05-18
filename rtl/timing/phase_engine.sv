`timescale 1ns/1ps

module phase_engine (

    input  logic clk,
    input  logic rst_n,

    // ============================================================
    // TICK INPUT
    // ------------------------------------------------------------
    // Timing advances only on tick pulse
    // ============================================================

    input  logic tick,

    // ============================================================
    // OUTPUTS
    // ============================================================

    output logic scl_internal,

    output logic scl_low_phase,
    output logic scl_high_phase,

    // ============================================================
    // EVENT PULSES
    // ------------------------------------------------------------
    // These are INTERNAL timing events
    // ============================================================

    output logic sample_pulse,

    // ============================================================
    // DEBUG
    // ============================================================

    output logic [2:0] debug_subphase

);

    // ============================================================
    // SUBPHASE COUNTER
    //
    // Timing sequence:
    //
    // 0 -> LOW begin
    // 1 -> LOW hold
    // 2 -> HIGH begin
    // 3 -> SAMPLE point
    // 4 -> HIGH hold
    // 5 -> return LOW
    // ============================================================

    logic [2:0] subphase;

    // ============================================================
    // SUBPHASE ADVANCEMENT
    // ============================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            subphase <= 3'd0;

        end
        else begin

            if (tick) begin

                if (subphase == 3'd5)
                    subphase <= 3'd0;
                else
                    subphase <= subphase + 1'b1;

            end
        end
    end

    // ============================================================
    // OUTPUT GENERATION
    // ============================================================

    always_comb begin

        // ========================================================
        // DEFAULTS
        // ========================================================

        scl_internal   = 1'b0;

        scl_low_phase  = 1'b0;
        scl_high_phase = 1'b0;

        sample_pulse   = 1'b0;

        // ========================================================
        // LOW REGION
        // ========================================================

        if (subphase == 3'd0 ||
            subphase == 3'd1 ||
            subphase == 3'd5) begin

            scl_internal  = 1'b0;

            scl_low_phase = 1'b1;

        end

        // ========================================================
        // HIGH REGION
        // ========================================================

        else begin

            scl_internal   = 1'b1;

            scl_high_phase = 1'b1;

        end

        // ========================================================
        // SAMPLE EVENT
        // --------------------------------------------------------
        // SAMPLE occurs INSIDE HIGH region
        // ========================================================

        if (subphase == 3'd3) begin

            sample_pulse = 1'b1;

        end
    end

    // ============================================================
    // DEBUG
    // ============================================================

    assign debug_subphase = subphase;

endmodule
