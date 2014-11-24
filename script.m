% Vikram Prasad and Charles Guan
% todo define operator

W1 = 40e-6
L1 = 2e-6
WB1 = 10e-6
LB1 = 5e-6
WL1 = 20e-6
LL1 = 4e-6
W2 = 9e-6
L2 = 1e-6 
WB2 = 2e-6
LB2 = 5e-6
WL2 = 2e-6
LL2 = 2e-6
W3 = 25e-6
L3 = 2e-6
WB3 = 10e-6
LB3 = 5e-6
RU = 33e3
RD = 33e3

lam = 0.1; % lambda', ie lambda = lambda' / length

ro1 = L1 / (lam*i1);
ro1 = LL1 / (lam*i1);

Av1 = Ru || Rd || roL1 || ro1

%%%%%%%%%%%%%%%%%%
% Pole 1 computation
%%%%%%%%%%%%%%%%%%
C1 = Cin + Cgs1 + Csb1+Cgdbias1+Cdbbias1
R1 = robias1 || ro1b ||  1/ (1.2*gm1)*(1 + (RL || Ru|| Rd)/ro1) % drain resistance from above)
tau_in1 = R1*C1;

%%
% Capacitance at node x % defined in 
Cx = Cgd1 + Cgb1 + CdbL1 + CdgL1 + Cgs2 + Cgb2 + Cgd2
R
