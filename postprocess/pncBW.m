function pnc(it,comp,iint)

nm = getNModels;

if nargin < 3 || isempty(iint)
  iint = 1;
end

if nargin < 2 || isempty(comp)
  comp = [];
end

if nargin < 1
  it = '';
end

postncintf(it,comp,iint)


% for gray colormap
graymap

% for gray crack lines (see hack in crackPlotFunction)
set(gca,'colororder',[.1 .1 .1])

% plotCracks(it,[iint mod(iint+1,nm)]) % NB, plotCracks does mod(iint+1,nmodels)
plotCracks(it,[iint mod(iint,nm)+1])

nameFig;
