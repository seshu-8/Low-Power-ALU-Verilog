# Simulation Guide — Low-Power ALU Design

## Option 1: EDA Playground (Free, Browser-Based, No Install Needed)
---

Steps:
1. Go to: https://www.edaplayground.com
2. Create a free account (use college email)
3. Click "Add HDL" → Select "Verilog"
4. In the LEFT panel (Design): paste contents of rtl/alu_top.v
5. In the RIGHT panel (Testbench): paste contents of tb/alu_tb.v
6. Under "Tools & Simulators": select "Icarus Verilog 0.9.7"
7. Check "Open EPWave after run" for waveform viewer
8. Click Run ▶

Expected console output:
  ==============================================
     LOW-POWER ALU TESTBENCH - ALL OPERATIONS  
  ==============================================
  TEST : ADD: 20+15=35
    A=0x14  B=0xf  Opcode=0000  En=1
    Result   = 0x23 (Expected: 0x23) PASS
  ...


## Option 2: ModelSim (Offline)
---

Step 1 - Compile:
  vlog rtl/alu_top.v tb/alu_tb.v

Step 2 - Simulate:
  vsim alu_tb

Step 3 - Run:
  run -all

Step 4 - Open waveform:
  add wave -recursive *
  In Wave window: right-click → Zoom Full


## Option 3: Xilinx Vivado (Recommended for synthesis + power report)
---

Step 1: Launch Vivado → Create New Project
  - Project name: Low_Power_ALU
  - Project type: RTL Project
  - Do not specify sources at this time: uncheck

Step 2: Add Sources
  - Add Design Source: rtl/alu_top.v
  - Add Simulation Source: tb/alu_tb.v
  - Add Constraints: constraints/alu_basys3.xdc (only for FPGA flow)

Step 3: Run Simulation
  Flow Navigator → Run Simulation → Run Behavioral Simulation
  In Tcl console: run 2000ns

Step 4: Inspect Waveform
  Signals to check:
  - en, A, B, opcode
  - result
  - zero_flag, carry_flag, overflow_flag, negative_flag

Step 5: Run Synthesis
  Flow Navigator → Run Synthesis
  After synthesis: Open Reports → Utilization / Power

Step 6: Generate Power Report (post-synthesis)
  Report Power → Default settings
  Look for: Total On-Chip Power (mW)
  Compare with/without operand isolation to see power savings concept


## What to Screenshot (GitHub Proof):
---

1. [ ] Simulation console output showing PASS for each test
2. [ ] Waveform: all signals visible, zoom into ADD and CMP operations
3. [ ] Waveform: en=0 section showing result=0 (power isolation proof)
4. [ ] Synthesis Utilization Report
5. [ ] Power Report (if Vivado)
6. [ ] RTL Schematic view (Vivado: Open Elaborated Design)

## VCD Waveform Viewer (Free Alternative):
---

Install GTKWave: https://gtkwave.sourceforge.net/
After simulation: gtkwave simulation/alu_wave.vcd
