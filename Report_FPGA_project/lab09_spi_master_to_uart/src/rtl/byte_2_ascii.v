module byte_2_ascii(
    input           clk,
    input           n_rst,
    input [7:0]     do, 
    input           ns, 
    // input           rx_done;

    output          next_start,
    output [7:0]    data_out
    
);


assign data_out = do;   
assign next_start = ns;

endmodule