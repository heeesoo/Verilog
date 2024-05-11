module byte_2_ascii(
    input       clk,
    input       n_rst,
    input [7:0] do,
    input       ns,
    input       uart_tx_done,

    output reg       next_start,    
    output reg [7:0] data_out
);

localparam S_IDLE = 2'b00;
localparam S_1 = 2'b01;
localparam S_2 = 2'b10;
localparam S_3 = 2'b11;

reg [1:0]   n_state;    // next state
reg [1:0]   c_state;    // current state

reg [7:0]   temp;   
reg         uart_start;


// State FF
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        c_state <= S_IDLE;
    end
    
    else begin
        c_state <= n_state;
    end
end

// State Machine (Combinational Logic)
always @(*) begin
    case(c_state)
        S_IDLE: begin
            n_state = (ns)? S_1 : c_state;
            uart_start = (n_state == S_1)? 1'b1 : 1'b0;
        end

        S_1: begin
          n_state = (uart_tx_done)? S_2 : c_state;
          uart_start = (n_state == S_2)? 1'b1 : 1'b0;
        end

        S_2: begin
          n_state = (uart_tx_done)? S_3 : c_state;
          uart_start = (n_state == S_3)? 1'b1 : 1'b0;
        end

        S_3: begin
          n_state = (uart_tx_done)? S_IDLE : c_state;
          uart_start = (n_state == S_IDLE)? 1'b1 : 1'b0;
        end

        default: begin
          n_state = S_IDLE;
          uart_start = 1'b0;
        end

    endcase
end


// Next_start FF  
always @(posedge clk or negedge n_rst) begin
  if (!n_rst) begin
    next_start <= 1'b0;
  end

  else begin
    next_start <= uart_start;
  end
end

// DATA Temp FF
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        temp <= 8'h00;
    end

    else begin
      if (ns) begin
        temp <= do;
      end

      else begin
        temp <= temp;
      end
    end
end

// Data_out FF 
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        data_out <= 8'h00;
    end

    else begin
        case(c_state) 
            S_1 : begin 
                data_out <= (temp[7:4] < 4'hA)? {4'h3, temp[7:4]} : 
                              {4'h4, temp[7:4] - 4'h9};
            end

            S_2 : begin
                data_out <= (next_start && (temp[3:0] < 4'hA))? {4'h3, temp[3:0]} :
                              (next_start && ((temp[3:0] >= 4'hA) && (temp[3:0] <= 4'hF)))? {4'h4, temp[3:0] - 4'h9} :
                                  data_out;
            end

            S_3 : begin
                data_out <= 8'h20;
            end

            default begin
                data_out <= data_out;
            end
        endcase
    end
end

endmodule