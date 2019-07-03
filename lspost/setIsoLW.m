function setIsoLW ( val )
% set linewidth for addIso0

global isoLW;

if ( nargin < 1 )
  disp('pxLW set to 1');
  val = 1;
end

if ischar(val)
  val = str2num(val);
end

assert(val>=0.);

isoLW = val;


