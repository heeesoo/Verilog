module s2p(
    clk,
    n_rst,
    din,
    data,
    vld,
    dout,
    dout_vld
);

input                   clk;
input                   n_rst;

input                   din;
input                   data;
input                   vld;

output  reg     [3:0]   dout;  
output  reg             dout_vld;

// dout FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        dout <= 4'b0000;
    end

    else begin
        if (vld == 1'b1) begin
            if (data == 1'b1) begin
                dout[3] <= 1'b1;
                dout <= {1'b0, dout[3:1]};
            end

            else begin // data == 1'b0
                dout[3] <= 1'b0;
                dout <= {1'b0, dout[3:1]};
            end
        end

        else begin // vld == 1'b0
            dout <= dout;
        end
    end
end


// dout_vld FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        dout_vld <= 1'b0;
    end

    else begin
        if (dout == din) begin
            dout_vld <= 1'b1;
        end

        else begin
            dout_vld <= 1'b0;
        end

    end
            
end

endmodule