`timescale 1ns/10ps
`define T_CLK 10
`define SIM

module tb_doorlock;
`ifdef SIM
parameter [25:0] T_1S = 26'h000_000F; // d50_000_000;
parameter [19:0] T_20MS = 20'h00008; // d50_000_000;
`else
parameter [25:0] T_1S = 26'h2FA_F080; // d50_000_000;
parameter [19:0] T_20MS = 20'hF_4240; // d1_000_000;
`endif

reg clk;
reg n_rst;

reg [9:0] bt;
reg btstar;

wire led;


initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    #(`T_CLK*2.2) n_rst = 1'b1;
end

always #(`T_CLK/2) clk = ~clk;

//integer i;

// wire [6:0] fnd;

top #(
	.T_1S(T_1S),
	.T_20MS(T_20MS)
) u_top(
    .clk(clk),
    .n_rst(n_rst),
    .bt(bt),
    .btstar(btstar),
    // .fnd_en(fnd),
    .led(led)
);


integer cnt_led;
integer cnt_open;

initial begin
    bt = 10'h000;
    btstar = 1'b1;
    cnt_open = 0;
    //i = 1;

    wait(n_rst == 1'b1);
    #(`T_CLK*5) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;
    cnt_open = cnt_open + 1;

    #(`T_CLK*25) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*20) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;
    cnt_open = cnt_open + 1;

    #(`T_CLK*25) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;
    cnt_open = cnt_open + 1;

    #(`T_CLK*25) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;
    cnt_open = cnt_open + 1;

    #(`T_CLK*25) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;
    cnt_open = cnt_open + 1;

    #(`T_CLK*25) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*20) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;

    #(`T_CLK*25) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*20) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;

    #(`T_CLK*5) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;

    #(`T_CLK*25) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*20) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*3) bt[1] = 1'b0;
    #(`T_CLK*1) bt[1] = 1'b1;
    #(`T_CLK*2) bt[1] = 1'b0;

    #(`T_CLK*5) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*20) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*3) bt[2] = 1'b0;
    #(`T_CLK*1) bt[2] = 1'b1;
    #(`T_CLK*2) bt[2] = 1'b0;

    #(`T_CLK*5) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*20) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*3) bt[7] = 1'b0;
    #(`T_CLK*1) bt[7] = 1'b1;
    #(`T_CLK*2) bt[7] = 1'b0;

    #(`T_CLK*5) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*20) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*3) bt[5] = 1'b0;
    #(`T_CLK*1) bt[5] = 1'b1;
    #(`T_CLK*2) bt[5] = 1'b0;

    #(`T_CLK*1) btstar = 1'b0;
    #(`T_CLK*20) btstar = 1'b1;

    #(`T_CLK*3) 
    $display("Open : %d ",cnt_open);
    if (cnt_led > cnt_open) begin
        $display("$t : error",$time);
        $display("LED : %d", cnt_led);
    end
	wait (led == 1'b0);
	#(`T_CLK*0.2);
    $stop;
end

initial cnt_led = 0;

always @(posedge led)
    //if (led == 1'b1) 
		cnt_led = cnt_led + 1;


endmodule