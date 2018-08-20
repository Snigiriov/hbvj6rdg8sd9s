function rms = EstimateRMS(s)
    rms = round(20*log10(std(s)) - 20*log10(20e-6));
end

