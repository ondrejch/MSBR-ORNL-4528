% Parameters msbr_pke_stat

Lam  = 3.300E-04;  % mean generation time
lam = [1.260E-02, 3.370E-02, 1.390E-01, 3.250E-01, 1.130E+00, 2.500E+00]; 
beta = [2.290E-04, 8.320E-04, 7.100E-04, 8.520E-04, 1.710E-04, 1.020E-04];
beta_t = 2.896E-03; % total delayed neutron fraction MSBR
C0 = lam.\beta/Lam; % delayed neutron precursor concentration initial values (IRIS matrix inversion method: lam.\beta/Lam)
% C0 = [55.0746, 74.8134, 15.4785, 7.9441, 0.4586, 0.1236]; % delayed neutron precursor concentration initial values (IRIS matrix inversion method: lam.\beta/Lam)

n_frac0 = 1; % initial fractional nuetron density n/n0 (n/cm^3/s)