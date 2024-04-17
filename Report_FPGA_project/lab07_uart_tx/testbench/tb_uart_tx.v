`timescale 1ns/1ps
`define T_CLK 20

module tb_uart_tx;

parameter T_DIV = 13'd7;    // 0- 7 : 8
parameter T_DIV_HALF = 13'd3;   // 0- 3 : 4

reg clk;
reg n_rst;

reg start;
reg [T_DIV:0] din;

wire done;
wire uart_txd;

uart_tx #(
    .T_DIV(T_DIV), 
    .T_DIV_HALF(T_DIV_HALF)) 
u_uart_tx(
    .clk(clk),
    .n_rst(n_rst),
    .start(start),
    .din(din),
    .done(done),
    .uart_txd(uart_txd)
);

initial begin
    n_rst = 1'b0;
    clk = 1'b1;
    #(`T_CLK*2.2) n_rst = 1'b1;
end

always #(`T_CLK/2) clk = ~clk;

initial begin
    start = 1'b0;
    din = 8'h00;

    wait(n_rst == 1'b1);

    #(`T_CLK*T_DIV*14) 
        din = 8'h37;
        start = 1'b1;
    #(`T_CLK*1) start = 1'b0;

    #(`T_CLK*T_DIV*14) 
        din = 8'h20;
        start = 1'b1;
    #(`T_CLK*1) start = 1'b0;
    
    #(`T_CLK * T_DIV*14) $stop;
end

endmodule