function postVarna(its)
% dedicated visualization for varna case
% using pxthick

nt = size(cleanLodi,1)-1;

if ( nargin < 1 )
  its = nt;
elseif strcmp(its,'all')
  its = 1:nt;
end

setVIEW([0 90])
setPxOption(3);
setPxScale(10);

h = gcf;
n = length(its);

for j=1:n

  try
    get(h,'type'); % to stop execution after closing figure
  catch ex
    fprintf('\npostVarna detects that the figure has been closed')
    fprintf('\n      ... stopping execution\n\n')
    return
  end

  it = its(j);

  fprintf('\npostVarna plotting time step %1i (%1i of %1i)\n\n',it,j,n)
  j = j+1;

  pxthick(it,0,0);
  drawnow

end
