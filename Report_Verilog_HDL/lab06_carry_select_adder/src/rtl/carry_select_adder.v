
module carry_select_adder(
    din_a,
    din_b,
    cin,
    sum,
    cout
);

input [7:0] din_a;
input [7:0] din_b;
input cin;

output [7:0] sum;
output cout;

wire c1;
wire c2;
reg c3;
reg c4;

reg [3:0] reg_s;  // temp sum

// assign 
assign {c1, sum[1:0]} = din_a[1:0] + din_b[1:0] + cin;


// assign, ? : 
assign {c2, sum[3:2]} = (c1 == 1'b1) ? din_a[3:2] + din_b[3:2] + c1 : din_a[3:2] + din_b[3:2];


// always, if ~ else
always @(c2 or din_a or din_b) begin
    if (c2) begin  // c2 == 1'b1
        {c3, reg_s[1:0]} = din_a[5:4] + din_b[5:4] + 1'b1;
    end
    else begin
        {c3, reg_s[1:0]} = din_a[5:4] + din_b[5:4];
    end
end


// always, case 
always @(c3 or din_a or din_b) begin
    case(c3)
        1'b1 : begin
            {c4, reg_s[3:2]} = din_a[7:6] + din_b[7:6] + 1'b1;
        end
        1'b0 : begin
            {c4, reg_s[3:2]} = din_a[7:6] + din_b[7:6];
        end
        default : begin
            {c4, reg_s[3:2]} = 3'b000;
        end
    endcase
end


assign sum[7:4] = reg_s[3:0];
assign cout = c4;

endmodule