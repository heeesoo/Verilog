module debounc_1 (
	clk,
	n_rst,
	din,
	dout
);

parameter T_20MS = 20'hF_4240; // d1_000_000;

input clk;
input n_rst;
input din;
output dout;

reg [19:0] cnt;
wire cnt_restart;

reg din_d1; 
reg dout_rdy;

always @(posedge clk or negedge n_rst) begin
	if(!n_rst) begin
		din_d1 <= 1'b0;
	end
	
	else begin
		din_d1 <= din;
	end
end

assign cnt_restart = (din != din_d1)? 1'b1 : 1'b0;

always @(posedge clk or negedge n_rst) begin
	if(!n_rst) begin
		cnt <= 20'h0_0000;
	end

	else begin
		cnt <= (cnt_restart == 1'b1)? T_20MS :
			   (cnt > 20'h0_0000)? cnt - 20'h0_0001 : cnt;
	end
end

always @(posedge clk or negedge n_rst) begin
	if(!n_rst) begin
		dout_rdy <= 1'b0;
	end

	else begin
		dout_rdy <= ((cnt == 20'h0_0000) && (cnt_restart == 1'b0))? din : dout_rdy;
	end	
end

assign dout = dout_rdy;

endmodule

