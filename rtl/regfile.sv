module regfile (
    input logic clk,
    input logic [19:15] A1,
    input logic [24:20] A2,
    input logic [11:7] A3,
    input logic WE3,
    input logic [31:0] WD3,
    output logic [31:0] RD1,
    output logic [31:0] RD2
);

  logic [31:0] RAM[31:0];

  // Writes are sequential
  always_ff @(posedge clk) if (WE3) RAM[A3] <= WD3;

  // Reads are combinational but make sure not to overrwrite 0
  assign RD1 = (A1 != 5'd0) ? RAM[A1] : 32'd0;
  assign RD2 = (A2 != 5'd0) ? RAM[A2] : 32'd0;

endmodule
