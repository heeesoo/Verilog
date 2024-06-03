module mem_controller#(
  parameter D_WIDTH = 8,
  parameter A_WIDTH = 4
)(
  input               clk,
  input               n_rst,

  // Uart Rx to Mem_Controller
  input [D_WIDTH-1:0] rx_data,
  input               rx_done,
  input               r_en,

  // RAM Read Control to 16x8 RAM
  input [D_WIDTH-1:0] r_data,

  // RAM Write Control to 16x8 RAM
  output                    w_en,   
  output reg [A_WIDTH-1:0]  w_addr, 
  output     [D_WIDTH-1:0]  w_data,

  // RAM_Read_Control to 16x8 RAM
  output reg [A_WIDTH-1:0]  r_addr,
  
  // Mem Controller to FND Output
  output reg [D_WIDTH-1:0]  fnd_data
);
  
wire              clear;

reg [A_WIDTH-1:0] r_addr_3_to_0;

// w_data    
assign w_data = rx_data;  
// By to Pass로 입력 데이터를 곧바로 w_data에 할당시켜준다.

// w_addr
always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        w_addr <= {(A_WIDTH){1'b0}};
    end

    else begin
        if (clear == 1'b1) begin
            w_addr <= {(A_WIDTH){1'b0}};
            // clear가 1이면 쓰기 데이터를 초기화시켜주고
        end

        else if (w_en == 1'b1) begin
            w_addr <= (w_addr < {{(A_WIDTH-1){1'b0}},3'b100}) ? w_addr + 1'b1 : w_addr;
            // write enable이 들어왔을 때
            // 쓰기 주소의 값이 3일 때 까지 +1을 해주고 그게 아니거나 넘어가게 되면 기존 값 유지
        end
    end
end


// w_en
assign w_en = ((rx_done == 1'b1) && (w_addr != {{(A_WIDTH-1){1'b0}},3'b100}))? 1'b1 : 1'b0;
// 입력 done이 1이며 쓰기주소 w_addr이 4가 아니라면 en에 1, 아니면 0

// r_addr
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    r_addr <= {(A_WIDTH){1'b0}};
  end

  else begin
    if ((r_en == 1'b1) && (r_addr <= {{(A_WIDTH-2){1'b0}}, 2'b10})) begin
      r_addr <= r_addr + {{(A_WIDTH-1){1'b0}},1'b1};
      // 읽기 인에이블인 r_en이 1이며 r_addr이 2이면 r_adder에 1씩 추가
    end

    else if ((r_addr == {{(A_WIDTH-2){1'b0}}, 2'b11}) && (r_en == 1'b1)) begin
      r_addr <= {(A_WIDTH){1'b0}};
      // r_addr이 3이며 r_en이 1이면 초기화
    end

    else begin
      r_addr <= r_addr;
      // 나머지 상태에서는 현행 유지
    end
  end
end

// r_addr_3_to_0 
always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        r_addr_3_to_0 <= {(A_WIDTH){1'b0}};
    end

    else begin
        r_addr_3_to_0 <= r_addr;
        // r_addr_3_to_0에 r_addr값 할당
    end
end

assign clear = ((r_addr == {(A_WIDTH){1'b0}}) && (r_addr_3_to_0 == {{(A_WIDTH-2){1'b0}}, 2'b11})) ? 1'b1 : 1'b0;
// clear에 r_addr의 전 값이 0, 현 값이 3일 때 1을 출력 아니면 0

// fnd_data
always @(posedge clk or negedge n_rst) begin
  if(!n_rst) begin
    fnd_data <= {(D_WIDTH){1'b0}};
  end

  else begin
    if (r_en == 1'b1) begin
      fnd_data <= r_data;
      // r_en이 1일 때, fnd에 r_data를 할당
    end

    else begin
      fnd_data <= fnd_data;
      // 따른 조건이 없을 때 현행 유지
    end
  end
end

endmodule