// Simple 32-bit ripple-style adder with carry-in / carry-out.
// Combinational: sum = a + b + cin, {cout, sum} captures the 33-bit result.
`timescale 1ns/1ps

module adder #(
    parameter int WIDTH = 32
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);

    assign {cout, sum} = {1'b0, a} + {1'b0, b} + {{WIDTH{1'b0}}, cin};

endmodule
