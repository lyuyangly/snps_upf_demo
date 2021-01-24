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
   file name: ALUB.v
   description: this part performs the arithmetic and logic funtion
                on the operands of internal data bus(IDB)

                IR: instruction register (from CCU)
                IDB: internal data bus (from PCU)
                PC: program counter (from PCU)
                C: timing control (from CCU,12-bits)
                clock: system clock
                reset: system reset
                S1: program counter control (to PCU)
                ALU: ALU output data (to PCU)
                IXR: index register (to PCU)
*/

`timescale 1 ns / 1 ns

module ALUB(IR, IDB, PC, CH, alu_mode, bus_mode, carry_mode, clock, reset, 
		S1, ALU, IXR, error_out);
input [1:0] IR;
input [7:0] IDB;
input [7:0] PC;
input [4:0] CH;
input [2:0] alu_mode;
input [2:0] bus_mode;
input carry_mode;
input clock;
input reset;
output S1;
output [7:0] ALU;
output [7:0] IXR;
output error_out;

reg [7:0] IXR;
reg [7:0] IXR_tmp;
reg [7:0] ACC_tmp;
reg [7:0] ACC;
reg zero_flag;
reg carry_flag;

reg [7:0] X0, Y0;
wire net_1, net_2, net_3;
wire carry;
wire zero;
wire T4, T2, T3;

and (T4, clock, CH[4]);
and (T3, clock, CH[3]);
and (T2, clock, CH[2]);


assign net_2 = (ALU == 8'h30) & (~CH[1]);
assign net_3 = S1 & (~IR[0]);
assign error_out = net_2 & net_3
			& (~carry_flag) & zero_flag & net_1;

alu i_alu (.a(X0) , .b(Y0) , .cin(carry_mode) , .select(alu_mode)
        , .out(ALU) , .carry(carry) , .zero(zero));

always @(bus_mode or IXR_tmp or ACC_tmp or PC or IDB )
        case (bus_mode)
                0:      X0 = IXR_tmp;
                1:      X0 = ACC_tmp;
                2:      X0 = PC;
                3:      X0 = ACC_tmp;
          default:      X0 = IDB;
        endcase

always @(bus_mode or IXR_tmp or ACC_tmp or PC )
        case (bus_mode)
                0:      Y0 = 8'h00;
                1:      Y0 = PC;
                2:      Y0 = 8'h00;
                3:      Y0 = 8'h00;
                4:      Y0 = PC;
                5:      Y0 = IXR_tmp;
                6:      Y0 = ACC_tmp;
          default:      Y0 = 8'h00;
        endcase

assign net_1 = (IR[0] == 0) ? zero_flag : carry_flag;
assign S1 = ~CH[0] | (~CH[1] & (IR[1] ^ net_1));

always @(negedge clock or negedge reset)
 begin
        if (!reset) IXR_tmp = 8'h00;
        else IXR_tmp = IXR;
 end

always @(negedge clock or negedge reset)
 begin
        if (!reset) ACC_tmp = 8'h00;
        else ACC_tmp = ACC;
 end

always @(posedge T3 or negedge reset)
 begin
        if (!reset) IXR <= 8'h00;
        else IXR <= ALU;
 end

always @(posedge T4 or negedge reset)
 begin
        if (!reset) ACC = 8'h00;
        else ACC = ALU;
 end

always @(posedge T2 or negedge reset)
 begin
        if (!reset) carry_flag = 1'b0;
        else carry_flag = carry;
 end

always @(posedge T2 or negedge reset)
 begin
        if (!reset) zero_flag = 1'b0;
        else zero_flag = zero;
 end

endmodule
