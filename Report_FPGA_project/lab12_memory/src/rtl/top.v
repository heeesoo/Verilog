module top#(
    parameter D_WIDTH = 8,
    parameter A_WIDTH = 4
)(
    input                   clk,
    input                   n_rst,
    input                   rx_done,
    input [D_WIDTH-1:0]     rx_data,
    input                   push_sw,

    output [D_WIDTH-1:0]    fnd_data
);

// mem_controller to ram_dual Wire
wire [A_WIDTH-1:0]      w_addr_w;
wire                    w_en_w;
wire [D_WIDTH-1:0]      w_data_w;

wire [A_WIDTH-1:0]      r_addr_w;
wire [D_WIDTH-1:0]      r_data_w;

// Mem_controller Instance
mem_controller #(
  .D_WIDTH(D_WIDTH),
  .A_WIDTH(A_WIDTH)
) u_mem_controller(
  .clk(clk),
  .n_rst(n_rst),
  .rx_done(rx_done),
  .rx_data(rx_data),
  .r_en(push_sw),
  .w_addr(w_addr_w),
  .w_en(w_en_w),
  .w_data(w_data_w),
  .r_addr(r_addr_w),
  .r_data(r_data_w),
  .fnd_data(fnd_data)
);

// Ram_16x8 Instance
ram_dual_16x8 #( 
  .D_WIDTH(D_WIDTH),
  .A_WIDTH(A_WIDTH)
) u_ram_dual_16x8(
  .clk(clk),
  .wdata(w_data_w),
  .waddr(w_addr_w),
  .wen(w_en_w),
  .raddr(r_addr_w),
  .rdata(r_data_w)
);

endmodule