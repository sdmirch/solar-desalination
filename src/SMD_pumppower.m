function [ Pw_pump, Pa_pump ] = SMD_pumppower( Ha_TOT,Hw_TOT,Q_air,Q_hw,N_mod,n_hwpump,n_blower)
%SMD_pumppower.m
%Created: 2/22/15
%Last Updated: 2/22/15
%Creator: Sera Mirchandani

%Description:
%Calculates the pump power required to overcome the frictional headlosses
%on the water and air sides

%Power = pressure drop * flow rate
%Power in Watts
Pw_pump = Hw_TOT*N_mod*Q_hw*(1/60000)/n_hwpump;
Pa_pump = Ha_TOT*N_mod*Q_air*(1/60000)/n_blower;

%check water and air
end

