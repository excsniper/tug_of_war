`timescale 1ns / 1ps

module LFSR(
    output rout,
    input clk,
    input rst
    );

	reg [9:0] lfsr;
	assign rout = lfsr[0];
	
	always @(posedge clk or posedge rst)
		if (rst) lfsr[9:0] <= 10'b1000000000;
		else begin
			lfsr[8:0] <= lfsr[9:1];
			lfsr[9] <= lfsr[0]^lfsr[3];	// x^10 + x^3 + 1
		end

endmodule
