function l = RadiusVector(s)
    s = [2 3 5 7]
    A = s(1:end-1);
    B = s(2:end);
    for i = 1:length(s)-1
        l(i)=sqrt(A(i)^2 + B(i)^2);
    end
    plot(A, B)
end

