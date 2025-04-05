`timescale 1ns / 1ps
`define STRLEN 32

module SignExtender_tb;

    // Task to check if a test passed or failed
    task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask

    task allPassed;
        input [7:0] passed;
        input [7:0] numTests;
        
        if(passed == numTests) $display ("All tests passed");
        else $display("Some tests failed");
    endtask

    // Inputs
    reg [25:0] Imm26;
    reg [1:0] Ctrl;
    reg [7:0] passed;

    // Outputs
    wire [63:0] BusImm;

    SignExtender uut (
        .BusImm(BusImm),
        .Imm26(Imm26),
        .Ctrl(Ctrl)
    );

    initial begin
        Imm26 = 0;
        Ctrl = 0;
        passed = 0;


        // Test 1, branch
        {Imm26, Ctrl} = {26'b1010, 2'b00}; #40; passTest(BusImm, 64'b0000101000, "Branch", passed);

        // Test 2, i_type
        {Imm26, Ctrl} = {26'b11100110111101000011111001, 2'b01}; #40; passTest(BusImm, {52'b0, 12'b011011110100}, "i_type", passed);

        // Test 3, d_type
        {Imm26, Ctrl} = {26'b11101110111101000011111001, 2'b10}; #40; passTest(BusImm, {{55{1'b1}}, 9'b110111101}, "d_type", passed);

        // Test 4, cb
        {Imm26, Ctrl} = {26'b11101110111101000011111001, 2'b11}; #40; passTest(BusImm, {{43{1'b1}}, 19'b1011101111010000111, 2'b0}, "cb", passed);

        allPassed(passed, 4);
    end

endmodule