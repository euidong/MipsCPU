module Control(
		input wire [5:0] Opcode1, Funct1,
		output reg JtoPC1, Branch1, RegWrite1, RegDst1, ALUSrc1, MemWrite1, MemRead1, MemtoReg1,
		output reg [3:0] ALUOp1 );

always @(*)
begin
	case (Opcode1)
		6'b000000 : begin // R Type - add, sub, and, or, mult, xor, nor, slt, Noop
			if(Funct1 == 6'b000000) //Noop
			begin
				JtoPC1 = 0;
				Branch1 = 0;
				RegWrite1 = 0;
				RegDst1 = 0;
				ALUSrc1 = 0;
				MemWrite1 = 0;
				MemRead1 = 0;
				MemtoReg1 = 0;
				ALUOp1 = 4'b0000;
			end
			else // add, sub, and, or, mult, xor, nor, slt
			begin
				JtoPC1 = 0;
				Branch1 = 0;
				RegWrite1 = 1;
				RegDst1 = 1;
				ALUSrc1 = 0;
				MemWrite1 = 0;
				MemRead1 = 0;
				MemtoReg1 = 0;
				if(Funct1 == 6'b100000)	ALUOp1 = 4'b0001; // add
				else if(Funct1 == 6'b100010) ALUOp1 = 4'b0010; // sub
				else if(Funct1 == 6'b100100) ALUOp1 = 4'b0011; // and
				else if(Funct1 == 6'b100101) ALUOp1 = 4'b0100; // or
				else if(Funct1 == 6'b011000) ALUOp1 = 4'b0101; // mult
				else if(Funct1 == 6'b100110) ALUOp1 = 4'b0110; // xor
				else if(Funct1 == 6'b100111) ALUOp1 = 4'b0111; // nor
				else if(Funct1 == 6'b101010) ALUOp1 = 4'b1000; // slt
			end
		end
		6'b000100 : begin // Beq
			JtoPC1 = 0;
			Branch1 = 1;
			RegWrite1 = 0;
			RegDst1 = 0;
			ALUSrc1 = 1;
			MemWrite1 = 0;
			MemRead1 = 0;
			MemtoReg1 = 0;
			ALUOp1 = 4'b1001;
		end
		6'b000010 : begin// Jump
			JtoPC1 = 1;
			Branch1 = 0;
			RegWrite1 = 0;
			RegDst1 = 0;
			ALUSrc1 = 0;
			MemWrite1 = 0;
			MemRead1 = 0;
			MemtoReg1 = 0;
			ALUOp1 = 4'b1010;
		end
		6'b100011 : begin // Load Word
			JtoPC1 = 0;
			Branch1 = 0;
			RegWrite1 = 1;
			RegDst1 = 0;
			ALUSrc1 = 1;
			MemWrite1 = 0;
			MemRead1 = 1;
			MemtoReg1 = 1;
			ALUOp1 = 4'b1011;
		end
		6'b101011 : begin // Store Word
			JtoPC1 = 0;
			Branch1 = 0;
			RegWrite1 = 0;
			RegDst1 = 0;
			ALUSrc1 = 1;
			MemWrite1 = 1;
			MemRead1 = 0;
			MemtoReg1 = 0;
			ALUOp1 = 4'b1100;
		end
		default : begin //Noop
			JtoPC1 = 0;
			Branch1 = 0;
			RegWrite1 = 0;
			RegDst1 = 0;
			ALUSrc1 = 0;
			MemWrite1 = 0;
			MemRead1 = 0;
			MemtoReg1 = 0;
			ALUOp1 = 4'b0000;
		end
	endcase
end

initial
begin
	JtoPC1 = 0;
	Branch1 = 0;
	RegWrite1 = 0;
	RegDst1 = 0;
	ALUSrc1 = 0;
	MemWrite1 = 0;
	MemRead1 = 0;
	MemtoReg1 = 0;
	ALUOp1 = 4'b0000;
end
endmodule
