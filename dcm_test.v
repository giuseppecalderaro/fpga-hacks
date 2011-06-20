`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:16:55 06/19/2011
// Design Name:   vgactrl
// Module Name:   C:/Users/giuseppe/Projects/FpgaDev/Nexys2/dcm_test.v
// Project Name:  Nexys2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vgactrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dcm_test;

	// Inputs
	reg reset;
	reg clk;
	reg resolution;

	// Outputs
	wire slowclk;
	wire hs;
	wire vs;
	wire [10:0] hcount;
	wire [10:0] vcount;

	// Instantiate the Unit Under Test (UUT)
	vgactrl uut (
		.slowclk(slowclk), 
		.reset(reset), 
		.clk(clk), 
		.resolution(resolution), 
		.hs(hs), 
		.vs(vs), 
		.hcount(hcount), 
		.vcount(vcount)
	);

	always
		#10 clk = ~clk;

	initial begin
		// Initialize Inputs
		reset = 1;
		clk = 0;
		resolution = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		reset = 0;

	end
      
endmodule

