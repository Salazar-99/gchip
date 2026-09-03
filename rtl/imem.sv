module imem (
    // Full 32-bit address per RISC-V ISA; only [7:2] indexes this 64-word
    // memory. Upper bits are for SoC-level address decoding (no decoder
    // in this toy system), and [1:0] is the byte-in-word offset.
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic [31:0] a,
    /* verilator lint_on UNUSEDSIGNAL */
    output logic [31:0] rd
);

  // 64 words, 32 bits each in the RAM array
  logic [31:0] RAM[63:0];

  initial $readmemh("tb/test.txt", RAM);

  // Lookup the instruction by dividing the address by 4 by dropping the bottom two bits
  assign rd = RAM[a[7:2]];

endmodule
