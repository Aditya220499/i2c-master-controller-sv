# Transaction Engine Architecture

## Overview

The transaction engine is the top-level protocol controller for the I2C master transmit path.

It coordinates:

* START generation
* Address transmission
* ACK handling
* Data transmission
* STOP generation

The transaction engine does NOT directly manipulate SDA/SCL.

Instead, it orchestrates lower-level protocol engines through handshake signaling.

---

# Architectural Philosophy

The design follows hierarchical protocol control architecture.

The transaction engine:

* controls protocol sequencing
* commands submodules
* waits for completion handshakes

Submodules:

* perform bit-level operations
* handle timing-sensitive protocol details

This separation improves:

* scalability
* modularity
* verification
* protocol clarity

---

# Controlled Modules

| Module         | Responsibility            |
| -------------- | ------------------------- |
| start_gen      | Generate START condition  |
| byte_tx_engine | Control byte transmission |
| serializer     | Serialize tx_data         |
| bit_tx_engine  | SDA bit driving           |
| ack_handler    | ACK/NACK detection        |
| stop_gen       | Generate STOP condition   |

---

# Transaction Flow

The FSM executes the following sequence:

1. Wait for transaction request
2. Generate START condition
3. Send address byte
4. Wait for address ACK
5. Send data byte
6. Wait for data ACK
7. Generate STOP condition
8. Complete transaction

---

# FSM State Diagram

```text
                +--------+
                | IDLE   |
                +--------+
                     |
                     | start_transaction
                     v
              +-------------+
              | GEN_START   |
              +-------------+
                     |
                     | start_done
                     v
              +-------------+
              | SEND_ADDR   |
              +-------------+
                     |
                     | byte_done
                     v
           +-------------------+
           | WAIT_ADDR_ACK     |
           +-------------------+
              |           |
     ACK OK   |           | NACK
              v           v
       +-------------+   +-----------+
       | SEND_DATA   |   | GEN_STOP  |
       +-------------+   +-----------+
              |
              | byte_done
              v
       +-------------------+
       | WAIT_DATA_ACK     |
       +-------------------+
              |        |
       ACK OK |        | NACK
              v        v
          +-----------+
          | GEN_STOP  |
          +-----------+
                |
                | stop_done
                v
            +--------+
            | DONE   |
            +--------+
                |
                v
             IDLE
```

---

# FSM State Descriptions

## IDLE

Waits for transaction request.

Outputs:

* busy = 0

Transition:

* start_transaction -> GEN_START

---

## GEN_START

Triggers START generator.

Outputs:

* start_enable = 1

Transition:

* start_done -> SEND_ADDR

---

## SEND_ADDR

Starts address byte transmission.

Outputs:

* tx_start = 1
* tx_data_select = ADDRESS

Transition:

* byte_done -> WAIT_ADDR_ACK

---

## WAIT_ADDR_ACK

Waits for ACK result from slave.

Transition:

* ack_received = 1 -> SEND_DATA
* ack_received = 0 -> GEN_STOP

---

## SEND_DATA

Starts data byte transmission.

Outputs:

* tx_start = 1
* tx_data_select = DATA

Transition:

* byte_done -> WAIT_DATA_ACK

---

## WAIT_DATA_ACK

Waits for slave ACK after data byte.

Transition:

* ack_received = 1 -> GEN_STOP
* ack_received = 0 -> GEN_STOP

---

## GEN_STOP

Triggers STOP generator.

Outputs:

* stop_enable = 1

Transition:

* stop_done -> DONE

---

## DONE

Transaction complete state.

Outputs:

* busy = 0
* done = 1

Transition:

* automatic return to IDLE

---

# Interface Signals

## Inputs

| Signal            | Description                 |
| ----------------- | --------------------------- |
| clk               | system clock                |
| rst_n             | active-low reset            |
| start_transaction | transaction request         |
| start_done        | START completed             |
| stop_done         | STOP completed              |
| byte_done         | byte transmission completed |
| ack_received      | slave ACK status            |

---

## Outputs

| Signal       | Description               |
| ------------ | ------------------------- |
| start_enable | trigger START generator   |
| stop_enable  | trigger STOP generator    |
| tx_start     | trigger byte transmission |
| busy         | transaction active        |
| done         | transaction completed     |

---

# Handshake Philosophy

All control handshakes use:

* synchronous signaling
* single-clock pulse methodology
* deterministic completion

The FSM never advances without explicit completion acknowledgement.

---

# Verification Strategy

The transaction engine verification must confirm:

* correct state sequencing
* correct protocol ordering
* correct ACK handling
* correct STOP behavior
* proper transaction completion

Waveform debug must include:

* current state
* next state
* handshake pulses
* tx_active
* ack_phase

---

# Future Expansion

Future revisions may include:

* repeated START support
* read transactions
* multi-byte transfers
* FIFO integration
* APB register interface
* interrupt generation
* arbitration handling
* clock stretching
* timeout detection

The current architecture is intentionally modular to support future scalability.
