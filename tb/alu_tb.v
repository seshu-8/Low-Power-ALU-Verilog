// ============================================================
// Project  : Low-Power ALU Design
// Module   : alu_tb (Testbench)
// Author   : Seshu
// Description:
//   Tests all 11 ALU operations, flag generation,
//   enable (power-save) mode, and edge cases.
//   Compatible with: ModelSim, Vivado Simulator, EDA Playground
// ============================================================

`timescale 1ns / 1ps

module alu_tb;

    // ---- Parameters ----
    parameter WIDTH = 8;

    // ---- Testbench signals ----
    reg             clk;
    reg             rst_n;
    reg             en;
    reg  [WIDTH-1:0] A;
    reg  [WIDTH-1:0] B;
    reg  [3:0]       opcode;

    wire [WIDTH-1:0] result;
    wire             zero_flag;
    wire             carry_flag;
    wire             overflow_flag;
    wire             negative_flag;

    // ---- Instantiate DUT (Design Under Test) ----
    alu_top #(.WIDTH(WIDTH)) DUT (
        .clk          (clk),
        .rst_n        (rst_n),
        .en           (en),
        .A            (A),
        .B            (B),
        .opcode       (opcode),
        .result       (result),
        .zero_flag    (zero_flag),
        .carry_flag   (carry_flag),
        .overflow_flag(overflow_flag),
        .negative_flag(negative_flag)
    );

    // ---- Clock generation (50 MHz) ----
    initial clk = 0;
    always #10 clk = ~clk;  // 20ns period = 50 MHz

    // ---- Task: apply_test ----
    // Applies one test case and prints result vs expected
    task apply_test;
        input [WIDTH-1:0] test_A, test_B;
        input [3:0]       test_op;
        input             test_en;
        input [63:0]      expected_result;
        input [7:0]       expected_flags; // {4'bxxxx, neg, ovf, carry, zero}
        input [127:0]     test_name;

        begin
            A      = test_A;
            B      = test_B;
            opcode = test_op;
            en     = test_en;
            #20; // Wait one clock cycle

            $display("----------------------------------------------");
            $display("TEST : %0s", test_name);
            $display("  A=0x%0h  B=0x%0h  Opcode=%b  En=%b", A, B, opcode, en);
            $display("  Result   = 0x%0h (Expected: 0x%0h) %s",
                      result, expected_result[WIDTH-1:0],
                      (result == expected_result[WIDTH-1:0]) ? "PASS" : "FAIL <<<");
            $display("  ZeroFlag = %b | CarryFlag = %b | OvfFlag = %b | NegFlag = %b",
                      zero_flag, carry_flag, overflow_flag, negative_flag);
        end
    endtask

    // ---- Main test sequence ----
    initial begin
        // Waveform dump (for GTKWave or Vivado)
        $dumpfile("simulation/alu_wave.vcd");
        $dumpvars(0, alu_tb);

        // ---- Reset ----
        rst_n = 0; en = 0; A = 0; B = 0; opcode = 0;
        #30;
        rst_n = 1;
        #10;

        $display("==============================================");
        $display("   LOW-POWER ALU TESTBENCH - ALL OPERATIONS  ");
        $display("==============================================");

        // ============================================================
        // ARITHMETIC TESTS
        // ============================================================

        // ADD: 20 + 15 = 35 (0x23)
        apply_test(8'd20, 8'd15, 4'b0000, 1, 64'd35, 8'b0000_0000, "ADD: 20+15=35");

        // ADD with CARRY: 200 + 100 = 300 → 44 (carry=1)
        apply_test(8'd200, 8'd100, 4'b0000, 1, 64'd44, 8'b0000_0010, "ADD: 200+100 CARRY TEST");

        // SUB: 50 - 20 = 30 (0x1E)
        apply_test(8'd50, 8'd20, 4'b0001, 1, 64'd30, 8'b0000_0000, "SUB: 50-20=30");

        // SUB: 10 - 20 = negative result
        apply_test(8'd10, 8'd20, 4'b0001, 1, 64'd246, 8'b0000_0000, "SUB: 10-20 (negative, borrow)");

        // INCREMENT: 127 + 1 = 128
        apply_test(8'd127, 8'd0, 4'b1000, 1, 64'd128, 8'b0000_0000, "INC: 127+1=128");

        // INCREMENT: 255 + 1 = 0 (overflow wraps, carry=1)
        apply_test(8'd255, 8'd0, 4'b1000, 1, 64'd0, 8'b0000_0011, "INC: 255+1=0 WRAP+CARRY");

        // DECREMENT: 5 - 1 = 4
        apply_test(8'd5, 8'd0, 4'b1001, 1, 64'd4, 8'b0000_0000, "DEC: 5-1=4");

        // DECREMENT: 0 - 1 = 255 (borrow)
        apply_test(8'd0, 8'd0, 4'b1001, 1, 64'd255, 8'b0000_0010, "DEC: 0-1=255 BORROW");

        // ============================================================
        // LOGIC TESTS
        // ============================================================

        // AND: 0xF0 & 0x0F = 0x00 (zero flag!)
        apply_test(8'hF0, 8'h0F, 4'b0010, 1, 64'h00, 8'b0000_0001, "AND: 0xF0&0x0F=0x00 ZERO");

        // AND: 0xFF & 0xAA = 0xAA
        apply_test(8'hFF, 8'hAA, 4'b0010, 1, 64'hAA, 8'b0000_0000, "AND: 0xFF&0xAA=0xAA");

        // OR: 0xF0 | 0x0F = 0xFF
        apply_test(8'hF0, 8'h0F, 4'b0011, 1, 64'hFF, 8'b0000_1000, "OR: 0xF0|0x0F=0xFF NEG");

        // XOR: 0xFF ^ 0xFF = 0x00 (zero flag!)
        apply_test(8'hFF, 8'hFF, 4'b0100, 1, 64'h00, 8'b0000_0001, "XOR: 0xFF^0xFF=0 ZERO");

        // XOR: 0xAA ^ 0x55 = 0xFF
        apply_test(8'hAA, 8'h55, 4'b0100, 1, 64'hFF, 8'b0000_0000, "XOR: 0xAA^0x55=0xFF");

        // NOT A: ~0x00 = 0xFF
        apply_test(8'h00, 8'h00, 4'b0101, 1, 64'hFF, 8'b0000_0000, "NOT A: ~0x00=0xFF");

        // NOT A: ~0xFF = 0x00 (zero flag!)
        apply_test(8'hFF, 8'h00, 4'b0101, 1, 64'h00, 8'b0000_0001, "NOT A: ~0xFF=0 ZERO");

        // ============================================================
        // SHIFT TESTS
        // ============================================================

        // SHIFT LEFT: 0x01 << 1 = 0x02
        apply_test(8'h01, 8'h00, 4'b0110, 1, 64'h02, 8'b0000_0000, "SHL: 0x01<<1=0x02");

        // SHIFT LEFT: 0x80 << 1 = 0x00 (MSB lost → carry=1, zero=1)
        apply_test(8'h80, 8'h00, 4'b0110, 1, 64'h00, 8'b0000_0011, "SHL: 0x80<<1 MSB LOST");

        // SHIFT RIGHT: 0x80 >> 1 = 0x40
        apply_test(8'h80, 8'h00, 4'b0111, 1, 64'h40, 8'b0000_0000, "SHR: 0x80>>1=0x40");

        // SHIFT RIGHT: 0x01 >> 1 = 0x00 (LSB lost → carry=1, zero=1)
        apply_test(8'h01, 8'h00, 4'b0111, 1, 64'h00, 8'b0000_0011, "SHR: 0x01>>1 LSB LOST");

        // ============================================================
        // COMPARE TESTS
        // ============================================================

        // COMPARE: 50 == 50 → zero_flag=1
        apply_test(8'd50, 8'd50, 4'b1010, 1, 64'h00, 8'b0000_0001, "CMP: 50==50 ZERO FLAG");

        // COMPARE: 10 < 20 → carry_flag=1 (borrow)
        apply_test(8'd10, 8'd20, 4'b1010, 1, 64'h00, 8'b0000_0010, "CMP: 10<20 CARRY FLAG");

        // COMPARE: 20 > 10 → no flags set (A > B)
        apply_test(8'd20, 8'd10, 4'b1010, 1, 64'h00, 8'b0000_0000, "CMP: 20>10 NO FLAGS");

        // ============================================================
        // LOW-POWER / ENABLE TEST
        // ============================================================

        $display("==============================================");
        $display("   ENABLE=0 POWER SAVE TEST                  ");
        $display("==============================================");

        // en=0: even with valid inputs and opcode, output must be 0
        apply_test(8'hFF, 8'hFF, 4'b0000, 0, 64'h00, 8'b0000_0001, "PWR: en=0 ISOLATION");
        apply_test(8'd100, 8'd50, 4'b0001, 0, 64'h00, 8'b0000_0001, "PWR: en=0 SUB BLOCKED");

        // ============================================================
        // EDGE CASES
        // ============================================================

        // ADD zero: 0 + 0 = 0
        apply_test(8'd0, 8'd0, 4'b0000, 1, 64'd0, 8'b0000_0001, "EDGE: 0+0=0 ZERO FLAG");

        // Max values: 0xFF + 0x01 = 0x00 (carry)
        apply_test(8'hFF, 8'h01, 4'b0000, 1, 64'h00, 8'b0000_0011, "EDGE: 0xFF+1=0 CARRY");

        $display("==============================================");
        $display("   TESTBENCH COMPLETE                        ");
        $display("==============================================");

        #50;
        $finish;
    end

endmodule
