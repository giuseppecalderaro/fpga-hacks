`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:58:01 06/16/2011 
// Design Name: 
// Module Name:    sevenseg 
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
module sevenseg(
		input wire clk, reset,
		input wire[3:0] segment0,
		input wire[3:0] segment1,
		input wire[3:0] segment2,
		input wire[3:0] segment3,
		output wire[3:0] anodes,
		output wire[7:0] segments_out
    );

wire finished;
modcounter 
#(
	.MOD(1 << 17)
)
counter (
	.clk(clk),
	.reset(reset),
	.finished(finished)
);

localparam		seg0 = 2'b00,
					seg1 = 2'b01,
					seg2 = 2'b10,
					seg3 = 2'b11;

function [7:0] decoder;
	input [3:0] number;
	case (number)
		4'b0000:
			decoder = 8'b11000000;
		4'b0001:
			decoder = 8'b11111001;
		4'b0010:
			decoder = 8'b10100100;
		4'b0011:
			decoder = 8'b10110000;
		4'b0100:
			decoder = 8'b10011001;
		4'b0101:
			decoder = 8'b10010010;
		4'b0110:
			decoder = 8'b10000010;
		4'b0111:
			decoder = 8'b11111000;
		4'b1000:
			decoder = 8'b10000000;
		4'b1001:
			decoder = 8'b10010000;
		4'b1010:
			decoder = 8'b10001000;
		4'b1011:
			decoder = 8'b10000011;
		4'b1100:
			decoder = 8'b11000110;
		4'b1101:
			decoder = 8'b10100001;
		4'b1110:
			decoder = 8'b10000110;
		4'b1111:
			decoder = 8'b10001110;
	endcase
endfunction

/* State reg.  */
reg[1:0] state_reg;
/* Local regs.  */
reg[3:0] anodes_reg;
reg[7:0] segments_reg;

always @(posedge clk, posedge reset) begin
	if (reset)
		state_reg <= seg0;
	else
		if (finished != 0)
			state_reg <= state_reg + 1;
end

always @(state_reg) begin
	case (state_reg)
		0:
			begin
				anodes_reg <= 4'b1110;
				segments_reg <= decoder(segment0);
			end
		1:
			begin
				anodes_reg <= 4'b1101;
				segments_reg <= decoder(segment1);
			end
		2:
			begin
				anodes_reg <= 4'b1011;
				segments_reg <= decoder(segment2);
			end
		3:
			begin
				anodes_reg <= 4'b0111;
				segments_reg <= decoder(segment3);
			end
	endcase
end

assign anodes = anodes_reg;
assign segments_out = segments_reg;

endmodule
