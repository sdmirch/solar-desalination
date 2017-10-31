function [ Ha_TOT,Hw_TOT ] = SMD_headloss( N_mod, N_cond, rho_w, rho_a, mew_a,...
    mew_w, d_h_a, d_h_w, Q_air, Q_hw, L_pa, L_pw, L_paT, L_pwT )

%SMD_headloss.m
%Created: 2/21/15
%Last Updated: 2/21/15
%Creator: Sera Mirchandani

%Description:
%Calculates headlosses in the system


%% Reynolds number and friction factor Calculation

% Per individual module piping
Re_a = rho_a*Q_air*d_h_a*(1/60)/(mew_a*(pi*d_h_a*d_h_a/4));

Re_w = rho_w*Q_hw*d_h_w*(1/60)/(mew_w*(pi*d_h_w*d_h_w/4));

% For totaled flow piping
Re_aT = rho_a*N_mod*Q_air*d_h_a*(1/60)/(mew_a*(pi*d_h_a*d_h_a/4));

Re_wT = rho_w*N_mod*Q_hw*d_h_w*(1/60)/(mew_w*(pi*d_h_w*d_h_w/4));

% Assume laminar flow to calculate the frictional factor (even though it is
% likely that it is transient, which has an indeterminate frictional
% factor)
%%%%6666 might have to fix. not necessarily true

ff_a = Re_a/64;
ff_w = Re_w/64;
ff_aT = Re_aT/64;
ff_wT = Re_wT/64;

%% Calculates Individual Headlosses
%Headlosses in Pa
%Ha for air headlosses
%Hw for water headlosses
%Pipe losses are estimated PER MODULE

% J conversion factor: 1 psi = 6894.75729 Pa
J = 6894.75729;

%Condenser headlosses given in specs
Ha_cond = 1.45*J;
Hw_cond = 1.25*J; %we need this for the cold loop!!! circulation pump

% Module headloss from empirical results - only based on Q_air = 136LPM but
% since it is so small compared to the condenser, it doesn't matter for
% now.
Ha_mod = 96.527;
Hw_mod = 0;

% Individual module piping
Ha_pipe = ff_a*(L_pa/d_h_a)*(rho_a/2)*((Q_air*(1/60)*(1/1000)/(pi*d_h_a*d_h_a/4))^2);
Hw_pipe = ff_w*(L_pw/d_h_w)*(rho_w/2)*((Q_hw*(1/60)*(1/1000)/(pi*d_h_w*d_h_w/4))^2);
% For totaled flow piping
HaT_pipe = ff_a*(L_paT/d_h_a)*(rho_a/2)*((N_mod*Q_air*(1/60)*(1/1000)/(pi*d_h_a*d_h_a/4))^2);
HwT_pipe = ff_w*(L_pwT/d_h_w)*(rho_w/2)*((N_mod*Q_hw*(1/60)*(1/1000)/(pi*d_h_w*d_h_w/4))^2);

%% Calculates total system headloss
%Are headlosses additive like this?
Ha_TOT = Ha_mod + Ha_cond + Ha_pipe + HaT_pipe;

Hw_TOT = Hw_mod + Hw_pipe + HwT_pipe;

end