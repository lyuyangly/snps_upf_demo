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
   file name: CCU.v
   description: this part generates the timing control signals to 
		the rest parts of process under the controlof OpCode 
		of macroinstruction and predefined microinstsruction.

		TDB: tri-state data buffer (from PCU)
		clock: system clock
		reset: system reset
		CH: timing control (higher 14 bits to ALU)
		CL: timing control (lower 7 bits to PCU)
		IR: instruction register (to ALU)
*/

`timescale 1 ns / 1 ns

module CCU(TDB, clock, reset, CH, alu_mode, bus_mode, carry_mode, mux_sel,
	C6, C5, C1, C0, IR);
input [7:0] TDB;
input clock;
input reset;
output [4:0] CH;
output [2:0] alu_mode;
output [2:0] bus_mode;
output carry_mode;
output [2:0] mux_sel;
output C6, C5, C1, C0;
output [1:0] IR;

reg [2:0] mux_sel;
reg C6, C5, C1, C0;
reg [4:0] CH;
reg [2:0] alu_mode;
reg [2:0] bus_mode;
reg carry_mode;
reg [1:0] IR;
reg [5:0] IR7_IR2; 
wire [1:0] C21_C20;
wire [7:0] MAP;
wire [7:0] n_MA;
reg [7:0] MA;
reg [7:0] next_MA;
wire n_C20;
wire n_C21;
wire [21:0] mprom_out;
reg C21;
reg C20;
reg C19;

wire MA_carry;


// Instruction Register
 always @(negedge C19 or negedge reset)
 begin
	if (~reset)
		{IR7_IR2, IR} = 0;
	else begin
		{IR7_IR2, IR} = TDB;
	end
 end

// mapping rom
 maprom i_maprom (.addr(IR7_IR2)
	, .dout(MAP)
	, .addr_error());

// next address data selector
 and (n_C20, reset, C20) ;
 and (n_C21, reset, C21) ;
 always @(n_C21 or n_C20 or MAP or next_MA)
	case ({n_C21, n_C20})
		0:	MA = 8'h00;
		1:	MA = MAP;
		2:	MA = 8'h00;
	  default:	MA = next_MA;
	endcase

// Incrementor for memory address
 always @(negedge clock or negedge reset)
 begin
	if (~reset)
		next_MA = 0;
	else begin
		next_MA = MA + 1'b1;
	end
 end

// microprogram rom
 mprom i_mprom (.addr(MA)
	, .dout(mprom_out)
	, .addr_error());

// timing control register
 always @(negedge clock or negedge reset)
 begin
	if (~reset) begin
		{C21, C20, C19, carry_mode, bus_mode, 
		alu_mode, CH, C6, C5, mux_sel, C1, C0} = 22'h000000;
	end
	else begin
		C21 = mprom_out[21];
		C20 = mprom_out[20];
		C19 = mprom_out[19];
		carry_mode = mprom_out[18];
		bus_mode = mprom_out[17:15];
		alu_mode = mprom_out[14:12];
		CH = ~mprom_out[11:7];
		C6 = mprom_out[6];
		C5 = mprom_out[5];
		mux_sel = mprom_out[4:2];
		C1 = mprom_out[1];
		C0 = mprom_out[0];
	end
 end

endmodule
