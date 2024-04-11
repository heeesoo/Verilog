`timescale 1ns/100ps
`define T_CLK 10

module tb_s2p;
reg clk;
reg n_rst;

reg data;
reg vld;   

wire [3:0] dout;
wire dout_vld;

s2p u_s2p(
  .clk(clk),
  .n_rst(n_rst),
  .din(din),
  .load(load),
  .send(send),
  .data(data),
  .vld(vld)
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

  #(`T_CLK * 2)
  $stop;

end

endmodule