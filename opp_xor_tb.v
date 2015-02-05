`timescale 1ms / 1ms


module opp_xor_tb;

	// Inputs
	reg sypush;
	reg clk;
	reg rst;

	// Outputs
	wire winrnd;

	// Instantiate the Unit Under Test (UUT)
	OPP #(0) uut (
		.winrnd(winrnd), 
		.sypush(sypush), 
		.clk(clk), 
		.rst(rst)
	);
	
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		sypush = 0;
		clk = 0;
		rst = 1;
	
		@(posedge clk);
		#1 rst = 0;
	
		repeat(3) @(posedge clk);
   
		#1 sypush = 1;
	
		repeat(5) @(posedge clk);
		
		#1 sypush = 0;
	
		repeat(5) @(posedge clk);
		
		#1 sypush = 1;
	
		repeat(5) @(posedge clk);
		
		#1 sypush = 0;
	
		repeat(5) @(posedge clk);
		
		$finish;
		
	end
      
endmodule

