// Morse module
// Made by KIM, KWON, YOON 

//`define SIM
//`define CP

module morse#(
  `ifdef SIM
  parameter T_BIT = 4,
  parameter T_1S = 4'd5,
  parameter T_QUARTER = 4'd2
  `else 
  parameter T_BIT = 26,
  parameter T_1S = 26'h2FA_F080, // d50_000_000;
  parameter T_QUARTER = 26'h17d_7840
  `endif
)(
  clk,
  n_rst,
  
  baudrate,
  
  tx_done,
  
  bt,
  start,
  data,
  done,
  cnt_num
);

// declare parameters for State Machines
localparam S_0 = 3'h0;
localparam S_1 = 3'h1;
localparam S_2 = 3'h2;
localparam S_3 = 3'h3;
localparam S_4 = 3'h4;
localparam S_5 = 3'h5;

// declare parameters that determine the number of zeros in the data
localparam M_1 = 1;
localparam M_2 = 2;
localparam M_3 = 3;
localparam M_4 = 4;


input clk;
input n_rst;
input bt;
input start;
input baudrate;
input tx_done;

//output [4:0] data;
output done;
output [2:0] cnt_num;

reg [T_BIT-1:0] cnt_finish;
reg [2:0] cnt_number;
reg [4:0] mux;

output [4:0] data;

wire bt_d;
//wire bt_edge;
wire bt_start;
wire bt_done;
wire signal;

debounce u_debounce(
 .clk(clk),
 .n_rst(n_rst),
 .din(bt),
 .dout(bt_d)
);

// connect parameter values through an instance
detector#(
  .T_BIT(T_BIT),
  .T_1S(T_1S),
  .T_QUARTER(T_QUARTER)
) u_detector(
  .clk(clk),
  .n_rst(n_rst),
  .bt(bt_d),
  //.bt_edge(bt_edge),
  .bt_start(bt_start),
  .bt_done(bt_done),
  .length(signal)
);

// detect five signals
always@ (posedge clk or negedge n_rst)
  if(!n_rst)
    cnt_number <= 3'h0;
  else
    cnt_number <= ((cnt_number == 3'h6) || tx_done) ? 3'h0 : 
                  (bt_done == 1'h1) ? cnt_number + 3'h1 : cnt_number;

reg bt_en;

// shows between the input signal and the signal
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    bt_en <= 1'b0;
  end

  else begin
    if(start) begin
      if(bt_done) begin
        bt_en <= 1'b1;
      end

      else if (bt_start || cnt_finish == T_1S) begin
        bt_en <= 1'b0;
      end

      else begin
        bt_en <= bt_en;
      end

    end

    else begin
      bt_en <= 1'b0;
    end
  end
end

// Counter that counts seconds after the input signal ends
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    cnt_finish <= 26'b0;
  end

  else begin
    if (bt_en) begin
      cnt_finish <= (cnt_finish == T_1S) ? cnt_finish : cnt_finish + 26'h000_0001;
    end

    else if (tx_done) begin
      cnt_finish <= 26'b0;
    end

    else begin
      cnt_finish <= 26'b0;
    end
  end
end

wire t_start;

// Role of sending a start signal to the tx module
assign t_start = (cnt_finish == T_QUARTER)? 1'b1 : 1'b0;   //(cnt_f) && (cnt_num < 5)

wire finish;
assign finish = (cnt_num == 3'h5 || cnt_finish == T_1S) ? 1'h1 : 1'h0;

//s2p
always@ (posedge clk or negedge n_rst)
  if(!n_rst)
    mux <= 5'h00;
  else begin
    mux <= (bt_done == 1'h1) ? {mux[3:0], signal} : mux;
  end
  

reg [2:0] c_state, n_state;
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    c_state <= S_0;
  end
  else begin
    c_state <= n_state;
  end
  
 

wire [4:0] we;
reg [T_BIT-1:0] time_bomb;

// State machine that determines the output according to the number of signals
always @(*) begin //{(T_DIV_BIT){1'b0}}
  case (c_state)
    S_0 : begin
      n_state = (bt_done)? S_1 : c_state;
    end
    S_1 : begin
      n_state = (finish)? S_0 : 
                (bt_done)? S_2 : c_state;
    end
    S_2 : begin
      n_state = (finish)? S_0 : 
                (bt_done)? S_3 : c_state;
    end
    S_3 : begin
      n_state = (finish)? S_0 : 
                (bt_done)? S_4 : c_state;
    end
    S_4 : begin
      n_state = (finish)? S_0 : 
                (bt_done)? S_5 : c_state;
    end
    S_5 : begin
      n_state = (time_bomb == T_1S)? S_0 : c_state;
    end
    default : begin
      n_state = S_0;
    end
  endcase
end

// Output according to the current state
assign we = (c_state == S_0) ? 5'h00 : 
            (c_state == S_1) ? {mux[0], {(M_4){1'b0}}} : 
            (c_state == S_2) ? {mux[1:0], {(M_3){1'b0}}} : 
            (c_state == S_3) ? {mux[2:0], {(M_2){1'b0}}} : 
            (c_state == S_4) ? {mux[3:0], {(M_1){1'b0}}} : 
            (c_state == S_5) ? mux : 5'h00;

// Variables to give a slight delay       
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    time_bomb <= 26'b0;
  end
  else begin
    if(c_state == S_5)    
      time_bomb <= (time_bomb == {(T_BIT){1'b0}}) ? T_1S : 
                   (time_bomb > {(T_BIT){1'b0}}) ? time_bomb - {{(T_BIT-1){1'b0}}, 1'b1} : time_bomb; 
  end
end

assign data = we;
assign done = t_start;  
assign cnt_num = cnt_number;

endmodule 
