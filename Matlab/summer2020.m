% Code examples and functions based on Trapman et. al. example 1.4.5.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FUNCTIONS %
%
% calcR0_N(pa,ka,pb,kb,k)
% plot_R0_over_ka(R0_H,kb,k,ka,to)
% R0_at_end(R0_H,kb,k,ka_end)
% plotR0_N_over_R0_H(R0_H_input, kb, k, ka_end, to)

% Using solve is slow 8or indeed impossible?). Numerical vpasolve() is
% efficient!
syms x

% Examples to reproduce: 

% Article case:
calcR0_N(1/3,2,2/3,1,2) - 2+sqrt(3)/3;
calcR0_N(1/3,2,2/3,2,3);
R0_at_end(4/3,1,2,2); % still same

% behaviour when increasing R_0^H:
R0_at_end(1.25,1,3,50)                  % 1.33...
R0_at_end(1.5,1,3,50)                   % 1.99...
R0_at_end(1.65,1,3,50)                  % 2.86...

R0_at_end(1.5,1,3,100000000)            % Still does not exceed limit of 2 

% All close to theoretical upper bound kappa:

R0_at_end(1.66666,1,3,100000)           % R0_H < 1+2/3
R0_at_end(1.749,1,4,100000)             % R0_H < 1+3/4
R0_at_end(1.799,1,5,100000)             % R0_H < 1+4/5
R0_at_end(1.83333,1,6,100000)           % R0_H < 1+5/6
R0_at_end(1.98,1,100,100000000000)      % R0_H < 1+99/100 - agrees w. R0^N = lim 1/e_to_a
R0_at_end(1.9899999,1,100,10000000)     % R0_H < 1+99/100
R0_at_end(1.99899999,1,1000,10000000)   % R0_H < 1+999/1000 = 1+(1-1/k)
R0_at_end(1.4999,1,2,100000000)         % R0_H < 1+1/2

% kb == 2 instead:
R0_at_end(2.333,2,3,100000000)      % R0_H < 2+1/3
R0_at_end(2.49999,2,4,100000000)    % R0_H < 2+2/4
R0_at_end(2.5999,2,5,100000000)     % R0_H < 2+3/5
R0_at_end(2.66666,2,6,100000000)    % R0_H < 2+4/6 = kb + (1-kb/k)


R0_at_end(10.8999,10,100,100000000)     % R0_H < 10 + (1-10/100) = kb + (1-kb/k)
R0_at_end(10.989999,10,1000,100000000)  % R0_H < kb + (1-kb/k)

% Elbow behaviour:
% Phase transition seemingly appearing around kappa_a==kappa:
% R0_H = 1.99... , k_b = 1, k=1000

R0_at_end(1.99899999,1,1000,1000) % 16
R0_at_end(1.99899999,1,1000,1001) % 990

R0_at_end(1.83333,1,6,6) % 5.2 
R0_at_end(1.83333,1,6,7) % 5.999

% elbow seemingly located at ka=k when R0_H close to limit
% Possible avenue: how does vpasolve() solve lambda?


% testing limit for lambda
%
% for R0 = 4/3
% R0_at_end(4/3,1,2,10000) -> 0.6667
% -log(-(1-2*0.66667)/(2*0.66667))
% 1.386244354869 vs 1.3863
%
% for R0 = 1.5, k=3
% R0_at_end(1.5,1,3,10000) -> 0.5000
%  -log(-(1-3*0.5000)/(3*0.5000))
% 1.09851 vs 1.0986
%
% for R0 = 1.6666, k=3
% R0_at_end(1.6666,1,3,10000000) -> 0.3334
% -log(-(1-3*0.3334)/(3*0.3334))
% 8.5173929 vs 8.5174
% R0_at_end(1.666666666,1,3,10000000) -> 0.33333334
% -log(-(1-3*0.333333334)/(3*0.333333334))
% 20.03011832 vs 20.0301

%
% for R0 = 1.749999, k=4
% R0_at_end(1.749999,1,4,10000000) -> 0.2500
% -log(-(1-4*0.250001)/(4*0.250001))
% 12.4292198 vs 12.4292
% R0_at_end(1.74999999,1,4,1000000000000000000)
% -log(-(1-4*0.25000001)/(4*0.2500001))
% 17.034386 vs 17.0344
% increasing accuracy (of R0 and ka limit) brings us closer to the zero border in lambda's
% equation - machine precision becomes an issue
% but the results still agree

% R0_at_end(1.99899999,1,1000,100010)
% e_to_a = 9.9003e-04 -> 0.0010
% lambda:
% 11.5028962
% -log(-(1-1000*1.00001e-03)/(1000*1.00001e-03)) ans = 11.5129