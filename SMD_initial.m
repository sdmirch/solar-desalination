function [  ] = SMD_initial( )

%SMD_initial.m
%Created: 1/22/15
%Last Updated: 2/23/15
%Creator: Sera Mirchandani

%Description:
%All initial values inputted by user
%Used in SMD_MAIN

%% Location Specific Values

% Day of year (0<n<365)
n = 180;

% Site altitude in km (0<A<2.5)
A = 1.4;

% Latitude of site in deg, ~35.29 Leupp
phi = 35.29;

%% Solar Design

% Number of autonomous days
N_auto = 1;

% Solar collector angle between solar collector and due south
% 90°=due west, -90°=due east
gamma = 35;

% Solar collector slope, angle between collector and a horizontal plane
%  ? 0°<?<180°
beta = 45;

%Thermal and PV efficiencies 
n_th = 0.5;
n_pv = 1; %0.15;

%Solar collector heat transfer coefficient
u_th = 1;

%Battery power in Watts
%12V * (129 A-h / 24 hr)
%12 V battery, 129 Ah capacity w/ 24 hour discharge rate
Pb12 = 12*(129/24);
%Battery depth of discharge, 25% recommended for off-grid applications
DOD = 0.80;
%AC/DC Battery converter efficiency: only 70% of available energy can be
%stored
n_acdc = 0.7;
%Battery charging and discharging efficiency: as the battery discharges a
%certain amount, you can only use 80% of that amount
n_bcd = 0.8;

%% MD System Design

% Number of modules for each condenser ratio
ModCondRatio = 4;

%% Piping and Pumps Properties

%Hydraulic diameter of air piping = 2" = 0.0508m
d_h_a = 0.0508;

%Hydraulic diameter of water piping = 3/4" = 0.01905m
d_h_w = 0.01905;

% Individual piping length for modules in m
L_pa = 3;
L_pw = 3;
% Total flow piping length in m
L_paT = 3;
L_pwT = 5;

%Pump efficiencies
n_hwpump = 0.5;
n_blower = 0.5;

%% Fluid Properties 
%Specific heats for water and glycol in J/kg C
%Glycol 0.5*water = 2093 J/kg C
C_pg = 3140; %50/50 mix of glycol and water
C_pw = 4186;

%Densities or water, glycol, and air in kg/L
rho_g = 1.1132;
rho_w = 0.9999;
rho_a = 0.001204;

%Absolute viscosity of water and air in Pa*s = kg/m*s
mew_a = 1.983e-5;
mew_w = 1e-3;

%% Random
%Ambient Temperatures

T_amb=25*ones(1,1020);

%% Save all values into a .mat file
%all values in .mat file read into SMD_MAIN and loaded there
save SMD_init.mat n A phi N_auto gamma beta...
    n_th n_pv T_amb C_pg C_pw rho_g rho_w u_th...
    rho_a d_h_a d_h_w mew_a mew_w L_pa L_pw...
    L_paT L_pwT ModCondRatio n_hwpump n_blower...
    Pb12 DOD n_acdc n_bcd




end

