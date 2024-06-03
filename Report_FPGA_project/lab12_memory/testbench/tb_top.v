`timescale 1ns/100ps
`define T_CLK 10

module tb_top;

parameter D_WIDTH = 8;
parameter A_WIDTH = 4;

parameter T_DIV_BIT    = 4;   //  2-bit
parameter T_DIV_0      = 4'd7; // 0-15 : 16 // 50 MHz clock -> 9,600 rate
parameter T_DIV_HALF_0 = 4'd7;  // 0- 7 : 8
parameter T_DIV_1      = 4'd7;  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
parameter T_DIV_HALF_1 = 4'd3;  // 0- 3 : 4
parameter SCLK_HALF = 4'hC;

// Inputs
reg clk;
reg n_rst;
reg rx_done;
reg [D_WIDTH-1:0] rx_data;
reg push_sw;

// Outputs
wire [D_WIDTH-1:0] fnd_data;

top #(
    .D_WIDTH(D_WIDTH),
    .A_WIDTH(A_WIDTH)
)u_top(
    .clk(clk),
    .n_rst(n_rst),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .push_sw(push_sw),
    .fnd_data(fnd_data)
);

// Clock generation
initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    rx_done = 1'b0;
    rx_data = 8'h0;  
    push_sw = 1'b0;
    #(`T_CLK*2.2)n_rst = 1'b1;
end

always #(`T_CLK/2) clk = ~clk;


initial begin
  wait(n_rst == 1'b1);
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h63; // C
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1; // rx_done signal 1
  #(`T_CLK*1) rx_done = 1'b0; // next clock rx_done signal 0
  #(`T_CLK*SCLK_HALF*1) push_sw = 1'b1;
  #(`T_CLK*1) push_sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h35; // 5
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) push_sw = 1'b1;
  #(`T_CLK*1) push_sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h20; // 20
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h63; // C
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) push_sw = 1'b1;
  #(`T_CLK*1) push_sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h36; // 6
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) push_sw = 1'b1;
  #(`T_CLK*1) push_sw = 1'b0;
  wait (u_top.u_mem_controller.clear == 1'b1);
  
  #(`T_CLK*SCLK_HALF*4) rx_data = 8'h20; // 20
  #(`T_CLK*SCLK_HALF*1) rx_done = 1'b1;
  #(`T_CLK*1) rx_done = 1'b0;
  #(`T_CLK*SCLK_HALF*1) push_sw = 1'b1;
  #(`T_CLK*1) push_sw = 1'b0;
  
  #(`T_CLK*SCLK_HALF*4) $stop;
end



endmodule