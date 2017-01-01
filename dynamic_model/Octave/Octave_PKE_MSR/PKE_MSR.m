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


clear all;        # clear workspace.
pkg load odepkg;  # load odepkg.


# Ask for user input on fuel type. Options: U233, U235 or MSBR; case insensitive.
x=[""]; # initialize string array.

while (strcmp(x,""))
    x=input("Select fuel. Options are U233, U235, or MSBR   ","s");
    if (strcmpi("U233",x)==1 || strcmpi("U235",x)==1 || strcmpi("MSBR",x)==1)
        break
    else
        disp("Please try again!")
        x=[""]
    endif
endwhile


# Decay constants for the corresponding decay groups.
global lam = [0.0126,0.0337,0.139,0.325,1.13,2.50]';


# Mean neutron generation time.
global L = 0.00033; 


# Transit time of fuel in external loop and core respectively.
global t_L = 5.85;
global t_C = 3.28;


# Calculate the big term from rho_0 equation.
function rho_0=bigterm(bet,lam,L,t_L,t_C)
    rho_0 = 0;
    global bet;
    global lam;
    global L;
    global t_L;
    global t_C;
    for i = 1:6
        rho_0 += bet(i)/(1.0 + (1.0-exp(-lam(i)*t_L))/(lam(i)*t_C));
    end
endfunction


# Delayed neutron lifetimes 'beta' for the six precursor groups depending on 
# fuel type. B = sum(bet). Retrieved from ORNL-MSR-67-102.
if (strcmpi("U233",x)==1)
  global bet   = [0.00023,0.00079,0.00067,0.00073,0.00013,0.00009]';
  global B     = sum(bet);
  global rho_0 = B - bigterm(bet,lam,L,t_L,t_C); 
  elseif (strcmpi("U235",x)==1)
    global bet   = [0.000215,0.00142,0.00127,0.00257,0.00075,0.00027]';
    global B     = sum(bet);
    global rho_0 = B - bigterm(bet,lam,L,t_L,t_C);
      elseif (strcmpi("MSBR",x)==1)
        global bet   = [0.000229,0.000832,0.000710,0.000852,0.000171,0.000102]';
        global B     = sum(bet);
        global rho_0 = B - bigterm(bet,lam,L,t_L,t_C);
endif


# Initial values for n(t) and C_i(t).
nt    = 1.0;
Ct(1) = ((bet(1)*nt)/L)*(1.0/(lam(1) - (exp(-lam(1)*t_L) - 1.0)/t_C));
Ct(2) = ((bet(2)*nt)/L)*(1.0/(lam(2) - (exp(-lam(2)*t_L) - 1.0)/t_C));
Ct(3) = ((bet(3)*nt)/L)*(1.0/(lam(3) - (exp(-lam(3)*t_L) - 1.0)/t_C));
Ct(4) = ((bet(4)*nt)/L)*(1.0/(lam(4) - (exp(-lam(4)*t_L) - 1.0)/t_C));
Ct(5) = ((bet(5)*nt)/L)*(1.0/(lam(5) - (exp(-lam(5)*t_L) - 1.0)/t_C));
Ct(6) = ((bet(6)*nt)/L)*(1.0/(lam(6) - (exp(-lam(6)*t_L) - 1.0)/t_C));


# Read in input file. Formatted as time, reactivity, source.
global input_data = dlmread('./reactivity.dat');
global nrows      = rows(input_data);
global tmax       = input_data(nrows,1); # length of time to evaluate equations.


# Initial y and t values
global y0 = [nt,Ct(1),Ct(2),Ct(3),Ct(4),Ct(5),Ct(6)]';
global t0 = -30; # we start at -30s to avoid small fluctuations at the beginning.


# Get reactivity value from input file for some t. 
function rho=react(t)
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


# Get external source value from input file for some t. 
function S=source(t)
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


