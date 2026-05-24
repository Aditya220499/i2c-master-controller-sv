`timescale 1ns/1ps

module clock_enable_generator #(

    parameter DIVIDE_COUNT = 4

)(

    input logic clk,
    input logic rst_n,

    output logic tick

);

    // ============================================================
    // COUNTER
    // ============================================================

    logic [$clog2(DIVIDE_COUNT)-1:0] count;

    // ============================================================
    // CLOCK ENABLE GENERATION
    // ============================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin

            count <= 0;
            tick  <= 0;

        end
        else begin

            // ====================================================
            // DEFAULT
            // ====================================================

            tick <= 0;

            // ====================================================
            // GENERATE SINGLE-CYCLE TICK
            // ====================================================

            if(count == DIVIDE_COUNT-1) begin

                count <= 0;

                tick <= 1;

            end
            else begin

                count <= count + 1;

            end
        end
    end

endmodule