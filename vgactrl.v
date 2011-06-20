`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Giuseppe Calderaro
// 
// Create Date:    18:01:25 06/17/2011 
// Design Name: 
// Module Name:    vgactrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	Res 800x600 if resolution == 1
//						Res 640x480 if resolution == 0
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vgactrl(
		input wire reset,
		input wire clk,
		input wire resolution,
		output wire hs, /* Horizontal sync.  */
		output wire vs, /* Vertical sync.  */
		output wire[10:0] hcount,
		output wire[10:0] vcount
    );

wire clk_25Mhz_dcm, clk_40Mhz_dcm;
/* Digital clock manager.  */
DCM_SP #(
      .CLKDV_DIVIDE(2.0),
      .CLKFX_DIVIDE(5),
      .CLKFX_MULTIPLY(4),
      .CLKIN_DIVIDE_BY_2("FALSE"),
      .CLKIN_PERIOD(20.0),
      .CLKOUT_PHASE_SHIFT("NONE"),
      .CLK_FEEDBACK("1X"),
      .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"),
      .DLL_FREQUENCY_MODE("LOW"),
      .DUTY_CYCLE_CORRECTION("TRUE"),
      .PHASE_SHIFT(0),
      .STARTUP_WAIT("FALSE")
   ) DCM_SP_inst (
      .CLKDV(clk_25Mhz_dcm),
      .CLKFX(clk_40Mhz_dcm),
      .CLKFB(clk),
      .CLKIN(clk),
      .RST(reset)
   );
/* Digital clock manager -- END  */

wire clk_25Mhz, clk_40Mhz;
/* BUFGs  */
BUFG buf_25Mhz (
		.I(clk_25Mhz_dcm),
		.O(clk_25Mhz)
	);
	
BUFG buf_40Mhz (
		.I(clk_40Mhz_dcm),
		.O(clk_40Mhz)
	);
/* BUFG -- END  */

localparam 	HMAX 		= 800,
				HLINES	= 640,
				HFP		= 656,
				HSP		= 752;

reg hs_reg, vs_reg;
reg[10:0] hcount_reg, vcount_reg;

always @(posedge clk_25Mhz) begin
	hs_reg <= 1'b0;
	vs_reg <= 1'b0;
	hcount_reg <= 0;
	vcount_reg <= 0;
end

assign hs = hs_reg;
assign vs = vs_reg;
assign hcount = hcount_reg;
assign vcount = vcount_reg;

endmodule
