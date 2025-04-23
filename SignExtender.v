`timescale 1ns / 1ps

module SignExtender(BusImm, Imm26, Ctrl); 
   output reg [63:0] BusImm; 
   input [25:0]  Imm26; 
   input [2:0] Ctrl; 
   
   wire 	 extBit; 



   parameter branch = 3'b000;
   parameter i_type = 3'b001;
   parameter d_type = 3'b010;
   parameter CB = 3'b011;
   parameter MOVZ = 3'b100;


   always @(*) begin
      
   
   case (Ctrl)
      branch: BusImm = {{38{Imm26[25]}}, Imm26[25:0]};

      i_type: BusImm = {{52{Imm26[21]}}, Imm26[21:10]};

      d_type: BusImm =  {{55{Imm26[20]}}, Imm26[20:12]};

      CB: BusImm = {{45{Imm26[23]}}, Imm26[23:5]}; //changed

      MOVZ: BusImm = {{48'b0}, Imm26[20:5]} << (Imm26[22:21] * 16); 


   endcase


   
   end
   
   
endmodule
