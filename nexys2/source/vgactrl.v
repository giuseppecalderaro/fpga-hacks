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

/* VGA resolution controller.  */
module vgares_ctrl 
	#(
		/* 640x480 resolution.  */
		parameter 	HMAX = 0,
						HLINES = 0,
						HFP = 0,
						HSP = 0,
						VMAX = 0,
						VLINES = 0,
						VFP = 0,
						VSP = 0,
						SPP = 0
	)
	(
		input wire reset,
		input wire clk,
		output wire hs,
		output wire vs
	);

/* Active when inside visible area.  */
wire video_enable;

/* Blank signal.  */
reg blank_reg;
always @(posedge clk) begin
	blank_reg <= !video_enable;
end

/* Horizontal counter.  */
reg[10:0] hcount_reg;
always @(posedge clk, posedge reset) begin
	if (reset)
		hcount_reg <= 0;
	else
		if (hcount_reg == HMAX)
			hcount_reg <= 0;
		else
			hcount_reg <= hcount_reg + 1;
end

/* Vertical counter.  */
reg[10:0] vcount_reg;
always @(posedge clk, posedge reset) begin
	if (reset)
		vcount_reg <= 0;
	else
		if (hcount_reg == HMAX)
			if (vcount_reg == VMAX)
				vcount_reg <= 0;
			else
				vcount_reg <= vcount_reg + 1;
end

/* Horizontal sync.  */
reg hs_reg;
always @(posedge clk) begin
	if ((hcount_reg >= HFP) && (hcount_reg <= HSP))
		hs_reg <= SPP;
	else
		hs_reg <= !SPP;
end

/* Vertical sync.  */
reg vs_reg;
always @(posedge clk) begin
	if ((vcount_reg >= VFP) && (vcount_reg < VSP))
		vs_reg <= SPP;
	else
		vs_reg <= !SPP;
end

assign vs = vs_reg;
assign hs = hs_reg;

endmodule

module vgactrl(
		input wire reset,
		input wire clk,
		input wire resolution,
		output reg hs, /* Horizontal sync.  */
		output reg vs, /* Vertical sync.  */
		output wire[10:0] hcount,
		output wire[10:0] vcount	
    );

wire clk0, clk_25Mhz, clk_40Mhz;
wire clk0_dcm, clk_25Mhz_dcm, clk_40Mhz_dcm;
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
		.CLK0(clk0_dcm),
      .CLKDV(clk_25Mhz_dcm),
      .CLKFX(clk_40Mhz_dcm),
      .CLKFB(clk0),
      .CLKIN(clk),
      .RST(reset)
   );
/* Digital clock manager -- END  */

/* BUFGs  */
BUFG buf0 (
		.I(clk0_dcm),
		.O(clk0)
	);

BUFG buf_25Mhz (
		.I(clk_25Mhz_dcm),
		.O(clk_25Mhz)
	);
	
BUFG buf_40Mhz (
		.I(clk_40Mhz_dcm),
		.O(clk_40Mhz)
	);
/* BUFG -- END  */

/* 640x480 controller.  */
wire hs640x480, vs640x480;
vgares_ctrl #(
		.HMAX(800),
		.HLINES(640),
		.HFP(656),
		.HSP(752),
		.VMAX(525),
		.VLINES(480),
		.VFP(482),
		.VSP(484),
		.SPP(0)
	) vga640x480 (
		.clk(clk_25Mhz),
		.reset(reset),
		.hs(hs640x480),
		.vs(vs640x480)
	);
	
/* 800x600 controller.  */
wire hs800x600, vs800x600;
vgares_ctrl #(
		.HMAX(1056),
		.HLINES(800),
		.HFP(840),
		.HSP(968),
		.VMAX(628),
		.VLINES(600),
		.VFP(601),
		.VSP(605),
		.SPP(1)
	) vga800x600 (
		.clk(clk_40Mhz),
		.reset(reset),
		.hs(hs800x600),
		.vs(vs800x600)
	);


/* Mux.  */
always @(resolution) begin
	case (resolution)
	0:
		begin
			hs <= hs640x480;
			vs <= vs640x480;
		end
	1:
		begin
			hs	<= hs800x600;
			vs <= vs800x600;
		end
	endcase
end

endmodule
