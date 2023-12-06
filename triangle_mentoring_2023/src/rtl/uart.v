
module uart(
    clk,
    n_rst,
    din,
    start,
    dout,
    final_dout
);

parameter IDLE = 2'b00;   // S_0
parameter START = 2'b01;  // S_1
parameter DATA = 2'b10;   // S_2
parameter PARITY = 2'b11; // S_3

parameter PER = 13'h1457; // cnt_period
input clk;
input n_rst;

input [7:0] din;
input start;

output reg dout;

output final_dout;


reg shift;

reg [1:0] c_state;
reg [1:0] n_state;
reg [2:0] cnt;

reg [12:0] cnt_period;  // enable counter 
reg en;
reg start_d; // start_delay
reg tx_start;
reg [7:0] d_ff;

// Sequential Logic

assign final_dout = ~dout;

// enable counter
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin   
        cnt_period <= 1'b0;
    end

    else begin
        cnt_period <= (cnt_period == PER) ? 13'h0000 : cnt_period + 13'h0001;
    end
end

// assign cnt_tmp = (cnt_period == PER) ? 4'b0101 : 4'b0000; 

// enable flip-flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        en <= 1'b0;
    end

    else begin
        if (cnt_period == 4'b0001) begin
            en <= 1'b1;
        end

        else begin
            en <= 1'b0;
        end
    end
end

// start_delay flip-flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        start_d <= 1'b0;
    end

    else begin
        if (en) begin
            start_d <= start;
        end

        else begin
            start_d <= start_d;
        end
    end 
end

// tx_start flip-flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        tx_start <= 1'b0;
    end

    else begin
        if (en) begin
            tx_start <= (start == 1'b0 && start_d == 1'b1) ? 1'b1 : 1'b0;
        end

        else begin
            tx_start <= tx_start;
        end
    end
end

// state flip-flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        c_state <= IDLE;
    end

    else begin
        if (en) begin // en == 1'b1
            c_state <= n_state;
        end

        else begin // en = 1'b0
            c_state <= c_state;
        end
    end
end

// DATA counter
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt <= IDLE;
    end

    else begin
        if (en) begin // en == 1'b1
            cnt <= (c_state == DATA) ? cnt + 3'h1 : cnt;
        end

        else begin // en == 1'b0
            cnt <= cnt;
        end
    end
end

// 8bit shift register 
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        d_ff <= 8'b1;
    end

    else begin
        if (en) begin
            if (c_state == IDLE) begin
                if (tx_start) begin
                    d_ff <= din;
                end

                else begin
                    d_ff <= d_ff;           
                end
            end

            else if (c_state == DATA) begin
                d_ff <= {1'b0, d_ff[7:1]}; 
            end

            else begin
                d_ff <= d_ff;
            end
        end

        else begin
            d_ff <= d_ff;
        end
    end
end

// dout FF 
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        dout <= 1'b0;
    end

    else begin
        if (c_state == START) begin
            dout <= 1'b0;
        end

        else if (c_state == DATA) begin
            dout <= d_ff[0];
        end

        else if (c_state == PARITY) begin
            dout <= 1'b0;
        end

        else begin
            dout <= 1'b1;
        end
    end
end


// Combinational Logic
always @(*) begin 
        case(c_state)
            IDLE : begin
                n_state = (tx_start == 1'b1) ? START : IDLE;
                shift = 1'b0;
            end

            START : begin
                n_state = DATA;
                shift = 1'b0;
            end

            DATA : begin
                n_state = (cnt == 3'h7) ? PARITY : DATA;
                shift = 1'b1;
            end

            PARITY : begin
                n_state = IDLE;
                shift = 1'b0;
            end

            default : begin        
                n_state = IDLE;
                shift = 1'b0;
            end 

        endcase
end


endmodule
