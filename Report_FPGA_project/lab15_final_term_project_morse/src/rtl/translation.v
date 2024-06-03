//`define SIM
//`define CP

module translation(
    input clk,
    input n_rst,
    input [4:0] din,
    input [2:0] cnt_number,
    input trans_start,
    input space,

    output [7:0] dout,
    output trans_done
);

`ifdef SIM
parameter T_BIT = 4;
parameter T_1S = 4'd5;
`else 
parameter T_BIT = 26;
parameter T_1S = 26'h2FA_F080; // d50_000_000;
`endif

reg a, b, c, d, e, f, g, h; // fnd display data 위치

assign trans_done = trans_start;   // by to pass trans_done to trans_start

// cnt_number를 통해 입력하는 숫자의 개수에 따라 fnd에 표시할 데이터를 ascii 코드로 바꾸는 역할이다
always @(*) begin
  if (cnt_number == 3'h1) begin   
    case(din)
      5'h00 : {a, b, c, d, e, f, g, h} = 8'h45;
      5'h10 : {a, b, c, d, e, f, g, h} = 8'h54;
      default : {a, b, c, d, e, f, g, h} = 8'h00;
    endcase
  end
  
  else if (cnt_number == 3'h2) begin
    case(din)
      5'h00 : {a, b, c, d, e, f, g, h} = 8'h49;
      5'h08 : {a, b, c, d, e, f, g, h} = 8'h41;
      5'h10 : {a, b, c, d, e, f, g, h} = 8'h4E;
      5'h18 : {a, b, c, d, e, f, g, h} = 8'h4D;
      default : {a, b, c, d, e, f, g, h} = 8'h00;
    endcase
  end
  
  else if (cnt_number == 3'h3) begin
    case(din)
      5'h10 : {a, b, c, d, e, f, g, h} = 8'h44;
      5'h18 : {a, b, c, d, e, f, g, h} = 8'h47;
      5'h14 : {a, b, c, d, e, f, g, h} = 8'h4b;
      5'h1c : {a, b, c, d, e, f, g, h} = 8'h4f;
      5'h08 : {a, b, c, d, e, f, g, h} = 8'h52;
      5'h00 : {a, b, c, d, e, f, g, h} = 8'h53;
      5'h04 : {a, b, c, d, e, f, g, h} = 8'h55;
      5'h0c : {a, b, c, d, e, f, g, h} = 8'h57;
      default : {a, b, c, d, e, f, g, h} = 8'h00;
    endcase
  end
  
  else if (cnt_number == 3'h4) begin
    case(din)
      5'b1_0000: {a, b, c, d, e, f, g, h} = 8'h42;  // B
      5'b1_0100: {a, b, c, d, e, f, g, h} = 8'h43;  // C
      5'b0_0100: {a, b, c, d, e, f, g, h} = 8'h46;  // F
      5'b0_0000: {a, b, c, d, e, f, g, h} = 8'h48;  // H
      5'b0_1110: {a, b, c, d, e, f, g, h} = 8'h4A;  // J
      5'b0_1000: {a, b, c, d, e, f, g, h} = 8'h4C;  // L
      5'b0_1100: {a, b, c, d, e, f, g, h} = 8'h50;  // P
      5'b1_1010: {a, b, c, d, e, f, g, h} = 8'h51;  // Q
      5'b0_0010: {a, b, c, d, e, f, g, h} = 8'h56;  // V
      5'b1_0010: {a, b, c, d, e, f, g, h} = 8'h58;  // X
      5'b1_0110: {a, b, c, d, e, f, g, h} = 8'h59;  // Y
      5'b1_1000: {a, b, c, d, e, f, g, h} = 8'h5A;  // Z
      default : {a, b, c, d, e, f, g, h} = 8'h00;
    endcase
  end
  
  else if (cnt_number == 3'h5) begin  // 모스부호의 cnt_number가 5일 때는 숫자를 입력받는다.
    case(din)
      5'h0f : {a, b, c, d, e, f, g, h} = 8'h31;
      5'h07 : {a, b, c, d, e, f, g, h} = 8'h32;
      5'h03 : {a, b, c, d, e, f, g, h} = 8'h33;
      5'h01 : {a, b, c, d, e, f, g, h} = 8'h34;
      5'h00 : {a, b, c, d, e, f, g, h} = 8'h35;
      5'h10 : {a, b, c, d, e, f, g, h} = 8'h36;
      5'h18 : {a, b, c, d, e, f, g, h} = 8'h37;
      5'h1c : {a, b, c, d, e, f, g, h} = 8'h38;
      5'h1e : {a, b, c, d, e, f, g, h} = 8'h39;
      5'h1f : {a, b, c, d, e, f, g, h} = 8'h30;
      default : {a, b, c, d, e, f, g, h} = 8'h00;
    endcase
  end
  
  else begin
    {a, b, c, d, e, f, g, h} = 8'h00; 
  end
end

// space 버튼은 morse 부호에서 원래는 없지만 uart 상으로 가독성을 높이기 위해 사용
// 실제로는 어느정도 delay를 통해 띄어쓰기를 전달.
assign dout = (space) ? 8'h20 : {a, b, c, d, e, f, g, h} ;


endmodule
