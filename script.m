% Vikram Prasad and Charles Guan

% Sample variable values
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

% Constants
lam = 0.1; % lambda', ie lambda = lambda' / length
Cov = 0.5e-9; % Cov'=0.5fF/um, Cov=Cov'*W;

% Junction capcitance calculations
Ldiff = 3e-6; % junction capacitances
n_CJ = 0.1e-3; % 0.1 fF/um^2
n_CJSW = 0.5e-9; % 0.5 fF/um
MJ = 0.5;
MJSW = 1/3;
PB = 0.95;

function C_junc = n_Cj(W, Vsb)
% Calculates junction capacitance (Cjdb and Cjsb) for NMOS)
% Vsb is interchangebale for Vdb here
AS = W*Ldiff;
PS = W + 2*Ldiff;
C_junc = AS*CJ/(1+Vsb/PB)^MJ + PS*CJSW/(1+Vsb/PB)^MJ;
end

ro1 = L1 / (lam*i1);
ro1 = LL1 / (lam*i1);

function Req = par(R1,R2)
Req = R1*R2/(R1+R2);
end

Av1 = Ru || Rd || roL1 || ro1

%%%%%%%%%%%%%%%%%%
% Pole 1 computation
%%%%%%%%%%%%%%%%%%
C1 = Cin + Cgs1 + Csb1+Cgdbias1+Cdbbias1
R1 = robias1 || ro1b ||  1/ (1.2*gm1)*(1 + (RL || Ru|| Rd)/ro1) % drain resistance from above)
tau_in1 = R1*C1;

%%
% Capacitance at node x % defined in 
Cx = Cgd1 + Cgb1 + CdbL1 + CdgL1 + Cgs2 + Cgb2 + Cgd2*(1-K) % K defined above, but take the sign properly now!!
Rx = % calculated above as RL
tau_x = Cx*Rx;

%%% Node y pole %% todo decompose per node. ie Cg3 (what you see from each)
Cy = Cdb2 + Cgd2*(1-1/K) + CsbL2 + CsgL2 + Cgs3*(1-K) + Cgd3 + Cgb3 % about zero for Cgs3
Ry = ro2 || 1/gmL2  || 1/gmbL2 || roL2
tau_y = Cy * Ry

%%%% Output node
Cout = Csb3 + Cgs3(1-1/K) % about zero
+ Cgdbias3 + Cdbbias3 + 2*CL % 2x because of diff mode
Rout = 1/(1.2*gm3) || ro3 || ro3bias3b || RL/2 % body effect 
tau_out = Cout * Rout
