`timescale 1ns/1ps

module ack_handler_tb;

    logic clk;
    logic rst_n;

    logic ack_phase;
    logic sample_pulse;

    logic sda_in;

    logic ack_received;

    ack_handler dut (

        .clk(clk),
        .rst_n(rst_n),

        .ack_phase(ack_phase),
        .sample_pulse(sample_pulse),

        .sda_in(sda_in),

        .ack_received(ack_received)

    );

    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end

    initial begin

        rst_n = 0;

        #20;

        rst_n = 1;

    end

    initial begin

        ack_phase   = 0;
        sample_pulse = 0;

        sda_in = 1;

        wait(rst_n);

        // ========================================================
        // ACK CASE
        // ========================================================

        @(negedge clk);

        ack_phase = 1;

        sda_in = 0;

        sample_pulse = 1;

        @(posedge clk);

        sample_pulse = 0;

        #20;

        // ========================================================
        // NACK CASE
        // ========================================================

        @(negedge clk);

        sda_in = 1;

        sample_pulse = 1;

        @(posedge clk);

        sample_pulse = 0;

        #20;

        $finish;

    end

endmodule