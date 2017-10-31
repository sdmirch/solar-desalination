function [  ] = SMD_prices( )

%SMD_prices.m
%Created: 2/15/15
%Last Updated: 2/23/15
%Creator: Sera Mirchandani

%Description:
%User can input prices of components in this file
%Used in SMD_MAIN

%% Multiplied Costs
%Costs that will be changed by a multiplier

%Cost of PV per m2
cost_pv = 385;

%Cost of Solar collectors per m2
cost_th = 160;

%Cost of Membrane Modules per unit
cost_mod = 1500;

%Cost of Condensers per unit
cost_cond = 253;

%Cost of batteries per unit
cost_bat = 300;

%Cost of CPVC or PEX piping and fittings PER METER
cost_pex = 20;

%% Constant Costs
%Costs that stay constant regardless of the size of the system

%Cost of Variable Frequency Drive VFD
cost_vfd = 374;

%Cost of Permeate Tank
cost_permtank = 157;

%Cost of Tent
cost_tent = 4514;

%Cost of Permeate Pump
cost_permpump = 628;

%Cost of Brine Circulation Pump
cost_circpump = 1300;

%Cost of Level sensor
cost_lse = 725;

%Cost of Level switch, $30 each
cost_lsw = 90;

%Cost of Thermocouples, $40 each
cost_thermo = 200;

%Total Constant Costs
cost_constant = cost_vfd+cost_permtank+cost_tent+cost_permpump...
    +cost_circpump+cost_lse+cost_lsw+cost_thermo;


%% Save all values into a .mat file
%all values in .mat file read into SMD_MAIN and loaded there
save SMD_prices.mat cost_pv cost_th cost_mod cost_cond...
    cost_pex cost_constant cost_bat
    

end

