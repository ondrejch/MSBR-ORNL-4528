% % Create the variable to load from
% R.time = [0,100,150,200]'; %the values must be in a column vector
% R.values = [0,0,0,0]';
% 
% S.time = [0,100,150,200]'; %the values must be in a column vector
% S.values = [0,0,0,0]';

% U233
%L = 0.00033;
%bet = [2.3E-4; 7.9E-4; 6.7E-4; 7.3E-4; 1.3E-4; 9.0E-5];
%B = sum(bet);
%lam = [0.0126; 0.0337; 0.139; 0.325; 1.13; 2.50];
% t_C  = 3.28; t_L = 5.85;
% nt    = 1.0;
% Ct(1) = ((bet(1)*nt)/L)*(1.0/(lam(1) - (exp(-lam(1)*t_L) - 1.0)/t_C));
% Ct(2) = ((bet(2)*nt)/L)*(1.0/(lam(2) - (exp(-lam(2)*t_L) - 1.0)/t_C));
% Ct(3) = ((bet(3)*nt)/L)*(1.0/(lam(3) - (exp(-lam(3)*t_L) - 1.0)/t_C));
% Ct(4) = ((bet(4)*nt)/L)*(1.0/(lam(4) - (exp(-lam(4)*t_L) - 1.0)/t_C));
% Ct(5) = ((bet(5)*nt)/L)*(1.0/(lam(5) - (exp(-lam(5)*t_L) - 1.0)/t_C));
% Ct(6) = ((bet(6)*nt)/L)*(1.0/(lam(6) - (exp(-lam(6)*t_L) - 1.0)/t_C));
% y0 = [nt;Ct'];


% U235
%L = 0.00033;
%bet = [2.15E-4; 0.00142; 0.00127; 0.00257; 7.5E-4; 2.7E-4];
%B = sum(bet);
%lam = [0.0126; 0.0337; 0.139; 0.325; 1.13; 2.50];
% t_C  = 3.28; t_L = 5.85;
% nt    = 1.0;
% Ct(1) = ((bet(1)*nt)/L)*(1.0/(lam(1) - (exp(-lam(1)*t_L) - 1.0)/t_C));
% Ct(2) = ((bet(2)*nt)/L)*(1.0/(lam(2) - (exp(-lam(2)*t_L) - 1.0)/t_C));
% Ct(3) = ((bet(3)*nt)/L)*(1.0/(lam(3) - (exp(-lam(3)*t_L) - 1.0)/t_C));
% Ct(4) = ((bet(4)*nt)/L)*(1.0/(lam(4) - (exp(-lam(4)*t_L) - 1.0)/t_C));
% Ct(5) = ((bet(5)*nt)/L)*(1.0/(lam(5) - (exp(-lam(5)*t_L) - 1.0)/t_C));
% Ct(6) = ((bet(6)*nt)/L)*(1.0/(lam(6) - (exp(-lam(6)*t_L) - 1.0)/t_C));
% y0 = [nt;Ct'];


% MSBR
L = 0.00033;
bet = [2.29E-4; 8.32E-4; 7.1E-4; 8.52E-4; 1.71E-4; 1.02E-4];
B = sum(bet);
lam = [0.0126; 0.0337; 0.139; 0.325; 1.13; 2.50];
t_C  = 3.28; t_L = 5.85;

rho = 0;
for i = 1:6
    rho = rho + bet(i)/(1.0 + (1.0-exp(-lam(i)*t_L))/(lam(i)*t_C));
end

reac = B - rho;
nt    = 1.0;
Ct(1) = ((bet(1)*nt)/L)*(1.0/(lam(1) - (exp(-lam(1)*t_L) - 1.0)/t_C));
Ct(2) = ((bet(2)*nt)/L)*(1.0/(lam(2) - (exp(-lam(2)*t_L) - 1.0)/t_C));
Ct(3) = ((bet(3)*nt)/L)*(1.0/(lam(3) - (exp(-lam(3)*t_L) - 1.0)/t_C));
Ct(4) = ((bet(4)*nt)/L)*(1.0/(lam(4) - (exp(-lam(4)*t_L) - 1.0)/t_C));
Ct(5) = ((bet(5)*nt)/L)*(1.0/(lam(5) - (exp(-lam(5)*t_L) - 1.0)/t_C));
Ct(6) = ((bet(6)*nt)/L)*(1.0/(lam(6) - (exp(-lam(6)*t_L) - 1.0)/t_C));
y0 = [nt; Ct'];