df = gcf();
df.anti_aliasing="8x";

scf(122);
plot(a.time,a.values(:,2),"k-");
xlabel("$ \rm Time \ [s]$","font_size",4);
ylabel("$ \rm Reactor \ Power \ [rel.]$","font_size",4);

scf(214);
plot(b.time,b.values(:,[1,3,5,7,9,11]));
xlabel("$\rm Time \ [s]$","font_size",4);
ylabel("$\rm C_i(t)$","font_size",4);
legend(["$C_1$";"$C_2$";"$C_3$";"$C_4$";"$C_5$";"$C_6$"],5);
