module decoder_4x16 (
    din,
    dout
);

// input din [3:0];
input [3:0] din;  // 메모리 선언 위치와 변수 선언 위치를 바꿨습니다.

output [15:0] dout;

wire [3:0] dec_4_dout;  // 메모리 공간을 4bit로 설정해줍니다.
// wire dec_t_dout;

decoder_2x4 u_decoder_2x4_0 (
    .en(dec_4_dout[0]),
    .din(din[1:0]),
    .dout(dout[3:0])
);

decoder_2x4 u_decoder_2x4_1 (
    .en(dec_4_dout[1]),
    .din(din[1:0]),
    .dout(dout[7:4])
);

decoder_2x4 u_decoder_2x4_2 (
    .en(dec_4_dout[2]),
    .din(din[1:0]),
    .dout(dout[11:8])
);

decoder_2x4 u_decoder_2x4_3 (
    .en(dec_4_dout[3]),
    .din(din[1:0]),
    .dout(dout[15:12])
);

decoder_2x4 u_decoder_2x4_4 (
    .en(1'b1),
    .din(din[3:2]),
    .dout(dec_4_dout)
);

endmodule

