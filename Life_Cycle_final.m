%Life-cycle model of consumption and saving (T periods)
% Written by Michael Hatcher (m.c.hatcher@soton.ac.uk) in 2017.

clear; clc;

%------------------------
%Housekeeping
%------------------------

beta = 0.96; r = 0.035; T = 80; A(T) = 0;       
% Since r < 1/beta-1 optimal consumption path downward sloping
a = -0.01; b=2/3; c =1;  % Parameters of income process (quadratic)

for t=1:T
    Y(t) = a*t^2 + b*t + c;
    
    if t >= 0.75*T
        Y(t) = 0;    %Retired from T = 60 onwards
    end
    
end

%-------------------------------
%Simulating the model
%-------------------------------

Ainit = -7.5;  %Initial value of wealth used in guess loop
Nguess = 80000;  step = 1e-5;

%Outer loop i (guess loop)
% Inner loop t (simulates consumption for each initial guess of A)

for i=1:Nguess
    
    Aguess(i) = Ainit + (i-1)*step;
    A(1) = Aguess(i);
    C(1) = Y(1) - A(1);
    C(2) = beta*(1+r)*C(1);
    A(2) = Y(2) - C(2) + (1+r)*A(1);
    
    for t=3:T
        
        C(t) = beta*(1+r)*C(t-1);    
        A(t) = Y(t)-C(t) + (1+r)*A(t-1);
   
    end
        
        CCheck = C(T);
        C(T) = Y(T) + (1+r)*A(T-1);
        A(T) = 0;
        
        gap(i) = CCheck - C(T);
    
    for t=1:T
        
        U(t) = beta^(t-1)*log(C(t));   %Period utility; this is ssumed to get total utility below
        
        H(t) = isreal(U(t));
        
         if H(t) == 0
            U(t) = -1e100;    %Not economically meaningful solutions
         end
        
        if C(t) <= 0 
            C(t) = 0;                     
            U(t) = -1e10000;      %Negative or zero consumption would never be chosen so we rule out those cases
        end
        
             if C(t) > 500 
            C(t) = 0;                       %Rule out consumption paths which are implausible
            U(t) = -1e10000;
             end
        
    end
     
    v = ones(T,1);
    Usum(i) = U*v;   %Lifetime utility
    
end

%Find maximum of utiility w.r.t. A guesses
[Umax, IndexU] = max(Usum)        %IndexU is location of maximum of utility
    
    Astar(1) = Aguess(IndexU);
    Astar(2) = Y(2) - beta*(1+r)*Y(1) + (1+r)*(1+beta)*Astar(1);
    Cstar(1) = Y(1) - Astar(1);
    Cstar(2) = beta*(1+r)*Cstar(1);
    
    %Simulate consumption path for the optimal case (best Aguess)
    for t=3:T
        
        Cstar(t) = beta*(1+r)*Cstar(t-1); 
        
        Astar(t) = Y(t)-Cstar(t) + (1+r)*Astar(t-1);
        
        Sstar(t) = Astar(t) - Astar(t-1);
       %Alternative def: Sstar(t) = Y(t)-Cstar(t);
   
    end
    
       Astar(T) = 0;  
       Cstar1(T) = Y(T) +  (1+r)*Astar(T-1);
       
       Check = Cstar(T)-Cstar1(T)

  %Plot the results     
   subplot(2,1,1)
   hold on, plot(Y), plot(Cstar, 'r')
   %ylabel('Consumption, Income')
   xlabel('Time')
   legend('Income','Consumption')
   subplot(2,1,2)
   hold on, plot(Astar), plot(Sstar, '--r')
   %ylabel('Wealth, Saving')
   xlabel('Time')
   legend('Wealth','Saving')
    
