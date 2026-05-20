`timescale 1ns/1ps

module byte_tx_engine (

    input logic clk,
    input logic rst_n,

    input logic tx_start,

    input logic scl_low_phase,
    input logic scl_high_phase,

    // ============================================================
    // DATA BYTE FINISHED
    // ------------------------------------------------------------
    // Indicates:
    // 8 data bits completed
    // ============================================================

    input logic byte_done,

    // ============================================================
    // ACK RESULT
    // ============================================================

    input logic ack_received,

    output logic load,
    output logic shift_enable,

    output logic tx_active,

    // ============================================================
    // ACK PHASE INDICATOR
    // ============================================================

    output logic ack_phase

);

    typedef enum logic [1:0] {

        IDLE,
        DATA_TX,
        ACK_WAIT

    } state_t;

    state_t state;

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

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
                // DATA TRANSMISSION
                // ================================================

                DATA_TX: begin

                    if(scl_low_phase)
                        shift_enable <= 1;

                    // ============================================
                    // ENTER ACK PHASE
                    // ============================================

                    if(byte_done) begin

                        ack_phase <= 1;

                        state <= ACK_WAIT;

                    end
                end

                // ================================================
                // ACK PHASE
                // ================================================

                ACK_WAIT: begin

                    // ============================================
                    // Wait for ACK sampling
                    // ============================================

                    if(scl_high_phase) begin

                        tx_active <= 0;

                        ack_phase <= 0;

                        state <= IDLE;

                    end
                end

            endcase
        end
    end

endmodule