`timescale 1ns / 1ps

module Sound(
    output reg beep,
    input leds_on,
	 input clear,
    input clk,
    input rst
    );

	`define wait_leds_on 	0
	`define wait_clr			63

	reg [5:0] state, nxt_state;

	// seq logic
	always @(posedge clk or posedge rst)
	
		if (rst)
			state <= `wait_leds_on;
		else
			state <= nxt_state;
	
	// next state logic
	always @(*)
		
		case (state)
				
			`wait_leds_on:	if (leds_on) nxt_state = 1; else nxt_state = `wait_leds_on;
			`wait_clr:		if (clear) nxt_state = `wait_leds_on; else nxt_state = `wait_clr;
			
			// 1 <= state <= 62
			default:			nxt_state = state + 1;		
		
		endcase
	
	// output logic
	always @(*)
		
		case (state)
				
			`wait_leds_on:	beep = 0;
			`wait_clr:		beep = 0;
			
			// 1 <= state <= 62
			default:			beep = clk;	
		
		endcase
		
endmodule
