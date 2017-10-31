function cost_FINAL = SMD_fMAINcon(Xin)

%function MAIN MODEL
%SMD_fMAIN.m
%Created: 3/12/15
%Last Updated: 3/12/15
%Creator: Sera Mirchandani

%Description:
%TO BE USED WITH THE CONSTRAINED GA
%To be run with output from GA so that you can know important values

global Table_MEM n A phi N_auto gamma beta...
    n_th n_pv T_amb C_pg C_pw rho_g rho_w u_th...
    rho_a d_h_a d_h_w mew_a mew_w L_pa L_pw...
    L_paT L_pwT cost_pv cost_th cost_mod cost_cond...
    cost_pex cost_constant ModCondRatio...
    water_req n_hwpump n_blower Pb12 DOD...
    n_acdc n_bcd cost_bat
    

%% Resets Xin to Common Variable Names
%N_mod V_HT Q_hw Q_air Q_cw Q_g A_pv A_th N_cond...

% Number of modules
N_mod = ceil(Xin(1));
% Volume of the hot tank in L
V_HT = 100*ceil(Xin(2));
% Area of the PV cells in m2
A_pv = ceil(Xin(3));
% Area of the Thermal Collectors in m2
A_th = ceil(Xin(4));
% Flow Rate: Hot Water; Must be 0.5,1,2 LPM
Q_hw_index = [0.5,1,2];
Q_hw = Q_hw_index(ceil(Xin(5)));
% Flow Rate: Air
%Must be 20,40,60,80,100,120,140,160,180,200,220,240,260 LPM
%PER MODULE must take into account how many modules when calc
%the power needed for the water pump
Q_air = 20*ceil(Xin(6));
% Flow Rate: Cold water (cooling line) LPM
Q_cw = 50*ceil(Xin(7));
% Flow Rate: Glycol LPM
Q_g = 5*ceil(Xin(8));

% % Number of modules
% N_mod = ceil(Xin(1));
% N_b = ceil(Xin(2));
% % Volume of the hot tank in L
% V_HT = 100*ceil(Xin(3));
% % Area of the PV cells in m2
% A_pv = ceil(Xin(4));
% % Area of the Thermal Collectors in m2
% A_th = ceil(Xin(5));
% % Flow Rate: Hot Water; Must be 0.5,1,2 LPM
% Q_hw_index = [0.5,1,2];
% Q_hw = Q_hw_index(ceil(Xin(6)));
% % Flow Rate: Air
% %Must be 20,40,60,80,100,120,140,160,180,200,220,240,260 LPM
% %PER MODULE must take into account how many modules when calc
% %the power needed for the water pump
% Q_air = 20*ceil(Xin(7));
% % Flow Rate: Cold water (cooling line) LPM
% Q_cw = 50*ceil(Xin(8));
% % Flow Rate: Glycol LPM
% Q_g = 5*ceil(Xin(9));

% Number of condensers based on the number of modules (rounded up)
N_cond = ceil(N_mod/ModCondRatio);

%% Design Calculations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESIGN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pick values for decision variables
%Calculate flow rates
%Calculate electrical demand and battery storage
%Calculate area of membrane

%Calculates the system headloss on the water and air sides
[ Ha_TOT,Hw_TOT ] = SMD_headloss( N_mod, N_cond, rho_w, rho_a, mew_a,...
    mew_w, d_h_a, d_h_w, Q_air, Q_hw, L_pa, L_pw, L_paT, L_pwT );

%Calculates the power needed to deliver the air/water flow rates with above
%headlosses
[ Pw_pump, Pa_pump ] = SMD_pumppower( Ha_TOT,Hw_TOT,Q_air,Q_hw,N_mod,n_hwpump,n_blower);

%Calculates the total power demand of the system
[ P_demand N_b] = SMD_powerdemand( Pw_pump,Pa_pump,N_auto,DOD,n_acdc,n_bcd );
%% Cost Calculations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ cost_TOTAL ] = SMD_COST( Pw_pump, Pa_pump, A_pv, A_th, N_mod,...
    N_cond, cost_mod, cost_cond, cost_pex, L_pa, L_paT, L_pw, L_pwT,...
    cost_constant, cost_pv, cost_th, N_b, cost_bat);

cost_FINAL = cost_TOTAL;
end

