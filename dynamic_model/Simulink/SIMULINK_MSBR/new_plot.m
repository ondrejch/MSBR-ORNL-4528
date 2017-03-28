figure(1);plot(tout,msbr_core_mux(:,4));grid on;
figure(2);plot(tout,msbr_core_mux(:,[5 7 9 11 13 15]));
figure(3);plot(tout,msbr_core_mux(:,[17 18 19 20]));
figure(4);plot(tout,msbr_core_mux(:,[21 22 23 24]));
figure(5);plot(tout,msbr_core_mux(:,[25 26 27 28]));
figure(6);plot(tout,msbr_core_mux(:,[29 30 31 32]));
figure(7);plot(tout,msbr_core_mux(:,[33 34 35 36]));
figure(8);plot(tout,msbr_core_mux(:,[38 39]));

figure(1);title('n/n_0');xlabel('Time (s)');ylabel('Fractional Power');
figure(2);title('Precursor Concentrations');xlabel('Time (s)');ylabel('Ci/n0');legend('C1','C2','C3','C4','C5','C6');
figure(3);xlabel('Time (s)');ylabel('Temperature (\circC)');legend('f1b1','f1b2','f1a1','f1a2');%title('Fuel Temperatures');
figure(4);xlabel('Time (s)');ylabel('Temperature (\circC)');legend('g1b','g2b','g1a','g2a');%title('Graphite Temperatures');
figure(5);xlabel('Time (s)');ylabel('Temperature (\circC)');legend('f2a1','f2a2','f2b1','f2b2');%title('Fuel Temperatures');
figure(6);xlabel('Time (s)');ylabel('Temperature (\circC)');legend('g3a','g4a','g3b','g4b');%title('Graphite Temperatures')
figure(7);xlabel('Time (s)');ylabel('Temperature (\circC)');legend('Bb1','Bb2','Ba1','Ba2');%title('Fertile Temperatures');
figure(8);xlabel('Time (s)');ylabel('Temperature (\circC)');legend('BL','Bm');%title('Blanket Temperatures');

y = (P*msbr_core_mux(:,4))-1.0279887316*P;
figure(2);plot(tout,y,[0 simtime],[0 0]);grid on;
figure(2);xlabel('Time (s)');ylabel('\Delta P(MW)');

figure(2);plot(tout,msbr_core_mux(:,[18 19 21 22]));
figure(2);xlabel('Time (s)');ylabel('Temperature (\circC)');


figure(3);plot(tout,msbr_core_mux(:,[17 20 23]));
figure(3);xlabel('Time (s)');ylabel('Temperature (\circC)');


%%
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 6.5, 9.0], 'PaperUnits', 'Inches', 'PaperSize', [6.5, 9.0])
subplot(2,2,1)
plot(tout-2500,msbr_core_mux(:,[17 18 19 20]));
xlabel('Time (s)');ylabel('Temperature (\circC)');legend('f1b1','f1b2','f1a1','f1a2');%title('Fuel Temperatures');
subplot(2,2,2)
plot(tout-2500,msbr_core_mux(:,[25 26 27 28]));
xlabel('Time (s)');ylabel('Temperature (\circC)');legend('f2a1','f2a2','f2b1','f2b2');%title('Fuel Temperatures');
subplot(2,2,3)
plot(tout-2500,msbr_core_mux(:,[29 30 31 32]));
xlabel('Time (s)');ylabel('Temperature (\circC)');legend('g3a','g4a','g3b','g4b');%title('Graphite Temperatures');
subplot(2,2,4)
plot(tout-2500,msbr_core_mux(:,[21 22 23 24]));
xlabel('Time (s)');ylabel('Temperature (\circC)');legend('g1b','g2b','g1a','g2a');%title('Graphite Temperatures');