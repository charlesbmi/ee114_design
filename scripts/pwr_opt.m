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

specs(x0)

xmin = [Wmin;Lmin;Wmin;LBmin;Wmin;Lmin;Wmin;Lmin;Wmin;LBmin;Wmin;Lmin;Wmin;Lmin;Wmin;LBmin;Rmin;Rmin];
xmax = [Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Wmax;Lmax;Rmax;Rmax];
%x = lsqnonlin(@specs,x0)%,xmin,xmax)
x = fmincon(@specs,x0,[],[],[],[],xmin,xmax,@mycon,'TypicalX',x0,'TolX',1e-7)
