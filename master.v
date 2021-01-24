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
module fsm_master(Clock, Reset, ThreeOnly, FirstDataInRdy,
		StartFSM1, StartFSM2, StartFSM3,FirstDataOutRdy);

   input Clock, Reset, ThreeOnly, FirstDataInRdy;
   output StartFSM1, StartFSM2, StartFSM3;
   output FirstDataOutRdy;
   reg StartFSM1, StartFSM2, StartFSM3,FirstDataOutRdy;
   reg [3:0] CurrStateMasterFSM, NextStateMasterFSM;
   parameter ST0=0,  ST1=1,  ST2=2,  ST3=3,  ST4=4,
             ST5=5,  ST6=6,  ST7=7,  ST8=8,  ST9=9,
             ST10=10,ST11=11,ST12=12;

   // -----------
   // MASTER FSM
   // -----------
   always @(FirstDataInRdy or ThreeOnly or CurrStateMasterFSM)
     begin: MASTER_FSM_COMB
       StartFSM1 = 0;
       StartFSM2 = 0;
       StartFSM3 = 0;
       FirstDataOutRdy = 0;
       case (CurrStateMasterFSM)
          ST0  :  if (FirstDataInRdy)
                    begin
                      StartFSM1 = 1;
                      if (ThreeOnly)
                        NextStateMasterFSM = ST7;
                      else 
                        NextStateMasterFSM = ST1;
                    end
                  else 
                    NextStateMasterFSM = ST0;
          ST1  :  NextStateMasterFSM = ST2;
          ST2  :  begin 
                    StartFSM2 = 1;
                    NextStateMasterFSM = ST3;
                  end
          ST3  :  NextStateMasterFSM = ST4;
          ST4  :  NextStateMasterFSM = ST5;
          ST5  :  NextStateMasterFSM = ST6;
          ST6  :  begin
                    StartFSM3 = 1;
                    FirstDataOutRdy = 1;
                    if (FirstDataInRdy)
                      begin
                        StartFSM1 = 1;
                        NextStateMasterFSM = ST1;
                      end
                    else 
                      NextStateMasterFSM = ST0;
                  end
          ST7  :  NextStateMasterFSM = ST8;
          ST8  :  begin
                    StartFSM2 = 1;
                    NextStateMasterFSM = ST9;
                  end
          ST9  :  begin
                    if (FirstDataInRdy)
                      begin
                        StartFSM1 = 1;
                        NextStateMasterFSM = ST10;
                      end 
                    else 
                      NextStateMasterFSM = ST12;
                  end
          ST10 :  begin
                    StartFSM3 = 1;
                    FirstDataOutRdy = 1;
                    NextStateMasterFSM = ST11;
                  end
          ST11 :  begin
                    StartFSM2 = 1;
                    NextStateMasterFSM = ST9;
                  end
          ST12 :  begin
                    StartFSM3 = 1;
                    FirstDataOutRdy = 1;
                    NextStateMasterFSM = ST0;
                  end
          default :  NextStateMasterFSM = ST0;
       endcase
     end

   always @(posedge Clock)
     begin: MASTER_FSM_SEQ
       if (Reset)
         CurrStateMasterFSM = ST0;
       else
         CurrStateMasterFSM = NextStateMasterFSM;
     end
endmodule

