
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
    assign {c2, sum[3:2]} = (c1 == 1'b1) ? din_a[3:2] + din_b[3:2] + 1'b1 : din_a[3:2] + din_b[3:2];


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


/*
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

wire c0;
wire c1;
wire c2;
wire c3;

reg c4;
reg c5;
reg c6;
reg c7;

reg [3:0] reg_s;

// assign 
assign {c0, sum[0]} = din_a[0] + din_b[0] + cin;
assign {c1, sum[1]} = din_a[1] + din_b[1] + c1;


// assign, ? : 
assign {c2, sum[2]} = (c1 == 1'b1) ? din_a[2] + din_b[2] + c1 : din_a[2] + din_b[3]; // don't carry 
assign {c3, sum[3]} = (c2 == 1'b1) ? din_a[3] + din_b[3] + c2 : din_a[3] + din_b[3];


// always, if ~ else
always @(c3 or din_a or din_b) begin
    if (c3) begin
        {c4, reg_s[0]} = din_a[4] + din_b[4] + c3;
    end

    else begin
        {c4, reg_s[0]} = din_a[4] + din_b[4];
    end
end

always @(c4 or din_a or din_b) begin
    if (c4) begin
        {c5, reg_s[1]} = din_a[5] + din_b[5] + c4;
    end

    else begin
        {c5, reg_s[1]} = din_a[5] + din_b[5];
    end
end


// always, case
always @(c5 or din_a or din_b) begin
    case (c5) 
        1'b1 : {c6, reg_s[2]} = din_a[6] + din_b[6] + c5;

        1'b0 : {c6, reg_s[2]} = din_a[6] + din_b[6];

        default : {c6, reg_s[2]} = 2'b00;
    endcase
end

always @(c6 or din_a or din_b) begin
    case (c6) 
        1'b1 : {c7, reg_s[3]} = din_a[7] + din_b[7] + c6;

        1'b0 : {c7, reg_s[3]} = din_a[7] + din_b[7];

        default : {c7, reg_s[3]} = 2'b00;
    endcase
end

assign sum[7:4] = reg_s[3:0];
assign cout = c7; 

endmodule 
*/


/*
module four_bit_adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    
    output [3:0] sum,
    output cout
);

wire c0;

assign c0 = cin;

full_adder u_fa_0 (.a(a[0]), .b(b[0]), .cin(c0), .sum(sum[0]));
full_adder u_fa_1 (.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]));
full_adder u_fa_2 (.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]));
full_adder u_fa_3 (.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]));


endmodule


module full_adder(
    input a,
    input b,
    input cin,

    output s,
    output cout
);

wire s0;
wire s1;

wire c0;
wire c1;

assign s0 = s;

half_adder u_ha_0 (.a(a), .b(b), .s(s0), .c(c0));
half_adder u_ha_1 (.a(s0), .b(cin), .s(s1), .c(c1));

assign cout =  | c1;




endmodule


module half_adder(
    input a,
    input b,
    output s,
    output c
);

assign s = a ^ b;
assign c = a & b;


endmodule




*/
