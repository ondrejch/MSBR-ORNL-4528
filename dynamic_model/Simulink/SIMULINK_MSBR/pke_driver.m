clear;clc;
%% Parameters
bet = [2.290E-04, 8.320E-04, 7.100E-04, 8.520E-04, 1.710E-04, 1.020E-04]';
B   = sum(bet);
lam = [0.0126,0.0337,0.139,0.325,1.13,2.50]';
L = 3.300E-04;
nt_0 = 1.0; 
Ct_0 = zeros(6,1);
for i=1:6
    Ct_0(i) = (bet(i)/(L*lam(i)))*nt_0; % for i=1..6
end
y0=[nt_0;Ct_0];
[T,Y] = ode45(@(t,y) neudens(t,y,bet,B,lam,L),[0,1000],y0);
    
    
