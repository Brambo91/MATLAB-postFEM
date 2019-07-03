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


if isempty(comp)
  pastelmap(2,1,10)
end

% plotCracks(it,[iint mod(iint+1,nm)]) % NB, plotCracks does mod(iint+1,nmodels)
plotCracks(it,[iint mod(iint,nm)+1])

nameFig;
