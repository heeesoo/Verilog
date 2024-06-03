
//Made by KIM, KWON, YOON
//`define SIM
//`define CP

//debounce
module debounce #(
   `ifdef SIM   //for SIM
    parameter T_1S = 4'd5,
    parameter T_20MS = 4'd1,
    parameter T_QUARTER = 4'd2
    `else 
    // 50 MHz clock -> (1/(d5208)) -> 9,600 rate
    parameter T_1S = 26'h2FA_F080, // d50_000_000;
    parameter T_20MS = 20'hF_4240, // d1_000_000;
    parameter T_QUARTER = 26'h17d_7840
    `endif
)(
  input clk,
  input n_rst,
  
  input din,   //input_1bit
  output dout   //output_1bit
);


reg din_d1, din_d2;      //for delay
always @(posedge clk or negedge n_rst)
   if(!n_rst) begin
      din_d1 <= 1'b0;
      din_d2 <= 1'b0;
   end
   else begin
      din_d1 <= din;
      din_d2 <= din_d1;
   end
   

wire cnt_restart;
assign cnt_restart = (din_d1 != din_d2)? 1'b1 : 1'b0;

reg [19:0] cnt;   //used de_bounc_2
always @(posedge clk or negedge n_rst)
   if(!n_rst) begin
      cnt <= 20'h0_0000;
   end
   else begin
     cnt <= ((cnt_restart == 1'b1) && (cnt == 20'h0_0000))? T_20MS : 
              (cnt > 20'h0_0000)? cnt - 20'h0_0001 : cnt;
   end
   

reg dout_rdy;
always @(posedge clk or negedge n_rst)
   if(!n_rst) begin
      dout_rdy <= 1'b0;
   end
   else begin
      dout_rdy <= ((cnt == 20'h0_0000) && (cnt_restart == 1'b1))? din : dout_rdy;
   end
   

assign dout = dout_rdy;


endmodule
