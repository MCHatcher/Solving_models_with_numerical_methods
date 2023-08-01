% Two-period life-cycle model with income risk (saving in riskless bond only)
% Written by Michael Hatcher (m.c.hatcher@soton.ac.uk) in 2017.

clear; clc;

% Parameter values
beta = 0.96; r = 0.05; Y1 = 1; p = 0.5;
eps1 = 0.5; eps2 = 1.05;
Nguess = 8000; 
Sguess = NaN(Nguess,1); U = Sguess;

S_vec = linspace(0,Y1,Nguess);  %Vector of guesses for S

for i=1:Nguess
    
    Sguess(i) =  S_vec(i);
    S = Sguess(i);
    C1 = Y1 - S;
    C2_1 = eps1 + (1+r)*S; 
    C2_2 = eps2 + (1+r)*S;
    
    U(i) = log(C1) + beta*( p*log(C2_1) + (1-p)*log(C2_2) );
       
    if ~isreal(U(i)) || C1 <= 0 || C2_1 <= 0 || C2_2 <= 0  
        U(i) = -realmax;     %Not sensible economic solutions
    end
    
end

%Find maximum of utility w.r.t. S guesses
[Umax, IndexU] = max(U);        %IndexU is the location of the optimal value

disp('Optimal holding of shares is') 
Sguess(IndexU)

Sstar = Sguess(IndexU);
C1star = Y1 - Sstar;
C2_1star = eps1 + (1+r)*Sstar;
C2_2star = eps2 + (1+r)*Sstar;

%Check that FOC holds
Resid = abs(1/C1star - beta*(1+r)*(p/C2_1star + (1-p)/C2_2star) )

%Plot results
T = 1000; %Window around optimum (see below)
plot(Sguess(IndexU-T:IndexU+T),U(IndexU-T:IndexU+T))
ylabel('Expected Utility'), xlabel('S')
