module fnd_decoder(
	input		[3:0]	num,
	output	reg	[6:0]	fnd_on
);

always @(*) begin
	case(num) 
		4'h1 : fnd_on = 7'b011_0000;
		4'h2 : fnd_on = 7'b110_1101;
		4'h3 : fnd_on = 7'b111_1001;
		4'h4 : fnd_on = 7'b011_0011;
		4'h5 : fnd_on = 7'b101_1011;
		4'h6 : fnd_on = 7'b101_1111;
		4'h7 : fnd_on = 7'b111_0010;
		default : fnd_on = 7'b111_1110;
	endcase
end

endmodule
