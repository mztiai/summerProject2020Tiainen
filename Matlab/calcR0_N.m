function [R0_N] = calcR0_N(pa,ka,pb,kb,k)
% calc heterogenous R0 - solve e^{-a} -> solve lambda -> solve R0
    syms x
    e_to_a = (1-pa*ka)/(pb*kb);
    %disp('e_to_a:');
    %disp(e_to_a);
    lambda = vpasolve(1 == k*(pa + pb*e_to_a-pa*exp(-ka*x)-pb*exp(-kb*x)*e_to_a),x);
    %disp('lambda:');
    %disp(lambda);
    R0_N = k*(pa*(1-exp(-ka*lambda))+pb*(1-exp(-kb*lambda)));
end

