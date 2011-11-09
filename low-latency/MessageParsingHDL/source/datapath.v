`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:35 06/04/2011 
// Design Name: 
// Module Name:    datapath 
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
module datapath
  #(
    parameter	WordWidth = 64,
    LogWidth	 = 3
    )
   (
    input wire datapath_clk, datapath_reset,
    /* Signals towards block2.  */
    input wire [WordWidth - 1:0] datapath_data,
    output wire 		 datapath_finished,
    /* Signals towards TopModule.  */
    output wire 		 datapath_Valid,
    output wire 		 datapath_Start_Msg,
    output wire 		 datapath_End_Msg,
    output wire [LogWidth - 1:0] datapath_Mod,
    output wire [WordWidth - 1:0] datapath_Msg
    );
   
   localparam[1:0]	decode		= 2'b00,
     decode2		= 2'b01,
     getdata		= 2'b11;
   
   reg [WordWidth - 1:0] 	  temp;
   reg [WordWidth - 1:0] 	  old;
   reg [15:0] 			  length;
   reg [7:0] 			  type;
   reg [3:0] 			  bytes_left;
   
   /* State regs.  */
   reg [1:0] 			  state_reg;
   
   /* Output regs.  */
   reg 				  finished_reg, valid_reg, start_msg_reg, end_msg_reg;
   reg [LogWidth - 1:0] 	  mod_reg;
   reg [WordWidth - 1:0] 	  data_reg;
   
   always @(posedge datapath_clk, posedge datapath_reset) begin
      if (datapath_reset) begin
	 finished_reg <= 0;
	 valid_reg <= 0;
	 start_msg_reg <= 0;
	 end_msg_reg <= 0;
	 mod_reg <= 0;
	 data_reg = 0;
	 bytes_left = 0;	 
	 length = 0;
	 temp = 0;	 
	 old = 0;
	 state_reg <= decode;
      end else begin
	 case (state_reg)
	   decode:
	     begin
		finished_reg <= 1;
		if (datapath_data != old) begin
		   bytes_left = 8;
		   temp = datapath_data;
		   old = datapath_data;
		   
		   length = temp[63:48];
		   if (length != 0) begin
		      type = temp[47:40];
		      temp = temp << 24;
		      length = length - 3;
		      bytes_left = bytes_left - 3;
		      
		      valid_reg <= 1;
		      start_msg_reg <= 1;
		      end_msg_reg <= 1;		      
		      mod_reg <= length;
		      
		      case (length)
			16'h0001:
			  begin
			     data_reg <= { temp[63:56], 56'h00000000000000 };
			     temp = temp << 8;
			     bytes_left = bytes_left - 1;
			     if (bytes_left != 0) begin
				finished_reg <= 0;
				state_reg <= decode2;
			     end
			  end
			16'h0002:
			  begin
			     data_reg <= { temp[63:48], 48'h00000000000000 };
			     temp = temp << 16;
			     bytes_left = bytes_left - 2;
			     if (bytes_left > 2) begin
				finished_reg <= 0;
				state_reg <= decode2;
			     end
			  end
			16'h0003:
			  begin
			     data_reg <= { temp[63:40], 40'h00000000000000 };
			  end
			16'h0004:
			  begin
			     data_reg <= { temp[63:32], 32'h00000000000000 };
			  end
			16'h0005:
			  begin
			     data_reg <= { temp[63:24], 24'h00000000000000 };
			  end
			16'h0006:
			  begin
			     data_reg <= { temp[63:16], 16'h00000000000000 };
			  end
			16'h0007:
			  begin
			     data_reg <= { temp[63:8], 8'h00000000000000 };
			  end
			default:
			  begin
			     length = length - bytes_left;
			     mod_reg <= bytes_left;
			     data_reg <= temp;
			     end_msg_reg <= 0;
			     state_reg <= getdata;
			  end
		      endcase
		   end else begin
		      valid_reg <= 0;
		      start_msg_reg <= 0;
		      end_msg_reg <= 0;
		   end
		end else begin
		   valid_reg <= 0;
		   start_msg_reg <= 0;
		   end_msg_reg <= 0;
		   mod_reg <= 0;
		   data_reg <= 0;
		end
	     end
	   decode2:
	     begin
		state_reg <= decode;
		finished_reg <= 1;
		length = temp[63:48];
		if (length != 0) begin				
		   type = temp[47:40];
		   temp = temp << 24;
		   length = length - 3;
		   bytes_left = bytes_left - 3;
		   if (bytes_left != 0) begin
		      length = length - 1;
		      bytes_left = bytes_left - 1;
		      
		      valid_reg <= 1;
		      start_msg_reg <= 1;
		      data_reg <= { temp[63:56], 56'h00000000000000 };
		      mod_reg <= 1; /* This is the only possible case.  */
		   end
		   if (length > bytes_left) begin
		      end_msg_reg <= 0;
		      state_reg <= getdata;
		   end else
		     end_msg_reg <= 1;
		end else begin
		   valid_reg <= 0;
		   start_msg_reg <= 0;
		   end_msg_reg <= 0;
		end
	     end
	   getdata:
	     begin
		if (datapath_data != old) begin
		   temp = datapath_data;
		   old = datapath_data;
		   bytes_left = 8;

		   finished_reg <= 1;
		   mod_reg <= length;
		   start_msg_reg <= 0;
		   valid_reg <= 1;
		   end_msg_reg <= 1;
		   state_reg <= decode;
		   
		   case (length)
		     16'h0001:
		       begin
			  bytes_left = bytes_left - 1;
			  data_reg <= { temp[63:56], 56'h00000000000000 };
			  if (bytes_left > 2) begin
			     finished_reg <= 0;
			     state_reg <= decode2;
			  end	
		       end
		     16'h0002:
		       begin
			  bytes_left = bytes_left - 2;
			  data_reg <= { temp[63:48], 48'h00000000000000 };
			  if (bytes_left > 2) begin
			     finished_reg <= 0;
			     state_reg <= decode2;
			  end
		       end
		     16'h0003:
		       data_reg <= { temp[63:40], 40'h00000000000000 };
		     16'h0004:
		       data_reg <= { temp[63:32], 32'h00000000000000 };
		     16'h0005:
		       data_reg <= { temp[63:24], 24'h00000000000000 };
		     16'h0006:
		       data_reg <= { temp[63:16], 16'h00000000000000 };
		     16'h0007:
		       data_reg <= { temp[63:8], 8'h00000000000000 };
		     default:
		       begin
			  length = length - bytes_left;
			  bytes_left = 0;

			  mod_reg <= 0;
			  data_reg <= temp;
			  valid_reg <= 1;
			  end_msg_reg <= 0;
			  state_reg <= getdata;
		       end
		   endcase
		   if (length < 8)
		     temp = temp << (length << 3);
		   if (bytes_left != 0) begin
		      state_reg <= decode2;
		   end
		end else begin
		   valid_reg <= 0;
		   start_msg_reg <= 0;
		   end_msg_reg <= 0;
		end
	     end
	 endcase
      end
   end
   
   assign datapath_finished = finished_reg;
   assign datapath_Valid = valid_reg;
   assign datapath_Start_Msg = start_msg_reg;
   assign datapath_End_Msg = end_msg_reg;
   assign datapath_Mod = mod_reg;
   assign datapath_Msg = data_reg;
   
endmodule
