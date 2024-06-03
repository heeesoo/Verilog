//`define SIM
//`define CP

module top#(
    `ifdef SIM
    parameter T_DIV_BIT    = 4,   //  2-bit
    parameter T_DIV_0      = 4'd15, // 0-15 : 16 // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_0 = 4'd7,  // 0- 7 : 8
    parameter T_DIV_1      = 4'd7,  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_1 = 4'd3,  // 0- 3 : 4
    parameter D_WIDTH = 8,
    parameter A_WIDTH = 4
    `else
    // 50 MHz clock -> (1/(d5208)) -> 9,600 rate
    parameter T_DIV_BIT    = 13,   // 5207 : 13-bit
    parameter T_DIV_0      = 13'd5207, // 0-5207 : 5208  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_HALF_0 = 13'd2603, // 5208/2 = 2604  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_1      = 13'd5207, // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
    parameter T_DIV_HALF_1 = 13'd1301, // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
    parameter D_WIDTH = 8,
    parameter A_WIDTH = 4
    `endif
)(
    input                   clk,
    input                   n_rst,
    input                   baudrate,
    input                   uart_rxd,
    input                   push_sw,

    output [6:0]            fnd_1,
    output [6:0]            fnd_2
);

// uart rx
wire           uart_rxd_n;
wire [7:0]     rx_data;
wire           rx_done;  // new_data

// mem_controller to ram_dual Wire
wire [A_WIDTH-1:0]      w_addr_w;
wire                    w_en_w;
wire [D_WIDTH-1:0]      w_data_w;

wire [A_WIDTH-1:0]      r_addr_w;
wire [D_WIDTH-1:0]      r_data_w;

// Uart RX Negative Signal
assign uart_rxd_n = ~uart_rxd;

// fnd_data
wire [D_WIDTH-1:0]      fnd_data;

// Push Switch
reg     ps_d1;
reg     ps_d2;

// Uart RX Instance 
uart_rx#(
  .T_DIV_BIT(T_DIV_BIT),   //  2-bit
  .T_DIV_0(T_DIV_0), // 0-15 : 16 // 50 MHz clock -> 9,600 rate
  .T_DIV_HALF_0(T_DIV_HALF_0),  // 0- 7 : 8
  .T_DIV_1(T_DIV_1),  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
  .T_DIV_HALF_1(T_DIV_HALF_1)  // 0- 3 : 4
) u_uart_rx(
  .clk(clk),
  .n_rst(n_rst),
  .baudrate(baudrate),
  .uart_rxd(uart_rxd_n),
  .new_data(rx_done),
  .rx_data(rx_data)
);

// Delay push switch
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        ps_d1 <= 1'b0;
        ps_d2 <= 1'b0;
    end

    else begin
        ps_d1 <= push_sw;
        ps_d2 <= ps_d1;
    end
end

// Push Button edge detector 
assign p_sw = (!ps_d1 && ps_d2)? 1'b1 : 1'b0;

// Mem_controller Instance
mem_controller #(
  .D_WIDTH(D_WIDTH),
  .A_WIDTH(A_WIDTH)
) u_mem_controller(
  .clk(clk),
  .n_rst(n_rst),
  .rx_done(rx_done),
  .rx_data(rx_data),
  .r_en(p_sw),
  .w_addr(w_addr_w),
  .w_en(w_en_w),
  .w_data(w_data_w),
  .r_addr(r_addr_w),
  .r_data(r_data_w),
  .fnd_data(fnd_data)
);

// Ram_16x8 Instance
ram_dual_16x8 u_ram_dual_16x8(
  .clock(clk),
  .data(w_data_w),
  .wraddress(w_addr_w),
  .wren(w_en_w),
  .rdaddress(r_addr_w),
  .q(r_data_w)
);

fnd u_fnd_lsb(
	.din(fnd_data[7:4]),
	.dout(fnd_1)
);

fnd u_fnd_msb(
	.din(fnd_data[3:0]),
	.dout(fnd_2)
);

endmodule