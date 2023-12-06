
`timescale 1ns/100ps
`define T_CLK 10

module tb_uart;

reg clk, n_rst;

initial begin
	clk = 1'b1;
	n_rst = 1'b0;
	#(`T_CLK*1.2) n_rst = 1'b1;
end
always #(`T_CLK/2) clk = ~clk;

reg start;
reg [7:0] din;

initial begin
	start = 1'b0;
	din = 8'h00;
	wait(n_rst == 1'b1);

	din = 8'h81;
	start = 1'b1;
	#(`T_CLK*5) start = 1'b0;
	#(`T_CLK*100) $stop;
		
end

wire dout;
wire final_dout;

uart u_uart(
	.clk(clk),  
	.n_rst(n_rst),
	.start(start),
	.din(din),
	.dout(dout),
	.final_dout(final_dout)
);

endmodule
