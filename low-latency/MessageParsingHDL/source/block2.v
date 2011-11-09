`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:55 05/31/2011 
// Design Name: 
// Module Name:    block2 
// Project Name: 
// Target Devices: 
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
module block2
	#(
		parameter	WordWidth = 64,
						LogWidth	 = 3
	)
	(
		input wire block2_clk, block2_reset,
		/* Signals towards FIFO.  */
		input wire block2_empty,
		input wire [WordWidth - 1:0] block2_Data,
		output wire block2_rd,
		/* Signals towards DataPath.  */
		input wire block2_finished,
		output wire[WordWidth - 1:0] block2_outdata
    );

localparam			idle 				= 1'b0,
						busy	 			= 1'b1;

/* State regs.  */	
reg[1:0] state_reg, state_next;

always @(posedge block2_clk, posedge block2_reset) begin
	if (block2_reset)
		state_reg <= idle;
	else
		state_reg <= state_next;
end

reg rd;
reg[WordWidth - 1:0] data;

always @* begin
	case (state_reg)
		idle:
			begin
				if (block2_empty == 0) begin
					rd = 1;
					data = block2_Data;
					state_next = busy;
				end else begin
					rd = 0;
					data = 0;
					state_next = idle;
				end
			end
		busy:
			begin
				rd = 0;
				if (block2_finished)
					state_next = idle;
			end
	endcase
end

assign block2_rd = rd;
assign block2_outdata = data;

endmodule
