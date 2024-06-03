// clock : 50 MHz
//   (50M/9.6k) = 5208.3333 -> 5208 => h1458

//`define SIM
//`define CP

module uart_rx (
	clk, 	
	n_rst, 		// active low push button

 	baudrate, // 0 : 9600, 1 : 19200...
	
	new_data, 	// LED
	//check, 		// active low push button

	uart_rxd, 	// UART RX DATA

	rx_data
);

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

input 		clk;
input 		n_rst;
input		baudrate; // 0 : 9600, 1 : 19200...

output 		new_data;
// input 		check;

input 		uart_rxd;
output [7:0] rx_data;

// ----------------------------------------------
// UART - RX
// ----------------------------------------------

reg  [T_DIV_BIT-1:0] cnt_rx_div; // (50M/9.6k)
wire [T_DIV_BIT-1:0] t_div; // (27M/9.6k)/2 -> (50M/9.6k)
wire [T_DIV_BIT-1:0] t_div_half; // (27M/9.6k)/2 -> (50M/9.6k)
assign t_div 	  = (baudrate == 1'b1)? T_DIV_1 : T_DIV_0;
assign t_div_half = (baudrate == 1'b1)? T_DIV_HALF_1 : T_DIV_HALF_0;

reg [3:0] cnt_rx_bit; //, cnt_8_d; // 0-8

wire		rx_en;
reg 		rxin_d1, rxin_d2, rxin_d3;
reg 		start_en;

wire 		clk_rx_en;
reg [7:0]   rx_data;

//reg    		new_data_i;

// rx data
always @(posedge clk or negedge n_rst)
	if(!n_rst) begin
		rxin_d1 <= 1'b1;
		rxin_d2 <= 1'b1;
		rxin_d3 <= 1'b1;
	end
	else begin
		rxin_d1 <= uart_rxd; 
		rxin_d2 <= rxin_d1;
		rxin_d3 <= rxin_d2;
	end

// start bit count enable
always @(posedge clk or negedge n_rst)
	if(!n_rst) begin
		start_en <= 1'b0;
	end
	else begin
		if ((rxin_d3 == 1'b1) && (rxin_d2 == 1'b0) && (rx_en == 1'b0))
			start_en <= 1'b1;
		else
			start_en <= 1'b0;
	end

// start bit count
always @(posedge clk or negedge n_rst)
	if(!n_rst)
		cnt_rx_div <= {(T_DIV_BIT){1'b0}} ; 
	else begin
		if ((start_en == 1'b1) || (cnt_rx_div == t_div))
			cnt_rx_div <= {(T_DIV_BIT){1'b0}} ; 
	    else if (rx_en == 1'b1)
			cnt_rx_div <= cnt_rx_div + {{(T_DIV_BIT-1){1'b0}},1'b1};
		else
			cnt_rx_div <= {(T_DIV_BIT){1'b0}} ; 
	end

always @(posedge clk or negedge n_rst)
	if(!n_rst) begin
		cnt_rx_bit <= 4'h0;
	end
	else begin
		if (start_en == 1'b1)
			cnt_rx_bit = 4'h1;
		else if ((rx_en == 1'b1) && (cnt_rx_div == t_div_half))
			cnt_rx_bit <= cnt_rx_bit + 4'h1;
		else if (cnt_rx_div == t_div_half)
			cnt_rx_bit <= 4'h0;
	end

assign rx_en = (cnt_rx_bit >= 4'h1 && cnt_rx_bit <= 4'hb)? 1'b1 : 1'b0;

// start bit ok / sampling position
assign clk_rx_en = ((rx_en == 1'b1) && (cnt_rx_div == t_div_half))? 1'b1 : 1'b0;

always @(posedge clk or negedge n_rst)
	if(!n_rst) begin
		rx_data <= 8'b0000_0000;
	end
	else begin
		if(clk_rx_en == 1'b1 && (cnt_rx_bit < 4'ha))
			rx_data <= {rxin_d2,rx_data[7:1]};

	end
/*
//// receive check
always @(posedge clk or negedge n_rst)
	if (!n_rst) begin
		new_data_i <= 1'b0;
	end
	else begin
		if (check == 1'b1)
			new_data_i <= 1'b0;
		else if ((clk_rx_en == 1'b1) && (cnt_rx_bit == 4'ha))
			new_data_i <= 1'b1;
	end
*/
//assign new_data = new_data_i;
assign new_data = ((clk_rx_en == 1'b1) && (cnt_rx_bit == 4'ha))? 1'b1 : 1'b0;

endmodule
