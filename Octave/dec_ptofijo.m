% Juan Jose Rojas Salazar 
% Encargado de la conversion decimal a punto fijo
% Conversion Decimal2FixedPoint(Num.dec,fraccional,tamaño total secuencia binaria)
% Decimal2FixedPoint es dependiente de la funcion dec2twos (revisar que este en la misma carpeta)
%
%function dec_ptofijo()
%
%    %Encargado de la conversion decimal a punto fijo
%    %Conversion Decimal2FixedPoint(Num.dec,fraccional,tamaño total secuencia binaria)
%    %Decimal2FixedPoint es dependiente de la funcion dec2twos (revisar que este en la misma carpeta)
%
%    entrada1 = fopen('Valores_prueba_I.txt','r');              %Valores de prueba corriente estimador 
%    salida1 = fopen('EstimuloCorrienteW_ptofijo.txt','w');     %Valores de salida corriente estimador en punto fijo 
%    entrada2 = fopen('Valores_prueba_V','r');                  %Valores de prueba tension estimador    
%    salida2 = fopen('EstimuloTensionY_ptofijo.txt','w');       %Valores de salida tension estimador en punto fijo  
%    
%    formato = '%f';
%    A = fscanf(entrada1,formato);
%    B = fscanf(entrada2,formato);
%    
%        for i = 1:30000
%            y(i)=cellstr(Decimal2FixedPoint(log(A(i)),16,32)); %Conversion decimal a punto fijo
%            z(i)=cellstr(Decimal2FixedPoint(B(i),16,32));
%            fprintf(salida1,'%s\n',y{i});                      %Escritura en archivos de salida
%            fprintf(salida2,'%s\n',z{i});
%        end
%        
%           
%    fclose(entrada1);                                          %Cierra I/O archivos  
%    fclose(salida1);
%    fclose(entrada2);
%    fclose(salida2);
%    
%end

function dec_ptofijo()

    %Encargado de la conversion decimal a punto fijo
    %Conversion Decimal2FixedPoint(Num.dec,fraccional,tamaño total secuencia binaria)
    %Decimal2FixedPoint es dependiente de la funcion dec2twos (revisar que este en la misma carpeta)

    entrada1 = fopen('Theta_1.txt','r');              %Valores de prueba corriente estimador 
    salida1 = fopen('Theta_1_ptofijo.txt','w');       %Valores de salida corriente estimador en punto fijo 
    entrada2 = fopen('Theta_2.txt','r');              %Valores de prueba tension estimador    
    salida2 = fopen('Theta_2_ptofijo.txt','w');       %Valores de salida tension estimador en punto fijo  
    
    formato = '%f';
    A = fscanf(entrada1,formato);
    B = fscanf(entrada2,formato);
    
        for i = 1:1000
            y(i)=cellstr(Decimal2FixedPoint(A(i),26,32));      %Conversion decimal a punto fijo
            z(i)=cellstr(Decimal2FixedPoint(B(i),26,32));
            fprintf(salida1,'%s\n',y{i});                      %Escritura en archivos de salida
            fprintf(salida2,'%s\n',z{i});
        end
        
           
    fclose(entrada1);                                          %Cierra I/O archivos  
    fclose(salida1);
    fclose(entrada2);
    fclose(salida2);
    
end
