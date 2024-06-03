module fnd(
	din,
	dout
);

parameter OFF = 1'b1;
parameter ON = 1'b0;
input[3:0] din;
//output [7:0] dout;
output [6:0] dout;

reg a, b, c, d, e, f, g;
//wire h;

// off condition
always @(din)
	case (din)
		4'h0 : {a,b,c,d,e,f,g} = {ON ,ON ,ON ,ON ,ON ,ON ,OFF};
		4'h1 : {a,b,c,d,e,f,g} = {OFF,ON ,ON ,OFF,OFF,OFF,OFF}; 
		4'h2 : {a,b,c,d,e,f,g} = {ON ,ON ,OFF,ON ,ON ,OFF,ON }; 
		4'h3 : {a,b,c,d,e,f,g} = {ON ,ON ,ON ,ON ,OFF,OFF,ON }; 
		4'h4 : {a,b,c,d,e,f,g} = {OFF,ON ,ON ,OFF,OFF,ON ,ON }; 
		4'h5 : {a,b,c,d,e,f,g} = {ON ,OFF,ON ,ON ,OFF,ON ,ON }; 
		4'h6 : {a,b,c,d,e,f,g} = {ON ,OFF,ON ,ON ,ON ,ON ,ON }; 
		4'h7 : {a,b,c,d,e,f,g} = {ON ,ON ,ON ,OFF,OFF,OFF,OFF}; 
		4'h8 : {a,b,c,d,e,f,g} = {ON ,ON ,ON ,ON ,ON ,ON ,ON }; 
		4'h9 : {a,b,c,d,e,f,g} = {ON ,ON ,ON ,ON ,OFF,ON ,ON }; 
		4'hA : {a,b,c,d,e,f,g} = {ON ,ON ,ON ,OFF,ON ,ON ,ON }; 
		4'hB : {a,b,c,d,e,f,g} = {OFF,OFF,ON ,ON ,ON ,ON ,ON }; 
		4'hC : {a,b,c,d,e,f,g} = {ON ,OFF,OFF,ON ,ON ,ON ,OFF}; 
		4'hD : {a,b,c,d,e,f,g} = {OFF,ON ,ON ,ON ,ON ,OFF,ON }; 
		4'hE : {a,b,c,d,e,f,g} = {ON ,OFF,OFF,ON ,ON ,ON ,ON }; 
		4'hF : {a,b,c,d,e,f,g} = {ON ,OFF,OFF,OFF,ON ,ON ,ON }; 
		default : {a,b,c,d,e,f,g} = {OFF,OFF,OFF,OFF,OFF,OFF,OFF};
	endcase

//assign h = 1'b1;

//assign dout = {h,g,f,e,d,c,b,a};
assign dout = {g,f,e,d,c,b,a};

endmodule
