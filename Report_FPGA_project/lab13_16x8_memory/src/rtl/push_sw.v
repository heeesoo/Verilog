module push_sw(
    input   clk,
    input   n_rst,
    input   push_sw,
    output  p_sw    // Output
);

reg ps_d1;
reg ps_d2;

// delay push switch
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        ps_d1 <= 1'b0;
        ps_d2 <= 1'b0;
    end

    else begin
        ps_d1 <= push_sw;
        ps_d2 <= ps_d1;
    end
end

// edge detector 
assign p_sw = (!ps_d1 && ps_d2)? 1'b1 : 1'b0;

endmodule