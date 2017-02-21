% MSBR - circulating - expanded nodalization
clear; close all;clc;
format longe

%% Nuclear Model
n_frac0 = 1; % initial fractional nuetron density n/n0 (n/cm^3/s)
P       = 556.0; % Thermal Power in MW


% Feedback co-efficients
a_f   = -8.172E-05; % fuel temperature feedback coefficient in drho/°C
a_g   =  2.016E-05; % graphite temperature feedback coefficient in drho/°C
a_b   =  1.656E-05; % fertile temperature feedback coefficient in drho/°C

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
reactdata = [0 6e-4];
reacttime = [0 4500];
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


%% CORE HEAT XFER PARAMETERS FROM CONDENSED NODALIZATION ORNL-MSR-67-102

K = 0.97514; % sum of power deposition fractions from 67-102 (should equal 1)

mcp_g1   = 1.403E+01; % (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f1   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f2   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
Cp_g     = 1.679E-03; % (MJ/kg/C) specific heat capacity of the graphite
rho_g    = 1.698E+03; % (kg/m^3) density of graphite 67-102
hA_fg_up = 1.733E+00; % (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g1     = 3.300E-02; % fraction of total power generated in the graphite lump
k_f1     = 2.210E-01; % fraction of total power generated in lump f1
k_f2     = 2.210E-01; % fraction of total power generated in lump f2
tau_1    = 8.400E-01; % residence time in lump f1
tau_2    = 8.400E-01; % residence time in lump f2

mcp_g2   = 1.403E+01; % (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f3   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f4   = 2.748E-01; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
hA_fg_dn = 1.123E+00; % (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g2     = 3.300E-02; % fraction of total power generated in the graphite lump
k_f3     = 2.210E-01; % fraction of total power generated in lump f3
k_f4     = 2.210E-01; % fraction of total power generated in lump f4
tau_3    = 8.400E-01; % residence time in lump f3
tau_4    = 8.400E-01; % residence time in lump f4

mcp_g3   = 3.467E+00; % (mass of material x heat capacity of material x fraction tranferring heat to fertile stream)in MW-s/°C
mcp_b1   = 1.733E+00; % (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
mcp_b2   = 1.733E+00; % (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
hA_bg    = 1.054E+00; % (salt to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g3     = 8.140E-03; % fraction of total power generated in the graphite lump
k_b1     = 8.500E-03; % fraction of total power generated in lump b1
k_b2     = 8.500E-03; % fraction of total power generated in lump b2
tau_b1   = 6.998E+00; % residence time in lump b1
tau_b2   = 6.998E+00; % residence time in lump b2

kck=k_f1+k_f2+k_f3+k_f4+k_g1+k_g2+k_g3+k_b1+k_b2;
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
%% Reactor Components

% Geometry
apothem_in = 5.375; % (in) the perpendicular distance from center to a side ORNL-4528 p.35
l_cell_in = 13*12+3; % (in) length of graphite fuel cell ORNL-4528 p.35
bore_OD_in = 2+23/32; % (in) diameter of the biggest bore circle ORNL-4528 p.36
sle_OD_in  = 2.25; % (in) outer diameter of the sleeve ORNL-4528 p.36
sle_ID_in  = 1.5; % (in) inner diameter of the sleeve ORNL-4528 p.36
in_m = 0.0254; % one inch equals exactly 0.0254 meters

l_cell  = l_cell_in*in_m; % (m) length of graphite fuel cell ORNL-4528 p.35
n_cell  = 240; % no of fuel cells in core ORNL-4528 p.35

apothem = apothem_in*in_m; % (m) the perpendicular distance from center to a side ORNL-4528 p.35
n_sides = 6; % hexagon has 6 sides
A_hex   = apothem^2*n_sides*tand(180/n_sides); % area of the hexagon, fuel-cell cross-section

p_hex   = 2*A_hex/apothem; % (m) perimeter of the hexagon (A_hex = 0.5*p_hex*apothem)

bore_OD = bore_OD_in*in_m; % (m) diameter of the biggest bore circle ORNL-4528 p.36
sle_OD  = sle_OD_in*in_m; % (m) outer diameter of the sleeve ORNL-4528 p.36
sle_ID  = sle_ID_in*in_m; % (m) inner diameter of the sleeve ORNL-4528 p.36

r_mhex = sqrt((A_hex+(pi*(bore_OD/2)^2))/(2*pi)); % (m) radius of circle dividing hex into equal area
r_msle = sqrt(((pi*(sle_OD/2)^2)+(pi*(sle_ID/2)^2))/(2*pi)); % (m) radius of circle dividing sleeve into equal area

A_fgsleid = pi*sle_ID*l_cell*n_cell; % (m^2) Area of graphite in contact with fuel upstream
A_fgsleod = pi*sle_OD*l_cell*n_cell; % (m^2) f-g inner area
A_fgbore  = pi*bore_OD*l_cell*n_cell; % (m^2) f-g outer area
A_ggi   = pi*r_msle*l_cell*n_cell; % (m^2) g-g inner area
A_ggo   = pi*r_mhex*l_cell*n_cell; % (m^2) g-g outer area
A_Bg    = p_hex*l_cell*n_cell; % (m^2) B-g area


% Core fuel inner channel (downflow)
W_f  = 1.414E3; %calcd from m_f/tau_c 1.414E3; % fuel flow rate (kg/s)
m_f  = 4776; %477.6; % fuel mass in core (kg) corrected error from 67-102 (might have affected responsiveness)
nn_f = 8; % number of fuel nodes in core
mn_f = m_f/nn_f; % fuel mass per node (kg)
Cp_f   = 2.302E-03; % (MJ/kg/C) specific heat capacity of the fuel
h_fgi  = 9.176E-03; % (MW/m^2/C) heat xfer coefficient between fuel and graphite
nn_fup = 4; % number of upstream fuel nodes
A_fgsleidn = A_fgsleid/nn_fup ; % (m^2) nodal area
m_f1b1  = mn_f; % (kg) mass in the node
m_f1b2  = mn_f; % (kg) mass in the node
m_f1a1  = mn_f; % (kg) mass in the node
m_f1a2  = mn_f; % (kg) mass in the node

k_f1b1  = 2.210E-01/2; % (frac) fraction of total power deposited in the node
k_f1b2  = 2.210E-01/2; % (frac) fraction of total power deposited in the node
k_f1a1  = 2.210E-01/2; % (frac) fraction of total power deposited in the node
k_f1a2  = 2.210E-01/2; % (frac) fraction of total power deposited in the node

% Graphite hollow cylinder
cond_g   = 0.5612E-6; % (MW/K/m) @ 704C ORNL-P150 (graphite) thermal conductivity of graphite
rho_g    = 1.698E+03; % (kg/m^3) density of graphite 67-102
l_i      = (sle_OD+r_msle)/2 - (r_msle+sle_ID)/2; % centerline-centerline dist. b/n radial sleeve graphite nodes
Cp_g     = 1.679E-03; % (MJ/kg/C) specific heat capacity of the graphite
h_ggi    = cond_g/l_i; % (MW/m^2/C) heat xfer coefficient between nodes of continuous graphite
nn_gg    = 2; % number of upstream and downstream graphite nodes in hollow cylinder
A_ggin   = A_ggi/nn_gg;
nn_fdn = nn_fup;
A_fgsleodn  = A_fgsleod/nn_fdn;
m_g1b    = rho_g*(pi*r_msle^2 - pi*(sle_ID/2)^2)*l_cell*n_cell/2; % 
m_g2b    = rho_g*(pi*(sle_OD/2)^2 - pi*r_msle^2)*l_cell*n_cell/2; %  
m_g1a    = rho_g*(pi*r_msle^2 - pi*(sle_ID/2)^2)*l_cell*n_cell/2; %
m_g2a    = rho_g*(pi*(sle_OD/2)^2 - pi*r_msle^2)*l_cell*n_cell/2; %

m_g_tot = (A_hex-pi*(bore_OD/2)^2+pi*(sle_OD/2)^2-pi*(sle_ID/2)^2)*rho_g*n_cell*l_cell;
m_gbt_ratio = mcp_g3/(mcp_g3+mcp_g2+mcp_g1); % ratio of graphite mass interacting with interstitial fertile salt in core to total graphite mass
m_gB = m_gbt_ratio*m_g_tot; % mass of graphite interacting "only" with fertile salt
rkmB = k_g3/m_gB; % power deposited in fertile salt graphite : mass of m_gB
rkmf = (k_g1+k_g2)/(m_g_tot-m_gB);

k_g1b    = rkmf*m_g1b; 
k_g2b    = rkmf*m_g2b; 
k_g1a    = rkmf*m_g1a; 
k_g2a    = rkmf*m_g2a; 

% Core fuel outer channel (upflow)
A_fgboren = A_fgbore/nn_fdn;
m_f2b1  = mn_f; % (kg) mass in the node
m_f2b2  = mn_f; % (kg) mass in the node
m_f2a1  = mn_f; % (kg) mass in the node
m_f2a2  = mn_f; % (kg) mass in the node

k_f2b1  = 2.210E-01/2; % (frac) fraction of total power deposited in the node
k_f2b2  = 2.210E-01/2; % (frac) fraction of total power deposited in the node
k_f2a1  = 2.210E-01/2; % (frac) fraction of total power deposited in the node
k_f2a2  = 2.210E-01/2; % (frac) fraction of total power deposited in the node

h_fgo  = 8.165E-03; % (MW/m^2/C) heat xfer coefficient between fuel and graphite


% Graphite hollow hexagon
l_o      = (apothem+r_mhex)/2 - (r_mhex+bore_OD)/2; % centerline-centerline dist. b/n radial sleeve graphite nodes
h_ggo    = cond_g/l_o; % (MW/m^2/C) heat xfer coefficient between nodes of continuous graphite
nn_gg    = 2; % number of upstream and downstream graphite nodes in hollow hexagon
A_ggon   = A_ggo/nn_gg;
h_Bg     = 2.839E-03; % heat xfer coefficent between graphite and fertile stream
nn_Bg    = 4; % number of nodes of fertile stream
A_Bgn    = A_Bg/nn_Bg; % nodal area for heat xfer
% nodal masses
m_g3a    = rho_g*(pi*r_mhex^2 - pi*(bore_OD/2)^2)*l_cell*n_cell/2; %
m_g4a    = rho_g*(A_hex - pi*r_mhex^2)*l_cell*n_cell/2;            %
m_g3b    = rho_g*(pi*r_mhex^2 - pi*(bore_OD/2)^2)*l_cell*n_cell/2; %
m_g4b    = rho_g*(A_hex - pi*r_mhex^2)*l_cell*n_cell/2;            %

k_g3a    = rkmf*m_g3a; 
k_g3b    = rkmf*m_g3b;
k_g4a    = (rkmB*m_gB+rkmf*(m_g4a+m_g4b-m_gB))/2;
k_g4b    = (rkmB*m_gB+rkmf*(m_g4a+m_g4b-m_gB))/2; 
%  
% Fertile stream
W_B = 2.690E+02; % (kg/s) mass flow rate of fertile salt
m_B = 3.765E+03; % (kg) mass fertile salt in core
nn_B = 4; % number of nodes of fertile salt in core
Cp_B = 9.207E-04; % (MJ/kg/C)specific heat capacity of fertile salt
m_Bb1   = m_B/nn_B; % 
m_Bb2   = m_B/nn_B; % 
m_Ba1   = m_B/nn_B; % 
m_Ba2   = m_B/nn_B; % 

k_Bb1   = 8.500E-03/2; % fraction of total power generated in node
k_Bb2   = 8.500E-03/2; % fraction of total power generated in node
k_Ba1   = 8.500E-03/2; % fraction of total power generated in node
k_Ba2   = 8.500E-03/2; % fraction of total power generated in node
k_core  = k_Bb1+k_Bb2+k_Ba1+k_Ba2+k_g1a+k_g2a+k_g3a+k_g4a+k_g1b+k_g2b+k_g3b+k_g4b+k_f1b1+k_f1b2+k_f1a1+k_f1a2+k_f2b1+k_f2b2+k_f2a1+k_f2a2;

% Blanket
k_BL    = 1-k_core; % fraction of power generated in blanket
m_BL    = k_BL*m_B/(k_Bb1+k_Bb2+k_Ba1+k_Ba2); % mass fertile salt in blanket (to match energy generation density ofinterstitial fertile salt)
W_BL    = m_BL*W_B/m_B; % mass flow rate of fertile salt in blanket (to match resident time of interstitial fertile salt)
m_Bm    = W_B; % mass of fertile salt mixing node for blanket and interstitial streams (to give resident time of 1 second)

% Initial temperature conditions for Steady State at full power   **************
Tf_in  = 537.77; % in °C
T_b_in = 621.11; % in °C
% 
T0_f1b1  = T0_f4;
T0_f1b2  = T0_f4-(T0_f4-Tf_in)*(1/8); % in °C
T0_f1a1  = T0_f4-(T0_f4-Tf_in)*(2/8); % in °C
T0_f1a2  = T0_f4-(T0_f4-Tf_in)*(3/8); % in °C
T0_f2a2  = T0_f4-(T0_f4-Tf_in)*(5/8); % in °C
T0_f2a1  = T0_f4-(T0_f4-Tf_in)*(4/8); % in °C
T0_f2b2  = T0_f4-(T0_f4-Tf_in)*(7/8); % in °C
T0_f2b1  = T0_f4-(T0_f4-Tf_in)*(6/8); % in °C 

T0_Ba2   = T0_b2; % in °C
T0_Bb1   = T0_b2-(T0_b2-T_b_in)*(3/4); % in °C
T0_Bb2   = T0_b2-(T0_b2-T_b_in)*(2/4); % in °C
T0_Ba1   = T0_b2-(T0_b2-T_b_in)*(1/4); % in °C

%Dummy variables used for graphite node steady state temp calcs
A = k_g1b*P;
B = 2*h_fgi*A_fgsleidn;
C = h_ggi*A_ggin;
D = k_g2b*P;
E = 2*h_fgo*A_fgsleodn;

F = k_g3b*P;
G = 2*h_fgo*A_fgboren;
H = h_ggo*A_ggon;
I = k_g4b*P;
J = 2*h_Bg*A_Bgn;

T0_g1b   = (A+B*T0_f1b2+C/E*(A+D+B*T0_f1b2+E*T0_f2b2))/(B+C+B*C/E); % in °C
T0_g2b   = (A+D+B*T0_f1b2-B*T0_g1b+E*T0_f2b2)/E; % in °C
T0_g1a   = (A+B*T0_f1a2+C/E*(A+D+B*T0_f1a2+E*T0_f2a2))/(B+C+B*C/E); % in °C
T0_g2a   = (A+D+B*T0_f1a2-B*T0_g1a+E*T0_f2a2)/E; % in °C

T0_g3a   = (F+G*T0_f2a2+H/J*(F+I+G*T0_f2a2+J*T0_Ba1))/(G+H+G*H/J); % in °C
T0_g4a   = (F+I+G*T0_f2a2-G*T0_g3a+J*T0_Ba1)/J; % in °C
T0_g3b   = (F+G*T0_f2b2+H/J*(F+I+G*T0_f2b2+J*T0_Bb1))/(G+H+G*H/J); % in °C
T0_g4b   = (F+I+G*T0_f2b2-G*T0_g3b+J*T0_Bb1)/J; % in °C



T0_BL    = T0_Ba2;

% power deposition fraction back calculations
% kk_g1b = m_g1b*Cp_g/P*(-2*h_fg*A_fgsleidn/m_g1b/Cp_g*(T0_f1b1-T0_g1b)-h_ggi*A_ggin/m_g1b/Cp_g*(T0_g2b-T0_g1b));
% kk_g2b = m_g2b*Cp_g/P*(-2*h_fg*A_fgsleodn/m_g2b/Cp_g*(T0_f2b1-T0_g2b)-h_ggi*A_ggin/m_g2b/Cp_g*(T0_g1b-T0_g2b));
% kk_g1a = m_g1a*Cp_g/P*(-2*h_fg*A_fgsleidn/m_g1a/Cp_g*(T0_f1a1-T0_g1a)-h_ggi*A_ggin/m_g1a/Cp_g*(T0_g2a-T0_g1a));
% kk_g2a = m_g2a*Cp_g/P*(-2*h_fg*A_fgsleodn/m_g2a/Cp_g*(T0_f2a1-T0_g2a)-h_ggi*A_ggin/m_g2a/Cp_g*(T0_g1a-T0_g2a));
% kk_g3a = m_g3a*Cp_g/P*(-2*h_fg*A_fgboren/m_g3a/Cp_g*(T0_f2a1-T0_g3a)-h_ggo*A_ggon/m_g3a/Cp_g*(T0_g4a-T0_g3a));
% kk_g4a = m_g4a*Cp_g/P*(-2*h_Bg*A_Bgn/m_g4a/Cp_g*(T0_Ba1-T0_g4a)-h_ggo*A_ggon/m_g4a/Cp_g*(T0_g3a-T0_g4a));
% kk_g3b = m_g3b*Cp_g/P*(-2*h_fg*A_fgboren/m_g3b/Cp_g*(T0_f2b1-T0_g3b)-h_ggo*A_ggon/m_g3b/Cp_g*(T0_g4b-T0_g3b));
% kk_g4b = m_g4b*Cp_g/P*(-2*h_Bg*A_Bgn/m_g4b/Cp_g*(T0_Bb1-T0_g4b)-h_ggo*A_ggon/m_g4b/Cp_g*(T0_g3b-T0_g4b));

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
mcp_s5   = 2.632E+00; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s6   = 2.632E+00; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
hA_s5 = 7.150E-01; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s6 = 7.150E-01; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C

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



