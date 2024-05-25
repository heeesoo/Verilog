module top#(
    parameter T_DIV_BIT    = 4,   //  2-bit
    parameter T_DIV_0      = 4'd15, // 0-15 : 16 // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_0 = 4'd7,  // 0- 7 : 8
    parameter T_DIV_1      = 4'd7,  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_1 = 4'd3  // 0- 3 : 4
)(
    input        clk,
    input        n_rst,
    input        n_start,
    input        sdata,
    input        baudrate,
    input        check_rxd,
    input        uart_rxd_n,

    // This Output is spi_master module output.
    output       sclk,
    output       cs_n,
    output [8:0] led,
    output [7:0] data_rx,
    // This Output is uart_tx module output.
    output uart_txd_n,

    // This Output is rxd module.
    output [6:0] fnd_1,
    output [6:0] fnd_2

);


wire        next_start;

// Output of byte_2_ascii module
wire [7:0]  data_o;
wire        next_s;
wire [7:0]  data_out;

// Uart_tx input Data
wire  [7:0]  uart_input_data;
wire txd_n;
wire tx_done;
wire done;

// DATA Combinational Logic
assign uart_input_data = data_o;
assign led[7:0] = uart_input_data;

// Uart_rx C L
wire rxd;


// spi_master_adc module 
spi_master_adc u_spi_master_adc (
    .clk(clk),
    .n_rst(n_rst),
    .n_start(n_start),  
    .sdata(sdata), 
    .sclk(sclk),
    .cs_n(cs_n),
    .led(data_out), 
    .done(next_start)   
);


// byte_2_ascii module
byte_2_ascii u_byte_2_ascii(
    .clk(clk),
    .n_rst(n_rst),
    .do(data_out), 
    .ns(next_start),    
    .uart_tx_done(tx_done),
    .data_out(data_o),  
    .next_start(next_s) 
);

// Uart_tx module
uart_tx u_uart_tx(
    .clk(clk),
    .n_rst(n_rst),
    .baudrate(baudrate),
    .start(next_s), 
    .din(uart_input_data), 
    .uart_txd(txd_n),   
    .done(tx_done)
);

// Uart_tx_Combinational Logic
assign uart_txd_n = ~txd_n;
assign done = tx_done;

// rx invertor
assign rxd = ~uart_rxd_n;

// Uart_rx module
uart_rx u_uart_rx(
    .clk(clk),
    .n_rst(n_rst),
    .baudrate(baudrate),
    .uart_rxd(rxd),
    .rx_done(led[8]),
    .rx_data(data_rx)
);

// segement 7 module
segement_7 u_segement_7_1(
    .number(data_rx[7:4]),
    .fnd_on(fnd_1)
);

// segement 7 module
segement_7 u_segement_7_2(
    .number(data_rx[3:0]),
    .fnd_on(fnd_2)
);

endmodule