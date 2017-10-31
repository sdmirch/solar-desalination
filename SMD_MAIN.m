%MAIN MODEL
%SMD_MAIN.m
%Created: 1/22/15
%Last Updated: 2/22/15
%Creator: Sera Mirchandani

%Description:
%Main program that calls all external functions
%External functions calculate specific components of the whole system. 
%External functions for component calculations all named SMD_'NAME' 
%External functions for other purposes all named SMD_'name'

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

%% Cost Calculations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ cost_TOTAL ] = SMD_COST( Pw_pump, Pa_pump, A_pv, A_th, N_mod,...
    N_cond, cost_mod, cost_cond, cost_pex, L_pa, L_paT, L_pw, L_pwT,...
    cost_constant, cost_pv, cost_th)

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
    
end

%Water production in Liters
water_prod = sum(n_wtot)/55.6

%% Penalty Function

% change penalty multiplier to be a function of the number of modules
% (scale of the system)
prod_penalty = (10000*N_mod)*(water_req-water_prod)

%penalty fxn that penalized water_prod values that are much further away
%from the water_req
%prod_penalty = (250*N_mod)*(water_req-water_prod)^2;

%% Final Cost

cost_FINAL = cost_TOTAL+prod_penalty

%% Plotting

% 
% %Initializes time vector for plotting only
% time = (300:1:1020);
% 
% %Solar Radiation Plot
% figure(1)
% plot(time,G_cnb(time),'r-', 'linewidth', 1.5);
% hold on
% plot(time,G_cd(time),'b-', 'linewidth', 1.5);
% legend('Normal Beam', 'Diffuse');
% xlabel('Time (min)','FontWeight', 'bold','FontSize',15);
% ylabel('Radiation (W/m2)','FontWeight', 'bold', 'FontSize',15);
% title('Clear Sky Daily Radiation Example','FontWeight', 'bold', 'FontSize',15);
% 
% %Power (electrical and thermal) Plot
% figure(2)
% plot(time,P_th(time),'r-', 'linewidth', 1.5);
% hold on
% plot(time,P_pv(time),'b-', 'linewidth', 1.5);
% legend('Thermal', 'Electrical(PV)');
% xlabel('Time (min)','FontWeight', 'bold','FontSize',15);
% ylabel('Power (W)','FontWeight', 'bold', 'FontSize',15);
% title('Daily Power Example','FontWeight', 'bold', 'FontSize',15);
% 
% %Thermal energy Plot
% figure(3)
% plot(time,E_th(time),'r-', 'linewidth', 1.5);
% hold on
% legend('Thermal Energy');
% xlabel('Time (min)','FontWeight', 'bold','FontSize',15);
% ylabel('Energy (J)','FontWeight', 'bold', 'FontSize',15);
% title('Daily Energy per Minute Example','FontWeight', 'bold', 'FontSize',15);
% 
% %Glycol and Hot Water Temperature Plot
% figure(4)
% plot(time,T_go(time),'r-', 'linewidth', 1.5);
% hold on
% plot(time,T_hwo(time),'b-', 'linewidth', 1.5);
% plot(time,T_hwi(time),'m-', 'linewidth', 1.5);
% legend('Glycol Into Tank','Hot Water Out','Hot Water In');
% xlabel('Time (min)','FontWeight', 'bold','FontSize',15);
% ylabel('Temperature (C)','FontWeight', 'bold', 'FontSize',15);
% title('Daily Fluid Temperature Example','FontWeight', 'bold', 'FontSize',15);
% 
% %Water Produced Plot
% figure(5)
% plot(time,n_w(time),'r-', 'linewidth', 1.5);
% hold on
% plot(time,n_wtot(time),'b-', 'linewidth', 1.5);
% legend('Water Produced Per Module','Total Water Produced');
% xlabel('Time (min)','FontWeight', 'bold','FontSize',15);
% ylabel('Production (mol/min)','FontWeight', 'bold', 'FontSize',15);
% title('Daily Water Produced Example','FontWeight', 'bold', 'FontSize',15);
