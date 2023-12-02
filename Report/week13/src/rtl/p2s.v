// Ver.2

module p2s(
    clk,
    n_rst,
    din,
    load,
    send,
    data,
    vld
);

input   clk;
input   n_rst;

input   [3:0]   din;
input           load;
input           send;

output  reg     data;
output  reg     vld;

reg     [3:0]   tmp_din;

// vld FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        vld <= 1'b0;
    end

    else begin
        vld <= send;
    end
end

// data FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        data <= 1'b0;
    end

    else begin
        if (send == 1'b1 && load == 1'b0) begin
            data <= tmp_din[0];

        end

        else begin
            data <= 1'b0;
        end
    end
end

// tmp_din FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        tmp_din <= 4'b0000;
    end

    else begin 
        if (send == 1'b1 && load == 1'b0) begin
            tmp_din <= {1'b0, tmp_din[3:1]};
        end

        else begin
            tmp_din <= din;
        end
    end

end

endmodule
