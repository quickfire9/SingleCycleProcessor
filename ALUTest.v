`timescale 1ns / 1ps
`define STRLEN 32
module ALUTest_v;

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
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

		//template tests, may or may not work
		// {BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h2}; #40; passTest({Zero, BusW}, 65'h0ABCD1234, "ADD 0x1234,0xABCD0000", passed); //good
		// {BusA, BusB, ALUCtrl} = {64'hABCD0000, 64'h1234, 4'h6}; #40; passTest({Zero, BusW}, 65'h0ABCCEDCC, "SUB 0xABCD0000, 0x1234", passed); 
		// {BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h6}; #40; passTest({Zero, BusW}, {1'b0, 64'hffffffff54331234}, "SUB 0x1234, 0xABCD0000", passed); //sub negative
		// {BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h0}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "AND 0x1234,0xABCD0000", passed);
		// {BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h1}; #40; passTest({Zero, BusW}, 65'h0ABCD1234, "OR 0x1234,0xABCD0000", passed);
		// {BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h7}; #40; passTest({Zero, BusW}, 65'hABCD0000, "PASSB 0x1234,0xABCD0000", passed);

		{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h2}; #40; passTest({Zero, BusW}, 65'h0ABCD1234, "ADD1", passed);
		{BusA, BusB, ALUCtrl} = {64'h0832FAAA, 64'h1EF2, 4'h2}; #40; passTest({Zero, BusW}, 65'h833199C, "ADD2", passed);
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'h2}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "ADD3", passed);

		{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h1}; #40; passTest({Zero, BusW}, 65'hABCD1234, "OR1", passed);
		{BusA, BusB, ALUCtrl} = {64'h1234, 64'h1234, 4'h1}; #40; passTest({Zero, BusW}, 65'h1234, "OR2", passed);
		{BusA, BusB, ALUCtrl} = {64'h1234, 64'h0, 4'h1}; #40; passTest({Zero, BusW}, 65'h1234, "OR3", passed);

		{BusA, BusB, ALUCtrl} = {64'hABCD0000, 64'h1234, 4'h0}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "AND1", passed);
		{BusA, BusB, ALUCtrl} = {64'hABCD, 64'h1234, 4'h0}; #40; passTest({Zero, BusW}, 65'h0204, "AND2", passed);
		{BusA, BusB, ALUCtrl} = {64'hABCD, 64'h03BE, 4'h0}; #40; passTest({Zero, BusW}, 65'h38C, "AND3", passed);

		{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h6}; #40; passTest({Zero, BusW}, {1'b0, 64'hFFFFFFFF54331234}, "SUB1", passed);
		{BusA, BusB, ALUCtrl} = {64'hABCD0000, 64'h1234, 4'h6}; #40; passTest({Zero, BusW}, 65'hABCCEDCC, "SUB2", passed);
		{BusA, BusB, ALUCtrl} = {64'h1111, 64'h1111, 4'h6}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "SUB3", passed);

		{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD, 4'h7}; #40; passTest({Zero, BusW}, 65'hABCD, "PASSB1", passed);
		{BusA, BusB, ALUCtrl} = {64'haef4, 64'h0000, 4'h7}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "PASSB2", passed);
		{BusA, BusB, ALUCtrl} = {64'h0000, 64'h1234, 4'h7}; #40; passTest({Zero, BusW}, 65'h1234, "PASSB3", passed);

		allPassed(passed, 15);
	end
      
endmodule

