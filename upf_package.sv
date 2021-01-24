`define MAX_ARCH_STRLEN 100

function supply_on;
  //input string pad_name;
  input [8*`MAX_ARCH_STRLEN : 1] pad_name;
  input real value;
  //Novas insert begin
  string label,message,stream_name,state_s, value_s;
  int severity = 0;
  //Novas insert end
begin
  supply_on = $mvsim_supply_on(pad_name, value);
  //Novas insert begin
  $sformat(value_s,"%f",value);
  $sformat(state_s,"on");
  $sformat(stream_name,"%s",pad_name);
  $fsdbLog(label,message,severity,stream_name, state_s, value_s);
  //Novas insert end
end
endfunction

function supply_off;
  //input string pad_name;
  input [8*`MAX_ARCH_STRLEN : 1] pad_name;
  //Novas insert begin
  string label,message,stream_name,state_s, value_s;
  int severity = 0;
  //Novas insert end
begin
  supply_off = $mvsim_supply_off(pad_name);
  //Novas insert begin
  $sformat(value_s,"%f",0.0);
  $sformat(state_s,"%s", "off");
  $sformat(stream_name,"%s",pad_name);
  $fsdbLog(label,message,severity,stream_name, state_s, value_s);
  //Novas insert end
end
endfunction

function supply_partial_on;
  //input string pad_name;
  input [8*`MAX_ARCH_STRLEN : 1] pad_name;
  input real value;
  //Novas insert begin
  string label,message,stream_name,state_s,value_s;
  int severity = 0;
  //Novas insert end
begin
  supply_partial_on = $mvsim_supply_partial_on(pad_name, value);
  //Novas insert begin
  $sformat(value_s,"%f",value);
  $sformat(state_s,"%s", "partial_on");
  $sformat(stream_name,"%s",pad_name);
  $fsdbLog(label,message,severity,stream_name, state_s, value_s);
  //Novas insert end
end
endfunction
