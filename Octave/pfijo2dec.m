function dec = pfijo2dec(bin,mag,pres) %mag=exponente y pres=fraccional
if bin(1)=='1';
    dec2=-1;
    for n = length(bin):-1:2
       if bin(n)=='1';
        for l = (n-1):-1:1;
         if bin(l)=='0';
            bin(l)=dec2bin(1);
          elseif bin(l)=='1';
            bin(l)=dec2bin(0);
          end
         end
       break
     end
  end
else
    dec2=1;
end

for m = 1:mag
    bin1(m)=bin(m+1);
end
k=mag;
for s = 1:pres
    bin2(s)=bin(k+2);
    k=k+1;
end
dec1=0;
for p = 1:pres
    dec1=dec1+(bin2dec(bin2(p))/(2^p));
end
dec3=bin2dec(bin1);
dec=(dec1+dec3)*dec2;

end