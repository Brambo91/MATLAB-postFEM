function it = getIT(value)
% get the number of time step with value

if nargin < 1
  error('getIT requires a displacement value as argument')
end

% open data file

lodi = load('lodi.dat');

if ( value > max(lodi(:,2)) )
  
  disp(['value does not exist, max = ' num2str(max(lodi(:,2)))]);
  it = size(lodi,1);
  
else
  
  iplus = find(lodi(:,2)>value,1,'first');
  imin  = iplus - 1;

  dplus = abs( lodi(iplus,2) - value );
  dmin  = abs( lodi(imin ,2) - value );

  if dplus < dmin
    it = iplus;
  else
    it = imin;
  end

end

fprintf('getIT: value closest to %f is %f, time step %i\n',value,lodi(it,2),it);
