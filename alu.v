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
   file name: alu.v
   description: this parts perform the arithmetic and login funtion 
 	        which is defined by mode select

		a,b: operand data inputs
		cin: carry input
		select: alu function select
		dout: alu result data output
		carry: alu result carry output
		zero: alu result zero output
*/

`timescale 1 ns / 1 ns

module alu(a, b, cin, select, out, carry, zero);
input [7:0] a;
input [7:0] b;
input cin;
input [2:0] select;
output [7:0] out;
output carry;
output zero;
reg [7:0] out;
reg carry;

`define ADD	0
`define SUB	1
`define SUB1	2
`define AND_OP	3
`define OR_OP	4
`define XOR_OP	5
`define XOR1_OP	6

always @(select or a or b or cin)
   begin
      #1 case (select)
         `ADD:     {carry,out} = a + b + cin;
         `SUB:     {carry,out} = a - b - 1 + cin;
         `SUB1:    {carry,out} = b - a - 1 + cin;
         `AND_OP:  {carry,out} = a & b;
         `OR_OP:   {carry,out} = a | b;
         `XOR_OP:  {carry,out} = a ^ b;
         `XOR1_OP: {carry,out} = a ^~ b;
         default:  {carry,out} = 0;
      endcase
   end
 assign zero = (out==0) ? 1 : 0;
endmodule
