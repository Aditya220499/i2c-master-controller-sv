`timescale 1ns/1ps

module open_drain_tb;

    // ============================================================
    // SHARED SDA BUS WIRE
    // ------------------------------------------------------------
    // This represents the physical I2C SDA wire on PCB.
    //
    // Multiple devices connect to SAME wire.
    //
    // Devices can:
    //   - pull LOW
    //   - release line
    //
    // Nobody actively drives HIGH.
    // ============================================================

    wire sda;

    // ============================================================
    // PULL-UP RESISTOR MODEL
    // ------------------------------------------------------------
    // Real I2C buses use external pull-up resistors.
    //
    // If nobody drives SDA LOW:
    //      resistor pulls SDA HIGH
    //
    // This primitive models that hardware behavior.
    // ============================================================

    pullup(sda);

    // ============================================================
    // MASTER DRIVER CONTROL
    // ------------------------------------------------------------
    // master_drive_low = 1
    //      -> master pulls SDA LOW
    //
    // master_drive_low = 0
    //      -> master releases SDA
    // ============================================================

    logic master_drive_low;

    // ============================================================
    // SLAVE DRIVER CONTROL
    // ------------------------------------------------------------
    // slave_drive_low = 1
    //      -> slave pulls SDA LOW
    //
    // slave_drive_low = 0
    //      -> slave releases SDA
    // ============================================================

    logic slave_drive_low;

    // ============================================================
    // OPEN-DRAIN MODEL
    // ------------------------------------------------------------
    // If device wants LOW:
    //      drive 0
    //
    // Otherwise:
    //      disconnect from bus using Z
    //
    // IMPORTANT:
    //      Z is NOT logic HIGH.
    //
    //      Z means:
    //      "I am electrically disconnected"
    // ============================================================

    assign sda = (master_drive_low) ? 1'b0 : 1'bz;

    assign sda = (slave_drive_low)  ? 1'b0 : 1'bz;

    // ============================================================
    // TEST SEQUENCE
    // ============================================================

    initial begin

        $display("\n==============================");
        $display("OPEN-DRAIN BUS SIMULATION");
        $display("==============================\n");

        // ========================================================
        // INITIAL STATE
        // Nobody drives bus
        //
        // Expected:
        // SDA should become HIGH due to pull-up resistor
        // ========================================================

        master_drive_low = 0;
        slave_drive_low  = 0;

        #20;

        $display("CASE 1: Nobody drives bus");
        $display("Expected SDA = 1");
        $display("Actual   SDA = %b\n", sda);

        // ========================================================
        // MASTER PULLS SDA LOW
        // ========================================================

        master_drive_low = 1;

        #20;

        $display("CASE 2: Master pulls LOW");
        $display("Expected SDA = 0");
        $display("Actual   SDA = %b\n", sda);

        // ========================================================
        // MASTER RELEASES BUS
        // ========================================================

        master_drive_low = 0;

        #20;

        $display("CASE 3: Master releases bus");
        $display("Expected SDA = 1");
        $display("Actual   SDA = %b\n", sda);

        // ========================================================
        // SLAVE PULLS LOW
        // ========================================================

        slave_drive_low = 1;

        #20;

        $display("CASE 4: Slave pulls LOW");
        $display("Expected SDA = 0");
        $display("Actual   SDA = %b\n", sda);

        // ========================================================
        // BOTH MASTER + SLAVE PULL LOW
        // ========================================================

        master_drive_low = 1;

        #20;

        $display("CASE 5: Both pull LOW");
        $display("Expected SDA = 0");
        $display("Actual   SDA = %b\n", sda);

        // ========================================================
        // BOTH RELEASE
        // ========================================================

        master_drive_low = 0;
        slave_drive_low  = 0;

        #20;

        $display("CASE 6: Both release");
        $display("Expected SDA = 1");
        $display("Actual   SDA = %b\n", sda);

        $display("==============================");
        $display("SIMULATION COMPLETE");
        $display("==============================");

        $finish;
    end

endmodule