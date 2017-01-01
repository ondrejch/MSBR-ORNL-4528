// SETTING MAX STACKSIZE FOR BUFFER
stacksize('max');

clear;

// EXTERNAL REACTIVITY AND SOURCE INPUTS

// Create the variable to load from
R.time   = [0,50,100]'; //the values must be in a column vector
R.values = [0,6e-4,0]';

S.time   = [0]'; //the values must be in a column vector
S.values = [0]';


// FUEL PARAMETERS

// U233
//L = 0.00033;
//bet1 = 0.00023; bet2 = 0.00079; bet3 = 0.00067; bet4 = 0.00073; bet5 = 0.00013; bet6 = 0.00009;
//B = bet1 + bet2 + bet3 + bet4 + bet5 + bet6;
//lam1 = 0.0126; lam2 = 0.0337; lam3 = 0.139; lam4 = 0.325; lam5 = 1.13; lam6 = 2.50;


// U235
//L = 0.00033;
//bet1 = 2.15E-4; bet2 = 0.00142; bet3 = 0.00127; bet4 = 0.00257; bet5 = 7.5E-4; bet6 = 2.7E-4;
//B = bet1 + bet2 + bet3 + bet4 + bet5 + bet6;
//lam1 = 0.0126; lam2 = 0.0337; lam3 = 0.139; lam4 = 0.325; lam5 = 1.13; lam6 = 2.50;


// MSBR
L = 0.00033;
bet1 = 2.29E-4; bet2 = 8.32E-4; bet3 = 7.1E-4; bet4 = 8.52E-4; bet5 = 1.71E-4; bet6 = 1.02E-4;
B = bet1 + bet2 + bet3 + bet4 + bet5 + bet6;
lam1 = 0.0126; lam2 = 0.0337; lam3 = 0.139; lam4 = 0.325; lam5 = 1.13; lam6 = 2.50;


// Core neutronics parameters calculations
bet = [bet1, bet2, bet3, bet4, bet5, bet6]; // Fuel-specific delayed neutron fractions
lam = [lam1, lam2, lam3, lam4, lam5, lam6]; // Decay constants of the 6 precursor groups
t_C  = 3.28; t_L = 5.85; // Core and loop fuel transit times

rho_0 = 0; 
for i = 1:6
    rho_0 = rho_0 + bet(i)/(1.0 + (1.0-exp(-lam(i)*t_L))/(lam(i)*t_C));
end
react = B - rho_0; // Reactivity change in going from stationary to circulating fuel

nt    = 1.0;
Ct(1) = ((bet(1)*nt)/L)*(1.0/(lam(1) - (exp(-lam(1)*t_L) - 1.0)/t_C));
Ct(2) = ((bet(2)*nt)/L)*(1.0/(lam(2) - (exp(-lam(2)*t_L) - 1.0)/t_C));
Ct(3) = ((bet(3)*nt)/L)*(1.0/(lam(3) - (exp(-lam(3)*t_L) - 1.0)/t_C));
Ct(4) = ((bet(4)*nt)/L)*(1.0/(lam(4) - (exp(-lam(4)*t_L) - 1.0)/t_C));
Ct(5) = ((bet(5)*nt)/L)*(1.0/(lam(5) - (exp(-lam(5)*t_L) - 1.0)/t_C));
Ct(6) = ((bet(6)*nt)/L)*(1.0/(lam(6) - (exp(-lam(6)*t_L) - 1.0)/t_C));
y0    = [nt;Ct]'; // Initial conditions 


// CORE HEAT TRANSFER PARAMETERS
W_f  = 1.414E+03; // fuel flow rate (kg/s)
m_f  = 4.776E+02; // fuel mass in core (kg)
nn_f = 4.000E+00; // number of fuel nodes in core
mn_f =  m_f/nn_f;  // fuel mass per node (kg)


