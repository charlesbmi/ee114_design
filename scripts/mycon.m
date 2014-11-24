function [c,ceq] = mycon(sizes)
[gain, bw, pwr] = specs(sizes);
ceq = -1;
c = [40-gain;80-bw]; 
end

