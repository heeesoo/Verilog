/*
module segement_7(
    number,
    fnd_on
);

input [3:0] number;

output [6:0] fnd_on;

reg a;
reg b;
reg c;
reg d;
reg e;
reg f;
reg g;

always @(number) begin
    case(number)
        4'b0000 : begin  // 0
            {g, f, e, d, c, b, a} = 7'b100_0000;
        end

        4'b0001 : begin  // 1
            {g, f, e, d, c, b, a} = 7'b111_1001;
        end

        4'b0010 : begin  // 2
            {g, f, e, d, c, b, a} = 7'b010_0100;
        end

        4'b0011 : begin  // 3
            {g, f, e, d, c, b, a} = 7'b011_0000;
        end

        4'b0100 : begin  // 4
            {g, f, e, d, c, b, a} = 7'b001_1001;
        end

        4'b0101 : begin  // 5
            {g, f, e, d, c, b, a} = 7'b001_0010;
        end

        4'b0110 : begin  // 6
            {g, f, e, d, c, b, a} = 7'b000_0010;
        end

        4'b0111 : begin  // 7
            {g, f, e, d, c, b, a} = 7'b101_1000;
        end

        4'b1000 : begin  // 8
            {g, f, e, d, c, b, a} = 7'b000_0000;
        end

        4'b1001 : begin  // 9
            {g, f, e, d, c, b, a} = 7'b001_0000;
        end

        4'b1010 : begin // A
            {g, f, e, d, c, b, a} = 7'b000_1000;
        end

        4'b1011 : begin  // B
            {g, f, e, d, c, b, a} = 7'b000_0011;
        end

        4'b1100 : begin  // C
            {g, f, e, d, c, b, a} = 7'b100_0110;
        end

        4'b1101 : begin  // D
            {g, f, e, d, c, b, a} = 7'b010_0001;
        end

        4'b1110 : begin  // E
            {g, f, e, d, c, b, a} = 7'b000_0110;
        end

        4'b1111 : begin  // F
            {g, f, e, d, c, b, a} = 7'b000_1110;
        end

        default : begin
             {g, f, e, d, c, b, a} = 7'b111_1111;
        end
    endcase
end

assign fnd_on = {g, f, e, d, c, b, a};

endmodule


*/
