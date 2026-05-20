`timescale 1ns/1ps

module ack_handler (

    input logic clk,
    input logic rst_n,

    input logic ack_phase,

    input logic sample_pulse,

    input logic sda_in,

    output logic ack_received

);

    always_ff @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            ack_received <= 0;

        end
        else begin

            // ====================================================
            // Sample ACK during ACK phase
            // ====================================================

            if(ack_phase && sample_pulse) begin

                // ================================================
                // ACK = SDA LOW
                // ================================================

                if(sda_in == 1'b0)
                    ack_received <= 1'b1;
                else
                    ack_received <= 1'b0;

            end
        end
    end

endmodule