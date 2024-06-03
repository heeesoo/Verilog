module ram_dual_16x8#(
    parameter D_WIDTH = 8,
    parameter A_WIDTH = 4
)(
    input               clk,

    // RAM Write Control to 16x8 RAM
    input [A_WIDTH-1:0] waddr,
    input               wen,
    input [D_WIDTH-1:0] wdata,

    // RAM_Read_Control to 16x8 RAM
    input [A_WIDTH-1:0] raddr,

    // RAM Read Control to 16x8 RAM
    output reg [D_WIDTH-1:0] rdata
);

// Single-clk, Simple Dual-Port Synchronous RAM
// with Old wdata Read-During-Write Behavior
reg [D_WIDTH-1:0] ram[2**(A_WIDTH-1):0];

always @ (posedge clk) begin
    if (wen == 1'b1) begin  
        ram[waddr] <= wdata;
        // wen이 1이면 쓰는 데이터를 ram에 할당
    end
    
    rdata <= ram[raddr];
    // 예외에서는 ram의 읽은 주소값을 rdata에 할당
end

endmodule