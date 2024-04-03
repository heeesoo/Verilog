`timescale 1ns/1ps
`define T_CLK 20

module tb_spi_slave;

reg sclk_run, n_rst;
reg [7:0] data;
reg cs_n_0, cs_n_1;

wire sclk;
wire sdata;

spi_slave_adc u_spi_slave_adc_0(
   .n_rst(n_rst),

   .data(data), 

   .sclk(sclk),
   .cs_n(cs_n_0),
   .sdata(sdata)  // output
);

spi_slave_adc u_spi_slave_adc_1(
   .n_rst(n_rst),

   .data(data), 

   .sclk(sclk),
   .cs_n(cs_n_1),
   .sdata(sdata) // output
);    

initial begin
    sclk_run = 1'b0;
end

always #(`T_CLK/2) sclk_run = ~sclk_run;


integer i;
initial begin
	n_rst = 1'b0;

	cs_n_0 = 1'b1;
	cs_n_1 = 1'b1;
	data = 8'h00;

    #(`T_CLK*2.1) n_rst = 1'b1;
   
    for (i=8'hC5; i<8'hC9;i=i+1) begin
		#(`T_CLK*5) data = i;

		#(`T_CLK*1) n_rst = 1'b0; // to reset a counter of spi_slave
		#(`T_CLK*1) n_rst = 1'b1;
		#(`T_CLK*1) n_rst = 1'b1;
		
        @(posedge sclk_run) ;
        #(`T_CLK * 0.1)
        cs_n_0 = (i%2 == 1'b1)? 1'b0 : 1'b1;
        cs_n_1 = (i%2 == 1'b1)? 1'b1 : 1'b0;

        #(`T_CLK * 16)
	    cs_n_0 = 1'b1;
	    cs_n_1 = 1'b1;
	end
	#(`T_CLK * 5) $stop;
end

assign sclk = (cs_n_0 == 1'b0 || cs_n_1 == 1'b0)? sclk_run : 1'b1;


endmodule
