// Point Kinetics Equation (PKE)solver for education and research purposes.

// Author: Vikram Singh, viikraam@gmail.com
// Supervisor: Dr. Ondrej Chvala, Dept. of Nuclear Engineering, UTK, ochvala@utk.edu

// This program takes an input file with time (in s), reactivity, and external neutron source as three columns and returns plots for n(t) and C_i(t) for i=1,2,...6

//........................................................................................//


// Ask for user unput on fuel type. Options: U233, U235 or MSBR; case insensitive.
x=[""]; // initialize string array
while x==[""]
    x=input("Select fuel. Options are U233, U235, or MSBR   ","s")
    if (strcmp("U233",x,'i')==0 | strcmp("U235",x,'i')==0 | strcmp("MSBR",x,'i')==0)
        break
    else
        disp('Please try again!')
        x=[""]
    end
end


// Delayed neutron lifetimes 'beta' for the six precursor groups depending on fuel type. B = sum(bet)
// Retrieved from ORNL-MSR-67-102
bet = []; // initialize array
if (strcmp("U233",x,'i')==0) then
    bet = [0.00023,0.00079,0.00067,0.00073,0.00013,0.00009]';
    B   = sum(bet);
    else if (strcmp("U235",x,'i')==0) then
        bet = [0.000215,0.00142,0.00127,0.00257,0.00075,0.00027]';
        B   = sum(bet);
        else if (strcmp("MSBR",x,'i')==0) then
            bet = [0.000229,0.000832,0.000710,0.000852,0.000171,0.000102]';
            B   = sum(bet);
        end
    end
end


// Decay constants for the corresponding decay groups
lam = [0.0126,0.0337,0.139,0.325,1.13,2.50]';


// Mean neutron generation time
L = 0.0005; 


// Initial values for n(t) and C_i(t)
nt    = 1.0;
Ct(1) = (bet(1)/(L*lam(1)))*nt;
Ct(2) = (bet(2)/(L*lam(2)))*nt;
Ct(3) = (bet(3)/(L*lam(3)))*nt;
Ct(4) = (bet(4)/(L*lam(4)))*nt;
Ct(5) = (bet(5)/(L*lam(5)))*nt;
Ct(6) = (bet(6)/(L*lam(6)))*nt;


// Read in input file. Formatted as time, reactivity, source.
input_data = read('./reactivity.dat',-1,3);
nrows      = size(input_data,"r");
tmax       = input_data($,1); // length of time for which to evaluate the equations


// Get reactivity value from input file for some t
function rho=react(t)
    rho=0;
    for i = 1:nrows-1
        if (t>=input_data(i,1) & t<=input_data(i+1,1)) then
            rho=input_data(i,2);
            break
        else
            continue
        end
    end
endfunction


// Get source value from input file for some t
function S=source(t)
    S=0;
    for i = 1:nrows-1
        if (t>=input_data(i,1) & t<=input_data(i+1,1)) then
            S=input_data(i,3);
            break
        else
            continue
        end
    end
endfunction


// Function to calculate the n(t) and C_i(t) as a function of time.
// The parameters passed to the function are 1. t=time vector, 2. y=initial values for n(t) and C_i(t), 3. react=function to retrieve reactivity values, 4. source=function to retrieve source values, 5. bet=column vector with beta values, 6. B=sum of all betas, 7. lam=column vector of lambda values, 8. L=mean neutron generation time.
funcprot(0)
function ndot=neudens(t,y,react,source,bet,B,lam,L)
    ndot(1) = source(t) + (((react(t)-B)/L)*y(1)) + (lam(1)*y(2)) + (lam(2)*y(3)) + (lam(3)*y(4)) + (lam(4)*y(5)) + (lam(5)*y(6)) + (lam(6)*y(7));
    ndot(2) = ((bet(1)/L)*y(1)) - (lam(1)*y(2));
    ndot(3) = ((bet(2)/L)*y(1)) - (lam(2)*y(3));
    ndot(4) = ((bet(3)/L)*y(1)) - (lam(3)*y(4));
    ndot(5) = ((bet(4)/L)*y(1)) - (lam(4)*y(5));
    ndot(6) = ((bet(5)/L)*y(1)) - (lam(5)*y(6));
    ndot(7) = ((bet(6)/L)*y(1)) - (lam(6)*y(7));
endfunction


// Initial y and t values
y0 = [nt,Ct(1),Ct(2),Ct(3),Ct(4),Ct(5),Ct(6)]';
t0 = 0;


// Time vector
t = 0:0.1:tmax; t = t';


// ODE solution stored in a matrix of 7 x (tmax*dt)
sol = ode("rk4",y0,t0,t,list(neudens,react,source,bet,B,lam,L));


// Plot the solutions
clf(); // clear the graphics window

plot(t,sol(1,:)',"k-","thickness",2);
xlabel("$t$","font_size",4);
ylabel("$n(t)$","font_size",4);
legend("$n(t)$",2);

xset('window',1);
plot(t,sol(2:7,:)',"thickness",2);
xlabel("$t$","font_size",4);
ylabel("$C_i(t)$","font_size",4);
legend(["$C_1$";"$C_2$";"$C_3$";"$C_4$";"$C_5$";"$C_6$"],2);
