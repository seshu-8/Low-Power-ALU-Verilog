// ============================================================
// Project  : Low-Power ALU Design
// Module   : alu_top
// Author   : Seshu
// Description:
//   Parameterized 8-bit ALU with 11 operations.
//   Low-power concept: operand isolation via enable signal.
//   When en=0, inputs are gated to zero → no switching activity.
// ============================================================

module alu_top #(
    parameter WIDTH = 8     // Parameterized bit-width; change to 4 or 16 easily
)(
    input  wire             clk,        // Clock (used for registered output variant)
    input  wire             rst_n,      // Active-low reset
    input  wire             en,         // Enable: LOW = power-save mode (operand isolation)
    input  wire [WIDTH-1:0] A,          // Operand A
    input  wire [WIDTH-1:0] B,          // Operand B
    input  wire [3:0]       opcode,     // 4-bit opcode → 16 possible operations (11 used)

    output reg  [WIDTH-1:0] result,     // ALU result output
    output reg              zero_flag,  // 1 if result == 0
    output reg              carry_flag, // 1 if arithmetic carry/borrow occurred
    output reg              overflow_flag, // 1 if signed overflow occurred
    output reg              negative_flag  // 1 if result MSB is 1 (negative in 2's complement)
);

// ----------------------------------------------------------------
// LOW-POWER OPERAND ISOLATION
// When en=0, isolated_A and isolated_B are forced to 0.
// This prevents unnecessary toggle activity inside ALU logic.
// ----------------------------------------------------------------
wire [WIDTH-1:0] isolated_A = en ? A : {WIDTH{1'b0}};
wire [WIDTH-1:0] isolated_B = en ? B : {WIDTH{1'b0}};

// ----------------------------------------------------------------
// Intermediate signals for carry/overflow detection
// ----------------------------------------------------------------
reg [WIDTH:0] temp;   // One extra bit to capture carry

// ----------------------------------------------------------------
// OPCODE TABLE
// 0000 = ADD
// 0001 = SUB
// 0010 = AND
// 0011 = OR
// 0100 = XOR
// 0101 = NOT A
// 0110 = Shift Left  (A << 1)
// 0111 = Shift Right (A >> 1)
// 1000 = Increment A (A + 1)
// 1001 = Decrement A (A - 1)
// 1010 = Compare A and B (sets flags; result = 0 if equal)
// ----------------------------------------------------------------

always @(*) begin
    // Default outputs
    result        = {WIDTH{1'b0}};
    zero_flag     = 1'b0;
    carry_flag    = 1'b0;
    overflow_flag = 1'b0;
    negative_flag = 1'b0;
    temp          = {(WIDTH+1){1'b0}};

    if (en) begin
        case (opcode)

            // ---- ARITHMETIC OPERATIONS ----

            4'b0000: begin // ADD
                temp          = {1'b0, isolated_A} + {1'b0, isolated_B};
                result        = temp[WIDTH-1:0];
                carry_flag    = temp[WIDTH];
                // Signed overflow: both same sign, result different sign
                overflow_flag = (~isolated_A[WIDTH-1] & ~isolated_B[WIDTH-1] & result[WIDTH-1]) |
                                ( isolated_A[WIDTH-1] &  isolated_B[WIDTH-1] & ~result[WIDTH-1]);
            end

            4'b0001: begin // SUB (A - B using 2's complement)
                temp          = {1'b0, isolated_A} - {1'b0, isolated_B};
                result        = temp[WIDTH-1:0];
                carry_flag    = temp[WIDTH]; // borrow flag
                overflow_flag = ( isolated_A[WIDTH-1] & ~isolated_B[WIDTH-1] & ~result[WIDTH-1]) |
                                (~isolated_A[WIDTH-1] &  isolated_B[WIDTH-1] &  result[WIDTH-1]);
            end

            4'b1000: begin // INCREMENT A
                temp       = {1'b0, isolated_A} + 1;
                result     = temp[WIDTH-1:0];
                carry_flag = temp[WIDTH];
            end

            4'b1001: begin // DECREMENT A
                temp       = {1'b0, isolated_A} - 1;
                result     = temp[WIDTH-1:0];
                carry_flag = temp[WIDTH];
            end

            // ---- LOGIC OPERATIONS ----

            4'b0010: result = isolated_A & isolated_B; // AND
            4'b0011: result = isolated_A | isolated_B; // OR
            4'b0100: result = isolated_A ^ isolated_B; // XOR
            4'b0101: result = ~isolated_A;             // NOT A (bitwise invert)

            // ---- SHIFT OPERATIONS ----

            4'b0110: begin // SHIFT LEFT LOGICAL (×2)
                result     = isolated_A << 1;
                carry_flag = isolated_A[WIDTH-1]; // MSB shifted out
            end

            4'b0111: begin // SHIFT RIGHT LOGICAL (÷2)
                result     = isolated_A >> 1;
                carry_flag = isolated_A[0]; // LSB shifted out
            end

            // ---- COMPARE OPERATION ----

            4'b1010: begin // COMPARE A vs B (result=0, flags tell the story)
                temp   = {1'b0, isolated_A} - {1'b0, isolated_B};
                result = {WIDTH{1'b0}}; // Result is 0 (compare doesn't store)
                // zero_flag=1 → A == B  | carry_flag=1 → A < B
                carry_flag = temp[WIDTH];
            end

            default: result = {WIDTH{1'b0}}; // Safety: unknown opcode = 0
        endcase

        // ---- COMMON FLAG GENERATION ----
        zero_flag     = (result == {WIDTH{1'b0}}) ? 1'b1 : 1'b0;
        negative_flag = result[WIDTH-1]; // MSB = sign bit in 2's complement

    end
    // If en=0: all outputs remain 0 (power-save, no toggling)
end

endmodule
