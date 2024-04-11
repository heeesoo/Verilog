module delay_led(
    clk,
    n_rst,
    led,
    led_d
);

parameter T_1S = 26'h2FA_F080;

input clk;
input n_rst;
input led;

output reg led_d;

reg [25:0] cnt;

always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        cnt <= 26'h000_0000;
    end

    else begin
        cnt <= ((led == 1'b1) && (cnt == 26'h000_0000)) ? T_1S : 
                (cnt > 26'h000_0000) ? cnt - 26'h000_0001 : cnt;
    end
end

always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        led_d <= 1'b0;
    end

    else begin
        led_d <= (cnt == 26'h000_0000) ? 1'b0 : 1'b1;
    end

end


endmodule