// Feedback co-efficients
a_f   = -8.172E-05; // fuel temperature feedback coefficient in drho/°C
a_g   =  2.016E-05; // graphite temperature feedback coefficient in drho/°C
a_b   =  1.656E-05; // fertile temperature feedback coefficient in drho/°C


// Initial conditions
T0_f1  = 579.44; // in °C
T0_f2  = 621.11; // in °C
T0_f3  = 662.77; // in °C
T0_f4  = 704.44; // in °C

T0_b1  = 648.88; // in °C
T0_b2  = 676.66; // in °C

T0_g1  = 590.00; // in °C
T0_g2  = 673.33; // in °C
T0_g3  = 652.77; // in °C

Tf_in  = 537.77; // in °C
T_b_in = 621.11; // in °C
P      = 556.00; // Thermal Power in MW


// Core Upflow
mcp_g1   = 1.403E+01; // (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f1   = 2.748E-01; // (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f2   = 2.748E-01; // (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
hA_fg_up = 1.733E+00; // (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g1     = 3.300E-02; // fraction of total power generated in the graphite lump
k_1      = 5.000E-01; // fraction of heat transferred from graphite which goes to first fuel lump
k_2      = 5.000E-01; // fraction of heat transferred from graphite which goes to second fuel lump
k_f1     = 2.210E-01; // fraction of total power generated in lump f1
k_f2     = 2.210E-01; // fraction of total power generated in lump f2
tau_1    = mn_f/W_f;  // 8.400E-01; // residence time in lump f1 in s
tau_2    = mn_f/W_f;  // 8.400E-01; // residence time in lump f2 in s


// Core downflow
mcp_g2   = 1.403E+01; // (mass of material x heat capacity of material) of graphite per lump in MW-s/°C
mcp_f3   = 2.748E-01; // (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
mcp_f4   = 2.748E-01; // (mass of material x heat capacity of material) of fuel salt per lump in MW-s/°C
hA_fg_dn = 1.123E+00; // (fuel to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g2     = 3.300E-02; // fraction of total power generated in the graphite lump
k_3      = 5.000E-01; // fraction of heat transferred from graphite which goes to third fuel lump
k_4      = 5.000E-01; // fraction of heat transferred from graphite which goes to fourth fuel lump
k_f3     = 2.210E-01; // fraction of total power generated in lump f3
k_f4     = 2.210E-01; // fraction of total power generated in lump f4
tau_3    = mn_f/W_f;  // 8.400E-01; // residence time in lump f3 in s
tau_4    = mn_f/W_f;  // 8.400E-01; // residence time in lump f4 in s


// Fertile stream
mcp_g3   = 3.467E+00; // (mass of material x heat capacity of material x fraction tranferring heat to fertile stream)in MW-s/°C
mcp_b1   = 1.733E+00; // (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
mcp_b2   = 1.733E+00; // (mass of material x heat capacity of material) of blanket salt per lump MW-s/°C
hA_bg    = 1.054E+00; // (salt to graphite heat transfer coeff x heat transfer area) in MW/°C
k_g3     = 8.140E-03; // fraction of total power generated in the graphite lump
k_1b     = 5.000E-01; // fraction of heat transferred from graphite which goes to blanket salt lump b1
k_2b     = 5.000E-01; // fraction of heat transferred from graphite which goes to blanket salt lump b2
k_b1     = 8.500E-03; // fraction of total power generated in lump b1
k_b2     = 8.500E-03; // fraction of total power generated in lump b2
tau_b1   = 6.998E+00; // residence time in lump b1 in s
tau_b2   = 6.998E+00; // residence time in lump b2 in s


// PRIMARY HEAT EXCHANGER (Fuel salt)

// PRIMARY FLOW PARAMETERS
W_p  = 1.414E+03; // fuel flow rate in kg/s
m_p  = 3.030E+03; // fuel mass in PHE (kg)
nn_p = 4.000E+00; // number of fuel nodes in PHE
mn_p =  m_p/nn_p; // fuel mass per node (kg)
mn_m = 1.414E+03; // mass primary salt in mixing node (kg)
cp_p = 2.302E-03; // fuel heat capacity (MW-s/(kg-C))

