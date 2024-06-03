// Testbench Top module
// Made by KIM, KWON, YOON

`timescale 1ns/100ps
`define T_CLK 10

`define SIM
`define CP

module tb_top;

`ifdef SIM
    parameter T_DIV_BIT    = 4;   //  2-bit
    parameter T_DIV_0      = 4'd15; // 0-15 : 16 // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_0 = 4'd7;  // 0- 7 : 8
    parameter T_DIV_1      = 4'd7;  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_1 = 4'd3;  // 0- 3 : 4
    parameter T_BIT = 4;
    parameter T_1S = 4'd5;
    parameter T_QUARTER = 4'd2;
`else 
    // 50 MHz clock -> (1/(d5208)) -> 9,600 rate
    parameter T_DIV_BIT    = 13;   // 5207 : 13-bit
    parameter T_DIV_0      = 13'd5207; // 0-5207 : 5208  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_HALF_0 = 13'd2603; // 5208/2 = 2604  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_1      = 13'd5207; // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
    parameter T_DIV_HALF_1 = 13'd1301; // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
    parameter T_BIT = 26;
    parameter T_1S = 26'h2FA_F080; // d50_000_000;
    parameter T_QUARTER = 26'h17d_7840;
`endif

//parameter T_BIT = 4;
//parameter T_1S = 4'd1;

parameter TIME = 4'h7;
parameter HALF_TIME = 4'hA; // 011
parameter HALF_HALF_TIME = 4'h2; // 010


reg clk;
reg n_rst;
reg baudrate;

// Top module input 
reg bt;     
reg start;

reg space;

// Top module output
wire [6:0]  fnd_dout;
wire        uart_txd;


// Initial Clock Setting
initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    #(`T_CLK*2.2) n_rst = 1'b1;
end

always #(`T_CLK/2) clk = ~clk;


initial begin
    start = 1'b0;
    bt = 1'b0;
    baudrate = 1'b0;
    space = 1'b0;

    wait(n_rst == 1'b1);

    // Number 0
    #(`T_CLK*TIME*10) bt = 1'b1;
                start = 1'b1;
    
    //#(`T_CLK*1.3) start = 1'b0;
    #(`T_CLK*T_1S) bt = 1'b0;

    #(`T_CLK*T_1S) bt = 1'b1;
    #(`T_CLK*T_1S) bt = 1'b0;

    #(`T_CLK*T_1S) bt = 1'b1;
    #(`T_CLK*T_1S) bt = 1'b0;

    #(`T_CLK*T_1S) bt = 1'b1;
    #(`T_CLK*T_1S) bt = 1'b0;

    #(`T_CLK*T_1S) bt = 1'b1;
    #(`T_CLK*T_1S) bt = 1'b0;
    
    #(`T_CLK*2) start = 1'b0;



    #(`T_CLK*T_QUARTER*15) space = 1'b1;

    #(`T_CLK * TIME*4) $stop;
   
end

// Top module instance 
top#(
  .T_DIV_BIT(T_DIV_BIT),   //  2-bit
  .T_DIV_0(T_DIV_0), // 0-15 : 16 // 50 MHz clock -> 9,600 rate
  .T_DIV_HALF_0(T_DIV_HALF_0),  // 0- 7 : 8
  .T_DIV_1(T_DIV_1),  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
  .T_DIV_HALF_1(T_DIV_HALF_1),  // 0- 3 : 4er T_1S = 26'h2FA_F080 // d50_000_000
  .T_BIT(T_BIT),
  .T_1S(T_1S),
  .T_QUARTER(T_QUARTER)
) u_top ( 
    .clk(clk), 
    .n_rst(n_rst), 
    .baudrate(baudrate), 

    .bt(bt),
    .start(start),
    
    .space(space),

    .fnd_dout(fnd_dout),
    .uart_txd(uart_txd)
);

endmodule



