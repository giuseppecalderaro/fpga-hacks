`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:18 05/31/2011 
// Design Name: 
// Module Name:    fifo 
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
module fifo
	#(
		parameter 	WordWidth = 64,
						Bits = 4
	)
	(
		input wire fifo_clk, fifo_reset,
		input wire fifo_rd, fifo_wr,
		input wire[WordWidth - 1:0] fifo_w_data,
		output wire fifo_empty, fifo_full,
		output wire [WordWidth - 1:0] fifo_r_data
	);

/* Signal declaration.  */
reg[WordWidth - 1:0] array_reg[2**Bits - 1:0]; /* register array.  */
reg[Bits - 1:0] w_ptr_reg, w_ptr_next, w_ptr_succ;
reg[Bits - 1:0] r_ptr_reg, r_ptr_next, r_ptr_succ;
reg full_reg, empty_reg, full_next, empty_next;
wire wr_en;

/* Register file write operation.  */
always @(posedge fifo_clk) begin
	if (wr_en)
		array_reg[w_ptr_reg] <= fifo_w_data;
end
/* Register file read operation.  */
assign fifo_r_data = array_reg[r_ptr_reg];
assign wr_en = fifo_wr & ~full_reg;

/* FIFO control logic.  */
always @(posedge fifo_clk, posedge fifo_reset) begin
	if (fifo_reset)
		begin
			w_ptr_reg <= 0;
			r_ptr_reg <= 0;
			full_reg <= 1'b0;
			empty_reg <= 1'b1;
		end
	else
		begin
			w_ptr_reg <= w_ptr_next;
			r_ptr_reg <= r_ptr_next;
			full_reg <= full_next;
			empty_reg <= empty_next;
		end	
end

/* Next state logic.  */
always @* begin
	/* Successive pointer values.  */
	w_ptr_succ = w_ptr_reg + 1;
	r_ptr_succ = r_ptr_reg + 1;
	/* Default: keep old values.  */
	w_ptr_next = w_ptr_reg;
	r_ptr_next = r_ptr_reg;
	full_next = full_reg;
	empty_next = empty_reg;
	case ({fifo_wr, fifo_rd})
		/* 2'b00: nop  */
		2'b01: /* read.  */
			if (~empty_reg)
				begin
					r_ptr_next = r_ptr_succ;
					full_next = 1'b0;
					if (r_ptr_succ == w_ptr_reg)
						empty_next = 1'b1;
				end
		2'b10: /* write.  */
			if (~full_reg)
				begin
					w_ptr_next = w_ptr_succ;
					empty_next = 1'b0;
					if (w_ptr_succ == r_ptr_reg)
						full_next = 1'b1;
				end
		2'b11: /* write and read.  */
			begin
				w_ptr_next = w_ptr_succ;
				r_ptr_next = r_ptr_succ;
			end
	endcase
end
	
assign fifo_full = full_reg;
assign fifo_empty = empty_reg;

endmodule
