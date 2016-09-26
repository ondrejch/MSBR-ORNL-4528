#{

Point Kinetics Equation (PKE) solver for education and research purposes.

Author: Vikram Singh, viikraam@gmail.com
Supervisor: Dr. Ondrej Chvala, 
Dept. of Nuclear Engineering, UTK, ochvala@utk.edu

This program takes an input file with time (in s), reactivity, and external 
neutron source as three columns and returns plots for n(t) and C_i(t) 
for i=1,2,...6

#}
################################################################################

# Ask for user unput on fuel type. Options: U233, U235 or MSBR; case insensitive.
x=[""]; # initialize string array

while (strcmp(x,""))
    x=input("Select fuel. Options are U233, U235, or MSBR   ","s");
    if (strcmpi("U233",x)==1 || strcmpi("U235",x)==1 || strcmpi("MSBR",x)==1)
        break
    else
        disp("Please try again!")
        x=[""]
    endif
endwhile


# Delayed neutron lifetimes 'beta' for the six precursor groups depending on 
# fuel type. B = sum(bet). Retrieved from ORNL-MSR-67-102
if (strcmpi("U233",x)==1)
  global bet = [0.00023,0.00079,0.00067,0.00073,0.00013,0.00009]';
  global B   = sum(bet);
  elseif (strcmpi("U235",x)==1)
    global bet = [0.000215,0.00142,0.00127,0.00257,0.00075,0.00027]';
    global B   = sum(bet);
      elseif (strcmpi("MSBR",x)==1)
        global bet = [0.000229,0.000832,0.000710,0.000852,0.000171,0.000102]';
        global B   = sum(bet);
endif


# Decay constants for the corresponding decay groups
global lam = [0.0126,0.0337,0.139,0.325,1.13,2.50]';


# Mean neutron generation time
global L = 0.0005; 


# Initial values for n(t) and C_i(t)
nt    = 1.0;
Ct(1) = (bet(1)/(L*lam(1)))*nt;
Ct(2) = (bet(2)/(L*lam(2)))*nt;
Ct(3) = (bet(3)/(L*lam(3)))*nt;
Ct(4) = (bet(4)/(L*lam(4)))*nt;
Ct(5) = (bet(5)/(L*lam(5)))*nt;
Ct(6) = (bet(6)/(L*lam(6)))*nt;


# Read in input file. Formatted as time, reactivity, source.
global input_data = dlmread('./reactivity.dat');
global nrows      = rows(input_data);
global tmax       = input_data(nrows,1); # length of time for which to evaluate the equations


# Initial y and t values
y0 = [nt,Ct(1),Ct(2),Ct(3),Ct(4),Ct(5),Ct(6)]';
t0 = [0,0];

# Get reactivity value from input file for some t. 
# Not general purpose. Only compatible with this project.


function rho=react(t)%,nrows,input_data)
  rho=0;
  global nrows;
  global input_data;
  if (t>input_data(nrows,1))
    rho=input_data(nrows,2);
  else
    for i = 1:nrows-1
      if (t>=input_data(i,1) & t<=input_data(i+1,1))
        rho=input_data(i,2);
        break
        else
          continue
      endif
    endfor
  endif  
endfunction


function S=source(t)%,nrows,input_data)
  S=0;
  global nrows;
  global input_data;
  if (t>input_data(nrows,1))
    S=input_data(nrows,3);
  else
    for i = 1:nrows-1
      if (t>=input_data(i,1) & t<=input_data(i+1,1))
        S=input_data(i,3);
        break
        else
          continue
      endif
    endfor
  endif
endfunction


function ndot=neudens(t,y,react,source,bet,B,lam,L)
  ndot(1) = source(t) + (((react(t)-B)/L)*y(1)) + (lam(1)*y(2)) + ...
  (lam(2)*y(3)) + (lam(3)*y(4)) + (lam(4)*y(5)) + (lam(5)*y(6)) + (lam(6)*y(7));
  ndot(2) = ((bet(1)/L)*y(1)) - (lam(1)*y(2));
  ndot(3) = ((bet(2)/L)*y(1)) - (lam(2)*y(3));
  ndot(4) = ((bet(3)/L)*y(1)) - (lam(3)*y(4));
  ndot(5) = ((bet(4)/L)*y(1)) - (lam(4)*y(5));
  ndot(6) = ((bet(5)/L)*y(1)) - (lam(5)*y(6));
  ndot(7) = ((bet(6)/L)*y(1)) - (lam(6)*y(7));
endfunction


# Time vector
%t = [0:0.1:tmax]; t = t';

%function ndot=neu(t,y)
%  ndot=zeros(2,1);
%  V = y(1); P = y(2);
%  ndot(1) = -13*V+(0.08*P);
%  ndot(2) = 15*V-(0.08*P);
%endfunction

# ODE solution stored in a matrix of 7 x (tmax*dt)

vopt = odeset ("RelTol", 1e-3, "AbsTol", 1e-3, "NormControl","on", "InitialStep",0.0001, "MaxStep",0.01);%, "OutputFcn", @odeplot);

sol = odebda(@(t,y) neudens(t,y,@react,@source,bet,B,lam,L),[0 tmax],y0,vopt);

tsol = sol.x; ysol = sol.y;

figure(1)
plot(tsol,ysol(:,1));

figure(2)
plot(tsol,ysol(:,2:7))
