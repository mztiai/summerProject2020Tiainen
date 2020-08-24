function plotR0_N_over_R0_H(R0_H_in, kb, k, ka_end, to)
%PLOTR0_N_OVER_R0_H Summary of this function goes here
%   Detailed explanation goes here
R0_ends = zeros(1,to);
for j= 1:to
    R0_ends(j) = R0_at_end(R0_H_in,kb,k,ka_end);
    R0_H_in = R0_H_in + 0.01;
end

plot((R0_H_in-0.01*(to-1):0.01:R0_H_in), R0_ends)
axis([R0_H_in-0.01*(to-1) R0_H_in+0.05 0 k])
end

