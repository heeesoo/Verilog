`timescale 1ns/100ps
`define T_CLK 10

module tb_s2p_to_p2s;
reg clk;
reg n_rst;

reg [3:0] din;
reg load;   
reg send;

wire [3:0] dout;
wire dout_vld;

top u_top(
  .clk(clk),
  .n_rst(n_rst),
  .din(din),
  .load(load),
  .send(send),
  .dout(dout),
  .dout_vld(dout_vld)
);

always #(`T_CLK/2) clk = ~clk;

initial begin
    #0;
    clk = 1'b1;
    n_rst = 1'b0;
    din = 4'b0000;
    load = 1'b0;
    send = 1'b0;
  
    #(`T_CLK * 1.2) n_rst = 1'b1;
  
    #(`T_CLK * 2) 
    din = 4'b1001;
    load = 1'b1;
  
    #(`T_CLK)
    load = 1'b0;

    #(`T_CLK)
    send = 1'b1;

    #(`T_CLK * 4)
    send = 1'b0;

    #(`T_CLK * 4)
    din = 4'b1100;
    load = 1'b1;

    #(`T_CLK)
    load = 1'b0;

    #(`T_CLK)
    send = 1'b1;

    #(`T_CLK)
    send = 1'b0;

    #(`T_CLK)
    send = 1'b1;

    #(`T_CLK)
    send = 1'b0;

    #(`T_CLK)
    send = 1'b1;

    #(`T_CLK)
    send = 1'b0;

    #(`T_CLK)
    send = 1'b1;

    #(`T_CLK)
    send = 1'b0;

    #(`T_CLK * 2)
    din = 4'b0110;
    load = 1'b1;

    #(`T_CLK)
    load = 1'b0;

    #(`T_CLK)
    send = 1'b1;

    #(`T_CLK * 2)
    send = 1'b1;

    #(`T_CLK)
    send = 1'b0;

    #(`T_CLK)
    send = 1'b1;

    #(`T_CLK)
    send = 1'b0;

    #(`T_CLK * 3)
    $stop;
    
end

endmodule