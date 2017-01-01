% MSBR - circulating

% U233
% Lam = 0.00033;
% beta = [0.00023, 0.00079, 0.00067, 0.00073, 0.00013, 0.00009]; % U233
% lam = [0.0126, 0.0337, 0.139, 0.325, 1.13, 2.50]; % U235
% beta_t = sum(beta); % U233 system

% U235
Lam = 0.00033; % U235
beta = [0.000215, 0.00142, 0.00127, 0.00257, 0.00075, 0.00027]; % U235
lam = [0.0126, 0.0337, 0.139, 0.325, 1.13, 2.50]; % U235
beta_t = sum(beta);

n_frac0 = 1; % initial fractional nuetron density n/n0 (n/cm^3/s)

tau_c =  3.28; % core transit time (s)
tau_l =  5.85; % external loop transit time (s)

% Lam  = 3.300E-04;  % mean generation time
% lam = [1.260E-02, 3.370E-02, 1.390E-01, 3.250E-01, 1.130E+00, 2.500E+00]; 
% beta = [2.290E-04, 8.320E-04, 7.100E-04, 8.520E-04, 1.710E-04, 1.020E-04];
% beta_t = sum(beta); % total delayed neutron fraction MSBR
rho_0 = beta_t - bigterm(beta,lam,Lam,tau_l,tau_c); % reactivity change in going from stationary to circulating fuel
C0(1) = ((beta(1))/Lam)*(1.0/(lam(1) - (exp(-lam(1)*tau_l) - 1.0)/tau_c));
C0(2) = ((beta(2))/Lam)*(1.0/(lam(2) - (exp(-lam(2)*tau_l) - 1.0)/tau_c));
C0(3) = ((beta(3))/Lam)*(1.0/(lam(3) - (exp(-lam(3)*tau_l) - 1.0)/tau_c));
C0(4) = ((beta(4))/Lam)*(1.0/(lam(4) - (exp(-lam(4)*tau_l) - 1.0)/tau_c));
C0(5) = ((beta(5))/Lam)*(1.0/(lam(5) - (exp(-lam(5)*tau_l) - 1.0)/tau_c));
C0(6) = ((beta(6))/Lam)*(1.0/(lam(6) - (exp(-lam(6)*tau_l) - 1.0)/tau_c));

sourcedata = [0 0 0];
sourcetime = [0 50 100];
source = timeseries(sourcedata,sourcetime);

