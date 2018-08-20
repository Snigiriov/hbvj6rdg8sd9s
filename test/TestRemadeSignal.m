clear
hold on
[s, fs] = audioread('E:\Synpatic\Solution 11\audio\train Deutsch dataset\Joy_13.wav');

rem = Remaking(s, fs);

PlotFFTabs(rem, fs)

% legend('original', 'new')

sound(rem, fs)