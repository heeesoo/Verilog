`timescale 1ns/10ps
`define T_CLK 10

module tb_det_011_reset_moore;
reg clk;
reg n_rst;
reg din;

wire dout;

initial clk = 1'b1;

always #(`T_CLK/2) clk = ~clk;

initial begin
    n_rst = 1'b0;
    #(`T_CLK*1.1) n_rst = 1'b1;
end

initial begin
    din = 1'b0;
    #(`T_CLK*1.1) din = 1'b0; //1st
    #(`T_CLK) din = 1'b0;
    #(`T_CLK) din = 1'b1; 
    #(`T_CLK) din = 1'b1; // 2nd
    #(`T_CLK) din = 1'b1;
    #(`T_CLK) din = 1'b0;
    #(`T_CLK) din = 1'b0; // 3rd
    #(`T_CLK) din = 1'b1;
    #(`T_CLK) din = 1'b1;
    #(`T_CLK) din = 1'b0; // 4th
    #(`T_CLK) din = 1'b0;
    #(`T_CLK) din = 1'b0;
    #(`T_CLK*3) $stop;

end

det_011_reset_mealy u_det_011_reset_mealy(
    .clk(clk),
    .n_rst(n_rst),
    .din(din),
    .dout(dout_011_reset_mealy)
);


det_011_reset_moore u_det_011_reset_moore(
    .clk(clk),
    .n_rst(n_rst),
    .din(din),
    .dout(dout_011_reset_moore)
);

endmodule
