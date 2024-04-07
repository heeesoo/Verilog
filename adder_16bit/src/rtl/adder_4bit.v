module adder_4bit(
    a,
    b,
    sum,
    c_in,
    c_out
);

input [3:0] a;
input [3:0] b;
input c_in;

output [3:0] sum;
output c_out;

wire carry_wire;

adder_2bit u_adder_2bit_0(
    .a(a[1:0]),
    .b(b[1:0]),
    .sum(sum[1:0]),
    .c_in(c_in),
    .c_out(carry_wire)
);

adder_2bit u_adder_2bit_1(
    .a(a[3:2]),
    .b(b[3:2]),
    .sum(sum[3:2]),
    .c_in(carry_wire),
    .c_out(c_out)
);

endmodule