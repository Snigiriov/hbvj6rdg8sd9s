function zcr = ZCR(s)

zcr = sum(abs(diff(s>0)));

end

