
//Made by KIM, KWON, YOON
//`define SIM
//`define CP

//detector
module detector(
  clk,
  n_rst,
  bt,      //input == push_sw
  bt_start,
  bt_done,
  length   //length -> long is '1', short is '0'
);

`ifdef SIM   //for used test_beach
parameter T_BIT = 4;
parameter T_1S = 4'd5;
parameter T_QUARTER = 4'd2;
`else 
parameter T_BIT = 26;
parameter T_1S = 26'h2FA_F080; // d50_000_000;
parameter T_QUARTER = 26'hC8_E420;
`endif


input clk;
input n_rst;
input bt;

output bt_start;
output bt_done;
output length;

wire    bt_edge;

reg bt_d1, bt_d2;   //used delay
reg [T_BIT-1:0] cnt_long;   //clk cnt
// reg [19:0] cnt_long;

// delay
always @(posedge clk or negedge n_rst)
  if(!n_rst) begin
    bt_d1 <= 1'b0;
    bt_d2 <= 1'b0;
  end

  else begin
    bt_d1 <= bt;
    bt_d2 <= bt_d1;
  end
  
 

//bt_start   //bt_start is edge_d
assign bt_start = ((bt_d1 == 1'b1)&&(bt_d2 == 1'b0))? 1'b1 : 1'b0;

//edge detector   //(d1 == d2 == 1) => '1'
assign bt_edge = ((bt_d1 == 1'b1)&&(bt_d2 == 1'b1))? 1'b1 : 1'b0;

// bt_done   //signal is (d1 == 0) & (d2 == 1) => done signal
assign bt_done = ((bt_d1 == 1'b0)&&(bt_d2 == 1'b1))? 1'b1 : 1'b0;

// counter to distinguish short, long signal
always@ (posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        cnt_long <= {(T_BIT){1'b0}};
    end
  
    else begin
        if (bt_edge) begin
            if ((cnt_long >= {(T_BIT){1'b0}}) && (cnt_long < T_QUARTER)) begin
                cnt_long <= cnt_long + {{(T_BIT-1){1'b0}}, 1'b1};
            end   //cnt_long 

            else if (cnt_long >= T_QUARTER) begin
                cnt_long <= T_QUARTER;
            end
        end

        else if (bt_done) begin
            cnt_long <= {(T_BIT){1'b0}};
        end

        else begin
            cnt_long <= cnt_long;
        end
    end
end

assign length = (cnt_long == T_QUARTER) ? 1'h1 : 1'h0;
//length -> long is '1', short is '0' 
//standard) T_QUARTER parameter set

endmodule
