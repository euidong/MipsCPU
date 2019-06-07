module Instruct_Mem(
input wire [6:0] PC,
input wire stall,
output wire [31:0] Instruction
);

reg [31:0] InstructionMemory [0:127];
reg [31:0] temp;

assign Instruction = temp;

localparam mov=11'd257;// addi+regZero
localparam lw=6'b100011, sw=6'b101011, addi=6'b001000, beq=6'b000100, bne=6'b000101, jump=6'b000010;
localparam typeR=6'b000000, add=6'b100000, sub=6'b100010, mul=6'b011000, AND=6'b100100, OR=6'b100101, XOR=6'b100110, NOR=6'b101111;
localparam reg0=5'd0, regZero=5'd1, reg2=5'd2, reg3=5'd3, reg4=5'd4, reg5=5'd5, reg6=5'd6, reg7=5'd7;
localparam reg8=5'd8, reg9=5'd9, reg10=5'd10, reg11=5'd11, reg12=5'd12, reg13=5'd13, reg14=5'd14, reg15=5'd15;
localparam reg16=5'd16, reg17=5'd17, reg18=5'd18, reg19=5'd19, reg20=5'd20, reg21=5'd21, reg22=5'd22, reg23=5'd23;
localparam reg24=5'd24, reg25=5'd25, reg26=5'd26, reg27=5'd27, reg28=5'd28, reg29=5'd29, reg30=5'd30, reg31=5'd31;


always @(*) begin
// typeR 앞에 두개 더해서 뒤에 저장
/*
// convolution
InstructionMemory[0] = { jump, 26'd1 };
InstructionMemory[1] = { mov, reg20, 16'd1 }; // input feature
InstructionMemory[2] = { mov, reg21, 16'd2 }; // 1,2,3,4,5,6,7,8,9
InstructionMemory[3] = { mov, reg22, 16'd3 };
InstructionMemory[4] = { mov, reg23, 16'd4 };
InstructionMemory[5] = { mov, reg24, 16'd5 };
InstructionMemory[6] = { mov, reg25, 16'd6 };
InstructionMemory[7] = { mov, reg26, 16'd7 };
InstructionMemory[8] = { mov, reg27, 16'd8 };
InstructionMemory[9] = { mov, reg28, 16'd9 };
InstructionMemory[10] = { mov, reg15, 16'd1 }; // filter 1,2,3,4
InstructionMemory[11] = { mov, reg16, 16'd2 };
InstructionMemory[12] = { mov, reg17, 16'd3 };
InstructionMemory[13] = { mov, reg18, 16'd4 };

InstructionMemory[14] = { typeR, reg20, reg15, reg10, 5'd0, mul };
InstructionMemory[15] = { typeR, reg21, reg16, reg11, 5'd0, mul };
InstructionMemory[16] = { typeR, reg23, reg17, reg12, 5'd0, mul };
InstructionMemory[17] = { typeR, reg24, reg18, reg13, 5'd0, mul };
InstructionMemory[18] = { mov, reg9, 16'd0 }; // reg9에 계산 결과를 저장할 예정이므로 초기화
InstructionMemory[19] = { typeR, reg9, reg10, reg9, 5'd0, add };
InstructionMemory[20] = { typeR, reg9, reg11, reg9, 5'd0, add };
InstructionMemory[21] = { typeR, reg9, reg12, reg9, 5'd0, add };
InstructionMemory[22] = { typeR, reg9, reg13, reg9, 5'd0, add };

InstructionMemory[24] = { mov, reg3, 16'd10 };
InstructionMemory[25] = { sw, reg3, reg9, 16'd0 }; //reg3가 가리키는 위치에 reg13을 저장 [reg3+0] = reg9

InstructionMemory[26] = { mov, reg9, 16'd0 }; // reg9에 계산 결과를 저장할 예정이므로 초기화
InstructionMemory[27] = { typeR, reg21, reg15, reg10, 5'd0, mul };
InstructionMemory[28] = { typeR, reg22, reg16, reg11, 5'd0, mul };
InstructionMemory[29] = { typeR, reg24, reg17, reg12, 5'd0, mul };
InstructionMemory[30] = { typeR, reg25, reg18, reg13, 5'd0, mul };
InstructionMemory[31] = { typeR, reg9, reg10, reg9, 5'd0, add };
InstructionMemory[32] = { typeR, reg9, reg11, reg9, 5'd0, add };
InstructionMemory[33] = { typeR, reg9, reg12, reg9, 5'd0, add };
InstructionMemory[34] = { typeR, reg9, reg13, reg9, 5'd0, add };

InstructionMemory[35] = { mov, reg3, 16'd10 };
InstructionMemory[36] = { sw, reg3, reg9, 16'd1 }; //reg30가 가리키는 위치에 reg13을 저장 [reg3+1] = reg9

InstructionMemory[37] = { mov, reg9, 16'd0 }; // reg9에 계산 결과를 저장할 예정이므로 초기화
InstructionMemory[38] = { typeR, reg23, reg15, reg10, 5'd0, mul };
InstructionMemory[39] = { typeR, reg24, reg16, reg11, 5'd0, mul };
InstructionMemory[40] = { typeR, reg26, reg17, reg12, 5'd0, mul };
InstructionMemory[41] = { typeR, reg27, reg18, reg13, 5'd0, mul };
InstructionMemory[42] = { typeR, reg9, reg10, reg9, 5'd0, add };
InstructionMemory[43] = { typeR, reg9, reg11, reg9, 5'd0, add };
InstructionMemory[44] = { typeR, reg9, reg12, reg9, 5'd0, add };
InstructionMemory[45] = { typeR, reg9, reg13, reg9, 5'd0, add };

InstructionMemory[46] = { mov, reg3, 16'd10 };
InstructionMemory[47] = { sw, reg3, reg9, 16'd2 }; //reg30가 가리키는 위치에 reg13을 저장 [reg3+1] = reg9

InstructionMemory[48] = { mov, reg9, 16'd0 }; // reg9에 계산 결과를 저장할 예정이므로 초기화
InstructionMemory[49] = { typeR, reg24, reg15, reg10, 5'd0, mul };
InstructionMemory[50] = { typeR, reg25, reg16, reg11, 5'd0, mul };
InstructionMemory[51] = { typeR, reg27, reg17, reg12, 5'd0, mul };
InstructionMemory[52] = { typeR, reg28, reg18, reg13, 5'd0, mul };
InstructionMemory[53] = { typeR, reg9, reg10, reg9, 5'd0, add };
InstructionMemory[54] = { typeR, reg9, reg11, reg9, 5'd0, add };
InstructionMemory[55] = { typeR, reg9, reg12, reg9, 5'd0, add };
InstructionMemory[56] = { typeR, reg9, reg13, reg9, 5'd0, add };

InstructionMemory[57] = { mov, reg3, 16'd10 };
InstructionMemory[58] = { sw, reg3, reg9, 16'd3 }; //reg30가 가리키는 위치에 reg13을 저장 [reg3+1] = reg9
*/

