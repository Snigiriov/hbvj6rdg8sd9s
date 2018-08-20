function [ang, l]  = CalculateAngle(array)
if length(array) <=3
    error('Ќужно больше значений в векторе (4 и более)')
end
    for i = 1:length(array) - 2
        l(i)=sqrt(((array(i)-array(i+1))^2)+(array(i+1)-array(i+2))^2);
    end

    for i = 1:length(l)-1
        a = l(i);
        b = l(i+1);
        c = sqrt(((array(i)-array(i+2))^2)+(array(i+1)-array(i+3))^2);
        ang(i) = rad2deg(acos((a.^2+b.^2-c.^2)./(2*a*b)));
    end
    
end

