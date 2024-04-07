module half_adder(
    a,
    b,
    s,
    c
);

input a;
input b;

output s;
output c;

xor(s, a, b); // s = a ^ b;
and(c, a, b); // c = a & b;

endmodule