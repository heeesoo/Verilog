module debounc_3 (
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
		cnt <= ((cnt_restart == 1'b1) && (cnt == 1'b0))? T_20MS :
			   (cnt > 20'h0_0000)? cnt - 20'h0_0001 : cnt;
	end
end

always @(posedge clk or negedge n_rst) begin
	if(!n_rst) begin
		dout_rdy <= 1'b0;
	end

	else begin
		dout_rdy <= ((cnt == 20'h0_0000) && (cnt_restart == 1'b0))? din : dout_rdy;
		// cnt가 0인 상태에서 restart가 0이여야 dout에 사용자의 입력값 din, 즉 bt값이 들어간다.
		// 시뮬레이션 처음에 0일 때는 din의 값이 입력되니 다음 클럭부터 cnt가 8부터 하나씩 내려가서
		// dout이 0이였지만 다 끝나고 cnt가 0이 되었을 때 din의 신호가 들어가니 dout도 그 신호를 따라간다.
	end	
end

assign dout = dout_rdy;

endmodule