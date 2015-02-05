`timescale 1ns / 1ps

module tow(
    output [6:0] leds_out,
	 output leds_on,
	 output beep,
	 output red,
	 output green,
	 output blue,
	 output hsync,
	 output vsync,
	 output pbl_high,
    input pbl,
    input pbr,
	 input red_in,
	 input green_in,
	 input blue_in,
	 input red_bg,
	 input green_bg,
	 input blue_bg,
    input clk,
	 input clk50,
	 input rst
    );

	wire slowen, rout, push, tie, right, sypush, clk25, clr, ready_clr, pbl_p, pbr_p, G, H, show_ready, ready, endrnd, clear_score;
	wire [1:0] leds_ctrl;
	wire [6:0] score;

	dcm50to25 dcm (
    .CLKIN_IN(clk50), 
    .RST_IN(rst), 
    .CLKFX_OUT(clk25)
    );

	assign pbl_high = 1;  // local vcc

	// OPP
	`define OGATE_AND	0
	`define OGATE_XOR	1

	OPP #(`OGATE_AND) opp(.winrnd(winrnd), .sypush(sypush), .clk(clk), .rst(rst));	
	OPP #(`OGATE_XOR) opp_pbl (.winrnd(pbl_p), .sypush(pbl), .clk(clk), .rst(rst));		// using OPP to fix toggle switch problem
	OPP #(`OGATE_XOR) opp_pbr (.winrnd(pbr_p), .sypush(pbr), .clk(clk), .rst(rst));

	PBL pb_latch(.push(push), .tie(tie), .right(right), .pbl(pbl_p), .pbr(pbr_p), .rst(rst), .clear(clr));
	Ready_Latch ready_latch(.ready(ready), .G(G), .H(H), .pbl(pbl_p), .pbr(pbr_p), .rst(rst), .clear(ready_clr));

	DIV256 div256(.slowen(slowen), .clk(clk), .rst(rst));
	LFSR lfsr(.rout(rout), .clk(clk), .rst(rst));
	Synchronizer synczor(.sypush(sypush), .push(push), .clk(clk), .rst(rst));
	Scorer scorer(.winrnd(winrnd), .right(right), .leds_on(leds_on), .tie(tie), .clk(clk), .rst(rst), .score(score), .endrnd(endrnd), .clear_score(clear_score));
	MC mc(.leds_on(leds_on), .clear(clr), .clear_score(clear_score), .leds_ctrl(leds_ctrl), .show_ready(show_ready), .ready_clr(ready_clr), .winrnd(winrnd), .slowen(slowen), .rand(rout),
			.endrnd(endrnd), .ready(ready), .clk(clk), .rst(rst));
	LedMux ledmux(.leds_out(leds_out), .score(score), .leds_ctrl(leds_ctrl));
	
	Sound sound(.beep(beep), .leds_on(leds_on), .clear(clr), .clk(clk), .rst(rst));
	VGA vga(.red(red), .green(green), .blue(blue), .hsync(hsync), .vsync(vsync), .red_in(red_in), .green_in(green_in), .blue_in(blue_in),
			  .red_bg(red_bg), .green_bg(green_bg), .blue_bg(blue_bg), .show_ready(show_ready), .ready_l(G), .ready_r(H), .leds_out(leds_out), .clk25(clk25), .rst(rst));

endmodule
