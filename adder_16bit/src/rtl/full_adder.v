module full_adder(
    a,
    b,
    sum,
    c_in,
    c_out
);

input a;
input b;
input c_in;

output sum;
output c_out;

wire wire_sum;
wire wire_c_out_0;
wire wire_c_out_1;

assign c_out = wire_c_out_0 | wire_c_out_1;

half_adder u_ha_0(
    .a(a),
    .b(b),
    .s(wire_sum),
    .c(wire_c_out_0)
);

half_adder u_ha_1(
    .a(wire_sum),
    .b(c_in),
    .s(sum),
    .c(wire_c_out_1)
);


endmodule