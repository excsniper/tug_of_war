`timescale 1ns / 1ps

module MC(
    output reg leds_on,
    output reg clear,
    output reg [1:0] leds_ctrl,
	 output reg show_ready,
	 output reg ready_clr,
	 output reg clear_score,
    input winrnd,
	 input endrnd,
    input slowen,
    input rand,
	 input ready,
    input clk,
    input rst
    );

	/* Led status */
	`define led_all			0 // all leds on
	`define led_none		1 //all leds off
	`define led_score		3
	

	/* The Stages of the game */
	`define RESET			0
	`define Wait_a			1
	`define Wait_b			2
	`define Dark_Random	3
	`define Play			4
	`define Gloat_a		5
	`define Gloat_b		6
	`define Wait_ready	7

	reg [2:0] stage, nxt_stage;

	/* seq logic */
	always @(posedge clk or posedge rst)
		if (rst)
			stage <= `RESET;
		else
			stage <= nxt_stage;
		
	/* nxt_stage logic */
	always @(*)
	begin
		
		case(stage)
			
			`RESET: 			if (~rst) nxt_stage = `Wait_a; else nxt_stage = `RESET;
			`Wait_a: 		nxt_stage = (slowen ? `Wait_b : stage);	 // wait for 0.5s
			`Wait_b: 		nxt_stage = (slowen ? `Dark_Random : stage);			
			`Dark_Random:	if (winrnd)
									nxt_stage = `Gloat_a;  // jumped the light
								else
									nxt_stage = ((slowen & rand) ? `Play : stage);  // Get Ready To Rumble !!
			`Play:			nxt_stage = (winrnd ? `Gloat_a : stage);
			`Gloat_a:		nxt_stage = (slowen ? `Gloat_b : stage);	
			`Gloat_b:
								begin
									if (slowen)
										if (endrnd) nxt_stage = `Wait_ready;
										else			nxt_stage = `Dark_Random;
									else
										nxt_stage = stage;
								
								end 
			`Wait_ready:	nxt_stage = ((ready & slowen) ? `Wait_a : stage);		// wait for ready
			
			default: nxt_stage = `RESET;
		
		endcase
	
	end
	
	/* output logic */
	always @(*)
	begin
		show_ready = 0;
		ready_clr = 1;
		clear_score = 0;
		case(stage)
			
			`RESET: 			begin		leds_on = 0; clear = 1; leds_ctrl = `led_all;		end 
			`Wait_a: 		begin		leds_on = 0; clear = 1;	leds_ctrl = `led_all;		end
			`Wait_b: 		begin 	leds_on = 0; clear = 1; leds_ctrl = `led_all; clear_score = 1; end
			`Dark_Random:	begin 	leds_on = 0; clear = 0; leds_ctrl = `led_none;		end
			`Play:			begin 	leds_on = 1; clear = 0; leds_ctrl = `led_score;		end
			`Gloat_a:		begin 	leds_on = 0; clear = 1; leds_ctrl = `led_score;		end
			`Gloat_b:		begin 	leds_on = 0; clear = 1; leds_ctrl = `led_score;		end
			`Wait_ready:	begin		leds_on = 0; clear = 1; leds_ctrl = `led_score; ready_clr = 0; show_ready = 1; end
			
			default: 		begin 	leds_on = 0; clear = 1; leds_ctrl = `led_all;		end
			
		endcase
	end

endmodule
