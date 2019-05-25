`timescale 1ns/1ns
module testbench;
reg X,Y;
wire C,S;

reg clk1;
reg clk2;

always begin
#250 clk1 = !clk1;
#500 clk2 = !clk2;
end

initial begin
clk1 =0;
clk2 =0;
end

h_add half (X,Y,S,C);

initial begin
 assign X = clk2; assign Y = clk1;
 assign X = clk2; assign Y = clk1;
 assign X = clk2; assign Y = clk1;
 assign X = clk2; assign Y = clk1;

 end
endmodule
