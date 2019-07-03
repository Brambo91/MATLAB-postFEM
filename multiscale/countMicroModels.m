function nmicro = countMicroModels
% return number of micromodels in directory
% based on number of filenames that matches '*micro*.dat'

pattern = ['*micro*.dat'];
candidates = dir(pattern);
nmicro = length(candidates);
