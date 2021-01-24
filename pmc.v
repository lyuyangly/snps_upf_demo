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

module pmc();

import UPF::*;

//`include "upf_package.sv"

reg [5:0] PowerControl;
reg ALUB_iso, PCU_iso;


initial
begin
       ALUB_iso = 0;PCU_iso = 0;
#950   ALUB_iso = 1;PCU_iso = 1;   //TURN ON ISOLATION ALUB & PCU
#400   ALUB_iso = 0;PCU_iso = 0;
#1600  ALUB_iso = 1;               //TURN ON ISOLATION ALUB
#400   ALUB_iso = 0;PCU_iso = 0;
#3000  PCU_iso  = 1;               //TURN ON ISOLATION PCU
#400   PCU_iso  = 0;
end


initial
begin
       PowerControl = 6'b111111;
#1000  PowerControl = 6'b111101;  //TURN OFF DOMAIN PD_CPU
#300   PowerControl = 6'b111111;  //TURN ON  DOMAIN PD_CPU
#1700  PowerControl = 6'b111011;  //TURN OFF DOMAIN PD_ALUB
#300   PowerControl = 6'b111111;  //TURN ON  DOMAIN PD_ALUB
#2000  PowerControl = 6'b110111;  //TURN OFF DOMAIN PD_CCU
#300   PowerControl = 6'b111111;  //TURN ON  DOMAIN PD_CCU
#1700  PowerControl = 6'b101111;  //TURN OFF DOMAIN PD_PCU
#300   PowerControl = 6'b111111;  //TURN ON  DOMAIN PD_PCU
end

//initial
//begin
//       supply_on("VDD", 1.08);supply_on("VSS", 0);
//#4000  supply_on("VDD", 0.8); supply_on("VSS", 0);
//#4000  supply_on("VDD", 1.08);supply_on("VSS", 0);
//end

endmodule
