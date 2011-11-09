`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:38:42 05/31/2011 
// Design Name: 
// Module Name:    block1 
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
module block1
	#(
		parameter	WordWidth = 64,
						LogWidth	 = 3
	)
	(
	input wire block1_clk, block1_reset,
	/* Interface towards TopModule.  */
	input wire block1_LastWord,
	input wire block1_DataValid,
	input wire [WordWidth - 1:0] block1_Data,
	input wire [LogWidth - 1:0] block1_DataMod,
	output wire block1_DataAck,
	/* Interface towards FIFO.  */
	input wire block1_full,
	output wire block1_wr,
	output wire[WordWidth - 1:0] block1_w_data
	);

/* Local regs.  */
reg wr_reg, dataack_reg;
reg[WordWidth - 1:0] w_data_reg;

always @(posedge block1_clk, posedge block1_reset) begin
	if (block1_reset) begin		
		wr_reg <= 0;
		dataack_reg <= 0;
		w_data_reg <= 0;
	end else begin
		if (block1_DataValid) begin
			case (block1_DataMod)
					1:	
						w_data_reg <= block1_Data & 64'hFF000000_00000000;
					2:
						w_data_reg <= block1_Data & 64'hFFFF0000_00000000;
					3:
						w_data_reg <= block1_Data & 64'hFFFFFF00_00000000;
					4:
						w_data_reg <= block1_Data & 64'hFFFFFFFF_00000000;
					5:
						w_data_reg <= block1_Data & 64'hFFFFFFFF_FF000000;
					6:
						w_data_reg <= block1_Data & 64'hFFFFFFFF_FFFF0000;
					7:
						w_data_reg <= block1_Data & 64'hFFFFFFFF_FFFFFF00;
					default:
						w_data_reg <= block1_Data;
			endcase
			if (block1_full == 0) begin
				dataack_reg <= 1;
				wr_reg <= 1;
			end else begin
				dataack_reg <= 0;
				wr_reg <= 0;
			end
		end else begin	
			dataack_reg <= 0;
			w_data_reg <= 0;
			wr_reg <= 0;
		end
	end	
end

/* Output towards TopModule.  */
assign block1_DataAck = dataack_reg;
/* Outputs towards fifo.  */
assign block1_wr = wr_reg;
assign block1_w_data = w_data_reg;

endmodule
