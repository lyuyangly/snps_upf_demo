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
   file name: TopModule.v
   description: This part describes the top module of CPU including
		CCU, PCU, ALU three block and their connectivity.

		clock: system clock
		reset: system reset
		VMA: valid memory address where read/write can be performed
		R_W: memory read or memory write
		data: 8-bits data bus
		addr: 8-bits address bus
*/

`timescale 1 ns / 1 ns

module CPU(clock, reset, VMA, R_W, data, addr);
input clock;
input reset;
output VMA;
output R_W;
inout [7:0] data;
output [7:0] addr;

wire [4:0] CH;
wire [2:0] alu_mode;
wire [2:0] bus_mode;
wire carry_mode;
wire S1;
wire [7:0] ALU;
wire [7:0] IXR; 
wire [7:0] IDB;
wire [7:0] PC;
wire [1:0] IR;
wire [7:0] TDB;
wire C0, C1, C5, C6;
wire [2:0] mux_sel;


assign addr = IDB;
assign VMA = C0;
assign R_W = C1;

// Program Control Unit block
 PCU i_PCU (.S1(S1)
	, .ALU(ALU)
	, .IXR(IXR)
	, .reset(reset)
	, .data(data)
	, .mux_sel(mux_sel)
	, .C6(C6)
	, .C5(C5)
	, .C1(C1)
	, .PC(PC)
	, .error_in(error)
	, .IDB(IDB)
	, .TDB(TDB));

// Arithmatic and Logic Unit block
 ALUB i_ALUB (.IR(IR)
	, .IDB(IDB)
	, .PC(PC)
	, .CH(CH)
	, .alu_mode(alu_mode)
	, .bus_mode(bus_mode)
	, .carry_mode(carry_mode)
	, .clock(clock)
	, .error_out(error)
	, .reset(reset)
	, .S1(S1)
	, .ALU(ALU)
	, .IXR(IXR));

// Computer Control Unit block
 CCU i_CCU (.TDB(TDB)
	, .clock(clock)
	, .reset(reset)
	, .CH(CH)
	, .alu_mode(alu_mode)
	, .bus_mode(bus_mode)
	, .carry_mode(carry_mode)
	, .mux_sel(mux_sel)
	, .C6(C6)
	, .C5(C5)
	, .C1(C1)
	, .C0(C0)
	, .IR(IR));

endmodule
