figure;plot(tout,msbr_core_mux(:,4));%,tout,power_demand);grid on;legend('Core Power','Demand Power','location','southeast');
figure(2);plot(tout,msbr_core_mux(:,[5 7 9 11 13 15]));
figure(3);plot(tout,msbr_core_mux(:,[17 18 19 20]));
figure(4);plot(tout,msbr_core_mux(:,[21 22 23 24]));
figure(5);plot(tout,msbr_core_mux(:,[25 26 27 28]));
figure(6);plot(tout,msbr_core_mux(:,[29 30 31 32]));
figure(7);plot(tout,msbr_core_mux(:,[33 34 35 36]));
figure(8);plot(tout,msbr_core_mux(:,[38 39]));

figure(1);title('n/n_0');xlabel('Time (s)');ylabel('Fractional Power');
figure(2);title('Precursor Concentrations');xlabel('Time (s)');ylabel('Ci/n0');legend('C1','C2','C3','C4','C5','C6');
figure(3);title('Fuel Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('f1b1','f1b2','f1a1','f1a2');
figure(4);title('Graphite Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('g1b','g2b','g1a','g2a');
figure(5);title('Fuel Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('f2a1','f2a2','f2b1','f2b2');
figure(6);title('Graphite Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('g3a','g4a','g3b','g4b');
figure(7);title('Fertile Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('Bb1','Bb2','Ba1','Ba2');
figure(8);title('Blanket Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('BL','Bm');

figure;plot(tout,msbr_core_mux(:,4),tout,power_demand,tout,measured_react_power);grid on;legend('Core Power','Demand Power','Measured Power','location','southeast');

figure;plot(tout,msbr_br_mux(:,[3 6 7 8 9]));legend('Tb','Tr','tauR','tauB','mix');
figure;plot(tout,msbr_core_mux(:,3));

figure;plot(tout,rho_ext)

%%useful formulae

total_core_power = W_f*Cp_f*(msbr_core_mux(end,17)-Tf_in) + W_B*Cp_B*(msbr_core_mux(end,36)-T_b_in) + W_BL*Cp_B*(msbr_core_mux(end,38)-T_b_in);

% fuel power across core and phe
P_fcore = W_f*Cp_f*(msbr_core_mux(end,17)-msbr_core_mux(end,1));
P_fphe  = W_f*Cp_f*(msbr_phe_mux(end,1)-msbr_phe_mux(end,7));

% coolant power across phe
P_sphe  = W_s*cp_s*(msbr_phe_mux(end,13)-msbr_phe_mux(end,2));

% fertile power across core and bhe
P_Bcore = W_B*Cp_B*(msbr_core_mux(end,36) - msbr_core_mux(end,2)) + W_BL*Cp_B*(msbr_core_mux(end,38)- msbr_core_mux(end,2));
P_Bbhe  = W_pb*Cp_B*(msbr_bhe_mux(end,2) - msbr_bhe_mux(end,4));

% coolant power across bhe
P_sbhe  = W_s*cp_s*(msbr_bhe_mux(end,7)-msbr_bhe_mux(end,1));