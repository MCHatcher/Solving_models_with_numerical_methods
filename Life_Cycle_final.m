%Life-cycle model of consumption and saving (T periods)
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk) in 2017.
%Fast and short version as per the slides

clear; clc;

%------------------------
%Housekeeping
%------------------------

beta = 0.96; r = 0.035; T = 80;       
% Since r < 1/beta-1 optimal consumption path downward sloping
a = -0.01; b=2/3; c =1;  % Parameters of income process (quadratic)

for t=1:T
    Y(t) = a*t^2 + b*t + c;
    
    if t >= 0.75*T
        Y(t) = 0;    %Retired from T = 60 onwards
    end
    
end

%----------------------------------------
%Simulating the model (guesses on A(1))
%----------------------------------------

Ainit = -15;  %Initial value of wealth used in guess loop
Nguess = 200000;  
A_vec = linspace(Ainit,-Ainit,Nguess);   %Vector of guesses for A(1)

%Outer loop i (guess loop)
%Inner loop t (simulates consumption for each initial guess of A)

for i=1:Nguess
    
    Aguess(i) = A_vec(i);
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
        %Equals CCheck only if A(T) = 0; 
        
        gap(i) = abs(CCheck - C(T));
        %Equal to -A(T)

end
    

%Find optimal path
[gap_min, IndexU] = min(gap);  

disp('Terminal wealth at our solution is')
gap_min

%----------------------------------------------------------
%Simulate optimal path of consumption, saving and wealth
%----------------------------------------------------------
    
    Astar(1) = Aguess(IndexU);
    Astar(2) = Y(2) - beta*(1+r)*Y(1) + (1+r)*(1+beta)*Astar(1);
    Cstar(1) = Y(1) - Astar(1);
    Cstar(2) = beta*(1+r)*Cstar(1);
    Sstar(1) = 0; Sstar(2) = Astar(2);
    
    
    %Simulate consumption path in periods 3 to T
    for t=3:T
        
        Cstar(t) = beta*(1+r)*Cstar(t-1); 
        
        Astar(t) = Y(t)-Cstar(t) + (1+r)*Astar(t-1);
        
        Sstar(t) = Astar(t) - Astar(t-1);
       %Alternative def: Sstar(t) = Y(t)-Cstar(t);
   
    end

%-------------------
%Plot the results   
%-------------------

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
    
