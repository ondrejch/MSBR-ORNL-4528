figure;plot(tout,msbr_core_mux(:,4),tout,power_demand);grid on;legend('Core Power','Demand Power','location','southeast');
figure;plot(tout,msbr_core_mux(:,[5 7 9 11 13 15]));
figure;plot(tout,msbr_core_mux(:,[17 20 23]));
figure;plot(tout,msbr_core_mux(:,[18 19 21 22]));
figure;plot(tout,msbr_core_mux(:,[24 25]));
figure(1);title('n/n_0');xlabel('Time (s)');ylabel('Fractional Power');
figure(2);title('Precursor Concentrations');xlabel('Time (s)');ylabel('Ci/n0');legend('C1','C2','C3','C4','C5','C6');
figure(3);title('Graphite Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('G1','G2','G3');
figure(4);title('Fuel Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('F1','F2','F3','F4');
figure(5);title('Fertile Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('B1','B2');



figure;plot(tout,msbr_br_mux(:,[3 6 7 8 9]));legend('Tb','Tr','tauR','tauB','mix');
figure;plot(tout,msbr_core_mux(:,3));

figure;plot(tout,rho_ext)
