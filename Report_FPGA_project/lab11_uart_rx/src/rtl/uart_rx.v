`define SIM
`define CP
// 위의 define SIM, CP는 Modelsim simulation시에만 이용

module uart_rx#(    
    `ifdef SIM
    parameter T_DIV_BIT    = 4,   //  2-bit
    parameter T_DIV_0      = 4'd15, // 0-15 : 16 // 50 MHz clock -> 9,600 rate
    parameter T_DIV_HALF_0 = 4'd7,  // 0- 7file : 8
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
    
    input        baudrate,  // 0 : 9600, 1 : 19200...
    input        uart_rxd,  
    
    output           rx_done,   
    output     [7:0] rx_data    
);

reg [T_DIV_BIT-1:0]   cnt;  
reg [T_DIV_BIT-1:0]   cnt_rx_bit;

reg [7:0]   temp;

reg         rxin_d1;
reg         rxin_d2;
reg         rxin_d3;

reg         start_en;
reg         rx_en;

wire        clk_rx_en;


// rx_data "temp" flip flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        temp <= 8'h00;
    end

    else begin
        if (rx_en && clk_rx_en) begin
            if ((cnt_rx_bit >=  4'h1) && (cnt_rx_bit < 4'hA)) begin
                temp <= {uart_rxd, temp[7:1]};
                // cnt
            end

            else begin 
                temp <= temp;
            end
        end

        else begin 
            temp <= temp;
        end
    end     
end

// rx_data Combinational Logic
assign rx_data = temp;


// rxin_delay flip flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        rxin_d1 <= 1'b0;
        rxin_d2 <= 1'b0;
        rxin_d3 <= 1'b0;
    end

    else begin
        rxin_d1 <= uart_rxd;
        rxin_d2 <= rxin_d1;
        rxin_d3 <= rxin_d2;
    end
end

// start_en flip flop (edge detector)
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        start_en <= 1'b0;
    end

    else begin
        if ((rx_en == 1'b0) && (rxin_d2 == 1'b0) && (rxin_d3 == 1'b1)) begin
            start_en <= 1'b1;
        end

        else begin
            start_en <= 1'b0;
        end
    end
end

// rx_en flip flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        rx_en <= 1'b0;
    end

    else begin
        if (start_en) begin
            rx_en <= 1'b1;
        end

        else if ((cnt_rx_bit == 4'hA) && (clk_rx_en)) begin
            rx_en <= 1'b0;
        end

        else begin
            rx_en <= rx_en;
        end
    end
end

//  cnt flip flop       
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt <= 4'h0;
    end

    else begin
        if (rx_en) begin
            if (cnt < T_DIV_0) begin 
                cnt <= cnt + 4'h1;
            end

            else if (cnt >= T_DIV_HALF_0) begin
                cnt <= 4'h0;
            end

            else begin
                cnt <= cnt;
            end
        end

        else begin
            cnt <= 4'h0;
        end
    end
end

// clk_rx_en Combinational Logic
assign clk_rx_en = ((cnt_rx_bit != 4'h0) && (cnt == {(T_DIV_BIT){1'd3}}))? 1'b1 : 1'b0; 

// cnt_rx_bit 
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt_rx_bit <= 4'h0;
    end

    else begin
        if (clk_rx_en || start_en) begin
            cnt_rx_bit <= cnt_rx_bit + 4'h1;
        end

        else if (!rx_en) begin
            cnt_rx_bit <= 4'h0;
        end
            
        else begin
            cnt_rx_bit <= cnt_rx_bit;
        end
    end
end

// rx_done 
assign rx_done = ((cnt_rx_bit == 4'hA) && (clk_rx_en))? 1'b1 : 1'b0;


endmodule       