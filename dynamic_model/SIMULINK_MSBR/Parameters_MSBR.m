%% Molten Salt Breeder Reactor Matlab/Simulink Model
%  University of Tennessee, 2016
%  Parameters and dynamic modeling equations come from ORNL-MSR-67-102 and
%  ORNL 4528

clear;close all;clc;
%% Neutronics
% Variables:
% U235
% Lam = 0.00033; % U235
% beta = [0.000215, 0.00142, 0.00127, 0.00257, 0.00075, 0.00027]; % U235
% lam = [0.0126, 0.0337, 0.139, 0.325, 1.13, 2.50]; % U235
% beta_t = sum(beta);
% C0 = lam.\beta/Lam;

% U233
% Lam = 0.00033;
% beta = [0.00023, 0.00079, 0.00067, 0.00073, 0.00013, 0.00009]; % U233
% lam = [0.0126, 0.0337, 0.139, 0.325, 1.13, 2.50]; % U235
% beta_t = sum(beta); % U233 system
% C0 = lam.\beta/Lam;

% MSBR - stationary
% Lam  = 3.300E-04;  % mean generation time
% lam = [1.260E-02, 3.370E-02, 1.390E-01, 3.250E-01, 1.130E+00, 2.500E+00]; 
% beta = [2.290E-04, 8.320E-04, 7.100E-04, 8.520E-04, 1.710E-04, 1.020E-04];
% beta_t = sum(beta); % total delayed neutron fraction MSBR
% C0 = lam.\beta/Lam; % delayed neutron precursor concentration initial values (IRIS matrix inversion method: lam.\beta/Lam)
% C0 = [55.0746, 74.8134, 15.4785, 7.9441, 0.4586, 0.1236]; % delayed neutron precursor concentration initial values (IRIS matrix inversion method: lam.\beta/Lam)

% MSBR - circulating
format shorte

n_frac0 = 1; % initial fractional nuetron density n/n0 (n/cm^3/s)

a_f   = -0.00008172; % fuel temperature feedback coefficient
a_g   =  0.00002016; % graphite temperature feedback coefficient
a_b   =  0.00001656; % fertile temperature feedback coefficient
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
% % 100 n/s for 50 seconds
% sourcedata = [0 100 0];
% sourcetime = [0 50 100];

source = timeseries(sourcedata,sourcetime);

% REACTIVITY INSERTION
% No reactivity insertion
simtime = 1000;
reactdata = [0 0 0];
reacttime = [0 50 100];
% % Periodic 60 PCM for 50 seconds
% simtime = 700;
% periodic = [0, 0; 50, 6e-5; 100, 0; 150, -6e-5; 200, 0; 250, 6e-5; 300, 0; 350, -6e-5; 400, 0]; 
% reactdata = periodic(:,2);
% reacttime = periodic(:,1);
% % Step up 60 pcm for 10 sec
% simtime = 510;
% reactdata = [0 6e-4];
% reacttime = [0 500];
% % Step down -60 pcm for 10 sec
% simtime = 510;
% reactdata = [0 -6e-4];
% reacttime = [0 500];
% % Pulse 600 pcm for 0.1 sec
% simtime = 1000;
% reactdata = [0 6e-3 0];
% reacttime = [0 500 500.1];

react = timeseries(reactdata,reacttime);

% sim msbr_pke_circ.slx
% figure;plot(tout,pke_circ_mux(:,2));
% figure;plot(tout,pke_circ_mux(:,[3 5 7 9 11 13]));
% figure(1);title('n/n_0');
% figure(2);title('Precursor Concentrations');

% lam1 = 1.260E-02; % decay constant for delayed neutron precursor group 1
% lam2 = 3.370E-02; % decay constant for delayed neutron precursor group 2
% lam3 = 1.390E-01; % decay constant for delayed neutron precursor group 3
% lam4 = 3.250E-01; % decay constant for delayed neutron precursor group 4
% lam5 = 1.130E+00; % decay constant for delayed neutron precursor group 5
% lam6 = 2.500E+00; % decay constant for delayed neutron precursor group 6
% beta_1 = 2.290E-04; % 1st group delayed neutron fraction MSBR
% beta_2 = 8.320E-04; % 2nd group delayed neutron fraction MSBR
% beta_3 = 7.100E-04; % 3rd group delayed neutron fraction MSBR
% beta_4 = 8.520E-04; % 4th group delayed neutron fraction MSBR
% beta_5 = 1.710E-04; % 5th group delayed neutron fraction MSBR
% beta_6 = 1.020E-04; % 6th group delayed neutron fraction MSBR

%% Core heat transfer
% Core upflow
% Variables:
t_g1; % temperature of graphite in lump g1
t_f1; % temperature of fuel in lump f1
t_f2; % temperature of fuel in lump f2
t_in; % temperature going into node f1
P; % total power

m_gf = ; % mass of graphite in fuel loop
n_gf = ; % number of graphite nodes in fuel loop
cp_gf = ; % heat capacity of graphite in fuel loop
% mcp_g1 = 14.03; % (mass of material) x (specific heat capacity of material) of graphite per lump
% mcp_f1 = 0.2748; % (mass of material) x (specific heat capacity of material) of fuel per lump
% mcp_f2 = 0.2748;

