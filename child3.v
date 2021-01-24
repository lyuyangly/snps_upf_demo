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

`timescale 1 ns / 1ns
module fsm_child3(Clock, Reset, ThreeOnly,StartFSM3,Mux3_Sel);

   reg [1:0] CurrStateFSM3, NextStateFSM3;
   input Clock, Reset, ThreeOnly,StartFSM3;
   output [1:0] Mux3_Sel;
   reg [1:0] Mux3_Sel;

   parameter ST_Sum1=0, ST_Sum2=1,         // FSM3
             ST_Sum3=2, ST_NoSum=3;


   //------
   // FSM3
   //------
   always @(StartFSM3 or ThreeOnly or CurrStateFSM3)
     begin: FSM3_COMB
       Mux3_Sel = 0;
       case (CurrStateFSM3)
          ST_Sum1  :  begin
                        Mux3_Sel = 0;
                        if (StartFSM3)
                          if (ThreeOnly)
                            NextStateFSM3 = ST_NoSum;
                          else 
                            NextStateFSM3 = ST_Sum2;
                        else 
                          NextStateFSM3 = ST_Sum1;
                     end
          ST_Sum2  :  begin
                        Mux3_Sel = 1;
                        NextStateFSM3 = ST_Sum3;
                      end
          ST_Sum3  :  begin
                        Mux3_Sel = 2;
                        NextStateFSM3 = ST_Sum1;
                      end
          ST_NoSum :  begin
                        Mux3_Sel = 3;
                        NextStateFSM3 = ST_Sum1;
                      end
          default  :  NextStateFSM3 = ST_Sum1;
       endcase
     end

   always @(posedge Clock)
     begin: FSM3_SEQ
       if (Reset)
         CurrStateFSM3 = ST_Sum1;
       else
         CurrStateFSM3 = NextStateFSM3;
     end
endmodule
