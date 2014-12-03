* Design Problem, ee114/214A- 2014
* Team Member 1 Name: Charles Guan
* Team Member 2 Name: Vikram Prasad
* btw(Both members enrolled in 114)
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

*** Trans-impedance Amplifier ***
***	d	g	s	b	n/pmos114	w	l

*** A Side ***
M1a     vxa     0       iina    vss     nmos114         w='W1'    l='L1'
Mbias1a iina    vbiasn  vss     vss     nmos114         w='WB1'   l='LB1'
*ML1a    vxa     vbiasp  vdd     vdd     pmos114         w='WL1'   l='LL1'
*Rua     vdd     vxa     'RU'
*Rda     vxa     vss     'RD'
M2a     vcsa    vxa     vz      vss     nmos114         w='W2'    l='L2'
Mbias2a vz      vbiasn  vss     vss     nmos114         w='WB2'   l='LB2'
*ML2a    vdd     vdd     vya     vss     nmos114         w='WL2'   l='LL2'
M3a     vdd     vya     vouta   vss     nmos114         w='W3'    l='L3'
Mbias3a vouta   vbiasn  vss     vss     nmos114         w='WB3'   l='LB3'  

*** Cascode 
***	d	g	s	b	n/pmos114	w	l
*Mcasc2a vya     vbiasp    vcsa    vss     nmos114         w='W2'    l='L2'
*Mcasc2b vyb     vbiasp     vcsb    vss     nmos114         w='W2'    l='L2'
Ra vya vcsa 0
Rb vyb vcsb 0
* switch to pmos, then gs connect it
*ML2a    vya     vya     vdd     vdd     pmos114         w='WL2'   l='LL2'
*ML2b    vyb     vya     vdd     vdd     pmos114         w='WL2' l='LL2'
*** nmos original
ML2b    vdd     vdd     vyb     vss     nmos114         w='WL2' l='LL2'
ML2a    vdd     vdd     vya     vss     nmos114         w='WL2'   l='LL2'
** Capacitor nulling
*Mcapa2b vyb     vxa     vyb     vss     nmos114         w='W2/2'  l='L2'
*Mcapb2a vya     vxb     vya     vss     nmos114          w='W2/2'  l='L2'
Rda vdd vxa 50K
Rdb vdd vxb 50K

*** Cascode-regulated NMOS decrease input impedance
*Mb1a    vg1   vbiasp  vdd       vdd     pmos114         w='WL1'   l='LL1'
*Mfb1a   vg1   iina    vss       vss     nmos114         w='W1'    l='L1'

*** B Side ***
*NAME D G S B MODEL WIDTH LENGTH
M1b     vxb     0       iinb    vss     nmos114         w='W1' l='L1'
Mbias1b iinb    vbiasn  vss     vss     nmos114         w='WB1' l='LB1'
*ML1b    vxb     vbiasp  vdd     vdd     pmos114         w='WL1' l='LL1'
*ML2b    vdd     vdd     vyb     vss     nmos114         w='WL2' l='LL2'
M2b     vcsb     vxb     vz      vss     nmos114         w='W2'  l='L2'
Mbias2b vz      vbiasn  vss     vss     nmos114         w='WB2' l='LB2'
M3b     vdd     vyb     voutb   vss     nmos114         w='W3' l='L3'
Mbias3b voutb   vbiasn  vss     vss     nmos114         w='WB3' l='LB3'
*Rub     vdd     vxb     'RU'
*Rdb     vxb     vss     'RD'

*** Variables ***
.param W1 = 5u
.param L1 = 1u
.param WB1 = 2u
.param LB1 = 3u
.param WL1 = 3u
.param LL1 = 2u
.param W2 = 3u
.param L2 = 1u 
.param WB2 = 2u
.param LB2 = 6u
.param WL2 = 2u
.param LL2 = 1.6u
.param W3 = 26u
.param L3 = 1u
.param WB3 = 4u
.param LB3 = 2u
.param RU = 90K
.param RD = 90K 

*** Current Bias ***


*** Your Bias Circuitry here ***
vbiasn vbiasn 0 -1
vbiasp vbiasp 0 1

* defining the analysis

.op
.option post brief nomod

** For ac simulation uncomment the following line** 
.ac dec 1k 100 1g

.measure ac gainmaxa max vdb(vouta)
.measure ac gaindiff max v(vouta, voutb)
.measure ac f3dba when vdb(vouta)='gainmaxa-3'

.measure ac gainmaxb max vdb(voutb)
.measure ac f3dbb when vdb(voutb)='gainmaxb-3'

** For transient simulation uncomment the following line **
*.tran 0.01u 4u 
*.probe tran v(vouta,voutb)

.end
