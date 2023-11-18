
module tb_carry_select_adder;
reg [7:0] din_a;
reg [7:0] din_b;
reg cin;

wire [7:0] sum;
wire cout;

integer i, j, error;

carry_select_adder u_carry_select_adder(
    .din_a(din_a),
    .din_b(din_b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    din_a = 8'h00;
    din_b = 8'h00;
    error = 0;
    
    //for carry in =0
    cin = 1'b0;
    for(i=0;i<2**8;i=i+1) begin
        for(j=0;j<2**8;j=j+1) begin
            din_a = i;
            din_b = j;
            #10;
            if({cout,sum} != (i+j)) begin
                error = error + 1;
                $display("error : i=%h, j=%h", i, j);
                $stop;
            end
        end
    end

    //for carry in =1
    cin = 1'b1;
    for(i=0;i<2**8;i=i+1) begin
        for(j=0;j<2**8;j=j+1) begin
            din_a = i;
            din_b = j;
            #10;
            if({cout,sum} != (i+j+1)) begin
                error = error + 1;
                $display("error : i=%h, j=%h", i, j);
                $stop;  
            end
        end
    end

    $display("Total error =%h", error);

    #10; 
    $stop;

end

endmodule
