function [f0, autocorrmax] = timedomain_f0(s, fs)
%% set low & high frequency
lowFQ=round(fs/80);                 % lower frequency 
highFQ=round(fs/320);                 % higher frequency
%% calculate autocorrelation
autocorr=xcorr(s,lowFQ,'coeff');

%% find fundamental frequency
autocorr=autocorr(lowFQ+1:2*lowFQ+1);
[autocorrmax,I]=max(autocorr(highFQ:lowFQ));     % rmax = max autocorrelation

f0 = fs/(highFQ+I-1);
end