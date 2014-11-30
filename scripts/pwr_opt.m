% Charles Guan and Vikram Prasad
% EE114 Design Project
% Script for power optimization

clear all;

W1 = 5e-6;
L1 = 1e-6;
WB1 = 10e-6; % todo sweep this and lock WL1 as appropriate
LB1 = 5e-6;
WL1 = 5e-6; % lock this with WB1
LL1 = 1e-6;
W2 = 4e-6; % todo sweep this
L2 = 1e-6;
WB2 = 2e-6; % todo sweep this
LB2 = 5e-6;
WL2 = 1e-6;
LL2 = 1e-6;
W3 = 25e-6; % what to do with this?
L3 = 1e-6;
WB3 = 10e-6; % todo sweep this
LB3 = 5e-6;

x0 = [W1;L1;WB1;LB1;WL1;LL1;W2;L2;WB2;LB2;WL2;LL2;W3;L3;WB3;LB3];
Lmin = 1e-6;
LBmin = 2e-6;
Wmin = 2e-6;
Lmax = 20e-6;
Wmax = 50e-6;

xmin = [Wmin;Lmin;Wmin;LBmin;Wmin;Lmin;Wmin;Lmin;Wmin;LBmin;Wmin;Lmin;Wmin;Lmin;Wmin;LBmin];
xmax = [Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax];
%x = lsqnonlin(@specs,x0)%,xmin,xmax)
%opts = optimset('TypicalX',x0,'TolX',1e-9)
%[x, min_pwr] = fmincon(@(x) specs(x),x0,[],[],[],[],xmin,xmax,@(x) mycon(x),opts)

min_cost = 1e10;
best_sizes = x0;
d = 2; % denominator
% TODO parfor this on the cluster  with lock

for W1diff = -W1/2:W1/d:W1/2
    for WB1diff = -WB1/2:WB1/d:WB1/2
        disp('1 more');
        for WL1diff = -WL1/2:WL1/d:WL1/2
            for W2diff = -W2/2:W2/d:W2/2
                for WB2diff = -WB2/2:WB2/d:WB2/2
                    for WL2diff = -WL2/2:WL2/d:WL2/2
                        for W3diff = -W3/2:W3/d:W3/2
                            for WB3diff = -WB3/2:WB3/d:WB3/2

                                    xdiff = [W1diff;0;WB1diff;0;WL1diff;0;W2diff;0;WB2diff;0;WL2diff;0;W3diff;0;WB3diff;0];
                                    [gain, bw, pwr] = specs(x0 + xdiff);
                                    cost = norm([gain; bw; pwr] - [45; 90; 0]);
                                    if cost < min_cost
                                        min_cost = cost;
                                        best_sizes = x0 + xdiff;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


