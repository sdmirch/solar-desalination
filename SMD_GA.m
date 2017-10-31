%SMD_GA.m
%Created: 1/30/15
%Last Updated: 2/23/15
%Creator: Sera Mirchandani

%Description:
%Main genetic algorithm call
%Objective function calculations in SMD_MAIN


global Table_MEM n A phi N_auto gamma beta...
    n_th n_pv T_amb C_pg C_pw rho_g rho_w u_th...
    rho_a d_h_a d_h_w mew_a mew_w L_pa L_pw...
    L_paT L_pwT cost_pv cost_th cost_mod cost_cond...
    cost_pex cost_constant ModCondRatio...
    water_req n_hwpump n_blower Pb12 DOD...
    n_acdc n_bcd cost_bat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read in User Inputs GLOBAL VARIABLES

%Loads location and user variables
SMD_initial;
load SMD_init.mat;

%Loads tables
SMD_tableload;
load SMD_tables.mat;

%Loads fixed prices
SMD_prices;
load SMD_prices.mat;

%% Water Req

%Water requirement for the system in Liters
water_req = 90;

%% SETUP GA WITH BATTERIES AS A DECISION VARIABLE (9)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% GA, NVARS= 9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %[X,FVAL] = ga(FITNESSFCN,NVARS,A,b,Aeq,beq,lb,ub,NONLCON,options) 
% % N_mod N_b V_HT A_pv A_th Q_hw Q_air Q_cw Q_g
% %NVARS is number of decision variables, lb is lower bounds, ub is upper bounds
% NVARS = 9;
% lb = [0.001 0.001 0.001 0.001 0.001 0.001 0.001 0.001 0.001];
% ub = [40 20 30 50 50 3 13 8 10];
% 
% %Set a starting point for the GA
% X0 = [12 10 20 10 25 2.5 7 4 2]; % Start point (row vector)
% options = gaoptimset('InitialPopulation',X0);

%% SETUP GA WITHOUT BATTERIES AS A DECISION VARIABLE (8)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% GA, NVARS= 8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[X,FVAL] = ga(FITNESSFCN,NVARS,A,b,Aeq,beq,lb,ub,NONLCON,options) 
% N_mod V_HT A_pv A_th Q_hw Q_air Q_cw Q_g
%NVARS is number of decision variables, lb is lower bounds, ub is upper bounds
NVARS = 8;
lb = [0.001 0.001 0.001 0.001 0.001 0.001 0.001 0.001];
ub = [40 30 50 50 3 13 8 10];

%Changes the mutation function from the default: MUTATIONGAUSSIAN
%options = gaoptimset('MutationFcn',@mutationadaptfeasible);

%Set a starting point for the GA
X0 = [12 20 10 25 2.5 7 4 2]; % Start point (row vector)
options = gaoptimset('InitialPopulation',X0);
%options = gaoptimset(options,'InitialPopulation',X0);

%% RUN GA

%SMD_fMAIN is function handle to model that calcs design and water prod.
[X,FVAL] = ga(@SMD_fMAIN,NVARS,[],[],[],[],lb,ub)
%then you will run your genetic algorithm form here that calls the fitness 
%function which will be smd main