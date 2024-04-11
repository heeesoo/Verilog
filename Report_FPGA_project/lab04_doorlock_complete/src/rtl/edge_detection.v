module edge_detection(
    clk,
    n_rst,
    din,
    b0_on
);

input clk;
input n_rst;
input din;

output b0_on;

reg b0_d1;
reg b0_d2;

// Button Delay Sequential Logic
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        b0_d1 <= 1'b0;
        b0_d2 <= 1'b0;
    end

    else begin
        b0_d1 <= din;
        b0_d2 <= b0_d1;
    end
end

// Button On Combinational Logic
assign b0_on = ((b0_d1 == 1'b1) && (b0_d2 == 1'b0))? 1'b1 : 1'b0;

endmodule