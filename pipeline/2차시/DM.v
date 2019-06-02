module Data_Mem(
	input CLK,
	input wire MemWrite, MemRead, // control signal
	input wire [6:0] addr,
	input wire [31:0] Write_Data,
	output reg [31:0] Read_Data );

reg [31:0] mem [0:127];  // 32-bit memory with 128 entries

always @(*)
begin
	if(MemWrite == 0 && MemRead == 1) // lw
		Read_Data = mem[addr][31:0];
	else
		Read_Data = Read_Data; // To avoid creating a latch
end

always @(posedge CLK)
begin
	if(MemWrite == 1) // sw
		mem[addr][31:0] <= Write_Data;
end

integer i;
initial
begin
	mem[0] = 32'd0; // initialize
	mem[1] = 32'd1; // initialize
	mem[2] = 32'd2; // initialize
	mem[3] = 32'd3; // initialize
	mem[4] = 32'd4; // initialize
	mem[5] = 32'd5; // initialize
	mem[6] = 32'd6; // initialize
	mem[7] = 32'd7; // initialize
	mem[8] = 32'd8; // initialize
	mem[9] = 32'd9; // initialize
	mem[10] = 32'b0101_0101_1010_1010_0101_0101_1010_1010; // 0x55aa_55aa
	mem[11] = 32'b0111_0111_1000_1000_0111_0111_1000_1000; // 0x7788_7788
	for (i=12; i<128; i = i+1) // initialize
	begin
		mem[i] = 32'd0;
	end
end
endmodule
