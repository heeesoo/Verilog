module hw_case(
    din0,
    din1,
    sel,
    dout
);

input [2:0] din0;
input [2:0] din1;
input [1:0] sel;

output reg [2:0] dout;

always @(sel or din0 or din1) begin
    case(sel)
        2'b00 : dout = din0 + din1;

        2'b01 : dout = din0 + (~din1 + 3'b001);

        2'b10 : dout = din0 & din1;

        2'b11 : dout = {1'b0, din0[2:1]};

        default begin
            dout = 3'b0;
        end

    endcase
end

endmodule
