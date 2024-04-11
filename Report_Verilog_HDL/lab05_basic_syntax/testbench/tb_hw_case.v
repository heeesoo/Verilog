`timescale 1ns/100ps

module tb_hw_case;
reg [2:0] din0; // 빈 공간을 reg로 고침.
reg [2:0] din1; // 빈 공간을 reg로 고침.
reg [1:0] sel; // 빈 공간을 reg로 고침.

wire [2:0] dout; // 빈 공간을 wire로 고침.

initial begin
    din0 = 3'h2;
    din1 = 3'h1;
    sel = 2'h0;
    #(10) sel = 2'h1;
    #(10) sel = 2'h2;
    #(10) sel = 2'h3;
    #(10)

    din0 = 3'h3; // 빈 공간을 3'h3으로 고침.
    din1 = 3'h6; // 빈 공간을 3'h6으로 고침.
    sel = 2'h0; // 빈 공간을 2'h0으로 고침.
    #(10) sel = 2'h1; // 빈 공간을 2'h1으로 고침.
    #(10) sel = 2'h2; // 빈 공간을 2'h2으로 고침.
    #(10) sel = 2'h3; // 빈 공간을 2'h3으로 고침.
    #(10) $stop;
end

cal_case u_hw_case(
    .din0(din0), // 빈 공간을 .din0(din0)으로 고침.
    .din1(din1), // 빈 공간을 .din1(din1)으로 고침.
    .sel(sel), // 빈 공간을 .sel(sel)으로 고침.
    .dout(dout) // 빈 공간을 .dout(dout)으로 고침.
); 

endmodule
