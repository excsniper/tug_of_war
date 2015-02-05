`timescale 1ns / 1ps

module Ready_Latch(
    output ready,
	 output G,
	 output H,
    input pbl,
    input pbr,
    input rst,
    input clear
    );
	
	wire clr;
	
	assign ready = G & H;
	assign clr = clear | rst;
	
	RS_Latch rsl(.Q(G), .trigger(pbl), .clr(clr));
	RS_Latch rsr(.Q(H), .trigger(pbr), .clr(clr));

endmodule
