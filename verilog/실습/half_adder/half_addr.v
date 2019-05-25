module h_add (X,Y,S,C);
input X,Y;
output C,S;
and (C,X,Y);
xor (S,X,Y);
endmodule
