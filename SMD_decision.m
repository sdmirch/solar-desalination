function [  ] = SMD_decision(ModCondRatio)

%SMD_decision.m
%Created: 1/22/15
%Last Updated: 2/23/15
%Creator: Sera Mirchandani

%Description:
%All decision variables inputted by user or GA??
%Used in SMD_MAIN

%% Decision Variables

% Number of modules
N_mod = 8;

% Number of condensers based on the number of modules (rounded up)
N_cond = ceil(N_mod/ModCondRatio);

% Number of 12 V batteries in the battery storage system
N_b = 0;

% Volume of the hot tank in L
V_HT = 1500;

% Flow rates of hot water, air, cold water, and glycols in L/min

%Must be 0.5,1,2 L/min
Q_hw = 2;

%Must be 20,40,60,80,100,120,140,160,180,200,220,240,260 L/min
%PER MODULE must take into account how many modules when calc
%the power needed for the water pump
Q_air = 100;

Q_cw = 200;

Q_g = 10;

% Area of the PV cells in m2
A_pv = 4;
% Area of the Thermal Collectors in m2
A_th = 25;


%% Save all values into a .mat file
%all values in .mat file read into SMD_MAIN and loaded there
save SMD_decision.mat N_mod V_HT Q_hw Q_air Q_cw Q_g A_pv A_th N_cond N_b




end

