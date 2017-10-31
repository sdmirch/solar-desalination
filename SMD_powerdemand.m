function [ P_demand N_b] = SMD_powerdemand( Pw_pump,Pa_pump,N_auto,DOD,n_acdc,n_bcd )
%SMD_powerdemand.m
%Created: 2/22/15
%Last Updated: 2/22/15
%Creator: Sera Mirchandani

%Description:
%Calculates the total power demand of the system

%SHOULD STAY CONSTANT

%Power Demand in Watts
P_demand = 2*Pw_pump + Pa_pump;

% %Current Demand in Amps
% C_demand = 3.5402*(P_demand/1000)+0.5219;
% %Number of batteries to run for 24 hours
% %129 A-h per battery
% N_b = C_demand*24/129;
% N_b = ceil(N_b);

% %129A-h at 12V is 1.548KW-h

%Calculate current available based on battery relationship:
%Capacity(A-h) = 13.767*ln(t_discharge(hr))+ 84.391
%N_auto*24 is discharge rate in hours
Capacity = (13.767*log(N_auto*24))+84.391;
Current = Capacity/(N_auto*24);

%DOD*N_bcd*N_acdc
%Cannot discharge past DOD, converting, and discharge inefficencies
N_b = ceil((P_demand/(Current*12))/(DOD*n_bcd*n_acdc));
end

