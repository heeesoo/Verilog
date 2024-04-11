// Ver.2

module top(
    clk,
    n_rst,
    din,
    load,
    send,
    dout,
    dout_vld
);

input           clk;
input           n_rst;

input   [3:0]   din;
input           load;
input           send;

output  [3:0]   dout;
output          dout_vld;


wire             data;
wire             vld;


p2s u_p2s(
    .clk(clk),
    .n_rst(n_rst),
    .din(din),
    .load(load),
    .send(send),
    .data(data),
    .vld(vld)
);


s2p u_s2p(
    .clk(clk),
    .n_rst(n_rst),
    .din(din),
    .data(data),
    .vld(vld),
    .dout(dout),
    .dout_vld(dout_vld)
);



endmodule


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