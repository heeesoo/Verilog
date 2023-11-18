/*
module sign_adder_8bit(
    din0,
    din1,
    dout
);

input [7:0] din0;
input [7:0] din1;

output [7:0] dout;

sign_adder_4bit u_sa4_0(.din0(din0[3:0]), .din1(din1[3:0]), .dout(dout[3:0]));
sign_adder_4bit u_sa4_1(.din0(din0[7:4]), .din1(din1[7:4]), .dout(dout[7:4]));


endmodule


module sign_adder_4bit(
    din0,
    din1,
    dout
);

input [3:0] din0;
input [3:0] din1;

output [3:0] dout;

sign_adder_2bit u_sa2_0(.din0(din0[1:0]), .din1(din1[1:0]), .dout(dout[1:0]));
sign_adder_2bit u_sa2_1(.din0(din0[3:2]), .din1(din1[3:2]), .dout(dout[3:2]));

endmodule


module sign_adder_2bit(
    din0,
    din1,
    dout
);

input [1:0] din0;
input [1:0] din1;

output [1:0] dout;

sign_adder_1bit u_sa1_0(.din0(din0[0]), .din1(din1[0]), .dout(dout[0]));
sign_adder_1bit u_sa1_1(.din0(din0[1]), .din1(din1[1]), .dout(dout[1]));

endmodule

module sign_adder_1bit(
    din0,
    din1,
    dout
);

input din0;
input din1;

output dout;

assign dout = din0 | din1;

endmodule
*/

module hw_always_if(
    input [2:0] din0,
    input signed [2:0] din1,
    input [1:0] sel,

    output reg [2:0] dout
);

always @(sel)begin

    if (sel == 2'h1)
        dout <= din0 + din1;

    else if (sel == 2'h2)
        dout <= din0 + (~din1) + 1'h1;

    else if (sel == 2'h3)
        dout <= din0 & din1;

    else
        dout <= din0 >> 1;

end

endmodule
/*

module hw_assign(
    input [2:0] din0,
    input signed [2:0] din1,
    input [1:0] sel,

    output [2:0] dout
);

wire sel_0;
wire sel_1;
wire sel_2;
wire sel_3;

assign sel_0 = din0 + din1;
assign sel_1 = din0 + (~din1) + 1'h1;
assign sel_2 = din0 & din1;
assign sel_3 = din0 >> 1;

assign dout = (sel == 1'h0) ? sel_0 
                : (sel == 1'h1) ? sel_1
                : (sel == 1'h2) ? sel_2
                : sel_3;

endmodule
*/