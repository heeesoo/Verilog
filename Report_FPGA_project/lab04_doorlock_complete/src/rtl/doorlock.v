module doorlock(
    clk,
    n_rst,
    bt,
    btstar,
    led
);

input clk;
input n_rst;
input [9:0] bt;
input btstar;

output led;

parameter S_IDLE = 3'h0;
parameter S_FIRST = 3'h1;
parameter S_RAND = 3'h2;
parameter S_LAST = 3'h3;
parameter S_OPEN = 3'h4;

reg [2:0] c_state;
reg [2:0] n_state;

// Sequential Logic
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        c_state <= S_IDLE;
    end 

    else begin
        c_state <= n_state;
    end
end

// Combinational Logic
assign led = (c_state == S_OPEN)? 1'b1 : 1'b0;

always @(*) begin
    case(c_state) 
        S_IDLE : begin
            if (bt[1]) begin
                n_state = S_FIRST;
            end

            else begin
                n_state = c_state;
            end
        end

        S_FIRST : begin
            if (bt[2]) begin
                n_state = S_RAND;
            end

            else if (bt == 10'b0 && !btstar) begin
                n_state = c_state;
            end

            else begin
                n_state = S_IDLE;
            end
        end

        S_RAND : begin
            if (bt[7]) begin
                n_state = S_LAST;
            end

            else if (btstar) begin
                n_state = S_IDLE;
            end

            else begin
                n_state = c_state;
            end
        end

        S_LAST : begin
            if (btstar) begin
                n_state = S_OPEN;
            end

            else if (bt[7]) begin
                n_state = c_state;
            end

            else if (bt[0] | bt[1] | bt[2] | bt[3] | bt[4] | bt[5] | bt[6] | bt[8] | bt[9]) begin
                n_state = S_RAND;
            end

            else begin
                n_state = c_state;
            end
        end

        S_OPEN : begin
            n_state = S_IDLE;
        end

        default : begin
            n_state = S_IDLE;
        end
    endcase

end


endmodule





/*
ex) parameter = 4;

din_d1 <= {(D_W){1'b0}};