% MSBR - circulating
format shorte

clear; close all;clc;

n_frac0 = 1; % initial fractional nuetron density n/n0 (n/cm^3/s)

% a_f   = -0.00008172; % fuel temperature feedback coefficient
% a_g   =  0.00002016; % graphite temperature feedback coefficient
% a_b   =  0.00001656; % fertile temperature feedback coefficient
tau_c =  3.28; % core transit time (s)
tau_l =  5.85; % external loop transit time (s)

Lam  = 3.300E-04;  % mean generation time
lam = [1.260E-02, 3.370E-02, 1.390E-01, 3.250E-01, 1.130E+00, 2.500E+00]; 
beta = [2.290E-04, 8.320E-04, 7.100E-04, 8.520E-04, 1.710E-04, 1.020E-04];
beta_t = sum(beta); % total delayed neutron fraction MSBR
rho_0 = beta_t - bigterm(beta,lam,Lam,tau_l,tau_c); % reactivity change in going from stationary to circulating fuel
C0(1) = ((beta(1))/Lam)*(1.0/(lam(1) - (exp(-lam(1)*tau_l) - 1.0)/tau_c));
C0(2) = ((beta(2))/Lam)*(1.0/(lam(2) - (exp(-lam(2)*tau_l) - 1.0)/tau_c));
C0(3) = ((beta(3))/Lam)*(1.0/(lam(3) - (exp(-lam(3)*tau_l) - 1.0)/tau_c));
C0(4) = ((beta(4))/Lam)*(1.0/(lam(4) - (exp(-lam(4)*tau_l) - 1.0)/tau_c));
C0(5) = ((beta(5))/Lam)*(1.0/(lam(5) - (exp(-lam(5)*tau_l) - 1.0)/tau_c));
C0(6) = ((beta(6))/Lam)*(1.0/(lam(6) - (exp(-lam(6)*tau_l) - 1.0)/tau_c));

% SOURCE INSERTION
% no source insertion
sourcedata = [0 0 0];
sourcetime = [0 50 100];
% % 1 (n/no)/s for 10 seconds
% sourcedata = [0 10 0];
% sourcetime = [0 10 20];

source = timeseries(sourcedata,sourcetime);

% REACTIVITY INSERTION
% No reactivity insertion
simtime = 200;
reactdata = [0 0 0];
reacttime = [0 50 100];
% Periodic 60 PCM for 50 seconds
% simtime = 500;
% periodic = [0, 0; 50, 6e-4; 100, 0; 150, -6e-4; 200, 0; 250, 6e-4; 300, 0; 350, -6e-4; 400, 0]; 
% reactdata = periodic(:,2);
% reacttime = periodic(:,1);
% % Step up 60 pcm 
% simtime = 100;
% reactdata = [0 6e-4];
% reacttime = [0 50];
% % Step down -60 pcm for 10 sec
% simtime = 100;
% reactdata = [0 -6e-4];
% reacttime = [0 50];
% % Pulse 600 pcm for 0.1 sec
% simtime = 30;
% reactdata = [0 6e-3 0];
% reacttime = [0 10 10.1];

react = timeseries(reactdata,reacttime);

ts_max = 1e-3; % maximum timestep (s)
% ts_max = 'auto';
% figure;plot(tout,msbr_core_SS(:,4));
% figure;plot(tout,msbr_core_SS(:,[5 7 9 11 13 15]));
% figure;plot(tout,msbr_core_SS(:,[17 20 23]));
% figure;plot(tout,msbr_core_SS(:,[18 19 21 22]));
% figure;plot(tout,msbr_core_SS(:,[24 25]));
% figure(1);title('n/n_0');xlabel('Time (s)');ylabel('Fractional Power');
% figure(2);title('Precursor Concentrations');xlabel('Time (s)');ylabel('Ci/n0');legend('C1','C2','C3','C4','C5','C6');
% figure(3);title('Graphite Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('G1','G2','G3');
% figure(4);title('Fuel Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('F1','F2','F3','F4');
% figure(5);title('Fertile Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('B1','B2');

% CORE HEAT TRANSFER PARAMETERS
W_f  = 1.414E3; % fuel flow rate (kg/s)
m_f  = 477.6; % fuel mass in core (kg)
nn_f = 4; % number of fuel nodes in core
mn_f = m_f/nn_f; % fuel mass per node (kg)

% Feedback co-efficients
a_f   = -8.172E-05; % fuel temperature feedback coefficient in drho/°C
a_g   =  2.016E-05; % graphite temperature feedback coefficient in drho/°C
a_b   =  1.656E-05; % fertile temperature feedback coefficient in drho/°C


% Initial conditions
T0_f1  = 579.44; % in °C
T0_f2  = 621.11; % in °C
T0_f3  = 662.77; % in °C
T0_f4  = 704.44; % in °C

T0_b1  = 648.88; % in °C
T0_b2  = 676.66; % in °C

T0_g1  = 590.00; % in °C
T0_g2  = 673.33; % in °C
T0_g3  = 652.77; % in °C

Tf_in  = 537.77; % in °C
T_b_in = 621.11; % in °C
P      = 556.0; % Thermal Power in MW


% Core Upflow
mcp_g1   = 1.403E+01; % (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f1   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f2   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
hA_fg_up = 1.733E+00; % (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g1     = 3.300E-02; % fraction of total power generated in the graphite lump
k_1      = 5.000E-01; % fraction of heat transferred from graphite which goes to first fuel lump
k_2      = 5.000E-01; % fraction of heat transferred from graphite which goes to second fuel lump
k_f1     = 2.210E-01; % fraction of total power generated in lump f1
k_f2     = 2.210E-01; % fraction of total power generated in lump f2
tau_1    = mn_f/W_f;  % 8.400E-01; % residence time in lump f1
tau_2    = mn_f/W_f;  % 8.400E-01; % residence time in lump f2


% Core downflow
mcp_g2   = 1.403E+01; % (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f3   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f4   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
hA_fg_dn = 1.123E+00; % (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g2     = 3.300E-02; % fraction of total power generated in the graphite lump
k_3      = 5.000E-01; % fraction of heat transferred from graphite which goes to third fuel lump
k_4      = 5.000E-01; % fraction of heat transferred from graphite which goes to fourth fuel lump
k_f3     = 2.210E-01; % fraction of total power generated in lump f3
k_f4     = 2.210E-01; % fraction of total power generated in lump f4
tau_3    = mn_f/W_f;  % 8.400E-01; % residence time in lump f3
tau_4    = mn_f/W_f;  % 8.400E-01; % residence time in lump f4


% Fertile stream
mcp_g3   = 3.467E+00; % (mass of material x heat capacity of material x fraction tranferring heat to fertile stream)in MW-s/°C
mcp_b1   = 1.733E+00; % (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
mcp_b2   = 1.733E+00; % (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
hA_bg    = 1.054E+00; % (salt to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g3     = 8.140E-03; % fraction of total power generated in the graphite lump
k_1b     = 5.000E-01; % fraction of heat transferred from graphite which goes to blanket salt lump b1
k_2b     = 5.000E-01; % fraction of heat transferred from graphite which goes to blanket salt lump b2
k_b1     = 8.500E-03; % fraction of total power generated in lump b1
k_b2     = 8.500E-03; % fraction of total power generated in lump b2
tau_b1   = 6.998E+00; % residence time in lump b1
tau_b2   = 6.998E+00; % residence time in lump b2


