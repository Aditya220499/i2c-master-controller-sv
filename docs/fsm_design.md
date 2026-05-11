# FSM Design

---

# Purpose

The FSM controls:
- transaction sequencing
- protocol order
- state transitions

The FSM does NOT directly control:
- precise timing
- electrical wire behavior

---

# FSM States

---

# IDLE

## Purpose
Wait for transaction request.

## Exit Condition
start asserted.

---

# START

## Purpose
Generate START condition.

## Exit Condition
START timing complete.

---

# SEND_ADDRESS

## Purpose
Transmit:
- 7-bit address
- R/W bit

## Exit Condition
8 bits transmitted.

---

# ADDRESS_ACK

## Purpose
Sample slave ACK.

## Exit Condition
ACK phase complete.

---

# WRITE_DATA

## Purpose
Transmit data byte.

## Exit Condition
8 bits transmitted.

---

# READ_DATA

## Purpose
Receive data byte.

## Exit Condition
8 bits received.

---

# DATA_ACK

## Purpose
ACK/NACK handling after data phase.

---

# STOP

## Purpose
Generate STOP condition.

## Exit Condition
STOP timing complete.

---

# DONE

## Purpose
Signal transaction completion.

---

# Error Handling

FSM must detect:
- missing ACK
- arbitration loss
- timeout conditions

Future enhancement.
