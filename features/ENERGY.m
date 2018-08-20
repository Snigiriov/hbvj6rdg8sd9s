function [sumEnergy, i, maxEnergy] = ENERGY(x)

% x = fft(x); % compute the DFT (using the Fast Fourier Transform)
energy = abs(x).^2/ length(x); % Get the energy using Parseval's theorem
sumEnergy = mean(energy);
[maxEnergy, i] = max(energy);

end

