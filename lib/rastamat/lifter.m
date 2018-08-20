function y = lifter(x, modelorder)
% y = lifter(x, lift, invs)
%   Apply lifter to matrix of cepstra (one per column)
%   lift = exponent of x i^n liftering
%   or, as a negative integer, the length of HTK-style sin-curve liftering.
%   If inverse == 1 (default 0), undo the liftering.
% 2005-05-19 dpwe@ee.columbia.edu

if nargin < 2;   lift = 0.6; end   % liftering exponent
if nargin < 3;   invs = 0; end      % flag to undo liftering

ncep = size(x)

liftwts = [1, (1:(ncep-1)).^lift];

y = diag(liftwts)*x;

end
