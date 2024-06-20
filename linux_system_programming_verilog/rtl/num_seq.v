module num_seq(
	input	clk,
	input	n_rst,
	output	[3:0] num
);

reg	[2:0]	cnt;

always @(posedge clk or negedge n_rst) begin
	if (!n_rst) begin
		cnt <= 3'h0;
	end

	else begin 
		if (cnt == 3'h7) begin
			cnt <= 3'h0;
		end

		else begin 
			cnt <= cnt + 3'h1;
		end
	end
end

assign num = (cnt == 3'h0)? 4'h2 : 
				(cnt == 3'h1)? 4'h0 :
				(cnt == 3'h2)? 4'h1 :
				(cnt == 3'h3)? 4'h7 : 
				(cnt == 3'h4)? 4'h0 :
				(cnt == 3'h5)? 4'h3 : 
				(cnt == 3'h6)? 4'h0 :
				(cnt == 3'h7)? 4'h1 : 4'h0;
	
endmodule
