module resetControl(
  input wire CLK,
  input wire PCSrc3_1,
  input wire JtoPC3_1,
  
  output reg PCSrc1,
  output reg JtoPC1
);

always @ (posedge CLK)
begin
  if (PCSrc3_1)
    PCSrc1 <= 0;
  else
    PCSrc1 <= PCSrc3_1;
  if (JtoPC3_1)
    JtoPC1 <= 0;
  else
    JtoPC1 <= JtoPC3_1;
end

endmodule
