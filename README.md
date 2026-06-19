# Low-Power ALU Design in Verilog

**8-bit Parameterized ALU | Operand Isolation | RTL Design | Vivado / EDA Playground**

---

## Overview

This project implements a **parameterized 8-bit Arithmetic Logic Unit (ALU)** in Verilog with a focus on **low-power design**. The ALU supports 11 operations across arithmetic, logic, shift, and compare categories. A low-power technique called **operand isolation** is implemented via an enable signal — when disabled, input operands are gated to zero, eliminating unnecessary switching activity inside the ALU logic.

This project is simulation-ready (no hardware required) and synthesis-tested on Xilinx Vivado targeting Basys3 (Artix-7).

---

## Problem Statement

Modern digital systems — phones, IoT devices, AI chips — demand high computational efficiency at minimum power. Even a fundamental block like the ALU must be power-aware. An ALU that performs computation during idle cycles (pipeline stalls, sleep modes) wastes dynamic power unnecessarily. This project demonstrates RTL-level power control as a foundation for low-power digital design.

---

## VLSI Concepts Used

| Concept | Implementation |
|---|---|
| Combinational Logic | All ALU operations in a single `always @(*)` block |
| Parameterized RTL | `WIDTH` parameter controls bit-width globally |
| Operand Isolation | `en=0` gates inputs to 0, killing switching activity |
| Flag Generation | Zero, Carry, Overflow, Negative flags computed per operation |
| Overflow Detection | Signed overflow via XOR of MSB sign bits |
| Carry Detection | Extended `WIDTH+1` bit addition to capture carry-out |
| Testbench | Self-checking testbench with 25+ test cases |
| VCD Waveform | Waveform dump for GTKWave / EPWave visualization |

---

## ALU Operations

| Opcode | Operation | Description |
|--------|-----------|-------------|
| 0000 | ADD | A + B |
| 0001 | SUB | A - B |
| 0010 | AND | A & B |
| 0011 | OR | A \| B |
| 0100 | XOR | A ^ B |
| 0101 | NOT A | ~A |
| 0110 | Shift Left | A << 1 |
| 0111 | Shift Right | A >> 1 |
| 1000 | Increment | A + 1 |
| 1001 | Decrement | A - 1 |
| 1010 | Compare | Sets flags (A == B, A < B, A > B) |

---

## Low-Power Design Concept

```
Dynamic Power: P = α · C · V² · f

α = switching activity factor

When en = 0:
  isolated_A = 0
  isolated_B = 0
  → No internal node toggles
  → α ≈ 0
  → Power drops significantly
```

This is **operand isolation** — a standard RTL low-power technique used in ARM Cortex-M cores, DSP processors, and mobile SoCs to reduce power during idle or stall cycles.

---

## Architecture

```
          ┌─────────────────────────────────────┐
  A[7:0] ─┤                                     ├─► result[7:0]
  B[7:0] ─┤   OPERAND ISOLATION                 │
 opcode  ─┤   (en=0 → A=0, B=0)                ├─► zero_flag
     en  ─┤          ↓                          ├─► carry_flag
          │   OPERATION DECODE (case)           ├─► overflow_flag
          │          ↓                          ├─► negative_flag
          │   COMPUTE RESULT                    │
          │          ↓                          │
          │   FLAG GENERATION                   │
          └─────────────────────────────────────┘
```

---

## Folder Structure

```
Low-Power-ALU-Verilog/
│
├── rtl/
│   └── alu_top.v              ← Main RTL module (parameterized ALU)
│
├── tb/
│   └── alu_tb.v               ← Self-checking testbench (25+ tests)
│
├── constraints/
│   └── alu_basys3.xdc         ← Vivado constraints (Basys3 FPGA)
│
├── simulation/
│   └── HOW_TO_SIMULATE.md     ← ModelSim / Vivado / EDA Playground guide
│
├── waveforms/                 ← Waveform screenshots from simulation
│
├── reports/                   ← Synthesis/power reports from Vivado
│
├── images/                    ← Architecture diagrams
│
├── docs/
│   └── INTERVIEW_QA.md        ← 10 interview Q&A with detailed answers
│
└── README.md
```

---

## Tools Used

| Tool | Purpose | Free? |
|------|---------|-------|
| Xilinx Vivado 2023 | Synthesis, Simulation, Power Analysis | Yes (WebPACK) |
| EDA Playground | Browser-based simulation (no install) | Yes |
| ModelSim | RTL simulation | Free for students |
| GTKWave | VCD waveform viewer | Yes |
| Basys3 FPGA | Optional hardware implementation | Optional |

---

## How to Simulate

### EDA Playground (Recommended — No Install):
1. Go to [edaplayground.com](https://www.edaplayground.com)
2. Paste `rtl/alu_top.v` → Design panel
3. Paste `tb/alu_tb.v` → Testbench panel
4. Select: **Icarus Verilog** + Check **EPWave**
5. Click **Run**

### ModelSim:
```bash
vlog rtl/alu_top.v tb/alu_tb.v
vsim alu_tb
run -all
```

### Vivado:
```
File → Add Sources → Add alu_top.v + alu_tb.v
Flow Navigator → Run Simulation → Behavioral Simulation
In Tcl: run 2000ns
```

---

## Sample Waveform Output

Expected waveform shows:
- `en=1` → ALU computes correctly for each opcode
- `en=0` → `result=0x00`, all flags=0 (operand isolation active)
- ADD carry: `0xFF + 0x01 = 0x00`, `carry_flag=1`
- CMP equal: `A=50, B=50`, `zero_flag=1`

*(See `/waveforms/` folder for screenshots)*

---

## Synthesis Results (Vivado, Artix-7 XC7A35T)

| Metric | Value |
|--------|-------|
| LUTs Used | ~12-20 |
| FFs Used | 0 (pure combinational) |
| Estimated Power | < 5 mW dynamic |
| Max Frequency | > 200 MHz |

*(See `/reports/` folder for actual synthesis reports)*

---

## Screenshots Checklist

- [ ] RTL code in editor
- [ ] Testbench code
- [ ] Simulation console — PASS results
- [ ] Waveform: all operations
- [ ] Waveform: en=0 isolation
- [ ] Synthesis Utilization Report
- [ ] Power Report
- [ ] RTL Schematic (Vivado Elaborated Design)

---

## Future Improvements

- Add 16-bit / 32-bit mode (change WIDTH parameter only)
- Implement barrel shifter (multi-bit shifts)
- Add multiplication (Booth's algorithm)
- Registered output with clock gating
- Full power comparison report: with vs without operand isolation
- Integrate into simple processor datapath

---

## Learning Outcomes

- RTL design in Verilog from scratch
- Parameterized module design
- CMOS power consumption fundamentals
- Low-power RTL technique: operand isolation
- Flag generation in ALU (Zero, Carry, Overflow, Negative)
- Testbench design and simulation methodology
- Synthesis flow in Vivado
- Power analysis basics

---

## Author

**Seshu** | VLSI Design Portfolio | GitHub: [@Github][https://github.com/seshu-8]

Linkedin:[@Linkedin][https://www.linkedin.com/in/seshu-babu-konijeti-74968b2b9?utm_source=share_via&utm_content=profile&utm_medium=member_android}
*Built as part of a VLSI course project and technical placement portfolio.*
