#!/usr/bin/python3

import struct
import math
import csv
import binascii

def binary(num):
    return ''.join(bin(c).replace('0b', '').rjust(8, '0') for c in struct.pack('!f', num))

def exp():
    cont = 0
    exp = []
    #x = 5.009
    x= 0.58495 #para generar numeros negativos

    I=open('0.58495-0.58495.txt','w')
    I.close()

    j=0;
    I=open('0.3645833-0.58495.txt','a')

    
    
    while cont < 1000:
        #exp.append (binary(math.exp(x)))
        exp.append (binary(x)) #para generar numeros negativos
        x = x + 0.0007644
        #x = x + 0.00007277 #para generar numeros negativos
        cont = cont + 1

    while j< 1000: 
            
            I.write(exp[j])
            I.write(" ")
            j = j+1
    I.close()
