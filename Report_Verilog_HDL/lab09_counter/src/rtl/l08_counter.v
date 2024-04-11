
module l08_counter(
    clk,
    n_rst,
    up,
    counter_3
);

input clk;
input n_rst;
input up;

output reg [1:0] counter_3;
reg [1:0] counter_1;

wire [1:0] cnt_3;
wire [1:0] cnt_1;

assign cnt_3 = counter_3;
assign cnt_1 = counter_1;


always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        counter_3 <= 2'b00;
    end

    else begin // n_rst == 1'b1
        if (up == 1'b1) begin
            if (counter_1 == 2'b10) begin
                if (counter_3 == 2'b10) begin
                    counter_3 <= 2'b00;
                end

                else begin 
                    counter_3 <= counter_3 + 2'b01;
                end
            end

            else begin 
                counter_3 <= counter_3;
            end
        end

        else begin 
            counter_3 <= counter_3;
        end
        
    end
end

always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        counter_1 <= 2'b00;
    end

    else begin // n_rst == 1'b1
        if (up == 1'b1) begin
            if (counter_1 == 2'b10) begin
                counter_1 <= 2'b00;    
            end

            else begin // counter_1 = 2'b00, 2'b01, 2'b11
                counter_1 <= counter_1 + 2'b01;
            end
        end

        else begin 
            counter_1 <= counter_1;
        end
        
    end
end

endmodule




/*

// 공유용
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        counter_3 <= 2'b00;
        counter_1 <= 2'b00;
    end

    else begin // n_rst == 1'b1
        if (up == 1'b1) begin
            if (counter_1 == 2'b10) begin
                if (counter_3 == 2'b10) begin
                    counter_3 <= 2'b00;
                    counter_1 <= 2'b00;
                end

                else begin 
                    counter_3 <= counter_3 + 2'b01;
                    counter_1 <= 2'b00;
                end
            end

            else begin 

                counter_3 <= counter_3;
                counter_1 <= counter_1 + 2'b01;
            end
        end

        else begin 
            counter_3 <= counter_3;
            counter_1 <= counter_1;
        end
        
    end
end
*/

/*
// 준모형 코드
module l08_counter(
    clk,
    n_rst,
    up,
    counter_1,
    counter_3
);
input clk;
input n_rst;
input up;

output [1:0] counter_1;
output [1:0] counter_3;

reg [1:0] cnt_1;
reg [1:0] cnt_3;

always @(posedge clk or negedge n_rst)
    if(!n_rst) begin
        cnt_1 <= 2'h0;
        cnt_3 <= 2'h0;
    end
    else begin
        if (up == 1'h1) begin
            if (cnt_1 == 2'h11) begin
                cnt_1 <= 2'h0;
                if (cnt_3 == 2'h11) begin
                    cnt_3 <= 2'h0;
                end

                else begin 
                    cnt_3 <= cnt_3 + 2'h1;
                end
            end
        end
        else begin 
            cnt_1 <= cnt_1 + 2'h1;             
        end
    end

assign counter_1 = cnt_1;
assign counter_3 = cnt_3;

endmodule
*/
