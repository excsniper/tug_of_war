`timescale 1ns / 1ps

module Synchronizer(
    output reg sypush,
    input push,
    input clk,
    input rst
    );

	always @(posedge clk or posedge rst)
	begin		
	
		if(rst)
			sypush <= 0;
		else
			sypush <= push;
		
	end 

endmodule
