clear
files = dir('audio\train Deutsch dataset');
files(1:2) = [];

folderName = 'emoDB_imageFFT';
if ~exist(folderName, 'dir')
    mkdir(folderName)
end

for i = 1:length(files)
    [dir, name, ext] = fileparts([files(i).folder, '\', files(i).name]);
    [s, fs] = audioread([dir, '\', name, ext]);
    
    imagFFT = imag(fft(s));
    PlotFaseRUEL(imagFFT)
    
    set(gca, 'Visible', 'off');
    saveas(gcf, [folderName, '\', name, '.bmp'])
end

