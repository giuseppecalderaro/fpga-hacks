`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Giuseppe Calderaro
// 
// Create Date:    19:51:30 06/16/2011 
// Design Name: 
// Module Name:    modcounter 
// Project Name: 
// Target Devices: Spartan 3E xc3s500e-4fg320
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module modcounter
	#(
		parameter MOD = (1 << 0)
	)
	(
		input wire clk, reset,
		output wire[31:0] cnt,
		output wire finished
	);
	
reg[31:0] cnt_reg;
reg finished_reg;
	
always @(posedge clk, posedge reset) begin
	if (reset) begin
		finished_reg <= 0;
		cnt_reg <= 0;
	end else begin
		finished_reg <= 0;
		cnt_reg <= (cnt_reg + 1) % MOD;
		if (cnt_reg == MOD - 1)
			finished_reg <= 1;
	end
end

assign finished = finished_reg;
assign cnt = cnt_reg;
	
endmodule
