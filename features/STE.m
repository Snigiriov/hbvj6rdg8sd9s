function ste = STE(signal, fs)
winLen = round(0.02*fs);
ste = sum(buffer(signal.^2, winLen));