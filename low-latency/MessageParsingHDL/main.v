`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:19 05/31/2011 
// Design Name: 
// Module Name:    main 
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
module main
	#(
		parameter 	WordWidth 	= 64,
						Bits 			= 3
	)
	(	
	input wire clk, reset,
	output wire InBus_DataAck,
	input wire InBus_LastWord,
	input wire InBus_DataValid,
	input wire[WordWidth - 1:0] InBus_Data,
	input wire[Bits - 1:0] InBus_DataMod,
	output wire OutBus_Valid,
	output wire OutBus_Start_Msg,
	output wire OutBus_End_Msg,
	output wire[Bits - 1:0] OutBus_Mod,
	output wire[WordWidth - 1:0] OutBus_Data
    );

/* Wires from TopModule to block1.  */
wire tb1_dataack;

/* Wires from block1 to fifo. */
wire fb1_full, b1f_wr;
wire[WordWidth - 1:0] b1f_w_data;

/* Wires from fifo to block2.  */
wire fb2_empty, b2f_rd;
wire[WordWidth - 1:0] fb2_r_data;

/* Wires from block2 to datapath.  */
wire db2_finished;
wire[WordWidth - 1:0] b2d_data;

/* Wires from datapath to TopModule.  */
wire dt_valid, dt_start_msg, dt_end_msg;
wire[Bits - 1:0] dt_mod;
wire[WordWidth - 1:0] dt_msg;

/* Instantiate block1  */
block1 blk1 (
	.block1_clk(clk),
	.block1_reset(reset),
	.block1_LastWord(InBus_LastWord),
	.block1_DataValid(InBus_DataValid),
	.block1_DataMod(InBus_DataMod),
	.block1_Data(InBus_Data),
	.block1_DataAck(tb1_dataack),
	.block1_wr(b1f_wr),
	.block1_w_data(b1f_w_data),
	.block1_full(fb1_full)
	);
	
fifo buffer (
	.fifo_clk(clk),
	.fifo_reset(reset),
	.fifo_rd(b2f_rd),
	.fifo_wr(b1f_wr),
	.fifo_w_data(b1f_w_data),
	.fifo_empty(fb2_empty),
	.fifo_full(fb1_full),
	.fifo_r_data(fb2_r_data)
	);

block2 blk2 (
	.block2_clk(clk),
	.block2_reset(reset),
	.block2_empty(fb2_empty),
	.block2_Data(fb2_r_data),
	.block2_rd(b2f_rd),
	.block2_finished(db2_finished),
	.block2_outdata(b2d_data)
	);

datapath dpath (
	.datapath_clk(clk),
	.datapath_reset(reset),
	.datapath_data(b2d_data),
	.datapath_finished(db2_finished),
	.datapath_Valid(dt_valid),
	.datapath_Start_Msg(dt_start_msg),
	.datapath_End_Msg(dt_end_msg),
	.datapath_Mod(dt_mod),
	.datapath_Msg(dt_msg)
	);

assign OutBus_Valid = dt_valid;
assign OutBus_Start_Msg = dt_start_msg;
assign OutBus_End_Msg = dt_end_msg;
assign OutBus_Mod = dt_mod;
assign OutBus_Data = dt_msg;
assign InBus_DataAck = tb1_dataack;

endmodule
