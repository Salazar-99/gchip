module cpu (
    input  logic        clk,
    input  logic        reset,

    // Instruction memory
    output logic [31:0] PC,
    input  logic [31:0] Instr,

    // Data memory
    output logic        MemWrite,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData
);

  logic       ALUSrc, RegWrite, Zero, PCSrc;
  logic [1:0] ResultSrc, ImmSrc;
  logic [2:0] ALUControl;

  // TODO: Jump is produced by the controller but not yet consumed by the
  // datapath (JAL/JALR support is pending). Remove waiver once wired in.
  /* verilator lint_off UNUSEDSIGNAL */
  logic Jump;
  /* verilator lint_on UNUSEDSIGNAL */

  controller c (
      .op       (Instr[6:0]),
      .funct3   (Instr[14:12]),
      .funct7b5 (Instr[30]),
      .Zero,
      .ResultSrc,
      .MemWrite,
      .PCSrc,
      .ALUSrc,
      .RegWrite,
      .Jump,
      .ImmSrc,
      .ALUControl
  );

  datapath dp (
      .clk,
      .reset,
      .ResultSrc,
      .PCSrc,
      .ALUSrc,
      .RegWrite,
      .ImmSrc,
      .ALUControl,
      .Zero,
      .PC,
      .Instr,
      .ALUResult,
      .WriteData,
      .ReadData
  );

endmodule
