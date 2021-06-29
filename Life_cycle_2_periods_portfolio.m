% Two-period life-cycle porfolio model
% Written by Michael Hatcher (m.c.hatcher@soton.ac.uk) in 2017.

clc; clear;

% Parameter values
beta = 0.96; r = 0.05; Y1 = 1; p = 0.99;
eps1 = 0.0107; eps2 = -0.7; 
Nguess = 2000; 
Nguess2 = 2000;

for i=1:Nguess
    
    for j=1:Nguess2
    
    Sguess(i) =  0.5*(i-1)/Nguess;
    Bguess(j) = 0.5*(j-1)/Nguess2;
    
    S = Sguess(i); 
    B = Bguess(j);
    C1 = Y1 - S - B;
    C2_1 =  (1+r)*B + (1+r+eps1)*S ; 
    C2_2 = (1+r)*B + (1+r+eps2)*S;
    
    U(i,j) = log(C1) + beta*( p*log(C2_1) + (1-p)*log(C2_2) );
    
    end
    
end

%Find maximum of utility w.r.t. S guesses
MN = max(U'); %row vector containing max for each column (note: transposed)
[MN1, Index_S] = max(MN); 
Index_S

%Find maximum of utility w.r.t. B guesses
MN3 = max(U); %row vector containing max for each column (note: not transposed)
[MN4, Index_B] = max(MN3); 
Index_B

disp('Optimal holding of shares is') 
Sstar = Sguess(Index_S)
disp('Optimal holding of bonds is') 
Bstar = Bguess(Index_B)

C1star = Y1 - Sstar - Bstar;
C2_1star = (1+r)*Bstar + (1+r+eps1)*Sstar;
C2_2star = (1+r)*Bstar + (1+r+eps2)*Sstar;

%Check that FOCs hold
Resid = 1/C1star - beta*(1+r)*(p/C2_1star + (1-p)/C2_2star) 
Resid2  = 1/C1star - beta*( p*(1+r+eps1)/C2_1star + (1-p)*(1+r+eps2)/C2_2star )

%Plot results
T = 40; %Window around optimum (see below)
surf( Sguess(Index_S-T:Index_S+T), Bguess(Index_B-T:Index_B+T),...
    U(Index_S-T:Index_S+T, Index_B-T:Index_B+T) )
xlabel('S'), ylabel('B'), zlabel('Expected Utility, U')
