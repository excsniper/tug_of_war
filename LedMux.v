`timescale 1ns / 1ps

module LedMux(
    output reg [6:0] leds_out,
    input [6:0] score,
    input [1:0] leds_ctrl
    );

	/* Led status */
	`define led_all		0 // all leds on
	`define led_none		1 //all leds off
	`define led_score		3

	always @(*)
	begin
		
		case(leds_ctrl)
		
			`led_all: leds_out = 7'b1111111;
			`led_none: leds_out = 7'b0000000;
			`led_score: leds_out = score;
			default: leds_out = 7'b0000000;
		
		endcase
		
	end

endmodule
