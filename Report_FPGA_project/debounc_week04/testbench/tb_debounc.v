`timescale 1ns/10ps
`define T_CLK 10
`define SIM

module tb_debounc;
`ifdef SIM
parameter [25:0] T_1S = 26'h000_000F; // d50_000_000;
parameter [19:0] T_20MS = 20'h00008; // d50_000_000;
`else
parameter [25:0] T_1S = 26'h2FA_F080; // d50_000_000;
parameter [19:0] T_20MS = 20'hF_4240; // d1_000_000;
`endif

reg clk;
reg n_rst;
reg bt;

wire dout;


debounc_2 #(
    .T_20MS(T_20MS)
) u_debounc_2(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt),
    .dout(dout)
);

initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    #(`T_CLK*2.2) n_rst = 1'b1;
end

always #(`T_CLK/2) clk = ~clk;

initial begin
    bt = 1'b0;

    wait(n_rst == 1'b1);
    #(`T_CLK*10)    bt = 1'b1;
    #(`T_CLK*2)     bt = 1'b0;
    #(`T_CLK)       bt = 1'b1;
    #(`T_CLK*3)     bt = 1'b0;
    #(`T_CLK)       bt = 1'b1;
    #(`T_CLK*10)    bt = 1'b0;
    #(`T_CLK)       bt = 1'b1;
    #(`T_CLK*3)     bt = 1'b0;
    #(`T_CLK)       bt = 1'b1;
    #(`T_CLK*2)     bt = 1'b0;
    #(`T_CLK*10)    $stop;

/*  #(`T_CLK*10)  bt = 1'b1;
    #(`T_CLK*2)   bt = 1'b0;
    #(`T_CLK*3)   bt = 1'b1;
    #(`T_CLK)     bt = 1'b0;
    #(`T_CLK*2)   bt = 1'b1;
    #(`T_CLK*10)  bt = 1'b0;
    #(`T_CLK*2)     bt = 1'b1;
    #(`T_CLK*2)   bt = 1'b0;
    #(`T_CLK*2)   bt = 1'b1;
    #(`T_CLK*10)  bt = 1'b0;
*/

end



endmodule