function [ C_ineq, C_eq] = SMD_constraint(Xin)
%function MAIN MODEL
%SMD_fMAIN.m
%Created: 3/12/15
%Last Updated: 3/12/15
%Creator: Sera Mirchandani

%Description:
%Water requirement constraint
%TO BE USED WITH THE CONSTRAINED GA
%C_ineq inequality constraints
%C_eq equality constraints


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


%% Performance Calculations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% TIME LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Initializes vectors for sun function 
%calculates actual, clear sky normal beam,
%and clear sky diffuse radiations
G_on = zeros(1,1020);
G_cnb = zeros(1,1020);
G_cd = zeros(1,1020);

%Initializes vectors for power
%thermal and electrical (PV) and electricity
P_th = zeros(1,1020);
P_pv = zeros(1,1020);
E_th = zeros(1,1020);

%Initializes battery power vectors in Watts
P_b = zeros(1,1020);
%Assumes charge at beginning of day
charge = 0.5;
PbTOT = N_b*Pb12;
P_b(300) = charge*PbTOT;

%Initializes vectors for the glycol and hot water temperatures
T_go = zeros(1,1020);
T_go(300) = 60;
T_hwo = zeros(1,1020);
T_hwo(300)= 40;
T_hwi = 25*ones(1,1020); 
T_hwi(300) = 40;

T_gi = T_hwo; %6666666FIX but it is true, it just needs to be moved to a better location (in loop?)

%Initializes vectors for water production
n_w = zeros(1,1020);
n_wtot = zeros(1,1020);

%Minimum beginning of loop is t_st=2
%There are indicies being accessed that are "t_st-1"
for t_st = (300:1:1020)
    %Solar radiation external fxn call
    [ G_on,G_cnb,G_cd,omega,delta ] = SMD_SUN( n,A,phi,t_st,G_on,G_cnb,G_cd);

    %Power (electrical and thermal) external fxn call
    [ P_th,P_pv,E_th ] = SMD_PVTHERM(t_st,G_on,G_cnb,G_cd,n_th,n_pv,A_th,A_pv,gamma,beta,omega,delta,phi,P_th,P_pv,E_th);
    
    %Glycol temperature external fxn call
    [ T_go ] = SMD_GLYCOL( t_st,E_th,T_amb,T_go,T_hwo,A_th,C_pg,rho_g,Q_g,u_th);
    
    %Hot water calculation (hot tank heat balance) external fxn call
    [ T_hwo ] = SMD_HOTTANK( t_st,T_hwo,C_pw,rho_w,V_HT,Q_hw,T_hwi,C_pg,rho_g,Q_g,T_go,T_amb,N_mod);

    %Membrane module permeate PER MODULE production external fxn call
    [ n_w,T_hwi,n_wtot ] = SMD_MEMMOD( t_st,Table_MEM,Q_air,Q_hw,T_hwo,n_w,T_hwi,N_mod,n_wtot);
    
    %Charging and discharging of the batteries
    %[ P_b,n_w,n_wtot ] = SMD_BATTERY( t_st,P_b,DOD,PbTOT,n_w,n_wtot,n_acdc,n_bcd,P_pv,P_demand);
end

%Water production in Liters
water_prod = sum(n_wtot)/55.6;

C_ineq = [water_req - water_prod];

C_eq = [];

end

