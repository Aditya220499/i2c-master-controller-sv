# TX Pipeline Architecture

# 1. Introduction

This document describes the internal TX pipeline architecture of the I2C Master Controller.

The goal of this architecture is to create a modular, timing-safe, scalable, and industry-style protocol engine.

The design is divided into:

- timing generation
- protocol sequencing
- serialization
- line control
- ACK handling

Each module owns a very specific responsibility.

This separation improves:

- scalability
- debug visibility
- verification quality
- RTL maintainability
- timing closure safety

---

# 2. High-Level Architecture

```text
                    +------------------+
                    |    clk_gen       |
                    +------------------+
                              |
                              v
                    +------------------+
                    |   phase_engine   |
                    +------------------+
                       |    |      |
                       |    |      |
                       |    |      +----------------+
                       |    |                       |
                       |    v                       v
                       | sample_pulse        phase_start pulses
                       |
                       v
               +------------------+
               | byte_tx_engine   |
               +------------------+
                    |        |
                    |        |
                    |        +------------------+
                    |                           |
                    v                           v
               load pulse               shift_enable pulse
                    |                           |
                    +------------+--------------+
                                 |
                                 v
                         +---------------+
                         |  serializer   |
                         +---------------+
                                 |
                                 v
                           serial_bit
                                 |
                                 v
                         +---------------+
                         | bit_tx_engine |
                         +---------------+
                                 |
                                 v
                           sda_drive_low
                                 |
                                 v
                        +----------------+
                        | i2c_line_ctrl  |
                        +----------------+
                                 |
                                 v
                                SDA
                                 |
                                 |
                       +------------------+
                       |   ack_handler    |
                       +------------------+
                                 |
                                 v
                           ack_received

# 3. Design Philosophy

The architecture follows strict modular ownership.
Each module owns only one responsibility.

Examples:

serializer:
only shifts bits
bit_tx_engine:
only converts serial bits into SDA drive behavior
line_ctrl:
only models open-drain bus behavior
phase_engine:
only generates timing phases
byte_tx_engine:
only controls byte-level sequencing

This prevents:
tight coupling
hidden timing dependencies
difficult debugging
large monolithic FSMs

# 4. Timing Architecture

The entire design is synchronous to the system clock.

No internally generated clocks are used.

Instead:

tick pulses
phase pulses
enable pulses

are used for timing control.

This is industry best practice because it avoids:

clock domain issues
skew problems
timing uncertainty
FPGA clock routing problems

# 5. phase_engine
Responsibility
Generates protocol timing phases.

Outputs:
scl_low_phase
scl_high_phase
sample_pulse
low_phase_start
high_phase_start
Internal Operation

Uses a subphase counter.

Timing sequence:
Subphase	Meaning
0	LOW begin
1	LOW hold
2	HIGH begin
3	SAMPLE point
4	HIGH hold
5	return LOW
Important Design Rule

Phase level signals are combinational.
Event pulses are registered.
This avoids unstable pulse behavior.

# 6. serializer
Responsibility
Converts parallel byte data into serial stream.

Features
MSB-first transmission
synchronous shifting
byte completion detection
Internal Signals
Signal	Purpose
shift_reg	active transmit data
bit_count	tracks remaining bits
byte_done	final bit completion
Important Behavior

Shifting occurs only on:
shift_enable pulse
generated from the timing engine.

# 7. byte_tx_engine
Responsibility

Controls byte-level transmission sequencing.

Responsibilities
start byte transfer
load serializer
trigger shifts
generate ACK phase
track TX activity
FSM States
State	Purpose
IDLE	waiting for transaction
DATA_TX	sending 8 bits
ACK_PHASE	waiting for slave ACK
COMPLETE	byte finished
8. bit_tx_engine
Responsibility

Converts logical serial bits into I2C SDA behavior.

Important Rule

I2C uses open-drain signaling.

Therefore:
serial_bit	SDA behavior
0	drive LOW
1	release line

Important Timing Rule

SDA changes only during:
scl_low_phase

SDA must remain stable during:
scl_high_phase

# 9. i2c_line_ctrl
Responsibility

Models open-drain bus behavior.
Behavior
drive_low	SDA
1	0
0	Z

External pull-up produces logic HIGH.
Industry Importance
This accurately models real I2C electrical behavior.

# 10. ack_handler
Responsibility

Samples slave ACK response.

ACK Definition
SDA	Meaning
0	ACK
1	NACK
Sampling Rule

ACK sampled only during:
sample_pulse
inside ACK phase.

# 11. Event Flow
Single Byte Transmission Sequence
tx_start
    ↓
byte_tx_engine issues load
    ↓
serializer loads tx_data
    ↓
phase_engine generates timing phases
    ↓
byte_tx_engine generates shift_enable
    ↓
serializer shifts bits
    ↓
bit_tx_engine updates SDA behavior
    ↓
serializer completes byte
    ↓
byte_tx_engine enters ACK phase
    ↓
master releases SDA
    ↓
slave drives ACK
    ↓
ack_handler samples SDA
    ↓
ack_received generated

# 12. Debug Strategy

The design exposes internal debug signals for waveform visibility.
Examples:
bit_count
shift_enable
serial_bit
subphase
ack_phase

This improves:
protocol debug
timing analysis
transaction visibility

# 13. Industry Best Practices Used

The design intentionally follows professional RTL practices:
synchronous design
no internally generated clocks
registered event pulses
modular ownership
timing-safe enable generation
open-drain modeling
clean FSM separation
protocol phase abstraction

# 14. Future Expansion

The architecture is designed to scale toward:
START/STOP integration
multi-byte transfer
repeated START
read transactions
clock stretching
arbitration handling
programmable clock divider
interrupt/status engine
APB/AXI integration

# 15. Conclusion

The TX pipeline architecture forms the protocol foundation of the I2C master controller.

The design emphasizes:
clean timing
modularity
protocol correctness
debug visibility
scalability
