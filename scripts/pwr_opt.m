% Charles Guan and Vikram Prasad
% EE114 Design Project
% Script for power optimization

clear all;

W1 = 5;
L1 = 1;
WB1 = 10; % todo sweep this and lock WL1 as appropriate
LB1 = 2;
WL1 = 5; % lock this with WB1
LL1 = 1;
W2 = 4; % todo sweep this
L2 = 1;
WB2 = 2; % todo sweep this
LB2 = 2;
WL2 = 2;
LL2 = 2;
W3 = 20; % what to do with this? I guess this can be very large. because of Miller cancel. But not too large?
L3 = 1;
WB3 = 10; % todo sweep this
LB3 = 2;

min_cost = 1e10;
min_pwr = 0;
best_sizes = 0;
best_R = 0;

% todo parfor on cluster?
%WBR = [2, 5, 10, 15, 20, 25] % Bias width range 
WBR = [2:5,7,10]

for WB1 = WBR
    WL1 = 2*WB1/LB1*LL1; % match sizes to match current, diff uc
    for W2 = [2:6]
        for WB2 = WBR
            for WB3 = WBR
                for W3 = [15,25,27]

x = [W1;L1;WB1;LB1;WL1;LL1;W2;L2;WB2;LB2;WL2;LL2;W3;L3;WB3;LB3];
[gain, bw, pwr, Req] = specs(x*1e-6);
cost = max(40-gain,0) + max(80-bw,0) + pwr;
if cost < min_cost & pwr < 2.5
    min_cost = cost
    min_pwr = pwr;
    best_sizes = x;
    best_R = Req;
end

>>>>>>> 0f3c51fa8fbf653de13fe097834cf664e1f40e54
                end
            end
        end
    end
end
