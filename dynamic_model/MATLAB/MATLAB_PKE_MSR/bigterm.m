% Calculate the big term from rho_0 equation.
function rho_0=bigterm(bet,lam,L,t_L,t_C)
    rho_0 = 0;
    for i = 1:6
        rho_0 = rho_0 + bet(i)/(1.0 + (1.0-exp(-lam(i)*t_L))/(lam(i)*t_C));
    end
end