module MIPS(input wire CLK);

reg [31:0] PC1;
reg reset;

/*----------------------- ALL WIRE  ---------------------- */
// stage1 : IF
wire [31:0] next_PC1;
wire [31:0] instruct1;
wire [31:0] branch_addr1;
wire [31:0] jump_addr1;
wire PCSrc1;
wire JtoPC1;

// stage2 : ID
wire [31:0] instruct2;
wire [4:0] Rreg_addr12;
wire [4:0] Rreg_addr22;
wire [4:0] Wreg_addr2;
wire [31:0] imm2;
wire [31:0] Rdata12;
wire [31:0] Rdata22;
wire [31:0] next_PC2;
wire [5:0] OP2;
wire [5:0] Funct2;
wire regDst2;
wire stall2;
wire RegWrite2;
wire flag;

// pipe로 받은 값을 잠깐 저장. (forwarding 해주기 위해 따로 저장)
wire [31:0] Rdata12_3;
wire [31:0] Rdata22_3;


//stage3 : EX

wire [31:0] next_PC3;
wire [31:0] imm3;
wire [31:0] Rdata13;
wire [31:0] Rdata23;
wire [31:0] branch_addr3;
wire [31:0] jump_addr3;
wire [4:0] Wreg_addr3;
wire [3:0] ALUOp3;
wire [31:0] ALUresult3;
wire [5:0] OP3;
wire [5:0] Funct3;
wire ALUSrc3;
wire MemRead3;
wire MemWrite3;
wire MemtoReg3;
wire RegWrite3;
wire branch3;
wire zero3;
wire PCSrc3;
wire JtoPC3;

//stage4 : MEM
wire [31:0] ALUresult4;
wire [31:0] imm4;
wire [4:0] Wreg_addr4;
wire [31:0] Mem_Rdata4;
wire [31:0] Wdata4;
wire MemRead4;
wire MemWrite4;
wire MemtoReg4;
wire RegWrite4;

//stage5 : WB
wire [4:0] Wreg_addr5;
wire [31:0] Wdata5;
wire RegWrite5;

/*----------------------- ASSIGN ---------------------- */

//stage1 : IF
assign next_PC1 = PC1 + 32'd4;

//stage2 : ID
assign OP2 = instruct2[31:26];
assign Funct2 = instruct2[5:0];
assign regDst2 = (OP2 == 6'd0); //R-type인 경우 1, I-type인 경우 0
assign Rreg_addr12 = instruct2[25:21];
assign Rreg_addr22 = instruct2[20:16];
assign Wreg_addr2 = (regDst2) ? instruct2[15:11] : instruct2[20:16];
assign imm2 = (instruct2[15] == 1) ? { 16'hFFFF, instruct2[15:0] } : { 16'h0000, instruct2[15:0] };
assign RegWrite2 = (OP2 != 6'b101011 && OP2 != 6'b000010 && OP2 != 6'b000100 && Wreg_addr2 != 5'd0); // sw, j, beg 가 아니고 $0에 데이터를 저장하려하지 않는 경우 1

//stage3 : EX
//assign Rdata13 = (RegWrite4 & (Rreg_addr12 == Wreg_addr4))? Wdata4 :(RegWrite3 & (Rreg_addr12 == Wreg_addr3)) ? ALUresult3 : Rdata12_3; //FORWARDING
assign Rdata13 = Rdata12_3;
//assign Rdata23 = ALUSrc3 ? imm3 : (RegWrite4 & (Rreg_addr22 == Wreg_addr4) & (OP3 == 6'd0)) ? Wdata4 : (RegWrite3 & (Rreg_addr22 == Wreg_addr3) & (OP3 == 6'd0))? ALUresult3 : Rdata22_3; //FORWARDING
assign Rdata23 = ALUSrc3 ? imm3 : Rdata22_3;

assign branch_addr3 = next_PC3 + {imm3[29:0], 2'd0};
assign jump_addr3 = {next_PC3[31:28], {imm3[25:0], 2'd0}};

//stage4 : MEM
assign PCSrc3 = zero3 & branch3; 
assign Wdata4 = (MemtoReg4) ? Mem_Rdata4 : ALUresult4;

//flag 판단
assign flag = (MemRead4 & stall2) | PCSrc1 | JtoPC1;



/*----------------------- pc get ---------------------- */
always @(posedge CLK)
begin
  if (stall2)
    PC1 <= next_PC1 - 32'd4;
  else if(JtoPC1)
    PC1 <= jump_addr1;
  else if (PCSrc1)
    PC1 <= branch_addr1;
  else
    PC1 <= next_PC1;
end

initial
begin
  PC1 <= 32'b1111_1111_1111_1111_1111_1111_1111_1100;
end


/*----------------------- reset ---------------------- */
always @(posedge CLK)
begin
  if (PCSrc1 | JtoPC1)
    reset <= 1;
  else
    reset <= 0;
end



/*-----------------------module 선언 ---------------------- */
Instruction_Mem im(PC1[8:2], instruct1);

Register REG(CLK, RegWrite5, Rreg_addr12, Rreg_addr22, Wreg_addr5, Wdata5 ,Rdata12, Rdata22);

//STALL 판단
Staller take (instruct1, Wreg_addr2, flag, OP2, stall2); //stall 판단

Control ctrl(OP3, Funct3, ALUSrc3, MemWrite3, MemRead3, MemtoReg3, JtoPC3, branch3, ALUOp3);

ALU alu(ALUOp3, Rdata13, Rdata23, ALUresult3, zero3);

Data_Mem dm(CLK, MemWrite4, MemRead4, ALUresult4[6:0], imm4, Mem_Rdata4);

//resetControl rst(CLK, PCSrc3_1,JtoPC3_1, PCSrc1, JtoPC1);
/*-----------------------pipe Register ---------------------- */
First_pipe pipe1(CLK, stall2, next_PC1, instruct1, next_PC2, instruct2);
Second_pipe pipe2(CLK, Wreg_addr2, imm2, Rdata12, Rdata22, next_PC2, OP2, Funct2, RegWrite2, next_PC3, OP3, Funct3, Rdata12_3, Rdata22_3, Wreg_addr3, imm3, RegWrite3);
Third_pipe pipe3(CLK, next_PC3,imm3, branch_addr3, jump_addr3, Wreg_addr3, ALUresult3,
 MemRead3, MemWrite3, MemtoReg3, RegWrite3, PCSrc3, JtoPC3, imm4, Wreg_addr4, ALUresult4, jump_addr1, branch_addr1, MemRead4, MemWrite4, MemtoReg4, RegWrite4, JtoPC1, PCSrc1);
Forth_pipe pipe4(CLK, Wdata4, Wreg_addr4, RegWrite4, Wdata5, Wreg_addr5, RegWrite5);

endmodule
