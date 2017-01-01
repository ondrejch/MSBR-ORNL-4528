simtype='pid';
perturbation='tempfall'; %fuel HX low temp falls by six deg
imagetype='.png';
close all

figure(1)
plot(power.Time,power.Data)
title('Power Response')
xlabel('Time (s)')
ylabel('Fractional power change')
grid on
saveas(gcf,[simtype perturbation 'power' imagetype])

figure(2)
plot(temperatures.Time,temperatures.Data(:,1:3))
grid on
title('Fuel Upflow Temperature Response')
xlabel('Time (s)')
ylabel('Temperature perturbation (def F)')
legend('Graphite 1','Fuel 1','Fuel 2')
saveas(gcf,[simtype perturbation 'uptemp' imagetype])

figure(3)
plot(temperatures.Time,temperatures.Data(:,4:6))
grid on
title('Fuel Downflow Temperature Response')
ylabel('Temperature perturbation (def F)')
legend('Graphite 2','Fuel 3','Fuel 4')
xlabel('Time (s)')
saveas(gcf,[simtype perturbation 'downtemp' imagetype])


figure(4)
plot(temperatures.Time, temperatures.Data(:,7:9))
grid on
title('Blanket Region Temperature Response')
legend('Graphite 3','Blanket 1','Blanket 2')
ylabel('Temperature perturbation (def F)')
xlabel('Time (s)')
saveas(gcf,[simtype perturbation 'btemp' imagetype])

figure(5)
plot(precursors.Time, precursors.Data)
title('Precursor Concentrations')
xlabel('Time (s)')
ylabel('C_i perturbation')
legend('1','2','3','4','5','6')
grid on
saveas(gcf,[simtype perturbation 'ci' imagetype])

figure(6)
plot(mdotf.Time, mdotf.Data)
title('Mass Flow Rate Perturbation from PID controller')
xlabel('TIme (s)')
ylabel('Mass flow perturb. (lbm/s)')
saveas(gcf,[simtype perturbation 'mflow' imagetype])
