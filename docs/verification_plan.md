# Verification Plan

---

# Verification Philosophy

Every module must be:
- tested independently
- waveform verified
- integrated gradually

Goal:
avoid integration surprises.

---

# Verification Stages

---

# Stage 1 — Electrical Bus Modeling

Verify:
- open-drain behavior
- pull-up behavior
- shared bus ownership

---

# Stage 2 — Timing Verification

Verify:
- clock divider accuracy
- phase timing
- setup/hold timing

---

# Stage 3 — START/STOP Verification

Verify:
- correct START timing
- correct STOP timing

---

# Stage 4 — Bit Transfer Verification

Verify:
- serializer correctness
- SDA stability during SCL HIGH

---

# Stage 5 — ACK Verification

Verify:
- slave ACK behavior
- master sampling timing

---

# Stage 6 — Full Transaction Verification

Verify:
- write transaction
- read transaction
- repeated START

---

# Stage 7 — Corner Cases

Verify:
- missing ACK
- stuck SDA LOW
- clock stretching
- arbitration loss

---

# Assertions Planned

## SDA Stability

SDA must not change while SCL HIGH.

---

## START Detection

Detect:
```text
SDA HIGH -> LOW
while SCL HIGH
```

---

## STOP Detection

Detect:
```text
SDA LOW -> HIGH
while SCL HIGH
```

---

# Waveform Strategy

Waveforms are primary debug tools.

Each stage must include:
- waveform inspection
- timing validation
- edge relationship analysis

---

# Self-Checking Goals

Long-term goal:
automatic PASS/FAIL verification.