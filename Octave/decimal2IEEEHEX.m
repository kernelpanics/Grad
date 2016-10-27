function decimal2IEEEHEX()

    entrada = fopen('Theta_2.txt','r');
    salida = fopen('Theta_2_HEX.txt','w');
    formato = '%f';
    A = fscanf(entrada,formato);

        for i = 1:1000
            y(i)=cellstr(num2hex(single(A(i))));
            fprintf(salida,'%s\n',y{i});
        end
           
    fclose(entrada)
    fclose(salida);
    
end
