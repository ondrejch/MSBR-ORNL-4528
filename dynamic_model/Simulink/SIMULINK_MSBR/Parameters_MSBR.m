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
simtime = 8000;
reactdata = [0 0 0];
reacttime = [0 50 100];
% Periodic 60 PCM for 50 seconds
% simtime = 500;
% periodic = [0, 0; 50, 6e-4; 100, 0; 150, -6e-4; 200, 0; 250, 6e-4; 300, 0; 350, -6e-4; 400, 0]; 
% reactdata = periodic(:,2);
% reacttime = periodic(:,1);
% Step up 60 pcm 
% simtime = 1000;
% reactdata = [0 6e-3];
% reacttime = [0 300];
% % Step down -60 pcm for 10 sec
% simtime = 100;
% reactdata = [0 -6e-4];
% reacttime = [0 50];
% % Pulse 600 pcm for 0.1 sec
% simtime = 30;
% reactdata = [0 6e-3 0];
% reacttime = [0 10 10.1];

react = timeseries(reactdata,reacttime);

ts_max = 1e-2; % maximum timestep (s)


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


K = 0.97514;
% Core Upflow
mcp_g1   = 1.403E+01; % (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f1   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f2   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
hA_fg_up = 1.733E+00; % (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g1     = 3.300E-02/K; % fraction of total power generated in the graphite lump
k_1      = 5.000E-01; % fraction of heat transferred from graphite which goes to first fuel lump
k_2      = 5.000E-01; % fraction of heat transferred from graphite which goes to second fuel lump
k_f1     = 2.210E-01/K; % fraction of total power generated in lump f1
k_f2     = 2.210E-01/K; % fraction of total power generated in lump f2
tau_1    = mn_f/W_f;  % 8.400E-01; % residence time in lump f1
tau_2    = mn_f/W_f;  % 8.400E-01; % residence time in lump f2


% Core downflow
mcp_g2   = 1.403E+01; % (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f3   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f4   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
hA_fg_dn = 1.123E+00; % (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g2     = 3.300E-02/K; % fraction of total power generated in the graphite lump
k_3      = 5.000E-01; % fraction of heat transferred from graphite which goes to third fuel lump
k_4      = 5.000E-01; % fraction of heat transferred from graphite which goes to fourth fuel lump
k_f3     = 2.210E-01/K; % fraction of total power generated in lump f3
k_f4     = 2.210E-01/K; % fraction of total power generated in lump f4
tau_3    = mn_f/W_f;  % 8.400E-01; % residence time in lump f3
tau_4    = mn_f/W_f;  % 8.400E-01; % residence time in lump f4


% Fertile stream
mcp_g3   = 3.467E+00; % (mass of material x heat capacity of material x fraction tranferring heat to fertile stream)in MW-s/°C
mcp_b1   = 1.733E+00; % (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
mcp_b2   = 1.733E+00; % (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
hA_bg    = 1.054E+00; % (salt to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g3     = 8.140E-03/K; % fraction of total power generated in the graphite lump
k_1b     = 5.000E-01; % fraction of heat transferred from graphite which goes to blanket salt lump b1
k_2b     = 5.000E-01; % fraction of heat transferred from graphite which goes to blanket salt lump b2
k_b1     = 8.500E-03/K; % fraction of total power generated in lump b1
k_b2     = 8.500E-03/K; % fraction of total power generated in lump b2
tau_b1   = 6.998E+00; % residence time in lump b1
tau_b2   = 6.998E+00; % residence time in lump b2


%% Fuel salt/primary heat exchanger

% PRIMARY FLOW PARAMETERS - DONE
W_p  = 1.414E3; % fuel flow rate (kg/s)
m_p  = 3.030e3; % fuel mass in PHE (kg)
nn_p = 4; % number of fuel nodes in PHE
mn_p = m_p/nn_p; % fuel mass per node (kg)
mn_m = 1.414e3; % mass primary salt in mixing node (kg)
cp_p = 2.302E-3; % fuel heat capacity (MW-s/(kg-C))

% SECONDARY FLOW PARAMETERS - DONE
W_s  = 2.181E3; % coolant flow rate (kg/s)
m_s  = 1.588E4; % coolant mass in PHE (kg)
nn_s = 4; % number of coolant nodes in PHE
mn_s = m_s/nn_s; % coolant mass per node (kg)
cp_s = 1.714E-3; % coolant heat capacity (MW-s/(kg-C)

% Initial conditions - DONE
Tp_in  = 704.44; % in °C
Ts_in  = 454.444; % in °C

T0_p1  = Tp_in - 41.6675; % in °C
T0_p2  = Tp_in - 2*41.6675; % in °C
T0_p3  = Tp_in - 3*41.6675; % in °C
T0_p4  = 537.77; % in °C
T0_pm  = T0_p2; % in °C

T0_t1  = 596.87; % in °C
T0_t2  = 520.71; % in °C

T0_s1  = Ts_in + 36.25; % in °C
T0_s2  = Ts_in + 2*36.25; % in °C
T0_s3  = Ts_in + 3*36.25; % in °C
T0_s4  = 599.4444; % in °C
A_phe = 2*4.584E+02; % area for heat transfer (primary and secondary, m^2)

h_p = 1.306E-02; % heat transfer coefficient from primary to tubes
h_s = 2.555E-02; % heat transfer coefficient from tubes to secondary
% Primary Side - DONE
mcp_p1   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_p2   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_p3   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_p4   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C

hA_p1 = h_p*A_phe/4; %3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
hA_p2 = h_p*A_phe/4; %3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
hA_p3 = h_p*A_phe/4; %3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
hA_p4 = h_p*A_phe/4; %3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C


% Tubes - DONE
mcp_t1   = 2.158; % (mass of material x heat capacity of material) of tubes per lump in MW-s/°C
mcp_t2   = 2.158; % (mass of material x heat capacity of material) of tubes per lump in MW-s/°C


% Secondary Side - DONE
mcp_s1   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s2   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s3   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s4   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C

hA_s1 = h_s*A_phe/4; %5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s2 = h_s*A_phe/4; %5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s3 = h_s*A_phe/4; %5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s4 = h_s*A_phe/4; %5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C

%% Fertile Salt Heat Exchanger
% Secondary
tau_s5 = 7.446E-01;
tau_s6 = 7.446E-01;
mcp_s5 = 2.632E+00; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s6 = 2.632E+00; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
hA_s5  = 7.150E-01; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s6  = 7.150E-01; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C

% Primary
tau_pb = 7.983E-01;
hA_pb1 = 7.150E-01; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
hA_pb2 = 7.150E-01; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
mcp_pb1   = 3.967E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_pb2   = 3.967E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C

% Tubes
cp_t = 5.873E-04; % heat capacity of tubes
m_t = 8.754E+02; % mass tubes
mcp_t3   = m_t*cp_t; % (mass of material x heat capacity of material) of tubes per lump in MW-s/°C

% Initial conditions
T0_s5 = 603.33;
T0_s6 = 607.22;
T0_pb1 = 648.88;
T0_pb2 = 676.66; % fertile exit temp deg C
T0_t3 =  633.6967; % tube temp
%% Boiler and Reheater Parameters
mn_ms = mn_m; % mass salt in mixing node (kg)
p_b = 0.87*P; % power removed by boiler (MW)
p_r = 0.13*P; % power removed by reheater (MW)

tau_r = 22.09; % resident time in reheater (sec)
tau_b = 10.43; % resident time in boiler (sec)

W_sb = (1-0.133)*W_s; % Coolant salt flow through boiler (kg/s)
W_sr = 0.133*W_s; % Coolant salt flow through reheater (kg/s)
mb_cpb = 3.297E+01;
mr_cpr = 1.050E+01;
%% Pure time delays between components

tau_fhx_c = 1.22; % (sec) delay from fuel hx to core
tau_c_fhx = 1.32; % (sec) delay from core to fuel hx
tau_fhx_fehx = 7.88; % (sec) fuel hx to fertile hx
tau_fehx_c = 7.0; % (sec) fertile hx to core
tau_c_fehx = 7.0; % (sec) core to fertile hx
tau_fehx_b = 13.5; % (sec) fertile hx to boiler
tau_fehx_r = 17.3; % (sec) fertile hx to reheater
tau_b_fhx = 4.2; % (sec) boiler to fuel hx
tau_r_fhx = 11.1; % (sec) reheater to fuel hx
%% Initial condititons for dynamic model from open loop model simulation
% sim MSBR_SS
% coress=msbr_core_mux(end,[4:25]);

%% Useful calculations
% Core Power
% corepower = W_f*cp_p*(msbr_core_mux(end,22)-msbr_core_mux(end,1))
% coolantpower = W_s*cp_s*(msbr_phe_mux(end,13)-msbr_phe_mux(end,2))
% heatsinkpower = W_s*cp_s*(msbr_br_mux(end,1)-msbr_br_mux(end,9))
% fertpower = W_s*cp_s*(msbr_phe_mux(end,13)-msbr_phe_mux(end,2))



