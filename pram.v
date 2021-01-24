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
   file name: pram.v
   description: This part modelize the program memory for the system operation

		clock: system clock
		VMA: valid memory address where read/write can be performed
		R_W: memory read or memory write
		addr: 8-bits address bus
		data: 8-bits data bus
*/

module pram(clock,VMA,R_W,addr,data);
input clock;
input VMA;
input R_W;
input [7:0] addr;
inout [7:0] data;

reg [7:0] macroram [255:0];
reg [7:0] dataout;

assign data = R_W ? dataout : 8'hz;

always @(posedge (clock & VMA))
begin
	//$fsdbDumpMem(macroram, 0, 256);
	if (R_W == 1) dataout=macroram[addr];
	else macroram[addr]=data;
end
initial
   begin
        $readmemb("./memory/pram.dat",macroram);
    end
endmodule
