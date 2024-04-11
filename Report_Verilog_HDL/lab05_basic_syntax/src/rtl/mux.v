module mux_8x1(
    input [7:0] din,
    input [2:0] sel,

    output reg dout
);

always @(*) begin
    
    case(sel)
        3'b000 : dout = din[0];

        3'b001 : dout = din[1];

        3'b010 : dout = din[2];

        3'b011 : dout = din[3];

        3'b100 : dout = din[4];

        3'b101 : dout = din[5];

        3'b110 : dout = din[6];

        3'b111 : dout = din[7];

        default : dout = 1'b0;
    endcase

end


endmodule
