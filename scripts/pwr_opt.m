% Script for power optimization

W1 = 20e-6;
L1 = 1e-6;
WB1 = 10e-6;
LB1 = 5e-6;
WL1 = 20e-6;
LL1 = 4e-6;
W2 = 9e-6;
L2 = 1e-6;
WB2 = 2e-6;
LB2 = 5e-6;
WL2 = 2e-6;
LL2 = 2e-6;
W3 = 25e-6;
L3 = 1e-6;
WB3 = 10e-6;
LB3 = 5e-6;
RU = 33e3;
RD = 33e3;

x0 = [W1;L1;WB1;LB1;WL1;LL1;W2;L2;WB2;LB2;WL2;LL2;W3;L3;WB3;LB3;RU;RD];
Lmin = 1e-6;
LBmin = 2e-6;
Wmin = 2e-6;
Lmax = 20e-6;
Wmax = 50e-6;
Rmin = 10e3;
Rmax = 120e3;

xmin = [Wmin;Lmin;Wmin;LBmin;Wmin;Lmin;Wmin;Lmin;Wmin;LBmin;Wmin;Lmin;Wmin;Lmin;Wmin;LBmin;Rmin;Rmin];
xmax = [Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Rmax;Rmax];
%x = lsqnonlin(@specs,x0)%,xmin,xmax)
%opts = optimset('TypicalX',x0,'TolX',1e-9)
%[x, min_pwr] = fmincon(@(x) specs(x),x0,[],[],[],[],xmin,xmax,@(x) mycon(x),opts)

best_sizes = x0;
d = 6; % denominator
% TODO parfor this on the cluster  with lock

range = -W1/2:W1/d:W1/2;
min_cost = 1e10*ones(size(range));
best_sizes = repmat(x0,[1 numel(range)]);

for rangei = 1:numel(range)
    W1diff = range(rangei);
    disp(['starting parfor index: ',num2str(rangei)])
    for WB1diff = -WB1/2:WB1/d:WB1/2
        disp('1 more');
        for WL1diff = -WL1/2:WL1/d:WL1/2
            for W2diff = -W2/2:W2/d:W2/2
                for WB2diff = -WB2/2:WB2/d:WB2/2
                    for WL2diff = -WL2/2:WL2/d:WL2/2
                        for W3diff = -W3/2:W3/d:W3/2
                            for WB3diff = -WB3/2:WB3/d:WB3/2
                                for Rdiff = -RU/2:RU/d:RU/2

                                    xdiff = [W1diff;0;WB1diff;0;WL1diff;0;W2diff;0;WB2diff;0;WL2diff;0;W3diff;0;WB3diff;0;Rdiff;Rdiff];
                                    [gain, bw, pwr] = specs(x0 + xdiff);
                                    cost = norm([gain; bw; pwr] - [45; 90; 0]);
                                    if cost < min_cost(rangei)
                                        min_cost(rangei) = cost;
                                        best_sizes(:,rangei) = x0 + xdiff;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


