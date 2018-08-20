function PlotFFTabs(s, fs)
    fftabs = abs(fft(s, fs));
    fftabs = fftabs(1:round(end/2));
    semilogx(fftabs)
end
