`timescale 1ns / 1ps

module VGA(
    output reg red,
    output reg green,
    output reg blue,
    output reg hsync,
    output reg vsync,
	 input red_in,
	 input green_in,
	 input blue_in,
	 input red_bg,
	 input green_bg,
	 input blue_bg,
	 input show_ready,
	 input ready_l,
	 input ready_r,
	 input [6:0] leds_out,
    input clk25,
    input rst
    );
	
	reg [9:0] hcounter, vcounter;

	always @(posedge clk25 or posedge rst)
	begin
		
		if (rst) {red, green, blue, hsync, vsync} <= {red_bg, green_bg, blue_bg, 0, 0};
		
		else begin
		
			if (hcounter == 799) begin
				hcounter <= 0;
				if (vcounter == 524)
					vcounter <= 0;
				else
					vcounter <= vcounter + 1;
			end else begin
				hcounter <= hcounter + 1;
			end
			
			if (vcounter >= 490 && vcounter < 491)
				vsync <= 0;
			else
				vsync <= 1;
				
			if (hcounter >= 656 && hcounter < 752)
				hsync <= 0;
			else
				hsync <= 1;
				
			if (hcounter < 640 && vcounter < 480) begin
			
				// background colour
				{red, green, blue} <= {red_bg, green_bg, blue_bg};			
				
				// reset bars
				if (show_ready && ready_l && hcounter <= 9)
					{red, green, blue} <= {red_in, green_in, blue_in};
					
				if (show_ready && ready_r && hcounter >= 629)				
					{red, green, blue} <= {red_in, green_in, blue_in};
				
				// LEDs
				if (vcounter >= 159 && vcounter <= 319)
					
					if (leds_out[6] && hcounter >= 15 && hcounter <= 85)
						{red, green, blue} <= {red_in, green_in, blue_in};
					else if (leds_out[5] && hcounter >= 105 && hcounter <= 175)
						{red, green, blue} <= {red_in, green_in, blue_in};
					else if (leds_out[4] && hcounter >= 195 && hcounter <= 265)
						{red, green, blue} <= {red_in, green_in, blue_in};
					else if (leds_out[3] && hcounter >= 285 && hcounter <= 355)
						{red, green, blue} <= {red_in, green_in, blue_in};
					else if (leds_out[2] && hcounter >= 375 && hcounter <= 445)
						{red, green, blue} <= {red_in, green_in, blue_in};
					else if (leds_out[1] && hcounter >= 465 && hcounter <= 535)
						{red, green, blue} <= {red_in, green_in, blue_in};
					else if (leds_out[0] && hcounter >= 555 && hcounter <= 625)
						{red, green, blue} <= {red_in, green_in, blue_in};

			end else begin
			
				// don't display anything
				{red, green, blue} <= {0, 0, 0};
			
			end
			
		end // if(rst)
	end //module

endmodule
