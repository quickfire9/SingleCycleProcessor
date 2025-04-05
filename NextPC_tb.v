`timescale 1ns / 1ps
`define STRLEN 32

module NextPC_tb;

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
    reg [63:0] CurrentPC, SignExtImm64; 
    reg Branch;
    reg ALUZero;
    reg Uncondbranch;
    reg [7:0] passed;

    // Outputs
    wire [63:0] NextPC;

    NextPClogic uut (
        .NextPC(NextPC),
        .CurrentPC(CurrentPC),
        .SignExtImm64(SignExtImm64),
        .Branch(Branch),
        .ALUZero(ALUZero),
        .Uncondbranch(Uncondbranch)
    );

    initial begin
        CurrentPC = 0;
        SignExtImm64 = 0;
        Branch = 0;
        ALUZero = 0;
        Uncondbranch = 0;
        passed = 0;


    
       // Test 1: No branch, no ALUZero, no unconditional branch (pc += 4, pc 10 -> pc 14)
        {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'd10, 64'd0, 1'b0, 1'b0, 1'b0}; #40; passTest(NextPC, 64'd14, "No Branch", passed);
        
        // Test 2: Unconditional branch (current 10 + 8 offset = 18)
        {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'd10, 64'd8, 1'b0, 1'b0, 1'b1}; #40; passTest(NextPC, 64'd18, "Unconditional Branch", passed);
        
        // Test 3: Conditional branch (Branch=1, ALUZero=1) (current 10 + 12 offset = 22)
        {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'd10, 64'd12, 1'b1, 1'b1, 1'b0}; #40; passTest(NextPC, 64'd22, "Conditional Branch Taken", passed);
        
        // Test 4: Conditional branch (Branch=1, ALUZero=0) (current 10, no branching, next is 14)
        {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'd10, 64'd12, 1'b1, 1'b0, 1'b0}; #40; passTest(NextPC, 64'd14, "Conditional Branch Not Taken", passed);
        
        allPassed(passed, 4);
    end

endmodule