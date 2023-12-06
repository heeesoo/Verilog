module s2p(
    clk,
    n_rst,
    data,
    vld,
    dout,
    dout_vld
);

input       clk;
input       n_rst;

input       data;
input       vld;

output  reg     [3:0]   dout;
output  reg             dout_vld;

reg     [1:0]   cnt;


// Sequential Logic
// 4bit dout FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        dout <= 4'b0000;
    end

    else begin
        if (vld == 1'b1) begin
            dout <= {data, dout[3:1]};
        end

        else begin
            dout <= dout;
        end
    end
end


// counter FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt <= 2'b00;
    end

    else begin 
        if (vld == 1'b1) begin
            cnt <= cnt + 2'b01;
        end

        else begin
            cnt <= cnt;
        end
    end
end

// dout_vld FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        dout_vld <= 1'b0;
    end

    else begin
        if (vld == 1'b1 && cnt == 2'b11) begin
            dout_vld <= 1'b1;
        end

        else begin
            dout_vld <= 1'b0;
        end
    end
end


endmodule