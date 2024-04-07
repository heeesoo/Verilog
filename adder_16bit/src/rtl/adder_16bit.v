module adder_16bit(
    a,
    b,
    sum,
    c_in,
    c_out
);

input [15:0] a;
input [15:0] b;
input c_in;

output [15:0] sum;
output c_out;

wire carry_wire;

adder_8bit u_adder_8bit_0(
    .a(a[7:0]),
    .b(b[7:0]),
    .sum(sum[7:0]),
    .c_in(c_in),
    .c_out(carry_wire)
);

adder_8bit u_adder_8bit_1(
    .a(a[15:8]),
    .b(b[15:8]),
    .sum(sum[15:8]),
    .c_in(carry_wire),
    .c_out(c_out)
);

endmodule