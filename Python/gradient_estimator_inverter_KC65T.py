#This program performs basic operations related with Solar Photovoltaic Panels

import matplotlib.pyplot as plt
import math
import numpy as np
from scipy.integrate import odeint
import scipy.signal as signal
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='Times')

#Defining some constants
e=math.exp(1)

#Parameters (same as Ph.D. thesis)

Lambda=3.99    					#Short-Circuit current
Psi=5.1387085e-6				#Is current (saturation)
alpha=0.625					#Thermal voltage relation
V_oc=1/alpha*(math.log(Lambda/Psi))		#Open circuit voltage
V_mpp=17.4					#Maximum power point voltage
I_mpp=3.75					#Maximum power point current
P_mpp=65.25					#Maximum power 
y=math.log(Lambda)				#Short-Circuit logarithm
b=math.log(Psi)					#Is current logarithm

#"Linear" simplified PV model 
def LinearPV(alpha,b,v):				
    "This function obtains the PV current from the PV model 1"  #Ipv
    #print (alpha*v+b)					 	#Print y=ln(Ig-Ipv)=alpha*Vpv+ln(Is)							
    return alpha*v+b
#------------------------------------------------
#Time evolution of v
def InputVoltage(t):
    "This functions defines the time evolution of v"		#Vpv	
    V_cte=16.69							#Average voltage
    #print (V_cte+0.3*V_cte*math.sin(2*math.pi*100*t))   	#Print Vpv
    return V_cte+0.3*V_cte*math.sin(2*math.pi*100*t)
#------------------------------------------------

#--------Differential equation----				#Set ODE with stoptime=0.005 for initial estimation
#ODE solver parameters
abserr = 5e-8
relerr = 5e-8
#stoptime = 0.005
stoptime = 15
numpoints = 1000#00

# Create the time samples for the output of the ODE solver.
t = [stoptime * float(i) / (numpoints - 1) for i in range(numpoints)]

#Differential equation
def vectorfield(x,t,p): 					#x:state variables, t:time, p:parameters
    theta1, theta2 = x 
    alpha, b, g11, g12, g21, g22 = p 
    f=[(g11*InputVoltage(t)+g12)*(LinearPV(alpha,b,InputVoltage(t))-theta1*InputVoltage(t)-theta2),
       (g21*InputVoltage(t)+g22)*(LinearPV(alpha,b,InputVoltage(t))-theta1*InputVoltage(t)-theta2)]
    return f

#initial conditions
x1=0.55  	   						#Initial estimation of alpha 
x2=-13             						#Initial estimation of b

#Parameters for the numerical solution of the ode
g1a=0.0375
g1b=0.0625
g2a=135
g2b=121
sumg212=2*math.sqrt(g1b)*math.sqrt(g2b)
#g11=g1a+g1b
#g12=200+sumg212
#g21=-200
#g22=g2a+g2b

g11=0.1								#Gammas
g12=0
g21=0
g22=100

p=[alpha, b, g11, g12, g21, g22]				#parameters for ODE solver
x0=[x1,x2]

wsol = odeint(vectorfield, x0, t, args=(p,),			#wsol for ODE solver
             atol=abserr, rtol=relerr)

fig1=plt.figure(1);						#figure plots
ax=fig1.add_subplot(211)
#ax.axis([0,stoptime,0.0245,0.0290])
#ax.axis([0,stoptime,0.45,0.8])
ax.axis([0,stoptime,0.55,0.66])					#set axis
ax.set_xlabel('t [s]')
ax.set_ylabel(r'$\theta_1$')					#Theta_1 estimated
ax.plot(t,wsol[:,0],lw=2)
ax.plot([0,stoptime],[alpha, alpha],'k--',lw=2);
#with open("Theta_1.txt", "w") as text_file:			#Uncomment to print to txt file wsol(Theta_1) data
#    text_file.write("{}".format(wsol[:,0]))

ax.grid(True)
ax=fig1.add_subplot(212)
#ax.axis([0,stoptime,-17,-15])
#ax.axis([0,stoptime,-15,-11])
ax.axis([0,stoptime,-13.5,-11])
ax.set_xlabel('t [s]')
ax.set_ylabel(r'$\theta_2$')
ax.plot(t,wsol[:,1],lw=2)
ax.plot([0,stoptime],[b, b],'k--',lw=2);
#with open("Theta_2.txt", "w") as text_file:			#Uncomment to print to txt file wsol(Theta_2) data
#    text_file.write("{}".format(wsol[:,1]))

ax.grid(True)

fig2=plt.figure(2);						#Phaseplane Theta_1 vs Theta_2
ax=fig2.add_subplot(111)
ax.axis([0.45,0.8,-15,-9])
ax.set_xlabel(r'$\theta_1$')
ax.set_ylabel(r'$\theta_2$')
ax.plot(wsol[:,0],wsol[:,1],'.b',ms=8)
plt.grid(True)
plt.hold
plt.axis.hold=0
vv=17.4
yy=LinearPV(alpha,b,vv)
print(yy)							#print Ipv
print(b)							#print ln(Is)
aa=np.zeros(2)
bb=np.zeros(2)							#trace line on phaseplane
aa[0]=0
aa[1]=0.8	
bb[0]=yy
bb[1]=-aa[1]*vv+yy
ax.plot(aa,bb,'-k',lw=2)
ax.plot(alpha,b,'ro',ms=8);

fig1.savefig('simulation_estimator1.eps')
fig2.savefig('phaseplane_simulation_estimator1.eps')

plt.show()
