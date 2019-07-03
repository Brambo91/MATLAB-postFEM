function setPxLW ( val )
% set linewidth for addPxLayer (0 gives no lines)

global pxLW;

if ( nargin < 1 )
  disp('pxLW set to .1');
  val = .1;
end

if ischar(val)
  val = str2num(val);
end

assert(val>=0.);

pxLW = val;


