// ************************************************************************
// *  SYNOPSYS CONFIDENTIAL PROPRIETARY NOTE                              *
// *                                                                      *
// *  This software contains information confidential and proprietary     *
// *  to Synopsys, Inc. It shall not be reproduced in whole               *
// *  or in part or transferred to other documents, or disclosed          *
// *  to third parties, or used for any purpose other than that           *
// *  for which it was obtained, without the prior written consent        *
// *  of Synopsys, Inc.                                                   *
// *  Copyright (c) 2012-2013 Synopsys, Inc.                              *
// *  All rights reserved                                                 *
// *                                                                      *
// ************************************************************************

/* Synopsys tutorial case: A simplified microprogramming-based CPU
   file name: PCU.v
   description: this part provides external memory read/write operations
 	        to perform macro-program sequence

		CL: timing control (from CCU,7-bits)
		ALU: ALU output data (from ALU)
		S1: program counter control (from ALU)
		IXR: index register (from ALU)
		reset: system reset
		data: 8-bits data bus
		PC: program counter (to ALU)
		IDB: internal data bus (to ALU)
		TDB: tri-state data buffer (to CCU)
*/


`timescale 1 ns / 1 ns


module PCU (mux_sel, C6, C5, C1, ALU, S1, IXR, reset, data, PC, 
		IDB, TDB, error_in);
    input error_in;
    input [2:0] mux_sel;
    input C6, C5, C1;
    input [7:0] ALU;
    input S1;
    input [7:0] IXR;
    input reset;
    inout [7:0] data;
    output [7:0] PC;
    output [7:0] IDB;
    output [7:0] TDB;

reg [7:0] PC; 
reg [7:0] IDR, IDB; 
reg [7:0] TR;
wire [7:0] TDB0; 
reg [7:0] TDB; 
wire error_reset;

assign #1 error_reset = reset & error_in;

// data bus I/O

assign TDB0 = (C1 == 0) ? IDB : TDB;

always @(negedge C5 or negedge reset) begin
	if (~reset) IDR = 8'h00;
	else IDR = TDB0;
end
assign data = (~C1) ? IDR : 8'bzzzzzzzz;

always @(negedge S1 or negedge reset) begin
	if (~reset) PC = 8'h00;
	else PC = ALU;
end

// Temporary Register
always @(negedge C6 or negedge reset)
begin
	if (~reset) TR = 8'h00;
	else TR = ALU;
end

// 8-to-1 multiplexer for IDB
always @(IDR or mux_sel or PC or TR or ALU or IXR)
	case (mux_sel)
		0:	IDB = IDR;
		1:	IDB = PC;
		2:	IDB = TR;
		3:	IDB = ALU;
		4:	IDB = IXR;
	  default:	IDB = 8'h00;
	endcase

always @(data or C1 or error_reset)
	if (error_reset)
		TDB = 8'h00;
	else if (C1) TDB = data;

endmodule
