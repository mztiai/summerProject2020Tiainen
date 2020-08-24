function plot_R0_over_ka(R0_H,kb,k,ka,to)
% loop over differing ka
% assume RO_H const, kb const 1 -> pb=1-pa defines pa by R0_H = kapa+kbpb
% calc for one choice of ka -> change value 
% to: number of iter, for now just +1 

ka_orig = ka;
R0_vec = zeros(1,to);

for j = 1:to
    pa = (R0_H-kb)/(ka-kb);
    R0_N = calcR0_N(pa,ka,1-pa,kb,k);
    R0_vec(j) = R0_N;
    ka = ka + 1;
    %X = ['input for func:',num2str(pa),',',num2str(ka),',',num2str(1-pa),',',num2str(kb),',',num2str(k)];
    %disp(X);
    %disp(R0_N);
end

plot(ka_orig:(ka-1),R0_vec)
yline(R0_H)
axis([0 ka+1 0 k+1])
end

