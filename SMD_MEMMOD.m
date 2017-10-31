function [ n_w,T_hwi,n_wtot ] = SMD_MEMMOD( t_st,Table_MEM,Q_air,Q_hw,T_hwo,n_w,T_hwi,N_mod,n_wtot)

%SMD_MEMMOD.m
%Created: 1/27/15
%Last Updated: 1/27/15
%Creator: Sera Mirchandani

%Description:
%Accesses Vickys table

% [T_hwo(C), T_hwi(C), Q_hw(L/min), Q_air(L/min), T_airo(C), n_w(mol/min)]

%Finds the specific part of the table that applies to the 
%Q_air and Q_hw picked in SMD_decision.m
Specific = Table_MEM(Table_MEM(:,3)==Q_hw & Table_MEM(:,4)==Q_air,:);
[~,I] = min(abs(Specific(:,1)-T_hwo(t_st)));

%Hot water going into the tank (hot water leaving the module)
%T_hwi(t_st+1) = Specific(I,2);

%IF the difference between T_hwo and Vicky's minimum values is more
%than 1 degree, then the program defaults to 0 mol/min production
if min(abs(Specific(:,1)-T_hwo(t_st))) < 1.0;
    n_w(t_st) = Specific(I,6);
    T_hwi(t_st+1) = Specific(I,2);
elseif T_hwo(t_st) > 90; %Over max water temp
    n_w(t_st) = Specific(length(Specific),6);
    T_hwi(t_st+1) = Specific(length(Specific),2);
else
    n_w(t_st)=0;
    T_hwi(t_st+1) = T_hwo(t_st);
end

%Calculates total production from all modules
n_wtot(t_st) = N_mod*n_w(t_st);

end

