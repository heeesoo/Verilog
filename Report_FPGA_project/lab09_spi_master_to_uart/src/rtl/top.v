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
   input [8:0]  sw,  // sw[8] = select signal switch, sw[7:0] = slide switch
   input        sdata,
   input        baudrate,

   // This Output is spi_master module output.
   output       sclk,
   output       cs_n,
   output [7:0] data_out,
   output reg [7:0] led,

   // This Output is uart_tx module output.
   output       done,   // uart_tx done
   output       txd // tx module output uart_txd
);

wire        next_start;

// Output of byte_2_ascii module
wire [7:0]  data_o;
wire        next_s;

// Uart_tx input Data
reg  [7:0]  uart_input_data;
wire txd_n;


// DATA MUX
always @(*) begin
    case(sw[8])
        1'b1: begin
            uart_input_data = data_o;
            led = uart_input_data;
        end

        1'b0: begin
            uart_input_data = sw[7:0];
            led = uart_input_data;
        end

        default: begin
            uart_input_data = 8'h00;
            led = uart_input_data;   
        end 

    endcase
end


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
    .done(done) 
);

assign txd = ~txd_n;

endmodule