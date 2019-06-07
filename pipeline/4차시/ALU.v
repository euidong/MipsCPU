module ALU(
		input [3:0] ALUOp,
		input [31:0] a, b,
		output reg [31:0] ALUresult,
		output wire zero );

wire [31:0] sub_ab;
wire [31:0] add_ab;
wire [31:0] mult_ab;

reg slt;

assign sub_ab = a - b;
assign add_ab = a + b;
assign mult_ab = a * b;

assign zero = (sub_ab == 32'd0)? 1 : 0; // true or false

//slt 판단
always @(ALUOp == 4'b1000)
begin
	if (a < b)
		slt <= 1;
	else
		slt <= 0;
end

always @(*)
begin
	case (ALUOp)
		4'b0001  : ALUresult = add_ab;				/* add  */
		4'b0010  : ALUresult = sub_ab;				/* sub  */
		4'b0011  : ALUresult = a & b;					/* and  */
		4'b0100  : ALUresult = a | b;					/* or   */
		4'b0101  : ALUresult = mult_ab;				/* mult */
		4'b0110  : ALUresult = a ^ b;					/* xor  */
		4'b0111  : ALUresult = ~(a | b);			/* nor  */
		4'b1000  : ALUresult = {31'd0, slt};	/* slt  */
	//4'b1001  : 														/* beq  */
	//4'b1010  : 														/* jump */
		4'b1011  : ALUresult = add_ab;				/* lw   */
		4'b1100  : ALUresult = add_ab;				/* sw   */
		4'b1101  : ALUresult = add_ab;				/* addi */
		default  : ALUresult = 32'd0;					/* all  */
	endcase
end
endmodule
