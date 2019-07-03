function labelMicroModels(imodels)
% draw micro model locations in macromodel plot
% assuming macroplot is already there
% Argument: imodels (array of indices). Default: plot all

hold on

if ( nargin < 1 )
  imodels = 1:countMicroModels;
end

xs = zeros(length(imodels),2);

for i = 1:length(imodels)
  imodel = imodels(i)-1;
  xs(i,:) = getMicroLocation(getMicroFilename(imodel));
  plot(xs(i,1),xs(i,2),'k.');
  plot(xs(i,1),xs(i,2),'r.');
%   text(xs(i,1),xs(i,2),num2str(imodel));
end

