function setPiLW ( val )
% set linewidth for postintf (0 gives no lines)

global piLW;

if ( nargin < 1 )
  disp('piLW set to .1');
  val = .1;
end

if ischar(val)
  val = str2num(val);
end

assert(val>=0.);

piLW = val;


