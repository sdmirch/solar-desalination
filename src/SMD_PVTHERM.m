function [ P_th,P_pv,E_th ] = SMD_PVTHERM(t_st,G_on,G_cnb,G_cd,n_th,n_pv,A_th,A_pv,gamma,beta,omega,delta,phi,P_th,P_pv,E_th)

%SMD_PVTHERM.m
%Created: 1/23/15
%Last Updated: 1/23/15
%Creator: Sera Mirchandani

%Description:
%Temporary implementation of Patrick's model
%calculates electrical and thermal energy created

% Angle of Incidence between solar collector and sun in deg
%66666666 FIX
theta_i = acosd(sind(delta)*sind(phi)*cosd(beta)-...
    sind(delta)*cosd(phi)*sind(beta)*cosd(gamma)+...
    cosd(delta)*cosd(phi)*cosd(beta)*cosd(omega)+...
    cosd(delta)*sind(phi)*sind(beta)*cosd(gamma)*cosd(omega)+...
    cosd(delta)*sind(beta)*sind(gamma)*sind(omega));

% Thermal power being absorbed (W)
P_th(t_st) = A_th*n_th*(G_cd(t_st)+(G_cnb(t_st)*cosd(theta_i)));
% Thermal energy being created PER MINUTE TIMESTEP (J)
% E_th = ((P_th(i)+P_th(i+1))/2)*(60s/min)*(1min/timestep) in Joules
E_th(t_st) = ((P_th(t_st)+P_th(t_st-1))/2)*(60);

% Electrical power being produced (W)
P_pv(t_st) = A_pv*n_pv*(G_cd(t_st)+(G_cnb(t_st)*cosd(theta_i)));


end

