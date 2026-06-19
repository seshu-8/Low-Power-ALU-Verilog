# ============================================================
# Constraints File: Low-Power ALU - Basys3 FPGA Board
# File: constraints/alu_basys3.xdc
# ============================================================
# SWITCH MAPPING:
#   SW[7:0]  → Operand A (8-bit)
#   SW[7:0]  → Operand B (shared, via btn select — simplified)
#   BTN[3:0] → Opcode (4-bit)
#   SW[15]   → Enable (power-save toggle)
#
# LED MAPPING:
#   LED[7:0] → ALU Result
#   LED[12]  → Zero Flag
#   LED[13]  → Carry Flag
#   LED[14]  → Overflow Flag
#   LED[15]  → Negative Flag
# ============================================================

# --- Clock ---
set_property PACKAGE_PIN W5       [get_ports clk]
set_property IOSTANDARD  LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# --- Reset (active low, BTNC) ---
set_property PACKAGE_PIN U18      [get_ports rst_n]
set_property IOSTANDARD  LVCMOS33 [get_ports rst_n]

# --- Enable Signal (SW15) ---
set_property PACKAGE_PIN R2       [get_ports en]
set_property IOSTANDARD  LVCMOS33 [get_ports en]

# --- Operand A: SW[7:0] ---
set_property PACKAGE_PIN V17 [get_ports {A[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[0]}]
set_property PACKAGE_PIN V16 [get_ports {A[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[1]}]
set_property PACKAGE_PIN W16 [get_ports {A[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[2]}]
set_property PACKAGE_PIN W17 [get_ports {A[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[3]}]
set_property PACKAGE_PIN W15 [get_ports {A[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[4]}]
set_property PACKAGE_PIN V15 [get_ports {A[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[5]}]
set_property PACKAGE_PIN W14 [get_ports {A[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[6]}]
set_property PACKAGE_PIN W13 [get_ports {A[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {A[7]}]

# --- Operand B: SW[15:8] ---
set_property PACKAGE_PIN V2  [get_ports {B[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[0]}]
set_property PACKAGE_PIN T3  [get_ports {B[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[1]}]
set_property PACKAGE_PIN T2  [get_ports {B[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[2]}]
set_property PACKAGE_PIN R3  [get_ports {B[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[3]}]
set_property PACKAGE_PIN W2  [get_ports {B[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[4]}]
set_property PACKAGE_PIN U1  [get_ports {B[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[5]}]
set_property PACKAGE_PIN T1  [get_ports {B[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[6]}]
set_property PACKAGE_PIN R2  [get_ports {B[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B[7]}]

# --- Opcode: BTNL/BTNR/BTNU/BTND ---
set_property PACKAGE_PIN W19 [get_ports {opcode[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {opcode[0]}]
set_property PACKAGE_PIN T17 [get_ports {opcode[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {opcode[1]}]
set_property PACKAGE_PIN T18 [get_ports {opcode[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {opcode[2]}]
set_property PACKAGE_PIN U17 [get_ports {opcode[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {opcode[3]}]

# --- Result Output: LED[7:0] ---
set_property PACKAGE_PIN U16 [get_ports {result[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[0]}]
set_property PACKAGE_PIN E19 [get_ports {result[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[1]}]
set_property PACKAGE_PIN U19 [get_ports {result[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[2]}]
set_property PACKAGE_PIN V19 [get_ports {result[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[3]}]
set_property PACKAGE_PIN W18 [get_ports {result[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[4]}]
set_property PACKAGE_PIN U15 [get_ports {result[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[5]}]
set_property PACKAGE_PIN U14 [get_ports {result[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[6]}]
set_property PACKAGE_PIN V14 [get_ports {result[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {result[7]}]

# --- Flags: LED[15:12] ---
set_property PACKAGE_PIN V3  [get_ports zero_flag];     set_property IOSTANDARD LVCMOS33 [get_ports zero_flag]
set_property PACKAGE_PIN V13 [get_ports carry_flag];    set_property IOSTANDARD LVCMOS33 [get_ports carry_flag]
set_property PACKAGE_PIN V12 [get_ports overflow_flag]; set_property IOSTANDARD LVCMOS33 [get_ports overflow_flag]
set_property PACKAGE_PIN V11 [get_ports negative_flag]; set_property IOSTANDARD LVCMOS33 [get_ports negative_flag]