// SECONDARY FLOW PARAMETERS
W_s  = 2.181E+03; // coolant flow rate (kg/s)
m_s  = 1.588E+04; // coolant mass in PHE (kg)
nn_s = 4.000E+00; // number of coolant nodes in PHE
mn_s =  m_s/nn_s; // coolant mass per node (kg)
cp_s = 1.714E-03; // coolant heat capacity (MW-s/(kg-C)


// Initial conditions
Tp_in  = 704.440; // in °C
Ts_in  = 454.444; // in °C

T0_p1  = Tp_in - 41.6675; // in °C
T0_p2  = Tp_in - 2*41.6675; // in °C
T0_p3  = Tp_in - 3*41.6675; // in °C
T0_p4  = 537.77; // in °C
T0_pl  = T0_p2; // in °C

T0_t1  = 596.87; // in °C
T0_t2  = 520.71; // in °C

T0_s1  = Ts_in + 36.25; // in °C
T0_s2  = Ts_in + 2*36.25; // in °C
T0_s3  = Ts_in + 3*36.25; // in °C
T0_s4  = 599.4444; // in °C

A = 2*4.584E+02; // area for heat transfer (primary and secondary, m^2)
h_overall=0.975*P/A/((Tp_in+T0_p4)/2-(Ts_in+T0_s4)/2)*2;

h_p = 1.306E-02; // heat transfer coefficient from primary to tubes
h_s = 2.555E-02; // heat transfer coefficient from tubes to secondary

// Primary side
mcp_p1   = mn_p*cp_p; // (mass of material x heat capacity of material) of fuel salt lump 1 in MW-s/°C
mcp_p2   = mn_p*cp_p; // (mass of material x heat capacity of material) of fuel salt lump 2 in MW-s/°C
mcp_p3   = mn_p*cp_p; // (mass of material x heat capacity of material) of fuel salt lump 3 in MW-s/°C
mcp_p4   = mn_p*cp_p; // (mass of material x heat capacity of material) of fuel salt lump 4 in MW-s/°C
hA_p1    = h_p*A/4; // (heat transfer coeff x heat transfer area) of fuel salt lump 1 in MW/°C
hA_p2    = h_p*A/4; // (heat transfer coeff x heat transfer area) of fuel salt lump 2 in MW/°C
hA_p3    = h_p*A/4; // (heat transfer coeff x heat transfer area) of fuel salt lump 3 in MW/°C
hA_p4    = h_p*A/4; // (heat transfer coeff x heat transfer area) of fuel salt lump 4 in MW/°C

// Tubes
mcp_t1   = 2.158E+00; // (mass of material x heat capacity of material) of tube node 1 in MW-s/°C
mcp_t2   = 2.158E+00; // (mass of material x heat capacity of material) of tube node 2 in MW-s/°C

// Secondary side
mcp_s1   = mn_s*cp_s; // (mass of material x heat capacity of material) of coolant salt lump 1 in MW-s/°C
mcp_s2   = mn_s*cp_s; // (mass of material x heat capacity of material) of coolant salt lump 2 in MW-s/°C
mcp_s3   = mn_s*cp_s; // (mass of material x heat capacity of material) of coolant salt lump 3 in MW-s/°C
mcp_s4   = mn_s*cp_s; // (mass of material x heat capacity of material) of coolant salt lump 4 in MW-s/°C
hA_s1    = h_s*A/4; // (heat transfer coeff x heat transfer area) of coolant salt lump 1 in MW/°C
hA_s2    = h_s*A/4; // (heat transfer coeff x heat transfer area) of coolant salt lump 2 in MW/°C
hA_s3    = h_s*A/4; // (heat transfer coeff x heat transfer area) of coolant salt lump 3 in MW/°C
hA_s4    = h_s*A/4; // (heat transfer coeff x heat transfer area) of coolant salt lump 4 in MW/°C

