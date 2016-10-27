import struct
import math
import csv
import binascii

#PV without series resistance 										#Electrical parameters for Kyocera Solar KC65T
Lambda=3.99    												#Short-Circuit current Ig+Is, assumption Is<<Ig equals to Ig
Psi=5.1387085e-6											#Is current (saturation)
alpha=0.625												#Thermal voltage relation 1/(n*Vt)
V_oc=1/alpha*(math.log(Lambda/Psi))									#Open circuit voltage
V_mpp=17.4												#Maximum power point voltage
I_mpp=3.75												#Maximum power point current
P_mpp=65.25												#Maximum power 
y=math.log(Lambda)											#Short-Circuit logarithm
b=math.log(Psi)												#Is current logarithm
Rp=100													#Parallel resistance			
e=math.exp(1)					

# Create the time samples for the output of the ODE solver.
stoptime = 0.005
numpoints = 1000#00
t = [stoptime * int(j) / (numpoints - 1) for j in range(numpoints)]					# Time Samples

Vpv=[]													# Vpv value data array 
ipv=[]													# Ipv value data array
    
z=[]													# Z input estimator
y=[]													# Y input estimator
yreal = []
ynorm = [] 												# Normalized entry data estimator

P= []													# Data arrays	
PV = []
FIX = []
FIXV = []
F=[]
FX=[]


def InputVoltage(t):											#Vpv							
    "This functions defines the time evolution of v"
    V_cte=16.69
    return V_cte+0.3*V_cte*math.sin(2*math.pi*100*t)

def ModelPV():
    j=0
    while j< numpoints: 										#Vpv/Ipv time data samples
            Vpv.append(InputVoltage(t[j])) 
            ipv.append((Lambda-(Vpv[j]/Rp)-Psi*(e**(Vpv[j]*alpha)))/2)					#Correct this equation!
            j=j+1
            
def binary(num):											#Binary struct pack
    return ''.join(bin(c).replace('0b', '').rjust(8, '0') for c in struct.pack('!f', num))

def creartxt():												#Create txt files																
    I=open('LINEALIZACION_NORMALIZACION_I.txt','w')
    I.close()
    ipv_d=open('Valores_ipv_decimal.txt','w')
    ipv_d.close()
    V=open('NORMALIZACION_V.txt','w')
    V.close()
    Vpv_d=open('Valores_Vpv_decimal.txt','w')
    Vpv_d.close()
    I_LI_NOR=open('Corriente_lineal_y_normalizada.txt','w')
    I_LI_NOR.close()
    V_LI_NOR=open('Tension_lineal_y_normalizada.txt','w')
    V_LI_NOR.close()
    
def grabartxt():											#Save data on txt files
    j=0;
    I=open('LINEALIZACION_NORMALIZACION_I.txt','a')
    ipv_d=open('Valores_ipv_decimal.txt','a')
    V=open('NORMALIZACION_V.txt','a')
    Vpv_d=open('Valores_Vpv_decimal.txt','a')
    V_L_NOR=open('Tension_lineal_y_normalizada.txt','a')
    I_LI_NOR=open('Corriente_lineal_y_normalizada.txt','a')
    
    while j< numpoints: 										#Floating point convertion Vpv & Ipv (saves to txt)
            ipv_f = binary(ipv[j])
            Vpv_f = binary(Vpv[j])
            ILN = math.log(ipv[j])*0.19964110454							#Normalized data in max ranges (remove if possible)
            VLN = Vpv[j]*0.05524861878
            I.write(ipv_f)
            I.write(" ")
            ipv_d.write(str(ipv[j]))
            ipv_d.write("\n")
            V.write(Vpv_f)
            V.write(" ")
            Vpv_d.write(str(Vpv[j]))
            Vpv_d.write("\n")
            I_LI_NOR.write(str(ILN))
            I_LI_NOR.write("\n")
            V_LI_NOR.write(str(VLN))
            V_LI_NOR.write("\n")
            j=j+1
    I.close()
    ipv_d.close()
    V.close()
    Vpv_d.close()
    V_LI_NOR.close()
    I_LI_NOR.close()


