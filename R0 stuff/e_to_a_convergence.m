function e_to_a_convergence(R0_H,kb,ka,ka_end)
%E_TO_A_CONVERGENCE Summary of this function goes here
%   Detailed explanation goes here
ans_v = zeros(1,(ka_end-ka));
for j = ka:ka_end
    disp(j);
    pa = (R0_H-kb)/(j-kb);
    disp(pa)
    e_to_a = (1-pa*j)/((1-pa)*kb);
    ans_v(j-ka+1) = log((1-R0_H+kb)/(kb)) -log( e_to_a);
    disp('e_to_a:');
    disp(e_to_a);
    disp('limit:');
    disp((1-R0_H+kb)/(kb));
end
plot(ka:ka_end,ans_v)
end

