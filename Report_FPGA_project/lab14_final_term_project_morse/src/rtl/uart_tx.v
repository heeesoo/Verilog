// Uart Tx Module
// Made by KIM, KWON, YOON

// clock : 50 MHz
//   (50M/9.6k) = 5208.3333 -> 5208 => h1458

//`define SIM
//`define CP

module uart_tx#(
    `ifdef SIM
    parameter T_DIV_BIT    = 4,   //  2-bit
    parameter T_DIV_0      = 4'd15, // 0-15 : 16 // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_0 = 4'd7,  // 0- 7 : 8
    parameter T_DIV_1      = 4'd7,  // 0- 7 : 8  // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_1 = 4'd3  // 0- 3 : 4
    `else 
    // 50 MHz clock -> (1/(d5208)) -> 9,600 rate
    parameter T_DIV_BIT    = 13,   // 5207 : 13-bit
    parameter T_DIV_0      = 13'd5207, // 0-5207 : 5208  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_HALF_0 = 13'd2603, // 5208/2 = 2604  // 50 MHz clock ->  9,600 rate
    parameter T_DIV_1      = 13'd5207, // 0-2603 : 2604  // 50 MHz clock -> 19,200 rate
    parameter T_DIV_HALF_1 = 13'd1301 // 2604/2 = 1302  // 50 MHz clock -> 19,200 rate
    `endif
)(
    input       clk,
    input       n_rst,
    input       baudrate,   // 0 : 9600, 1 : 19200...

    input       uart_start,
    input [7:0] uart_din,   // parallel to serial data conversion.
    
    output      tx_done,    
    output 		 uart_txd    // tera term output.
);

reg             tx_en;
reg     [9:0]	tx_data;

reg     [T_DIV_BIT-1:0] cnt_tx_div; 
reg     [3:0] 			cnt_bit; // cnt 11 : 0-10

wire [T_DIV_BIT-1:0]    t_div; // (50M/9.6k)
wire                    clk_tx_en;

// ----------------------------------------------------------------------------

// Select data velocity (baudrate) 
assign t_div = (baudrate == 1'b1)? T_DIV_0 : T_DIV_1;

// Count clock timing enable (clk_tx_en)
assign clk_tx_en = (cnt_tx_div == t_div)? 1'b1 : 1'b0;

// Uart txd parallel to serial send data
assign uart_txd = tx_data[0];

// Uart tx done signal
assign tx_done = (cnt_bit == 4'hc)? 1'b1 : 1'b0;


// tx_en Flip Flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        tx_en <= 1'b0;
    end

    else begin 
        if (uart_start) begin
            tx_en <= 1'b1;
        end

        else if (clk_tx_en && (cnt_bit == 4'hB)) begin
            tx_en <= 1'b0;
        end

        else begin
            tx_en <= tx_en;
        end
    end
end


// cnt_tx_div Flip Flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt_tx_div <= {(T_DIV_BIT){1'b0}};
    end

    else begin
        if (tx_en) begin
            cnt_tx_div <= (clk_tx_en == 1'b1)? {(T_DIV_BIT){1'b0}} : 
					        cnt_tx_div + {{(T_DIV_BIT-1){1'b0}}, 1'b1};
        end

        else begin
            cnt_tx_div <= {(T_DIV_BIT){1'b0}};
        end
    end
end


// Clock Counter Flip Flop 
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt_bit <= 4'h0;
    end

    else begin 
        if (tx_en) begin
            cnt_bit <= (clk_tx_en)? cnt_bit + 4'h1 : cnt_bit;
        end

        else begin
            cnt_bit <= 4'h0;
        end
    end
end


// tx_data shift machine Flip Flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        tx_data <= 10'h000;
    end

    else begin
        if (tx_en) begin
            if (clk_tx_en) begin
                if (cnt_bit == 4'h0) begin
					tx_data <= {1'b0, uart_din, 1'b0}; // 1-bit parity, 8-bit data, 1-bit start
                end

				else begin
					tx_data <= {1'b1, tx_data[9:1]}; // stop bit = 1
                end
			end
		end

		else begin
			tx_data <= 10'h3FF;
		end
	end
end

endmodule