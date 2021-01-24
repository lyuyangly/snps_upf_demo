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
module fsm_child2(Clock, Reset, ThreeOnly,StartFSM2,
		 Mux1_Sel, Mux2_Sel,
                 En_AB,En_AC,En_AD,En_BC,En_BD,En_CD);

             input Clock,Reset,ThreeOnly,StartFSM2;
	     output [1:0] Mux1_Sel, Mux2_Sel;
	     output En_AB,En_AC,En_AD,En_BC,En_BD,En_CD;
	     reg [1:0] Mux1_Sel, Mux2_Sel;
	     reg En_AB,En_AC,En_AD,En_BC,En_BD,En_CD;

   parameter Zero=0,  One=1,  Two=2,       // FSM2
             Three=3, Four=4, Five=5;
   

   reg [2:0] CurrStateFSM2, NextStateFSM2;
   //------
   // FSM2
   //------
   always @(StartFSM2 or ThreeOnly or CurrStateFSM2)
     begin: FSM2_COMB
       Mux1_Sel = 0;
       Mux2_Sel = 0;
       En_AB = 0;
       En_AC = 0;
       En_AD = 0;
       En_BC = 0;
       En_BD = 0;
       En_CD = 0;
       case (CurrStateFSM2)
          Zero  :  begin
                     Mux1_Sel = 0;
                     Mux2_Sel = 0;
                     if (StartFSM2)
                       begin
                         NextStateFSM2 = One;
                         En_AB = 1;
                       end
                     else 
                       NextStateFSM2 = Zero;
                   end
          One   :  begin
                     Mux1_Sel = 0;
                     Mux2_Sel = 1;
                     En_AC = 1;
                     if (ThreeOnly)
                       NextStateFSM2 = Three;
                     else
                       NextStateFSM2 = Two;
                   end
          Two   :  begin
                     Mux1_Sel = 0;
                     Mux2_Sel = 2;
                     En_AD = 1;
                     NextStateFSM2 = Three;
                   end
          Three :  begin
                     Mux1_Sel = 1;
                     Mux2_Sel = 1;
                     En_BC = 1;
                     if (ThreeOnly)
                       NextStateFSM2 = Zero;
                     else
                       NextStateFSM2 = Four;
                   end
          Four  :  begin
                     Mux1_Sel = 1;
                     Mux2_Sel = 2;
                     En_BD = 1;
                     NextStateFSM2 = Five;
                   end
          Five  :  begin
                     Mux1_Sel = 2;
                     Mux2_Sel = 2;
                     En_CD = 1;
                     NextStateFSM2 = Zero;
                   end
          default :  NextStateFSM2 = Zero;
       endcase
     end
     always @(posedge Clock)
     begin: FSM2_SEQ
       if (Reset)
         CurrStateFSM2 = Zero;
       else
         CurrStateFSM2 = NextStateFSM2;
     end

endmodule
