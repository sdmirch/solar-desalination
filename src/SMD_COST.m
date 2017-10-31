function [ cost_TOTAL ] = SMD_COST( Pw_pump, Pa_pump, A_pv, A_th, N_mod,...
    N_cond, cost_mod, cost_cond, cost_pex, L_pa, L_paT, L_pw, L_pwT,...
    cost_constant, cost_pv, cost_th, N_b, cost_bat)

%SMD_COST.m
%Created: 2/15/15
%Last Updated: 2/23/15
%Creator: Sera Mirchandani

%Description:
%Calculates cost after GA picks decision variables

%Price of the pumps
cost_hwpump = 3181.5*(Pw_pump/1000)^0.4178;
cost_blower = 675.35*(Pa_pump/1000)^0.5135;

cost_solar = A_pv*cost_pv + A_th*cost_th;
cost_components = N_mod*cost_mod + N_cond*cost_cond + N_b*cost_bat;
cost_pipe = (cost_pex*((N_mod*L_pa)+L_paT))+(cost_pex*((N_mod*L_pw)+L_pwT));


cost_TOTAL = cost_hwpump+cost_blower+cost_solar+cost_components+...
    cost_pipe + cost_constant;
end

