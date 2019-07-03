function plotInfo ( imodel )
% plot cohesive info that from model.info file
% arg: imodel [1]

%% get data

if nargin < 1
  imodel = 1;
end

fid = fopen ( findFile('info',imodel) );

str = fgetl(fid);
names = regexp(str, '\w*\w*', 'match');

values = fscanf(fid, '%g' ,[length(names),inf])';

its = 1:size(values,1);
ni = size(values,2);

%% make plot

clf
hold all

for ii = 1:ni
  stairs(its,values(:,ii))
end

set(gcf,'paperposition',[0 0 3 2])
set(gca,'fontsize',8)

gcl=legend(names);
set(gcl,'fontsize',8)

xlabel('it')
ylabel('n')

assignin('base','cinfo',values)
assignin('base','infonames',names)

fclose(fid);
