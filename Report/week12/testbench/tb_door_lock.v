`timescale 1ns/100ps
`define T_CLK 10

module tb_door_lock;
reg clk;
reg n_rst;
reg button_0;
reg button_1;
reg button_2;
reg start;

wire led_ok;
wire led_fail;
wire led_0;
wire led_1;
wire led_2;

door_lock u_door_lock(
    .clk(clk),
    .n_rst(n_rst),
    .button_0(button_0),
    .button_1(button_1),
    .button_2(button_2),
    .start(start),
    .led_ok(led_ok),
    .led_fail(led_fail),
    .led_0(led_0),
    .led_1(led_1),
    .led_2(led_2)
);

always #(`T_CLK/2) clk = ~clk;

initial begin
    clk = 1'b1;
	  n_rst = 1'b0;
    start = 1'b0;
    button_0 = 1'b0;
    button_1 = 1'b0;
    button_2 = 1'b0;

	#(`T_CLK*1.2) n_rst = 1'b1;

    #(`T_CLK) 
    start = 1'b1;
    
    #(`T_CLK * 2) 
    button_2 = 1'b1;

    #(`T_CLK) 
    button_2 = 1'b0;

    #(`T_CLK * 2) 
    button_0 = 1'b1;

    #(`T_CLK) 
    button_0 = 1'b0;

    #(`T_CLK * 2) 
    start = 1'b0;

    #(`T_CLK * 4) 
    start = 1'b1;

    #(`T_CLK * 2) 
    button_2 = 1'b1;

    #(`T_CLK) 
    button_2 = 1'b0;

    #(`T_CLK * 2)  
    button_1 = 1'b1;

    #(`T_CLK)  
    button_1 = 1'b0;

    #(`T_CLK * 2) 
    start = 1'b0;

    #(`T_CLK * 4) 
    start = 1'b1;

    #(`T_CLK * 2)  
    button_0 = 1'b1;

    #(`T_CLK)  
    button_0 = 1'b0;

    #(`T_CLK * 2)  
    button_0 = 1'b1;

    #(`T_CLK )  
    button_0 = 1'b0;

    #(`T_CLK * 2) 
    start = 1'b0;

    #(`T_CLK * 3) 
    $stop;
end

endmodule



/*
// Copy

`timescale 1ns/100ps
`define T_CLK 10

module tb_door_lock();
reg clk;
reg n_rst;
reg button_0;
reg button_1;
reg button_2;
reg start;

wire led_0;
wire led_1;
wire led_2;
wire led_ok;
wire led_fail;

door_lock u_door_lock(  
    .clk(clk),
    .n_rst(n_rst),
    .button_0(button_0),
    .button_1(button_1),
    .button_2(button_2),
    .start(start),
    .led_ok(led_ok),
    .led_fail(led_fail),
    .led_0(led_0),
    .led_1(led_1),
    .led_2(led_2)
);

always begin
    #(`T_CLK/2) clk = ~clk;
end

initial begin
    clk = 1'b1;
    n_rst = 1'b0;
    start = 1'b0;
    button_0 = 1'b0;
    button_1 = 1'b0;
    button_2 = 1'b0;
end

initial begin
	#(`T_CLK*1.2) n_rst = 1'b1;

    #(`T_CLK) 
    start = 1'b1;
    
    #(`T_CLK * 2) 
    button_2 = 1'b1;

    #(`T_CLK) 
    button_2 = 1'b0;

    #(`T_CLK * 2) 
    button_0 = 1'b1;

    #(`T_CLK) 
    button_0 = 1'b0;

    #(`T_CLK * 2) 
    start = 1'b0;

    #(`T_CLK * 4) 
    start = 1'b1;

    #(`T_CLK * 2) 
    button_2 = 1'b1;

    #(`T_CLK) 
    button_2 = 1'b0;

    #(`T_CLK * 2)  
    button_1 = 1'b1;

    #(`T_CLK)  
    button_1 = 1'b0;

    #(`T_CLK * 2) 
    start = 1'b0;

    #(`T_CLK * 4) 
    start = 1'b1;

    #(`T_CLK * 2)  
    button_0 = 1'b1;

    #(`T_CLK)  
    button_0 = 1'b0;

    #(`T_CLK * 2)  
    button_0 = 1'b1;

    #(`T_CLK )  
    button_0 = 1'b0;

    #(`T_CLK * 2) 
    start = 1'b0;

    #(`T_CLK * 3) 
    $stop;
end

endmodule
*/

