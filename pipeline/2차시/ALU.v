module ALU(
		input [3:0] ALUOp,
		input [31:0] a, b,
		output reg [31:0] ALUresult,
		output wire zero );

wire [31:0] sub_ab;
wire [31:0] add_ab;
wire [31:0] mult_ab;
wire oflow_add, oflow_sub, oflow, slt;
//reg slt;

assign zero = (ALUresult == 32'd0); // true or false
assign sub_ab = a - b;
assign add_ab = a + b;
assign mult_ab = a * b;

// overflow detection
assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0; // overflow
assign oflow_sub = (a[31] == b[31] && sub_ab[31] != a[31]) ? 1 : 0; // overflow, If the latter is greater in absolute value, oflow_sub is 1.
assign oflow = (ALUOp == 4'b0010) ? oflow_add : oflow_sub;
assign slt = oflow_sub ? ~(a[31]) : a[31];

//always @(*)
//begin
//	if (a[31] == 1'b1 && b[31] == 1'b0) slt = 1;
//	else if (a[31] == 1'b0 && b[31] == 1'b1) slt = 0;
//	else if (a[31] == b[31] && sub_ab[31] == 1'b1) slt = 1;
//	else if (a[31] == b[31] && sub_ab[31] == 1'b0) slt = 0;
//end

always @(*)
begin
	case (ALUOp)
		4'b0010  : ALUresult = add_ab;		/* add */
		4'b0000  : ALUresult = a & b;			/* and */
		4'b1000  : ALUresult = mult_ab;		/* mult */
		4'b1100  : ALUresult = ~(a | b);		/* nor */
		4'b0001  : ALUresult = a | b;			/* or */
		4'b0111  : ALUresult = {31'd0, slt};		/* slt */
		4'b0110  : ALUresult = sub_ab;		/* sub */
		4'b1101  : ALUresult = a ^ b;			/* xor */
		default  : ALUresult = 0;
	endcase
end
endmodule
