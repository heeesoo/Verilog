`timescale 1ns/100ps

module testbench;
reg [3:0] din;

wire [15:0] dout;

decoder_4x16 u_decoder_4x16 (  // decoder_2x4를 decoder_2x4로 바꾸었습니다.
    .din(din),
    .dout(dout)
);

integer i;

initial begin
    din = 4'h0;

    for (i=0;i<16;i=i+1) begin
        #5 din = din + 4'h1;
    end
    
    #5 $stop;
end

initial begin
    $monitor(" %h => %h", din, dout);

end

endmodule



















/*
module add_4bit(
    input [3:0] a,
    input [3:0] b,
    output [3:0] out
);


add_1bit u_add_1bit_0(.a_i(a[0]), .b_i(b[0]), .out(out[0]));
add_1bit u_add_1bit_1(.a_i(a[1]), .b_i(b[1]), .out(out[1]));
add_1bit u_add_1bit_2(.a_i(a[2]), .b_i(b[2]), .out(out[2]));
add_1bit u_add_1bit_3(.a_i(a[3]), .b_i(b[3]), .out(out[3]));


endmodule

module add_1bit(
    input a_i,
    input b_i,
    output out_i
);

assign out_i =  a_i + b_i;

endmodule 
*/