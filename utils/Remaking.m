function s = Remaking(s, fs)
    
s = s.*abs(acot(s));

% 	realFFT = real(fft(s));
%     imagFFT = imag(fft(s));
%     s = ifft(complex(realFFT, imagFFT));

end

