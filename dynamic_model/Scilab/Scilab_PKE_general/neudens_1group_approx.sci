function ndot=neudens(t,y)
    ndot(1) = -13*y(1)+(0.08*y(2));
    ndot(2) = 15*y(1)-(0.08*y(2));
    //ndot(3) = (0.0015975*y(1)/0.005)-(0.0317*y(3));
    //ndot(4) = (0.00141*y(1)/0.005)-(0.115*y(4));
    //ndot(5) = (0.0030525*y(1)/0.005)-(0.311*y(5));
    //ndot(6) = (0.00096*y(1)/0.005)-(1.4*y(6));
    //ndot(7) = (0.000195*y(1)/0.005)-(3.87*y(7));
endfunction

//delayed neutron lifetimes 'beta' for the six precursor groups
bet=[0.000285,0.0015975,0.00141,0.0030525,0.00096,0.000195]; bet=bet';
//total beta
B=sum(bet);
//decay constants for the corresponding decay groups
lam=[0.0127,0.0317,0.115,0.311,1.4,3.87]; lam=lam';
//mean neutron generation time
L=0.0005;
//reactivity value
p=1; //*****
//Source value
S=0;

//initial values for nt and Ct
nt = 1.0;
Ct=(B/(L*0.08))*nt;
//Ct(2)=(bet(2)/(L*lam(2)))*nt;
//Ct(3)=(bet(3)/(L*lam(3)))*nt;
//Ct(4)=(bet(4)/(L*lam(4)))*nt;
//Ct(5)=(bet(5)/(L*lam(5)))*nt;
//Ct(6)=(bet(6)/(L*lam(6)))*nt;

//initial y and t values
y0 = [nt,Ct]';//,Ct(2),Ct(3),Ct(4),Ct(5),Ct(6)]';
t0=0;

//time vector
T=0:0.1:120;T=T';

sol=ode(y0,t0,T,neudens);
clf();

plot2d(T,sol')
