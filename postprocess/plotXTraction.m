function  dat = plotXTraction(it,tmax,iint)
% plot sliding cohesive tractions from interface
% assuming the normal is in y-direction
% Args: time step, tmax, iint

% default arguments 

if nargin < 3
  iint = 1;
end
if nargin < 2
  tmax = '';
end
if nargin < 1
  it = '';
end

% find filename

[x,y,ty,tx,ii] = getTraction(it,iint);

% read and reorder tractions

if ( ~isempty(tmax) )
  lmax = sqrt(max(ty.*ty));
  tx = tx/lmax*tmax;
end

% make figure

plot(x,y+tx,'r--')
hold on
plot(x(ii),y(ii)+tx(ii),'color',dblue,'linewidth',1)
% plot(x,y,'k')
% plot(x(ii),y(ii),'r')

% set(gca,'dataaspectratio',[1 1 1])

fclose('all');

if nargout > 0 
  dat = [x,y+tx];
end

