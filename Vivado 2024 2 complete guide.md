\# Vivado 2024.2 — Complete Project Guide

\# Low-Power ALU Design in Verilog



\---



\## PART 1: CREATE PROJECT



1\. Open Vivado 2024.2

2\. Click "Create Project" → Next

3\. Project name: Low\_Power\_ALU

4\. Project location: D:/vivado projects/

5\. Leave "Create project subdirectory" checked

6\. Click Next

7\. Project type: RTL Project

8\. CHECK ✅ "Do not specify sources at this time"

9\. Click Next

10\. Select device:

&#x20;   - Click "Parts" tab

&#x20;   - Family: Artix-7

&#x20;   - Package: cpg236

&#x20;   - Part: xc7a35tcpg236-1

&#x20;   - Speed: -1

11\. Click Next → Finish



\---



\## PART 2: ADD DESIGN SOURCE (RTL)



1\. Sources panel (left) → click "+" button

2\. Select "Add or create design sources" → Next

3\. Click "Add Files"

4\. Navigate to your folder → select: rtl/alu\_top.v

5\. Check ✅ "Copy sources into project"

6\. Click Finish



\---



\## PART 3: ADD SIMULATION SOURCE (Testbench)



1\. Sources panel → click "+" again

2\. Select "Add or create simulation sources" → Next

3\. Click "Add Files"

4\. Select: tb/alu\_tb.v

5\. Check ✅ "Copy sources into project"

6\. Click Finish

7\. In Sources panel → expand "Simulation Sources"

8\. Right-click alu\_tb → Set as Top



\---



\## PART 4: ADD CONSTRAINTS (For FPGA only)



1\. Sources panel → click "+" again

2\. Select "Add or create constraints" → Next

3\. Click "Add Files"

4\. Select: constraints/alu\_basys3.xdc

5\. Check ✅ "Copy sources into project"

6\. Click Finish



\---



\## PART 5: RUN BEHAVIORAL SIMULATION



1\. Flow Navigator (left) → SIMULATION → Run Simulation

2\. Click "Run Behavioral Simulation"

3\. Vivado opens simulation window

4\. In Tcl Console (bottom): type → run 2000ns → Enter



\---



\## PART 6: ADD SIGNALS TO WAVEFORM



1\. Scope panel → click "alu\_tb"

2\. Objects panel → hold Ctrl → click these signals:

&#x20;    en

&#x20;    A\[7:0]

&#x20;    B\[7:0]

&#x20;    opcode\[3:0]

&#x20;    result\[7:0]

&#x20;    zero\_flag

&#x20;    carry\_flag

&#x20;    overflow\_flag

&#x20;    negative\_flag

3\. Right-click selected → "Add to Wave Window"

4\. Tcl Console → type: restart → Enter

5\. Tcl Console → type: run 2000ns → Enter

6\. Press F key → zoom to fit



\---



\## PART 7: FORMAT WAVEFORM



Right-click A\[7:0], B\[7:0], result\[7:0]:

&#x20; → Radix → Hexadecimal



Right-click opcode\[3:0]:

&#x20; → Radix → Binary



\---



\## PART 8: SAVE WAVEFORM



Ctrl+S → save as: simulation/alu\_wave.wcfg

Take screenshot → save to: waveforms/waveform\_full.png



\---



\## PART 9: RUN SYNTHESIS



1\. Flow Navigator → SYNTHESIS → Run Synthesis

2\. Wait 2-5 minutes

3\. Dialog appears → Select "Open Synthesized Design" → OK



\---



\## PART 10: VIEW SCHEMATIC



Top menu → Tools → Schematic

Screenshot → save to: reports/schematic.png



Shows: 139 Cells | 35 I/O Ports | 190 Nets



\---



\## PART 11: UTILIZATION REPORT



Top menu → Reports → Report Utilization → OK



Key numbers:

&#x20; Slice LUTs: 70 (1%)

&#x20; Slice Registers: 0

&#x20; DSPs: 0

&#x20; BRAMs: 0



Screenshot → save to: reports/utilization\_report.png



\---



\## PART 12: POWER REPORT



Top menu → Reports → Report Power → OK (default settings)



Key numbers:

&#x20; Total On-Chip Power: 3.307 W

&#x20; Dynamic Power: 3.228 W (98%)

&#x20; Logic Power: 0.353 W (11%)

&#x20; I/O Power: 2.552 W (79%)

&#x20; Device Static: 0.080 W (2%)

&#x20; Confidence: Low (normal without switching activity file)



Screenshot → save to: reports/power\_report.png



\---



\## PART 13: CLOSE SIMULATION (to free memory)



Flow Navigator → SIMULATION → Close Simulation



\---



\## TCL QUICK REFERENCE



| Command | Action |

|---------|--------|

| run 2000ns | Run simulation 2000 nanoseconds |

| restart | Reset to time 0 |

| run -all | Run until $finish |

| report\_utilization | Print utilization in console |

| report\_power | Print power in console |



\---



\## COMMON ERRORS IN VIVADO 2024.2



ERROR: "No top module found"

FIX: Right-click alu\_tb in Sources → Set as Top



ERROR: Waveform blank after run

FIX: Add signals first → then restart → then run 2000ns



ERROR: Synthesis fails with constraint errors

FIX: Skip .xdc file if no FPGA — only needed for hardware



ERROR: "timescale not found"

FIX: Check alu\_tb.v starts with `timescale 1ns/1ps



\---



\## SCREENSHOTS CHECKLIST



\- \[ ] waveforms/waveform\_full.png

\- \[ ] reports/schematic.png

\- \[ ] reports/utilization\_report.png

\- \[ ] reports/power\_report.png

