
`timescale 1ns/1ps

module tb_de0_led_slider;
reg [3:0] din;

wire [7:0] dout;
wire [6:0] fnd_30_out;
wire [6:0] fnd_74_out;

integer i;

initial begin
    din = 4'h0;
    for (i=0;i<=9;i=i+1) begin
        #10;
        din = i;
    end

    #10;
    $stop;
end

de0_led_slider u_de0_led_slider(
    .din(din),
    .dout(dout),
    .fnd_30_out(fnd_30_out),
    .fnd_74_out(fnd_74_out)
);
endmodule


