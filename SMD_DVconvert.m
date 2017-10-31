
function [  ] = SMD_DVconvert(Xin)

% Number of modules
N_mod = ceil(Xin(1))
% Volume of the hot tank in L
V_HT = 100*ceil(Xin(2))
% Area of the PV cells in m2
A_pv = ceil(Xin(3))
% Area of the Thermal Collectors in m2
A_th = ceil(Xin(4))
% Flow Rate: Hot Water; Must be 0.5,1,2 LPM
Q_hw_index = [0.5,1,2];
Q_hw = Q_hw_index(ceil(Xin(5)))
% Flow Rate: Air
%Must be 20,40,60,80,100,120,140,160,180,200,220,240,260 LPM
%PER MODULE must take into account how many modules when calc
%the power needed for the water pump
Q_air = 20*ceil(Xin(6))
% Flow Rate: Cold water (cooling line) LPM
Q_cw = 50*ceil(Xin(7))
% Flow Rate: Glycol LPM
Q_g = 5*ceil(Xin(8))
% % Number of modules
% N_mod = ceil(Xin(1))
% % Number of 12 V batteries in the battery storage system
% N_b = ceil(Xin(2))
% % Volume of the hot tank in L
% V_HT = 100*ceil(Xin(3))
% % Area of the PV cells in m2
% A_pv = ceil(Xin(4))
% % Area of the Thermal Collectors in m2
% A_th = ceil(Xin(5))
% % Flow Rate: Hot Water; Must be 0.5,1,2 LPM
% Q_hw_index = [0.5,1,2];
% Q_hw = Q_hw_index(ceil(Xin(6)))
% % Flow Rate: Air
% %Must be 20,40,60,80,100,120,140,160,180,200,220,240,260 LPM
% %PER MODULE must take into account how many modules when calc
% %the power needed for the water pump
% Q_air = 20*ceil(Xin(7))
% % Flow Rate: Cold water (cooling line) LPM
% Q_cw = 50*ceil(Xin(8))
% % Flow Rate: Glycol LPM
% Q_g = 5*ceil(Xin(9))

end