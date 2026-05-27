`timescale 1ns/1ps

module phase_engine (

    input  logic clk,
    input  logic rst_n,

    // ============================================================
    // TICK INPUT
    // ============================================================

    input  logic tick,

    // ============================================================
    // OUTPUTS
    // ============================================================

    output logic scl_internal,

    output logic scl_low_phase,
    output logic scl_high_phase,

    output logic low_phase_start,
    output logic high_phase_start,

    // ============================================================
    // EVENT PULSES
    // ============================================================

    output logic sample_pulse,

    // ============================================================
    // DEBUG
    // ============================================================

    output logic [2:0] debug_subphase

);

    // ============================================================
    // SUBPHASE COUNTER
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
    // COMBINATIONAL PHASE LEVELS
    // ------------------------------------------------------------
    // ONLY level signals here
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
        // SAMPLE POINT
        // ========================================================

        if (subphase == 3'd3) begin

            sample_pulse = 1'b1;

        end
    end

    // ============================================================
    // REGISTERED EVENT PULSES
    // ------------------------------------------------------------
    // CLEAN SYNCHRONOUS ONE-SHOT EVENTS
    // ============================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            low_phase_start  <= 1'b0;
            high_phase_start <= 1'b0;

        end
        else begin

            // ====================================================
            // DEFAULT
            // ====================================================

            low_phase_start  <= 1'b0;
            high_phase_start <= 1'b0;

            // ====================================================
            // GENERATE CLEAN EVENT PULSES
            // ====================================================

            if(tick) begin

                // ================================================
                // ENTER LOW PHASE
                // 5 -> 0
                // ================================================

                if(subphase == 3'd5)
                    low_phase_start <= 1'b1;

                // ================================================
                // ENTER HIGH PHASE
                // 1 -> 2
                // ================================================

                if(subphase == 3'd1)
                    high_phase_start <= 1'b1;

            end
        end
    end

    // ============================================================
    // DEBUG
    // ============================================================

    assign debug_subphase = subphase;

endmodule
