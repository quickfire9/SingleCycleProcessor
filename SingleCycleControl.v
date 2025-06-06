`define OPCODE_ANDREG 11'b?0001010??? // "?" means dont care bit
`define OPCODE_ORRREG 11'b?0101010???
`define OPCODE_ADDREG 11'b?0?01011???
`define OPCODE_SUBREG 11'b?1?01011???

`define OPCODE_ADDIMM 11'b?0?10001???
`define OPCODE_SUBIMM 11'b?1?10001???

`define OPCODE_MOVZ   11'b110100101??

`define OPCODE_B      11'b?00101?????
`define OPCODE_CBZ    11'b?011010????

`define OPCODE_LDUR   11'b??111000010
`define OPCODE_STUR   11'b??111000000

module control(
	       output reg 	reg2loc, // ??
	       output reg 	alusrc, // need alu?
	       output reg 	mem2reg, // STUR instrutcion
	       output reg 	regwrite, // write to register
	       output reg 	memread, // need to read from memory
	       output reg 	memwrite, //is STUR instruction
	       output reg 	branch, //is branch
	       output reg 	uncond_branch, //is unconditional branch
	       output reg [3:0] aluop, //alu op code input || "ALUCtrl" in ALU.v
	       output reg [2:0] signop, // for r type it is always 0'bxx
	       input [10:0] 	opcode //input, the opcode
	       );

   always @(*)
     begin
	casez (opcode)
          `OPCODE_ANDREG:begin
               reg2loc = 0;
               uncond_branch = 0;
               branch = 0;
               memread = 0;
               mem2reg = 0;
               memwrite = 0;
               alusrc = 0;
               regwrite = 1;
               aluop = 4'b0000;
               signop = 2'bxx;
          end
          `OPCODE_ORRREG:begin
               reg2loc = 0;
               uncond_branch = 0;
               branch = 0;
               memread = 0;
               mem2reg = 0;
               memwrite = 0;
               alusrc = 0;
               regwrite = 1;
               aluop = 4'b0001;
               signop = 2'bxx;
          end
          `OPCODE_ADDREG:begin
               reg2loc = 0;
               uncond_branch = 0;
               branch = 0;
               memread = 0;
               mem2reg = 0;
               memwrite = 0;
               alusrc = 0;
               regwrite = 1;
               aluop = 4'b0010;
               signop = 2'bxx;
          end
          `OPCODE_SUBREG:begin
               reg2loc = 0;
               uncond_branch = 0;
               branch = 0;
               memread = 0;
               mem2reg = 0;
               memwrite = 0;
               alusrc = 0;
               regwrite = 1;
               aluop = 4'b0110;
               signop = 2'bxx;
          end
          `OPCODE_ADDIMM:begin
               reg2loc = 1'bx;
               uncond_branch = 0;
               branch = 0;
               memread = 0;
               mem2reg = 0;
               memwrite = 0;
               alusrc = 1;
               regwrite = 1;
               aluop = 4'b0010;
               signop = 2'b01;
          end
          `OPCODE_SUBIMM:begin
               reg2loc = 1'bx;
               uncond_branch = 0;
               branch = 0;
               memread = 0;
               mem2reg = 0;
               memwrite = 0;
               alusrc = 1;
               regwrite = 1;
               aluop = 4'b0110;
               signop = 2'b01;
          end
          `OPCODE_MOVZ:begin //??
               reg2loc = 1'bx;
               alusrc = 1'b1; //good
               mem2reg = 1'b0; //good
               regwrite = 1'b1;
               memread = 1'b0;
               memwrite = 1'b0;
               branch = 1'b0;
               uncond_branch = 1'b0;
               aluop = 4'b0111;
               signop = 3'b100;
          end
          `OPCODE_B:begin
               reg2loc = 1'bx;
               uncond_branch = 1;
               branch = 1'bx;
               memread = 0;
               mem2reg = 1'bx;
               memwrite = 0;
               alusrc = 1'bx;
               regwrite = 0;
               aluop = 4'bxxxx;
               signop = 2'b00;
          end
          `OPCODE_CBZ:begin
               reg2loc = 1'b1;
               uncond_branch = 0;
               branch = 1'b1;
               memread = 0;
               mem2reg = 1'bx;
               memwrite = 0;
               alusrc = 1'b0;
               regwrite = 0;
               aluop = 4'b0111;
               signop = 2'b11;
          end
          `OPCODE_LDUR:begin
               reg2loc = 1'bx;
               uncond_branch = 0;
               branch = 1'b0;
               memread = 1;
               mem2reg = 1'b1;
               memwrite = 0;
               alusrc = 1'b1;
               regwrite = 1;
               aluop = 4'b0010;
               signop = 2'b10;
          end
          `OPCODE_STUR:begin
               reg2loc = 1'b1;
               uncond_branch = 0;
               branch = 1'b0;
               memread = 0;
               mem2reg = 1'bx;
               memwrite = 1;
               alusrc = 1'b1;
               regwrite = 0;
               aluop = 4'b0010;
               signop = 2'b10;
          end

          default:
            begin
               reg2loc       = 1'bx;
               alusrc        = 1'bx;
               mem2reg       = 1'bx;
               regwrite      = 1'b0;
               memread       = 1'b0;
               memwrite      = 1'b0;
               branch        = 1'b0;
               uncond_branch = 1'b0;
               aluop         = 4'bxxxx;
               signop        = 2'bxx;
            end
	endcase
     end

endmodule