hA_fg_up = 1.73; % (fuel to graphite heat transfer coefficient) x (heat transfer area)
k_g1 = 0.033; % fraction of total power generated in the graphite lump
k_1 = .5; % fraction of the heat transferred from the graphite which goes to the first fuel lump
k_2 = .5; % fraction of the heat transferred from the graphite which goes to the second fuel lump
k_f1 = .221; % fraction of total power generated in lump f1
k_f2 = .221; % fraction of total power generated in lump f2
W_f = ; % fuel flow rate (kg/s)
m_f = ;

m_fn = m_f/nn_f;

tau_1 = 0.84; % transfer time (?)
tau_2 = 0.84; % transfer time (?)


% Equations:
ddt_t_g1 = hA_fg_up/mcp_g1*(t_f1-t_g1)+k_g1/mcp_g1*P;
ddt_t_f1 = W_f/m_fn*(t_in-t_f1)+k_f1*P/mcp_f1+k_1*hA_fg_up/mcp_f1*(t_g1-t_f1);
ddt_t_f2 = W_f/m_fn*(t_f1-t_f2)+k_f2*P/mcp_f2+k_2*hA_fg_up/mcp_f2*(t_g1-t_f1);


% Core downflow
% Variables:
t_g2; % temperature of graphite in lump g2
t_f2; % temperature of fuel in lump f2
t_f3; % temperature of fuel in lump f3
t_f4; % temperature going into node f4
P; % total power


mcp_g2 = 14.03; % (mass of material) x (specific heat capacity of material) of graphite per lump
mcp_f3 = 0.2748; % (mass of material) x (specific heat capacity of material) of fuel per lump
mcp_f4 = 0.2748;
hA_fg_down = 1.123; % (fuel to graphite heat transfer coefficient) x (heat transfer area)
k_g1 = 0.033; % fraction of total power generated in the graphite lump
k_3 = .5; % fraction of the heat transferred from the graphite which goes to the first fuel lump
k_4 = .5; % fraction of the heat transferred from the graphite which goes to teh second fuel lump
k_f3 = .221; % fraction of total power generated in lump f1
k_f4 = .221; % fraction of total power generated in lump f2
tau_3 = 0.84; % transfer time (?)
tau_4 = 0.84; % transfer time (?)


% Equations:
ddt_t_g2 = hA_fg_down/mcp_g2*(t_f3-t_g2)+k_g2*P/mcp_g2;
ddt_t_f3 = 1/tau_3*(t_f2-t_f3)+k_3*hA_fg_down/mcp_f3*(t_g2-t_f3);
ddt_t_f4 = 1/tau_4*(t_f3-t_f4)+k_4*hA_fg_down/mcp_f4*(t_g2-t_f3);


% Fertile stream
% Variables:
t_g3; % temperature of graphite in lump g3
t_b1; % temperature of salt in lump b1
t_b2; % temperature of salt in lump b2
t_bin; % temperature going into node b1
P; % total power


mcp_g3 = 3.485; % (mass of material) x (specific heat capacity of material) x (fraction transferring heat to fertile stream)
mcp_b1 = 1.733; % (mass of material) x (specific heat capacity of material) of salt per lump
mcp_b2 = 1.733;
hA_bg = 1.054; % (salt to graphite heat transfer coefficient) x (heat transfer area)
k_g3 = 0.00814; % fraction of total power generated in the graphite lump
k_1b = .5; % fraction of the heat transferred from the graphite which goes to the first salt lump
k_2b = .5; % fraction of the heat transferred from the graphite which goes to the second salt lump
k_b1 = .0085; % fraction of total power generated in lump b1
k_b2 = .0085; % fraction of total power generated in lump b2
tau_b1 = 7.0; % transfer time (?)
tau_b2 = 7.0; % transfer time (?)


% Equations:
ddt_t_g3 = hA_bg/mcp_g3*(t_b1-t_g3)+k_g3/mcp_g3*P;
ddt_t_b1 = 1/tau_b1*(t_bin-t_b1)+k_b1/mcp_b1*P+k_1b*hA_bg/mcp_b1*(t_g3-t_b1);
ddt_t_b2 = 1/tau_b2*(t_b1-t_b2)+k_b2/mcp_b2*P+k_2b*hA_bg/mcp_b2*(t_g3-t_b1);


%% Fuel salt/primary heat exchanger
% Variables:
t_p1; %    tempreature of the fuel salt in lump 1 of the primary heat exchanger
t_p2; %    tempreature of the fuel salt in lump 2 of the primary heat exchanger
t_pl; %    temperature of the fuel salt in the mixing plenum
t_p3; %    tempreature of the fuel salt in lump 3 of the primary heat exchanger
t_p4; %    tempreature of the fuel salt in lump 4 of the primary heat exchanger
t_t1;
t_t2;
t_s1; % temperature of the coolant salt in lump 1 of the primary heat exchanger
t_s2; %    temperature of the coolant salt in lump 2 of the primary heat exchanger
t_s3; %    temperature of the coolant salt in lump 3 of the primary heat exchanger
t_s4; %    temperature of the coolant salt in lump 4 of the primary heat exchanger
t_pin; % temperature of the fuel salt entering the heat exchanger
t_sin; % temperature of the coolant salt entering the heat exchanger
t_pin = t_f4*(t-1.32); % component coupling


