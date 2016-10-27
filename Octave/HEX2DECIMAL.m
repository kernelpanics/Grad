%function HEX2DECIMAL()

    %entrada = fopen('I_LINEAL_NORM.txt','r');
    %salida = fopen('I_LINEAL_NORM_HEX.txt','w');
%    entrada = fopen('Prueba_Xilinx_3Sumador_Desnormalizador_Deslinealizador_I.txt','r');
%    salida = fopen('Prueba_Xilinx_3Sumador_Desnormalizador_Deslinealizador_I_DECIMAL.txt','w');
%    formato = '%s';
%    A = fscanf(entrada,formato);
%    p=1;
%    m=8;
%        for i = 1:1000
%            y(i)=typecast(uint32(hex2dec(A(p:m))), 'single');
%            %y(i)=cellstr(bin2hex2(A(p:m)));
%            fprintf(salida,'%1.42f\n',y(i));
%            p=p+8;
%            m=m+8;
%        end
           
%    fclose(entrada);
%    fclose(salida);
%    
%end

function HEX2DECIMAL()

%    entrada1 = fopen('Prueba_Xilinx_Conv Fijo Flotante.txt','r');
%    entrada2 = fopen('Prueba_Xilinx_Conv Fijo Flotante_2.txt','r');
%    salida1 = fopen('Prueba_Xilinx_Conv Fijo Flotante_DECIMAL.txt','w');
%    salida2 = fopen('Prueba_Xilinx_Conv Fijo Flotante_2_DECIMAL.txt','w');

    entrada1 = fopen('Theta_1_Flotante.txt','r');
    entrada2 = fopen('Theta_2_Flotante.txt','r');
    salida1 = fopen('Theta_1 Flotante_DECIMAL.txt','w');
    salida2 = fopen('Theta_2 Flotante_DECIMAL.txt','w');
		
    formato = '%s';
    A = fscanf(entrada1,formato);
    B = fscanf(entrada2,formato);
    
    p=1;
    m=8;
        for i = 1:1000
            y(i)=typecast(uint32(hex2dec(A(p:m))), 'single');
            z(i)=typecast(uint32(hex2dec(B(p:m))), 'single');
            %y(i)=cellstr(bin2hex2(A(p:m)));
            fprintf(salida1,'%1.42f\n',y(i));
            fprintf(salida2,'%1.42f\n',z(i));
            p=p+8;
            m=m+8;
        end
           
    fclose(entrada1);
    fclose(salida1);
    fclose(entrada2);
    fclose(salida2);
    
end