// 메모리의 5~9번지의 값을 읽어와 반복문을 사용하여 3을 곱하고 10~14번지에 저장: bne
InstructionMemory[0] = { jump, 26'd1 };
InstructionMemory[1] = { mov, reg9, 16'd5 }; // repeat 5times
InstructionMemory[2] = { mov, reg10, 16'd0 };
InstructionMemory[3] = { mov, reg11, 16'd5 }; // 배열의 시작주소 reg11=5
InstructionMemory[4] = { mov, reg15, 16'd3 }; // 3을 곱할 것이다
InstructionMemory[5] = { mov, reg14, 16'd10 }; // 저장될 배열의 시작주소 reg14=10

InstructionMemory[6] = { lw, reg11, reg13, 16'd0 }; // reg13에 피연산자
InstructionMemory[7] = { typeR, reg13, reg15, reg13, 5'd0, mul }; // reg13 * 3 = reg13
InstructionMemory[8] = { sw, reg14, reg13, 16'd0 }; //reg14가 가리키는 위치에 reg13을 저장 [reg14+0] = reg13

InstructionMemory[9] = { addi, reg10, reg10, 16'd1 }; // reg10++
InstructionMemory[10] = { addi, reg14, reg14, 16'd1 }; // reg14++
InstructionMemory[11] = { addi, reg11, reg11, 16'd1 }; // reg11++
InstructionMemory[12] = { bne, reg10, reg9, -16'd7 }; // pc는 13이므로 -7 하면 6으로 돌아간다


/*
// 메모리의 5~9번지의 값을 읽어와 반복문을 사용하여 3을 곱하고 10~14번지에 저장: beq
InstructionMemory[0] = { jump, 26'd1 };
InstructionMemory[1] = { addi, regZero, reg9, 16'd5 }; // repeat 5times
InstructionMemory[2] = { addi, regZero, reg10, 16'd0 };
InstructionMemory[3] = { addi, regZero, reg11, 16'd5 }; // 배열의 시작주소 reg11=5
InstructionMemory[4] = { addi, regZero, reg15, 16'd3 }; // 3을 곱할 것이다
InstructionMemory[5] = { addi, regZero, reg14, 16'd10 }; // 저장될 배열의 시작주소 reg14=10

InstructionMemory[6] = { lw, reg11, reg13, 16'd0 }; // reg13에 피연산자
InstructionMemory[7] = { typeR, reg13, reg15, reg13, 5'd0, mul }; // reg13 * 3 = reg13
InstructionMemory[8] = { sw, reg14, reg13, 16'd0 }; //reg14가 가리키는 위치에 reg13을 저장 [reg14+0] = reg13

InstructionMemory[9] = { addi, reg10, reg10, 16'd1 };
InstructionMemory[10] = { addi, reg14, reg14, 16'd1 };
InstructionMemory[11] = { addi, reg11, reg11, 16'd1 };
InstructionMemory[12] = { beq, reg10, reg9, 16'd1 }; // pc는 13이므로 -7 하면 6으로 돌아간다
InstructionMemory[13] = { jump, 26'd6 };
*/

/*
// 1~5까지의 합(정상작동)
InstructionMemory[0] = { jump, 26'd1 };
InstructionMemory[1] = { addi, regZero, reg10, 16'd5 }; // 5번 반복
InstructionMemory[2] = { addi, regZero, reg11, 16'd0 }; //number=0
InstructionMemory[3] = { addi, regZero, reg12, 16'd0 }; //sum=0
InstructionMemory[4] = { addi, reg11, reg11, 16'd1 };// number++
InstructionMemory[5] = { typeR, reg12, reg11, reg12, 5'd0, add }; //sum=sum+number
InstructionMemory[6] = { bne, reg10, reg11, -16'd3 }; // 다르면 앞으로
InstructionMemory[7] = { addi, reg12, reg4, 16'd0 }; // reg25에 출력
*/

/*
// 1~5까지의 합(정상작동)
InstructionMemory[0] = 32'b00001000000000000000000000000001;
InstructionMemory[1] = 32'b00100000001010100000000000000101;
InstructionMemory[2] = 32'b00100000001010110000000000000000;
InstructionMemory[3] = 32'b00100000000101100000000000000000;
InstructionMemory[4] = 32'b00100001011010110000000000000001;
InstructionMemory[5] = 32'b00000001100010110110000000100000;
InstructionMemory[6] = 32'b00010101010010111111111111111101;
InstructionMemory[7] = 32'b00100001100001000000000000000000;
*/

/*
// 1~5까지의 합
InstructionMemory[0] = { jump, 26'd1 };
InstructionMemory[1] = { addi, regZero, reg10, 16'd5 }; // 5번 반복
InstructionMemory[2] = { addi, regZero, reg11, 16'd1 }; //index=1
InstructionMemory[3] = { addi, regZero, reg12, 16'd0 }; //sum=0
InstructionMemory[4] = { typeR, reg12, reg11, reg12, 5'd0, add }; //sum=sum+index
InstructionMemory[5] = { addi, reg11, reg11, 16'd1 };// index++
InstructionMemory[6] = { bne, reg10, reg11, -16'd3 }; // 다르면 앞으로
InstructionMemory[7] = { addi, reg12, reg25, 16'd0 }; // reg25에 출력
*/


// 산술, 논리 연산(정상작동) add, sub, mul, AND, OR, XOR, NOR 연산 테스트
/*
InstructionMemory[0] = { jump, 26'd1 };
InstructionMemory[1] = { addi, regZero, reg10, 16'b0000_0000_0000_0011_1011 };
InstructionMemory[2] = { addi, regZero, reg11, 16'b0000_0000_0000_0101_0111 };
InstructionMemory[3] = { typeR, reg10, reg11, reg13, 5'd0, add };
InstructionMemory[4] = { typeR, reg10, reg11, reg14, 5'd0, mul };
InstructionMemory[5] = { typeR, reg10, reg11, reg15, 5'd0, sub };
InstructionMemory[6] = { typeR, reg10, reg11, reg16, 5'd0, AND };
InstructionMemory[7] = { typeR, reg10, reg11, reg17, 5'd0, OR };
InstructionMemory[8] = { typeR, reg10, reg11, reg18, 5'd0, XOR };
InstructionMemory[9] = { typeR, reg10, reg11, reg19, 5'd0, NOR };
*/

/*
//1~5까지의 합(정상작동)
InstructionMemory[0] = { jump, 26'd1 };
InstructionMemory[1] = { addi, regZero, reg10, 16'd5 }; // 5번 반복
InstructionMemory[2] = { addi, regZero, reg11, 16'd1 }; //index=1
InstructionMemory[3] = { addi, regZero, reg12, 16'd0 }; //sum=0
InstructionMemory[4] = { typeR, reg12, reg11, reg12, 5'd0, add }; //sum=sum+index
InstructionMemory[5] = { beq, reg10, reg11, 16'd2 }; // 같으면 loop종료
InstructionMemory[6] = { addi, reg11, reg11, 16'd1 };// index++
InstructionMemory[7] = { jump, 26'd4 }; // jump to InstructionMemory[4]
InstructionMemory[8] = { addi, reg12, reg25, 16'd0 }; // reg25에 출력
//InstructionMemory[2] = { typeR, reg14, reg12, reg14, 5'd0, add };
//InstructionMemory[2] = { addi, reg8, reg10, 16'd3 };
*/

/*
InstructionMemory[0] = { addi, regZero, reg10, 16'd33 }; 					// reg10에 33 대입 mov reg10, 33
InstructionMemory[1] = { addi, regZero, reg11, 16'd12 };					// mov reg11, 12
InstructionMemory[2] = { typeR, reg10, reg11, reg12, 5'd0, add };	// 더해서 reg12
InstructionMemory[3] = { addi, regZero, reg13, 16'd3 };					// mov reg13, 3
InstructionMemory[4] = { addi, regZero, reg14, 16'd3 };					// mov reg13, 3
InstructionMemory[5] = { typeR, reg12, reg13, reg14, 5'd0, mul };	// 곱해서 reg14
InstructionMemory[6] = { addi, regZero, reg20, 16'd10 }; 					// InstructionMemory[10]에 저장할 예정
InstructionMemory[7] = { sw, reg20, reg14, 16'd0 }; 					// reg14의 값을 M[reg20]에 저장
/*
InstructionMemory[0] = { lw, 5'd16, 5'd21, 16'd2 }; //lw reg16 + offset2 -> reg21
InstructionMemory[1] = { lw, 5'd17, 5'd22, 16'd3 }; //lw reg17 + offset3 -> reg22
InstructionMemory[2] = { typeR, 5'd21, 5'd22 , 5'd23, 5'd0, add }; // reg21 + reg22 -> reg23
InstructionMemory[3] = { sw, 5'd20, 5'd23, 16'd1 }; // sw reg23(데이터) -> reg20(메모리위치26) + offset1
//              base  reg번호  offset
InstructionMemory[4] = { typeR, 5'd21, 5'd22 , 5'd24, 5'd0, mul };
//InstructionMemory[5] = { 6'd43, 5'd
*/
/*
InstructionMemory[0] = { addi, regZero, reg10, 16'd62 }; 					// reg10에 33 대입 mov reg10, 33
InstructionMemory[1] = { addi, regZero, reg11, 16'd62 };					// mov reg11, 12
InstructionMemory[2] = { beq, reg10, reg11, -16'd3 };
//InstructionMemory[2] = { jump, 26'd4 };
InstructionMemory[3] = { typeR, reg10, reg11, reg12, 5'd0, add };	// 더해서 reg12
InstructionMemory[4] = { typeR, reg10, reg11, reg12, 5'd0, mul };
InstructionMemory[5] = { typeR, reg12, reg12, reg13, 5'd0, XOR };
*/
/*
InstructionMemory[0] = { addi, regZero, reg10, 16'd5 }; // 10회 반복
InstructionMemory[1] = { addi, regZero, reg11, 16'd0 }; // reg11 = 0 --> Sum
InstructionMemory[2] = { addi, regZero, reg12, 16'd4 }; // reg12 = 0 --> index

InstructionMemory[3] = { typeR, reg11, reg12, reg11, 5'd0, add };
InstructionMemory[4] = { addi, reg12, reg12, 16'd1 };
InstructionMemory[5] = { beq, reg10, reg12, 16'd1 };
InstructionMemory[6] = { jump, 26'd3 };
InstructionMemory[7] = { addi, reg11, reg20, 16'd0 };
*/

/*
lw, sw 명령어는 reg, InstructionMemoryory 간의 데이터 전송
lw, regA, regB, offset		regA에 있는 주소값에 offset을 더한 주소의 값을 regB에 가져온다.

d24 mul, d32 add, d34 sub
*/
temp <= stall? 32'd0 : InstructionMemory[PC];
end
endmodule
