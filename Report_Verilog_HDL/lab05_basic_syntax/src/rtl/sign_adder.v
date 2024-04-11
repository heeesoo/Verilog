module hw_always_if(
    input [2:0] din0,
    input signed [2:0] din1,
    input [1:0] sel,

    output reg [2:0] dout
);

always @(sel)begin

    if (sel == 2'h1)
        dout <= din0 + din1;

    else if (sel == 2'h2)
        dout <= din0 + (~din1) + 1'h1;

    else if (sel == 2'h3)
        dout <= din0 & din1;

    else
        dout <= din0 >> 1;

end

endmodule
