module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RW;
    input [4:0] RA;
    input [4:0] RB;
    input RegWr;
    input Clk;
    //inputs and outputs done
    reg [63:0] registers [31:0]; 

    // always @(*) begin
    // 	// 2 delay read
    // 	#2 BusA = (RA == 5'd31) ? 64'd0 : registers[RA];
    //     BusB = (RB == 5'd31) ? 64'd0 : registers[RB]; //only 1 delay insidfe always block, or second is delayed by 4 ticks instead of 2
	// end

    //both the always block and the continous assignment work 

    assign #2 BusA = (RA == 5'd31) ? 64'd0 : registers[RA];
    assign #2 BusB = (RB == 5'd31) ? 64'd0 : registers[RB];

    always @(negedge Clk) begin
    	if (RegWr && (RW != 5'd31)) begin
        	// 3 delay write
            #3 registers[RW] <= BusW;
    	end
	end
     
endmodule