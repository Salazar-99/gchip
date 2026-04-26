// Simple self-checking testbench for the 32-bit adder.
// Drives a handful of directed vectors plus randomized stimulus and dumps
// a VCD that can be opened with `make wave`.
`timescale 1ns/1ps

module adder_tb;

    localparam int WIDTH = 32;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic             cin;
    logic [WIDTH-1:0] sum;
    logic             cout;

    int errors = 0;

    adder #(.WIDTH(WIDTH)) dut (
        .a   (a),
        .b   (b),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );

    task automatic check(input [WIDTH-1:0] ea,
                         input [WIDTH-1:0] eb,
                         input             ecin);
        logic [WIDTH:0] expected;
        begin
            a   = ea;
            b   = eb;
            cin = ecin;
            #1;
            expected = {1'b0, ea} + {1'b0, eb} + {{WIDTH{1'b0}}, ecin};
            if ({cout, sum} !== expected) begin
                $display("[FAIL] a=%h b=%h cin=%0b -> got {cout,sum}=%h, exp=%h",
                         ea, eb, ecin, {cout, sum}, expected);
                errors++;
            end else begin
                $display("[ OK ] a=%h b=%h cin=%0b -> sum=%h cout=%0b",
                         ea, eb, ecin, sum, cout);
            end
        end
    endtask

    initial begin
        $dumpfile("waves/dump.vcd");
        $dumpvars(0, adder_tb);

        check(32'h0000_0000, 32'h0000_0000, 1'b0);
        check(32'h0000_0001, 32'h0000_0001, 1'b0);
        check(32'hFFFF_FFFF, 32'h0000_0001, 1'b0);  // overflow -> cout
        check(32'hFFFF_FFFF, 32'h0000_0000, 1'b1);  // cin overflow
        check(32'hDEAD_BEEF, 32'h1111_1111, 1'b0);
        check(32'h7FFF_FFFF, 32'h0000_0001, 1'b0);  // signed overflow boundary

        for (int i = 0; i < 64; i++) begin
            check($urandom(), $urandom(), 1'($urandom_range(0, 1)));
        end

        if (errors == 0)
            $display("PASS: all adder vectors matched");
        else
            $display("FAIL: %0d mismatches", errors);

        $finish;
    end

endmodule
