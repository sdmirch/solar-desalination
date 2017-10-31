function [ T_go ] = SMD_GLYCOL( t_st,E_th,T_amb,T_go,T_hwo,A_th,C_pg,rho_g,Q_g,u_th)

%SMD_GLYCOL.m
%Created: 1/26/15
%Last Updated: 1/26/15
%Creator: Sera Mirchandani

%Description:
%Calculates the glycol temperature for the next timestep
%6666666 FIX actual balance

%T_go(t_st+1)=((T_amb(t_st)*u_th*A_th)-E_th(t_st)-(C_pg*rho_g*Q_g*T_hwo(t_st)))/...
   % ((u_th*A_th)-(C_pg*rho_g*Q_g));
T_go(t_st+1)=(E_th(t_st)+(C_pg*rho_g*Q_g*T_hwo(t_st)))/...
    ((C_pg*rho_g*Q_g));
end

