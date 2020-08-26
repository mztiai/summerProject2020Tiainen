function [R0_N_e] = R0_at_end(R0_H,kb,k,ka_end)
%R0_AT_END Summary of this function goes here
%   Detailed explanation goes here
pa = (R0_H-kb)/(ka_end-kb);
disp(pa);
R0_N_e = calcR0_N(pa,ka_end,1-pa,kb,k);
end

