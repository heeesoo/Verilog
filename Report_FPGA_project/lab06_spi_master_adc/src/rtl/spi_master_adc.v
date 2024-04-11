module spi_master_adc(
    clk,
    n_rst,
    n_start,
    sclk,
    cs_n,
    sdata,
    led
);

parameter SCLK_HALF = 4'hC;

input           clk;
input           n_rst;
input           n_start;
input           sdata;

output  reg         sclk; 
output  reg         cs_n;  

output  [7:0]       led;

reg     [3:0]   cnt;  
reg     [4:0]   cnt_sclk; 
reg     [7:0]   temp;  

wire            sclk_rise;  


// cs_n FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cs_n <= 1'b1;
    end

    else begin
        cs_n <= (n_start == 1'b0)? 1'b0 :  
                    (cnt_sclk == 5'b1_0000)? 1'b1 : cs_n;  
    end                                                    
end


// cnt FF 
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt <= 4'h0;
    end

    else begin
        if (cs_n == 1'b0) begin
            if (cnt < SCLK_HALF) begin
                cnt <= cnt + 4'h1; 
            end

            else begin
                cnt <= 4'h0;    
            end                
        end

        else if (cs_n == 1'b1) begin
            cnt <= 4'h0;    
        end

        else begin 
            cnt <= cnt;
        end
    end
end


// sclk FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        sclk <= 1'b1;  
    end

    else begin
        if (cnt == SCLK_HALF) begin
            sclk <= ~sclk;  
        end

        else if (cnt_sclk == 5'b1_0000) begin
            sclk <= 1'b1;  
        end

        else begin
            sclk <= sclk;
        end
    end
end


// sclk_rise Combinational Logic
assign sclk_rise = ((cnt == SCLK_HALF) && (sclk == 1'b0))? 1'b1 : 1'b0; 


// cnt_sclk FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        cnt_sclk <= 5'h0;  
    end

    else begin 
        if ((cs_n == 1'b0) && (sclk_rise == 1'b1)) begin
            if (cnt_sclk < 5'b1_0000) begin
                cnt_sclk <= cnt_sclk + 5'h1;
            end

            else if (cnt_sclk == 5'b1_0000) begin
                cnt_sclk <= 5'h0;
            end

            else begin
                cnt_sclk <= cnt_sclk;
            end
        end

        else if (cs_n == 1'b1) begin
            cnt_sclk <= 5'h0;
        end

        else begin 
            cnt_sclk <= cnt_sclk;
        end
    end
end


// temp FF
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        temp <= 8'h00;
    end

    else begin
        if (sclk_rise == 1'b1) begin
            if ((cnt_sclk >= 5'h3) && (cnt_sclk < 5'hB)) begin
                temp <= {temp[6:0], sdata};
            end

            else begin
                temp <= temp; 
            end
        end

        else begin
            temp <= temp;
        end
    end

end

// LED Combinational Logic
assign led = temp;  

endmodule
