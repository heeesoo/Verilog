module door_lock(
    clk,
    n_rst,
    button_0,
    button_1,
    button_2,
    start,
    led_ok,
    led_fail,
    led_0,
    led_1,
    led_2
);

parameter IDLE = 3'h0;
parameter WAIT = 3'h1;
parameter FIRST = 3'h2;
parameter OK = 3'h3;
parameter FAIL = 3'h4;  
parameter FAIL_WAIT = 3'h5;

input clk;
input n_rst;

input start;
input button_0;
input button_1;
input button_2;

output reg led_ok;
output reg led_fail;
output reg led_0;
output reg led_1;
output reg led_2;

reg [2:0] n_state; // next_state
reg [2:0] c_state; // current_state

// Sequential Logics

// state flip-flop  
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin 
        c_state <= IDLE;
    end

    else begin
        c_state <= n_state;
    end
end

// led flip-flop

// led_0
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        led_0 <= 1'b0;
    end

    else begin
        if (button_0 == 1'b1 && start == 1'b1) begin
            led_0 <= 1'b1;
        end

        else if (button_0 == 1'b0 && start == 1'b1) begin 
            led_0 <= led_0;
        end

        else begin
            led_0 <= 1'b0;
        end
    end
end

// led_1
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        led_1 <= 1'b0;
    end

    else begin
        if (button_1 == 1'b1 && start == 1'b1) begin
            led_1 <= 1'b1;
        end

        else if (button_1 == 1'b0 && start == 1'b1) begin 
            led_1 <= led_1;
        end

        else begin
            led_1 <= 1'b0;
        end
    end
end

// led_2
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        led_2 <= 1'b0;
    end

    else begin
        if (button_2 == 1'b1 && start == 1'b1) begin
            led_2 <= 1'b1;
        end

        else if (button_2 == 1'b0 && start == 1'b1) begin 
            led_2 <= led_2;
        end

        else begin
            led_2 <= 1'b0;
        end
    end
end

// led_ok
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        led_ok <= 1'b0;
    end

    else begin
        if (c_state == OK) begin
            led_ok <= 1'b1;
        end

        else begin
            led_ok <= 1'b0;
        end
    end
end

// led_fail
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        led_fail <= 1'b0;
    end

    else begin
        if (c_state == FAIL) begin
            led_fail <= 1'b1;
        end

        else begin
            led_fail <= 1'b0;
        end
    end
end


// Combinational Logics
always @(c_state or button_0 or button_1 or button_2 or start) begin
    case(c_state) 
        IDLE : begin
            if (start == 1'b0) begin
                n_state = IDLE;
            end

            else begin // start == 1'b1
                n_state = WAIT;
            end
        end

        WAIT : begin
            if (button_0 == 1'b0 && button_1 == 1'b0 && button_2 == 1'b1) begin
                n_state = FIRST;
            end

            else if (button_0 == 1'b0 && button_1 == 1'b0 && button_2 == 1'b0) begin
                n_state = WAIT;
            end

            else begin
                n_state = FAIL_WAIT;
            end
        end

        FIRST : begin
            if (button_0 == 1'b1 && button_1 == 1'b0 && button_2 == 1'b0) begin
                n_state = OK;
            end

            else if (button_0 == 1'b0 && button_1 == 1'b0 && button_2 == 1'b0) begin
                n_state = FIRST;
            end
            
            else begin
                n_state = FAIL;
            end
        end

        OK : begin
            if (start == 1'b0) begin
                n_state = IDLE;
            end

            else begin
                n_state = OK;
            end
        end

        FAIL_WAIT : begin
            n_state = FAIL;
        end

        FAIL : begin
            if (start == 1'b0) begin
                n_state = IDLE;
            end

            else begin
                n_state = FAIL;
            end
        end

        default : begin
            n_state = IDLE;
        end

    endcase

end


endmodule





















