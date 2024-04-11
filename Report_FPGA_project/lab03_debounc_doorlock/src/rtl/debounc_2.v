module debounc_2 (
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
		cnt <= ((cnt_restart == 1'b1) && (cnt == 20'h0_0000))? T_20MS :
			   (cnt > 20'h0_0000)? cnt - 20'h0_0001 : cnt;
	end
end

always @(posedge clk or negedge n_rst) begin
	if(!n_rst) begin
		dout_rdy <= 1'b0;
	end

	else begin
		dout_rdy <= ((cnt == 20'h0) && (cnt_restart == 1'b1)) ? din : dout_rdy;
		// cnt가 8일 때, restart가 1이면 dout은 din, 즉 사용자의 버튼 신호에 영향을 받아야한다.
		// d1의 신호에 영향을 받으면 한 클럭씩 뒤로 밀리기 때문에 사용자의 버튼 신호의 영향을 받는다.
		// 당연히 사용자의 신호에 영향을 받으면 d1이 생성되기 전이므로 restart는 1일 것이다.
	end	
end

assign dout = dout_rdy;

endmodule