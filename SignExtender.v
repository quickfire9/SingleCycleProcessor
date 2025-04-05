`timescale 1ns / 1ps

module SignExtender(BusImm, Imm26, Ctrl); 
   output reg [63:0] BusImm; 
   input [25:0]  Imm26; 
   input [1:0] Ctrl; 
   
   wire 	 extBit; 



   parameter branch = 2'b00;
   parameter i_type = 2'b01;
   parameter d_type = 2'b10;
   parameter CB = 2'b11;


   always @(*) begin
      
   
   case (Ctrl)
      branch: BusImm = {{36{Imm26[25]}}, Imm26[22:0], 2'b0};

      i_type: BusImm = {52'b0, Imm26[21:10]};

      d_type: BusImm =  {{55{Imm26[20]}}, Imm26[20:12]};

      CB: BusImm = {{43{Imm26[23]}}, Imm26[23:5], 2'b0};


   endcase


   
   end
   
   
endmodule
