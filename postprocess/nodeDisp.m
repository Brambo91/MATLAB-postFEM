function nd = nodeDisp(in,ix)
% find displacement history for node in (and plot component ix)

if nargin < 1
  disp('give node number as argument!')
  return
end

str = ['!grep ''^' num2str(in) ''' disp.dat > thisDisp.dat'];
eval(str);
load thisDisp.dat

if nargin < 2
  nd = thisDisp(:,2:3);
else
  nd = thidDisp(:,ix+1);
end

!rm thisDisp.dat

