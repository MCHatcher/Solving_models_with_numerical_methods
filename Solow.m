%Solow model
% Written by Michael Hatcher (m.c.hatcher@soton.ac.uk) in 2017.

clear; clc;

%Parameters
alpha = 1/3; delta = 0.05; n = 0.05; s = 0.20;

%Initial capital and output
k(1) = 1;          
y(1) = k(1)^alpha; 

%Number of simulated periods
T = 150;

%Simulate economy using a loop
for t=2:T

      k(t) = (1/(1+n))*(s*k(t-1)^alpha - (n+delta)*k(t-1) ) + k(t-1);
      y(t) = k(t)^alpha;
      Growth(t) = 100*(y(t) - y(t-1))/y(t-1);
      
end

%Plot graphs
hold on,
subplot(1,2,1), plot(k) 
title('Capital per person, k'), xlabel('Time')
subplot(1,2,2), plot(Growth(2:T),'r')
title('Growth rate (output per person)'), xlabel('Time')

