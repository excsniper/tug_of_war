`timescale 1ns / 1ps

module RS_Latch(Q, trigger, clr);

	output Q;
	input trigger, clr;
	
	assign Q = ~clr & (Q | trigger);

endmodule
