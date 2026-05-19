`timescale 1ns/1ps

module serializer_tb;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst_n;

    // ============================================================
    // CONTROL
    // ============================================================

    logic load;
    logic shift_enable;

    // ============================================================
    // INPUT DATA
    // ============================================================

    logic [7:0] tx_data;

    // ============================================================
    // OUTPUTS
    // ============================================================

    logic serial_bit;
    logic byte_done;

    logic [7:0] debug_shift_reg;
    logic [2:0] debug_bit_count;

    // ============================================================
    // DUT
    // ============================================================

    serializer dut (

        .clk             (clk),
        .rst_n           (rst_n),

        .load            (load),
        .shift_enable    (shift_enable),

        .tx_data         (tx_data),

        .serial_bit      (serial_bit),
        .byte_done       (byte_done),

        .debug_shift_reg (debug_shift_reg),
        .debug_bit_count (debug_bit_count)

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

        load         = 0;
        shift_enable = 0;

        tx_data      = 8'b1010_1101;

        wait(rst_n);

        #20;

        // ========================================================
        // LOAD BYTE
        // ========================================================

        load = 1;

        @(posedge clk);
        @(posedge clk);

        load = 0;

        // ========================================================
        // SHIFT ALL 8 BITS
        // ========================================================

        repeat(8) begin

            @(posedge clk);

            shift_enable = 1;

            @(posedge clk);

            shift_enable = 0;

        end

        #50;

        $display("\n=================================");
        $display("SERIALIZER SIMULATION COMPLETE");
        $display("=================================\n");

        $finish;

    end

    // ============================================================
    // DEBUG MONITOR
    // ============================================================

    always @(posedge clk) begin

        $display(
            "[TIME=%0t] "
            "shift_reg=%b "
            "serial_bit=%b "
            "bit_count=%0d "
            "byte_done=%b",
            $time,
            debug_shift_reg,
            serial_bit,
            debug_bit_count,
            byte_done
        );
    end

endmodule