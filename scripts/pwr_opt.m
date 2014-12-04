% Charles Guan and Vikram Prasad
% EE114 Design Project
% Script for power optimization

clear all;

W1 = 5;
L1 = 1;
WB1 = 2;
LB1 = 3;
WL1 = 3;
LL1 = 2;
W2 = 3;
L2 = 1;
WB2 = 2;
LB2 = 4;
WL2 = 2;
LL2 = 1.6;
W3 = 26;
L3 = 1;
WB3 = 4;
LB3 = 2;

min_cost = 1e10;
min_pwr = 0;
best_sizes = 0;
best_R = 0;

% todo parfor on cluster?
%WBR = [2, 5, 10, 15, 20, 25] % Bias width range 
WBR = [2:30]

for ind = 1:numel(WBR)
    W2 = WBR(ind)
    x = [W1;L1;WB1;LB1;WL1;LL1;W2;L2;WB2;LB2;WL2;LL2;W3;L3;WB3;LB3];
    [gain, bw, pwr, I3,govtout3,Av2(ind),tau_x(ind)] = specs(x*1e-6);
end


% I3 vs G/tauout at stage 3
% G-vs-tau_x at stage 2
%for WB1 = WBR
    %WL1 = 2*WB1/LB1*LL1; % match sizes to match current, diff uc
    %for W2 = [2:6]
        %for WB2 = WBR
            %for WB3 = WBR
                %for W3 = [15,25,27,30]
%
%x = [W1;L1;WB1;LB1;WL1;LL1;W2;L2;WB2;LB2;WL2;LL2;W3;L3;WB3;LB3];
%[gain, bw, pwr, Req] = specs(x*1e-6);
%cost = max(40-gain,0) + max(80-bw,0) + pwr;
%if cost < min_cost & pwr < 1.5
    %min_cost = cost
    %min_pwr = pwr;
    %best_sizes = x;
    %best_R = Req;
%end
%
                %end
            %end
        %end
    %end
%end
