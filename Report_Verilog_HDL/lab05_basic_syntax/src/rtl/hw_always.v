module hw_always(
    din0,
    din1,
    sel,
    dout
);

input [2:0] din0;
input [2:0] din1;
input [1:0] sel;

output reg [2:0] dout;

always @(sel) begin
    if (sel == 2'b00) begin
        dout = din0 + din1;
    end

    else if (sel == 2'b01) begin
        dout = din0 + (~din1 + 3'b001);
    end

    else if (sel == 2'b10) begin
        dout = din0 & din1;
    end

    else begin // sel = 2'b11
        dout = {1'b0, din0[2:1]};
    end 
end

endmodule