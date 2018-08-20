function l  = CalculateLengths(s)

A = 1:length(s);
B = s;
    for i = 1:length(s) - 1
        l(i)=sqrt((A(i+1) - A(i))^2 + (B(i+1) - B(i))^2);
    end
    
end

