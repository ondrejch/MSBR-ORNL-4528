% Gavin Ridley
% gridley@vols.utk.edu
%
% NE 357 Fall 2016 Final Project
%
% This script saves all of the relevant parameters for the MSBR
% primary system to the workspace. The steady-state conditions are
% calculated. A linearized model is constructed in state-space form.
% Delayed neutron precursors flowing back into the core are treated as
% separate input variables to the problem, and are modeled by a variable
% transport delay.
%
% All units are MW, s, lbm, deg F.

clear all, close all, clc
format compact
%% Physical properties
cpb=.22*.001055; %MJ/lb/F heat capacity of blanket salt, table 3.1
cpf=.55*.001055;  %MJ/lb/F heat capacity of fuel salt
cpg=.42*.001055; %MJ/lb/F heat capacity of graphite @ 1200F, 4528 table 3.5
rhob=277; % lb/ft^3 table 3.1
rhof=127; % lb/ft^3 table 3.1
rhog=106; % lb/ft^3 67-102 p. 10

%% Masses
mfuel=1053; %Total mass of fuel in core p. 11 ORNL-67-102
mblanket=502.65*.058*rhob; %Total mass of blanket salt in core.058 is fraction of blanket in core.
mgraphblank=.11*17.6/cpg; %Mass of graphite in blanket zone. apparently only 11% of it
                          % is actually involved in heat transfer. p. 15 67-102
mgraphfuel=502.65*.777*rhog; %Mass of graphite in fuel zone
mfuelloop=25*rhof*(1.32+1.22); %mass of fuel in fuel loop. deduced by p. 32. 
                               %their nominal fuel rate is 25ft^3/s. total
                               %time is taken as fuelHX->core +
                               %core->fuelHX


%% Some Parameters of the system:
% Order goes: blanket, fuel down, fuel up, neutronics

% --- Thermal parameters ---
Tbhigh=1250; %HX high blanket temp
Tblow=1150; %HX low blanket temp
Tfhigh=1300; %HX high fuel temp
Tflow=1000; % HX low fuel temp
fPfs=.017; %power fraction to fertile salt
fPgfs=.00814; %power fraction to graphite in fertile zone
fPg1=0.033; %fraction of power to node1/outer graphite
fPg2=0.033;   %fraction of powre to node2/ inner graphite
fPf1=.221; %power fraction to fuel nodes
fPf2=.221;
fPf3=.221;
fPf4=.221;
P=556; %MW
hAbg=.586; %heat transfer coefficient times area for graphite to blanket salt
hAfg1=.963; % HTC times area for fuel nodes 1,2
hAfg2=.624; % HTC times area for fuel nodes 3,4

%---Neutronics parameters ---
betas=[.00029,.000832,.000710,.000852,.000171,.000102];
lambdas=[.0126,.0337,.139,.325,1.13,2.5];
Lambda=3.3e-4;
alpha_f=-4.54e-5;
alpha_b=9.2e-6;
alpha_g=1.12e-5;

% Firstly, the initial conditions must be determined!
%% Blanket initial conditions:
% Considering the blanket HX inlet and outlet as fixed tempertures
% after solving for mass flow rate, three variables exist. Blanket node 1
% temp, blanket graphite temp, and 
% Mass flow rate in blanket determined from first law of thermo.
mdotb_0=(fPfs+fPgfs)*P/cpb/(Tbhigh-Tblow);
% And then a 2x2 system is solved to find the Tb1 and Tg3:
mat1=[mdotb_0+hAbg/cpb/2,-hAbg/cpb/2;-hAbg,hAbg]\[fPfs*P/cpb+mdotb_0*Tblow;fPgfs*P];
%then unpack
Tb1_0=mat1(1);
Tg3_0=mat1(2);
Tb2_0=Tbhigh; %know this from mann's model

%% Fuel initial conditions:
%First, mass flow rate is found from the first law of thermo.
mdotf_0=(fPg1+fPg2+fPf1+fPf2+fPf3+fPf3)*P/cpf/(Tfhigh-Tflow);

