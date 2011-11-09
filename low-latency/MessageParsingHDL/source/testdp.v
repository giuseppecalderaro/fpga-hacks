`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:04:44 06/04/2011
// Design Name:   main
// Module Name:   testdp.v
// Project Name:  
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testdp;

	// Inputs
	reg clk;
	reg reset;
	reg InBus_LastWord;
	reg InBus_DataValid;
	reg [63:0] InBus_Data;
	reg [2:0] InBus_DataMod;

	// Outputs
	wire InBus_DataAck;
	wire OutBus_Valid;
	wire OutBus_Start_Msg;
	wire OutBus_End_Msg;
	wire [2:0] OutBus_Mod;
	wire [63:0] OutBus_Data;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.clk(clk), 
		.reset(reset), 
		.InBus_DataAck(InBus_DataAck), 
		.InBus_LastWord(InBus_LastWord), 
		.InBus_DataValid(InBus_DataValid), 
		.InBus_Data(InBus_Data), 
		.InBus_DataMod(InBus_DataMod), 
		.OutBus_Valid(OutBus_Valid), 
		.OutBus_Start_Msg(OutBus_Start_Msg), 
		.OutBus_End_Msg(OutBus_End_Msg), 
		.OutBus_Mod(OutBus_Mod), 
		.OutBus_Data(OutBus_Data)
	);

	always
		#5 clk = ~clk;
		
	initial begin
		clk = 0;
		reset = 1;
		InBus_LastWord = 0;
		InBus_DataValid = 0;
		InBus_Data = 0;
		InBus_DataMod = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		/* Only one packet, type A.  */
		reset = 0;
		InBus_LastWord = 1;
		InBus_DataValid = 1;
		InBus_DataMod = 3'b100;
		InBus_Data = 64'h000441FF00000000;
		
		#10;
		
		/* Two packets, both type A.  */
		reset = 0;
		InBus_LastWord = 1;
		InBus_DataValid = 1;
		InBus_Data = 64'h000441CC000441AA;
		InBus_DataMod = 0;
		
		#10
				
		/* Two packets, type A / type D.  */
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 1;
		InBus_DataMod = 0;
		InBus_Data = 64'h0004415500204401;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 1;
		InBus_Data = 64'h23456789ABCDEFFE;
		InBus_DataMod = 0;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 1;
		InBus_Data = 64'hDCBA987654321001;
		InBus_DataMod = 0;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 1;
		InBus_Data = 64'h23456789ABCDEFFE;
		InBus_DataMod = 0;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 1;
		InBus_DataValid = 1;
		InBus_Data = 64'hDEADBEEF00000000;
		InBus_DataMod = 4;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 0;
		InBus_Data = 64'h0000000000000000;
		InBus_DataMod = 0;
		
		#50
		
		/* Two packets, type B.  */
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 1;
		InBus_DataMod = 0;
		InBus_Data = 64'h0014421122334455;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 1;
		InBus_DataMod = 0;
		InBus_Data = 64'h66778899AABBCCDD;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 1;
		InBus_DataValid = 1;
		InBus_DataMod = 0;
		InBus_Data = 64'hEEFFEEDD00044101;
		
		#10;
		
		reset = 0;
		InBus_LastWord = 0;
		InBus_DataValid = 0;
		InBus_Data = 64'h0000000000000000;
		InBus_DataMod = 0;
		
	end
      
endmodule

