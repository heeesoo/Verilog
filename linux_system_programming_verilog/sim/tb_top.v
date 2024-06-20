`timescale 1ns/100ps
`define T_CLK 10

module tb_top;

reg clk;
reg n_rst;

wire [6:0] fnd_on;

top u_top(
	.clk(clk),
	.n_rst(n_rst),
	.fnd_on(fnd_on)
);


always #(`T_CLK) clk = ~clk;  

initial begin
	clk = 1'b1;
	n_rst = 1'b0;
	
	#(`T_CLK * 2) n_rst = 1'b1;

	#(`T_CLK * 40) 
	$finish;

end

initial begin 
	$dumpfile("wave.vcd");
	$dumpvars(0);
end

endmodule	
