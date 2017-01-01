%{

Point Kinetics Equation (PKE) solver for education and research purposes.

Author: Vikram Singh, viikraam@gmail.com
Supervisor: Dr. Ondrej Chvala, 
Dept. of Nuclear Engineering, UTK, ochvala@utk.edu

This program takes an input file with time (in s), reactivity, and external 
neutron source as three columns and returns plots for n(t) and C_i(t) 
for i=1,2,...6

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear;        % clear workspace.

% Ask for user input on fuel type. Options: U233, U235 or MSBR; case insensitive.
x=''; % initialize string array.

while (strcmp(x,''))
    x=input('Select fuel. Options are U233, U235, or MSBR   ','s');
    if (strcmpi('U233',x)==1 || strcmpi('U235',x)==1 || strcmpi('MSBR',x)==1)
        break
    else
        disp('Please try again!')
        x='';
    end
end


% Decay constants for the corresponding decay groups.
 lam = [0.0126,0.0337,0.139,0.325,1.13,2.50]';


% Mean neutron generation time.
 L = 0.00033; 


% Transit time of fuel in external loop and core respectively.
t_L = 5.85;
t_C = 3.28;


% Delayed neutron lifetimes 'beta' for the six precursor groups depending on 
% fuel type. B = sum(bet). Retrieved from ORNL-MSR-67-102.
if (strcmpi('U233',x)==1)
   bet   = [0.00023,0.00079,0.00067,0.00073,0.00013,0.00009]';
   B     = sum(bet);
   rho_0 = B - bigterm(bet,lam,L,t_L,t_C); 
  elseif (strcmpi('U235',x)==1)
     bet   = [0.000215,0.00142,0.00127,0.00257,0.00075,0.00027]';
     B     = sum(bet);
     rho_0 = B - bigterm(bet,lam,L,t_L,t_C);
      elseif (strcmpi('MSBR',x)==1)
         bet   = [0.000229,0.000832,0.000710,0.000852,0.000171,0.000102]';
         B     = sum(bet);
         rho_0 = B - bigterm(bet,lam,L,t_L,t_C);
end


% Initial values for n(t) and C_i(t).
nt    = 1.0;
Ct(1) = ((bet(1)*nt)/L)*(1.0/(lam(1) - (exp(-lam(1)*t_L) - 1.0)/t_C));
Ct(2) = ((bet(2)*nt)/L)*(1.0/(lam(2) - (exp(-lam(2)*t_L) - 1.0)/t_C));
Ct(3) = ((bet(3)*nt)/L)*(1.0/(lam(3) - (exp(-lam(3)*t_L) - 1.0)/t_C));
Ct(4) = ((bet(4)*nt)/L)*(1.0/(lam(4) - (exp(-lam(4)*t_L) - 1.0)/t_C));
Ct(5) = ((bet(5)*nt)/L)*(1.0/(lam(5) - (exp(-lam(5)*t_L) - 1.0)/t_C));
Ct(6) = ((bet(6)*nt)/L)*(1.0/(lam(6) - (exp(-lam(6)*t_L) - 1.0)/t_C));


% Read in input file. Formatted as time, reactivity, source.
global input_data; 
input_data = dlmread('./reactivity.txt');
global nrows;
nrows      = size(input_data,1);
tmax       = input_data(nrows,1); % length of time to evaluate equations.


% Initial y and t values
y0 = [nt,Ct(1),Ct(2),Ct(3),Ct(4),Ct(5),Ct(6)]';
t0 = 0; % we start at -30s to avoid small fluctuations at the beginning.

 
sol = dde23(@(t,y,Z) neudens(t,y,Z,@react,rho_0,@source,bet,B,lam,L,t_L,t_C)', [t_L,t_L,t_L,t_L,t_L,t_L,t_L], y0, [t0 tmax]);


% % Saving the solution for t and y, where y1 is n(t) and y2:y7 are C_i(t).            
% tsol = sol.x; 
% ysol = sol.y;
% 
% 
% % Plot figure 1, n(t) vs t.
% clf('reset');
% figure(1);
% F1 = plot(tsol,ysol(:,1));
% X1 = xlabel('Time [s]');
% set(X1,'FontName','Times New Roman','fontsize',14);
% axis([0,tmax]);
% Y1 = ylabel('Reactor Power [rel.]');
% set(Y1,'FontName','Times New Roman','fontsize',14);
% 
% 
% % Plot figure 2, C_i(t) vs t. 
% figure(2)
% F2 = plot(tsol,ysol(:,2:7));
% X2 = xlabel('Time [s]');
% set(X2,'FontName','Times New Roman','fontsize',14);
% axis([0,tmax]);
% Y2 = ylabel('C_i(t)');
% set(Y2,'FontName','Times New Roman','fontsize',14);
% legend('C_1','C_2','C_3','C_4','C_5','C_6');