[hA_p1, hA_p2, hA_p3, hA_p4] = MANY(2.97); %    heat transfer coefficient
[hA_s1, hA_s2, hA_s3, hA_s4] = MANY(5.94); %    heat transfer coefficient
[mcp_p1, mcp_p2, mpc_p3, mcp_p4] = MANY(3.452); %    mass of material x specific heat for node pi
[mcp_t1, mcp_t2] = MANY(2.16); % mass of material x specific heat for node ti
[mcp_s1, mcp_s2, mcp_s3, mcp_s4] = MANY(6.75); %    mass of material x specific heat for node si
[tau_p1, tau_p2, tau_p3, tau_p4] = MANY(0.5); % residence time in lump pi
tau_pl = 1.0; % residence time in lump pl
[tau_s1, tau_s2, tau_s3, tau_s4] = MANY(1.9); % residence time in lump si


% Equations:
ddt_t_p1 = 1/tau_p1*(t_pin-t_p1)-hA_p1/mcp_p1*(t_p1-t_t1);
ddt_t_p2 = 1/tau_p2*(t_p1-t_p2)-hA_p2/mcp_p2*(t_p1-t_t1);
ddt_t_pl = 1/tau_pl*(t_p2-t_pl);
ddt_t_p3 = 1/tau_p3*(t_pl-t_p3)-hA_p3/mcp_p3*(t_p3-t_t2);
ddt_t_p4 = 1/tau_p4*(t_p3-t_p4)-hA_p4/mcp_p4*(t_p3-t_p2);
ddt_t_t1 = 2*hA_p1/mcp_t1*(t_p1-t_t1)-2*hA_s3/mcp_t1*(t_t1-t_s3);
ddt_t_t2 = 2*hA_p3/mcp_t2*(t_p3-t_t2)-2*hA_s1/mcp_t2*(t_t2-t_s1);
ddt_t_s1 = 1/tau_s1*(t_sin-t_s1)-hA_s1/mcp_s1*(t_s1-t_t2);
ddt_t_s2 = 1/tau_s2*(t_s1-t_s2)-hA_s2/mcp_s2*(t_s1-t_t2);
ddt_t_s3 = 1/tau_s3*(t_s2-t_s3)-hA_s3/mcp_s3*(t_s3-t_t1);
ddt_t_s4 = 1/tau_s4*(t_s3-t_s4)-hA_s4/mcp_s4*(t_s3-t_t1); % I changed some of the constants to s4




%% Blanket salt/fertile heat exchanger
% Variables:
t_pbin;
t_pb1;
t_pb2;
t_tb;
t_s5;
t_s6;
t_s5in;


hA_pb1 = 0.72;
hA_pb2 = 0.72;
hA_pb = hA_pb1; % (???)
hA_s5 = 0.72;
hA_s6 = 0.72;
hA_s = hA_s5; % (???)
mcp_pb1 = 0.396;
mcp_pb2 = 0.396;
mcp_s5 = 2.7;
mcp_s6 = 2.7;
mcp_tb = 0.522;
tau_pb1 = 0.8;
tau_pb2 = 0.8;
tau_s5 = 0.74;
tau_s6 = 0.74;


% Equations:
ddt_t_pb1 = 1/tau_pb1*(t_pbin-t_pb1)-hA_pb1/mcp_pb1*(t_pb1-t_tb); % changed wcp to mcp
ddt_t_pb2 = 1/tau_pb2*(t_pb1-t_pb2)-hA_pb2/mcp_pb2*(t_pb1-t_tb); % changed wcp to mcp
ddt_t_tb = 2*hA_pb/mcp_tb*(t_tb1-t_tb)-2*hA_s/mcp_tb*(t_tb-t_s5);
ddt_t_s5 = 1/tau_s5*(t_s5in-t_s5)+hA_s5/mcp_s5*(t_tb-t_s5);
ddt_t_s6 = 1/tau_s6*(t_s5-t_s6)+hA_s6/mcp_s6*(t_tb-t_s5);




%% Boiler and reheater
% Variables:
t_bin; % salt temperature at boiler inlet
t_b; % temperature of salt in the boiler
t_rin; % salt temperature at reheater inlet
t_r; % temperature of salt in the reheater
p_b = 0.87*P; % power removed from salt in the bioler
p_r = 0.13*P; % power removed from salt in the reheater


mcp_b = 32.97; % mass x specific heat of salt in the boiler
mcp_r = 10.5; % mass x specific heat of salt in the reheater
tau_b = 10.4; % residence time of salt in the boiler
tau_r = 22.0; % residence time of salt in the rehehater


% Equations:
ddt_t_b = 1/tau_b*(t_bin-t_b)-p_b/mb_cpb; % changed t_b to tau_b
ddt_t_r = 1/tau_r*(t_rin-t_r)-p_r/mr_cpr;


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