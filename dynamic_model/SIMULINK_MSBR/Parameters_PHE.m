% MSBR Primary Heat Exchanger Parameters

format shorte

clear; close all;clc;

phe_simtime = 1000; % simulation time (s)
phe_ts_max = 1e-1; % maximum timestep (s)
% ts_max = 'auto';

% PRIMARY FLOW PARAMETERS - DONE

W_p  = 1.414E3; % fuel flow rate (kg/s)
m_p  = 3.030e3; % fuel mass in PHE (kg)
nn_p = 4; % number of fuel nodes in PHE
mn_m = 1.414e3; % mass primary salt in mixing node (kg)
mn_p = (m_p-mn_m)/nn_p; % fuel mass per node (kg)
cp_p = 2.302E-3; % fuel heat capacity (MW-s/(kg-C)

% SECONDARY FLOW PARAMETERS - DONE

W_s  = 2.109E3; % coolant flow rate (kg/s)
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


% Primary Side - DONE

mcp_p1   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_p2   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_p3   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_p4   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C

hA_p1 = 3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
hA_p2 = 3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
hA_p3 = 3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C
hA_p4 = 3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/°C


% Tubes - DONE

mcp_t1   = 2.158; % (mass of material x heat capacity of material) of tubes per lump in MW-s/°C
mcp_t2   = 2.158; % (mass of material x heat capacity of material) of tubes per lump in MW-s/°C


% Secondary Side - DONE

mcp_s1   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s2   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s3   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C
mcp_s4   = mn_s*cp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/°C

hA_s1 = 5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s2 = 5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s3 = 5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C
hA_s4 = 5.929; % (tube to secondary heat transfer coeff x heat transfer area) in MW/°C


% Plotting

% figure;plot(tout,msbr_phe_SS(:,[7 13]));
% figure(1);title('PHE Exit Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('Primary','Secondary');
