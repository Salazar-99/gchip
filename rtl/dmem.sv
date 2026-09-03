module dmem (
    input logic clk,
    input logic we,
    // Full 32-bit address per RISC-V ISA; only [7:2] indexes this 64-word
    // memory. Upper bits are for SoC-level address decoding (no decoder
    // in this toy system), and [1:0] is the byte-in-word offset.
    /* verilator lint_off UNUSEDSIGNAL */
    input logic [31:0] a,
    /* verilator lint_on UNUSEDSIGNAL */
    input logic [31:0] wd,
    output logic [31:0] rd
);

  logic [31:0] RAM[63:0];

  assign rd = RAM[a[7:2]];

  always_ff @(posedge clk) if (we) RAM[a[7:2]] <= wd;

endmodule
