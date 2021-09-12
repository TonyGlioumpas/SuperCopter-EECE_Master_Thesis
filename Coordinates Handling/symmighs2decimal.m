function decimal = symmighs2decimal(a,b,c)

%Morfh symmigh: 23°27'24.12''
%Morfh decimal: 23.4567°

a1 = b/60;
a2 = c/3600;
a3 = a1+a2;

decimal = a+a3;

end

