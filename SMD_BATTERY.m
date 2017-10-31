function [ P_b,n_w,n_wtot ] = SMD_BATTERY( t_st,P_b,DOD,PbTOT,n_w,n_wtot,n_acdc,n_bcd,P_pv,P_demand)
%SMD_BATTERY.m
%Created: 3/10/15
%Last Updated: 3/10/15
%Creator: Sera Mirchandani

%Description:
%Calculates the charge/discharge of the batteries in Watts.
%Takes into account Depth of Discharge (DOD)
%Assumes linear charging and discharging rate, 100% charge for startup, and
%equal loading on all of the batteries.
%Does not take into account capacity degredation over lifetime


    %CHARGE, when below 100%, excess PV for charge (charging is slower when
    %batteries are closer to full)
if (P_pv(t_st)*n_acdc)>P_demand && P_b(t_st)<PbTOT
    P_b(t_st+1) = P_b(t_st) + (((PbTOT-P_b(t_st))/PbTOT)^2)*(((P_pv(t_st)*n_acdc)-P_demand)*(n_acdc*n_bcd));

    %NO CHARGE, when batteries are at 100%, excess PV does nothing  
elseif (P_pv(t_st)*n_acdc)>P_demand && P_b(t_st)>=PbTOT
    P_b(t_st+1) = P_b(t_st);
    
    %DISCHARGE, when above DOD, use batteries for what PV cannot provide
elseif (P_pv(t_st)*n_acdc)<=P_demand && P_b(t_st)>=((1-DOD)*PbTOT)
    P_b(t_st+1) = P_b(t_st) + (((P_pv(t_st)*n_acdc)-P_demand)/(n_acdc*n_bcd));
    
    %NO DISCHARGE, when below DOD, STOP system & no water
elseif (P_pv(t_st)*n_acdc)<=P_demand && P_b(t_st)<((1-DOD)*PbTOT)
    P_b(t_st+1) = P_b(t_st);
    n_wtot(t_st) = 0;
    n_w(t_st) = 0;
end


end

