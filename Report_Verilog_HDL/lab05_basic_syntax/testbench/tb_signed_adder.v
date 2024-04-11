/*
module tb_sign_adder();
reg [7:0] din0;
reg [7:0] din1;

wire [7:0] dout;

sign_adder_8bit u_sign_adder_8bit(
    .din0(din0),
    .din1(din1),
    .dout(dout)
);

initial begin
    #0;
    din0 = 8'b0;
    din1 = 8'b0;
     
    #10;
    din0 = 8'b00110011;
    din1 = 8'b10010001;

    #10;
    $stop;

end

endmodule
*/


`timescale 1ns/100ps

module tb_hw_assign();

reg [2:0] din0;
reg signed [2:0] din1;

reg [1:0] sel;

wire [2:0] dout;

hw_always_if u_hw_assign(
    .din0(din0),
    .din1(din1),
    .sel(sel),
    .dout(dout)
);

initial begin
    din0 = 3'h2;
    din1 = 3'h1;
    sel = 2'h0;
    
    #10
    sel = 2'h1;

    #10
    sel = 2'h2;

    #10
    sel = 2'h3;

    #10
    din0 = 3'h3;
    din1 = 3'h1;
    sel = 2'h0;

    #10 
    sel = 2'h1;
    
    #10 
    sel = 2'h2;

    #10
    sel =2'h3;

    #10
    $stop;
end

endmodule