/*
module DoorLock(
  input wire clk,       // Clock input
  input wire n_rst,     // Active-low reset input
  input wire start,     // Start signal input
  input wire bt0,       // Button 0 input
  input wire bt1,       // Button 1 input
  input wire bt2,       // Button 2 input
  output reg led0,      // LED 0 output
  output reg led1,      // LED 1 output
  output reg led2,      // LED 2 output
  output reg led_ok,    // OK LED output
  output reg led_fail   // Fail LED output
);

// Define states as parameters
parameter [2:0] s_idle = 3'h0;
parameter [2:0] s_wait = 3'h1;
parameter [2:0] s_first = 3'h2;
parameter [2:0] s_ok = 3'h3;
parameter [2:0] s_fail = 3'h4;
parameter [2:0] s_fail_wait = 3'h5;

// Current state and next state registers
reg [2:0] c_state = 3'h0;
reg [2:0] n_state = 3'h0;

// State transition and output logic
always @(posedge clk or negedge n_rst) 
  if (!n_rst) 
    c_state <= s_idle;
  else 
    c_state <= n_state;

always @(c_state or start or bt0 or bt1 or bt2)
  case (c_state)
    // Idle state
    s_idle : begin
      n_state = (start == 1'b1) ? s_wait : c_state; 
      led0 = 1'b0;
      led1 = 1'b0;
      led2 = 1'b0;
      led_ok = 1'b0;
      led_fail = 1'b0;
    end

    // Wait state
    s_wait : begin
      if (bt2 == 1'b1) begin
        n_state = s_first;
        led2 = 1'b1;  // Turn on LED 2
      end
      else if (bt1 == 1'b1) begin
        n_state = s_fail_wait;
        led1 = 1'b1;  // Turn on LED 1
      end
      else if (bt0 == 1'b1) begin
        n_state = s_fail_wait;
        led0 = 1'b1;  // Turn on LED 0
      end
      else 
        n_state = s_wait;
    end

    // First button press state
    s_first : begin
      if (bt0 == 1'b1) begin
        n_state = s_ok;
        led0 = 1'b1;  // Turn on LED 0
      end
      else if (bt1 == 1'b1) begin
        n_state = s_fail;
        led1 = 1'b1;  // Turn on LED 1
      end
      else if (bt2 == 1'b1) begin
        n_state = s_fail;
        led2 = 1'b1;  // Turn on LED 2
      end
      else
        n_state = s_first;
    end

    // OK state
    s_ok : begin
      if (start == 1'b0) begin
        n_state = s_idle;
      end
      else begin
        n_state = s_ok; 
        led_ok = 1'b1;  // Turn on OK LED
      end
    end

    // Fail wait state
    s_fail_wait : begin
      if (bt0 == 1'b1) begin
        n_state = s_fail;
        led0 = 1'b1;  // Turn on LED 0
      end
      else if (bt1 == 1'b1) begin
        n_state = s_fail;
        led1 = 1'b1;  // Turn on LED 1
      end
      else if (bt2 == 1'b1) begin
        n_state = s_fail;
        led2 = 1'b1;  // Turn on LED 2
      end
      else
        n_state = s_fail_wait;
    end

    // Fail state
    s_fail : begin
      if (start == 1'b0) begin
        n_state = s_idle;   
      end
      else begin
        n_state = s_fail;
        led_fail = 1'b1;  // Turn on Fail LED
      end
    end

    // Default case
    default : begin
      n_state = s_idle;
    end
  endcase

endmodule
*/