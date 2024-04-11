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
    .data(data),
    .vld(vld),
    .dout(dout),
    .dout_vld(dout_vld)
);



endmodule