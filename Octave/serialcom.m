function [] = serialcom(port,BR,n,prec)
pkg load instrument-control;

s1 = serial(port, BR); 
srl_flush(s1)
data = srl_read(s1,n);
datahex = dec2hex(data);
datos=0;

%f1=fopen('/home/jeffryqf/Desktop/Result_SIN64_200MHz_fpga_2048.txt','w');
%f1=fopen('/home/jjrojas/Documents/Prueba_Xilinx_1Sumador_Deslinealizador_I_PipelineMult.txt','w');
f1=fopen('/home/jjrojas/Documents/Prueba_Xilinx_NuevoCORDIC.txt','w');
if(prec==32)
  datos = n/2;
  for(j=1 : 4 : n)
        fprintf(f1,'%s', datahex(j,1));
        fprintf(f1,'%s', datahex(j,2));
        fprintf(f1,'%s', datahex(j+1,1));
        fprintf(f1,'%s', datahex(j+1,2));
        fprintf(f1,'%s', datahex(j+2,1));
        fprintf(f1,'%s', datahex(j+2,2));
        fprintf(f1,'%s', datahex(j+3,1));
        fprintf(f1,'%s\n', datahex(j+3,2));
  end
else
  datos = n/8;
  for(j=1 : 8 : n)
      fprintf(f1,'%s', datahex(j,1));
      fprintf(f1,'%s', datahex(j,2));
      fprintf(f1,'%s', datahex(j+1,1));
      fprintf(f1,'%s', datahex(j+1,2));
      fprintf(f1,'%s', datahex(j+2,1));
      fprintf(f1,'%s', datahex(j+2,2));
      fprintf(f1,'%s', datahex(j+3,1));
      fprintf(f1,'%s', datahex(j+3,2));
      fprintf(f1,'%s', datahex(j+4,1));
      fprintf(f1,'%s', datahex(j+4,2));
      fprintf(f1,'%s', datahex(j+5,1));
      fprintf(f1,'%s', datahex(j+5,2));
      fprintf(f1,'%s', datahex(j+6,1));
      fprintf(f1,'%s', datahex(j+6,2));
      fprintf(f1,'%s', datahex(j+7,1));
      fprintf(f1,'%s\n', datahex(j+7,2));
  end    

endif
fclose(f1);
