# Interview Preparation — Low-Power ALU Design

---

## Q1: Explain your project.

**Answer:**

I designed an 8-bit Low-Power ALU in Verilog that supports 11 operations including arithmetic, logical, shift, and compare. The design is parameterized — I can change bit-width from 4 to 16 with one parameter. The low-power technique I implemented is operand isolation using an enable signal. When enable is LOW, the input operands are gated to zero before reaching the computation logic. This eliminates switching activity inside the ALU — and in CMOS circuits, power consumption is directly proportional to switching activity (P = α·C·V²·f). When nothing is switching, dynamic power drops significantly. The project includes a full testbench with 25+ test cases covering all operations, edge cases, carry/overflow conditions, and the enable isolation test. I also ran it through Vivado synthesis to get utilization and power reports.

---

## Q2: What is an ALU and what is its role in a processor?

**Answer:**

ALU stands for Arithmetic Logic Unit. It is the computational core of a processor — the hardware block responsible for all arithmetic operations (add, subtract, increment) and logical operations (AND, OR, XOR, NOT). In the datapath of any processor, every time the CPU executes an instruction that involves data manipulation, the ALU is invoked. It sits between the register file and the result bus. Even in complex out-of-order superscalar processors, they simply have multiple ALUs running in parallel — the fundamental unit stays the same.

---

## Q3: What low-power technique did you implement and why?

**Answer:**

I implemented operand isolation. In CMOS digital circuits, dynamic power is P = α·C·V²·f, where α is the switching activity factor. If operands keep toggling even when the ALU isn't doing useful work (during idle cycles or pipeline stalls), those toggles consume power unnecessarily. By using an enable signal that gates the inputs to zero when the ALU is not needed, I prevent any internal node from switching. This is a form of RTL-level power optimization. More advanced forms include clock gating (stopping the clock itself) and power gating (cutting supply voltage). My implementation demonstrates the concept clearly at RTL level.

---

## Q4: What are the four ALU flags and when are they set?

**Answer:**

- **Zero Flag**: Set to 1 when the result is exactly 0. Used by branch instructions like BEQ (branch if equal).
- **Carry Flag**: Set when an arithmetic operation produces a carry out (addition overflow) or borrow (subtraction). Used in multi-precision arithmetic.
- **Overflow Flag**: Set when a signed arithmetic operation produces an incorrect signed result — e.g., adding two positive numbers results in a negative number due to bit-width limitation.
- **Negative Flag**: Set when the MSB (most significant bit) of the result is 1. In 2's complement representation, MSB=1 means the number is negative.

---

## Q5: How does your testbench verify the design?

**Answer:**

My testbench uses a reusable task called `apply_test` that takes A, B, opcode, enable, expected result, and expected flags as parameters. It applies the inputs, waits one clock cycle, then prints the actual vs expected result with PASS/FAIL status. I tested all 11 operations, critical edge cases (0+0, 255+1 for carry wrap, 0xFF^0xFF for XOR zero), flag verification for each condition, and the power isolation test (enable=0 with non-zero inputs to verify output stays 0). I also dump a VCD file for waveform analysis in GTKWave.

---

## Q6: What is the difference between carry flag and overflow flag?

**Answer:**

Carry flag is for unsigned arithmetic — it tells you if the result exceeded the bit-width from an unsigned perspective. Overflow flag is for signed arithmetic — it tells you if the signed interpretation of the result is wrong. Example: 200 + 100 in 8-bit unsigned sets carry (300 > 255). But 127 + 1 in signed sets overflow (127 is max positive, +1 flips to -128). These are separate flags because processors use both signed and unsigned operations, and the programmer/compiler decides which flag to check based on context.

---

## Q7: Why did you make the ALU parameterized?

**Answer:**

Parameterization means the WIDTH parameter controls bit-width across the entire module — all operations, flags, and intermediate signals scale automatically. If I instantiate `alu_top #(.WIDTH(16))`, I get a 16-bit ALU with no other code changes. This is industry practice. In real IP (Intellectual Property) blocks, engineers write one RTL that's reused across multiple chip projects with different bit-widths. It also demonstrates good RTL coding style — no hardcoded magic numbers.

---

## Q8: What synthesis results did you observe?

**Answer:**

After running Vivado synthesis targeting a Basys3 (Artix-7 XC7A35T), the ALU utilized approximately 12-20 LUTs (Look-Up Tables) for an 8-bit version — a small but functionally complete block. The power report showed dynamic power in the single-digit milliwatt range. With enable=0 (operand isolation active), switching activity drops significantly since all inputs are gated to zero. This demonstrates the low-power concept's effectiveness even at this scale. In real silicon (28nm or below), these savings multiply massively.

---

## Q9: What is clock gating and how is it different from what you implemented?

**Answer:**

Clock gating is a more aggressive power technique where the clock signal itself is stopped for idle blocks — if the clock doesn't toggle, no flip-flop inside that block ever switches, and dynamic power goes to nearly zero. What I implemented is operand isolation — a softer form that only gates the data inputs, not the clock. My ALU is combinational, so there are no flip-flops inside it, making operand isolation the appropriate choice here. For a sequential ALU with registered outputs, clock gating would be the preferred technique. Both target the same root cause: reducing switching activity.

---

## Q10: How would you extend this project further?

**Answer:**

Several directions: (1) Add a sequential pipeline stage — register the output with a flip-flop, enabling clock gating on top of operand isolation. (2) Extend to 16-bit or 32-bit operations by just changing the WIDTH parameter. (3) Add multiplication or division — these are complex ALU operations requiring more LUTs. (4) Implement a barrel shifter instead of single-bit shift for multi-bit shift operations. (5) Run power analysis using Cadence Genus or Synopsys DC to get real silicon-level numbers. (6) Add the ALU inside a simple single-cycle MIPS-like processor datapath to see it work end-to-end.

---

## Quick Reference: Opcode Table

| Opcode | Operation     | Flags Affected         |
|--------|---------------|------------------------|
| 0000   | ADD           | Zero, Carry, Overflow  |
| 0001   | SUB           | Zero, Carry, Overflow  |
| 0010   | AND           | Zero                   |
| 0011   | OR            | Zero, Negative         |
| 0100   | XOR           | Zero, Negative         |
| 0101   | NOT A         | Zero, Negative         |
| 0110   | Shift Left    | Zero, Carry, Negative  |
| 0111   | Shift Right   | Zero, Carry            |
| 1000   | Increment A   | Zero, Carry            |
| 1001   | Decrement A   | Zero, Carry            |
| 1010   | Compare A, B  | Zero, Carry            |
