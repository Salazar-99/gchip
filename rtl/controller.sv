module controller (
    // Instruction
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,

    // Datapath
    input  logic       Zero,
    output logic [1:0] ResultSrc,
    output logic       MemWrite,
    output logic       PCSrc,
    output logic       ALUSrc,
    output logic       RegWrite,
    output logic       Jump,
    output logic [1:0] ImmSrc,
    output logic [2:0] ALUControl
);

  logic [1:0] ALUOp;
  logic Branch;

  maindecoder md (
      .op,
      .ResultSrc,
      .MemWrite,
      .Branch,
      .ALUSrc,
      .RegWrite,
      .Jump,
      .ImmSrc,
      .ALUOp
  );

  aludecoder ad (
      .opb5    (op[5]),
      .funct3,
      .funct7b5,
      .ALUOp,
      .ALUControl
  );

  assign PCSrc = Branch & Zero | Jump;

endmodule
