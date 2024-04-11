module det_011_reset_moore(
    clk,
    n_rst,
    din,
    dout
);

input clk;
input n_rst;
input din;

output reg dout;

reg [2:0] c_state;
reg [2:0] n_state;

parameter S_0 = 3'h0;
parameter S_1 = 3'h1;
parameter S_2 = 3'h2;
parameter S_3 = 3'h3;
parameter S_4 = 3'h4;
parameter S_5 = 3'h5;

always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        c_state <= S_0;
    end

    else begin
        c_state <= n_state;
    end
end

always @(c_state or din) begin
    case (c_state)
        S_0 : begin
            n_state = (din == 1'b0)? S_1 : S_4;
            dout = 1'b0;
        end

        S_1 : begin
            n_state = (din == 1'b1)? S_2 : S_5;
            dout = 1'b0;
        end

        S_2 : begin
            n_state = (din == 1'b1)? S_3 : S_0;
            dout = 1'b0;
        end

        S_3 : begin
            n_state = (din == 1'b1)? S_4 : S_1;
            dout = 1'b1;
        end

        S_4 : begin
            n_state = S_5;
            dout = 1'b0;
        end

        S_5 : begin
            n_state = S_0;
            dout = 1'b0;
        end
        
        default : begin
            n_state = S_0;
            dout = 1'b0;
        end
    endcase
end

endmodule

