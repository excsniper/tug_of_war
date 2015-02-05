`timescale 1ns / 1ps

module PBL(
    output push,
    output tie,
    output right,
    input pbl,
    input pbr,
    input rst,
    input clear
    );

	wire G, H, pre_l, pre_r, clr;

	// clr signal
	assign clr = clear | rst;

	// pre-latch
	assign pre_l = pbl & ~H; 
	assign pre_r = pbr & ~G;

	//output
	assign push = G | H;
	assign tie = G & H;
	assign right = ~G & H;

	RS_Latch rsl(.Q(G), .trigger(pre_l), .clr(clr));
	RS_Latch rsr(.Q(H), .trigger(pre_r), .clr(clr));

endmodule
