function yval = interpData(xdata,ydata,xval)
% interpolate y(x) for given x value
% arguments: xdata, ydata, xval

if nargin < 3
  error('interpData requires three arguments (xdata,ydata,yval)')
end

assert ( length(xdata) == length(ydata) )

nx = length(xval);
if ( nx > 1 )

  yval = zeros(size(xval));
  for i = 1:nx
    yval(i) = interpData(xdata,ydata,xval(i));
  end

elseif ( xval > xdata(end) )
  
  fprintf('value does not exist, max = %g\n',xdata(end))
  yval = ydata(end);
  
elseif ( xval < xdata(1) )

  fprintf('value does not exist, min = %g\n',xdata(1))
  yval = ydata(1);

elseif ( xval == xdata(end) )
  
  yval = ydata(end);
  
else
  
  imin  = find(xdata<=xval,1,'last');
  iplus = imin + 1;
  
  dx    = xdata(iplus)-xdata(imin);
  dplus = ( xdata(iplus) - xval ) / dx;
  dmin  = ( xval - xdata(imin) ) / dx;

  yval = ydata(iplus)*dmin + ydata(imin)*dplus;

end


