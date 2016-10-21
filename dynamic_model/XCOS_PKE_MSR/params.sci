// Create the variable to load from
R.time = [0,100,150,200]'; //the values must be in a column vector
R.values = [0,0,0,0]';

S.time = [0,100,150,200]'; //the values must be in a column vector
S.values = [0,100,0,0]';

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

bet = [bet1,bet2,bet3,bet3,bet5,bet6];
lam = [lam1,lam2,lam3,lam4,lam5,lam6];
t_C  = 3.28; t_L = 5.85;
rho_0 = 0;
for i = 1:6
    rho_0 = rho_0 + bet(i)/(1.0 + (1.0-exp(-lam(i)*t_L))/(lam(i)*t_C));
end
react = B -rho_0;
nt    = 1.0;
Ct(1) = ((bet(1)*nt)/L)*(1.0/(lam(1) - (exp(-lam(1)*t_L) - 1.0)/t_C));
Ct(2) = ((bet(2)*nt)/L)*(1.0/(lam(2) - (exp(-lam(2)*t_L) - 1.0)/t_C));
Ct(3) = ((bet(3)*nt)/L)*(1.0/(lam(3) - (exp(-lam(3)*t_L) - 1.0)/t_C));
Ct(4) = ((bet(4)*nt)/L)*(1.0/(lam(4) - (exp(-lam(4)*t_L) - 1.0)/t_C));
Ct(5) = ((bet(5)*nt)/L)*(1.0/(lam(5) - (exp(-lam(5)*t_L) - 1.0)/t_C));
Ct(6) = ((bet(6)*nt)/L)*(1.0/(lam(6) - (exp(-lam(6)*t_L) - 1.0)/t_C));
y0 = [nt;Ct]';
