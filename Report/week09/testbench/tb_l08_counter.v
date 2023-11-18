`timescale 1ns/1ps
`define T_CLK 10

module tb_l08_counter;
reg clk;
reg n_rst;

initial clk = 1'b1;

always #(`T_CLK/2) clk = ~clk;

initial begin
    n_rst = 1'b0;
    #(`T_CLK * 1.2) n_rst = 1'b1;
end

reg up;
wire [1:0] counter_3;

initial begin
    up = 1'b0;  
    wait(n_rst == 1'b1);
    #(`T_CLK) up = 1'b1 ;
    #(`T_CLK * 3) up = 1'b0;
    #(`T_CLK * 2) up = 1'b1;
    #(`T_CLK * 2) up = 1'b0;
    #(`T_CLK * 2) up = 1'b1;
    #(`T_CLK * 5) up = 1'b0;
    #(`T_CLK * 3) $stop;
end

l08_counter u_l08_counter(
    .clk(clk),
    .n_rst(n_rst),
    .up(up),
    .counter_3(counter_3)
);

endmodule