tau_p1   = 5.260E-01; // residence time in lump p1 in s
tau_p2   = 5.260E-01; // residence time in lump p2 in s
tau_pl   = 1.000E+00; // residence time in mixing plenum in s
tau_p3   = 5.000E-01; // residence time in lump p3 in s
tau_p4   = 5.000E-01; // residence time in lump p4 in s
tau_s1   = 1.882E+00; // residence time in lump s1 in s
tau_s2   = 1.882E+00; // residence time in lump s2 in s
tau_s3   = 1.882E+00; // residence time in lump s3 in s
tau_s4   = 1.882E+00; // residence time in lump s4 in s


// FERTILE (SECONDARY) HEAT EXCHANGER 

// Initial conditions

T0_s5  = 603.33;
T0_s6  = 607.22;
T0_pb1 = 648.88;
T0_pb2 = 676.66; // fertile exit temp °C
T0_tb  =  633.6967; // tube temp

mcp_pb1  = 3.967E-01; // (mass of material x heat capacity of material) of blanket salt lump 1 in MW-s/°C
mcp_pb2  = 3.967E-01; // (mass of material x heat capacity of material) of blanket salt lump 2 in MW-s/°C
mcp_tb   = 5.141E-01; // (mass of material x heat capacity of material) of transfer lump in MW-s/°C
mcp_s5   = 2.632E+00; // (mass of material x heat capacity of material) of coolant salt lump 5 in MW/°C
mcp_s6   = 2.632E+00; // (mass of material x heat capacity of material) of coolant salt lump 6 in MW/°C
hA_pb1   = 7.150E-01; // (heat transfer coeff x heat transfer area) of blanket salt lump 1 in MW/°C
hA_pb2   = 7.150E-01; // (heat transfer coeff x heat transfer area) of blanket salt lump 2 in MW/°C
hA_pb    = 1.430E+01; // (average heat transfer coeff x heat transfer area) of blanket salt in MW/°C
hA_s     = 1.430E+01; // (average heat transfer coeff x heat transfer area) of coolant salt in MW/°C
hA_s5    = 7.150E-01; // (heat transfer coeff x heat transfer area) of coolant salt lump 3 in MW/°C
hA_s6    = 7.150E-01; // (heat transfer coeff x heat transfer area) of coolant salt lump 4 in MW/°C
tau_pb1  = 7.983E-01; // residence time in lump p5 in s
tau_pb2  = 7.983E-01; // residence time in lump p6 in s
tau_s5   = 7.446E-01; // residence time in lump s5 in s
tau_s6   = 7.446E-01; // residence time in lump s6 in s


// BOILER AND REHEATER
mn_ms = mn_m; // mass salt in mixing node (kg)
p_b = 0.87*P; // power removed by boiler (MW)
p_r = 0.13*P; // power removed by reheater (MW)

tau_r = 22.09; // resident time in reheater (sec)
tau_b = 10.43; // resident time in boiler (sec)

W_sb = (1-0.133)*W_s; // Coolant salt flow through boiler (kg/s)
W_sr = 0.133*W_s; // Coolant salt flow through reheater (kg/s)
mb_cpb = 3.297E+01;
mr_cpr = 1.050E+01;
 
 
// PURE TIME DELAYS BETWEEN COMPONENTS

tau_fhx_c = 1.22; // (sec) delay from fuel hx to core
tau_c_fhx = 1.32; // (sec) delay from core to fuel hx
tau_fhx_fehx = 7.88; // (sec) fuel hx to fertile hx
tau_fehx_c = 7.0; // (sec) fertile hx to core
tau_c_fehx = 7.0; // (sec) core to fertile hx
tau_fehx_b = 13.5; // (sec) fertile hx to boiler
tau_fehx_r = 17.3; // (sec) fertile hx to reheater
tau_b_fhx = 4.2; // (sec) boiler to fuel hx
tau_r_fhx = 11.1; // (sec) reheater to fuel hx
