function [low,up] = envelopeX(data)

[sorted,ii] = sort(data(:,1));
sorted(:,2) = data(ii,2);

xs = unique(data(:,1));

low = [ 0 0 ];
up  = [ 0 0 ];

for x=xs'
  clear this
  this = data(data(:,1)==x,2);
  if length(this)==1; return; end;
  low = [ low ; x min(this) ];
  up  = [  up ; x max(this) ];
end
 
