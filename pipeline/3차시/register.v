// `define DEBUG_CPU_REG 0
module Register(
		input wire CLK,
		input wire RegWrite, // control signal
		input wire [4:0] Rreg_addr1, Rreg_addr2,
		input wire [4:0] Wreg_addr,
		input wire [31:0] Wdata,
		output reg [31:0] Rdata1, Rdata2 );

reg [31:0] mem [0:31];  // 32-bit memory with 32 entries

initial
begin
	// $display("$v0, $v1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7");
	//$monitor("%b, %b, %b, %b, %b, %b, %b, %b, %b, %b",
		//mem[0][31:0],		/* $zero */
		//mem[16][31:0],	/* $s0 */
		//mem[17][31:0],	/* $s1 */
		//mem[18][31:0],	/* $s2 */
		//mem[19][31:0],	/* $s3 */
		//mem[20][31:0],	/* $s4 */
		//mem[21][31:0],	/* $s5 */
		//mem[22][31:0],	/* $s6 */
		//mem[23][31:0]		/* $s7 */
		//);
	mem[0] = 32'd0; // $zero = 0;
	mem[1] = 32'd0;
	mem[2] = 32'd0;
	mem[3] = 32'd0;
	mem[4] = 32'd0;
	mem[5] = 32'd0;
	mem[6] = 32'd0;
	mem[7] = 32'd0;
	mem[8] = 32'd0;
	mem[9] = 32'd0;
	mem[10] = 32'd0;
	mem[11] = 32'd0;
	mem[12] = 32'd0;
	mem[13] = 32'd0;
	mem[14] = 32'd0;
	mem[15] = 32'd0;
	mem[16] = 32'd0;
	mem[17] = 32'd0;
	mem[18] = 32'd0;
	mem[19] = 32'd0;
	mem[20] = 32'd0;
	mem[21] = 32'd0;
	mem[22] = 32'd0;
	mem[23] = 32'd0;
	mem[24] = 32'd0;
	mem[25] = 32'd0;
	mem[26] = 32'd0;
	mem[27] = 32'd0;
	mem[28] = 32'd0;
	mem[29] = 32'd0;
	mem[30] = 32'd0;
	mem[31] = 32'd0;
end

always @(*)
begin
	if (Rreg_addr1 == 5'd0) // $zero
		Rdata1 = 32'd0;
	else if (Rreg_addr1 == Wreg_addr & RegWrite)
		Rdata1 = Wdata;
	else
		Rdata1 = mem[Rreg_addr1];
end

always @(*)
begin
	if (Rreg_addr2 == 5'd0) // $zero
		Rdata2 = 32'd0;
	else if (Rreg_addr2 == Wreg_addr & RegWrite)
		Rdata2 = Wdata;
	else
		Rdata2 = mem[Rreg_addr2];
end

always @(posedge CLK)
begin
	if (RegWrite && Wreg_addr != 5'd0) // $zero can not be changed.
	begin
		// write a non $zero register
		mem[Wreg_addr] <= Wdata;

	end
end
endmodule
