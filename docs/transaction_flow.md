# I2C Transaction Flow

---

# Write Transaction

---

# Step 1 — Bus Idle

Initial condition:

```text
SCL = HIGH
SDA = HIGH
```

Both lines released.

---

# Step 2 — START Condition

Master generates:

```text
SDA: HIGH -> LOW
while SCL remains HIGH
```

This indicates:
- transaction begins
- bus becomes busy

---

# Step 3 — Address Transmission

Master sends:
- 7-bit slave address
- R/W bit

Example:

```text
1010000 + 0
```

---

# Step 4 — ACK Phase

Master releases SDA.

Slave responds:

## ACK
Slave pulls SDA LOW.

## NACK
Slave leaves SDA HIGH.

---

# Step 5 — Data Transmission

Master sends:
- 8-bit data

One bit per SCL cycle.

---

# Step 6 — ACK Phase

Slave again acknowledges.

---

# Step 7 — STOP Condition

Master generates:

```text
SDA: LOW -> HIGH
while SCL remains HIGH
```

Bus returns to idle.

---

# Important Timing Rule

SDA must remain stable while SCL is HIGH.

SDA changes are allowed only during:
- SCL LOW
- START condition
- STOP condition

---

# SDA Ownership

## Master Controls SDA During
- START
- address bits
- write data bits
- STOP

## Slave Controls SDA During
- ACK
- read data bits

---

# Clock Stretching

Slave may hold SCL LOW to delay transaction.

Master must wait until:
```text
SCL actually becomes HIGH
```

---

# Arbitration

If:
- master sends 1
- observes 0

then:
- another master won arbitration