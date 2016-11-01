df = gdf();
df.anti_aliasing="16x";

scf(1);
plot(a.time,a.values(:,2),"k-");
xlabel("$ \rm Time \ [s]$","font_size",4);
ylabel("$ \rm Reactor \ Power \ [rel.]$","font_size",4);

scf(2);
plot(b.time,b.values(:,[1,3,5,7,9,11]));
xlabel("$\rm Time \ [s]$","font_size",4);
ylabel("$\rm C_i(t)$","font_size",4);
legend(["$C_1$";"$C_2$";"$C_3$";"$C_4$";"$C_5$";"$C_6$"],5);

// T_g temps
scf(3);
plot(b.time,b.values(:,[14,17,20]));
xlabel("$\rm Time \ [s]$","font_size",4);
ylabel("$\rm Graphite \ node \ temperature \ [^{\circ} C]$","font_size",4);
legend(["$T_{g1}$";"$T_{g2}$";"$T_{g3}$"],5);


// T_f temps
scf(4);
plot(b.time,b.values(:,[15,16,18,19]));
xlabel("$\rm Time \ [s]$","font_size",4);
ylabel("$\rm Fuel \ node \ temperature \ [^{\circ} C]$","font_size",4);
legend(["$T_{f1}$";"$T_{f2}$";"$T_{f3}$";"$T_{f4}$"],5);


// T_b temps
//plot(b.time,b.values(:,[21,22]));
//xlabel("$\rm Time \ [s]$","font_size",4);
//ylabel("$\rm C_i(t)$","font_size",4);
//legend(["$T_{b1}$";"$T_{b2}$"],5);
