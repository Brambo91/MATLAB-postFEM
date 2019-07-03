function out = DL(its,path)
% plot total dissipation versus load 
% input: its, path

if nargin < 2
  path = pwd;
end

% load data

lname = strcat(path,filesep,'lodi.dat');
dname = strcat(path,filesep,'dissipation.dat');

try
  lodi = load(lname);
catch
  error(['Did not find file ' lname]);
end

fid = fopen(dname);
if fid < 0
  error(['Did not find file ' dname]);
end

str = fgetl(fid);
names = regexp(str, '\w*\w*', 'match');
dissipation = fscanf(fid, '%g' ,[length(names),inf])';

% set total dissipation in lodi variable

nlodi = size(lodi,1);
ndiss = size(dissipation,1);
if nlodi ~= ndiss
  disp([nlodi ndiss])
  warning('lodi and dissipation file not of same size!');
  if nlodi > ndiss
    lodi = lodi(1:ndiss,:);
  else
    dissipation = dissipation(1:nlodi,:);
  end
end
lodi(:,2) = dissipation(:,size(dissipation,2));
lodi = [0 0 0;lodi];

% make plot

clf

if nargin < 1 || isempty(its)
  plot(lodi(:,2),lodi(:,3),'color',dblue,'marker','.');
else
  hold on;
  plot(lodi( : ,2),lodi( : ,3),'color',dblue)
  plot(lodi(its,2),lodi(its,3),'r.','markersize',8);
  hold off;
  set(gca,'box','on')
end

set(gcf,'paperposition',[0 0 3 2])
set(gca,'fontsize',8)
xlabel('total dissipation [N mm]')
ylabel('F [N]')
nameFig;

% store in base workspace

assignin('base','lodi',lodi)
try   
  str = [getDirName(1,path)];
  assignin('base',str,lodi); 
  disp(['lodi stored in ''' str ''''])
end

set(gca,'tag','lodi')

if nargout > 0 
  out=lodi;
end

fclose(fid);
