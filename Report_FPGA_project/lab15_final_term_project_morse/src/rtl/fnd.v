//fnd module
// Made by KIM, KWON, YOON

module fnd(
  input [7:0] din,
  output [6:0] dout
);

reg a, b, c, d, e, f, g;

always @(*)
  case(din)
    8'h30 : {g, f, e, d, c, b, a} = 7'b100_0000;
    8'h31 : {g, f, e, d, c, b, a} = 7'b111_1001;
    8'h32 : {g, f, e, d, c, b, a} = 7'b010_0100;
    8'h33 : {g, f, e, d, c, b, a} = 7'b011_0000;
    8'h34 : {g, f, e, d, c, b, a} = 7'b001_1001;
    8'h35 : {g, f, e, d, c, b, a} = 7'b001_0010;
    8'h36 : {g, f, e, d, c, b, a} = 7'b000_0010;
    8'h37 : {g, f, e, d, c, b, a} = 7'b101_1000;
    8'h38 : {g, f, e, d, c, b, a} = 7'b000_0000;
    8'h39 : {g, f, e, d, c, b, a} = 7'b001_0000;
    default : {g, f, e, d, c, b, a} = 7'b111_1111;
  endcase
  

assign dout = {g, f, e, d, c, b, a};


endmodule
