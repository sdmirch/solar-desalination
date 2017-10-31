function [ T_hwo ] = SMD_HOTTANK( t_st,T_hwo,C_pw,rho_w,V_HT,Q_hw,T_hwi,C_pg,rho_g,Q_g,T_go,T_amb,N_mod)

%SMD_HOTTANK.m
%Created: 1/26/15
%Last Updated: 1/27/15
%Creator: Sera Mirchandani

%Description:
%Calculates the hot water temperature for the next time step


%heat transfer coefficient tank for now
%6666666 FIX
u_tank = 0;
A_tank = 2.5;

%666666 FIX can't deal with this right now. do it later
% INCLUDE MAKE UP WATER TERM next time... need permeate balance?
%added 0.25 degrees to mess with it. fix this
T_hwo(t_st+1) = T_hwo(t_st)+(1/(C_pw*rho_w*V_HT))*...
    ((rho_w*C_pw*Q_hw*N_mod*(T_hwi(t_st)-T_hwo(t_st)))+...
    C_pg*rho_g*Q_g*(T_go(t_st)-T_hwo(t_st-1))-...
    u_tank*A_tank*(T_hwo(t_st)-T_amb(t_st)));
end
