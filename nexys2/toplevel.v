`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:00 06/15/2011 
// Design Name: 
// Module Name:    led 
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
module toplevel
	(
		/* Clock.  */
		input wire clk,
		/* Inputs.  */
		input wire[3:0] buttons,
		input wire[7:0] switches,
		/* Outputs.  */
		output wire[7:0] leds,
		output wire[3:0] anodes,
		output wire[7:0] segments,
		/* VGA Controller.  */
		output wire hs, /* Horizontal sync.  */
		output wire vs, /* Vertical sync.  */
		output wire[10:0] hcount,
		output wire[10:0] vcount
    );

/* Modulus counter.  */
wire finished;
modcounter 
#(
	.MOD(1 << 25)
)
cnt1 (
	.clk(clk),
	.reset(buttons[0]),
	.finished(finished)
);
/* Modulus counter -- END  */

/* Seven segments controller.  */
sevenseg ssegctrl (
	.clk(clk),
	.reset(buttons[0]),
	.segment0(4'b0000),
	.segment1(4'b1010),
	.segment2(4'b0001),
	.segment3(4'b1100),
	.anodes(anodes),
	.segments_out(segments)
);
/* Seven segments controller -- END  */

/* VGA controller.  */
vgactrl VGA_Controller (
	.reset(buttons[0]),
	.clk(clk),
	.resolution(switches[0]),
	.hs(hs),
	.vs(vs),
	.hcount(hcount),
	.vcount(vcount)
);
/* VGA controller -- END  */

localparam 	idle = 1'b0,
				next = 1'b1;

/* State register.  */
reg state_reg;
reg[7:0] leds_reg;

always @(posedge clk, posedge buttons[0]) begin
	if (buttons[0]) begin
		leds_reg <= 0;
		state_reg <= idle;
	end else begin
		case (state_reg)
			idle:
				if (finished)
					if (leds_reg == 0)
						leds_reg <= 1;
					else
						leds_reg <= leds_reg << 1;
		endcase
	end
end
	
assign leds = leds_reg;
	
endmodule
