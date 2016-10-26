#This program performs basic operations related with Solar Photovoltaic Panels

#Importing packages
import matplotlib.pyplot as plt
import math
import numpy as np
from scipy.integrate import odeint

from matplotlib import rc
rc('text', usetex=True)      #LaTeX psfrag
rc('font', family='Times')   #LaTeX psfrag

puntos=200

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

print alpha
print math.log(Psi)
print V_oc

#Causal v->i model for the PV generator: model 1.
def obtainPVcurrent(Lambda,Psi,alpha,cc,v):
    "This function obtains the PV current from the PV model 1"
    y=math.log(Lambda)				#Short-Circuit logarithm
    beta=math.log(Psi)				#Is current logarithm
    V_oc_eval=(y-beta)/alpha			#Open circuit evaluation
    if v>V_oc_eval:           			#in case the input voltage is larger than V_oc
        i_fun=0					#Ipv = 0
    else:
        i_fun=Lambda-Psi*math.exp(alpha*v)-cc*v	#Ipv = Isc-Is*e^(alpha*Vpv)
    return i_fun
#------------------------------------------------
v_test=np.logspace(math.log(0.001),math.log(V_oc),num=puntos,endpoint=True,base=e); #Numpy logspace, describes an exponential function from 0.001 to Voc

i_out=np.zeros(puntos)

P_out=np.zeros(puntos)

for i in range(1,puntos):
    i_out[i]=obtainPVcurrent(Lambda,Psi,alpha,0,V_oc-v_test[i])
    P_out[i]=i_out[i]*(V_oc-v_test[i])

fig=plt.figure(1);				 #Figure plots Ipv-Vpv
ax=fig.add_subplot(211)
ax.plot(V_oc-v_test,i_out,'k-', lw=2.5)
ax.plot(V_mpp,I_mpp,'or',markersize=8)
ax.axis([0,25,0,5])
#ax.set_xticklabels(' ',visible=False)		 #Uncomment to not show axis	
#ax.set_yticklabels(' ',visible=False)		 #Uncomment to not show axis
ax.grid(True)
ax.set_xlabel('$v_\mathrm{pv}$ (V)',fontsize=16)
ax.set_ylabel('$i_\mathrm{pv}$ (A)',fontsize=16)

ax=fig.add_subplot(212)				 #Figure plots Ppv-Vpv
ax.plot(V_oc-v_test,P_out,'k-', lw=2.5)
ax.plot(V_mpp,P_mpp,'or',markersize=8)
ax.axis([0,25,0,75])
#ax.set_xticklabels(' ',visible=False)
#ax.set_yticklabels(' ',visible=False)
ax.grid(True)
ax.set_xlabel('$v_\mathrm{pv}$ (V)',fontsize=16)
ax.set_ylabel('$P_\mathrm{pv}$ (W)',fontsize=16)

fig.savefig('iv_pot_curve.eps')

plt.show()
