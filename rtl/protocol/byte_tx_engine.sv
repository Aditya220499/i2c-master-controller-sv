`timescale 1ns/1ps

module byte_tx_engine (

    input logic clk,
    input logic rst_n,

    // ============================================================
    // TRANSACTION START
    // ============================================================

    input logic tx_start,

    // ============================================================
    // PHASE INPUTS
    // ============================================================

    input logic scl_low_phase,
    input logic scl_high_phase,

    input logic low_phase_start,

    input logic sample_pulse,

    // ============================================================
    // SERIALIZER STATUS
    // ============================================================

    input logic byte_done,

    // ============================================================
    // ACK STATUS
    // ============================================================

    input logic ack_received,

    // ============================================================
    // SERIALIZER CONTROL
    // ============================================================

    output logic load,
    output logic shift_enable,

    // ============================================================
    // STATUS
    // ============================================================

    output logic tx_active,

    // ============================================================
    // ACK CONTROL
    // ============================================================

    output logic ack_phase

);

    typedef enum logic [1:0] {

        IDLE,
        DATA_TX,
        ACK_PHASE,
        COMPLETE

    } state_t;

    state_t state;

    always_ff @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            load         <= 0;
            shift_enable <= 0;

            tx_active    <= 0;

            ack_phase    <= 0;

            state        <= IDLE;

        end
        else begin

            // ====================================================
            // DEFAULT PULSES
            // ====================================================

            load         <= 0;
            shift_enable <= 0;

            case(state)

                // ================================================
                // IDLE
                // ================================================

                IDLE: begin

                    tx_active <= 0;
                    ack_phase <= 0;

                    if(tx_start) begin

                        load      <= 1;

                        tx_active <= 1;

                        state     <= DATA_TX;

                    end
                end

                // ================================================
                // SEND 8 DATA BITS
                // ================================================

                DATA_TX: begin

                    if(low_phase_start)
                        shift_enable <= 1;

                    // ============================================
                    // BYTE COMPLETE
                    // ============================================

                    if(byte_done) begin

                        ack_phase <= 1;

                        state <= ACK_PHASE;

                    end
                end

                // ================================================
                // ACK CLOCK
                // ================================================

                ACK_PHASE: begin

                    // ============================================
                    // Wait for ACK sample point
                    // ============================================

                    if(sample_pulse) begin

                        state <= COMPLETE;

                    end
                end

                // ================================================
                // COMPLETE
                // ================================================

                COMPLETE: begin

                    tx_active <= 0;

                    ack_phase <= 0;

                    state <= IDLE;

                end

            endcase
        end
    end

endmodule
