// Morse Machine Top Module
// Made by KIM, KWON, YOON

// clock : 50 MHz
//   (50M/9.6k) = 5208.3333 -> 5208 => h1458

//`define SIM
//`define CP

module top#(
    `ifdef SIM
    parameter T_DIV_BIT    = 4,   //  2-bit
    parameter T_DIV_0      = 4'd15, // 0-15 : 16 // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_0 = 4'd7,  // 0- 7 : 8
    parameter T_DIV_1      = 4'd7,  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_1 = 4'd3,  // 0- 3 : 4
    parameter T_BIT = 4,
    parameter T_1S = 4'd5,
    parameter T_QUARTER = 4'd2
    `else 
    // 50 MHz clock -> (1/(d5208)) -> 9,600 rate
    parameter T_DIV_BIT    = 13,   // 5207 : 13-bit
    parameter T_DIV_0      = 13'd5207, // 0-5207 : 5208  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_HALF_0 = 13'd2603, // 5208/2 = 2604  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_1      = 13'd5207, // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
    parameter T_DIV_HALF_1 = 13'd1301, // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
    parameter T_BIT = 26,
    parameter T_1S = 26'h2FA_F080, // d50_000_000;
    parameter T_QUARTER = 26'h17d7840
    `endif
)(
    input           clk,
    input           n_rst,
    input           baudrate,

    input           space,

    input           bt, // Push Button[2]
    input           start,  // Slide Switch[9]
    
    output [6:0]    fnd_dout,    // Ascii -> FND (8bit data)
    output          uart_txd   // final output 
);

wire bt_t;

assign bt_t = ~bt;

// Morse module wire or reg data.
wire            morse_done;
wire    [4:0]   morse_data;
wire    [2:0]   cnt_number;

// Translate module wire or reg data.
wire    [7:0]   fnd_wire;
wire            trans_done;

// Uart tx module wire or reg data.
wire        uart_txd_n;
wire        tx_done;
// --------------------------------------------------------------------
// Instance Modules
// --------------------------------------------------------------------

// Morse module
// connect parameter values through an instance
morse #(
    .T_BIT(T_BIT),
    .T_1S(T_1S),
    .T_QUARTER(T_QUARTER)
)u_morse(
    .clk(clk),
    .n_rst(n_rst),
    .baudrate(baudrate),
    .bt(bt_t),
    .start(start),
    .done(morse_done),
    .tx_done(tx_done),
    .data(morse_data),
    .cnt_num(cnt_number)
);

wire space_d;

debounce u_debounce(
    .clk(clk),
    .n_rst(n_rst),
    .din(space),
    .dout(space_d)
);

// connect parameter values through an instance
translation#(
    .T_BIT(T_BIT),
    .T_1S(T_1S)
) u_translation(
  .clk(clk),
  .n_rst(n_rst),
  .din(morse_data),
  .space(space_d),
  .cnt_number(cnt_number),
  .trans_start(morse_done),
  .dout(fnd_wire),
  .trans_done(trans_done)
);

fnd u_fnd(
    .din(fnd_wire),
    .dout(fnd_dout)
);

// Uart tx module
// connect parameter values through an instance
uart_tx#(
  .T_DIV_BIT(T_DIV_BIT),   //  2-bit
  .T_DIV_0(T_DIV_0), // 0-15 : 16 // 50 MHz clock -> 9,600 rate
  .T_DIV_HALF_0(T_DIV_HALF_0),  // 0- 7 : 8
  .T_DIV_1(T_DIV_1),  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
  .T_DIV_HALF_1(T_DIV_HALF_1)  // 0- 3 : 4
) u_uart_tx(
    .clk(clk),
    .n_rst(n_rst),
    .baudrate(baudrate),
    .uart_start(trans_done),
    .uart_din(fnd_wire),
    .tx_done(tx_done),
    .uart_txd(uart_txd_n)
);

// Uart txd inverter
assign uart_txd = ~uart_txd_n;


endmodule

