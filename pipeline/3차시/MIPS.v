module MIPS(input wire CLK);

reg [31:0] PC1;

/*----------------------- ALL WIRE  ---------------------- */
// stage1 : IF
wire [31:0] next_PC1;
wire [31:0] instruct1;
wire [31:0] branch_addr4;
wire [31:0] jump_addr4;

wire stall;
wire flag;


//control
wire JtoPC1;
wire Branch1;
wire RegWrite1;
wire RegDst1;
wire ALUSrc1;
wire MemWrite1;
wire MemRead1;
wire MemtoReg1;
wire [3:0] ALUOp1;


// stage2 : ID
wire [4:0] Rreg_addr12;
wire [4:0] Rreg_addr22;
wire [4:0] Wreg_addr2;
wire [31:0] imm2;
wire [31:0] Rdata12;
wire [31:0] Rdata22;
wire [31:0] next_PC2;
wire [31:0] instruct2;

//control
wire JtoPC2;
wire Branch2;
wire RegWrite2;
wire RegDst2; // 사용
wire ALUSrc2;
wire MemWrite2;
wire MemRead2;
wire MemtoReg2;
wire [3:0] ALUOp2;


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
wire [31:0] ALUresult3;


wire zero3;
wire PCSrc3;

//control
wire JtoPC3;
wire Branch3; //사용
wire RegWrite3;
wire ALUSrc3; //사용
wire MemWrite3;
wire MemRead3;
wire MemtoReg3;
wire [3:0] ALUOp3; //사용

//stage4 : MEM
wire [31:0] ALUresult4;
wire [31:0] imm4;
wire [4:0] Wreg_addr4;
wire [31:0] Mem_Rdata4;
wire [31:0] Wdata4;

//control
wire JtoPC4; //사용
wire PCSrc4; //사용
wire RegWrite4;
wire MemWrite4; //사용
wire MemRead4; //사용
wire MemtoReg4; //사용


//stage5 : WB
wire [4:0] Wreg_addr5;
wire [31:0] Wdata5;
wire RegWrite5;

/*----------------------- ASSIGN ---------------------- */

//stage1 : IF
assign next_PC1 = PC1 + 32'd4;

//stage2 : ID
assign Rreg_addr12 = instruct2[25:21];
assign Rreg_addr22 = instruct2[20:16];
assign Wreg_addr2 = (RegDst2) ? instruct2[15:11] : instruct2[20:16];
assign imm2 = (instruct2[15] == 1) ? { 16'hFFFF, instruct2[15:0] } : { 16'h0000, instruct2[15:0] };

//stage3 : EX
//assign Rdata13 = (RegWrite4 & (Rreg_addr12 == Wreg_addr4))? Wdata4 :(RegWrite3 & (Rreg_addr12 == Wreg_addr3)) ? ALUresult3 : Rdata12_3; //FORWARDING
assign Rdata13 = Rdata12_3;
//assign Rdata23 = ALUSrc3 ? imm3 : (RegWrite4 & (Rreg_addr22 == Wreg_addr4) & (OP3 == 6'd0)) ? Wdata4 : (RegWrite3 & (Rreg_addr22 == Wreg_addr3) & (OP3 == 6'd0))? ALUresult3 : Rdata22_3; //FORWARDING
assign Rdata23 = ALUSrc3 ? imm3 : Rdata22_3;

assign branch_addr3 = next_PC3 + {imm3[29:0], 2'd0};
assign jump_addr3 = {next_PC3[31:28], {imm3[25:0], 2'd0}};
assign PCSrc3 = zero3 & Branch3;

//stage4 : MEM
assign Wdata4 = (MemtoReg4) ? Mem_Rdata4 : ALUresult4;


/*----------------------- pc get ---------------------- */
always @(posedge CLK)
begin
  if(JtoPC4)
    PC1 <= jump_addr4;
  else if (PCSrc4)
    PC1 <= branch_addr4;
  else
    PC1 <= next_PC1;
end

initial
begin
  PC1 <= 32'b1111_1111_1111_1111_1111_1111_1111_1100;
end


/*-----------------------module 선언 ---------------------- */
Instruction_Mem im(PC1[8:2], instruct1);

Register REG(CLK, RegWrite5, Rreg_addr12, Rreg_addr22, Wreg_addr5, Wdata5 ,Rdata12, Rdata22);

//STALL 판단
//Staller take (instruct1, Wreg_addr2, flag, OP2, stall2); //stall 판단

Control ctrl(instruct1[31:26], instruct1[25:20], JtoPC1, Branch1, RegWrite1, RegDst1, ALUSrc1, MemWrite1, MemRead1, MemtoReg1, ALUOp1);

ALU alu(ALUOp3, Rdata13, Rdata23, ALUresult3, zero3);

Data_Mem dm(CLK, MemWrite4, MemRead4, ALUresult4[6:0], imm4, Mem_Rdata4);

/*-----------------------pipe Register ---------------------- */
First_pipe pipe1(CLK, next_PC1, instruct1, JtoPC1, Branch1, RegWrite1, RegDst1, ALUSrc1, MemWrite1, MemRead1, MemtoReg1, ALUOp1, next_PC2, instruct2, JtoPC2, Branch2, RegWrite2, RegDst2, ALUSrc2, MemWrite2, MemRead2, MemtoReg2, ALUOp2);
Second_pipe pipe2(CLK, Wreg_addr2, imm2, Rdata12, Rdata22, next_PC2, JtoPC2, Branch2, RegWrite2, ALUSrc2, MemWrite2, MemRead2, MemtoReg2, ALUOp2, Wreg_addr3, imm3, Rdata12_3, Rdata22_3, next_PC3, JtoPC3, Branch3, RegWrite3, ALUSrc3, MemWrite3, MemRead3, MemtoReg3, ALUOp3);
Third_pipe pipe3(CLK, imm3, branch_addr3, jump_addr3, Wreg_addr3, ALUresult3, PCSrc3, JtoPC3, RegWrite3, MemWrite3, MemRead3, MemtoReg3, imm4, branch_addr4, jump_addr4, Wreg_addr4, ALUresult4, PCSrc4, JtoPC4, RegWrite4, MemWrite4, MemRead4, MemtoReg4);
Forth_pipe pipe4(CLK, Wdata4, Wreg_addr4, RegWrite4, Wdata5, Wreg_addr5, RegWrite5);

endmodule