# Function to calculate the n(t) and C_i(t) as a function of time.
# The parameters passed to the function are:
# 1. t=time step, 2. y=initial values for n(t) and C_i(t), 
# 3. react=function to retrieve reactivity values, 
# 4. source=function to retrieve source values, 
# 5. bet=column vector with beta values, 6. B=sum of all betas, 
# 7. lam=column vector of lambda values, 8. L=mean neutron generation time, 
# 9. t_L=transit time in loop, 10. t_C=transit time in core.
function ndot=neudens(t,y,yd,react,rho_0,source,bet,B,lam,L,t_L,t_C)
  ndot(1) = source(t) + ((((rho_0+react(t))-B)/L)*y(1)) + (lam(1)*y(2)) + ...
            (lam(2)*y(3)) + (lam(3)*y(4)) + (lam(4)*y(5)) + (lam(5)*y(6)) + ...
            (lam(6)*y(7));
  ndot(2) = ((bet(1)/L)*y(1)) - (lam(1)*y(2)) + (yd(2)*exp(-lam(1)*t_L)/t_C) - ...
             (y(2)/t_C);
  ndot(3) = ((bet(2)/L)*y(1)) - (lam(2)*y(3)) + (yd(3)*exp(-lam(2)*t_L)/t_C) - ...
             (y(3)/t_C);
  ndot(4) = ((bet(3)/L)*y(1)) - (lam(3)*y(4)) + (yd(4)*exp(-lam(3)*t_L)/t_C) - ...
             (y(4)/t_C);
  ndot(5) = ((bet(4)/L)*y(1)) - (lam(4)*y(5)) + (yd(5)*exp(-lam(4)*t_L)/t_C) - ...
             (y(5)/t_C);
  ndot(6) = ((bet(5)/L)*y(1)) - (lam(5)*y(6)) + (yd(6)*exp(-lam(5)*t_L)/t_C) - ...
             (y(6)/t_C);
  ndot(7) = ((bet(6)/L)*y(1)) - (lam(6)*y(7)) + (yd(7)*exp(-lam(6)*t_L)/t_C) - ...
             (y(7)/t_C);
endfunction


# Options for the DDE solver. Passed to as struct to [opt], see below.
vopt = odeset ("RelTol", 1e-7, "AbsTol", 1e-7, "NormControl", "on", ...
               "InitialStep", 1e-4, "MaxStep", 0.01);#,"OutputFcn", @odeplot);


# Integrate ODEs for given time using the ode45d (mod RK 4,5) routine in odepkg. 
# Used under the GNU GPL for research purposes.  
# Function definition as follows:
# [sol] = ode45d (@function, timeslot, initial values, timelags, history, [opt]) 
# The timelags are passed to the solver as a vector. History is passed as an 
# mxn matrix where X_i,j is the history of the ith component at the jth lag. 
# For our case there's only one lag, t_L, and the history vector is a 7x1 column
# vector equivalent to the initial condition. 
# Ref: http://octave.sourceforge.net/odepkg/function/odepkg_examples_dde.html
# http://www.runet.edu/~thompson/webddes/tutorial.pdf
sol = ode45d(@(t,y,yd) neudens(t,y,yd,@react,rho_0,@source,bet,B,lam, ...
             L,t_L,t_C), [t0 tmax], y0, t_L, y0, vopt);


# Saving the solution for t and y, where y1 is n(t) and y2:y7 are C_i(t).            
tsol = sol.x; 
ysol = sol.y;


# Plot figure 1, n(t) vs t.
clf('reset');
figure(1);
F1 = plot(tsol,ysol(:,1));
X1 = xlabel('time (in s)');
set(X1,'FontName','Times New Roman','fontsize',14);
axis([0,tmax]);
Y1 = ylabel('Reactor Power (rel.)');
set(Y1,'FontName','Times New Roman','fontsize',14);


# Plot figure 2, C_i(t) vs t. 
figure(2)
F2 = plot(tsol,ysol(:,2:7));
X2 = xlabel('time (in s)');
set(X2,'FontName','Times New Roman','fontsize',14);
axis([0,tmax]);
Y2 = ylabel('C_i(t)');
set(Y2,'FontName','Times New Roman','fontsize',14);
legend('C_1','C_2','C_3','C_4','C_5','C_6');