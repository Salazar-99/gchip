module tb ();
  logic clk;
  logic reset;
  logic [31:0] WriteData;
  logic [31:0] DataAdr;
  logic MemWrite;

  // Device Under Test (DUT)
  top dut (
      .clk,
      .reset,
      .WriteData,
      .DataAdr,
      .MemWrite
  );

  // Waveform dump: everything under `tb` (depth = 0 means unlimited).
  initial begin
    $dumpfile("waves/dump.vcd");
    $dumpvars(0, tb);
  end

  // Per-cycle text trace: printed on the falling edge so signals are stable.
  // Handy alongside the VCD when correlating PC -> instruction.
  always @(negedge clk) begin
    $display("t=%0t  PC=%08h  Instr=%08h  MemWrite=%b  DataAdr=%08h  WriteData=%08h",
             $time, dut.PC, dut.Instr, MemWrite, DataAdr, WriteData);
  end

  // Reset everything
  initial begin
    reset = 1;
    #22;
    reset = 0;
  end

  // Generate clock signal
  always 
  begin
    clk <= 1;
    #5;
    clk <= 0;
    #5;
  end

  // Check results. Use $finish (not $stop) so Verilator flushes the VCD
  // and returns cleanly instead of aborting mid-write.
  always @(negedge clk)
    begin
        if(MemWrite) begin
            if (DataAdr === 100 & WriteData === 25) begin
                $display("Success");
                $finish;
            end else if (DataAdr !== 96) begin
                $display("Failure at t=%0t: DataAdr=%0d WriteData=%0d", $time, DataAdr, WriteData);
                $finish;
            end
        end
    end

  // Safety net: if neither Success nor Failure fires, don't run forever.
  initial begin
    #10000;
    $display("Timeout: no store to expected address within 10000 time units");
    $finish;
  end

endmodule
