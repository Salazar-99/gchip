module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    // TODO: alucontrol[2] is reserved for future ops (SLT, XOR, shifts, ...).
    // Only [1:0] is decoded today (add/sub/and/or). Remove waiver once bit 2
    // is wired into the op mux.
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic [ 2:0] alucontrol,
    /* verilator lint_on UNUSEDSIGNAL */
    output logic [31:0] result,
    output logic        zero
);

  logic [31:0] and_result;
  logic [31:0] or_result;
  logic [31:0] sum;
  logic [31:0] difference;

  assign and_result = a & b;
  assign or_result  = a | b;
  assign sum        = a + b;
  assign difference = a - b;

  mux4 #(32) outputmux (
      .d0(sum),
      .d1(difference),
      .d2(and_result),
      .d3(or_result),
      .s (alucontrol[1:0]),
      .y (result)
  );

  assign zero = (result == 32'b0);

endmodule
