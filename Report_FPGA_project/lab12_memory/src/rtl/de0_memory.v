`define FPGA

module de0_memory (
    clk, 
    n_rst,
    sw,
    fnd0, 
    fnd1, 
    fnd2, 
    fnd3
);

input clk; 
input n_rst;
input [5:0] sw;

output [6:0] fnd0; 
output [6:0] fnd1;
output [6:0] fnd2; 
output [6:0] fnd3;

wire [4:0] rom_addr; 
wire [7:0] rom_data;

reg [4:0] ram_waddr; 
wire [7:0] ram_wdata;

reg ram_wen;
reg [4:0] ram_raddr; 
wire [7:0] ram_rdata;

assign rom_addr = {sw[4:0]};

always @(posedge clk or negedge n_rst)
    if (!n_rst) begin
        ram_waddr <= 5'h00;
        ram_wen <= 1'b0;
    end

    else begin
        ram_waddr <= rom_addr;
        ram_wen <= sw[5];
    end

assign ram_wdata = rom_data;

always @(posedge clk or negedge n_rst)
    if (!n_rst) ram_raddr <= 5'h00;
    else ram_raddr <= (ram_wen == 1'b1)? ram_waddr :
                                            ram_addr;


`ifdef FPGA
rom_32x8 rom_32x8_inst (
    .address ( rom_addr ),
    .clock ( clk ),
    .q ( rom_data )
);

ram_dual_32x8 ram_dual_32x8_inst (
    .clock ( clk ),
    .data ( ram_wdata ),
    .rdaddress ( ram_raddr ),
    .wraddress ( ram_waddr ),
    .wren ( ram_wen ),
    .q ( ram_rdata )
);

`else 
rom #( .D_WIDTH(8), .A_WIDTH(5) ) u_rom_32x8 (
    .addr(rom_addr),
    .clk(clk),
    .data(rom_data)
);

ram_dual #( .D_WIDTH(8), .A_WIDTH(5) ) u_ram_dual_32x8 (
    .clk (clk),
    .waddr(ram_waddr),
    .wen(ram_wen),
    .wdata(ram_wdata),
    .raddr(ram_raddr),
    .rdata(ram_rdata)
);
`endif


fnd_enc u_fnd_rom_addr(
    .din(rom_addr[3:0]), 
    .dout(fnd3) 
);

fnd_enc u_fnd_rom_data(
    .din(rom_data[3:0]), 
    .dout(fnd2)
);
fnd_enc u_fnd_ram_raddr(
    .din(ram_raddr[3:0]), 
    .dout(fnd1)
);
fnd_enc u_fnd_ram_rdata(
    .din(ram_rdata[3:0]), 
    .dout(fnd0)
);
endmodule