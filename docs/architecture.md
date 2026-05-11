# I2C Master Controller Architecture

---

# High-Level Architecture

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

# Architectural Philosophy

The architecture separates:
- control logic
- timing logic
- electrical bus control
- serialization logic

This avoids:
- monolithic FSMs
- timing confusion
- difficult debugging

---

# Major Blocks

---

# 1. Main Transaction FSM

## Responsibility

Controls:
- transaction sequencing
- protocol ordering
- state transitions

## Does NOT Control

- exact wire timing
- SCL pulse generation
- setup/hold timing

---

# 2. Timing Engine

## Responsibility

Controls:
- SCL low period
- SCL high period
- setup timing
- hold timing
- sample timing

## Purpose

Separates timing management from FSM behavior.

---

# 3. Shift Register / Serializer

## Responsibility

Converts parallel data into serial bit stream.

Example:

```text
0xA5
```

becomes:

```text
1 0 1 0 0 1 0 1
```

---

# 4. SDA/SCL Controller

## Responsibility

Handles:
- open-drain behavior
- pull LOW
- release HIGH
- tri-state behavior

---

# 5. Arbitration Checker

## Responsibility

Monitors:
- transmitted value
- observed bus value

Detects:
- arbitration loss

---

# Signal Ownership

## FSM Owns
- transaction states
- protocol sequencing

## Timing Engine Owns
- timing phases
- sample points

## SDA Controller Owns
- electrical wire behavior

## Serializer Owns
- bit ordering

---

# Open-Drain Behavior

Devices:
- can drive LOW
- cannot drive HIGH

HIGH occurs because of pull-up resistors.

---

# SDA Ownership

## Master Owns SDA During
- address phase
- data transmission

## Slave Owns SDA During
- ACK phase
- read data phase

---

# Verification Architecture

Verification will include:
- unit-level testing
- waveform debugging
- assertions
- protocol validation
- integration testing