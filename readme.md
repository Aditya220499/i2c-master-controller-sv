# I2C Master Controller (SystemVerilog)

Industry-style I2C Master Controller RTL project built from scratch for deep FPGA/VLSI learning, protocol understanding, RTL architecture development, verification methodology, and professional hardware design practices.

---

# Project Goal

The goal of this project is NOT just to make I2C communication work.

The real objective is to develop strong understanding of:

- protocol engineering
- RTL architecture
- timing-driven design
- FPGA system thinking
- verification mindset
- waveform-level debugging
- modular hardware design
- scalable IP development practices

This project is being developed incrementally using industry-style methodology.

Every module will be:
- designed
- simulated
- verified
- debugged

before integration.

This avoids:
- big-bang integration failures
- difficult debugging
- uncontrolled RTL growth

---

# What This Project Implements

This project implements a custom I2C Master Controller in SystemVerilog.

The controller will:
- generate SCL
- control SDA
- create START/STOP conditions
- transmit addresses
- transmit/receive data
- handle ACK/NACK
- support clock stretching
- support arbitration detection
- support protocol checking

---

# Key Learning Areas

This project focuses heavily on:

## Protocol Understanding
- I2C transaction flow
- START/STOP conditions
- ACK/NACK handling
- arbitration
- clock stretching
- open-drain behavior

## RTL Architecture
- FSM design
- timing engines
- serializer/deserializer design
- modular RTL structure
- interface partitioning
- timing ownership

## FPGA/System Thinking
- electrical behavior
- pull-up resistors
- tri-state behavior
- synchronization
- metastability
- CDC concepts

## Verification Mindset
- self-checking testbenches
- assertions
- waveform debugging
- corner-case testing
- protocol validation

---

# Design Philosophy

This project follows several important engineering principles:

## Incremental Development
Modules are developed and verified independently before integration.

## Single Responsibility
Each RTL block owns one clear responsibility.

## Timing Ownership Separation
Timing generation is separated from protocol sequencing.

## Debug Visibility
Design includes observable internal states/signals.

## Verification-Driven Thinking
Verification grows together with RTL.

---

# Repository Structure

```text
i2c-master-controller-sv/

├── rtl/
│   ├── core/
│   ├── timing/
│   ├── interface/
│   ├── protocol/
│   └── top/
│
├── tb/
│   ├── unit/
│   ├── integration/
│   ├── models/
│   └── tests/
│
├── docs/
│
├── sim/
│
├── waveforms/
│
├── scripts/
│
├── README.md
│
└── .gitignore
```

---

# High-Level Architecture

The I2C Master Controller consists of several major blocks:

```text
                    +----------------------+
                    |  Main Transaction    |
System Commands --->|        FSM           |
                    +----------+-----------+
                               |
                               v
                    +----------------------+
                    |    Timing Engine     |
                    +----------+-----------+
                               |
       -------------------------------------------------
       |                     |                        |
       v                     v                        v

+---------------+   +----------------+    +------------------+
| Shift Register|   | SDA/SCL Ctrl   |    | Arbitration      |
| Serializer    |   | Open-Drain IO  |    | Bus Monitor       |
+---------------+   +----------------+    +------------------+

                               |
                               v

                         Physical I2C Bus
```

---

# Current Development Status

## Stage 1 — Project Foundation
- [x] Repository planning
- [x] Architecture planning
- [x] Documentation structure

## Stage 2 — Electrical Bus Modeling
- [ ] Open-drain bus simulation
- [ ] Pull-up behavior modeling
- [ ] Shared bus ownership verification

## Stage 3 — Timing Foundation
- [ ] Clock enable generation
- [ ] Timing/phase engine

## Stage 4 — Bus Control
- [ ] SDA/SCL control logic
- [ ] START/STOP generation

## Stage 5 — Data Transfer
- [ ] Serializer
- [ ] Byte transfer
- [ ] ACK/NACK handling

## Stage 6 — Transaction Engine
- [ ] Main FSM integration

## Stage 7 — Advanced Features
- [ ] Clock stretching
- [ ] Arbitration handling

## Stage 8 — Verification Expansion
- [ ] Assertions
- [ ] Self-checking testbench

---

# Supported Features (Planned)

## Initial Features
- single-master support
- 7-bit addressing
- write transactions
- read transactions
- ACK/NACK handling
- repeated START
- configurable clock divider

## Advanced Features
- arbitration detection
- clock stretching
- timeout handling
- protocol assertions

---

# Important Concepts Used

## Open-Drain Bus

I2C uses open-drain signaling.

Devices:
- can pull line LOW
- cannot actively drive HIGH

HIGH level occurs because of external pull-up resistors.

---

## SDA Ownership

During:
- address/data bits → master controls SDA

During:
- ACK cycle → slave controls SDA

This ownership switching is critical.

---

## Timing Separation

FSM decides:
- WHAT operation to perform

Timing engine decides:
- WHEN wire transitions occur

This separation keeps RTL scalable and maintainable.

---

# Simulation Philosophy

Waveforms are treated as first-class debugging tools.

Every module will be verified independently using:
- dedicated testbenches
- waveform inspection
- assertions
- corner-case testing

---

# Long-Term Goal

This project is intended to build strong foundations for:
- SPI
- UART
- AXI
- APB
- Ethernet MAC
- PCIe concepts
- DDR controller concepts
- complex SoC protocol architectures

---

# Author

FPGA/VLSI Engineer focused on:
- protocol engineering
- RTL architecture
- timing-driven design
- scalable hardware systems
- deep protocol understanding