def fixed_to_dec(FLOAT):										#Fixed to decimal convertion
    cont = 0
    dec = 0
    #str(y) 
    if FLOAT[0] == '1':
        Iter = 1
        y = FLOAT.replace("1", "2")
        z = y.replace("0", "1")
        F = z.replace("2", "0")
        #resultado = int(F, 2) + 1
        #resultadoP = bin(resultado)
        #FF=resultadoP.replace("0b", "000")
        #print(F)
        #print (resultadoP)
        #print(FF)
        while cont < 32:
            dec = dec + int(F[cont])*(2**Iter)
            Iter = Iter - 1
            cont = cont + 1
        dec = -dec
    else:
        Iter = 1
        while cont < 32:
            dec = dec + int(FLOAT[cont])*(2**Iter)
            Iter = Iter - 1
            cont = cont + 1


    return dec

def leertxtI():												#Read Ipv & Vpv fixed point/normalized data
    I_fixed=open('I_LINEAL_NORM.txt','r')
       
    lineaI=I_fixed.readline()
    
    while lineaI!="":
        #print lineaI
        P.append(lineaI)
        lineaI=I_fixed.readline()

    I_fixed.close()

def leertxtV():
    V_fixed=open('V_NORM.txt','r')
       
    lineaV=V_fixed.readline()
    
    while lineaV!="":
        #print lineaI
        PV.append(lineaV)
        lineaV=V_fixed.readline()

    V_fixed.close()
    
def FixedI():
    leertxtI()
    contador=0
    y=P[0]
    contador2=0
    while contador < 1000:
        
        FIX.append(y[contador2:contador2+32])
        contador2 = contador2 + 33;
        print(fixed_to_dec(FIX[contador]))
        contador = contador +1    
        

def FixedV():
    leertxtV()
    contador=0
    y=PV[0]
    contador2=0
    while contador < 999:
        
        FIXV.append(y[contador2:contador2+32])
        contador2 = contador2 + 33;
        print(fixed_to_dec(FIXV[contador]))
        contador = contador +1    


def float_dec():											#Floating point to decimal
    
    I_fixed=open('I_LINEAL.txt','r')
       
    lineaI=I_fixed.readline()
    
    while lineaI!="":
        #print lineaI
        F.append(lineaI)
        lineaI=I_fixed.readline()

    I_fixed.close()

    contador=0
    y=F[0]
    contador2=0
    while contador < 1000:
        
        FX.append(y[contador2:contador2+32])
        contador2 = contador2 + 33;
        x=FX[contador]
        FF= '001'+ str(x[10:40]) +'0000000'; 
        if x[0] == 0:
            if x[1:9] > 127:
                print((2**(int(x[1:9],2)-127))*(fixed_to_dec(FF)+1))
            else:
                print((2**(int(x[1:9],2)+127))*(fixed_to_dec(FF)+1))
        else:
            if x[1:9] > 127: 
                print(-1*(2**(int(x[1:9],2)-127))*(fixed_to_dec(FF)+1))
            else:
                print(-1*(2**(int(x[1:9],2)+127))*(fixed_to_dec(FF)+1))
        contador = contador +1

def F2D(arg):
    cont = 0
    exp = 0
    dec = 0;
    while cont < 24:
        dec = dec + (2**(exp))* int(arg[cont])
        cont = cont + 1
        exp = exp - 1
    return dec
        
    

def float_dec2():
    
    I_fixed=open('I_LINEAL.txt','r')
       
    lineaI=I_fixed.readline()
    
    while lineaI!="":
        #print lineaI
        F.append(lineaI)
        lineaI=I_fixed.readline()

    I_fixed.close()

    contador=0
    y=F[0]
    contador2=0
    while contador < 1000:
        
        FX.append(y[contador2:contador2+32])
        contador2 = contador2 + 33;
        x=FX[contador]
        FF= '1'+ str(x[9:32] + '00000000'); 
        if x[0] == 0:
            if x[1:9] > 127:
                print((2**(int(x[1:9],2)-127))*(F2D(FF)))
            else:
                print((2**(int(x[1:9],2)+127))*(F2D(FF)))
        else:
            if x[1:9] > 127: 
                print(-1*(2**(int(x[1:9],2)-127))*(F2D(FF)))
            else:
                print(-1*(2**(int(x[1:9],2)+127))*(F2D(FF)))
        contador = contador +1
        

def exp():												#Exponential random 
    cont = 0
    exp = []
    x = 5.009

    I=open('0.0066777-0.58495.txt','w')
    I.close()

    j=0;
    I=open('0.0066777-0.58495.txt','a')

    
    
    while cont < 1000:
        exp.append (binary(math.exp(-x)))
        x = x - 0.00447277
        cont = cont + 1

    while j< 1000: 
            
            I.write(exp[j])
            I.write(" ")
            j = j+1
    I.close()
    


