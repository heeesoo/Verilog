module uart_tx(
    clk,
    n_rst,
    start,
    din,
    uart_txd,
    done
);

parameter T_DIV = 13'd7;    // 0- 7 : 8
parameter T_DIV_HALF = 13'd3;   // 0- 3 : 4

input               clk;
input               n_rst;

input               start;
input   [T_DIV:0]   din;

output  reg         done;
output  reg         uart_txd;

reg                         tx_en;
reg     [2:0]               cnt;
reg     [T_DIV_HALF:0]      cnt_bit;    // 5bit cnt_bit 선언
reg     [T_DIV:0]           buffer;

wire                        cnt_tx_en;

// tx_en Flip Flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        tx_en <= 1'b0;
    end

    else begin 
        if ((din != 2'h0) && (start)) begin
            tx_en <= 1'b1;
        end

        else if (done) begin
            tx_en <= 1'b0;
        end

        else begin 
            tx_en <= tx_en;
        end
    end
end


// cnt_tx_en Combinational Logic
assign cnt_tx_en = (cnt == T_DIV)? 1'b1 : 1'b0;


// cnt Flip Flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt <= 3'b000;
    end

    else begin 
        if (tx_en) begin
            if (cnt <= T_DIV) begin
                cnt <= cnt + 3'b001;
            end

            else begin 
                cnt <= 3'b000;
            end
        end

        else begin
            cnt <= 3'b000;
        end
    end 
end


// cnt_bit Flip Flop 
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin 
        cnt_bit <= 5'h0;
    end
    
    else begin
        if ((tx_en) && (cnt_tx_en)) begin 
            if (cnt_bit < 5'hB) begin
                cnt_bit <= cnt_bit + 5'h1;
            end

            else if (cnt_bit == 5'hB) begin
                cnt_bit <= 5'h0;
            end

            else begin
                cnt_bit <= cnt_bit;
            end
        end

        else begin 
            cnt_bit <= cnt_bit;
        end
    end
end


// done Flip Flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        done <= 1'b0;
    end

    else begin 
        if ((cnt_bit == 5'hB) && (cnt_tx_en)) begin
            done <= 1'b1;
        end

        else begin 
            done <= 1'b0;
        end
    end
end


// Assignment uart_txd Flip Flop
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        uart_txd <= 1'b1;   
    end

    else begin
        if (cnt_tx_en & (cnt_bit == 5'h0)) begin
            uart_txd <= 1'b0;
        end
        
        else begin
            uart_txd <= (tx_en && cnt_tx_en)? buffer[0] : 
                            (tx_en)? uart_txd : 1'b1;
        end
    end
end


// buffer Flip Flop 
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        buffer <= 9'h00;
    end

    else begin 
        if (cnt_tx_en) begin
            // cnt_tx_en이 0일 때
            if (cnt_bit == 5'h0) begin
                buffer <= din;
            end

            else if ((cnt_bit >= 5'h1) && (cnt_bit < 5'h7)) begin
                buffer <= {2'b0, buffer[6:1]};
            end

            else if (cnt_bit == 5'h7) begin
                buffer <= 9'h00;
            end

            else if (cnt_bit == 5'h9) begin
                buffer <= 9'h01;
            end

            else if (cnt_bit == 5'hA) begin
                buffer <= 9'h01;
            end

            else begin 
                buffer <= buffer;
            end
        end

        else begin 
            buffer <= buffer;
        end
    end
end


endmodule