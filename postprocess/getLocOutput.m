function [dat,coords] = getLocOutput ( ip, imodel )
% function that reads data written to to *.locOut
% input: ip, imodel
% output: dat, coords

% default parameters
if nargin < 2
  imodel = 1;
end
if nargin < 1
  ip = 1;
end

% open file
lfile = findFile ( 'locOut', imodel );
fid = fopen(lfile);

% read information
fgetl(fid); % header
info = str2num(fgetl(fid));
np = info(1);
rank = info(2);


% read coordinates
fgetl(fid); % header
coords = fscanf(fid,'%g',[rank,np])';
fgetl(fid); % read endline character

strCounts = [1,3,6];
strCount = strCounts(rank);

dat = zeros(0,2*strCount+1);
line = fgetl(fid);
while ischar(line)
  timestepdata = fscanf(fid,'%g',[2*strCount+1,np])';
  fgetl(fid); % read endline character
  line = fgetl(fid);
  dat = [dat;timestepdata(ip,:)];
end


