module adder_8bit(
    a,
    b,
    sum,
    c_in,
    c_out
);

input [7:0] a;
input [7:0] b;
input c_in;

output [7:0] sum;
output c_out;

wire carry_wire;

adder_4bit u_adder_4bit_0(
    .a(a[3:0]),
    .b(b[3:0]),
    .sum(sum[3:0]),
    .c_in(c_in),
    .c_out(carry_wire)
);

adder_4bit u_adder_4bit_1(
    .a(a[7:4]),
    .b(b[7:4]),
    .sum(sum[7:4]),
    .c_in(carry_wire),
    .c_out(c_out)
);

endmodule