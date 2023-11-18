module tb_mux();
reg [7:0] din;
reg [2:0] sel;

wire dout;

mux_8x1 u_mux_8x1(
    .din(din),
    .sel(sel),
    .dout(dout)
);

initial begin
    #0;
    din = 8'b0;
    sel = 3'b0;

    #10;
    din = 8'b10101100;

    #10;
    sel = 3'b010;

    #10;
    sel = 3'b011;

    #10; 
    sel = 3'b100;
    
    #10;
    sel = 3'b101;

    #10;
    sel = 3'b110;

    #10;
    sel = 3'b111;

    #10;
    sel = 3'b000;
    
    #10;
    $stop;
end        

endmodule