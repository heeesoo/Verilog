module adder_2bit(
    a,
    b,
    sum,
    c_in,
    c_out
);

input [1:0] a;
input [1:0] b;
input c_in;

output [1:0] sum;
output c_out;

wire carry_wire;

full_adder u_full_adder_0(
    .a(a[0]),
    .b(b[0]),
    .sum(sum[0]),
    .c_in(c_in),
    .c_out(carry_wire)
);

full_adder u_full_adder_1(
    .a(a[1]),
    .b(b[1]),
    .sum(sum[1]),
    .c_in(carry_wire),
    .c_out(c_out)
);

endmodule