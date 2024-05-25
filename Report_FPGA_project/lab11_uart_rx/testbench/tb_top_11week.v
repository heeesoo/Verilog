//tb_top
`timescale 1ns/100ps
`define T_CLK 20
`define SIM

module tb_top_11week;
  
`ifdef SIM
parameter T_DIV_BIT    = 4;   //  2-bit
parameter T_DIV_0      = 4'd15; // 0-15 : 16 // 50 MHz clock -> 9,600 rate
parameter T_DIV_HALF_0 = 4'd7;  // 0- 7 : 8
parameter T_DIV_1      = 4'd7;  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
parameter T_DIV_HALF_1 = 4'd3;  // 0- 3 : 4
`else
// 50 MHz clock -> (1/(d5208)) -> 9,600 rate
parameter T_DIV_BIT    = 13;   // 5207 : 13-bit
parameter T_DIV_0      = 13'd5207; // 0-5207 : 5208  // 50 MHz clock ->  9,600 rate
parameter T_DIV_HALF_0 = 13'd2603; // 5208/2 = 2604  // 50 MHz clock ->  9,600 rate
parameter T_DIV_1      = 13'd5207; // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
parameter T_DIV_HALF_1 = 13'd1301; // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
`endif

parameter SCLK_HALF = 4'hC;

reg clk;
reg n_rst;

reg n_rst_slave;
reg start;
reg [7:0] data;

reg baudrate;

wire sclk;
wire cs_n;
wire sdata;
wire [7:0] data_rx;
wire [6:0] fnd_1;
wire [6:0] fnd_2;

wire [8:0] led;

top #( 
   .T_DIV_BIT(T_DIV_BIT), 
   .T_DIV_0(T_DIV_0), 
   .T_DIV_HALF_0(T_DIV_HALF_0), 
   .T_DIV_1(T_DIV_1), 
   .T_DIV_HALF_1(T_DIV_HALF_1)
) u_top ( 
   .clk(clk), 
   .n_rst(n_rst), 
  
   .n_start(~start), 
   .sdata(sdata), 
   .baudrate(baudrate), 


  
   .sclk(sclk), 
   .cs_n(cs_n), 

  
   .data_rx(data_rx),
   .led(led),
   .fnd_1(fnd_1),
	.fnd_2(fnd_2)


);

spi_slave_adc u_spi_slave_adc(
   .n_rst(n_rst_slave),

   .data(data), 

   .sclk(sclk),
   .cs_n(cs_n),
   .sdata(sdata)  // output
);

initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    #(`T_CLK*2.2) n_rst = 1'b1;
end

always #(`T_CLK/2) clk = ~clk;

integer i;

initial begin
   n_rst_slave = 1'b0;
   start = 1'b0;
   data = 8'h00;

   baudrate = 1'b0;

   wait(n_rst == 1'b1);
   n_rst_slave = 1'b1;
   
    for(i=8'hC5; i<8'hC9; i=i+1) begin
      #(`T_CLK*SCLK_HALF*9) data = i;

      #(`T_CLK*1) n_rst_slave = 1'b0;
      #(`T_CLK*1) n_rst_slave = 1'b1;

      #(`T_CLK*1) start = 1'b1;
      #(`T_CLK*1) start = 1'b0;
      

      wait (u_top.u_uart_rx.rx_done == 1'b1) ;
      
      // if (i==8'hC6) baudrate = 1'b1;
   end
   #(`T_CLK * SCLK_HALF*4) $stop;
    
end

endmodule