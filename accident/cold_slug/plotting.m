figure;plot(tout,msre_core_mux(:,4));grid on; % legend('Core Power','Demand Power','location','southeast');
figure;plot(tout,msre_core_mux(:,[5 7 9 11 13 15])); grid on;
figure;plot(tout,msre_core_mux(:,17),[0,max(tout)],[T0_g1,T0_g1]); grid on;
figure;plot(tout,msre_core_mux(:,[18 19]),[0,max(tout)],[T0_f1,T0_f1],[0,max(tout)],[T0_f2,T0_f2]); grid on;
%figure;plot(tout,msre_core_mux(:,19),[0,max(tout)],[T0_out,T0_out]); grid on;
figure(1);title('n/n_0');xlabel('Time (s)');ylabel('Fractional Power');
figure(2);title('Precursor Concentrations');xlabel('Time (s)');ylabel('Ci/n0');legend('C1','C2','C3','C4','C5','C6');
figure(3);title('Graphite Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('G1');
figure(4);title('Fuel Temperatures');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('F1','F2');
%figure(5);title('Fuel Temp for outside loop node');xlabel('Time (s)');ylabel('Temperature (\circC)');legend('Fout');



figure;plot(tout,msre_he_mux(:,[1 2])); grid on; legend('fin','cin');
figure;plot(tout,msre_he_mux(:,[3 4 5 6])); grid on; legend('p1','p2','p3','p4');
figure;plot(tout,msre_he_mux(:,[7 8])); grid on; legend('t1','t2');
figure;plot(tout,msre_he_mux(:,[9 10 11 12])); grid on; legend('s1','s2','s3','s4');


figure;plot(tout,msre_rad_mux(:,[1 2])); grid on; legend('salt in','air in');
figure;plot(tout,msre_rad_mux(:,[3 4])); grid on; legend('salt out','air out');
figure;plot(tout,msre_rad_mux(:,4),tout,rad_air_out); grid on; legend('air','air_out');

%% Useful calculations

% fuel power across core and phe
Pfc = W_f*scp_f*(msre_core_mux(end,19)-msre_core_mux(end,1));
Pfh = W_f*scp_f*(msre_he_mux(end,1)-msre_he_mux(end,6));

% coolant power across phe and radiator
Pch = W_s*scp_s*(msre_he_mux(end,12)-msre_he_mux(end,2));
Pcr = W_s*scp_s*(msre_rad_mux(end,1)-msre_rad_mux(end,3));

% air power across radiator
Par = W_rs*scp_rs*(msre_rad_mux(end,4)-msre_rad_mux(end,2));

% power transfered from graphite to fuel
Pgf = hA_fg*(msre_core_mux(end,17)-msre_core_mux(end,18));

Pfti = hA_pn*2*(msre_he_mux(end,3)-msre_he_mux(end,7));
Pfto = hA_pn*2*(msre_he_mux(end,5)-msre_he_mux(end,8));

Ptsi = hA_sn*2*(msre_he_mux(end,8)-msre_he_mux(end,9))
Ptso = hA_sn*2*(msre_he_mux(end,7)-msre_he_mux(end,11))


