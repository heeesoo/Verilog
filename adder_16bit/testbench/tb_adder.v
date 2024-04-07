module tb_adder;

reg [15:0] a;
reg [15:0] b;
reg c_in;

wire [15:0] sum;
wire c_out;

adder_16bit u_adder_16bit(
    .a(a),
    .b(b),
    .sum(sum),
    .c_in(c_in),
    .c_out(c_out)
);

initial begin
    #0;
    a = 16'h0;
    b = 16'h0;
    c_in = 1'b0;

    #10;
    a = 16'h0;
    b = 16'h0;
    c_in = 1'b1;

    #10;
    a = 16'h5;
    b = 16'h6;
    c_in = 1'b0;

    #10;
    a = 16'h7;
    b = 16'hA;
    c_in = 1'b1;

    #10;
    $stop;

end

endmodule