function graymap(high,low)
% gray colormap inverted with darkest part removed
% args: numeric value for high and low darkness


ntotal = 128;
frac = .8;

if nargin < 2
  low = 1;
end

if nargin < 1 
  high = 154/255;
end

for i=1:64
  Cm(i,:)= ( (i-1)/63*high + (64-i)/63*low ) * [ 1. 1. 1. ];
end
colormap(Cm);
