dirPathFROM = 'audio\test_audio\test\'; % '\NeoSound\Laboratory_Prog\' - ������� ��������� ���� (���� � ����� ����������)
dirPathTO = 'aud\';

if exist(dirPathTO) == 0
    mkdir(dirPathTO)
end

files = dir(dirPathFROM);
files(1:2) = [];

for i = 1:length(files)
    audioFile = fullfile(dirPathFROM, files(i).name);
    CutAudioFile(audioFile,dirPathTO, 2)
end
