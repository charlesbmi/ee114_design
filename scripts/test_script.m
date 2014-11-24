% Charles Guan and Vikram Prasad
% EE114 Design Project

clear all;

% Sample variable values
W1 = 40e-6;
L1 = 2e-6;
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

% Other components
Vdd = 2.5;
Vss = -2.5;
Cin  = 100e-15;
CL = 250e-15;
RL = 20e3;
Vbiasn = -1;
Vbiasp = 1;

% Constants
lam = 0.1; % lambda', ie lambda = lambda' / length
Cov = 0.5e-9; % Cov'=0.5fF/um, Cov=Cov'*W;
kp = 50e-6; % 50 uA/V^2
Cox = 2.3e-3;
Vov_min = 0.150;
gam = 0.6; %V^0.5
phi = 0.8; %2phi, Vt = Vt0 + gam*(sqrt(2phi+Vsb)-sqrt(2phi))
Vt0 = 0.5;

% Junction capcitance constants
Ldiff = 3e-6; % junction capacitances
n_CJ = 0.1e-3; % 0.1 fF/um^2
n_CJSW = 0.5e-9; % 0.5 fF/um
p_CJ = 0.3e-3;
p_CJSW = 0.35e-9;
MJ = 0.5;
MJSW = 0.33;
PB = 0.95;

% constraints on 
RU = RD; 
% Vx = 0
% todo restrictions:
% W from 2e-6 to 100e-6 in 0.2 increments, probably 50 tops
% L from 1e-6 to idk, 10e-6
% W-L current matching for MB1 and ML1 to match current
% body effect
% approximations
% enforce Vov_min
% enforce Vout restrictions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate op point and initialize MOSFETS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I1 = 0.5*kp*(WB1/LB1)*(Vbiasn-Vss-Vt0)^2 + 1e-6; % todo add CLM
I2 = 0.5*kp*(WB2/LB2)*(Vbiasn-Vss-Vt0)^2 + 1e-6;
I3 = 0.5*kp*(WB3/LB3)*(Vbiasn-Vss-Vt0)^2 + 1e-6;

% according to schematic, MB := M-bias, ML := M-load
MB1 = mosfet(WB1,LB1,I1);
MB2 = mosfet(WB2,LB2,I2);
MB3 = mosfet(WB3,LB3,I3);
M1 = mosfet(W1,L1,I1);
M2 = mosfet(W2,L2,I2);
M3 = mosfet(W3,L3,I3);
ML1 = mosfet(WL1,LL1,I1,'p');
ML2 = mosfet(WL2,LL2,I2);

% Operating point calculations without CLM or body effect
Vin = -sqrt(2*I1/(kp*W1/L1))-Vt0;
Vin = Vin-gam*(sqrt(phi+Vin-Vss)-sqrt(phi)) % body effect,gam*(sqrt(2phi+Vsb)-sqrt(2phi))
Vx = 0;
Vy = Vdd-sqrt(2*I2/(kp*WL2/LL2))-Vt0;
Vy = Vy-gam*(sqrt(phi+Vy-Vss)-sqrt(phi)) % body effect,gam*(sqrt(2phi+Vsb)-sqrt(2phi))
Vz = -sqrt(2*I2/(kp*W2/L2))-Vt0;
Vz = Vz-gam*(sqrt(phi+Vz-Vss)-sqrt(phi))
Vout = Vy-sqrt(2*I3/(kp*W3/L3))-Vt0;
Vout = Vout-gam*(sqrt(phi+Vout-Vss)-sqrt(phi))

% calculate and set junction capacitances
MB1.setCJ(0,Vin-Vss); % vsb, vdb
MB2.setCJ(0,Vz-Vss);
MB3.setCJ(0,Vout-Vss);
M1.setCJ(Vin-Vss,-Vss)
M2.setCJ(Vz-Vss,Vy-Vss);
M3.setCJ(Vout-Vss,Vdd-Vss)
ML1.setCJ(0,Vdd); % using Vbd for PMOS
ML2.setCJ(Vy-Vss,Vdd-Vss);

%%%%%%%%%%%%%%%%%%%%%
% Gain computations %
%%%%%%%%%%%%%%%%%%%%%
%Av1 = par(par(RU,RD), par(ML1.ro,M1.ro)); % RU || RD || roL1 || ro1
R1 = RU | RD | ML1.ro;
R2 = 1/ML2.gmp | M2.ro | ML2.ro;
R3 = M3.ro | 1/M3.gmb | MB3.ro | RL/2; % approx 1/gmb | RL/2

Avin = M1.gmp/(M1.gmp + 1/MB1.ro) % current transfer of CG gm'/(gm'+1/Rs)
Av1 = R1 | M1.ro*(1+M1.gmp*MB1.ro) % RU || RD || roL1 || ro1, approx RU || RD
Av2 = -M2.gm*R2 % gm2*(1/gmL2 || 1/gmbL2 || roL2 || ro2), approx  gm2/gm'L2
Av3 = M3.gm*R3/(M3.gm*R3+1)
Av = abs(Avin*Av1*Av2*Av3);

%%%%%%%%%%%%%%%%%%%%%
% Pole computations %
%%%%%%%%%%%%%%%%%%%%%
% Input pole
Cinput = Cin + M1.Cgs + M1.Csb + MB1.Cgd + MB1.Cdb %Cin + Cgs1 + Csb1 + Cgdbias1 + Cdbbias1
Rinput = MB1.ro | M1.ro | (1 + R1/M1.ro)/M1.gmp; % approx gm1*5/6
tau_in = Rinput*Cinput;

% Node x pole (gate of M2)
Cx = M1.Cgd + ML1.Cdb + ML1.Cgd + M2.Cgs + M2.Cgd*(1-Av2); % Cgd1 + Cgb1 + CdbL1 + CgdL1 + Cgs2 + Cgb2 + Cgd2*(1-Av2). Cgb=0 in sat
Rx = Av1;
tau_x = Cx*Rx

% Node y pole (gate of M3)
Cy = M2.Cdb + M2.Cgd*(1-1/Av2) + ML2.Csb + ML2.Cgs + M3.Cgs*(1-Av3) + M3.Cgd;  %Cdb2 + Cgd2*(1-1/Av2) + CsbL2 + CsgL2 + Cgs3*(1-Av3) + Cgd3 + Cgb3 % approx Cgs3 = 0
Ry = 1/ML2.gmp | M2.ro | ML2.ro; % approx 1/ML2.gmp
tau_y = Cy * Ry

% Output pole
Cout = 2*CL + M3.Csb + M3.Cgs*(1-1/Av3) + MB3.Cgd + MB3.Cdb; % 2x due to diff mode % Cgs negative and about zero due to Miller
%Rout = 1/(1.2*gm3) || ro3 || ro3bias3b || RL/2 % body effect 
Rout = 1/M3.gm | R3;
tau_out = Cout * Rout

zvtc = tau_in + tau_x + tau_y + tau_out
approx_BW_in_Mhz = 1/(2*pi*zvtc)/1e6 * 1.1 % ZVTC tends to underestimate
gain_in_kOhm = Av / 1e3
pwr_in_mW = 1e3*(2*(Vdd-Vss)*(I1+I2+I3) + (Vdd-Vss)^2/(RU+RD)) % in mW
