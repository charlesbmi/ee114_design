* Design Problem, ee114/214A- 2014
* Team Member 1 Name:
* Team Member 2 Name:
* Please fill in the specification achieved by your circuit 
* before you submit the netlist.
**************************************************************
* sunetids of team members = 
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


*** B Side ***


*** Current Bias ***


*** Your Bias Circuitry here ***


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
