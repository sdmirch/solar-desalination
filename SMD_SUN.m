function [ G_on,G_cnb,G_cd,omega,delta ] = SMD_SUN( n,A,phi,t_st,G_on,G_cnb,G_cd)

%SMD_SUN.m
%Created: 11/30/14
%Last Updated: 1/22/15
%Creator: Sera Mirchandani

%Description:
%Prediction of position of sun and irradiance
%that is received at the surface of the Earth
%as a fxn of location and time of day
%Used in SMD_MAIN

%% Define Experimental Parameters

% Day of year (0<n<365)
%n = 180;

% Site altitude in km (0<A<2.5)
%A = 1.4;

% Latitude of site in deg, ~35.29 Leupp
%phi = 35.29;

% Standard meridian of local time zone in deg, Pacific std is 120 deg
L_st = 120;

% Longitude of the site in deg, ~111.01 Leupp
L_loc = 111.01;

% Climate modifiers, r0, r1, rk
% Midlatitude Summer r0=0.97, r1=0.99, rk=1.02
r0 = 0.97;
r1 = 0.99;
rk = 1.02;

%t_st = standard time, min
%t_st = 720;

%% Define Global Constants

%G_sc Solar Constant, W/m2
G_sc = 1367;

%% Perform Calculations: TIME

%B equation of time parameter
B = 360*(n-81)/364;
%E =equation of time
E = 9.87*sind(2*B)-7.53*cosd(B)-1.5*sind(B);
%t_sol = solar time, min
t_sol = t_st+4*(L_st-L_loc)+E;

%% Perform Calculations: ANGLES

%delta = declination, angle between sun and plane of the equator at solar
%noon, deg
delta = 23.45*sind(360*((284+n)/365));
%omega = hour angle, angular displacement between the sun and plane of the
%earth, deg
omega = (720-t_sol)*(1/4);
%theta_z = angle of incidence between site zenith and sun, deg
theta_z = acosd((cosd(delta)*cosd(phi)*cosd(omega))+(sind(delta)*sind(phi)));
%Tb = radio of G_cnb to G_on
Tb = r0*(0.4237-0.00821*((6-A)^2))+ r1*(0.5055+0.00595*((6.5-A)^2))*exp(-1*rk*(0.2711+(0.01858*((2.5-A)^2)))/cosd(theta_z));
%Td = ratio of diffuse radiation to actual solar radiation on a horizontal
%plane
Td = 0.2710-(0.2939*Tb);

%% Perform Calculations: RADIATION

%G_on actual solar radiation on day n, W/m2
G_on(t_st) = G_sc*(1+(0.033*cosd(360*n/365)));
%G_cnb clear sky beam normal radiation, W/m2
G_cnb(t_st) = Tb*G_on(t_st);
%G_cd clear sky diffuse radiation, W/m2
G_cd(t_st) = G_sc*(1+0.033*cosd(360*n/365))*Td*cosd(theta_z);

end

