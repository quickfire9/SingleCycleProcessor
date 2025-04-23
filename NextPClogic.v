// Branch - true if the current instruction is a conditional branch instruction
// Uncondbranch - true if the current instruction is an Unconditional Branch (B)
// ALUZero - Zero output of the ALU


module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
   input [63:0] CurrentPC, SignExtImm64; 
   input 	Branch, ALUZero, Uncondbranch; 
   output reg [63:0] NextPC; 
   reg [63:0] tempImm64;



   always@(*) begin
      tempImm64 = SignExtImm64 << 2;
      if (Uncondbranch || (Branch && ALUZero)) begin
         NextPC = CurrentPC + tempImm64;
      end else begin
         NextPC = CurrentPC + 4;
      end 
      
   end


endmodule
