%function FLOAT2HEX()

%    entrada = fopen('I_LINEAL.txt','r');
%    salida = fopen('I_LINEAL_HEX.txt','wt');
%    formato = '%c';
%    A = fscanf(entrada,formato);
%    p=1;
%    m=32;
%        for i = 1:1000
%            %y(i)=typecast(uint32(bin2dec(A(p:m))), 'single'); //impresion de binario pto.float o pto.fijo a dec...
%            y(i)=cellstr(bin2hex(A(p:m)));
%            fprintf(salida,'%s\n',y{i});
%            %fprintf(salida,'%f\n',y(i)); //impresion de numeros en decimal pto.flotante
%            p=p+33;
%            m=m+33;
%        end
%        
%    fclose(entrada);
%    fclose(salida);
    
%end

function FLOAT2HEX()

    entrada1 = fopen('Theta_1_ptofijo.txt','r');
    entrada2 = fopen('Theta_2_ptofijo.txt','r');
    salida1 = fopen('Theta_1_HEX.txt','wt');
    salida2 = fopen('Theta_2_HEX.txt','wt');
    
    formato = '%c';
    A = fscanf(entrada1,formato);
	B = fscanf(entrada2,formato); 	
    
    p=1;
    m=32;
        for i = 1:1000
            y(i)=cellstr(bin2hex(A(p:m)));
            z(i)=cellstr(bin2hex(B(p:m)));
            fprintf(salida1,'%s\n',y{i});
            fprintf(salida2,'%s\n',z{i});
            p=p+33;
            m=m+33;
        end
        
    fclose(entrada1);
    fclose(salida1);
    fclose(entrada2);
    fclose(salida2);
    
end
