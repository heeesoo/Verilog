module spi_slave_adc(
    sclk,
    n_rst,
    data,
    cs_n,
    sdata
);  

input           sclk;
input           n_rst;
input   [7:0]   data;
input           cs_n;

output   reg    sdata;

reg     [4:0]   cnt;
reg     [7:0]   temp;

// Assignment sdata 
assign sdata = (cs_n == 1'b1) ? 1'hz : (cnt > 5'hF) ? 1'hz : temp[7];

// sdata Flip Flop
always @(negedge sclk or negedge n_rst) begin
    if (!n_rst) begin
        temp <= 8'b0;
    end

    else begin
        if ((cnt == 5'h1) || (cnt == 5'hB)) begin
            temp <= 8'h0;
        end

        else if (cnt == 5'h3) begin
            temp <= data;
        end
        
        else begin
            temp <= {temp[6:0], 1'b0};
        end
    end
end

// Counter Flip Flop
always @(negedge sclk or negedge n_rst) begin
    if (!n_rst) begin
        cnt <= 5'h0;
    end

    else begin
        cnt <= cnt + 5'h1;
    end
end


endmodule