function teager = teagerEnergy(s)
teager = diff(s(1:end-1)).^2 - s(1:end-2).*diff(diff(s));