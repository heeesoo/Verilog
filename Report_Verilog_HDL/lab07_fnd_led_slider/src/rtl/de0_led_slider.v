/*
module de0_led_slider(
    din,
    dout,
    fnd_30_out,
    fnd_74_out
);

input [3:0] din;
output [7:0] dout;
output [6:0] fnd_30_out;
output [6:0] fnd_74_out;

assign dout[3:0] = din[3:0];
assign dout[7:4] = {2'b00, din[3:2]} + {2'b00, din[1:0]};

segement_7 u_segment_0(.number(din), .fnd_on(fnd_30_out)); 
segement_7 u_segment_1(.number(dout[7:4]), .fnd_on(fnd_74_out));  

endmodule

*/
