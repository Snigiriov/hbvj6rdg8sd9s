function [LSFcoeff, LPCerror] = LSF_LPC(s)
%%      create object lpc2lsf
lpc2lsf = dsp.LPCToLSF;
%%      calculate LPC
[LPCcoeff,LPCerror] = lpc(s, 50);
%%      convert LPC to LSF
LSFcoeff = lpc2lsf(LPCcoeff')';
% LSFcoeff = LSFcoeff(2);