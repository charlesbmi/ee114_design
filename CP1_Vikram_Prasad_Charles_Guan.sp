* Design Problem, ee114/214A- 2014
* Team Member 1 Name: Charles Guan
* Team Member 2 Name: Vikram Prasad
* Please fill in the specification achieved by your circuit 
* before you submit the netlist.
**************************************************************
* sunetids of team members = cguan2, vprasad2
* The specifications that this script achieves are: 
* Power  =   
* Gain   =    
* BandWidth =   
* FOM = 
***************************************************************

** Including the model file
.include /usr/class/ee114/hspice/ee114_hspice.sp

* Defining Top level circuit parameters
.param Cin = 100f
.param CL  = 250f
.param RL  = 20k

* defining the supply voltages

vdd vdd 0 2.5
vss vss 0 -2.5

* Defining the input current source

** For ac simulation uncomment the following 2 lines**
 Iina		iina	vdd	ac	0.5	
 Iinb		vdd	iinb	ac	0.5	

** For transient simulation uncomment the following 2 lines**
*Iina		iina	vdd	sin(0 0.5u 1e6)
*Iinb		vdd	iinb	sin(0 0.5u 1e6)

* Defining Input capacitance

Cina	vdd	iina 'Cin'
Cinb	vdd	iinb 'Cin'

* Defining the differential load 

RL	vouta		voutb		'RL'
CL	vouta		voutb		'CL'

*** Your Trans-impedance Amplifier here ***
***	d	g	s	b	n/pmos114	w	l

*** A Side ***
m1a     vxa     0       iina    vss     nmos114         (W1)    (L1)
mb1a    iina    vbiasn  0       vss     nmos114         (WB1)   (LB1)
ml1a    vxa     vbiasp  vdd     vdd     pmos114         (WL1)   (LL1)
Rua     vdd     vxa     (RU)
Rda     vxa     vss     (RD)
m2a     vya     vxa     vz      vss     nmos114         (W2)    (L2)
mb2a    vz      vbiasn  vss     vss     nmos114         (WB2)   (LB2)
ml2a    vdd     vdd     vya     vss     nmos114         (WL2)   (LL2)
m3a     vdd     vya     vouta   vss     nmos114         (W3)   (L3)
mb3a    vouta   vbiasn  vss     vss     nmos114         (WB3)   (LB3)  

*** B Side ***
*NAME D G S B MODEL WIDTH LENGTH
M1b vxb 0 iinb vss nmos114 [WIDTH1] [LENGTH1]
Mbias-1b iinb vbiasn vss vss nmos114 [WIDTHBIAS-1B] [LENGTHBIAS-1B]
ML-1b vx vbiasp vdd vdd pmos114 [WIDTHL-1B] [LENGTHL-1B]
ML-2b vdd vdd vy vss nmos114 [WIDTHL-2B] [LENGTHL-2B]
M2b vy vx vz vss nmos114 [WIDTHBIAS2B] [LENGTH2B]
Mbias-2b vz vbiasn vss vss nmos114 [WIDTHBIAS-2B] [LENGTHBIAS-2B]
M3b vdd vy voutb vss nmos114 [WIDTH3B] [LENGTH3B]
Mbias-3b voutb vbiasn vss vss nmos114 [WIDTHBIAS-3B] [LENGTHBIAS-3B]

*** Current Bias ***


*** Your Bias Circuitry here ***
vbiasn vbiasn 0 [VOLTAGE]
vbiasp vbiasp 0 [VOLTAGE]

* defining the analysis

.op
.option post brief nomod

** For ac simulation uncomment the following line** 
.ac dec 1k 100 1g

.measure ac gainmaxa max v(vouta)
.measure ac f3dba when vdb(vouta)='gainmaxa-3'

.measure ac gainmaxb max v(voutb)
.measure ac f3dbb when vdb(voutb)='gainmaxb-3'

.measure ac gaindiff max v(vouta, voutb)

** For transient simulation uncomment the following line **
*.tran 0.01u 4u 

.end
