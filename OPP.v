`timescale 1ns / 1ps

module OPP(
    output winrnd,
    input sypush,
    input clk,
    input rst
    );

	`define OGATE_AND	0
	`define OGATE_XOR	1

	parameter OGATE = `OGATE_AND;

	reg rnd;
	
	// output
	assign winrnd = (OGATE == `OGATE_AND ? ~rnd & sypush : rnd ^ sypush);
	
	always @(posedge clk or posedge rst)
	begin
		
		if (rst)
			rnd <= 0;
		else
			rnd <= sypush;
			
	end

endmodule
