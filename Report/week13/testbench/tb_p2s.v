`timescale 1ns/100ps
`define T_CLK 10

module tb_p2s;
reg clk;
reg n_rst;

reg [3:0] din;
reg load;   
reg send;

wire data;
wire vld;

p2s u_p2s(
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