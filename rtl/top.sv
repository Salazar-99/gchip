module top (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite
);

  logic [31:0] PC;
  logic [31:0] Instr;
  logic [31:0] ReadData;

  cpu cpu (
      .clk,
      .reset,
      .PC,
      .Instr,
      .MemWrite,
      .ALUResult(DataAdr),
      .WriteData,
      .ReadData
  );

  imem imem (
      .a (PC),
      .rd(Instr)
  );

  dmem dmem (
      .clk,
      .we(MemWrite),
      .a (DataAdr),
      .wd(WriteData),
      .rd(ReadData)
  );

endmodule
