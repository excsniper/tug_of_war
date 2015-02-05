`timescale 1ns / 1ps

module DIV256(
    output slowen,
	 input clk,
    input rst
    );

	reg [7:0] counter;
	
	assign slowen = &counter;  // counter == 255
	
	always @(posedge clk  or posedge rst) 
		if (rst) counter <= 0;
		else	counter <= counter + 1;

endmodule
