function alive = running(interval,filename)
% checks if a program is still running
% args: 1. wait time for new data (in seconds) [1]
%       2. name of file to check for changes ['*.log']

persistent lastTime

if nargin < 2
  filename = '*.log';
end

if nargin < 1
  % by default: wait 1 second for new data
  interval = 1;
end

if isempty ( lastTime )
  lastTime = 0.;
end

info = dir(filename);

% fprintf('lasttime %12.8e\n',lastTime)
% fprintf('datenum  %12.8e\n',info.datenum)
% fprintf('diff     %12.8e\n',info.datenum - lastTime)

if info.datenum > lastTime
  lastTime = now;
  alive = true;
else
  alive =  ( now - lastTime ) < interval / 24 / 3600;
end

