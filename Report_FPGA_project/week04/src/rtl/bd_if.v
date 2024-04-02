module bd_if(
    clk,
    n_rst,
    bt_i,
    btstar_i,
    led_i,
    bt_o,
    btstar_o,
    led_o
    //fnd_o
);

parameter T_1S = 26'h2FA_F080;
parameter T_20MS = 20'hF_4240;
// 실제 FPGA 구현할 때 사용할 값

input clk;
input n_rst;
input [9:0] bt_i;
input btstar_i;
input led_i;

output [9:0] bt_o;
output btstar_o;
output led_o;
// output [6:0] fnd_o;

wire [9:0] bt_w;

// debounc_1
debounc_1 #(.T_20MS(T_20MS)) u_debounc_1(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[0]),
    .dout(bt_w[0])
);

edge_detection u_edge_detection_1(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[0]),
    .b0_on(bt_o[0])
);

debounc_1 #(.T_20MS(T_20MS)) u_debounc_2(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[1]),
    .dout(bt_w[1])
);

edge_detection u_edge_detection_2(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[1]),
    .b0_on(bt_o[1])
);

// debounc_2
debounc_2 #(.T_20MS(T_20MS)) u_debounc_3(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[2]),
    .dout(bt_w[2])
);

edge_detection u_edge_detection_3(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[2]),
    .b0_on(bt_o[2])
);

debounc_2 #(.T_20MS(T_20MS)) u_debounc_4(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[3]),
    .dout(bt_w[3])
);

edge_detection u_edge_detection_4(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[3]),
    .b0_on(bt_o[3])
);

debounc_2 #(.T_20MS(T_20MS)) u_debounc_5(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[4]),
    .dout(bt_w[4])
);

edge_detection u_edge_detection_5(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[4]),
    .b0_on(bt_o[4])
);

debounc_2 #(.T_20MS(T_20MS)) u_debounc_6(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[5]),
    .dout(bt_w[5])
);

edge_detection u_edge_detection_6(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[5]),
    .b0_on(bt_o[5])
);

// debounc_3
debounc_3 #(.T_20MS(T_20MS)) u_debounc_7(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[6]),
    .dout(bt_w[6])
);

edge_detection u_edge_detection_7(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[6]),
    .b0_on(bt_o[6])
);

debounc_3 #(.T_20MS(T_20MS)) u_debounc_8(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[7]),
    .dout(bt_w[7])
);

edge_detection u_edge_detection_8(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[7]),
    .b0_on(bt_o[7])
);

debounc_3 #(.T_20MS(T_20MS)) u_debounc_9(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[8]),
    .dout(bt_w[8])
);

edge_detection u_edge_detection_9(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[8]),
    .b0_on(bt_o[8])
);

debounc_3 #(.T_20MS(T_20MS)) u_debounc_10(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_i[9]),
    .dout(bt_w[9])
);

edge_detection u_edge_detection_10(
    .clk(clk),
    .n_rst(n_rst),
    .din(bt_w[9]),
    .b0_on(bt_o[9])
);


// btstar detection
edge_detection u_detection_11(
    .clk(clk),
    .n_rst(n_rst),
    .din(~btstar_i),
    .b0_on(btstar_o)
);


// led delay instance 
delay_led #(.T_1S(T_1S)) u_delay_led(
    .clk(clk),
    .n_rst(n_rst),
    .led(led_i),
    .led_d(led_o)
);


endmodule