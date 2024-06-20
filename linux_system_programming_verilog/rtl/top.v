module top(clk, n_rst, fnd_on);

input	clk;
input	n_rst;

output	[6:0]	fnd_on;

wire	[3:0]		num_w;


num_seq u_num_seq(
	.clk(clk),
	.n_rst(n_rst),
	.num(num_w)
);

fnd_decoder u_fnd_decoder(
	.num(num_w),
	.fnd_on(fnd_on)
);

endmodule