% Then a 2x2 system can be solved for Tg2 and Tf3. Tf4 is outlet temp.
mat2=[mdotf_0-hAfg2/cpf,hAfg2/cpf;hAfg2,-hAfg2]\[mdotf_0*Tfhigh-fPf4/cpf*P;-fPg2*P];
%unpack
Tf3_0=mat2(1);
Tg2_0=mat2(2);
Tf4_0=Tfhigh; %known from manns model

% Now, Tf1 and Tg1 can be found similarly.
mat3=[-mdotf_0-.5*hAfg1/cpf,.5*hAfg1/cpf;hAfg1,-hAfg1]\[-mdotf_0*Tflow-fPf1/cpf*P;-fPg1*P];
%unpack
Tf1_0=mat3(1);
Tg1_0=mat3(2);

%From this, fuel temp 2 can be solved for explicitly.
Tf2_0=(mdotf_0*Tf1_0+fPf2*P/cpf+hAfg1/2/cpf*(Tg1_0-Tf1_0))/mdotf_0;

%% Neutronics initial conditions:
tauc_0=mfuel/mdotf_0; %core fuel transit time
taul_0=mfuelloop/mdotf_0; %fuel loop transit time

%ORNL 67-102 presents an explicit formula for finding the excess reactivity
%required due to delayed neutron precursor drift.
rho_0=sum(betas);
%Now rho gets decremented
for i=1:6
    rho_0 =rho_0 - betas(i)/(1+1/lambdas(i)/tauc_0*(1-exp(-taul_0*lambdas(i))));
end

% Precursor concentration equations have to be re-linearized due to the
% original 67-102 report using constant mass flow rate. This means that the
% initial precursor concentrations must be known. Precursor concentration
% is taken in the sense of concentration per initial neutron density.
C_0=zeros(1,6);
for i=1:6
    C_0(i)=betas(i)/Lambda/(lambdas(i)+mdotf_0/mfuel-exp(-lambdas(i)*mfuelloop/ ...
        mdotf_0)*mdotf_0/mfuel);
end

% Huzzah! That should be all of the initial conditions required.

%% State-space matrix construction

% The A matrix is 17x17 :'-(
% Vars (all in perturbation form):
% p/p0
% c1-6
% Tg1-3
% Tf1-4
% Tb1,2

% --- neutronics stuff ---
A=zeros(16,16); %initialize
A(1,1)=(rho_0-sum(betas))/Lambda;
A(1,2:7)=lambdas;
%fuel temps are divided by four, blanket by two, graphite by 3
A(1,8:10)=ones(1,3)*alpha_g/3;
A(1,11:14)=ones(1,4)*alpha_f/4;
A(1,15:16)=ones(1,2)*alpha_b/2;

%now do the state-space precursor stuff:
for i=2:7
    A(i,1)=betas(i-1)/Lambda;
    A(i,i)=-(lambdas(i-1)+mdotf_0/mfuel);%disapearance of precursor
end

