# I2C Master Controller Specification

---

# Project Objective

Design and implement a professional industry-style I2C Master Controller in SystemVerilog for FPGA/VLSI learning and reusable IP development.

---

# Supported Protocol

- I2C
- Standard Mode (100 kHz initially)

Future expansion:
- Fast Mode
- Multi-master support
- Extended timing support

---

# Initial Functional Scope

## Mandatory Features

- START generation
- STOP generation
- 7-bit addressing
- write transactions
- read transactions
- ACK/NACK handling
- repeated START support
- configurable clock divider

---

# Future Features

- arbitration detection
- clock stretching
- timeout detection
- protocol assertions
- error reporting

---

# System Interface

This interface is used by FPGA internal logic to command the controller.

## Inputs

```sv
input        clk;
input        rst_n;

input        start;
input [6:0]  addr;
input        rw;
input [7:0]  tx_data;
```

## Outputs

```sv
output [7:0] rx_data;

output       busy;
output       done;
output       ack_error;
```

---

# I2C Bus Interface

```sv
inout sda;
inout scl;
```

---

# Clocking

## System Clock
- FPGA clock input

Example:
- 100 MHz

## I2C Clock
Generated internally using clock divider.

Example:
- 100 kHz

---

# Transaction Flow

## Write Transaction

1. START
2. Send Address + Write Bit
3. Receive ACK
4. Send Data Byte
5. Receive ACK
6. STOP

---

## Read Transaction

1. START
2. Send Address + Read Bit
3. Receive ACK
4. Receive Data Byte
5. Send ACK/NACK
6. STOP

---

# Design Methodology

The controller is partitioned into:
- protocol sequencing
- timing generation
- bit serialization
- SDA/SCL electrical control

This keeps RTL modular and scalable.

---

# Verification Strategy

Each module will be:
- unit tested
- waveform verified
- integrated gradually

Verification includes:
- protocol correctness
- timing correctness
- corner-case testing
- assertions