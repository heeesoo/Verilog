module top(
	clk,
	n_rst,
	bt,
	btstar,
	led
	//fnd_en
);

parameter T_1S = 26'h2FA_F080; // d50_000_000;
parameter T_20MS = 20'hF_4240; // d1_000_000;

input clk;
input n_rst;
input [9:0] bt;
input btstar;

output led;
//output [6:0] fnd_en;

wire [9:0] bt_w;
wire btstar_w;
wire led_w;
//wire [6:0] fnd_en_w;

bd_if #(
	.T_1S(T_1S),
	.T_20MS(T_20MS)
) u_bd_if(
    .clk(clk),
    .n_rst(n_rst),
 
    .bt_i(bt),
    .btstar_i(btstar),

    //.fnd_i(fnd_en_w),
    .led_i(led_w),

    .bt_o(bt_w),
    .btstar_o(btstar_w),

    // .fnd_o(fnd_en),
    
    .led_o(led)
);


doorlock u_doorlock(
    .clk(clk), 
    .n_rst(n_rst),
 
    .bt(bt_w),
    .btstar(btstar_w),

    //.fnd_en(fnd_en_w),
    .led(led_w)
);


endmodule