% Now is the thermal-hydraulic stuff
% graphite node 1:
A(8,1)=fPg1*P/(mgraphfuel/2)/cpg;
A(8,8)=-hAfg1/(mgraphfuel/2)/cpg;
A(8,9)=hAfg1/(mgraphfuel/2)/cpg;
% Fuel node 1:
A(9,1)=fPf1/(mfuel/4)/cpf*P;
A(9,8)=.5*hAfg1/(mfuel/4)/cpf;
A(9,9)=-mdotf_0/(mfuel/4)-.5*hAfg1/(mfuel/4)/cpf;
% Fuel node 2:
A(10,1)=fPf2/(mfuel/4)/cpf*P;
A(10,8)=.5*hAfg1/(mfuel/4)/cpf;
A(10,9)=mdotf_0/(mfuel/4)-.5*hAfg1/(mfuel/4)/cpf;
A(10,10)=-mdotf_0/(mfuel/4);
%Graphite node 2:
A(11,1)=fPg2*P/(mgraphfuel/2)/cpg;
A(11,11)=-hAfg2/(mgraphfuel/2)/cpg;
A(11,12)=hAfg2/(mgraphfuel/2)/cpg;
%Fuel node 3:
%they totally forgot the power terms in fuel node 3 and 4
A(12,1)=fPf3/(mfuel/4)/cpf*P;
A(12,11)=.5*hAfg2/(mfuel/4)/cpf;
A(12,12)=-.5*hAfg2/(mfuel/4)/cpf-mdotf_0/(mfuel/4);
A(12,10)=mdotf_0/(mfuel/4);
%Fuel node 4:
A(13,1)=fPf4/(mfuel/4)/cpf*P;
A(13,11)=.5*hAfg2/(mfuel/4)/cpf;
A(13,12)=mdotf_0/(mfuel/4)-.5*hAfg2/(mfuel/4)/cpf;
A(13,13)=-mdotf_0/(mfuel/4);
% Blanket graphite:
A(14,1)=fPgfs/(mgraphblank)/cpg*P;
A(14,14)=-hAbg/mgraphblank/cpg;
A(14,15)=hAbg/mgraphblank/cpg;
% Blanket node 1:
A(15,1)=fPfs/(mblanket/2)/cpb*P;
A(15,14)=.5*hAbg/(mblanket/2)/cpb;
A(15,15)=-mdotb_0/mblanket-.5*hAbg/(mblanket/2)/cpb;
%Blanket node 2:
A(16,1)=fPfs/(mblanket/2)/cpb*P;
A(16,14)=.5*hAbg/(mblanket/2)/cpb;
A(16,15)=mdotb_0/(mblanket/2)-.5*hAbg/(mblanket/2)/cpb;
A(16,16)=-mdotb_0/(mblanket/2);

% The B matrix is 16x11
% Vars (perturbations)
%rho_ext
%mdotf
%mdotb
%Tflow
%Tblow
%precursors delay 1-6
B=zeros(16,11);
B(1,1)=1/Lambda;
for i=2:7
    B(i,1)=0; %no rho
    B(i,2)=(1/mfuel)*(C_0(i-1)*lambdas(i-1)*mfuelloop/mdotf_0*exp(-lambdas(i-1)*mfuelloop/mdotf_0)+C_0(i-1)*exp(-lambdas(i-1)*mfuelloop/mdotf_0)-C_0(i-1));
    B(i,i+2)=mdotf_0/mfuel*exp(-lambdas(i-1)*mfuelloop/mdotf_0);
end
% there are no forcing terms in the graphite 1 equation
%fuel node 1:
B(9,2)=(4/mfuel)*(Tflow-Tf1_0);
B(9,11)=mdotf_0*4/mfuel;
%fuel node 2:
B(10,2)=(4/mfuel)*(Tf1_0-Tf2_0);
%fuel node 3:
B(12,2)=(4/mfuel)*(Tf2_0-Tf3_0);
%fuel node 4:
B(13,2)=(4/mfuel)*(Tf3_0-Tf4_0);


%blanket node 1
B(15,10)=mdotb_0/(mblanket/2);
B(15,3)=(2/mblanket)*(Tblow-Tb1_0);
%blanket node 2
B(16,3)=(2/mblanket)*(Tb1_0-Tb2_0);

%% and lastly, some output stuff
amatrixfile=fopen('amatrix.txt','w');
bmatrixfile=fopen('bmatrix.txt','w');
%print a matrix
for i=1:16
    for j=1:16
        fprintf(amatrixfile, ' %6.2f & ', A(i,j));
    end
    fprintf(amatrixfile,' \\\\ \n');
end

%print b matrix
for i=1:16
    for j=1:11
        fprintf(bmatrixfile, '%6.2f & ', B(i,j));
    end
        fprintf(bmatrixfile,' \\\\ \n');
end

fclose(amatrixfile);
fclose(bmatrixfile);