`timescale 10ns/10ns
module testbench;
reg clk;


always begin
  #10; clk = !clk;
end

initial begin
  clk =0;
end

MIPS mips (clk);

endmodule
