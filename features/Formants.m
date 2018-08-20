function formants = Formants(s, fs)
%%      calculate coefficients LPC
l = lpc(s, 55);
%%      find root from polynomial coefficients LPC
r = roots(l);
%%      choose only one-sign values
r = r(imag(r)>=0);
%%      calculate angle 
angz = atan2(imag(r),real(r));
%%      frequencies
[frqs,indices] = sort(angz.*(fs/(2*pi)));
%%      bandwidth
bw = -1/2*(fs/(2*pi))*log(abs(r(indices)));
%%      find formants
nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 80 && bw(kk) < 400)
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end