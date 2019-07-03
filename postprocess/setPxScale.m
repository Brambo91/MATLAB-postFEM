function setPxScale ( val )
% set deformation magnification factor for px. Input: scale.

global pxScale;

if ( nargin < 1 )
  disp('pxScale set to 1');
  val = 1.;
end

if ischar(val)
  val = str2num(val);
end

pxScale = val;


