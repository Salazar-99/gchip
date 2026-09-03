module datapath (
    input logic clk,
    input logic reset,

    // Controller
    input  logic [1:0] ResultSrc,
    input  logic       PCSrc,
    input  logic       ALUSrc,
    input  logic       RegWrite,
    input  logic [1:0] ImmSrc,
    input  logic [2:0] ALUControl,
    output logic       Zero,

    // Instruction memory
    output logic [31:0] PC,
    // Full 32-bit instruction word; the datapath consumes rs1/rs2/rd, funct3,
    // funct7, and the immediate fields. The opcode [6:0] is decoded by the
    // controller (see cpu.sv), not the datapath.
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic [31:0] Instr,
    /* verilator lint_on UNUSEDSIGNAL */

    // Data memory
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData
);

  logic [31:0] PCNext;
  logic [31:0] PCPlus4;
  logic [31:0] PCTarget;
  logic [31:0] ImmExt;
  logic [31:0] SrcA;
  logic [31:0] SrcB;
  logic [31:0] Result;

  // Compute next PC value
  flopr #(32) pcreg (
      .clk,
      .reset,
      .d(PCNext),
      .q(PC)
  );
  adder pcadd4 (
      .a(PC),
      .b(32'd4),
      .y(PCPlus4)
  );
  adder pcaddbranch (
      .a(PC),
      .b(ImmExt),
      .y(PCTarget)
  );
  mux2 #(32) pcmux (
      .d0(PCPlus4),
      .d1(PCTarget),
      .s (PCSrc),
      .y (PCNext)
  );

  // Register file
  regfile registerfile (
      .clk,
      .A1 (Instr[19:15]),
      .A2 (Instr[24:20]),
      .A3 (Instr[11:7]),
      .WE3(RegWrite),
      .WD3(Result),
      .RD1(SrcA),
      .RD2(WriteData)
  );

  extend ext (
      .instr (Instr[31:7]),
      .immsrc(ImmSrc),
      .immext(ImmExt)
  );

  // ALU
  alu alu (
      .a         (SrcA),
      .b         (SrcB),
      .alucontrol(ALUControl),
      .result    (ALUResult),
      .zero      (Zero)
  );

  mux2 #(32) srcbmux (
      .d0(WriteData),
      .d1(ImmExt),
      .s (ALUSrc),
      .y (SrcB)
  );

  mux3 #(32) resultmux (
      .d0(ALUResult),
      .d1(ReadData),
      .d2(PCPlus4),
      .s (ResultSrc),
      .y (Result)
  );

endmodule
